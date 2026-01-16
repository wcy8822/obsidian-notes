---
title: ChatGPT-商户画像-3表治理分析
source: https://chatgpt.com/g/g-p-692abef2079c81918c16c22b66aec849-shang-hu-hua-xiang/c/6935365d-d3d4-8322-a8e1-e1610571a5e5
author:
  - "[[ChatGPT-非油品-2期BRD草稿]]"
published:
created: 2025-12-23
description: ChatGPT 是一款供日常使用的 AI 聊天机器人。与最先进的 AI 模型互动，探索创意、解决问题以及提升学习效率。
tags:
  - clippings
---
\[ ### SHOW FULL COLUMNS FROM tag\_enum;
```
Field    Type    Collation    Null    Key    Default    Extra    Privileges    Comment
tag_code    varchar(64)    utf8mb4_0900_ai_ci    NO    PRI            select,insert,update,references    标签英文名
spec_version    varchar(16)    utf8mb4_0900_ai_ci    NO    PRI            select,insert,update,references    规格版本号
enum_code    varchar(64)    utf8mb4_0900_ai_ci    NO    PRI            select,insert,update,references    枚举编码
enum_label    varchar(128)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    枚举中文展示名称
sort_order    int        NO                select,insert,update,references    排序值，越大越靠前，默认值通常最小
is_default    tinyint        NO                select,insert,update,references    是否默认值，1=是，0=否
brand_aliases    text    utf8mb4_0900_ai_ci    YES                select,insert,update,references    品牌别名，用于匹配
exclusion_field    text    utf8mb4_0900_ai_ci    YES                select,insert,update,references    排除词，防止误匹配
brand_category    varchar(64)    utf8mb4_0900_ai_ci    YES                select,insert,update,references    品牌类别，如石化/民营等
keywords    text    utf8mb4_0900_ai_ci    YES                select,insert,update,references    其他关键词
is_active    tinyint        NO                select,insert,update,references    是否当前有效，1=是，0=否
match_method    int        NO                select,insert,update,references    匹配方法编号
match_score_threshold    decimal(5,2)        NO                select,insert,update,references    匹配分数阈值
white_list    tinyint        NO                select,insert,update,references    是否白名单强制命中，1=是，0=否
black_list    tinyint        NO                select,insert,update,references    是否黑名单强制排除，1=是，0=否
created_at    timestamp        NO        CURRENT_TIMESTAMP    DEFAULT_GENERATED    select,insert,update,references    记录创建时间
updated_at    timestamp        NO        CURRENT_TIMESTAMP    DEFAULT_GENERATED on update CURRENT_TIMESTAMP    select,insert,update,references    最近更新时间
updated_by    varchar(64)    utf8mb4_0900_ai_ci    YES                select,insert,update,references    最近一次修改人
```
\### SHOW FULL COLUMNS FROM tag\_spec;
```
Field    Type    Collation    Null    Key    Default    Extra    Privileges    Comment
tag_code    varchar(64)    utf8mb4_0900_ai_ci    NO    PRI            select,insert,update,references    标签英文名
spec_version    varchar(16)    utf8mb4_0900_ai_ci    NO    PRI            select,insert,update,references    规格版本号，如1.0.0
definition    text    utf8mb4_0900_ai_ci    NO                select,insert,update,references    标签定义
value_type    varchar(16)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    标签值类型：enum/bool/string
fallback    varchar(64)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    回退默认值
effective_from    date        NO                select,insert,update,references    规格生效开始日期
effective_to    date        YES                select,insert,update,references    规格生效结束日期，NULL表示长期
approved_by    varchar(64)    utf8mb4_0900_ai_ci    YES                select,insert,update,references    审批人
approved_at    datetime        YES                select,insert,update,references    审批时间
calc_type    varchar(16)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    计算方式：compute/result
validation_regex    text    utf8mb4_0900_ai_ci    YES                select,insert,update,references    值校验正则
ttl_days    int        NO                select,insert,update,references    标签有效期天数
w_source_s1    decimal(5,2)        NO                select,insert,update,references    来源S1权重
w_source_s2    decimal(5,2)        NO                select,insert,update,references    来源S2权重
w_source_s3    decimal(5,2)        NO                select,insert,update,references    来源S3权重
w_source_s4    decimal(5,2)        NO                select,insert,update,references    来源S4权重
decay_mode    varchar(16)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    置信度衰减模式，如linear
delta_min    decimal(5,2)        NO                select,insert,update,references    置信度最小衰减步长
value_type_connect    varchar(32)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    映射到事实表的字段类型：target_value_bool/number/string
created_at    timestamp        NO        CURRENT_TIMESTAMP    DEFAULT_GENERATED    select,insert,update,references    记录创建时间
updated_at    timestamp        NO        CURRENT_TIMESTAMP    DEFAULT_GENERATED on update CURRENT_TIMESTAMP    select,insert,update,references    最近更新时间
updated_by    varchar(64)    utf8mb4_0900_ai_ci    YES                select,insert,update,references    最近一次修改人
```
\### SHOW FULL COLUMNS FROM tag\_catalog;
```
Field    Type    Collation    Null    Key    Default    Extra    Privileges    Comment
tag_code    varchar(64)    utf8mb4_0900_ai_ci    NO    PRI            select,insert,update,references    标签英文名，主键
tier1    varchar(64)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    一级类目
tier2    varchar(64)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    二级类目
tier3    varchar(128)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    三级类目，通常是标签中文名
tag_class    char(1)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    标签等级分类，如A/B
owner_biz    varchar(64)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    业务负责人
owner_data    varchar(64)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    数据负责人
status    varchar(32)    utf8mb4_0900_ai_ci    NO                select,insert,update,references    状态：draft/released/deprecated等
is_p0    tinyint        NO                select,insert,update,references    是否P0标签，1=是，0=否
created_at    timestamp        NO        CURRENT_TIMESTAMP    DEFAULT_GENERATED    select,insert,update,references    记录创建时间
updated_at    timestamp        NO        CURRENT_TIMESTAMP    DEFAULT_GENERATED on update CURRENT_TIMESTAMP    select,insert,update,references    最近更新时间
updated_by    varchar(64)    utf8mb4_0900_ai_ci    YES                select,insert,update,references    最近一次修改人
```
\]总结一下我这个 3 个字典表.核心描述各个表的字段和逻辑,在讲 3 个表的关联,最后讲你的理解和建议.不改现在的基础上做个迭代;

20251207\_1045\_标签字典三表梳理\_v1

tags: #标签字典 #商户画像 #标签治理 #数据建模

---

### 1）一句话结论

这三张表本质上分别承担了「业务标签目录（tag\_catalog）+ 标签规格与计算规则（tag\_spec）+ 枚举值与匹配规则（tag\_enum）」三层职责，结构已经基本合理，下一步主要是通过“约束 + 视图 + 使用规范”把它们真正固化成一套可长期演进的标签治理基座。

---

### 2）三段论据（现状与问题 → 关键洞察 → 路径方案）

**论据一：现状与问题 —— 三表职责清晰，但落地依赖隐含约定**

- `tag_catalog` ：一行一个 `tag_code` ，承载的是 **业务维度的标签目录** ——分类（tier1/2/3）、优先级（tag\_class / is\_p0）、责任人（owner\_biz/owner\_data）、生命周期状态（status）。这是“标签是什么、谁负责、重要程度”的统一入口。
- `tag_spec` ：以 `(tag_code, spec_version)` 为主键，负责标签的 **技术规格与计算规则** ：定义（definition）、类型（value\_type）、回退值（fallback）、生效区间（effective\_from/to）、TTL（ttl\_days）、多来源权重（w\_source\_s1~s4）、置信度衰减（decay\_mode/delta\_min）、以及与事实表字段的映射方式（value\_type\_connect）。
- `tag_enum` ：同样以 `(tag_code, spec_version, enum_code)` 为主键，存放 **枚举值字典 + 文本匹配规则** ：展示名称（enum\_label）、默认值（is\_default）、排序（sort\_order）、是否启用（is\_active），以及针对品牌类标签的 alias、排除词、品牌类别、关键词、白名单/黑名单、匹配方法与阈值等。
- 当前问题：
	- 三表逻辑在你脑子里是清楚的，但在数据库层面缺少“显式约束”和“标准访问视图”（例如：什么叫当前生效版本、枚举值和 fallback 的一致性如何保证），后续其他人接入容易踩坑。
	- 品牌匹配相关字段集中在 `tag_enum` ，与普通枚举共用一张表，在语义上是“合理的叠加”，但需要明确： **哪些标签可以/应该使用这些匹配字段？** 否则可能出现“字段很多但没人敢用”的情况。

---

**论据二：关键洞察 —— 三表其实对应三层治理视角**

可以把这套设计映射到一个很清晰的三层模型：

1. **“我有哪几类标签”（标签资产层）： `tag_catalog`**
	- 维度：tier1/2/3 + tag\_class + is\_p0 + status
	- 解决的是： **标签盘点、优先级、Owner 和生命周期管理** 。
	- 与商户画像项目直接对应的是：哪些标签是 A 类/P0，必须优先打通到商户视图。
2. **“每个标签具体怎么长成值”（标签规格层）： `tag_spec`**
	- 维度：value\_type、calc\_type、definition、ttl\_days、w\_source\_\*、decay\_mode、value\_type\_connect…
	- 解决的是： **计算口径统一、版本演进可追溯** （spec\_version + effective\_from/to）。
	- 对下游来说，正确的打开方式是：给定 `tag_code + as_of_date` ，只应该有一条“当前有效的规格”。
3. **“这个标签有哪些合法取值 / 如何从文本识别出来”（枚举与匹配层）： `tag_enum`**
	- 维度：enum\_code/enum\_label/is\_default/sort\_order/is\_active + brand\_aliases/exclusion\_field/keywords/match\_\*
	- 解决的是： **标签值的取值空间 + 文本匹配策略** ，特别是品牌/品类类标签。
	- 与 `tag_spec.value_type = 'enum'` 紧密耦合， `enum_code` 既是逻辑枚举值，也是最终写入事实表的可读编码。

这三层叠在一起，就构成了完整的「标签治理矩阵」： **业务视图（catalog） → 规则视图（spec） → 数据值视图（enum）** 。  
目前结构已经具备这一能力，差的是一些小的制度化“收口动作”。

---

**论据三：落地与风险 —— 不动现有表结构，增强约束与访问方式**

在“不改现在表结构”的前提下，可以做一轮轻量迭代，把风险点收一收：

1. **增加逻辑约束（通过约定/脚本/检查视图实现）**
	- 对 `tag_spec` ：
		- 同一 `tag_code` 在任一自然日内， **至多一个规格版本有效** ：  
			`effective_from <= as_of_date < IFNULL(effective_to, '9999-12-31')` 应该只有一条记录。
		- 当 `value_type = 'enum'` 时：
			- `fallback` 必须出现在对应 `(tag_code, spec_version)` 的 `tag_enum.enum_code` 列表中。
		- 当 `value_type != 'enum'` 时：
			- `tag_enum` 可以为空，落库和业务逻辑需容忍。
	- 对 `tag_enum` ：
		- `match_score_threshold` 、 `w_source_*` 思路一致，建议统一标准：例如 0–1 区间还是 0–100 区间，避免后续不同标签各玩各的。
		- 品牌匹配字段（brand\_aliases / exclusion\_field / brand\_category / keywords）建议约定只为特定类型标签使用（例如 tier1=“品牌与渠道” 或某一类 `value_type` ）。
2. **构建标准访问视图，而不是直接查物理表**
	- 例如为下游提供：
		- `v_tag_spec_active` ：
			- 每个 `tag_code` 只暴露当前有效规格（按 `effective_from/to` + 最大发布 spec\_version 选一条）。
		- `v_tag_enum_active` ：
			- 只暴露 `is_active = 1` 的枚举值；
			- JOIN `tag_spec` ，限制在 `value_type = 'enum'` 的标签上。
		- `v_tag_catalog_full` ：
			- JOIN `v_tag_spec_active` ，带出标签的当前类型、TTL、calc\_type 等关键字段（方便运营和产品看一张总表）。
3. **风险与演进**
	- 如果不做上述约束，后续可能会出现：
		- 同一标签在某天有两个有效规格版本，导致画像结果前后不一致、难以追溯。
		- fallback 不在枚举列表中，造成界面展示、风控逻辑的各种“其他”异常。
		- 品牌 alias/黑白名单被随意填，匹配线上效果好坏全靠人肉记忆，无法系统迭代。
	- 通过视图和校验脚本，可以在不动表结构的前提下，逐步把这套体系从“约定俗成”升级为“规则可检查”。

---

### 3）思维导图结构（文本分层）

**一、三个字典表概览**

1. `tag_catalog` —— 标签目录 & 责任人  
	1.1 键与粒度
	- 主键： `tag_code` （一行一个标签）
	- 粒度：标签级（不随版本变化）  
		1.2 核心字段
	- 类目： `tier1` / `tier2` / `tier3` （三级分类 + 中文名）
	- 重要度： `tag_class` （A/B 等）， `is_p0` （是否 P0 标签）
	- 责任划分： `owner_biz` / `owner_data`
	- 生命周期： `status` （draft / released / deprecated 等）  
		1.3 角色定位
	- 统一标签清单
	- 标签优先级和 Owner 管理
	- 作为所有标签治理讨论的“目录入口”
2. `tag_spec` —— 标签规格 & 计算规则  
	2.1 键与粒度
	- 主键： `(tag_code, spec_version)`
	- 粒度：标签规格版本级  
		2.2 核心业务字段
	- 定义： `definition` （标签定义）
	- 类型： `value_type` （enum/bool/string）
	- 默认值： `fallback` （需与 value\_type 和 enum 匹配）
	- 有效期： `effective_from` / `effective_to` （版本生效区间）
	- 计算方式： `calc_type` （compute/result）  
		2.3 数据质量 & 算法相关字段
	- TTL： `ttl_days`
	- 来源权重： `w_source_s1~s4` （S1–S4 来源权重）
	- 衰减： `decay_mode` （如 linear）、 `delta_min` （衰减步长）
	- 取值验证： `validation_regex`
	- 连接事实表： `value_type_connect` （target\_value\_bool/number/string）  
		2.4 治理字段
	- 审批： `approved_by` / `approved_at`
	- 审计： `created_at` / `updated_at` / `updated_by`
3. `tag_enum` —— 枚举值 & 文本匹配规则  
	3.1 键与粒度
	- 主键： `(tag_code, spec_version, enum_code)`
	- 粒度：标签规格版本下的单一枚举值  
		3.2 枚举值层面字段
	- 编码： `enum_code` （写入事实表的值）
	- 展示： `enum_label` （中文展示名）
	- 排序/默认： `sort_order` / `is_default`
	- 是否有效： `is_active`  
		3.3 品牌/文本匹配相关扩展字段
	- 匹配词： `brand_aliases` 、 `keywords`
	- 排除词： `exclusion_field`
	- 品牌分类： `brand_category` （石化/民营等）
	- 匹配逻辑： `match_method` 、 `match_score_threshold`
	- 白/黑名单： `white_list` / `black_list`  
		3.4 审计字段
	- `created_at` / `updated_at` / `updated_by`

---

**二、三表关联逻辑**

1. `tag_catalog` ↔ `tag_spec`
	- 关联键： `tag_catalog.tag_code = tag_spec.tag_code`
	- 关系：1 (catalog): N (spec 版本)
	- 使用方式：
		- 从业务目录出发，列出某标签的所有历史版本规格；
		- 或在视图中只暴露“当前有效 + 最新版本”的规格信息。
2. `tag_spec` ↔ `tag_enum`
	- 关联键： `tag_spec.tag_code = tag_enum.tag_code AND tag_spec.spec_version = tag_enum.spec_version`
	- 关系：1 (spec 版本): N (枚举值)
	- 使用方式：
		- 当 `tag_spec.value_type='enum'` 时， `tag_enum` 提供合法值集合和匹配配置；
		- `fallback` 应该是这一集合中的一员（业务规则）。
3. 事实表 / 计算逻辑的使用路径（抽象）
	- 步骤 1：根据 `tag_catalog` 决定要计算/使用哪些标签（按 tier / is\_p0 / status 过滤）。
	- 步骤 2：调用 `tag_spec` （按 `tag_code + as_of_date` ）拿到当前有效规格：包括类型、TTL、calc\_type、w\_source\_\* 等。
	- 步骤 3：如为 enum 型：
		- 从 `tag_enum` 拿当前启用枚举列表（ `is_active=1` ），构建映射规则；
		- 若为品牌类标签，则利用 alias/keywords/白黑名单进行文本匹配。
	- 步骤 4：将计算结果按 `value_type_connect` 写入事实表的 `target_value_*` 字段。

---

**三、我的理解与建议（在现有结构上的迭代方向）**

1. **明确“当前有效版本”的统一口径（建议用视图，而不是每个 SQL 自己算）**
	- 约定：给定 `(tag_code, as_of_date)` ， `tag_spec` 应该只有一条符合条件的有效记录。
	- 实施：
		- 建议用一个 `v_tag_spec_active` 视图封装：
			- 逻辑包含：按 `effective_from/to` 过滤 + 若重叠则取最大的 `spec_version` 。
			- 后续所有计算逻辑只依赖这个视图，不直接查物理表。
	- 价值：
		- 下游不需要理解所有历史版本规则，只消化“今天的规则”；
		- 未来变更只需新增版本，无需改老数据。
2. **为 enum 型标签补齐“fallback ∈ 枚举列表”的校验环节**
	- 保持现有结构不动，在 ETL 或定期脚本中增加检查：
		- 针对 `value_type='enum'` 的标签，检查 `tag_spec.fallback` 是否在对应 `tag_enum.enum_code` 里；
		- 如不在，给出告警或阻断发布。
	- 对运营/产品来说，这会极大减少“fallback 显示成一串奇怪代码”的问题。
3. **规范化品牌匹配字段的使用范围**
	- 在文档和数据层面建立“规范标签清单”，比如：
		- 只有 `tier1='品牌与渠道'` 且 `value_type='enum'` 的标签可以/应该填 `brand_aliases/keywords/exclusion_field/brand_category` ；
		- 其他标签即便字段非空，在逻辑上也不启用匹配引擎。
	- 可以通过一个 `v_tag_enum_brand_matching` 视图收口：
		- 只暴露满足上述条件、且 `is_active=1` 的记录给匹配逻辑使用。
4. **轻量治理安排（不改表结构，但提升可用性）**
	- 数据层面：
		- 在 `tag_spec` / `tag_enum` 上增加合适的联合索引（如 `(tag_code, effective_from)` 、 `(tag_code, spec_version, is_active)` ），提高查询效率。
	- 流程层面：
		- 发布新标签或新版本时，“最小检查清单”里包含：
			- 是否配置到 `tag_catalog` ，且 `status` 不是 deprecated；
			- spec 是否有 TTL、fallback、value\_type\_connect；
			- 当 enum 型时，对应的 `tag_enum` 是否已配置且包含 fallback；
			- 是否在 brand 匹配视图中出现（如果是品牌类标签）。
	- 文档层面：
		- 用当前三表定义快速画一张「标签治理体系图」（业务/规格/枚举三层）给老板和合作团队对齐；这会让后续的“商户画像标签池”、“标签计算任务”、“标签可视化”都更顺滑。

---

### 4）迭代日志

- **来源**
	- 来自你提供的三张表结构（ `tag_enum` / `tag_spec` / `tag_catalog` 的字段定义与注释），结合商户画像项目的整体语境。
- **本轮结论**
	- 现有三表角色分工清晰，已经天然对应“目录层 / 规格层 / 枚举与匹配层”。
	- 在不改表结构的前提下，通过约束规则、访问视图和使用规范，就可以把它们升级成一套稳定可演进的标签治理底座。
- **本轮改动点（思路迭代）**
	1. 把三表从“字段罗列”抽象提升为“三层治理模型”，方便后续与业务/技术对齐。
	2. 明确提出“当前有效版本”视图、fallback 枚举一致性校验、品牌匹配视图三类轻量改造方向。
	3. 强调将校验和规范尽量前置在“发布环节”和“公共视图”中，而不是让每个下游任务各自实现一套逻辑。
