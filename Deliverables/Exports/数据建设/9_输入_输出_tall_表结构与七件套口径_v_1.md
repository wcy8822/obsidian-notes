# 《输入/输出 Tall 表结构与七件套口径 v1.0》

> 版本：v1.0 · 适用里程碑：**930 上线 P0=13 标签**  
> 背景：本稿将 **INPUT Tall（信号事实）** 与 **OUTPUT Tall（标签真相层）** 的表结构、主键/分区、字段含义、七件套构成、约束与示例**一次讲清**。不含 SQL 细节，强调语义与协作接口。

---

## 0. 术语速记
- **INPUT Tall（`tag_input`）**：源端标准化后的**信号行**（站×日×信号键×单值），供规则融合统一消费。  
- **OUTPUT Tall（`tag_value_fact`）**：规则融合后的**标签事实行**（站×日×标签ID），带 **SCD2** 与 **七件套**。  
- **七件套（统一定义）**：`value` + `source` + `conf` + `ver` + `class` + `evidence_state` + `trace`（其中 `value` 在 Tall 中以 `value_string/number/bool` 之一承载，`trace` 在表内以 `trace_id` 指向 `tag_trace`）。

---

## 1. INPUT Tall（信号事实）
### 1.1 主键/分区与用途
- **用途**：承接三源（S2 区域、S3 运营订正、S4 情报）经 STD 的**统一信号**，以及 S1 官方线上事实的**契约信号**。  
- **分区键**：`as_of_date=YYYY-MM-DD`  
- **唯一键（幂等）**：`(as_of_date, source, store_id, signal_key)`；同键**覆盖**。

### 1.2 字段（最小集）
| 字段 | 类型 | 说明 |
|---|---|---|
| as_of_date | DATE | 事实对应自然日（通常 D-1） |
| source | STRING | `region/ops/intel/official`（上游来源） |
| store_id | STRING | 门店 ID（官方画像解析） |
| station_gid | STRING | 站点全局 ID（ER 完成后填充；落写时可为空） |
| signal_key | STRING | 信号键（如 `service.carwash_exists`；来自 `tag_signal_map`） |
| value_bool | SMALLINT | `1/0/99`（与该信号的 `value_type` 匹配，三槽位互斥） |
| value_number | DECIMAL(..) | 数值型 |
| value_string | STRING | 文本/枚举 code/ID |
| report_time | TIMESTAMP | 记录时间（取三源原始 `report_time`） |
| reporter | STRING | 责任人或系统标识 |
| std_ruleset | STRING | STD 版本（便于回放） |
| batch_id | STRING | 可选，分批投递识别 |

**约束**  
- `value_bool/value_number/value_string` **三选一且仅一项非空**。  
- `signal_key → value_type` 的类型一致性在 STD 已校验，不一致时**拒收**。  
- 无 `store_id` 的记录**不入 INPUT**（先经官方画像解析）。

---

## 2. OUTPUT Tall（标签真相层）
### 2.1 主键/分区与用途
- **用途**：承载最终**标签值**与**证据语义**，作为下游查询与 Hot 宽层透视的**唯一真相层**。  
- **分区键**：`as_of_date=YYYY-MM-DD`  
- **主键（SCD2 维度键）**：`(station_gid, as_of_date, tag_id)`。

### 2.2 字段（含七件套）
| 字段 | 类型 | 说明 |
|---|---|---|
| as_of_date | DATE | 事实对应自然日 |
| station_gid | STRING | 站点全局 ID（ER 对齐） |
| tag_id | STRING | 三级标签 ID（对应治理 `tag_spec/tag_catalog`） |
| value_string | STRING | **值槽位之一**：枚举/ID/文本（枚举写 `enum_code`） |
| value_number | DECIMAL(18,6) | **值槽位之一**：数值 |
| value_bool | SMALLINT | **值槽位之一**：`1/0/99` |
| source | STRING | 七件套：来源 `official/region/ops/external/intel/fusion` |
| conf | INT | 七件套：置信度（0–100），按规则/证据加权计算 |
| ver | STRING | 七件套：规则/口径版本（建议 SemVer） |
| class | STRING | 七件套：`'A'/'B'`（A=线下上翻；B=纯线上） |
| evidence_state | STRING | 七件套：`Unknown/Candidate/Inferred/Verified/Locked` |
| trace_id | STRING | 七件套：证据指针（指向 `tag_trace.trace_id`） |
| effective_from | TIMESTAMP | SCD2：生效时间 |
| effective_to | TIMESTAMP | SCD2：失效时间（开区间） |
| is_current | BOOLEAN | SCD2：是否当前有效版本 |
| updated_at | TIMESTAMP | 技术时间戳 |

**约束**  
- 三个值槽位**互斥**（仅一项非空），与标签的 `value_type` 一致。  
- A 类样本须具备 `trace_id`（Trace 覆盖率=100%），B 类≥95%。  
- `conf` 与 `evidence_state` 应随证据变化单调合理（例如 `Locked` → `conf` 通常为 100）。

