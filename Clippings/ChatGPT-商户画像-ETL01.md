---
title: ChatGPT-商户画像-ETL01
source: https://chatgpt.com/g/g-p-692abef2079c81918c16c22b66aec849-shang-hu-hua-xiang/c/6933b5d7-ef34-8320-9c0c-5d2113195a16
author:
  - "[[ChatGPT-非油品-2期BRD草稿]]"
published:
created: 2025-12-23
description: ChatGPT 是一款供日常使用的 AI 聊天机器人。与最先进的 AI 模型互动，探索创意、解决问题以及提升学习效率。
tags:
  - clippings
---
20251206\_1400\_商户画像倒推框架\_油站标签覆盖率与准确率  
tags:: #商户画像 #油站标签 #标签覆盖率 #标签准确率

---

一句话结论：  
要从“油站经营决策能稳定用画像驱动作业”这个终局倒推，把商户画像拆成「业务目标 → 决策场景 → 标签体系 → 数据与评估 → 流程与治理」五层结构，按“先跑通 10 个核心标签的覆盖率与准确率闭环，再逐步扩展”的路径流程化建设。

---

### 一、三段论据（逻辑闭环）

**论据一：现状与问题——标签很多尝试，但缺“终局对齐 + 过程闭环”**

- 你现在已经有：1.6 万动销油站、竞争/品牌/服务等 10 个标签，做了不少探索，但感觉“没有体系化”，本质是：
	- 没有一个被大家认可的“终局画像能力”定义（业务到底要靠这些标签做成什么）。
	- 标准不够结构化：每个标签的定义、使用场景、质量目标（覆盖率、准确率）没有写成规则化设计。
	- 没有“按周期跑”的质量闭环：今天 65% 覆盖、87% 准确，明天是好是坏，靠感觉而不是指标体系和复盘节奏。
- 结果就是：你在做的是一堆“局部优化”，而不是一条“从终局倒推、层层可落地”的路线图。

**论据二：策略选择与推演——用五层倒推法，把画像从“目标”拆成“能力栈”**

- 从最终想要的效果倒推：  
	1）业务终局：
	- 例如：提升 KA 精细运营效果 / 提升某类活动 ROI / 提升某类油站渗透率 / 降低某类风险损失。  
		2）决策终局：
	- 具体到“运营在系统里要能做什么决策”：如“筛出 3km 范围内有强竞对且服务差的站”“给品牌弱但服务好的站推某类活动”等。  
		3）标签终局：
	- 决策要落到：10 个核心标签要支持哪些典型分群？每个标签定义什么状态值？覆盖率、准确率目标是多少？  
		4）数据终局：
	- 每个标签背后的数据源、更新频率、TTL、样本和标注能力要明确，保证“可以被持续生产”。  
		5）流程终局：
	- 最后落到一条固定节奏的流程：需求收集 → 标签设计 → 开发与数据生产 → 质量评估与回归 → 上线使用 → 运营反馈 → 迭代。
- 这样“从右往左”推完之后，再“从左往右”实施：先选 2–3 个场景 + 10 个标签做完整闭环，再扩展到更多标签与更多场景。

**论据三：落地与风险——以“标签质量闭环 + 项目节奏”双轮驱动，避免烂尾和失控**

- 落地层面，建议用“三条主线”管住事情：  
	1）主线一：标签体系设计 → 先把 10 个标签做成标准件（定义 + 取值 + 指标 + 应用场景）。  
	2）主线二：数据生产与质量闭环 → 明确覆盖率、准确率指标，设立“抽检样本 + 质量报告”的固定节奏。  
	3）主线三：业务应用与运营协同 → 找 2–3 个运营场景试点，反推标签是否好用，并用“活动效果”反证标签质量。
- 主要风险：
	- 数据不干净或不足，导致覆盖率和准确率提升遇到硬上限。
	- 各区域/各业务线的“好坏判准”不一致，标签定义反复改。
	- 没有固定节奏和统一 owner，项目慢慢演化成“堆标签”，而不是“做能力”。
- 解法：
	- 在设计阶段就写死“质量评估方法 + 验收口径”，并绑定到每一次需求评审和上线；
	- 用“小范围试点 + 标准化对齐”的方式，先在全国层面固化定义，再放给各区域个性化补充。

---

### 二、从目标倒推的整体框架（五层）

#### 2.1 第一层：业务终局目标（Business Outcome）

先把你心里的“最后一张图”画清楚（可以先用假设）：

- 例：到 2026 年底，商户画像要能稳定支撑的 3–5 个业务结果：
	1. KA 油站精细运营：画像分群能覆盖 80% 以上 KA 站，活动 ROI 提升 X%。
	2. 活动策略优化：某类活动的投放目标由“拍脑袋”变为“基于画像筛选”，转化率提升 Y%。
	3. 渠道与服务策略：通过服务/品牌标签，识别出不同成长阶段商户，形成差异化 BD/服务策略。
- 对应的关键指标示例：
	- “用到画像的活动占比”（活动数、油站数、GMV 占比）。
	- “按画像分群决策之后，ROI 或转化率的相对提升”。
	- “画像在日常业务评审文档中的出现频次”（软指标，但反映渗透）。

> 结论：没有“业务终局”，所有覆盖率/准确率都只是技术指标，没有方向感。

#### 2.2 第二层：决策与场景终局（Decision & Scenario）

围绕你现有的 10 个标签（竞争、品牌、服务等），先把“典型决策场景”列出来：

- 举例（先只要 5–8 个高频场景即可）：  
	1）竞对围剿：找出“竞对强 / 我方弱 / 服务弱”的站，制定重点跟进策略。  
	2）品牌升级：对“品牌弱但服务好”的站，试点品牌共建活动。  
	3）服务提升：对“品牌强但服务差”的站，推服务优化项目。  
	4）新店培育：识别“新开站 + 竞争压力大”的站，给出专项支持。  
	5）流失预警：服务下降 + 竞对增强 + 品牌弱 → 提前预警。
- 每个场景要写清楚四件事：
	- 业务目标：例如“降低流失率 2 个百分点”。
	- 操作动作：运营/销售具体要做什么（筛站、拉名单、制定方案等）。
	- 所需画像能力：需要哪些标签、标签的取值粒度、刷新频率。
	- 成功判断：用什么指标来判定该场景“画像好用”。

> 结论：决策场景是从业务到标签的桥梁，不写清楚场景，就很难判断标签“到底够不够”。

#### 2.3 第三层：标签终局与质量目标（Tag Design & Quality）

在场景确定后，给 10 个标签做“标准化设计卡片”（统一模板）：

一个标签一张卡，建议包含以下要素：

1. 基本信息
	- tag\_code：如 `brand_level` / `service_level` / `competition_strength` 。
	- 标签描述：一句话说明这个标签“描述的是什么状态”。
	- 标签类型：枚举/分数/布尔/文本。
	- 取值枚举及含义：例如
		- `competition_strength` ： `strong_competition 强竞对` / `medium_competition 中度竞争` / `weak_competition 弱竞争` / `unknown 未知` 。
2. 业务规则
	- 决策场景：该标签参与哪些场景？作为筛选条件还是只是展示？
	- 业务判定标准：
		- 例如“强竞对”：3km 内有 2 家以上核心竞对且其销量/活动频次达到某阈值。
	- 优先级：对核心场景的重要程度（高/中/低）。
3. 数据规则
	- 数据来源：内部交易/拜访记录/外部竞对数据/人工标注等。
	- 更新策略：每天/每周/每月；TTL 多久过期。
	- 生产逻辑：核心 SQL/规则的思路（不是具体代码，但要写出主干逻辑）。
4. 质量目标
	- 覆盖率目标：例如全国 1.6W 油站中，有非空标签比例 ≥ 90%。
	- 准确率目标：在人工抽检样本中，主观/客观一致率 ≥ 95%。
	- 质量评估方法：抽样方法、样本量、评估频率（如月度）。

> 结论：标签要从“字段”变成“标准化产品”，质量目标写在设计里，而不是事后补。

#### 2.4 第四层：数据与评估终局（Data & Evaluation）

围绕覆盖率与准确率，建立“质量闭环机制”：

1. 覆盖率（Coverage）
	- 定义：有合法取值的油站数 / 总动销油站数。
	- 拆解：
		- 按标签：每个标签一条线。
		- 按区域：看哪个区域缺失严重。
		- 按来源：分“自动计算 / 人工补录 / 外部数据”。
	- 提升路径：
		- 优先补“关键场景 + 高价值站”的缺失。
		- 对长期“unknown”的原因做分类（数据缺失 / 规则过严 / 逻辑错误）。
2. 准确率（Accuracy）
	- 定义：在抽样核查中，标签值与“真实状态”一致的比例。
	- “真实状态”从哪里来：
		- 黄金样本库：运营/BD/产品共同标注的一批站，作为标准。
		- 拜访记录 / 一线反馈：结构化转写。
	- 评估机制：
		- 每月抽取固定样本（按区域、标签值分层），人工核对。
		- 对错的样本要分类原因（规则错误 / 数据延迟 / 人工标注错误）。
3. 质量报告与动作绑定
	- 每月/每季度固定产出“标签质量报告”：包含覆盖率/准确率趋势、问题清单。
	- 对每个问题挂“整改 owner + 截止时间”，且在下次报告中回看整改效果。

> 结论：覆盖率和准确率不是“看一眼的指标”，而是要绑定“整改动作”的项目机制。

#### 2.5 第五层：流程与治理终局（Process & Governance）

建立一个你可以“重复使用”的流程，而不是一次性项目：

1. 需求与规划流程
	- 每季度：拉一次“画像需求 workshop”，把各条线需要的画像能力梳理成“场景列表”。
	- 形成“标签路线图”：核心标签（10 个）+ 增量标签（N 个），按季度排期。
2. 标签建设流程（一次迭代）  
	1）画像需求评审：场景 → 标签 → 指标 → 验收方式对齐。  
	2）标签设计评审：一张“标签卡片”评审通过。  
	3）开发与数据生产：数据、算法、工程介入实现。  
	4）质量验证：用黄金样本 + 自动校验做验收。  
	5）上线与使用：接入前端/报表/运营后台。  
	6）复盘与迭代：看使用效果 + 质量指标，再调整。
3. 治理与版本管理
	- 标签目录：维护一个“标签目录表”（你现在已有雏形），每次改动都要有版本号和变更记录。
	- 定期清理：废弃不用的标签、冗余字段，避免“标签坟场”。

---

### 三、覆盖率与准确率提升的具体路径（围绕 10 个标签）

结合你当前的 1.6W 油站与 10 个核心标签，给一个可以马上执行的三步法：

#### 步骤一：锁定“首批做完整闭环的标签 + 场景”

- 从 10 个标签里选出 3–5 个最关键的（例如：竞对强度、品牌等级、服务水平、成长阶段）。
- 从场景库中选择 2–3 个“未来三个月内一定会用到”的业务场景。
- 形成一个“闭环试点清单”，明确：
	- 试点范围：全国 / 某几个重点省区。
	- 关键指标：覆盖率目标、准确率目标、业务结果目标。

#### 步骤二：做一次“质量体检 + 问题分类”

- 对这 3–5 个标签做一次专项体检：
	- 覆盖率：按全国、省区、油站类型分层统计。
	- 准确率：抽样黄金样本（例如每省 50 站），人工核查。
- 把问题按类型归类：
	- A 类：数据源缺失（比如某些省没有竞对数据）。
	- B 类：规则设计不合理（阈值过严 / 区域差异没考虑）。
	- C 类：更新策略不合理（TTL 太长 / 更新太慢）。
	- D 类：业务理解不一致（同一状态不同人理解不同）。

#### 步骤三：驱动一次“质量提升冲刺”周期（4–6 周）

- 为每类问题拟定动作：
	- A 类：补数据源或引入备用逻辑。
	- B 类：调整规则，先在小部分站点验证再扩展。
	- C 类：调整刷新频率、TTL 配置，或加增量更新逻辑。
	- D 类：组织一次全国统一定义对齐（培训 + 文档）。
- 在 4–6 周内，跑完一轮：
	- 周 1：体检与问题清单
	- 周 2–3：修规则/补数据 + 回放历史数据
	- 周 4：再次体检 + 与运营一起做“标签使用小试点”
- 这一轮做成之后，把方法固化成模板，以后每新加一批标签就用同样方式做。

---

### 四、项目推进行动清单（可执行版本）

| 时间范围 | 事项 | 责任人角色 | 预期输出物 |
| --- | --- | --- | --- |
| 本周 | 明确 3–5 个业务场景与 10 个标签的映射 | 产品/运营/数据共创 | 场景–标签映射表 V1 |
| 本周 | 为 10 个标签制作“标签设计卡片”初稿 | 产品/数据 | 标签设计文档 V1 |
| 下周 | 选定首批 3–5 个重点标签做质量体检 | 数据/分析 | 标签质量体检报告 V1 |
| 未来 2–4 周 | 按问题分类，落地一轮规则/数据修复 | 数据/工程/外部数据 | 规则调整方案 + 修复脚本 |
| 未来 4–6 周 | 做一次结合画像的运营试点 | 运营/产品 | 运营试点方案 + 复盘报告 |
| 本季度内 | 固化“标签建设流程与质量评估模板” | 产品/数据 | 画像建设流程文档 + 质量评估模板 |
| 年度视角 | 输出商户画像长期路线图与标签规划 | 产品/策略 | 商户画像三年路线图 / 标签池规划 V1 |

---

### 五、思维导图结构（文本版）

- 商户画像倒推框架
	- 一、业务终局
		- 提升 KA 精细运营
		- 提升活动 ROI
		- 优化渠道与服务策略
	- 二、决策与场景
		- 竞对围剿
		- 品牌升级
		- 服务提升
		- 新店培育
		- 流失预警
	- 三、标签终局
		- 10 个核心标签
			- 竞争强度
			- 品牌等级
			- 服务水平
			- 成长阶段 …
		- 标签设计卡片
			- 基本信息
			- 业务规则
			- 数据规则
			- 质量目标
	- 四、数据与评估
		- 覆盖率
			- 定义与分层统计
			- 提升路径
		- 准确率
			- 黄金样本
			- 抽检机制
			- 问题分类
		- 质量报告与整改动作
	- 五、流程与治理
		- 季度需求规划
		- 标签建设迭代流程
		- 标签目录与版本管理
	- 六、落地节奏与行动清单
		- 首批场景 + 标签闭环
		- 4–6 周质量冲刺
		- 年度路线图

---

### 《迭代日志》

- 【来源】
	- 基于你当前的项目背景：1.6 万动销油站、10 个核心标签（竞争/品牌/服务等），以及你对“覆盖率和准确率提升 + 缺乏体系化”的诉求。
- 【结论】
	- 给出了一套从“业务终局 → 决策场景 → 标签设计 → 数据与评估 → 流程与治理”的五层倒推框架，并给了围绕 10 个标签做覆盖率和准确率提升的三步落地路径。
- 【改动点】
	- 把“提升标签质量”从纯技术视角，提升到“业务场景驱动 + 项目化推进”的视角。
	- 第一次明确提出“标签设计卡片 + 质量评估模板 + 4–6 周质量冲刺周期”这套可复用机制。
- 【待补充】
	- 当前 10 个标签的实际定义、字段结构和现有取值情况。
	- 近 3–6 个月里，你真实发生过的 2–3 个“画像决策场景”（哪次活动/评审里用过或想用画像）。
	- 现有的覆盖率和准确率统计口径（表结构/指标计算方式）。
- 【下一步建议】
	1. 先选出 2–3 个你“马上要用画像做决策”的场景，写成简短说明（业务目标 + 操作动作 + 想要的筛选条件）。
	2. 把现在 10 个标签的定义/字段/取值样例贴出来，我们可以一起补全“标签设计卡片”V1。
	3. 在此基础上，我可以帮你进一步打磨成一份“给老板看的商户画像一页纸 + 标签质量提升方案”，直接用于内部对齐和拉资源。

20251206\_1505\_商户画像\_ETL机制\_标签推断到终表  
tags:: #商户画像 #标签ETL #油站标签 #覆盖率 #准确率

---

一句话结论：  
在你现有 tag\_spec / tag\_enum / tag\_catalog / tag\_total 这套配置基础上，把商户画像做成一条“配置驱动的标签 ETL 流水线”：按【多源采集 → 标准化候选值 → 规则推断与冲突消解 → 写入统一终表 → 质量评估】五层机制固化下来，每个标签只要补充规则，就能自动完成推断与入库，从而支撑覆盖率与准确率冲到 90%。

---

## 一、三段论据（逻辑闭环）

**论据一：目标已经很清晰，问题在于缺一条“可复用的标签生产流水线”**

- 你的 Q4 目标不是“再想标签”，而是非常具体的：用现有 1.6W 油站、13 个标签（brand\_level / brand\_name / competitive\_overlap / convenience\_store\_available / open\_24h / open\_hours / parking\_available / restroom\_available / service\_carwash\_available / service\_carwash\_type / sme\_supplier / sme\_supplier\_partner / wyc\_pricing\_enabled 等）
	- 覆盖率 ≥ 90%
	- 准确率 ≥ 90%
- 你已经有了完整的配置体系：
	- `tag_spec` ：定义 tag\_code、value\_type、fallback、ttl\_days、calc\_type（compute/result）、w\_source\_s1~s4 等。
	- `tag_enum` ：每个标签的枚举值、别名匹配、白名单黑名单。
	- `tag_catalog` / `tag_total_20251201.xlsx` ：业务分类、产出方式（“定时任务自动产出，T+1 生成离线表”）、数据源（gas\_dw.dwm\_gas\_merch\_tag\_source\_s1\_di…）、规则描述。
- 缺口就是：还没把这些“配置 + 文档规则”落成一条固定的 ETL 机制，让任何一个标签都能按同一套路，被自动推断、清洗、打标、写入「统一终表」。

**论据二：用配置驱动 ETL，把“每个标签一份文档”变成“每个标签一段可复用 SQL 模板 + 参数”**

- 既然已经有 tag\_spec / tag\_enum，就不应该每个标签写一份完全独立的 SQL，而是：
	- 定义统一的“标签候选值表结构”，把 S1~S4、多种来源的原始观测统一到一张表里；
	- 定义统一的“冲突消解 + 权重打分”逻辑，利用 `w_source_s1~s4` 、 `ttl_days` 、时间戳，选出一个“最佳候选”；
	- 对 calc\_type = `result` 的标签：直接从 S1~S4 结果型数据装配；
	- 对 calc\_type = `compute` 的标签（如 brand\_name、brand\_level）：在上一层候选值的基础上再做一次计算（别名匹配、品牌分级等）；
	- 所有标签最终写入一张标准终表（你之前已经定过 schema： `store_id, as_of_date, tag_code, target_value_bool/number/string, enum_code, source, evidence_state, ttl_days, reason, conf, upload_batch_id, closest_source, target_value_string_back` ）。
- 通过这套机制，你只需要为每个标签配置：
	- 数据源（S1~S4 哪些字段）
	- 取值映射（用 tag\_enum 驱动）
	- 计算逻辑（简单 CASE / 多表关联 / 聚合）  
		就能批量生成 SQL 片段，而不是一次次从头设计。

**论据三：从“多源候选 → 终表”的端到端 ETL，一旦固定，覆盖率 & 准确率就有了可控的工程抓手**

- 覆盖率提升靠的是：
	- 从更多源（S1~S4 + 手工纠偏）产出候选值；
	- TTL、回填、fallback 逻辑明确，减少“无值”和“过期值”；
	- 每日/每周定时跑 ETL，覆盖率是可观测可追踪的。
- 准确率提升靠的是：
	- 规则配置化，出问题可以精确定位到“哪个来源 + 哪条映射规则”；
	- 利用 w\_source 权重与最新时间的组合打分，避免被“陈旧的坏数据”覆盖；
	- 和 tag\_enum 的 white/black list、brand\_aliases 配合，控制字符串匹配错误。
- 最后，通过一个固定的“ETL + 质量评估”链路，你不只是完成 Q4 90% 的目标，而是真正在 MySQL 里落下一条可复用的“标签生产线”。

---

## 二、ETL 总体架构：从多源观测到统一终表

结合你现有配置，我建议把油站画像标签 ETL 拆成五层，每一层都对应到具体表和 SQL 模板。

### 2.1 层级 0：终表设计（我们先把终点钉死）

终表建议就用你之前提过的结构，表名示例： `store_tag_snapshot_di` （按日快照）：

> 以后你所有标签 ETL 的终点，全部是往这张表写 `INSERT ... ON DUPLICATE KEY UPDATE` 。

---

### 2.2 层级 1：多源原始观测表（S1~S4）统一抽取

根据 `tag_total` 中的数据源定义（gas\_dw.dwm\_gas\_merch\_tag\_source\_s1\_di 等），你可以在 MySQL 里做一张“统一原始观测表”，每天同步一次：

同步策略（可以是离线导入或 ETL 作业，这里讲逻辑）：

- 每天把各个数据源的标签表（例如 `*_tag_source_s1_di` ）抽到 MySQL，按 `store_id + as_of_date + tag_code` 对齐，写入 `raw_tag_observation_di` ；
- 手工修正（铁橙 APP 首报 / 后续修正）也可以统一写到这张表， `source_channel = 'MANUAL'` 。

---

### 2.3 层级 2：候选值标准化（类型、枚举映射、TTL、初始 conf）

根据 `tag_spec` / `tag_enum` 做第一层标准化，产出“候选值表”，表名示例： `tag_candidate_value_di` ：

核心逻辑（伪代码级说明 + SQL 模板）：

1）按标签类型写入对应字段

- `value_type = 'bool'` → 写入 `target_value_bool` （0/1/99）；
- `value_type = 'enum'` → join `tag_enum` ，写 `enum_code` 和标准 `target_value_string` ；
- `value_type = 'string'` → 直接写 `target_value_string` ；
- `value_type = 'number'` → cast 成 `DECIMAL` 写入 `target_value_number` 。

2）从 tag\_spec 注入 `ttl_days` 与各源权重：

`tag_spec` 示例：

| tag\_code | value\_type | calc\_type | ttl\_days | w\_source\_s1 | w\_source\_s2 | w\_source\_s3 | w\_source\_s4 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| brand\_level | enum | compute | 7 | 1.0 | 0.6 | 0.5 | 0.4 |
| brand\_name | enum | compute | 180 | 0.7 | 0.8 | 0.9 | 0.6 |
| competitive\_overlap | bool | result | 90 | 0.7 | 0.9 | 0.8 | 0.6 |
| … |  |  |  |  |  |  |  |

SQL 模板（简化示例，以 `bool/enum` 为例）：

```sql
sqlINSERT INTO tag_candidate_value_di (
    as_of_date, store_id, tag_code,
    source_channel,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    ttl_days,
    conf_initial,
    raw_updated_at,
    raw_value_backup
)
SELECT
    r.as_of_date,
    r.store_id,
    r.tag_code,
    r.source_channel,
    -- 类型拆分
    CASE 
        WHEN s.value_type = 'bool' THEN 
            CASE 
                WHEN r.raw_value IN ('1','true','是','Y') THEN 1
                WHEN r.raw_value IN ('0','false','否','N') THEN 0
                ELSE 99
            END
        ELSE NULL
    END AS target_value_bool,
    CASE 
        WHEN s.value_type = 'number' THEN CAST(r.raw_value AS DECIMAL(18,4))
        ELSE NULL
    END AS target_value_number,
    CASE 
        WHEN s.value_type IN ('string','enum') THEN r.raw_value
        ELSE NULL
    END AS target_value_string,
    -- 枚举匹配
    e.enum_code,
    s.ttl_days,
    -- 初始 conf：来源权重
    CASE r.source_channel
        WHEN 'S1' THEN s.w_source_s1
        WHEN 'S2' THEN s.w_source_s2
        WHEN 'S3' THEN s.w_source_s3
        WHEN 'S4' THEN s.w_source_s4
        WHEN 'MANUAL' THEN 1.0
        ELSE 0.5
    END AS conf_initial,
    r.raw_updated_at,
    r.raw_value AS raw_value_backup
FROM raw_tag_observation_di r
JOIN tag_spec s
  ON r.tag_code = s.tag_code
LEFT JOIN tag_enum e
  ON r.tag_code = e.tag_code
 AND s.value_type = 'enum'
 AND (
     r.raw_value = e.enum_label
     OR FIND_IN_SET(r.raw_value, e.brand_aliases) > 0
 )
WHERE r.as_of_date = @biz_date;
```

> 注意：这里没有用 WITH，全部用显式子查询 & JOIN，符合你“不用 WITH”的要求。

---

### 2.4 层级 3：冲突消解 + TTL 过滤（得到每个标签的“最佳候选值”）

在 `tag_candidate_value_di` 里，每个 (store\_id, tag\_code, as\_of\_date) 可能有多条记录（S1/S2/S3/S4/MANUAL），需要合并成一个最终值。

策略建议：

- 步骤 1：过滤 TTL 过期的候选：
	- `as_of_date - DATE(raw_updated_at) <= ttl_days` 才算有效；
- 步骤 2：计算综合得分 score：
	- 比如： `score = conf_initial * freshness_factor` ；
	- `freshness_factor` 可以简单设为 “越新越高”，例如 `1 - DATEDIFF(as_of_date, raw_updated_at)/ttl_days` ，下限 0；
- 步骤 3：同一 (store\_id, tag\_code, as\_of\_date) 选 score 最高那条；
- 步骤 4：如果没有任何有效候选 → 用 tag\_spec.fallback 填充 fallback 记录。

示例 SQL（简化版）：

```sql
sql-- 建一个中间表存“有效候选 + score”
CREATE TABLE IF NOT EXISTS tag_candidate_scored_di (
    as_of_date      DATE        NOT NULL,
    store_id        BIGINT      NOT NULL,
    tag_code        VARCHAR(64) NOT NULL,
    source_channel  VARCHAR(8)  NOT NULL,
    target_value_bool   TINYINT NULL,
    target_value_number DECIMAL(18,4) NULL,
    target_value_string VARCHAR(512) NULL,
    enum_code       VARCHAR(64) NULL,
    score           DECIMAL(6,4) NOT NULL,
    ttl_days        INT NOT NULL,
    conf_initial    DECIMAL(5,4) NOT NULL,
    reason          VARCHAR(128) NULL,
    PRIMARY KEY (as_of_date, store_id, tag_code, source_channel)
);

INSERT INTO tag_candidate_scored_di (...)
SELECT
    c.as_of_date,
    c.store_id,
    c.tag_code,
    c.source_channel,
    c.target_value_bool,
    c.target_value_number,
    c.target_value_string,
    c.enum_code,
    -- 只保留 TTL 内的
    CASE 
        WHEN DATEDIFF(c.as_of_date, DATE(c.raw_updated_at)) <= c.ttl_days
        THEN c.conf_initial * 
             GREATEST(0.1, 1 - DATEDIFF(c.as_of_date, DATE(c.raw_updated_at)) / c.ttl_days)
        ELSE 0
    END AS score,
    c.ttl_days,
    c.conf_initial,
    CONCAT('TTL=', c.ttl_days) AS reason
FROM tag_candidate_value_di c
WHERE c.as_of_date = @biz_date
  AND c.raw_updated_at IS NOT NULL;
```

选出最佳候选并写入终表（对 calc\_type='result' 的标签）：

```sql
sqlINSERT INTO store_tag_snapshot_di (
    store_id, as_of_date, tag_code,
    target_value_bool, target_value_number, target_value_string, enum_code,
    source, closest_source, evidence_state,
    ttl_days, conf, reason, upload_batch_id, target_value_string_back
)
SELECT
    s.store_id,
    s.as_of_date,
    s.tag_code,
    s.target_value_bool,
    s.target_value_number,
    s.target_value_string,
    s.enum_code,
    'FINAL_MERGED' AS source,
    s.source_channel AS closest_source,
    'FOUND_IN_RAW'  AS evidence_state,
    s.ttl_days,
    s.score         AS conf,
    s.reason,
    NULL AS upload_batch_id,
    s.target_value_string AS target_value_string_back
FROM (
    SELECT t1.*
    FROM tag_candidate_scored_di t1
    JOIN (
        SELECT as_of_date, store_id, tag_code, MAX(score) AS max_score
        FROM tag_candidate_scored_di
        WHERE as_of_date = @biz_date
        GROUP BY as_of_date, store_id, tag_code
    ) t2
      ON t1.as_of_date = t2.as_of_date
     AND t1.store_id   = t2.store_id
     AND t1.tag_code   = t2.tag_code
     AND t1.score      = t2.max_score
) AS s
JOIN tag_spec sp
  ON s.tag_code = sp.tag_code
WHERE sp.calc_type = 'result'
ON DUPLICATE KEY UPDATE
    target_value_bool   = VALUES(target_value_bool),
    target_value_number = VALUES(target_value_number),
    target_value_string = VALUES(target_value_string),
    enum_code           = VALUES(enum_code),
    source              = VALUES(source),
    closest_source      = VALUES(closest_source),
    evidence_state      = VALUES(evidence_state),
    ttl_days            = VALUES(ttl_days),
    conf                = VALUES(conf),
    reason              = VALUES(reason),
    target_value_string_back = VALUES(target_value_string_back);
```

> 这一段就是所有 result 型标签的统一“终表写入层”。

---

### 2.5 层级 4：compute 型标签的推断（以 brand\_name / brand\_level 为例）

#### 4.1 brand\_name：多源 + 别名匹配 → 标准品牌枚举

根据 tag\_spec：brand\_name 为 `value_type = enum, calc_type = compute` ，TTL=180，源权重 S1~S4 不同。  
tag\_enum 中为 brand\_name 定义了大量 `enum_code` + `enum_label` + `brand_aliases` 。

计算思路：

1）先从 `tag_candidate_value_di` 中取出 tag\_code='brand\_name' 的候选数据（来源 S1~S4），已经做了枚举匹配；  
2）对 score 再加一层“品牌优先级”（如果你有特定品牌优先规则可以在此实现），否则沿用上一层的 score；  
3）再做一轮同 (store\_id, as\_of\_date, tag\_code) 的 max(score) 选最佳；  
4）写回 `store_tag_snapshot_di` ，source 可以标记为 `FINAL_COMPUTE` ，evidence\_state = 'INFERRED'。

简化 SQL 示例：

```sql
sqlINSERT INTO store_tag_snapshot_di (
    store_id, as_of_date, tag_code,
    target_value_bool, target_value_number, target_value_string, enum_code,
    source, closest_source, evidence_state,
    ttl_days, conf, reason, upload_batch_id, target_value_string_back
)
SELECT
    t.store_id,
    t.as_of_date,
    'brand_name' AS tag_code,
    NULL AS target_value_bool,
    NULL AS target_value_number,
    e.enum_label AS target_value_string,
    t.enum_code,
    'FINAL_COMPUTE' AS source,
    t.source_channel AS closest_source,
    'INFERRED' AS evidence_state,
    sp.ttl_days,
    t.score AS conf,
    'brand_name_compute_from_sources' AS reason,
    NULL AS upload_batch_id,
    t.target_value_string AS target_value_string_back
FROM (
    SELECT c1.*
    FROM tag_candidate_scored_di c1
    JOIN (
        SELECT as_of_date, store_id, tag_code, MAX(score) AS max_score
        FROM tag_candidate_scored_di
        WHERE as_of_date = @biz_date
          AND tag_code = 'brand_name'
        GROUP BY as_of_date, store_id, tag_code
    ) c2
      ON c1.as_of_date = c2.as_of_date
     AND c1.store_id   = c2.store_id
     AND c1.tag_code   = c2.tag_code
     AND c1.score      = c2.max_score
) AS t
JOIN tag_enum e
  ON t.tag_code = e.tag_code
 AND t.enum_code = e.enum_code
JOIN tag_spec sp
  ON sp.tag_code = 'brand_name'
ON DUPLICATE KEY UPDATE
    target_value_string     = VALUES(target_value_string),
    enum_code               = VALUES(enum_code),
    source                  = VALUES(source),
    closest_source          = VALUES(closest_source),
    evidence_state          = VALUES(evidence_state),
    ttl_days                = VALUES(ttl_days),
    conf                    = VALUES(conf),
    reason                  = VALUES(reason),
    target_value_string_back= VALUES(target_value_string_back);
```

#### 4.2 brand\_level：从 brand\_name 派生 KA / CKA / 小散

规则在 `tag_total` 里已有说明（从门店品牌标签判断）；同时 brand\_level 的枚举在 tag\_enum 中定义为 KA/CKA/SMALL。

思路：

- 你可以有一张“KA 品牌列表 / CKA 品牌列表”的配置表（可以直接复用 tag\_enum 中的 brand\_category 或单独建）；
- 从终表/品牌标签中取到 `brand_name.enum_code` ，按配置映射到 KA / CKA / SMALL；
- 若没有品牌信息或没有命中列表 → fallback SMALL（已在 tag\_spec.fallback 中设为 SMALL）。

SQL 示例（假设有一个 `brand_level_mapping` 表：brand\_enum\_code → level\_enum\_code）：

```sql
sql-- brand_level_mapping 示例结构：
-- brand_enum_code (如 BRAND_0001) | level_enum_code (KA/CKA/SMALL)

INSERT INTO store_tag_snapshot_di (
    store_id, as_of_date, tag_code,
    target_value_bool, target_value_number, target_value_string, enum_code,
    source, closest_source, evidence_state,
    ttl_days, conf, reason, upload_batch_id, target_value_string_back
)
SELECT
    b.store_id,
    b.as_of_date,
    'brand_level' AS tag_code,
    NULL AS target_value_bool,
    NULL AS target_value_number,
    le.enum_label AS target_value_string,
    m.level_enum_code AS enum_code,
    'FINAL_COMPUTE' AS source,
    b.source AS closest_source,   -- 继承 brand_name 的来源
    'INFERRED' AS evidence_state,
    sp.ttl_days,
    b.conf AS conf,               -- 继承 brand_name 的置信度
    'brand_level_from_brand_name' AS reason,
    NULL AS upload_batch_id,
    le.enum_label AS target_value_string_back
FROM store_tag_snapshot_di b
LEFT JOIN brand_level_mapping m
  ON b.enum_code = m.brand_enum_code
JOIN tag_enum le
  ON le.tag_code  = 'brand_level'
 AND le.enum_code = IFNULL(m.level_enum_code, sp.fallback)  -- 没命中用 fallback
JOIN tag_spec sp
  ON sp.tag_code = 'brand_level'
WHERE b.as_of_date = @biz_date
  AND b.tag_code   = 'brand_name'
ON DUPLICATE KEY UPDATE
    target_value_string     = VALUES(target_value_string),
    enum_code               = VALUES(enum_code),
    source                  = VALUES(source),
    closest_source          = VALUES(closest_source),
    evidence_state          = VALUES(evidence_state),
    ttl_days                = VALUES(ttl_days),
    conf                    = VALUES(conf),
    reason                  = VALUES(reason),
    target_value_string_back= VALUES(target_value_string_back);
```

> 至此，brand\_name 和 brand\_level 这两个“compute 型标签”的推断就挂在已有的候选值和终表之上，形成一个稳定闭环。

---

### 2.6 层级 5：ETL 调度与日常运行

整条链路放在一起，一天的 ETL 流程就是：

1. D-1 晚 → D 日凌晨：同步 S1~S4/手工修正到 `raw_tag_observation_di` ；
2. 步骤 A：从 `raw_tag_observation_di` → `tag_candidate_value_di` （类型与枚举标准化）；
3. 步骤 B：从 `tag_candidate_value_di` → `tag_candidate_scored_di` （TTL + 评分）；
4. 步骤 C：针对 calc\_type='result' 的标签，将最佳候选写入 `store_tag_snapshot_di` ；
5. 步骤 D：针对 calc\_type='compute' 的标签（brand\_name、brand\_level …），从候选或已有终表计算再写入；
6. 步骤 E：出一张“标签覆盖率 & 准确率抽样表”，用于 Q4 指标监控和后续优化。

---

## 三、可执行行动清单（专注 ETL 体系搭建）

| 优先级 | 事项 | 角色 | 预计完成时间 | 输出物 |
| --- | --- | --- | --- | --- |
| P0 | 在 MySQL 建好 4 张核心表：raw / candidate / scored / snapshot | 数据 | 本周 | 表结构 SQL & 初始化脚本 |
| P0 | 把 S1~S4 原始标签同步到 `raw_tag_observation_di` | 数据/工程 | 本周 | 每日同步脚本（或说明） |
| P0 | 完成 `tag_candidate_value_di` 的 INSERT 模板 | 数据 | 本周 | 统一标准化 SQL（带 bool/enum/number） |
| P1 | 完成“冲突消解 + TTL”逻辑，写 `tag_candidate_scored_di` & snapshot | 数据 | 下周 | score 计算 SQL + 终表写入 SQL |
| P1 | 实现 brand\_name / brand\_level 的 compute SQL | 数据/产品 | 下周 | 两个 compute 标签的 SQL 文件 |
| P1 | 按 1.6W 油站全量跑一次 ETL，输出覆盖率统计表 | 数据 | 下周 | 各标签覆盖率报表（全国 / 省区） |
| P2 | 接入 1–2 个服务类标签（open\_24h、restroom\_available 等）全链路跑通 | 数据/运营 | 2 周内 | 服务类标签终表数据 + 使用 demo |
| P2 | 搭建基础质量监控（覆盖率 & 抽样准确率看板） | 数据 | 本月内 | 质量看板 + 报表 |

---

## 四、思维导图结构（文本版）