- **待补充信息**
	- 每个标签的典型使用场景（例如：品牌标签主要用在商户归因、投放、风控哪一块）。
	- 现在线上已经有哪些作业/服务在读这三张表，它们各自的访问模式（频率、过滤条件）。
	- 事实表或标签结果表的结构（尤其是 `target_value_*` 的设计、与 `value_type_connect` 的对应关系）。
- **下一步建议**
	1. 先选 3–5 个核心 P0 标签（最好包含一个品牌类枚举标签），按照上述思路试着搭一版：
		- `v_tag_spec_active` + `v_tag_enum_active` + `v_tag_enum_brand_matching` 。
	2. 看看对现有计算任务/商户画像看板的改造成本有多大，再决定是否推广到全量标签。
	3. 如果你愿意，下一轮可以一起把“当前有效版本视图 + 校验 SQL/脚本”的具体方案写出来，做到可以直接交给数据侧落地。

20251207\_1115\_兜底值单一来源方案\_v1

tags: #fallback兜底值 #标签字典 #一致性治理 #商户画像

---

### 1）一句话结论

兜底值必须统一以 `tag_spec.fallback` 作为唯一“真相来源”， `tag_enum` 和其他表一律从这里派生或校验，通过视图 + 批量同步 SQL 保证“订正一处、全链路生效”，避免多处手改。

---

### 2）三段论据（现状与问题 → 关键洞察 → 路径方案）

**论据一：现状与问题——兜底值被多表隐式表达，存在天然不一致风险**

- 兜底值在当前三表中的体现：
	- `tag_spec` ：有明确字段 `fallback` ，定义为“标签兜底默认值”，适用于 enum/bool/string 全类型，是 **标准的规格层定义** 。
	- `tag_enum` ：通过 `is_default` 标记某个 `enum_code` 为默认值，本质上也是一种“兜底值”的表达，但语义是“在所有枚举值中，哪个是默认选项”，更偏 **界面/枚举层** 。
	- `tag_catalog` ：没有任何默认值/兜底相关字段。
- 问题点：
	- 对 enum 型标签， `fallback` 和 `is_default` 有可能产生冲突（例如 `fallback='99'` ，但 `is_default=1` 打在 `enum_code='00'` 上）。
	- 下游如果有人直接用 `tag_enum.is_default` 、有人直接用 `tag_spec.fallback` ，一旦你“只改了一处”，就会出现行为不一致。

---

**论据二：关键洞察——兜底值是“规格级属性”，不应该在枚举层独立定义**

- 从职责分层看：
	- `tag_spec` 描述“一个标签在某个版本下 **应该如何计算和表现** ”，兜底值（fallback）是其中核心一环（值类型、TTL、来源权重、衰减规则都在这里）。
	- `tag_enum` 描述的是“这一规格下合法的 **取值集合** 以及辅助匹配策略”，它不具备决定“兜底值是什么”的主权，只能 **映射和承接** 规格层定义。
- 因此正确的方向是：
	- 把“兜底值是哪个 code/值”这件事， **只允许在 `tag_spec.fallback` 上进行订正** ；
	- `tag_enum.is_default` 必须是一个“衍生字段”（derived），仅用于 UI/配置便利，一切读写逻辑都要围绕 spec 的定义来对齐。
- 一旦确定：
	- 兜底值 = `tag_spec.fallback`  
		那么所有下游逻辑（枚举默认、商户画像初始化值、缺失填充逻辑等）都可以统一从 spec 获取， `tag_enum` 只做“展示和 alias”。

---

**论据三：路径方案——定义单一来源 + 统一读取视图 + 周期同步脚本**

- 兜底值的 **唯一编辑入口** ： `tag_spec.fallback`
	- 任何“改默认值/改兜底值”的需求，都只修改 `tag_spec` 。
	- 对 enum 型标签， `fallback` 必须是某个 `enum_code` ；对 bool/string 则可以是具体值（"0"/"1"/"UNKNOWN"...）。
- 统一读取方式：
	- 所有业务代码、ETL、API 都不再直接查 `tag_enum.is_default` ，而是：
		- 从 `tag_spec` 拿 `fallback` ；
		- 对 enum 型标签，如需展示“默认枚举项”，再左联 `tag_enum` ，把 `enum_code == fallback` 的那一行当作默认项。
- 同步与守护机制：
	- 通过一个统一的批量 SQL，把 `tag_enum.is_default` 自动对齐到 `tag_spec.fallback` ，而不是手工维护：
		- 每次你批量订正 fallback 后，执行一次同步；
		- 或者做成定时任务（天级、小时级），自动纠偏。
	- 这样可以满足你“订正一处、其他自动变”的要求，同时不破坏现有表结构。

---

### 3）思维导图结构（文本分层）

#### 一、兜底值在三表中的分布与角色

1. `tag_catalog`
	- 兜底值相关字段： **无** 。
	- 作用：标签目录（分类、Owner、状态、P0 标记）。
	- 结论：与兜底值无直接关系，是 **兜底逻辑的上游标签清单** ，但不参与数值定义。
2. `tag_spec`
	- 兜底字段： `fallback` （varchar(64)）
	- 配套信息：
		- `value_type` ：enum / bool / string
		- `value_type_connect` ：target\_value\_bool/number/string
		- `ttl_days` 、 `w_source_*` 、 `decay_mode` ：都与“值如何产生/衰减”有关。
	- 定位：规格级别的 **唯一兜底定义** ：
		- 对 enum：fallback = 某个 `enum_code`
		- 对 bool：fallback = "0" / "1" 等
		- 对 string：fallback = "UNKNOWN" 等
	- 这是我们建议的兜底“唯一真相来源”。
3. `tag_enum`
	- 与兜底相关字段：
		- `enum_code` ：具体枚举编码
		- `enum_label` ：中文展示名
		- `is_default` ：是否默认值，1=是，0=否
	- 其他字段（alias、keywords、白黑名单等）偏向“匹配与展示”，不定义兜底语义。
	- 结论：
		- `is_default` 应视为“从 `tag_spec.fallback` 映射过来的标记”，而不是兜底定义本身。

---

#### 二、三表的相同字段梳理与职责划分

1. 字面上一致的字段
- 三表共有：
	- `tag_code`
	- `created_at`
	- `updated_at`
	- `updated_by`
- 仅 `tag_spec` 与 `tag_enum` 共有：
	- `spec_version`
1. 如何保持“订正一处、其他自动变”
- 对每一个“重复字段/概念”，指定“谁是主表”：
	1. `tag_code` ：
		- 主表： `tag_catalog` （标签存在性的权威来源）
		- `tag_spec` 、 `tag_enum` 只能引用 catalog 中已存在的 `tag_code` 。
		- 实现方式：
			- 最理想：外键约束（如果允许）；
			- 或标签发布流程中做检查：创建 spec/enum 前必须先有 catalog 记录。
	2. `spec_version` ：
		- 主表： `tag_spec` （规格版本号由这里定义和发布）
		- `tag_enum` 的 `(tag_code, spec_version)` 必须在 `tag_spec` 里存在。
		- 实现方式：
			- 定义约定：不允许只在 `tag_enum` 新增一个 spec\_version；
			- 可以用批量检查 SQL 找出“有 enum 没 spec”的异常。
	3. `created_at` / `updated_at` / `updated_by` ：
		- 这是各表独立审计字段，不建议“订正一处自动同步”，除非你想做一个跨表的统一操作审计（但那会使逻辑更复杂）。
		- 建议：保持 **各表独立维护** ，用于追踪那张表最后一次修改。
- 总体原则：
	- **业务概念层的唯一来源** ：
		- 标签存在/分类/负责人/状态 → `tag_catalog`
		- 标签规格/兜底值/生效区间 → `tag_spec`
		- 具体枚举值/匹配词 → `tag_enum`
	- 其他表只做“引用 + 校验 + 衍生”，不自己发明定义。

---

#### 三、兜底值的统一读取与自动同步方案

1. 统一读取：只信 `tag_spec.fallback`
- 建议定义一个视图： `v_tag_default_value` （示意）
- 下游规则：
	- 所有“我要拿兜底值”的地方（商户画像初始化、缺失填充、前端默认选项），统一走这个视图，不再直接读 `tag_enum.is_default` 。
	- 对非 enum 标签， `enum_code/enum_label` 为 NULL，直接用 `default_raw_value` 。
1. 自动同步 `tag_enum.is_default` 到 spec 定义
- 为了兼容已有逻辑，你可以保留 `is_default` ，但把它改成一个“由 spec 驱动的结果”，例如定期执行这样的 SQL：
- 使用方式：
	- 每次你批量订正 `tag_spec.fallback` 后，执行一次上述更新。
	- 或者做成调度任务（例如每天凌晨），自动纠偏。
- 注意：
	- 若你希望更稳妥，可以先写一个 SELECT 检查视图，列出“fallback 与 is\_default 不一致”的情况，再决定是否自动更新。
1. 兜底值修改流程建议
- 未来的操作规范可以写成：
	1. 修改兜底值：
		- 只修改 `tag_spec.fallback` （和需要时的 `effective_from / effective_to` ），不直接动 `tag_enum.is_default` 。
	2. 执行一致性校验：
		- 检查所有 enum 型标签， `fallback` 是否出现在对应枚举的 `enum_code` 列表中；
		- 不在则报错/告警（这一步可以写一个单独 SQL）。
	3. 执行同步脚本：
		- 通过 `UPDATE tag_enum JOIN tag_spec ...` 把 `is_default` 对齐。
	4. 下游只读：
		- 所有新代码、报表、服务，一律从 `v_tag_default_value` （或类似视图）拿兜底值，不再读物理表。

---

### 4）迭代日志

- **来源**
	- 基于你前一轮对三张字典表职责的阐述，以及本轮新增需求：“统一订正 code 对应兜底值，并梳理三表重复字段，做到订正一处自动变”。
- **本轮关键结论**
	1. 兜底值只在两个地方有体现： `tag_spec.fallback` （规格层定义）和 `tag_enum.is_default` （枚举层默认标记）； `tag_catalog` 不涉及兜底值。
	2. 从职责分工看，兜底值应当 **唯一归属 `tag_spec.fallback`** ， `tag_enum.is_default` 必须视为衍生字段，而不是一个独立的定义来源。
	3. 三表重复字段只有： `tag_code` 、 `spec_version` （在 spec/enum）、 `created_at/updated_at/updated_by` ，其中前两者需要明确“谁是主表”（catalog/spec），后面三个是各表独立审计信息，不建议强行同步。
- **本轮新增设计点**
	1. 提出 `v_tag_default_value` 视图，用来统一提供“兜底值 + 对应枚举展示”的标准读取口径。
	2. 给出一条通用同步 SQL，把 `tag_enum.is_default` 从 `tag_spec.fallback` 自动对齐，满足“订正一处自动变”的需求。
	3. 定义兜底值修改的标准流程（只改 spec → 校验 → 同步 → 下游统一读视图）。
- **待补充/下一步可做**
	1. 你这边现有“兜底值不一致”的真实案例（比如 fallback 和 is\_default 打不齐的情况），用几条数据验证上述同步逻辑是否符合预期。
	2. 核实是否存在“一个标签多版本并行”的业务诉求（比如 A/B 试验），如果有，需要在视图中额外引入 `effective_from/to` 和 `as_of_date` 维度。
	3. 看看当前哪些下游任务直接读了 `tag_enum.is_default` ，我们可以一起列一张“改造影响清单”，方便你安排灰度切换。

如果你愿意，下一步我可以直接帮你写：

- “查出所有 fallback 与 is\_default 不一致的标签/枚举”的 SQL；
- 和“一次性订正这些不一致”的完整 SQL 脚本（含校验 SELECT + UPDATE）。

很好,现在我需要给写几个查询,帮我规范管理管理这个 3 个表;1.建视图 2.先建议把兜底值 在 2 个表中做拉齐;需要有个检测不一致,或者空缺的查询;在 catalog 表中写入,全部兜底用未知来兜底,英文 unknown;定义为 1.0.1 版本; 并且在 enum 表中拉齐这个;\[tag\_code spec\_version definition value\_type fallback effective\_from effective\_to approved\_by approved\_at calc\_type validation\_regex ttl\_days w\_source\_s1 w\_source\_s2 w\_source\_s3 w\_source\_s4 decay\_mode delta\_min value\_type\_connect created\_at updated\_at updated\_by brand\_level 1.0.0 品牌等级：KA/CKA/小散（小散为默认回退） enum SMALL 2025-09-04 业务-已批 2025-09-04 05:50:55 compute 7 1.00 0.60 0.50 0.40 linear 0.00 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import brand\_name 1.0.0 对外展示主品牌（按品牌ID受控集），未知回退 other enum other 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.80 0.90 0.60 linear 0.10 target\_value\_string 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import competitive\_overlap 1.0.0 是否与竞对/同品类门店形成地理与业务重叠 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 90 0.70 0.90 0.80 0.60 exp 0.15 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import convenience\_store\_available 1.0.0 是否设有便利店 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import is\_ka\_direct 1.0.0 是否KA直营 bool 99 2025-12-04 业务-已批 2025-12-04 00:00:00 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import open\_24h 1.0.0 是否24小时营业 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import open\_hours 1.0.0 营业时间段（规范：HHMM-HHMM 或多段协议） string unknown 2025-09-04 业务-已批 2025-09-04 05:50:55 result ^(\[0-2\]\\d{3}-\[0-2\]\\d{3})(,(\[0-2\]\\d{3}-\[0-2\]\\d{3}))\*$ 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_string 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import parking\_available 1.0.0 是否提供停车位 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import restroom\_available 1.0.0 是否提供卫生间 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import service\_carwash\_available 1.0.0 是否提供洗车服务 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import service\_carwash\_type 1.0.0 洗车类型（machine/manual/none） enum none 2025-09-04 业务-已批 2025-09-04 05:50:55 result 180 0.70 0.90 0.80 0.60 linear 0.10 target\_value\_string 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import sme\_supplier 1.0.0 合作中小供给名称（受控ID） enum unknown 2025-09-04 业务-已批 2025-09-04 05:50:55 result 90 0.70 0.90 0.80 0.60 exp 0.15 target\_value\_string 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import sme\_supplier\_partner 1.0.0 是否合作中小供给（伙伴关系是否存在） bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 result 90 0.70 0.90 0.80 0.60 exp 0.15 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import store\_life 1.0.0 油站生命周期 string unknown 2025-12-04 业务-已批 2025-12-04 00:00:00 compute 180 1.00 0.60 0.50 0.40 exp 0.00 target\_value\_string 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import wyc\_pricing\_enabled 1.0.0 是否开通网顺单独定价 bool 99 2025-09-04 业务-已批 2025-09-04 05:50:55 compute 7 1.00 0.60 0.50 0.40 exp 0.00 target\_value\_bool 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import\];这个变更如何和3 表拉齐,我需要有明确的兜底值,是未知;如果已经是未知兜底就不用改了;

20251207\_1205\_标签兜底值治理\_SQL方案\_v1

tags: #tag\_spec #tag\_enum #fallback兜底值 #SQL视图 #一致性校验

---

### 1）一句话结论

在不改表结构的前提下，可以通过「3 个视图 + 3 类检查查询 + 一组 INSERT/UPDATE 模板」来规范兜底值，做到：所有兜底值以 `tag_spec.fallback` 为唯一来源、在 `tag_enum` 中自动拉齐、并通过视图挂到 `tag_catalog` 上统一查看（含你要的 `unknown / 1.0.1` 版本）。

---

### 2）三段论据

**论据一：现状与问题——兜底值定义分散在 spec / enum，catalog 不可直接写**

- 真兜底值定义在 `tag_spec.fallback` ；
- `tag_enum.is_default` 是“枚举层默认项”，但现在有可能和 `fallback` 不一致；
- `tag_catalog` 没有兜底字段，无法“物理写入兜底值”，只能通过 JOIN/视图挂载。  
	如果直接手改两张表，很容易出现“已经在 spec 改为 unknown，但 enum 还保留 old 默认”的不一致。

**论据二：关键洞察——兜底推荐只统一 enum/string，bool 仍保留数值编码**

- 你给的样例里：
	- enum/string： `fallback` 是 `"SMALL" / "other" / "none" / "unknown"` 等字符串；
	- bool： `fallback` 是 `"99"` ，而 `value_type_connect = target_value_bool` ，很明显是用 99 表示“未知/未定义”。
- 如果强行把 bool 的 `fallback` 改成 `'unknown'` ，将会和下游 bool 字段类型冲突。  
	所以本轮设计默认策略：
	- **enum / string 型标签** ：统一兜底值→ `'unknown'` ，版本号升级为 `'1.0.1'` ；
	- **bool 型标签** ：继续使用 `99` 作为“未知”，不做本轮统一，后续如要改再单独方案。

**论据三：路径方案——视图统一视图+检查+批量 DML，收口在 3 个表**

- 视图层：
	- 给 `tag_spec` 做“最新版本视图”；
	- 给 `catalog + spec` 做“带兜底的目录视图”；
	- 给 `spec + enum` 做“兜底校验视图”。
- 检查层：
	- 查缺失兜底的标签；
	- 查 `fallback` 不在枚举中的标签；
	- 查 `fallback` 与 `is_default` 不一致的标签。
- DML 层：
	- 在 `tag_spec` 中基于 `1.0.0` 批量生成 `1.0.1` 版本，将 enum/string 型的 `fallback` 改为 `'unknown'` ；
	- 在 `tag_enum` 中批量补齐 `'unknown'` 枚举并拉齐 `is_default` ；
	- `tag_catalog` 通过视图挂载 `spec_version` 和 `fallback` ，实现“catalog 里能看到 1.0.1 + unknown”。

下面直接给你可以用的 SQL 模板（按模块分好）。

---

### 3）核心内容模块（SQL 结构化输出）

#### 3.1 视图设计：三张基础视图

> 说明：你可以按需调整视图名；以下使用 `CREATE OR REPLACE VIEW` ，MySQL 8.0 支持。

**视图 1：每个标签当前“最新规格版本”视图（按 effective\_from + spec\_version）**

**视图 2：带兜底值的标签目录视图（catalog + 最新 spec）**

> 用这个视图，等价于“在 catalog 中写入兜底值和版本号”，不用改物理表结构。

**视图 3：规格与枚举的兜底一致性检查视图**

---

#### 3.2 检测不一致 / 空缺的查询

**1）查 enum 型标签中，fallback 为空或不在枚举列表中的情况**

**2）查 enum 型标签中，fallback 与 is\_default 不一致的情况**

**3）查“你希望升级为 unknown 的标签”（enum/string 且 fallback!= 'unknown'）**

> 这些就是你准备生成 `1.0.1` 并统一兜底为 unknown 的候选集合。

---

#### 3.3 拉齐方案：生成 1.0.1 版本 & enum 表对齐

> 这里是“模板 SQL”。强烈建议你先用 SELECT 把 WHERE 命中的行打印出来，确认没问题再执行 INSERT/UPDATE。

##### 步骤 1：基于 1.0.0 生成 1.0.1，统一 enum/string 的 fallback → 'unknown'

假设你当前都在用 `spec_version = '1.0.0'` ，且想创建 `'1.0.1'` 版本；  
只对 `value_type IN ('enum','string')` 且 `fallback <> 'unknown'` 的标签升级兜底。

> 这样，像你贴的这些：
> 
> - `brand_level` （原 fallback=SMALL）
> - `brand_name` （原 fallback=other）
> - `service_carwash_type` （原 fallback=none）
> - `sme_supplier` （原 fallback=unknown，已是 unknown 不会被插入新版本）  
> 	都会有一条 1.0.1 版本，统一 fallback='unknown'，而且旧版本完全保留。

##### 步骤 2：在 tag\_enum 中补齐/对齐 'unknown' 枚举值，并设为默认

1）先为所有“新版本 1.0.1 + fallback='unknown' 的 enum 型标签”，补齐枚举行（如果缺）

