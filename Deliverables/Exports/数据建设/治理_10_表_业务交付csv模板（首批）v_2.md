# 治理10表 · 业务交付CSV模板（首批）v1.0

> 共识：**业务侧一律交 CSV**，不要求产 JSON；如有嵌套结构，由 **DE 负责从 CSV 萃取/序列化** 为系统内部 JSON 或配置表。本文给出 **最小可用 CSV 头** + 示例行，开箱即用。

---

## 表间映射与顺序（地铁线图）

**顺序总览（谁→谁）**

0. **治理前置（业务交 CSV）**：`tag_catalog / tag_spec / tag_enum / tag_quality_policy / tag_source_registry / tag_testset`  ➜  入治理层表，生成 `vw_tag_spec_current` 等“当前生效视图”。

1. **规则与探测器（业务交 CSV·扁平）**：`rule_config_flat / detector_config_flat`  ➜  DE 组装写入 `tag_rule_config / tag_detector_config`，并暴露 `vw_tag_rule_active`（仅激活版）。

2. **RAW 投喂（四源 CSV）**：`raw_s1/2/3/4_*_staging`（非分区覆盖） ➜ DE 承接到 `raw_*_daily`（`p_date=as_of_date`）分区表。

3. **STD 归一**：按 `vw_tag_spec_current.value_type` 做类型/枚举/合法性严格校验（布尔1/0/99；枚举写 code；ID 写 id）。

4. **INPUT Tall（信号事实）**：标准化后的“可消费信号”，按 `tag_signal_map`（内部表）声明“某 tag 吃哪些信号、优先级如何”。

5. **规则执行（A/B）**：B=契约直算；A=多源证据融合/探测器晋升，冲突回退、订正抢占（`Locked+TTL`）。

6. **OUTPUT Tall**：`tag_value_fact`（三槽位互斥+七件套+SCD2）+ 证据外置 `tag_trace`（按 `trace_id` 关联）。

7. **Hot 宽层**：白名单透视至 `tag_wide_daily`，兼容视图 `tag_wide_daily_compat` 渐进迁移。

8. **质量与发布**：按 `tag_quality_policy` 闸门 + `tag_testset` 回归；通过后写 `tag_release`，留痕 `tag_change_log`。

---

### 业务交付 CSV → DE 消费/生成 映射表（可打印）

| 业务交付 CSV                   | DE 消费/生成对象                                       | 消费阶段           | 作用/口径要点                                                                  |
| -------------------------- | ------------------------------------------------ | -------------- | ------------------------------------------------------------------------ |
| `tag_catalog.csv`          | `tag_catalog`                                    | 治理前置           | 注册 `tag_code`、层级、A/B、Owner，所有下游外键基准                                      |
| `tag_spec.csv`             | `tag_spec` ➜ `vw_tag_spec_current`               | 治理前置/STD/执行/输出 | 定义 `value_type/枚举/是否允许订正/生效期`；决定 **写哪个槽位**与拒收规则                          |
| `tag_enum.csv`             | `tag_enum`                                       | 输出/展示          | **code→label** 映射；展示与宽表 label 通过 join 获取                                 |
| `tag_quality_policy.csv`   | `tag_quality_policy`                             | 质检/发布          | Acc/Cov/Fresh/Stable 阈值与抽样策略；用于阻断/告警与验收                                  |
| `tag_source_registry.csv`  | `tag_source_registry`                            | 取数/规则执行        | 来源契约：表名、主键、字段、SLA；规则/DSL 输入约束                                            |
| `tag_testset.csv`          | `tag_testset`                                    | 质检/回归          | 金标样本与证据链接；计算 Acc/Kappa/漂移                                                |
| `rule_config_flat.csv`     | **组装**➜ `tag_rule_config` ➜ `vw_tag_rule_active` | 规则执行           | 来源优先级、权重、阈值、灰度、黑白名单；以 **激活版本**为准                                         |
| `detector_config_flat.csv` | **组装**➜ `tag_detector_config`                    | 探测器执行          | `signal_key/window/threshold/effect`，驱动证据阶梯（Candidate/Inferred/Verified） |
| `brand_alias_delta.csv`    | 公共/专属字典表（由 DE 入库）                                | 清洗/STD         | **字典只做映射**：脏串→标准 `id/code`；不直接当数据源                                       |
| `trace_lines.csv`（可选）      | `tag_trace`（DE 生成，按 `trace_id` 关联）               | 输出             | 扁平证据→结构化证据；可还原“为何产出该值”                                                   |
| 四源 RAW CSV                 | `raw_*_staging` ➜ `raw_*_daily`                  | RAW/承接         | **非分区覆盖→按 **``** 分区**，同分区全量覆盖，历史保留                                       |

> 记忆口诀：**“治口径→装规则→喂 RAW→落分区→做 STD→产 INPUT→跑规则→写 Tall→透视 Hot→质检发布”**。

---

## 0) 批次元信息（manifest.csv）

**列头**

```
batch_id,producer,produced_at,as_of_date_start,as_of_date_end,source,file,rows,stores,notes,attachments
```

**说明**

- `source`: S1|S2|S3|S4
- `attachments`: 相关附件文件名（可用 `|` 分隔） **示例**

```
BATCH_20250906_A,业务-王XX,2025-09-06T20:30:00+08:00,2025-09-06,2025-09-06,S2,raw_s2_ops_tag_staging.csv,12543,812,"brand 映射已完成","trace_lines.csv|brand_alias_delta.csv"
```

