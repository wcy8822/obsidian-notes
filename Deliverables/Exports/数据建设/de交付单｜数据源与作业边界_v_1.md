# 《DE交付单｜数据源与作业边界 v1.1》

> 版本：v1.1（含 **RAW 统一主键** 与 **Hive 投递** 口径）  
> 适用里程碑：**926 上线 P0=13 标签**  
> 角色定位：**业务主导口径与模板 · DE 承接接收/标准化/融合与发布 · DS 协作质量评估**  
> SLA：**T+1，最晚 D+1 11:00 完成标签产出**；质量闸门：**Acc/Cov ≥90%，Stable ≤5%，Fresh=T+1**

---

## 0. 导读（这份文档里含 RAW 放在哪）
- **本稿 A 文档**内已新增专章 **§3《RAW 设计与投递规范》**（你关心的 RAW 全量口径放在这里）。  
- 后续文档中：  
  - **C 文档**《四源→INPUT Tall 字段映射模板》：落地区域/运营可直接填的列头模板；  
  - **D 文档**《回填模板（STD 对齐版）》：业务侧可下载的表头与说明；  
  - **E 文档**《订正治理与放行 SOP》：订正（Locked+TTL）细则。

---

## 1. TL;DR（30 秒口径）
- **四源入、一点出**：数仓（官方）/ 区域反馈 / 商户运营 / 情报反馈 → 统一沉到**信号事实（输入 Tall）**；规则融合后写入**标签真相层（输出 Tall）**；常用标签经**白名单**投影到 Hot 宽表，兼容视图平滑迁移。  
- **三段式协作**：**RAW→STD→INPUT Tall**。业务主导采集与口径，DE 承接标准化/ER/融合与发布，DS 协作质量与抽样。  
- **统一 RAW 主键**：除 S1 外，S2/S3/S4 的 RAW 统一采用 **`(store_id, as_of_date, tag_code)`**，天然幂等、方便覆盖。  
- **订正优先**：商户运营订正以 **ops RAW** 进入，规则层先判强制名单，命中即 **Locked(+TTL)** 生效；留痕可回放可回滚。

---

## 2. 数据源（S1–S4）与“接力边界”
> 仅表格类（文本/数值/枚举），**不涉及图片/链接**。未来新增来源，仅扩 `source` 枚举与接入清单，无需改表结构。

| 源 | 服务目标 | 产出/承接 | 交付形态（短表名） | 到数窗口 | 进入链路 |
|---|---|---|---|---|---|
| **S1 数仓（官方）** | 主体清单+核心事实（合同/价差/交易/画像…）；B 类直接参照 | 数仓主导；DE 承接**只读视图** | `vw_official_*`（对齐 `as_of_date, station_gid`） | T+1（常规 04:00 前） | 规则直接消费/ER 对齐 |
| **S2 区域反馈** | 现场上翻（站内服务/营业/外显品牌…）；A 类主来源 | 业务主导采集；DE 承接 | **`raw_region_tag`** → `std_region_tag` → **INPUT Tall** | D 日提交，D+1 标准化 | RAW→STD→INPUT |
| **S3 商户运营** | 订正与口径收口（人工确认、到期降级） | 业务主导订正；DE 承接 | **`raw_ops_tag`** → `std_ops_tag` → **INPUT Tall**（订正优先） | D 日提交，D+1 标准化 | RAW→STD→INPUT |
| **S4 情报反馈** | 市场/专项表格情报（重叠/中小供给侧证等） | 业务主导采集；DE 承接 | **`raw_intel_tag`** → `std_intel_tag` → **INPUT Tall** | 常规 T+1（≤12:00） | RAW→STD→INPUT→ER |

**接力边界**  
- 业务侧：明确字段与口径、组织采集与抽检、提出字典/规则变更诉求。  
- DE：接收→标准化→ER 对齐→融合→落表与透视→发布与监控。  
- DS：质量评估（Acc/Cov/Stable/Kappa）、分布漂移与阈值建议。

---

## 3. RAW 设计与投递规范（**四源统一到“站×日×标签”**）

### 3.1 建表与主键（短名）
- **三张 RAW 分区表（Hive）**：`raw_region_tag` / `raw_ops_tag` / `raw_intel_tag`  
- **统一主键（唯一键）**：`(store_id, as_of_date, tag_code)`  
  - `tag_code` 源自治理字典（见 §6）；  
  - 幂等策略：同键重复投递**覆盖**；  
  - 不具备 `store_id` 的行**不入 RAW**（先通过 S1 画像底表/视图解析，再入）。

### 3.2 最小字段（四源通用）
- 主键列：`store_id STRING` · `as_of_date DATE` · `tag_code STRING`  
- 值槽位（**三选一且互斥**）：`target_value_bool TINYINT` / `target_value_number DECIMAL(..)` / `target_value_string STRING`  
- 元信息：`report_time TIMESTAMP` · `reporter STRING` · `source_channel STRING NULL` · `batch_id STRING NULL`  
- 备注 & 扩展：`reason STRING NULL` · `ext_*`（预留）  
- 技术列：`ingested_at TIMESTAMP`（DE 填）

> **校验口径**：主键齐全；三槽位恰有其一非空；`report_time` 可解析；`tag_code` 存在于 `vw_tag_spec_current`；其余在 STD 处理（布尔 1/0/99、枚举落 code、时段格式）。

