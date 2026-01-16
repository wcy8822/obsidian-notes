# 《订正治理与放行 SOP v1.0》（Locked + TTL）

> 版本：v1.0 · 适用里程碑：**930 上线 P0=13 标签**  
> 适用对象：商户运营（S3）、数据治理、DE、DS  
> 范围：**无 SQL**，仅定义订正的**输入规范、优先级、审核放行、留痕与回滚**。

---

## 1. 目标与原则
- **目标**：将人工订正作为**最高优先级证据**纳入生产链路，保证**必然生效、可追溯、可回滚、可到期降级**。
- **四项原则**：
  1) **优先级最高**：订正先判强制，再走普通融合；命中即生效。
  2) **Locked + TTL**：生效即置 `evidence_state=Locked`，**必须配置 `ttl_days>0`**，到期自动降级回普通融合。
  3) **一本账治理**：订正全部走治理/发布表留痕（发版记录/变更审计）。
  4) **轻提交、重校验**：输入简洁（站×日×标签×值），严控类型/取值与质量抽检。

---

## 2. 术语与角色
- **订正（Fix）**：由商户运营通过 RAW（S3）提交的标签级修正。
- **Locked**：标签的证据等级，表示“人工确认、强约束”；优先级最高。
- **TTL（Time To Live）**：订正有效期（天）；到期自动降级为普通融合结果。
- **业务**：发起订正、提供依据、选择 TTL、复核抽样。
- **DE**：接收/标准化、规则优先判定、落表与发布、留痕与回滚处理。
- **DS**：抽样评估（Acc、Kappa）、稳定性与漂移监控。

---

## 3. 输入规范（S3 → RAW → STD → INPUT Tall）
### 3.1 RAW 表（短名）
- **`raw_ops_tag`**（Hive 分区 `ingest_date`）
- **主键**：`(store_id, as_of_date, tag_code)`（幂等覆盖）
- **最小列**：
  - 主键：`store_id, as_of_date, tag_code`
  - 值槽位（三选一互斥）：`target_value_bool | target_value_number | target_value_string`
  - 订正属性：`ttl_days`（必填且 `>0`）、`reason`
  - 元信息：`report_time, reporter, source_channel, batch_id`（可选）

> **取值与类型**：`tag_code` 必须来自 `vw_tag_spec_current`；且所填槽位与 `value_type` 匹配。

### 3.2 STD 与 INPUT
- **STD（`std_ops_tag`）**：统一类型与口径（布尔 1/0/99、枚举 code），校验 `tag_code→value_type`，记录 `std_ruleset`。
- **INPUT Tall（`tag_input`）**：按 `tag_signal_map(tag_code→signal_key)` 写入 **行式键值**；ER 后补 `station_gid`。

---

## 4. 规则优先级与生效表达
1) **先判强制**：规则引擎第一步检查是否存在订正（来源 `ops`）且在有效期内：
   - 命中 → 直接产出 Locked 结果。
   - 未命中 → 走多源权重/阈值的普通融合。  
2) **输出落表**：写入 `tag_value_fact`：
   - 值槽位（仅一项非空）：`value_bool/number/string`
   - **七件套**：`source='ops'`（或 `fusion` + `locked_by='ops'`）、`conf=100`（或配置上限）、`ver=rule_version`、`class(A|B)`、`evidence_state='Locked'`、`trace_id`
   - **SCD2**：`effective_from/effective_to/is_current` 维护版本
3) **TTL 到期**：到期后下一周期自动降级（去除 Locked 优先），进入普通融合流程。

> **本期 fix_type**：仅启用 `lock`；`override` 字段保留但不启用。

---

## 5. 审核与放行流程（无回执表版本）
**SLA：** 当日订正提交（D）→ 次日（D+1）发布截止 **11:00**

### 步骤
1) **业务提交**：按《回填模板》CSV 或工具填写 `raw_ops_tag` 分区；完成自查（主键/单槽位/类型）。
2) **DE 标准化**：跑 `std_ops_tag`，检查类型与取值；不合规的记录当日不发布（留在 STD，业务修正后重投 RAW）。
3) **DS 抽样复核**：按抽样规则（≥50 或 ≥5%）双人复核，计算 Kappa≥0.8 通过；不通过时退回。
4) **规则发布**：D+1 规则任务优先判定订正，产出 Locked；
5) **质量拦截**：若该标签当日 **Stable>5%/Cov<90%** 触发阻断，改为灰度或回滚前一发布点；
6) **完成发布**：写 `tag_value_fact` 与 `tag_wide_daily`；生成 `tag_release` 记录（类型=Normal）。