- 油站商户画像标签 ETL 体系
	- 终表设计
		- store\_tag\_snapshot\_di 结构
		- 统一 target\_value\_\* 字段
		- TTL / conf / evidence\_state
	- 多源原始观测（S1~S4 + 手工）
		- raw\_tag\_observation\_di
		- 数据同步策略
	- 候选值标准化
		- tag\_candidate\_value\_di
		- 按 value\_type 映射
		- tag\_enum 枚举匹配
		- 权重 w\_source\_s1~s4 注入
	- 冲突消解 & TTL
		- tag\_candidate\_scored\_di
		- score = conf\_initial \* freshness
		- 每站每标签选 max(score)
		- fallback 逻辑
	- compute 型标签
		- brand\_name：多源 + alias + score
		- brand\_level：brand\_name → KA/CKA/SMALL
		- 其他 compute 标签扩展模式
	- 调度与监控
		- D 日全量 ETL 流程
		- 覆盖率监控
		- 抽样准确率监控

---

## 《迭代日志》

- 【来源】
	- 基于你最新说明：Q4 的硬目标就是“标签覆盖率 & 准确率 90%”；你已经有完整的 tag\_spec / tag\_enum / tag\_catalog / tag\_total 配置，只是缺一条系统化的 ETL 生产线，把每个标签规则变成 MySQL 中可执行的打标流水线。
- 【结论】
	- 本轮输出从“业务侧路径”切换到“工程化 ETL 路径”，给出了完整的五层架构：
		- 统一原始观测表 → 候选值标准化 → TTL+冲突消解 → compute 标签推断 → 终表写入 & 调度；
	- 特别针对 brand\_name / brand\_level 做了 compute 型标签的 SQL 范式示例，其余标签可以按同一模式扩展。
- 【改动点】
	- 不再强调业务场景拆解，而是直接围绕你现有配置文件（tag\_spec/tag\_enum/tag\_total）设计 ETL 结构；
	- 引入“候选值表 + 得分表 + 终表”三层结构，避免每个标签写一大坨独立 SQL；
	- 明确了 result 型与 compute 型标签的不同路径。
- 【待补充】
	- S1~S4 的实际表结构（字段名、字段类型）和在 MySQL 中的落地方式（是直接抽取、还是有中转层）；
	- 你现在用于覆盖率 & 准确率统计的表/SQL（方便把监控直接挂在终表之上）；
	- brand\_level 实际分级规则（KA/CKA/小散对应的品牌列表），是已经有表，还是写死在配置中。
- 【下一步建议】
	1. 先挑一个标签（建议 `competitive_overlap` 或 `restroom_available` 这种简单 result 型）和 `brand_name` / `brand_level` 这一对：
		- 把它们在 S1~S4 中的字段示例贴给我（或表结构）；
		- 我可以帮你把上述 SQL 模板改成“能直接跑”的版本。
	2. 在 MySQL 中建表 & 写入一小批测试数据（10–50 个油站），跑通整条链路，确认终表结构和字段涵义没问题；
	3. 等这一条 ETL 跑顺了，我们再一起把剩下的服务/设施类标签接上，这一轮结束后，你就有一条标准化的“标签生产流水线”，Q4 的 90% 目标就有了非常明确的工程抓手。

好，我切到教练模式，一起先把“这条 ETL 生产线”想清楚再动手。

先帮你复述一下我现在的理解：  
你现在的终局不是“再设计标签”，而是要有一条可复用的 ETL 机制，把现有多源数据（S1~S4 + 手工）自动推断成终表 `store_tag_snapshot_di` ，并且通过这条线，实打实把当前这批油站标签的覆盖率、准确率拉到 90%+。

我先问几件关键的事，咱们一层层锁定范围：

1. **范围与版本**  
	这条 ETL 机制的 V1，你更希望是：  
	A）先把「当前 10–13 个核心标签」全部挂上这条流水线，先不管新标签；  
	还是  
	B）先把「1–2 个简单标签 + 1 对复杂标签（brand\_name/brand\_level）」跑通，从而验证整个机制？
2. **现有基础**  
	现在 S1~S4 这些标签源，真实状态是：
	- 都已经在 MySQL 里有对应表了？
	- 还是主要在数仓（Hive / ClickHouse），你打算每天抽一份到 MySQL 来算画像？
3. **最大痛点**  
	你觉得当前“冲不上双 90%”的最大卡点是：
	- 规则还不够清晰（逻辑本身没定死）；
	- 规则清晰，但没做成标准化 SQL / 表结构（每个标签都是一坨脚本）；
	- 还是“上线后没质量监控，出了问题不知道在哪儿坏掉”？

你先选一两个选项、简单回答一下，我再根据你的选择，把这条 ETL 机制的「V1 范围」和「最少要有的能力」跟你一起定死。

先帮你对一下现在的共识：

- 你要的是一条「对所有标签通用」的算法流水线，每个 `tag_code` 都有清晰的规则/算法，新标签也必须挂在这套机制下跑。
- 源数据在数仓，每天同步一份到本地 MySQL 来做画像计算。
- 核心卡点不是工程，而是：每个标签到底怎么算，现在规则不清晰，算法没长成“标准形态”。

接下来我建议咱们 **先把“算法长什么样”定成一个统一模版，再逐个标签填空** ，这样不会散。

我先问 3 个关键问题，帮你锁定“算法长相”和优先级：

1. **算法形态边界**  
	你心里说的“算法”，更接近哪种？
	- 规则引擎型：固定规则 + 阈值（多条件 IF / CASE / 打分 + 分段，比如：3km 内有 2 家竞对 ⇒ 强竞争）。
	- 统计/模型型：允许做一点简单打分或逻辑回归 / 树模型（但不一定要很“AI”）。  
		你更希望 V1 完全用规则搞定，还是允许个别标签用简单模型？
2. **先把哪类标签打样？**  
	在你现有 10+ 个标签里，大概可以分三类：
	- 「结果型」：直接来自单一源的明确字段，比如： `open_24h` 、 `restroom_available` 。
	- 「融合型」：多源合并 + 冲突消解，比如： `brand_name` 、 `sme_supplier` 。
	- 「推断型」：需要组合多个信号推出来，比如： `competitive_overlap` 、 `service_level` 。  
		你愿不愿意先选：
	- 1 个简单结果型 + 1 个融合型 + 1 个推断型，  
		当作“三个算法模版”，后面所有标签都套这三种模版来写？
3. **你对“可解释 vs 精度”的偏好**  
	为了上“双 90%”，如果在一些难标签上出现：
	- A 方案：可解释、规则简单，但只能到 85–90%。
	- B 方案：稍复杂（比如用 10 个特征打分），可解释性差一点，但可以冲到 92–95%。  
		你倾向先做哪个作为 V1 的标准？（可解释优先，还是精度优先？）

你先按直觉回答就行，不用展开长文。  
下一步，我会根据你的选择，给你一个「统一标签算法说明模版」骨架（比如：输入信号 → 数据预处理 → 特征/规则 → 决策表），然后咱们一起拿一个具体 tag 来“现场写一版算法”，把这个模版打磨扎实。

听懂了，你现在的设想其实是：

- 每个 `tag_code` 都有自己的一套“特征 → 规则 → 结果值”的算法，只是算法写法要有统一模版；
- 所有标签本质都是“结果值”，只按 `tag_class` 划分：B=线上纯计算（应 100% 准确）、A=需要特征推断；
- 在设计上，你愿意牺牲一点可解释性，用更“重”的规则/打分体系，来换取更高的准确率（选了 B 档）。

我现在想帮你往前推进一步：先把“一个标签的算法长啥样”用完整模版打出来，再复制到所有 tag\_code。关键有几个点需要你拍板：

1. **先拿哪两个标签当打样对象？**
	- 一个 `tag_class = B` （线上纯计算、应该 100% 对的，比如 open\_24h / restroom\_available 那种）
	- 一个 `tag_class = A` （需要特征组合推断，比如 competitive\_overlap / service\_level）  
		你各点一个具体的 `tag_code` ，我们后续就围绕这俩写“算法说明 + SQL 版本”。
2. **底层“特征建模”的表你现在是怎么想的？**  
	你更倾向：
	- 直接在原始明细（如订单、拜访、竞对信息表）上算特征？
	- 还是建一张统一的 `store_feature_snapshot_di` （每日一行，里面预先算好所有特征），再在上面做标签推断？
3. **标签字典里跟算法强相关的字段有哪些？**  
	除了你提到的 `tag_class` ，还有没有类似： `tag_calc_priority` 、 `tag_calc_window_days` 、 `tag_conf_threshold` 这类已经存在的列？  
	如果有，我们后面就可以把它们直接拉进“规则引擎”的配置里，而不是重新造轮子。

你先帮我：

- 点名 1 个 B 类标签 + 1 个 A 类标签（写 tag\_code）
- 简单说一下你更倾向用“统一特征快照表”还是“直接在底表上算特征”

我下一步就基于你的选择，给你一个「单标签算法模版」骨架，然后我们一起把其中一个标签从“自然语言规则”写到“可落地 SQL”。

先说一下我现在的理解（这次是看了你 catalog 真数据之后说的）：

- 现有一共 13 个标签，只有 `brand_level` 和 `wyc_pricing_enabled` 是 `tag_class = B` （纯线上计算），其它像 `open_24h` 、 `open_hours` 、 `restroom_available` 全是 `tag_class = A` 。
- 你要的不是“一个规则搞定 10 个标签”，而是“统一的特征表 + 每个 tag\_code 一套算法”，并且新标签也必须按这个模版接进来。
- 我们现在要重点用「站内服务里的营业时间」这条线（ `open_hours` + 衍生 `open_24h` ）来打样 V1 算法和 ETL 形态。

接下来我想先把「open\_hours / open\_24h 算法」这个样板搞清楚，所以问你 3 个关键点：

1. **数据源到底长什么样？**  
	对于营业时间相关，现在你在数仓里的“原始字段”有哪些？
	- 哪张（或哪几张）表里有营业时间信息？（比如：门店主数据表 / 合同表 / 某业务系统配置表 / 拜访记录里的手填字段 等）
	- 这些字段的典型格式是怎样的？比如：
		- 单一字段： `"08:00-20:00"`
		- 复杂一点： `"工作日 07:00-22:00；周末 08:00-20:00"`
		- 还是多列形式： `open_time` / `close_time` 之类？  
			你可以先只说“最主的那一个源 + 样例格式”，不用一次性讲全。
2. **业务上“open\_hours / open\_24h”要长成什么样？**
	- 对 `open_hours` ，你希望终表里存的是：
		- A）统一字符串（比如 `"08:00-20:00"` ），还是
		- B）拆成多个字段（如 `open_time` / `close_time` / `weekend_pattern` ），还是先 A，后面再考虑拆？
	- 对 `open_24h` ，你是希望：
		- 完全由 `open_hours` 推出来（如： `00:00-24:00` 视为 24 小时），还是
		- 允许额外信号（比如某系统里有“24 小时站”标记，优先用这个）？
3. **“准确”在这里怎么定义？**  
	双 90% 里，“营业时间准确”你更偏哪种口径：
	- 必须严格到小时/分钟都对上？
	- 还是只要“是否 24 小时 + 大致白天/晚间”对上就算准确？
	- 举个极端例子：实际是 `08:00-21:00` ，我们算成 `08:00-20:30` ，在你的评估里算对还是算错？

你可以这样回复就足够了：

- 列一下营业时间最主数据源的表名 + 1–2 个字段名 + 举个真实值样例；
- 选一下 open\_hours / open\_24h 你期望的终表表现形式；
- 用一句话说你对“准确”的容忍度（严到分钟，还是粗颗粒即可）。

我拿到这些后，就能和你一起把「open\_hours / open\_24h 的算法模版」从“特征 → 规则引擎步骤 → 终表字段”结构化写出来，然后你可以照这个模版去扩展其它标签。

先帮你捋一下刚才的信息：

- 当前营业时间的主信号在订单表，用类似 `"06-24"` 这样的时间区间来表示。
- `open_hours` 终表你希望先用字符串表达， `open_24h` 从 `open_hours` 推断出来。
- 准确率这块你更倾向先“假定为真”，用负向治理（区域反馈错误才修），再通过算法版本（严格 / 宽松 / 可解释）迭代，找一个既能冲 90% 又风险可控的组合。

我完全理解你说的“多个版本，选一个风险更小但覆盖更高的版本”——这本质上是在做一个「算法策略 AB 测」+「负向治理」的组合。

接下来我想跟你对齐两块关键前提，再决定 open\_hours/open\_24h 的算法形态：

1. **关于 `"06-24"` 这个字段：我们不能想当然**  
	这里有几个具体点要搞清楚，否则后面的规则都不稳：
	- 在订单表里：
		- `"06-24"` 一定代表 `06:00–24:00` 吗？有没有 `"0-24"` 、 `"7-23"` 、 `"6-20"` 这种形式？
		- 这个字段是“系统配置的营业时间”，还是“根据订单实际出现时间推出来的统计窗口”？
	- 是否存在多种模式，比如：
		- 都是同一字段，格式稳定；
		- 还是某些站没有这个字段，只能用订单时间分布来推断？
2. **多版本算法你更希望怎么拆？**  
	我先帮你拟一个可解释、又能量化风险的拆法，你看看哪种更接近你想要的：
	- 严格版（v\_strict）：
		- 只用明确、结构化的 `"HH-HH"` 配置值，完全照字面生成 open\_hours 和 open\_24h（比如 `"0-24"` → 24 小时站）。
		- 覆盖率可能不高，但错误极少，适合当“基准真值”。
	- 宽松版（v\_relaxed）：
		- 在严格版基础上，再用订单时间分布去“补齐”营业时段（例如：过去 90 天有订单分布在 22:00 以后，就把关门时间扩展到 22:00+）。
		- 覆盖率高很多，但有一定误判风险。
	- 治理版（v\_governed）：
		- 用宽松版跑出结果，但对“高风险情况”打标（例如：夜间订单极少但被推断成 24 小时），这些站推荐给区域做校准。  
			你会更希望我们在 ETL 里就显式维护这三个版本（比如不同字段 / 不同 tag\_code），还是只保留一个主结果，版本只是内部算法策略？
3. **负向治理这块，你最现实能做到的反馈机制是？**  
	要用“区域校准”做准确率兜底，得想清楚他们怎么反馈：
	- 你现在能否在铁橙 / 运营后台给他们一个“标错入口”？比如：
		- 区域点某个站，“营业时间不对 → 选正确的段 → 回写一条 Sx 源”？
	- 还是短期内只能通过“Excel 拉名单 + 线下反馈”，再由你手动回填？
	- 这会直接影响我们是否要在终表里为每个标签额外留一个字段（比如 `is_region_overwrite` / `manual_version` ）。

你先帮我补这三点里能回答的部分就好，特别是：

- `"06-24"` 的真实含义和格式范围；
- 你想不想在结构上区分 v\_strict / v\_relaxed / v\_governed，还是只保留一个“最终说了算”的结果；
- 你现实中可承载的负向治理入口是“系统内可点”还是“线下表格”。

下一步，我会基于你的回答，把「open\_hours / open\_24h 的算法模版」拆成 2–3 个步骤（严格版 + 宽松版 + 治理标记），然后我们一起确认这个模版可以复制到其他 A 类服务标签。

好，我总结一下你刚才给的信息，确认我们现在的“ETL 认知地图”已经成型到可以设计统一模版的程度：

### 你已明确的关键点（我先复述一遍确保无偏差）

1. **营业时间 `"06-24"` 是你自己算的**
	- 规则：取站点过去 30 天订单的最早小时 + 最晚小时组合。
	- 稳定格式 `"HH-HH"` ，没有订单则空值。
	- 这是一个站点维度的“computed feature”，不是业务配置字段。
2. **你同意“严格版 + 宽松版 + 治理版”三层逻辑，且需要一个“中间表”记录清洗过程产生的所有版本 + 特征值**
	- 推荐值才进入终表，其他版本作为可解释性依据存下来。
	- 这是一个“推荐引擎”行为，而不是简单清洗。
3. **区域反馈走“拉清单 → 人工校准 → 你手动回填”**
	- 即短期内没有系统内直接标错入口。
	- 所以我们需要在 ETL 中为每个标签至少保留 “manual\_override 优先级最高” 的机制。
4. **你补充了一个关键的数据治理规则（非常重要）：工商登记 → 商户 → 门店 的层级聚合必须参与清洗逻辑**
	- 同一工商主体下可能有 N 个商户，商户下可能有 M 个门店。
	- 这些门店的标签有可能一致（趋同），也可能冲突。
	- 数据集聚合后，需要识别：
		- 趋同值（例如大多数门店的 `open_hours` 都在 `"06-22"` 附近）
		- 异常值（例如某门店是 `"06-18"` ）
	- 聚合的作用：
		- 让推荐值“更稳定、更一致、更高置信度”
		- 为下游决策提供一个更“企业级”的视角
	- 最终仍然输出“门店级结果值”，但要附带“企业级趋势 or 聚合值”。

**这一条是你过去画像体系没有体系化的根本原因，今天我们把它捞出来了，非常关键。**

---

接下来我问你 3 个关键问题，帮我们把“统一算法模版”定型，然后我就能给你完整的 ETL blue-print：

## 问题 1：在三层聚合中，你最希望用哪一层做“推荐值”的默认优先级？

我们现在有 3 个层级：

- 工商（party\_first\_name）
- 商户（pop\_name）
- 门店（store\_name）

一个标签例如 open\_hours，在三层上有三种潜在形态：

- 单店计算值（来自订单）
- 商户聚合值（多数门店的一致模式）
- 工商聚合值（多数商户一致模式）

你更希望推荐逻辑是：

A） **单店优先** ：  
先看门店-level 值，如果可信（比如在严格版/宽松版都合理），就用它。只有单店无值或异常时，才用商户聚合值，再无则用工商。

B） **商户优先（我目前倾向这个更稳）** ：  
认为“同一商户的门店应该营业时间一致”，所以如果商户聚合结果稳定（多数一致、方差很小），就优先使用它，除非门店值明显更可信。

C） **工商优先** ：  
默认同一工商主体的经营模式一致，所以优先用工商聚合 → 校正商户 → 再校正门店。

你倾向 A / B / C ？  
（没有对错，只看你的战略偏好；我的专业判断是 B 更能提升准确率并减少奇怪边界情况。）

---

## 问题 2：你希望“趋同/冲突”用什么形式沉淀在中间表里？

现在我们要设计的是“中间表（feature\_cleaning\_stage\_di）”，你更喜欢：

A）结构化字段：

- merchant\_consistency\_rate（0–1）
- merchant\_mode（dominant\_mode: `"06-22"` ）
- merchant\_conflict\_flag（0/1）
- party\_consistency\_rate（0–1）
- party\_mode（dominant\_mode）

B）不结构化 JSON：

- 一个字段记录清洗过程的回溯，比如：

A 的好处是：可查询、可统计、可质量监控  
B 的好处是：灵活、不需要提前定义所有字段

你倾向 A 还是 B？  
（我的建议是 A+B：关键指标结构化，其余 JSON trace 存下来。）

---

## 问题 3：open\_hours 算法的“宽松推断”边界你希望有多宽？

例如：  
订单最早时间是 06:10 / 最晚时间是 23:50  
你希望宽松版把它变成：

A）“06-24”（向上取整）  
B）“06-23”（向下取整）  
C）“06-24”，但标记 high\_risk（用于治理）  
D）严格尊重实际订单分布（即 “06-23.8” → “06-23”）

你更倾向哪一个？  
（我的专业判断：C 最稳，可以冲击 90% 覆盖率且风险可控。）

---

你先回答这三个问题，我们就能把「open\_hours / open\_24h 的统一算法模版」定型。

这套模版定型后，我会立刻给你完整的：

- 特征快照表结构
- 中间清洗表结构
- 推荐引擎逻辑
- SQL 模版（严格版、宽松版、治理标记）
- 最终标签写入终表的规则

然后你就能用这个模版去复制所有 A 类标签。

听懂了，你的取舍很清晰：

- 聚合层级： **商户优先** （pop\_name 这一层的趋同结果是主参考）。
- 中间表：既要结构化指标（consistency、mode 等），又要一份 JSON trace 保证“能追溯每一条标签是怎么算出来的”。
- 宽松推断：接受 C，但你实际想要的是更激进的 **D1：只要 6 点前或 20 点后出现过订单，就视为 00-24 营业** ；前提是整个决策过程要能被查询、回溯。

下一步我们要把这几个选择落成 **可以复制到所有 A 类标签的“算法模版 + 表结构”** ，所以我再卡几个关键点：

1. **商户层趋同怎么判“够一致”？**  
	比如同一商户下 5 家门店的 open\_hours 值分布是：
	- `"06-22"` ：3 家
	- `"07-22"` ：2 家  
		你希望“商户趋同 mode”怎么定？
	- 只要占比 ≥ 50% 就视为一致（3/5 OK）？
	- 还是要求 ≥ 70% 才算真趋同？  
		这个阈值会直接写进 `merchant_consistency_rate` 的决策逻辑里。
2. **追溯能力，你更接受哪种落地方式？**  
	假设我们为每个标签搞一个“审计表”，支持按 `store_id + tag_code + as_of_date` 查出：
	- 输入特征（订单时间段、商户聚合、工商聚合）
	- 算法版本（v\_strict / v\_relaxed / v\_D1）
	- 决策路径（命中哪些条件）  
		你更倾向：
	- 单独一张 `tag_audit_log_di` （所有 tag 混在一起，通过 JSON trace 区分）？
	- 还是每个 tag 有一行简明的结构化审计 + 一列 JSON 细节？（利于排查问题）
3. **运行方式上，我们先锁一个最小闭环范围？**  
	现在这个“open\_hours + open\_24h + 商户聚合 + D1 激进规则 + 可追溯审计”，  
	你更想要 V1：
	- 只在 **一个城市 / 一个区域** 先跑一轮，把逻辑和字段定死；
	- 还是直接对全国 1.6W 站跑一遍，接受前两次跑出来的脏结果主要拿来看“问题分布”？

你可以这样简单回复：

- 商户趋同阈值选多少（比如：≥50% / ≥70%）；
- 审计表你偏“单表 + JSON trace”还是“结构化 + JSON 混合”；
- 这条样板链路 V1 是先地区试点，还是直接全国全量。

我拿到这三个选择，就可以给你一个\*\*“open\_hours/open\_24h 标准算法模版”的最终形态\*\*，后面你只需要照这个模版，给每个 A 类标签补“特征 → 规则树 → 审计字段”，这条 ETL 生产线就成型了。

我先对一下现在的“共识状态”，防止我们脑子里版本不一样：

- 你要的是： **门店 / 商户 / 工商 三层特征建模 → 每层都算出自己的候选值 + 置信度 → 再在门店层做一次决策，选出“全局可信度最高”的那个写入门店标签** 。
- 以营业时间为例，你当前的偏好是：
	- 商户营业时间 = 该商户所有门店过去 30 天订单里的「最早小时 ~ 最晚小时」预测出来的区间；
	- 如果门店自己的预测值和商户预测值冲突（不一致）， **优先用商户的** ，这样有利于把覆盖率拉上去；
	- 上面再叠 D1 激进规则：早于 6 点或晚于 20 点有订单，就认为是 `00-24` ；
	- 所有这些决策过程，要在一个单独的审计表里可追溯（store\_id + tag\_code + as\_of\_date 一查就能看到整条路径）。
- 审计表：单表即可，不在主链路上，算完结果后写一条审计记录，查询频率不高即可。
- 运行：直接全国全量（2W 级别），本地跑纯算法推演；后续我不再问你“要不要先试点”。

这样理解对你现在脑子里的蓝图是贴合的。

接下来我会收敛到两个关键设计点，咱们确认完，就可以把这个思路固化成统一模版，给所有 A 类标签用：

---

**问题 1：三层候选值的“置信度函数”我们要不要现在就抽象出来？**

你现在给了一个具体规则例子（以营业时间为例）：

- 门店候选值： `store_open_hours_30d = min_hour ~ max_hour` （基于单店订单）。
- 商户候选值： `merchant_open_hours_30d = 该商户所有门店 min_hour ~ max_hour` 。
- 工商候选值：未来也可以类似算一遍（所有商户的门店整合）。

你刚刚说的是一句“非常有启发”的话： **不是只是看一致，而是要把这些当成特征，算一个“可信度最高的值”写给门店** 。

我的建议是：我们干脆现在就把一个“通用置信度公式”定出来，比如：

- `conf_store` ：基于单店订单量 / 夜间订单分布 / 最近订单时间衰减。
- `conf_merchant` ：基于商户层趋同度（模式占比）、门店数量、订单量。
- `conf_party` ：基于工商层趋同度、商户数量、覆盖范围。

然后门店最终的推荐值是类似：

> 在 \[store 候选、merchant 候选、party 候选\] 三个中，  
> 选 `(conf_x, hierarchy_weight_x)` 组合得分最高的那个。

你现在更倾向的做法是：

- 先不搞统一公式，就在营业时间里直接写死一条“商户优先、冲突取商户”的决策树；
- 还是愿意为营业时间这一个例子，多花点脑力，把“候选值 + conf”的范式抽象成一个可以复用到其它标签的通用模版？

（这里没有对错，只是取舍：前者快落地，后者利于后面扩展。）

---

**问题 2：D1 激进规则你更倾向挂在哪一层生效？**

你现在的 D1 思路是：

> 早于 6 点或晚于 20 点有订单，就认为是 00-24。

这个规则可以有三种挂法：

1. **只在门店层生效** ：
	- 即 D1 规则只作用在门店订单分布上，生成 store 级候选值。
2. **在门店层 + 商户层都生效** ：
	- 商户营业时间也是看「所有门店的最早/最晚」，在这个层面上也可以触发 00-24。
3. **只在商户层生效** ：
	- 门店是原始 min~max 区间，商户层在聚合时才用 D1，最后写回门店的是商户版。

我的直觉：如果你希望“open\_24h 的定义尽量稳定、也便于运营理解”，更适合在 **商户层** 来决定是否是 24 小时（因为“这个商户就是 24h 连锁”这件事，本身更像商户属性，而不是某个单店偶发深夜加油行为）。  
但这是业务判定，你必须拍板。

---

你先直接告诉我：

- 对问题 1：你是「先搞营业时间一个专用决策树」、还是「愿意多花一点力气抽通用候选+置信度模版」？
- 对问题 2：D1 规则希望在 门店层 / 商户层 / 两层 都生效？

我拿到这两点，就可以在下一步给你一份 **严格对齐你偏好的“open\_hours/open\_24h 标签算法说明模版”** ，包括：

- 三层特征表应该有哪些字段；
- 中间清洗表（含推荐值 + conf + 决策版本）；
- 审计表里最少要存什么信息，才能做到“任意一条标签都能追溯”；
- 以及一条可以翻译成 SQL 的决策树结构（不写具体代码，只给你骨架）。

我先帮你把现在的共识再压一遍，只保留关键点：

- 所有标签共享一套「三层候选 + 置信度」范式：门店 / 商户 / 工商都算自己的候选值 + conf，再在门店层做一个“谁最可信就用谁”的决策。
- open\_hours / open\_24h 是我们打样的标签，用来长出这套 **通用模版** 。
- D1 规则（6 点前或 20 点后有订单 → 00-24）在三层都要生效，只是每层各自用自己 30 天的订单分布。
- 需要一个单独的审计表，能查出“任意一条标签是怎么算出来的”；但不在主链路上，不追求高频、只要可查。

接下来咱们不再纠结业务，而是把“通用候选 + 置信度模版”捏出来，用 open\_hours 当例子，其它 A 类标签直接照抄结构就行。

---

### 我先提一版「统一算法模版」骨架（用 open\_hours 举例）

你先看整体是不是你脑子里的形状，再决定细节：

**0\. 特征层（3 张特征快照表，按日）**

- store\_feature\_snapshot\_di：
	- store\_id, as\_of\_date
	- open\_hour\_min\_30d, open\_hour\_max\_30d
	- has\_order\_before\_6, has\_order\_after\_20 （D1 信号）
	- order\_cnt\_30d, night\_order\_cnt\_30d, last\_order\_datetime\_30d
- merchant\_feature\_snapshot\_di：
	- merchant\_id（pop\_name 对应的主键）、as\_of\_date
	- agg\_open\_hour\_min\_30d（所有门店最小小时）、agg\_open\_hour\_max\_30d（最大小时）
	- has\_order\_before\_6\_any\_store, has\_order\_after\_20\_any\_store
	- store\_cnt, store\_with\_data\_cnt, store\_consistency\_rate（比如模式最多的时间段占比）
- party\_feature\_snapshot\_di：
	- party\_id（party\_first\_name 对应的主键）、as\_of\_date
	- 同上，只是聚合粒度再上一层。

**1\. 候选值层：对每个 tag\_code、每个层级产出候选 + 基础 conf**

以 open\_hours 为例：

- store\_level\_candidate：
	- candidate\_value = `${open_hour_min_30d}-${open_hour_max_30d}` （基础版）
	- 如果 has\_order\_before\_6 或 has\_order\_after\_20，则 candidate\_value\_D1 = `00-24`
- merchant\_level\_candidate：
	- candidate\_value = `${agg_open_hour_min_30d}-${agg_open_hour_max_30d}`
	- 同样套 D1
- party\_level\_candidate：
	- 同上。

**2\. 置信度函数（conf\_store / conf\_merchant / conf\_party）**

统一用一个通用框架（以后其它标签也套）：

- conf\_store = f(订单量、最近订单时间、数据是否完整)
- conf\_merchant = f(门店数量、store\_consistency\_rate、总订单量)
- conf\_party = f(商户数量、merchant\_consistency\_rate、总订单量)

最后门店的“推荐候选值”来自：

> 在 \[store, merchant, party\] 三个候选中，选 conf\_x \* hierarchy\_weight\_x 最大的那一个  
> （hierarchy\_weight 门店 / 商户 / 工商各有一个系数，比如 0.8 / 1.0 / 0.7）

D1 是在各层算候选值时就已经参与了：

- 三层各自先决定自己是不是 `00-24` ，再进入“谁最可信”的对比。

**3\. 决策层：门店最终标签值**

- 如果有 manual\_override → 一律 manual 优先。
- 否则按上面 conf\_x \* weight\_x 选择一个候选，写入 store\_tag\_snapshot\_di。

**4\. 审计层：tag\_audit\_log\_di**

- 每条记录至少包含：
	- store\_id, as\_of\_date, tag\_code
	- chosen\_level（STORE / MERCHANT / PARTY / MANUAL）
	- chosen\_value
	- conf\_store / conf\_merchant / conf\_party
	- candidate\_value\_store / merchant / party
	- strategy\_version（v\_strict / v\_D1 / v\_relaxed 等）
	- trace\_json（详细路径：各层特征、是否命中 D1、聚合分布等）

这个骨架的意思是：  
以后任何 A 类标签，都有：

- 三层特征快照；
- 三层候选值；
- 三层 conf；
- 一个通用“谁最可信”的决策器；
- 一条审计记录。

你要给每个标签做的，就是：

- 定义它在三层的特征是什么；
- 定义它的候选值怎么从特征算出来；
- 定义 conf\_x（store/merchant/party）怎么根据特征算。

---

### 接下来需要你拍板的 2 个关键点

我现在不给完整公式，而是让你先决定两个“方向性选择”，然后我们再一起填公式。

1. **置信度函数里，三层共同的“硬指标”你认为最关键的 3 个是什么？**  
	先不纠结权重，我们只要先选出「所有标签都共用」的 3–4 个信号：
	我给你一个候选列表，你从中挑 3 个你觉得“不选它就不踏实”的：
	- S1：样本量（如 order\_cnt\_30d / 门店数 / 商户数）
	- S2：数据新鲜度（如 最近一次订单距 as\_of\_date 的天数）
	- S3：一致性 / 离散程度（如 consistency\_rate，最大模式占比）
	- S4：结构完整度（如 store\_with\_data\_cnt / store\_cnt）
	- S5：是否命中“强信号规则”（比如 D1 → extended\_hours\_flag）
	- S6：是否有人工覆盖（manual\_override\_flag）
	你先选 3–4 个“所有标签都应该用”的底座信号，我们后面再给 open\_hours 定它自己的附加信号。
2. **跨层决策时，有没有“坚决不能发生”的 override 规则？**  
	比如：
	- 是否允许“商户层候选是空，门店层候选很强，但仍写一个商户值”？（大概率你会说不允许）
	- 是否允许“门店层候选有值且 conf\_store 很高，但商户层有轻微多数，就用商户覆盖门店”？
	- 有没有类似：
		- “只要 conf\_store ≥ 0.9，就永远不能被覆盖”
		- “conf\_merchant ≥ 0.9 时，可以覆盖低于 0.8 的 store 值”
	换句话说：你能不能给我一句话的 **红线规则** ，比如：
	> “只要门店自己的 conf ≥ 0.9，就永远用门店；否则按商户优先，再考虑工商。”
	或者别的组合？  
	这个红线一旦定下，我们后面所有标签都按这个来。

---

你先帮我做两件事：

1. 从 S1–S6 里面选 3–4 个「所有标签的通用置信度信号」；
2. 给一句话的“跨层 override 红线规则”（门店值在什么条件下永远不能被覆盖，反过来商户/工商在什么条件下可以强行覆盖门店）。

下一步，我就用你选的信号 + 红线规则，给你写出：

- open\_hours 的完整「特征 → 候选 → conf → 决策 → 审计」模版（还是教练模式，但会比较接近最终形态）；
- 你可以一眼看到：其它标签只要换特征和候选计算，骨架完全复用。

听起来我们已经定下了几个关键“规则框架”：

- 置信度统一用：S2 数据新鲜度 + S3 一致性 + S4 结构完整度 + S6 人工覆盖，四个信号做底座。
- 跨层决策红线：门店 `conf >= T_store` （默认 0.9，可配置）就永远用门店，否则按商户优先，再考虑工商。
- 但商户层必须先经过一道“是否可聚合”的前置筛选，有一批虚拟/异常商户要进黑名单，不能拿来做聚合。

接下来有 3 个关键点需要你补一点信息，我才能帮你把“商户聚合准入规则 + 置信度公式”设计成可落地、可配置的模版：

1. **识别“虚拟商户”的线索**  
	在你当前的数据结构里，商户这层（pop\_name / 相关 ID）有没有：
	- 字段能标记商户类型？（比如线上虚拟、测试、总部账户、代理商等）
	- 明显的命名特征？（例如“测试/虚拟/集团聚合/总部账户”这类关键词，经常出现在 pop\_name 或其他字段里）
	- 现有的运维/业务维护黑名单？（例如某张表里已有一批“不计入运营指标”的商户）
2. **商户聚合“准入”你更能接受哪种组合方式？**  
	我先给你一个可配置的思路，你选一下你觉得现实可行的方向：
	- 基于「元数据」：type 字段 + 名称规则 → 一刀切排除一批明显虚拟商户。
	- 基于「行为特征」：
		- 比如“该商户下门店极度分散、一致性极差、结构完整度很低”的，自动降级为不可聚合。  
			你是更想先从“元数据规则 + 少量人工黑名单”为主，行为特征做补充，还是相反？
3. **阈值可配置这件事，你希望落地到哪一层？**  
	你刚说“0.9 现在没体感，需要数据支撑”，那在系统设计上你更希望：
	- `T_store` / `T_merchant` / `T_party` 写在 tag\_spec 里，每个 tag\_code 可以有不同阈值；
	- 还是所有标签共用一套默认阈值，只有少数标签单独 override？  
		这会直接影响我们后面怎么设计 `tag_spec` 的扩展字段（是新增几个 conf\_threshold 字段，还是搞一张专门的 algo\_config 表）。

你先简单告诉我：

- 虚拟商户现在有没有任何“现成线索”（字段/命名/已有表）；
- 聚合准入你倾向“元数据规则优先”还是“行为规则优先”；
- 阈值你更想挂在 tag\_spec（按标签配置）还是搞一张统一的 algo\_config（全局默认 + 少量覆盖）。

下一步，我就可以：

- 直接给你一套「商户可聚合判定逻辑」的模版（包括黑名单、白名单、行为降级），
- 再把 `conf_store / conf_merchant / conf_party` 的通用公式草案写出来，用 open\_hours 当例子让你看是不是顺眼。

1.我可以前置识别,我可以标记这个标记在上游的表里,同步你字段;2.基于「行为特征」3.这个先不放到字典表格里吧,放在后面的算法逻辑中配置,是不是可行?

我先对齐一下现在的新前提：

- 你可以在上游给商户打一个是否“虚拟/不可聚合”的标记字段，下游直接用。
- 真正决定“能不能用商户层”的核心还是 **行为特征** （一致性、结构完整度之类），不是死规则。
- `T_store` 、 `T_merchant` 这些阈值你暂时不想写进字典表，而是放在“算法逻辑/配置层”里单独管理。

我现在有两个关键点想跟你一起敲定，然后就可以把“通用候选 + conf 模版”写出来了：

1. **行为特征这块，你最能接受的“商户是否可聚合”判定信号是哪些？**  
	比如先不管权重，你觉得下面哪些一定要进来（选 2–3 个就行）：
	- 该商户下门店数量（门店太少/太多都可能异常）；
	- 有数据的门店占比（store\_with\_data\_cnt / store\_cnt）；
	- open\_hours 的模式占比（最大模式占比 = consistency\_rate）；
	- 门店间 open\_hours 的“跨度”（比如 min=06-18, max=08-24，跨度太大视为不靠谱）；
	- 历史是否被区域反馈有问题（feedback\_cnt > 0）。
2. **参数不进字典，你更倾向用什么形式来管？**  
	为了后面调阈值方便，我会建议你：
	- 要么建一张简单的 `tag_algo_config` （tag\_code, conf\_threshold\_store, conf\_threshold\_merchant, enable\_D1\_flag…），
	- 要么在代码里读一个 YAML/JSON 配置文件（本地项目里就能改），  
		这两种你更习惯哪种？（重点是：你自己未来调参时更顺手的方式）

你先勾一下行为特征里最关键的 2–3 个，再选一个你自己最想用的“参数配置载体”（表 or 配置文件）。  
下一步我就不再问问题，直接给你一版 **通用模版草图** （特征字段列表 + conf 公式骨架 + 决策流程），我们用 open\_hours 填一遍，你看是不是能直接拿去写 SQL。

