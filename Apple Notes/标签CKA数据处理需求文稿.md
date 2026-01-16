## 一、项目背景与目标
<span style="font-family:.PingFangUITextSC-Regular;">为实现对客户数据的标准化分类与校验，需开发标签</span>CKA数据处理工具，通过品牌匹配、逻辑校验、数据清洗等流程，输出符合业务规则的分类结果，支撑客户等级（KA/CKA/小散）的精准判定，同时确保数据质量可追溯。


## 二、数据输入要求
1. **原始数据**：  
   - 来源文件：`/Users/didi/Downloads/panth/tag_ct/overlap/标签数据-重叠站-202507.xlsx`  
   - 工作表：`在线`（需严格指定，避免与其他工作表混淆）  
   - 核心字段：需包含`store_id`（门店ID）、`store_name`（门店名）、`party_first_name`（参与方名称）、`actual_controller`（实控人）等，其中`store_id`需以字符串形式读取，避免科学计数法。

2. **品牌对照表**：  
   - 来源文件：`/Users/didi/Downloads/panth/tag_ct/kacka/分类验证与品牌对照表.xlsx`  
   - 核心字段：`简称`（品牌名）、`主营/非主营`、`KA/CKA/小散`（用于判定客户等级）。


## 三、核心处理逻辑
### 1. 数据清洗规则
- **store_id处理**：  
  - 以字符串形式读取，移除引号、空格等特殊字符（如`'5932526965`→`5932526965`），保留原始长度（不限制为18位）。  
- **弃用品牌处理**：  
  - 完全排除弃用品牌（如`GPPC`、`长乐CNG`），输出时品牌名置为空值。  
- **重叠站数据关联**：  
  - 关联`标签数据-重叠站-202507.xlsx`的`在线`工作表，字段包括`store_level_mtd_v2`、`order_cnt_mtd`、`is_overlap`。  
  - 若`store_id`重复，按`store_level_mtd_v2`→`order_cnt_mtd`→`is_overlap`降序排列，取第一条（rn=1）。


### 2. 品牌匹配逻辑
- **关键词提取**：  
  - 拆分名称为细粒度关键词，过滤停用词（如“公司”“石油”）和地区词（如“广东”“山东”），支持中英文别名（如`Sinopec`→`中石化`）。  
- **匹配优先级**：  
  1. 精确匹配（关键词与品牌库简称完全一致）；  
  2. 子串匹配（品牌库简称是关键词的子串，按长度占比计算置信度）；  
  3. 模糊匹配（Levenshtein相似度≥0.6，不区分大小写）。  
- **KA品牌校验**：  
  - 最终客户等级为KA时，品牌名需在KA品牌库中（取自对照表中“主营”且“KA/CKA/小散=KA”的品牌）。


### 3. 数据质量与校验
- **新增字段校验**：  
  - 空值率：关键字段（如`store_id`、`品牌名`）空值率需≤10%，重叠站字段空值率需≤30%；  
  - 数据类型：`order_cnt_mtd`等需为数值型，无负值异常。  
- **最终数据校验**：  
  - 输出客户等级分布统计，品牌匹配置信度均值，低置信度匹配示例（置信度<0.7）。


### 4. 脏数据定义
<span style="font-family:.PingFangUITextSC-Regular;">仅标记“主营</span>>KA>品牌”逻辑冲突的记录，具体包括：  
- 主营单位（`主营/非主营=主营`）但最终客户等级≠KA；  
- 最终客户等级=KA，但品牌名不在KA品牌库或为空。  
- 实控人未匹配**不**算脏数据。


## 四、输出要求
1. **字段顺序**（严格遵循）：  
   `store_id`、`store_name`、`party_first_name`、`cleaned_party_name`、`cleaned_keywords`、`matched_abbr`、`confidence`、`主营/非主营`、`KA/CKA/小散`、`品牌名`、`actual_controller`、`coop_station_cnt`、`is_coop_station_cnt_valid`、`最终客户等级`、`分类层级`、`suggested_abbr`、`is_controller_matched`、`store_level_mtd_v2`、`order_cnt_mtd`、`is_overlap`。  

