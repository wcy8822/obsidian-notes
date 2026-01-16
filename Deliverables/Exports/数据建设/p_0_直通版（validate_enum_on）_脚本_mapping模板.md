# P0 直通版（validate\_enum=ON）

> 目的：按“**源已清洗，直接直通**”的诉求，**不做品牌别名匹配**，将 `*_code` 英文字段直通到 S3 的 `target_value_string`；布尔字段用 `bool_map`；开放可选的 **validate\_enum** 强校验（建议开启）。

---

## 一、run\_raw\_passthrough.py（双击即跑 · 3.7+）

```python
# -*- coding: utf-8 -*-
"""
run_raw_passthrough.py — P0 直通版（validate_enum=ON）
- 不做 alias 清洗；枚举用 enum_passthrough 直通
- validate_enum: 对 enum 的 code 进行字典校验，不合法拒收到 rejects
- 空值不写入；同主键去重（conf 高/后行）
- 一键版：无需命令行参数，路径已硬编码为你的主目录
"""
import sys, os, datetime, traceback
from pathlib import Path
import pandas as pd
import numpy as np

BASE_DIR = Path("/Users/didi/Downloads/panth/tag_ct/overlap/auto_raw_pack_templates")

# 是否对 enum 直通值做强校验（命中 tag_enum@spec_version）
VALIDATE_ENUM = True

CONFIG = {
    "S3": {
        "excel_or_csv":        BASE_DIR / "RAW_DELIVERY_TEMPLATE/BATCH_20250904_A/source_template.csv",
        "mapping_rules_csv":   BASE_DIR / "RAW_DELIVERY_TEMPLATE/BATCH_20250904_A/mapping_rules.csv",
        "gov_dir":             BASE_DIR / "GOVERNANCE_TEMPLATES",
        "out_dir":             BASE_DIR / "out",
        "batch_id":            "BATCH_20250904_A",
        "producer":            "业务-alveswang",
        "force_s3":            True
    },
    "WINNER": {
        "raw_s1_csv":          None,
        "raw_s2_csv":          None,
        "raw_s3_csv":          BASE_DIR / "out/raw_s3_correction_tag_staging.csv",
        "raw_s4_csv":          None,
        "rule_config_flat_csv":BASE_DIR / "GOVERNANCE_TEMPLATES/rule_config_flat.csv",
        "run_date":            "2025-09-04",
        "winner_out_csv":      BASE_DIR / "out/winner_preview.csv",
    }
}

RAW_HEADERS = [
    "store_id","as_of_date","tag_code",
    "target_value_bool","target_value_number","target_value_string",
    "source","evidence_state","ttl_days","reason","conf","upload_batch_id"
]

def log(msg):
    ts = datetime.datetime.now().strftime("%H:%M:%S")
    print(f"[{ts}] {msg}")

def ensure_dir(p: Path):
    p.mkdir(parents=True, exist_ok=True)

def load_csv(path: Path) -> pd.DataFrame:
    return pd.read_csv(path, dtype=str, keep_default_na=False)

def load_excel_any(path: Path, sheet: str) -> pd.DataFrame:
    suf = path.suffix.lower()
    if suf in (".csv", ".txt"):
        return pd.read_csv(path, dtype=str, keep_default_na=False)
    xls = pd.ExcelFile(path)
    return xls.parse(sheet_name=sheet, dtype=str)

# --- 直通与布尔变换 ---

def parse_transform(s: str):
    s = (s or "").strip()
    if s.startswith("bool_map"): return ("bool_map", (s.split(":",1)[1] if ":" in s else "1|0|99").split("|"))
    if s in ("enum_passthrough","number_passthrough","id_passthrough","string_passthrough"): return (s, None)
    return (None, None)

def apply_transform(kind, param, series: pd.Series):
    ser = series.fillna("").astype(str).str.strip()
    if kind == "bool_map":
        ser = ser.str.lower().replace({
            "true":"1","false":"0","是":"1","否":"0","y":"1","n":"0","yes":"1","no":"0","":"99"
        })
        ser = ser.where(ser.isin({"1","0","99"}), other="99")
        return ser
    if kind in ("enum_passthrough","id_passthrough","string_passthrough"):
        return ser
    if kind == "number_passthrough":
        return ser.str.extract(r"([-]?\d+(?:\.\d+)?)", expand=False).fillna("")
    return ser

# --- 规格/枚举装载与校验 ---

def load_spec(gov_dir: Path):
    p = gov_dir / "tag_spec.csv"
    if not p.exists(): return pd.DataFrame(columns=["tag_code","spec_version","value_type","fallback"])
    df = pd.read_csv(p, dtype=str, keep_default_na=False)
    if "effective_to" in df.columns:
        df = df[df["effective_to"].fillna("").eq("")]
    return df[["tag_code","spec_version","value_type","fallback"]]

def load_enum(gov_dir: Path) -> pd.DataFrame:
    p = gov_dir / "tag_enum.csv"
    if not p.exists():
        return pd.DataFrame(columns=["tag_code","spec_version","enum_code"])
    df = pd.read_csv(p, dtype=str, keep_default_na=False)
    return df[["tag_code","spec_version","enum_code"]]

# --- A) S3 灌包 ---

def build_s3():
    cfg = CONFIG["S3"]
    excel_path = Path(cfg["excel_or_csv"])
    map_path   = Path(cfg["mapping_rules_csv"])
    gov_dir    = Path(cfg["gov_dir"])
    out_dir    = Path(cfg["out_dir"])
    batch_id   = cfg["batch_id"]
    force_s3   = bool(cfg.get("force_s3", True))

    log("S3 灌包开始")
    ensure_dir(out_dir)

    rules = load_csv(map_path)
    # 统一把 brand_display 口径改成 brand_name（兼容历史）
    if "tag_code" in rules.columns:
        rules["tag_code"] = rules["tag_code"].replace({"brand_display":"brand_name"})

    needed = ["source","sheet","tag_code","value_type","store_id_col","as_of_date_col","source_column","transform","const_value","target_slot","evidence_state_default","ttl_days_default","reason_default","conf_default"]
    miss = [c for c in needed if c not in rules.columns]
    if miss: raise RuntimeError("mapping 缺列: {}".format(miss))

    if force_s3:
        rules["source"] = "S3"
        rules["evidence_state_default"] = rules["evidence_state_default"].mask(rules["evidence_state_default"].eq(""), "Locked")
        rules["ttl_days_default"]       = rules["ttl_days_default"].mask(rules["ttl_days_default"].eq(""), "90")
        rules["reason_default"]         = rules["reason_default"].mask(rules["reason_default"].eq(""), "S3_BOOTSTRAP")
        rules["conf_default"]           = rules["conf_default"].mask(rules["conf_default"].eq(""), "100")
    rules = rules[rules["source"].str.upper().eq("S3")]
    if rules.empty: raise RuntimeError("mapping 中没有 S3 规则；请配置或开启 force_s3")

    spec = load_spec(gov_dir)
    vt_map = dict(zip(spec["tag_code"], spec["value_type"]))
    enum_df = load_enum(gov_dir)

    cache = {}
    def get_sheet(name):
        key = (str(excel_path), name)
        if key not in cache:
            cache[key] = load_excel_any(excel_path, name).rename(columns=lambda c: str(c).strip())
        return cache[key]

    outs, rejects = [], []

    for _, r in rules.iterrows():
        sheet = r["sheet"]; tag = r["tag_code"]; tgt_slot = r["target_slot"]
        vt = (r["value_type"] or vt_map.get(tag,"")).lower()
        sid_col, date_col, src_col = r["store_id_col"], r["as_of_date_col"], r["source_column"]
        ev_state = r.get("evidence_state_default") or "Locked"
        ttl, reason, conf = (r.get("ttl_days_default") or "90"), (r.get("reason_default") or "S3_BOOTSTRAP"), (r.get("conf_default") or "100")

        log(f"  [S3] tag={tag} sheet={sheet} col={src_col} → {tgt_slot}")
        try:
            df = get_sheet(sheet).copy()
        except Exception as e:
            rejects.append({"tag_code": tag, "reason": f"missing_sheet:{sheet}", "detail": str(e)})
            log(f"    ! 缺少 sheet：{sheet}")
            continue

        for col in [sid_col, date_col]:
            if col not in df.columns:
                rejects.append({"tag_code": tag, "reason": f"missing_column:{col}", "detail": f"sheet={sheet}"})
                log(f"    ! 缺少列：{col}"); df = None; break
        if df is None: continue

        if src_col and src_col in df.columns:
            src = df[src_col]
        elif (r["const_value"] or "") != "":
            src = pd.Series([r["const_value"]]*len(df))
        else:
            rejects.append({"tag_code": tag, "reason": "missing_source_value", "detail": f"sheet={sheet}, source_column={src_col}"})
            log("    ! 源列缺失且无常量"); continue

        kind, param = parse_transform(r["transform"])
        values = apply_transform(kind, param, src)

        out = pd.DataFrame({
            "store_id": df[sid_col].astype(str).str.strip(),
            "as_of_date": pd.to_datetime(df[date_col], errors="coerce").dt.date.astype(str),
            "tag_code": tag,
            "target_value_bool": "", "target_value_number": "", "target_value_string": "",
            "source": "S3", "evidence_state": ev_state, "ttl_days": ttl,
            "reason": reason, "conf": conf, "upload_batch_id": CONFIG["S3"]["batch_id"]
        })

        if tgt_slot == "target_value_string": out["target_value_string"]=values
        elif tgt_slot == "target_value_number": out["target_value_number"]=values
        elif tgt_slot == "target_value_bool":   out["target_value_bool"]=values
        else:
            rejects.append({"tag_code": tag, "reason": f"bad_target_slot:{tgt_slot}", "detail": ""}); log("    ! 目标槽位非法"); continue

        # 仅保留恰好一个槽位非空（空值不写，多槽位拒收）
        non_empty = (out[["target_value_bool","target_value_number","target_value_string"]] != "").sum(axis=1)
        for _,row in out[non_empty>1].iterrows():
            rejects.append({"tag_code": tag, "reason": "multi_slots", "detail": f"{row.to_dict()}"})
        out = out[non_empty==1].copy()

        # 日期合法性
        bad_date = out["as_of_date"].isin(["NaT","nat","NaN","None",""])
        for _,row in out[bad_date].iterrows():
            rejects.append({"tag_code": tag, "reason": "bad_date", "detail": f"{row.to_dict()}"})
        out = out[~bad_date]

        # validate_enum：仅在 enum 且写 string 槽位时校验 code 合法性
        if VALIDATE_ENUM and vt == "enum" and tgt_slot == "target_value_string" and not out.empty:
            sub = out[["tag_code","target_value_string"]].rename(columns={"target_value_string":"enum_code"}).copy()
            spec_ver = spec.loc[spec["tag_code"].eq(tag), "spec_version"].unique()
            if len(spec_ver)>0:
                cur_ver = spec_ver[0]
                joined = sub.merge(enum_df[(enum_df["tag_code"].eq(tag)) & (enum_df["spec_version"].eq(cur_ver))],
                                   on=["tag_code","enum_code"], how="left", indicator=True)
                invalid = joined[joined["_merge"].eq("left_only")]
                if not invalid.empty:
                    # 把非法 code 写入 rejects
                    bad_keys = invalid["enum_code"].astype(str).tolist()
                    mask = out["target_value_string"].astype(str).isin(bad_keys)
                    for _, row in out[mask].iterrows():
                        rejects.append({"tag_code": tag, "reason": "invalid_enum_code", "detail": f"{row.to_dict()}"})
                    out = out[~mask]

        outs.append(out)

    df_out = pd.concat(outs, ignore_index=True) if outs else pd.DataFrame(columns=RAW_HEADERS)

    # 同主键去重（conf 高/后行）
    if not df_out.empty:
        df_out["conf_num"] = pd.to_numeric(df_out["conf"], errors="coerce").fillna(0)
        df_out["__row"] = np.arange(len(df_out))
        df_out = df_out.sort_values(["store_id","as_of_date","tag_code","conf_num","__row"])\
                       .drop_duplicates(["store_id","as_of_date","tag_code"], keep="last")\
                       .drop(columns=["conf_num","__row"])

    df_out = df_out.reindex(columns=RAW_HEADERS)
    out_file = Path(out_dir)/"raw_s3_correction_tag_staging.csv"
    df_out.to_csv(out_file, index=False, encoding="utf-8")
    log(f"写出：{out_file}（{len(df_out)} 行, {df_out['store_id'].nunique() if len(df_out)>0 else 0} 站）")

    # manifest
    man_cols = ["batch_id","producer","produced_at","as_of_date_start","as_of_date_end","source","file","rows","stores","notes","attachments"]
    man = pd.DataFrame(columns=man_cols)
    if not df_out.empty:
        man.loc[len(man)] = [
            CONFIG["S3"]["batch_id"], CONFIG["S3"]["producer"], datetime.datetime.now().isoformat(timespec="seconds"),
            df_out["as_of_date"].min(), df_out["as_of_date"].max(),
            "S3", "raw_s3_correction_tag_staging.csv", str(len(df_out)), str(df_out["store_id"].nunique()),
            "", ""
        ]
    man_file = Path(out_dir)/"manifest.csv"
    man.to_csv(man_file, index=False, encoding="utf-8")
    log(f"写出：{man_file}")

    # rejects
    rej_file = Path(out_dir)/"rejects.csv"
    pd.DataFrame(rejects or [], columns=["tag_code","reason","detail"]).to_csv(rej_file, index=False, encoding="utf-8")
    log(f"写出：{rej_file}")

    log("S3 灌包完成")
    return out_file

# --- B) 赢家预览（保持不变） ---

def parse_priority_order(s):
    order = [x.strip().lower() for x in str(s or "").split(">") if x.strip()]
    token_to_src = {"official":"S1","region":"S2","ops":"S3","intel":"S4","external":None}
    rank = {}
    r = 1
    for t in order:
        src = token_to_src.get(t)
        if src and src not in rank:
            rank[src] = r; r += 1
    return rank

def winner_preview():
    cfg = CONFIG["WINNER"]
    out_csv = Path(cfg["winner_out_csv"]) if cfg.get("winner_out_csv") else None
    if out_csv is None:
        log("赢家预览已禁用（winner_out_csv 未配置）"); return None
    ensure_dir(out_csv.parent)

    log("赢家预览开始")

    # 读取四源（可缺）
    def read_raw(p, src):
        if p is None: return None
        p = Path(p)
        if not p.exists():
            log(f"  ! 缺少文件：{p}"); return None
        df = load_csv(p)
        need = set(RAW_HEADERS) - {"source"}
        miss = list(need - set(df.columns))
        if miss: raise RuntimeError(f"{p.name} 缺列：{miss}")
        df["source"] = src
        return df

    dfs = [
        read_raw(cfg.get("raw_s1_csv"), "S1"),
        read_raw(cfg.get("raw_s2_csv"), "S2"),
        read_raw(cfg.get("raw_s3_csv"), "S3"),
        read_raw(cfg.get("raw_s4_csv"), "S4"),
    ]
    dfs = [d for d in dfs if d is not None]
    if not dfs:
        log("  ! 无可用 RAW，跳过赢家预览"); return None

    u = pd.concat(dfs, ignore_index=True)

    # 统一类型
    u["ttl_days"] = pd.to_numeric(u["ttl_days"], errors="coerce").fillna(0).astype(int).astype(str)
    u["conf_num"] = pd.to_numeric(u["conf"], errors="coerce").fillna(0)
    u["as_of_date_dt"] = pd.to_datetime(u["as_of_date"], errors="coerce")
    run_dt = pd.to_datetime(cfg["run_date"], errors="coerce")
    if pd.isna(run_dt): raise RuntimeError("run_date 非法，期望 YYYY-MM-DD")

    # 同源内主键去重
    u["__row"] = np.arange(len(u))
    u = u.sort_values(["source","store_id","as_of_date","tag_code","conf_num","__row"]).drop_duplicates(
        ["source","store_id","as_of_date","tag_code"], keep="last"
    )

    # 来源优先级
    default_rank = {"S1":1,"S2":2,"S3":3,"S4":4}
    per_tag_rank = {}
    pr_path = cfg.get("rule_config_flat_csv")
    if pr_path and Path(pr_path).exists():
        rc = load_csv(Path(pr_path))
        if "tag_code" in rc.columns and "priority_order" in rc.columns:
            for _, r in rc.iterrows():
                pr = parse_priority_order(r.get("priority_order",""))
                if pr: per_tag_rank[r["tag_code"]] = pr

    def rank_for(row):
        pr = per_tag_rank.get(row["tag_code"])
        if pr and row["source"] in pr: return pr[row["source"]]
        return default_rank.get(row["source"], 99)

    u["src_rank"] = u.apply(rank_for, axis=1)

    # 订正有效
    ttl_days = pd.to_numeric(u["ttl_days"], errors="coerce").fillna(0).astype(int)
    valid_until = u["as_of_date_dt"] + pd.to_timedelta(ttl_days, unit="D")
    u["locked_valid"] = ((u["source"]=="S3") & (u["evidence_state"].str.upper()=="LOCKED") & (valid_until >= run_dt)).astype(int)

    # 赢家排序
    u["upload_batch_id"] = u["upload_batch_id"].astype(str)
    u = u.sort_values(["store_id","as_of_date","tag_code","locked_valid","src_rank","conf_num","upload_batch_id","__row"],
                      ascending=[True,True,True,False,True,False,False,False])
    w = u.drop_duplicates(["store_id","as_of_date","tag_code"], keep="first").copy()

    # 输出
    w["value_any"] = w["target_value_string"]
    w.loc[w["value_any"].eq("") , "value_any"] = w["target_value_number"]
    w.loc[w["value_any"].eq("") , "value_any"] = w["target_value_bool"]

    cols = ["store_id","as_of_date","tag_code","value_any","source","evidence_state","ttl_days","conf","upload_batch_id","locked_valid","src_rank"]
    ensure_dir(out_csv.parent)
    w[cols].sort_values(["as_of_date","store_id","tag_code"]).to_csv(out_csv, index=False, encoding="utf-8")
    log(f"赢家预览已输出：{out_csv}（{len(w)} 行，{w['store_id'].nunique() if len(w)>0 else 0} 站）")
    return out_csv

if __name__ == "__main__":
    try:
        build_s3()
        winner_preview()
        log("全部完成 ✅")
        if sys.platform.startswith("darwin"):
            os.system(f'open "{str(CONFIG["S3"]["out_dir"])}"')
    except Exception as e:
        log("[ERROR] " + str(e))
        print(traceback.format_exc())
        input("\n按回车键退出…"); sys.exit(2)
    input("\n处理完成，按回车键退出…")
```