```sql
sqlINSERT INTO tag_enum (
    tag_code,
    spec_version,
    enum_code,
    enum_label,
    sort_order,
    is_default,
    brand_aliases,
    exclusion_field,
    brand_category,
    keywords,
    is_active,
    match_method,
    match_score_threshold,
    white_list,
    black_list,
    created_at,
    updated_at,
    updated_by
)
SELECT
    s.tag_code,
    s.spec_version,
    'unknown' AS enum_code,
    '未知'    AS enum_label,           -- 可按需改成你习惯的中文
    0         AS sort_order,           -- 默认给个 0，后续你再调顺序
    1         AS is_default,
    NULL      AS brand_aliases,
    NULL      AS exclusion_field,
    NULL      AS brand_category,
    NULL      AS keywords,
    1         AS is_active,
    0         AS match_method,
    0.00      AS match_score_threshold,
    0         AS white_list,
    0         AS black_list,
    NOW()     AS created_at,
    NOW()     AS updated_at,
    'fallback_batch_unknown_1_0_1' AS updated_by
FROM tag_spec s
LEFT JOIN tag_enum e
  ON s.tag_code     = e.tag_code
 AND s.spec_version = e.spec_version
 AND e.enum_code    = 'unknown'
WHERE s.spec_version = '1.0.1'
  AND s.value_type  = 'enum'
  AND s.fallback    = 'unknown'
  AND e.enum_code IS NULL;      -- 只插缺的
```

2）再全局拉齐 `is_default` ：只允许 fallback 那个 enum\_code 为默认

> 这一步是你之前说的“订正一处、其他自动变”的关键。

> 结果：
> 
> - 对于 1.0.1 版本的 enum 型标签， `enum_code = 'unknown'` 会被置为 `is_default=1` ；
> - 其他枚举统一 `is_default=0` ；
> - 任何未来修改 fallback，只要再执行这条 UPDATE，就能重新拉齐。

##### 步骤 3：bool 型（如 competitive\_overlap 等）暂不改

- 这些行目前是：
- 鉴于下游字段很可能是 TINYINT/INT， `99` 已经是“布尔维度的未知”编码，本轮就不强行改成 `'unknown'` 。
- 如后续你希望变成 3 态（0/1/2=unknown）或改别的编码，可以单独再设计一轮。

---

#### 3.4 和 catalog 的拉齐方式说明

- 物理上： `tag_catalog` 没有 `spec_version` 和 `fallback` 字段，无法真正“写入”；
- 逻辑上：我们通过 `v_tag_catalog_with_fallback` 已经实现了“在 catalog 层可以看到当前最新版本和兜底值”的效果。
	- 当你完成上述 1.0.1 插入后，这个视图会自动显示：
		- `spec_version` = '1.0.1'
		- `fallback` = 'unknown'
- 如果你强烈希望“给运营/老板看到的就是 catalog 表里存着兜底值和版本号”，最推荐做法是：
	- 直接用 `v_tag_catalog_with_fallback` 做报表 / 看板数据源；
	- 不建议为了这点信息去改动物理表结构。

---

### 4）迭代日志

- **来源**
	- 你刚才提供的三张表结构 + 一组 `tag_spec` 初始数据样例（brand\_level / brand\_name / competitive\_overlap / open\_hours 等）。
	- 你的明确诉求：  
		1）建视图统一管理三表；  
		2）检测/拉齐兜底值；  
		3）用 `'unknown'` 作为统一兜底；  
		4）定义为 `1.0.1` 版本，并在 enum 中同步。
- **本轮关键改动点**
	1. 确定统一策略：enum/string 型统一兜底 `'unknown'` ，bool 型继续用 `99` 表示未知。
	2. 设计了 3 个视图：最新 spec、catalog+spec 目录视图、spec+enum 兜底校验视图。
	3. 提供了一组完整的 DML 模板：
		- 从 1.0.0 批量生成 1.0.1；
		- 在 enum 表中补齐 `'unknown'` 枚举；
		- UPDATE 一次拉齐 `is_default` 和 `fallback` 。
- **待补充/下一步建议**
	1. 先只对一小批标签（例如你贴出来的这一批）执行 INSERT/UPDATE，在测试库验证：
		- v\_tag\_catalog\_with\_fallback 里显示是否符合预期；
		- v\_tag\_fallback\_check 是否不再报错。
	2. 再决定是否把 WHERE 条件放宽到“所有 value\_type in ('enum','string') 的标签”。
	3. 如果你愿意，下一轮可以一起把“检测不一致 + 一键修复”的 SQL 做成一套 check + fix 脚本（例如 `check_fallback_inconsistency.sql` + `fix_fallback_from_spec.sql` ），方便你以后直接用 Navicat / 命令行执行。

你这边可以先贴一下：

- 当前 `tag_enum` 针对 `brand_level / brand_name / service_carwash_type / sme_supplier / store_life` 的枚举列表，我可以帮你顺着这个模板再演一次“真实数据级”的演练，确保不会踩坑。

20251207\_1305\_enum兜底标记拉齐方案\_v1

tags: #tag\_enum #tag\_spec #fallback兜底值 #bool标签 #版本策略

---

### 1）一句话结论

像 `is_ka_direct` 这种记录， **确实应该把 enum 里 `enum_code = fallback` 的那一行标记为 `is_default = 1`** ，但这属于“元数据修正”，不需要新开规格版本，直接用一条 UPDATE 按 `tag_code + spec_version` 批量拉齐即可。

---

### 2）三段论据

#### 论据一：你举的例子实际代表了一类“典型错位”

这条记录：

说明两件事：

1. 规格层：你已经把“未知/兜底”定义为 `99` （在 `tag_spec.fallback` ）；
2. 枚举层： `tag_enum` 虽然有 `enum_code = 99` ，但 `is_default` 还是 0，下游如果只看 `is_default` 拿默认值，就会拿不到真正的兜底。

所以答案是： **是的，这类记录应该在 enum 表里，把 `enum_code = 99` 那一行改成 `is_default = 1` ，并把其他枚举的 `is_default` 清零** 。

---

#### 论据二：这是“元数据对齐”，不涉及规格变化，不必新开版本

你问的两个维度：

1. **要不要按版本迭代？**
	- 只有在你“修改兜底值本身”（比如从 `99` 改成 `'unknown'` ）或“改计算逻辑”时，才需要在 `tag_spec` 新开一版 `spec_version` （1.0.0 → 1.0.1）。
	- 像现在这种情况， `fallback` 本身没变，仍然是 `99` ，只是 `tag_enum.is_default` 没跟上，这属于“把枚举层标记对齐规格定义”，从治理角度看算 **修正/对齐** ，不需要新版本。
2. **在 enum 表中如何保持与 spec 一致？**
	- 原则就是我们前面说的： **“兜底定义只在 spec，enum 只做映射”** 。
	- 具体做法是：
		- 永远只在 `tag_spec.fallback` 修改兜底；
		- 定期用一条 UPDATE 把 `tag_enum.is_default` 自动拉齐成：“谁的 `enum_code = fallback` ，谁就是默认”。

因此，你现在要做的，不是再造一版 `1.0.1` ，而是对当前版本（包括 bool）跑一次“对齐脚本”。

---

#### 论据三：一条统一 UPDATE 覆盖 enum + bool，做到“订正一处，全都跟着变”

回答你最关键的问题：

> 在 enum 表中，如何保持和 spec 表一致的兜底值标记？

推荐做法：

1. **继续坚持“兜底值定义只在 `tag_spec.fallback` ”的规则（包括 bool）。**
2. **写一条统一的 UPDATE，把所有 `tag_enum.is_default` 对齐到 fallback。**
3. **如果后面某个标签的兜底值变了（你在 spec 上改），只要再次执行这条 UPDATE，就能同步到 enum。**

这一条 SQL 就解决你现在看到的所有 `fallback_in_enum=1, has_default_enum=0` 、 `fallback_is_default_enum=0` 的情况。

---

### 3）思维导图结构（文本分层）

#### 一、概念层回答

1. `is_ka_direct` 这类 bool 标签要不要在 enum 中标记兜底？
	- 要。
	- 统一逻辑： **只要 `fallback` 在 enum 里存在，就应该有一个 `enum_code = fallback` 的枚举被标记为 `is_default = 1`** ，类型 enum/bool 都一样。
2. 这种改动要不要开新版本？
	- 不必。
	- 因为你并没改“兜底是什么”，只是把枚举层的标记修正为与规格一致，这是对现有版本的“元数据修复”。
3. 如何确保以后不再手工一个个改？
	- 不在 `tag_enum` 手动维护 `is_default` 。
	- 用一条 UPDATE 定期跑（或者每次 spec 改动后跑一次），让 enum 永远从 spec 的 fallback 派生。

#### 二、具体 SQL 方案：bool + enum 一次性拉齐

> 下面这两段就是你要的“保持 enum 与 spec 一致的兜底值标记”的标准脚本。

**1）先查出当前“不一致”的 enum（验证一下修复对象）**

你刚举的 `is_ka_direct` 就会出现在这里。

**2）统一拉齐 is\_default（enum + bool 一起修）：推荐版本**

含义：

- 只要是 enum 或 bool 类型：
	- `enum_code = fallback` 的这条 → `is_default = 1` ；
	- 同一 `(tag_code, spec_version)` 下其他枚举 → `is_default = 0` ；
- 对 `is_ka_direct` 这类：
	- 如果 enum 有 `enum_code = 99` 那条，就会被打成 `is_default = 1` ，下游再看 is\_default，就能拿到正确兜底。

> 如果你担心覆盖面太大，也可以先加一个过滤条件，只修你关心的版本，例如：

**3）修完后的验证查询**

- 理想状态：结果集为空，说明所有 fallback 都有对应默认枚举，且一致。

#### 三、版本策略上的“小结建议”

1. **什么时候要开新版本（例如 1.0.1）？**
	- 修改 `fallback` 值本身（例：从 `SMALL` 改成 `'unknown'` ）；
	- 修改计算逻辑、TTL、权重、衰减模式等会影响“值如何生成”的内容。
2. **什么时候直接 UPDATE 当前版本即可？**
	- 像你现在问的这种：
		- fallback 不变，只是 `tag_enum.is_default` 没跟上 → 直接用 UPDATE 拉齐即可；
		- 这类操作可以看作“数据修复/治理”，不影响规格语义本身。
3. **如何保证以后永远不用纠结？**
	- 把上面那条 UPDATE 当成“兜底对齐标准脚本”：
		- 每次修改 `tag_spec.fallback` 后，跑一次；
		- 或者每天/每周定时跑一次；
	- 把 `v_tag_fallback_check` 当成“兜底体检表”，任何异常都能在这里发现。

---

### 4）迭代日志

- **来源**
	- 你提供的 `v_tag_fallback_check` 示例行： `is_ka_direct 1.0.0 bool 99 1 0 0` ；
	- 你的问题聚焦在：enum 表里如何把兜底值标记成默认、是否需要开新版本。
- **本轮关键结论**
	1. 对 enum 和 bool 标签， **只要 fallback 在 enum 中存在，就应该在 enum 中打上 `is_default=1`** ，保持“规格定义”和“枚举标记”的一致性。
	2. 这种调整仅是“元数据对齐”，不涉及规格语义变化，不需要创建新的 `spec_version` 。
	3. 推荐用一条通用 UPDATE（按 `tag_code + spec_version` JOIN）来拉齐 `is_default` ，并配合 `v_tag_fallback_check` 做验证和巡检。
- **后续可做**
	1. 如果你愿意，我们可以基于你真实的 `tag_enum` 数据，设计一份“兜底治理脚本包”：
		- `01_check_fallback_inconsistency.sql`
		- `02_fix_enum_default_from_spec.sql`
		- `03_report_fallback_summary.sql` （输出每个 tag 的 fallback 和 default 枚举）
	2. 长远看，可以把这条 UPDATE 融进“标签规格发布流程”或定时任务，让这件事变成系统自动保障，而不是人工记忆。

你这边如果方便，可以下一步把 `is_ka_direct` 对应的 `tag_enum` 几行贴出来，我可以按真实数据帮你演算一遍“修复前后”的结果，让你更有感觉。

20251207\_1330\_兜底值对比查询\_v1

tags: #fallback兜底值 #tag\_spec #tag\_enum #一致性检查 #元数据治理

---

### 1）一句话结论

可以用一条聚合查询，把每个 `(tag_code, spec_version)` 在 `tag_spec` 和 `tag_enum` 里的兜底情况一次性拉齐展示： **有没有兜底 / spec 兜底是什么 / enum 默认值是什么 / 是否一致 / 类型是什么** 。

---

### 2）三段论据

**论据一：你的关注点**

- 不是每个 code 都一定有兜底（ `tag_spec.fallback` 可能为空）；
- 即便有兜底， `tag_enum` 里不一定有 `is_default=1` ，或者默认值不等于 `fallback` ；
- 你希望 **一个查询** 就能看到：
	- spec 侧有没有兜底、兜底值是什么；
	- enum 侧有没有默认值、默认值是什么；
	- 两边关系是否一致；
	- 以及这个标签是什么类型（enum/bool/string）。

**论据二：关键信息来源**

- 兜底“定义”只在 `tag_spec` ： `value_type` + `fallback` （+ `value_type_connect` ）。
- 兜底“枚举标记”只在 `tag_enum` ： `is_default=1` 的 `enum_code` 。
- 只要把 `tag_spec` 左连 `tag_enum` ，并对枚举做一次聚合，就能同时看清两边状态。

**论据三：查询思路**

- 以 `tag_spec` 为主表（所有已定义规格都覆盖）；
- 按 `(tag_code, spec_version)` 分组，聚合枚举侧信息：
	- 聚出：是否有 default、有哪些 default code；
	- 判断：fallback 是否存在于枚举中，fallback 是否就是 default；
- 加上 `value_type` / `value_type_connect` ，方便你按类型过滤或分析。

---

### 3）核心 SQL：一次性对比 2 表兜底情况

> 直接复制即可执行；会返回每个 `(tag_code, spec_version)` 在 2 个表里的兜底差异。

```sql
sqlSELECT
    s.tag_code,
    s.spec_version,
    s.value_type,              -- 标签值类型：enum/bool/string
    s.value_type_connect,      -- 落地到事实表的字段类型
    s.fallback        AS spec_fallback,          -- 在 tag_spec 中定义的兜底值
    CASE
        WHEN s.fallback IS NULL OR s.fallback = '' THEN 0
        ELSE 1
    END AS has_spec_fallback,                    -- spec 是否有兜底

    -- enum 侧：所有被标记为默认的枚举值（通常应为 0 或 1 条记录）
    GROUP_CONCAT(
        DISTINCT CASE WHEN e.is_default = 1 THEN e.enum_code END
        ORDER BY e.enum_code
    ) AS enum_default_codes,                     -- 在 tag_enum 中标记为默认的枚举 code 列表
    MAX(CASE WHEN e.is_default = 1 THEN 1 ELSE 0 END) AS has_enum_default, -- enum 是否有默认值

    -- 关系判断：fallback 与 enum 的关系
    MAX(CASE
            WHEN e.enum_code = s.fallback THEN 1
            ELSE 0
        END) AS fallback_in_enum,                -- fallback 是否存在于枚举表中
    MAX(CASE
            WHEN e.is_default = 1 AND e.enum_code = s.fallback THEN 1
            ELSE 0
        END) AS enum_default_matches_fallback    -- enum 默认值是否等于 fallback
FROM tag_spec s
LEFT JOIN tag_enum e
  ON s.tag_code     = e.tag_code
 AND s.spec_version = e.spec_version
GROUP BY
    s.tag_code,
    s.spec_version,
    s.value_type,
    s.value_type_connect,
    s.fallback
ORDER BY
    s.tag_code,
    s.spec_version;
```

**字段解释：**

- `spec_fallback` / `has_spec_fallback`
	- 看 spec 侧有没有兜底、兜底值是什么。
- `enum_default_codes` / `has_enum_default`
	- 看 enum 侧有没有默认值、默认枚举是哪些（通常应该只会有 1 个）。
- `fallback_in_enum`
	- `1` ： `fallback` 在 `tag_enum.enum_code` 中存在；
	- `0` ： `fallback` 根本不在枚举列表里。
- `enum_default_matches_fallback`
	- `1` ：默认枚举正好就是 `fallback` ；
	- `0` ：要么没有默认，要么默认值!= `fallback` 。
- `value_type` / `value_type_connect`
	- 方便你区分 enum/bool/string，以及它落到事实表是哪个字段（bool/number/string）。

---

### 4）如何快速定位“有问题的兜底”

如果你想 **只看有问题的那一部分** （比如：没兜底、或者 enum 默认没对齐），可以在外面再套一层：

```sql
sqlSELECT *
FROM (
    SELECT
        s.tag_code,
        s.spec_version,
        s.value_type,
        s.value_type_connect,
        s.fallback        AS spec_fallback,
        CASE
            WHEN s.fallback IS NULL OR s.fallback = '' THEN 0
            ELSE 1
        END AS has_spec_fallback,
        GROUP_CONCAT(
            DISTINCT CASE WHEN e.is_default = 1 THEN e.enum_code END
            ORDER BY e.enum_code
        ) AS enum_default_codes,
        MAX(CASE WHEN e.is_default = 1 THEN 1 ELSE 0 END) AS has_enum_default,
        MAX(CASE
                WHEN e.enum_code = s.fallback THEN 1
                ELSE 0
            END) AS fallback_in_enum,
        MAX(CASE
                WHEN e.is_default = 1 AND e.enum_code = s.fallback THEN 1
                ELSE 0
            END) AS enum_default_matches_fallback
    FROM tag_spec s
    LEFT JOIN tag_enum e
      ON s.tag_code     = e.tag_code
     AND s.spec_version = e.spec_version
    GROUP BY
        s.tag_code,
        s.spec_version,
        s.value_type,
        s.value_type_connect,
        s.fallback
) t
WHERE
    -- 任选组合条件，这里示例“任何一处有问题”的情况
    has_spec_fallback = 0                        -- spec 没有兜底
    OR (value_type IN ('enum', 'bool')
        AND (
            fallback_in_enum = 0                 -- fallback 不在枚举中
            OR has_enum_default = 0              -- 枚举没默认值
            OR enum_default_matches_fallback = 0 -- 默认值不是 fallback
        )
    )
ORDER BY
    tag_code,
    spec_version;
```

你可以先跑第一条“全量对照表”，整体扫一眼；  
觉得 OK 后，再用第二条“只看异常”的做日常巡检。

---

### 5）迭代日志

- **你新提的关注点**
	- 有些 `tag_code` 可能根本没有指定兜底；
	- 你希望一眼看到：
		- spec 有没有 fallback；
		- enum 有没有 default；
		- 两者是否对齐；
		- 对应的类型。
- **本轮给出的东西**
	- 一条聚合查询，把 `tag_spec` 和 `tag_enum` 的兜底信息合并输出；
	- 再给了一个“异常过滤版本”，让你只看不一致/缺失的情况。
- **下一步建议**
	- 跑一遍全量结果导出到 Excel，看哪些标签确实“不想设兜底、但 enum 里有人标了默认”的，和运营对一下预期；
	- 跑一遍异常过滤结果，配合你之前的拉齐 UPDATE，一次性修完现在所有不一致；
	- 如果你觉得这张“兜底对照表”很好用，可以考虑把这条查询固化成一个视图，比如 `v_tag_fallback_overview` ，方便随时查。

\[tag\_code spec\_version value\_type value\_type\_connect spec\_fallback has\_spec\_fallback enum\_default\_codes has\_enum\_default fallback\_in\_enum enum\_default\_matches\_fallback brand\_level 1.0.0 enum target\_value\_bool SMALL 1 SMALL 1 1 1 brand\_level 1.0.1 enum target\_value\_bool unknown 1 unknown 1 1 1 brand\_name 1.0.0 enum target\_value\_string other 1 other 1 1 1 brand\_name 1.0.1 enum target\_value\_string unknown 1 unknown 1 1 1 competitive\_overlap 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 convenience\_store\_available 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 is\_ka\_direct 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 open\_24h 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 open\_hours 1.0.0 string target\_value\_string unknown 1 0 0 0 parking\_available 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 restroom\_available 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 service\_carwash\_available 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 service\_carwash\_type 1.0.0 enum target\_value\_string none 1 none 1 1 1 service\_carwash\_type 1.0.1 enum target\_value\_string unknown 1 unknown 1 1 1 sme\_supplier 1.0.0 enum target\_value\_string unknown 1 0 0 0 sme\_supplier\_partner 1.0.0 bool target\_value\_bool 99 1 99 1 1 1 store\_life 1.0.0 string target\_value\_string unknown 1 0 0 0 wyc\_pricing\_enabled 1.0.0 bool target\_value\_bool 99 1 0 0 0\]你帮我分析一下,是不是有问题?以及怎么修

