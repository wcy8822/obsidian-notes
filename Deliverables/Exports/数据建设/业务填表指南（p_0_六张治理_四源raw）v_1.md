# 业务填表指南（P0·六张治理+四源RAW）v1.0

> 目的：把你**需要填写**的 CSV（`tag_catalog/tag_spec/tag_enum/rule_config_flat/detector_config_flat/四源 RAW`）讲人话：表格作用、每列中文释义、允许取值示例、状态字典、易错点。业务侧**只填 tag\_code**，不碰 `tag_id`。

---

## 0. 总览（谁先填？）

1. **治理三件套**：`tag_catalog.csv → tag_spec.csv → tag_enum.csv（如是枚举）`
2. **规则两件套**：`rule_config_flat.csv → detector_config_flat.csv（可选）`
3. **四源 RAW**：`raw_s1/2/3/4_*_staging.csv`（按三槽位互斥 + 订正口径）

---

## 1) tag\_catalog.csv（标签目录）

**作用**：注册标签清单和归属，是所有下游的外键基准。

**列 & 释义**

- `tag_code`：标签英文码（全局唯一、稳定），如 `brand_display`。
- `tier1/tier2/tier3`：业务层级（中文/英文均可），用于对外展示/检索。
- `tag_class`：A/B 类（可选）——`A`=证据融合类；`B`=契约/算法直算类。
- `owner_biz/owner_data`：业务/数据 owner（人名或组名）。
- `status`：**状态**（见下）。

**状态字典**

- `draft`=草稿；`in_review`=评审中；`released`=**已发布可计算**；`deprecated`=拟下线（仅维护，不新增）；`retired`=已下线（不再产出）。

**示例**

```
tag_code,tier1,tier2,tier3,tag_class,owner_biz,owner_data,status
brand_display,基础合作,品牌结构,外显品牌,A,张三,DE_TBD,released
```

---

## 2) tag\_spec.csv（标签规格/SCD2）

**作用**：定义**类型、口径、回退**，并以版本（SemVer）管理生效区间。

**列 & 释义**

- `tag_code`：对应目录里的 code。
- `spec_version`：规格版本（如 `1.0.0`）。
- `definition`：业务定义/口径说明（中文即可）。
- `value_type`：值类型：`bool|number|enum|id|string`。
- `fallback`：回退值（按类型）：
  - bool：`99`（未知）
  - enum：`other`（或你定义的兜底 code）
  - id/string：`unknown`（建议）
  - number：留空或 `-1`（按口径）
- `effective_from/effective_to`：生效区间（`effective_to` 为空视为当前生效）。
- `approved_by/approved_at`：批准人/时间。

**示例**

```
tag_code,spec_version,definition,value_type,fallback,effective_from,effective_to,approved_by,approved_at
brand_display,1.0.0,对外展示主品牌,enum,other,2025-08-01,,张三,2025-08-01T10:00:00
```

---

## 3) tag\_enum.csv（枚举集）

**作用**：列出某个 `tag_code@spec_version` 的**全部合法取值**；事实层只存 `enum_code`，展示层映射 `enum_label`。

**列 & 释义**

- `tag_code`：标签英文码。
- `spec_version`：与规格版本对齐。
- `enum_code`：**存储值**（如 `KA`、`BRAND_0001`）不含中文。
- `enum_label`：**展示值**（如 `KA`、`中国石化`） 含中文。
- `sort_order`： 优先级取值逻辑,值越大优先级越高。
- `is_default`：是否默认/回退；与 `tag_spec.fallback` 对齐。

brand_aliases	: 映射别名,包含则命中,对应的别名,存在多个值
exclusion_field: 映射别名,包含则排除,对应的别名,存在多个值
brand_category	标签类别
keywords	is_active	标签关键词
match_method	匹配方法(0/1 0-精准匹配/1-非精准匹配 精准匹配定义叫 100% 符合)
match_score_threshold	匹配的精准度最高 1
white_list	 白名单 0/1 1 表示白名单命中,可以使用,不代表任何阈值的放行
black_list 黑名单,0/1 1 表示命中,命中则丢弃
示例:
brand_name	1.0.0	BRAND_0002	BP	233	FALSE	BP,英国石油,中油BP,碧辟,中油碧辟		石油		1	0	1	1	0
**示例**

```
tag_code,spec_version,enum_code,enum_label,sort_order,is_default
brand_level,1.0.0,KA,KA,10,false
brand_level,1.0.0,CKA,CKA,20,false
brand_level,1.0.0,SMALL,小散,30,true
brand_display,1.0.0,BRAND_0001,中国石化,10,false
brand_display,1.0.0,other,其他,999,true
```

