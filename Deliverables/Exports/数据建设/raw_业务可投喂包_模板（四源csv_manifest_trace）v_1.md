# RAW 业务可投喂包 · 模板（四源CSV + manifest + trace）v1.0

> 目的：把业务线下多源数据（S1/S2/S3/S4）快速整理为**可投喂**的 RAW 包（非分区覆盖），并配套清单与证据；DE 用承接作业将其转存为**按日分区**的 RAW_DAILY。口径遵循：三槽位互斥、值类型与规格一致、订正优先（Locked+TTL>0）。

---

## 0) 命名与文件组织
- **文件命名**（建议）：
  - `raw_s1_official_tag_staging.csv`
  - `raw_s2_ops_tag_staging.csv`
  - `raw_s3_correction_tag_staging.csv`
  - `raw_s4_intel_tag_staging.csv`
- **批次元信息**：每次交付附 `manifest.yaml`（见 §4）。
- **证据文件（可选）**：`trace_lines.jsonl`（见 §5）。

---

## 1) CSV 列头（M0/M1）
> **M0=硬门槛**；M1=订正/证据场景强烈建议；**三槽位仅一列非空**。

**列顺序（统一）**
```
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,source,evidence_state,ttl_days,reason,conf,upload_batch_id
```

**字段说明**
- `store_id` (string)：站点统一主键。
- `as_of_date` (date, YYYY-MM-DD)：口径日（非上传日）。
- `tag_code` (string)：三级标签英文码，必须存在于当前生效规格。
- `target_value_bool` (int)：布尔/有无类取 `1/0/99`。
- `target_value_number` (decimal)：数值类，单位/小数位按规格卡。
- `target_value_string` (string)：**枚举写 enum_code；主数据写 id**（如 `brand_id`）。
- `source` (`S1|S2|S3|S4`)：四源标识。
- `evidence_state` (`Locked|Normal`)：S3 订正用 `Locked`，其余默认 `Normal`。
- `ttl_days` (int)：`Locked` 必填且 >0，到期自动降级。
- `reason` (string)：订正原因；审计用。
- `conf` (0–100)：置信度，订正建议 100。
- `upload_batch_id` (string)：本批次唯一 ID（整文件一致）。

**拒收规则（线下自检）**
- 三槽位互斥；任一行仅一列非空。
- `tag_code` 存在且类型匹配；布尔/枚举/ID 合法。
- 若 `source=S3` 且 `evidence_state=Locked` ⇒ `ttl_days>0 & reason 非空`。
- 日期格式合法；CSV 为 UTF-8 无 BOM、`,` 分隔、`\n` 换行。

---

## 2) 示例行（P0 典型标签）
> 示例仅演示格式；实际 `enum_code/brand_id` 请以治理枚举/主数据为准。

```
# S2：外显品牌（A，写 brand_id 到 string 槽位）
370100001,2025-09-06,brand_display,,,,S2,Normal,, ,85,BATCH_20250906_A
370100001,2025-09-06,brand_display,,,,S2,Locked,180,"门头图+区域确认",100,BATCH_20250906_A
# 置换后的业务值示例（同一站不同行只保留其一）：
370100001,2025-09-06,brand_display,,,BRAND_0001,S2,Normal,, ,85,BATCH_20250906_A

# S3：是否重叠站（A，布尔）
370100001,2025-09-06,overlap,1,,,,S3,Locked,30,"竞对强匹配+价露出",100,BATCH_20250906_B

# S2：洗车类型（A，枚举写 code）
370100002,2025-09-06,service_carwash_type,,,machine,S2,Normal,, ,80,BATCH_20250906_A

# S2：营业时间（A，文本标准化 HHMM-HHMM）
370100003,2025-09-06,open_hours,,,0700-2200,S2,Normal,, ,75,BATCH_20250906_A
```

---

## 3) 线下处理步骤（可打印 Checklist）
1. **列对齐**：按 §1 列头重命名；去除无关列。
2. **值归一**：
   - 布尔→`1/0/99`；数值→单位统一；
   - 枚举→写 `enum_code`（勿写中文）；
   - ID 类→写主键 id（如 `brand_id`）。
3. **字典映射**（如品牌、供给商别名）：原始串→标准 `id/code`，保留命中链路到 trace（§5）。
4. **订正补齐**：`Locked + ttl_days + reason + conf`。
5. **互斥校验**：仅一个槽位非空；类型与规格匹配。
6. **导出**：四源各导出一个 CSV；统一 `upload_batch_id`。
7. **交付“四件套”**：四源 CSV + `manifest.yaml` + `trace_lines.jsonl`（可选）+ 字典增量。

---

## 4) manifest.yaml（样例）
```yaml
upload_batch_id: BATCH_20250906_A
producer: 业务-王XX
produced_at: 2025-09-06T20:30:00+08:00
as_of_date_range: [2025-09-06, 2025-09-06]
sources:
  - source: S2
    file: raw_s2_ops_tag_staging.csv
    rows: 12543
    stores: 812
  - source: S3
    file: raw_s3_correction_tag_staging.csv
    rows: 132
    stores: 120
notes:
  - "brand_display 已按品牌字典映射为 brand_id；冲突回退其他"
  - "S3 全部 Locked：TTL=180，reason 已填"
attachments:
  - type: trace
    file: trace_lines.jsonl
  - type: dict_delta
    file: brand_alias_delta_20250906.csv
```