> **到数/校验自查**：通过 Hive 查询各层分区与违规统计（行数、主键去重、槽位互斥、类型错配），不额外生成“回执表”。

---

## 6. 续期、撤销与批量处理
- **续期**：业务在到期前重新提交同一 `(store_id, as_of_date, tag_code)` 且新的 `ttl_days`；下一周期发布自动延续。
- **提前撤销**：提交同键记录并将值改为业务认可的常规信号，或在治理端标记该键进入“撤销队列”；发布任务将移除 Locked 优先。
- **批量订正**：大促/活动等场景，需提前报备；建议设置 **最短 TTL=30**、**最长 TTL=180**，并按区域/品牌做灰度发布。

---

## 7. 质量与监控
- **核心指标**：
  - **Acc/Cov/Stable/Fresh**（标签级）  
  - **Locked 比例**、**TTL 将到期数**、**到期降级成功率**  
  - **类型错配率**、**槽位互斥违规数**
- **监控位置**：DE 监控看板（Hive 指标聚合）；关键指标触发 **Critical** 告警时，阻断发布或回滚。

---

## 8. 风险控制
- **范围白名单**：只允许在 `tag_spec.status='active'` 且 `allow_ops_fix=true` 的标签上订正。
- **TTL 必填**：杜绝“永久锁死”；默认建议 90/180 天，**不得为 0**。
- **日阈值**：同一 `tag_code` 每日最大 Locked 数量建议设上限（如按区域/品牌配额），防止误批量。
- **类型/枚举**：与 `value_type/enum_set` 强校验；错配直接拒绝发布。
- **稳定性护栏**：当日 Stable>5% 触发灰度或回滚；必要时冻结该标签发布。

---

## 9. 常见场景（示例）
1) **营业 24h 订正**（`open.24h`，BOOL）：
   - 输入：`raw_ops_tag` 一行（`target_value_bool=1, ttl_days=90`）
   - 输出：`evidence_state='Locked'`，`conf=100`，TTL 到期后降级；
2) **便利店类型修正**（`service.store_type`，ENUM/STRING）：
   - 输入：`target_value_string='c_store'`，TTL=180；
   - 输出：Locked，展示通过字典联接中文名；
3) **B 类临时覆盖**（如 `brand_level`）：
   - 原则：优先推动上游事实修正；如需临时覆盖，亦走 Locked（TTL 较短，如 30 天），并在发布记录注明“临时覆盖”。

---

## 10. 数据落表与留痕（治理）
- **输出事实**：`tag_value_fact`（SCD2 + 七件套）
- **发布记录**：`tag_release(release_id, date, scope, type={Normal|Replay|Rollback}, operator, note)`
- **变更审计**：`tag_change_log(tag_id, store_id, as_of_date, before_value, after_value, operator, reason, ts)`
- **字典视图**：`vw_tag_spec_current`（订正必须命中）

> 注：本期无需“回执表”；到数与违规检查通过 Hive 查询与看板实现。

---

## 11. 提交流程（业务侧简表）
1) 从 `vw_tag_spec_current` 获取 `tag_code` 下拉清单；  
2) 填《回填模板 S3》：`store_id, as_of_date, tag_code, target_value_*, ttl_days, reason, report_time, reporter`；  
3) 自查三项：主键齐全、单槽位、类型匹配；  
4) 写入 `raw_ops_tag` 分区；  
5) 如需批量订正，提前报备并设定 TTL 与灰度策略。

---

## 12. 发布前 Checklist（DE/治理）
- [ ] `raw_ops_tag` 当日分区到数，主键去重率正常  
- [ ] STD 类型/取值校验通过，无错配  
- [ ] Locked 生效数在阈值内，TTL 均>0  
- [ ] `tag_value_fact` 槽位互斥=0  
- [ ] 质量四指标达标，Stable≤5%  
- [ ] Hot 透视已更新（如该标签在白名单内）  
- [ ] `tag_release` 发布记录已写入

---

## 13. 附录
### 13.1 证据阶梯（简表）
`Unknown < Candidate < Inferred < Verified < Locked`

### 13.2 字段字典（S3 订正最小集）
- `store_id STRING` · `as_of_date DATE` · `tag_code STRING`  
- `target_value_bool TINYINT | target_value_number DECIMAL | target_value_string STRING`（三选一）  
- `ttl_days INT (>0)` · `reason STRING`  
- `report_time TIMESTAMP` · `reporter STRING` · `source_channel/batch_id`（可选）

### 13.3 命名与状态
- 值槽位**互斥**；  
- `source='ops'`（或 `fusion` + `locked_by='ops'`）；  
- `evidence_state='Locked'`；  
- TTL 到期自动降级，无需人工干预。