20251207\_1405\_兜底对比结果诊断\_v1

tags: #fallback兜底值 #tag\_spec #tag\_enum #枚举一致性 #数据治理

---

### 1）一句话结论

从你贴出来的对照结果看，整体兜底体系是健康的，当前真正有问题的只有两类：

- `sme_supplier` （enum 型）：spec 有兜底 `unknown` ，enum 里完全没有对应枚举；
- `wyc_pricing_enabled` （bool 型）：spec 兜底 `99` ，enum 里也没有任何默认枚举。  
	其他行基本都已经对齐，不需要再动。

---

### 2）三段论据

#### 论据一：逐行解读——哪些是“正常的”，哪些值得警惕

你给的结果（简化标注一下）：

```markdown
texttag_code                  value_type  spec_fallback  enum_default_codes  备注
---------------------------------------------------------------------------
brand_level    1.0.0/1.0.1 enum      SMALL/unknown  SMALL/unknown       ✅ 已对齐
brand_name     1.0.0/1.0.1 enum      other/unknown  other/unknown       ✅ 已对齐
competitive_overlap       bool       99             99                  ✅ 已对齐
convenience_store_available bool     99             99                  ✅ 已对齐
is_ka_direct              bool       99             99                  ✅ 已对齐
open_24h                  bool       99             99                  ✅ 已对齐
parking_available         bool       99             99                  ✅ 已对齐
restroom_available        bool       99             99                  ✅ 已对齐
service_carwash_available bool       99             99                  ✅ 已对齐
sme_supplier_partner      bool       99             99                  ✅ 已对齐

open_hours                string     unknown        (空)                ⚠️ 但 string，本来就不用 enum
store_life                string     unknown        (空)                ⚠️ 同上

service_carwash_type 1.0.0/1.0.1 enum  none/unknown none/unknown       ✅ 已对齐

sme_supplier              enum       unknown        (空)                ❌ enum 型，却没有任何默认枚举
wyc_pricing_enabled       bool       99             (空)                ❌ bool 型，却没有任何默认枚举
```

结合类型解读一下：

1. **enum 型标签（brand\_level / brand\_name / service\_carwash\_type / sme\_supplier）**
	- 前三组： `spec_fallback` 与 `enum_default_codes` 一一对应， `fallback_in_enum=1` 且 `enum_default_matches_fallback=1` ，这是理想状态；
	- `sme_supplier` ：
		- `value_type = enum` ， `spec_fallback = 'unknown'` ；
		- 但 `enum_default_codes` 为空， `has_enum_default = 0` ， `fallback_in_enum = 0` ：
			- 说明 enum 表里既没有默认值，也没有 `enum_code = 'unknown'` 这条。  
				→ 这是明显缺口： **enum 型一定要有一条与 fallback 对应的枚举行，并设为默认** 。
2. **bool 型标签（competitive\_overlap 等 + wyc\_pricing\_enabled）**
	- 除了 `wyc_pricing_enabled` 外，其他 bool 标签都是：
		- `spec_fallback = 99` ；
		- `enum_default_codes = 99` ；
		- `fallback_in_enum = 1` 且 `enum_default_matches_fallback = 1` 。
	- `wyc_pricing_enabled` ：
		- `spec_fallback = 99` ，但 `enum_default_codes` 为空， `fallback_in_enum = 0` ：
			- 说明 enum 表里根本没有 `enum_code = 99` 这条记录，也没任何 is\_default=1。  
				→ 对 bool，我们之前定的规范是“只要 fallback 在 enum 存在，就要有 default 标记”，而你其它 bool 标签都按照这个规范做了， **这一条明显落单，应当补齐** 。
3. **string 型标签（open\_hours / store\_life）**
	- 这两条：
		- `value_type = string` ， `spec_fallback = 'unknown'` ；
		- `enum_default_codes` 为空， `fallback_in_enum = 0` 。
	- 按我们之前的设计，string 型标签本来就不依赖 `tag_enum` ，只需要在 spec 有一个清晰的 fallback 就够了。  
		→ 所以这两个“看起来有 0/空”，其实是 **预期内的正常状态，不需要修** 。

总结：

- ✅ 已对齐：所有 enum/bool 中 fallback 已有对应 default 枚举的标签；string 型不用管。
- ❌ 真问题：
	- `sme_supplier` （enum）：应有 `'unknown'` 枚举行并设为 default；
	- `wyc_pricing_enabled` （bool）：至少要有一条 `enum_code = 99` 的枚举行，并设为 default。

---

#### 论据二：修复原则——坚持“spec 定义，enum 映射”的单一来源

结合前面约定，这里再强调一次修复原则，避免之后越修越乱：

1. **兜底“定义”的唯一来源仍然是 `tag_spec.fallback`**
	- 对 enum：fallback = 某个枚举 code；
	- 对 bool：fallback = 某个编码（当前是 99，代表“未知”）；
	- 对 string：fallback = `'unknown'` 或其它字符串。
2. **enum 只做“把 fallback 投影到枚举层”的映射**
	- 若 `value_type = 'enum'` ，则必须在 `tag_enum` 中有一条 `enum_code = fallback` 的记录，并设 `is_default = 1` ；
	- 若 `value_type = 'bool'` ，你当前实践是“所有 bool 也用 enum 表做 0/1/99 枚举”，那么同样：
		- 至少要确保 `enum_code = fallback` 的这条存在且 `is_default=1` 。
3. **string 型不强制要求出现在 enum 表**
	- 所以 open\_hours / store\_life 这两条的“无 enum”状态是 OK 的，不视为异常。

这样一来，你只需要对“enum/bool 且 fallback 在 enum 表不存在 or 默认没对齐”的场景做修复即可。

---

#### 论据三：修复路径——局部手修 vs 通用 SQL 两条路

你现在的列表不多，完全可以直接对 `sme_supplier` 和 `wyc_pricing_enabled` 手工 INSERT 一两条枚举；但从可维护性考虑，建议按“ **通用 SQL 脚本** ”来做：

1. **一条 INSERT，给所有 enum 型标签补齐 fallback 对应的枚举**
	- 专门覆盖类似 `sme_supplier` 这种： `value_type='enum'` 且 `fallback_in_enum=0` 。
2. **一条 INSERT，给所有 bool 型标签补齐 fallback 对应的枚举**
	- 专门覆盖类似 `wyc_pricing_enabled` 这种： `value_type='bool'` 且 `fallback_in_enum=0` 。
3. **最后再跑一次通用 UPDATE，把 is\_default 统一拉齐**
	- 保证以后你只改 spec.fallback，enum 默认标记都能跟上。

下面给你直接可用的 SQL 模板。

---

### 3）思维导图结构（文本分层）

#### 一、问题聚类

1. 正常 & 已对齐
	- enum： `brand_level`, `brand_name`, `service_carwash_type` （1.0.0/1.0.1）
	- bool： `competitive_overlap`, `convenience_store_available`, `is_ka_direct`, `open_24h`, `parking_available`, `restroom_available`, `service_carwash_available`, `sme_supplier_partner`
2. 设计上合理但查询看着“异常”的
	- string： `open_hours`, `store_life`
	- 原因：string 类型本就不依赖 enum 表， `fallback_in_enum=0` 是正常信号。
3. 需要修复的
	- enum： `sme_supplier` （缺少 `'unknown'` 枚举，且无默认）
	- bool： `wyc_pricing_enabled` （缺少 `99` 枚举，且无默认）

---

#### 二、通用修复 SQL 模板

> 如果你已经有前面那个 `v_tag_fallback_check` 视图，可以先用它定位问题，再执行以下 INSERT。  
> 下面的 SQL 不限定具体 tag\_code，会自动覆盖所有类似 `sme_supplier` / `wyc_pricing_enabled` 这种问题。

**1）给 enum 型标签补齐 fallback 对应的枚举（例如 sme\_supplier）**

```sql
sql-- 为所有 enum 型标签，补一条 "enum_code = fallback" 的枚举（若不存在）
INSERT INTO tag_enum (
    tag_code,
    spec_version,
    enum_code,
    enum_label,
    sort_order,
    is_default,
    brand_aliases,
    exclusion_field,
    brand_category,
    keywords,
    is_active,
    match_method,
    match_score_threshold,
    white_list,
    black_list,
    created_at,
    updated_at,
    updated_by
)
SELECT
    s.tag_code,
    s.spec_version,
    s.fallback          AS enum_code,
    '未知'              AS enum_label,          -- 统一中文展示，可按需调整
    0                   AS sort_order,
    1                   AS is_default,          -- 直接作为默认
    NULL                AS brand_aliases,
    NULL                AS exclusion_field,
    NULL                AS brand_category,
    NULL                AS keywords,
    1                   AS is_active,
    0                   AS match_method,
    0.00                AS match_score_threshold,
    0                   AS white_list,
    0                   AS black_list,
    NOW()               AS created_at,
    NOW()               AS updated_at,
    'fallback_enum_patch' AS updated_by
FROM tag_spec s
LEFT JOIN tag_enum e
  ON s.tag_code     = e.tag_code
 AND s.spec_version = e.spec_version
 AND e.enum_code    = s.fallback
WHERE s.value_type = 'enum'
  AND s.fallback IS NOT NULL
  AND s.fallback <> ''
  AND e.enum_code IS NULL;     -- 只补 "fallback 不在 enum 中" 的
```

这条会自动覆盖 `sme_supplier` 这类问题。

---

**2）给 bool 型标签补齐 fallback 对应的枚举（例如 wyc\_pricing\_enabled）**

```sql
sql-- 为所有 bool 型标签，补一条 "enum_code = fallback" 的枚举（若不存在）
INSERT INTO tag_enum (
    tag_code,
    spec_version,
    enum_code,
    enum_label,
    sort_order,
    is_default,
    brand_aliases,
    exclusion_field,
    brand_category,
    keywords,
    is_active,
    match_method,
    match_score_threshold,
    white_list,
    black_list,
    created_at,
    updated_at,
    updated_by
)
SELECT
    s.tag_code,
    s.spec_version,
    s.fallback          AS enum_code,
    '未知状态'          AS enum_label,          -- 区分于普通枚举，可按需改
    0                   AS sort_order,
    1                   AS is_default,          -- 直接作为默认
    NULL                AS brand_aliases,
    NULL                AS exclusion_field,
    NULL                AS brand_category,
    NULL                AS keywords,
    1                   AS is_active,
    0                   AS match_method,
    0.00                AS match_score_threshold,
    0                   AS white_list,
    0                   AS black_list,
    NOW()               AS created_at,
    NOW()               AS updated_at,
    'fallback_bool_patch' AS updated_by
FROM tag_spec s
LEFT JOIN tag_enum e
  ON s.tag_code     = e.tag_code
 AND s.spec_version = e.spec_version
 AND e.enum_code    = s.fallback
WHERE s.value_type = 'bool'
  AND s.fallback IS NOT NULL
  AND s.fallback <> ''
  AND e.enum_code IS NULL;     -- 只补 "fallback 不在 enum 中" 的
```

这条会自动覆盖 `wyc_pricing_enabled` 这类问题。

---

**3）最后再全局拉齐 is\_default（防止将来再出现错位）**

跑完之后，你再执行刚才那条对比查询， `sme_supplier` / `wyc_pricing_enabled` 这两行应该会变成：

---

### 4）迭代日志

- **本轮输入**
	- 你贴了一小段汇总数据（spec vs enum 的兜底对比），希望判断有没有问题，以及应该如何修。
- **本轮判断结果**
	1. 大部分标签（enum/bool）已经完全对齐，无需再动；
	2. string 型标签 `open_hours` / `store_life` 外观“无 enum”，但从设计上是正常的（不依赖 enum）；
	3. 真正需要修复的是：
		- `sme_supplier` ：enum 型却没有 fallback 对应枚举；
		- `wyc_pricing_enabled` ：bool 型却没有 fallback 对应枚举。
- **本轮输出内容**
	- 从业务/类型角度解释了“哪些是真的问题，哪些是预期”；
	- 给出了通用 SQL：
		- 自动为 enum 型缺失的 fallback 值补一条枚举并设为 default；
		- 自动为 bool 型缺失的 fallback 值补一条枚举并设为 default；
		- 再全局 UPDATE 一次，把 is\_default 永远跟着 spec.fallback 走。
- **下一步建议**
	1. 先在测试库跑上述 INSERT + UPDATE，再用你那条对照查询验证结果；
	2. 如果结果符合预期，就把这套脚本固化成“兜底治理脚本”（比如命名成 `fix_fallback_enum_alignment.sql` ），以后每次大批量改 spec 之后都跑一遍；
	3. 后面如果你需要，我可以帮你把“对照查询 + 修复脚本”整理成一个完整的检查/修复包，直接当巡检工具用。

为了减少解释成本,我打算把拉齐全部的标签的兜底值,不要搞一部分没有的逻辑,就是不区分value\_type,全部做修正;是否可行?

20251207\_1435\_兜底值全量拉齐策略\_v1

tags: #fallback兜底值 #tag\_enum #tag\_spec #一致性治理 #规则简化

---

### 1）一句话结论

可以的，而且在你当前这套设计里，“不区分 value\_type，全部按 fallback ↔ enum\_code 拉齐”是可行的，只要你接受： **所有有 fallback 的标签，都在 tag\_enum 里至少有一条“fallback 枚举 + is\_default=1”的记录** ，哪怕它是 string 型标签。

---

### 2）三段论据

#### 论据一：你为什么会有这个冲动——现在的规则确实有“心智成本”

现在的逻辑是：

- enum / bool：必须在 `tag_enum` 有 fallback 对应枚举，并设 `is_default=1` ；
- string：只在 `tag_spec` 里有 fallback，就认为足够，不强制出现在 `tag_enum` 。

结果就是：

- 查询/修复脚本里要带 `value_type IN (...)` 的分支；
- 看检查结果时要在脑子里“哦，string 型看到 fallback\_in\_enum=0 是正常的”；
- 对你这种要长期维护的人来说，确实增加了 mental overhead。

你现在想的是：“干脆统一逻辑，凡是有 fallback 的，都保证 `tag_enum` 里有一条同 code 的默认枚举，这样排查和口径都能一句话讲完。”——这个方向是对的。

#### 论据二：这样做的前提条件 —— 在你当前数据里，风险很可控

如果要“一刀切”，需要看两件事：

1. **fallback 是否都是可枚举、可落表的简单值**
	- 你现有的 fallback 大致是： `'SMALL' / 'other' / 'none' / 'unknown' / '99'` 这类短 code。
	- 没看到那种“长句 free text / JSON / 业务公式”类型的 fallback。  
		→ 把这些值同步到 `tag_enum.enum_code` ，完全没问题。
2. **tag\_enum 在你系统里的角色**
	- 它本来就是“标签的值域控制 + 匹配字典”；
	- 就算 string 型标签（如 `open_hours` / `store_life` ）多了一条 `"unknown"` 的枚举，也只是多了一条“兜底编码”的元数据，并不会强行要求所有 string 值都在 enum 里列全。

结论：在你当前的这个版本里， **做一刀切的全量拉齐，风险是可控且收益明显的** ——最主要收益就是：

> 从此你可以对任何人说：  
> “所有标签的兜底值只有一个定义点： `tag_spec.fallback` ，并保证 tag\_enum 中一定有一条 enum\_code=fallback 且 is\_default=1 的记录。”

没有“string 例外”的解释成本。

#### 论据三：落地方式 —— 把所有 SQL 里的 value\_type 分支干掉

思路很简单：

1. **从现在开始，不在代码/脚本里再根据 `value_type` 决定是否拉齐** ；
2. **统一约束** ：
	- 只要 `tag_spec.fallback` 非空，就保证：
		- `tag_enum` 里存在一条 `(tag_code, spec_version, enum_code = fallback)` ；
		- 这条记录 `is_default=1` ；
		- 同一 `(tag_code, spec_version)` 下其他枚举 `is_default=0` 。
3. **string 型标签**
	- 会多一条 `enum_code='unknown'` 的记录（或者你指定的 fallback）；
	- 用处主要是：
		- 对齐检查不再出现“fallback\_in\_enum=0”；
		- 将来如果有人硬要读 enum 表找“unknown”的文案，也能拿得到。

---

### 3）思维导图结构（文本分层）

#### 一、统一后的“兜底规则”口径

1. 兜底定义
	- 仅在 `tag_spec.fallback` 定义；不再在 enum 上手工指定。
2. 兜底落地
	- 对所有标签（不看 `value_type` ）：
		- 若 `fallback` 非空：
			- `tag_enum` 必须有一条 `enum_code = fallback` 、 `is_default=1` ；
			- 同一 `(tag_code, spec_version)` 下其他枚举 `is_default=0` 。
3. 检查规则
	- 任何 `fallback_in_enum=0` 或 `enum_default_matches_fallback=0` 的情况，都是异常，类型不再是“解释例外”的理由。

---

#### 二、SQL 改造：把按类型拆分的脚本合成一套“全量通用版”

下面是“去掉 value\_type 分支”的统一版本，你可以把之前那几段替换掉。

**1）统一补齐“fallback 对应枚举”的 INSERT**

```sql
sql-- 为所有有 fallback 的标签，补一条 "enum_code = fallback" 的枚举（若不存在）
INSERT INTO tag_enum (
    tag_code,
    spec_version,
    enum_code,
    enum_label,
    sort_order,
    is_default,
    brand_aliases,
    exclusion_field,
    brand_category,
    keywords,
    is_active,
    match_method,
    match_score_threshold,
    white_list,
    black_list,
    created_at,
    updated_at,
    updated_by
)
SELECT
    s.tag_code,
    s.spec_version,
    s.fallback          AS enum_code,
    '未知'              AS enum_label,          -- 通用中文名，可按需区分（比如“未知状态”）
    0                   AS sort_order,
    1                   AS is_default,          -- 直接设为默认
    NULL                AS brand_aliases,
    NULL                AS exclusion_field,
    NULL                AS brand_category,
    NULL                AS keywords,
    1                   AS is_active,
    0                   AS match_method,
    0.00                AS match_score_threshold,
    0                   AS white_list,
    0                   AS black_list,
    NOW()               AS created_at,
    NOW()               AS updated_at,
    'fallback_unify_all' AS updated_by
FROM tag_spec s
LEFT JOIN tag_enum e
  ON s.tag_code     = e.tag_code
 AND s.spec_version = e.spec_version
 AND e.enum_code    = s.fallback
WHERE s.fallback IS NOT NULL
  AND s.fallback <> ''
  AND e.enum_code IS NULL;     -- 只补 "fallback 不在 enum 中" 的
```

> 这一条对所有标签生效：enum / bool / string，只要 fallback 非空，一律保证 enum 里有一条同 code 的记录。

---

**2）统一拉齐 is\_default 的 UPDATE（完全不看 value\_type）**

> 这下就真的不需要 `value_type` 了：
> 
> - bool：99 那条会被设为默认；
> - enum：unknown/other/none 那条会被设为默认；
> - string：unknown 那条会被设为默认；
> - 任何未来新标签，只要填了 fallback，跑这两步，就自动对齐。

---

**3）对照查询仍然可以用原来的（只是解释更简单了）**

你的对照查询不需要改逻辑，只是解释可以变为一句话：

- `has_spec_fallback = 0` → 规格未定义兜底；
- `has_enum_default = 0` → 枚举未定义默认（按我们的脚本执行完后，这种情况应该只出现在 fallback 本身为空的标签）；
- `fallback_in_enum = 0` 或 `enum_default_matches_fallback = 0` → 必然属于“元数据不一致，需要修复”。

---

### 4）迭代日志