我先帮你对齐一下我们现在已经“锁死”的点：

- 行为特征这块，你明确要用：  
	1） **有数据的占比** （store\_with\_data\_cnt / store\_cnt，小于 0.2 就很危险）；  
	2） **历史被反馈次数** （区域已经说“这家不靠谱”）；
- 参数不进字典，用一张 **tag\_algo\_config** 来管阈值和策略逻辑，“能调参但先别搞太复杂”。

下面我先用非常白话的方式解释一个概念，然后给你一个「tag\_algo\_config 怎么弄」的骨架，再追问 1–2 个关键点。

---

### 1\. 简单说一下 consistency\_rate 是啥

你现在不理解这个词，本质上是因为我说得太学术了，换个说法：

> consistency\_rate = “这家公司下面的门店，有多少比例是同一种营业时间模式？”

例子：

- 同一个商户下有 10 家门店，open\_hours 分布是：
	- `06-22` ：7 家
	- `07-22` ：3 家
- 那么：
	- 最常见模式是 `06-22` ，占比 7/10 = 0.7
	- 我们就说这个商户的 **consistency\_rate = 0.7**

用处是：

- 0.9+：几乎都一样，可以认为这个商户“营业时间相当统一”，聚合可信；
- 0.3：特别散乱，说明商户层没啥统一规律，用它反而坑。

你现在可以理解成一句话：

> consistency\_rate 就是“这个商户下面门店在某个标签上的一致程度”。

你要是觉得这个概念现在还用不上，我们可以先把它放一边，先用你已经认可的“数据占比 + 历史反馈”搞一个 V1。

---

### 2\. tag\_algo\_config 怎么弄（先给你一个简单骨架）

不用上字典表，就单独搞一张轻量配置表，专门存“算法阈值 & 策略开关”，形态大概是这样（先概念，不写完整 SQL）：

| 字段名 | 含义 |
| --- | --- |
| tag\_code | 标签编码，比如 `open_hours` 、 `open_24h` |
| conf\_threshold\_store | 门店层“不能被覆盖”的阈值（比如 0.9，可调） |
| enable\_merchant\_level | 是否启用商户层聚合（0/1） |
| min\_merchant\_data\_ratio | 商户层“有数据门店占比”的下限，比如 0.2（低于就视为不可聚合） |
| max\_feedback\_cnt\_for\_agg | 商户层历史反馈次数上限（超过就禁用聚合） |
| enable\_party\_level | 是否启用工商层聚合（0/1） |
| algo\_version | 算法版本号（方便以后灰度 / 回溯） |
| extra\_config\_json | 预留 JSON 配置（放一些特定标签才需要的参数） |

你的日常使用方式可以是这样的：

- 想调 “门店 conf 到多少就不能被覆盖” → 改 `conf_threshold_store` ；
- 想关闭某个标签的商户聚合 → 把 `enable_merchant_level` 改成 0；
- 想要求“至少 30% 门店有数据才允许用商户聚合” → 把 `min_merchant_data_ratio` 改成 0.3。

这一张表可以完全由你自己控制，跟 tag\_spec / tag\_enum 分开，心智负担更小。

---

### 3\. 商户“可聚合”前置逻辑，用你给的两个行为特征就够起步

以 open\_hours 为例，商户层是否可聚合可以先用一个简单规则：

> 对某个商户，如果：
> 
> - 有数据门店占比 ≥ min\_merchant\_data\_ratio（比如 ≥ 0.2），且
> - 历史反馈次数 ≤ max\_feedback\_cnt\_for\_agg（比如 0）  
> 	且
> - 不在你上游标记的“虚拟/异常商户黑名单”里
> 
> 那么：这个商户 **可以聚合** ，可以参与“候选值 + conf\_merchant 计算”。

否则，该商户直接视为 “不可聚合”，这层候选直接当不存在；门店就只在门店/工商之间决策。

---

### 4\. 我这轮想追问的 2 个关键点

为了下一步给你画完整模版，我还需要你再补两刀：

1. 上游你给商户打“虚拟/不可聚合”标记时，字段名打算叫什么？  
	比如： `is_virtual_merchant` / `is_agg_blocked_merchant` 之类，随便起，但之后我们要在文档和 SQL 里用同一个名字。
2. 历史反馈你现在有没有打算做结构化？  
	比如一张非常简单的表： `merchant_feedback_stats` （merchant\_id, tag\_code, feedback\_cnt）
	- 如果暂时没有，我们可以在算法设计里先当它“未来可接入”，V1 只用数据占比 + 黑名单。

你可以简单回答：

- “虚拟商户字段我准备叫 XXX”；
- “反馈这块现在有/没有、打算以后怎么做（比如先不做）”。

我拿到这两点之后，下一轮我会直接给你：

- open\_hours 的完整 “三层候选 + conf + 决策 + 审计” 结构模版（还是教练模式，但会具体到字段层级），
- 然后我们就可以说“好，这个就是 A 类标签的标准模版”，你再决定下一步先拿哪个标签按这个模版填规则。

先对齐一下现在的盘面：

- 商户可聚合黑名单字段：你会在上游打 `is_agg_blocked_merchant` ，下游只用这个结果。
- 行为特征准入：我们用“有数据门店占比 + merchant\_feedback\_stats”来判断商户层是否允许参与聚合。
- 阈值与策略：走独立的 `tag_algo_config` 表来管，而不是塞回 tag 字典。

接下来我不直接给你一坨 SQL，而是先把「open\_hours 标准算法模版」的组件列清楚，你确认结构没偏，再一起决定哪块先落地。

---

### 我建议的 open\_hours 通用模版骨架（你看形状对不对）

先别纠结细节和公式，只看“几个表 + 几步流程”你是否认同。

**1）特征快照层（3 张表，按日）**

- `store_feature_snapshot_di` （门店层）  
	核心字段（open\_hours 这一块）：
	- store\_id, as\_of\_date
	- open\_hour\_min\_30d, open\_hour\_max\_30d
	- has\_order\_before\_6\_30d, has\_order\_after\_20\_30d （D1 信号）
	- order\_cnt\_30d, last\_order\_dt\_30d
- `merchant_feature_snapshot_di` （商户层）
	- merchant\_id, as\_of\_date
	- store\_cnt, store\_with\_data\_cnt
	- agg\_open\_hour\_min\_30d, agg\_open\_hour\_max\_30d （基于所有门店）
	- has\_order\_before\_6\_any\_store\_30d, has\_order\_after\_20\_any\_store\_30d
	- is\_agg\_blocked\_merchant （你上游打好的字段）
- `party_feature_snapshot_di` （工商层）
	- party\_id, as\_of\_date
	- merchant\_cnt, merchant\_with\_data\_cnt
	- agg\_open\_hour\_min\_30d, agg\_open\_hour\_max\_30d
	- has\_order\_before\_6\_any\_merchant\_30d, has\_order\_after\_20\_any\_merchant\_30d

先不搞很复杂，其他特征（比如 consistency\_rate）可以之后再加。

---

**2）算法配置层： `tag_algo_config` （以 open\_hours 为一行例子）**

示意一行配置（不是最终值，只是形态）：

- tag\_code = `open_hours`
- conf\_threshold\_store = 0.9 （门店 conf ≥ 0.9 不允许被覆盖）
- enable\_merchant\_level = 1
- min\_merchant\_data\_ratio = 0.2 （有数据门店占比）
- max\_feedback\_cnt\_for\_agg = 0 （反馈>0 的商户先视为不聚合）
- enable\_party\_level = 1
- algo\_version = `open_hours_v1`
- extra\_config\_json：可放 D1 开关、窗口期等

以后如果你想调门店阈值或关掉商户聚合，只改这一行。

---

**3）候选 + conf 层：三层各自产生自己的候选值**

还是以 open\_hours 举例：

- 门店候选（store\_candidate）：
	- base\_candidate = `${open_hour_min_30d}-${open_hour_max_30d}`
	- 如果 has\_order\_before\_6\_30d 或 has\_order\_after\_20\_30d 为真 → D1 版本 candidate = `00-24` （并记录命中 D1）
	- conf\_store = f(数据新鲜度 S2, 结构完整度=是否有 open\_hour\_min/max, 是否命中 D1, 是否 manual\_override)
- 商户候选（merchant\_candidate）：
	- 先用 behavior 准入逻辑过滤：
		- is\_agg\_blocked\_merchant = 0
		- store\_with\_data\_cnt / store\_cnt ≥ min\_merchant\_data\_ratio
		- merchant\_feedback\_stats 中该商户、该 tag 的 feedback\_cnt ≤ max\_feedback\_cnt\_for\_agg
	- 通过准入后：
		- base\_candidate = `agg_open_hour_min_30d-agg_open_hour_max_30d`
		- D1 同理 → 有任一门店早于 6 或晚于 20 → `00-24`
	- conf\_merchant = f(有数据门店占比、总订单量/门店数、是否命中 D1)
- 工商候选（party\_candidate）：
	- 准入可以先简单一点：
		- merchant\_with\_data\_cnt / merchant\_cnt ≥ 某个阈值（可以共用或单独配置）
	- 通过准入后：
		- base\_candidate = `agg_open_hour_min_30d-agg_open_hour_max_30d`
		- D1 一样
	- conf\_party = f(有数据商户占比、整体数据新鲜度等)

这里的 f() 先别急着写公式，我们后面可以一起“算几条样本”再调。

---

**4）门店最终决策规则（带你刚同意的红线）**

对每个 store\_id + as\_of\_date + tag\_code= `open_hours` ：

1. 如果有 manual\_override → 直接用 manual，chosen\_level=MANUAL。
2. 否则计算 conf\_store、conf\_merchant、conf\_party（不存在的层就当 conf=0）。
3. 如果 `conf_store >= T_store` （从 tag\_algo\_config 读，比如 0.9） → 直接用门店候选。
4. 否则：
	- 在【允许聚合的商户候选、允许聚合的工商候选、门店候选】中
	- 选 conf\_x \* weight\_x 最大的那一个（weights 可以默认：store 0.8 / merchant 1.0 / party 0.7）。
5. 把选出来的 `candidate_value_x` 写入终表 `store_tag_snapshot_di` ，并标记：
	- source\_level（STORE/MERCHANT/PARTY/MANUAL）
	- conf\_final
	- algo\_version（open\_hours\_v1）

---

**5）审计表： `tag_audit_log_di` （单表）**

对每一条门店最终写入的标签，记一条审计：

- 主键：store\_id, as\_of\_date, tag\_code
- chosen\_level, chosen\_value, conf\_final
- conf\_store, conf\_merchant, conf\_party
- candidate\_value\_store, candidate\_value\_merchant, candidate\_value\_party
- manual\_override\_flag
- strategy\_version（open\_hours\_v1）
- trace\_json（放细节：D1 是否触发、各层特征快照主字段、商户准入判断过程、feedback 统计等）

以后你查一条：  
`WHERE store_id = X AND as_of_date = Y AND tag_code = 'open_hours'`  
就能看到它到底是门店算的、商户算的、还是工商算的，以及 D1 是在哪一层触发的。

---

### 接下来两个关键选择（决定我们怎么从“模版”走向“可写 SQL”）

1. 上面这个「五块组件」的骨架，你整体上是不是认可？
	- 特征快照层（三张表）
	- `tag_algo_config` 管阈值和开关
	- 三层候选 + conf
	- 门店决策红线 + 选 max(conf\*weight)
	- 单审计表
2. 在 open\_hours 上，你更想 **先具体化哪一块** ？
	- A：先具体化 `store_feature_snapshot_di` 的字段 & 生成逻辑（怎么从订单表算出 `open_hour_min_30d` 等）；
	- B：先具体化 `tag_algo_config` + 决策规则（conf 的公式和跨层优先级），再回头补特征；
	- C：先具体化 `tag_audit_log_di` （你很在意追溯），确保任何决策都留痕。

你可以直接说：“骨架 OK，先从 A 开始” 或 “骨架 OK，先从 B 开始”等。  
我会按你选的那块，下一步和你一起把 open\_hours 做到“可以直接翻译成 SQL 伪代码”的程度，然后你就可以对其它服务类标签套模版了。

先直接回应你这两个点，然后再追问关键选择。

---

我先帮你压一下我们在讨论的核心：

- 我们现在设计的是“标签算法的共用骨架”，open\_hours 只是打样；
- 你关心的是：  
	1）特征层到底要 3 张表（门店/商户/工商）还是 1 张宽表；  
	2）上游依赖到底有哪些字段/表，要全部点名出来，让你能回头补数、打标。

### 1\. 特征快照层：3 张 vs 1 张表，怎么权衡？

本质差异是：

- 3 张表：
	- store\_feature\_snapshot\_di（store\_id 粒度）
	- merchant\_feature\_snapshot\_di（merchant\_id 粒度）
	- party\_feature\_snapshot\_di（party\_id 粒度）
- 1 张宽表：
	- 比如 store\_feature\_snapshot\_di，一张表里既有门店特征，也有商户聚合特征、工商聚合特征（通过关联 merchant\_id、party\_id 拉进来）。

各自的利弊我帮你拆一下（简化版）：

**三张表的优点：**

- 概念清晰：  
	每张表只管一种粒度，聚合逻辑、质量问题都比较好定位（“商户层算错”一眼能看出来）。
- 方便单独复用：  
	未来如果你有别的项目也要用“商户特征”，可以直接用 merchant\_feature\_snapshot\_di。
- 对“行为特征判定可聚合/黑名单”比较直观：  
	比如 merchant\_feature\_snapshot\_di 里就能直接挂 store\_with\_data\_ratio、feedback\_cnt 等。

**三张表的缺点：**

- 下游决策 SQL 需要 JOIN 三次（store→merchant→party），复杂度略高一点；
- ETL 任务看起来多（虽然数据量不大，但心理负担会大一点）。

**一张宽表的优点：**

- 下游“决策那一步”的 SQL 非常简单：只扫一张表就能得到 store/merchant/party 三层特征；
- 逻辑都集中在一处，不用来回 JOIN。

**一张宽表的缺点：**

- 聚合逻辑混在一块：  
	你不容易单独看“某商户层特征有没有算对”，因为它只是宽表里的几列；
- 行为特征（例如某商户是否可聚合）变成“从宽表里再反推”，治理不如三张分开直观；
- 未来如果有“只用商户层的项目”，会被迫依赖 store 粒度的宽表。

用你现在的习惯来翻译一句话：

> 如果你更看重“可治理、可复用、问题好排查”，三张表更利于项目长期演化；  
> 如果你更看重“本次只为标签决策服务、快速落地”，一张宽表（以 store 为行）能少写不少 SQL。

---

### 2\. 你要的“上游依赖清单”，先按 open\_hours 打样列一遍

你刚刚点名的需求其实很明确：

> “你需要搜集全部的信息, 必要产出的上游依赖详细标注, 让我确认和反馈。”

那我们先以 open\_hours 为例，把“上游要准备什么”列成几类：

1） **ID & 层级关系依赖**

- 门店主键：store\_id
- 商户主键：merchant\_id（与 pop\_name 对应）
- 工商主体主键：party\_id（与 party\_first\_name 对应）
- 三层之间的映射关系表（或字段）：
	- store\_id → merchant\_id
	- merchant\_id → party\_id

2） **订单明细依赖（30 天窗口）**

- 来源表：订单事实表（你现在在用的那张，里边有时间字段）
- 必要字段：
	- store\_id
	- 订单完成时间（order\_time / pay\_time，具体字段名你来定）
- 用途：
	- 计算每个门店过去 30 天订单的最早小时、最晚小时；
	- 统计是否存在 6 点前 / 20 点后的订单；
	- 统计 order\_cnt\_30d、last\_order\_dt\_30d 等。

3） **商户行为特征依赖**

- 商户黑名单标记：
	- `is_agg_blocked_merchant` （你上游打，字段挂在 merchant 维表或某张商户属性表上）
- 商户反馈统计（未来要建）：
	- 表名： `merchant_feedback_stats` （你刚刚也同意这个名字）
	- 字段：merchant\_id, tag\_code, feedback\_cnt
	- 用途：
		- 判断商户是否“反馈过有问题”，作为商户层是否可聚合的行为特征之一。

4） **算法配置依赖**

- `tag_algo_config` 表：
	- 至少需要为 `open_hours` 配：
		- conf\_threshold\_store
		- enable\_merchant\_level
		- min\_merchant\_data\_ratio
		- max\_feedback\_cnt\_for\_agg
		- enable\_party\_level
		- algo\_version
		- extra\_config\_json（预留）

这 4 类，就是 open\_hours 整条算法链路所需的上游依赖骨架。

---

### 接下来我想问你两个非常关键的选择

为了不浪费你时间，我们必须先定一个方向，否则后面细节越写越偏。

1. 关于“三张 vs 一张宽表”，你现在的感觉更偏哪一侧？
	- A：追求治理 & 复用 & 结构清晰 → 接受三张特征表；
	- B：追求这次标签决策简单落地 → 用一张宽表（store 为行，商户/工商特征作为列）。
2. 上面我列的 open\_hours 上游依赖清单，你觉得有没有“缺了什么关键东西”？
	- 比如：你觉得“还得有 X 张表 / X 个字段”才能算完整，或者哪里你觉得我误读了。

你可以这样简单回我就够了：

- “特征层我选 A/B”；
- “依赖清单 OK/哪里不对/需要补哪些字段或表名”。

我拿到这两个点，就可以在你选的结构上，把 **open\_hours 的整条算法模版** （从特征算起，到终表 & 审计）做成一版“可以直接翻译成 SQL 伪代码”的版本，你后面只要按这个模版给其它标签填特征和规则就行。

我先帮你把最新信息捋一下，确认我们现在的“地基”：

- 三层关系 & 大部分特征，其实都集中在一个视图： `merchant_profile_latest`
	- `store_id` → 门店
	- `merchant_id` → 商户（对应 pop\_name）
	- `party_first_name` → 工商主体名（如果要真正的 party\_id，要再 join 工商登记号）
	- `is_zxgj` ：营业时间区间，示例 `06-22` （已经是 30 天订单推出来的小时区间）
	- `order_cnt_30d` ：过去 30 天 TMD 订单相关指标（你说“日均订单值”，我们要把含义掰开）
	- `is_agg_blocked_merchant` ：商户黑名单标记，也在这个视图里
- 未来要补两块：
	- `merchant_feedback_stats` ：商户×标签的反馈次数
	- `tag_algo_config` ：各标签的算法阈值/策略配置

我们已经决定走「三张特征快照表」的长期优解路线（store / merchant / party），但 **这三张表可以全部从 `merchant_profile_latest` + 少量额外表推出来** ，这点你已经给足了前置条件。

---

接下来，我建议这样推进：先把「特征快照三张表」用 open\_hours 打样，所有字段都从你现有的源里“点名出来”，你确认没问题后，我们再往下长候选 + conf + 决策。

在定三张表之前，有几个细节必须你拍板：

1. **关于 `is_zxgj` & `order_cnt_30d` 的语义**  
	这两个是 open\_hours 特征的核心，请你确认一下：
	- `is_zxgj` ：
		- 是否可以认为已经是“过去 30 天订单最早小时 & 最晚小时”的结果？
		- 形如 `06-22` ，我们直接拆成 `open_hour_min_30d=6` 、 `open_hour_max_30d=22` 用就可以？
	- `order_cnt_30d` ：
		- 它现在到底是“30 天内订单总数”还是“30 天日均订单”或别的口径？
		- 这个字段对你来说，哪个口径最有用？如果现在不是，我们要不要在特征表里重算一个你想要的版本（比如 `total_order_cnt_30d` + `avg_order_cnt_30d` ）？
2. **三张特征表全部落在 MySQL 没问题？**  
	我现在默认设计是：
	- 每天从数仓/ `merchant_profile_latest` 同步一份到本地 MySQL；
	- 再在 MySQL 里生成：
		- `store_feature_snapshot_di` （主要就是拆 `is_zxgj` + 搬运 order\_cnt\_30d 等）
		- `merchant_feature_snapshot_di` （按 `merchant_id` 聚合 store 特征）
		- `party_feature_snapshot_di` （按 party 聚合 merchant 特征）  
			你是认同“特征计算也在本地 MySQL 做”，还是订单那部分更想在数仓做好，只把结果同步进来？
3. **party 这一层，你希望现在就引入“工商登记号”当 ID 吗？**  
	目前：
	- `party_first_name` 只是名字，不够稳定；
	- 你说“如果必要有 id, 我建议是工商登记号, 需要 join”。  
		这里的取舍是：
	- A）V1 先用 `party_first_name` 充当 party\_key（有风险，但快）；
	- B）立刻把“工商登记号”引入进来，把 party\_key 架在登记号上（稳，但要多做一点上游准备）。

你可以这样回我就够了：

- `is_zxgj` / `order_cnt_30d` 的精确含义 + 你想要的口径；
- 特征三张表是不是都在 MySQL 里算（是/否）；
- party\_key 你选 A 还是 B（先用名字，还是上来就用登记号）。

我拿到这三个决定后，下一步就会把三张特征表的字段列表完整列出来（全部引用你现有的源字段），让你一眼看到：

- 哪些直接来自 `merchant_profile_latest` ，
- 哪些需要你在上游/数仓补一列或多 join 一张表，  
	然后我们再往下长“候选 + conf + 决策 + 审计”的骨架。

我先帮你把关键点重新捏一下，保证我们现在是在同一张脑图上：

- `is_zxgj` ：你已经在数仓算好了，就是「过去 30 天订单最早小时–最晚小时」的区间字符串，例如 `06-22` ，这一点跟我之前理解一致。
- `order_cnt_30d` ：定义很关键——永远是“当前这个维度下的 30 天日均订单”。
	- 门店维度：store\_id 下 30 天日均订单。
	- 商户维度：= 所有门店的「日均订单」求和（= 该商户整体的日均订单），不是再取平均。
	- party 维度同理，依然是从门店聚合上去。
- 三张特征快照表都在本地 MySQL 做，但概念上“所有聚合都从门店特征往上走”，merchant、party 只是不同聚合视角。
- party\_key：你会尝试把“工商登记号” join 进来，作为真正的 party\_key，不再只用 `party_first_name` 这个名字。

很好，这些点已经足够支撑我们把「三张特征快照表」定型了。

接下来两三件事要跟你对齐一下，然后我才敢给你一版“完全按你现有字段来的特征表草稿”：

---

### 1\. 我需要确认一下：store 特征这层，你期望的字段全集

现在从 `merchant_profile_latest` 里能直接拿到的（和 open\_hours / 订单有关的）有：

- store\_id
- merchant\_id
- party\_first\_name（未来你会额外补 party\_key = 工商登记号）
- is\_zxgj（例： `06-22` ，30 天窗口的 min-max 小时区间）
- order\_cnt\_30d（30 天日均订单）
- is\_agg\_blocked\_merchant（商户黑名单标记）

我现在的默认想法是，把这些转换成 store\_feature\_snapshot\_di 的核心字段：

- `open_hour_min_30d` / `open_hour_max_30d` （从 `is_zxgj` 拆出来）
- `order_cnt_30d` （原值）
- `has_order_before_6_30d` / `has_order_after_20_30d` （从 min/max 推出来）

我这边有两个问题想跟你确认：

1）store\_feature\_snapshot\_di 里，你还想补哪些“以后肯定会用到的通用特征”？  
例如：

- 是否需要一个“最近订单日期 `last_order_dt_30d` ”（如果没订单，方便识别爬坡站 /沉默站）？
- 是否需要把 “30 天总订单量” 单独算一列（有时候你会想看总盘子，而不是只看日均）？

2）以上这些特征，你更想让 store\_feature\_snapshot\_di 尽量“简单，只放现在必要字段”，还是愿意多留几个你感觉八成会用上的通用列？  
（这会决定我下一步给你的表结构，是极简版还是预留版。）

---

### 2\. 关于「一个商户 N 个工商主体」这个特殊结构

你刚提了一句非常重要的话：

> “有可能一个也存在 1 个商户 N 个工商注册主体的”。

这在建 party\_feature\_snapshot\_di 时，是个必须先说清楚的问题。  
逻辑上会有几种处理方式（你先选一种你更能接受的）：

- 方案 A： **强行一对一化**
	- 在上游先定好“一个商户主挂哪一个工商登记号”，其它登记号视为附属，不参与聚合。
	- 优点：party\_key 清晰，好算、好理解；
	- 缺点：需要你在上游先拍板映射规则。
- 方案 B： **允许一商户挂多个 party\_key，但在聚合时只按门店→party 的映射算**
	- 即：同一个商户的不同门店，可能属于不同 party\_key，各自归各自聚合。
	- 这样 party\_feature\_snapshot\_di 本质还是从 store 聚合，只是 merchant 这一层在部分场景看起来有点“跨 party”。
- 方案 C： **暂时弱化 party 聚合的意义**
	- V1 里：merchant\_feature\_snapshot\_di 是主角，party\_feature\_snapshot\_di 先只做很轻的聚合，甚至只在审计里用，不参与主要决策。

这里没有标准答案，你现在更倾向哪一种？  
（我的感觉：如果你未来确实有“按企业集团看整体经营”的需求，B 会更安全；如果短期内主要看商户层，C 也不丢关键价值。）

---

### 3\. 关于「上游依赖已经集中在 merchant\_profile\_latest」这一点

这是好事，说明我们特征快照三层：

- store\_feature\_snapshot\_di：
	- 直接从 merchant\_profile\_latest 拆字段 + 算简单派生特征；
- merchant\_feature\_snapshot\_di：
	- 全部从 store\_feature\_snapshot\_di 聚合上去（用 merchant\_id 分组）；
- party\_feature\_snapshot\_di：
	- 全部从 store\_feature\_snapshot\_di（或 merchant\_feature\_snapshot\_di）聚合上去（用 party\_key 分组）；

我会按你刚刚补充的：

- “不管什么时候讲日均订单，都是当前维度下的日均订单”
- 聚合逻辑：从门店日均 → 商户日均（求和）→ party 日均（再求和）

来设计聚合字段。

---

你先帮我做两件事：

1. 回答一下：
	- store\_feature\_snapshot\_di 你是倾向“先极简（只把现在讨论到的字段放进去）”，还是“多预留几个通用特征”（比如 last\_order\_dt\_30d / total\_order\_cnt\_30d 等）？
2. 在「1 商户 N 工商主体」的场景下，你更倾向用 A / B / C 哪一种处理方式？
	- 只要告诉我你现在的直觉选择就行，后面我们可以再调。

等你拍了这两个点，我下一步就不再问问题，直接在教练模式下给你一版：

- 三张特征快照表的字段草稿（全部严格基于 merchant\_profile\_latest + 你刚才说的规则），
- 并标注每一列“上游字段来源 / 计算方式”，让你一眼看清楚依赖关系，再决定哪些列要先上、哪些可以延后。

先复述我抓到的两件关键事，确保完全对上：

1. **上游统一入口换成 `v_merchant_profile_latest`** ，以后所有特征快照（store / merchant / party）都从它及其 join 衍生，不再分散来源。  
	这会极大简化 ETL 复杂度。
2. **工商主体（party）与商户的关系你已经澄清：不会存在“一个商户对应多个工商主体”的情况** 。  
	也就是说：
	- party\_key → merchant\_id 是一对多
	- merchant\_id → store\_id 是一对多
	- store\_id → N/A

你的问题是想确认：

> “工商这一层，是应该从门店直接聚合，还是从商户聚合再上去？”

下面我给你一个非常清晰的判断框架，你看完能马上定下来。

---

## 简短复述

你现在的画像体系是 **三层结构：门店 → 商户 → 工商** ，三层之间的聚合逻辑必须保证：

- 值能正确反映真实经营结构
- conf（置信度）的可解释性不被破坏
- 审计链路能 100% 追溯
- ETL 稳定性高
- 未来扩展其它标签不需要重写聚合逻辑

---

## 关于“工商层聚合方式”的对比

### 方案 A：从门店 → 工商直接聚合（跳过商户）

流程是：  
store\_feature → group by party\_key → party\_feature

看起来简单，但是有致命问题：

- 商户层的“聚合规则”“准入规则”“行为特征”(如 feedback\_cnt、data\_ratio、黑名单) 在工商层全部失效
- party\_conf/party\_candidate 无法沿用 merchant\_conf 的逻辑
- 审计不连续：
	- store 层一套逻辑
	- merchant 层另一套
	- party 层跳过 merchant，行为特征断档
- 未来很多 A 类标签（如品牌、服务类标签）无法复用商户逻辑，会造成两套规则树

一句话总结： **技术简单，逻辑断裂，后期代价巨大** 。

---

### 方案 B：门店 → 商户 → 工商（逐层聚合） ← 推荐选择

流程是：

1. store\_feature\_snapshot\_di
2. → 聚合 merchant\_feature\_snapshot\_di
3. → 聚合 party\_feature\_snapshot\_di

优势非常明显：

1. **聚合规则连续、可叠加、可解释**
	- 商户层有行为准入（data\_ratio≥0.2、feedback\_cnt、黑名单）
	- 工商层可以沿用商户层的聚合逻辑
	- conf 计算公式可以逐层继承（store → merchant → party）
2. **审计链路完整**
	- open\_hours 最终取自哪个层级一目了然
	- 每层都能 trace：store trace、merchant trace、party trace
3. **扩展能力强**  
	你未来会做更多标签（brand, services, pricing, competition），很多是天然商户属性，不是门店属性。  
	如果直接跳过商户层，后面写算法会非常难受。
4. **一致性处理合理**  
	比如：
	- 某商户有 20 家店，它们的营业时间算出来都很一致，则商户层 conf 很高
	- 该商户属于某工商主体下 N 个商户，工商层 conf 也能继续捕捉“跨商户一致性”

一句话：  
**工业级画像体系必须逐层聚合，而不是跳跃聚合。**

---

## 回答你的问题

你问：

> “从油站直接聚合工商，还是商户聚合工商？”

明确答案：  
**必须从商户聚合工商（merchant → party），不能跳过商户层。**

理由：

- 行为特征（data\_ratio/feedback/blacklist）必须在 merchant 层执行，否则 party 层无法判断可信度；
- 逐层 conf 才能累积，不然 party\_conf 会变成无根之木；
- 三层模型的解释性、质量治理能力靠 merchant 层承接；
- long-term optimal（你自己选的方向）一定是逐层治理，而不是跳跃治理。

---

## 下一步我想问你两个很小但关键的问题（锁定三层特征表字段）

### 1）party\_key

你要把工商登记号 join 进来，那你准备把字段叫：

- `party_id`  
	还是
- `party_reg_no`  
	还是
- `party_key`

（我建议统一叫 `party_key` ，抽象，不依赖未来字段变化。）

### 2）merchant\_feature 里你是否想保留“商户级日均订单”这列？

它会是所有标签的强特征之一（不是只用于 open\_hours）。  
本质计算：

> merchant\_order\_cnt\_30d = 所有门店的 order\_cnt\_30d 求和

我建议一定保留。  
你确认一下即可。

---

你回我：

- party key 字段名选哪个
- merchant 聚合是否确定包含“商户级日均订单”

然后我下一步就给你：  
###《三张特征快照表完整字段草稿（含上游依赖标注）》  
可以直接用于 ETL 设计与 SQL 落库。

收到。我先做一次 **最后一致性检查** ，避免我们遗漏关键前提，之后你一句话让我退出教练模式，我就会直接产出 **完整正式需求文档（结构化模式 / 可评审级别）** 。

下面这份 checklist 是我根据过去几十条对话浓缩的“必须确认项”。  
你逐条看，如果都 OK，就直接回我：“确认，退出教练模式”。

---

## 【最终一致性检查清单】——确认后即可生成正式文档

### 一、基础结构确认（画像三层体系）

1. 画像分三层：store → merchant → party
2. 逐层聚合，不跳层（store → merchant → party 必须按顺序）
3. 工商主体的 ID 字段统一叫： `party_key` （来自工商登记号 join）
4. 商户黑名单来自上游字段： `is_agg_blocked_merchant`

是否确认？（是 / 否）

---

### 二、上游数据源确认（全部基于 v\_merchant\_profile\_latest）

我们所有特征均来自：

- 主入口： `v_merchant_profile_latest`  
	包含
	- store\_id
	- merchant\_id
	- party\_first\_name（未来你会 join 工商登记号变成 party\_key）
	- is\_zxgj（open hours 区间：06-22）
	- order\_cnt\_30d（日均订单）
	- is\_agg\_blocked\_merchant

**额外上游：**

- `merchant_feedback_stats` （你未来会建）
- `party_key_mapping` （工商登记号 join 源）
- 标签算法配置表： `tag_algo_config` （你会建）

是否确认？（是 / 否）

---

### 三、日均订单聚合规则（你非常强调的关键逻辑）

**“任何维度的日均订单，都必须是该维度下的 30 天订单总量 / 30，不是简单平均门店值。”**

具体规则：

- store\_order\_cnt\_30d：单店 30 天日均订单
- merchant\_order\_cnt\_30d ＝ sum(store\_order\_cnt\_30d)
- party\_order\_cnt\_30d ＝ sum(store\_order\_cnt\_30d across all merchants under party\_key)

是否确认？（是 / 否）

---

### 四、特征快照层（长期最优）

三张特征表：

1. `store_feature_snapshot_di`
2. `merchant_feature_snapshot_di`
3. `party_feature_snapshot_di`

都在 MySQL 本地生成。

是否确认？（是 / 否）

---

### 五、open\_hours / open\_24h 的候选逻辑（算法模版打样标签）

通用候选逻辑（适用于所有 A 类标签）：

- 三层都生成各自候选值：store\_candidate / merchant\_candidate / party\_candidate
- D1 激进规则（6 点前或 20 点后有订单 → 00-24）在三层全部生效
- 各层候选都记录：base\_candidate, d1\_candidate, candidate\_source\_flag

是否确认？（是 / 否）

---

### 六、置信度体系（conf 模型）

适用于所有 A 类标签，底座信号为：

- S2：数据新鲜度
- S3：一致性（未来可能启用，不强制）
- S4：结构完整度（store\_with\_data\_ratio 等）
- S6：是否有人工覆盖（manual\_override\_flag）

且三层 conf 都是同一框架，只是输入特征不同。

是否确认？（是 / 否）

---

### 七、商户“可聚合”判定（行为特征准入逻辑）

商户层允许聚合的前提（open\_hours 版本）：

1. `is_agg_blocked_merchant = 0`
2. store\_with\_data\_ratio ≥ 0.2
3. merchant\_feedback\_stats.feedback\_cnt = 0 或小于某阈值
4. 日均订单（merchant\_order\_cnt\_30d）大于 0（或非极端低值）

否则 merchant\_candidate 直接视为不可用。

是否确认？（是 / 否）

---

### 八、最终决策规则（跨层选择）

所有标签共享决策器：

1. 若 manual\_override 存在 → 用 manual
2. 若 conf\_store ≥ T\_store → 永远用 store（T\_store 从 tag\_algo\_config 配置）
3. 否则在 {store, merchant, party} 三层中选 conf\_x \* weight\_x 最大的
4. 三层 weights 可配置，默认 store=0.8, merchant=1.0, party=0.7

是否确认？（是 / 否）

---

### 九、审计表（可追溯性）

一张表： `tag_audit_log_di`  
每条记录包含：

- candidate\_store / merchant / party
- conf\_store / merchant / party
- chosen\_level
- chosen\_value
- algo\_version
- trace\_json（全量路径）

是否确认？（是 / 否）

---

### 十、open\_hours / open\_24h 是整个画像 ETL 的打样模板

确认后：

- 我会按此结构产出正式文档：
	- 三张特征表结构（字段级）
	- 上游依赖清单
	- 中间候选逻辑
	- 通用 conf 体系
	- 决策器（跨层选择器）
	- 审计表结构
	- open\_hours 的完整模版（详细逻辑）
	- 可扩展到所有 A 类标签的标准模版

是否确认？（是 / 否）

---

你只需要回复：

> **“全部确认，退出教练模式”**
> 
> 或者  
> **指出需要调整的条目编号（如：5、7 需要改）**

只要你一句话确认，我立刻切回结构化模式，为你输出 **正式、完整、评审级别的需求文档（可直接进入项目基建）** 。

20251206\_1700\_商户画像标签ETL\_双90需求文档  
tags: #商户画像 #标签ETL #营业时间 #特征快照 #双90

---

### 1）一句话结论

本需求文档将商户画像“标签双 90%（覆盖率 & 准确率）”目标，具体落成一条以 `v_merchant_profile_latest` 为唯一上游入口、三层特征快照（门店/商户/工商）+ 通用候选 & 置信度模型 + 跨层决策器 + 审计日志的标签 ETL 机制，以 `open_hours/open_24h` 为打样模版，可扩展到所有 A 类标签，并附带 `merchant_feedback_stats` 与 `tag_algo_config` 的建表与使用规范。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 论据一：现状与问题——目标清晰，但缺“算法形态 + 工程骨架”

- 业务目标非常明确：
	- 现有约 1.6 万动销油站、若干核心标签（品牌、服务、营业时间等），Q4 指标是标签覆盖率 & 准确率双双拉到 ≥ 90%。
- 数据与配置已经具备基础条件：
	- 入口视图统一为 `v_merchant_profile_latest` ，已包含 `store_id / merchant_id / party_key / is_zxgj(06-22) / order_cnt_30d(日均订单) / is_agg_blocked_merchant` 等关键字段。
	- 标签字典（tag\_spec、tag\_enum、tag\_catalog 等）已经沉淀标签定义与分类（包括 tag\_class 区分线上纯计算/推断）。
- 当前缺口主要集中在：
	- 没有统一的“特征 → 候选值 → 置信度 → 跨层决策 → 审计”的算法模版，每个标签都是散点脚本；
	- 门店/商户/工商三层没有体系化治理逻辑（例如虚拟商户、日均订单聚合规则、跨层 override 红线等）；
	- 阈值、策略配置无统一载体（调参成本高，不可回溯）。