2. **文件命名**：  
   - 输出文件夹：`标签CKA清洗数据_时间戳`（如`标签CKA清洗数据_20250730_183000`）；  
   - 输出文件：`分类结果表_时间戳.csv`、`脏数据表_时间戳.csv`、`分析专用数据_时间戳.csv`，均含时间戳避免覆盖。  


## 五、版本说明
<span style="font-family:.PingFangUITextSC-Regular;">当前最新版本为</span>V7，主要优化：  
- 强化`store_id`格式处理，解决科学计数法和特殊字符问题；  
- 完善重叠站数据关联逻辑，支持重复处理和字段校验；  
- 严格控制输出字段顺序，新增详细日志和错误处理；  
- 明确版本标识（所有模块和日志标记为V7）。


## 六、依赖与环境
- 输入文件：原始数据（CSV/Excel）、品牌对照表（Excel）、重叠站数据（Excel）；  
- 运行环境：Python 3.9+，依赖库：`pandas`、`numpy`、`difflib`。



请对 organize_tags.py 增加两项修复，并把它们放在品牌回填之前执行：

【1. store_id 清洗规范化（两侧一致）】
目标：避免因格式差异导致 brand 回填 join 失败，同时不改变 store_id 的长度与前导零。

实现要求：
- 所有数据源读入时强制：dtype={'store_id': 'string'} 或 astype('string')
- 定义 normalize_store_id(s: str)：
  a) 若为空返回空；
  b) Unicode 规范化：unicodedata.normalize('NFKC', s)
  c) 去除零宽与不可见字符：[\u200B-\u200F\uFEFF]
  d) 去除首尾空白：包含半角空格、tab、NBSP(\u00A0)、全角空格(\u3000)
  e) 去除首尾引号：单/双引号与中英文引号（' " ‘ ’ “ ”）
  f) 去除 **前导**撇号（Excel 导致的 `'5932526965` → `5932526965`）
  g) 不做 int/float 转换；不去掉前导零；保留原始长度
- 在 staging、final、以及任何使用到 store_id 的 DataFrame 上，新增列 store_id_norm = normalize_store_id(store_id)，并用 store_id_norm 替代原 store_id 参与关联与后续流程；最终导出仍使用列名 store_id（即把规范化后的值覆盖回 store_id 字段）。
- manifest 计数：
  - store_id_normalized_total：参与规范化的行数
  - store_id_changed_count：规范化前后发生变化的行数（便于审计）

【2. CSV 中文编码修复】
目标：解决 /Users/didi/Downloads/panth/tag_ct_clean/out_*/correction_tag_staging_all.csv 中文乱码问题。

实现要求：
- 所有 CSV 输出（包括 correction_tag_staging_all.csv、raw_s1/2/3_correction_tag_staging.csv）统一：
  df.to_csv(path, index=False, encoding='utf-8-sig', newline='')
- 如有 CSV 输入（比如 tag_spec.csv），读取采用编码容错策略：
  try utf-8 → utf-8-sig → gbk（逐个尝试，成功即止），并在 manifest 中记录实际使用的编码：
  tag_spec_read_encoding = 'utf-8' | 'utf-8-sig' | 'gbk'
- manifest 增加：
  - output_csv_encoding: "utf-8-sig"

【3. 流程顺序（务必调整）】
请确保整体顺序：
RAW1 落槽 → store_id 规范化（两侧）→ brand 回填 → 无意义行丢弃 → 精确去重 → 按 source 分流落盘
（回填必须在丢弃/去重之前，否则会影响命中与计数。）

【4. 断言与自检】
- 断言：规范化后 staging 与 final 的 (store_id, tag_code) join 命中数 brand_join_matched > 0
- 断言：输出 CSV 文件 BOM 正确（写入 utf-8-sig 后，用二进制方式检查文件开头为 0xEF 0xBB 0xBF）
- 将以下计数写入 run_manifest.json：
  - store_id_normalized_total
  - store_id_changed_count
  - tag_spec_read_encoding
  - output_csv_encoding="utf-8-sig"

【5. 示例】
输入 store_id="'5932526965" 或 "  000123  " → 规范化后为 "5932526965" 与 "000123"（保留长度与前导零）。


