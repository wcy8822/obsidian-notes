# 批次 2｜宽表 `tag_wide_daily` DDL（含公共主体列）
> 一行 = 站点(Store) × 自然日的标签快照；SCD2 管理（支持回放/回滚）。所有三级标签统一“七件套”：`value / source / conf / ver / class / evidence_state / trace`。公共主体列按【签约方>POP>Store】与你新增的六列输出。

## 2.1 建表 DDL（通用 SQL 方言）
```sql
CREATE TABLE IF NOT EXISTS tag_wide_daily (
  /* ========== 主键与日期分区 ========== */
  as_of_date DATE NOT NULL,                 -- 数据对应自然日（D-1）
  station_gid STRING NOT NULL,              -- 站点全局ID（ER 后稳定主键）

  /* ========== 主体公共维度（你拍板的六列 + 站点基础） ========== */
  store_id STRING,
  store_name STRING,
  pop_id STRING,
  pop_name STRING,
  contract_party_name STRING,               -- 签约合同方名称
  business_registration_no STRING,          -- 工商注册登记号
  province STRING,
  city STRING,
  lng DECIMAL(10,6),
  lat DECIMAL(10,6),

  /* ===================== P0(13) 标签字段（每个七件套） ===================== */
  -- 1. 品牌等级（B）：KA/CKA/小散（五中四外=>KA；否则有效合作站点数≥10=>CKA；其他=小散）
  tag_brand_level_value STRING,
  tag_brand_level_source STRING,
  tag_brand_level_conf INT,
  tag_brand_level_ver STRING,
  tag_brand_level_class STRING,
  tag_brand_level_evidence_state STRING,
  tag_brand_level_trace STRING,

  -- 2. 外显品牌（A）：展示品牌中文 + 可选brand_id
  tag_brand_display_value STRING,           -- 中国石化/壳牌/其他
  tag_brand_display_source STRING,
  tag_brand_display_conf INT,
  tag_brand_display_ver STRING,
  tag_brand_display_class STRING,
  tag_brand_display_evidence_state STRING,
  tag_brand_display_trace STRING,
  tag_brand_id_value STRING,                -- 主品牌ID（方便下游Join）

  -- 3. 是否重叠站（A）：1/0/99
  tag_overlap_value SMALLINT,
  tag_overlap_source STRING,
  tag_overlap_conf INT,
  tag_overlap_ver STRING,
  tag_overlap_class STRING,
  tag_overlap_evidence_state STRING,
  tag_overlap_trace STRING,

  -- 4. 是否合作中小供给（A）：1/0/99
  tag_mid_vendor_exists_value SMALLINT,
  tag_mid_vendor_exists_source STRING,
  tag_mid_vendor_exists_conf INT,
  tag_mid_vendor_exists_ver STRING,
  tag_mid_vendor_exists_class STRING,
  tag_mid_vendor_exists_evidence_state STRING,
  tag_mid_vendor_exists_trace STRING,

  -- 5. 合作中小供给名称（A）：八大枚举+其他
  tag_mid_vendor_name_value STRING,         -- 易加油/帮油/鲸车惠/站联科技/油吨吨/聚油加油/陕西万联/广电猫猫/其他
  tag_mid_vendor_name_source STRING,
  tag_mid_vendor_name_conf INT,
  tag_mid_vendor_name_ver STRING,
  tag_mid_vendor_name_class STRING,
  tag_mid_vendor_name_evidence_state STRING,
  tag_mid_vendor_name_trace STRING,

  -- 6. 是否开通网顺单独定价（B）：1/0/99
  tag_ns_unique_pricing_value SMALLINT,
  tag_ns_unique_pricing_source STRING,
  tag_ns_unique_pricing_conf INT,
  tag_ns_unique_pricing_ver STRING,
  tag_ns_unique_pricing_class STRING,
  tag_ns_unique_pricing_evidence_state STRING,
  tag_ns_unique_pricing_trace STRING,

  -- 7. 是否有洗车（A）：1/0/99
  tag_service_carwash_exists_value SMALLINT,
  tag_service_carwash_exists_source STRING,
  tag_service_carwash_exists_conf INT,
  tag_service_carwash_exists_ver STRING,
  tag_service_carwash_exists_class STRING,
  tag_service_carwash_exists_evidence_state STRING,
  tag_service_carwash_exists_trace STRING,

  -- 8. 洗车类型（A）：机器清洗/手工清洗/未知
  tag_service_carwash_type_value STRING,
  tag_service_carwash_type_source STRING,
  tag_service_carwash_type_conf INT,
  tag_service_carwash_type_ver STRING,
  tag_service_carwash_type_class STRING,
  tag_service_carwash_type_evidence_state STRING,
  tag_service_carwash_type_trace STRING,

  -- 9. 是否有便利店（A）（>5㎡ 认定）
  tag_service_store_exists_value SMALLINT,
  tag_service_store_exists_source STRING,
  tag_service_store_exists_conf INT,
  tag_service_store_exists_ver STRING,
  tag_service_store_exists_class STRING,
  tag_service_store_exists_evidence_state STRING,
  tag_service_store_exists_trace STRING,

  -- 10. 是否有卫生间（A）
  tag_service_restroom_exists_value SMALLINT,
  tag_service_restroom_exists_source STRING,
  tag_service_restroom_exists_conf INT,
  tag_service_restroom_exists_ver STRING,
  tag_service_restroom_exists_class STRING,
  tag_service_restroom_exists_evidence_state STRING,
  tag_service_restroom_exists_trace STRING,

  -- 11. 是否有停车位（A）
  tag_service_parking_exists_value SMALLINT,
  tag_service_parking_exists_source STRING,
  tag_service_parking_exists_conf INT,
  tag_service_parking_exists_ver STRING,
  tag_service_parking_exists_class STRING,
  tag_service_parking_exists_evidence_state STRING,
  tag_service_parking_exists_trace STRING,

  -- 12. 是否24小时营业（A）
  tag_open_24h_value SMALLINT,
  tag_open_24h_source STRING,
  tag_open_24h_conf INT,
  tag_open_24h_ver STRING,
  tag_open_24h_class STRING,
  tag_open_24h_evidence_state STRING,
  tag_open_24h_trace STRING,

  -- 13. 油站营业时间（A）
  tag_open_hours_value STRING,              -- HHMM-HHMM，异常回退99/Unknown
  tag_open_hours_source STRING,
  tag_open_hours_conf INT,
  tag_open_hours_ver STRING,
  tag_open_hours_class STRING,
  tag_open_hours_evidence_state STRING,
  tag_open_hours_trace STRING,

  /* ========== SCD2 管控字段 ========== */
  effective_from TIMESTAMP,                 -- 值生效时间
  effective_to TIMESTAMP,                   -- 失效时间（null=当前）
  is_current BOOLEAN,                       -- 便于快速取“最新”
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (station_gid, as_of_date)
);
```