- **本轮问题**
	- 你在实际跑完一轮对齐之后，感受到“按 value\_type 分支”的解释成本，希望改为一套统一规则：不分 enum/bool/string，只要有 fallback，就保证在 tag\_enum 里有对应枚举，并设为默认。
- **本轮结论**
	1. 在你当前这批标签的数据形态下，这种“一刀切”的规则是安全、可行的；
	2. 统一规则后的好处非常直接：查询/巡检/对外解释全部简化成一条线；
	3. 风险点主要是未来如果某些标签用到“复杂 fallback”，可能不适合写进 enum——但你现在的 fallback 形态看起来都非常简单。
- **本轮输出**
	- 将原来按 enum/bool 分支的 INSERT/UPDATE 合并成一套“全量通用脚本”，删除所有 `value_type` 条件；
	- 明确了新的“标签兜底规则口径”，方便你以后对团队解释和写文档。
- **下一步建议**
	1. 在测试库用这两条“全量统一版”脚本跑一遍，再用你的对照查询验证一次；
	2. 如果结果符合预期，就把这两条脚本直接固化为“兜底对齐标准脚本”，以后无脑复用；
	3. 文档上补一句约束： **“未来新增标签的 fallback 必须是可枚举的简单 code，不允许写 JSON/长文本，否则会污染 tag\_enum”** ，这样整个体系就闭环了。

20251207\_1455\_兜底拉齐自动化\_方案\_v1

tags: #fallback拉齐 #数据巡检 #自动化脚本 #MySQL事件 #运维规范

---

### 1）一句话结论

最稳的做法是：把你现在的「检测 SQL + 修复 SQL」封装成一个固定脚本（或存储过程），再用「数据库事件 / 定时脚本 / 现有调度系统」每天自动跑一遍，同时做好操作日志和“异常阈值告警”，这样既能自动拉齐，又不会悄悄把大规模问题掩盖掉。

---

### 2）三段论据

#### 论据一：你已经有了 90% 的能力，缺的是“固定入口 + 定时触发”

现状你已经有：

1. 检查兜底差异的 SQL（类似刚才那条对比查询）；
2. 修复兜底差异的 SQL：

但现在每次都是你手动复制执行：

- 好处：可控；
- 问题：
	- 容易忘；
	- 别人不会用；
	- 无操作记录。

你要的其实是：

> 有一个固定“入口”，自动帮你每天跑一遍，这个入口可以是：MySQL 事件 / cron+脚本 / 你已有的 Python 调度器。

#### 论据二：自动化要兼顾“拉齐”和“可观测性”

简单粗暴的做法是： **每天 3 点跑一次 UPDATE** ，但这样有两个风险：

1. 有人误填了一堆 fallback，自动脚本帮他“修好了”，没人知道根因在哪；
2. 你之后排查问题，没有任何“什么时候修过多少行”的记录。

所以更稳妥的设计是：

- 把自动化拆成三步：  
	1）统计差异；  
	2）修复；  
	3）记录本次修复的统计信息（写日志表）。
- 当差异数量超过某个阈值（比如 > 1000 条）时，只写入日志+告警，不自动修，留给你人工确认。

#### 论据三：实现路径有多种，你可以从“最简单可落地”的选一个

根据你现在的环境（本地 MySQL + 经常用 Navicat + 你自己有 Python 项目），大致有三条路：

1. **MySQL 内建事件调度（轻量、无外部依赖）**
2. **cron + SQL 文件（在你的 Mac 或服务器上跑一个小脚本）**
3. **接入你已有的 Python 调度系统（比如你已有的 updater 项目）**

我直接给你每条路径的模板，你选一个就能落地。

---

### 3）可落地方案设计（按路径拆）

#### 3.1 公用组件：检查视图 + 修复 SQL + 日志表

先统一一个“检查视图”和“日志表”，后续所有方案都共用。

**1）兜底一致性视图（简化版）**

```sql
sqlCREATE OR REPLACE VIEW v_tag_fallback_check AS
SELECT
    s.tag_code,
    s.spec_version,
    s.value_type,
    s.value_type_connect,
    s.fallback        AS spec_fallback,
    CASE
        WHEN s.fallback IS NULL OR s.fallback = '' THEN 0
        ELSE 1
    END AS has_spec_fallback,
    GROUP_CONCAT(
        DISTINCT CASE WHEN e.is_default = 1 THEN e.enum_code END
        ORDER BY e.enum_code
    ) AS enum_default_codes,
    MAX(CASE WHEN e.is_default = 1 THEN 1 ELSE 0 END) AS has_enum_default,
    MAX(CASE WHEN e.enum_code = s.fallback THEN 1 ELSE 0 END) AS fallback_in_enum,
    MAX(CASE WHEN e.is_default = 1 AND e.enum_code = s.fallback THEN 1 ELSE 0 END) AS enum_default_matches_fallback
FROM tag_spec s
LEFT JOIN tag_enum e
  ON s.tag_code     = e.tag_code
 AND s.spec_version = e.spec_version
GROUP BY
    s.tag_code,
    s.spec_version,
    s.value_type,
    s.value_type_connect,
    s.fallback;
```

**2）“有问题的记录数”检查 SQL**

**3）兜底拉齐 UPDATE（enum + bool）**

**4）日志表（建议建一个，很简单但很有用）**

---

#### 3.2 路径 A：用 MySQL EVENT 自动每日运行

前提：MySQL 配置里启用了 event\_scheduler（ `SHOW VARIABLES LIKE 'event_scheduler';`）。

**1）封装成存储过程**

```sql
sqlDELIMITER $$

CREATE PROCEDURE sp_sync_tag_fallback_enum_bool()
BEGIN
    DECLARE v_diff_cnt INT DEFAULT 0;
    DECLARE v_updated_rows INT DEFAULT 0;

    -- 1. 统计修复前有多少差异
    SELECT COUNT(*) INTO v_diff_cnt
    FROM v_tag_fallback_check
    WHERE value_type IN ('enum', 'bool')
      AND (
            has_spec_fallback = 0
         OR fallback_in_enum = 0
         OR has_enum_default = 0
         OR enum_default_matches_fallback = 0
      );

    -- 简单的“安全阈值”，比如 >500 就只记录不自动修
    IF v_diff_cnt <= 500 THEN

        -- 2. 做一次拉齐
        UPDATE tag_enum e
        JOIN tag_spec s
          ON e.tag_code     = s.tag_code
         AND e.spec_version = s.spec_version
        SET e.is_default = CASE
            WHEN e.enum_code = s.fallback THEN 1
            ELSE 0
        END
        WHERE s.value_type IN ('enum', 'bool');

        SET v_updated_rows = ROW_COUNT();

    ELSE
        SET v_updated_rows = 0;
    END IF;

    -- 3. 写日志
    INSERT INTO tag_fallback_sync_log(run_at, before_diff_cnt, updated_rows, remark)
    VALUES (NOW(), v_diff_cnt, v_updated_rows,
            CASE
                WHEN v_diff_cnt > 500 THEN 'diff too large, skipped auto-fix'
                ELSE 'auto-fix executed'
            END);
END$$

DELIMITER ;
```

**2）建一个每天跑一次的事件（例如每天 03:30）**

之后：

- 你只需要时不时查一下：

就能看到每天修了多少行，有没有异常跳变。

---

#### 3.3 路径 B：cron + SQL 文件（适合你在 Mac/服务器上跑）

1）新建一个 SQL 文件，比如 `/Users/didi/xxx/sync_tag_fallback.sql` ，内容可以是：

前提是你已经在 DB 里建好视图 + 存储过程。

2）在 crontab 里加一条（示例每天 03:30 跑一次）：

这样所有逻辑都在 DB 里，cron 只是帮你“每天敲一下 CALL”。

---

#### 3.4 路径 C：接到你已有的 Python 更新框架

既然你已经有 `alveswave-updater` 这类自动化项目，其实可以把“兜底拉齐”当成其中一个 workflow：

- 在项目里加一个小模块：
	- 用 `pymysql` / `mysqlclient` 连接 `data_manager_db` ；
	- 先执行检查 SQL，把 `diff_cnt` 打到日志里；
	- 再执行 UPDATE，把 `rowcount` 打到日志里；
- 在你的 main workflow 里加一个 step，比如：
- 最终还是通过外部调度（cron / Airflow / 现有调度平台）按天触发。

好处：

- 所有更新/ETL/兜底修正都在同一套观察体系里，日志/告警统一管理；
- 你可以引入更多逻辑，例如“只在有新 tag\_spec 发布时才跑拉齐”。

---

### 4）迭代日志

- **本轮诉求**
	- 你决定保守策略：只对 `value_type IN ('enum','bool')` 做拉齐，避免影响下游；
	- 当前一次性修复已经完成，想解决“后期怎么自动跑拉齐 SQL”的问题。
- **本轮结论**
	1. 自动化的关键不是再写一条 SQL，而是：
		- 固定一个“统一入口”（存储过程/脚本）；
		- 用事件或调度系统定期触发；
		- 保留操作日志，防止静默修复。
	2. 最实用的方案：
		- 建 `v_tag_fallback_check` + `tag_fallback_sync_log` ；
		- 封装 `sp_sync_tag_fallback_enum_bool` ；
		- 用 MySQL EVENT 或 cron 每天跑一次。
- **下一步建议**
	1. 先在测试环境建：视图 + 日志表 + 存储过程；手动 CALL 一次，看 log 是否符合预期；
	2. 再决定用 EVENT 还是 cron 接入生产；
	3. 如果你愿意，下轮我可以帮你把“兜底治理”写成一份 README/内部 wiki，直接发给数据侧同学做标准化。

\[tag\_code spec\_version enum\_code enum\_label sort\_order is\_default brand\_aliases exclusion\_field brand\_category keywords is\_active match\_method match\_score\_threshold white\_list black\_list created\_at updated\_at updated\_by brand\_level 1.0.0 SMALL 小散 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import brand\_level 1.0.1 unknown 未知 0 1 1 0 0.00 0 0 2025-12-07 17:26:52 2025-12-07 17:26:52 fallback\_batch\_unknown\_1\_0\_1 brand\_name 1.0.0 other 其他 1 1 其他 1 1 0.00 1 1 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import brand\_name 1.0.1 unknown 未知 0 1 1 0 0.00 0 0 2025-12-07 17:26:52 2025-12-07 17:26:52 fallback\_batch\_unknown\_1\_0\_1 competitive\_overlap 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import convenience\_store\_available 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import is\_ka\_direct 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import open\_24h 1.0.0 99 未知 10 1 1 0 1.00 1 0 2025-12-06 19:07:04 2025-12-06 19:11:06 alves\_manual\_fix parking\_available 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import restroom\_available 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import service\_carwash\_available 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import service\_carwash\_type 1.0.0 none 无 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import service\_carwash\_type 1.0.1 unknown 未知 0 1 1 0 0.00 0 0 2025-12-07 17:26:52 2025-12-07 17:26:52 fallback\_batch\_unknown\_1\_0\_1 sme\_supplier 1.0.0 unknown 未知 0 1 1 0 0.00 0 0 2025-12-07 17:59:26 2025-12-07 17:59:26 fallback\_enum\_patch sme\_supplier\_partner 1.0.0 99 未知 1 1 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-07 17:27:43 initial\_import wyc\_pricing\_enabled 1.0.0 99 未知 0 1 1 0 0.00 0 0 2025-12-07 17:59:26 2025-12-07 17:59:26 fallback\_enum\_patch\],这个是最新版的 tag\_enum 表,发现一个问题,下游在找兜底值,如何快速定位找到最新的,且长期稳定呢?现在问题是增加了版本,有多个is\_default=1

20251207\_1810\_兜底值“只取当前版本”的稳定方案\_v1

tags: #tag\_enum #tag\_spec #兜底值 #版本治理 #查询规范

---

### 1）一句话结论

现在出现“多个 `is_default=1` ”是因为一个 `tag_code` 有多个 `spec_version` ；不要去改历史版本，而是统一规定： **下游查兜底值时永远先锁定“当前生效的 spec 版本”，再去 `tag_enum` 里找 `is_default=1`** ，用视图把这套逻辑封装掉，下游禁止直接用 `tag_enum WHERE tag_code=? AND is_default=1` 。

---

### 2）三段论据

**论据一：问题的本质——版本多了，is\_default 必然“多行”**

从你贴的 `tag_enum` 最新数据看：

- `brand_level` 有两行默认：
	- `1.0.0` SMALL / `is_default=1`
	- `1.0.1` unknown / `is_default=1`
- `brand_name` 、 `service_carwash_type` 也是同样结构。

这不是错，是“有历史版本”的自然结果：

- 对 2025-09-10 的数据来说，应该认 1.0.0 的兜底；
- 对 2025-12-10 的数据来说，应该认 1.0.1 的兜底；
- 所以历史版本保留 `is_default=1` 是有意义的（否则你做历史还原会错）。

问题出在下游现在的写法很可能是：

这在有多版本时一定拿到多行。 **根因不是 is\_default 设计错，而是“没有带版本维度”。**

---

**论据二：正确的稳定做法——“先定活跃 spec，再找 enum 默认”**

你现在的版本体系已经有：

- `tag_spec` ： `effective_from` / `effective_to` / `spec_version`
- `tag_enum` ： `spec_version` + `is_default`

所以，“最新兜底值”的正确定义应该是：

> 给定某个 `as_of_date` （默认今天）：
> 
> 1. 在 `tag_spec` 里，找到该 `tag_code` 在 `as_of_date` 下 **唯一生效的规格版本** ：
> 	- `effective_from <= as_of_date < effective_to(NULL=长期)` ；
> 	- 如果有多条，取 `spec_version` 最大的那条。
> 2. 用这个 `(tag_code, spec_version)` 去 `tag_enum` 里找 `is_default=1` 的那一条，就是该日期下的兜底枚举。

也就是说：

- 同一个 `tag_code` 可以在多个 `spec_version` 下各有一个 `is_default=1` ；
- 但“对某一天、某次计算来说”，只有一个版本会被选中 → 最终只有一个兜底值。

**我们不去清历史，只是规定：任何想要兜底值的人，必须先过 spec 版本选取逻辑。**

---

**论据三：路径方案——用视图把规则固定住，下游一律改用视图**

为了让下游不用自己写“先选 spec 再选 enum”这段逻辑，建议：

1. 做一个“当前生效 spec 视图”（按今天日期）；
2. 再做一个“当前生效兜底枚举视图”；
3. 下游所有查兜底值的 SQL，统一改为查这个视图。

这样：

- 即便以后你再出 1.0.2 / 1.0.3，历史版本照样保留 `is_default=1` ；
- 但实际应用里 “默认值” 永远只有一个入口， `SELECT * FROM v_tag_default_today` 。

下面直接给 SQL。

---

### 3）思维导图结构（含 SQL 模板）

#### 一、当前生效 spec 视图（按今天）

> 如果你需要“任意 as\_of\_date 参数”，可以在下游 SQL 里改 `CURDATE()` 为变量；视图里先给一个“今天版”是最实用的。

效果：

- 对每个 `tag_code` ， `v_tag_spec_active_today` 只保留“今天真正生效的那一版规格”；
- 旧版 1.0.0 会继续留在 `tag_spec` 里，但不会出现在这个视图中。

---

#### 二、当前生效兜底枚举视图

> 这一步用上面那个 active spec，再连 `tag_enum` 找 `is_default=1` 。

特点：

- 对每个 `tag_code` ：
	- `v_tag_default_today` 最多只有一行（因为 active\_today 只有一个版本 + 此版本只有一个 `is_default=1` ）；
- 下游拿兜底只需要：

而不是直接查 `tag_enum` 。

如果你要带上 catalog 信息，也可以再包一层：

报表、下游配置都可以直接用这个视图作为“标签目录 + 当前兜底”的总入口。

---

#### 三、下游使用规范（建议你写进内部文档）

给你一个可以直接写进 wiki 的“规范句”：

1. **禁止** ：
2. **推荐（今天的兜底）** ：
3. **如需历史还原（指定 as\_of\_date）** ：
	- 在代码层用变量代替 `CURDATE()` ，写成：
	- 这就是“对某天，只取那天生效版本的默认值”。

---

### 4）迭代日志

- **你新发现的问题**
	- 在 `tag_enum` 里，现在因为有 1.0.0 和 1.0.1，所以同一个 `tag_code` 出现了多条 `is_default=1` ；
	- 下游如果写“按 tag\_code + is\_default=1 查兜底”，会拿到多条，不稳定；
	- 你希望找到一个“长期稳定、统一的取兜底值方式”。
- **本轮结论**
	1. 多个 `spec_version` 同时有 `is_default=1` 本身没问题，是历史版本存在的自然结果；
	2. 正确做法是： **取兜底前必须先选“当前生效 spec 版本”，再在该版本的枚举里找 `is_default=1`** ；
	3. 建议用两个视图封装： `v_tag_spec_active_today` + `v_tag_default_today` ，让下游一律用视图，而不是直接扫 `tag_enum` 。
- **下一步建议**
	1. 先在测试库创建这两个视图，用几个 tag（brand\_level / brand\_name / service\_carwash\_type）验证一下结果；
	2. 拉上需要用兜底值的同学，对齐一个规则：只允许从 `v_tag_default_today` / 类似参数化 SQL 获取兜底；
	3. 如果你后续希望，我可以帮你写一页“小规范文档”，把“兜底值规则 + 取数规范 + 示例 SQL”整理成正式评审材料。

20251207\_1835\_版本维度兜底值决胜\_is\_active方案\_v1

tags: #兜底值 #版本治理 #is\_active #tag\_enum #简化下游查询

---

### 1）一句话结论

你的思路是可行的：在多版本场景下，通过一个自动脚本保证 **每个 tag\_code 只有一套版本的枚举行 `is_active=1`** （其余版本全部置为 0），下游统一按 `tag_code = ? AND is_default = 1 AND is_active = 1` 取兜底值，就不用再理解一堆视图逻辑了，但要接受“历史版本是否仍然 active”只靠忽略 `is_active` 来处理。

---

### 2）三段论据（现状与问题 → 关键洞察 → 路径方案）

#### 论据一：现状与问题——多版本 + 多条 is\_default=1，是设计上的必然

现在 `tag_enum` 的情况是这样的（简化）：

- `brand_level` ：
	- `1.0.0 / SMALL / is_default=1 / is_active=1`
	- `1.0.1 / unknown / is_default=1 / is_active=1`
- `brand_name` 、 `service_carwash_type` 同理。

从“严格按版本回放历史”的视角看，这是合理的：

- 对 1.0.0 生效期间的数据，兜底是 SMALL/other/none；
- 对 1.0.1 生效期间的数据，兜底是 unknown。

但对于下游的简单需求：“我就想拿 **现在** 这个标签的默认值”，他们不会自觉去写一堆 `effective_from` 的判断，通常只会：

现在有多版本，就会中招。  
你提议的方案是：

> 不要要求下游理解版本，只要求加一个条件： `AND is_active = 1` ，由我们保证全库只有“当前版本的枚举行 is\_active=1”。

这是非常现实的工程化简化。

---

#### 论据二：关键洞察——把“当前版本”的选择结果物化到 is\_active 上

目前我们是“逻辑上”区分版本：

- 在 `tag_spec` 里，根据 `effective_from/effective_to + spec_version` 推导“当前有效版本”；
- 在 `tag_enum` 里，只知道 `(tag_code, spec_version, enum_code)` 和 `is_default` ，不知道“哪一版是现在用的”。

你现在的想法是： **把这段“推导逻辑”结果写回到 `tag_enum.is_active` 上** ：

- 对每个 `tag_code` ：
	- 先用一套规则选出“当前有效 spec\_version”；
	- 然后把该 `(tag_code, spec_version)` 下的所有枚举行 `is_active=1` ；
	- 其他版本的枚举行 `is_active=0` 。

这样：

- “版本推导”只在一个同步脚本里做；
- 下游只要记住一句话：
	> “要当前兜底值，就查 `tag_enum WHERE tag_code=? AND is_default=1 AND is_active=1` 。”

视图可以不要，下游 SQL 足够简单、解释成本极低。

---

#### 论据三：路径方案——用一个对齐脚本维护 is\_active，保证“每 tag 仅一版 active”

你想要的是：

