# RAW 执行Checklist v1.1（修正版）

> 适用对象：业务侧首批投喂 RAW（四源）与 DE 承接。目标：**一次通过、可回放、可审计**。口径：三槽位互斥、订正优先（Locked+TTL>0）、以 `vw_tag_spec_current.value_type` 定槽位。

---

## A. 一图速用（7 步到交付）

-

---

## B. 详细 Checklist（含 Owner/DoD）

| 步骤  | 任务                               | Owner | 截止           | DoD（完成定义）                            | 产物                                            |
| --- | -------------------------------- | ----- | ------------ | ------------------------------------ | --------------------------------------------- |
| B1  | 更新/确认 `tag_spec/tag_enum`（P0=13） | 业务    | T-2d         | value\_type/单位/枚举 code 与描述一致；审批就绪    | `tag_spec.csv`，`tag_enum.csv`                 |
| B2  | 准备四源工作簿（S1/S2/S3/S4）             | 业务    | T-1d         | 4 个 Sheet 列头统一；有批次号                  | `raw_s*_tag_staging.xlsx`                     |
| B3  | 归一化与互斥校验                         | 业务    | T-1d         | 三槽位互斥校验通过（错误率 0%）；日期合法               | 通过截图/校验日志                                     |
| B4  | 字典映射与留痕                          | 业务    | T-1d         | 100% 可映射行落 `id/code`；冲突清单=0          | `brand_alias_delta.csv`，`trace_lines.csv`（可选） |
| B5  | 订正清单（如有 S3）                      | 业务    | T-1d         | 全部订正行 **Locked+ttl\_days+reason** 齐全 | 含示例行的 S3 CSV                                  |
| B6  | 导出四源 CSV + manifest              | 业务    | T-1d         | UTF-8 无 BOM、`,` 分隔；manifest 行数/站数匹配  | `raw_s*_tag_staging.csv`，`manifest.csv`       |
| B7  | 交付与入湖承接                          | 业务→DE | T-1d         | 文件到位；DE 脚本可读                         | 提交记录/存储路径                                     |
| B8  | 承接为分区 RAW\_DAILY                 | DE    | T            | `p_date=as_of_date` 分区覆盖；行数=manifest | `raw_*_daily` 分区清单                            |
| B9  | STD 校验与 INPUT 产信号                | DE    | T            | 类型/枚举/单位校验 100% 通过；生成信号              | STD 校验报告、INPUT 预览                             |
| B10 | 回放/差异对账                          | 业务&DE | T+0.5d       | 与四源 CSV 行/站/日期一致；差异=0                | 回放 SQL/结果截图                                   |
| B11 | 质量复核与放行                          | 业务&DE | T+1d 11:00 前 | Acc/Cov≥90%、Stable≤5%、Fresh=T+1      | 质量小结、放行记录                                     |

> 提示：若 B3/B4 出现异常，优先修 CSV 与字典，不要把“特殊口径”写死在规则。

---

## C. 线下自检脚本/公式（可复制）

**三槽位互斥（Excel）**：

```
= (COUNTA([@target_value_bool]:[@target_value_string]) = 1)
```

**日期合法**（Excel）：

```
=NOT(ISERROR(DATEVALUE([@as_of_date])))
```

**枚举合法**（VLOOKUP 到枚举表）：

```
=IFERROR(XLOOKUP([@target_value_string],枚举!A:A,枚举!A:A),"INVALID_CODE")
```

---

## D. 交付“四件套”目录结构（建议）

```
/RAW_DELIVERY/BATCH_20250906_A/
  ├─ raw_s1_official_tag_staging.csv
  ├─ raw_s2_ops_tag_staging.csv
  ├─ raw_s3_correction_tag_staging.csv
  ├─ raw_s4_intel_tag_staging.csv
  ├─ manifest.csv
  ├─ brand_alias_delta.csv           # 如有品牌清洗
  └─ trace_lines.csv                 # 可选证据扁平
```

---

## E. 回放/回滚 Checklist（DE 承接后）

> 目标：**可回放、可回滚、可对账**。DE 承接到 `raw_*_daily` 后，按以下步骤完成闭环。

### E1｜指定分区回放（必做）

- **单日回放**

```sql
-- 覆盖 2025-09-06 分区
INSERT OVERWRITE TABLE raw_s2_ops_tag_daily PARTITION (p_date='2025-09-06')
SELECT store_id,as_of_date,tag_code,
       target_value_bool,target_value_number,target_value_string,
       source,evidence_state,ttl_days,reason,conf,upload_batch_id
FROM raw_s2_ops_tag_staging
WHERE as_of_date='2025-09-06';
```

- **多日回放**（逐日循环或动态 SQL 构造）

```sql
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE raw_s2_ops_tag_daily PARTITION (p_date)
SELECT store_id,as_of_date,tag_code,
       target_value_bool,target_value_number,target_value_string,
       source,evidence_state,ttl_days,reason,conf,upload_batch_id,
       as_of_date AS p_date
FROM raw_s2_ops_tag_staging
WHERE as_of_date BETWEEN DATE '2025-09-01' AND DATE '2025-09-07';
```

### E2｜幂等校验（必做）

```sql
-- 行数对账（分区 vs staging）
SELECT 'daily' AS side, COUNT(*) AS cnt FROM raw_s2_ops_tag_daily WHERE p_date='2025-09-06'
UNION ALL
SELECT 'staging', COUNT(*) FROM raw_s2_ops_tag_staging WHERE as_of_date='2025-09-06';

-- 站点数对账
SELECT 'daily' AS side, COUNT(DISTINCT store_id) FROM raw_s2_ops_tag_daily WHERE p_date='2025-09-06'
UNION ALL
SELECT 'staging', COUNT(DISTINCT store_id) FROM raw_s2_ops_tag_staging WHERE as_of_date='2025-09-06';
```