**易错点**：一值一行；**只写 code，不写中文到事实层**。

---

## 4) rule\_config\_flat.csv（规则配置·扁平）

**作用**：声明融合/决策的输入契约 & 权重优先级，由 DE 组装为引擎可读配置。

**列 & 释义**

- `tag_code`：目标标签。
- `rule_version`：规则版本（SemVer）。
- `region_scope`：适用地域（省/市编码或中文，`|` 分隔）。
- `priority_order`：来源优先级链：`official>region>ops>external>intel`。
- `weights_official/region/ops/external/intel`：各来源权重（0\~1）。
- `threshold_1/threshold_2`：阈值参数（自定义，如相似度/覆盖率等）。
- `fallback_unknown/fallback_conflict`：未知/冲突时回退 code（如 `other/99`）。
- `blacklist_codes/whitelist_codes`：黑/白名单（code，`|` 分隔）。
- `is_active`：是否激活（`true/false`）。

**示例**

```
tag_code,rule_version,region_scope,priority_order,weights_official,weights_region,weights_ops,weights_external,weights_intel,threshold_1,threshold_2,fallback_unknown,fallback_conflict,blacklist_codes,whitelist_codes,is_active
overlap,1.0.0,浙江省|江苏省,official>external>region>ops>intel,1.0,0.9,0.85,0.8,0.7,er_name_sim>=0.90,days_3_7,99,99,, ,true
```

---

## 5) detector\_config\_flat.csv（探测器配置·扁平）

**作用**：把“信号→证据等级”的判定规则表格化，供规则 A 类融合使用。

**列 & 释义**

- `detector_id`：探测器 ID（英文码）。
- `tag_code`：目标标签。
- `rule_version`：与规则版本对齐。
- `signal_key`：信号键（如 `price_expose`）。
- `window_days`：统计窗口天数（如 3/7/14）。
- `threshold_value`：阈值（如 `>=1`、`>0.9`）。
- `effect`：命中效果：`candidate|inferred|verified`（建议使用）。
- `is_active`：是否激活。

**示例**

```
detector_id,tag_code,rule_version,signal_key,window_days,threshold_value,effect,is_active
price_expose_d3,overlap,1.0.0,price_expose,3,>=1,inferred,true
```

---

## 6) 四源 RAW（raw\_s\*\_tag\_staging.csv）

**作用**：业务投喂的“最小事实表”。DE 会承接为按日分区的 `raw_*_daily`。

**列 & 释义**

- `store_id`：站点主键。
- `as_of_date`：口径日（YYYY-MM-DD）。
- `tag_code`：标签英文码。
- `target_value_bool/number/string`：**三槽位互斥**，仅一列非空。
- `source`：`S1`官方/`S2`区域/`S3`运营订正/`S4`情报。
- `evidence_state`：`Normal`（默认）/`Locked`（仅 S3 订正）。
- `ttl_days`：订正 TTL（`Locked` 必填且 >0）。
- `reason`：订正理由（审计）。
- `conf`：置信度（0-100）。
- `upload_batch_id`：批次 ID（整包一致）。

**示例（节选）**

```
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,source,evidence_state,ttl_days,reason,conf,upload_batch_id
370100001,2025-09-06,brand_display,,,,S2,Normal,,,85,BATCH_20250906_A
370100001,2025-09-06,overlap,1,,,,S3,Locked,30,竞对强匹配+价露出,100,BATCH_20250906_B
370100002,2025-09-06,service_carwash_type,,,machine,S2,Normal,,,80,BATCH_20250906_A
```

**硬规则**：槽位互斥；`S3+Locked` ⇒ 必填 `ttl_days>0 & reason`；枚举/ID 只写 **code**/id。

---

## 7) 常见取值与枚举建议（摘录）

- 布尔：`1/0/99`（是/否/未知）。
- 品牌等级：`KA|CKA|SMALL`；回退 `SMALL` 或 `other`（与口径一致）。
- 洗车类型：`machine|manual|none`。
- 便利店/卫生间/停车位/24h：布尔。
- 油站营业时间：`HHMM-HHMM` 或多段标准化协议（与 STD 约定）。

---

## 8) 易错点清单

- 事实层写了中文：❌；应写 code（`enum_code`/`id`）。
- 多槽位同时填：❌；仅保留一个，其他置空。
- 用上传日当 `as_of_date`：❌；应为观察日。
- S3 未填 TTL：❌；订正必须 `Locked+ttl_days>0+reason`。

---

> 以上口径与模板与《治理10表 · 业务交付CSV模板（首批）v1》和《RAW 业务可投喂包》一致，可直接照填。