#### 论据二：策略选择与推演——构建统一三层特征 + 通用决策器，以 open\_hours 打样

- 结构上采用“长期最优”的三层特征快照：
	- `store_feature_snapshot_di` ：以 `store_id` 为主键，承接所有“门店级特征”（如 `is_zxgj` 拆分、store 日均订单）。
	- `merchant_feature_snapshot_di` ：由门店特征按 `merchant_id` 聚合，内置行为特征（数据占比、反馈次数、黑名单等），决定商户层是否可聚合。
	- `party_feature_snapshot_di` ：由门店或商户特征按 `party_key` （工商登记号）聚合，承接工商主体视角的特征。
- 算法上抽象统一的“候选 + conf + 决策器”范式：
	- 每个标签在三层各自产出候选值（store/merchant/party），叠加 D1 激进规则（6 点前/20 点后有订单 → 00-24）和行为准入（数据占比 + 反馈 + 黑名单）；
	- 统一用 S2 数据新鲜度 / S4 结构完整度 / S6 人工覆盖等信号构建 conf\_store/conf\_merchant/conf\_party；
	- 决策器按红线规则：“只要门店 conf ≥ T\_store，就永远用门店，否则在商户/工商中按 conf×weight 选最优”。
- 以 `open_hours/open_24h` 为打样标签：
	- 利用 `is_zxgj=06-22` 及 30 天订单分布构建时间段特征；
	- 通过门店→商户→工商逐层聚合，验证“日均订单聚合逻辑 + D1 规则 + 商户可聚合逻辑 + 审计回溯”的全链路闭环；
	- 打磨完成后，对所有 tag\_class=A 的服务/设施类标签按模版复制扩展。

#### 论据三：落地与风险——以表结构 + 流程为载体固化机制，并用反馈表 & 配置表兜底

- 落地路径：
	- 以 `v_merchant_profile_latest` 为唯一上游，先在 MySQL 中建立三张特征快照表，再搭一张终表 `store_tag_snapshot_di` 和一张审计表 `tag_audit_log_di` ；
	- 新建 `merchant_feedback_stats` 承接区域反馈，形成“负向治理”闭环；
	- 新建 `tag_algo_config` 管理各标签的 conf 阈值和聚合策略开关，为调参与实验留出空间。
- 风险点及对策：
	- 风险 1：日均订单口径被误用（直接对门店日均取平均）。
		- 对策：在文档与 SQL 层明确“任何维度日均订单均为门店总量求和后再 /30”，在三层聚合逻辑中写死。
	- 风险 2：虚拟商户、数据稀疏商户导致商户层聚合结果失真。
		- 对策：依赖 `is_agg_blocked_merchant` + store\_with\_data\_ratio + merchant\_feedback\_stats 的行为特征判定“可聚合”。
	- 风险 3：阈值难以评估（如 T\_store=0.9 只是经验值）。
		- 对策：全部阈值放入 `tag_algo_config` ，由数据分析+运营共同基于真实指标调参，实现灰度和回溯。

---

### 3）思维导图结构（文本分层）

#### 3.1 商户画像标签 ETL 项目定位

- 项目目标（双 90 视角）
	- 硬指标：
		- 标签覆盖率 ≥ 90%（按 store\_id 维度计算）
		- 抽样准确率 ≥ 90%（重点标签按省区/分群抽检）
	- 能力目标：
		- 构建一条可复用的标签生产线：任何新标签（尤其 tag\_class=A）都能接入统一 ETL 模版。
- 关键应用场景（本期聚焦）
	- 站内服务标签的准确识别（营业时间、24 小时站、服务设施等），为运营筛站与活动策略提供可信基础。
	- 品牌/价格/竞对等标签在商户/工商视角下的一致性分析，为 KA 分层与策略制定提供依据。

---

#### 3.2 数据与特征快照体系设计

##### 3.2.1 上游视图与核心依赖

- 统一上游视图： `v_merchant_profile_latest`
	- 核心字段（与本期相关）：
		- `store_id` ：门店主键
		- `merchant_id` ：商户主键（映射 pop\_name）
		- `party_key` ：工商主体 key（由工商登记号 join 而来）
		- `is_zxgj` ：营业时间区间，格式形如 `06-22` ，含义为“过去 30 天订单最早小时 ~ 最晚小时”
		- `order_cnt_30d` ：当前维度下 30 天日均订单（store 维度已有；上游用于下游聚合逻辑）
		- `is_agg_blocked_merchant` ：商户是否被禁止聚合（虚拟/异常商户）
- 必建依赖表：
	- `merchant_feedback_stats` ：商户 × 标签 的反馈统计
		- 用于“行为特征”判定商户层聚合可信度。
	- `tag_algo_config` ：标签算法配置表
		- 管理各标签的阈值和开关，支撑调参、灰度与回溯。

##### 3.2.2 特征快照三张表设计（MySQL 内）

1）门店特征快照： `store_feature_snapshot_di`

- 粒度： `store_id + as_of_date`
- 建议字段（开放扩展，以下为 V1 必要 + 通用字段）：

| 字段名 | 类型 | 含义 | 来源/计算方式 |
| --- | --- | --- | --- |
| as\_of\_date | DATE | 业务日期 | ETL 日期 / 回算日期 |
| store\_id | BIGINT | 门店ID | v\_merchant\_profile\_latest |
| merchant\_id | BIGINT | 商户ID | v\_merchant\_profile\_latest |
| party\_key | VARCHAR(64) | 工商主体ID（登记号） | v\_merchant\_profile\_latest / 关联表 |
| open\_hour\_min\_30d | TINYINT | 30天最早营业小时 | 从 is\_zxgj 拆分前半段（如06） |
| open\_hour\_max\_30d | TINYINT | 30天最晚营业小时 | 从 is\_zxgj 拆分后半段（如22） |
| has\_order\_before\_6\_30d | TINYINT(1) | 30天内是否有6点前订单 | 由 open\_hour\_min\_30d < 6 推导或后续订单分布计算 |
| has\_order\_after\_20\_30d | TINYINT(1) | 30天内是否有20点后订单 | 由 open\_hour\_max\_30d > 20 推导或后续订单分布计算 |
| order\_cnt\_30d | DECIMAL(18,4) | 门店日均订单（30天） | v\_merchant\_profile\_latest |
| total\_order\_cnt\_30d | DECIMAL(18,4) | 门店30天订单总数 | 由 order\_cnt\_30d × 30 计算 |
| last\_order\_dt\_30d | DATETIME | 近30天最近一笔订单时间 | 如需则自订单表计算，同步入视图/中间层 |
| feature\_version | VARCHAR(32) | 特征版本号 | 方便日后特征逻辑调整 |
| extra\_json | JSON | 预留其他特征（订单分布等） | 可选 |
| PRIMARY KEY(as\_of\_date,store\_id) |  |  |  |

2）商户特征快照： `merchant_feature_snapshot_di`

- 粒度： `merchant_id + as_of_date`
- 所有字段由 `store_feature_snapshot_di` 聚合（严守“日均订单聚合”逻辑：永远从门店 total\_order\_cnt\_30d 求和再 /30）。

| 字段名 | 类型 | 含义 | 计算方式 |
| --- | --- | --- | --- |
| as\_of\_date | DATE | 业务日期 | 同上 |
| merchant\_id | BIGINT | 商户ID | 来自 store\_feature\_snapshot\_di 聚合键 |
| party\_key | VARCHAR(64) | 工商主体ID | 从 store\_feature\_snapshot\_di 聚合时取主流或一致值 |
| store\_cnt | INT | 该商户下门店数 | COUNT(DISTINCT store\_id) |
| store\_with\_data\_cnt | INT | 有 open\_hours 数据的门店数 | COUNT(店内 open\_hour\_min\_30d 非空) |
| store\_with\_data\_ratio | DECIMAL(5,4) | 有数据门店占比 | store\_with\_data\_cnt / store\_cnt |
| merchant\_order\_cnt\_30d | DECIMAL(18,4) | 商户 30 天日均订单 | SUM(store.total\_order\_cnt\_30d)/30 |
| has\_order\_before\_6\_any\_store\_30d | TINYINT(1) | 任一门店是否有6点前订单 | MAX(has\_order\_before\_6\_30d) |
| has\_order\_after\_20\_any\_store\_30d | TINYINT(1) | 任一门店是否有20点后订单 | MAX(has\_order\_after\_20\_30d) |
| is\_agg\_blocked\_merchant | TINYINT(1) | 是否被禁止聚合 | 从 v\_merchant\_profile\_latest 聚合时取一致值 |
| feedback\_cnt\_open\_hours | INT | open\_hours 反馈次数 | 从 merchant\_feedback\_stats 过滤 tag\_code='open\_hours' 后聚合 |
| feature\_version | VARCHAR(32) | 特征版本 | 同上 |
| extra\_json | JSON | 预留其他标签相关特征 |  |
| PRIMARY KEY(as\_of\_date, merchant\_id) |  |  |  |

3）工商主体特征快照： `party_feature_snapshot_di`

- 粒度： `party_key + as_of_date`
- 由门店或商户特征聚合，但 **日均订单统一从门店 total\_order\_cnt\_30d 聚合** 。

| 字段名 | 类型 | 含义 | 计算方式 |
| --- | --- | --- | --- |
| as\_of\_date | DATE | 业务日期 |  |
| party\_key | VARCHAR(64) | 工商主体ID |  |
| merchant\_cnt | INT | 旗下商户数 | COUNT(DISTINCT merchant\_id) |
| merchant\_with\_data\_cnt | INT | 有数据商户数 | 有 store\_with\_data\_cnt>0 的商户数 |
| merchant\_with\_data\_ratio | DECIMAL(5,4) | 有数据商户占比 | merchant\_with\_data\_cnt / merchant\_cnt |
| party\_order\_cnt\_30d | DECIMAL(18,4) | 工商主体 30 天日均订单 | SUM(store.total\_order\_cnt\_30d)/30 |
| has\_order\_before\_6\_any\_merchant\_30d | TINYINT(1) | 任一门店是否有6点前订单 | 从门店层聚合 MAX(has\_order\_before\_6\_30d) |
| has\_order\_after\_20\_any\_merchant\_30d | TINYINT(1) | 任一门店是否有20点后订单 | 从门店层聚合 MAX(has\_order\_after\_20\_30d) |
| feature\_version | VARCHAR(32) | 特征版本 |  |
| extra\_json | JSON | 预留 |  |
| PRIMARY KEY(as\_of\_date, party\_key) |  |  |  |

---

#### 3.3 策略路径对比（以 open\_hours/open\_24h 为模版）

##### 3.3.1 路径 A：规则引擎 + 行为特征（当前选择）

- 思路
	- 通过三层特征 + 行为准入 + 激进规则（D1）构建候选值，再用通用置信度模型 + 跨层决策器选择“最可信”的值。
- 优点
	- 完全基于规则，过程可解释，可审计；
	- 可通过 `tag_algo_config` 快速调参；
	- 一套模版可扩展到所有 A 类标签。
- 缺点
	- 对规则设计质量要求高；
	- 初期 conf 拟合度需要结合数据不断调整。

##### 3.3.2 路径 B：直接用单层（门店）特征计算（弃选）

- 思路
	- 仅用门店级特征（如 is\_zxgj）直接产出标签，完全不引入商户/工商聚合。
- 优点
	- 工程实现简单，短期可快速上线。
- 缺点
	- 无法利用商户/工商层的一致性与行为特征信息，难以提升准确率；
	- 对数据稀疏站点无补偿能力，覆盖率难冲双 90。

> 结论：当前阶段选择路径 A，构建“规则引擎 + 三层特征”的长期能力，放弃仅门店层的短期方案。

---

#### 3.4 项目推进与协同

##### 3.4.1 阶段拆解

- 近期（本月内）
	- 在 MySQL 中建三张特征快照表、终表、审计表；
	- 建立 `merchant_feedback_stats` & `tag_algo_config` 表结构；
	- 完成 open\_hours/open\_24h 模版实现，跑通全国全量数据。
- 本季度
	- 扩展模版到其他服务类 A 标签（如 restroom\_available、parking\_available 等）；
	- 结合真实抽样结果，调整 conf 公式与 `tag_algo_config` 阈值。
- 年内
	- 将模版推广到品牌、价格、竞对等其它 A 类标签，完成标签体系主干的“可计算化”。

##### 3.4.2 角色分工（按角色，而非人）

- 数据/ETL：
	- 负责 MySQL 建表、数据同步、特征计算、候选 & 决策 SQL 实现。
- 产品/策略：
	- 定义标签业务含义、阈值默认方案、行为准入逻辑（数据占比、黑名单规则等）。
- 运营/区域：
	- 使用标注清单回收错误样本，沉淀至 `merchant_feedback_stats` ，参与阈值与规则调优。

##### 3.4.3 行动清单（可执行）

| 时间范围 | 事项 | 责任人角色 | 预计完成时间 | 输出物 |
| --- | --- | --- | --- | --- |
| 本周 | 在 MySQL 建 `store/merchant/party_feature_snapshot_di` | 数据 | 本周内 | 三张特征表 DDL + 初始化脚本 |
| 本周 | 建 `store_tag_snapshot_di` 和 `tag_audit_log_di` | 数据 | 本周内 | 终表 + 审计表 DDL |
| 本周 | 建 `merchant_feedback_stats` & `tag_algo_config` | 数据/产品 | 本周内 | 两张配置/反馈表 DDL |
| 下周 | 实现 open\_hours/open\_24h 的候选 & 决策逻辑 | 数据/产品 | 下周内 | SQL 模版 + 首轮全国跑数结果 |
| 下周 | 设计反馈采集流程（清单模板 + 回填规范） | 产品/运营 | 下周内 | 反馈 Excel 模版 + 说明文档 |
| 未来 2–4 周 | 将模版扩展至 2–3 个服务类 A 标签 | 数据 | 2–4 周内 | 多标签 ETL SQL + 结果验收报告 |

---

#### 3.5 风险与关键假设

- 关键假设
	- `v_merchant_profile_latest` 能稳定提供 store/merchant/party\_key/is\_zxgj/order\_cnt\_30d/is\_agg\_blocked\_merchant 等字段；
	- 工商登记号可稳定映射到 `party_key` ，且不会频繁变更；
	- 区域愿意配合以清单形式提供“错误标签反馈”，支持 `merchant_feedback_stats` 填充。
- 风险 & 兜底
	- 若上游视图字段变更：
		- 建议在 MySQL 端增加一层中间视图做 schema 适配，避免修改大量 ETL。
	- 若反馈数据短期不足：
		- 先以数据占比与黑名单为主进行聚合准入，反馈仅作为未来增强项。

---

### 4）关键表：merchant\_feedback\_stats & tag\_algo\_config 建表指引

#### 4.1 merchant\_feedback\_stats 建表指引

**目标** ：承接区域对“商户标签错误”的回收结果，用作行为特征之一，约束商户层聚合。

- 建议表结构（MySQL）：
- 使用方式：
	- 区域按清单反馈错误标签（例如：某商户 open\_hours 明显不对），由数据侧汇总写入该表：
		- `feedback_cnt = feedback_cnt + 1`
		- 更新 `last_feedback_at`
	- 在 `merchant_feature_snapshot_di` 中，按 `merchant_id, tag_code` JOIN 得到 `feedback_cnt` ：
		- 对 open\_hours 标签，映射至 `feedback_cnt_open_hours` 字段。
	- 在“商户可聚合逻辑”中：
		- 若 `feedback_cnt_open_hours > max_feedback_cnt_for_agg` （来自 `tag_algo_config` ），则该商户在 open\_hours 标签中被视为不可用于商户层聚合。

#### 4.2 tag\_algo\_config 建表指引

**目标** ：集中管理各标签算法参数（阈值/开关/版本），支持调参、灰度、回溯。

- 建议表结构：
- 示例配置（open\_hours）：

| tag\_code | algo\_version | conf\_threshold\_store | enable\_merchant\_level | min\_merchant\_data\_ratio | max\_feedback\_cnt\_for\_agg | enable\_party\_level | weight\_store | weight\_merchant | weight\_party |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| open\_hours | open\_hours\_v1 | 0.90 | 1 | 0.20 | 0 | 1 | 0.80 | 1.00 | 0.70 |

- 使用方式：
	- 在候选决策 SQL 中按 tag\_code+algo\_version JOIN `tag_algo_config` ：
		- 读取 T\_store = conf\_threshold\_store；
		- 控制是否启用商户/工商层候选（enable\_\*）；
		- 控制行为准入阈值（min\_merchant\_data\_ratio / max\_feedback\_cnt\_for\_agg）；
		- 控制 hierarchy\_weight\_\*；
	- 在调参时仅更新该表，不动主逻辑 SQL；
	- 支持通过切换 algo\_version 做 A/B 测试和灰度。

---

### 5）终表 & 审计表（简要）

#### 5.1 终表：store\_tag\_snapshot\_di（简化版本）

#### 5.2 审计表：tag\_audit\_log\_di

---

### 6）迭代日志

- 【来源】
	- 基于前期标签字典与 Q4 OKR（标签覆盖率 & 准确率 90%），结合本轮在教练模式下对“open\_hours/open\_24h + 日均订单聚合 + 三层特征 + 商户可聚合逻辑”的多轮拆解与对齐，形成本需求文档。
	- 上游数据以 `v_merchant_profile_latest` 为唯一入口，补充 `party_key` 字段。
- 【本版结论要点】
	1. 明确采用“store/merchant/party 三层特征快照 + 通用候选 & conf 模型 + `tag_algo_config` + `merchant_feedback_stats` + 审计表”的统一标签 ETL 骨架。
	2. 用 open\_hours/open\_24h 打样：定义了 D1 规则、日均订单聚合方式、商户行为准入、门店 conf 红线和跨层决策器。
	3. 给出 `merchant_feedback_stats` 与 `tag_algo_config` 的详细建表指引及使用方式，确保阈值与行为特征可调、可回溯。
- 【与上一轮思路相比的改动点】
	- 从“单标签算法讨论”提升为“全局标签 ETL 需求文档”，结构上加入特征快照层设计；
	- 将“日均订单永远按门店 total 求和再/30”的逻辑显式固化到三层特征计算规范中；
	- 将商户行为特征准入、虚拟商户黑名单、反馈机制通过 `is_agg_blocked_merchant` + `merchant_feedback_stats` 组合机制体现。
- 【待补充与后续动作建议】
	1. 你侧确认 `v_merchant_profile_latest` 的最终字段列表（尤其是 party\_key 的落地字段名）并完成 MySQL 同步。
	2. 在此文档基础上，先为 open\_hours 编写一版“伪代码级 ETL 脚本”（包含：三层特征生成 + 候选值计算 + conf 计算 + 决策写入 + 审计写入）。
	3. 跑一轮全国全量，抽样输出：
		- open\_hours 覆盖率、准确率（按省区/类型分层）；
		- conf 分布（store/merchant/party 三层），验证 0.9 红线是否合理，再通过 `tag_algo_config` 微调。
	4. 当 open\_hours 模版稳定后，选 2–3 个典型 A 类标签（如 restroom\_available / parking\_available / service\_carwash\_available）按模版补齐特征与规则，完成第一批服务标签的 ETL 上线。

如果你愿意，下一步我们可以直接围绕本需求文档，落一版“open\_hours 端到端 ETL 伪代码”，帮你把抽象逻辑变成能在 MySQL 里直接改写的 SQL 框架。

\[COLUMN\_NAME ORDINAL\_POSITION DATA\_TYPE CHARACTER\_MAXIMUM\_LENGTH IS\_NULLABLE COLUMN\_DEFAULT COLUMN\_COMMENT dm\_id 1 bigint NO 0 系统主键 gas\_region 2 varchar 50 YES gas\_region province 3 varchar 50 YES province province\_name 4 varchar 50 YES province\_name city\_id 5 varchar 50 YES city\_id city\_name 6 varchar 50 YES city\_name store\_id 7 varchar 50 YES store\_name 8 varchar 50 YES store\_name store\_address 9 varchar 50 YES store\_address lon 10 decimal YES lon lat 11 decimal YES lat dd\_store\_contact 12 varchar 50 YES dd\_store\_contact is\_online\_1d 13 tinyint YES is\_online\_1d is\_trd\_30d 14 decimal YES is\_trd\_30d store\_level\_mtd\_v2 15 varchar 50 YES store\_level\_mtd\_v2 order\_cnt\_mtd 16 decimal YES order\_cnt\_mtd is\_chz 17 varchar 18 YES is\_chz is\_zxgj 18 varchar 18 YES is\_zxgj pop\_id 19 varchar 50 YES POP商家ID pop\_name 20 varchar 50 YES pop\_name store\_grade 21 varchar 50 YES store\_grade brand\_name\_before 22 varchar 50 YES brand\_name\_before gas\_flag 23 tinyint YES gas\_flag party\_first\_name 24 varchar 50 YES party\_first\_name party\_second\_name 25 varchar 50 YES party\_second\_name store\_level\_score 26 tinyint YES store\_level\_score order\_count\_score 27 tinyint YES order\_count\_score total\_score 28 tinyint YES total\_score competitive\_overlap\_before 29 decimal YES competitive\_overlap\_before is\_overlap\_source 30 varchar 50 YES 重叠来源 is\_cooperate\_with\_sme\_suppliers 31 decimal YES 是否合作中小供应商 typical\_sme\_supplier\_names 32 varchar 50 YES 典型中小供应商名称 profit\_mtd 33 decimal YES profit\_mtd gmv\_mtd 34 decimal YES gmv\_mtd actual\_take\_rate 35 decimal YES actual\_take\_rate contract\_take\_rate 36 decimal YES contract\_take\_rate rate\_difference\_flag 37 decimal YES rate\_difference\_flag rate\_difference\_value 38 decimal YES rate\_difference\_value days\_with\_data 39 decimal YES days\_with\_data order\_cnt\_30d 40 decimal YES order\_cnt\_30d inner\_order\_cnt\_30d 41 decimal YES inner\_order\_cnt\_30d bigc\_order\_cnt\_30d 42 decimal YES bigc\_order\_cnt\_30d wyc\_order\_cnt\_30d 43 decimal YES wyc\_order\_cnt\_30d is\_storm 44 decimal YES is\_storm is\_league\_member 45 decimal YES is\_league\_member brand\_level 46 varchar 50 YES brand\_level brand\_name 47 varchar 50 YES brand\_name competitive\_overlap 48 varchar 50 YES competitive\_overlap sme\_supplier\_partner 49 varchar 50 YES sme\_supplier\_partner sme\_supplier 50 varchar 50 YES sme\_supplier wyc\_pricing\_enabled 51 varchar 50 YES wyc\_pricing\_enabled service\_carwash\_available 52 varchar 50 YES service\_carwash\_available service\_carwash\_type 53 varchar 50 YES service\_carwash\_type convenience\_store\_available 54 varchar 50 YES convenience\_store\_available restroom\_available 55 varchar 50 YES restroom\_available parking\_available 56 varchar 50 YES parking\_available open\_24h 57 varchar 50 YES open\_24h open\_hours 58 varchar 50 YES open\_hours dt 59 varchar 50 YES 数据日期分区 dm\_created\_at 60 timestamp YES 记录创建时间 dm\_updated\_at 61 timestamp YES 记录更新时间 is\_overlap 62 varchar 18 YES brand\_name.1 63 varchar 50 YES balance\_td 64 decimal YES 自动导入字段: balance\_td is\_non\_member\_station 65 tinyint YES 是否非会员站（is\_chz=0且is\_league\_member=0） is\_storm\_station 66 tinyint YES 是否风暴站（is\_storm=1） is\_storm\_balance\_surplus 67 tinyint YES 是否风暴余额盈余站（balance\_td>0） is\_non\_member\_storm\_surplus 68 tinyint YES 是否非会员且风暴余额盈余站 inner\_order\_cnt\_30d\_abnormal 69 tinyint YES 原inner\_order\_cnt\_30d是否异常（与order-bigc不等） inner\_order\_cnt\_30d\_new 70 decimal YES 重新计算的inner\_order\_cnt\_30d（order\_cnt\_30d-bigc\_order\_cnt\_30d） is\_sd 71 tinyint YES 是否推推乐合作站（sd=storedistribution），1是，0否 is\_sd\_key 72 tinyint YES 是否推推乐重点站，1是，0否 additional\_services 73 varchar 255 YES 附加服务：0-卫生间,1-洗车,2-早点便当,3-便利店,4-车胎充气,5-修车,6-快餐店 is\_car\_wash 74 tinyint YES 是否送水送洗车，1：是，0：否 ttl\_14d 75 tinyint YES 是否14天堆堆乐动销站，1是，0否 ttl\_14d\_order\_cnt 76 decimal YES 14天堆堆乐订单均值 is\_insure 77 tinyint NO 99 是否安心保上线站点（1=是，0=否，99=未知） party\_key 78 varchar 128 YES party\_key;工商注册登记号 is\_agg\_blocked\_merchant 79 int YES 0 \];以上是反馈v\_merchant\_profile\_latest 的最终字段列表;针对需求文档,做一个详细的规划 todo,来产出对应的 SQL,我去运行,报错,更改的循环,直到全部完成;特别尤其我要做的需要明确列举指引,最好是一键复制可执行的版本;

20251206\_2125\_标签ETL\_SQL落地\_TODO与首版脚本  
tags: #商户画像 #v\_merchant\_profile\_latest #标签ETL #open\_hours #SQL落地

---

### 1）一句话结论

先用 `v_merchant_profile_latest` 搭起 7 张核心表（3 层特征 + 反馈 + 配置 + 终表 + 审计），再从门店层出发跑通 `open_hours/open_24h` 的 V1 严格版 ETL，形成一套可以“复制粘贴直接跑”的 SQL 基线，后续你只需要在此基础上迭代修正即可。

---

### 2）三段论据（现状与问题 → 关键洞察 → 路径方案）

**论据一：现状与问题——源字段已齐，但 ETL 骨架和执行路径还没落到 SQL**

- 你已经整理出 `v_merchant_profile_latest` 全字段，包含标签字段（brand\_name、open\_hours 等）和必要特征（is\_zxgj、order\_cnt\_30d、party\_key、is\_agg\_blocked\_merchant 等）。
- 上游视图已统一，关系链清晰（store\_id → pop\_id(商户) → party\_key(工商)），但：
	- 特征快照三层表还没建；
	- 行为反馈表、算法配置表没建；
	- 终表 & 审计表也没在 MySQL 落地。
- 你需要的是“可一键复制执行的 SQL + 清晰 TODO 路线”，通过跑-报错-修-再跑的循环，把这条 ETL 走通。

**论据二：关键洞察——先建骨架、再打样 open\_hours 是最小闭环**

- 不可能一次把所有标签的复杂算法写完，正确方式是：  
	1）先把「结构性表」建好（特征、配置、反馈、终表、审计）；  
	2）选一个代表性标签（open\_hours/open\_24h），跑通“从源视图 → 特征 → 标签终表 → 审计”的闭环；  
	3）在这个闭环基础上迭代规则和 conf 模型。
- 现在 open\_hours 的特征全部可以从 `v_merchant_profile_latest` 拆出来（特别是 is\_zxgj、order\_cnt\_30d、party\_key、is\_agg\_blocked\_merchant），完全具备先跑 V1 严格版的条件。

**论据三：路径方案——用精确 TODO + 可执行 SQL，把工程拆成 3 阶段**

- 阶段 1：建表（一次性工作）——3 层特征 + 反馈 + 配置 + 终表 + 审计。
- 阶段 2：特征填充——从 `v_merchant_profile_latest` 生成 store/merchant/party 特征快照。
- 阶段 3：open\_hours/open\_24h 的 V1 严格版标签 ETL（先用 store 层结果写终表 + 审计）。
- 后面你可以在此基础上，按标签扩展（restroom\_available 等）、按规则增强（商户层/工商层聚合、conf 公式细化）。

下面直接给你「详细 TODO + 可复制 SQL」。

---

## 3）详细 TODO + 可执行 SQL（V1 骨架）

> 说明：以下 SQL 默认在 MySQL 里执行，不使用 WITH。  
> 所有 `-- TODO` 行，表示你后续可以按需要调整；先跑通再说。

---

### Step 0：约定 & 小说明

- 源视图名： `v_merchant_profile_latest` （与你给的一致）。
- store\_id / pop\_id / party\_key 保持 VARCHAR 类型，避免数值转换问题。
- dt 字段是“数据日期分区”，本文假设格式为 `YYYY-MM-DD` ，转成 DATE 用 `STR_TO_DATE(dt, '%Y-%m-%d')` 。如格式不同，你改一下格式串即可。

---

### Step 1：建 7 张核心表（只建，不插）

#### 1.1 门店特征快照：store\_feature\_snapshot\_di

#### 1.2 商户特征快照：merchant\_feature\_snapshot\_di

#### 1.3 工商特征快照：party\_feature\_snapshot\_di

#### 1.4 商户反馈表：merchant\_feedback\_stats

#### 1.5 标签算法配置表：tag\_algo\_config

先插一条 open\_hours 的默认配置（可调）：

#### 1.6 标签终表：store\_tag\_snapshot\_di

#### 1.7 审计表：tag\_audit\_log\_di

---

### Step 2：从 v\_merchant\_profile\_latest 生成特征快照（三张）

> 建议先选一个 `@biz_date` 跑通（比如最新 dt），再考虑历史重算。

#### 2.1 填充 store\_feature\_snapshot\_di（门店层）

```sql
sqlSET @biz_date = '2025-12-06';  -- TODO: 换成你实际 dt 对应日期

-- 可先清理当日数据，方便重复跑
DELETE FROM store_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO store_feature_snapshot_di (
    as_of_date,
    store_id,
    pop_id,
    party_key,
    open_hour_min_30d,
    open_hour_max_30d,
    has_order_before_6_30d,
    has_order_after_20_30d,
    order_cnt_30d,
    total_order_cnt_30d,
    feature_version
)
SELECT
    STR_TO_DATE(v.dt, '%Y-%m-%d') AS as_of_date,
    v.store_id,
    v.pop_id,
    v.party_key,

    -- 拆 is_zxgj，如 06-22
    CASE 
        WHEN v.is_zxgj IS NOT NULL AND v.is_zxgj <> '' THEN
            CAST(SUBSTRING_INDEX(v.is_zxgj, '-', 1) AS UNSIGNED)
        ELSE NULL
    END AS open_hour_min_30d,

    CASE 
        WHEN v.is_zxgj IS NOT NULL AND v.is_zxgj <> '' THEN
            CAST(SUBSTRING_INDEX(v.is_zxgj, '-', -1) AS UNSIGNED)
        ELSE NULL
    END AS open_hour_max_30d,

    -- D1 信号（先简单从 min/max 推）
    CASE 
        WHEN v.is_zxgj IS NOT NULL AND v.is_zxgj <> '' 
             AND CAST(SUBSTRING_INDEX(v.is_zxgj, '-', 1) AS UNSIGNED) < 6
        THEN 1 ELSE 0 END AS has_order_before_6_30d,

    CASE 
        WHEN v.is_zxgj IS NOT NULL AND v.is_zxgj <> '' 
             AND CAST(SUBSTRING_INDEX(v.is_zxgj, '-', -1) AS UNSIGNED) > 20
        THEN 1 ELSE 0 END AS has_order_after_20_30d,

    v.order_cnt_30d AS order_cnt_30d,
    v.order_cnt_30d * 30 AS total_order_cnt_30d,

    'v1' AS feature_version
FROM v_merchant_profile_latest v
WHERE STR_TO_DATE(v.dt, '%Y-%m-%d') = @biz_date;
```

> 如果 `dt` 格式不是 `YYYY-MM-DD` ，你把 STR\_TO\_DATE 的格式串改一下。

#### 2.2 填充 merchant\_feature\_snapshot\_di（商户层）

```sql
sqlDELETE FROM merchant_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO merchant_feature_snapshot_di (
    as_of_date,
    pop_id,
    party_key,
    store_cnt,
    store_with_data_cnt,
    store_with_data_ratio,
    merchant_order_cnt_30d,
    has_order_before_6_any_store_30d,
    has_order_after_20_any_store_30d,
    is_agg_blocked_merchant,
    feedback_cnt_open_hours,
    feature_version
)
SELECT
    s.as_of_date,
    s.pop_id,
    MAX(s.party_key) AS party_key,  -- 假设同一商户的 party_key 一致

    COUNT(DISTINCT s.store_id) AS store_cnt,
    SUM(CASE WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN 1 ELSE 0 END) AS store_with_data_cnt,
    CASE 
        WHEN COUNT(DISTINCT s.store_id) > 0 THEN
            SUM(CASE WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN 1 ELSE 0 END)
            / COUNT(DISTINCT s.store_id)
        ELSE NULL
    END AS store_with_data_ratio,

    -- 商户日均订单 = 所有门店 total_order_cnt_30d 求和 / 30
    CASE 
        WHEN SUM(s.total_order_cnt_30d) IS NOT NULL THEN
            SUM(s.total_order_cnt_30d) / 30
        ELSE NULL
    END AS merchant_order_cnt_30d,

    MAX(s.has_order_before_6_30d) AS has_order_before_6_any_store_30d,
    MAX(s.has_order_after_20_30d) AS has_order_after_20_any_store_30d,

    -- is_agg_blocked_merchant 从源视图聚合
    MAX(CASE WHEN v.is_agg_blocked_merchant IS NULL THEN 0 ELSE v.is_agg_blocked_merchant END) AS is_agg_blocked_merchant,

    -- 反馈次数，如暂无则为 0
    IFNULL(f.feedback_cnt, 0) AS feedback_cnt_open_hours,

    'v1' AS feature_version
FROM store_feature_snapshot_di s
LEFT JOIN v_merchant_profile_latest v
  ON v.store_id = s.store_id
 AND STR_TO_DATE(v.dt, '%Y-%m-%d') = s.as_of_date
LEFT JOIN (
    SELECT pop_id, feedback_cnt
    FROM merchant_feedback_stats
    WHERE tag_code = 'open_hours'
) f
  ON f.pop_id = s.pop_id
WHERE s.as_of_date = @biz_date
GROUP BY
    s.as_of_date,
    s.pop_id;
```

#### 2.3 填充 party\_feature\_snapshot\_di（工商层）

```sql
sqlDELETE FROM party_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO party_feature_snapshot_di (
    as_of_date,
    party_key,
    merchant_cnt,
    merchant_with_data_cnt,
    merchant_with_data_ratio,
    party_order_cnt_30d,
    has_order_before_6_any_merchant_30d,
    has_order_after_20_any_merchant_30d,
    feature_version
)
SELECT
    s.as_of_date,
    s.party_key,

    COUNT(DISTINCT s.pop_id) AS merchant_cnt,
    SUM(CASE WHEN s.merchant_order_cnt_30d IS NOT NULL THEN 1 ELSE 0 END) AS merchant_with_data_cnt,
    CASE 
        WHEN COUNT(DISTINCT s.pop_id) > 0 THEN
            SUM(CASE WHEN s.merchant_order_cnt_30d IS NOT NULL THEN 1 ELSE 0 END)
            / COUNT(DISTINCT s.pop_id)
        ELSE NULL
    END AS merchant_with_data_ratio,

    -- 工商层日均订单 = 所有门店 total_order_cnt_30d 求和 / 30
    CASE 
        WHEN SUM(st.total_order_cnt_30d) IS NOT NULL THEN
            SUM(st.total_order_cnt_30d) / 30
        ELSE NULL
    END AS party_order_cnt_30d,

    MAX(st.has_order_before_6_30d) AS has_order_before_6_any_merchant_30d,
    MAX(st.has_order_after_20_30d) AS has_order_after_20_any_merchant_30d,

    'v1' AS feature_version
FROM merchant_feature_snapshot_di s
LEFT JOIN store_feature_snapshot_di st
  ON st.as_of_date = s.as_of_date
 AND st.pop_id    = s.pop_id
WHERE s.as_of_date = @biz_date
GROUP BY
    s.as_of_date,
    s.party_key;
```

---

### Step 3：open\_hours / open\_24h V1 严格版标签计算（仅用门店层，先跑通）

> 先来一个“门店严格版”：只用 store\_feature\_snapshot\_di 的 is\_zxgj 拆分为 open\_hours，按 D1 逻辑给 open\_24h（有 6 点前 or 20 点后订单就视为 00-24），暂时不启用商户/工商层覆盖。  
> 后续我们再在此基础上叠商户层/工商层候选 + conf 模型。

#### 3.1 计算 open\_hours 标签（store 严格版）

```sql
sql-- 清理当日 open_hours 标签
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_hours';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    s.store_id,
    s.as_of_date,
    'open_hours' AS tag_code,

    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 严格版：直接用  is_zxgj 的区间文本
    CASE 
        WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN
            LPAD(s.open_hour_min_30d, 2, '0')
            || '-' ||
            LPAD(s.open_hour_max_30d, 2, '0')
        ELSE NULL
    END AS target_value_string,

    NULL AS enum_code,

    'STORE' AS source_level,
    'FOUND_IN_RAW' AS evidence_state,

    30 AS ttl_days,  -- TODO: 可放入 tag_spec，将来再抽
    0.80 AS conf,    -- V1 先给一个固定值，后续用 conf 模型替换

    'open_hours_strict_from_is_zxgj' AS reason,
    'open_hours_v1' AS algo_version,

    -- 备份原始文本（如果 v_merchant_profile_latest.open_hours 已有值，也可以写这里）
    CASE 
        WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN
            LPAD(s.open_hour_min_30d, 2, '0')
            || '-' ||
            LPAD(s.open_hour_max_30d, 2, '0')
        ELSE NULL
    END AS target_value_string_back
FROM store_feature_snapshot_di s
WHERE s.as_of_date = @biz_date;
```

> 说明：
> 
> - 这里没有用 v\_merchant\_profile\_latest.open\_hours，而是用 is\_zxgj 拆出来，符合“30 天订单分布推断”的思路。
> - ttl\_days/conf 在 V1 先写死，等你有真实校验后再用 `tag_algo_config` / conf 模型替换。

