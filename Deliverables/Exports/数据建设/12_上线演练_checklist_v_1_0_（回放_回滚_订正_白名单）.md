# 《上线演练 Checklist v1.1》（回放/回滚/订正/白名单）

> 适用：**滴滴加油 · 930 上线 P0=13 标签**\
> 说明：本版在 v1.0 基础上**补充了每个演练的逐步操作清单与通过标准**（你在某些视图里看到“步骤为空”的原因是旧版只给了标题级提纲）。

---

## 0. 预备条件

- INPUT/OUTPUT/Hot 三层表与视图已建立；质量看板可用（RAW/STD/INPUT/OUTPUT/Hot）。
- 字典/规则/白名单存在“当前版”与至少 1 个历史版；`tag_release` 表已启用。
- 时间口径：`as_of_date=D`，发布 SLA：**D+1 ≤ 11:00**。

---

## 1. 回放（Replay）演练 —— **指定日期窗重算，不改 RAW/STD**

### 1.1 步骤

1. **选窗**：确定回放日期窗（如 `2025-08-20 ~ 2025-08-26`）。
2. **冻结快照**：冻结当下 `tag_spec / rule_config / quality_policy`，生成 `snapshot_id`。
3. **参数准备**：组装回放参数 `{date_from, date_to, snapshot_id}`。
4. **执行回放**：触发回放作业（只跑 `tag_input → tag_value_fact → tag_wide_daily` 的目标窗口）。
5. **一致性校验**：生成回放对比报告（行数、七件套差异、Acc/Cov/Stable/Fresh）。
6. **登记发布**：写 `tag_release`（type=`Replay`，含 `snapshot_id/窗口/说明`）。
7. **评审归档**：评审结论、落存报告（PDF/MD）。

### 1.2 检查项 & 通过标准

-

---

## 2. 回滚（Rollback）演练 —— **恢复历史发布点为当前**

### 2.1 步骤

1. **选点**：从 `tag_release` 中选择目标 `release_id`（确认范围与说明）。
2. **设置版本**：将现行版 `is_current=false`，目标版 `is_current=true`（SCD2 语义保持正确）。
3. **重建 Hot**：重算 `tag_wide_daily` 与 `tag_wide_daily_compat` 当日分区。
4. **一致性验证**：关键报表/接口对比无异常；质量指标不过线则回退操作取消。
5. **登记发布**：写 `tag_release`（type=`Rollback`，含 `from→to release_id`、operator、note）。

### 2.2 检查项 & 通过标准

-

---

## 3. 订正（Locked + TTL）演练 —— **验证“必然生效+到期降级”**

### 3.1 步骤

1. **挑样**：选择 2–3 家试点门店；各覆盖 **1 个布尔** 与 **1 个枚举** 标签。
2. **准备订正**：按《回填模板 S3》填 `raw_ops_tag`（包含 `ttl_days>0` 与 `reason`）。
3. **发布日验证**（D+1）：确认 `tag_value_fact` 中命中订正的行 `evidence_state='Locked'`，`source='ops'`（或 `fusion + locked_by=ops`），`conf≈100`。
4. **质量检查**：槽位互斥=0；类型/枚举合法=100%；发布看板指标正常。
5. **到期演练**：构造一组 `as_of_date` 在过去的订正（TTL 短，如 7 天），等待或模拟到期，验证**自动降级**回普通融合。
6. **登记发布**：写 `tag_release`（type=`Normal`，note=Ops Fix Pilot）。

### 3.2 检查项 & 通过标准

-

---

## 4. 白名单（Wide）演练 —— **列展开灰度/回退与兼容视图**

### 4.1 步骤

1. **预置**：在 `tag_wide_hot_list` 新增 2–3 个标签（含 A/B 各 1 个），先置 `enabled=false`。
2. **灰度开启**：对试点城市/站群设置 `enabled=true`；构建当日 `tag_wide_daily`。
3. **一致性校验**：对比 `tag_wide_daily_compat` 与旧查询口径；检查列族 `value_* + 七件套` 互斥=0。
4. **全量开启**：将白名单 `enabled=true` 并记录 `rollout_policy` 从 `gray` → `direct`。
5. **快速回退**：将目标标签 `enabled=false`，确认历史列保留、后续分区不再写入。
6. **登记发布**：写 `tag_release`（note=Whitelist rollout）。

### 4.2 检查项 & 通过标准

-

---

## 5. 异常处置（统一 R/A/G）

- **Critical（红）**：槽位互斥>0、类型错配>0、Stable>8%、Fresh<99% → **阻断或回滚**；生成事件记录。
- **Warning（黄）**：Cov/Acc 85–<90%、ER 对齐 98–<99% → **灰度或回放上一版**，附整改计划。
- **Info（绿）**：常规偏差，仅记录与观察。

---

## 6. 演练记录模板（复制即可）

```markdown
# 上线演练记录（YYYY-MM-DD）
- 场景：Replay / Rollback / Ops-Fix / Hot-Whitelist
- 范围：xxx
- 快照或发布点：snapshot_id/release_id=xxx
- 关键数据：行数、Acc/Cov/Stable/Fresh、互斥=0、类型合法=100%
- 结果：通过/不通过（说明）
- 责任人：xxx
```

---

## 7. Go/No-Go（上线前门槛）

-