- 每个 `tag_code` ：
	- 有多个 `spec_version` ——> 但 **只能有一版是“当前 active 版本”** ；
	- 枚举层表现：只有这一版的枚举行 `is_active=1` ，其它版全部 `is_active=0` ；
- 下游：
	- 不需要视图、不需要 JOIN，统一写：

完全可以做到，只要你愿意：

- 接受 `is_active` 的语义从“单枚举值是否启用”提升为“整个版本是否当前启用”（单版本内部的“禁用某个枚举”需求以后就要另想办法，比如用 `status` 字段）。

下面给你一套 **具体可执行的 SQL 同步脚本** ，把“当前版本决胜 → is\_active 写回”这件事自动化。

---

### 3）思维导图结构（含具体 SQL）

#### 一、确定每个 tag\_code 的“当前有效版本”

规则建议（和我们前面视图的一样，只是现在直接写到临时表/子查询里，不做视图）：

> 对每个 tag\_code：
> 
> - 只看 `effective_from <= CURDATE()` && (`effective_to IS NULL OR effective_to > CURDATE()`) 的记录；
> - 在这些里选 `effective_from` 最大的那条；
> - 若仍有多条，则选 `spec_version` 最大的那条。

用一个子查询算出当前版本集合（记作 `tmp_active_spec` ）：

> 注意：MySQL 8 支持 CTE；如果你版本较低，不支持 WITH，我们可以改成两张临时表或嵌套子查询，下边我给一个“无 WITH 版”的 UPDATE 写法。

---

#### 二、根据“当前版本集合”更新 tag\_enum.is\_active

目标：

- 对于属于“当前版本集合”的 `(tag_code, spec_version)` ，所有枚举行 `is_active=1` ；
- 对于不在集合中的枚举行 `is_active=0` 。

**无 WITH 版 UPDATE（兼容 MySQL 5.7/8.0）** ：

```sql
sql-- 1）先全部置 0
UPDATE tag_enum
SET is_active = 0;

-- 2）再把当前版本的枚举置为 1
UPDATE tag_enum e
JOIN (
    -- 计算当前版本集合 active_spec_with_version
    SELECT s1.tag_code, s1.spec_version
    FROM tag_spec s1
    JOIN (
        -- 每个 tag_code 的 max_effective_from
        SELECT tag_code, MAX(effective_from) AS max_effective_from
        FROM tag_spec
        WHERE effective_from <= CURDATE()
          AND (effective_to IS NULL OR effective_to > CURDATE())
        GROUP BY tag_code
    ) t
      ON s1.tag_code       = t.tag_code
     AND s1.effective_from = t.max_effective_from
    JOIN (
        -- 对 (tag_code, effective_from) 再选 max spec_version
        SELECT tag_code, effective_from, MAX(spec_version) AS max_spec_version
        FROM tag_spec
        WHERE effective_from <= CURDATE()
          AND (effective_to IS NULL OR effective_to > CURDATE())
        GROUP BY tag_code, effective_from
    ) u
      ON s1.tag_code       = u.tag_code
     AND s1.effective_from = u.effective_from
     AND s1.spec_version   = u.max_spec_version
) a
  ON e.tag_code     = a.tag_code
 AND e.spec_version = a.spec_version
SET e.is_active = 1;
```

执行完这两条后：

- 每个 `tag_code` ：
	- 当前版本（比如 1.0.1）下的枚举行： `is_active = 1` ；
	- 历史版本（1.0.0 等）： `is_active = 0` 。
- 下游只要 `WHERE tag_code=? AND is_default=1 AND is_active=1` 就只会拿到“当前版本”的兜底。

> 你可以把这两条 UPDATE 封装进一个存储过程 `sp_sync_tag_enum_is_active_by_spec()` ，再按前面说的用 EVENT/cron 每天跑一次。

---

#### 三、下游最终查询规范（你可以直接写进团队规范）

1. **取当前版本兜底值（推荐写法）**
1. **如需枚举全量值域（仅当前版本）**
1. **如需“历史版本兜底值”，则显式带版本**

> 也就是说：
> 
> - “只加 is\_active=1” → 始终拿当前版本；
> - “加 spec\_version=xxx” → 明确指定要历史哪一版。

---

### 4）迭代日志

- **本轮新问题**
	- 你不想再搞多个视图、多个 JOIN，下游很难记；
	- 提出一个更简单的规则：
		> “每个 tag 多版本里只保留一个 is\_active=1 的版本，下游统一用 `is_default=1 AND is_active=1` 取兜底值。”
- **本轮结论**
	1. 这个方案在你当前的表结构和业务需求下是完全可行的；
	2. 核心是用一段 UPDATE 脚本把“当前有效 spec\_version”计算结果物化到 `tag_enum.is_active` 上；
	3. 下游最终查询规则非常简单易记，也便于你在评审/文档中讲清楚。
- **下一步建议**
	1. 在测试库先手动跑一遍“is\_active 同步脚本”，确认每个 tag\_code 的当前版本是否被正确标记为 1；
	2. 把这两条 UPDATE 封装成存储过程，并用 EVENT/cron 做成每天一次的自动巡检；
	3. 内部写一页“标签枚举兜底规范”：明确
		- `tag_spec.fallback` 是兜底定义点；
		- `tag_enum.is_default` + `is_active` 是兜底落地点；
		- 下游只允许从 `tag_enum WHERE is_default=1 AND is_active=1` 取当前版本默认值。

如果你愿意，下一步我可以直接帮你把这套 `sp_sync_tag_enum_is_active_by_spec` 存储过程和触发它的 EVENT/cron 命令写成一份“运维说明”，你只要复制进 Navicat / crontab 就能跑。

20251207\_1915\_纠错与重构：is\_active 不能滥用\_v1

tags: #纠错 #is\_active语义 #版本选择 #视图封装 #兜底查询规范

---

### 1）一句话结论

你说得完全对： **不能全量把 tag\_enum.is\_active 置 0，再用脚本改回 1** ，这会破坏“枚举是否可用”的本意，是我这边设计失误。正确做法是：

- 保留 `is_active` 的“枚举是否当前可用”语义；
- 不用它做“版本选择”；
- 用一个 **单一视图** 把“当前版本 + is\_active + is\_default”封装起来，下游统一从这个视图查，不直接怼物理表。

下面我直接给你“修正思路 + 安全方案”。

---

### 2）先把逻辑错误说清楚（承认这次是我搞砸了）

你指出的几个点，都是对的：

1. `UPDATE tag_enum SET is_active = 0` 是 **全表杀伤** ：
	- 把所有历史版本 + 当前版本的所有枚举都先干成 0；
	- 再根据“当前版本集合”把一部分改回 1；
	- 一旦某些 `tag_code` 在 `tag_spec` 里算不出“当前有效版本”（比如 effective\_from 在未来 或 数据异常），那这一类的枚举就永远停留在 0 了。
2. `is_active` 原本含义是“这个枚举值是否可用”，不等于“这个版本是否当前有效”：
	- 有些枚举值虽然不是兜底（不是 fallback），但照样要被前端、规则调用；
	- 你强调的这句很关键：
		> “有一些不是兜底值, 但是他是要是被调用的”
	- 全表置 0 再改回 1，会把所有历史版本、所有枚举的“可用性状态”抹平， **相当于把“禁用某些枚举”的能力直接废掉** 。
3. 你最近贴的 tag\_enum 快照里：
	- 所有行 `is_active` 还是 1，说明你还没执行那个危险 UPDATE；
	- 这是好事，这个坑我们现在就当没踩过，直接换一条安全路径。

这块我直接认错： **把 is\_active 拿来“做版本决胜”，且用全表置 0 的方式，是不安全的设计。我们不这么干。**

---

### 3）换一条安全路线：不改 is\_active，用“单一视图 + 统一查询规范”

你刚才的诉求其实很简单两点：

1. 下游找兜底值时，要有一个 **长期稳定且简单的条件** ；
2. 现在有多版（1.0.0, 1.0.1…），不想让下游理解一堆版本细节。

我们可以达成一个折中：

- **不再碰 is\_active** （让它继续表示“这个枚举值是否可用”）；
- 把“当前版本选取逻辑”封装在一个视图里，下游：
	- 要兜底 → 查视图 + `is_default=1 AND is_active=1`
	- 永远不直接查 tag\_enum 原表。

也就是说：

> 版本的复杂度 → 我们藏在视图里；  
> is\_active 的语义 → 保持干净纯粹（只表示枚举是否可用）。

下面我把这个“单视图方案”写成具体 SQL，你实际使用只跟一个视图打交道。

---

### 4）单视图方案：v\_tag\_enum\_current

目标：做一个视图，满足：

- 只包含“ **当前生效版本** ”的枚举行；
- 保留原始的 `is_active` / `is_default` 等字段；
- 下游拿“当前枚举值域”或“当前兜底值”都从这里来。

#### 4.1 定义：按“今天”决胜的当前版本视图

```sql
sqlCREATE OR REPLACE VIEW v_tag_enum_current AS
SELECT
    e.tag_code,
    e.spec_version,
    e.enum_code,
    e.enum_label,
    e.sort_order,
    e.is_default,
    e.brand_aliases,
    e.exclusion_field,
    e.brand_category,
    e.keywords,
    e.is_active,
    e.match_method,
    e.match_score_threshold,
    e.white_list,
    e.black_list,
    e.created_at,
    e.updated_at,
    e.updated_by
FROM tag_enum e
JOIN (
    -- 选出每个 tag_code 当前生效的 spec_version
    SELECT s1.tag_code, s1.spec_version
    FROM tag_spec s1
    JOIN (
        -- 每个 tag_code 的 max_effective_from（在今天之前且仍未过期）
        SELECT tag_code, MAX(effective_from) AS max_effective_from
        FROM tag_spec
        WHERE effective_from <= CURDATE()
          AND (effective_to IS NULL OR effective_to > CURDATE())
        GROUP BY tag_code
    ) t
      ON s1.tag_code       = t.tag_code
     AND s1.effective_from = t.max_effective_from
    JOIN (
        -- 对 (tag_code, effective_from) 再选 max spec_version
        SELECT tag_code, effective_from, MAX(spec_version) AS max_spec_version
        FROM tag_spec
        WHERE effective_from <= CURDATE()
          AND (effective_to IS NULL OR effective_to > CURDATE())
        GROUP BY tag_code, effective_from
    ) u
      ON s1.tag_code       = u.tag_code
     AND s1.effective_from = u.effective_from
     AND s1.spec_version   = u.max_spec_version
) a
  ON e.tag_code     = a.tag_code
 AND e.spec_version = a.spec_version;
```

要点：

- **我们只做 JOIN，不 UPDATE** ：
	- tag\_enum 原表的 `is_active` 完全不动；
	- 版本决胜全部在这个视图里完成。
- 视图里每个 `tag_code` 只会出现“当前版本”的枚举值（例如 brand\_level 的 1.0.1，brand\_name 的 1.0.1…）。
- 历史版本（1.0.0）的枚举仍在 tag\_enum 原表里，用于历史分析，但不会出现在 `v_tag_enum_current` 。

#### 4.2 下游用法规范

有了这个视图，下游可以这样写：

1. **取当前兜底值（推荐写法）**
- `is_default=1` ：当前版本兜底值；
- `is_active=1` ：这个枚举本身是可用的（你将来可以手动把某个枚举 is\_active=0 禁用掉，视图仍然保留真实状态）。
1. **取当前版本的全部枚举值域**
1. **需要历史版本时，直接查原表 + 指定 spec\_version**

这样一来：

- “当前业务逻辑” → 一律用 `v_tag_enum_current` ；
- “历史回溯” → 精确带 spec\_version 查原表；
- is\_active 的语义完全没有被“版本决胜”污染。

---

### 5）如果你坚持要 “is\_active 决胜版本”，有什么更安全的折中？

老实说，我现在 **不建议再用 is\_active 做版本决胜** ，但如果你坚持要“多版本有且仅一版 is\_active=1”，那也必须遵守两个原则：

1. 只能对 **有多版本的 tag\_code** 做决胜，不搞 `UPDATE tag_enum SET is_active=0` 这种全表操作；
2. 决胜逻辑只影响“版本维度”，不要改变单个枚举原本“启用/禁用”的状态（这一点很难保证，实质上还是在混用语义）。

所以从安全、维护和语义清晰的角度，我还是更推荐上面的“单视图 + 统一查询规范”方案，而不是继续调教 is\_active。

---

### 6）迭代日志

- **你指出的问题**
	- 全表 `SET is_active=0` 是重大逻辑漏洞；
	- 有些不是兜底值但仍然要被调用，不能随意改 is\_active；
	- 你不接受这种“破坏原表含义”的方案，这是完全正确的。
- **本轮修正**
	1. 明确撤回之前“用 is\_active 决胜版本 + 全量置 0”的建议；
	2. 提出新的安全方案：
		- 不再触碰 is\_active 字段；
		- 用一个视图 `v_tag_enum_current` ，把“当前版本”封装进去；
		- 下游统一用 `v_tag_enum_current + is_default=1 + is_active=1` 获取兜底。
- **下一步建议**
	1. 在测试环境建好 `v_tag_enum_current` ；
	2. 用你刚刚那批 tag（brand\_level / brand\_name / service\_carwash\_type 等）跑几条 SELECT，确认返回的都是 1.0.1 版本的枚举；
	3. 跟下游对齐一条规矩：
		> “查标签枚举、兜底值，一律从 v\_tag\_enum\_current 查，不直接查 tag\_enum 原表。”
	4. 如果你愿意，我可以帮你写一段“给同事看的解释文案”，把这个视图和使用方式讲清楚，直接发到飞书/企业微信群里。

20251207\_1935\_tag\_enum版本兜底修正\_SQL\_v2

tags: #tag\_enum #is\_active #版本治理 #SQL脚本 #保护措施

---

### 1）一句话结论

按你的要求，给你一套“ **只动多版本 code** ”的 SQL：  
1）先把 `tag_enum.is_active` 全部恢复为 1；  
2）以后重大操作前，用一条简单 SQL 备份整表；  
3）再对“有多个 `spec_version` 的 tag\_code”，只保留最大版本号的 `is_active=1` ，其余版本全部 `is_active=0` —— **且只作用在这些多版本标签上，不会误伤只有单版本的 code** 。

---

### 2）三段论据（现状 → 关键点 → 落地方式）

#### 论据一：先“原地救火”——恢复 is\_active，避免继续污染

你现在的诉求是：

> 1. 先恢复到全部 is\_active = 1

对应最直接的 SQL 就是这句（你已经确认要这么干）：

它的含义很简单：

- 当前所有枚举值（所有版本、所有 code）全部视为“可用”；
- 之后我们再用精确 UPDATE 针对“多版本 code”按规则归 0/1。

这一条你可以先在测试库跑一遍确认状态正常，再考虑是否在正式库执行。

---

#### 论据二：变更前先“留后路”——最简单的备份方式

> 1. 以后重大变更前先备份一份

给你一个最简单、实用的备份方式（不搞复杂工具）：

**方式 A：用新表做快照备份**

特点：

- 秒级完成，适合在同一个库里“留个影子”；
- 一旦脚本出问题，你可以：
	- 直接 `DROP TABLE tag_enum;`
	- `ALTER TABLE tag_enum_backup_20251207 RENAME TO tag_enum;` 恢复。

**方式 B：命令行 mysqldump（你 Mac 上也可以用）**

两种方式都可以，你选一个自己顺手的；原则是： **大操作前一定先留备份，不再裸跑 UPDATE。**

---

#### 论据三：核心逻辑——“只动多版本 code，保留最大版本 is\_active=1”

> 1. 对有多个版本的 code，只保留最大值的版本号 is\_active=1，其余全部归 0

我按你说的逻辑写成一条 **完整、可执行、且不会误伤单版本标签** 的 SQL。

约定：

- 版本号比较：用 `CAST(REPLACE(spec_version,'.','') AS UNSIGNED)` 做数值比较，避免 `'1.0.10'` 和 `'1.0.2'` 的字符串排序问题；
- 只对在 `tag_spec` 中有多版本的 `tag_code` 生效；
- 只处理 `value_type IN ('enum','bool')` 的标签，更谨慎一点。

完整 SQL 如下（建议你直接整体复制到 Navicat）：

```sql
sql-- 第一步：【可选但建议】先备份
-- CREATE TABLE tag_enum_backup_20251207 AS
-- SELECT * FROM tag_enum;

-- 第二步：先恢复，确保所有行 is_active = 1（你已经明确要求）
UPDATE tag_enum
SET is_active = 1;

-- 第三步：只对“有多个版本的 enum/bool 标签”做 is_active 归一化
UPDATE tag_enum e
JOIN (
    -- 计算每个 tag_code 的“最大版本号”（只看 enum/bool，且有多个版本的）
    SELECT
        s.tag_code,
        MAX(CAST(REPLACE(s.spec_version, '.', '') AS UNSIGNED)) AS max_ver_num
    FROM tag_spec s
    WHERE s.value_type IN ('enum', 'bool')
    GROUP BY s.tag_code
    HAVING COUNT(DISTINCT s.spec_version) > 1    -- 只筛选“多版本”的 code
) v
  ON e.tag_code = v.tag_code
JOIN tag_spec s
  ON e.tag_code     = s.tag_code
 AND e.spec_version = s.spec_version
SET e.is_active = CASE
    -- 当前这行属于“最大 spec_version” → 保持 1
    WHEN CAST(REPLACE(e.spec_version, '.', '') AS UNSIGNED) = v.max_ver_num THEN 1
    -- 其它旧版本 → 归 0
    ELSE 0
END
WHERE s.value_type IN ('enum', 'bool');
```

逻辑逐条翻译成自然语言就是：

1. 把枚举表先全部恢复为“都可用”（is\_active=1）。
2. 用 `tag_spec` 找出“有多个规格版本，且是 enum/bool 类型”的那些 `tag_code` 。
3. 对这些 code：
	- 找出数值意义上的 **最大版本号** （比如 1.0.1 比 1.0.0 新）；
	- 对这个版本下的所有枚举记录保持 `is_active=1` ；
	- 对同一 code 的其它版本，全部 `is_active=0` 。
4. 对那些“只有一个版本”的 code，这条 UPDATE 根本不会命中，它们的 `is_active` 仍然是 1（因为我们前面恢复过）。

满足你说的那句：

> “对有多个版本的 code，只保留最大值的版本号 is\_active=1, 其余全部归 0；只有一条记录的不要碰。”

---

### 3）思维导图结构（文本分层）

**一、恢复与保护**

1. 恢复现场
	- `UPDATE tag_enum SET is_active = 1;`
	- 所有枚举重新视为可用，避免之前逻辑污染残留。
2. 变更前备份
	- `CREATE TABLE tag_enum_backup_yyyymmdd AS SELECT * FROM tag_enum;`
	- 或 `mysqldump` 导出到 `.sql` 文件。

**二、多版本 code 的版本决胜逻辑**

1. 判定“多版本 code”
	- 在 `tag_spec` 里：
		- `GROUP BY tag_code`
		- `HAVING COUNT(DISTINCT spec_version) > 1`
2. 选“最大版本”
	- 用 `CAST(REPLACE(spec_version,'.','') AS UNSIGNED)` 做数值比较；
	- 取 `MAX(...)` 作为最大版本号。
3. 更新策略
	- JOIN `tag_enum` + `tag_spec` ：
		- 若当前行的 `spec_version` 对应 `max_ver_num` → `is_active=1` ；
		- 否则（旧版本） → `is_active=0` 。
	- WHERE 限制在 `s.value_type IN ('enum','bool')` ，保守生效。

**三、下游使用建议（不改表名、不建视图的前提下）**

- 取当前可用兜底值：
- 取当前版本的可用枚举值域：

旧版本要用的话，就显式加 `spec_version='1.0.0'` ，这是你后续自己掌控的。

---

### 4）迭代日志

- **你刚刚明确的三条要求**
	1. 不要再改下游表名/查询方式那一套；
	2. 先整体把 `is_active` 恢复为 1，保证表不被逻辑污染；
	3. 对“有多个版本”的 code，按“最大版本号 is\_active=1，其余版本 is\_active=0”的规则处理，且单版本 code 不得被误伤。