---

## 二、mapping\_rules.csv（P0=13 · 直通版 · 可复制）

> 统一参数：`source=S3`、`sheet=S3`（示例）、`store_id_col=store_id`、`as_of_date_col=as_of_date`、`evidence_state_default=Locked`、`ttl_days_default=90`、`reason_default=S3_BOOTSTRAP`、`conf_default=100`。

```csv
source,sheet,tag_code,value_type,store_id_col,as_of_date_col,source_column,transform,const_value,target_slot,evidence_state_default,ttl_days_default,reason_default,conf_default
S3,S3,brand_name,enum,store_id,as_of_date,brand_text,enum_passthrough,,target_value_string,Locked,90,S3_BOOTSTRAP,100
S3,S3,brand_level,enum,store_id,as_of_date,brand_level_code,enum_passthrough,,target_value_string,Locked,90,S3_BOOTSTRAP,100
S3,S3,overlap,bool,store_id,as_of_date,overlap_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,has_small_supplier,bool,store_id,as_of_date,sme_partner_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,small_supplier_name,id,store_id,as_of_date,sme_supplier_id,id_passthrough,,target_value_string,Locked,90,S3_BOOTSTRAP,100
S3,S3,netprice_channel_enabled,bool,store_id,as_of_date,ws_sep_pricing_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,has_carwash,bool,store_id,as_of_date,carwash_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,carwash_type,enum,store_id,as_of_date,carwash_type_code,enum_passthrough,,target_value_string,Locked,90,S3_BOOTSTRAP,100
S3,S3,has_cstore,bool,store_id,as_of_date,cstore_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,has_toilet,bool,store_id,as_of_date,restroom_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,has_parking,bool,store_id,as_of_date,parking_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,open_24h,bool,store_id,as_of_date,open_24h_flag,bool_map:1|0|99,,target_value_bool,Locked,90,S3_BOOTSTRAP,100
S3,S3,business_hours,string,store_id,as_of_date,open_hours_text,string_passthrough,,target_value_string,Locked,90,S3_BOOTSTRAP,100
```

> 说明：含有中文的同名列（如 `brand_text1`、`brand_level_code1`）**忽略**，不在 mapping 中引用。

---

## 三、使用方法（两步）

1. 将本页脚本保存为 `run_raw_passthrough.py` 到任意目录，双击运行。
2. 把上面的 CSV 片段粘贴到你的 `BATCH_20250904_A/mapping_rules.csv`（可直接覆盖 P0 的 13 行）。

生成物：`out/` 下的 `raw_s3_correction_tag_staging.csv`、`manifest.csv`、`rejects.csv`、`winner_preview.csv`。

---

## 四、FAQ 小贴士

- 如果 `VALIDATE_ENUM=True` 且你的 `brand_text/brand_level_code/carwash_type_code` 中某些 code 不在 `tag_enum`，会被拒收到 `rejects.csv`，请补 `tag_enum.csv` 或修正源值。
- `open_hours_text` 没有强规则；建议尽早统一成 `HHMM-HHMM[|HHMM-HHMM]` 协议，便于 STD 校验。
- 需要切回“品牌别名清洗”时，只需把 transform 改回 `brand_alias_lookup:file=brand_alias_delta.csv` 并在脚本里打开对应逻辑（我可随时恢复该分支）。

