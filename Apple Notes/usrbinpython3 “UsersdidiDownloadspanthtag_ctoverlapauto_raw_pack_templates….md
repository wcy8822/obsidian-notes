--excel "/Users/didi/Downloads/panth/tag_ct/overlap/auto_raw_pack_templates/RAW_DELIVERY_TEMPLATE/BATCH_20250904_A/source_template.csv" \
  --mapping "/Users/didi/Downloads/panth/tag_ct/overlap/auto_raw_pack_templates/RAW_DELIVERY_TEMPLATE/BATCH_20250904_A/mapping_rules.csv" \
  --gov "/Users/didi/Downloads/panth/tag_ct/overlap/auto_raw_pack_templates/GOVERNANCE_TEMPLATES" \
  --out "/Users/didi/Downloads/panth/tag_ct/overlap/auto_raw_pack_templates/out" \
  --batch-id "BATCH_20250904_A" \
  --producer "业务-alveswang" \
  --force-s3


我们先定义一下,我的大文件结构的主路径是:

/Users/didi/Downloads/panth/tag_ct/overlap/auto_raw_pack_templates
用/…/替代,你要换回去

然后具体文件就是按文件结构在这个下面,跟你给我打包结构一致

[S3]
excel_or_csv=/.../RAW_DELIVERY_TEMPLATE/BATCH_20250904_A/source_template.csv
mapping_rules_csv=/.../RAW_DELIVERY_TEMPLATE/BATCH_20250904_A/mapping_rules.csv
gov_dir=/.../GOVERNANCE_TEMPLATES
out_dir=/.../out
batch_id=BATCH_20250904_A
producer=业务-alveswang
force_s3=true
brand_alias_delta_csv=/.../BATCH_20250904_A/brand_alias_delta.csv   # 可留空

[WINNER]
raw_s1_csv=
raw_s2_csv=
raw_s3_csv=/.../out/raw_s3_correction_tag_staging.csv
raw_s4_csv=
rule_config_flat_csv=/.../GOVERNANCE_TEMPLATES/rule_config_flat.csv
run_date=2025-09-04
winner_out_csv=/.../out/winner_preview.csv