### 2.3 `tag_trace`（证据外置，指针追溯）
最小字段：`trace_id(UUID), station_gid, tag_id, as_of_date, trace_json, size_bytes, created_at`。  
- **用途**：存放完整证据 JSON（来源列表、探测器命中、ER 匹配、权重计算过程等）。  
- **建议**：限制 `size_bytes`；过大内容外链对象存储，仅在 JSON 保留摘要与链接。

---

## 3. INPUT → OUTPUT 的映射口径
1) **信号到标签**：按 `tag_signal_map(tag_code → signal_key)` 和 `rule_config` 取值/仲裁，写入对应 `tag_id`。  
2) **值槽位对齐**：`value_*` 在 INPUT 与 OUTPUT **同型映射**（string→string；number→number；bool→bool）。  
3) **七件套生成**：
   - `source`：若命中订正（ops）则 `ops`；否则 `fusion` 或最强证据来源。  
   - `conf`：按来源权重×一致性×新鲜度×探测器（如需）计算，0–100。  
   - `ver`：规则版本（与 `rule_config` 同步发版）。  
   - `class`：按标签在治理中登记的 `A/B`。  
   - `evidence_state`：证据阶梯（`Locked` 优先，TTL 到期自动降级）。  
   - `trace_id`：落 `tag_trace`，包含各来源与打分细节。

---

## 4. SCD2 语义（如何读“当前值”与“历史值”）
- **当前值**：`as_of_date=D AND is_current=TRUE`。  
- **历史追溯**：同站同标签按 `effective_from/to` 序列化；**回放**会生成新的版本（`updated_at` 更新）。  
- **回滚**：选定 `release_id` 后，将目标版本标记为 `is_current=TRUE` 并重建 Hot 视图。

---

## 5. 枚举与类型（治理约束）
- **类型来源**：`tag_spec.value_type ∈ {BOOL, NUMBER, STRING/ENUM}` 决定 OUTPUT 所用槽位。  
- **枚举展示**：`value_string` 存 enum **code**，展示端 join `tag_enum` 显示中文。  
- **来源枚举**：`source ∈ {official, region, ops, external, intel, fusion}`。  
- **证据阶梯**：`Unknown < Candidate < Inferred < Verified < Locked`（在融合/订正中晋升或降级）。

---

## 6. 质量与校验（Tall 专用）
- **互斥**：任意一行若出现 2 个及以上 `value_*` 非空 → **阻断发布**。  
- **类型一致**：`tag_id` 的 `value_type` 与落写槽位一致，否则拒写并告警。  
- **Trace 覆盖**：A 类=100%，B 类≥95%。  
- **稳定性**：按 **DoD 变更率** 统计 `Stable≤5%`；异常需给出变更解释。  
- **SLA**：`as_of_date=D` 的分区在 **D+1 ≤ 11:00** 完成产出。

---

## 7. 示例（2 行 OUTPUT Tall）
### 7.1 布尔标签（是否有洗车）
| as_of_date | station_gid | tag_id | value_bool | source | conf | ver | class | evidence_state | trace_id |
|---|---|---|---:|---|---:|---|:--:|:--:|---|
| 2025-09-02 | GID_100023 | service_carwash_exists | 1 | ops | 100 | 1.0.0 | A | Locked | tr_9f1a... |

### 7.2 枚举标签（便利店类型）
| as_of_date | station_gid | tag_id | value_string | source | conf | ver | class | evidence_state | trace_id |
|---|---|---|---|---|---:|---|:--:|:--:|---|
| 2025-09-02 | GID_100023 | service_store_type | c_store | fusion | 86 | 1.0.0 | A | Verified | tr_3c8b... |

> 展示层会将 `c_store` 通过 `tag_enum` 映射为“连锁便利店”。

---

## 8. 与 Hot 宽层的关系
- Hot 仅是对 OUTPUT Tall 当日 `is_current=1` 的**列式透视**；列集由 `tag_wide_hot_list` 决定。  
- 旧消费迁移请使用 `tag_wide_daily_compat` 视图完成别名映射与过渡。

---

## 9. 发布前 Checklist（Tall 视角）
- [ ] INPUT 分区到数、主键去重率正常、三槽位互斥=100%  
- [ ] OUTPUT 三槽位互斥=100%，类型一致  
- [ ] 七件套合规：A 类均有 `trace_id`；`conf` 范围正确；`ver/class` 有值  
- [ ] SCD2 标识正确：`is_current` 唯一、有效期不交叉  
- [ ] Hot 透视完成且兼容视图一致性校验通过

---

## 10. 角色边界（Tall 相关）
- **业务/治理**：定义标签与 `value_type/enum_set`、提出规则与订正策略。  
- **DE**：构建/维护 INPUT 与 OUTPUT Tall、实现融合/订正优先、生成 `trace`、产出 Hot 与兼容视图。  
- **DS**：验证 Acc/Cov/Stable/Fresh、设计抽样与阈值建议。