- **本轮给出的结果**
	- 一条恢复 SQL；
	- 一条最简单可用的备份 SQL；
	- 一条严格按你规则实现的 UPDATE（只作用在多版本 enum/bool 标签，且通过数值化 spec\_version 决胜）。
- **建议你下一步怎么做**
	1. 在测试库严格按顺序跑：备份 → 恢复 is\_active → 版本决胜 UPDATE；
	2. 用你刚才那条对比查询，再看一眼多版本 code 的 is\_active 是否符合预期：
		- 1.0.1 行 is\_active=1，1.0.0 行 is\_active=0；
	3. 确认无误后，再把这三步写进你自己的“DB 操作 SOP”，以后所有类似大调整都按这个流程来。

如果你愿意，下一步你可以把跑完之后的部分 tag\_enum 结果再贴一份，我帮你一起做一轮 sanity check，看逻辑有没有漏。

你的查询写错了,仍然没有改变;

20251207\_2015\_tag\_enum版本is\_active修正\_纠错版

tags: #tag\_enum #is\_active #版本治理 #SQL纠错

---

### 1）一句话结论

之前那条 UPDATE 的确存在命中范围问题，我现在给你一套更“笨但稳”的两步 SQL：只对「有多个版本的 tag\_code 且 value\_type IN ('enum','bool')」动手——先把这些 code 的所有版本 is\_active 归 0，再只把最大版本号那一版改回 1，单版本 code 完全不受影响。

---

### 2）三段论据（现状 → 漏洞 → 修正版逻辑）

**论据一：为什么你看到“没有改变”**

你刚反馈“查询写错了，仍然没有改变”，本质上说明：

- 要么 UPDATE 命中的行本来就不多（甚至 0 行）；
- 要么 JOIN 条件过于复杂，某一层过滤把多版本的 code 给漏掉了。

上一版我把“找多版本 + 算最大 spec\_version + JOIN 回 tag\_enum”都揉在一条 UPDATE 里，层次太复杂，确实容易出现：

- 把多版本 code 过滤没命中；
- 或者 CAST 版本号时出现一些细节差异（比如 spec\_version 格式有空格、其它字符）。

你现在需要的是——简单、可读、可控的逻辑，不要花样。

---

**论据二：你要求的规则很清晰**

你刚把要求说得很明白，直接照抄成规则就是：

1. 先恢复：全表 `is_active=1` （你已经做了/可以再做一次）；
2. 以后大改前必备份一份（防止脚本翻车无路可退）；
3. 再对「有多个版本的 code」做决策：
	- 只保留“最大版本号”的那一版 `is_active=1` ；
	- 其余版本全部 `is_active=0` ；
	- **只有一个版本的 code 一律不动。**

我们就按这个规则来实现，逻辑上拆成“先找出多版本 code → 再改这些 code 对应的 tag\_enum”，不要搞花里胡哨的嵌套。

---

**论据三：修正版策略——两步 UPDATE，严格限定作用范围**

为了保证不再“误伤全表”，我把逻辑拆成两步：

1. 只把「多版本 enum/bool 标签」的所有版本 is\_active 先置 0；
2. 再只把这些标签的“最大 version”那一版 is\_active 改回 1。

关键点：

- 通过 `HAVING COUNT(DISTINCT spec_version) > 1` 精确圈出“多版本 code”；
- 用 `CAST(REPLACE(spec_version,'.','') AS UNSIGNED)` 选最大版本号；
- WHERE 永远加 `s.value_type IN ('enum','bool')` ，更保守。

---

### 3）思维导图结构（含“修正版 SQL”）

下面所有 SQL 都只针对你说的需求来写，不动表名、不改下游查询习惯。

#### 一、（可选）先恢复全表 is\_active=1

如果你已经执行过，可以跳过；如果不放心就再跑一次：

——作用：清掉之前可能已经被错误置 0 的状态，先回到“全部可用”的基线。

---

#### 二、一步查清：哪些 tag\_code 是“多版本 enum/bool 标签”

先用 SELECT 看一下，心里有数（只查，不改）：

这一步只是让你看到：预计会被“版本决胜”的 code 有哪些（比如 brand\_level / brand\_name / service\_carwash\_type 等）。

---

#### 三、真正的修正逻辑：两步 UPDATE（只动多版本 enum/bool）

**第 1 步：只把“多版本 enum/bool 标签”的所有版本 is\_active 归 0**

解释：

- `mv` 限定只对“多版本标签”生效；
- 再 JOIN `tag_spec` 限定只对 enum/bool ；
- 所以：
	- 单版本标签：完全不受影响（is\_active 仍是 1，因为第一步 UPDATE 没命中）；
	- 多版本 enum/bool 标签：所有版本 is\_active 暂时归 0，准备第二步“选 winner”。

---

**第 2 步：把这些多版本标签里“最大版本号”的那一版 is\_active 改回 1**

解释：

- `v` 表里每个 tag\_code 只保留一个 max\_ver\_num（比如 1.0.1 → 101）；
- 只对这些 tag\_code 的 enum/bool 行进行 UPDATE；
- 只有 `spec_version` 转成数字后等于 max\_ver\_num 的那一批被设为 1；
- 非最大版本保持 0。

最终状态应该是：

- 对于 brand\_level：
	- 1.0.0 → is\_active=0；
	- 1.0.1 → is\_active=1；
- 对于只有 1 个版本的 code（比如 competitive\_overlap）：
	- 仍然是 is\_active=1（第一步不命中它，第二步也不命中；我们没动它）。

---

#### 四、事后自检：确认逻辑是否按你预期生效

跑完之后，建议你用这条 SQL 快速检查一轮：

你预期看到的模式是：

- 对于多版本 enum/bool 标签：
	- 较小的 spec\_version 行 → is\_active = 0
	- 最大的 spec\_version 行 → is\_active = 1（兜底那行还会 is\_default=1）
- 对于单版本 enum/bool 标签：
	- 唯一一行 → is\_active 仍为 1

如果不是这个结果，再继续调；但这次逻辑已经非常直给，不绕弯子。

---

### 4）迭代日志

- **你的刚性诉求**
	- 不要改下游对 tag\_enum 的使用习惯；
	- 不接受“视图 + 改查询逻辑”那套；
	- 必须按你说的三点做：先恢复、先备份、只对多版本 code 做“最大版本 is\_active=1，其余版本 is\_active=0”的精确操作。
- **我这边的修正**
	- 明确承认之前“全量置 0 再置 1”的思路不安全；
	- 把逻辑拆开：
		- 单独恢复；
		- 单独备份；
		- 单独对“多版本 enum/bool 标签”做两步 UPDATE；
	- 严格按你的规则写了两条语义清晰、可自查的 SQL。
- **下一步建议（不需要你回答，直接做就行）**
	1. 在测试库顺序执行：
		- （可选）恢复 is\_active=1；
		- 两步 UPDATE；
	2. 用“事后自检 SQL”看 brand\_level / brand\_name / service\_carwash\_type 的 is\_active 是否符合预期；
	3. 确认无误之后，再迁移到正式库执行，并记得先建一张备份表。

如果你愿意，你可以把“跑完后的 tag\_enum 部分结果”再贴一小段，我可以帮你做一次 sanity check，看是不是完全符合你刚才描述的规则。

20251207\_2045\_版本决胜与主键逻辑\_澄清版

tags: #tag\_enum主键 #版本决胜 #is\_active #枚举版本策略

---

### 1）一句话结论

你说「主键其实是 tag\_code + spec\_version + enum\_code，要按主键改回」，从表结构上是对的，但要看你想“决胜”的对象是谁：

- 如果是「这个标签当前用哪一版规格」（按 tag\_code 选一个 spec\_version），那第二步只需要用 `tag_code + spec_version` 就够了， **不应该加 enum\_code** ；
- 如果是「同一个 enum\_code 在多个版本中只保留最新一条」，那才需要按 `(tag_code, enum_code)` 维度算最大版本，但这个逻辑会有副作用，我下面给你展开。

你现在说「我们再试试」，我先帮你把两种逻辑的区别讲清楚，避免走错路。

---

### 2）先把“主键”和“决胜对象”分清楚

1. **表设计上的主键**
	- `tag_enum` 的逻辑主键确实是：  
		`tag_code + spec_version + enum_code`
	- 意味着：同一个标签、同一版本下，每个枚举值是一行，不会重复。
2. **我们在做的“版本决胜”，决胜的是谁？**  
	看你前面一整轮描述，要求其实是这一句：
	> 对有多个版本的 code，只保留最大值的版本号 is\_active=1, 其余全部归 0；只有一个版本的不要动。
	这里的“code”指的其实是 `tag_code` ，不是 `tag_code + enum_code` 。  
	也就是说：
	- 对 `brand_level` ：1.0.0 vs 1.0.1 → 只保留「1.0.1 那一版的所有枚举」是 active；
	- 对 `brand_name` ：同理；
	- 旧版本整版枚举都视为“历史版”，is\_active=0。
	这个“决胜对象”是： **标签的规格版本（tag\_code 这一颗），不是枚举值本身。**
3. **为什么这时不应该按主键 `(tag_code, spec_version, enum_code)` 决胜？**
	- 主键只是“唯一定位行”的手段；
	- 现在我们要决定的是“哪一版 spec\_version 是当前生效的版本”，这个决策天然是在 `(tag_code, spec_version)` 层级；
	- 一旦决定了 `brand_level` 的当前版本是 `1.0.1` ，那这一个版本下的 **所有 enum\_code 行** 都应该被视为当前可用（is\_active=1），历史版本下的所有 enum\_code 行都应该是历史（is\_active=0）。
	- 这个过程里， **并不需要 enum\_code 参与“哪一版赢”这个决策** ，enum\_code 只是跟着版本一起被统治。

---

### 3）如果按你现在想到的“主键维度”去决胜，会发生什么？

假设存在这样一个演进（很像你 brand\_level / service\_carwash\_type 的情况）：

- `brand_level`
	- 1.0.0：只有枚举 `SMALL`
	- 1.0.1：只有枚举 `unknown`
- `service_carwash_type`
	- 1.0.0： `none`
	- 1.0.1： `unknown`

这在你现在的 tag\_enum 里差不多就是这样。

如果你按「主键维度决胜」的直觉改成：

> 对每个 `(tag_code, enum_code)` ，只保留它版本号最大的那一条 is\_active=1，其它版本的这个 enum\_code is\_active=0。

会出现两种情况：

1. 对 `enum_code = 'SMALL'` ：
	- 只出现在 1.0.0 → 版本最多是 1.0.0 → is\_active=1（合理：只有旧版有它）
2. 对 `enum_code = 'unknown'` ：
	- 只出现在 1.0.1 → 版本最多是 1.0.1 → is\_active=1（也合理）

但你前面第 1 步已经对「多版本 tag\_code 的所有枚举」 `is_active` 先清成 0：

这一步是按 tag\_code 维度归零的：

- `brand_level` 的 1.0.0 / 1.0.1 所有枚举都先变成 0；
- `service_carwash_type` 的所有版本所有枚举也先变成 0。

如果你第二步再按「(tag\_code, enum\_code) 维度 HAVING COUNT(DISTINCT spec\_version) > 1」去挑那些有多版本的 enum\_code 再设回 1，会有两个明显问题：

1. 对只在最新版本出现的 enum（比如 `unknown` ）：
	- 对于 `(brand_level, unknown)` ，在 tag\_enum 中只出现一次（1.0.1）， `COUNT(DISTINCT spec_version)=1` ；
	- 如果你在子查询里加 `HAVING COUNT(DISTINCT spec_version) > 1` ，这对根本不会被选中；
	- 结果是：
		- 第一步被置 0；
		- 第二步不会把它改回 1；
		- 你当前版本唯一的枚举反而处于停用状态。
2. 对只在旧版本有、在新版本被删除的 enum（比如 1.0.0 的某些值）
	- 合理状态：这些枚举在当前版本应该是 is\_active=0；
	- 这一点倒是和你“主键决胜”逻辑一致，但这是顺带效果，不是核心问题。

换句话说：

> 如果第二步改成“按主键维度 + HAVING COUNT>1 决胜”， **会导致当前版本里那些“新增的枚举”永远不会被恢复为 is\_active=1** ，因为它们在历史版本里没出现过。

这就违背了你最开始那句话的本意：

> “多版本的 code，只保留最大版本号的那一版 is\_active=1 其余归 0；单版本的不动。”

真正想要的是：

- `brand_level` 当前这颗标签 → 只有 1.0.1 这整个版本活着；
- 1.0.1 下面所有 enum（不管是 UNKNOWN 还是别的）都应该跟着活着；
- 旧版本 1.0.0 的所有枚举（比如 SMALL）都变成 is\_active=0。

这就是 **按 tag\_code+spec\_version 决胜** ，而不是按主键维度去逐枚举决胜。

---

### 4）结论：

- 你说“主键是 tag\_code + spec\_version + enum\_code，要按主键改回”，从“定位行”的角度是对的：UPDATE 时最终确实是对每一行（主键唯一）做修改；
- 但从“ **哪个版本赢** ”这个业务逻辑来说，决策维度应该仍然是「tag\_code 的哪一版规格是当前版」，也就是 `(tag_code, spec_version)` ；
- 一旦选出“当前 spec\_version”，那这一版下面的所有 `(tag_code, spec_version, enum_code)` 行自然都是“当前版”的一部分，该活的活、该死的死。

所以，我的判断是：

> 你第 1 步的逻辑（只把“多版本 enum/bool 标签”的所有版本 is\_active 归 0）是对的；  
> 第 2 步不需要改成按主键维度决胜， **应该继续按 tag\_code + spec\_version 决胜** ，只是我们之前那条 SQL 写得太绕，命中范围有问题，需要简化成一条更直白、你一眼能看懂的 UPDATE。

如果你愿意，我们下一步就：

- 不再纠结 HAVING 子查询；
- 直接写一条最简单、分两段的 SQL：
	- 用一个临时表算出「多版本标签各自的 max\_spec\_version」；
	- 再用 `tag_enum JOIN 这个临时表` 去把对应版本的行设回 is\_active=1。

你也可以把你当前跑过的那两条 SQL、以及跑完之后某几个 tag\_code 的 tag\_enum 现状贴出来，我可以对着真实结果帮你把第二步 UPDATE 改成最简单那种“我一眼就能 audit”的版本。

20251207\_2055\_tag\_enum版本默认值决胜\_SQL修正\_v3

tags: #tag\_enum #is\_active #is\_default #版本决胜 #SQL修正

---

### 1）一句话结论

是的，你现在这个说法才是对的：先把全表 `is_active=1` ，然后 **只在每个 tag\_code 下面、针对 `is_default=1` 的这些记录，在多版本里保留“最新一个版本 active=1”，其余默认行 active=0** ；非默认枚举一律不动，用一条自连接 UPDATE 就能稳定做到。

---

### 2）三段论据

#### 论据一：前一版为什么会误伤单版本 / 非默认枚举

- 之前那套“按 tag\_code + spec\_version 决胜”的 UPDATE，是：
	- 第一步把多版本 tag\_code 下的所有行 `is_active=0` ；
	- 第二步只把“最大 spec\_version 的所有行” `is_active=1` 。
- 问题在于：
	- 一个 tag\_code 下面有 N 个 `enum_code` ；
	- 我们其实只想“在多个默认版本里选一个 winner”，不想碰非默认枚举；
	- 但那一套写法是 **按版本整批处理** ，导致：
		- 某些只有一个版本的 default 行也被归 0；
		- 某些当前版本的非默认枚举行被错误从 1 改成 0（而这些值是要被调用的）。

你现在的修正是：

> 版本决胜只作用在 `is_default=1` 这几行身上， **不再动非默认枚举** 。  
> 这就是正确的方向。

---

#### 论据二：正确的“决胜对象”就是「每个 tag\_code 的默认行」

你的新表述可以拆成三个关键点：

1. “先全部赋值 `is_active=1` ”
	- 把之前可能被误改的 active 状态清零，所有枚举（默认+非默认）先统一为可用基线。
2. “tag\_code 分组下，选择 `is_default=1` 的记录”
	- 真正需要“版本唯一”的只有默认行：
		- 一个 tag\_code 可以有多版 default（1.0.0 / 1.0.1…）；
		- 但业务上你只承认最新一个 default 是“当前兜底值”。
3. “对多个版本中只保留最新一条（active=1），旧版 default 改为 active=0”
	- 对于 `brand_level` ：
		- 1.0.0/SMALL 默认 → active=0；
		- 1.0.1/unknown 默认 → active=1；
	- 对于只有一个默认版本的标签：
		- 它根本不会匹配“存在更高版”的条件 → 这条 default 仍保持 active=1。

也就是说：

- is\_active 用来区分“当前被当成默认兜底的那条 enum”；
- 非默认枚举行不再参与“版本决胜”，完全保留。

这和你要的行为完全一致。

---

#### 论据三：实现方法——先全表恢复，再用自连接只关掉“旧版默认行”

**核心思想：**

- 用一条自连接 UPDATE：
	- `e_old` = 某个 tag\_code 的“旧版默认行”；
	- `e_new` = 同一 tag\_code 下、版本比它更高的另一条默认行；
	- 对所有这样的 `e_old` ，把 `is_active` 置 0；
	- 对“最高版本的默认行”，因为找不到更高 `e_new` ，自然不会被改 0 → 仍然是 1。

下面是压到最简的版本，你一眼能 audit：

---

### 3）思维导图结构（含具体 SQL）

#### 一、步骤 0：恢复基线（你已经提过这一步）

含义：

- 所有枚举行（默认+非默认、所有版本）一律先恢复为 active=1；
- 为后续“只关掉旧版默认行”提供干净起点。

> 这一步你可以先在测试库跑，确认没问题再考虑在正式库执行。

---

#### 二、步骤 1：只关掉“旧版默认行”的 is\_active

**关键 UPDATE：**

逻辑展开讲就是：

- 对每一个 `tag_code` ：
	- 找到所有 `(e_old, e_new)` 对，满足：
		- 两边都是默认行（is\_default=1）；
		- `e_new.spec_version` 的数值 > `e_old.spec_version` 的数值。
	- 对所有这样的 `e_old` 执行 `is_active=0` 。

结果是：

- 若某个 tag\_code 只有一个默认版本：
	- 它找不到任何“版本更高的 e\_new”，不会被 JOIN 命中 → 默认行仍是 active=1。
- 若有多个默认版本：
	- 比如版本 1.0.0 / 1.0.1 / 1.0.2：
		- 1.0.0 会匹配 e\_new=1.0.1 和 1.0.2 → 置 0；
		- 1.0.1 会匹配 e\_new=1.0.2 → 置 0；
		- 1.0.2 找不到更高的 e\_new → 保持 1。

最重要的是：

- 非默认枚举行（ `is_default=0` ）永远不会出现在 e\_old 或 e\_new 条件中，因此完全不被这条 UPDATE 触发，保持为 1；
- 不需要 JOIN tag\_spec，不会“误选一部分版本”——谁是默认、谁版本更高，全在 tag\_enum 自身解决。

> 如果你想再保守一点，可以额外加上类型限制，只修 enum/bool 的默认行：

---

#### 三、步骤 2：快速自检（只看默认行的状态）

跑完之后，用这条 SQL 检查一眼：

你预期看到的 pattern：

- 对于多版本标签：
	- 较低版本的默认行： `is_active = 0`;
	- 最高版本的默认行： `is_active = 1`;
- 对于单版本标签：
	- 唯一默认行： `is_default=1 AND is_active=1` 。

非默认枚举行你可以另外查一眼确认基本都 still `is_active=1` ：

---

### 4）迭代日志

- **你刚刚的澄清**
	- 先全表 `is_active=1` 是对的；
	- 真正要决胜的不是“整个版本所有枚举”，而是：
		> 在每个 tag\_code 下，对 `is_default=1` 的这些记录，在多版本中只保留最新那条 active=1，旧版默认改为 0。
	- 上一轮“按 tag\_code + spec\_version”整批改 is\_active 的做法，会把当前版本下的非默认枚举行错误改为 0，这是你亲测发现的问题。
