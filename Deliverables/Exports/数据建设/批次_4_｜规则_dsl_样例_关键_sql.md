# 批次 4｜规则 DSL 样例 & 关键 SQL
> 目标：提供 **A 类（线下上翻）** 与 **B 类（纯线上计算）** 的 DSL 配置样例，以及对应可执行的关键 SQL 片段。保证规则可回放、可回滚。

---

## 1. B 类样例：品牌等级（brand_level）
### 1.1 DSL 配置（JSON 格式）
```json
{
  "tag_id": "brand_level",
  "spec_version": "1.0.0",
  "rule_version": "1.0.0",
  "class": "B",
  "inputs": ["dim_brand_main", "fact_station_contract"],
  "logic": {
    "if": "brand.is_top_tier == 1",
    "then": "KA",
    "elseif": "contract_site_cnt >= 10",
    "then": "CKA",
    "else": "小散"
  },
  "contracts": {
    "dim_brand_main": {"required": ["brand_id", "is_top_tier"]},
    "fact_station_contract": {"required": ["contract_party_id","brand_id","store_id","is_valid"]}
  },
  "output": {"value_col": "tag_brand_level_value"}
}
```

### 1.2 关键 SQL
```sql
WITH cte AS (
  SELECT s.station_gid,
         CASE WHEN b.is_top_tier=1 THEN 'KA'
              WHEN cnt.contract_site_cnt >= 10 THEN 'CKA'
              ELSE '小散' END AS v
  FROM dim_station_master s
  LEFT JOIN dim_brand_main b ON s.brand_id=b.brand_id
  LEFT JOIN (
    SELECT contract_party_id, brand_id, COUNT(DISTINCT store_id) AS contract_site_cnt
    FROM fact_station_contract
    WHERE is_valid=1 AND as_of_date=current_date-1
    GROUP BY contract_party_id, brand_id
  ) cnt ON cnt.brand_id=s.brand_id AND cnt.contract_party_id=s.contract_party_id
)
INSERT OVERWRITE TABLE tag_wide_daily PARTITION(as_of_date=current_date-1)
SELECT station_gid,
       v AS tag_brand_level_value,
       'official' AS tag_brand_level_source,
       100 AS tag_brand_level_conf,
       '1.0.0' AS tag_brand_level_ver,
       'B' AS tag_brand_level_class,
       'Verified' AS tag_brand_level_evidence_state,
       NULL AS tag_brand_level_trace
FROM cte;
```

---

## 2. A 类样例：是否重叠站（overlap）
### 2.1 DSL 配置（JSON 格式）
```json
{
  "tag_id": "overlap",
  "spec_version": "1.0.0",
  "rule_version": "1.0.0",
  "class": "A",
  "er": {"city_radius_m":200, "rural_radius_m":500, "name_strong":0.90},
  "sources": {"weights": {"official":1.0, "region":0.9, "ops":0.85, "external":0.8, "intel":0.7}},
  "detectors": [
    {"signal":"price_expose","window_days":2,"effect":"candidate"},
    {"signal":"price_expose+external_consistent","window_days":3,"effect":"inferred"},
    {"signal":"price_expose+external_consistent","window_days":7,"effect":"verified"}
  ],
  "fallback": {"unknown":"99","conflict":"99"},
  "output": {"value_col": "tag_overlap_value"}
}
```

### 2.2 关键 SQL
```sql
-- Step 1: ER 匹配（来源站点 ↔ 官方站点）
INSERT OVERWRITE TABLE er_match_log PARTITION(as_of_date=current_date-1)
SELECT a.poi_id, b.station_gid,
       ST_Distance(a.lng,a.lat,b.lng,b.lat) AS dist_m,
       text_similarity(a.name, b.name) AS name_sim,
       CASE WHEN b.city_type='urban' AND dist_m<=200 AND name_sim>=0.90 THEN 'strong'
            WHEN b.city_type IN('suburb','highway') AND dist_m<=500 AND name_sim>=0.90 THEN 'strong'
            ELSE 'weak' END AS match_type
FROM ext_competitor_station a
JOIN dim_station_master b ON a.city=b.city;

-- Step 2: 决策逻辑（多源仲裁）
WITH evidence AS (
  SELECT station_gid,
         MAX(CASE WHEN source='official' THEN 1 ELSE 0 END) AS has_official,
         MAX(CASE WHEN source='external' AND match_type='strong' THEN 1 ELSE 0 END) AS has_external,
         COUNT(DISTINCT CASE WHEN signal='price_expose' AND days>=2 THEN 1 END) AS expose_cnt
  FROM er_match_log
  WHERE as_of_date=current_date-1
  GROUP BY station_gid
)
INSERT OVERWRITE TABLE tag_wide_daily PARTITION(as_of_date=current_date-1)
SELECT e.station_gid,
       CASE WHEN has_external=1 AND expose_cnt>=1 THEN 1 ELSE 0 END AS tag_overlap_value,
       'fusion' AS tag_overlap_source,
       80 AS tag_overlap_conf,
       '1.0.0' AS tag_overlap_ver,
       'A' AS tag_overlap_class,
       CASE WHEN has_external=1 AND expose_cnt>=3 THEN 'Verified'
            WHEN has_external=1 AND expose_cnt=1 THEN 'Inferred'
            ELSE 'Candidate' END AS tag_overlap_evidence_state,
       to_json(named_struct('er','strong','expose_cnt',expose_cnt)) AS tag_overlap_trace
FROM evidence e;
```

---

## 3. 回放与回滚
- **回放**：指定 `(as_of_date, rule_version)` 全量重算，产出覆盖 `tag_wide_daily` 对应分区。
- **回滚**：将 `is_current=false`，并将上一版记录 `is_current=true`；或直接回写 `tag_release.rollback_point` 对应快照。

---

## 4. 关键点总结
- **B 类**：契约化输入，规则确定性，结果 100% 可回放。
- **A 类**：证据融合+探测器，输出 evidence_state 阶梯；trace JSON 记录来源/ER/探测器信息。
- **统一 DSL**：规则配置与探测器配置均 JSON 存储，执行层解析生成 SQL 或作业流；可多版本共存。

