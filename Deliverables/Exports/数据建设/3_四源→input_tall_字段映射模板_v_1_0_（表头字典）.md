# 《四源→INPUT Tall 字段映射模板 v1.0》（CSV/表头字典）

> 版本：v1.0 · 适用里程碑：**930 上线 P0=13 标签**\
> 口径：**RAW（站×日×标签）统一主键 **``** → STD 校验与类型对齐 → INPUT Tall（signal\_key + 单值槽位）**\
> 本稿提供：可直接复制使用的 **CSV 列头**、**字段解释**、**取值与校验**、**映射到 INPUT Tall 的规则**。

---

## 0. 使用说明（务必先读）

- **三表对应三源**：
  - 区域反馈 **S2** → `raw_region_tag`
  - 商户运营 **S3** → `raw_ops_tag`
  - 情报反馈 **S4** → `raw_intel_tag`
- **主键统一**：每条记录唯一由 `(store_id, as_of_date, tag_code)` 决定；同键重复投递会**覆盖**（幂等）。
- **值槽位互斥**：`target_value_string/number/bool` **三选一，且仅一项非空**。
- ``** 选择方式**：从仓内视图 `vw_tag_spec_current` 导出下拉清单（`tag_code, tag_name, value_type, enum_values`），仅允许表内可选项。
- ``** 来源**：从 **S1 画像底表/视图**解析获得（必要时由前置解析脚本完成），不具备 `store_id` 的记录**暂不投递 RAW**。

---

## 1. CSV 列头模板（可直接复制）

### 1.1 区域反馈 S2（`raw_region_tag`）

```csv
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,report_time,reporter,source_channel,batch_id,reason,ext_col_1,ext_col_2
```

### 1.2 商户运营 S3（`raw_ops_tag`）

```csv
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,ttl_days,reason,report_time,reporter,source_channel,batch_id,ext_col_1
```

### 1.3 情报反馈 S4（`raw_intel_tag`）

```csv
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,report_time,reporter,source_channel,batch_id,reason,ext_col_1
```

> **格式要求**：UTF-8（无 BOM）、逗号分隔、首行即为表头；日期 `YYYY-MM-DD`，时间 `YYYY-MM-DD HH:MM:SS`（UTC+8）。

---

## 2. 字段字典与校验（通用）

| 字段                    | 必填    | 类型        | 取值/规则                       | 说明                          |
| --------------------- | ----- | --------- | --------------------------- | --------------------------- |
| store\_id             | 必填    | STRING    | 存量商户 ID（来自 S1 画像）           | 站点唯一识别，**没有则不投**            |
| as\_of\_date          | 必填    | DATE      | `YYYY-MM-DD`                | 事实所属自然日（通常 D-1）             |
| tag\_code             | 必填    | STRING    | 必须存在于 `vw_tag_spec_current` | 标签编码，人类可读且稳定                |
| target\_value\_bool   | 三选一   | TINYINT   | `1/0/99`（是/否/未知）            | 仅当 `value_type=BOOL`        |
| target\_value\_number | 三选一   | DECIMAL   | 数值，单位见标签定义                  | 仅当 `value_type=NUMBER`      |
| target\_value\_string | 三选一   | STRING    | 文本/枚举 code                  | 仅当 `value_type=STRING/ENUM` |
| ttl\_days             | S3 必填 | INT       | `>0`                        | 订正有效期（到期自动降级）               |
| reason                | 建议    | STRING    | 任意文本                        | 订正/填报原因或备注                  |
| report\_time          | 必填    | TIMESTAMP | `YYYY-MM-DD HH:MM:SS`       | 事实发生/录入时间                   |
| reporter              | 必填    | STRING    | 姓名/工号                       | 责任人标识                       |
| source\_channel       | 可选    | STRING    | `app/form/excel/...`        | 采集渠道                        |
| batch\_id             | 可选    | STRING    | 任意                          | 区分当日多批投递                    |
| ext\_\*               | 可选    | MIXED     | 任意                          | 预留扩展列（按月归并）                 |

**硬约束校验**（落 RAW/STD 前即判定）：

1. 主键 3 列均非空；
2. `target_value_*` 仅一项非空；
3. `tag_code` 在 `vw_tag_spec_current` 存在且 `value_type` 与填写的 `target_value_*` 类型一致；
4. `ttl_days` 仅 S3 订正必填且 `>0`；
5. `report_time` 可解析；
6. 字符串去首尾空白，空字符串按 NULL 处理。