## 2.2 分区/索引/压缩建议
- **分区**：按 `as_of_date` 分区；大表引擎（Hive/StarRocks/ClickHouse）可加二级分桶 `station_gid`。
- **主键**：`(station_gid, as_of_date)`；SCD2 语义通过 `effective_*` + `is_current` 维护。
- **压缩**：建议列存 + ZSTD；`trace` 为 JSON 压缩存储（单字段上限建议 8KB）。
- **生命周期**：>90 天历史冷热分层，冷存保留回放所需最小列（value/ver/is_current/as_of_date/station_gid）。

## 2.3 命名规范与取值约定
- 布尔/有无类统一 **1=是 / 0=否 / 99=未知**。
- 证据状态：`Unknown / Candidate / Inferred / Verified / Locked`（B 类固定 `Verified`）。
- 字段命名：`tag_{domain}_{short}_{suffix}`，示例 `tag_service_parking_exists_value`。

## 2.4 物化视图（可选）
```sql
-- 近30天视图（下游策略常用）
CREATE VIEW IF NOT EXISTS mv_tag_wide_30d AS
SELECT * FROM tag_wide_daily
WHERE as_of_date >= current_date - 30 AND is_current = TRUE;
```

## 2.5 数据写入与幂等
- 每日调度在 04:00 产出 D-1；同日重跑需覆盖同 `(station_gid, as_of_date)` 分区数据。
- 回放采用 `as_of_date = 指定日` + 对应 `rule_version` 重算；回滚通过将 `is_current=false` 并开启上一版记录的 `is_current=true` 实现。