---

## 1) tag\_catalog.csv（标签目录）

**列头**

```
tag_code,tier1,tier2,tier3,tag_class,owner_biz,owner_data,status
```

**示例**

```
brand_display,基础合作,品牌结构,外显品牌,A,王超宇,DE_TBD,released
```

---

## 2) tag\_spec.csv（标签规格 / SCD2）

**列头**

```
tag_code,spec_version,definition,value_type,fallback,effective_from,effective_to,approved_by,approved_at
```

**示例**

```
brand_display,1.0.0,对外展示主品牌，未知回退其他,enum,other,2025-08-01,,王超宇,2025-08-01T10:00:00
```

---

## 3) tag\_enum.csv（枚举集）

**列头**

```
tag_code,spec_version,enum_code,enum_label,sort_order,is_default
```

**示例**

```
brand_level,1.0.0,KA,KA,1,false
brand_level,1.0.0,CKA,CKA,2,false
brand_level,1.0.0,SMALL,小散,3,true
```

---

## 4) tag\_quality\_policy.csv（质量闸门）

**列头**

```
tag_code,spec_version,acc_min,cov_min,fresh_sla,stable_max,sample_min_n,sample_pct,review_mode
```

**示例**

```
brand_display,1.0.0,0.90,0.90,T+1,0.05,50,0.05,double_kappa>=0.8
```

---

## 5) tag\_source\_registry.csv（来源契约）

**列头**

```
source_id,source_name,table_name,refresh_policy,primary_keys,fields,sla,owner_biz,owner_data
```

**说明**

- `primary_keys`/`fields` 允许**用文本**（如 `store_id|as_of_date`、或 `name:string|brand_id:string`）；DE 侧再序列化。 **示例**

```
ops,商户运营,coop_ops_entry,T+1,store_id|updated_at,name:string|brand_text:string,20:00,王超宇,DE_TBD
```

---

## 6) tag\_testset.csv（金标准样本）

**列头**

```
tag_code,spec_version,region,store_id,label_value,evidence,reviewed_by,reviewed_at,is_gold
```

**示例**

```
brand_display,1.0.0,浙江省,330100001,BRAND_0001,门头图+区域确认,张三,2025-09-05,true
```

---

## 7) rule\_config\_flat.csv（规则配置·扁平版，DE再组装）

**列头**

```
tag_code,rule_version,region_scope,priority_order,weights_official,weights_region,weights_ops,weights_external,weights_intel,threshold_1,threshold_2,fallback_unknown,fallback_conflict,blacklist_codes,whitelist_codes,is_active
```

**说明**

- `region_scope`: 省/市清单，`|` 分隔；
- `priority_order`: 来源优先级，如 `official>region>ops>external>intel`；
- `threshold_*`: 自由字段（如相似度阈值、N/K 等），文本数字皆可；
- 黑白名单：code 列表，用 `|` 分隔。 **示例**

```
overlap,1.0.0,浙江省|江苏省,official>external>region>ops>intel,1.0,0.9,0.85,0.8,0.7,er_name_sim>=0.90,days_3_7,99,99,,,
```

---

## 8) detector\_config\_flat.csv（探测器配置·扁平版，DE再组装）

**列头**

```
detector_id,tag_code,rule_version,signal_key,window_days,threshold_value,effect,is_active
```

**示例**

```
price_expose_d3,overlap,1.0.0,price_expose,3,>=1,inferred,true
```

---

## 9) 字典增量（以品牌为例 brand\_alias\_delta.csv）

**列头**

```
dict_id,brand_id,brand_name_std,alias,match_type,priority,valid_from,valid_to,status,spec_version,rule_version
```

**示例**

```
BRAND_ALIAS_V1,BRAND_0001,中国石化,中石化,regex,1,2024-01-01,2099-12-31,enabled,1.0.0,1.0.0
```

---

## 10) trace\_lines.csv（可选，JSON 替代的扁平证据）

**列头**

```
upload_batch_id,store_id,as_of_date,tag_code,alias,dict_hit,match_type,priority,er_dist_m,er_name_sim,detector_signal,detector_days,source_list,rule_version,spec_version,extra_notes
```

**示例**

```
BATCH_20250906_A,370100001,2025-09-06,brand_display,中石化XX加油站,BRAND_0001,regex,1,,,,ops|external,1.0.0,1.0.0,门头OCR命中
BATCH_20250906_B,370100001,2025-09-06,overlap,,,,,120,0.93,price_expose,3,external|intel,1.0.0,1.0.0,竞对强匹配
```

---

## 11) RAW 四源 CSV（引用《RAW 业务可投喂包》列头）

> 仍使用：

```
store_id,as_of_date,tag_code,target_value_bool,target_value_number,target_value_string,source,evidence_state,ttl_days,reason,conf,upload_batch_id
```

---

### 交付顺序（一次性交齐）

1. `manifest.csv` + 四源 RAW CSV；
2. `tag_catalog/tag_spec/tag_enum/tag_quality_policy/tag_source_registry/tag_testset` 六张治理 CSV；
3. `rule_config_flat.csv` + `detector_config_flat.csv`；
4. 字典增量 CSV + 可选 `trace_lines.csv`。

> DE 将据此**自动化组装**为治理10表目标结构（含内部 JSON 字段）、并承接 RAW→分区 RAW\_DAILY→STD→INPUT Tall→OUTPUT。