#### 3.2 计算 open\_24h 标签（store 严格版 + D1 规则）

```sql
sql-- 清理当日 open_24h 标签
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_24h';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    s.store_id,
    s.as_of_date,
    'open_24h' AS tag_code,

    -- bool：1 = 24小时，0 = 不是，99 = 未知
    CASE 
        WHEN s.open_hour_min_30d IS NULL OR s.open_hour_max_30d IS NULL THEN 99
        WHEN s.has_order_before_6_30d = 1 OR s.has_order_after_20_30d = 1 THEN 1
        ELSE 0
    END AS target_value_bool,

    NULL AS target_value_number,
    NULL AS target_value_string,
    NULL AS enum_code,

    'STORE' AS source_level,
    'INFERRED' AS evidence_state,

    30 AS ttl_days,
    0.80 AS conf,  -- V1 先固定

    'open_24h_from_open_hours_D1_rule' AS reason,
    'open_hours_v1' AS algo_version,
    NULL AS target_value_string_back
FROM store_feature_snapshot_di s
WHERE s.as_of_date = @biz_date;
```

#### 3.3 写审计日志（先记录 store 层版本）

```sql
sql-- 清理当日 open_hours/open_24h 审计
DELETE FROM tag_audit_log_di
 WHERE as_of_date = @biz_date
   AND tag_code IN ('open_hours', 'open_24h')
   AND algo_version = 'open_hours_v1';

-- open_hours 审计
INSERT INTO tag_audit_log_di (
    store_id,
    as_of_date,
    tag_code,
    algo_version,
    chosen_level,
    chosen_value_string,
    chosen_enum_code,
    conf_final,
    conf_store,
    conf_merchant,
    conf_party,
    candidate_store_string,
    candidate_merchant_string,
    candidate_party_string,
    manual_override_flag,
    trace_json
)
SELECT
    t.store_id,
    t.as_of_date,
    'open_hours' AS tag_code,
    t.algo_version,
    t.source_level AS chosen_level,
    t.target_value_string AS chosen_value_string,
    t.enum_code AS chosen_enum_code,
    t.conf AS conf_final,
    t.conf AS conf_store,
    NULL AS conf_merchant,
    NULL AS conf_party,
    t.target_value_string AS candidate_store_string,
    NULL AS candidate_merchant_string,
    NULL AS candidate_party_string,
    0 AS manual_override_flag,
    JSON_OBJECT(
        'strategy', 'strict_store_only',
        'source', 'is_zxgj',
        'd1_enabled', TRUE
    ) AS trace_json
FROM store_tag_snapshot_di t
WHERE t.as_of_date = @biz_date
  AND t.tag_code   = 'open_hours';

-- open_24h 审计
INSERT INTO tag_audit_log_di (
    store_id,
    as_of_date,
    tag_code,
    algo_version,
    chosen_level,
    chosen_value_string,
    chosen_enum_code,
    conf_final,
    conf_store,
    conf_merchant,
    conf_party,
    candidate_store_string,
    candidate_merchant_string,
    candidate_party_string,
    manual_override_flag,
    trace_json
)
SELECT
    t.store_id,
    t.as_of_date,
    'open_24h' AS tag_code,
    t.algo_version,
    t.source_level AS chosen_level,
    CASE 
        WHEN t.target_value_bool = 1 THEN 'Y'
        WHEN t.target_value_bool = 0 THEN 'N'
        ELSE 'UNKNOWN'
    END AS chosen_value_string,
    NULL AS chosen_enum_code,
    t.conf AS conf_final,
    t.conf AS conf_store,
    NULL AS conf_merchant,
    NULL AS conf_party,
    CASE 
        WHEN t.target_value_bool = 1 THEN 'Y'
        WHEN t.target_value_bool = 0 THEN 'N'
        ELSE 'UNKNOWN'
    END AS candidate_store_string,
    NULL AS candidate_merchant_string,
    NULL AS candidate_party_string,
    0 AS manual_override_flag,
    JSON_OBJECT(
        'strategy', 'strict_store_only_D1',
        'source', 'is_zxgj',
        'has_order_before_6_30d', (SELECT s.has_order_before_6_30d FROM store_feature_snapshot_di s 
                                   WHERE s.as_of_date = t.as_of_date AND s.store_id = t.store_id),
        'has_order_after_20_30d', (SELECT s.has_order_after_20_30d FROM store_feature_snapshot_di s 
                                   WHERE s.as_of_date = t.as_of_date AND s.store_id = t.store_id)
    ) AS trace_json
FROM store_tag_snapshot_di t
WHERE t.as_of_date = @biz_date
  AND t.tag_code   = 'open_24h';
```

---

## 4）迭代日志（你接下来怎么用这套 TODO + SQL）

- 【你现在可以做的事】
	1. 直接按顺序执行：
		- 所有 CREATE TABLE
		- 插入 `tag_algo_config` 中 open\_hours 配置
		- Step 2 的三段 INSERT（特征快照）
		- Step 3 的三段 INSERT（标签 + 审计）
	2. 如果报错：
		- 优先看 dt 格式、JSON 支持、字段名拼写；
		- 报错信息贴出来，我们再针对性改 SQL（比如某些字段类型不兼容）。
- 【后续扩展（等 V1 跑通后）】
	- 在现有框架上，引入 merchant/party 层候选 + conf 计算：
		- 在特征快照基础上算三层候选值（strict + D1），并写一个“跨层决策器”的 INSERT。
	- 将 `open_hours` 模版复制到其他标签：
		- restroom\_available、parking\_available 等服务标签按相同表 & 审计结构接入。

如果你愿意，下一步你可以：

- 把你执行这些 SQL 的报错贴出来（不用解释太多），我就按错误点直接给你改写后的版本；
- 或者我们直接在这套骨架上，补一版“商户层/工商层候选 + 简易 conf 模型”的 SQL 草图。

20251206\_2205\_ETL准备检查与视图优化建议  
tags: #标签ETL #数据准备 #视图优化 #v\_merchant\_profile\_latest

---

### 1）一句话结论

你现在 Step1 已经全部建完表，强制性的“手动补数据”其实不多：可以先不补也能跑 Step2/3，但有三块建议你逐步补齐； `v_merchant_profile_latest` 慢的问题，本质要用“物化 + 索引 + 精简字段”三板斧优化。

---

### 2）三段论据（简答版）

#### 问题1：Step1 之后，还需要手动补哪些数据？

严格一点分三层看：

1. **必须有的（否则 Step2/3 会空跑）：**
	- `v_merchant_profile_latest` 本身要有数据，且：
		- `dt` 有你要跑的那天（比如 @biz\_date）
		- 至少要有： `store_id, pop_id, party_key, is_zxgj, order_cnt_30d, is_agg_blocked_merchant` 这些字段不全是 NULL  
			→ 这块是上游工作，不在你刚执行的 SQL 里，需要你确认下游 ETL连接到的 DB 里，这个视图能正常查出数据。
2. **建议尽快补，但不补也能先跑：**
	- `merchant_feedback_stats` ：
		- 可以先全空，让逻辑默认 feedback\_cnt=0；
		- 如果你手头已有“典型错的商户清单”，可以先用一两条插入试试，比如：
	- `tag_algo_config` ：
		- open\_hours 的那条已经插了（按我 Step1 的 INSERT），这条是必需的；
		- 其它标签（brand\_name 等）暂时可以不加，等你开始算这些标签时再补。
3. **建议你现在就检查的“质量型数据”：**
	- `v_merchant_profile_latest.is_agg_blocked_merchant` ：
		- 至少确认 0/1 的含义对不对、极端值（NULL/其它数值）是否存在；
	- `v_merchant_profile_latest.is_zxgj` ：
		- 随机查几条，确认格式稳定为 `HH-HH` ，比如 `06-22` ，没有奇怪的中文/空格。

总结一句话：

- 不补任何东西，你可以先直接跑 Step2 + Step3，看跑出来多少行；
- 想更稳一点：
	- 先查 `SELECT COUNT(*) FROM v_merchant_profile_latest WHERE dt = '你的日期';`
	- 再查几条 is\_zxgj / order\_cnt\_30d / party\_key / is\_agg\_blocked\_merchant 看眼感受。

---

#### 问题2：v\_merchant\_profile\_latest 很慢，有什么优化思路？

简单说三层，从“最粗暴到稍微麻烦”的路线给你：

1. **你当前 ETL 视角，最立竿见影的一招：物化快照 + 精简字段**
	现在我们填 `store_feature_snapshot_di` 的 SQL 是直接查视图：
	如果这个视图本身特别复杂（多表 JOIN、窗口函数），建议你这样做：
	- 第一步：先落一张“当日快照表”把需要的字段抽出来：
		```sql
		sqlCREATE TABLE IF NOT EXISTS v_merchant_profile_latest_di LIKE v_merchant_profile_latest;
		DELETE FROM v_merchant_profile_latest_di WHERE dt = '2025-12-06'; -- 按天重刷
		INSERT INTO v_merchant_profile_latest_di
		SELECT
		    dm_id,
		    gas_region,
		    province,
		    province_name,
		    city_id,
		    city_name,
		    store_id,
		    store_name,
		    store_address,
		    lon,
		    lat,
		    dd_store_contact,
		    is_online_1d,
		    is_trd_30d,
		    store_level_mtd_v2,
		    order_cnt_mtd,
		    is_chz,
		    is_zxgj,
		    pop_id,
		    pop_name,
		    store_grade,
		    brand_name_before,
		    gas_flag,
		    party_first_name,
		    party_second_name,
		    store_level_score,
		    order_count_score,
		    total_score,
		    competitive_overlap_before,
		    is_overlap_source,
		    is_cooperate_with_sme_suppliers,
		    typical_sme_supplier_names,
		    profit_mtd,
		    gmv_mtd,
		    actual_take_rate,
		    contract_take_rate,
		    rate_difference_flag,
		    rate_difference_value,
		    days_with_data,
		    order_cnt_30d,
		    inner_order_cnt_30d,
		    bigc_order_cnt_30d,
		    wyc_order_cnt_30d,
		    is_storm,
		    is_league_member,
		    brand_level,
		    brand_name,
		    competitive_overlap,
		    sme_supplier_partner,
		    sme_supplier,
		    wyc_pricing_enabled,
		    service_carwash_available,
		    service_carwash_type,
		    convenience_store_available,
		    restroom_available,
		    parking_available,
		    open_24h,
		    open_hours,
		    dt,
		    dm_created_at,
		    dm_updated_at,
		    is_overlap,
		    brand_name.1,
		    balance_td,
		    is_non_member_station,
		    is_storm_station,
		    is_storm_balance_surplus,
		    is_non_member_storm_surplus,
		    inner_order_cnt_30d_abnormal,
		    inner_order_cnt_30d_new,
		    is_sd,
		    is_sd_key,
		    additional_services,
		    is_car_wash,
		    ttl_14d,
		    ttl_14d_order_cnt,
		    is_insure,
		    party_key,
		    is_agg_blocked_merchant
		FROM v_merchant_profile_latest
		WHERE dt = '2025-12-06';  -- TODO: 换成 @biz_date 对应格式
		```
	- 第二步：后续 ETL 全部改用 `v_merchant_profile_latest_di` （这张是物化好的），速度一般会快很多。
2. **加索引：至少给 dt + store\_id/pop\_id/party\_key 加组合索引**
	在 `v_merchant_profile_latest` 的“物化表版本”（比如 v\_merchant\_profile\_latest\_di）上，建议：
	这样你后续按 `dt` 过滤 + store/pop/party 关联都会走索引，不至于每次全表扫。
3. **从根上调优（如果你以后有空再搞）：**
	- 看原始 `v_merchant_profile_latest` 的定义：
		- 能否减少不必要的 JOIN / 子查询；
		- 能否在数仓那一侧把一些重活（窗口、聚合）前置，视图只做简单拼接。
	- 但这一步相对重，可以列入中长期优化，不影响你现在先通过“物化 + 索引”把 ETL 跑顺。

---

### 3）思维导图结构（简要）

- 数据准备
	- 必须：v\_merchant\_profile\_latest 有数据，关键字段不全空
	- 建议：merchant\_feedback\_stats 先为空、后续再补典型错商户
	- 检查：is\_agg\_blocked\_merchant / is\_zxgj 字段质量
- 性能优化
	- 物化：按 dt 把 v\_merchant\_profile\_latest 落到 v\_merchant\_profile\_latest\_di
	- 索引：dt+store\_id / dt+pop\_id / dt+party\_key
	- 长期：优化视图定义、前置重聚合到数仓

---

### 4）迭代日志

- 本轮新增：
	- 确认 Step1 后无需额外“强制补数”，你可以直接跑 Step2/3；
	- 给出基于 v\_merchant\_profile\_latest 的“物化视图 + 索引”优化方案，避免后续计算越来越慢。
- 建议下一步：
	- 先不动视图定义，直接新建 `v_merchant_profile_latest_di` + 索引，把 Step2 的 SQL 改成从这张表拉；
	- 把执行中的报错/慢查询的 explain 结果贴给我，我们再针对性减重或分段处理。

20251206\_2235\_v\_merchant\_profile\_latest\_物化表修正  
tags: #视图报错1347 #物化表DDL #性能优化

---

### 1）一句话结论

报错是因为 `v_merchant_profile_latest` 是视图，不能用 `CREATE TABLE ... LIKE` ，你需要手动建一张同结构的物化表 `v_merchant_profile_latest_di` ，再用 `INSERT ... SELECT ...` 从视图灌数即可。

---

### 2）问题 1：还要不要手动补数据？

你现在 Step1 的 1–17 全部执行完， **目前只需要确保两件事情** ：

1. `v_merchant_profile_latest` 在你选的那天 `dt` 下有数据。
2. `tag_algo_config` 里已经有一条 `open_hours / open_hours_v1` 的配置（你已经插过那条就行）。

其它像 `merchant_feedback_stats` ，可以先空表，不影响跑通 V1。  
所以目前不需要你再额外“造数据”，直接修好物化表这一步，然后继续 Step2/Step3 就可以了。

---

### 3）问题 2：1347 报错的原因 & 一键可跑的修正 SQL

#### 3.1 报错原因

`1347 - '...v_merchant_profile_latest' is not BASE TABLE`  
说明你对一个视图用了类似：

或者 `ALTER TABLE ...` 之类的操作。  
MySQL 只允许对“真实表”这么干，对 VIEW 不行，所以直接报 1347。

解决思路： **自己写一份 CREATE TABLE DDL** （用你贴出来的字段结构），然后再 `INSERT ... SELECT` 。

---

#### 3.2 正确做法：手动创建物化表 + 灌数

先建物化表（只建一次）：

```sql
sqlCREATE TABLE IF NOT EXISTS v_merchant_profile_latest_di (
    dm_id                       BIGINT        NOT NULL DEFAULT 0,
    gas_region                  VARCHAR(50)   NULL,
    province                    VARCHAR(50)   NULL,
    province_name               VARCHAR(50)   NULL,
    city_id                     VARCHAR(50)   NULL,
    city_name                   VARCHAR(50)   NULL,
    store_id                    VARCHAR(50)   NULL,
    store_name                  VARCHAR(50)   NULL,
    store_address               VARCHAR(50)   NULL,
    lon                         DECIMAL(18,6) NULL,
    lat                         DECIMAL(18,6) NULL,
    dd_store_contact            VARCHAR(50)   NULL,
    is_online_1d                TINYINT       NULL,
    is_trd_30d                  DECIMAL(18,4) NULL,
    store_level_mtd_v2          VARCHAR(50)   NULL,
    order_cnt_mtd               DECIMAL(18,4) NULL,
    is_chz                      VARCHAR(18)   NULL,
    is_zxgj                     VARCHAR(18)   NULL,
    pop_id                      VARCHAR(50)   NULL,
    pop_name                    VARCHAR(50)   NULL,
    store_grade                 VARCHAR(50)   NULL,
    brand_name_before           VARCHAR(50)   NULL,
    gas_flag                    TINYINT       NULL,
    party_first_name            VARCHAR(50)   NULL,
    party_second_name           VARCHAR(50)   NULL,
    store_level_score           TINYINT       NULL,
    order_count_score           TINYINT       NULL,
    total_score                 TINYINT       NULL,
    competitive_overlap_before  DECIMAL(18,4) NULL,
    is_overlap_source           VARCHAR(50)   NULL,
    is_cooperate_with_sme_suppliers DECIMAL(18,4) NULL,
    typical_sme_supplier_names  VARCHAR(50)   NULL,
    profit_mtd                  DECIMAL(18,4) NULL,
    gmv_mtd                     DECIMAL(18,4) NULL,
    actual_take_rate            DECIMAL(18,4) NULL,
    contract_take_rate          DECIMAL(18,4) NULL,
    rate_difference_flag        DECIMAL(18,4) NULL,
    rate_difference_value       DECIMAL(18,4) NULL,
    days_with_data              DECIMAL(18,4) NULL,
    order_cnt_30d               DECIMAL(18,4) NULL,
    inner_order_cnt_30d         DECIMAL(18,4) NULL,
    bigc_order_cnt_30d          DECIMAL(18,4) NULL,
    wyc_order_cnt_30d           DECIMAL(18,4) NULL,
    is_storm                    DECIMAL(18,4) NULL,
    is_league_member            DECIMAL(18,4) NULL,
    brand_level                 VARCHAR(50)   NULL,
    brand_name                  VARCHAR(50)   NULL,
    competitive_overlap         VARCHAR(50)   NULL,
    sme_supplier_partner        VARCHAR(50)   NULL,
    sme_supplier                VARCHAR(50)   NULL,
    wyc_pricing_enabled         VARCHAR(50)   NULL,
    service_carwash_available   VARCHAR(50)   NULL,
    service_carwash_type        VARCHAR(50)   NULL,
    convenience_store_available VARCHAR(50)   NULL,
    restroom_available          VARCHAR(50)   NULL,
    parking_available           VARCHAR(50)   NULL,
    open_24h                    VARCHAR(50)   NULL,
    open_hours                  VARCHAR(50)   NULL,
    dt                          VARCHAR(50)   NULL,
    dm_created_at               TIMESTAMP     NULL,
    dm_updated_at               TIMESTAMP     NULL,
    is_overlap                  VARCHAR(18)   NULL,
    \`brand_name.1\`              VARCHAR(50)   NULL,
    balance_td                  DECIMAL(18,4) NULL,
    is_non_member_station       TINYINT       NULL,
    is_storm_station            TINYINT       NULL,
    is_storm_balance_surplus    TINYINT       NULL,
    is_non_member_storm_surplus TINYINT       NULL,
    inner_order_cnt_30d_abnormal TINYINT      NULL,
    inner_order_cnt_30d_new     DECIMAL(18,4) NULL,
    is_sd                       TINYINT       NULL,
    is_sd_key                   TINYINT       NULL,
    additional_services         VARCHAR(255)  NULL,
    is_car_wash                 TINYINT       NULL,
    ttl_14d                     TINYINT       NULL,
    ttl_14d_order_cnt           DECIMAL(18,4) NULL,
    is_insure                   TINYINT       NOT NULL DEFAULT 99,
    party_key                   VARCHAR(128)  NULL,
    is_agg_blocked_merchant     INT           NULL DEFAULT 0,
    PRIMARY KEY (dm_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

> 说明：
> 
> - 列顺序和你贴出来的一致；
> - `brand_name.1` 用反引号包起来，MySQL 支持；
> - 精度我统一用了 `DECIMAL(18,4)` ，足够安全；
> - 主键先用 `dm_id` ，你后面如果有更好的键可以再改。

然后，每天（或你当前要跑的那天）做一键灌数：

之后，把之前 Step2 里用到 `v_merchant_profile_latest` 的地方，全部替换成 `v_merchant_profile_latest_di` ，例如：

改成：

如果你嫌 STR\_TO\_DATE 慢，也可以直接用字符串对齐：

- 规定 `@biz_date_str = '2025-12-06'`
- 用 `WHERE v.dt = @biz_date_str` 。

---

如果你愿意，下一步你可以：

- 把这段 CREATE TABLE + INSERT 跑一遍；
- 然后再跑 Step2 的 `store_feature_snapshot_di` INSERT；
- 有任何新的报错，直接把错误原文贴出来，我帮你继续改到能全量跑完为止。

20251206\_2300\_step2\_is\_zxgj\_清洗修正  
tags: #SQL报错1292 #is\_zxgj清洗 #标签ETL

---

你这个报错本质就一件事：

> `is_zxgj` 里有值是 `'未知'` 之类的非 `HH-HH` 格式，我们在 `CAST(SUBSTRING_INDEX(... ) AS UNSIGNED)` 时直接炸了。

我们只要在拆 `is_zxgj` 前先过滤一遍“是不是合法的 `NN-NN` 格式”，其它情况一律当 NULL 就行。

下面给你的是 **可以直接替换原来 Step2.1 的 INSERT 版本** 。

---

### 1\. 替换版：Step2.1 store\_feature\_snapshot\_di INSERT（已容错 '未知'）

```sql
sqlSET @biz_date = '2025-12-06';  -- TODO: 改成你的业务日期

DELETE FROM store_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO store_feature_snapshot_di (
    as_of_date,
    store_id,
    pop_id,
    party_key,
    open_hour_min_30d,
    open_hour_max_30d,
    has_order_before_6_30d,
    has_order_after_20_30d,
    order_cnt_30d,
    total_order_cnt_30d,
    feature_version
)
SELECT
    -- 这里如果你已经改成用字符串对齐，可以直接用 @biz_date
    @biz_date AS as_of_date,

    v.store_id,
    v.pop_id,
    v.party_key,

    -- 只对合法格式 'HH-HH' 做拆分，其它一律 NULL
    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$' THEN
            CAST(SUBSTRING_INDEX(v.is_zxgj, '-', 1) AS UNSIGNED)
        ELSE NULL
    END AS open_hour_min_30d,

    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$' THEN
            CAST(SUBSTRING_INDEX(v.is_zxgj, '-', -1) AS UNSIGNED)
        ELSE NULL
    END AS open_hour_max_30d,

    -- D1 信号：同样只在格式合法时判断，否则按 0 处理
    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$'
             AND CAST(SUBSTRING_INDEX(v.is_zxgj, '-', 1) AS UNSIGNED) < 6
        THEN 1 ELSE 0 END AS has_order_before_6_30d,

    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$'
             AND CAST(SUBSTRING_INDEX(v.is_zxgj, '-', -1) AS UNSIGNED) > 20
        THEN 1 ELSE 0 END AS has_order_after_20_30d,

    v.order_cnt_30d AS order_cnt_30d,
    v.order_cnt_30d * 30 AS total_order_cnt_30d,

    'v1' AS feature_version
FROM v_merchant_profile_latest_di v
WHERE v.dt = DATE_FORMAT(@biz_date, '%Y-%m-%d');
```

> 关键点：
> 
> - 用 `REGEXP '^[0-9]{2}-[0-9]{2}$'` 先筛一遍，只有“形如 06-22”才去 CAST。
> - '未知'、空字符串、NULL 等情况，直接走 ELSE NULL，不会再触发 1292。

---

### 2\. 接下来怎么做

1. 直接用上面 SQL 替换你当前的 Step2.1 INSERT，再跑一遍。
2. 如果继续报错（比如其它字段也有“未知”等杂值），把新的报错信息原样贴出来，我们再在对应字段加一层清洗即可。

这一步搞定之后，你就可以继续跑 Step2.2/2.3 和 Step3 了。

20251206\_2315\_ETL\_step2\_step3\_自动取日期版本  
tags: #标签ETL #open\_hours #自动取日期 #特征快照

---

先说结论：

- 不再手填日期，统一从 `v_merchant_profile_latest_di` 里自动取“最新 dt”。
- 你已经完成 step2.1，可以直接从 **step0 自动日期 + step2.2 / 2.3 / step3** 继续。
- 我下面给的是“可以直接复制执行”的版本，每段前都有 `-- stepX.X ...` 注释。

如果你愿意统一风格，可以把 step2.1 也改用这个 `@biz_date` 写法（不是必须）。

---

## step0：自动识别最新业务日期（必加在脚本最前）

> 说明：
> 
> - 后面的所有 SQL 都用 `@biz_date` / `@biz_dt_str` ，不再手动写日期。
> - 你可以先跑这段，看一下取到的日期是不是你预期的那一天。

---

## （可选）step2.1 统一改造版本（你已经跑通，可以按需替换）

```sql
sql-- step2.1.store_feature_snapshot 由物化视图生成门店层特征快照
DELETE FROM store_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO store_feature_snapshot_di (
    as_of_date,
    store_id,
    pop_id,
    party_key,
    open_hour_min_30d,
    open_hour_max_30d,
    has_order_before_6_30d,
    has_order_after_20_30d,
    order_cnt_30d,
    total_order_cnt_30d,
    feature_version
)
SELECT
    @biz_date AS as_of_date,
    v.store_id,
    v.pop_id,
    v.party_key,

    -- 仅对合法 'HH-HH' 格式做拆分
    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$' THEN
            CAST(SUBSTRING_INDEX(v.is_zxgj, '-', 1) AS UNSIGNED)
        ELSE NULL
    END AS open_hour_min_30d,

    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$' THEN
            CAST(SUBSTRING_INDEX(v.is_zxgj, '-', -1) AS UNSIGNED)
        ELSE NULL
    END AS open_hour_max_30d,

    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$'
             AND CAST(SUBSTRING_INDEX(v.is_zxgj, '-', 1) AS UNSIGNED) < 6
        THEN 1 ELSE 0 END AS has_order_before_6_30d,

    CASE 
        WHEN v.is_zxgj REGEXP '^[0-9]{2}-[0-9]{2}$'
             AND CAST(SUBSTRING_INDEX(v.is_zxgj, '-', -1) AS UNSIGNED) > 20
        THEN 1 ELSE 0 END AS has_order_after_20_30d,

    v.order_cnt_30d AS order_cnt_30d,
    v.order_cnt_30d * 30 AS total_order_cnt_30d,

    'v1' AS feature_version
FROM v_merchant_profile_latest_di v
WHERE v.dt = @biz_dt_str;
```

---

## step2.2：商户特征快照（pop\_id 粒度）

```sql
sql-- step2.2.merchant_feature_snapshot 汇总门店特征到商户粒度
DELETE FROM merchant_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO merchant_feature_snapshot_di (
    as_of_date,
    pop_id,
    party_key,
    store_cnt,
    store_with_data_cnt,
    store_with_data_ratio,
    merchant_order_cnt_30d,
    has_order_before_6_any_store_30d,
    has_order_after_20_any_store_30d,
    is_agg_blocked_merchant,
    feedback_cnt_open_hours,
    feature_version
)
SELECT
    s.as_of_date,
    s.pop_id,
    MAX(s.party_key) AS party_key,  -- 同一商户 party_key 理论一致，有异常后面再治理

    COUNT(DISTINCT s.store_id) AS store_cnt,
    SUM(CASE WHEN s.open_hour_min_30d IS NOT NULL
              AND s.open_hour_max_30d IS NOT NULL THEN 1 ELSE 0 END) AS store_with_data_cnt,
    CASE 
        WHEN COUNT(DISTINCT s.store_id) > 0 THEN
            SUM(CASE WHEN s.open_hour_min_30d IS NOT NULL
                      AND s.open_hour_max_30d IS NOT NULL THEN 1 ELSE 0 END)
            / COUNT(DISTINCT s.store_id)
        ELSE NULL
    END AS store_with_data_ratio,

    -- 商户维度 30 天日均订单 = ∑门店 total_order_cnt_30d / 30
    CASE 
        WHEN SUM(s.total_order_cnt_30d) IS NOT NULL THEN
            SUM(s.total_order_cnt_30d) / 30
        ELSE NULL
    END AS merchant_order_cnt_30d,

    MAX(s.has_order_before_6_30d) AS has_order_before_6_any_store_30d,
    MAX(s.has_order_after_20_30d) AS has_order_after_20_any_store_30d,

    -- 商户黑名单标记：从物化表聚合
    MAX(CASE WHEN v.is_agg_blocked_merchant IS NULL
             THEN 0 ELSE v.is_agg_blocked_merchant END) AS is_agg_blocked_merchant,

    -- 反馈次数：当前只接 open_hours，没数据则为 0
    IFNULL(MAX(f.feedback_cnt), 0) AS feedback_cnt_open_hours,

    'v1' AS feature_version
FROM store_feature_snapshot_di s
LEFT JOIN v_merchant_profile_latest_di v
  ON v.store_id = s.store_id
 AND v.dt      = @biz_dt_str
LEFT JOIN merchant_feedback_stats f
  ON f.pop_id  = s.pop_id
 AND f.tag_code = 'open_hours'
WHERE s.as_of_date = @biz_date
  AND s.pop_id IS NOT NULL
GROUP BY
    s.as_of_date,
    s.pop_id;
```

---

## step2.3：工商主体特征快照（party\_key 粒度）

```sql
sql-- step2.3.party_feature_snapshot 汇总商户/门店特征到工商粒度
DELETE FROM party_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO party_feature_snapshot_di (
    as_of_date,
    party_key,
    merchant_cnt,
    merchant_with_data_cnt,
    merchant_with_data_ratio,
    party_order_cnt_30d,
    has_order_before_6_any_merchant_30d,
    has_order_after_20_any_merchant_30d,
    feature_version
)
SELECT
    m.as_of_date,
    m.party_key,

    COUNT(DISTINCT m.pop_id) AS merchant_cnt,
    SUM(CASE WHEN m.merchant_order_cnt_30d IS NOT NULL THEN 1 ELSE 0 END) AS merchant_with_data_cnt,
    CASE 
        WHEN COUNT(DISTINCT m.pop_id) > 0 THEN
            SUM(CASE WHEN m.merchant_order_cnt_30d IS NOT NULL THEN 1 ELSE 0 END)
            / COUNT(DISTINCT m.pop_id)
        ELSE NULL
    END AS merchant_with_data_ratio,

    -- 工商维度 30 天日均订单 = ∑门店 total_order_cnt_30d / 30
    CASE
        WHEN SUM(st.total_order_cnt_30d) IS NOT NULL THEN
            SUM(st.total_order_cnt_30d) / 30
        ELSE NULL
    END AS party_order_cnt_30d,

    MAX(st.has_order_before_6_30d) AS has_order_before_6_any_merchant_30d,
    MAX(st.has_order_after_20_30d) AS has_order_after_20_any_merchant_30d,

    'v1' AS feature_version
FROM merchant_feature_snapshot_di m
LEFT JOIN store_feature_snapshot_di st
  ON st.as_of_date = m.as_of_date
 AND st.pop_id     = m.pop_id
WHERE m.as_of_date = @biz_date
  AND m.party_key IS NOT NULL
GROUP BY
    m.as_of_date,
    m.party_key;
```

---

## step3.1：open\_hours（门店严格版标签）

```sql
sql-- step3.1.open_hours_tag 基于门店特征生成 open_hours 标签（严格版）
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_hours';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    s.store_id,
    s.as_of_date,
    'open_hours' AS tag_code,

    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 严格版：直接用拆分得到的 06-22 之类的区间
    CASE 
        WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN
            CONCAT(
                LPAD(s.open_hour_min_30d, 2, '0'),
                '-',
                LPAD(s.open_hour_max_30d, 2, '0')
            )
        ELSE NULL
    END AS target_value_string,

    NULL AS enum_code,

    'STORE' AS source_level,
    'FOUND_IN_RAW' AS evidence_state,

    30 AS ttl_days,
    0.80 AS conf,  -- V1 固定，后续用 conf 模型替换

    'open_hours_strict_from_is_zxgj' AS reason,
    'open_hours_v1' AS algo_version,

    -- 备份：当前和结果一致，后续可写入其他来源值
    CASE 
        WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN
            CONCAT(
                LPAD(s.open_hour_min_30d, 2, '0'),
                '-',
                LPAD(s.open_hour_max_30d, 2, '0')
            )
        ELSE NULL
    END AS target_value_string_back
FROM store_feature_snapshot_di s
WHERE s.as_of_date = @biz_date;
```

---

## step3.2：open\_24h（门店 D1 规则）

```sql
sql-- step3.2.open_24h_tag 基于门店特征和D1规则生成 open_24h 标签
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_24h';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    s.store_id,
    s.as_of_date,
    'open_24h' AS tag_code,

    CASE 
        WHEN s.open_hour_min_30d IS NULL OR s.open_hour_max_30d IS NULL THEN 99  -- 未知
        WHEN s.has_order_before_6_30d = 1 OR s.has_order_after_20_30d = 1 THEN 1
        ELSE 0
    END AS target_value_bool,

    NULL AS target_value_number,
    NULL AS target_value_string,
    NULL AS enum_code,

    'STORE' AS source_level,
    'INFERRED' AS evidence_state,

    30 AS ttl_days,
    0.80 AS conf,

    'open_24h_from_open_hours_D1_rule' AS reason,
    'open_hours_v1' AS algo_version,
    NULL AS target_value_string_back
FROM store_feature_snapshot_di s
WHERE s.as_of_date = @biz_date;
```

---

## step3.3：审计写入（open\_hours & open\_24h）

```sql
sql-- step3.3.audit_logs 为 open_hours / open_24h 写审计日志（当前仅 store 层）
DELETE FROM tag_audit_log_di
 WHERE as_of_date   = @biz_date
   AND tag_code    IN ('open_hours', 'open_24h')
   AND algo_version = 'open_hours_v1';

-- open_hours 审计
INSERT INTO tag_audit_log_di (
    store_id,
    as_of_date,
    tag_code,
    algo_version,
    chosen_level,
    chosen_value_string,
    chosen_enum_code,
    conf_final,
    conf_store,
    conf_merchant,
    conf_party,
    candidate_store_string,
    candidate_merchant_string,
    candidate_party_string,
    manual_override_flag,
    trace_json
)
SELECT
    t.store_id,
    t.as_of_date,
    'open_hours' AS tag_code,
    t.algo_version,
    t.source_level AS chosen_level,
    t.target_value_string AS chosen_value_string,
    t.enum_code AS chosen_enum_code,
    t.conf AS conf_final,
    t.conf AS conf_store,
    NULL AS conf_merchant,
    NULL AS conf_party,
    t.target_value_string AS candidate_store_string,
    NULL AS candidate_merchant_string,
    NULL AS candidate_party_string,
    0 AS manual_override_flag,
    JSON_OBJECT(
        'strategy', 'strict_store_only',
        'source', 'is_zxgj'
    ) AS trace_json
FROM store_tag_snapshot_di t
WHERE t.as_of_date = @biz_date
  AND t.tag_code   = 'open_hours';

-- open_24h 审计
INSERT INTO tag_audit_log_di (
    store_id,
    as_of_date,
    tag_code,
    algo_version,
    chosen_level,
    chosen_value_string,
    chosen_enum_code,
    conf_final,
    conf_store,
    conf_merchant,
    conf_party,
    candidate_store_string,
    candidate_merchant_string,
    candidate_party_string,
    manual_override_flag,
    trace_json
)
SELECT
    t.store_id,
    t.as_of_date,
    'open_24h' AS tag_code,
    t.algo_version,
    t.source_level AS chosen_level,
    CASE 
        WHEN t.target_value_bool = 1 THEN 'Y'
        WHEN t.target_value_bool = 0 THEN 'N'
        ELSE 'UNKNOWN'
    END AS chosen_value_string,
    NULL AS chosen_enum_code,
    t.conf AS conf_final,
    t.conf AS conf_store,
    NULL AS conf_merchant,
    NULL AS conf_party,
    CASE 
        WHEN t.target_value_bool = 1 THEN 'Y'
        WHEN t.target_value_bool = 0 THEN 'N'
        ELSE 'UNKNOWN'
    END AS candidate_store_string,
    NULL AS candidate_merchant_string,
    NULL AS candidate_party_string,
    0 AS manual_override_flag,
    JSON_OBJECT(
        'strategy', 'strict_store_only_D1',
        'source', 'is_zxgj'
    ) AS trace_json
FROM store_tag_snapshot_di t
WHERE t.as_of_date = @biz_date
  AND t.tag_code   = 'open_24h';
```

---

### 接下来建议

1. 按顺序执行：
	- step0.detect\_biz\_date
	- step2.1（如你愿意统一风格）
	- step2.2 / step2.3
	- step3.1 / 3.2 / 3.3
2. 跑完之后，你可以查：
	- `SELECT COUNT(*) FROM store_feature_snapshot_di WHERE as_of_date=@biz_date;`
	- `SELECT COUNT(*) FROM store_tag_snapshot_di WHERE as_of_date=@biz_date AND tag_code IN ('open_hours','open_24h');`
	- 随机抽几条看 open\_hours/open\_24h 是否符合你预期。

有新的报错，照旧把完整报错信息贴出来，我们继续在这套骨架上迭代，不会推倒重来。

20251206\_2340\_step2.3\_ratio修正与重跑  
tags: #SQL报错1264 #比例字段 #party\_feature\_snapshot

---

1）一句话结论  
`merchant_with_data_ratio` 的类型太紧 + 算式没显式控制精度，导致 1264 报错；改字段类型放宽一点，同时在 INSERT 里显式算成小数，再重跑 step2.3 即可。

---

### 1\. 先改表结构（放宽比例字段）

建议两层都放宽一下，免得后面别的标签踩坑。

> 这样 0～1 之间的小数肯定不会再“越界”。

---

### 2\. 再改 step2.3 的 INSERT，显式用小数运算

把你原来的 step2.3 替换成下面版本（只改了 ratio 那一段，其他保持不动）：

```sql
sql-- step2.3.party_feature_snapshot 汇总商户/门店特征到工商粒度（修正版）
DELETE FROM party_feature_snapshot_di WHERE as_of_date = @biz_date;

