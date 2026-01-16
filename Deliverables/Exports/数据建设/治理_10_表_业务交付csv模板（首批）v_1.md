# 治理10表 · 业务交付CSV模板（首批）v1.0

> 共识：**业务侧一律交 CSV**，不要求产 JSON；如有嵌套结构，由 **DE 负责从 CSV 萃取/序列化** 为系统内部 JSON 或配置表。本文给出 **最小可用 CSV 头** + 示例行，开箱即用。

---

## 0) 批次元信息（manifest.csv）
**列头**
```
batch_id,producer,produced_at,as_of_date_start,as_of_date_end,source,file,rows,stores,notes,attachments
```
**说明**
- `source`: S1|S2|S3|S4
- `attachments`: 相关附件文件名（可用 `|` 分隔）
**示例**
```
BATCH_20250906_A,业务-王XX,2025-09-06T20:30:00+08:00,2025-09-06,2025-09-06,S2,raw_s2_ops_tag_staging.csv,12543,812,"brand 映射已完成","trace_lines.csv|brand_alias_delta.csv"
```

---

## 1) tag_catalog.csv（标签目录）
**列头**
```
tag_code,tier1,tier2,tier3,tag_class,owner_biz,owner_data,status
```
**示例**
```
brand_display,基础合作,品牌结构,外显品牌,A,王超宇,DE_TBD,released
```

---

## 2) tag_spec.csv（标签规格 / SCD2）
**列头**
```
tag_code,spec_version,definition,value_type,fallback,effective_from,effective_to,approved_by,approved_at
```
**示例**
```
brand_display,1.0.0,对外展示主品牌，未知回退其他,enum,other,2025-08-01,,王超宇,2025-08-01T10:00:00
```

---

## 3) tag_enum.csv（枚举集）
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

## 4) tag_quality_policy.csv（质量闸门）
**列头**
```
tag_code,spec_version,acc_min,cov_min,fresh_sla,stable_max,sample_min_n,sample_pct,review_mode
```
**示例**
```
brand_display,1.0.0,0.90,0.90,T+1,0.05,50,0.05,double_kappa>=0.8
```

---

## 5) tag_source_registry.csv（来源契约）
**列头**
```
source_id,source_name,table_name,refresh_policy,primary_keys,fields,sla,owner_biz,owner_data
```
**说明**
- `primary_keys`/`fields` 允许**用文本**（如 `store_id|as_of_date`、或 `name:string|brand_id:string`）；DE 侧再序列化。
**示例**
```
ops,商户运营,coop_ops_entry,T+1,store_id|updated_at,name:string|brand_text:string,20:00,王超宇,DE_TBD
```

---

## 6) tag_testset.csv（金标准样本）
**列头**
```
tag_code,spec_version,region,store_id,label_value,evidence,reviewed_by,reviewed_at,is_gold
```
**示例**
```
brand_display,1.0.0,浙江省,330100001,BRAND_0001,门头图+区域确认,张三,2025-09-05,true
```

---

## 7) rule_config_flat.csv（规则配置·扁平版，DE再组装）
**列头**
```
tag_code,rule_version,region_scope,priority_order,weights_official,weights_region,weights_ops,weights_external,weights_intel,threshold_1,threshold_2,fallback_unknown,fallback_conflict,blacklist_codes,whitelist_codes,is_active
```
**说明**
- `region_scope`: 省/市清单，`|` 分隔；
- `priority_order`: 来源优先级，如 `official>region>ops>external>intel`；
- `threshold_*`: 自由字段（如相似度阈值、N/K 等），文本数字皆可；
- 黑白名单：code 列表，用 `|` 分隔。
**示例**
```
overlap,1.0.0,浙江省|江苏省,official>external>region>ops>intel,1.0,0.9,0.85,0.8,0.7,er_name_sim>=0.90,days_3_7,99,99,,,
```

---

## 8) detector_config_flat.csv（探测器配置·扁平版，DE再组装）
**列头**
```
detector_id,tag_code,rule_version,signal_key,window_days,threshold_value,effect,is_active
```
**示例**
```
price_expose_d3,overlap,1.0.0,price_expose,3,>=1,inferred,true
```

---

## 9) 字典增量（以品牌为例 brand_alias_delta.csv）
**列头**
```
dict_id,brand_id,brand_name_std,alias,match_type,priority,valid_from,valid_to,status,spec_version,rule_version
```
**示例**
```
BRAND_ALIAS_V1,BRAND_0001,中国石化,中石化,regex,1,2024-01-01,2099-12-31,enabled,1.0.0,1.0.0
```

---

## 10) trace_lines.csv（可选，JSON 替代的扁平证据）
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

> DE 将据此**自动化组装**为治理10表目标结构（含内部 JSON 字段）、并承接 RAW→分区 RAW_DAILY→STD→INPUT Tall→OUTPUT。