---

## 5) 证据文件 trace_lines.jsonl（可选交付）
> 每行一条 JSON；DE 侧生成 `trace_id` 入库 `tag_trace`。`store_id` 在 ER 后补齐为 `station_gid`。
```
{"upload_batch_id":"BATCH_20250906_A","store_id":"370100001","as_of_date":"2025-09-06","tag_code":"brand_display","trace":{
  "alias":"中石化XX加油站","dict_hit":"BRAND_0001","match_type":"regex","priority":1,
  "spec_version":"1.0.0","rule_version":"1.0.0","sources":[{"src":"ops","ts":"2025-09-05","val":"中石化XX"}]}}
{"upload_batch_id":"BATCH_20250906_B","store_id":"370100001","as_of_date":"2025-09-06","tag_code":"overlap","trace":{
  "er":{"dist_m":120,"name_sim":0.93,"grade":"strong"},
  "detectors":[{"signal":"price_expose","days":3}],
  "sources":[{"src":"external","poi":"AMAP_123"}]}}
```

---

## 6) （给 DE）承接作业的接口契约
> 你无需执行，了解语义即可；DE 按同分区全量覆盖。
- STAGING → DAILY：`p_date = as_of_date`，分区幂等覆盖。
- ER 后补齐 `station_gid`，再流转到 STD/INPUT。
- 订正降级：TTL 到期后 `Locked→Normal`，走 RULE 流程重算。

**Hive 参考（DE侧）**
```sql
-- STAGING 表（非分区，覆盖）
CREATE TABLE IF NOT EXISTS raw_s2_ops_tag_staging (
  store_id STRING,
  as_of_date DATE,
  tag_code STRING,
  target_value_bool SMALLINT,
  target_value_number DECIMAL(18,6),
  target_value_string STRING,
  source STRING,
  evidence_state STRING,
  ttl_days INT,
  reason STRING,
  conf INT,
  upload_batch_id STRING
);

-- DAILY 表（按日分区）
CREATE TABLE IF NOT EXISTS raw_s2_ops_tag_daily (
  store_id STRING,
  as_of_date DATE,
  tag_code STRING,
  target_value_bool SMALLINT,
  target_value_number DECIMAL(18,6),
  target_value_string STRING,
  source STRING,
  evidence_state STRING,
  ttl_days INT,
  reason STRING,
  conf INT,
  upload_batch_id STRING
)
PARTITIONED BY (p_date DATE);

-- 承接（示例：覆盖 2025-09-06 分区）
INSERT OVERWRITE TABLE raw_s2_ops_tag_daily PARTITION (p_date='2025-09-06')
SELECT store_id,as_of_date,tag_code,
       target_value_bool,target_value_number,target_value_string,
       source,evidence_state,ttl_days,reason,conf,upload_batch_id
FROM raw_s2_ops_tag_staging
WHERE as_of_date='2025-09-06';
```

---

## 7) 线下字典“最小接口”模板（以品牌为例）
> 保留你现有列；在此基础上补齐以下最小必填列即可。

```
dict_id,brand_id,brand_name_std,alias,match_type,priority,valid_from,valid_to,status,spec_version,rule_version
BRAND_ALIAS_V1,BRAND_0001,中国石化,中石化,regex,1,2024-01-01,2099-12-31,enabled,1.0.0,1.0.0
BRAND_ALIAS_V1,BRAND_0002,壳牌,Shell|壳牌,regex,1,2024-01-01,2099-12-31,enabled,1.0.0,1.0.0
```

**使用要点**
- 一行一 `alias` 或使用 `|` 拆分；`regex` 需转义并声明大小写策略。
- 同一有效期内 `alias → brand_id` 唯一；冲突按 `priority` 解决。
- 仅输出映射后的 `id/code` 到 RAW；证据写 trace。

---

## 8) 质量与发布门槛（随批附带勾验）
- **质量闸门**：Acc/Cov ≥ 90%，Stable ≤ 5%，Fresh = T+1（D+1 ≤ 11:00）。
- **抽样自检表**（建议附 50 行）：`store_id,as_of_date,tag_code,value(expected),value(actual),pass(bool)`。
- **回放/回滚演练**：指明 `upload_batch_id` 与日期集；DE 可重载相应分区验证幂等。

---

## 9) 交付清单（一次性交齐即可跑通）
1. 四源 CSV（§1 列头），UTF-8 无 BOM。
2. `manifest.yaml`（§4）。
3. `trace_lines.jsonl`（§5，可选）。
4. 字典增量（如 `brand_alias_delta_YYYYMMDD.csv`）。
5. 首批验收抽样与质量证明（Acc/Cov/Fresh/Stable）。

---

### 附：Excel 互斥自检小技巧（可选）
- 在 `target_value_bool/number/string` 三列之右，用公式 `= (COUNTA(D2:F2)=1)` 批量判断是否仅一列非空；筛选 `FALSE` 即为违规行。