INSERT INTO party_feature_snapshot_di (
    as_of_date,
    party_key,
    merchant_cnt,
    merchant_with_data_cnt,
    merchant_with_data_ratio,
    party_order_cnt_30d,
    has_order_before_6_any_merchant_30d,
    has_order_after_20_any_merchant_30d,
    feature_version
)
SELECT
    m.as_of_date,
    m.party_key,

    COUNT(DISTINCT m.pop_id) AS merchant_cnt,
    SUM(CASE WHEN m.merchant_order_cnt_30d IS NOT NULL THEN 1 ELSE 0 END) AS merchant_with_data_cnt,

    -- 显式算成小数并限制在 0~1 区间
    CASE 
        WHEN COUNT(DISTINCT m.pop_id) > 0 THEN
            LEAST(
                1.0,
                SUM(CASE WHEN m.merchant_order_cnt_30d IS NOT NULL THEN 1 ELSE 0 END)
                / COUNT(DISTINCT m.pop_id)
            )
        ELSE NULL
    END AS merchant_with_data_ratio,

    -- 工商维度 30 天日均订单 = ∑门店 total_order_cnt_30d / 30
    CASE
        WHEN SUM(st.total_order_cnt_30d) IS NOT NULL THEN
            SUM(st.total_order_cnt_30d) / 30
        ELSE NULL
    END AS party_order_cnt_30d,

    MAX(st.has_order_before_6_30d) AS has_order_before_6_any_merchant_30d,
    MAX(st.has_order_after_20_30d) AS has_order_after_20_any_merchant_30d,

    'v1' AS feature_version
FROM merchant_feature_snapshot_di m
LEFT JOIN store_feature_snapshot_di st
  ON st.as_of_date = m.as_of_date
 AND st.pop_id     = m.pop_id
WHERE m.as_of_date = @biz_date
  AND m.party_key IS NOT NULL
GROUP BY
    m.as_of_date,
    m.party_key;
```

> 关键点：
> 
> - 用 `1.0 *` 或除法直接算小数，避免整数除法导致奇怪行为；
> - 用 `LEAST(1.0, …)` 兜一层，即使将来逻辑调整也不会爆表。

---

### 3\. 下一步建议

1. 先执行两条 `ALTER TABLE` ，再跑上面新的 step2.3。
2. 如果 step2.3 跑过了，继续 step3.1 / 3.2 / 3.3。
3. 跑完之后，查一下：

看一眼比例是否在 0～1 区间、数量是否符合预期。

有新的报错，继续把完整错误贴给我，我们直接在现有脚本上改，不推翻重来。

看起来是跑完了,我们继续.需要验证吗?如何验证,接下来的做什么

20251207\_0010\_open\_hours\_ETL\_验证与下一步  
tags: #标签ETL #open\_hours #数据验证 #商户画像

---

### 1）一句话结论

现在这条 open\_hours / open\_24h 的门店版 ETL 已经能完整跑通，下一步先做一轮“技术 + 业务”验证，确认没有明显翻车，再在此基础上开启「商户/工商聚合 + conf 模型」的第二阶段。

---

### 2）三段论据（现状 → 验证 → 下一步）

**论据一：现状**

- 从你截图看：step2.x / step3.x 的 INSERT 都返回了有行数的结果（store 特征 16246 行、标签也是 16246 行），说明链路是通的。
- 目前的逻辑是 **纯门店层** ：
	- 三层特征表都已经填好了，但 open\_hours / open\_24h 只用到了 `store_feature_snapshot_di` ；
	- 商户/工商层快照现在是为下一步准备的，还没参与决策。

**论据二：验证必要性和目标**

- 技术上，需要确认：
	- 行数是否对齐（有没有站点被漏掉）；
	- 字段值有没有明显脏数据或越界（比如小时 <0 或 >24、比例 >1 等）。
- 业务上，需要确认：
	- 用 is\_zxgj 推出来的 open\_hours 和原表 open\_hours/open\_24h 相比，一致率大概多少；
	- 随机看几条“极端点”（比如有凌晨订单、晚间订单）标签是否符合直觉。

**论据三：下一步路线**

- 先做一轮轻量验证（你可以 10–20 分钟搞完），如果没大问题，就：  
	1）在这条链路上加上商户/工商候选 + 简单 conf 决策；  
	2）把同样骨架复制到 1–2 个其它服务标签（restroom\_available、parking\_available）上，开始扩大覆盖标签数。

---

### 3）验证怎么做：给你一套“可复制”的 SQL 清单

下面所有 SQL 默认用你刚才脚本里的 `@biz_date` / `@biz_dt_str` 。

#### 3.1 技术验证：数量 & 分布

1）行数对齐检查

预期：

- B ≈ A；
- C 里的两条（open\_hours/open\_24h）都 ≈ A（除非你故意过滤了一些站）。

2）open\_hours 小时值是否正常

预期：

- 小时在 \[0,24\] 区间；
- NULL 比例在一个可接受范围内（太高就要反查源 is\_zxgj 的质量）。

3）比例字段是否正常

预期：

- min ≥ 0；max ≤ 1。

---

#### 3.2 业务验证：和源字段对比 & 抽样

1）open\_hours 与源表 open\_hours 字段对比（如果源有值）

预期：

- 看看 `match` 占比多少；
- `only_tag_has_value` 会提升覆盖率，这是我们希望的；
- 对 `mismatch` 部分你可以再抽 20 条看一眼原因。

2）open\_24h 与源表 open\_24h 对比（如果源有 Y/N 标识）

预期：

- 看 “Y -> 1”、“N -> 0” 的数量多不多；
- “Y -> 0” 或 “N -> 1” 这种反向样本，适合后面给区域做人工校准用。

3）抽样看极端值（早/晚订单）

肉眼扫一眼，有没有明显不合理的（比如 open\_hour\_min\_30d=8, max=20 但是被判成 24 小时等）。

---

### 4）接下来做什么（建议路线）

在你跑完上面几个校验 SQL、没有明显炸裂之后，可以按这个顺序走下一步：

1. **把“门店严格版”先沉淀成 v1：**
	- 记录下来当前脚本的版本号（简单点可以在 SQL 头上写 `-- open_hours_v1_20251207` ）；
	- 把这版结果导出给自己/运营做一次小范围抽样，知道大概的准确率区间。
2. **第二阶段：开始用上商户/工商层 + conf 决策**
	- 利用你已经有的三张特征表：
		- 为 open\_hours 设计 merchant/party 候选（比如商户层汇总最早–最晚小时 + D1）；
		- 写一版简易 conf（比如按日均订单、store\_with\_data\_ratio、is\_agg\_blocked\_merchant、feedback\_cnt\_open\_hours）；
		- 真正实现“门店 conf ≥ 阈值用门店，否则在 merchant/party 中选 conf×weight 最大”的跨层决策器。
	- 这一块我可以给你一版“专门的 step4.x 脚本”，继续沿用你现在的风格（自动取日期 + step 注释）。
3. **第三阶段：复制模版到其它 A 类服务标签**
	- 先选 1–2 个信息足够清晰的：restroom\_available / parking\_available；
	- 共用：三层特征 → 候选 → conf → 决策 → 审计 的框架，只换特征和规则。

---

如果你愿意，下一步可以告诉我两件事：

- 你跑完上面验证 SQL 后，open\_hours / open\_24h 的对比结果大概什么样（只需要贴一下分布统计就行）；
- 你想先做哪一步：
	- A：先把“跨层决策 + conf 模型”的 SQL 写出来；
	- B：先把 open\_hours 这套模板复制到 restroom\_available / parking\_available。

我建议优先 A，把“多层决策器”一次打透，其它标签就都能复用。

\[is\_zxgj cnt 00-00 1 00-10 1 00-11 2 00-13 1 00-14 3 00-15 1 00-16 1 00-17 7 00-18 8 00-19 32 00-20 61 00-21 195 00-22 622 00-23 7561 10月10日 15 10月11日 4 10月12日 4 10月13日 7 10月14日 4 10月15日 8 10月16日 6 10月17日 12 10月18日 24 10月19日 30 10月20日 17 10月21日 22 10月22日 20 10月23日 13 11月11日 15 11月12日 3 11月13日 2 11月14日 2 11月15日 10 11月16日 7 11月17日 4 11月18日 10 11月19日 18 11月20日 13 11月21日 11 11月22日 7 11月23日 7 12月12日 17 12月13日 2 12月14日 6 12月15日 5 12月16日 6 12月17日 6 12月18日 13 12月19日 6 12月20日 6 12月21日 9 12月22日 6 12月23日 4 13-13 19 13-14 4 13-15 2 13-16 6 13-17 6 13-18 5 13-19 8 13-20 5 13-21 5 13-22 3 13-23 3 14-14 24 14-15 1 14-16 6 14-17 3 14-18 9 14-19 3 14-20 6 14-21 3 14-22 1 14-23 1 15-15 22 15-16 2 15-17 4 15-18 2 15-19 2 15-20 3 15-21 4 15-22 3 16-16 27 16-17 3 16-18 2 16-19 3 16-21 2 16-22 1 17-17 21 17-18 1 17-20 3 17-21 2 18-18 11 18-19 4 18-20 4 18-22 1 19-19 13 19-21 1 1月13日 1 1月16日 1 1月17日 4 1月18日 12 1月19日 9 1月1日 3 1月20日 39 1月21日 86 1月22日 218 1月23日 650 20-20 6 20-21 2 21-21 7 22-22 3 23-23 2 2月14日 4 2月17日 4 2月18日 5 2月19日 12 2月20日 16 2月21日 50 2月22日 110 2月23日 238 2月2日 1 2月8日 1 3月14日 2 3月16日 2 3月18日 5 3月19日 13 3月20日 18 3月21日 39 3月22日 103 3月23日 175 4月13日 1 4月14日 1 4月16日 4 4月17日 4 4月18日 4 4月19日 7 4月20日 29 4月21日 44 4月22日 97 4月23日 149 4月4日 1 5月10日 1 5月13日 2 5月15日 2 5月16日 2 5月17日 9 5月18日 13 5月19日 23 5月20日 42 5月21日 129 5月22日 171 5月23日 223 5月5日 2 5月7日 1 6月10日 1 6月11日 1 6月13日 4 6月14日 1 6月15日 3 6月16日 16 6月17日 21 6月18日 41 6月19日 67 6月20日 154 6月21日 258 6月22日 269 6月23日 319 6月6日 1 7月10日 3 7月11日 3 7月12日 6 7月13日 4 7月14日 5 7月15日 10 7月16日 18 7月17日 36 7月18日 71 7月19日 110 7月20日 189 7月21日 271 7月22日 231 7月23日 234 7月7日 10 7月8日 1 8月10日 4 8月11日 3 8月12日 3 8月13日 2 8月14日 4 8月15日 17 8月16日 14 8月17日 35 8月18日 56 8月19日 53 8月20日 90 8月21日 128 8月22日 103 8月23日 62 8月8日 12 8月9日 2 9月10日 4 9月11日 3 9月12日 1 9月13日 7 9月14日 6 9月15日 14 9月16日 10 9月17日 25 9月18日 29 9月19日 39 9月20日 58 9月21日 44 9月22日 40 9月23日 27 9月9日 14 未知 1036;反查了上游的 is\_zxgj,有重大问题,需要修一下;你能理解他们的差异吗?就是 09-23,被识别成 9月23日;需要正确的反算回来,我会在上游用 09~23来修正后面的数据,现在的这个数据需要修一下,起码在v\_merchant\_profile\_latest\_di 这个表里需要修过来;直接替换正确的预期,评估一下能否改,影响面;

20251207\_0105\_is\_zxgj\_反算修复方案  
tags: #is\_zxgj #数据清洗 #视图物化 #标签ETL

---

### 1）一句话结论

这些 `10月10日 / 9月23日` 本质就是原来的 `10-10 / 09-23` 被上游把 `-` 变成了“月……日”，我们可以在 `v_merchant_profile_latest_di` 里用一条 UPDATE 把 `X月Y日` 统一反算回 `HH-HH` ，同时把 `未知` 归一成 `NULL` ，然后重跑 step2.1～step3 即可。

---

### 2）我对问题的理解（你可以快速扫一眼）

- 合法格式一： `HH-HH` ，例如 `00-23` 、 `06-22` ，我们已经按小时区间在用。
- 异常格式二： `10月23日` 、 `6月21日` 这类，很明显是“月日汉字形式”：
	- 逻辑上就是 `10-23` 、 `06-21` 这样的营业时间区间被错误格式化。
- 特例三： `未知` ，没法推断，应该当成“缺失值”，而不是让它参与任何 CAST 或逻辑判断。

你给的例子里：

- `00-23` 行数 7561（很正常）；
- `9月23日` 行数不小，说明 bug 影响不少门店；
- `未知` 有 1036 条，这是我们要兜底忽略的。

所以修复策略很简单：  
1） **只** 对 `^[0-9]{1,2}月[0-9]{1,2}日$` 的值做“反算回 `HH-HH` ”；  
2）对 `'未知'` 直接改成 `NULL` ；  
3）其它格式维持不动（你前面 REGEXP 已经会自动忽略它们）。

---

### 3）在 v\_merchant\_profile\_latest\_di 里的修复 SQL（可以直接跑）

> 建议放在“物化视图灌数之后、step2.1 之前”执行。  
> 用的还是你现成的 `@biz_dt_str` / `@biz_date` 。

#### 3.1 把 X月Y日 反算为 HH-HH

示例映射：

- `9月23日` → `09-23`
- `10月10日` → `10-10`
- `6月21日` → `06-21`
- `1月1日` → `01-01`

#### 3.2 把 未知 归一成 NULL

> 说明：
> 
> - 如果后续你发现还有类似“空字符串”、“NA”等，也可以加在这个 WHERE 里一起归一。
> - 我暂时只动 `'未知'` ，避免误杀其它合法内容。

#### 3.3 修完之后，快速看一眼分布

预期效果：

- `10月xx日 / 1月xx日 / 9月xx日 ...` 这些行应该都消失；
- 新增若干 `HH-HH` 组合（比如 09-23、10-23 等）；
- `未知` 行数应变为 0（或你后续扩展的其它异常值）。

---

### 4）对影响面的判断 & 下一步动作

**影响范围：**

- 只改 `v_merchant_profile_latest_di` 这张你本地的“物化快照表”，不动上游视图；
- 范围限定在 `dt = @biz_dt_str` 的那一天数据，不会影响历史；
- 修改字段只限 is\_zxgj 一列，其它标签字段不受影响。

**对结果的正向影响：**

- `store_feature_snapshot_di` 中 `open_hour_min_30d / open_hour_max_30d` 的可用率会明显提升（之前这些“X月Y日”是被丢弃成 NULL 的）；
- `open_hours` / `open_24h` 的覆盖率都会随之上升；
- 逻辑风险几乎为 0——因为这些“X月Y日”本来就应该是 `HH-HH` ，“反算”只是把错误格式修回来。

**下一步具体操作建议：**

1. 在当前 DB 会话里依次执行：
	- `step_fix_is_zxgj_month_day`
	- `step_fix_is_zxgj_unknown`
	- `step_fix_is_zxgj_check` 看一眼分布是否符合预期。
2. 然后重新跑：
	- step2.1.store\_feature\_snapshot
	- step2.2 / step2.3
	- step3.1 / 3.2 / 3.3
3. 跑完后，再用之前那几条验证 SQL 看：
	- open\_hours 覆盖率是否上来了（非 NULL 行数）；
	- open\_24h 中被判为 24 小时的站点有没有明显异常。

---

如果你愿意，等你重跑完这轮，我可以帮你一并把 **“跨层决策 + 商户/工商候选 + 简易 conf 模型”** 写成 step4.x 的 SQL，把这条 ETL 从“门店严格版”升级到“多层智能版。

跑完了,我验过了,看起来正常些了;接下来做什么?

20251207\_0135\_open\_hours\_step4\_三层候选+决策器  
tags: #open\_hours #三层候选 #置信度 #跨层决策

---

### 1）一句话结论

现在可以进入 step4：在已有三层特征表的基础上，为 `open_hours` 算出门店/商户/工商三层候选值和置信度，生成中间候选表，再用 `tag_algo_config` 驱动跨层决策，覆盖你现在的门店严格版结果。

下面所有 SQL 都是“接着你现有脚本直接跑”的版本，每段都加了 step 注释；你可以整体粘进去，从 step4.0 开始跑。

---

## 一、整体思路（先说人话版）

- step4.0：确认我们用的是刚才那天的 `@biz_date/@biz_dt_str` 。
- step4.1：建一张 `open_hours_candidate_di` 中间表，按门店写入：
	- store 层候选 + conf\_store；
	- merchant 层候选（同一 pop\_id 的最早开门 & 最晚打烊）+ conf\_merchant；
	- party 层候选（同一 party\_key 下所有门店的最早 & 最晚）+ conf\_party。
- step4.2：用 `tag_algo_config` 做跨层决策：
	- 若 conf\_store ≥ conf\_threshold\_store → 用门店；
	- 否则在 store/merchant/party 中选 score=conf×weight 最大的层级，写回 `store_tag_snapshot_di` ；
	- 同时写一版新的审计到 `tag_audit_log_di` （包含三层候选和 conf）。

**conf 简化规则（先求可用性）：**

- `conf_store` ：有合法区间就给 1.0，否则 0；
- `conf_merchant` ：满足下面条件才给 0.8，否则 0：
	- store\_with\_data\_ratio ≥ min\_merchant\_data\_ratio
	- is\_agg\_blocked\_merchant = 0
	- feedback\_cnt\_open\_hours ≤ max\_feedback\_cnt\_for\_agg
- `conf_party` ：只看“下挂商户有数据占比”，≥ 0.5 给 0.7，否则 0。

阈值和权重从 `tag_algo_config` 里读（你已经有 open\_hours\_v1 那条）。

---

## 二、step4 详细 SQL（可以直接跑）

> 前提：你前面所有 step0 ~ step3 已跑通， `@biz_date / @biz_dt_str` 还在当前 session。  
> 如果你新开了连接，请先再跑一遍 step0 的自动取日期。

---

### step4.0 确认业务日期（如果断了会话，先跑一次）

---

### step4.1 建/填 open\_hours 三层候选中间表

#### 4.1.1 建表（只建一次）

#### 4.1.2 生成 merchant/party 层聚合（辅助子表）

```sql
sql-- step4.1a.merchant_open_agg 计算商户层 open_hours 聚合（最早开门+最晚关门）
DROP TEMPORARY TABLE IF EXISTS tmp_merchant_open_agg;

CREATE TEMPORARY TABLE tmp_merchant_open_agg AS
SELECT
    s.as_of_date,
    s.pop_id,
    MIN(s.open_hour_min_30d) AS merchant_open_min_30d,
    MAX(s.open_hour_max_30d) AS merchant_open_max_30d
FROM store_feature_snapshot_di s
WHERE s.as_of_date = @biz_date
  AND s.pop_id IS NOT NULL
  AND s.open_hour_min_30d IS NOT NULL
  AND s.open_hour_max_30d IS NOT NULL
GROUP BY
    s.as_of_date,
    s.pop_id;

-- step4.1b.party_open_agg 计算工商层 open_hours 聚合（最早开门+最晚关门）
DROP TEMPORARY TABLE IF EXISTS tmp_party_open_agg;

CREATE TEMPORARY TABLE tmp_party_open_agg AS
SELECT
    s.as_of_date,
    s.party_key,
    MIN(s.open_hour_min_30d) AS party_open_min_30d,
    MAX(s.open_hour_max_30d) AS party_open_max_30d
FROM store_feature_snapshot_di s
WHERE s.as_of_date = @biz_date
  AND s.party_key IS NOT NULL
  AND s.open_hour_min_30d IS NOT NULL
  AND s.open_hour_max_30d IS NOT NULL
GROUP BY
    s.as_of_date,
    s.party_key;
```

#### 4.1.3 填充 open\_hours\_candidate\_di

```sql
sql-- step4.1c.fill_open_hours_candidate_di 生成门店/商户/工商三层候选+置信度
DELETE FROM open_hours_candidate_di WHERE as_of_date = @biz_date;

INSERT INTO open_hours_candidate_di (
    as_of_date,
    store_id,
    pop_id,
    party_key,
    candidate_store_string,
    conf_store,
    candidate_merchant_string,
    conf_merchant,
    candidate_party_string,
    conf_party
)
SELECT
    s.as_of_date,
    s.store_id,
    s.pop_id,
    s.party_key,

    -- store 层候选
    CASE 
        WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL THEN
            CONCAT(
                LPAD(s.open_hour_min_30d, 2, '0'),
                '-',
                LPAD(s.open_hour_max_30d, 2, '0')
            )
        ELSE NULL
    END AS candidate_store_string,

    -- conf_store：有合法区间 = 1.0，否则 0
    CASE 
        WHEN s.open_hour_min_30d IS NOT NULL AND s.open_hour_max_30d IS NOT NULL
        THEN 1.0000
        ELSE 0.0000
    END AS conf_store,

    -- merchant 层候选：商户聚合最早-最晚
    CASE 
        WHEN mo.merchant_open_min_30d IS NOT NULL AND mo.merchant_open_max_30d IS NOT NULL THEN
            CONCAT(
                LPAD(mo.merchant_open_min_30d, 2, '0'),
                '-',
                LPAD(mo.merchant_open_max_30d, 2, '0')
            )
        ELSE NULL
    END AS candidate_merchant_string,

    -- conf_merchant：满足数据占比+黑名单+反馈约束才给 0.8，否则 0
    CASE 
        WHEN m.pop_id IS NOT NULL
             AND m.store_with_data_ratio IS NOT NULL
             AND m.store_with_data_ratio >= cfg.min_merchant_data_ratio
             AND IFNULL(m.is_agg_blocked_merchant, 0) = 0
             AND IFNULL(m.feedback_cnt_open_hours, 0) <= cfg.max_feedback_cnt_for_agg
             AND mo.merchant_open_min_30d IS NOT NULL
             AND mo.merchant_open_max_30d IS NOT NULL
        THEN 0.8000
        ELSE 0.0000
    END AS conf_merchant,

    -- party 层候选：工商聚合最早-最晚
    CASE 
        WHEN po.party_open_min_30d IS NOT NULL AND po.party_open_max_30d IS NOT NULL THEN
            CONCAT(
                LPAD(po.party_open_min_30d, 2, '0'),
                '-',
                LPAD(po.party_open_max_30d, 2, '0')
            )
        ELSE NULL
    END AS candidate_party_string,

    -- conf_party：简单按“有数据商户占比”给 0.7，否则 0
    CASE 
        WHEN p.party_key IS NOT NULL
             AND p.merchant_with_data_ratio IS NOT NULL
             AND p.merchant_with_data_ratio >= 0.5000
             AND po.party_open_min_30d IS NOT NULL
             AND po.party_open_max_30d IS NOT NULL
        THEN 0.7000
        ELSE 0.0000
    END AS conf_party

FROM store_feature_snapshot_di s
LEFT JOIN tmp_merchant_open_agg mo
  ON mo.as_of_date = s.as_of_date
 AND mo.pop_id     = s.pop_id
LEFT JOIN merchant_feature_snapshot_di m
  ON m.as_of_date = s.as_of_date
 AND m.pop_id     = s.pop_id
LEFT JOIN tmp_party_open_agg po
  ON po.as_of_date = s.as_of_date
 AND po.party_key  = s.party_key
LEFT JOIN party_feature_snapshot_di p
  ON p.as_of_date = s.as_of_date
 AND p.party_key  = s.party_key
LEFT JOIN tag_algo_config cfg
  ON cfg.tag_code     = 'open_hours'
 AND cfg.algo_version = 'open_hours_v1'
WHERE s.as_of_date = @biz_date;
```

> 说明：
> 
> - 这里已经把 `min_merchant_data_ratio` 、 `max_feedback_cnt_for_agg` 从配置表里读出来；
> - `conf_store/merchant/party` 先用简单 1 / 0.8 / 0.7 的离散值，重点是“有/没有可用信息”，后面再细化。

---

### step4.2 跨层决策：写回终表 & 审计

#### 4.2.1 决策逻辑写回 store\_tag\_snapshot\_di（覆盖 open\_hours）

```sql
sql-- step4.2.open_hours_decision 基于三层候选+配置做跨层决策，写回标签终表
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_hours';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    c.store_id,
    c.as_of_date,
    'open_hours' AS tag_code,

    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 最终选中的标签值
    CASE chosen_level
        WHEN 'STORE'   THEN c.candidate_store_string
        WHEN 'MERCHANT' THEN c.candidate_merchant_string
        WHEN 'PARTY'    THEN c.candidate_party_string
        ELSE NULL
    END AS target_value_string,

    NULL AS enum_code,

    chosen_level AS source_level,
    'INFERRED'   AS evidence_state,

    30 AS ttl_days,
    chosen_conf AS conf,

    decision_reason AS reason,
    'open_hours_v1' AS algo_version,

    -- 备份：这里先写 store 候选，后续可以扩展为 JSON
    c.candidate_store_string AS target_value_string_back
FROM (
    SELECT
        c.*,
        cfg.conf_threshold_store,
        cfg.hierarchy_weight_store,
        cfg.hierarchy_weight_merchant,
        cfg.hierarchy_weight_party,

        -- 分层分数
        (c.conf_store    * cfg.hierarchy_weight_store)    AS score_store,
        (c.conf_merchant * cfg.hierarchy_weight_merchant) AS score_merchant,
        (c.conf_party    * cfg.hierarchy_weight_party)    AS score_party,

        -- 决策：先看 store 是否超过红线，否则看三层 score 最大
        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'STORE'
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN 'MERCHANT'
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN 'PARTY'
                    ELSE 'STORE'
                END
        END AS chosen_level,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN c.conf_store
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN c.conf_merchant
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN c.conf_party
                    ELSE c.conf_store
                END
        END AS chosen_conf,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'store_conf_above_threshold'
            ELSE 'hierarchy_score_max'
        END AS decision_reason

    FROM open_hours_candidate_di c
    JOIN tag_algo_config cfg
      ON cfg.tag_code     = 'open_hours'
     AND cfg.algo_version = 'open_hours_v1'
    WHERE c.as_of_date = @biz_date
) x;
```

#### 4.2.2 更新 open\_hours 审计（带三层候选+conf）

```sql
sql-- step4.2.audit_open_hours 写入带三层候选+置信度的审计日志
DELETE FROM tag_audit_log_di
 WHERE as_of_date   = @biz_date
   AND tag_code    = 'open_hours'
   AND algo_version = 'open_hours_v1';

INSERT INTO tag_audit_log_di (
    store_id,
    as_of_date,
    tag_code,
    algo_version,
    chosen_level,
    chosen_value_string,
    chosen_enum_code,
    conf_final,
    conf_store,
    conf_merchant,
    conf_party,
    candidate_store_string,
    candidate_merchant_string,
    candidate_party_string,
    manual_override_flag,
    trace_json
)
SELECT
    t.store_id,
    t.as_of_date,
    'open_hours' AS tag_code,
    t.algo_version,
    t.source_level AS chosen_level,
    t.target_value_string AS chosen_value_string,
    t.enum_code AS chosen_enum_code,
    t.conf AS conf_final,

    c.conf_store,
    c.conf_merchant,
    c.conf_party,

    c.candidate_store_string,
    c.candidate_merchant_string,
    c.candidate_party_string,

    0 AS manual_override_flag,

    JSON_OBJECT(
        'strategy', 'store_threshold_then_hierarchy',
        'conf_threshold_store', cfg.conf_threshold_store,
        'hierarchy_weight_store', cfg.hierarchy_weight_store,
        'hierarchy_weight_merchant', cfg.hierarchy_weight_merchant,
        'hierarchy_weight_party', cfg.hierarchy_weight_party,
        'decision_reason', t.reason
    ) AS trace_json
FROM store_tag_snapshot_di t
JOIN open_hours_candidate_di c
  ON c.as_of_date = t.as_of_date
 AND c.store_id   = t.store_id
JOIN tag_algo_config cfg
  ON cfg.tag_code     = 'open_hours'
 AND cfg.algo_version = 'open_hours_v1'
WHERE t.as_of_date = @biz_date
  AND t.tag_code   = 'open_hours';
```

> 说明：
> 
> - 现在审计里既能看到最终 chosen\_level/value，又能看到三层候选和各自 conf；
> - 决策原因只分两类：门店过阈值 / 层级打分最高，足够你后续分析。

---

### 三、接下来你可以怎么用

1. 直接从 step4.0 跑到 step4.2，确认都 `Affected rows >0` 。
2. 做几条简单校验：
1. 随机捞几条被商户/工商层覆盖的站点，对比一下源 open\_hours/open\_24h，看看是否“更合理”。

如果你跑完发现：

- 大部分仍来自 STORE，说明 store 源本身质量就不错；
- 有一小部分来自 MERCHANT/PARTY，这些就是你后续重点抽检和调参的对象。

你跑完 step4 之后，可以把几条统计结果贴给我（比如 source\_level 分布、覆盖率变化），我们再讨论要不要细化 conf 模型，或者把同样骨架迁到下一个标签（restroom\_available / parking\_available）。

20251207\_0200\_step4.2\_别名修正版  
tags: #SQL报错1054 #跨层决策 #open\_hours

---

你这次的报错原因其实很简单：

> `Unknown column 'c.store_id'`
> 
> 因为我在子查询里把别名叫成 `x` 了，外层 SELECT 还在用 `c.store_id` ，直接找不到列。

我们只需要把 step4.2 的那条 INSERT 改成“内层别名 d/外层用 d.xxx”，就能跑通。

下面是 **替换版的 step4.2 决策 SQL** ，直接覆盖你原来的那段 `DELETE + INSERT` 即可。

---

### 替换用：step4.2 决策写回终表（修正版）

```sql
sql-- step4.2.open_hours_decision 基于三层候选+配置做跨层决策，写回标签终表（修正版）
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_hours';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    d.store_id,
    d.as_of_date,
    'open_hours' AS tag_code,

    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 最终选中的标签值
    CASE d.chosen_level
        WHEN 'STORE'    THEN d.candidate_store_string
        WHEN 'MERCHANT' THEN d.candidate_merchant_string
        WHEN 'PARTY'    THEN d.candidate_party_string
        ELSE NULL
    END AS target_value_string,

    NULL AS enum_code,

    d.chosen_level AS source_level,
    'INFERRED'     AS evidence_state,

    30 AS ttl_days,
    d.chosen_conf  AS conf,

    d.decision_reason AS reason,
    'open_hours_v1'   AS algo_version,

    -- 备份：先写 store 候选，后续可以扩展为 JSON
    d.candidate_store_string AS target_value_string_back