### 3.3 投递与分区
- **投递位置**：业务/区域直接写入 Hive **RAW 分区表**；分区键统一 **`ingest_date=YYYY-MM-DD`**。  
- **SLA**：D 日 20:00 前写完分区；DE 在 D+1 02:00 完成 STD；**D+1 ≤ 11:00** 输出标签。  
- **到数自查**：  
  - 分区行数、主键去重率、必填非空、槽位互斥违规数；  
  - `tag_code`、`store_id` 的 join 完整性（对 `vw_tag_spec_current` 与 S1 画像底表）。

---

## 4. 三段式协作（RAW → STD → INPUT Tall）
- **RAW**：照单全收（已统一主键），保留 `report_time`/`reporter` 等元信息。  
- **STD**：统一字段名与取值（布尔 1/0/99；枚举落 code；单位/时段合法化），记录 `std_ruleset`；校验 `tag_code→value_type`。  
- **INPUT Tall（信号事实）**：将 STD 映射为**行式键值**（`signal_key` + 单一值槽位）；ER 后补 `station_gid`；供规则融合统一消费。  
  - 新增 N 个标签 ≙ 新增 N 个 `tag_code`（治理）与 `signal_key`（映射），**无需改 DDL**。

---

## 5. 输出口径（标签真相层 & Hot 宽层）
- **标签真相层**：`tag_value_fact`（一行=站×日×`tag_id`）  
  - 值槽位：`value_string/value_number/value_bool`（**互斥**）  
  - **七件套**：`source, conf, ver, class(A|B), evidence_state(Unknown|Candidate|Inferred|Verified|Locked), trace_id`  
  - **SCD2**：`effective_from/effective_to/is_current` + `updated_at`  
- **证据外置**：`tag_trace(trace_id, trace_json, size_bytes, created_at)`  
- **Hot 宽层**：`tag_wide_daily` 仅对白名单标签展开（七件套+主体列）；`tag_wide_hot_list` 管理范围；`tag_wide_daily_compat` 提供兼容视图。

---

## 6. 标签字典与 `tag_id` 生成/发布（一本账，三出口）
- **治理主表**：`tag_spec`（生成 **`tag_id`=UUIDv7** 推荐；`tag_code` 稳定、人类可读；含 `tag_name/domain/value_type/class/enum_set/status/effective_from/to/spec_version`）。  
- **仓内视图**：`vw_tag_spec_current`（`is_current=1`，DE/DS 直接 join）。  
- **表单/回填端**：下发轻量字典（`tag_code, tag_name, value_type, enum_values`）供下拉选择。  
- **计算映射**：`tag_signal_map(tag_code → signal_key)`，确保 INPUT Tall 能正确落 `signal_key`。  
- **变更治理**：`tag_change_log`（改名/并拆并合）与 `tag_backward_compat`（旧→新映射，带生效时间）；废弃 `status='deprecated'` 禁止新写 RAW。

---

## 7. 订正优先机制（Ops）
- 进入：`raw_ops_tag` 以标签级 RAW 写入（含 `ttl_days`、`reason`）。  
- 规则：先判 **whitelist/priority**；命中直接产出，`evidence_state='Locked'`（可配 TTL 到期降级）。  
- 留痕：`tag_release` 记录放行/回滚点；`tag_change_log` 记录前后差异、操作人、时间。

---

## 8. SLA · 质量 · 监控 · 验收
- **SLA**：四源 T+1，**D+1 11:00** 前完成 `tag_value_fact` 与 `tag_wide_daily` 当日分区。  
- **质量闸门**：Acc/Cov ≥90%，Stable ≤5%，Fresh=T+1；抽样 ≥50 或 ≥5%，双人一致 **Kappa ≥0.8**。  
- **监控项**：分区到数延迟、行数对账、主键去重率、槽位互斥率、`tag_code`/`store_id` 关联缺失率、四项质量指标、ER 未对齐占比。  
- **930 验收**：三表可用（INPUT Tall/真相层/Hot+兼容）、P0=13 产出与白名单、订正 Locked 演练、回放/回滚演练、质量达标。

---

## 9. 命名与短表名约定（可配置）
- **RAW（Hive）**：`raw_region_tag` / `raw_ops_tag` / `raw_intel_tag`（分区 `ingest_date`）。  
- **STD**：`std_region_tag` / `std_ops_tag` / `std_intel_tag`（含 `std_ruleset`）。  
- **INPUT Tall**：`tag_input_fact`（如需更短，可用 `tag_input`）。  
- **OUTPUT Tall**：`tag_value_fact`（如需更短，可用 `tag_value`）。  
- **Hot 宽层**：`tag_wide_daily` · 白名单 `tag_wide_hot_list` · 兼容视图 `tag_wide_daily_compat`。  
- **治理**：`tag_spec` · `vw_tag_spec_current` · `tag_signal_map` · `tag_change_log` · `tag_backward_compat`。

---

## 10. 风险与护栏
- **口径漂移**：阈值/权重/回退变更必须发版并写回滚点；禁止“静默调线”。  
- **宽表膨胀**：仅白名单透视；超出范围的消费以 Tall 查询或 BI 物化视图承接。  
- **过度订正**：订正默认 **TTL 必填**，避免永久锁死；建议双人复核（Kappa 控制）。  
- **主键缺失**：没有 `store_id` 的记录不入 RAW，先通过 S1 解析再投递。