> 期望：两个 UNION 的行数/站点数一致；若不一致→先回查 CSV（重复/空白/非法值）。

### E3｜端到端对账（抽样 50 行）

```sql
-- 随机抽样回看关键字段是否一致
WITH sample AS (
  SELECT store_id, tag_code, as_of_date
  FROM raw_s2_ops_tag_daily
  WHERE p_date='2025-09-06'
  ORDER BY rand() LIMIT 50
)
SELECT s.store_id,s.tag_code,s.as_of_date,
       d.target_value_bool,d.target_value_number,d.target_value_string
FROM sample s
JOIN raw_s2_ops_tag_daily d
  ON d.store_id=s.store_id AND d.tag_code=s.tag_code AND d.as_of_date=s.as_of_date AND d.p_date='2025-09-06';
```

将结果与 CSV 同行比对（可用 `store_id+tag_code+as_of_date` 做 join-key）。

### E4｜回滚预案（必备）

- **快照方案**：承接前 `EXPORT TABLE` 或 `INSERT OVERWRITE DIRECTORY` 导出旧分区；
- **回滚执行**：

```sql
-- 用上一次快照恢复 2025-09-06 分区
INSERT OVERWRITE TABLE raw_s2_ops_tag_daily PARTITION (p_date='2025-09-06')
SELECT * FROM tmp_backup_raw_s2_ops_tag_daily_20250906;
```

- **记录点**：在运维台账/`tag_change_log` 登记“回滚批次、原因、操作者、时间”。

### E5｜TTL 降级演练（订正专属）

- 构造一批 `evidence_state='Locked' AND ttl_days=1` 的样本；
- 等 T+1 后检查 `Locked→Normal` 的生效情况，并复算下游规则；
- 抽查 `tag_trace` 是否保留原订正证据。

### E6｜证据追溯自检

- 抽样 20 行核对 `trace_lines.csv`（或 JSONL）与 `tag_trace` 的 `trace_id` 能**一跳还原**：命中 alias/规则版本/优先级一致；
- 验证禁用字典项（`status=disabled`）在 `valid_to` 之后**不再命中**。

---

## F. 常见坑位 & 处理（快速排错）

- **多槽位同时非空** → 只保留规格要求的槽位，其余置空；在 CSV 端修复再投喂。
- **写了中文枚举** → 一律改为 `enum_code`；中文展示靠 `tag_enum` join。
- **S3 未填 TTL/REASON** → 订正行强制补 `ttl_days>0` 与 `reason`；`conf` 建议 100。
- **as\_of\_date 填了上传日** → 以“观察日”为准；承接按 `as_of_date` 分区。
- **布尔出现 true/false/是/否** → 统一换为 `1/0/99`；99=未知，不等于空值。
- **单位不一致** → 按规格卡统一（如 元、升、%）；必要时本地换算。
- **重复主键**（同 `store_id+as_of_date+tag_code` 多行）→ 保留一行；其余并入 `trace` 作为证据。
- **越权订正**（`allow_ops_fix=false`）→ 直接拒收；回写问题清单给业务。
- **字典冲突**（同 alias 命中多品牌）→ 以 `priority` 最小为准；冲突列表另存备查。

---

## G. 放行前 12 条硬闸门（逐条打 √）

1. 四源 CSV 为 UTF-8 无 BOM、`,` 分隔、`\n` 换行；文件未被 Excel 自动转码。
2. 每行仅一槽位非空；空白留空，**不要**写 `NULL/NA`。
3. `tag_code` 均存在于 \`\`；`value_type` 与槽位匹配。
4. 布尔仅 `1/0/99`；枚举仅合法 `enum_code`；ID 存合法主键。
5. `as_of_date` 合法，且覆盖的日期集与 `manifest` 一致。
6. `source ∈ {S1,S2,S3,S4}`；S3 订正需 `Locked+ttl_days>0+reason`。
7. `upload_batch_id` 一致且可追溯到 `manifest`。
8. 字典增量（如品牌别名）已随批交付，并通过最小接口校验。
9. trace 抽样 ≥ 50 行，可还原关键命中链路（别名/规则版本/优先级）。
10. RAW\_DAILY 分区行数/站点数与 staging 对账一致；随机 50 行字段值一致。
11. STD 校验 100% 通过（类型/枚举/单位）；INPUT 信号条数合理（无异常暴涨/骤降）。
12. 质量四指标的验收计划已就绪：**T+1 ≤ 11:00** 完成 Acc/Cov/Stable/Fresh 校验。

---

## H. 下一步（自动化演进建议）

- **目录规范**：将人工交付切换到目录：`/landing/raw_<source>_tag/dt=YYYYMMDD/batch_id=XXX/`；文件名与列头不变。
- **元信息标准化**：`manifest.csv` 可升级 `manifest.parquet`（机读稳定），但字段名/语义保持一致。
- **Schema 校验**：在 DE 入口加 **Schema Registry**（列头/类型/必填/枚举合法性自动校验），失败即拒收+错误清单。
- **SLA 监控**：基于 `tag_source_registry.sla` 和指标看板，首要监控 Fresh=T+1、D+1≤11:00。
- **版本治理**：规格、规则、字典均走 SemVer；`snapshot_id/release_id/spec_version/rule_version` 打点到 `tag_trace`。
- **回放自动化**：将 E1–E3 封装为一键化脚本，输入 `batch_id + date_range` 即可重跑/对账/出报告。