- **本轮结论**
	1. 决胜对象就是“每个 tag\_code 的默认行集合”，不动非默认枚举；
	2. 用自连接 `tag_enum e_old JOIN tag_enum e_new` ，只对“有更高版本默认行”的 e\_old 关 is\_active=0，可以稳定实现：
		- 单版本默认保留 1；
		- 多版本默认中只有最大版本保留 1。
	3. 不必再搞复杂的 tag\_spec JOIN 和多层子查询，逻辑足够清晰、可 audit。
- **下一步建议**
	1. 在测试库按顺序跑：
		- `UPDATE tag_enum SET is_active=1;`
		- 然后跑自连接 UPDATE（建议先不加 value\_type 限制，确认逻辑 OK 再加）；
	2. 用上面那两条自检 SELECT 看 brand\_level / brand\_name / service\_carwash\_type / sme\_supplier 等标签的 default 行是否符合预期；
	3. 如果验证通过，再加上类型限制（enum/bool）和备份流程，迁移到正式库执行。

你如果方便，把跑完后 `is_default=1` 那几行的结果再截一小段给我看，我可以帮你最后 sanity check 一轮，确认每个 tag\_code 只剩一条 active 默认。

这会对了,符合预期了.帮我把这个更新固化下来,一键产出.不要在做全局设置变更的逻辑,只改应该改的字段,改之前自动备份读取今天的日期做时间戳.写个查询给我

20251207\_2120\_tag\_enum默认版本拉齐\_一键SQL脚本\_v1

tags: #tag\_enum #is\_active #is\_default #版本决胜 #自动备份

---

### 1）一句话结论

给你一段「一次执行」的 SQL 脚本：

- 第一步：自动按今天日期创建 `tag_enum` 备份表（ `tag_enum_backup_YYYYMMDD` ）；
- 第二步：只对 `is_default=1` 的记录做版本决胜——在同一 `tag_code` 下，将所有“有更高版本默认行”的旧版默认行 `is_active` 置为 0，最新版本默认行保持 1；
- 非默认枚举（ `is_default=0` ）完全不动，没有任何全表型改动。

---

### 2）更新逻辑说明（确认一下我们已经对齐的规则）

我们现在固化的逻辑是：

1. 不再做任何「全表 is\_active 置 0 / 置 1」操作。
2. 只对 **默认枚举行** （ `is_default=1` ）做“版本唯一化”：
	- 同一个 `tag_code` 下，如果只有一个版本的默认行 → 保持 `is_active=1` ；
	- 如果有多个版本的默认行 → 只有“版本号最大”的那一条保持 `is_active=1` ，其余默认行 `is_active=0` 。
3. 非默认枚举行（ `is_default=0` ）无论版本多少，一律不动。

也就是：

> 「当前兜底值」= `tag_enum` 中满足 `tag_code = ? AND is_default = 1 AND is_active = 1` 的那一条；  
> 我们保证这个集合对每个 `tag_code` 至多一条。

---

### 3）一键执行 SQL 脚本（包含自动备份 + 精确 UPDATE）

下面这段就是你要的「一键产出」脚本，直接在 Navicat / 控制台里整段执行即可。

```sql
sql-- ==============================
-- Step 0：自动备份 tag_enum
-- 生成表名：tag_enum_backup_YYYYMMDD
-- ==============================

SET @suffix := DATE_FORMAT(CURDATE(), '%Y%m%d');
SET @backup_sql := CONCAT(
    'CREATE TABLE IF NOT EXISTS tag_enum_backup_',
    @suffix,
    ' AS SELECT * FROM tag_enum'
);

PREPARE stmt_backup FROM @backup_sql;
EXECUTE stmt_backup;
DEALLOCATE PREPARE stmt_backup;

-- 说明：
-- 1）每次执行会生成/复用当日的 tag_enum 备份表；
-- 2）如果当日已存在同名备份表，不会报错，会直接跳过建表步骤；
-- 3）需要完全回滚时，可以用：
--    DROP TABLE tag_enum;
--    ALTER TABLE tag_enum_backup_YYYYMMDD RENAME TO tag_enum;

-- ==============================
-- Step 1：版本决胜（只动默认行）
-- 规则：同一 tag_code 下，存在更高版本默认行的“旧版默认行” is_active 置为 0
--      最新版本默认行保持 is_active = 1
-- ==============================

UPDATE tag_enum e_old
JOIN tag_enum e_new
  ON e_old.tag_code   = e_new.tag_code
 AND e_old.is_default = 1
 AND e_new.is_default = 1
 -- e_new 是版本更高的默认行
 AND CAST(REPLACE(e_new.spec_version, '.', '') AS UNSIGNED)
       > CAST(REPLACE(e_old.spec_version, '.', '') AS UNSIGNED)
JOIN tag_spec s_old
  ON e_old.tag_code     = s_old.tag_code
 AND e_old.spec_version = s_old.spec_version
SET e_old.is_active = 0
WHERE s_old.value_type IN ('enum', 'bool')  -- 只管 enum/bool 标签
  AND e_old.is_active = 1;                  -- 只改原本是 1 的默认行

-- ==============================
-- Step 2：结果自检（可选，但强烈建议每次跑完看一眼）
-- 只看 is_default=1 的行，确认每个 tag_code 仅有最新版本 active=1
-- ==============================

SELECT
    tag_code,
    spec_version,
    enum_code,
    enum_label,
    is_default,
    is_active
FROM tag_enum
WHERE is_default = 1
ORDER BY tag_code,
         CAST(REPLACE(spec_version, '.', '') AS UNSIGNED);
```

---

### 4）迭代日志

- **你最新明确的要求**
	1. 不再接受任何“全局 is\_active 重置”的逻辑；
	2. 改之前必须自动备份一份 `tag_enum` ，备份表名带今天日期；
	3. 真正的版本决胜逻辑是：
		- 按 `tag_code` 维度，在 `is_default=1` 的记录里，只保留“最新版本”的那一条 `is_active=1` ；
		- 旧版本的默认行改为 `is_active=0` ；
		- 非默认枚举不改。
- **本轮固化的方案**
	- 用 `CREATE TABLE tag_enum_backup_YYYYMMDD AS SELECT *` 做简单可回滚备份；
	- 用 `tag_enum` 自连接实现“旧版默认行 is\_active 归 0”的精确 UPDATE；
	- 不再触碰非默认枚举、不做任何全表重置。
- **你后续可以怎么用**
	1. 每次新发一版标签规格（新增 spec\_version + enum 默认行）后，执行这一段脚本；
	2. 跑完看一下 Step 2 的自检 SELECT，确认每个 tag\_code 只有一个 `is_default=1 AND is_active=1` ；
	3. 将来再有新版本上线，直接复用这段脚本即可，不需要再重新设计逻辑。

如果你愿意，下一步我可以帮你把这段脚本包装成一个「操作说明」，直接发给数据同学：  
“每次新发标签版本 → 先跑这段 SQL → 就能保证默认兜底稳定”。

20251207\_2135\_tag\_enum默认值体检查询\_v1

tags: #tag\_enum #is\_default #is\_active #一致性巡检 #SQL查询

---

### 1）一句话结论

可以在原查询上加一个“每个 tag\_code 的激活默认条数 + 状态标记”，一眼就看出：哪个标签恰好 1 条激活默认值（OK）、哪个没有、哪个多条“超标”。

---

### 2）三段论据

1. 你的规则已经定死了： **全局要求是 `tag_code` 维度上， `is_default=1 AND is_active=1` 必须且仅有 1 条** 。
2. 检查逻辑就是：
	- 先按 `tag_code` 聚合，算出每个标签的 `active_default_cnt` ；
	- 再把这个计数回连到每一条 `is_default=1` 的记录上；
	- 用 `CASE` 派生一个状态字段（OK / 缺失 / 超标）。
3. 只用 SELECT，不做任何 UPDATE，也不做全表改动；你只是得到一张“体检报表”，看一眼就知道哪几个 tag 有问题。

---

### 3）思维导图结构（含 SQL 实现）

#### 一、详细视图：每一条默认行带“状态标记”

你现在的基础查询是：

在此基础上，加一个“每个 tag 的激活默认条数 + 状态字段”：

效果：

- 每一条 `is_default=1` 记录旁边都有：
	- `active_default_cnt` ：这个 tag\_code 当前“激活默认”有几条；
	- `status_flag` ：
		- `OK` → 这个标签整体是健康的；
		- `ERROR_NO_ACTIVE_DEFAULT` → 全局没有任何 `is_default=1 AND is_active=1` ；
		- `ERROR_MULTI_ACTIVE_DEFAULT` → 超出 1 条，需要你手动排查。

看输出时只要扫一眼 `status_flag` 列即可。

> 如果你想只看 enum/bool 标签，可以在子查询和外层都加上 JOIN tag\_spec + `WHERE s.value_type IN ('enum','bool')` 限制，这里先给你最通用版本。

---

#### 二、只看“有问题的 tag\_code”（报警列表）

如果你还想要一张“只列出有问题的标签”的简表，也可以用下面这个：

这张表就是你的“报警清单”：

- 没行 → 全部 OK；
- 有行 → 每一行一个问题 tag\_code，直接去上面那条“详细视图”里定位具体哪条记录错。

---

### 4）迭代日志

- **你最新的要求**
	- 不满足于只看 `is_default=1` 的明细，要有一个一眼可见的“是否符合预期”标记；
	- 规则是： `tag_code` 维度上 `is_default=1 AND is_active=1` 必须且仅有 1 条，多了/没了都要标红。
- **这次给出的内容**
	- 一个“详细体检查询”：在原明细基础上加上 `active_default_cnt + status_flag` ，一条行上就能看到自身是否处于健康/异常标签；
	- 一个“报警列表查询”：仅输出那些 `active_default_cnt <> 1` 的标签，方便你日常巡检。

后面你只要把这两条 SQL 固化到你自己的工具库里，每次跑完“拉齐脚本”之后，顺手跑一下这两个 SELECT，看 `status_flag` 是否全是 OK，就能快速判断有没有新坑。

那给我总结下本对话主要内容,萃取精华,我要存档.同时给出一个简短的上下游通知,告知大家兜底值的取值方法;

20251207\_2155\_tag\_enum兜底值治理精华总结\_v1

tags: #tag\_spec #tag\_enum #fallback兜底值 #is\_default\_is\_active #数据治理

---

### 1）一句话结论

本轮我们把“兜底值”的定义和落地口径彻底统一为： **只在 tag\_spec 定义兜底，在 tag\_enum 只维护枚举映射 + 默认标记，并通过 is\_default + is\_active 控制“当前唯一兜底值”的版本** ，同时配套了一键拉齐脚本和巡检 SQL，供后续稳定执行。

---

### 2）三段论据（现状与问题 → 关键洞察 → 路径方案）

**论据一：现状与问题——兜底值多源、多版本，容易错位**

- 字典表分工：
	- `tag_spec` ：标签“规格定义表”，包含 `value_type` / `fallback` / 有效期 / 置信度衰减等，是兜底值唯一“定义点”；
	- `tag_enum` ：标签“枚举值域表”，包含 `enum_code` / `enum_label` / `is_default` / 匹配配置等，是兜底值的“枚举落地点”；
	- `tag_catalog` ：标签“目录与责任表”，管分类、P0 标记、owner 等。
- 早期问题：
	- 有些标签在 `tag_spec.fallback` 已定义兜底，但 `tag_enum` 中没有对应枚举，或者没有打 `is_default=1` ；
	- 有的标签有多个 `spec_version` ， `tag_enum` 里各个版本都有 `is_default=1` ，下游按 `tag_code + is_default=1` 查默认值会拿到多条；
	- 一度尝试用 `is_active` 做“版本决胜”，但曾出现“全表 is\_active 重置”这类高风险方案，容易误伤正常枚举。

**论据二：关键洞察——定义点唯一，默认值“只做版本决胜，不动其他枚举”**

- 兜底定义的 **单一来源** ：
	- 统一约定：兜底值只在 `tag_spec.fallback` 定义（包括 enum / bool / string），不在 `tag_enum` 手工维护“兜底 code”；
	- `tag_enum` 只负责：
		- 兜底枚举行必须存在（ `enum_code = fallback` ）；
		- 兜底枚举行必须打上 `is_default = 1` ；
		- 非兜底枚举的 `is_default = 0` 。
- 多版本标签只需要对“默认行”做版本唯一化：
	- 真正需要“全局唯一”的只有： **每个 tag\_code 的“当前默认枚举”** ；
	- 决策对象是： `tag_enum` 中 `is_default=1` 的那些行，而不是整个版本的所有枚举；
	- 规则：
		- 一个 tag\_code 可以有多版默认值，但最终“当前兜底”只能有 1 条： `is_default=1 AND is_active=1` ；
		- 同一个 tag\_code 下，如果存在更高版本默认行，则旧版本默认行的 `is_active` 应被关掉（置为 0）；
		- 非默认枚举行（ `is_default=0` ）在任何版本下都不参与版本决胜，不应被误改。

**论据三：路径方案——“定义在 spec，映射在 enum，控制在 is\_default+is\_active”**

- 对齐与修复：
	- 仅对 `value_type IN ('enum','bool')` 的标签做兜底拉齐，避免影响 string 类型；
	- 用 SQL 插入缺失的兜底枚举（ `enum_code = fallback` ）并设 `is_default=1` ；
	- 用 UPDATE 以 `(tag_code, spec_version, enum_code)` 维度拉齐 `is_default` ，确保“谁 = fallback，谁是 default”。
- 版本唯一化（最终方案）：
	- 不再做任何“全表 is\_active 重置”；
	- 一键脚本逻辑：  
		1）自动按当日日期备份 `tag_enum` 为 `tag_enum_backup_YYYYMMDD` ；  
		2）在 `tag_enum` 内自连接：
		- 以 `tag_code` 分组，选择所有 `is_default=1` 的行；
		- 如果存在 `spec_version_new > spec_version_old` 的默认行，则将 `old` 行 `is_active=0` ；
		- 最新版本默认行由于不存在更高版本，不被命中，保持 `is_active=1` ；
		- 非默认枚举（ `is_default=0` ）不参与 JOIN，不被修改。
- 巡检与告警：
	- 定义“体检查询”：按 `tag_code` 统计 `is_default=1 AND is_active=1` 的条数 `active_default_cnt` ，
		- `=1` → OK；
		- `=0` → ERROR\_NO\_ACTIVE\_DEFAULT（缺兜底）；
		- `>1` → ERROR\_MULTI\_ACTIVE\_DEFAULT（多兜底）；
	- 只看 `active_default_cnt <> 1` 的标签，作为报警清单。

---

### 3）思维导图结构（文本分层）

**3.1 三张字典表的最终定位**

1. `tag_spec` （规格定义）
	- 关键字段： `tag_code`, `spec_version`, `value_type`, `fallback`, `effective_from/to`, `value_type_connect`
	- 职责：
		- 定义“标签是什么”（类型 / 含义 / TTL / 衰减）；
		- 定义“兜底是什么”（ `fallback` ），是兜底的唯一“权威定义点”。
2. `tag_enum` （枚举与默认值）
	- 关键字段： `tag_code`, `spec_version`, `enum_code`, `enum_label`, `is_default`, `is_active`, 匹配相关字段
	- 职责：
		- 定义“标签能取哪些枚举值”（值域）；
		- 对应兜底：必须存在 `enum_code = fallback` 且 `is_default=1` 的行；
		- 通过 `is_active` 控制：
			- 哪些枚举当前可用；
			- 哪一个版本的默认值是“当前兜底”。
3. `tag_catalog` （目录与责任）
	- 关键字段： `tag_code`, `tier1/2/3`, `tag_class`, `owner_biz`, `owner_data`, `is_p0`, `status`
	- 职责：
		- 做标签的归类、优先级标记和责任人分配；
		- 不参与兜底值计算。

---

**3.2 兜底拉齐规则（核心约束）**

1. 兜底定义：
	- 所有标签兜底只在 `tag_spec.fallback` 定义；
	- 不允许在 enum 层“另起炉灶”写兜底常量。
2. 兜底枚举存在性：
	- 对 `value_type in ('enum','bool')` 的标签：
		- 必须在 `tag_enum` 出现 `enum_code=fallback` 的枚举行；
		- 该行 `is_default=1` ；
		- 同一 `(tag_code, spec_version)` 下其他枚举 `is_default=0` 。
3. 版本唯一化（默认行）：
	- 对每个 `tag_code` ：
		- 在 `tag_enum` 中， `is_default=1 AND is_active=1` 全局最多 1 条；
		- 若存在多个版本的默认行：
			- 版本号最高的那条 `is_active=1` ；
			- 旧版本默认行 `is_active=0` 。
	- 非默认枚举行 `is_default=0` 不参与“版本决胜”，只依赖业务需要单独调整 `is_active` 。

---

**3.3 一键拉齐脚本（固化的执行步骤）**

1. 自动备份
1. 只对旧版本默认行做 is\_active=0
1. 体检查询（全量视角 + 状态标记）
1. 报警清单（只看有问题的 tag\_code）

---

**3.4 给上下游的简短通知文案（可直接复制发群）**

> 标题：标签兜底值取值规范更新说明（tag\_spec / tag\_enum）
> 
> 各位同学，
> 
> 为避免“兜底值”多版本、多来源导致的取值混乱，我们统一了兜底值的定义与使用规范，请后续严格按以下规则取值：
> 
> 1）兜底值定义来源
> 
> - 所有标签的兜底值只在 `tag_spec.fallback` 定义。
> - `tag_enum` 只负责提供枚举值及默认标记，不再单独约定兜底常量。
> 
> 2）当前“有效兜底值”的取值方式（给下游用）
> 
> - 任意标签当前版本的默认枚举（兜底值），请统一按以下条件从 `tag_enum` 读取：
> - 我们保证：
> 	- 每个 tag\_code 在全局范围内， `is_default=1 AND is_active=1` 至多一条；
> 	- 如存在历史版本默认值，已通过后台脚本统一置为 `is_active=0` 。
> 
> 3）注意事项
> 
> - 仅对 `value_type IN ('enum','bool')` 的标签执行兜底版本管理，string 类型按 `tag_spec.fallback` 直接兜底。
> - 如发现某标签没有任何 `is_default=1 AND is_active=1` 记录，请反馈给数据侧，我们会优先排查。
> 
> 后续若有兜底规则调整或新版本发布，我们会通过相同规则和脚本自动对齐，无需下游改代码逻辑。

---

### 4）迭代日志

- **来源**
	- 多轮 SQL 实验与对齐，包括：
		- `tag_spec` / `tag_enum` / `tag_catalog` 三表职责梳理；
		- fallback 存在性检测（是否在 enum 中有对应枚举）；
		- is\_default 拉齐；
		- 多版本默认值的 is\_active 决胜逻辑多轮修正。
- **关键结论**
	1. 兜底定义必须“只在 spec 一处维护”，enum 只做映射，不再双写含义；
	2. 版本问题只需要在“默认行集合”上解决，不能搞全表 is\_active 重置；
	3. 通过“自动备份 + 精确 UPDATE + 巡检查询”，构建了一套可复用的兜底治理工作流。
- **本轮改动点**
	- 明确 `tag_spec.fallback` 为兜底唯一定义点；
	- 为 enum/bool 标签补齐兜底枚举并拉齐 is\_default；
	- 设计并落定：
		- 自动备份脚本（tag\_enum\_backup\_YYYYMMDD）；
		- 仅对旧版本默认行做 is\_active=0 的 UPDATE；
		- 全局体检及报警 SQL；
	- 给上下游沉淀了统一的“兜底取值规范文案”。
- **待补充 / 下一步建议**
	1. 在内部 wiki 建一页《标签兜底值规范与运维手册》，包含：表结构说明、兜底规则、脚本、巡检 SQL；
	2. 将“兜底拉齐脚本 + 体检脚本”纳入固定运维流程（例如新 spec 上线后或月度巡检时执行）；
	3. 后续如引入新标签类型或更复杂 fallback（例如多段规则），需在引入前评估是否仍适配这套机制，必要时扩展一版新的规范。

你后面如果要把这一套沉淀到项目文档，我们可以在这个总结基础上再压缩一页“评审版 PPT/一页纸”，专门给老板和数据侧做对齐。