---

## 3. 映射到 INPUT Tall 的规则（STD→INPUT）

### 3.1 取 `signal_key`

- 通过 `` 维护映射：`tag_code → signal_key`。例如：
  - `service.carwash_exists` → `service.carwash_exists`
  - `open.hours` → `open.hours`
  - `brand.display_text` → `brand.display_text`

### 3.2 值槽位映射（保持 1:1）

- 若 `target_value_bool` 非空 → `value_bool = target_value_bool`
- 若 `target_value_number` 非空 → `value_number = target_value_number`
- 若 `target_value_string` 非空 → `value_string = target_value_string`

### 3.3 其它字段填充

- `as_of_date` 原样；`store_id` 原样；
- `source` 取 `region|ops|intel`；
- `report_time` 与 `reporter` 原样；
- ER 后补齐 `station_gid`（从 S1 画像派生）。

> **注意**：`tag_code → value_type` 的一致性在 STD 校验；不一致直接拦截，不写入 INPUT。

---

## 4. 示例（三条）

### 4.1 区域反馈：有洗车（布尔）

```csv
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,report_time,reporter,source_channel,batch_id,reason
100023,2025-09-02,service.carwash_exists,1,,,2025-09-02 15:30:00,zhangsan,app,20250902A,门店口述+现场观察
```

→ INPUT Tall：`signal_key=service.carwash_exists, value_bool=1`

### 4.2 商户运营订正：营业 24h（布尔，带 TTL）

```csv
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,ttl_days,reason,report_time,reporter
100023,2025-09-02,open.24h,1,,,90,合同附件确认,2025-09-02 16:00:00,lisi
```

→ INPUT Tall：`signal_key=open.24h, value_bool=1`；规则层命中 whitelist→输出 Locked（TTL=90）

### 4.3 情报反馈：便利店类型（枚举）

```csv
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,report_time,reporter
100023,2025-09-02,service.store_type,,,c_store,2025-09-02 11:00:00,external_sync
```

→ INPUT Tall：`signal_key=service.store_type, value_string='c_store'`

---

## 5. 错误样例与修复建议

| 场景            | 错误示例                                                | 诊断      | 修复                                   |
| ------------- | --------------------------------------------------- | ------- | ------------------------------------ |
| 双槽位同时填        | `target_value_bool=1` 且 `target_value_string='yes'` | 违反互斥    | 仅保留与 `value_type` 匹配的一项              |
| tag\_code 不存在 | `tag_code='service.parking'`                        | 未登记     | 从 `vw_tag_spec_current` 选择合法项或申请新增   |
| 类型不匹配         | `tag_code=open.hours` 但填了 `target_value_bool=1`     | 类型错配    | 改填 `target_value_string='0800-2200'` |
| 缺少 store\_id  | `store_id=NULL`                                     | 主键缺失    | 先用 S1 解析出 `store_id` 再投递             |
| TTL 缺失        | S3 订正没填 `ttl_days`                                  | 订正缺少有效期 | 补填 `ttl_days>0`                      |

---

## 6. 提交流程（业务侧）

1. 从 `vw_tag_spec_current` 下载/同步可选 `tag_code` 清单（含取值类型与枚举）。
2. 选择需要回填/订正的标签项，按本模板准备 CSV。
3. 校验三件套：主键齐全、单槽位非空、类型一致。
4. 写入对应 RAW 分区表（`ingest_date=YYYYMMDD`）。
5. 通过 Hive SQL 自查到数与基本质量（行数/去重/互斥/类型）。

---

## 7. FAQ（常见疑问）

- **Q：是否可以一次上传多个标签？** 可以，CSV 多行即可；同一 `store_id+as_of_date` 可包含多个 `tag_code`。
- **Q：能否只提供 **``**？** 不建议。必须先解析得到 `store_id` 再投；否则会破坏主键幂等。
- **Q：**``** 去哪看？** 在 `vw_tag_spec_current` 的 `enum_set` 字段，或导出的下拉字典文件中。
- **Q：是否支持历史补录？** 支持，`as_of_date` 按实际自然日填写，跑数时以分区与日期合规为准。