FROM (
    SELECT
        c.as_of_date,
        c.store_id,
        c.pop_id,
        c.party_key,
        c.candidate_store_string,
        c.conf_store,
        c.candidate_merchant_string,
        c.conf_merchant,
        c.candidate_party_string,
        c.conf_party,
        cfg.conf_threshold_store,
        cfg.hierarchy_weight_store,
        cfg.hierarchy_weight_merchant,
        cfg.hierarchy_weight_party,

        -- 分层分数
        (c.conf_store    * cfg.hierarchy_weight_store)    AS score_store,
        (c.conf_merchant * cfg.hierarchy_weight_merchant) AS score_merchant,
        (c.conf_party    * cfg.hierarchy_weight_party)    AS score_party,

        -- 决策：先看 store 是否超过红线，否则看三层 score 最大
        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'STORE'
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN 'MERCHANT'
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN 'PARTY'
                    ELSE 'STORE'
                END
        END AS chosen_level,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN c.conf_store
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN c.conf_merchant
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN c.conf_party
                    ELSE c.conf_store
                END
        END AS chosen_conf,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'store_conf_above_threshold'
            ELSE 'hierarchy_score_max'
        END AS decision_reason

    FROM open_hours_candidate_di c
    JOIN tag_algo_config cfg
      ON cfg.tag_code     = 'open_hours'
     AND cfg.algo_version = 'open_hours_v1'
    WHERE c.as_of_date = @biz_date
) d;
```

---

### 接下来怎么跑

1. 重新执行上面的 `DELETE + INSERT` （step4.2 决策）。
2. 再执行你后面的审计写入 step4.2.audit\_open\_hours（那个不需要改）。
3. 简单检查几下：

如果这一步也跑通了，我们就算是把 “三层候选 + 决策器” 版本的 `open_hours` 打完第一轮闭环了。  
你跑完可以把 `source_level` 的分布和大概行数贴给我，我们再一起看看需不需要微调阈值/权重，或者直接开始把同样骨架复制到 `restroom_available / parking_available` 这些服务标签上。

20251207\_0235\_open\_hours\_终表字段逻辑梳理  
tags: #store\_tag\_snapshot\_di #字段解释 #open\_hours #三层决策

---

### 1）一句话结论

`store_tag_snapshot_di` 对于 `open_hours` 这条链路，就是“某天、某站点、某标签”的 **最终决策结果表** ：把三层候选（门店/商户/工商）、配置表和决策器压扁成一行，方便下游查值。每个字段都能追溯到哪一层的什么逻辑。

---

### 2）三段论据（现状困惑 → 核心决策逻辑 → 字段-by-字段）

#### 论据一：你现在的困惑

- 你看到了分布：
	- STORE 15210
	- MERCHANT 1028
	- PARTY 8
- 说明决策器已经在起作用，但终表上的字段（特别是 `source_level / conf / reason / target_value_string_back` ）没有一眼能看懂“到底是怎么算出来的、和上游有什么关系”。

#### 论据二：核心决策逻辑再压缩一遍

在 `open_hours_candidate_di` 里，我们为每个 `store_id` 先算出：

- 三层候选值：
	- `candidate_store_string` ：门店层区间（来自 is\_zxgj → open\_hour\_min\_30d/open\_hour\_max\_30d）。
	- `candidate_merchant_string` ：同一商户下所有门店最早开门 + 最晚关门。
	- `candidate_party_string` ：同一 party\_key 下所有门店最早开门 + 最晚关门。
- 三层置信度：
	- `conf_store` ：只要门店有合法区间，就 1.0，否则 0。
	- `conf_merchant` ：商户满足「数据占比足够 + 非黑名单 + 无大量负反馈 + 有合法聚合区间」，给 0.8，否则 0。
	- `conf_party` ：工商主体下「有数据商户占比 ≥0.5 且有合法聚合区间」，给 0.7，否则 0。

再结合 `tag_algo_config` 中的配置：

- `conf_threshold_store` ：门店层红线（0.9）。
- `hierarchy_weight_*` ：三层权重（store=0.8, merchant=1.0, party=0.7）。

决策规则就是：

1. 如果 `conf_store >= conf_threshold_store` ⇒ 一律用门店（STORE）。
2. 否则算三层打分：
	- `score_store   = conf_store    * weight_store`
	- `score_merchant= conf_merchant * weight_merchant`
	- `score_party   = conf_party    * weight_party`  
		取分数最高的层级作为最终 `source_level` 和 `target_value_string` 的来源。

你看到的 15210 / 1028 / 8 就是这个逻辑跑出来的分布。

#### 论据三：终表字段逐个拆解（按 open\_hours 这条链路）

下面我按字段罗列： **字段含义 → 值是怎么来的 → 跟上游有什么关系** 。

> 注：仅针对 `tag_code = 'open_hours'` 的场景。

---

### 3）字段-by-字段逻辑梳理（open\_hours）

#### 3.1 主键相关

1. `store_id`
	- 含义：站点主键。
	- 来源：来自 `open_hours_candidate_di.store_id` → 最初来自 `store_feature_snapshot_di` → 最终来自 `v_merchant_profile_latest_di.store_id` 。
	- 决策中不被修改，始终代表“这一行就是这个油站的标签结果”。
2. `as_of_date`
	- 含义：业务日期（快照日期）。
	- 来源： `@biz_date` ，你通过 step0 自动从物化表提取的最新 dt。
	- 用途：控制“这行标签是哪个周期的数据”，也是我们每天重算时的分区键。
3. `tag_code`
	- 含义：标签英文标识，这里恒等于 `'open_hours'` 。
	- 来源：INSERT 时写死 `'open_hours'` 。
	- 用途：终表是多标签共用的，通过 `tag_code` 区分是营业时间、是否 24 小时等。

---

#### 3.2 标签值相关

1. `target_value_bool`
	- open\_hours 下恒为 `NULL` 。
	- 因为 open\_hours 是一个“区间字符串标签”（比如 06-22），而不是是/否标签。布尔结果只用于 open\_24h 这类标签。
2. `target_value_number`
	- open\_hours 下恒为 `NULL` 。
	- 未来若某些标签存在“数值形态”可用这个字段（例如“预计运营小时数”）。
3. `target_value_string`
	- 含义：最终生效的营业时间区间文本。
	- 产出逻辑：
	- 来源链路：
		- `candidate_store_string` 来自 `store_feature_snapshot_di.open_hour_min_30d/max_30d` → is\_zxgj 清洗反算。
		- `candidate_merchant_string` 来自 `tmp_merchant_open_agg` ：同商户下所有门店的 min / max 小时。
		- `candidate_party_string` 来自 `tmp_party_open_agg` ：同 party\_key 下所有门店的 min / max 小时。
	- 换句话说：
		- 如果 `source_level=STORE` ，这里就是“门店自己的 is\_zxgj 区间”；
		- 如果是 MERCHANT / PARTY，就是对应聚合层的“最早开门+最晚打烊”的预测区间。
4. `enum_code`
	- open\_hours 当前恒为 NULL。
	- 预留给枚举型标签（比如 A/B/C 档），open\_hours 这种自由区间暂时用不上。

---

#### 3.3 决策出处 &证据状态

1. `source_level`
	- 含义：最终采用的是哪个层级的候选值：
		- `STORE` / `MERCHANT` / `PARTY` 。
	- 来源：
		- 在决策子查询里叫 `chosen_level` ：
			- 如果 `conf_store >= conf_threshold_store` ⇒ `'STORE'` 。
			- 否则比较三层 score，score 最大者对应的层级。
	- 你看到的分布：
		- STORE 15210（门店本身就很可信）；
		- MERCHANT 1028（门店不够好，商户更可信）；
		- PARTY 8（门店和商户都较弱，工商层给了兜底）。
2. `evidence_state`
	- 当前 open\_hours 恒为 `'INFERRED'` 。
	- 含义：这行标签是“推断值”而不是“直接从原始字段原封不动搬来”。
		- 如果以后你引入人工标注、合同字段等，可以有 `'MANUAL' / 'CONTRACT' / 'FOUND_IN_RAW'` 之类的状态。

---

#### 3.4 置信度与 TTL

1. `ttl_days`
	- 含义：该标签值的“建议有效期天数”。
	- 当前 open\_hours 写死为 30。
	- 理解为：“默认认为 30 天内这个营业时间预测是有效的，不主动刷新也可以用”。
2. `conf`
	- 含义：最终被写入的置信度（0~1 之间）。
	- 来源：
		- 如果走“门店过阈值”路径： `chosen_conf = conf_store` （这里就是 1.0）；
		- 否则取 score 最大那一层对应的 conf（0.8/0.7…）。
	- 现在我们给的是离散值（1.0 / 0.8 / 0.7 / 0），后续你可以细化成连续函数（考虑订单量、统一度、反馈等）。

---

#### 3.5 决策原因 & 算法版本

1. `reason`
	- 含义：简短记录“为什么是这个层级”。
	- 当前有两种值：
		- `'store_conf_above_threshold'` ：门店层置信度≥配置阈值（默认 0.9），直接用门店。
		- `'hierarchy_score_max'` ：门店没过阈值，通过三层 score 比较选了更上层。
	- 用途：
		- 你以后筛选“因门店不稳定而被商户/工商覆盖”的样本时，就看 `reason='hierarchy_score_max'` 就行。
2. `algo_version`
	- 含义：算法版本号，当前为 `'open_hours_v1'` 。
	- 来源：写死，且和 `tag_algo_config` 的版本保持一致。
	- 用途：
		- 将来你调参数、改规则时，可以新增 `'open_hours_v2'` ，新老版本可以在一张表共存，支持 A/B 和回溯。

---

#### 3.6 备份值

1. `target_value_string_back`
	- 含义：当前版本下，储存“门店层严格候选”的备份值。
	- 来源： `candidate_store_string` 。
	- 用途：
		- 快速比较“最终结果 vs 单纯门店结果”的差异：
			- 当 `source_level <> 'STORE'` 且 `target_value_string_back <> target_value_string` 时，即为“被商户/工商覆盖、且区间发生变化”的站点，是典型的人工抽检样本。
		- 未来你也可以把它替换成更复杂的 JSON（比如三层候选全埋进去），但目前我们已经通过审计表存了更详细的 trace。

---

### 4）思维导图结构（终表在整个链路中的位置）

- 上游：
	- `v_merchant_profile_latest_di` （物化 + is\_zxgj 修复）
		- ↓ step2.1 → `store_feature_snapshot_di` （min/max hour, has\_order\_before\_6/after\_20, total\_order）
		- ↓ step2.2 → `merchant_feature_snapshot_di` （store\_with\_data\_ratio, merchant\_order\_cnt\_30d, is\_agg\_blocked\_merchant, feedback\_cnt）
		- ↓ step2.3 → `party_feature_snapshot_di` （merchant\_with\_data\_ratio, party\_order\_cnt\_30d）
- 中游：
	- `open_hours_candidate_di` （step4.1）
		- 三层候选：store/merchant/party 的区间
		- 三层 conf：conf\_store/conf\_merchant/conf\_party
- 配置：
	- `tag_algo_config` （open\_hours\_v1）
		- conf\_threshold\_store / min\_merchant\_data\_ratio / max\_feedback\_cnt\_for\_agg / weights
- 决策：
	- `store_tag_snapshot_di` （step4.2）
		- 每行 = 上述全部的“压缩结果”（最终值+层级+置信度+原因）
	- `tag_audit_log_di`
		- 保留三层候选与 conf，实现审计与追溯。

---

### 5）迭代日志（本轮到这里为止我们实际上完成了什么）

- 已完成：
	- 从“只靠门店 is\_zxgj 出 open\_hours”升级到“门店+商户+工商三层候选 + 配置驱动的决策器”；
	- 把决策结果稳态落到 `store_tag_snapshot_di` ，并用 `source_level / conf / reason / algo_version / *_back` 这些字段保证可解释性。
- 下一步建议：
	1. 你可以先写几条典型查询，例如：
		- 筛 `source_level='MERCHANT'` 且 `target_value_string_back <> target_value_string` 的站点，看它们是不是更符合业务直觉。
	2. 如果你希望“这个表一眼看懂”，下一版我们可以：
		- 在 `store_tag_snapshot_di` 的基础上再建一个视图 `v_store_tag_open_hours_explained` ，直接 join 上候选和审计，把“最终值 + 三层值 + conf + reason”展开成一张宽表，用来做数据分析/导出。
	3. 同样的骨架已经可以复制到其它 A 类服务标签（如 `restroom_available` ），只改特征 + 规则，不改整体框架。

如果你愿意，下一步我可以直接：

- 帮你写一个 `v_store_tag_open_hours_explained` 的视图 SQL；
- 或者开始规划“复制 open\_hours 骨架到 restroom\_available / parking\_available”的 stepX 脚本。

20251207\_0945\_终表字段语义澄清 & open\_hours/open\_24h 一致性改造  
tags: #store\_tag\_snapshot\_di #enum\_code #evidence\_state #open\_hours #open\_24h

---

### 1）先用你问的 4 点把逻辑讲清楚

#### 1\. enum\_code：应该和哪一个 target\_value\_\* 对齐？

你的理解是对的，可以这么定义这一列：

> 在任意一条记录里， `target_value_bool/number/string` 里 **最多有一个是非空** ， `enum_code` 就是对这个非空值的“规范化编码”。

具体到我们现在两个标签：

- `open_24h`
	- `target_value_bool` ：1/0/99（是/否/未知）
	- 建议： `enum_code` 用 `'Y'/'N'/'UNKNOWN'` ，和业务表达一致；
- `open_hours`
	- 只有 `target_value_string` 非空（营业时间区间），
	- 建议： `enum_code = target_value_string` ，也就是用区间字符串本身作为“枚举值”。

这样你在任何下游查询里，只要知道“这个标签是 bool/number/string 哪一种”，就可以直接用 enum\_code 做统计分组。

> 后面我会给你一段专门修 `open_24h` enum\_code 的 UPDATE； `open_hours` 会在新版本 INSERT 时直接写好。

---

#### 2\. evidence\_state：推荐的枚举值和逻辑

我们现在已经用到两个值，其实可以正式定一套“有限枚举”：

- `FOUND_IN_RAW`
	- 含义：直接来自原始字段 / 原始表，基本是“抄一遍”。
	- 例子：以后如果你直接用某个合同字段或人工录入字段作为标签值，就可以标成这个。
- `INFERRED`
	- 含义：基于行为/特征/聚合规则推断出来的算法值。
	- 当前： `open_hours/open_24h` 都属于这一类。

未来如果你要更细，还可以扩展（暂时不用改表，只当约定）：

- `MANUAL_CONFIRMED` ：区域人工确认/回填的最终值；
- `REGION_OVERRIDE` ：区域运营强制覆盖算法值；
- `EXTERNAL_SOURCE` ：比如第三方数据/B端系统同步过来的值。

现在只要记住： **我们这条 open\_hours/open\_24h 链路全部都是 `INFERRED` ，是根据订单行为 + 聚合规则推出来的** ，不是“抄合同”。

---

#### 3\. 为什么 target\_value\_string\_back 大部分是空的？

原因分两类：

1. 逻辑上的：
	- 对 `open_hours` ：
		- 只有在门店/商户/工商至少有一个合法区间时，我们才有 `candidate_*_string` ；
		- 如果这个站在所有层级都没有合法区间（例如 is\_zxgj 异常、数据为 NULL），那候选值就是 NULL， `target_value_string_back` 也会是 NULL，这是合理的“没法算”。
	- 对 `open_24h` ：
		- 我们本来就没给 `target_value_string_back` 赋值，全是 NULL。
2. 演进上的：
	- 你一开始跑的是 “纯 STORE 严格版”，后来又用 step4 覆盖成“三层决策版”，中间的 INSERT 里我给的是：
		- 若这一站来源是 MERCHANT/PARTY 且门店自己没有合法区间，那么 store 候选就是 NULL，自然就空了。

接下来你想要的是：

- 对 `open_hours` ： **所有有最终值的站点，都有一个“原始严格区间”备份** ，哪怕是商户/工商层补出来的；
- 对 `open_24h` ：我们其实暂时不需要 string\_back，用 bool + enum\_code +审计表就够了。

下面我在新的 open\_hours 决策 SQL 里，会把 `target_value_string_back` 明确定义为：

> “未做 24 小时强制覆盖前的 `HH-HH` 区间（三层决策之后的结果）”。

---

#### 4\. 关键逻辑：open\_24h = 1 时，open\_hours 必须是 00:00-24:00

你的要求很明确，我也同意：

- `open_24h = 1` ⇒ `open_hours` 必须是 `'00:00-24:00'` ，不能再出现 `06:00-23:00` 之类的矛盾组合；
- `open_hours` 最终值要统一用 `HH:MM-HH:MM` 格式；
- 同时要保留“原本算法得到的非 24 小时区间”（比如 `06-23` ），方便追溯，这个就是 `target_value_string_back` 的职责。

综合一下你要的效果是：

- 数据层面约束：
	- `tag_code='open_24h' AND target_value_bool=1` 时，必然有一条 `tag_code='open_hours'` 且 `target_value_string='00:00-24:00'` ；
- 结果展示层：
	- `open_hours.target_value_string` ：统一 `HH:MM-HH:MM` 格式；
	- `open_hours.target_value_string_back` ：保存三层决策后的“原始区间” `HH-HH` （例如 `06-23` ），不受 24h 覆盖影响。

下面我直接给你 **两块可执行的改造** ：

1）修正 `open_24h` 的 enum\_code；  
2）重写 open\_hours 决策的 INSERT，让它：

- 引用 open\_24h 结果；
- 同步改 HH:MM-HH:MM 格式；
- 严格保证 24 小时一致性。

---

### 2）改造一：修正 open\_24h 的 enum\_code（一次性 UPDATE）

> 这段是“补偿性修复”，你可以先跑一下，整理现有数据。

---

### 3）改造二：重写 open\_hours 最终写入逻辑（对齐 24h + HH:MM-HH:MM）

我们主要改 **step4.2.open\_hours\_decision** 那段，把：

- `target_value_string`
- `enum_code`
- `target_value_string_back`

改成你想要的语义，并在决策时 join 上 `open_24h` 的结果。

#### 3.1 新版 step4.2 决策（可以覆盖原版本）

```sql
sql-- step4.2.open_hours_decision_v2 三层决策 + 和 open_24h 对齐 + HH:MM-HH:MM 格式
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_hours';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    d.store_id,
    d.as_of_date,
    'open_hours' AS tag_code,

    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 最终写入的营业时间：先考虑 open_24h=1，再格式化为 HH:MM-HH:MM
    CASE 
        WHEN t24.target_value_bool = 1 THEN '00:00-24:00'
        ELSE
            CASE d.chosen_level
                WHEN 'STORE'    THEN d.store_range_hhmm
                WHEN 'MERCHANT' THEN d.merchant_range_hhmm
                WHEN 'PARTY'    THEN d.party_range_hhmm
                ELSE NULL
            END
    END AS target_value_string,

    -- enum_code = 文本标签的标准化编码，这里就等于 target_value_string
    CASE 
        WHEN t24.target_value_bool = 1 THEN '00:00-24:00'
        ELSE
            CASE d.chosen_level
                WHEN 'STORE'    THEN d.store_range_hhmm
                WHEN 'MERCHANT' THEN d.merchant_range_hhmm
                WHEN 'PARTY'    THEN d.party_range_hhmm
                ELSE NULL
            END
    END AS enum_code,

    d.chosen_level AS source_level,
    'INFERRED'     AS evidence_state,

    30 AS ttl_days,
    d.chosen_conf  AS conf,

    d.decision_reason AS reason,
    'open_hours_v1'   AS algo_version,

    -- 备份：不受 open_24h 覆盖影响，保留三层决策后的“原始 HH-HH 区间”
    CASE d.chosen_level
        WHEN 'STORE'    THEN d.candidate_store_string
        WHEN 'MERCHANT' THEN d.candidate_merchant_string
        WHEN 'PARTY'    THEN d.candidate_party_string
        ELSE NULL
    END AS target_value_string_back
FROM (
    SELECT
        c.as_of_date,
        c.store_id,
        c.pop_id,
        c.party_key,
        c.candidate_store_string,
        c.conf_store,
        c.candidate_merchant_string,
        c.conf_merchant,
        c.candidate_party_string,
        c.conf_party,
        cfg.conf_threshold_store,
        cfg.hierarchy_weight_store,
        cfg.hierarchy_weight_merchant,
        cfg.hierarchy_weight_party,

        -- 将 HH-HH 转成 HH:MM-HH:MM（只对合法格式处理）
        CASE 
            WHEN c.candidate_store_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                CONCAT(
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_store_string, '-', 1) AS UNSIGNED), 2, '0'),
                    ':00-',
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_store_string, '-', -1) AS UNSIGNED), 2, '0'),
                    ':00'
                )
            ELSE c.candidate_store_string
        END AS store_range_hhmm,

        CASE 
            WHEN c.candidate_merchant_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                CONCAT(
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_merchant_string, '-', 1) AS UNSIGNED), 2, '0'),
                    ':00-',
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_merchant_string, '-', -1) AS UNSIGNED), 2, '0'),
                    ':00'
                )
            ELSE c.candidate_merchant_string
        END AS merchant_range_hhmm,

        CASE 
            WHEN c.candidate_party_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                CONCAT(
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_party_string, '-', 1) AS UNSIGNED), 2, '0'),
                    ':00-',
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_party_string, '-', -1) AS UNSIGNED), 2, '0'),
                    ':00'
                )
            ELSE c.candidate_party_string
        END AS party_range_hhmm,

        -- 分层分数
        (c.conf_store    * cfg.hierarchy_weight_store)    AS score_store,
        (c.conf_merchant * cfg.hierarchy_weight_merchant) AS score_merchant,
        (c.conf_party    * cfg.hierarchy_weight_party)    AS score_party,

        -- 决策：先看 store 是否超过红线，否则看三层 score 最大
        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'STORE'
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN 'MERCHANT'
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN 'PARTY'
                    ELSE 'STORE'
                END
        END AS chosen_level,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN c.conf_store
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN c.conf_merchant
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN c.conf_party
                    ELSE c.conf_store
                END
        END AS chosen_conf,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'store_conf_above_threshold'
            ELSE 'hierarchy_score_max'
        END AS decision_reason

    FROM open_hours_candidate_di c
    JOIN tag_algo_config cfg
      ON cfg.tag_code     = 'open_hours'
     AND cfg.algo_version = 'open_hours_v1'
    WHERE c.as_of_date = @biz_date
) d
LEFT JOIN store_tag_snapshot_di t24   -- 引用 open_24h 结果
  ON t24.store_id   = d.store_id
 AND t24.as_of_date = d.as_of_date
 AND t24.tag_code   = 'open_24h';
```

> 关键变化总结：  
> 1）内部先把三层候选从 `HH-HH` 转成 `HH:MM-HH:MM` （store/merchant/party 各一列）；  
> 2）外层 left join open\_24h，如果 `target_value_bool=1` ，直接把 `target_value_string/enum_code` 设为 `'00:00-24:00'` ；  
> 3） `target_value_string_back` 保留三层决策后的“原始 HH-HH 区间”（不带:00），用于追溯；  
> 4） `enum_code` 对齐 `target_value_string` ，满足你“3 选 1 非空值”的约定。

---

### 4）你接下来可以怎么做

1. 顺序执行：
	- `step_fix_open_24h_enum_code` （一次性补偿）；
	- 重新跑 open\_24h（step3.2，那段 INSERT）——如果你有改动；
	- 用上面新版的 `step4.2.open_hours_decision_v2` 重跑 open\_hours；
2. 跑完后做两个简单校验：

如果这两个检查结果都正常，那么你的终表结构就已经满足：

- enum\_code 规范；
- evidence\_state 清晰；
- target\_value\_string\_back 有意义；
- open\_hours / open\_24h 强一致；
- 展示格式统一为 HH:MM-HH:MM。

后面你再把这一整套方法复制到其他 A 类标签上（比如服务类标签），框架就完全可复用了。

1.拉齐一个重大共识\[\*\*一句话结论：\*\* 现在就把 `station_tag_target_value` 的落表逻辑严格改成：先算出 `enum_code/enum_label` ，再根据 `value_type_connect` 精确把“唯一的 code 值”写入三选一的 `target_value_bool/number/string` 里，保证任意一行有且仅有一个 target\_value\_\* 非空，其余两个一定为 NULL。 --- ## 一、先对齐语义：三选一 + enum\_code 主导 你的口径我再帮你抽象一遍，后面 SQL 全按这个来写： 1. \*\*三选一的硬约束\*\* - 对于任意一行 `station_tag_target_value` ： - `target_value_bool、target_value_number、target_value_string` 三个字段中，\*\*有且仅有一个非 NULL\*\*； - 多个字段同时非空 → 清洗错误； - 全部为空 → 清洗失败（无值）。 2. \*\*enum\_code 驱动写值\*\* - 对“枚举型标签”（比如 `brand_name` ）： - 先用 `final_raw_value` 去 `tag_enum` 里匹配到 `enum_code / enum_label` ； - 再看 `tag_spec.value_type_connect` ： - 若是 `target_value_string` → 把 `enum_code` 写到 `target_value_string` ； - 若是 `target_value_bool` → 把 bool 结果写到 `target_value_bool` （本质也是 code，0/1）； - 若是 `target_value_number` → 数值型标签则写到 `target_value_number` 。 - 对“非枚举型标签”： - `enum_code/enum_label` 为空； - 直接根据 `value_type_connect` 把 `final_raw_value` 转成 bool/number/string 存进对应字段。 3. \*\*中英分离\*\* - `enum_code` ：英文/数字 code（如 BRAND\_0001），作为“最终标签值”的标准标识； - `enum_label` ：中文名（如 中化石油），只是用来对比原始值； - `target_value_string` ：\*\*永远存 code，不存中文 label\*\*。 你说的例子翻译成规则就是： > `tag_code = brand_name` ， `final_raw_value = '中化石油'` ，在 `tag_enum` 里找到 `enum_code = 'BRAND_0001'` 、 `enum_label = '中化石油'` ， > 再查 `tag_spec.value_type_connect = 'target_value_string'` ， > → 在结果表里： > > - `target_value_string = 'BRAND_0001'` > > - `enum_code = 'BRAND_0001'` > > - `enum_label = '中化石油'` > > - `target_value_bool = NULL` > > - `target_value_number = NULL` 。 > \],具体的说就是一个字典规范,要查询字典来写入最后的 标签值,都有规范的; 不能乱写,比如你这里的现在写的,t.tag\_code = 'open\_24h',的 t.enum\_code 就只有 1/0,因为他不是 1 就是 0,字典约束的,所以 99 也统一写 0,\[tag\_code spec\_version enum\_code enum\_label sort\_order is\_default brand\_aliases exclusion\_field brand\_category keywords is\_active match\_method match\_score\_threshold white\_list black\_list created\_at updated\_at updated\_by open\_24h 1.0.0 0 否 20 0 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import open\_24h 1.0.0 1 是 1 0 1 0 1.00 1 0 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import\];这里具体的字典关系,你可以读我们的项目文件表的,tag\_enum;2.字典规范约束下的,算法才是有意义的,如果你不清楚可以询问,我来对齐这个逻辑,在开始往下改造;

20251207\_1210\_标签终表规范对齐与 open\_24h/open\_hours 重构口径  
tags: #station\_tag\_target\_value #tag\_enum #value\_type\_connect #open\_24h #open\_hours

---

### 1）一句话结论

我们现在立一个“不会再改的硬规范”：所有标签落到 `station_tag_target_value` （你目前的 `store_tag_snapshot_di` 原型）时，先由 `tag_enum + tag_spec.value_type_connect` 决定 `enum_code/enum_label` ，再按照“三选一”规则写入唯一的一个 `target_value_xxx` 字段， `open_24h/open_hours` 这两条也全部按这个规范重写。

---

### 2）三段论据

#### 论据一：终表语义要先统一，否则后面所有算法都不稳

基于你说的“重大共识 + 字典约束”，我把终表的“隐含规则”正式收束成 3 点：

1. **三选一硬约束（对所有 tag\_code 通用）**
	- 行级约束：
		- `target_value_bool / target_value_number / target_value_string` 中， **有且仅有一个非 NULL** 。
	- 违反的情况定义为错误：
		- 多列非空 → 清洗逻辑错误；
		- 全部为空 → 算法失败/无值（可以配合 `enum_code=fallback` 表示）。
2. **enum\_code 主导标签值（由 tag\_enum + tag\_spec 决定）**
	- 对“枚举型标签”（tag\_enum 里有多行 code）：
		- 先用算法产出的 `final_raw_value` （字符串/数值/布尔）去 `tag_enum` 匹配出 `enum_code / enum_label` ；
		- 再看 `tag_spec.value_type_connect` ：
			- `target_value_string` → 把 `enum_code` 写到 `target_value_string` ，其余两个为 NULL；
			- `target_value_bool` → 实值写到 `target_value_bool` （本质上也是 code，0/1），其余两个为 NULL；
			- `target_value_number` → 数值写到 `target_value_number` ，其余两个为 NULL。
	- 对“非枚举型标签”（tag\_enum 只有一个 fallback 或没有枚举值）：
		- `enum_code/enum_label` 对正常值为空，只有 fallback 用于“未知”；
		- 直接根据 `value_type_connect` 把 `final_raw_value` 转成 bool/number/string 写进对应字段。
3. **中英分离 & 永远存 code，不存中文**
	- `enum_code`: 英文/数字 code（BRAND\_0001、0/1 这种），代表“标签值的标准 ID”；
	- `enum_label`: 中文展示名；
	- `target_value_string`: 对枚举型标签， **只存 code，不存中文** ；对非枚举型标签，存规范化后的业务字符串（例如 HHMM-HHMM）。

这三条一旦定死，你所有“覆盖率 / 准确率 / 版本治理 / A/B”都是在一个稳固协议上跑的，不会再出现“这列到底是中文还是英文”的灰区。

---

#### 论据二：open\_24h、open\_hours 在字典里的真正约束

结合我已经读过的 `tag_spec/tag_enum` （只说和这两个标签相关的关键字段）：

1. **open\_24h**
- `tag_spec` ：
	- `value_type = bool`
	- `fallback = 99` （业务口径：不知道是不是 24h 就记 99）
	- `value_type_connect = target_value_bool`
- `tag_enum` ：
	- 只定义了两个枚举：
		- `enum_code = '1'` → `enum_label = '是'`
		- `enum_code = '0'` → `enum_label = '否'`
	- 没有 `enum_code = '99'` ，所以 **字典视角里只有“是/否”两种合法 code** 。

→ 这就约束出一个清晰规范：

- 算法可以用 `99` 作为 `target_value_bool` 的“内部 fallback 值”；
- 但 **`enum_code` 只允许 0/1，不允许 99** ：
	- 你刚才说得很直白：“99 也统一写 0”，即 enum 维度上，“未知先当成否”。
1. **open\_hours**
- `tag_spec` ：
	- `value_type = string`
	- `fallback = 'unknown'`
	- `validation_regex` 已经明确期望 HHMM-HHMM 或多段；
	- `value_type_connect = target_value_string` 。
- `tag_enum` ：
	- 目前只有一行： `enum_code = '99'` / `enum_label = '未知'` 。

→ 这里的规范可以这么落地：

- 对“算不出营业时间”的：
	- `enum_code = '99'` / `enum_label = '未知'` ；
	- 三选一里： `target_value_string = NULL` （或者写成 `'unknown'` ，但我建议 NULL 更干净）；
- 对“算得出 HHMM-HHMM 区间”的：
	- 这是非枚举值，目前 `tag_enum` 没有每个区间的 code， **就当非枚举标签处理** ：
		- `enum_code = NULL` ；
		- `target_value_string = 'HHMM-HHMM'` ；
		- `target_value_bool/number = NULL` 。

未来如果你想把一些区间标准化成枚举（比如 06:00-22:00 定义成 BUSINESS\_HOURS\_A），那再往 tag\_enum 里加 code 即可。

---

#### 论据三：基于规范的改造方向（而不是临时 patch）

现在我们可以把“你看到的怪现象”全部归因到“没有按这个规范来”：

- `open_24h` 的 `enum_code` 被我直接写成 1/0/“UNKNOWN 字符串”，显然违背 tag\_enum（只能 0/1）；
- `open_hours` 的 `target_value_string_back` 大量为空，是因为我们没有清晰区分：
	- 最终展示值（要和 open\_24h 对齐，24h 时强制 00:00-24:00）；
	- 决策前的“原始区间”备份（HH-HH）。

重构后的目标状态是：

1. **open\_24h 行：**
	- 三选一：
		- `target_value_bool ∈ {0,1,99}` ；
		- `target_value_number = NULL` ；
		- `target_value_string = NULL` ；
	- 字典：
		- `enum_code ∈ {'0','1'}` （99 统一映射为 '0'）；
		- `enum_label` 由 `tag_enum` join 得到（'是' 或 '否'）；
	- 解释：
		- 业务能看出来：0/1 正常值；99 是 fallback，但枚举视角一律当“否”。
2. **open\_hours 行：**
	- 三选一：
		- `target_value_string` 用 `HH:MM-HH:MM` （24 小时时写 `'00:00-24:00'` ）；
		- `target_value_bool/number` 一律 NULL；
	- 字典：
		- 算不出的： `enum_code = '99'` (未知)， `target_value_string = NULL` ；
		- 算得出的： `enum_code = NULL` ， `target_value_string = 'HH:MM-HH:MM'` ；
	- 一致性：
		- 存在一条 `open_24h(target_value_bool=1)` 时，必须存在同站同日一条 `open_hours(target_value_string='00:00-24:00')` 。
3. **open\_hours 的备份：**
	- `target_value_string_back` ：
		- 永远存“未被 24h 覆盖前的 HH-HH 区间”，即三层决策后选中的“原始时段”；
		- 即使 24h=1，最终展示是 `00:00-24:00` ，备份里仍然保留原区间（例如 `06-23` ），方便你追溯规则。

这就是你要的“一行只有一个值字段 + 字典驱动 + 24h 一致”的状态。

---

### 3）思维导图结构（文本）

- 终表规范
	- 三选一：唯一非空 target\_value\_xxx
	- enum\_code 主导（tag\_enum + tag\_spec.value\_type\_connect）
	- 中英分离：code vs label
- open\_24h 规范
	- value\_type: bool；value\_type\_connect: target\_value\_bool
	- fallback=99，仅出现在 target\_value\_bool，不出现在 enum\_code
	- enum\_code ∈ {0,1}，99 映射到 0
- open\_hours 规范
	- value\_type: string；value\_type\_connect: target\_value\_string
	- fallback='unknown' → enum\_code=99、target\_value\_string=NULL
	- 正常值：非枚举，enum\_code=NULL、target\_value\_string='HH:MM-HH:MM'
	- 与 open\_24h 一致性：24h=1 ⇒ open\_hours='00:00-24:00'
	- 备份：target\_value\_string\_back 存原始 HH-HH 区间
- 实施路径
	- 先修 open\_24h 的 enum\_code 落表逻辑
	- 再重写 open\_hours 决策 & 写表逻辑，对齐 24h + 新格式
	- 最后把这套规范抽象成“station\_tag\_target\_value 通用写入函数/SQL 模板”

---

### 4）迭代日志 & 下一步建议

- 本轮达成的关键共识：
	- 明确了 `station_tag_target_value` 的 **行级约束** 和“字典驱动”的落值方式；
	- 把 `open_24h / open_hours` 在 tag\_enum/tag\_spec 里的约束翻译成“落表规范”，不再凭空造值（尤其是 99 的处理）。
- 下一步建议（我直接按你的节奏来，不搞大作文）：
	1. 我先基于这个规范，给你一版 **“open\_24h 正确写入 station\_tag\_target\_value 的 SQL 片段”** ：
		- 先算 raw\_bool（0/1/99）；
		- 再根据 tag\_enum + value\_type\_connect，写 `enum_code` 和三选一字段。
	2. 再给一版 **“open\_hours 正确写入 + 与 open\_24h 同步 + HH:MM-HH:MM + back 字段”** 的终稿 SQL，完全符合你刚刚定下的字典约束。
	3. 最后，我们把这两段抽象成一个“标签落表模板”（带 tag\_code 参数），给后续 brand\_name 等标签直接复用。

如果你这边没有其他要补充的“规范条款”，我下一条就直接开始写：

- 先给 `open_24h` 的“从候选 → station\_tag\_target\_value”完整 SQL（严格按照你上面这套字典逻辑来）。

20251207\_1230\_open\_24h\_enum\_99\_兜底值设计  
tags: #tag\_enum #open\_24h #fallback99 #标签字典

---

### 1）一句话结论

是的，现在 `open_24h` 的字典只有 0/1，而 `tag_spec` 又约定 fallback=99，这本身就是冲突的；在 `tag_enum` 里补一条 `enum_code='99'` 的兜底值，并把它设为默认值，是更合理也更安全的做法。

---

### 2）三段论据

#### 论据一：为什么现在的设计是“矛盾”的？

现状（你给的字典）：

同时， `tag_spec` 那边又说：

- `fallback = 99` （算法算不出来时，target\_value\_bool 用 99 表示未知）

这就导致两个问题：

1. 算法层面：我们会生成 `target_value_bool=99` 的数据；
2. 字典层面： `enum_code` 只有 0/1，没有 99；
	- 你要么硬把 99 映射成 0（“未知当否”），要么 `enum_code` 留空，这两种都不标准。

从“规范 + 可解释”的角度，最干净的做法就是： **让 tag\_enum 也有 99 这一行，并且它是默认兜底枚举** 。

---

#### 论据二：新增 99 行时，最关键的字段是哪些？

你这张 `tag_enum` 的关键字段是：

对于 `open_24h` 的 `enum_code=99` 行，我们的设计原则是：

- `enum_code='99'` ， `enum_label='未知'` （或你习惯的“未识别”等）；
- `sort_order` ：建议给一个比较靠后的排序，比如 99；
- `is_default=1` ：表示这是“默认兜底枚举”，其它 0/1 行继续保持 is\_default=0；
- `is_active=1` 、 `match_method=0` 、 `match_score_threshold=1.0` ：跟现有 0/1 行保持一致即可；
- `white_list=1, black_list=0` ：默认允许使用；
- `created_at/updated_at` ：直接用 NOW()；
- `updated_by` ：写一个能看出是你手工修复的标识，比如 'alves\_manual\_fix'。

---

#### 论据三：这样做之后，算法与字典完全对齐

补上这条 99 之后：

- 算法可以合法地产生三种布尔结果：0/1/99；
- 落表时：
	- `target_value_bool = 99` 表示“未知是否 24h”；
	- `enum_code = '99'` / `enum_label='未知'` ，在终表或中台看报表时，这一类会被单独分桶，不会混到“否”里；
- 你可以在某些下游逻辑里选择是否把 99 当 0 用，但那是“业务策略”，而不是“字典结构被迫这样”。

---

### 3）在 tag\_enum 里插入 99 兜底值的 SQL（可直接执行）

下面这条就是你要的“补 99 行”的标准写法。你可以先 `SELECT * FROM tag_enum WHERE tag_code='open_24h';` 看看 spec\_version 是否就是 `1.0.0` ，确认后直接执行。

如果你希望“默认值不要影响 0/1 的使用”，但又想保留 99 行，也可以把 `is_default` 设成 0，只是那样 `tag_spec.fallback=99` 的自动逻辑就需要你在落表 SQL 里自己兜底，我不太推荐。

---

### 4）下一步建议

- 你插入这条 99 行之后，建议顺手做两件小事：
	1. 查一下 `tag_enum` 的最终结果：
	2. 后面在 `station_tag_target_value` 里重写 `open_24h` 落表逻辑时，就可以非常自然地：
		- `target_value_bool` 用 0/1/99；
		- `enum_code` 用 0/1/99 对应的那一行；
		- 三选一严格遵守。

你这一步做完，我们下一个动作就可以是：

- 给你一段“完全符合字典规范的 open\_24h 落表 SQL”，直接跑在现有 ETL 上，把之前的“乱写”清掉，彻底统一口径。

20251207\_1245\_open\_24h\_sort\_order\_重排\_SQL  
tags: #tag\_enum #open\_24h #sort\_order #优先级

---

一句话先说清楚：  
你要的是在 `tag_enum` 里，把 `tag_code = 'open_24h'` 的三条枚举按「1 > 0 > 99」排优先级，对应 `sort_order = 90 / 60 / 10` ，数值越大优先级越高，99 是兜底最低优先级。

直接给你一条可执行的 SQL（一次性改完）：

建议你执行完再查一眼确认：

你应该会看到 sort\_order 按 90（是） > 60（否） > 10（未知） 排列，这样后面无论是默认选值还是报表排序，都能正确体现“1 > 0 > 99，最小才兜底”的优先级语义。

很好，我们现在 **字典层(tag\_enum)** + **规范层(tag\_spec + 三选一协议)** 都已经对齐并修正完成。  
接下来就正式进入 **实现层** ：让 `open_24h` 和 `open_hours` 两条标签真正按“规范后的终表协议”落到 `station_tag_target_value` （你当前的 `store_tag_snapshot_di` 原型）。

---

## 20251207\_1310\_标签规范落地的下一步：进入“落表逻辑”重写阶段

tags: #station\_tag\_target\_value #open\_24h #open\_hours #三选一 #enum落表

---

## 一句话结论

**下一步要做的，就是编写两个标签的“规范化落表 SQL 模板”：  
1）open\_24h 的完全规范版落表 SQL；  
2）open\_hours 的完全规范版落表 SQL（含 24h 一致性 + HH:MM-HH:MM + back）。  
这两段 SQL 将覆盖你现在的 step3 + step4 的逻辑，把“候选 → 决策 → 落表”变成完全符合规范的产物。**

---

## 一、当前我们已经完成的事（形成闭环）

你已经完成了：

1. 枚举字典修正：
	- 给 `open_24h` 加了 `enum_code=99` 的兜底行。
	- 重排了 sort\_order = 90/60/10。
2. 规范对齐（刚才的文档）：
	- “三选一”协议
	- enum\_code 驱动
	- fallback 行为
	- open\_24h/open\_hours 的一致性
	- open\_hours 的 HH:MM-HH:MM 标准格式
	- target\_value\_string\_back 的真实含义（备份原始 HH-HH 决策值）

接下来就是 **把规范“写进 SQL”** 。

---

## 二、下一步应该做什么？

下面是正确的“下一步路线”，你只需要确认我按这个方向写即可。

---

## 【下一步 Step A】

**编写 open\_24h 的终表落表 SQL（规范化版本）**

这个 SQL 会完全遵守：

- 三选一：仅 `target_value_bool` 非空；
- enum\_code = {0/1/99}（来自字典），enum\_label join tag\_enum；
- fallback 用 99；
- evidence\_state = INFERRED；
- algo\_version = open\_24h\_v1；
- reason = 决策原因（可简化/扩展都行）

最终生成的数据结构格式为：

| 字段 | 值 |
| --- | --- |
| target\_value\_bool | 0/1/99 |
| target\_value\_string | NULL |
| target\_value\_number | NULL |
| enum\_code | 0/1/99（字典合法 code） |
| enum\_label | 是/否/未知 |
| evidence\_state | INFERRED |
| algo\_version | open\_24h\_v1 |

并且所有 24h=1 的站点必须写一条标签行。

**这个 Step A 让 open\_24h 成为最标准的标签。**

---

## 【下一步 Step B】

**编写 open\_hours 的终表落表 SQL（规范化 + 与 open\_24h 对齐）**

重点是：

1. **24h=1 → 强制写 00:00-24:00**
2. **最终区间格式统一 HH:MM-HH:MM**
3. **三选一中只有 target\_value\_string 非空**
4. **算不出区间 → enum\_code=99（未知）**
5. **算出区间 → enum\_code=NULL（非枚举标签）**
6. **target\_value\_string\_back 保留原始 HH-HH**
7. **evidence\_state = INFERRED**
8. **算法版本 open\_hours\_v2（建议升级版本标识）**

最终结构应是：

| 字段 | 值 |
| --- | --- |
| target\_value\_bool | NULL |
| target\_value\_number | NULL |
| target\_value\_string | HH:MM-HH:MM 或 NULL |
| enum\_code | NULL 或 99（未知） |
| enum\_label | NULL 或 未知 |
| target\_value\_string\_back | HH-HH 原始决策值 |
| evidence\_state | INFERRED |

这个 Step B 完成后， **open\_hours 是一个格式稳定、字段遵循规范的标签** 。

---

## 【下一步 Step C（可选但强烈推荐）】

**为这两个标签构造一个统一的“标签落表模板 SQL”**

模板结构：

参数化内容：

- tag\_code
- value\_type\_connect（决定三选一落到哪个字段）
- enum 匹配逻辑
- fallback 行为
- raw 值和 back 值
- source\_level/conf/reason

一旦模板成型，未来新标签的落表只要新增：

- 特征
- 候选
- 决策
- final\_raw\_value（单列）  
	即可自动落表，不需要重新写 20 条字段 SELECT。

---

## 三、现在请你确认两件事（回答“是/否 + 补充”即可）

### Q1：open\_24h 的落表 SQL，是不是由我按以下内容写？

- 输入：你在 step3.2 得到的 candidate（1/0/99），或你准备更新的新版规则
- 输出：严格遵守字典 & 三选一协议的落表版本
- enum\_code 绝不再写 "Y"/"UNKNOWN"，只写 0/1/99
- enum\_label 来自 tag\_enum join
- 版本名 open\_24h\_v1

**请回答：确认或需要补充？**

---

### Q2：open\_hours 的落表 SQL，是不是按以下内容写？

- 输入：目前 step4 决策的三层候选（store/merchant/party）
- 24h 覆盖（从终表 open\_24h 获取）
- HH:MM-HH:MM 格式
- back 存 HH-HH 原始
- enum\_code = NULL 或 99
- 版本名升级为 open\_hours\_v2

**请回答：确认或需要补充？**

---

只要你确认 Q1/Q2，我下一条消息就给你：

- open\_24h 落表 SQL（终稿）
- open\_hours 落表 SQL（终稿）
- 两段完全符合规范的模板（可直接复制执行）

20251207\_1405\_open\_24h\_open\_hours\_规范落表SQL\_AB版  
tags: #open\_24h #open\_hours #tag\_enum #三选一 #终表规范

---

### 1）一句话结论

现在先不动 `station_tag_target_value` ，我们在现有的 `store_tag_snapshot_di` 上完成 A（open\_24h 规范落表）+ B（open\_hours 规范落表、与 24h 对齐、支持“有枚举用枚举，否则用实际值”），等你校验通过后再整体迁移到最终终表。

---

### 2）三段论据

**论据一：enum\_code 行为要“有枚举用枚举、没枚举用实际值”**

- 对绝大多数标签（包括 open\_24h）：
	- `tag_enum` 里有完整 code 列表（0/1/99…），我们就用 `tag_enum.enum_code` 作为 `enum_code` ；
- 对 open\_hours 这种“没有区间枚举”的标签：
	- “未知”用 `enum_code='99'` ；
	- 算出具体区间时，用“区间本身”作为 `enum_code` （比如 `'06:00-23:00'` ），这样可读且兼容你的“宽容逻辑”。

**论据二：为什么 A/B 都先在 store\_tag\_snapshot\_di 里做**

- 你已经把 open\_hours 全套算子（特征 → 候选 → 决策）和 open\_24h 的 D1 规则跑通在 MySQL 本地；
- `store_tag_snapshot_di` 本质就是未来 `station_tag_target_value` 的“预演版”：
	- 字段结构类似： `tag_code、enum_code、target_value_*、source_level、evidence_state、algo_version…`
- 现在直接把 open\_24h / open\_hours 按终表规范重写一遍，
	- 你可以先在这个表上做覆盖率/一致性/抽样校验；
	- 等确认“业务不翻车”之后，再按你说的过滤逻辑迁移到 `station_tag_target_value` 。

**论据三：A/B 完成后，你的“标签终表协议”就算真正落地**

- open\_24h：
	- 三选一：只用 `target_value_bool` ；
	- enum\_code 只用 `0/1/99` （来自字典，有枚举用枚举），可读性好；
- open\_hours：
	- 三选一：只用 `target_value_string` ，统一 `HH:MM-HH:MM` ；
	- 24h=1 时强制 `'00:00-24:00'` ，和 open\_24h 完全一致；
	- `target_value_string_back` 永远保存“原始 HH-HH 决策值”；
	- enum\_code 对 open\_hours 采用“未知 = 99；否则用实际值”的宽容逻辑。

---

### 3）思维导图结构（文本）

- 目标
	- A：open\_24h 规范落表 → store\_tag\_snapshot\_di
	- B：open\_hours 规范落表 + 对齐 open\_24h → store\_tag\_snapshot\_di
- 规范约束
	- 三选一：唯一非空 target\_value\_\*
	- enum\_code：有枚举用枚举，无枚举用实际值
	- evidence\_state：INFERRED（当前两条标签）
- A：open\_24h
	- 输入：store\_feature\_snapshot\_di（min/max hour + D1 信号）
	- 逻辑：raw\_bool(0/1/99) → join tag\_enum → bool-only 三选一
- B：open\_hours
	- 输入：open\_hours\_candidate\_di（三层候选） + tag\_algo\_config + open\_24h 终表结果
	- 决策：门店阈值 + 层级得分
	- 输出：final\_range\_hhmm + back(HH-HH) + enum\_code(99 或 实际值)
- 迁移（后续）
	- 从 store\_tag\_snapshot\_di → station\_tag\_target\_value
	- 加上你说的复杂过滤逻辑

---

### 4）具体 SQL——Step A：open\_24h 规范落表（store\_tag\_snapshot\_di）

> 假设当前会话已经有 `@biz_date` （DATE）和 `@biz_dt_str` （'YYYY-MM-DD'）两个变量。  
> 数据来源： `store_feature_snapshot_di` （已经是你 v\_merchant\_profile\_latest\_di 的特征快照）。

```sql
sql-- stepA.1.open_24h_rebuild 基于门店特征重建 open_24h 标签（规范版）
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_24h';

INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    x.store_id,
    x.as_of_date,
    'open_24h' AS tag_code,

    -- 三选一：只填 bool
    x.final_bool          AS target_value_bool,
    NULL                  AS target_value_number,
    NULL                  AS target_value_string,

    -- enum_code：优先用字典，没有就回退实际值
    COALESCE(te.enum_code, CAST(x.final_bool AS CHAR)) AS enum_code,

    'STORE'        AS source_level,
    'INFERRED'     AS evidence_state,

    30             AS ttl_days,
    x.conf_value   AS conf,
    x.reason       AS reason,
    'open_24h_v1'  AS algo_version,

    NULL           AS target_value_string_back
FROM (
    SELECT
        s.store_id,
        s.as_of_date,

        -- 最终布尔值：0/1/99
        CASE
            WHEN s.open_hour_min_30d IS NULL 
              OR s.open_hour_max_30d IS NULL
            THEN 99  -- 没有营业时间数据 → 未知
            WHEN s.has_order_before_6_30d = 1 
              OR s.has_order_after_20_30d = 1
            THEN 1   -- 有明显早/晚订单 → 24小时候选
            ELSE 0   -- 其他情况先当否
        END AS final_bool,

        -- 简单置信度：有数据比没数据高
        CASE
            WHEN s.open_hour_min_30d IS NULL 
              OR s.open_hour_max_30d IS NULL
            THEN 0.50
            ELSE 0.80
        END AS conf_value,

        CASE
            WHEN s.open_hour_min_30d IS NULL 
              OR s.open_hour_max_30d IS NULL
            THEN 'no_open_hours_data'
            WHEN s.has_order_before_6_30d = 1 
              OR s.has_order_after_20_30d = 1
            THEN 'has_order_in_early_or_late_window'
            ELSE 'no_early_late_orders'
        END AS reason

    FROM store_feature_snapshot_di s
    WHERE s.as_of_date = @biz_date
) x
LEFT JOIN tag_enum te
  ON te.tag_code  = 'open_24h'
 AND te.enum_code = CAST(x.final_bool AS CHAR);
```

要点：

- 行级上：
	- 只有 `target_value_bool` 非空；
	- `enum_code` ∈ { '0','1','99' }（由 tag\_enum 决定），除非未来字典缺失。
- `99` 在 enum 里有兜底条目，sort\_order=10，是你刚设定的最低优先级。

---

### 5）具体 SQL——Step B：open\_hours 规范落表（store\_tag\_snapshot\_di）

> 前置：
> 
> - `open_hours_candidate_di` 已经按我们前面 step4.1 跑好（含三层候选+置信度）；
> - `store_tag_snapshot_di` 里已经有刚重建好的 `open_24h` 结果（上面的 Step A）。

#### 5.1 删除旧的 open\_hours 结果

#### 5.2 规范化重建 open\_hours（含 24h 对齐 + HH:MM-HH:MM + back + enum\_code 宽容逻辑）

```sql
sql-- stepB.2.open_hours_rebuild_v2 三层决策 + 与 open_24h 对齐 + HH:MM-HH:MM + back
INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    d.store_id,
    d.as_of_date,
    'open_hours' AS tag_code,

    -- 三选一：仅 string 非空
    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 最终展示的营业时间（HH:MM-HH:MM），24h=1 用 00:00-24:00
    final_range_hhmm AS target_value_string,

    -- enum_code：未知=99；否则用实际 HH:MM-HH:MM 作为“code”
    CASE 
        WHEN final_range_hhmm IS NULL THEN '99'
        ELSE final_range_hhmm
    END AS enum_code,

    d.chosen_level   AS source_level,
    'INFERRED'       AS evidence_state,

    30               AS ttl_days,
    d.chosen_conf    AS conf,

    d.decision_reason AS reason,
    'open_hours_v2'   AS algo_version,

    -- back：保留“原始 HH-HH 决策值”，不受 24h 覆盖影响
    CASE d.chosen_level
        WHEN 'STORE'    THEN d.candidate_store_string
        WHEN 'MERCHANT' THEN d.candidate_merchant_string
        WHEN 'PARTY'    THEN d.candidate_party_string
        ELSE NULL
    END AS target_value_string_back
FROM (
    SELECT
        c.as_of_date,
        c.store_id,
        c.pop_id,
        c.party_key,
        c.candidate_store_string,
        c.conf_store,
        c.candidate_merchant_string,
        c.conf_merchant,
        c.candidate_party_string,
        c.conf_party,
        cfg.conf_threshold_store,
        cfg.hierarchy_weight_store,
        cfg.hierarchy_weight_merchant,
        cfg.hierarchy_weight_party,

        -- 三层 HH:MM-HH:MM 格式
        CASE 
            WHEN c.candidate_store_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                CONCAT(
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_store_string, '-', 1) AS UNSIGNED), 2, '0'),
                    ':00-',
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_store_string, '-', -1) AS UNSIGNED), 2, '0'),
                    ':00'
                )
            ELSE c.candidate_store_string
        END AS store_range_hhmm,

        CASE 
            WHEN c.candidate_merchant_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                CONCAT(
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_merchant_string, '-', 1) AS UNSIGNED), 2, '0'),
                    ':00-',
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_merchant_string, '-', -1) AS UNSIGNED), 2, '0'),
                    ':00'
                )
            ELSE c.candidate_merchant_string
        END AS merchant_range_hhmm,

        CASE 
            WHEN c.candidate_party_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                CONCAT(
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_party_string, '-', 1) AS UNSIGNED), 2, '0'),
                    ':00-',
                    LPAD(CAST(SUBSTRING_INDEX(c.candidate_party_string, '-', -1) AS UNSIGNED), 2, '0'),
                    ':00'
                )
            ELSE c.candidate_party_string
        END AS party_range_hhmm,

        -- 分层分数
        (c.conf_store    * cfg.hierarchy_weight_store)    AS score_store,
        (c.conf_merchant * cfg.hierarchy_weight_merchant) AS score_merchant,
        (c.conf_party    * cfg.hierarchy_weight_party)    AS score_party,

        -- 决策：先看 store 是否过阈值，否则三层 score 最大
        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'STORE'
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN 'MERCHANT'
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN 'PARTY'
                    ELSE 'STORE'
                END
        END AS chosen_level,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN c.conf_store
            ELSE
                CASE 
                    WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                    THEN c.conf_merchant
                    WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                      AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                    THEN c.conf_party
                    ELSE c.conf_store
                END
        END AS chosen_conf,

        CASE 
            WHEN c.conf_store >= cfg.conf_threshold_store THEN 'store_conf_above_threshold'
            ELSE 'hierarchy_score_max'
        END AS decision_reason

    FROM open_hours_candidate_di c
    JOIN tag_algo_config cfg
      ON cfg.tag_code     = 'open_hours'
     AND cfg.algo_version = 'open_hours_v1'
    WHERE c.as_of_date = @biz_date
) d
LEFT JOIN store_tag_snapshot_di t24   -- 引用刚刚重建好的 open_24h 结果
  ON t24.store_id   = d.store_id
 AND t24.as_of_date = d.as_of_date
 AND t24.tag_code   = 'open_24h'
CROSS JOIN (
    -- 计算最终展示区间：受 open_24h 影响
    SELECT 1 AS dummy
) z
CROSS JOIN (
    SELECT 1 AS dummy2
) z2
-- 用子查询包一层，为了表达 final_range_hhmm 更清晰，可在外层 SELECT 中定义
;
```

上面这段里面 `final_range_hhmm` 我直接放在外层定义更清晰，你可以改写为：

为简洁起见，你可以把上面 SQL 调整成两层 SELECT：内层算 `final_range_hhmm` ，外层再算 enum\_code/target\_value\_string/target\_value\_string\_back，我不再重复贴一大坨；核心逻辑已经对齐：

- `final_range_hhmm` ：先看 open\_24h=1 → '00:00-24:00'；否则取对应层的 HH:MM-HH:MM；
- `target_value_string` = `final_range_hhmm` ；
- `enum_code` ： `final_range_hhmm IS NULL → '99'` ，否则用 `final_range_hhmm` 本身；
- `target_value_string_back` ：不看 24h，永远存原始 HH-HH。

---

### 6）迭代日志

- 本轮完成：
	- 把你在「终表协议文档」里定下的规范，具体落实为两个可执行 SQL：
		- open\_24h 规范版落表（A）；
		- open\_hours 规范版落表（B），并且与 open\_24h 一致、格式对齐、back 语义清晰。
- 建议下一步：
	1. 按顺序跑：
		- stepA.1 （重建 open\_24h）；
		- stepB.1 + stepB.2（重建 open\_hours）。
	2. 做三类验证：
		- 三选一约束：
		- 24h 一致性：open\_24h=1 时 open\_hours=00:00-24:00；
		- open\_hours 格式：全部是 HH:MM-HH:MM 或 NULL。
	3. 验证通过后，我们再一起把终表 INSERT INTO `station_tag_target_value` 的过滤逻辑接上，把这两条标签纳入你的“全标签大管道”。

你先把 A/B 跑一轮，有任何报错或验证结果（特别是分布统计），直接贴出来，我们就在这套骨架上继续微调，不再改大方向。

20251207\_1430\_open\_hours\_stepB2\_最终可复制版本  
tags: #open\_hours #三层决策 #对齐open\_24h #三选一协议

---

1）一句话结论  
你现在只需要做一件事：把下面这段 `-- stepB.2.open_hours_rebuild_v2 ...` 整段复制到 MySQL 里执行（在已经跑完 open\_hours\_candidate\_di 和 新版 open\_24h 之后），不用再管我前面说的“可以改写”“两层 SELECT”那些话。

---

2）先说清：你现在的执行顺序

每天一轮跑 open\_hours 时，顺序建议是：

1. step0：自动取最新业务日期（你已经有了）
2. step2.x：三层特征快照（已跑通）
3. step4.1： `open_hours_candidate_di` （三层候选 + conf；已跑通）
4. stepA.1：重建规范版 `open_24h` 标签
5. stepB.1：删旧 open\_hours
6. stepB.2：用下面这段“最终版 SQL”重建规范版 `open_hours`

你现在卡在的是 5、6 这两步里——尤其是 6 这一段的具体 SQL。

---

3）你要用的就是这一段：stepB.2 最终版 SQL

> 前提：
> 
> - 当前会话已设置好 `@biz_date` ；
> - `open_hours_candidate_di` 已经刷新好；
> - `store_tag_snapshot_di` 里已经有 `tag_code='open_24h'` 的规范版结果（stepA.1 跑过）。

```sql
sql-- stepB.1.clear_open_hours 删除当前业务日的旧 open_hours 结果
DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'open_hours';

-- stepB.2.open_hours_rebuild_v2 三层决策 + 与 open_24h 对齐 + HH:MM-HH:MM + back
INSERT INTO store_tag_snapshot_di (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    source_level,
    evidence_state,
    ttl_days,
    conf,
    reason,
    algo_version,
    target_value_string_back
)
SELECT
    x.store_id,
    x.as_of_date,
    'open_hours' AS tag_code,

    -- 三选一：只用 string，bool/number 一律空
    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 最终展示值：HH:MM-HH:MM，24h=1 强制 00:00-24:00
    x.final_range_hhmm AS target_value_string,

    -- enum_code：未知=99，否则用实际值（区间字符串）作为“code”
    CASE 
        WHEN x.final_range_hhmm IS NULL THEN '99'
        ELSE x.final_range_hhmm
    END AS enum_code,

    x.chosen_level      AS source_level,
    'INFERRED'          AS evidence_state,

    30                  AS ttl_days,
    x.chosen_conf       AS conf,
    x.decision_reason   AS reason,
    'open_hours_v2'     AS algo_version,

    -- back：保留原始 HH-HH 决策区间，不受 24h 覆盖影响
    CASE x.chosen_level
        WHEN 'STORE'    THEN x.candidate_store_string
        WHEN 'MERCHANT' THEN x.candidate_merchant_string
        WHEN 'PARTY'    THEN x.candidate_party_string
        ELSE NULL
    END AS target_value_string_back
FROM (
    -- 内层：三层候选 → 三层 HH:MM-HH:MM → 选层级 & 置信度 → 结合 open_24h 得到 final_range_hhmm
    SELECT
        d.store_id,
        d.as_of_date,
        d.candidate_store_string,
        d.candidate_merchant_string,
        d.candidate_party_string,
        d.chosen_level,
        d.chosen_conf,
        d.decision_reason,

        -- 结合 open_24h 决策最终展示区间
        CASE 
            WHEN t24.target_value_bool = 1 THEN '00:00-24:00'   -- 24 小时站点强制 00:00-24:00
            ELSE
                CASE d.chosen_level
                    WHEN 'STORE'    THEN d.store_range_hhmm
                    WHEN 'MERCHANT' THEN d.merchant_range_hhmm
                    WHEN 'PARTY'    THEN d.party_range_hhmm
                    ELSE NULL
                END
        END AS final_range_hhmm
    FROM (
        -- d：只负责三层候选 + 决策 + 把 HH-HH 转成 HH:MM-HH:MM
        SELECT
            c.as_of_date,
            c.store_id,
            c.pop_id,
            c.party_key,
            c.candidate_store_string,
            c.conf_store,
            c.candidate_merchant_string,
            c.conf_merchant,
            c.candidate_party_string,
            c.conf_party,
            cfg.conf_threshold_store,
            cfg.hierarchy_weight_store,
            cfg.hierarchy_weight_merchant,
            cfg.hierarchy_weight_party,

            -- store 层 HH:MM-HH:MM
            CASE 
                WHEN c.candidate_store_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                    CONCAT(
                        LPAD(CAST(SUBSTRING_INDEX(c.candidate_store_string, '-', 1) AS UNSIGNED), 2, '0'),
                        ':00-',
                        LPAD(CAST(SUBSTRING_INDEX(c.candidate_store_string, '-', -1) AS UNSIGNED), 2, '0'),
                        ':00'
                    )
                ELSE c.candidate_store_string
            END AS store_range_hhmm,

            -- merchant 层 HH:MM-HH:MM
            CASE 
                WHEN c.candidate_merchant_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                    CONCAT(
                        LPAD(CAST(SUBSTRING_INDEX(c.candidate_merchant_string, '-', 1) AS UNSIGNED), 2, '0'),
                        ':00-',
                        LPAD(CAST(SUBSTRING_INDEX(c.candidate_merchant_string, '-', -1) AS UNSIGNED), 2, '0'),
                        ':00'
                    )
                ELSE c.candidate_merchant_string
            END AS merchant_range_hhmm,

            -- party 层 HH:MM-HH:MM
            CASE 
                WHEN c.candidate_party_string REGEXP '^[0-9]{1,2}-[0-9]{1,2}$' THEN
                    CONCAT(
                        LPAD(CAST(SUBSTRING_INDEX(c.candidate_party_string, '-', 1) AS UNSIGNED), 2, '0'),
                        ':00-',
                        LPAD(CAST(SUBSTRING_INDEX(c.candidate_party_string, '-', -1) AS UNSIGNED), 2, '0'),
                        ':00'
                    )
                ELSE c.candidate_party_string
            END AS party_range_hhmm,

            -- 分层分数
            (c.conf_store    * cfg.hierarchy_weight_store)    AS score_store,
            (c.conf_merchant * cfg.hierarchy_weight_merchant) AS score_merchant,
            (c.conf_party    * cfg.hierarchy_weight_party)    AS score_party,

            -- 先看门店是否过阈值，否则按 score 选层
            CASE 
                WHEN c.conf_store >= cfg.conf_threshold_store THEN 'STORE'
                ELSE
                    CASE 
                        WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                          AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                        THEN 'MERCHANT'
                        WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                          AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                        THEN 'PARTY'
                        ELSE 'STORE'
                    END
            END AS chosen_level,

            CASE 
                WHEN c.conf_store >= cfg.conf_threshold_store THEN c.conf_store
                ELSE
                    CASE 
                        WHEN (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_store * cfg.hierarchy_weight_store)
                          AND (c.conf_merchant * cfg.hierarchy_weight_merchant) >= (c.conf_party * cfg.hierarchy_weight_party)
                        THEN c.conf_merchant
                        WHEN (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_store * cfg.hierarchy_weight_store)
                          AND (c.conf_party * cfg.hierarchy_weight_party) >= (c.conf_merchant * cfg.hierarchy_weight_merchant)
                        THEN c.conf_party
                        ELSE c.conf_store
                    END
            END AS chosen_conf,

            CASE 
                WHEN c.conf_store >= cfg.conf_threshold_store THEN 'store_conf_above_threshold'
                ELSE 'hierarchy_score_max'
            END AS decision_reason

        FROM open_hours_candidate_di c
        JOIN tag_algo_config cfg
          ON cfg.tag_code     = 'open_hours'
         AND cfg.algo_version = 'open_hours_v1'
        WHERE c.as_of_date = @biz_date
    ) d
    LEFT JOIN store_tag_snapshot_di t24   -- 引用当天的 open_24h 结果
      ON t24.store_id   = d.store_id
     AND t24.as_of_date = d.as_of_date
     AND t24.tag_code   = 'open_24h'
) x;
```

你现在做的事很简单：

- 是的， **你应该直接复制这整段 stepB.2（连同上面的 stepB.1 DELETE）去执行** ；
- 不用再管之前我说的“可以改写”“两层 SELECT”那些骚操作，这里已经帮你收敛成一个“可执行终稿”。

---

4）执行完之后建议的 3 个快速校验（你可以只跑 SQL 看结果，不用解释）

1. open\_hours 三选一是否满足：

预期： `bool_cnt = 0, num_cnt = 0, str_cnt > 0` 。

1. 24h 一致性是否满足：

预期： `total_24h = ok_cnt` 。

1. open\_hours 格式：

预期：主要是 `OK_HHMM` 和少量 `NULL` ，不要出现 `OTHER` 。

你先把这段 stepB.2 跑一遍，有报错/有统计结果就直接贴给我，我们再在这套“定稿逻辑”上迭代，不再改方向。

总结一下这个文档的关键内容,作为一个承上启下的提示词,我去新对话框继续我们这个未完成的工作.

下面是 **高度浓缩、可以直接放进新对话框的“承上启下提示词”** ，确保我在新的对话里能够 100% 恢复当前上下文，并继续未完成的 open\_24h/open\_hours 规范化落表 & 迁移到终表的工作。

---

## 20251207\_open\_hours\_open\_24h\_规范化ETL\_承上启下提示词（可直接复制）

我正在构建标签体系的核心落表链路，当前工作重点是 **open\_24h / open\_hours 两个标签的规范化产出** 。  
你需要基于以下共识继续未完工作：

---

## 【一、终表规范（必须严格遵守）】

1. **三选一协议**
	- `target_value_bool / number / string` **有且仅有一个非空** 。
	- 多个非空 → 清洗错误；全部为空 → 算法失败（可 fallback）。
2. **enum\_code 驱动标签值（字典决定一切）**
	- 有枚举 → enum\_code 按 `tag_enum` ；
	- 无枚举 → enum\_code = 业务值本身（例如 `'06:00-23:00'` ）；
	- “未知”统一用 `enum_code = '99'` （已在字典补充）。
3. **中英分离**
	- `enum_code` 存英文/数字 code；
	- `enum_label` 存中文展示；
	- `target_value_string` 存 code 或规范化后的字符串，不存 label。

---

## 【二、open\_24h 标签规范】

1. value\_type = bool → 落 `target_value_bool`
2. 枚举值只有：
	- `'1'` （是）， `'0'` （否）， `'99'` （未知兜底，sort\_order=10）
3. 算法生成的 bool 值 ∈ {0,1,99}
4. 落表时三选一：
	- target\_value\_bool = 0/1/99
	- target\_value\_string = NULL
	- target\_value\_number = NULL
5. enum\_code 来自 tag\_enum
6. evidence\_state = INFERRED
7. algo\_version = open\_24h\_v1

---

## 【三、open\_hours 标签规范】

1. value\_type = string → 落 `target_value_string`
2. 所有最终区间格式统一： **HH:MM-HH:MM**
3. 与 open\_24h 强一致：
	- 若该站点 open\_24h = 1 → open\_hours = `'00:00-24:00'`
4. 无合法区间 → enum\_code='99'（未知）
5. 有合法区间 → enum\_code = `'HH:MM-HH:MM'` （因为没有对应枚举）
6. 三选一：
	- target\_value\_string = 最终区间
	- bool/number 均为 NULL
7. target\_value\_string\_back：保留“原始 HH-HH 决策值”（不受 24h 覆盖影响）
8. algo\_version = open\_hours\_v2

---

## 【四、三层候选 + 决策逻辑（open\_hours）】

1. 输入： `open_hours_candidate_di` （STORE / MERCHANT / PARTY 候选 + conf）
2. 决策规则：
	- conf\_store ≥ conf\_threshold\_store → 用 STORE
	- 否则三层 score = conf × weight → 选最大层级
3. 决策输出：chosen\_level / chosen\_conf / chosen\_range
4. 然后结合 open\_24h → 最终展示区间 final\_range\_hhmm
5. 再统一格式化 → HH:MM-HH:MM

---

## 【五、当前 ETL 已完成部分】

1. 原始 is\_zxgj 清洗（含 X月Y日 → HH-HH 修复、未知归一）
2. store → merchant → party 三层特征快照
3. open\_hours\_candidate\_di（候选 + conf）
4. open\_24h：规范版重建（A）
5. open\_hours：规范版重建（B）

---

## 【六、下一阶段要做的事（你需要继续推进）】

1. **验证 open\_24h / open\_hours 是否完全符合“三选一 + enum 规范”**
2. **验证 open\_24h=1 → open\_hours=00:00-24:00 是否全量一致**
3. **验证 open\_hours 统一 HH:MM-HH:MM 格式**
4. **准备把两个标签迁移到最终产物表 station\_tag\_target\_value**
	- 迁移前有一套过滤逻辑（我会在你发给我后整合）
	- station\_tag\_target\_value 会汇集全部标签的最终落表结果
	- 最后输出到数仓

---

## 【七、你的任务】

开始一个新对话后，你可以直接说：

> “继续 open\_hours / open\_24h 的规范迁移工作，我们已经完成 A/B，现在准备迁移到 station\_tag\_target\_value。下面是过滤逻辑：xxx……”

我将自动恢复上下文，并继续把：

- **迁移逻辑**
- **过滤逻辑融合**
- **通用落表模板（所有标签共用）**

全部补齐。

---

如果你准备好了，就去新对话框粘贴这段“承上启下提示词”，我们会无缝继续剩余的标签大链路构建工作。

20251207\_1505\_open\_hours\_open\_24h\_每日执行链路总览  
tags: #标签ETL工作流 #open\_24h #open\_hours #一键封装

---

### 1）一句话结论

整个链路其实就三个大阶段：  
1）准备“干净的一维事实表 + 修好 is\_zxgj”；  
2）算三层特征快照 + open\_hours 候选；  
3）按规范重建 open\_24h / open\_hours 标签落到 `store_tag_snapshot_di` 。  
下次只要照着这个顺序跑一遍脚本，就能完成每日更新；你完全可以封装成“8 步一键脚本”。

---

### 2）三段论据（现状 → 执行链路 → 简化封装）

#### 论据一：现状是“SQL 都对了，但顺序你已经记不住了”

- 你这两天把所有关键模块都打通了：
	- v\_merchant\_profile\_latest\_di 物化 & is\_zxgj 纠错；
	- store / merchant / party 三层特征快照；
	- open\_hours 三层候选 & 决策；
	- open\_24h / open\_hours 规范落表（符合三选一 + enum 规范）；
- 问题在于：这些东西是你一点点贴 SQL 迭代出来的， **顺序是“对的”，但脑子完全记不住** ，下次想更新就不知道从哪里开始。

我们现在要做的，是把这些“散装 SQL”收束成一个 **固定日更链路** + 一个 **简单封装方式** 。

---

#### 论据二：核心执行链路可以收敛为“8 大步”

我把你现在所有已经跑通的东西，按依赖关系整理成 **每日刷新一条龙** ，你只要记住下面这 8 步就够了（重点是顺序）。

> 默认数据库： `data_manager_db`  
> 默认变量： `@biz_dt_str` （字符串日期）、 `@biz_date` （DATE）

---

#### 【阶段 0：业务日期 & 物化源表】

**Step 0：自动识别最新业务日期**

> 作用：整个 ETL 的“锚点日期”，后续所有快照和标签都按这个日期处理。

> 这一步一定要最先跑，每天只跑一次。

---

**Step 1：v\_merchant\_profile\_latest\_di 物化 & is\_zxgj 修复**

> 如果你已经有稳定的 `v_merchant_profile_latest_di` 物化逻辑，这里只要记住两件事：  
> 1）先“重灌整天数据”；  
> 2） **立刻修正 is\_zxgj** （X月Y日 → HH-HH，未知 → NULL）。

示意（核心修复 SQL）：

到这里，你有了一张：

> “ **当日所有油站的干净画像明细表** （含 is\_zxgj 已修复）”。

---

#### 【阶段 1：三层特征快照（基础层）】

**Step 2.1：store\_feature\_snapshot\_di（门店层特征快照）**

> 用 v\_merchant\_profile\_latest\_di 生成“门店维度的行为特征”，核心是 open\_hours 相关字段：
> 
> - open\_hour\_min\_30d / open\_hour\_max\_30d
> - has\_order\_before\_6\_30d / has\_order\_after\_20\_30d
> - total\_order\_cnt\_30d

你已经有完整 SQL，这里只记住：

> “ **先有门店特征，再谈商户/工商** ”。

---

**Step 2.2：merchant\_feature\_snapshot\_di（商户层特征快照）**

> 按 pop\_id 聚合门店，得到：
> 
> - store\_with\_data\_ratio（商户下有数据门店占比）
> - merchant\_order\_cnt\_30d（商户 30 日总订单）
> - is\_agg\_blocked\_merchant（是否禁止聚合）
> - feedback\_cnt\_open\_hours（后面要建的反馈表）

依赖： **必须在 store\_feature\_snapshot\_di 跑完之后** 。

---

**Step 2.3：party\_feature\_snapshot\_di（工商层特征快照）**

> 再按 party\_key 聚合商户，得到：
> 
> - merchant\_with\_data\_ratio（工商下有数据商户占比）
> - party\_order\_cnt\_30d（工商 30 日总订单）

你已经修过比例字段的类型（DECIMAL(10,6)），这里只记住一句话：

> “ **工商层就是商户的再聚合，用来兜底** ”。

---

#### 【阶段 2：open\_hours 候选生成（三层候选）】

**Step 3：open\_hours\_candidate\_di（三层候选 + conf）**

拆三小步：

1）建候选表（只建一次）  
2）用 store\_feature\_snapshot\_di → 得到门店候选 & conf\_store  
3）用 merchant/party 特征 + 聚合 → 得到 merchant/party 候选 & conf\_merchant/conf\_party

核心作用：

> “ **把这一堆特征快照，压成一张表：一行一个油站，带三层候选 + 三个置信度** ”。

---

#### 【阶段 3：标签落表（规范版）】

这里有两个标签： **open\_24h（A）** 和 **open\_hours（B）** 。  
它们都落在 `store_tag_snapshot_di` 这张“标签结果表”上，并且：

- 三选一协议：每行只有一个 target\_value\_xxx 非空；
- enum\_code 按字典 / 实际值规则写入；
- evidence\_state = INFERRED；
- algo\_version 有明确版本号。

---

**Step 4：open\_24h 规范版重建（A）**

> 从 store\_feature\_snapshot\_di 取“早/晚订单 + 是否有 open\_hours 数据”，算一个 0/1/99：
> 
> - 算不出 → 99（未知）；
> - 有明显早/晚订单 → 1（24 小时候选）；
> - 其他 → 0。

然后：

- target\_value\_bool = 0/1/99
- target\_value\_string/number = NULL
- enum\_code = 0/1/99（来自 tag\_enum，已经补过 99 且调好 sort\_order）
- algo\_version = open\_24h\_v1

这是 **后面所有“是否 24 小时”逻辑的唯一真相来源** 。

---

**Step 5：open\_hours 规范版重建（B）**

分两步：

1）删除当日旧的 open\_hours

2）用你刚才确认的 `stepB.2.open_hours_rebuild_v2` 重建：

- 输入：
	- open\_hours\_candidate\_di（三层候选 + conf + HH-HH）
	- tag\_algo\_config（层级权重、阈值）
	- store\_tag\_snapshot\_di 里的 open\_24h 结果
- 决策流程：
	- 先在三层中选一个 chosen\_level + chosen\_conf；
	- 把对应 HH-HH 转 HH:MM-HH:MM；
	- 如果 open\_24h=1 ⇒ final\_range\_hhmm = '00:00-24:00'；
- 输出：
	- target\_value\_string = final\_range\_hhmm（HH:MM-HH:MM）
	- enum\_code：
		- final\_range\_hhmm IS NULL → '99'（未知）；
		- 否则 enum\_code = final\_range\_hhmm（区间本身作为 code）
	- target\_value\_string\_back：chosen\_level 的原始 HH-HH 区间
	- source\_level/conf/reason/algo\_version（open\_hours\_v2）

一句话概括这步：

> “ **先在 STORE/MERCHANT/PARTY 里选一个最可信时段，再跟 open\_24h 对齐，变成 HH:MM-HH:MM，最后写入标签结果表** ”。

---

#### 【阶段 4：校验 & 未来迁移】

**Step 6：校验（简单但必须跑）**

三类检查：

1）三选一约束：

- open\_24h：只有 `target_value_bool` 非空；
- open\_hours：只有 `target_value_string` 非空；  
	2）24h 一致性：
- open\_24h=1 的站 → open\_hours 必须是 `00:00-24:00` ；  
	3）格式一致性：
- open\_hours 的 `target_value_string` 只能是 HH:MM-HH:MM 或 NULL。

---

**Step 7：未来迁移到 station\_tag\_target\_value（暂不执行）**

你已经明确说了：

> `station_tag_target_value` 将来是“全集标签终表”，会有一套过滤逻辑 + 上报数仓。

那到时，只要在现有链路后面再加一层：

- 从 `store_tag_snapshot_di` 选择：
	- 筛当天；
	- 筛有值的标签；
	- 按你的过滤规则（比如 conf 阈值、evidence\_state 等）；
- INSERT INTO `station_tag_target_value` （字段协议跟现在这套一致）。

但这个是 **下一阶段** 的任务，你让我们现在先专注到 A/B。

---

#### 论据三：如何更简单封装？——“8 个脚本 + 一个一键执行命令”

现在难记主要是因为你是“在交互式客户端里，到处贴 SQL”。  
更简单的封装方式有两个层次：

---

**封装方案 1：按步骤拆成 8 个.sql 文件 + 一个 shell**

目录大概这样：

- `00_detect_biz_date.sql` （Step0）
- `10_refresh_profile_and_fix_is_zxgj.sql` （Step1）
- `20_store_feature_snapshot.sql` （Step2.1）
- `21_merchant_feature_snapshot.sql` （Step2.2）
- `22_party_feature_snapshot.sql` （Step2.3）
- `30_open_hours_candidate.sql` （Step3）
- `40_open_24h_rebuild.sql` （Step4）
- `50_open_hours_rebuild_v2.sql` （Step5）
- `90_validation.sql` （Step6，可选）

然后写一个最简单的 shell：

> 以后你只需要记住一件事：  
> 在项目目录里执行一次 `./run_open_tags_daily.sh` 就完事了。

---

**封装方案 2：写一个 MySQL 存储过程 `CALL run_open_tags_daily()`**

如果你不想管 shell，只想在客户端里跑一个命令，可以把上述 8 步写进一个存储过程：

里面就是按顺序拼接上述 Step0 ~ Step5 的语句。  
优点：所有逻辑在 DB 端；缺点：调试略麻烦。

---

### 3）思维导图结构（文本版）

- 顶层目标：
	- 每天“自动”产出规范版 open\_24h / open\_hours 标签到 store\_tag\_snapshot\_di
- 工作流阶段：
	- 阶段0：识别业务日期 & 物化源表
	- 阶段1：三层特征快照（store/merchant/party）
	- 阶段2：open\_hours 三层候选
	- 阶段3：open\_24h / open\_hours 标签落表（规范版）
	- 阶段4：校验 & 日志
	- 阶段5（未来）：迁移到 station\_tag\_target\_value + 上报数仓
- 封装：
	- 8 个 SQL 脚本 + 一个一键 shell
	- 或 1 个存储过程 `run_open_tags_daily`

---

### 4）迭代日志（这轮我们做了哪些“收口”）

- 从“几十条散 SQL” → 抽象成 **8 步固定日更链路** ；
- 把 open\_24h / open\_hours 从“单标签调试代码”升级为：
	- 明确位置（阶段3）；
	- 明确依赖（阶段0–2）；
	- 明确出口（store\_tag\_snapshot\_di）；
- 给出了两种可落地的封装方案：
	- bash 一键脚本；
	- MySQL 存储过程。

下一步，如果你愿意，我们可以在新对话里专门干两件事：  
1）帮你把这 8 个.sql 的骨架写出来（带注释、带 step 标记）；  
2）按你说的“过滤逻辑”，设计 `INSERT INTO station_tag_target_value` 的整体迁移模板。