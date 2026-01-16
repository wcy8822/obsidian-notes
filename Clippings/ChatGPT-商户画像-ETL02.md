---
title: ChatGPT
source: https://chatgpt.com/g/g-p-692abef2079c81918c16c22b66aec849-shang-hu-hua-xiang/c/6934165a-17b0-8320-adf7-82cb0e43d6ca
author:
  - "[[ChatGPT-非油品-2期BRD草稿]]"
published:
created: 2025-12-23
description: ChatGPT 是一款供日常使用的 AI 聊天机器人。与最先进的 AI 模型互动，探索创意、解决问题以及提升学习效率。
tags:
  - clippings
---
下面是\*\*高度浓缩、可以直接放进新对话框的“承上启下提示词”\*\*，确保我在新的对话里能够 100% 恢复当前上下文，并继续未完成的 open\_24h/open\_hours 规范化落表 & 迁移到终表的工作。 --- # 20251207\_open\_hours\_open\_24h\_规范化ETL\_承上启下提示词（可直接复制） 我正在构建标签体系的核心落表链路，当前工作重点是 \*\*open\_24h / open\_hours 两个标签的规范化产出\*\*。 你需要基于以下共识继续未完工作： --- ## 【一、终表规范（必须严格遵守）】 1. \*\*三选一协议\*\* \* `target_value_bool / number / string` \*\*有且仅有一个非空\*\*。 \* 多个非空 → 清洗错误；全部为空 → 算法失败（可 fallback）。 2. \*\*enum\_code 驱动标签值（字典决定一切）\*\* \* 有枚举 → enum\_code 按 `tag_enum` ； \* 无枚举 → enum\_code = 业务值本身（例如 `'06:00-23:00'` ）； \* “未知”统一用 `enum_code = '99'` （已在字典补充）。 3. \*\*中英分离\*\* \* `enum_code` 存英文/数字 code； \* `enum_label` 存中文展示； \* `target_value_string` 存 code 或规范化后的字符串，不存 label。 --- ## 【二、open\_24h 标签规范】 1. value\_type = bool → 落 `target_value_bool` 2. 枚举值只有： \* `'1'` （是）， `'0'` （否）， `'99'` （未知兜底，sort\_order=10） 3. 算法生成的 bool 值 ∈ {0,1,99} 4. 落表时三选一： \* target\_value\_bool = 0/1/99 \* target\_value\_string = NULL \* target\_value\_number = NULL 5. enum\_code 来自 tag\_enum 6. evidence\_state = INFERRED 7. algo\_version = open\_24h\_v1 --- ## 【三、open\_hours 标签规范】 1. value\_type = string → 落 `target_value_string` 2. 所有最终区间格式统一：\*\*HH:MM-HH:MM\*\* 3. 与 open\_24h 强一致： \* 若该站点 open\_24h = 1 → open\_hours = `'00:00-24:00'` 4. 无合法区间 → enum\_code='99'（未知） 5. 有合法区间 → enum\_code = `'HH:MM-HH:MM'` （因为没有对应枚举） 6. 三选一： \* target\_value\_string = 最终区间 \* bool/number 均为 NULL 7. target\_value\_string\_back：保留“原始 HH-HH 决策值”（不受 24h 覆盖影响） 8. algo\_version = open\_hours\_v2 --- ## 【四、三层候选 + 决策逻辑（open\_hours）】 1. 输入： `open_hours_candidate_di` （STORE / MERCHANT / PARTY 候选 + conf） 2. 决策规则： \* conf\_store ≥ conf\_threshold\_store → 用 STORE \* 否则三层 score = conf × weight → 选最大层级 3. 决策输出：chosen\_level / chosen\_conf / chosen\_range 4. 然后结合 open\_24h → 最终展示区间 final\_range\_hhmm 5. 再统一格式化 → HH:MM-HH:MM --- ## 【五、当前 ETL 已完成部分】 1. 原始 is\_zxgj 清洗（含 X月Y日 → HH-HH 修复、未知归一） 2. store → merchant → party 三层特征快照 3. open\_hours\_candidate\_di（候选 + conf） 4. open\_24h：规范版重建（A） 5. open\_hours：规范版重建（B） --- ## 【六、下一阶段要做的事（你需要继续推进）】 1. \*\*验证 open\_24h / open\_hours 是否完全符合“三选一 + enum 规范”\*\* 2. \*\*验证 open\_24h=1 → open\_hours=00:00-24:00 是否全量一致\*\* 3. \*\*验证 open\_hours 统一 HH:MM-HH:MM 格式\*\* 4. \*\*准备把两个标签迁移到最终产物表 station\_tag\_target\_value\*\* \* 迁移前有一套过滤逻辑（我会在你发给我后整合） \* station\_tag\_target\_value 会汇集全部标签的最终落表结果 \* 最后输出到数仓 --- ## 【七、你的任务】 开始一个新对话后，你可以直接说： > “继续 open\_hours / open\_24h 的规范迁移工作，我们已经完成 A/B，现在准备迁移到 station\_tag\_target\_value。下面是过滤逻辑：\[✓ value\_has\_meaning = 1 (结果有实际意义) ✓ is\_wrong\_cleaning = 0 (不是错误清洗,错误清洗是原值有意义,清洗成无意义) ✓ is\_same\_as\_source = 0 (和原始值不同，确实完成纠偏) ✓ is\_fallback\_value = 0 (不是兜底默认值)\]” 我将自动恢复上下文，并继续把： \* \*\*迁移逻辑\*\* \* \*\*过滤逻辑融合\*\* \* \*\*通用落表模板（所有标签共用）\*\* 全部补齐。 ---

20251206\_2105\_open\_hours\_open\_24h\_承上启下提示词校验版  
tags：#商户画像ETL #标签规范化 #open\_hours #open\_24h #终表落表

---

**1）一句话结论**

你这版「承上启下提示词」已经足够完整，可以直接复制到新对话作为上下文恢复入口，用来继续推进 open\_24h / open\_hours 规范化落表与迁移 station\_tag\_target\_value 的工作。

---

**2）三段论据（现状与问题 → 关键洞察 → 路径方案）**

**论据一：现状与问题**

- 你已经完成 open\_24h / open\_hours 的重建 A/B 版本，以及三层候选、决策逻辑、与 24h 联动的一整套 ETL 思路，但当前对话太长、不利于在新会话中「秒级恢复上下文」继续做迁移与校验工作。
- 终表 station\_tag\_target\_value 已经确定了一套统一规范（“三选一协议”、enum\_code 驱动、一表收敛所有标签），但实际对 open\_24h / open\_hours 是否 100% 对齐规范、过滤逻辑如何嵌入迁移链路，仍需要在新对话中进一步落地。

**论据二：关键洞察**

- 你这份提示词已经把「终表规范」「两标签定义」「三层候选决策」「当前已完工范围」「下一步要做什么」全部串起来，相当于把这条链路的「设计文档摘要」打包成一页提示词。
- 对于任何一个新对话的模型来说，这个结构足够把关键假设拉齐：
	- 终表字段语义 & 三选一约束；
	- enum\_code / enum\_label / target\_value\_\* 的职责边界；
	- open\_24h / open\_hours 的强一致关系和格式统一要求；
	- 已完成的 ETL 环节和下一步只剩「校验 + 迁移 + 通用模板」。

**论据三：路径方案**

- 在新对话中，你只需要先贴这段提示词，然后补一句：「现在我们继续做：1）规范校验；2）迁移到 station\_tag\_target\_value；3）融合过滤逻辑，抽象通用落表模板」，即可直接进入执行态。
- 后续可以按你提示词中的「四步」推进：  
	1）写验证 SQL，逐项检查三选一 / 24h 强一致 / HH:MM-HH:MM 格式；  
	2）基于现有 A/B 产物，设计 INSERT INTO station\_tag\_target\_value 的迁移 SQL（只针对 open\_24h / open\_hours）；  
	3）把 value\_has\_meaning 等过滤条件嵌入迁移 SQL；  
	4）从这两个标签的迁移 SQL 抽象出「全标签可复用」的落表模板。

---

**3）思维导图结构（文本分层）**

- 1. 目标：承上启下提示词的定位
	- 1.1 在新对话中 100% 恢复 open\_24h / open\_hours 项目上下文
	- 1.2 让模型清楚：当前已完成 A/B 重建，下一步是「校验 + 迁移 + 抽象模板」
	- 1.3 绑定终表 station\_tag\_target\_value 的统一规范与过滤逻辑
- 1. 终表规范（统一约束）
	- 2.1 三选一协议
		- target\_value\_bool / number / string 有且仅有一个非空
		- 多个非空 = 清洗错误；全部为空 = 算法失败
	- 2.2 enum\_code 驱动标签值
		- 有枚举 → 按 tag\_enum
		- 无枚举 → enum\_code = 业务值本身
		- “未知”统一 enum\_code = '99'
	- 2.3 中英分离
		- enum\_code：英文/数字 code
		- enum\_label：中文展示
		- target\_value\_string：存 code 或规范化字符串，不存中文
- 1. open\_24h 定义与约束
	- 3.1 value\_type = bool → 落 target\_value\_bool
	- 3.2 枚举域：'1' / '0' / '99'（未知兜底）
	- 3.3 落表三选一：
		- target\_value\_bool = 0/1/99
		- string/number = NULL
	- 3.4 其他规范
		- enum\_code 来自 tag\_enum
		- evidence\_state = INFERRED
		- algo\_version = open\_24h\_v1
- 1. open\_hours 定义与约束
	- 4.1 value\_type = string → 落 target\_value\_string
	- 4.2 最终格式统一为 HH:MM-HH:MM
	- 4.3 与 open\_24h 强一致
		- 若 open\_24h = 1 → open\_hours = '00:00-24:00'
	- 4.4 enum\_code 规则
		- 有合法区间 → enum\_code = 'HH:MM-HH:MM'（无字典，用业务值）
		- 无合法区间 → enum\_code = '99'
	- 4.5 三选一：
		- target\_value\_string = 最终区间
		- bool/number = NULL
	- 4.6 其他规范
		- target\_value\_string\_back：保留原始 HH-HH 决策值
		- algo\_version = open\_hours\_v2
- 1. 三层候选 + 决策逻辑（open\_hours）
	- 5.1 输入：open\_hours\_candidate\_di
		- STORE / MERCHANT / PARTY 三层候选 + conf
	- 5.2 决策规则
		- 优先规则：conf\_store ≥ 阈值 → 用 STORE
		- 否则：score = conf × weight，三层取最大
	- 5.3 输出字段
		- chosen\_level / chosen\_conf / chosen\_range
	- 5.4 与 open\_24h 联动
		- 先决策出 chosen\_range
		- 再与 open\_24h 对齐成 final\_range\_hhmm
		- 统一标准化为 HH:MM-HH:MM
- 1. 已完成 ETL 链路
	- 6.1 原始 is\_zxgj 清洗（含 X月Y日 → HH-HH 修复、未知归一）
	- 6.2 store / merchant / party 三层特征快照
	- 6.3 open\_hours\_candidate\_di（三层候选 + conf）
	- 6.4 open\_24h 重建（A：规范版）
	- 6.5 open\_hours 重建（B：规范版，含三层决策）
- 1. 下一步待完成工作（在新对话中继续）
	- 7.1 规范校验
		- 三选一 + enum 规范
		- open\_24h=1 → open\_hours='00:00-24:00' 强一致
		- open\_hours 格式统一为 HH:MM-HH:MM
	- 7.2 迁移到 station\_tag\_target\_value
		- 以 open\_24h / open\_hours 为试点标签
		- 先做标签级别的 INSERT 逻辑
	- 7.3 过滤逻辑融合
		- value\_has\_meaning = 1
		- is\_wrong\_cleaning = 0
		- is\_same\_as\_source = 0
		- is\_fallback\_value = 0
	- 7.4 通用落表模板抽象
		- 把这两标签的迁移 SQL 抽象成「全局标签落表模板」
		- 用于后续所有标签汇聚到 station\_tag\_target\_value
- 1. 在新对话中的使用方式
	- 8.1 首句可以直接用你写的引导语：
		- 「继续 open\_hours / open\_24h 的规范迁移工作，我们已经完成 A/B，现在准备迁移到 station\_tag\_target\_value。下面是过滤逻辑：\[…\]」
	- 8.2 紧接着追加你的这整个承上启下提示词
	- 8.3 然后发「先从校验 SQL 开始」或「先写迁移 SQL」即可进入执行

---

**4）迭代日志**

- 来源：
	- 由你提供的《20251207\_open\_hours\_open\_24h\_规范化ETL\_承上启下提示词》原文整理与校验。
- 本轮结论：
	- 这份提示词在信息密度和结构上已经满足「新对话秒级恢复上下文」的要求；无需大改，可以直接作为标准开场模板使用。
- 本轮改动点 / 补充视角：
	- 帮你从「是否能用」的视角做了一次校验：确认终表规范、标签定义、已完成环节和下一步任务都说清楚了。
	- 用思维导图结构把这段提示词的隐含逻辑展开，方便你后续如果要做「更短摘要版」或「评审版一页纸」时，有骨架可用。
	- 明确了在新对话中的使用方式（先一句引导语 + 整段提示词 + 明确下一步动作）。
- 待补充 / 下一步建议：
	- 下一轮可以直接开新对话，贴上这段提示词，然后让模型从「1）规范校验 SQL」开始干活。
	- 等 open\_24h / open\_hours 的迁移 SQL 和通用模板跑通后，可以再整理一份「station\_tag\_target\_value 落表规范 v1.0」文档，把这套方法升级为全局标准。

申请一下我们核心目标是\[20251206\_1700\_商户画像标签ETL\_双90需求文档 tags: #商户画像 #标签ETL #营业时间 #特征快照 #双90 1）一句话结论 本需求文档将商户画像“标签双 90%（覆盖率 & 准确率）”目标，具体落成一条以 v\_merchant\_profile\_latest 为唯一上游入口、三层特征快照（门店/商户/工商）+ 通用候选 & 置信度模型 + 跨层决策器 + 审计日志的标签 ETL 机制，以 open\_hours/open\_24h 为打样模版，可扩展到所有 A 类标签，并附带 merchant\_feedback\_stats 与 tag\_algo\_config 的建表与使用规范。 2）三段论据（现状与问题 → 策略 → 落地与风险） 论据一：现状与问题——目标清晰，但缺“算法形态 + 工程骨架” 业务目标非常明确： 现有约 1.6 万动销油站、若干核心标签（品牌、服务、营业时间等），Q4 指标是标签覆盖率 & 准确率双双拉到 ≥ 90%。 数据与配置已经具备基础条件： 入口视图统一为 v\_merchant\_profile\_latest，已包含 store\_id / merchant\_id / party\_key / is\_zxgj(06-22) / order\_cnt\_30d(日均订单) / is\_agg\_blocked\_merchant 等关键字段。 标签字典（tag\_spec、tag\_enum、tag\_catalog 等）已经沉淀标签定义与分类（包括 tag\_class 区分线上纯计算/推断）。 当前缺口主要集中在： 没有统一的“特征 → 候选值 → 置信度 → 跨层决策 → 审计”的算法模版，每个标签都是散点脚本； 门店/商户/工商三层没有体系化治理逻辑（例如虚拟商户、日均订单聚合规则、跨层 override 红线等）； 阈值、策略配置无统一载体（调参成本高，不可回溯）。 论据二：策略选择与推演——构建统一三层特征 + 通用决策器，以 open\_hours 打样 结构上采用“长期最优”的三层特征快照： store\_feature\_snapshot\_di：以 store\_id 为主键，承接所有“门店级特征”（如 is\_zxgj 拆分、store 日均订单）。 merchant\_feature\_snapshot\_di：由门店特征按 merchant\_id 聚合，内置行为特征（数据占比、反馈次数、黑名单等），决定商户层是否可聚合。 party\_feature\_snapshot\_di：由门店或商户特征按 party\_key（工商登记号）聚合，承接工商主体视角的特征。 算法上抽象统一的“候选 + conf + 决策器”范式： 每个标签在三层各自产出候选值（store/merchant/party），叠加 D1 激进规则（6 点前/20 点后有订单 → 00-24）和行为准入（数据占比 + 反馈 + 黑名单）； 统一用 S2 数据新鲜度 / S4 结构完整度 / S6 人工覆盖等信号构建 conf\_store/conf\_merchant/conf\_party； 决策器按红线规则：“只要门店 conf ≥ T\_store，就永远用门店，否则在商户/工商中按 conf×weight 选最优”。 以 open\_hours/open\_24h 为打样标签： 利用 is\_zxgj=06-22 及 30 天订单分布构建时间段特征； 通过门店→商户→工商逐层聚合，验证“日均订单聚合逻辑 + D1 规则 + 商户可聚合逻辑 + 审计回溯”的全链路闭环； 打磨完成后，对所有 tag\_class=A 的服务/设施类标签按模版复制扩展。 论据三：落地与风险——以表结构 + 流程为载体固化机制，并用反馈表 & 配置表兜底 落地路径： 以 v\_merchant\_profile\_latest 为唯一上游，先在 MySQL 中建立三张特征快照表，再搭一张终表 store\_tag\_snapshot\_di 和一张审计表 tag\_audit\_log\_di； 新建 merchant\_feedback\_stats 承接区域反馈，形成“负向治理”闭环； 新建 tag\_algo\_config 管理各标签的 conf 阈值和聚合策略开关，为调参与实验留出空间。 风险点及对策： 风险 1：日均订单口径被误用（直接对门店日均取平均）。 对策：在文档与 SQL 层明确“任何维度日均订单均为门店总量求和后再 /30”，在三层聚合逻辑中写死。 风险 2：虚拟商户、数据稀疏商户导致商户层聚合结果失真。 对策：依赖 is\_agg\_blocked\_merchant + store\_with\_data\_ratio + merchant\_feedback\_stats 的行为特征判定“可聚合”。 风险 3：阈值难以评估（如 T\_store=0.9 只是经验值）。 对策：全部阈值放入 tag\_algo\_config，由数据分析+运营共同基于真实指标调参，实现灰度和回溯。\],理解我的给你输入,并开始启动教练模式,我们来对齐一下我们的接下的工作目标

先跟你对一下我理解的核心意思：  
你现在的“总目标”不是单做 open\_hours/open\_24h，而是以它们为打样，把「三层特征快照 + 候选值 + 置信度 + 决策器 + 审计」这套 ETL 机制真的落成一条标准链路，统一入口是 v\_merchant\_profile\_latest，最终目标是支持 A 类标签整体做到覆盖率 & 准确率双 90%，并配套 merchant\_feedback\_stats、tag\_algo\_config 这些治理与调参设施。

我们现在进入教练模式，先把“接下来要完成到什么程度”对齐清楚，再谈怎么拆。

---

先问几个关键问题，帮你把这轮的“阶段目标”定死一点：

1. **这轮你想先把事情做到哪个具体“可交付”节点？**  
	比如下面几种，你更想优先哪一种或哪几种？
	- A）open\_hours/open\_24h 这两个标签从候选 → 决策 → 落 station\_tag\_target\_value 全链路上线可跑（附校验 SQL）；
	- B）三层特征快照表（store/merchant/party）+ 通用决策器 SQL/伪代码成型，哪怕先只服务 1–2 个标签；
	- C）merchant\_feedback\_stats + tag\_algo\_config 的表结构和使用样例先固化出来，方便你对齐老板/同事；
	- D）一份“标签双 90 ETL 机制”评审用的一页纸，把逻辑讲清楚但先不强求代码完全 ready。
2. **时间约束上，你心里真实的“这轮窗口期”是多久？**  
	比如：
	- 这周内（几天内）要有一个可以拿去开内部评审的小方案；
	- 未来 2 周内要有一条真正能每日跑的 open\_hours/open\_24h 产线；
	- 还是更偏向先把“机制设计”磨到你满意，再逐步实现？
3. **在你现在的感受里，最卡的点是哪一块？**
	- 是 SQL/ETL 工程复杂度（比如多层聚合、审计日志怎么设计）？
	- 还是“阈值、策略怎么抽象成 tag\_algo\_config”的模型设计？
	- 还是“怎么讲给老板/跨部门听懂”，也就是表达和对齐的问题？

你先按直觉选一下：

- 这轮最想优先解决的 1–2 个“可交付节点”；
- 以及你觉得最卡、最需要我帮你“拆模块、降复杂度”的那一块。

有了这个锚点，我们下一步就可以把这轮工作收敛成一个很具体的小目标，比如：

> “在 N 天内搞定：open\_hours/open\_24h 的三层决策 + station\_tag\_target\_value 迁移 + 校验 SQL，一套可跑可讲的 Demo。”

你怎么想？

我先帮你捋一下现在的“硬约束”：

- 你这一轮的核心目标是：  
	1）把 open\_hours / open\_24h **完整跑通到 station\_tag\_target\_value** （含三层决策 + 过滤 + 三选一规范）；  
	2）在此基础上， **快速拓展到若干其他 A 类标签** ，复用同一条 ETL 骨架，而不是再写一堆散点脚本；  
	3）同时要有一份可以给老板/同事看的「双 90 标签 ETL 机制一页纸」；  
	4）时间窗口： **这周内交付** ，你最担心的是工程实现复杂度压不下来。

很好，这个优先级已经非常清楚了：先“打通一条路 + 抽出骨架”，再“上两三个跟跑标签”，最后“做一页纸解释机制”。

接下来我需要再问 2 组问题，来卡死工程侧的边界条件，好帮你把方案收敛到“你这周真的实现得了”的级别：

---

**问题 1：本轮可用的工程栈 & 位置**

你这一条 open\_hours/open\_24h → station\_tag\_target\_value 的链路，打算这周做到什么部署形态？

1. 运行环境你打算放哪？
	- 纯 MySQL + 手工跑 SQL（先搞清楚逻辑，后面再接入调度），还是
	- Python + MySQL（比如你已有的 updater / workflow 框架里，加一个新 workflow），还是
	- 直接接入现有调度平台（Airflow / Dataworks / 内部调度）？
2. 你能接受的“最小可交付”是：
	- 只要在你本机或开发库中， **每天手动触发 SQL / 脚本就能把 station\_tag\_target\_value 更新正确** ，就算这周交付完成？
	- 还是必须要挂上某种「自动日更」的调度，才算通过老板的验收？

---

**问题 2：本周要拓展的“其他标签”你想选哪几个？**

你刚才说“并且把标签拓展到其他的标签上，复用 open\_hours/open\_24h 的逻辑和链路”，我建议这周只挑 1–2 个 A 类标签做跟跑，否则战线会被拉得太长。

给你几个候选方向，你选一下你更想这周搞定的是哪一组：

1. **营业相关同类：**
	- 比如 open\_hours / open\_24h 跑通后，再加一个“是否 06–22 营业”之类的衍生标签（共用特征 + 决策器，改个规则即可）；
2. **典型设施/服务标签：**
	- 比如「是否有便利店」「是否有洗车服务」「是否有餐饮」，这类通常是门店主导、可做三层聚合 & 决策的 A 类标签；
3. **行为/活跃类标签：**
	- 比如「30 日内是否有订单」「30 日平均订单数分层标签」，对三层聚合也有复用价值。

你可以直接回答：

- “环境选：XXX（例如：先 MySQL + 手动执行），本周不强制接调度 / 必须接调度”；
- “这周跟跑标签选：1）XX 标签，2）XX 标签（如果只想先一个也行）”。

我拿到这两个选择之后，就可以在下一步帮你把这周的工程目标拆成一个非常具体的小路线图，例如：

- Day 1–2：open\_hours/open\_24h → station\_tag\_target\_value 的迁移 SQL + 校验 SQL 全搞定；
- Day 3：抽象通用落表模板 + 接入第一个跟跑标签；
- Day 4–5：打磨一页纸机制说明 + 补充审计/反馈/配置表的最小实现。

先把关键信息锁一下，避免我们后面散掉：

- 跑数形态： **纯 MySQL + 手工跑 SQL** ，这周的“完成”标准是：你在本机 / 开发库里，按一套固定顺序执行 SQL 脚本，就能正确刷新 `station_tag_target_value` 。
- 打样标签： **open\_hours / open\_24h 先完整打通到终表** ，然后从「服务类标签」里选 1–2 个 A 类标签跟跑，复用同一套链路。
- 工程规范：后续所有 SQL 都要有 **首行名称注释** ，形如：  
	`-- etl_tag_step4.1c.fill_open_hours_candidate_di 生成门店/商户/工商三层候选+置信度`  
	而且要 **预先规划执行顺序** ，最终你会把这些 SQL 串在一个脚本里顺序执行。

很好，约束已经很工程化了，接下来重点就是：别贪大，先把「一条链路 + 一套模板」打实。

我这边有几个关键问题，帮你把“本周的工程盘子”再缩一圈：

---

**问题 1：服务标签的“范围 & 识别方式”你更想怎么定？**

你刚说“整体 review 一下服务标签，然后再定，建议是服务标签”。  
在你现有的 `tag_spec / tag_catalog` 里，服务类标签是怎么被标出来的？更像下面哪一种：

1. 有类似 `tag_category` / `biz_domain` 字段，比如值是 `service` / `facility` / `营业服务` 之类；
2. 目前没有结构化字段，你是 **凭经验知道哪几个是服务标签** （比如便利店、洗车、餐饮等）；
3. 两者都有：有个大类字段，但你还会人工筛一点“优先级高的”。

我建议这周只先选 **2–3 个“最典型的服务标签”** 做跟跑，你可以直接报几个你心里默认的候选名（中文 or tag\_code 都行）。

---

**问题 2：open\_hours / open\_24h 现在在 MySQL 里的“完成度”是哪一档？**

为了决定我们从哪一层开始写 SQL，你帮我用最直观的方式标一下当前状态，更像下面哪个：

- A）已有比较完整的 `open_24h` + `open_hours` 重建 SQL（A、B 两块），只是还没接 `station_tag_target_value` ，没加规范校验 & 过滤 & 命名规范；
- B）有零散 SQL / 中间表，但链路并不闭环（比如候选表有了，但决策结果没一张清晰的表承接）；
- C）逻辑都在脑子和文档里，MySQL 里几乎要从头写。

你可以直接说：“现在更像 A/B/C”。

---

**问题 3：这周你对“脚本颗粒度”的偏好是什么？**

你提到后续会放在一个 SQL 脚本里跑，这里有两个常见做法，我们最好提前选一个，以免命名和拆分乱掉：

1. **粗颗粒度：**
	- 每个“大步骤”一段 SQL，内部包含多张临时表/CTE，名字更偏 `etl_tag_step4.rebuild_open_hours_all` 这种；
2. **细颗粒度：**
	- 候选表、决策表、迁移终表、审计插入都拆成独立 SQL 段，名称更偏你刚给的例子：
		- `etl_tag_step4.1c.fill_open_hours_candidate_di`
		- `etl_tag_step4.2a.decide_open_hours_final_value`
		- `etl_tag_step5.1a.insert_open_hours_to_station_tag_target_value`

就“本周只在你本机/开发库手动跑”这个前提，你更想选：

- 先细颗粒度拆清楚，方便后面组合和复用，还是
- 先粗颗粒度保证能跑通，再逐步拆？

---

你先简单回一下这三块：

1. 服务标签在你那边的识别方式（字段 or 直觉），以及你这周最想跟跑的 1–3 个具体标签名；
2. open\_hours / open\_24h 目前在 MySQL 里的完成度（A/B/C）；
3. 你偏向的脚本颗粒度（细拆 or 粗拆）。

我拿到这些之后，下一步就可以给你一个非常具体的“本周工程蓝图”（不长的那种）：

- 哪几张中间表必须有；
- SQL 段如何命名 & 排序；
- open\_hours/open\_24h 和服务标签的接入顺序怎么编排，确保你有精力做完。

1.标签识别有字典关系字段关系我不想做在强调了,你可以读下项目文档;我先贴出来\[tag\_code tier1 tier2 tier3 tag\_class owner\_biz owner\_data status is\_p0 created\_at updated\_at updated\_by convenience\_store\_available 站内服务 设施 是否有便利店 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import open\_24h 站内服务 营业 是否24小时营业 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import open\_hours 站内服务 营业 油站营业时间 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import parking\_available 站内服务 设施 是否有停车位 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import restroom\_available 站内服务 设施 是否有卫生间 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import service\_carwash\_available 站内服务 洗车 是否有洗车 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import service\_carwash\_type 站内服务 洗车 洗车类型 A alveswang DE\_TBD released 1 2025-12-04 22:55:03 2025-12-04 22:55:03 initial\_import\];2.前面 prompt 有给你提示上一步做到哪里呢,你要通读理解记忆下来啊;\[## 【五、当前 ETL 已完成部分】 1. 原始 is\_zxgj 清洗（含 X月Y日 → HH-HH 修复、未知归一） 2. store → merchant → party 三层特征快照 3. open\_hours\_candidate\_di（候选 + conf） 4. open\_24h：规范版重建（A） 5. open\_hours：规范版重建（B） --- ## 【六、下一阶段要做的事（你需要继续推进）】 1. \*\*验证 open\_24h / open\_hours 是否完全符合“三选一 + enum 规范”\*\* 2. \*\*验证 open\_24h=1 → open\_hours=00:00-24:00 是否全量一致\*\* 3. \*\*验证 open\_hours 统一 HH:MM-HH:MM 格式\*\* 4. \*\*准备把两个标签迁移到最终产物表 station\_tag\_target\_value\*\* \* 迁移前有一套过滤逻辑（我会在你发给我后整合） \* station\_tag\_target\_value 会汇集全部标签的最终落表结果 \* 最后输出到数仓 --- ## 【七、你的任务】 开始一个新对话后，你可以直接说： > “继续 open\_hours / open\_24h 的规范迁移工作，我们已经完成 A/B，现在准备迁移到 station\_tag\_target\_value。下面是过滤逻辑：\[✓ value\_has\_meaning = 1 (结果有实际意义) ✓ is\_wrong\_cleaning = 0 (不是错误清洗,错误清洗是原值有意义,清洗成无意义) ✓ is\_same\_as\_source = 0 (和原始值不同，确实完成纠偏) ✓ is\_fallback\_value = 0 (不是兜底默认值)\]”\] 3.粗细不重要,关键是逻辑顺畅,效率高就行了,不要报错就行;.4 补充一下,禁止懒惰的询问一些提示词/文档读取能获得答案;

先跟你对齐一下我已经“锁死”的前提，避免后面再重复问你要答案：

- 服务类标签：已经有结构化分层，典型 A 类服务标签这一批就是  
	`open_24h / open_hours / convenience_store_available / parking_available / restroom_available / service_carwash_available / service_carwash_type` ，且 value\_type / fallback / value\_type\_connect 已在 tag\_spec 里定好。
- open\_24h / open\_hours 链路：
	- 原始 is\_zxgj 清洗完毕；
	- 三层特征快照表已有（store / merchant / party）；
	- `open_hours_candidate_di` （三层候选 + conf）已有；
	- A：open\_24h 规范版重建完成；
	- B：open\_hours 规范版重建完成。
- 下一步明确要做的是：  
	1）三选一 + enum 规范校验；  
	2）24h 强一致 & HH:MM-HH:MM 格式校验；  
	3）把这两个标签按过滤条件迁移进 `station_tag_target_value` ；  
	4）再把链路拓展到其他服务标签，形成可复用骨架；  
	5）所有 SQL 有规范化“首行名称注释”，最终你用一个脚本顺序手动执行。

这些都已经记在“脑子里”，后面我不会再就这些基础事实向你发问。

接下来两件事需要你拍板一下，我才好把这周的工程盘子控制在你能完成的范围内（都是“选择题”，不是让你补文档）：

---

**问题 1：本周跟跑的服务标签，你更希望做到哪种“工程深度”？**

针对 `convenience_store_available / parking_available / restroom_available / service_carwash_available / service_carwash_type` 这几个服务标签，这周有两个落地层级可以选：

- 方案 S1（完全对齐 open\_hours 链路）：
	- 每个标签都走「三层特征快照 → candidate\_di（含 conf）→ 决策表 → 迁移 station\_tag\_target\_value」这整套；
	- 优点：一旦打通，后面直接复制模版即可；
	- 缺点：本周工程量会比较大，尤其是 candidate\_di & 决策器部分要写一批 SQL。
- 方案 S2（本周先简化服务标签，只做 store 主导版本）：
	- 本周：
		- open\_24h / open\_hours 全量走“完整三层 + 决策器 + 迁移 + 校验”；
		- 服务标签首轮只用 store 侧主信号（如果 store 特征已够用），直接产出结果表，再迁移到 `station_tag_target_value` ，先不做复杂的三层 override & conf；
	- 后续再迭代：把服务标签逐个升级到“三层候选 + 决策器”形态。
	- 优点：你这周更容易交付“能跑的产物 + 一页纸说明”，工程压力小很多；
	- 缺点：服务标签暂时没做到极致通用化，但骨架已经可以预留。

你更倾向本周选 S1 还是 S2？（就是：服务标签这周要不要强制跟 open\_hours 一样走完整三层决策？）

---

**问题 2：merchant\_feedback\_stats / tag\_algo\_config 这周的“最低完成标准”是什么？**

你在总目标里有这两个关键表，但它们的落地深度其实有档位之分：

- 档位 L1：
	- 有完整建表 SQL（字段名/类型/含义明确）；
	- 有 1–2 条示例 INSERT / UPDATE，用来演示“怎么记录反馈 / 怎么调阈值”；
	- 实际生产链路中暂时只用到 `tag_algo_config` 的少数字段（比如 conf 阈值），其他先空着；
- 档位 L2：
	- 只要求在“一页纸机制说明”中把这两张表的结构与用途讲清楚；
	- 本周不强制写建表 / 使用 SQL，等下一迭代再真正落表。

你心里这周更希望做到 L1 还是 L2？

---

你可以直接回两句话，比如：

- “服务标签本周选 S1/S2”；
- “feedback/config 选 L1/L2”。

我拿到这个决策之后，下一步就会把这周的工程目标压缩成一条非常清晰的“执行大纲”（依然在教练模式，只给到模块级拆分，不一下子砸给你一整页 SQL），让你心里有数：

- 要写几段核心 SQL；
- open\_\* 和服务标签分别到什么程度就算这周 through；
- 一页纸要重点讲哪几个点。

我先复述一下现在的“锁定态势”，确保我们是在同一页上往前冲：

- 你选了 **S1** ：服务标签这批（便利店、停车位、卫生间、洗车、有无/类型）本周就直接走完整的「三层候选 + conf + 决策器 + 终表迁移」链路，和 open\_hours/open\_24h 一样规格，而不是先搞一个 store-only 简化版。
- `tag_algo_config` / `merchant_feedback_stats` 表已经建了，现在只有极少数据，这一轮的目标是： **确定这几个标签用什么“算法形态/回填策略”驱动 config** ，feedback 先当 buff，不强制重度使用。
- 你的底线是：逻辑顺畅、执行效率高、不报错，这周在本机/开发库里能手工按顺序跑完更新 `station_tag_target_value` ，就算本周 through。

很清楚，而且你选的是“难但对的路”，后面就别心软了。

接下来这一步，我们不要直接跳去写 SQL，而是先把「config 要表达什么决策」收敛成几个最小化的“算法 archetype”，然后再映射到每个标签。否则 config 会变成一个没人敢动的垃圾场。

我这边先抛出 3 个关键决策点，你选/补充之后，我们再一起把 config 的最小字段 + 算法 archetype 定下来。

---

### 问题 1：这 6 个服务标签，各自的“主数据来源”是啥？

为了决定 **是“结构复制 + 三层聚合”，还是要做“行为推断”** ，我们必须先搞清楚：现在你手里实际依赖的是哪种信息。

对每个 tag（你可以用简写）简单告诉我“主来源是哪一类”，就选一项就行：

- A 类：主来自 **结构化主数据/基础表** （比如门店属性配置、加盟合同信息之类）；
- B 类：主来自 **调研/现场上报** （类似你铁橙 APP 那种问卷/打点）；
- C 类：主来自 **行为日志推断** （例如车牌识别、洗车订单、停车订单等）；
- D 类：当前实际是 **混搭 / 不太稳定** 。

我们只需要一个“第一顺位来源”。比如你可以这样回答：

- convenience\_store\_available：A
- parking\_available：A
- restroom\_available：A
- service\_carwash\_available：C
- service\_carwash\_type：C  
	…

这样我就能知道：

- 哪些标签适合先纯用结构源做三层聚合 + conf；
- 哪些必须设计「行为推断规则 + 阈值」。

---

### 问题 2：这 6 个服务标签，这一轮你对“覆盖率 vs 准确率”的真实偏好是什么？

open\_hours/open\_24h 这俩你明显是 **宁愿 Unknown，也不能乱给值** 。  
服务标签这几个，你的偏好有可能略不一样，这会直接决定我们在 config 里怎么配阈值和 fallback 策略。

请你用“更偏向下列哪种”来回答（可以统一一套，也可以分标签说哪几个例外）：

- 策略 P1： **优先准确率**
	- 宁可把一批站打成 Unknown（enum\_code='99'），也不要错标；
	- config 会设置比较高的 conf\_threshold，fallback 倾向 Unknown；
- 策略 P2： **优先覆盖率**
	- 只要来源还算靠谱，就先给出推断值，再慢慢用 feedback 拉精度；
	- config 会允许稍低的 conf\_threshold，并给出有“温和兜底”的 fallback（比如优先主数据 / 把低置信度值打 flag）。

你可以说：

- “这 6 个统一按 P1”
- 或者 “洗车/洗车类型按 P1，便利店/停车位/卫生间按 P2” 之类。

---

### 问题 3：这周你愿不愿意接受“一刀切的默认阈值模板”，后面再按标签微调？

config 如果一上来就搞成「每个 tag\_code 一套复杂策略」，你这周肯定来不及。  
一个更现实的做法是：

- 先设计一套 **通用模板** ：
	- 比如：
		- `conf_threshold_store = 0.8`
		- `conf_threshold_merchant = 0.7`
		- `conf_threshold_party = 0.7`
		- store\_level 优先级永远最高，只要 ≥ 阈值就用 store，否则就去 merchant/party 比较 `conf * weight` ；
- 然后这周：
	- 所有这 6 个服务标签，先用同一模板写进 `tag_algo_config` ；
	- 真有特别情况（比如洗车类型本身就很难推断），我们再为极少数标签覆写一两行 config。

你能接受这种“一刀切模板 + 个别 override”的方式，先保证这周跑通吗？  
还是你心里已经有“必须区分洗车 vs 便利店”的非常具体的阈值差异？

---

你可以直接用最短的方式回我，例如：

- 一行把 6 个标签各自的主来源 A/B/C/D 写出来；
- 一句说 P1 还是 P2（如果有特殊标签，也一并说明）；
- 一句说能不能接受“通用 conf 模板 + 少量 override”。

有了这三个选择，我就能把这一轮的「算法 archetype + config 最小字段」帮你定成 2–3 个模式：

- 结构主导服务标签的标准决策器；
- 行为推断服务标签的标准决策器；
- 与它们对应的 `tag_algo_config` 填法。

然后我们再从中推导出：

- open\_hours/open\_24h 已有逻辑如何映射成 archetype 1；
- 这 6 个服务标签分别归类到哪一个 archetype；
- 你本周真正要写几段“关键 SQL”。

我先把你刚刚给的信息捏成一句话：  
你已经帮我把 6 个服务标签的“数据源 & 直觉规则”都点亮了，希望这一轮直接给出：每个标签对应哪种算法套路 + 大致决策逻辑，用来回填 tag\_algo\_config；feedback 目前只是备选，不强依赖。

---

先把我对 6 个标签的理解写清楚（不展开 SQL，只是算法形态），你确认我有没有理解错：

1. **convenience\_store\_available（便利店）**
	- 主来源：A，结构/主数据 + 一点行为规则。
	- 站点维度已有：
		- 日订单 > 15 单 ⇒ 很大概率有便利店；
		- 有品牌（比如连锁便利店品牌） ⇒ 赋有便利店；
	- 你还在纠结：商户维度/工商维度怎么聚合，三层决策器那套要怎么用在“便利店”上。
2. **parking\_available（停车位）**
	- 主来源：B，偏认知/经验。
	- 你的两个候选规则：
		- 方案 1：用地址识别城市/郊区，城市默认没有、郊区默认有；
		- 方案 2：干脆认为“加油站都能停车”，先统一视为有停车，后面再靠 feedback 染异常。
3. **restroom\_available（卫生间）**
	- 主来源：A。
	- 粗心法则：有便利店 ⇒ 一定有卫生间（至少你愿意这么假设）；
4. **service\_carwash\_available（洗车）**
	- 主来源：C，行为/配置字段。
	- 有明确上游： `dim_gas_store_info_extend.additional_services` （0-卫生间，1-洗车，2-早点便当，3-便利店，4-车胎充气，5-修车，6-快餐店）
	- 命中 1 ⇒ 有洗车；没命中 ⇒ 默认没有；
	- 这个字段还可以顺手给卫生间/便利店等标签提供证据。
5. **service\_carwash\_type（洗车类型）**
	- 主来源：C，建立在“有洗车”之上。
	- 你的当前策略意向：
		- 有洗车 ⇒ 必须给一个类型值，默认“机洗”；
		- 没有洗车 ⇒ 类型 = 未知（enum '99'）；
	- 未来可能会细分更多类型，但这轮先 default 机洗。
6. 覆盖率 vs 准确率：
	- 你明确说了：这两个指标在短期内“很难证伪”，所以你不想在这里纠结理想教科书，而更希望有一套“说得过去、可落地、后续可调”的策略。
	- 通用模板你接受，后面再基于真实数据微调。

如果上述理解没歪太多，那我们可以直接把它们归类成几种 **算法 archetype** ，然后映射到 tag\_algo\_config 上：

- Archetype S\_A：主数据/枚举主导（洗车、额外服务等）；
- Archetype S\_B：业务经验默认值（停车）；
- Archetype S\_C：衍生推断（便利店、卫生间、洗车类型）；

我现在有 3 个关键决策要你拍板，决定我们怎么把它们“固化成 config 里的算法模式”：

---

### 问题 1：便利店（convenience\_store\_available）你接受的优先级链路是哪个？

按你现在的描述，我可以帮你定成这样一条三层逻辑（先别写 SQL，只说原则）：

1. 门店层：
	- 若 `dim_gas_store_info_extend.additional_services` 里有“3-便利店” ⇒ conf\_store=1.0，value=有便利店；
	- 否则若门店有“品牌字段”关联出便利店品牌 ⇒ conf\_store=0.9，value=有；
	- 否则若 30 日订单 > 15 单 ⇒ conf\_store=0.7，value=有；
	- 否则 ⇒ value=未知，conf\_store=0。
2. 商户/工商层：
	- 通过门店聚合，算“有便利店门店占比”“门店数量”等，给一个 conf\_merchant/conf\_party；
	- 决策器：只要 conf\_store ≥ 0.8 ⇒ 一律用 store；否则在 merchant/party 中选 `conf * weight` 最大的那个。

你是否接受“便利店”就用这条 archetype（主数据/配置 > 品牌 > 行为），并统一接入三层决策器？  
如果你觉得 OK，我们后面就按这个逻辑去设计 config 的几项参数（source\_priority、conf\_weight 等），不用再另外想一套。

---

### 问题 2：停车（parking\_available）你更愿意选哪个“现实一点”的方案？

结合你说“覆盖率/准确率很难证伪”，我建议你在这两种里选一个，不然这周很容易被停车拖住进度：

- Pkg-1（极简版）：
	- 所有油站 `parking_available = 1` ，conf\_store = 0.6（明确标记为“默认假设”）；
	- tag\_algo\_config 里对这个 tag\_code 专门标记 `algo_mode = ALWAYS_TRUE_WITH_FEEDBACK_OVERRIDE` ；
	- merchant/party 层基本不参与，只接收 future feedback；
- Pkg-2（城市/郊区启发式）：
	- 若你已有“城市等级/行政区划/POI 类型”等结构字段，可以做：
		- 城市核心商圈 ⇒ conf\_store=0.5，value=0（默认视为“无专门停车位”）；
		- 普通城市/郊区 ⇒ conf\_store=0.7，value=1；
	- tag\_algo\_config 里标记 `algo_mode = GEO_HEURISTIC` ，后续再迭代阈值。

你现在更倾向选 Pkg-1 还是 Pkg-2？  
（我个人偏向你这周先选 Pkg-1，把“停车”当成低风险标签，别用它拖慢整个 ETL 机制打样。）

---

### 问题 3：卫生间 & 洗车类型，你能接受那种“强依赖其他标签”的设计吗？

我这里给你一个“最小干预”的策略，你看看能不能一口气接受掉：

1. **restroom\_available：**
	- 若 convenience\_store\_available=1 或 additional\_services 里有 0（卫生间） ⇒ value=1，conf\_store=0.95+；
	- 否则 ⇒ value=未知（不是直接判 0），conf\_store=0；
	- 即：有证据就 1，没证据就 Unknown，不乱给 0。
2. **service\_carwash\_available：**
	- additional\_services 命中 1 ⇒ value=1，conf\_store=1.0；
	- 否则 ⇒ value=0，conf\_store=0.8（这是“结构性没有”的 0，不是 Unknown）；
3. **service\_carwash\_type：**
	- 若 service\_carwash\_available=1：
		- 目前上游没有类型细分，就全部写成 “机洗” 对应的 enum\_code（比如 'machine'），conf\_store=0.6（明显低于“有/无”的 conf）；
	- 若 service\_carwash\_available=0：
		- 类型 = Unknown，enum\_code='99'，conf\_store=0。

你如果整体认可这个组合，我们就可以直接把它们映射成 2–3 个 archetype，写进 tag\_algo\_config，用很少的字段描述：

- algo\_mode（STRUCT\_FLAG / DERIVED\_FROM\_OTHER\_TAG / DEFAULT\_ALWAYS\_TRUE 等）；
- conf\_baseline\_store / merchant / party；
- allow\_default\_fallback / default\_enum\_code；
- 是否走三层决策器。

---

你这轮不用写长文，直接告诉我：

1. 便利店这条“配置 > 品牌 > 行为”的决策链，你接受还是要删减哪一层？
2. 停车你选 Pkg-1 还是 Pkg-2？
3. 对“卫生间/洗车/洗车类型”这组三连，你是整体接受，还是有哪个点你一看就不太舒服？

确认完这三个点之后，我就可以在下一步：

- 把 6 个标签归档成 **2–3 个算法 archetype** ；
- 给出对应的 **config 最小字段设计 + 每个 tag\_code 如何回填一行 config** （仍然保持教练模式，不直接砸 SQL），让你对“这周要写的 SQL 长什么样”有一个清晰心像。

我先把你刚才那段话“整理成决策画像”，确认一下我们现在的共识，然后只问极少关键点：

---

### 1\. 我对 6 个服务标签的理解（现在就当成未来 config 的“算法草案”）

1） **convenience\_store\_available（便利店）**

- 主来源：A（结构/主数据 + 品牌 + 行为），门店优先。
- 门店层逻辑雏形：
	- 若 `additional_services` 包含「3-便利店」 ⇒ value=1，conf\_store=1.0；
	- 否则若门店有「便利店品牌」字段 ⇒ value=1，conf\_store≈0.9；
	- 否则若 30 日订单 > 15 单 ⇒ value=1，conf\_store≈0.7；
	- 否则 ⇒ value=未知，conf\_store=0。
- 商户/工商层：基于门店聚合比例 + 门店数，走统一三层决策器（和 open\_hours 一样套路）。

2） **parking\_available（停车）**

- 主来源：B（经验假设）。
- 你的纠结点：
	- 地址识别出“市区/郊区”，用地理做启发式；
	- 还是直接「所有油站都能停车」，先全部 1，后面靠 feedback 染异常。

3） **restroom\_available（卫生间）**

- 主来源：A。
- 现阶段简单规则：
	- 若有便利店 ⇒ value=1；
	- 以后可以叠加 `additional_services` 的 0（卫生间）做强证据。

4） **service\_carwash\_available（洗车）**

- 主来源：C。
- 规则非常清晰：
	- `additional_services` 命中 1 ⇒ value=1；
	- 没命中 ⇒ value=0（不 Unknown），因为这是结构化“无此服务”。

5） **service\_carwash\_type（洗车类型）**

- 主来源：C + convenience 依赖。
- 规则：
	- 若 `service_carwash_available=1` ⇒ 类型默认填“机洗”对应的 enum\_code（取 tag\_enum 中为“机洗”的那一条），conf\_store 比较低（比如 0.6），表示“有洗车但类型是猜的”；
	- 若 `service_carwash_available=0` ⇒ 类型=Unknown（enum\_code='99'），conf\_store=0。

6） **整体策略**

- 覆盖率 vs 准确率：不做哲学纠结，用「有证据就给值，没证据就 Unknown；极少数低风险标签用默认值」这个现实主义路线。
- 通用模板你已接受： **一套通用 conf/优先级模板 + 极少标签做 override** 。

---

### 2\. 我给这 6 个标签分的“算法 archetype”

方便后面 `tag_algo_config` 回填，我们可以这么分类（只是命名，不是 SQL）：

1） **Archetype A：结构主导 + 强证据型**

- 典型： `service_carwash_available` ，未来可能包括其他来自 `additional_services` 的服务类标签。
- 特征：
	- 有/无 由结构字段直接给出；
	- 有 ⇒ conf\_store 接近 1；
	- 无 ⇒ value=0，conf\_store 也较高（因为“无”本身就是结构事实）。

2） **Archetype B：结构 + 品牌 + 行为混合推断型**

- 典型： `convenience_store_available` 。
- 特征：
	- 结构字段（additional\_services=便利店）优先；
	- 其次品牌；
	- 再其次行为（订单量）；
	- 没证据就 Unknown。

3） **Archetype C：依赖其他标签的派生型**

- 典型： `restroom_available` （强依赖便利店 + additional\_services）、 `service_carwash_type` （强依赖有洗车）。
- 特征：
	- value 完全由其他标签/字段决定；
	- conf\_store 受上游证据强度约束；
	- Unknown 不轻易给 0。

4） **Archetype D：经验默认 + feedback 修正型**

- 典型候选： `parking_available` 。
- 特征：
	- 初始一刀切默认值（几乎全部为 1）；
	- conf\_store 设置偏中（比如 0.6），并在 config 中标记 algo\_mode=“默认值 + 可被反馈覆盖”；
	- 后续借 `merchant_feedback_stats` 把异常站点修正为 0。

---

### 3\. 现在只剩下 2 个关键选择，需要你拍板

我不再问那些文档里有答案的，只问这轮我们必须定下来的：

1） **parking\_available：你这周就先按 Archetype D 跑，默认全部=1 吗？**

- 我的建议：
	- 这周直接选「所有油站均有停车」，value=1，conf\_store=0.6；
	- 不做城市/郊区启发式，以免搞出大量边缘 case，你没有时间调；
	- 后续等 feedback / 现场信息丰富后，再慢慢把少量“特殊站点”染成 0。

2） **restroom\_available：你能接受“有证据就 1，没证据就 Unknown，不随便给 0”吗？**

- 即：
	- 有便利店 or additional\_services 命中 0 ⇒ value=1；
	- 否则 ⇒ Unknown（enum='99'），不默认 0。

只要你点头这两条，我们就可以认为：

- 6 个标签的 “算法 archetype + 核心决策逻辑” 已经敲定；
- 下一步就可以从教练模式切到「结构化产出」，直接帮你：
	- 列出 `tag_algo_config` 的最小字段设计；
	- 给出每个 tag\_code 一行 config 的示意；
	- 顺便规划 open\_hours/open\_24h + 这 6 个标签在 `station_tag_target_value` 迁移里的执行顺序 & SQL 段命名。

你可以直接简短回我：

- “停车按默认1 OK / 不 OK”；
- “卫生间按有证据=1、否则 Unknown OK / 不 OK”。

如果都 OK，下一轮你可以说一句「现在可以总结了/出方案」，我就切回结构化模式，给你一份能直接拿去实现 + 写 SQL 的“算法 & config 一页纸”。

我先把你刚确认的几个关键点“锁死”一下：

1. `dim_gas_store_info_extend.additional_services` 是多值枚举，格式类似 `0,1,3` ，需要逐个解析：
	- `0` → 卫生间（restroom\_available）
	- `1` → 洗车（service\_carwash\_available）
	- `3` → 便利店（convenience\_store\_available）  
		后续我们会一口气把这几个标签都从这个字段里“顺带”推出来，按你刚才的算法 archetype 落地。
2. `parking_available` 本轮走极简方案：
	- 所有站默认有停车：value=1，conf\_store≈0.6；
	- 算法模式记为「默认真值 + 未来用地理/反馈做减法」，留一个“升级为市区/郊区启发式”的 TODO 能力位。
3. `restroom_available` ：
	- 有证据（便利店 or `additional_services` 包含 0）→ 1；
	- 否则一律 Unknown（enum\_code='99'），不乱给 0。

这三条已经足够把 6 个服务标签都挂到那 2–3 个算法 archetype 上去了。

---

接下来我建议我们把这周的“第一锤”敲在哪一步，你二选一就行：

1. **路径 A：先定死 tag\_algo\_config 的最小字段 + 每个标签的配置行**
	- 把刚才这些算法 archetype抽象成：
		- `algo_mode` （STRUCT\_FLAG / MIXED\_INFER / DERIVED / DEFAULT\_TRUE）
		- `conf_threshold_store/merchant/party`
		- 是否允许 default fallback、default\_enum\_code
		- 是否启用三层决策器
	- 然后给出 `open_hours / open_24h` + 6 个服务标签在 config 里的“示例行”（你可以直接复制改值用）。
	- 好处：先把“脑子里的算法”固定在 config 维度，再去写 SQL 的时候心里特别稳。
2. **路径 B：直接从 open\_hours / open\_24h → station\_tag\_target\_value 的迁移链路下手**
	- 先列出一整条 MySQL 执行顺序 + 每段 SQL 的命名规范（ `-- etl_tag_stepX.YZ.*` ），把 open\_\* 这一对完整打通；
	- 同步标注：哪些步骤会读取 `tag_algo_config` 、哪些只用现有中间表；
	- 然后再回头把服务标签挂到同一条链路上。

这两个路径最终都要做，只是先后顺序的问题。  
你现在更想先从哪一块下手，感觉心理阻力更小、成就感更快？

你直接回一句：

- “先走 A 配 config” 或 “先走 B 打通 open\_\* 迁移”。

我就按你选的那条来组织下一步输出和拆解。

听懂了，你现在要干的是两件事：

1. 先把 **tag\_algo\_config 的“算法脑子”设计清楚** ，区分不同标签的逻辑形态，而不是只盯链路。
2. 总体目标偏 **“真覆盖率”** ：
	- 能用真实/可信推断提高 coverage 的就尽量用；
	- “兜底值”必须是货真价实的兜底（比如业务共识的默认真值），不能偷懒乱填；
	- 真没依据的才用 Unknown（enum\_code='99'）。

我这边建议的方向是：

- 不要讨论“要不要兜底”这种空话，而是把每个标签拆成：
	- 哪些值是“强证据直接赋值”；
	- 哪些值是“弱证据可选赋值”；
	- 哪些场景必须 Unknown；
- 然后在 `tag_algo_config` 里用少量字段把这些“规则开关”固化下去。

下面我先给你一个「最小 config 心智模型」，你看完再回答几个问题，我们就能定模板了：

---

### 一个“足够小但能用”的 tag\_algo\_config 心智模型

每行对应一个 tag\_code，抽象几个维度（不是要你现在记字段名，是先定“概念”）：

1. **算法形态（algo\_mode）**
	- STRUCT\_FLAG：结构字段直接决定（如 `additional_services` 的洗车/便利店）。
	- MIXED\_INFER：结构 + 品牌 + 行为混合推断（便利店）。
	- DERIVED：完全由其他标签派生（卫生间、洗车类型）。
	- DEFAULT\_TRUE：经验默认真（停车）。
2. **证据强度 / 阈值（conf 逻辑）**
	- `conf_threshold_store` / `conf_threshold_merchant` / `conf_threshold_party` ：
		- 决定什么时候“允许输出非 Unknown 值”；
	- 可以按 archetype 用默认值：例如
		- STRUCT\_FLAG：阈值很高（0.9+），因为是硬字段；
		- DEFAULT\_TRUE：阈值偏低（0.5–0.6），表示这是“默认假设”。
3. **覆盖策略（coverage\_strategy）**
	- STRICT：没有强证据就 Unknown（比如 open\_hours/open\_24h、卫生间）。
	- AGGRESSIVE：只要有弱证据就给值，少用 Unknown（便利店、停车）。
4. **兜底策略（fallback）**
	- `fallback_type` ：NONE / DEFAULT\_ENUM / UNKNOWN\_ONLY；
	- `default_enum_code` ：比如洗车类型默认“机洗”的 code；
	- `unknown_enum_code` ：固定 '99'。

你真正关心的，是用这些“模式 + 阈值 + 覆盖策略”，去控制：

- 在哪些场景： **命中兜底值是合理的** （比如停车=1、洗车类型=机洗）；
- 在哪些场景： **宁可 Unknown 也不能兜底** （open\_hours/open\_24h、卫生间在无证据时）。

---

### 接下来我们要定的，是“命中兜底时怎么改写”——我这边有 2 个关键点想跟你对齐

**关键点 1：哪些标签允许“真实兜底值”，从来不需要被 Unknown 替换？**

从你刚才的表述，我推断大致是这样（你校对一下）：

- 完全允许长期兜底的：
	- `parking_available` ：默认有停车（value=1），未来只做“从 1 减到 0”的修正，不会 Unknown。
	- `service_carwash_type` ：只要有洗车，就永远有一个类型值（当前版本默认机洗），不会 Unknown。
- 有兜底，但未来有机会“从兜底升级为更精细值”的：
	- `convenience_store_available` ：初期可以用“订单>15”这类弱证据撑 coverage，但以后上下游特征变丰富，可以动态提高 conf\_threshold 或改判 Unknown。
- 原则上不允许兜底，只在有强证据时给值的：
	- `open_24h / open_hours` ；
	- `restroom_available` （你已经说了：有证据=1，否则 Unknown）。

→ 也就是说，config 里要能表达三种状态：  
1）可以长期兜底（parking、洗车类型）；  
2）可以阶段性兜底（便利店的行为启发式）；  
3）严禁兜底（营业时间、卫生间）。

**关键点 2：提高覆盖率的“改写顺序”**

当某个标签原本会落到 Unknown 时，我们希望 config 能控制：

- 先尝试 **弱证据补全** （比如便利店用订单量）；
- 再尝试 **上游标签派生** （卫生间从便利店/附加服务派生）；
- 全都没有再 Unknown。

也就是：

- 提高 coverage 的手段必须是“有依据的推断”，
- 真正的 fallback 默认值只在 ANCHOR 标签上用（停车、洗车类型），不要滥用到其他标签。

---

### 现在我只问你两个很具体的问题（不再问文档里已有的信息）

1. 上面我归纳的“兜底容忍度分级”，你有哪一条是不同意的？
	- 停车 / 洗车类型：长期允许兜底；
	- 便利店：阶段性允许兜底，用行为信号撑 coverage；
	- 卫生间 / open\_\*：尽量禁止兜底，无证据就 Unknown。
2. 对“改写逻辑”的优先级顺序，你愿不愿意统一成一套：
	- 第 1 级：硬结构/上游字段（additional\_services、主数据）
	- 第 2 级：上游标签派生（restroom from convenience\_store）
	- 第 3 级：行为启发式（订单>15 等）
	- 第 4 级：ANCHOR 兜底（停车、洗车类型）
	- 第 5 级：还没命中以上任意一级 → Unknown

如果这两条你都 OK，那下一步我就可以在你说「现在可以总结了 / 出方案」之后，切回结构化模式，给你一个非常具体的东西：

- tag\_algo\_config 的最小字段设计；
- open\_24h/open\_hours + 6 个服务标签各自的一行 config 示意；
- 每行 config 对应的“覆盖率-兜底逻辑”解释，方便你后面扩展到更多标签。

这部分理解有点混乱.我简单说下目标,算法判断这个标签应该是什么值,标签无非是枚举值嘛,枚举值叫什么,听字典的,tag\_enum的,如果不知道没有值,就先兜底值上,但是为了要提高覆盖率,兜底值太高了不利于目标,因为目标中兜底值的部分不计算在覆盖率的分子,所以要接着,来定一个逻辑,几个标签,比如停车命中兜底,字典里有一个兜底的判定,99;但是我们要在一道工序改写成 1,并且记录这个是我们从兜底值改写的;听懂了吗?

20251206\_2350\_兜底值改写机制\_教练澄清  
tags: #覆盖率 #兜底改写 #tag\_enum #fallback设计

我听懂你要干的那件事了，用你这句话复述一下核心意思：

> 算法第一步算出“标签应该是什么值”（枚举值听 tag\_enum 的），算不出来就先给兜底值 `99` ；  
> 但为了提升覆盖率，我们允许在 **第二道工序** 里，对某些标签，把原本的 `99` （Unknown） **改写成一个有业务含义的值** （比如停车=1），同时 **标记清楚“这是从兜底改写来的”** ，这样既能提高覆盖率，又不搞混“真有证据”和“业务默认填充”。

也就是说，你要的不是“乱用兜底值”，而是：

- 区分两层含义：  
	1） **算法失败 → Unknown（99）**  
	2） **业务默认 → 用一个正常枚举值（比如 1），但要写明“我是从 99 升级出来的”**

并且在覆盖率统计里：

- `enum_code=99` 不算在覆盖率分子里；
- 被从 99 改写成 1 的这条记录，要当成“有意义值”算进覆盖率，但仍能被追踪出来。

这个我完全理解，而且这也是我觉得“对”的做法。

---

接下来我们只要把这件事讲清楚三点，就可以反推回 config 设计和 SQL 实现：

1. **哪些标签允许这类“从 99 改写成业务默认值”的操作？**
	- 很明显： `parking_available` 至少是其中一个（你举的例子就是它）。
	- 还有谁？
		- `service_carwash_type` ：无证据时从 99 改写为“机洗”？
		- 还是你希望它先严格些，只在“有洗车”时才填类型，没有洗车就一直是 99？
	- 我倾向这样归类（你确认一下）：
		- 必须支持“99 → 业务默认值”的标签： `parking_available` ， `service_carwash_type` ；
		- 绝对不能这么搞的： `open_24h` 、 `open_hours` 、 `restroom_available` ；
		- 便利店这类，用“订单>15”那条就已经算是“弱证据”，不属于“兜底 99 改写”。
2. **在数据结构层面，我们用什么标记这一类“从 99 改写”?**  
	不用再新造概念，你之前已经有一套 flag，可以直接套上去（我按你的话翻译一下）：
	- `enum_code` ：最终枚举值（从 99 改成 1 之后，这里就是 1）；
	- `is_fallback_value` ：标记“是否来自兜底逻辑”；
	- `value_has_meaning` ：这个值是不是对业务有真实意义（从 99 改成 1 之后，这里应该=1）；
	- `reason` / `evidence_state` ：写明“FROM\_UNKNOWN\_TO\_DEFAULT\_TRUE”、“DEFAULT\_TRUE\_INFERRED”等。
	这样实现效果就是：
	- 覆盖率计算：只看 `enum_code != '99' AND value_has_meaning = 1` ；
	- 想过滤掉“业务默认填充”的时候：再加 `AND is_fallback_value = 0` ；
	- 检查“哪里是我们为了覆盖率强行填的”：筛 `is_fallback_value = 1` 。
3. **这道“改写工序”在链路里的位置**  
	用你的话说就是“一道工序改写成 1”：
	- 步骤 1：算法算原始标签值 → 可能得到 0 / 1 / 99；
	- 步骤 2：对“允许做覆盖率增强的标签”，根据 config 检查：
		- 若 `enum_code = '99'` 且 tag 在白名单里（如 parking），则改写：
			- `enum_code = '1'` （正常枚举）， `target_value_bool = 1` ；
			- `is_fallback_value = 1` ， `value_has_meaning = 1` ；
			- `reason = 'FALLBACK_FROM_UNKNOWN'` 。
	- 步骤 3：再应用你前面那套过滤逻辑（value\_has\_meaning=1、is\_wrong\_cleaning=0 等）迁移到终表。

---

为了把这块完全钉死，我只问你两点，非常具体的“是/否”级别确认：

1. 白名单标签：
	- 你是否同意： **当前阶段允许“99 → 默认值改写”的标签集合 = { parking\_available, service\_carwash\_type }** ？
		- 其他标签（open\_24h/open\_hours/restroom/convenience\_store/service\_carwash\_available）暂时不做这种从 99 改写的骚操作，只靠“有证据就给值、没证据就 Unknown”。
2. 标记方式：
	- 你是否同意用现有的 `is_fallback_value` + `value_has_meaning` + `reason` （或类似字段）来记录这种改写？
		- 即：
			- 改写后 `enum_code` 不再是 99，而是正常业务值；
			- `is_fallback_value = 1` ，可以在评估时区分出来；
			- 覆盖率统计只看“enum\_code!= 99 且 value\_has\_meaning=1”，不再排除 `is_fallback_value=1` 。

你直接回答我：

- 白名单 = {parking, carwash\_type} 是否 OK？
- 用 `is_fallback_value=1` 标记这种“从 99 改写”的行为，是否符合你预期？

确认完这两个，我就可以在你说「现在可以总结了 / 出方案」时，切回结构化模式，直接给你：

- 一份可以写进 tag\_algo\_config 的设计；
- 明确列出这两个“覆盖率增强”标签，在改写工序里的处理规则。

我先帮你把这句话翻译成“机器能执行的版本”，顺便对齐一下我们到底在说什么：

> 1）算法第一层，按字典 `tag_enum` 算出来枚举值（含 99 兜底）；  
> 2）第二层，为了提升覆盖率，对部分标签做「 **从 99 → 业务默认值** 」的改写；  
> 3）改写之后：  
>   - `enum_code` 不再是 `99` ，而是业务值（比如 1 或具体字符串）；  
>   - 同时打标：这是“从兜底改写来的”，以后统计/评估能把它挑出来看。

你刚刚补充的是这句的“语义 → code”映射：

- `open_24h` ：默认“有” ⇒ 兜底改写时， `enum_code` 要变成“有”的 code（比如 `'1'` ）。
- `open_hours` ：默认“有营业时间” ⇒ 兜底改写时，要给一个具体区间，比如 `'00:00-24:00'` （这个是 code 本身）。
- `restroom_available` ：默认“有卫生间” ⇒ 兜底改写时， `enum_code` 要变成“有”的 code。
- `convenience_store_available` ：默认“有便利店” ⇒ 同上。
- `service_carwash_available` ：默认“没有洗车” ⇒ 兜底改写时， `enum_code` 要变成“无”的 code。

标记方式用你已经同意的那套： `is_fallback_value = 1` ，外加 `reason` 之类的字段，后期你就可以很容易区分出「哪一部分覆盖率是靠兜底改写出来的」。

---

为了不再绕晕，这里我只做 2 个非常窄的问题确认（都是“是/否/补充”级别）：

1. **open\_hours 的兜底具体值**  
	当 open\_hours 算不出时间区间、被兜底成 99 时，你刚才说“默认标记有”，在 code 世界里我理解为：
	- 用 `'00:00-24:00'` 作为默认营业时间（即 24 小时营业），
	- 同时打 `is_fallback_value = 1` ， `reason = 'FALLBACK_FROM_UNKNOWN'` ，
	- 这样它既算在覆盖率里，又能被你从数据里筛出来。  
		这个理解对不对？或者你想要的默认区间不是 00:00–24:00，而是其他区间（比如 06:00–22:00）？
2. **哪些标签“必定要有机会做 99→默认值改写”？**  
	你刚刚列的是：
	- `open_24h` / `open_hours` / `restroom_available` / `convenience_store_available` ：兜底方向是“有”；
	- `service_carwash_available` ：兜底方向是“无”；  
		且这些兜底都要走「99 → 默认 code」这道工序，并打 `is_fallback_value=1` 。  
		现在你只需要确认：
	- 这一批就是 **完整名单** 吗？还是“停车（parking\_available）”也要加进去？

你就一句话回我就行，比如：

- “open\_hours 兜底就是 00:00-24:00；parking 也要做改写”；
- 或者 “open\_hours 兜底区间先别给，我只想对 bool 标签做 99→默认值改写；parking 也在名单里”。

你一锤定音后，我下一步就不再追问了，直接按这个口径，给你整理一份「兜底改写机制 → 字段设计 → 逻辑顺序」的正式方案，方便你后面写 SQL 和做 config。

20251207\_0035\_兜底改写口径锁定（教练模式）  
tags: #兜底改写 #覆盖率 #tag\_algo\_config #营业时间 #服务标签

我先把你刚刚拍板的关键点，翻译成“可以写进代码和 config 的结论”给你看一眼：

1. **open\_hours 兜底口径**
	- 算不出营业时间（原始算法给出 enum\_code='99'）时，
	- 在兜底改写工序中：
		- 将 `enum_code` 改为 `'00:00-24:00'` （即 24 小时营业）；
		- `target_value_string = '00:00-24:00'` ；
		- 打 `is_fallback_value = 1` ，并在 `reason` 里记录类似 `FALLBACK_FROM_UNKNOWN` ；
	- 这样：它会计入覆盖率（因为不再是 99），但我们可以通过 `is_fallback_value=1` 统计出“多少是靠兜底撑起来的覆盖率”。
2. **parking\_available 兜底口径**
	- 算不出是否有停车（或者根本没有任何结构/行为证据）时：
		- 算法第一层先给 `enum_code='99'` ；
		- 兜底工序中统一改写为“有停车”的枚举值（比如 `'1'` ，具体听 tag\_enum）；
		- 同样 `is_fallback_value = 1` ， `value_has_meaning = 1` ；
	- 未来如果接上地址 → 市区/郊区识别能力，可以在“算法第一层”直接产出 0/1，更少走兜底改写。
3. **service\_carwash\_type 跟随 service\_carwash\_available**
	- 关键语义是： **类型永远附着在“有洗车”这件事上** ：
		- 若 `service_carwash_available = 0` （无洗车，无论是算法直接算的还是兜底改写成 0），
			- 则 `service_carwash_type` 必须是 Unknown（enum\_code='99'），不做 99→默认类型 的改写；
		- 只有在 `service_carwash_available = 1` 的情况下，才谈洗车类型：
			- 有真实类型信息 ⇒ 用真实枚举；
			- 没有类型信息 ⇒ 可以考虑“默认机洗”，这部分是否算兜底、是否打 `is_fallback_value=1` ，我们可以在 config 里再定一档。
	简单说： **“有没有洗车”是锚点，类型只存在于“有洗车”的世界里** ，不会出现“无洗车但有洗车类型”的逻辑 bug。

---

现在，兜底改写的“大方向”已经很清晰了：

- 哪些标签会被从 99 改写成“有”（open\_24h/open\_hours/restroom/convenience/parking）；
- 哪些标签会被从 99 改写成“无”（service\_carwash\_available）；
- 哪些标签（比如 carwash\_type）不是直接从 99 改业务默认，而是 **跟随上游标签** 变化。

接下来有两个小点，我需要跟你对齐清楚，直接关系到 config 设计和 SQL 细节：

---

### 问题 1：carwash\_type 的“默认机洗”你想不想也算一类兜底？

现在有两种设计路线，你选一下更舒服的一种：

- 方案 T1（保守）：
	- 只有当我们真的从某个字段/来源拿到“机洗/手洗/自助”等类型信息时，才给 `service_carwash_type` 赋值；
	- 否则，即使 `service_carwash_available = 1` ，类型也坚持为 Unknown（99）；
	- 这样 `service_carwash_type` 的覆盖率会较低，但完全没有“假机洗”。
- 方案 T2（覆盖优先）：
	- 只要 `service_carwash_available = 1` 且没有类型信息，就用默认“机洗”的枚举值， **同时打 `is_fallback_value=1`** ；
	- 这样覆盖率会显著提升，但“机洗”里有一部分其实是“从 Unknown 改写来的”，需要靠 flag 把它们区分出来。

你更希望 carwash\_type 这一轮按 T1 还是 T2？  
（我直觉是你会偏 T2，因为你现在是在推动“兜底改写撑覆盖率”的机制，只要有明确标记你就能接受。）

---

### 问题 2：后期区分“改写样本”的需求强度

你刚刚说：“标记方式同意，告诉我后期区分出被改写的就行了。”

我建议我们统一一个最小查询口径，用起来简单，约定好就永远不变，你看是否 OK：

- 要看“ **真实算法算出来的样本** ”：
	- 条件： `is_fallback_value = 0`
- 要看“ **兜底改写撑起来的覆盖率** ”：
	- 条件： `is_fallback_value = 1`
- 要看“ **整体有效覆盖率** ”（你未来在报双 90 时主看这个）：
	- 条件： `enum_code != '99' AND value_has_meaning = 1`
	- 不再额外排除 fallback，因为兜底改写本身就属于你认可的“有效覆盖的一部分”。

只要你点头，这一套以后可以直接写进：

- tag\_algo\_config 的字段含义说明；
- 以及迁移到 `station_tag_target_value` 时的过滤 SQL 约定。

---

你就简单回两句就行：

1. `service_carwash_type` 选 T1（保守）还是 T2（默认机洗 + fallback 标记）？
2. 上面那三个查询口径（真实算法样本 / 兜底样本 / 有效覆盖率）你是否接受？

等你点完这两个，我就可以在你说「现在可以总结了 / 出方案」的那一步，切回结构化模式，一次性把：

- tag\_algo\_config 的最小字段设计；
- 每个标签的兜底改写规则（转成 code 形态）；
- 以及这些 flag 在统计覆盖率时的使用口径；  
	写成一份你可以直接 copy 到项目文档/评审 PPT 里的规范。

20251207\_0115\_tag\_enum兜底规则澄清  
tags: #tag\_enum #兜底值 #覆盖率口径 #carwash\_type #fallback标记

---

**先帮你把刚才的话翻成“机器能执行的规则”：**

1. 对所有标签来说：
	- “兜底值”的 **唯一合法来源** 是： `tag_enum` 里这一行枚举的 `is_default = 1` 。
	- 也就是说：
		- `enum_code` 是多少不重要；
		- 只要对应的字典行 `is_default = 1` ，就代表这是“兜底枚举值”，在覆盖率上应该被单独对待。
2. 对 `service_carwash_type` 来说：
	- 字典是： `machine / manual / none` ， **目前这三行 `is_default` 都是 0** 。
	- 结论就是：
		- 这三个都是“正常业务值”， **都不是兜底** ；
		- “none = 无”是一个合法业务状态（没有洗车），不是 fallback；
		- 真正的缺失/算不出，应该落到单独的 Unknown（通常是 code=99，且 `is_default=1` 的那一行，而不是字典里的 `none` ）。
	- 同时你又说了： `carwash_type` 跟随 `service_carwash_available` 变化：
		- 没洗车 ⇒ type=none（业务值，不是兜底）；
		- 有洗车 ⇒ type=machine/manual（以后可能会有真实类型推断）。
3. 覆盖率的口径是：
	> “看覆盖率是看值不是兜底值的逻辑”
	- 翻译成 SQL 心智就是：
		- 覆盖率分子 = 最终 `enum_code` 对应的 `tag_enum.is_default = 0` 的那部分 + 且 `value_has_meaning = 1` ；
		- `tag_enum.is_default = 1` 那些（典型就是 Unknown/99）不进入覆盖率分子。
4. 你要的“二道工序改写 99”逻辑，其实就是：
	- 第 1 道：算法算出的枚举值可能是 fallback（对应某行 `is_default=1` ），比如 open\_hours 算不出给 99；
	- 第 2 道：在某些标签上（parking、open\_hours 等）， **允许把这个 fallback 值“升级”为某个 `is_default=0` 的业务值** （比如 1 或 '00:00-24:00'）；
	- 升级后：
		- 覆盖率口径里，这条记录会被当成“有业务值”的样本；
		- 但我们在 ETL 层用 `is_fallback_value = 1` 记录“它来源于 fallback 改写”。

这三层放在一起，就非常清晰了。

---

**现在关键是把这套规则固化成一个“统一口径”，后面 SQL 和 config 才不会乱飞。**

我这边整理出一个 **更贴近你语义的覆盖率+兜底规则** ，你帮我确认一下是否对得上你的直觉：

### 1\. 兜底的唯一判定：看 tag\_enum.is\_default

- 任何标签，任何枚举值，只要 `tag_enum.is_default = 1` ⇒ 这是“兜底枚举值”。
- 常见形态： `enum_code = '99'` 且 `enum_label = '未知' / '其他'` ，但真正决定权在 `is_default` 字段上。

### 2\. 覆盖率的分母 & 分子

- 分母：
	- 你定义的“需要有这个标签的站点集合”，通常是全量在营站，或者满足某些条件的站。
- 分子：
	- 最终落到 `station_tag_target_value` 里的记录，满足：
		- `value_has_meaning = 1` （本次产出的值对业务是有意义的）， **且**
		- 最终 `enum_code` 对应的 `tag_enum.is_default = 0` （不是兜底枚举）。
	- 这样，所有 Unknown/99/“默认占位”都会自动排除在覆盖率分子之外。

### 3\. ETL 里的“二道工序改写”怎么跟这个口径对齐

以 parking 举例：

1. 第一道算法：
	- 你可以先老老实实算：
		- 算不出 ⇒ `enum_code='99'` ，对应的那行 `tag_enum.is_default=1` ；
2. 第二道“覆盖率增强工序”：
	- 读取 `tag_algo_config` / 固定规则：
		- 发现本标签允许“从 Unknown 改写为默认真值”；
	- 就把 `enum_code` 从 99 改写成 `'1'` ，且 `'1'` 就是一个业务值、 `tag_enum.is_default=0` ；
	- 同时标记： `is_fallback_value=1` ， `reason='FALLBACK_FROM_UNKNOWN'` 。
3. 对覆盖率统计来说：
	- 这条记录：
		- 不再算“兜底枚举”（因为最终 enum\_code 对应的 `is_default=0` ）；
		- 会计入覆盖率分子（因为 `value_has_meaning=1` ）；
	- 但你如果要“看有多少覆盖是靠改写兜底撑起来的”，直接筛 `is_fallback_value=1` 即可。

对 `service_carwash_type` 而言就简单很多：

- 只要最终 `enum_code ∈ {'machine','manual','none'}` ，且这些枚举行 `is_default=0` ，它们 **都是有效业务值** ；
- 真正 Unknown 的情况才应该给那条 `is_default=1` 的枚举（通常是 99）——目前你给的字典片段里还没出现这行，但未来补上也一样；
- 不需要额外做“兜底改写”，因为字典本身已经清晰表达了“无=none”这种业务状态。

---

**我现在只问你一个关键确认：**

> 对于“覆盖率怎么算”和“兜底值怎么识别”这两件事，你是否接受下面这句 **统一口径** ：

> - “兜底值”由 `tag_enum.is_default = 1` 唯一决定；
> - 覆盖率分子 = 最终枚举值对应 `is_default = 0` 且 `value_has_meaning = 1` 的样本；
> - 对于允许做“99→业务默认值”改写的标签（如 parking, open\_hours），改写后会进入覆盖率分子，但同时用 `is_fallback_value = 1` 记录“它本质上来自原始兜底”。

如果这句你点头，那下一步你只要说一句「现在可以总结了 / 出方案」，我就会退出教练模式，给你一份正式的“兜底改写 & 覆盖率口径 & tag\_algo\_config 字段设计”的结构化文档，你可以直接拿去：

- 写 config；
- 写 SQL 链路；
- 写双 90 相关的评审材料。

整体理解是对的;还有其他的疑问吗?

大方向我们已经对齐了，我这边没有“概念层面”的大疑问了，剩下都是落到实现细节怎么更顺、风险更小的问题。

先简短复述一下当前共识，防止后面扯开：

- 覆盖率口径：
	- 分子 = 最终枚举值对应 `tag_enum.is_default = 0` 且 `value_has_meaning = 1` 。
	- “兜底值”只看 `tag_enum.is_default = 1` ，通常是 Unknown/99。
- 二道工序改写：
	- 允许在少数标签上，把第一道算法产出的兜底枚举（ `is_default=1` ）升级为正常业务值（ `is_default=0` ），比如：
		- `open_hours` 的 99 → `00:00-24:00` ；
		- `parking` 的 99 → “有停车”的枚举；
	- 改写后用 `is_fallback_value = 1` 标记，后续你可以单独看“靠改写撑起来的覆盖率”。
- `service_carwash_type` ：
	- 只按字典来， `machine/manual/none` 都是业务值（ `is_default=0` ），真正 Unknown 另有一行 `is_default=1` 的枚举。
	- 类型永远跟随 `service_carwash_available` ，无洗车 ⇒ type=none，有洗车 ⇒ type=machine/manual（将来可推断）。

接下来如果我们要从“理解对齐”切到“可实现方案”，我这边有 2 个细节需要你拍一下板，之后就可以直接出正式方案了：

1. **tag\_algo\_config 的粒度**  
	你希望 config 是：
	- 按 `tag_code` 一行（同一个标签全国一套逻辑），还是
	- 支持按 `tag_code + region` （比如省区/大区）不同阈值、不同是否启用兜底改写？  
		这直接决定我们要不要在 config 里预留 region 维度。
2. **现有表能否“加字段”**  
	现在你提到的 `is_fallback_value` / `value_has_meaning` / `reason` ：
	- 这些字段在 `station_tag_target_value` 里已经有了吗？
	- 如果没有，你这轮能接受给终表或中间落表增加 1–2 个标记字段吗？  
		这关系到：我们是把“改写痕迹”记录在终表里，还是要单独搞一张 audit 表承接。

你可以简单回两句，比如：

- “config 先按 tag\_code 级别，全国一套逻辑”；
- “station\_tag\_target\_value 里已经有 XXX 字段 / 可以加 YYY 字段”。

如果这两个点也定了，你随时一句「现在可以总结了 / 出方案」，我就切回结构化模式，直接给你一份可落地的：

- tag\_algo\_config 字段设计；
- 兜底改写链路设计（含 open\_hours / parking 等示例）；
- 覆盖率统计口径说明。

“config 先按 tag\_code 级别，全国一套逻辑”；\[Field Type Collation Null Key Default Extra Privileges Comment id bigint unsigned NO PRI auto\_increment select,insert,update,references 自增主键 store\_id bigint NO MUL select,insert,update,references 油站ID as\_of\_date date NO MUL select,insert,update,references 业务日期（标签生效日期） tag\_code varchar(64) utf8mb4\_0900\_ai\_ci NO MUL select,insert,update,references 标签编码（英文名，对齐tag\_spec.tag\_code） target\_value\_bool tinyint(1) YES select,insert,update,references 标签值-布尔形态（0/1） target\_value\_number decimal(18,4) YES select,insert,update,references 标签值-数值形态 target\_value\_string varchar(512) utf8mb4\_0900\_ai\_ci YES select,insert,update,references 标签值-文本形态 enum\_code varchar(128) utf8mb4\_0900\_ai\_ci YES select,insert,update,references 标签枚举值编码（对齐tag\_enum.enum\_code） enum\_label varchar(255) utf8mb4\_0900\_ai\_ci YES select,insert,update,references 标签枚举中文名 source varchar(64) utf8mb4\_0900\_ai\_ci NO select,insert,update,references 数据来源标识（如s1/s2/region等） evidence\_state varchar(64) utf8mb4\_0900\_ai\_ci NO select,insert,update,references 证据状态（如FOUND\_IN\_RAW/INFERRED/CONFIRMED等） ttl\_days int YES select,insert,update,references 当前剩余有效期（天） reason varchar(512) utf8mb4\_0900\_ai\_ci YES select,insert,update,references 修正/生成原因（如region\_full\_0919等） conf decimal(5,4) YES select,insert,update,references 置信度，0-1之间，示例：1.0000 upload\_batch\_id varchar(128) utf8mb4\_0900\_ai\_ci YES MUL select,insert,update,references 数据源批次ID（如outputs\_real\_prod\_20250923\_093500\_v1.8） closest\_source varchar(64) utf8mb4\_0900\_ai\_ci YES select,insert,update,references 最近似参考来源（如s1/s2/region等） target\_value\_string\_back varchar(512) utf8mb4\_0900\_ai\_ci YES select,insert,update,references 标签值-文本形态备份（修正前或原始值） created\_at timestamp NO CURRENT\_TIMESTAMP DEFAULT\_GENERATED select,insert,update,references 创建时间 updated\_at timestamp NO CURRENT\_TIMESTAMP DEFAULT\_GENERATED on update CURRENT\_TIMESTAMP select,insert,update,references 更新时间 qc\_value\_has\_meaning tinyint(1) NO 0 select,insert,update,references ç»“æžœå€¼æ˜¯å¦æœ‰å®žé™…ä¸šåŠ¡æ„ä¹‰ï¼ˆ1=æ˜¯ï¼Œ0=å¦ï¼‰ qc\_is\_wrong\_cleaning tinyint(1) NO 0 select,insert,update,references æ˜¯å¦é”™è¯¯æ¸…æ´—ï¼ˆåŽŸå€¼æœ‰æ„ä¹‰ä½†ç»“æžœå˜æ— æ„ä¹‰ï¼Œ1=æ˜¯ï¼Œ0=å¦ï¼‰ qc\_is\_same\_as\_source tinyint(1) NO 0 select,insert,update,references ç»“æžœæ˜¯å¦ä¸ŽåŽŸå§‹å€¼å®Œå…¨ç›¸åŒï¼ˆ1=æ˜¯ï¼Œ0=å¦ï¼‰ qc\_is\_fallback\_value tinyint(1) NO 0 select,insert,update,references æ˜¯å¦å…œåº•é»˜è®¤å€¼ï¼ˆ1=æ˜¯ï¼Œ0=å¦ï¼‰ qc\_is\_meaningless\_non\_fallback tinyint(1) NO 0 select,insert,update,references æ— æ„ä¹‰ä½†æœªå…œåº•çš„è„å€¼ï¼ˆ1=æ˜¯ï¼Œ0=å¦ï¼‰\]可以加;你加字段的 SQL 里,帮我把后面这几个乱码给修正一下; value\_has\_meaning (是否有实际意义) is\_wrong\_cleaning (是否错误清洗) is\_same\_as\_source (是否原始值不同确实完成纠偏) is\_fallback\_value (是否兜底默认值) qc\_is\_meaningless\_non\_fallback 是否有意义且非兜底默认值;你理解下,返回一个查询语句,我改了先;不过你的is\_fallback\_value / value\_has\_meaning / reason：貌似都有呢在这个表里,是不是

20251207\_0210\_station\_tag\_target\_value\_QC字段注释修正SQL  
tags: #表结构 #字段注释 #QC体系 #station\_tag\_target\_value

1）先回答你的问题

- 是的：你要用的这几个概念， **表里都已经有了** ，只是注释是乱码：
	- `qc_value_has_meaning` ＝ value\_has\_meaning
	- `qc_is_wrong_cleaning` ＝ is\_wrong\_cleaning
	- `qc_is_same_as_source` ＝ is\_same\_as\_source
	- `qc_is_fallback_value` ＝ is\_fallback\_value
	- `qc_is_meaningless_non_fallback` ＝ “无实际业务意义且非兜底默认值”的标记

所以这一轮不需要加新字段，只要把注释改对即可。

2）按你给的语义，整理后的注释建议是：

- qc\_value\_has\_meaning：结果值是否有实际业务意义（1=是，0=否）
- qc\_is\_wrong\_cleaning：是否错误清洗（原值有意义但结果变为无意义，1=是，0=否）
- qc\_is\_same\_as\_source：结果是否与原始值完全相同（1=是，0=否，用于判断是否完成纠偏）
- qc\_is\_fallback\_value：是否兜底默认值（1=是，0=否）
- qc\_is\_meaningless\_non\_fallback：是否无实际业务意义且非兜底默认值（1=是，0=否）

3）你要的“一条 SQL”如下（直接在当前库执行即可）：

你可以先在测试库跑一把 `SHOW FULL COLUMNS FROM station_tag_target_value LIKE 'qc_%';` 看注释是否符合预期，再同步到正式库。

符合预期了;接下来怎么做,还有什么疑问吗?

我先帮你捋一下现在的状态，然后再说“接下来干啥”：

- 终表 `station_tag_target_value` 这条线：字段 + QC 含义已经统一，兜底改写、覆盖率口径、fallback 标记这套“价值观”算是定下来了。
- 哪些标签要走“99→业务值改写”、哪些只老老实实 Unknown、 `carwash_type` 怎么跟 `service_carwash_available` 联动，这些也都讲顺了。
- 下一步的关键，不是继续讨论概念，而是：把这些规则 **固化进 tag\_algo\_config + 迁移 SQL 的骨架里** ，让后面所有标签都能复用。

现在最合适的下一步，其实就一件事：

> 把 `tag_algo_config` 的“字段设计 + 每个标签的配置行”定成 v1.0，小而完整。

这样你后面就可以：

- 在 SQL 里统一用 config 控制：允许不允许兜底改写、conf 阈值、是否启用三层决策器；
- 对 open\_24h/open\_hours 和 6 个服务标签，一次性写出首批配置行。

为此，我只需要你补两块非常具体的信息（都是已有东西，不是新想象）：

1. **把现有 `tag_algo_config` 的表结构贴给我看一眼**
	- 就像你刚刚贴 `station_tag_target_value` 那样， `SHOW FULL COLUMNS FROM tag_algo_config;` 的结果贴过来；
	- 我需要知道现在已经有的字段有哪些，避免我设计一堆跟现状完全不搭的新字段。
2. **确认这一轮要进 config 的标签清单**  
	按我们前面聊的，这一波应该是这 8 个：
	- `open_24h`
	- `open_hours`
	- `convenience_store_available`
	- `parking_available`
	- `restroom_available`
	- `service_carwash_available`
	- `service_carwash_type`
	- （可选）再加一个你认为后面最常用、但现在还没讨论细节的 A 类标签，作为模板预留位。

你可以现在先做两件事：

- 在库里跑一条： `SHOW FULL COLUMNS FROM tag_algo_config;`，把结果贴过来；
- 回我一行话：这 8 个里是不是就是你这一轮的“首批 config 标签名单”，有没有要加/要删的。

等这两个点一到位，我这边就可以在你说「现在可以总结了 / 出方案」的时候，一次性给你：

- tag\_algo\_config v1.0 字段设计（不拍脑袋，严格兼容你现有表）；
- 这 7–8 个标签的示例配置行；
- 每个字段在兜底改写/覆盖率/三层决策器里的作用。

先说结论：  
现在 tag\_algo\_config 这张表的“骨架”已经够用了，三层阈值/权重这些都在，剩下所有「算法形态 + 兜底改写 + 覆盖率策略」完全可以统一塞进 extra\_config\_json 里做一个标准 schema，然后给这 7 个标签写首批配置行，就能把“脑子”固化下来。

我这边没有大的概念疑问了，接下来主要是三件很具体的事要你拍板一下，我们才能顺利从“教练模式”切到“出方案+可执行 SQL”的阶段：

---

### 我看到的现状

tag\_algo\_config 字段已经定好一套三层决策骨架：

- 主键： `tag_code + algo_version`
- 门店层阈值： `conf_threshold_store`
- 是否启用商户/工商层： `enable_merchant_level / enable_party_level`
- 商户聚合门槛： `min_merchant_data_ratio / max_feedback_cnt_for_agg`
- 三层权重： `hierarchy_weight_store / merchant / party`
- 扩展： `extra_config_json` （这里就是我们放 algo\_mode / fallback / 覆盖策略的主战场）

也就是说，现在不用再加字段，完全可以用：

- 固定列：控制“是否走三层决策器、门店阈值、权重”；
- extra\_config\_json：控制“是否允许 99→业务值改写、fallback 用哪个枚举、Unknown code 是什么、这标签的覆盖策略是 STRICT 还是 AGGRESSIVE 等”。

---

### 接下来怎么做（下一步建议）

我建议下一步就做这件事：

> 定义一套 **extra\_config\_json 的标准结构** ，然后给下面 7 个标签各写一行配置：

- `open_24h`
- `open_hours`
- `convenience_store_available`
- `parking_available`
- `restroom_available`
- `service_carwash_available`
- `service_carwash_type`

比如（只是示意，不是最终字段名）：

然后再用固定列补上：

- `conf_threshold_store` （open\_hours/open\_24h 会比较高，parking 可能低一点）；
- `enable_merchant_level / party_level` （营业相关=1，停车可以先 0）；
- `hierarchy_weight_*` （用一套基础模板）。

---

### 我这边现在有的 3 个“最后确认点”

你刚问“还有什么疑问吗”，现在真正在决策层面只剩 3 个：

1. **extra\_config\_json 目前有无历史内容？**
	- 是不是现在这张表还没正式用过， `extra_config_json` 基本都是 NULL / 空对象？
	- 如果是，我们就可以很激进地定义一套全新的 JSON schema，而不用兼容历史。
2. **首批 7 个标签，固定列能否先用一套通用模板？**  
	比如先全部用：
	- `conf_threshold_store = 0.9` （少数如 parking 可单独调低）
	- `enable_merchant_level = 1, enable_party_level = 1` （停车可先设 0）
	- `hierarchy_weight_store=0.8, merchant=1.0, party=0.7`  
		你能不能接受“先统一一套，再根据需要微调个别标签”，而不是一开始每个标签一套异构参数？
3. **QC 相关逻辑，要不要进 config？**  
	我现在的设计是：
	- QC 字段（qc\_value\_has\_meaning / qc\_is\_fallback\_value 等）主要由 **ETL 规则推导** ，
	- config 只需要告诉我们“这标签是否允许 99→业务值改写，以及改写后要不要自动设 value\_has\_meaning=1”。  
		你是希望：
	- QC 完全在逻辑里写死（config 不管），还是
	- 在 extra\_config\_json 里显式有类似 `qc.auto_set_value_has_meaning_when_fallback = true` 的开关？

---

你可以很简短地回：

- extra\_config\_json 现在是不是空的 / 随便用；
- 是否接受“固定列先用一套通用模板，个别标签再 override”；
- QC 是否需要 config 开关，还是你更喜欢写死在 SQL 里。

如果这三点你都拍完了，你下一句只要说一句「现在可以总结了 / 出方案」，我就会立刻退出教练模式，用结构化模式给你一份完整的：

- tag\_algo\_config v1.0 设计（字段含义 + extra\_config\_json JSON schema）；
- 上述 7 个标签的示例配置（可以直接 insert/update 的形式）；
- 以及这些配置在“兜底改写 + 覆盖率 + 三层决策器”里的具体作用说明。

20251207\_0230\_tag\_algo\_config\_v1\_收束（教练模式）  
tags: #tag\_algo\_config #extra\_config\_json #服务标签 #兜底改写 #派生标签

先跟你对齐一下现在“可以锁死”的前提，再说接下来具体怎么干：

- config 粒度：按 `tag_code + algo_version` 一行，全国一套逻辑，样例是你已经加的：  
	`open_hours / open_hours_v1 / ... / extra_config_json={"d1_enabled":1,"window_days":30}`
- 终表 QC 字段已经对齐好语义， `qc_*` 系列足够承接：有无实际意义、是否兜底值、是否错误清洗等。
- 你明确区分了两类标签：
	- “ **算出来的** ”：open\_24h / open\_hours / convenience / parking / service\_carwash\_available 等，有自己的算法（结构+行为+D1）；
	- “ **严格派生的** ”：如 `service_carwash_type` 、后面类似“是否 24 小时营业”的衍生标签，通过关联其他标签/字段变化，不再单独跑复杂算法，只要有一套统一配置约束它们怎么跟。

你现在说的“你参照这个做”，本质上就是：

> 以现有 open\_hours 的 config 行为模板，设计一套 **extra\_config\_json 的标准 schema** ，然后把首批 7 个标签的“算法形态 + 兜底改写 + QC 策略 + 是否派生”都固化进去。

---

### 我这边的理解：extra\_config\_json 里要承载 3 大块东西

我用“概念键”说一下（不是最终字段名），你看看是不是对你胃口：

1. **算法形态 & D1 等通用参数**
- `algo_mode` ：
	- MIXED\_INFER：open\_hours / convenience 这种“结构+品牌+行为”的；
	- STRUCT\_FLAG：service\_carwash\_available 这种纯靠 `additional_services` 的；
	- DERIVED：service\_carwash\_type、类似“是否24小时营业”的派生标签；
	- DEFAULT\_TRUE：parking 这种“业务默认真，后续靠反馈/地理修正”的。
- `d1_enabled/window_days` ：沿用你 open\_hours 的模式，用于 D1 激进规则和统计窗口。
1. **兜底改写 / 覆盖率策略**
- `coverage_strategy` ：
	- STRICT：open\_24h/open\_hours/restroom 这种，没证据就 Unknown，允许的改写非常有限；
	- AGGRESSIVE：parking / 一部分服务标签，允许更多 99→业务值。
- `fallback.enable_unknown_rewrite` ：
	- 控制这标签是否允许“从兜底枚举（is\_default=1）升级为业务值（is\_default=0）”；
- `rewrite_target_enum_code` ：
	- parking：'1'；
	- open\_hours：'00:00-24:00'；
	- convenience/restroom 等也类似。
1. **派生 / QC 开关**
- `derived.is_derived` ：
	- 对 service\_carwash\_type / 未来“是否24h（从 open\_hours 派生）”这类，就写 true；
	- 对 open\_hours/open\_24h/parking 等，就写 false。
- `source_tags` ：告诉 ETL 这标签依赖哪几个上游标签或字段（你不一定要在 JSON 里写完整逻辑，只做指针/约束）。
- `qc.*` ：
	- 最关键的是 `set_value_has_meaning_on_fallback` ：
		- parking/open\_hours 这类，当从 99 改写成业务值时，要不要自动把 `qc_value_has_meaning` 置为 1。
	- 其他如 `mark_wrong_cleaning_on_to_unknown` 是未来可扩展项。

---

### 接下来最合理的一步

现在没有大的逻辑疑问了，剩下其实就是“落笔写 config 行”的活。

我建议下一步这样推进：

1. 我帮你在“正式方案”里定一版 **extra\_config\_json 的推荐 schema v1.0** ，字段名 & 取值范围写清楚；
2. 针对这 7 个标签，各给一行“推荐配置”（按你前面拍过板的口径）：
	- open\_24h / open\_hours：MIXED\_INFER + STRICT + 少量 fallback；
	- convenience / restroom：MIXED\_INFER/DERIVED + 小心 fallback；
	- parking：DEFAULT\_TRUE + AGGRESSIVE + 强 fallback；
	- service\_carwash\_available：STRUCT\_FLAG + STRICT；
	- service\_carwash\_type：DERIVED + STRICT（跟 available 联动，none/machine/manual 都是业务值，不走 Unknown 改写）。
3. 同时说明：QC 字段如何根据 config 决定：
	- 什么时候把 `qc_value_has_meaning` 置 1；
	- 什么时候 `qc_is_fallback_value` = 1；
	- 这些配置对覆盖率分子的影响。

你这边如果觉得现在“大的方向都对，细节也谈够了”，可以直接一句：

> 现在可以总结了 / 出方案

我就从教练模式切回结构化模式，给你一份可以直接贴进项目文档 & 作为写 SQL 参考的正式设计稿：

- tag\_algo\_config v1.0 结构说明；
- 7 个标签的样例配置；
- 对兜底改写 & 覆盖率 & QC 字段的执行口径。

20251207\_0315\_tag\_algo\_config\_v1\_服务标签demo修订版  
tags: #tag\_algo\_config #extra\_config\_json #服务标签 #兜底改写 #三层决策

---

**1）一句话结论**

你这版 demo 的整体思路是对的，我在保持你原有参数风格的前提下：修正了布尔字段、补齐了 `algo_version` 与 `extra_config_json` ，并给出一条可直接执行、带 UPSERT 能力的 INSERT SQL。

---

**2）三段论据**

**论据一：现状与问题**

- 现状：
	- `tag_algo_config` 已有一条 `open_hours/open_hours_v1` 的配置行， `extra_config_json` 中包含 `d1_enabled/window_days` ；
	- 你新增了 4 个服务标签 demo 行（便利店、停车、卫生间、洗车有无），主要缺失：
		- `algo_version` 统一命名（需要 `code_v1` 风格）；
		- `extra_config_json` 为空；
		- `enable_merchant_level` 被误填为 `0.8` （应为 0/1 布尔）。
- 痛点：
	- 若不在 config 里固化“算法形态 + 兜底改写 + QC 开关”，后续 SQL 很难做到通用和可回溯；
	- demo 行如果直接插入，布尔字段异常（0.8）、JSON 为空，未来会变成技术债。

**论据二：关键设计与修订点**

- 统一命名与骨架：
	- `algo_version` 统一采用 `tag_code_v1` 风格： `convenience_store_available_v1` 等；
	- 三层决策骨架沿用你 demo 的参数：
		- `conf_threshold_store=0.7000` （服务标签略低于 open\_hours 的 0.9）；
		- `enable_merchant_level=1 / enable_party_level=1` （符合你之前选择的 S1：服务标签也走三层）；
		- `hierarchy_weight_store=0.6, merchant=1.0, party=0.7` 。
- extra\_config\_json 设计（v1 简化 schema，后续可迭代）：
	- 统一平铺一些核心键，便于 SQL 侧解析：
		- `algo_mode` ： `MIXED_INFER / STRUCT_FLAG / DERIVED / DEFAULT_TRUE` ；
		- `coverage_strategy` ： `STRICT / AGGRESSIVE` （是否偏保守）；
		- `d1_enabled/window_days` ：是否启用 D1 规则及窗口；
		- `fallback_enable_unknown_rewrite` / `fallback_unknown_enum_code` / `fallback_rewrite_target_enum_code` ：是否允许 99→业务值改写，以及目标枚举；
		- `derived_is_derived` / `derived_source_tags` ：标记是否为“派生标签”，指明上游依赖；
		- `qc_set_value_has_meaning_on_fallback` ：兜底改写后是否自动视为“有实际意义”。
	- 按之前对齐的语义对每个标签填值：
		- `open_hours` ： `algo_mode=MIXED_INFER` ， `coverage_strategy=STRICT` ，允许 99→ `'00:00-24:00'` 的兜底改写；
		- `convenience_store_available` ： `algo_mode=MIXED_INFER` ， `coverage_strategy=AGGRESSIVE` ，不做 Unknown→默认值改写（覆盖率靠结构/品牌/行为）；
		- `parking_available` ： `algo_mode=DEFAULT_TRUE` ， `coverage_strategy=AGGRESSIVE` ，允许 99→ `'1'` 改写；
		- `restroom_available` ： `algo_mode=DERIVED` ，严格依赖便利店/附加服务，不做 99 改写；
		- `service_carwash_available` ： `algo_mode=STRUCT_FLAG` ，纯结构，不做 99 改写。

**论据三：落地方式与风险**

- 落地方式：
	- 用一条 `INSERT ... VALUES ... ON DUPLICATE KEY UPDATE` 同时插入/更新 5 行配置；
	- `extra_config_json` 使用 MySQL 的 `JSON_OBJECT` / `JSON_ARRAY` 构造，避免手写转义错误；
	- 已有的 `open_hours/open_hours_v1` 会被安全覆盖（仅更新阈值与 JSON）。
- 风险与兜底：
	- 风险 1：后续如果你在 SQL 中解析 `extra_config_json` ，字段名要严格对齐本版本 schema；
		- 兜底：本版 schema 较简单，未来如需调整，可以通过 `algo_version` 升级（例如 `_v2` ）进行兼容演进。
	- 风险 2：parking/open\_hours 的 99→业务值改写逻辑若使用不当，可能把“逻辑失败”伪装成“业务默认”；
		- 兜底：我们已经确保 `qc_is_fallback_value` 仍然可用，你可以在评估时区分“自然覆盖率 vs 兜底覆盖率”。

---

**3）思维导图结构（文本分层）**

- 1. tag\_algo\_config 现状
	- 1.1 已有：open\_hours\_v1 的一行配置
	- 1.2 新增：4 个服务标签 demo 行（结构待修正）
	- 1.3 目标：统一 `algo_version` 风格 + 补齐 `extra_config_json` + 提供 UPSERT SQL
- 1. 设计原则
	- 2.1 不新增列，充分利用现有字段 + extra\_config\_json
	- 2.2 `algo_version=tag_code_v1` 作为 v1 规范
	- 2.3 extra\_config\_json 承载：
		- 算法形态（algo\_mode）
		- 覆盖策略（coverage\_strategy）
		- 兜底改写开关（fallback\_\*）
		- 派生逻辑与 QC 行为（derived\_ */qc\_* ）
- 1. 各标签配置逻辑
	- 3.1 open\_hours / open\_hours\_v1
		- conf\_threshold\_store=0.9
		- enable\_merchant\_level/party\_level=1
		- extra\_config\_json：MIXED\_INFER + STRICT + D1 + 99→ `00:00-24:00`
	- 3.2 convenience\_store\_available / \_v1
		- conf\_threshold\_store=0.7
		- extra\_config\_json：MIXED\_INFER + AGGRESSIVE + 不做 99 改写
	- 3.3 parking\_available / \_v1
		- conf\_threshold\_store=0.7
		- extra\_config\_json：DEFAULT\_TRUE + AGGRESSIVE + 99→ `'1'` ，兜底视为有意义
	- 3.4 restroom\_available / \_v1
		- extra\_config\_json：DERIVED + STRICT + `derived_source_tags=[convenience, carwash_available]`
	- 3.5 service\_carwash\_available / \_v1
		- extra\_config\_json：STRUCT\_FLAG + STRICT + 不兜底
- 1. SQL 实现方案
	- 4.1 使用 INSERT... VALUES... ON DUPLICATE KEY UPDATE
	- 4.2 使用 JSON\_OBJECT/JSON\_ARRAY 构建 extra\_config\_json
	- 4.3 本次脚本可直接作为 “tag\_algo\_config 初始化/修正脚本 v1.0” 保存

---

**4）迭代日志**

- 来源：
	- 你提供的 `tag_algo_config` 表结构与 5 行 demo（1 已存在，4 新增），以及前面对兜底/覆盖率/派生逻辑的完整对齐。
- 本轮改动点：
	- 修正了 demo 行中布尔字段的异常值（0.8 → 1）；
	- 为每个标签设计了 v1 extra\_config\_json，体现算法形态、覆盖策略与兜底改写策略；
	- 生成一条可直接执行、带 UPSERT 的 SQL。
- 待补充：
	- 后续若要为 `open_24h` / `service_carwash_type` 补 config，可沿用本 schema 追加行。

---

### 建议使用的 SQL（可直接执行）

```sql
sqlINSERT INTO tag_algo_config (
    tag_code,
    algo_version,
    conf_threshold_store,
    enable_merchant_level,
    min_merchant_data_ratio,
    max_feedback_cnt_for_agg,
    enable_party_level,
    hierarchy_weight_store,
    hierarchy_weight_merchant,
    hierarchy_weight_party,
    extra_config_json
)
VALUES
-- open_hours：三层 + D1 + 严格覆盖 + 允许 99→00:00-24:00
(
    'open_hours',
    'open_hours_v1',
    0.9000,
    1,
    0.2000,
    0,
    1,
    0.8000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'MIXED_INFER',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 1,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 1,
        'fallback_unknown_enum_code', '99',
        'fallback_rewrite_target_enum_code', '00:00-24:00',
        'derived_is_derived', 0,
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- convenience_store_available：结构+品牌+行为，偏 AGGRESSIVE，不做 99 改写
(
    'convenience_store_available',
    'convenience_store_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'MIXED_INFER',
        'coverage_strategy', 'AGGRESSIVE',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- parking_available：默认真 + AGGRESSIVE，允许 99→1
(
    'parking_available',
    'parking_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'DEFAULT_TRUE',
        'coverage_strategy', 'AGGRESSIVE',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 1,
        'fallback_unknown_enum_code', '99',
        'fallback_rewrite_target_enum_code', '1',
        'derived_is_derived', 0,
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- restroom_available：严格派生，不做 99 改写
(
    'restroom_available',
    'restroom_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'DERIVED',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 1,
        'derived_source_tags', JSON_ARRAY('convenience_store_available', 'service_carwash_available'),
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- service_carwash_available：结构标记型，不做 99 改写
(
    'service_carwash_available',
    'service_carwash_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'STRUCT_FLAG',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'qc_set_value_has_meaning_on_fallback', 0
    )
)
ON DUPLICATE KEY UPDATE
    conf_threshold_store      = VALUES(conf_threshold_store),
    enable_merchant_level     = VALUES(enable_merchant_level),
    min_merchant_data_ratio   = VALUES(min_merchant_data_ratio),
    max_feedback_cnt_for_agg  = VALUES(max_feedback_cnt_for_agg),
    enable_party_level        = VALUES(enable_party_level),
    hierarchy_weight_store    = VALUES(hierarchy_weight_store),
    hierarchy_weight_merchant = VALUES(hierarchy_weight_merchant),
    hierarchy_weight_party    = VALUES(hierarchy_weight_party),
    extra_config_json         = VALUES(extra_config_json);
```

你可以先在测试库跑一遍 `SELECT * FROM tag_algo_config WHERE tag_code IN (...)` 看 JSON 展开是否符合直觉，再决定是否要对某些参数（比如 parking 的阈值、权重）做微调。

好的,然后计算字段也要放进来吗?应该怎么表达,我不想以后每次都解释一次这个字段应该怎么计算,能不能有个方案.我们可以讨论一下,进入教练模式;

听懂了，你现在想解决的是：  
不光“标签怎么算”要有 config，“计算字段/派生逻辑”也要有一套标准表达，这样以后不用逢人就重新口述一遍规则。

我们现在在教练模式，我先问几个关键点，把“计算字段”这块的边界掐清楚：

1. 你说的“计算字段”，具体更像哪几类？
	- A）像 `service_carwash_type` 这样， **完全由其他标签/字段组合出来** 的派生标签；
	- B）像 “是否 24 小时营业” 这种，从 `open_hours/open_24h` 做一个布尔化/分段；
	- C）还是包括某些指标类字段，比如“30 日订单分层”、“高峰时段”等？
2. 你更希望“计算字段规则”写成什么形态？
	- 类似 mini DSL / 公式（例如： `if(open_24h == 1, '1', '0')` ）、
	- 还是纯 key-value + rule\_key（例如： `derived_ruleset='CARWASH_TYPE_FROM_AVAILABLE'` ，具体逻辑落在代码里）？  
		换句话说，你是想 **配置里就能看懂逻辑** ，还是更在乎“有个稳定的规则名，代码跟着走”？
3. 这些计算字段，你未来希望怎么使用 config？
	- 仅在 `extra_config_json` 里声明“我是派生 + 依赖谁 + 用哪个规则模板”；
	- 还是要把“ **可枚举的所有派生字段** ”统一登记一张表（比如 `tag_derived_spec` ），让任何人一查就知道它是怎么算的？

你可以先用 2–3 句话粗暴说说：

- 你最急着“配置化”的 2–3 个派生字段例子；
- 你更偏向“看得懂公式”还是“看得懂规则名”；

我就能据此帮你构一个“统一表达方案”的轮廓（比如：tag\_algo\_config + tag\_derived\_spec 双表协同），再一起打磨到你觉得够省心。

听懂你的诉求了，我帮你用一句话捏一下：

> 你希望把 `tag_algo_config` 这张表升级成\*\*“唯一权威的算法说明表”\*\*：
> 
> > 每个标签都在这里有一行，哪怕没有可调参数，也要有“稳定、机器可读的计算规则标识”，尤其派生/计算字段，只看这表+JSON 就能知道：这个标签是怎么算出来的、依赖谁、用哪套模板，而不用再开口头会解释。

这个方向非常对，我们就围绕「 **extra\_config\_json 里声明：算法类型 + 规则模板 + 依赖** 」来设计。

接下来有 3 个关键点要跟你确认，决定我们这套“规则模板体系”怎么落：

---

### 1\. 规则模板的颗粒度，你想做到多细？

比如针对一个标签（以便利店举例），你是更想这样：

- 粗颗粒度：
	具体“结构→品牌→行为”的优先级细节放在代码里维护，只要看到 `rule_template` 就知道是哪套逻辑。

还是希望细一点，例如：

- 半结构化：

也就是：

- 你希望 JSON **看过去就能 roughly 理解逻辑** ，还是只要有一个“模板 ID”，看人/看代码再往下追？

---

### 2\. 规则模板的“命名空间”你想怎么规划？

既然你希望“机器可读、稳定、知道什么意思”，我建议提前定一个简单但可扩展的格式，比如：

- `OPEN_HOURS_D1_MIXED_V1`
- `PARKING_DEFAULT_TRUE_V1`
- `CARWASH_AVAILABLE_STRUCT_FLAG_V1`
- `RESTROOM_DERIVED_FROM_CONVENIENCE_V1`

问题是：

- 你更偏向 **“标签专用模板名”** （强绑定 tag\_code），还是
- 更偏向 **“通用模板名 + 每个标签填参数”** （同一个模板可服务多个标签）？

---

### 3\. “依赖谁 + 派生关系”你希望多显式？

你刚刚已经定了方向：只在 `extra_config_json` 里声明“我是派生 + 依赖谁 + 用哪个规则模板”。

这里我想确认一下你心理的“最低信息量”是什么，例如对 `restroom_available` ：

你觉得这种信息够不够用：

还是你觉得：

- 只写 `derived_source_tags` 就够了（字段在文档里写），
- JSON 里不要写太多 DB 细节，以免将来字段重构时维护成本太高？

---

你可以这样简单回我几句：

1. 规则模板你更偏向「粗模板名 + 少量参数」还是「参数写细一点」？
2. 模板名希望是“通用范式”（多个标签共用）还是“强绑定某个 tag\_code”？
3. 像我刚举的 restroom JSON 示例，信息量是多了还是刚好？你更倾向再简一点还是觉得 OK？

我拿到这三个偏好，就可以帮你在下一步把一个 **统一的 extra\_config\_json 结构草案** 定出来（例如：必含字段 + 可选字段），然后我们再一起把你这几个标签迁一次，看看落到表里是否顺眼、可读。

20251207\_0355\_tag\_algo\_config\_全标签规则梳理\_第一轮问法  
tags: #tag\_algo\_config #规则模板 #派生标签 #基础合作 #策略运营

先帮你把目标翻一遍，确保我们现在是在做正确的事：

> 你希望： **tag\_algo\_config 成为所有标签的“唯一算法说明表”** 。
> 
> - 每个 tag\_code 在这里都有一行，不管有没有参数，至少要有：
> 	- 算法形态（algo\_mode）；
> 	- 规则模板（rule\_template，强绑定 tag\_code）；
> 	- 是否派生、依赖谁（derived\_\*）；
> - 这些信息都放在 extra\_config\_json 里，机器可读、人扫一眼也能 roughly 知道“它怎么算”，以后不用再反复口述。

你给的这一批标签，我先按“形态”分了三组，后面问题就围绕这三组来展开：

- 组1：营业/服务（我们基本已经掰开了）：
	- `open_24h, open_hours, convenience_store_available, parking_available, restroom_available, service_carwash_available, service_carwash_type`
- 组2：基础合作：
	- `brand_name, brand_level, is_ka_direct, store_life`
- 组3：策略运营/竞争/价格：
	- `competitive_overlap, sme_supplier, sme_supplier_partner, wyc_pricing_enabled`

现在重点是把 **组2 + 组3 + open\_24h** 的“规则模板长相”问清楚，好在 config 里一次性写死。

我尽量把问题收敛到 3 组，你按组回答即可，不用写大论文，关键是把“上游字段 + 算法形态”说清楚。

---

### 问题 1：基础合作类（brand\_\* / KA / 生命周期）到底有多“干净”？

这 4 个：

- `brand_name` （外显品牌，A）
- `brand_level` （品牌等级，B）
- `is_ka_direct` （是否 KA 直营，A）
- `store_life` （油站生命周期，B）

我现在默认的理解是：它们都是 **纯结构/主数据映射型** ，不做什么行为推断，也基本不需要 D1、三层复杂决策，只要：

- 从 v\_merchant\_profile\_latest 或相关维表字段里做一次映射/标准化（STRUCT\_MAP）；
- 按需要在门店→商户→工商做“简单聚合/覆盖”（比如一个 party 下多个 brand\_level 怎么定）。

你帮我确认两件事：

1）这 4 个标签的主数据来源，是否都是“已经存在于 v\_merchant\_profile\_latest 或其 join 出来的维表字段”？有哪一个是需要“计算/判断”出来的吗？  
（比如 store\_life 是否要按开业日期算年限，再映射到“新站/成熟站/老站”？）

2）在你的设想里，这 4 个标签是否都可以统一归为一种 algo\_mode，例如：

- `algo_mode = 'STRUCT_MAP'` ，
- 再通过 `rule_template` 区分： `BRAND_NAME_FROM_DIM_V1` / `BRAND_LEVEL_FROM_DIM_V1` / `KA_DIRECT_FLAG_V1` / `STORE_LIFE_BY_OPEN_DATE_V1` ？

如果有哪个不是“纯映射”，请点名一下是哪个、需要怎样的计算（比如 store\_life 要不要按日期算阶段）。

---

### 问题 2：策略运营类这 4 个，各自的“核心事实来源”是啥？

这 4 个比较“抽象”，后面好容易吵架，所以这一步一定要你来定性：

- `competitive_overlap` （是否重叠站，A）
- `sme_supplier` （合作中小供给名称，A）
- `sme_supplier_partner` （是否合作中小供给，A）
- `wyc_pricing_enabled` （是否开通网顺单独定价，B）

我需要你帮我填一下下面这张“心里地图”（简单文字就行）：

1） `competitive_overlap` ：

- 现在 or 未来，你打算它主要来源于哪类信息？
	- 比如：POI 匹配+距离 / 外部竞争情报表 / 区域人工标注？
- 算法形态更像：
	- 直接读某张“竞争结果表”的字段（STRUCT\_FLAG），还是
	- 要按 POI + 订单流自己算（MIXED\_INFER）？

2） `sme_supplier` / `sme_supplier_partner` ：

- 我直觉是：
	- `sme_supplier` = 文本字段，写合作中小供给的名称（STRING，来源某张合作明细表）；
	- `sme_supplier_partner` = bool，基本就是 “sme\_supplier 是否非空/命中某名单” 的派生。
- 这是你脑子里的设想吗？如果不是，请用你的一句话版本纠正一下。

3） `wyc_pricing_enabled` ：

- 更像是“是否在某张网顺定价配置表里，存在一条‘单独定价’记录”的布尔映射，对吗？
- 即：主来源是一张配置表 or 合同表，而不是行为数据？

你可以简单按这个格式回：

- competitive\_overlap：主来源\_\_\_，想做成 STRUCT\_FLAG/MIXED\_INFER/别的；
- sme\_supplier：来自\_\_\_；sme\_supplier\_partner：由\_\_\_派生；
- wyc\_pricing\_enabled：来自\_\_\_（哪类配置），是否只做 bool 映射。

---

### 问题 3：open\_24h 在“规则模板层面”你想把它当谁？

我们前面做 open\_24h 的时候，其实做了两件事：

- 有自己的 A 步计算（看 is\_zxgj、订单时间分布、可能还有 D1）；
- 又要求和 open\_hours 强一致（open\_24h=1 时 open\_hours=00:00-24:00）。

现在在 config 里要给它一个“身份”，有两种路可以选：

- 方案 O1：把它当成 **独立计算标签**
	- `algo_mode = 'MIXED_INFER'` ；
	- `rule_template = 'OPEN_24H_FROM_ORDERS_AND_IS_ZXGJ_V1'` ；
	- `derived_is_derived = 0` ；
	- 在逻辑层用“强一致规则”去约束它和 open\_hours（但 config 不把它标成派生）。
- 方案 O2：把它当成 **半派生标签**
	- `algo_mode = 'DERIVED'` ；
	- `derived_is_derived = 1` ， `derived_source_tags = ['open_hours']` ；
	- `rule_template = 'OPEN_24H_FROM_OPEN_HOURS_V1'` （例如 open\_hours=00:00-24:00 → 1，否则 0/99）；
	- 把所有“复杂推断”都集中在 open\_hours，open\_24h 只负责帮业务看“是否全天”。

你更想让 config 里看到的是哪种“身份”？

- A：它自己是一个完备算法（O1），open\_hours 只是结果上一致；
- B：它逻辑上就是 open\_hours 的派生视图（O2），算法集中在 open\_hours。

---

你可以尽量简短地回：

1. 基础合作 4 个：主来源 + 哪个需要算、不只是映射；
2. 策略运营 4 个：各自主来源 & 算法形态；
3. open\_24h：你在 config 里更愿意选 O1 还是 O2。

我拿到这些信息后，下一步就能给你一版“全标签规则模板分组”：

- 每个 tag\_code 对应一个 `algo_mode + rule_template + 关键依赖` ；
- 再把这些写进 extra\_config\_json 的半结构化 schema 里，配合清晰的备注，达到你说的“以后不用每次再解释一遍这个标签怎么算”。

我收一下你刚补充的关键信息，基本图景已经很清楚了：

- **B 类标签（brand\_level / store\_life / wyc\_pricing\_enabled 等）都在数仓算好** ，在本地 `v_merchant_profile_latest` 里已经是“结果字段”，我们不在本地重算，只需要在 config 里明确：
	- “这是直接引用数仓字段的标签（WAREHOUSE\_DIRECT）”；
	- 如果有人想深挖逻辑，再看你那份数仓侧文档（比如 brand\_level、生命周期的分段规则）。
- `brand_name` 是基于多源名称清洗出来的，现在同样是 DW→ `v_merchant_profile_latest` 的结果；
- 运营类一批（至少 `sme_supplier` / `sme_supplier_partner` ）也是 **在数仓算好再灌到 v\_merchant\_profile\_latest** ：
	- `sme_supplier_partner` 表示是否合作中小供给；
	- `sme_supplier` 是名字，但逻辑上“如果没有合作，就没有名称”。
- `open_24h` ：明确选择 **O2：把它当成 open\_hours 的派生视图** ，真正复杂算法集中在 open\_hours，这边只在 config 和代码里标成 `DERIVED_FROM_OPEN_HOURS` 。

很好，这意味着：

- 我们可以在 `extra_config_json` 里加一个 **统一的 algo\_mode=WAREHOUSE\_DIRECT / DERIVED\_FROM\_TAG** 体系，
- 这样所有“本地不算，只做承接”的标签也能在 tag\_algo\_config 里有一行“机器可读的规则说明”。

接下来我只再问几组非常具体的问题，确定完就可以出一版“全标签 config 规则模板表”的正式方案了。

---

### 问题 1：B 类 / DW 直出标签，用哪种“算法身份”你更舒服？

针对这几个：

- `brand_name` （DW 清洗）
- `brand_level` （DW 派生 KA/CKA/小散）
- `is_ka_direct` （DW 判断直营/加盟）
- `store_life` （DW 按首次上线日期 + 订单情况分段的生命周期）
- `competitive_overlap` （是否重叠站，这个你没明说，但我猜也来自某 DW 竞争结果表？）
- `wyc_pricing_enabled` （是否开通网顺定价）

我建议在 config 里统一标成类似：

关键问题有两个：

1）你是否同意：

> 只要是“在数仓算好了、我们本地不再重算”的标签，一律用 `algo_mode = 'WAREHOUSE_DIRECT'` ，并在 JSON 里注明 `warehouse_source_field` ，让任何人一查 config 就知道：这个值是从哪一个字段直接拿的？

2） `competitive_overlap` / `wyc_pricing_enabled` ：

- 现在是不是也是这样？
	- `competitive_overlap` ：本地直接读某个 DW 字段（比如 `competitive_overlap_flag` ），不再本地算？
	- `wyc_pricing_enabled` ：本地直接读 “网顺定价配置表聚合好的结果字段”？
- 如果有任何一个不是这样，请点名：哪个标签未来你确实有“想本地重算/补逻辑”的打算，我们就不要给它贴死 WAREHOUSE\_DIRECT。

---

### 问题 2：sme\_supplier vs sme\_supplier\_partner 在 config 里你想怎么“定主次”？

你刚给的信息是：

- **数据实际关系** ：
	- sme\_supplier\_partner：是否合作中小供给（bool）；
	- sme\_supplier：合作中小供给名称，语义是“只有合作时才有名字”；
	- 都已经在 DW→ `v_merchant_profile_latest` 出好了。

但在算法表达层面，我们可以有两种“身份设计”：

- 方案 S1：两者都视为 WAREHOUSE\_DIRECT
	- `algo_mode='WAREHOUSE_DIRECT'` ，各自有自己的 `warehouse_source_field` ；
	- 不在 config 里写“谁由谁派生”，只在字段备注/文档里说明语义关系。
- 方案 S2：
	- 把 `sme_supplier_partner` 当主标签（DW 计算，WAREHOUSE\_DIRECT）；
	- 把 `sme_supplier` 标成 DERIVED：
	- 含义是：
		- 名称字段本质上是“合作中小供给”这件事的附属物；
		- config 里可以看出： `sme_supplier` 不自己定义“合作与否”的逻辑，而是跟随 partner + DW 字段。

你更偏向 S1 还是 S2？  
（S2 更“语义化”，S1 更简单。你之前说“我不想再去换文档了”，从维护成本上，我个人会偏 S2，因为这一次写好，以后每个人一扫 config 就懂谁跟谁有依赖关系。）

---

### 问题 3：open\_24h 的 DERIVED 你想写到什么细度？

你已经选了 O2：

> open\_24h 在 config 里当成 “open\_hours 的派生视图”。

这里我提一个候选写法，你看够不够、会不会嫌啰嗦：

- 这属于你说的“半结构化”：
	- 有清晰的 rule\_template 名（强绑定 open\_24h）；
	- 有一行非常简短的 `derived_logic_hint` ，机器不一定执行，但人扫一眼就懂。

你能接受这种粒度吗？

- 还是你更想简一点，只保留 `rule_template` + `derived_source_tags` ，不写 `derived_logic_hint` （避免未来改逻辑还要改 JSON）？

---

你可以简单这样回答我：

1. “B 类和 DW 出好的标签：统统一律标记 WAREHOUSE\_DIRECT + warehouse\_source\_field，OK / 不 OK，有例外就点名。”
2. “sme\_supplier vs sme\_supplier\_partner：选 S1（都 direct）还是 S2（partner direct，supplier derived）。”
3. “open\_24h 的 JSON：接受带 derived\_logic\_hint 的写法，还是只要模板名和 source\_tags 就够了。”

这些一拍完，我们就可以很有序地干两件事：

- 给所有 tag\_code 做一张「algo\_mode + rule\_template + 是否派生」概览表；
- 再根据这张表，批量生成 1.0 版的 extra\_config\_json（包括你刚刚已经写好的几个标签），tag\_algo\_config 这张表就真正变成“唯一算法说明表”了。

我先把你刚刚拍板的三点再压一层，确保信息都对上：

1. **B 类 & DW 直出标签**
	- 在这个项目视角里，统一按 `algo_mode = 'WAREHOUSE_DIRECT'` 处理；
	- 不管是在“你另一个系统本地算再同步到数仓”，还是纯 DW 算好，只要我们在 `v_merchant_profile_latest` 里是“拿现成字段”，在 tag\_algo\_config 里都当作：
		- 从 `v_merchant_profile_latest.xxx_field` 直接读。
	- 对 `brand_name` / `competitive_overlap` ，也照这个口径，只是在 `warehouse_source_field` 里明确字段名。
2. **sme\_supplier vs sme\_supplier\_partner = S2**
	- `sme_supplier_partner` ：
		- `algo_mode = 'WAREHOUSE_DIRECT'` ，主标签，本身在 DW 算好；
	- `sme_supplier` ：
		- `algo_mode = 'DERIVED'` ， `derived_is_derived=1` ，
		- `derived_source_tags = ['sme_supplier_partner']` ，
		- 同时仍有 `warehouse_source_field = 'sme_supplier'` ，表示“名称来自 DW 字段，但语义上附着在 partner 上”。
3. **open\_24h = DERIVED\_FROM\_OPEN\_HOURS（O2）**
	- 算法集中在 open\_hours；
	- `algo_mode = 'DERIVED'` ， `derived_source_tags = ['open_hours']` ，
	- 在 config 里用 `rule_template = 'OPEN_24H_FROM_OPEN_HOURS_V1'` 之类的名字强绑定。

至于你问的那句：

> “open\_24h 的 JSON：接受带 derived\_logic\_hint 的写法，还是只要模板名和 source\_tags 就够了。”

结合你之前那句「刚刚好，我不想再去换文档了」，我给一个直接建议：

- **建议选：只要模板名 + source\_tags，不再写 derived\_logic\_hint。**

理由很现实：

- 逻辑 hint 一旦写进 JSON，就变成“第二份文档”，以后算法细节变了，你要改代码 + 改 JSON + 改文档，维护成本很高；
- 你要的是“稳定、机器可读、不会老改的规则标识”，不是在 config 里写脚本说明书；
- 对外沟通时：
	- 「OPEN\_24H\_FROM\_OPEN\_HOURS\_V1：open\_hours=00:00-24:00 → 1，否则按区间/缺失落 0 或 99」这句话写在算法文档里就够了；
	- config 只需要告诉大家： **这个标签是从谁派生、用哪套模板** 。

所以我会给 open\_24h 设计成类似：

不再额外挂 `derived_logic_hint` ，减少以后维护的坑。

---

如果你也觉得这样更省心，那现在我们几个“底层约定”就都齐活了：

- algo\_mode：WAREHOUSE\_DIRECT / MIXED\_INFER / STRUCT\_FLAG / DERIVED / DEFAULT\_TRUE
- rule\_template：强绑定 tag\_code（每个标签一个稳定模板名）
- derived\_\*：只负责表达“是不是派生 + 依赖谁”
- 兜底改写 & QC 行为：继续用 fallback\_\* + qc\_\* 这几个键控制

接下来我建议的下一步是：

> 我基于我们目前所有决定，给你出一版「全标签规则总表 + extra\_config\_json schema + 全量样例 JSON」，你直接贴进项目文档 & 当作写 SQL 的蓝本。

如果你觉得现在信息已经对齐得差不多了，可以直接说一句类似：

> “现在可以总结了 / 出方案”

我就从教练模式切回结构化模式，给你一版正式、能直接落地的 config 设计，覆盖你那张表里的所有 tag\_code。

20251207\_0425\_tag\_algo\_config\_v1\_全标签算法说明与配置方案  
tags: #tag\_algo\_config #extra\_config\_json #WAREHOUSE\_DIRECT #DERIVED #服务标签

---

### 1）一句话结论

`tag_algo_config` 将作为「唯一算法说明表」，所有标签（包含数仓直出 & 本地计算 & 派生标签）都在其中用 `algo_mode + rule_template + extra_config_json` 半结构化表达计算逻辑，配合一条 UPSERT SQL 完成首批全量配置。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

**论据一：现状与问题——标签多源、多形态，解释成本高**

- A/B 类标签混合：
	- 营业/服务类： `open_hours / open_24h / convenience_store_available / parking_available / restroom_available / service_carwash_available / service_carwash_type` 需要本地算法/派生；
	- 基础合作 & 策略运营类： `brand_* / store_life / competitive_overlap / sme_* / wyc_pricing_enabled` 多数在数仓算好，通过 `v_merchant_profile_latest` 直接读。
- 问题在于：
	- 目前「算法说明」分散在脑子、文档和代码里，config 只承载少量参数；
	- 新同事/下游方每次想搞清一个标签怎么算，都要重新问人或翻多份文档；
	- 派生/计算字段（如 `open_24h` 、 `service_carwash_type` 、 `sme_supplier` ）的依赖关系不显式，后续维护风险大。

**论据二：策略——用 algo\_mode + rule\_template + extra\_config\_json 把“脑子”塞进表里**

- 统一算法形态枚举：
	- `WAREHOUSE_DIRECT` ：数仓已算好，本地只从 `v_merchant_profile_latest` 指定字段直接读取；
	- `MIXED_INFER` ：结构字段 + 品牌 + 行为混合推断（如便利店、营业时间）；
	- `STRUCT_FLAG` ：单一结构字段标记（如 `additional_services` 推出洗车有无）；
	- `DERIVED` ：完全由其他标签/字段派生（如 `open_24h` from `open_hours` ， `sme_supplier` from `sme_supplier_partner` ）；
	- `DEFAULT_TRUE` ：业务默认真，允许 99→业务值改写（如 parking）。
- 强绑定 rule\_template：
	- 每个 tag\_code 对应一个稳定的 `rule_template` ，如：
		- `OPEN_HOURS_D1_FROM_IS_ZXGJ_AND_ORDERS_V1`
		- `OPEN_24H_FROM_OPEN_HOURS_V1`
		- `CONVENIENCE_FROM_ADDITIONAL_SERVICES_BRAND_ORDER_V1`
		- `BRAND_LEVEL_FROM_DW_V1` 等。
	- 人扫一眼就知道用了哪套规则，机器可根据模板名切换逻辑/分支。
- extra\_config\_json 半结构化承载关键参数：
	- 算法维度： `algo_mode, rule_template, d1_enabled, window_days` ；
	- 覆盖率/兜底维度： `coverage_strategy, fallback_enable_unknown_rewrite, fallback_unknown_enum_code, fallback_rewrite_target_enum_code` ；
	- 派生维度： `derived_is_derived, derived_source_tags, warehouse_source_view, warehouse_source_field` ；
	- QC 维度： `qc_set_value_has_meaning_on_fallback` 等。

**论据三：落地与风险——首批全量配置 + JSON schema v1.0**

- 落地做法：
	- 为你当前所有标签（共 15 个）补齐 `algo_version = tag_code_v1/open_hours_v1` 及 `extra_config_json` ；
	- 用一条 `INSERT ... ON DUPLICATE KEY UPDATE` SQL 完成首批 UPSERT；
	- 之后所有新标签、新版本一律走相同模式（例如 `_v2` ）。
- 风险与兜底：
	- 风险 1：JSON schema 演进。
		- 解法：本次 schema 控制在少数键，未来如要大改，直接通过 `algo_version` 升级为 `_v2` ，保留旧版本兼容。
	- 风险 2：config 和真实算法实现不一致。
		- 解法：
			- WAREHOUSE\_DIRECT 标签强调“视角说明”：本地不重算，只做字段映射；
			- DERIVED 标签用 `derived_source_tags` 显式表达依赖关系，减少误用；
			- 兜底改写一律受 `fallback_*` 控制，并配合 `qc_is_fallback_value` 记录。

---

### 3）思维导图结构（文本分层）

#### 3.1 extra\_config\_json v1.0 结构约定（字段语义）

（以下为“推荐键”，不是所有标签都必须用全量）

- 核心算法元信息
	- `algo_mode` ：
		- `WAREHOUSE_DIRECT | MIXED_INFER | STRUCT_FLAG | DERIVED | DEFAULT_TRUE`
	- `rule_template` ：强绑定 tag\_code 的规则名，如： `OPEN_HOURS_D1_FROM_IS_ZXGJ_AND_ORDERS_V1`
- 窗口 & D1 规则
	- `d1_enabled` ：0/1，是否启用 D1 激进规则（如营业时间窗口推断）
	- `window_days` ：行为统计窗口天数（如 30）
- 覆盖率 & 兜底改写
	- `coverage_strategy` ： `STRICT | AGGRESSIVE`
	- `fallback_enable_unknown_rewrite` ：是否允许“从兜底枚举（is\_default=1，如 99）改写为业务值（is\_default=0）”
	- `fallback_unknown_enum_code` ：兜底枚举的 code（通常 '99'）
	- `fallback_rewrite_target_enum_code` ：允许改写时的目标枚举值，如 `'00:00-24:00'` 、 `'1'`
- 派生 & 数仓直出
	- `derived_is_derived` ：0/1 是否派生标签
	- `derived_source_tags` ：JSON\_ARRAY，列出依赖的上游 tag\_code
	- `warehouse_source_view` ：通常 `'v_merchant_profile_latest'`
	- `warehouse_source_field` ：该标签在视图中的字段名
- QC 行为
	- `qc_set_value_has_meaning_on_fallback` ：兜底改写后是否自动视为有实际意义（1=是）

> 覆盖率口径：
> 
> - “兜底枚举”由 `tag_enum.is_default = 1` 唯一判定；
> - 覆盖率分子： `enum_code 对应 is_default = 0 且 qc_value_has_meaning = 1` ；
> - 从兜底改写出的值，通过 `qc_is_fallback_value = 1` 记录，可单独统计“兜底覆盖率”。

---

#### 3.2 各标签算法形态总览（algo\_mode + rule\_template）

**一）营业 / 服务类**

1. `open_hours`
	- `algo_mode`: `MIXED_INFER`
	- `rule_template`: `OPEN_HOURS_D1_FROM_IS_ZXGJ_AND_ORDERS_V1`
	- 特点：
		- 以 is\_zxgj + 订单时间分布三层决策，D1 开启，窗口 30 天；
		- `coverage_strategy=STRICT` ；
		- 允许 `99 -> '00:00-24:00'` 的兜底改写（并打 `qc_is_fallback_value=1` ）。
2. `open_24h`
	- `algo_mode`: `DERIVED`
	- `rule_template`: `OPEN_24H_FROM_OPEN_HOURS_V1`
	- 特点：
		- 依赖 `open_hours` ；
		- 逻辑集中在 open\_hours，24h 仅做视图派生（如 open\_hours=='00:00-24:00' → 1，否则 0/99）；
		- 不单独做 99→业务值改写。
3. `convenience_store_available`
	- `algo_mode`: `MIXED_INFER`
	- `rule_template`: `CONVENIENCE_FROM_ADDITIONAL_SERVICES_BRAND_ORDER_V1`
	- 特点：
		- 结构（additional\_services=3）> 品牌 > 行为（30 日订单 > 15）三层；
		- `coverage_strategy=AGGRESSIVE` ，但不走 99→业务值兜底。
4. `parking_available`
	- `algo_mode`: `DEFAULT_TRUE`
	- `rule_template`: `PARKING_DEFAULT_TRUE_V1`
	- 特点：
		- 当前阶段视为“所有油站默认有停车”，后续用反馈/地理做减法；
		- `coverage_strategy=AGGRESSIVE` + 允许 `99→'1'` 改写，撑覆盖率。
5. `restroom_available`
	- `algo_mode`: `DERIVED`
	- `rule_template`: `RESTROOM_FROM_CONVENIENCE_OR_ADDITIONAL_SERVICES_V1`
	- 特点：
		- 有便利店或 `additional_services` 含 0 → 1，否则 Unknown；
		- 严格派生，不做兜底改写。
6. `service_carwash_available`
	- `algo_mode`: `STRUCT_FLAG`
	- `rule_template`: `CARWASH_FROM_ADDITIONAL_SERVICES_V1`
	- 特点：
		- `additional_services` 含 1 → 1，否则 0；
		- 不做 99 改写，0/1 都是业务值。
7. `service_carwash_type`
	- `algo_mode`: `DERIVED`
	- `rule_template`: `CARWASH_TYPE_FROM_AVAILABLE_AND_DW_V1`
	- 特点：
		- 依赖 `service_carwash_available` ；
		- 枚举 `machine/manual/none` 均为业务值（ `is_default=0` ），真正 Unknown 另有 99 行；
		- 不做 99→默认类型改写。

**二）基础合作类**

1. `brand_name`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `BRAND_NAME_FROM_DW_V1`
	- DW 已算好清洗结果，读取 `v_merchant_profile_latest.brand_name` 。
2. `brand_level`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `BRAND_LEVEL_FROM_DW_V1`
	- 逻辑（你 DW 侧定义）：KA/CKA/小散，现阶段本地只读 `brand_level` 字段。
3. `is_ka_direct`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `KA_DIRECT_FLAG_FROM_DW_V1`
	- 读取 `is_ka_direct` 。
4. `store_life`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `STORE_LIFE_STAGE_FROM_DW_V1`
	- 生命周期分段（潜新/新/活跃/沉默/流失）由 DW 负责，本地只承接。

**三）策略运营 / 竞争 / 价格类**

1. `competitive_overlap`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `COMPETITIVE_OVERLAP_FROM_DW_V1`
	- 实际来自你“竞争重叠”结果表的 DW 聚合，本地不重算。
2. `sme_supplier_partner`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `SME_SUPPLIER_PARTNER_FROM_DW_V1`
	- 是否合作中小供给，DW 已算好。
3. `sme_supplier`
	- `algo_mode`: `DERIVED`
	- `rule_template`: `SME_SUPPLIER_NAME_FROM_PARTNER_AND_DW_V1`
	- `derived_is_derived=1` ，依赖 `sme_supplier_partner` ；名称本身来自 DW 字段 `sme_supplier` 。
4. `wyc_pricing_enabled`
	- `algo_mode`: `WAREHOUSE_DIRECT`
	- `rule_template`: `WYC_PRICING_ENABLED_FROM_DW_V1`
	- 是否开通网顺单独定价，来自配置/合同相关 DW 逻辑。

---

### 4）迭代日志（来源 / 结论 / 改动 / 待补充）

- 来源：
	- 你提供的 `tag_algo_config` 表结构、 `station_tag_target_value` QC 字段说明、标签全集（15 个）以及前面对各标签算法路径、兜底改写和派生关系的逐一澄清。
- 本轮结论：
	- 把 `tag_algo_config` 定位为“唯一算法说明表”；
	- 设计 `extra_config_json` v1.0 schema，并为 15 个标签给出 `algo_mode + rule_template + extra_config_json` ；
	- 通过一条 UPSERT SQL 完成首批配置落表。
- 本轮改动点：
	- 修正你之前 demo 中布尔字段（0.8 → 1）；
	- 明确 `open_24h` 作为 `open_hours` 的 DERIVED 视图；
	- 引入 `WAREHOUSE_DIRECT` 身份，覆盖 brand / lifecycle / 竞争 / 配置类标签；
	- 明确 `sme_supplier` 作为 `sme_supplier_partner` 的派生标签。
- 待补充 / 下一步建议：
	- 后续如需要为不同区域/业务线做差异化策略，可在同一 tag\_code 下增加 `_v2/_v3` 版本，并在 JSON 中增加区域维度配置。
	- 对部分标签（如 competitive\_overlap）未来若引入本地补算逻辑，可新增 `algo_mode = HYBRID` 并区分 DW / local 源。

---

## 附：首批全量 UPSERT SQL（可直接执行）

> 说明：
> 
> - 假设视图名统一填 `'v_merchant_profile_latest'` ；
> - 已存在的 `open_hours/open_hours_v1` 会被更新；
> - 数值字段按 DECIMAL(5,4) 书写；
> - 你可先在测试库执行并 `SELECT * FROM tag_algo_config` 检查 JSON 是否符合直觉。

```sql
sqlINSERT INTO tag_algo_config (
    tag_code,
    algo_version,
    conf_threshold_store,
    enable_merchant_level,
    min_merchant_data_ratio,
    max_feedback_cnt_for_agg,
    enable_party_level,
    hierarchy_weight_store,
    hierarchy_weight_merchant,
    hierarchy_weight_party,
    extra_config_json
)
VALUES
-- 1. open_hours：三层 + D1 + 严格覆盖 + 允许 99→00:00-24:00
(
    'open_hours',
    'open_hours_v1',
    0.9000,
    1,
    0.2000,
    0,
    1,
    0.8000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'MIXED_INFER',
        'rule_template', 'OPEN_HOURS_D1_FROM_IS_ZXGJ_AND_ORDERS_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 1,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 1,
        'fallback_unknown_enum_code', '99',
        'fallback_rewrite_target_enum_code', '00:00-24:00',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'open_hours',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 2. open_24h：派生自 open_hours
(
    'open_24h',
    'open_24h_v1',
    0.9000,
    1,
    0.2000,
    0,
    1,
    0.8000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'DERIVED',
        'rule_template', 'OPEN_24H_FROM_OPEN_HOURS_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 1,
        'derived_source_tags', JSON_ARRAY('open_hours'),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'open_24h',
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- 3. convenience_store_available：结构+品牌+行为，偏 AGGRESSIVE
(
    'convenience_store_available',
    'convenience_store_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'MIXED_INFER',
        'rule_template', 'CONVENIENCE_FROM_ADDITIONAL_SERVICES_BRAND_ORDER_V1',
        'coverage_strategy', 'AGGRESSIVE',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'convenience_store_available',
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- 4. parking_available：默认真 + AGGRESSIVE，允许 99→1
(
    'parking_available',
    'parking_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'DEFAULT_TRUE',
        'rule_template', 'PARKING_DEFAULT_TRUE_V1',
        'coverage_strategy', 'AGGRESSIVE',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 1,
        'fallback_unknown_enum_code', '99',
        'fallback_rewrite_target_enum_code', '1',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'parking_available',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 5. restroom_available：严格派生，不做 99 改写
(
    'restroom_available',
    'restroom_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'DERIVED',
        'rule_template', 'RESTROOM_FROM_CONVENIENCE_OR_ADDITIONAL_SERVICES_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 1,
        'derived_source_tags', JSON_ARRAY('convenience_store_available'),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'restroom_available',
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- 6. service_carwash_available：结构标记型
(
    'service_carwash_available',
    'service_carwash_available_v1',
    0.7000,
    1,
    0.2000,
    0,
    1,
    0.6000,
    1.0000,
    0.7000,
    JSON_OBJECT(
        'algo_mode', 'STRUCT_FLAG',
        'rule_template', 'CARWASH_FROM_ADDITIONAL_SERVICES_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'service_carwash_available',
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- 7. service_carwash_type：派生 + DW 字段
(
    'service_carwash_type',
    'service_carwash_type_v1',
    0.9000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'DERIVED',
        'rule_template', 'CARWASH_TYPE_FROM_AVAILABLE_AND_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 1,
        'derived_source_tags', JSON_ARRAY('service_carwash_available'),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'service_carwash_type',
        'qc_set_value_has_meaning_on_fallback', 0
    )
),

-- 8. brand_name：DW 直出
(
    'brand_name',
    'brand_name_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'BRAND_NAME_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'brand_name',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 9. brand_level：DW 直出
(
    'brand_level',
    'brand_level_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'BRAND_LEVEL_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'brand_level',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 10. is_ka_direct：DW 直出
(
    'is_ka_direct',
    'is_ka_direct_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'KA_DIRECT_FLAG_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'is_ka_direct',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 11. store_life：DW 直出
(
    'store_life',
    'store_life_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'STORE_LIFE_STAGE_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'store_life',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 12. competitive_overlap：DW 直出
(
    'competitive_overlap',
    'competitive_overlap_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'COMPETITIVE_OVERLAP_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'competitive_overlap',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 13. sme_supplier_partner：DW 直出
(
    'sme_supplier_partner',
    'sme_supplier_partner_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'SME_SUPPLIER_PARTNER_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'sme_supplier_partner',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 14. sme_supplier：派生 + DW 字段
(
    'sme_supplier',
    'sme_supplier_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'DERIVED',
        'rule_template', 'SME_SUPPLIER_NAME_FROM_PARTNER_AND_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 1,
        'derived_source_tags', JSON_ARRAY('sme_supplier_partner'),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'sme_supplier',
        'qc_set_value_has_meaning_on_fallback', 1
    )
),

-- 15. wyc_pricing_enabled：DW 直出
(
    'wyc_pricing_enabled',
    'wyc_pricing_enabled_v1',
    1.0000,
    0,
    0.0000,
    0,
    0,
    1.0000,
    0.0000,
    0.0000,
    JSON_OBJECT(
        'algo_mode', 'WAREHOUSE_DIRECT',
        'rule_template', 'WYC_PRICING_ENABLED_FROM_DW_V1',
        'coverage_strategy', 'STRICT',
        'd1_enabled', 0,
        'window_days', 30,
        'fallback_enable_unknown_rewrite', 0,
        'fallback_unknown_enum_code', '99',
        'derived_is_derived', 0,
        'derived_source_tags', JSON_ARRAY(),
        'warehouse_source_view', 'v_merchant_profile_latest',
        'warehouse_source_field', 'wyc_pricing_enabled',
        'qc_set_value_has_meaning_on_fallback', 1
    )
)
ON DUPLICATE KEY UPDATE
    conf_threshold_store      = VALUES(conf_threshold_store),
    enable_merchant_level     = VALUES(enable_merchant_level),
    min_merchant_data_ratio   = VALUES(min_merchant_data_ratio),
    max_feedback_cnt_for_agg  = VALUES(max_feedback_cnt_for_agg),
    enable_party_level        = VALUES(enable_party_level),
    hierarchy_weight_store    = VALUES(hierarchy_weight_store),
    hierarchy_weight_merchant = VALUES(hierarchy_weight_merchant),
    hierarchy_weight_party    = VALUES(hierarchy_weight_party),
    extra_config_json         = VALUES(extra_config_json);
```

如果你愿意，下一步我们可以针对某一个标签（比如 `open_24h` 或 `parking_available` ），从这个 config 出发，写一整条「从三层候选 → 决策 → station\_tag\_target\_value + QC 落表」的完整 SQL 链路，当成标准模版。

这个表太多术语了,需要更新表字段备注,详细备注,尤其术语英文,写个备注更新的查询

20251207\_0500\_tag\_algo\_config\_字段备注更新SQL  
tags: #表结构 #字段注释 #tag\_algo\_config #算法配置

下面这条 SQL 直接在当前库执行即可，给 `tag_algo_config` 所有字段补上清晰、含英文术语的备注（不改类型和默认值，只改 COMMENT）：

```sql
sqlALTER TABLE tag_algo_config
    MODIFY COLUMN tag_code VARCHAR(64) NOT NULL
        COMMENT '标签编码（tag_code），对齐 tag_spec.tag_code，作为算法配置主键之一',
    MODIFY COLUMN algo_version VARCHAR(64) NOT NULL DEFAULT 'v1'
        COMMENT '算法版本（algo_version），如 open_hours_v1。同一标签可有多个版本并存，用于灰度/历史兼容',
    MODIFY COLUMN conf_threshold_store DECIMAL(5,4) NOT NULL DEFAULT 0.9000
        COMMENT '门店层置信度阈值（store-level confidence threshold）。仅当 store_conf >= 此值时，门店层结果参与最终决策',
    MODIFY COLUMN enable_merchant_level TINYINT(1) NOT NULL DEFAULT 1
        COMMENT '是否启用商户层决策（enable_merchant_level，1=启用，0=关闭）。为 0 时仅使用门店/工商层',
    MODIFY COLUMN min_merchant_data_ratio DECIMAL(5,4) NOT NULL DEFAULT 0.2000
        COMMENT '商户层可聚合的最小有效门店占比（min_merchant_data_ratio，0-1）。低于该占比的商户不参与商户层聚合',
    MODIFY COLUMN max_feedback_cnt_for_agg INT NOT NULL DEFAULT 0
        COMMENT '用于判断商户是否可聚合的负向反馈阈值（max_feedback_cnt_for_agg）。超过该反馈次数的商户视为“不可聚合”',
    MODIFY COLUMN enable_party_level TINYINT(1) NOT NULL DEFAULT 1
        COMMENT '是否启用工商主体层决策（enable_party_level，1=启用，0=关闭）。为 0 时不计算 party_key 维度结果',
    MODIFY COLUMN hierarchy_weight_store DECIMAL(5,4) NOT NULL DEFAULT 0.8000
        COMMENT '门店层权重（hierarchy_weight_store）。跨层决策时用于 conf × weight 打分，数值越高代表门店层优先级越高',
    MODIFY COLUMN hierarchy_weight_merchant DECIMAL(5,4) NOT NULL DEFAULT 1.0000
        COMMENT '商户层权重（hierarchy_weight_merchant）。跨层决策时用于 conf × weight 打分，通常为三层中最高',
    MODIFY COLUMN hierarchy_weight_party DECIMAL(5,4) NOT NULL DEFAULT 0.7000
        COMMENT '工商主体层权重（hierarchy_weight_party）。跨层决策时用于 conf × weight 打分，控制 party_key 层影响力',
    MODIFY COLUMN extra_config_json JSON NULL
        COMMENT '扩展算法配置（extra_config_json）。统一以 JSON 存放 algo_mode、rule_template、coverage_strategy、fallback、derived_source_tags、warehouse_source_field 等详细规则';
```

建议先在测试库跑一遍，然后 `SHOW FULL COLUMNS FROM tag_algo_config;` 看一下注释效果是否符合你的阅读习惯。

退出教练模式,总结我们前面的目标和共识,写一个完整的需求文档,在根据需求文档来推进目标的开发;提升服务标签的覆盖率到 90%;

20251207\_服务标签覆盖率90\_算法与ETL需求文档  
tags: #商户画像 #服务标签 #标签ETL #tag\_algo\_config #station\_tag\_target\_value #覆盖率90

---

## 1）一句话结论

本需求文档将 `tag_algo_config` 定义为「唯一算法说明表」，配合 `station_tag_target_value` 与 QC 字段和兜底改写机制，为营业/服务类标签（open\_24h/open\_hours + 站内服务标签）搭建一条统一的三层决策 + 派生 + 兜底链路，目标是在可控风险下，将服务标签的有效覆盖率提升至 ≥90%。

---

## 2）三段论据（现状与问题 → 策略 → 落地与风险）

### 论据一：现状与问题——标签多源、多形态，算法与口径分散

- 标签体系已经成型：
	- `tag_spec / tag_enum / tag_catalog` 已有完整字典，A/B 类标签区分清晰；
	- v\_merchant\_profile\_latest 已整合门店/商户/工商三层主特征、数仓计算结果与服务类字段。
- 但在「算法形态 + 计算逻辑 + 覆盖率口径」上存在明显断层：
	- open\_hours / open\_24h / 服务标签（便利店、停车位、卫生间、洗车有无/类型）已经有清晰的算法思路和部分中间表（候选、三层特征快照），但 **没有统一的、机器可读的配置来源** ；
	- 基础合作类（brand\_name/brand\_level/is\_ka\_direct/store\_life）与策略运营类（competitive\_overlap/sme\_supplier\*/wyc\_pricing\_enabled）多数在数仓算好，本地只承接字段，但 **没有在算法表中声明“我是 DW 直出”** ，对后续维护者不透明；
	- 覆盖率统计口径、兜底值（tag\_enum.is\_default）、二道工序“99→业务默认值”的改写逻辑，目前散落在对话与草稿中， **缺乏集中定义** 。
- 目标：
	- 服务标签（站内服务相关标签）有效覆盖率 ≥90%（以站点×标签为粒度，剔除兜底枚举值），同时保留对兜底改写样本的可追踪能力。

### 论据二：策略——以 tag\_algo\_config 为单一算法源，extra\_config\_json 半结构化承载全部规则

- 最上层策略：
	- 所有标签必须在 `tag_algo_config` 中有且仅有一行有效配置（按 `tag_code + algo_version` 唯一）；
	- 该行配置必须回答三件事：  
		1）算法形态（algo\_mode：WAREHOUSE\_DIRECT / MIXED\_INFER / STRUCT\_FLAG / DERIVED / DEFAULT\_TRUE）；  
		2）规则模板（rule\_template：强绑定 tag\_code 的稳定 ID）；  
		3）关键参数与派生/兜底/覆盖率/数仓映射信息（extra\_config\_json）。
- 覆盖率与兜底的统一口径：
	- “兜底枚举值”由 `tag_enum.is_default = 1` 唯一确定（通常是 Unknown/99）；
	- 覆盖率分子定义为：
		- 在 `station_tag_target_value` 中，给定 tag\_code 下， `enum_code` 对应 `tag_enum.is_default = 0` 且 `qc_value_has_meaning = 1` 的样本数；
	- 对于允许“99→业务默认值”的标签（open\_hours/parking 等），在二道工序中改写 `enum_code` ，同时打 `qc_is_fallback_value = 1` ，使其进入覆盖率分子，但可以单独分析“兜底覆盖率”。
- 三层决策 + 派生 + DW 直出统一表达：
	- 三层决策标签（open\_hours / open\_24h / convenience / parking / restroom / carwash\_available）：
		- 通过 `conf_threshold_store / enable_merchant_level / enable_party_level / hierarchy_weight_*` 实现 store/merchant/party 三层决策骨架；
		- 在 extra\_config\_json 中声明 `algo_mode, rule_template, coverage_strategy, d1_enabled, fallback_*` 。
	- 派生标签（open\_24h / restroom\_available / service\_carwash\_type / sme\_supplier）：
		- 使用 `algo_mode='DERIVED' + derived_is_derived=1 + derived_source_tags` 显式表达依赖标签；
		- 对于 carwash\_type 等，类型枚举来自 tag\_enum， `none/machine/manual` 均为业务值，非兜底。
	- DW 直出标签（brand\_name/brand\_level/is\_ka\_direct/store\_life/competitive\_overlap/sme\_supplier\_partner/wyc\_pricing\_enabled）：
		- 使用 `algo_mode='WAREHOUSE_DIRECT'` ，并在 extra\_config\_json 中明确 `warehouse_source_view='v_merchant_profile_latest'` 与 `warehouse_source_field` 。

### 论据三：落地与风险——通过配置+ETL模版，将服务标签覆盖率推至 90%

- 落地路径：  
	1）统一更新 `tag_algo_config` 字段注释，确保字段语义清晰（尤其 algo\_version / conf\_threshold\_store / hierarchy\_weight\_\* / extra\_config\_json）；  
	2）基于本方案，为所有标签（共 15 个）写入/更新 v1 配置行（含 extra\_config\_json）；  
	3）以 open\_hours/open\_24h 与服务标签为模版，设计一条“从三层 candidate → 决策 → 兜底改写 → station\_tag\_target\_value + QC”的 ETL 标准链路；  
	4）在覆盖率计算与监控侧，统一使用“剔除 is\_default=1 枚举 + qc\_value\_has\_meaning=1”的口径，并额外追踪 `qc_is_fallback_value=1` 样本占比，衡量“自然覆盖率 vs 兜底覆盖率”。
- 风险与兜底：
	- 风险：config 与真实实现不一致，或者 future 标签忘记注册 config。
		- 兜底：
			- 强制约定“没有 tag\_algo\_config 的标签不得落表到 station\_tag\_target\_value”；
			- 在 ETL 中增加 config 缺失检测（直接 fail fast）。
	- 风险：fallback 改写滥用，掩盖算法质量问题。
		- 兜底：
			- 所有改写样本必须 `qc_is_fallback_value=1` ，并在覆盖率/质量看板上单独披露；
			- 初期仅在 parking/open\_hours 等你明确同意的标签上启用 `fallback_enable_unknown_rewrite=1` 。

---

## 3）思维导图结构（文本分层）

### 3.1 商户画像项目定位

- 项目目标（SMART）：
	- 目标：在当前阶段，优先将「站内服务相关标签」的有效覆盖率（非兜底值）提升到 ≥90%；
	- 范围：
		- 营业/服务核心标签：
			- `open_hours` （油站营业时间，A）
			- `open_24h` （是否24小时营业，A，视作 open\_hours 派生视图）
		- 站内服务标签：
			- `convenience_store_available` （是否有便利店，A）
			- `parking_available` （是否有停车位，A）
			- `restroom_available` （是否有卫生间，A）
			- `service_carwash_available` （是否有洗车，A）
			- `service_carwash_type` （洗车类型，A）
	- 时间：本周完成 config 与链路设计 + 服务标签首批落表，在开发/测试环境手工跑得通；后续扩展到更多标签。
- 关键业务场景：
	- KA 精细运营：基于“服务能力 + 营业时间”做站点分层、KA 选址与运营策略；
	- 服务能力看板：为运营/KA 提供服务画像（洗车/便利店/卫生间/停车等）；
	- 后续自动化策略（选站、优惠、商品组合）依赖这些服务标签作为前置画像维度。

---

### 3.2 数据与标签体系设计

#### 3.2.1 数据源与关键表

- 上游视图：
	- `v_merchant_profile_latest` ：
		- 聚合 store/merchant/party 三层信息与数仓计算字段；
		- 已包含 brand\_name/brand\_level/is\_ka\_direct/store\_life/competitive\_overlap/sme\_supplier\_partner/sme\_supplier/wyc\_pricing\_enabled 等字段；
		- 存放 open\_hours/open\_24h/服务标签相关字段（原始或结果视角）。
- 特征与候选中间表（已存在/约定）：
	- `store_feature_snapshot_di` / `merchant_feature_snapshot_di` / `party_feature_snapshot_di` ：三层特征快照；
	- `open_hours_candidate_di` ：open\_hours 三层候选 + conf；
	- `dim_gas_store_info_extend` ：包含 `additional_services` （0=卫生间,1=洗车,2=早点便当,3=便利店,4=充气,5=修车,6=快餐店），多值格式如 `0,1,3` 。
- 核心终表：
	- `station_tag_target_value` ：
		- 终态标签落表；
		- 关键字段：
			- `store_id, as_of_date, tag_code`
			- `target_value_bool/number/string` （三选一）
			- `enum_code/enum_label` （对齐 tag\_enum）
			- `source, evidence_state, ttl_days, reason, conf`
			- `qc_value_has_meaning, qc_is_wrong_cleaning, qc_is_same_as_source, qc_is_fallback_value, qc_is_meaningless_non_fallback` 。
- 算法配置表：
	- `tag_algo_config` ：
		- 关键字段与角色：
			- `tag_code` ：标签编码（主键之一）；
			- `algo_version` ：算法版本，如 `open_hours_v1` （主键之一）；
			- `conf_threshold_store` ：门店层置信度阈值；
			- `enable_merchant_level/enable_party_level` ：是否启用商户/工商层决策；
			- `min_merchant_data_ratio` ：商户层可聚合最小门店占比；
			- `max_feedback_cnt_for_agg` ：负向反馈阈值；
			- `hierarchy_weight_store/merchant/party` ：三层权重，用于 conf×weight；
			- `extra_config_json` ：承载算法形态/规则模板/兜底/派生等详细配置。

#### 3.2.2 标签范围与算法形态（algo\_mode）

- MIXED\_INFER：
	- `open_hours` ：is\_zxgj + 30 日订单分布 + 三层候选 + D1；
	- `convenience_store_available` ：additional\_services=3 + 品牌字段 + 订单阈值（例如 >15 单）。
- DERIVED：
	- `open_24h` ：从 `open_hours` 派生；
	- `restroom_available` ：从 convenience + additional\_services=0 派生；
	- `service_carwash_type` ：从 `service_carwash_available` + DW 字段派生；
	- `sme_supplier` ：从 `sme_supplier_partner` + DW 名称字段派生。
- STRUCT\_FLAG：
	- `service_carwash_available` ：additional\_services 是否包含 1。
- DEFAULT\_TRUE：
	- `parking_available` ：默认所有油站有停车，未来借地理/反馈修正。
- WAREHOUSE\_DIRECT：
	- `brand_name, brand_level, is_ka_direct, store_life, competitive_overlap, sme_supplier_partner, wyc_pricing_enabled` ：
		- 均在 DW 侧计算完毕，本地只从 v\_merchant\_profile\_latest 对应字段读取。

#### 3.2.3 终表与覆盖率指标定义

- 三选一协议（终表）：
	- 每条记录必须满足： `target_value_bool/number/string` 有且仅有一个非空；
	- `enum_code` 必须存在于 tag\_enum（无枚举的标签，enum\_code=业务值本身）；
	- Unknown/兜底枚举统一由 `tag_enum.is_default=1` 表示，常见是 enum\_code='99'。
- 覆盖率定义（服务标签）：
	- 范围：所有在营站（或指定站点集合）× 服务标签集合；
	- 分子：
		- 终表中该标签的记录，满足：
			- 对应 enum\_code 在 tag\_enum 中 `is_default=0` （非兜底枚举）；
			- `qc_value_has_meaning = 1` ；
	- 覆盖率 = 分子 / 分母；
	- `qc_is_fallback_value=1` 的记录：
		- 计入覆盖率分子，但在质量视图中单独展示“兜底覆盖率占比”。

#### 3.2.4 extra\_config\_json v1.0 schema（约定）

- 推荐键集合（实际按标签选择）：
	| 键名 | 含义 |
	| --- | --- |
	| algo\_mode | 算法形态： `WAREHOUSE_DIRECT / MIXED_INFER / STRUCT_FLAG / DERIVED / DEFAULT_TRUE` |
	| rule\_template | 规则模板名，强绑定 tag\_code（如 `OPEN_HOURS_D1_FROM_IS_ZXGJ_AND_ORDERS_V1` ） |
	| coverage\_strategy | 覆盖策略： `STRICT` （保守）/ `AGGRESSIVE` （覆盖优先） |
	| d1\_enabled | 是否启用 D1 激进规则（0/1） |
	| window\_days | 行为统计窗口，通常 30 |
	| fallback\_enable\_unknown\_rewrite | 是否允许“兜底枚举 → 业务值”改写（0/1） |
	| fallback\_unknown\_enum\_code | 兜底枚举 code（如 '99'） |
	| fallback\_rewrite\_target\_enum\_code | 允许改写时的目标业务枚举值（如 `'00:00-24:00'` 、 `'1'` ） |
	| derived\_is\_derived | 是否派生标签（0/1） |
	| derived\_source\_tags | JSON\_ARRAY，上游依赖标签列表 |
	| warehouse\_source\_view | 数仓/视图来源，如 `'v_merchant_profile_latest'` |
	| warehouse\_source\_field | 在视图中的字段名 |
	| qc\_set\_value\_has\_meaning\_on\_fallback | 兜底改写后是否自动设置 `qc_value_has_meaning=1` |

---

### 3.3 策略路径对比

#### 路径 A：严格不兜底（理论上更“干净”）

- 思路：
	- 所有标签仅基于“硬证据”与算法，算不出就 Unknown（enum\_code=兜底枚举，如 99）；
	- coverage\_strategy=STRICT， `fallback_enable_unknown_rewrite=0` ；
	- 服务标签覆盖率完全由算法质量决定。
- 优点：
	- 语义简单，兜底值 = 算法失败，统计/解释都容易；
	- 不会出现“覆盖率高但大量依赖默认假设”的情况。
- 缺点：
	- 在现有数仓/行为信号密度下，服务标签覆盖率短期难以拉高到 90%；
	- 无法把“业务公认恒真”的信息（如油站能停车）纳入覆盖率。

#### 路径 B：带标记的兜底改写（本方案采纳）

- 思路：
	- 先按 strict 算法生成枚举值（含 99 兜底）；
	- 再根据 per-tag 配置，在二道工序中允许“99→业务枚举值”的改写：
		- 如 open\_hours: 99 → `'00:00-24:00'` ；
		- parking\_available: 99 → `'1'` （有停车）。
	- 改写后：
		- enum\_code 对应 `is_default=0` ，计入覆盖率分子；
		- 同时 `qc_is_fallback_value = 1` ，可被单独统计。
- 优点：
	- 兼顾短期覆盖率目标（≥90%）与长期算法提升空间；
	- 通过 QC 标记清晰地区分“自然覆盖率 vs 兜底覆盖率”。
- 缺点：
	- 逻辑略复杂，需要在 ETL 和统计层严格遵守口径；
	- 如果 fallback 范围控制不好，可能掩盖算法问题。

> 结论：  
> 本项目阶段采用路径 B：在 config 中严格限定允许兜底改写的标签范围（优先 parking/open\_hours 这类业务共识强的标签），通过 QC 字段和 coverage 口径控制风险。

---

### 3.4 项目推进与协同（高层）

- 阶段拆解：
	- 最近 1 周：
		- tag\_algo\_config 字段注释修正 & v1 配置 UPSERT；
		- open\_hours/open\_24h + 服务标签的决策链路与迁移 SQL 模版打通，在开发库可一键执行；
		- 定义覆盖率统计 SQL，出一版服务标签覆盖率基线看板。
	- 本季度内：
		- 扩展同一链路到更多 A 类标签；
		- 和 DW/运营对齐「服务标签覆盖率 90%」的口径与看板；
		- 接入 feedback + 调参闭环。
- 协同角色：
	- 数据：负责 tag\_algo\_config 配置维护、ETL 实现与 QC 逻辑；
	- 产品/运营：确认各标签的业务语义、兜底策略与覆盖率目标；
	- DW 团队：确保 WAREHOUSE\_DIRECT 标签的字段逻辑与本地说明一致。

---

### 3.5 行动清单（可执行）

| 优先级 | 事项 | 责任人角色 | 预计完成时间 | 输出物 |
| --- | --- | --- | --- | --- |
| P0 | 更新 tag\_algo\_config 字段注释（已完成，可在正式库执行） | 数据 | 本周 | 表结构注释同步 |
| P0 | 按本方案 UPSERT 全量 15 个标签的 v1 配置行 | 数据 | 本周 | tag\_algo\_config\_v1 配置快照 |
| P0 | 为 open\_hours/open\_24h + 5 个服务标签设计「三层决策 + 派生 + 兜底 → station\_tag\_target\_value」SQL 模版，并按步骤命名（ `-- etl_tag_stepX.Y.*` ） | 数据 | 本周 | ETL SQL 脚本 v1 |
| P0 | 定义服务标签覆盖率统计 SQL（基于 enum.is\_default=0 + qc\_value\_has\_meaning=1） | 数据 | 本周 | 覆盖率统计 SQL & Demo 结果 |
| P1 | 把 ETL 脚本集成到日常手工跑流程（开发库可一键执行） | 数据 | 本周 | 手工执行脚本 + 操作说明 |
| P1 | 整理一页纸「服务标签双 90 链路说明」（可给老板/跨部门） | 产品/数据 | 本周或下周 | PPT/文档一页纸 |
| P2 | 设计 feedback 与阈值调参闭环（merchant\_feedback\_stats + tag\_algo\_config 升级） | 数据/运营 | 后续迭代 | 反馈表结构 & 调参流程 |

---

### 3.6 风险与关键假设

- 关键假设：
	- v\_merchant\_profile\_latest 已稳定提供 B 类 & 运营类字段，不频繁变更字段含义；
	- tag\_enum 中所有兜底枚举均已设置 `is_default=1` ；
	- station\_tag\_target\_value 的 QC 字段可以在现有产线中扩展使用，不影响其他标签。
- 主要风险：  
	1）服务标签覆盖率目标与真实业务认知不一致（例如停车标签默认 1 是否触发争议）；  
	2）DW 侧字段逻辑变动时，未同步更新 tag\_algo\_config 中的 rule\_template/warehouse\_source\_field 说明；  
	3）fallback 改写逻辑被误用到不该兜底的标签（如 restroom/open\_24h）。
- 应对：
	- 通过 config 白名单控制 `fallback_enable_unknown_rewrite=1` 的标签集合；
	- 每次 DW 字段变更时，要求同步更新 tag\_algo\_config 的 rule\_template/备注；
	- 覆盖率看板必须区分“自然覆盖率（qc\_is\_fallback\_value=0）”和“总覆盖率”。

---

### 3.7 对下一步的提问与迭代建议

后续如果要把本方案进一步打磨到“可以直接开评审会”的程度，建议你补充/确认：

1. 服务标签覆盖率 90% 的统计范围（仅动销站 / 全体在营站 / 需要排除的特殊站点清单）。
2. open\_hours/open\_24h 与 is\_zxgj/订单时间分布的具体实现 SQL（含 D1 逻辑），用于固化为正式文档示例。
3. parking/便利店/洗车等标签在一线运营心中的“真实可接受兜底逻辑”（例如哪些情况一定不能默认为有）。

这些信息补齐后，可以再出一版「评审版方案 + SQL 附录」，让开发、DW、运营一起对齐产线实现。

---

## 4）迭代日志

- 来源：
	- 本文基于前序对话中对 open\_hours/open\_24h 重建、三层特征快照、open\_hours\_candidate\_di、station\_tag\_target\_value QC 字段、tag\_algo\_config 表结构及 extra\_config\_json schema 的多轮澄清与决策。
- 本轮结论：
	- 已将 tag\_algo\_config 定义为唯一算法说明表；
	- 已在概念层面给出全部标签的 algo\_mode + rule\_template + 派生/兜底/覆盖率口径；
	- 明确了服务标签覆盖率 ≥90% 的统计定义与实现路径。
- 改动点：
	- 新增 algo\_mode=WAREHOUSE\_DIRECT，用于 B 类与 DW 直出标签；
	- 使用 DERIVED + derived\_source\_tags 显式表达 open\_24h/sme\_supplier/service\_carwash\_type 等派生关系；
	- 统一了“兜底枚举 = tag\_enum.is\_default=1”“覆盖率分子 = 非兜底枚举 + qc\_value\_has\_meaning=1”的口径。
- 下一步建议：
	- 先在开发库按本需求文档完善 config 与 SQL 脚本，跑出一版实际覆盖率结果；
	- 基于实测结果再反推：各标签的 conf 阈值与 fallback 策略是否需要微调，逐步逼近“覆盖率≥90% 且兜底覆盖率占比可控”的目标。

20251207\_0600\_服务标签ETL执行规划与SQL\_V1  
tags: #服务标签 #标签ETL #执行规划 #SQL脚本 #营业时间链路复用

---

### 1）一句话结论

接下来我们按“营业时间 open\_hours/open\_24h 已跑通链路”为蓝本，规划一条清晰、可逐步落地的 TODO 列表，并先完成【服务标签门店层算子 + 审计日志】的 SQL 实现，后续再在你的配合下扩展到三层决策与 station\_tag\_target\_value 迁移。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

**论据一：现状——营业时间链路已成型，但服务标签还停留在概念层**

- 你已经有一整套 open\_hours/open\_24h 的标准链路：
	- step0：自动检测业务日 @biz\_date；
	- step2：三层特征快照（store/merchant/party\_feature\_snapshot\_di）；
	- step3：门店层 strict 版本标签 + 审计（store\_tag\_snapshot\_di, tag\_audit\_log\_di）；
	- step4：open\_hours 三层候选 + 决策 + 审计；
	- stepA/B：open\_24h & open\_hours 规范版重建（24h 强一致 + HH:MM-HH:MM）。
- 但服务标签（便利店/停车/卫生间/洗车有无/类型）目前只有算法思路与 tag\_algo\_config，没有对应的 ETL SQL：
	- 没有规范的 step 命名；
	- 没有统一的 store\_tag\_snapshot\_di 写法；
	- 没有审计日志，debug/验算成本高。

**论据二：策略——先统一门店层算子 & 审计，再逐步扩展三层决策与终表迁移**

- 本轮不贪功，一刀切目标：
	- 用一套和 open\_hours 类似的 step 结构，先把服务标签在 **门店层算对 + 写入 store\_tag\_snapshot\_di + 写审计日志** ；
	- 三层候选/决策和 station\_tag\_target\_value 迁移作为下一轮 TODO，在当前脚本基础上追加，而不是另起炉灶。
- 设计原则：
	- 命名统一： `etl_tag_stepS.X_标签英文_动作` ，方便你后续合并为一个 SQL 文件顺序执行；
	- 不重复造中间表：尽量复用 `store_feature_snapshot_di` + `dim_gas_store_info_extend` + `v_merchant_profile_latest_di` ；
	- 保持和 tag\_algo\_config 的语义一致：
		- `algo_mode=DEFAULT_TRUE` 的 parking 用默认真；
		- `STRUCT_FLAG` 的洗车有无从 additional\_services 直接出结果；
		- `DERIVED` 的卫生间/洗车类型从上游标签 + DW 字段派生。

**论据三：落地与风险——分批 TODO + 你来跑数验证覆盖率**

- 落地方式：
	- 先给出一个清晰的 TODO 列表（按 step 顺序）；
	- 本轮回答直接给出 **S 段：服务标签门店层 + 审计的 SQL 模块** ，你可以拷贝到现有脚本尾部执行；
	- 你在开发库跑完后，对比覆盖率与业务期望，再和我一起迭代三层决策 & station\_tag\_target\_value 迁移。
- 风险点：
	- 部分规则（例如便利店通过订单>15 单推断）是启发式，需要实测；
	- 我现在假定 `dim_gas_store_info_extend` 与 `v_merchant_profile_latest_di` 字段名/含义与你描述一致，如有出入需要你在 SQL 中微调；
	- 暂未引入“反馈表驱动修正”（merchant\_feedback\_stats）到服务标签里，这部分可在下一轮做。

---

### 3）思维导图结构（文本分层）

#### 3.1 本轮执行总 TODO（只列必须做的）

**T1. 整体脚本结构梳理（你已有，略）**

- step0：detect\_biz\_date（已存在）
- step2：store/merchant/party\_feature\_snapshot\_di（已存在）
- step3/4/A/B：open\_hours/open\_24h 链路（已存在）

**T2. 新增服务标签门店层计算 + 审计（本轮给出 SQL）**

- S1： `etl_tag_stepS.1a_convenience_store_available_store`
	- 从 `store_feature_snapshot_di + dim_gas_store_info_extend` 推出 `convenience_store_available` 门店层标签；
- S2： `etl_tag_stepS.1b_parking_available_store`
	- 默认真：所有站视为有停车；
- S3： `etl_tag_stepS.1c_service_carwash_available_store`
	- additional\_services 含 1 → 有洗车，否则无洗车；
- S4： `etl_tag_stepS.1d_service_carwash_type_store`
	- 依赖 `service_carwash_available` + v\_merchant\_profile\_latest\_di.service\_carwash\_type（假设存在）；
- S5： `etl_tag_stepS.1e_restroom_available_store`
	- additional\_services 含 0 或有便利店 → 有卫生间，否则未知；
- S6： `etl_tag_stepS.2_service_tags_audit_store`
	- 把上述五个标签写入 tag\_audit\_log\_di（store-only）。

**T3. 下一轮 TODO（本轮不实现，只在规划里）**

- D1：为服务标签设计 candidate\_di（类似 open\_hours\_candidate\_di）和三层决策；
- D2：将服务标签从 store\_tag\_snapshot\_di 迁移到 station\_tag\_target\_value，填充 QC 字段与兜底改写；
- D3：为服务标签接入 feedback 机制（merchant\_feedback\_stats）。

下面先把 T2 的 SQL 全部写出来，你可以直接插入到现有脚本中，在 stepB 之后追加执行。

---

### 4）服务标签门店层 ETL SQL（可直接用，建议放在 open\_hours / open\_24h 链路之后）

> 约定：
> 
> - 依赖变量： `@biz_date` （已在脚本最前面由 v\_merchant\_profile\_latest\_di 计算）。
> - 依赖表：
> 	- `store_feature_snapshot_di` （已有）
> 	- `dim_gas_store_info_extend` （字段：store\_id, additional\_services）
> 	- `v_merchant_profile_latest_di` （假设有 `service_carwash_type` 字段，如无你可用实际字段名替换）
> 	- `store_tag_snapshot_di, tag_audit_log_di` （已有）

---

#### S1. 便利店标签：etl\_tag\_stepS.1a\_convenience\_store\_available\_store

**逻辑口径（门店层）**

- 输入：
	- `store_feature_snapshot_di` ：order\_cnt\_30d；
	- `dim_gas_store_info_extend.additional_services` ：多值枚举，如 `0,1,3` ；
- 决策规则：
	- 若 additional\_services 中包含 `3` （便利店）：
		- `convenience_store_available = 1` ，conf=1.0，reason='from\_additional\_services\_3'；
	- 否则若 30 日日均订单 ≥ 15：
		- `convenience_store_available = 1` ，conf=0.7，reason='from\_order\_cnt\_30d\_ge\_15'；
	- 否则：
		- `convenience_store_available = 99` （未知），conf=0.5，reason='no\_strong\_evidence'。
```sql
sql-- etl_tag_stepS.1a_convenience_store_available_store
-- 生成 convenience_store_available 门店层标签（来自 additional_services + 订单启发）

DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'convenience_store_available';

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
    'convenience_store_available' AS tag_code,

    -- 三选一：只用 bool（0/1/99）
    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('3', e.additional_services) > 0
        THEN 1
        WHEN s.order_cnt_30d IS NOT NULL
         AND s.order_cnt_30d >= 15
        THEN 1
        ELSE 99
    END AS target_value_bool,

    NULL AS target_value_number,
    NULL AS target_value_string,

    -- enum_code：优先用字典，没有就回退为 bool 字符串
    COALESCE(te.enum_code, CAST(
        CASE
            WHEN e.additional_services IS NOT NULL
             AND FIND_IN_SET('3', e.additional_services) > 0
            THEN 1
            WHEN s.order_cnt_30d IS NOT NULL
             AND s.order_cnt_30d >= 15
            THEN 1
            ELSE 99
        END AS CHAR
    )) AS enum_code,

    'STORE'    AS source_level,
    'INFERRED' AS evidence_state,

    30 AS ttl_days,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('3', e.additional_services) > 0
        THEN 1.0000
        WHEN s.order_cnt_30d IS NOT NULL
         AND s.order_cnt_30d >= 15
        THEN 0.7000
        ELSE 0.5000
    END AS conf,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('3', e.additional_services) > 0
        THEN 'from_additional_services_3'
        WHEN s.order_cnt_30d IS NOT NULL
         AND s.order_cnt_30d >= 15
        THEN 'from_order_cnt_30d_ge_15'
        ELSE 'no_strong_evidence'
    END AS reason,

    'convenience_store_available_v1' AS algo_version,

    NULL AS target_value_string_back
FROM store_feature_snapshot_di s
LEFT JOIN dim_gas_store_info_extend e
  ON e.store_id = s.store_id
LEFT JOIN tag_enum te
  ON te.tag_code  = 'convenience_store_available'
 AND te.enum_code = CAST(
        CASE
            WHEN e.additional_services IS NOT NULL
             AND FIND_IN_SET('3', e.additional_services) > 0
            THEN 1
            WHEN s.order_cnt_30d IS NOT NULL
             AND s.order_cnt_30d >= 15
            THEN 1
            ELSE 99
        END AS CHAR
    )
WHERE s.as_of_date = @biz_date;
```

---

#### S2. 停车标签：etl\_tag\_stepS.1b\_parking\_available\_store

**逻辑口径（门店层）**

- 当前版本：
	- 所有油站默认视为“有停车位”；
	- future：再基于地理/城市等级做减法，或用 feedback 校正。
- 决策规则：
	- `parking_available = 1` ，conf=0.6，reason='default\_true\_v1'。

---

#### S3. 洗车有无：etl\_tag\_stepS.1c\_service\_carwash\_available\_store

**逻辑口径（门店层）**

- 输入： `dim_gas_store_info_extend.additional_services` 。
- 决策规则：
	- 若 additional\_services 含 1： `service_carwash_available = 1` ，conf=1.0；
	- 否则： `service_carwash_available = 0` ，conf=0.8（结构性没有车洗）。
```sql
sql-- etl_tag_stepS.1c_service_carwash_available_store
-- 生成 service_carwash_available 门店层标签（additional_services=1）

DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'service_carwash_available';

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
    'service_carwash_available' AS tag_code,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('1', e.additional_services) > 0
        THEN 1
        ELSE 0
    END AS target_value_bool,

    NULL AS target_value_number,
    NULL AS target_value_string,

    COALESCE(te.enum_code, CAST(
        CASE
            WHEN e.additional_services IS NOT NULL
             AND FIND_IN_SET('1', e.additional_services) > 0
            THEN 1
            ELSE 0
        END AS CHAR
    )) AS enum_code,

    'STORE'    AS source_level,
    'INFERRED' AS evidence_state,

    30 AS ttl_days,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('1', e.additional_services) > 0
        THEN 1.0000
        ELSE 0.8000
    END AS conf,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('1', e.additional_services) > 0
        THEN 'from_additional_services_1'
        ELSE 'no_carwash_flag_in_additional_services'
    END AS reason,

    'service_carwash_available_v1' AS algo_version,

    NULL AS target_value_string_back
FROM store_feature_snapshot_di s
LEFT JOIN dim_gas_store_info_extend e
  ON e.store_id = s.store_id
LEFT JOIN tag_enum te
  ON te.tag_code  = 'service_carwash_available'
 AND te.enum_code = CAST(
        CASE
            WHEN e.additional_services IS NOT NULL
             AND FIND_IN_SET('1', e.additional_services) > 0
            THEN 1
            ELSE 0
        END AS CHAR
    )
WHERE s.as_of_date = @biz_date;
```

---

#### S4. 洗车类型：etl\_tag\_stepS.1d\_service\_carwash\_type\_store

**逻辑口径（门店层）**

- 前提： `service_carwash_available` 已算好；
- 依赖字段： `v_merchant_profile_latest_di.service_carwash_type` （假定存在，值应为 `machine/manual/none` 或 NULL）；
- 决策规则：
	- 若 `service_carwash_available = 0` ：
		- `service_carwash_type = 'none'` （业务值，不是兜底），conf=1.0；
	- 若 `service_carwash_available = 1` 且 DW 字段有值：
		- 用 DW 字段值（machine/manual），conf=0.9；
	- 若 `service_carwash_available = 1` 且 DW 字段无值：
		- 类型 Unknown → 使用 enum\_code='99'，conf=0.5。

> 注：如果你实际字段名不是 `service_carwash_type` ，记得替换为真实字段。

```sql
sql-- etl_tag_stepS.1d_service_carwash_type_store
-- 生成 service_carwash_type 门店层标签（依赖 service_carwash_available + DW 字段）

DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'service_carwash_type';

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
    'service_carwash_type' AS tag_code,

    NULL AS target_value_bool,
    NULL AS target_value_number,

    -- 文本值直接等于 enum_code（machine/manual/none/99）
    CASE
        WHEN ca.target_value_bool = 0 THEN 'none'
        WHEN ca.target_value_bool = 1 AND vm.service_carwash_type IS NOT NULL
        THEN vm.service_carwash_type
        ELSE '99'
    END AS target_value_string,

    COALESCE(
        te.enum_code,
        CASE
            WHEN ca.target_value_bool = 0 THEN 'none'
            WHEN ca.target_value_bool = 1 AND vm.service_carwash_type IS NOT NULL
            THEN vm.service_carwash_type
            ELSE '99'
        END
    ) AS enum_code,

    'STORE'    AS source_level,
    'INFERRED' AS evidence_state,

    30 AS ttl_days,

    CASE
        WHEN ca.target_value_bool = 0 THEN 1.0000
        WHEN ca.target_value_bool = 1 AND vm.service_carwash_type IS NOT NULL THEN 0.9000
        ELSE 0.5000
    END AS conf,

    CASE
        WHEN ca.target_value_bool = 0 THEN 'no_carwash_type_none'
        WHEN ca.target_value_bool = 1 AND vm.service_carwash_type IS NOT NULL THEN 'from_dw_carwash_type_field'
        ELSE 'carwash_available_but_type_unknown'
    END AS reason,

    'service_carwash_type_v1' AS algo_version,

    NULL AS target_value_string_back
FROM store_feature_snapshot_di s
LEFT JOIN store_tag_snapshot_di ca
  ON ca.store_id   = s.store_id
 AND ca.as_of_date = s.as_of_date
 AND ca.tag_code   = 'service_carwash_available'
LEFT JOIN v_merchant_profile_latest_di vm
  ON vm.store_id = s.store_id
 AND vm.dt       = DATE_FORMAT(@biz_date, '%Y-%m-%d')
LEFT JOIN tag_enum te
  ON te.tag_code  = 'service_carwash_type'
 AND te.enum_code = CASE
                        WHEN ca.target_value_bool = 0 THEN 'none'
                        WHEN ca.target_value_bool = 1 AND vm.service_carwash_type IS NOT NULL
                        THEN vm.service_carwash_type
                        ELSE '99'
                    END
WHERE s.as_of_date = @biz_date;
```

> 如果 `v_merchant_profile_latest_di` 没有 `service_carwash_type` 字段，先用 `NULL` 占位，类型全部走 `none` / '99' 流。

---

#### S5. 卫生间：etl\_tag\_stepS.1e\_restroom\_available\_store

**逻辑口径（门店层）**

- 依赖：
	- `dim_gas_store_info_extend.additional_services` （0 = 卫生间）；
	- `convenience_store_available` 标签（已算好）。
- 决策规则：
	- 若 additional\_services 含 0： `restroom_available = 1` ，conf=1.0；
	- 否则若 convenience\_store\_available = 1： `restroom_available = 1` ，conf=0.9；
	- 否则： `restroom_available = 99` （未知），conf=0.5。
```sql
sql-- etl_tag_stepS.1e_restroom_available_store
-- 生成 restroom_available 门店层标签（来自 additional_services=0 或便利店派生）

DELETE FROM store_tag_snapshot_di
 WHERE as_of_date = @biz_date
   AND tag_code   = 'restroom_available';

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
    'restroom_available' AS tag_code,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('0', e.additional_services) > 0
        THEN 1
        WHEN cv.target_value_bool = 1
        THEN 1
        ELSE 99
    END AS target_value_bool,

    NULL AS target_value_number,
    NULL AS target_value_string,

    COALESCE(te.enum_code, CAST(
        CASE
            WHEN e.additional_services IS NOT NULL
             AND FIND_IN_SET('0', e.additional_services) > 0
            THEN 1
            WHEN cv.target_value_bool = 1
            THEN 1
            ELSE 99
        END AS CHAR
    )) AS enum_code,

    'STORE'    AS source_level,
    'INFERRED' AS evidence_state,

    30 AS ttl_days,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('0', e.additional_services) > 0
        THEN 1.0000
        WHEN cv.target_value_bool = 1
        THEN 0.9000
        ELSE 0.5000
    END AS conf,

    CASE
        WHEN e.additional_services IS NOT NULL
         AND FIND_IN_SET('0', e.additional_services) > 0
        THEN 'from_additional_services_0'
        WHEN cv.target_value_bool = 1
        THEN 'from_convenience_store_available'
        ELSE 'no_strong_evidence'
    END AS reason,

    'restroom_available_v1' AS algo_version,

    NULL AS target_value_string_back
FROM store_feature_snapshot_di s
LEFT JOIN dim_gas_store_info_extend e
  ON e.store_id = s.store_id
LEFT JOIN store_tag_snapshot_di cv
  ON cv.store_id   = s.store_id
 AND cv.as_of_date = s.as_of_date
 AND cv.tag_code   = 'convenience_store_available'
LEFT JOIN tag_enum te
  ON te.tag_code  = 'restroom_available'
 AND te.enum_code = CAST(
        CASE
            WHEN e.additional_services IS NOT NULL
             AND FIND_IN_SET('0', e.additional_services) > 0
            THEN 1
            WHEN cv.target_value_bool = 1
            THEN 1
            ELSE 99
        END AS CHAR
    )
WHERE s.as_of_date = @biz_date;
```

---

#### S6. 审计日志：etl\_tag\_stepS.2\_service\_tags\_audit\_store

**逻辑口径**

- 类似 open\_hours/open\_24h 的审计，只不过先做 store-only 版：
	- 每个服务标签写一条审计记录：
		- chosen\_level = 'STORE'；
		- chosen\_value\_string：用可读字符串表示（如 'Y'/'N'/'UNKNOWN' 或枚举值）；
		- conf\_final = store\_tag\_snapshot\_di.conf；
		- trace\_json：记录 strategy / algo\_version / reason 等。
```sql
sql-- etl_tag_stepS.2_service_tags_audit_store
-- 为服务标签写入门店层审计日志（store-only）

DELETE FROM tag_audit_log_di
 WHERE as_of_date   = @biz_date
   AND tag_code IN (
        'convenience_store_available',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type'
   )
   AND algo_version IN (
        'convenience_store_available_v1',
        'parking_available_v1',
        'restroom_available_v1',
        'service_carwash_available_v1',
        'service_carwash_type_v1'
   );

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
    t.tag_code,
    t.algo_version,

    t.source_level AS chosen_level,

    -- chosen_value_string：按类型转换成可读字符串
    CASE
        WHEN t.tag_code IN ('convenience_store_available', 'parking_available', 'restroom_available', 'service_carwash_available')
        THEN
            CASE t.target_value_bool
                WHEN 1  THEN 'Y'
                WHEN 0  THEN 'N'
                WHEN 99 THEN 'UNKNOWN'
                ELSE NULL
            END
        WHEN t.tag_code = 'service_carwash_type'
        THEN t.target_value_string
        ELSE NULL
    END AS chosen_value_string,

    t.enum_code AS chosen_enum_code,

    t.conf AS conf_final,

    t.conf AS conf_store,
    NULL   AS conf_merchant,
    NULL   AS conf_party,

    -- store-only 版本：candidate_store_string 使用 target_value_string / bool 映射
    CASE
        WHEN t.tag_code IN ('convenience_store_available', 'parking_available', 'restroom_available', 'service_carwash_available')
        THEN
            CASE t.target_value_bool
                WHEN 1  THEN 'Y'
                WHEN 0  THEN 'N'
                WHEN 99 THEN 'UNKNOWN'
                ELSE NULL
            END
        WHEN t.tag_code = 'service_carwash_type'
        THEN t.target_value_string
        ELSE NULL
    END AS candidate_store_string,

    NULL AS candidate_merchant_string,
    NULL AS candidate_party_string,

    0 AS manual_override_flag,

    JSON_OBJECT(
        'strategy', 'store_only_v1',
        'algo_version', t.algo_version,
        'reason', t.reason
    ) AS trace_json
FROM store_tag_snapshot_di t
WHERE t.as_of_date = @biz_date
  AND t.tag_code IN (
        'convenience_store_available',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type'
  );
```

---

### 5）迭代日志

- 来源：
	- 以上 SQL 基于你现有的营业时间 ETL 脚本结构（step0~stepB）和我们前面对服务标签算法、tag\_algo\_config 形态的对齐。
- 本轮输出：
	- 给出了服务标签门店层计算 + 审计的完整 SQL 模块（S1~S6），命名规则统一为 `etl_tag_stepS.*` ，你可以直接拼接到现有脚本中执行；
	- 逻辑上与前文需求文档保持一致：
		- 便利店：结构 + 行为启发；
		- 停车：默认真；
		- 洗车有无：结构标记；
		- 洗车类型：依赖有无 + DW 字段；
		- 卫生间：结构 + 便利店派生。
- 待办/下一步建议：  
	1）你在开发库中按顺序执行新 SQL，验证五个服务标签的覆盖率与异常站点（方便我们后续调规则）；  
	2）下一轮，我们在这个基础上：
	- 设计服务标签的 candidate\_di + 三层决策（复用 open\_hours\_decision 模式）；
	- 再一起把服务标签从 store\_tag\_snapshot\_di 迁移到 station\_tag\_target\_value，补上 QC 和兜底改写逻辑；  
		3）你执行后，把“覆盖率结果 + 肉眼看着不对劲的几类站点”反馈给我，我们再有针对性地调 conf 或规则条件。

20251207\_2300\_服务标签ETL\_数仓对齐与多管道优化说明  
tags: #服务标签 #数仓对齐 #覆盖率 #ETL管道 #性能优化

---

### 1）一句话结论

是的，你理解得完全对：我们需要在 ETL 设计中显式区分「数仓/区域已给的结果」和「本地补洞逻辑」，围绕“把现在不在覆盖率分子里的样本拉进分子”来设计优先级和改写规则；同时，管道上每个 tag\_code 都会跑一遍，但可以通过共享特征 +统一后处理来控制整体效率。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 论据一：现状与问题——上游已有部分结果，现有 ETL 默认“重算一遍”

你现在的链路里，open\_hours/open\_24h 已经走的是“从 v\_merchant\_profile\_latest\_di 抽特征 → 三层特征快照 → 三层决策 → 写 store\_tag\_snapshot\_di / tag\_audit\_log\_di”的标准流程。

但对服务标签有一个新事实：

- v\_merchant\_profile\_latest\_di 里已经存在一部分 **区域/数仓上报的服务标签结果** ，本质上是“上一代版本的标签值”：
	- 有些是人工/区域首报（可信度高）；
	- 有些是 DW 侧已有算法算出来的（也应该优先尊重）；
- 你现在写的服务标签 ETL，是默认“从业务特征重新算一遍”，如果不加约束，可能会：
	- 无差别覆盖掉这些“上游已确认值”；
	- 把“本来在覆盖率分子里的样本”改成我们自己的推断，反而增加不确定性。

同时，你提到的目标也很关键：

> 覆盖率提升，是要对“不在分子里的那一部分标签”动刀，而不是对已经在分子里的部分反复重算。

所以， **区分“已有数仓结果” vs “需要补洞的样本”** ，确实是现在必须设计清楚的一块。

---

#### 论据二：策略——「上游值优先 + 本地补洞」的双层 ETL 模式

我建议把每个标签的 ETL 明确分成两个逻辑层，而不是“一刀切全重算”：

##### 1）S1 层：承接上游（DW/区域）的“已算好”结果

- 对于在 `v_merchant_profile_latest_di` 中已经存在的字段（不管是服务标签还是 B 类标签），统一做 **第一层写入** ：
	- 把上游结果写入 `store_tag_snapshot_di` ，并标记为：
		- `source_level = 'STORE'`
		- `evidence_state = 'FOUND_IN_RAW' / 'CONFIRMED'` （视你的口径）
		- `reason = 'from_dw_or_region'`
		- 再根据 `tag_enum.is_default` 设置 `qc_value_has_meaning` ：
			- 若 enum\_code 对应枚举 `is_default = 0` → `qc_value_has_meaning = 1` → 直接进覆盖率分子；
			- 若 enum\_code 对应枚举 `is_default = 1` （例如 99 Unknown） → `qc_is_fallback_value = 1` 且 `qc_value_has_meaning = 0` 。
- 这层 ETL 做的事情非常简单：
	- “把数仓/区域的当前版本结果结构化接进来，并在 QC 上贴标签”。

##### 2）S2 层：本地补洞 / 提升覆盖率（只对“分母里未进分子”的样本动手）

- 在 S1 完成后，第二层 ETL 再对同一标签做“补洞逻辑”，但有几个硬约束：
	1） **不覆盖上游已确认业务值** ：
	- 如果该 store/tag 的记录满足：
		- `evidence_state IN ('FOUND_IN_RAW','CONFIRMED')`
		- 且枚举 `is_default = 0`  
			→ 我们不去覆盖，最多在后续三层决策里“把上游视为一个候选之一”。
	2）优先处理两类样本：
	- 没有记录：即 `store_tag_snapshot_di` 当前没有该 tag 的行 → 本地算一条补上；
	- 有记录，但值为兜底（enum\_code 对应 `is_default = 1` ）或 `qc_value_has_meaning = 0` → 可以通过配置决定是否允许“兜底改写”。
	3）和覆盖率目标绑定：
	- 覆盖率分子 = 非兜底枚举 + `qc_value_has_meaning = 1` ；
	- 我们所有“补洞动作”，本质就是把“当前落在分母不在分子”的样本往“分子”推：
		- 从“无记录” → “有业务值”；
		- 从“兜底枚举” → “业务值”（并打 `qc_is_fallback_value = 1` ）。
- 实现形态上，可以按以下模式来写：
	- 步骤 A：S1 承接数仓值（ `INSERT ... ON DUPLICATE KEY UPDATE` 或 delete+insert）；
	- 步骤 B：S2 用 `INSERT ... ON DUPLICATE KEY UPDATE` ，但在 UPDATE 里加条件，只在“上游值为空或兜底”的场景下改写，例如伪代码：
	- 这里 `te_existing` 是通过当前 enum\_code 左联 tag\_enum 得到的 is\_default 状态。

这样设计之后， **数仓/区域上报的值永远是“第一优先级”，本地补洞只针对“空”或“兜底”** ，就和你“覆盖率提升”的目标完全对齐了。

---

#### 论据三：落地与性能——每个 tag 逻辑上走一遍管道，但共用特征和后处理

你说的第二个问题也对：

> “是不是每个 code 都会跑一遍 ETL 管道？多管道的效率如何优化？”

答案分两层：

##### 1）逻辑视角：是的，每个 tag 都有自己的“算法管道”

- 从“可维护性”和“解释性”角度， **每个 tag 确实应该有独立的算法声明 + ETL 逻辑** ：
	- 在 `tag_algo_config` 里有自己的 algo\_mode/rule\_template/extra\_config\_json；
	- 在 SQL 脚本里有自己的 step 名称（你已经定了类似 `etl_tag_stepS.1a_*` ）。
- 否则后面一定会变成“所有逻辑都揉在一起的 if-else 地狱”，新人根本搞不清楚每个标签是怎么来的。

##### 2）执行视角：可以把重型步骤和后处理共享，避免 N×全表扫

优化点主要有三个：

1） **共享特征表**

- 你已经做到了：
	- `store_feature_snapshot_di / merchant_feature_snapshot_di / party_feature_snapshot_di` 这三张表只在 step2 里跑一次，后面所有标签共用。
- 对服务标签，我们可以约束：
	- 所有逻辑一律基于这些特征表 + `dim_gas_store_info_extend` + `v_merchant_profile_latest_di` ；
	- 不再为每个标签重复做复杂 JOIN，而是把公共 JOIN 抽成一个临时表，比如 `tmp_store_service_features` ，里面一次性抽出：
		- store\_id, as\_of\_date
		- additional\_services
		- 相关 DW 字段（比如 service\_carwash\_type）、open\_hours 等
	- 然后每个标签的 INSERT 只 scan 这个 tmp 表，成本就从 N×全表 JOIN 变为 N×单表 scan。

2） **共享 QC & 兜底后处理**

- 我们可以把“改写 99→业务值 + 写 qc\_is\_fallback\_value”做成 **一个通用 step** ：
	- 例如 `etl_tag_stepQ.1_apply_fallback_rewrite` ：
		- 从 `station_tag_target_value` 中选出 `qc_is_fallback_value=0 AND enum_code='99' AND tag_algo_config.extra_config_json->'$.fallback_enable_unknown_rewrite'=1` 的记录；
		- 按每个 tag 的 config 决定改写成什么 enum\_code，并顺带写 QC 字段。
- 这样避免在每个 tag 的脚本里复制一遍兜底改写逻辑，后续想调整某个规则时，也只改一处。

3） **执行顺序优化**

- 把“所有 tag 的 S1（承接 DW/区域）”放在一个阶段，所有 tag 的 S2（本地补洞）放在一个阶段：
	- 例如：
		- `etl_tag_stepS1.*` ：各标签从 v\_merchant\_profile\_latest\_di 承接上游值；
		- `etl_tag_stepS2.*` ：各标签进行本地补洞；
		- `etl_tag_stepQ.*` ：所有标签统一做 QC/兜底后处理；
		- `etl_tag_stepT.*` ：统一迁移到 station\_tag\_target\_value。
- 这样，“重 JOIN + 重写入”的阶段都是批量、结构化的，更好调优。

---

### 3）思维导图结构（文本分层）

1. 问题收敛  
	1.1 上游已有部分服务标签结果（v\_merchant\_profile\_latest\_di）  
	1.2 覆盖率目标是“把不在分子里的样本拉进分子”  
	1.3 当前 ETL 默认重算，可能覆盖上游结果
2. 策略设计  
	2.1 双层 ETL：  
	\- S1：承接 DW/区域值（上游优先）  
	\- S2：本地补洞（只动“空/兜底”样本）  
	2.2 覆盖率口径与 QC：  
	\- 分子：非兜底 + qc\_value\_has\_meaning=1  
	\- 兜底改写：qc\_is\_fallback\_value=1  
	2.3 每 tag 都有独立管道，但共享特征 & 后处理
3. 落地与优化  
	3.1 S1：DW→store\_tag\_snapshot\_di 写入策略（FOUND\_IN\_RAW / CONFIRMED）  
	3.2 S2：用于补洞的 INSERT... ON DUPLICATE KEY UPDATE 模式  
	3.3 性能优化：  
	\- 共享特征临时表  
	\- 统一 fallback/QC 后处理 step  
	\- 批量执行顺序规划
4. 下一步 TODO  
	4.1 先选一个标签（比如 convenience\_store\_available），落地 “S1 上游承接 + S2 本地补洞” 的完整 SQL  
	4.2 跑一版覆盖率结果，对比“DW 自身覆盖率 vs DW+补洞后的提升”  
	4.3 再复制模式到其他服务标签

---

### 4）迭代日志（来源 / 结论 / 改动点 / 下一步建议）

- 来源
	- 你刚刚把“服务标签逻辑”写入查询，并提出两点关键疑问：  
		1）如何在 ETL 中区分“已有 v\_merchant\_profile\_latest\_di 值”和“需要补洞的样本”？  
		2）多个 tag 管道同时跑时，整体效率如何控制？
	- 参考现有 open\_hours/open\_24h 的完整脚本结构。
- 本轮结论  
	1）确认 ETL 需要显式区分“上游值优先 + 本地补洞”，不能暴力覆盖；  
	2）逻辑上，每个 tag 都有独立管道是合理的，但在实现上可通过：
	- 共享特征（snapshot 表 + 临时表）
	- 共享 QC/兜底后处理 step  
		来降低整体成本。
- 改动点（设计层）
	- 引入 S1/S2 二层模型：S1 负责承接 v\_merchant\_profile\_latest\_di 的结果，S2 负责针对“空/兜底样本”做本地推断；
	- 提出用 `INSERT ... ON DUPLICATE KEY UPDATE` + tag\_enum.is\_default 的组合来精确控制“哪些行可以被算法改写”。
- 下一步建议（非常具体）  
	1）我们可以先选一个标签当“样板工程”——比如 `convenience_store_available` ：
	- S1：写一段 SQL，把 v\_merchant\_profile\_latest\_di 里已有的 convenience 字段，按枚举/QC 规则写入 store\_tag\_snapshot\_di；
	- S2：在此基础上，只对“无记录/兜底记录”应用你刚刚那套“结构 + 行为启发”的逻辑；  
		2）你跑完这两步后，我们一起看：
	- 覆盖率提升了多少；
	- 有多少是 `qc_is_fallback_value=1` 的样本；  
		3）验证通过后，再把同样的 S1/S2 模式复制到 parking/restroom/carwash\_available/carwash\_type 等服务标签。

如果你愿意，我们下一步就直接从 `convenience_store_available` 开始，把 **“S1 承接 DW + S2 补洞”** 写成两段可跑的 SQL（沿用你现在的命名规范），你直接拿去测。

好的.我同意,我需要知道,这个改造,跑通之后是符合复通到整体的其他标签上呢?需要有完整的计划;并详细的说明,并记住我们的终极目标是快速提升覆盖率;

20251207\_2330\_服务标签ETL双层管道\_全局推广与覆盖率提升规划  
tags: #服务标签 #覆盖率90 #双层管道S1S2 #tag\_algo\_config #station\_tag\_target\_value

---

### 1）一句话结论

这次把「S1 上游承接 + S2 本地补洞」跑通在服务标签上，不是一次性的 hack，而是未来所有标签（服务、品牌、策略）的统一 ETL 模板——只要按这个模板推开，站在 `station_tag_target_value + tag_algo_config` 视角，整体覆盖率可以稳步、可控地向 90%+ 抬升。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 论据一：现状——标签多源，缺“上游优先 + 补洞有界”的统一骨架

- 标签现状是三层混在一起：
	- 一部分已经在 DW/区域中算好（甚至是人肉上报）→ `v_merchant_profile_latest_di` 已有字段（包括不少服务标签）；
	- 一部分是你这次要用行为/规则推断的（open\_hours、convenience、restroom 等）；
	- 一部分未来还会继续生长（更多 A 类服务/策略标签）。
- 当前问题：
	- 以前的脚本更偏「重算」，不区分“上游已经有值” vs “真空/兜底样本”；
	- 覆盖率的“分子”来自 `station_tag_target_value` ，但 ETL 并没有围绕“把不在分子里的样本拉进去”来设计，而是按标签各自写 SQL。
- 你的目标很清晰：
	> 短期内快速提升服务标签覆盖率，不破坏数仓/区域现有结果，把有限开发精力用在“补洞”上，而不是重造每个标签的轮子。

#### 论据二：策略——「S1 承接上游 + S2 本地补洞 + 通用 QC & 兜底」的统一 ETL 模板

我们现在定的双层模型，本质上是“一个可以复用给所有标签的标准外骨骼”：

1） **S1：上游承接层（DW / 区域 / 其它系统）**

- 目标：把已经存在于 `v_merchant_profile_latest_di` 或 DW 的标签值， **完整搬到 `store_tag_snapshot_di`** ，并打清楚“这是上游给的”。
- 行为：
	- 对每个标签：
		- 读取 v\_merchant\_profile\_latest\_di.xxxx\_field；
		- 映射到 enum\_code（对齐 tag\_enum）；
		- 设置：
			- `evidence_state = FOUND_IN_RAW / CONFIRMED` （视字段来源）
			- `qc_value_has_meaning = (enum 对应 is_default=0 ? 1 : 0)`
			- `qc_is_fallback_value = (is_default=1 ? 1 : 0)`
		- 统一落入 `store_tag_snapshot_di` 。
- 原则：上游结果优先，不在这一层做“洗脑式重算”。

2） **S2：本地补洞层（只动“空/兜底/无意义”的样本）**

- 目标： **只针对“当前不在覆盖率分子里的样本”下手** ：
	- store×tag 没记录；
	- 或者有记录，但 enum\_code 是兜底（is\_default=1）/ `qc_value_has_meaning=0` 。
- 行为：
	- 通过你设计的规则（结构/行为/派生）算出一个候选业务值；
	- 用 `INSERT ... ON DUPLICATE KEY UPDATE` ，只在“空/兜底”的场景覆盖：
		- 不动上游的业务值；
		- 改写时打上 `qc_is_fallback_value=1` 或 `reason` 增加 `|patched_by_algo` 。
- 结果：
	- 每一次补洞，都直接增加“非兜底 + 有意义”的记录数 → 覆盖率分子上升。

3） **统一 QC & 兜底后处理（适用于所有标签）**

- 再往后，在 `station_tag_target_value` 层可以统一做：
	- 兜底改写（从 99 → 默认业务值）按 config 白名单控制；
	- 所有“改写发生”的记录：
		- `qc_is_fallback_value=1` ；
		- 进入覆盖率分子，但在质量看板里单独统计“兜底覆盖率”。
- 这部分逻辑与 tag\_algo\_config.extra\_config\_json 严格对齐：
	- `fallback_enable_unknown_rewrite`
	- `fallback_unknown_enum_code`
	- `fallback_rewrite_target_enum_code`

> 换句话说：只要这个外骨骼定死，对任何标签，我们都能分三步问自己：  
> 1）上游已经给我什么？（S1）  
> 2）还有哪块是空/兜底，我能用什么规则补？（S2）  
> 3）哪些补洞是兜底性质，需要在 QC 上被盯住？（统一后处理）

#### 论据三：落地与推广——先打磨“服务标签模板”，再复制到全量标签

- 落地策略：
	- 第一步：用 convenience\_store\_available 做「S1+S2 全套样板」，验证以下 3 点：  
		1） **覆盖率曲线** ：看 S1（纯承接） vs S1+S2（补洞后）的覆盖率差异；  
		2） **DW 结果是否被尊重** ：抽样对比上游有值的样本，确认我们没乱动；  
		3） **性能与可维护性** ：脚本结构是否清晰、可读、可扩展。
	- 第二步：把同样结构推广到 parking/restroom/carwash\_available/carwash\_type，再推广到其它 A 类标签；
	- 第三步：对 B 类/策略类标签，S1 基本全是 WAREHOUSE\_DIRECT，S2 是否需要“补洞”（例如品牌/生命周期）可以按业务优先级选择。
- 风险与兜底：
	- 风险 1：S2 规则过于激进，带来了“假覆盖率”。
		- 兜底：所有 S2 改写必须打 `qc_is_fallback_value=1` ，在覆盖率看板上强制拆成“自然覆盖率 vs 补洞覆盖率”；
	- 风险 2：tag\_algo\_config 与实际实现脱节。
		- 兜底：所有 ETL 代码命名+注释必须遵循 `rule_template` 命名；任何改动先从 config 开始。

---

### 3）思维导图结构（执行规划）

#### 3.1 总体推广路线：从单标签样板 → 服务标签集 → 全量标签

1. **样板阶段（单标签）**
	- 对象： `convenience_store_available`
	- 目标：
		- 打通 S1（承接 DW/区域值）+ S2（补洞逻辑）的完整链路；
		- 看一次“真实覆盖率提升”的效果；
	- 输出：
		- 2 段 SQL：
			- `etl_tag_stepS1.1_convenience_store_available_store_from_dw`
			- `etl_tag_stepS2.1_convenience_store_available_store_patch`
		- 一组覆盖率对比结果（表：覆盖率前后值）。
2. **服务标签集阶段（同一逻辑模板扩散）**
	- 对象：
		- `parking_available`
		- `restroom_available`
		- `service_carwash_available`
		- `service_carwash_type`
	- 对每个标签：
		- 定义 S1：从 v\_merchant\_profile\_latest\_di 把已有结果搬到 store\_tag\_snapshot\_di，打好 QC；
		- 定义 S2：基于我们前面定好的规则，只补“空/兜底”部分；
	- 输出：
		- S1+S2 统一命名 SQL 模块；
		- 服务标签整体覆盖率看板：
			- 每个标签： `自然覆盖率` vs `总覆盖率（含补洞）` vs `兜底覆盖率占比` 。
3. **全量标签阶段（骨架复用）**
	- 对象：
		- 品牌/合作类： `brand_name, brand_level, is_ka_direct, store_life`
		- 策略/运营类： `competitive_overlap, sme_supplier_partner, sme_supplier, wyc_pricing_enabled`
	- 统一骨架：
		- 绝大多数只需要 S1（WAREHOUSE\_DIRECT）；
		- 某些标签（例如 brand\_level/store\_life）如果将来要补洞，也可以挂 S2。
	- 输出：
		- 所有 tag\_code 在 `tag_algo_config` 里都有对应的 S1/S2 思路；
		- 所有 tag\_code 在 `station_tag_target_value` 中都有统一的 QC 和覆盖率计算。

---

#### 3.2 和“快速提升覆盖率”的直接挂钩

**关键：我们只对“分母不在分子”的部分发力**

- 分母：某一日/周期，选定站点集合 × 某一 tag\_code 的理论样本数（比如所有在营站）；
- 分子：
	- 落在 `station_tag_target_value` 里，且满足：
		- `enum_code` 对应 `tag_enum.is_default=0` （非兜底枚举）；
		- `qc_value_has_meaning=1` 。
- S1 层：
	- 把 DW/区域已给值搬进来 → 增加“自然覆盖率”的分子；
- S2 层：
	- 对“没记录 + 兜底记录”进行补洞 → 增加“兜底覆盖率”这一块分子；
- 配合 QC 拆分：
	- 你可以很清晰地看到：
		- 不做改造时，自然覆盖率是多少；
		- 加上 S1 后，自然覆盖率提升多少；
		- 再加 S2 后，总覆盖率达到多少，兜底覆盖率占比多少。

> 所以这套骨架从一开始就是“围绕覆盖率指标设计”的：ETL 不再是为做而做，而是每一段 SQL 都清楚地知道自己在给“分子加几分”。

---

#### 3.3 多管道执行效率：可以达成“逻辑上 per-tag，物理上共用”

1. **逻辑维度：保证 per-tag 清晰**
	- 每个 tag\_code 必须有自己的：
		- `rule_template` （在 config 里）
		- `stepS1.x_tag_code_store_from_dw`
		- `stepS2.x_tag_code_store_patch`
	- 这样你以后查一个标签，只需：
		- 看 tag\_algo\_config.extra\_config\_json；
		- 搜索对应的 step 名称，即可精确找到它的逻辑。
2. **物理维度：减少重复 IO**
- 重用特征：
	- 所有标签都基于同一批 snapshot 表和特征临时表（尤其是 dim\_gas\_store\_info\_extend 和 v\_merchant\_profile\_latest\_di 的 JOIN），避免每个标签独立做重型 JOIN。
- 统一后处理：
	- QC 和兜底改写（从 99 → 默认值）通过一两个通用 step 完成，不在每个标签里重复写一遍。
- 执行顺序打包：
	- 例如：
		1）step0：detect\_biz\_date  
		2）step1：三层 snapshot（你已有）  
		3）stepS1.*：所有标签 S1 一次跑完（DW 承接）  
		4）stepS2.*：所有标签 S2 一次跑完（补洞）  
		5）stepQ.*：统一 QC 和兜底改写  
		6）stepT.*：统一 insert into station\_tag\_target\_value  
		7）stepM.\*：覆盖率统计与监控输出

---

### 4）迭代日志（来源 / 结论 / 改动点 / 下一步建议）

- 来源
	- 你刚刚确认了服务标签的规则逻辑，并提出两个关心点：  
		1）如何在 ETL 中明确区分“已有上游结果”和“需要补洞的部分”，让改造方向真正对准覆盖率分子；  
		2）多标签、多管道同时跑时，整体效率如何设计和优化。
- 本轮结论  
	1）确认“双层管道（S1 上游承接 + S2 本地补洞）+ 通用 QC & 兜底”的外骨骼，可以复用到所有标签，而不是仅服务标签；  
	2）确认 ETL 的设计必须围绕“分母不在分子”的样本来动手，S2 只动空/兜底样本，S1 永远尊重上游结果；  
	3）从执行角度，通过共享 snapshot & 统一后处理，可以让“逻辑 per-tag、物理共享”的模式成立。
- 改动点（认知/规划）
	- 从“按标签各自写 SQL”升级到“所有标签走相同 ETL 外骨骼，只在规则内部差异化”；
	- 将 DW/区域结果显式视为算法的“第一层候选”，而不是被隐性覆盖。
- 下一步建议（非常具体）  
	1）我们以 `convenience_store_available` 为样板标签，落地两段 SQL：
	- `etl_tag_stepS1.1_convenience_store_available_store_from_dw` ：只把 v\_merchant\_profile\_latest\_di 里的现有便利店结果接入 store\_tag\_snapshot\_di，并打 QC；
	- `etl_tag_stepS2.1_convenience_store_available_store_patch` ：只对“空/兜底”样本应用你刚刚那套结构+行为规则，做补洞。  
		2）你在开发库执行这两段后：
	- 算一版“便利店标签”的：自然覆盖率 / 总覆盖率 / 兜底覆盖率占比；
	- 抽几类边界案例（有便利店但没上报、上游标 Unknown 但我们推断有/无）。  
		3）验证便利店样板之后，我们按同样 S1+S2 模式扩到 parking/restroom/carwash\_available/carwash\_type，并做一次“服务标签整体覆盖率提升”的汇总（这就是你可以给老板看的“服务标签 90% 提升交付”）。

如果你愿意，下一步我们就直接对 `convenience_store_available` 写那两段 S1/S2 的具体 SQL（按你现有脚本风格命名），你可以直接粘贴去跑，看看覆盖率曲线长什么样。

20251207\_标签ETL\_知识库与文档体系设计  
tags: #标签ETL #服务标签 #文档体系 #数据血缘 #表备注规范

---

### 1）一句话结论

建议把这套 ETL 做成一个“可长期运维的知识库”：一份中心文档 + 若干模块化模板（标签说明、表说明、作业列表、血缘关系、变更记录），配合在所有建表语句上强制写“标准化表级备注 + 关键字段备注”，让任何人 10 分钟内能搞清楚「这个标签/这张表是干什么的、从哪来、怎么用」。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 论据一：现状——逻辑越来越复杂，但“知识只有你知道”

- 你现在这套东西，其实已经从“写几段 SQL”升级成了：
	- 一套统一的标签 ETL 外骨骼（S1 上游承接 + S2 补洞 + QC & 兜底 + station\_tag\_target\_value 落表）；
	- 一整套标签体系（tag\_spec/tag\_enum/tag\_catalog + tag\_algo\_config）；
	- 一堆中间表和视图（ *\_snapshot\_di、* \_candidate\_di、\*\_latest\_di、station\_tag\_target\_value 等）。
- 如果不把这些逻辑、关系、口径收束到一份“权威文档”里，未来会有几个必然问题：
	- 新人/合作方理解成本极高；
	- 过一段时间你自己也会忘记“某些边缘规则当初为什么这样写”；
	- 调整一个标签的算法，很难确保不踩到其它标签 / 下游看板。

#### 论据二：策略——设计一个专属的 ETL 知识库 + 标准化表备注规范

我建议把“文档”本身当成一个产品来设计，而不是一个随手记的文档：

- 文档层面：
	- 只有一份“入口文档”，可以拆成多个章节，但读者不用在十几个文件里乱跳；
	- 每个标签、每张表、每条 ETL 作业，都有固定的“描述模板”，看两三页你就能记住结构。
- 数据层面：
	- 所有建表语句必须带 **表级 COMMENT + 关键字段 COMMENT** ，而且建议使用统一格式，例如：
		> `业务域|层级|粒度|刷新频率|用途|上游|下游|负责人`
	- 这会在你看 INFORMATION\_SCHEMA / GUI 工具时，很快定位作用和上下游。

本质上你是要建一个“标签 ETL 蓝皮书”，而不是随便几页笔记。

#### 论据三：落地与风险——轻量开局，持续演进，而不是一次性写死

- 落地上不需要一上来就写一个 50 页的“说明书”，更好的方式是：
	- 先把“骨干结构 + 模板”确定下来（今天就可以定架子）；
	- 然后在你每次新增/改一个标签 ETL 时，顺手补齐这一页相关文档；
	- 典型是：先写 open\_hours/open\_24h + 服务标签的完整示例，再复制模式到其他标签。
- 风险在于：
	- 文档一旦太重、太难维护，就会变成“写过就没人看”的垃圾堆；
	- 或者表备注写得太抽象（比如“标签快照表”），实际查到时还是不懂。
- 解法就是：
	- 文档维持“骨干 +模板化”，每个模块不超过一页；
	- 表备注 / 字段备注用“机器可读 + 人能看懂”的短句，不要写长段话。

---

### 3）思维导图结构（文本分层）

#### 3.1 整体文档结构建议（可以当成目录）

我建议你把这份核心文档命名成类似：

> 《标签 ETL 总控文档（merchant\_profile\_tag\_etl\_bluebook\_v1）》

目录结构可以是：

1. **总览（Overview）**
	- 项目目标：双 90%、S1/S2 双层模型、station\_tag\_target\_value 终表定位
	- 核心组件一览：
		- 表：tag\_spec/tag\_enum/tag\_catalog/tag\_algo\_config/station\_tag\_target\_value 等
		- 视图：v\_merchant\_profile\_latest、各 \*\_latest\_di
		- 中间表： *\_snapshot\_di、* \_candidate\_di
	- 关键约定：
		- 三选一协议（bool/number/string）
		- enum\_code + tag\_enum.is\_default = 兜底口径
		- S1/S2/Q/T 阶段含义
2. **标签维度说明（按 tag\_code）**  
	每个标签一小节，结构统一：
	- 基本信息：tag\_code / 中文名 / tier1-3 / tag\_class / owner\_biz / owner\_data
	- 算法配置摘要：
		- algo\_mode / rule\_template（来自 tag\_algo\_config）
		- 是否 DERIVED、是否 WAREHOUSE\_DIRECT
	- 上游依赖：
		- 输入表 + 字段（v\_merchant\_profile\_latest\_di、\*\_snapshot\_di、dim\_gas\_store\_info\_extend 等）
		- 如有派生：derived\_source\_tags
	- 产出：
		- 产出到哪些表（store\_tag\_snapshot\_di / station\_tag\_target\_value 等）
		- 终表的 value\_type（bool/number/string）
	- 覆盖率策略：
		- 是否允许 fallback 改写
		- 自然覆盖率 vs 补洞覆盖率的关注点
	- 示例：典型站点的值（1-2 条）
3. **表级字典（按表）**  
	每张表一个小节：
	- 表信息：
		- 表名（含库名）
		- 表 COMMENT（你在 DDL 中写的那一行）
		- 数据粒度：store/merchant/party × 日期/快照
		- 刷新频率：日/小时/临时等
	- 字段字典（重点字段）：
		- 字段名 / 类型 / COMMENT（含英文术语）
		- 典型取值说明（比如 source/evidence\_state/enum\_code 的常见值）
	- 上下游：
		- 上游表：列表
		- 下游表：列表
	- 注意事项：
		- 哪些字段不能随便改（例如主键、渐变字段、QC 字段）。
4. **ETL 作业/脚本列表**
	- 每个 step 一行：
		- step 名： `etl_tag_stepS.1a_convenience_store_available_store`
		- 输入表
		- 输出表
		- 主要逻辑一句话： `从 additional_services + 订单启发生成便利店标签（门店层）`
	- 可以附一个整体流程图（哪怕是文本版的 DAG）。
5. **覆盖率 & QC 口径说明**
	- 覆盖率定义（分母/分子/过滤条件）
	- QC 字段的含义和使用场景
	- fallback 改写策略：哪些标签允许、如何统计兜底覆盖率。
6. **变更记录（Changelog）**
	- 时间 / 作者 / 变更内容 / 涉及标签 / 涉及表 / 影响说明
	- 比如： `2025-12-07：新增服务标签 S1/S2 双层 ETL，影响 convenience/parking/...`

---

#### 3.2 文档内的“模板”建议

为了让文档“可以一直更新下去”，强烈建议给自己定几个固定模板，复制填空即可。

1） **标签说明模板（示例）**

2） **表说明模板（示例）**

3） **作业/脚本说明模板（示例）**

---

#### 3.3 建表语句里“表备注”的建议写法

你说的“所有建表语句加完整表备注”，我非常赞成，而且建议你使用 **统一格式** ，比如：

字段层面同理：

这样做的好处：

- 你在任何 DB 管理工具里看一眼 COMMENT，就知道：
	- 这是哪一层（ODS/DW/DM/APP/特征/终表）；
	- 粒度是什么；
	- 刷新粒度；
	- 上下游主要是谁；
	- 谁负责。
- 和我们文档的结构是对齐的，文档只是提供更多文字和例子。

---

### 4）迭代日志

- 来源：
	- 你提出希望“给整体 ETL 建一个专属、可持续维护的文档体系”，并且希望建表语句里统一补充表备注；
	- 当前我们已经有：需求文档 + tag\_algo\_config 设计 + open\_hours/open\_24h + 服务标签 ETL 方案。
- 本轮结论：
	- 建议用“一份入口文档 + 模板化章节（标签/表/作业/覆盖率/变更）”的方式搭建“标签 ETL 蓝皮书”；
	- 所有建表语句统一使用规范化 COMMENT，作为文档的“机器可读元信息”；
	- 模板给出后，后续每写一个标签/表/脚本，只需要填模板，而不是重新想结构。
- 下一步建议：  
	1）你选一个载体（Notion/飞书文档/Markdown 仓库都行），先按我给的目录和模板开“v1 骨架”；  
	2）我们下一轮在写 `convenience_store_available` 的 S1/S2 SQL 时，就顺手填一份标签说明 + 作业说明，当作首个“标准示例”；  
	3）等服务标签这批都跑顺了，把这份文档直接作为“对齐老板/对齐 DW/对齐运营”的唯一入口，后面所有人都按这套规则接入新的标签。

20251207\_2355\_标签ETL\_双层管道需求说明书\_兼\_总控文档V1  
tags: #商户画像 #标签ETL #覆盖率90 #服务标签 #数仓对齐 #文档体系

---

## 1）一句话结论

我们将整套标签 ETL 统一升级为：以 `tag_algo_config` 为唯一算法说明中心、以 `station_tag_target_value` 为唯一终表、以「S1 数仓/区域承接 + S2 本地补洞 + 统一 QC/兜底后处理」为骨架的标签管道，并配套一份可长期运维的“标签 ETL 总控文档 + 表/字段备注规范”，目标是在不破坏上游结果的前提下，快速、可控地将服务标签等关键标签的有效覆盖率提升至 ≥90%。

---

## 2）三段论据（现状与问题 → 策略 → 落地与风险）

### 2.1 现状与问题——逻辑已然复杂，但“骨架”和“知识库”缺位

1. 业务目标清晰：
	- 商户画像项目中，服务标签（便利店、停车位、卫生间、洗车有无/类型）和营业时间标签（open\_hours/open\_24h），是核心 A 类标签，需要在短时间内把有效覆盖率（非兜底、有意义的标签值）推到 ≥90%。
	- 覆盖率指标已经有统一口径：
		- 分母：选定站点集合 × 标签（例如所有在营站）。
		- 分子： `station_tag_target_value` 中，对应 tag\_code 的记录，满足：
			- 枚举值 `enum_code` 对应 tag\_enum 中 `is_default = 0` （非兜底枚举），且
			- `qc_value_has_meaning = 1` 。
2. 数据与配置基础具备，但缺少统一骨架：
	- 有完整的标签字典体系： `tag_spec / tag_enum / tag_catalog` ，A/B 类标签、服务/品牌/策略维度划分清晰。
	- 有统一的上游视图： `v_merchant_profile_latest` ，整合 store/merchant/party 三层信息 + 数仓计算字段 + 部分服务标签区域上报结果。
	- 有算法配置表： `tag_algo_config` ，已包含三层决策所需的阈值/权重，并支持 `extra_config_json` 承载扩展配置。
	- 有终表： `station_tag_target_value` ，以及一套 QC 字段（ `qc_value_has_meaning / qc_is_fallback_value / qc_is_wrong_cleaning / qc_is_same_as_source / qc_is_meaningless_non_fallback` ）。
3. 当前缺口集中在三个层面：
	- 算法骨架：
		- 之前更多是“按标签各自写 SQL”，缺少统一的 S1/S2 管道定义与复用；
		- 数仓/区域上报的既有结果与本地算法推断之间的优先级、合流规则没有显式设计。
	- 覆盖率视角：
		- ETL 逻辑没有围绕“把当前不在分子里的样本拉进分子”来设计，补洞逻辑与覆盖率指标脱节。
	- 知识沉淀：
		- 没有一份权威的“标签 ETL 总控文档”，表字段说明、算法说明、上下游血缘分散在脑子和零散文档里；
		- 表/字段备注不统一，后续定位和交接成本高。

---

### 2.2 策略——双层管道 + 全局配置中心 + ETL 知识库

1. **双层管道：显式区分「数仓/区域已给结果」与「本地补洞逻辑」**
	我们为每一个 tag\_code 明确两个逻辑层（S1/S2），并用统一语义描述：
	- S1：上游承接层（DW/区域/其它系统）
		- 目标： **原封承接 `v_merchant_profile_latest` / DW 中已算好的标签值到 `store_tag_snapshot_di`** ，不做“重算”，只做结构化 + QC 标记。
		- 行为：
			- 将上游字段映射为 `target_value_* + enum_code` ；
			- 用 tag\_enum 的 `is_default` 判断是否兜底：
				- `is_default = 0` → 业务值 → `qc_value_has_meaning = 1` ；
				- `is_default = 1` → 兜底值 → `qc_is_fallback_value = 1` ， `qc_value_has_meaning = 0` ；
			- `evidence_state` 设为 `FOUND_IN_RAW` 或 `CONFIRMED` （视上游来源）。
		- 原则： **不在 S1 层做算法上的“洗脑”，只尊重上游。**
	- S2：本地补洞层（只对“不在覆盖率分子里的样本”动手）
		- 目标：通过结构/行为/派生规则， **只对“当前没有记录或只有兜底值”的样本补洞** ，将其尽可能转化为业务值，增加覆盖率分子。
		- 行为：
			- 识别补洞目标：
				- store×tag 没有记录；
				- 或 enum\_code 对应 `is_default = 1` / `qc_value_has_meaning = 0` 。
			- 使用标签特定的算法规则（MIXED\_INFER / STRUCT\_FLAG / DERIVED / DEFAULT\_TRUE）计算候选业务值；
			- 用 `INSERT ... ON DUPLICATE KEY UPDATE` ，仅在上述条件成立时改写现有记录：
				- 不覆盖上游已确认业务值（ `is_default = 0` 且 `evidence_state=FOUND_IN_RAW/CONFIRMED` ）；
				- 改写时：
					- 若来自“算法对兜底值的升级” → 设置 `qc_is_fallback_value = 1` ，并在 `reason` 中追加 `patched_by_algo` 等标记。
	- 统一后处理（Q/T）：
		- Q 层：各标签统一做 QC 规则与兜底改写，如在某些标签中允许 `99 → '00:00-24:00'` 、 `99 → '1'` 的二道兜底改写；
		- T 层：统一将 store/merchant/party 的决策输出迁移至 `station_tag_target_value` ，并按照“三选一协议 + enum\_code + QC 字段”规范落表。
2. **tag\_algo\_config 作为唯一算法说明中心**
	- 对每个 `tag_code` ， `tag_algo_config` 中必须有一条 `algo_version` 当前生效配置行：
		- `algo_mode` ：
			- `WAREHOUSE_DIRECT` ：数仓/其它系统计算完，本地只承接字段；
			- `MIXED_INFER` ：结构+行为混合推断（如 open\_hours、convenience）；
			- `STRUCT_FLAG` ：结构标记（如 additional\_services 推洗车有无）；
			- `DERIVED` ：派生标签（如 open\_24h from open\_hours、restroom from convenience）；
			- `DEFAULT_TRUE` ：业务默认真标签（如 parking）。
		- `rule_template` ：强绑定 tag\_code 的规则名，如 `OPEN_HOURS_D1_FROM_IS_ZXGJ_AND_ORDERS_V1` 。
		- `extra_config_json` ：半结构化承载：
			- 覆盖策略： `coverage_strategy = STRICT/AGGRESSIVE` ；
			- D1 与窗口： `d1_enabled` 、 `window_days` ；
			- 兜底改写控制： `fallback_enable_unknown_rewrite` 、 `fallback_unknown_enum_code` 、 `fallback_rewrite_target_enum_code` ；
			- 派生关系： `derived_is_derived` 、 `derived_source_tags` ；
			- DW 映射： `warehouse_source_view` 、 `warehouse_source_field` ；
			- QC 行为： `qc_set_value_has_meaning_on_fallback` 。
	- 所有标签（服务 + 品牌 + 策略）都统一写入 `tag_algo_config` ，保证“算法形态 + 规则模板 + 上下游”只需要查这一张表。
3. **构建“标签 ETL 总控文档 + 表/字段备注规范”的知识库**
	- 文档层：
		- 一份中心文档：《标签 ETL 总控文档（bluebook\_v1）》：
			- 总览：项目目标、S1/S2/Q/T 模型、核心表/视图/作业列表；
			- 标签说明章节：对每个 tag\_code 用统一模板说明算法与依赖；
			- 表说明章节：对每张核心表（如 station\_tag\_target\_value, store\_feature\_snapshot\_di 等）用统一模板说明字段与上下游；
			- 作业/脚本列表章节：列出所有 ETL step 名称、输入输出与主要逻辑（1 句话）；
			- 覆盖率 & QC 口径章节；
			- 变更记录章节。
	- 数据字典层：
		- 所有建表语句必须带 **标准化表级 COMMENT + 关键字段 COMMENT** ：
			- 表 COMMENT 建议格式：
				> `业务域|层级|粒度|刷新频率|用途|上游|下游|owner`
			- 字段 COMMENT：
				> `中文含义 + 英文术语关键字 + 与 tag_enum / QC 的关系` 。

---

### 2.3 落地与风险——从服务标签样板起步，向全标签推广

1. 落地路线：
	- Phase 1：open\_hours/open\_24h + 服务标签（convenience/parking/restroom/carwash\_available/carwash\_type）
		- 完成 tag\_algo\_config v1 配置（已基本确定）；
		- 按 S1/S2 模式写好门店层 ETL + 三层决策 + station\_tag\_target\_value 迁移；
		- 产出服务标签覆盖率视图（自然覆盖率 vs 补洞覆盖率 vs 总覆盖率）。
	- Phase 2：基础合作 & 策略标签（brand\_ *、store\_life、competitive\_overlap、sme\_* 、wyc\_pricing\_enabled）
		- 以 `WAREHOUSE_DIRECT` 为主，必要时加 S2 补洞；
		- 将所有标签纳入同一骨架。
	- Phase 3：完善 feedback（merchant\_feedback\_stats）与调参闭环，动态优化 conf 阈值与 fallback 策略。
2. 风险与兜底：
	- 风险 1：本地补洞逻辑过于激进，掩盖真实数据质量问题。
		- 兜底：所有从兜底改写来的值必须 `qc_is_fallback_value = 1` ，覆盖率看板必须拆分“自然 vs 兜底”。
	- 风险 2：tag\_algo\_config 与 SQL 实现偏离。
		- 兜底：严格要求 ETL step 名与 rule\_template 对齐，任何改动前先改 config，再改 SQL。
	- 风险 3：文档体系难以维护。
		- 兜底：通过模板化（标签说明/表说明/作业列表/血缘/变更）的方式，让每次新增/调整标签的文档维护成本“可控可预期”。

---

## 3）思维导图结构（文本分层）

### 3.1 需求文档 Part A：整体标签 ETL 改造需求

**A1. 背景与目标**

- 背景：
	- 商户画像项目中，标签已覆盖营业、服务、品牌、竞争、策略等多个维度；
	- 部分标签（尤其服务标签）存在覆盖率不足、算法规则分散、数仓与本地结果不统一的问题。
- 总目标：
	- 将服务标签（及后续关键标签）的有效覆盖率（非兜底、有意义）提升至 ≥90%；
	- 构建一个可扩展的统一 ETL 骨架，支撑所有标签的长期演进。

**A2. 业务范围**

- 必须支持的标签：
	- 营业时间： `open_hours`, `open_24h`
	- 服务标签： `convenience_store_available`, `parking_available`, `restroom_available`, `service_carwash_available`, `service_carwash_type`
	- 基础合作： `brand_name`, `brand_level`, `is_ka_direct`, `store_life`
	- 策略运营/竞争/价格： `competitive_overlap`, `sme_supplier`, `sme_supplier_partner`, `wyc_pricing_enabled`

**A3. 功能需求（核心）**

1. 算法配置中心
	- 所有标签必须在 `tag_algo_config` 中有一条 v1 配置行；
	- extra\_config\_json 中必须包含：algo\_mode, rule\_template, coverage\_strategy, fallback\_*, derived\_*, warehouse\_source\_\* 等关键配置。
2. S1/S2 双层 ETL
	- 对每个标签：
		- S1：承接 v\_merchant\_profile\_latest\_di/DW 中已有结果，写入 store\_tag\_snapshot\_di，并打 QC。
		- S2：仅对“无记录/兜底”样本执行本地补洞逻辑，不覆盖上游业务值。
3. QC & 兜底 & 覆盖率
	- 在 station\_tag\_target\_value 中统一使用 QC 字段记录：
		- value\_has\_meaning / is\_fallback\_value / is\_wrong\_cleaning / is\_same\_as\_source / meaningless\_non\_fallback；
	- 覆盖率计算必须基于：
		- 枚举 `is_default=0` + `qc_value_has_meaning=1` 。
4. 文档与备注
	- 输出一份中心文档《标签 ETL 总控文档（bluebook\_v1）》；
	- 所有建表语句必须带标准化表 COMMENT 和关键字段 COMMENT。

**A4. 非功能需求**

- 可维护性：增加新标签时，只需：
	- 在 tag\_spec/tag\_enum 注册标签；
	- 在 tag\_algo\_config 写一条配置；
	- 在文档中按模板写一节标签说明；
	- 按 S1/S2/Q/T 模式新增或复用 ETL；
- 性能：
	- 重 JOIN 抽象为共享 snapshot / 特征临时表；
	- QC & fallback 采用统一后处理 step；
- 可观测性：
	- 必须支持查看每个标签的：自然覆盖率 / 补洞覆盖率 / 总覆盖率；
	- 审计日志（tag\_audit\_log\_di）可以追踪三层决策与候选。

---

### 3.2 总控文档 Part B：标签 ETL 知识库设计

**B1. 文档结构（目录）**

1. 概览（Overview）
2. 标签说明（by tag\_code）
3. 表说明（by table）
4. ETL 作业/脚本列表（by step）
5. 覆盖率 & QC 口径说明
6. 血缘关系（数据流简图）
7. 变更记录（Changelog）

**B2. 标签说明模板（示意）**

每个 tag\_code 一节，字段示例：

- 基本信息：tag\_code / 中文名 / tier1-3 / tag\_class / owner\_biz / owner\_data
- 算法配置摘要（从 tag\_algo\_config 来）：
	- algo\_mode, rule\_template, coverage\_strategy
	- derived\_is\_derived, derived\_source\_tags
	- fallback\_enable\_unknown\_rewrite, fallback\_\*
- 上游依赖：
	- v\_merchant\_profile\_latest\_di 字段
	- snapshot / candidate 表
	- 其它结构表（如 dim\_gas\_store\_info\_extend.additional\_services）
- 输出路径：
	- store\_tag\_snapshot\_di → station\_tag\_target\_value
	- 三层决策说明（如有）
- 覆盖率策略：
	- 自然 vs 兜底覆盖率的关注点
- 示例站点：1-2 条典型值。

**B3. 表说明模板**

每张表一个模板：

- 基本信息：
	- 表名、库名
	- COMMENT（业务域|层级|粒度|刷新频率|用途|上游|下游|owner）
- 核心字段说明：字段名 / 类型 / COMMENT / 典型取值
- 上下游表：
	- 上游来源表列表
	- 下游消费表/视图列表

**B4. ETL 作业/脚本列表模板**

每个 step 一行：

- step 名： `etl_tag_stepS1.1_convenience_store_available_store_from_dw`
- 输入表：list
- 输出表：list
- 逻辑摘要：一行中文说明
- 关联 tag\_code：可选字段

**B5. 覆盖率 & QC 口径章节**

- 覆盖率定义 & 示例 SQL；
- QC 字段语义表： `qc_value_has_meaning / qc_is_fallback_value / qc_is_wrong_cleaning / ...`；
- fallback 改写策略：哪些标签允许、改写到哪个枚举值、如何统计兜底覆盖率。

**B6. 变更记录模板**

- 时间 / 标签 / 表 / 作业 / 改动内容 / 影响范围 / 回滚方式。

---

### 3.3 表/字段备注规范（DDL 级别）

**表级 COMMENT 格式建议：**

**字段 COMMENT 示例：**

---

## 4）迭代日志（来源 / 结论 / 改动点 / 下一步建议）

**来源**

- 多轮对话中已完成：
	- 对 open\_hours/open\_24h 链路的梳理与 SQL 打样；
	- 对服务标签（便利店/停车/卫生间/洗车有无/类型）的算法口径、algo\_mode、rule\_template 的对齐；
	- 对 tag\_algo\_config v1 配置方案、QC 字段语义、fallback 改写机制、覆盖率统计口径的统一；
	- 对“数仓/区域已给结果 vs 本地补洞逻辑”的区分共识。

**本轮结论**

- 提炼出一套可推广至所有标签的统一 ETL 设计： `S1 承接 DW/区域 + S2 本地补洞 + Q/T 统一 QC/兜底/终表迁移` ；
- 明确 tag\_algo\_config 作为唯一算法说明表，并制定 extra\_config\_json 的核心字段语义；
- 给出“标签 ETL 总控文档 + 表/字段备注规范”的整体设计，保证后续可长期运维和交接。

**改动点（相对于之前版本）**

- 进一步明确 ETL 是围绕“覆盖率分子提升”来设计优先级与改写规则，而不是单纯“算值”；
- 把“知识库”从零散文档提升为结构化的蓝皮书：中心文档 + 模板 + 变更记录；
- 在 DDL 层约定了标准化的表 COMMENT 和字段 COMMENT 格式。

**下一步建议（非常可执行）**

1. 文档侧：
	- 在你惯用的文档系统中（Notion/飞书/Markdown 仓库）创建《标签 ETL 总控文档（bluebook\_v1）》骨架，按本文件的章节/模板落地；
	- 先完整填一组标签：open\_hours/open\_24h + convenience\_store\_available，作为“样板章节”。
2. 配置侧：
	- 在 tag\_algo\_config 中按我们前面已经写好的 SQL，完成全部 15 个标签的 v1 配置写入/更新；
	- 对 extra\_config\_json 做一次抽样审阅，确认 algo\_mode/rule\_template/derived/fallback 配置与预期一致。
3. ETL 实现侧（短期目标：服务标签覆盖率提升）
	- 从 `convenience_store_available` 开始，按 S1/S2 模式完成：
		- S1：承接 v\_merchant\_profile\_latest\_di 中（如有）现有便利店结果；
		- S2：对“空/兜底”样本应用结构+行为规则补洞；
		- 统计覆盖率前后对比。
	- 在此基础上，复制模式到 parking/restroom/service\_carwash\_available/service\_carwash\_type，并输出一份服务标签覆盖率提升小结（自然 vs 补洞 vs 总体）。
4. 中长期：
	- 将同一骨架推广到品牌/策略标签，并对所有标签做覆盖率 + 质量看板；
	- 在总控文档中持续维护变更记录，确保整套 ETL 成为“可长期运维的标签基础设施”，而不只是阶段性脚本。

如果你愿意，下一步我们就可以从「convenience\_store\_available 的 S1/S2 具体 SQL」开始，一步一步按这个总控文档推进，把第一条样板管道真正跑通。

20251207\_2359\_标签ETL\_双层管道\_总控文档V2  
tags: #商户画像 #标签ETL #服务标签 #数据血缘 #覆盖率90 #数仓对齐

---

### 1）一句话结论

这版总控文档把整套标签 ETL 的“骨架 + 血缘 + 表级职责”拉通到了具体表和字段层面：围绕 `v_merchant_profile_latest_di → snapshot → store_tag_snapshot_di → station_tag_target_value` 的主干链路，显式区分 S1（数仓/区域已给结果）与 S2（本地补洞），并用一套可长期维护的文档/备注规范，把每张表、每个标签“干什么、从哪来、怎么用”写清楚。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 论据一：现状与问题——表多、字段多，但“谁负责什么”不够一眼清楚

从你现有库里看，和标签 ETL 强相关的核心表至少有十几张，且已经有较多字段和注释，但职责边界并不统一：

- 来源 & 运营层：
	- `visit_records_enriched` ：线下/区域拜访记录 + 现场录入标签（open\_hours、open\_24h、服务标签等），偏“人肉上报 + 清洗后样本”。
	- `dim_gas_store_info_extend` ：油站基础信息 + 附加服务（ `additional_services` 包含卫生间/洗车/便利店等多值枚举），是服务标签的重要结构来源。
- 数仓统一视图层：
	- `v_merchant_profile_latest_di` ：以站为粒度的统一画像视图，既包含订单/品牌/合作类特征，也包含一版服务/营业标签字段（open\_hours/open\_24h/parking/restroom/carwash/便利店等）。这是我们约定的 **唯一上游入口** 。
- 特征/候选/决策层：
	- `store_feature_snapshot_di` ：门店 30 天行为特征（营业时间分布、订单数、订单时间段等），是 open\_hours/open\_24h 和服务标签行为启发的基础。
	- `store_tag_snapshot_di` ：门店层标签快照（store\_id + as\_of\_date + tag\_code 粒度），是所有标签的“中间决策表”。
	- `tag_audit_log_di` ：针对每个标签/站点记录三层候选与最终决策，带 trace\_json，主要用于审计和 debug。
- 终表 & 元数据层：
	- `station_tag_target_value` ：终态标签落表，带三选一值 + enum\_code + QC 标记，是覆盖率统计和数仓对接唯一出口。
	- `tag_spec / tag_enum / tag_catalog` ：标签定义、枚举、分类（A/B 类、服务/品牌/策略等）。
	- `tag_algo_config` ：三层决策配置 + extra\_config\_json，用于描述每个 tag\_code 的算法形态与参数，是“算法说明中心”。

现在的问题是：

- 这些表的“层级/粒度/用途/上下游”虽然能从名字猜到，但没有一份集中、结构化的文档把它们串起来；
- ETL 脚本虽然按 step 命名，但对哪些字段来自数仓（S1）、哪些是本地补洞（S2）、哪些参与覆盖率分子，并没有统一说明；
- 对后续要扩展的标签（尤其服务 + 品牌 + 策略），缺乏“看一眼就知道要往哪里接”的标准入口。

#### 论据二：策略——围绕“覆盖率分子”重构血缘 & 角色分工

我们不再单纯从“算标签值”出发，而是从“覆盖率分子”的视角反推 ETL 设计：

- 覆盖率口径：
	- 分母：选定站点集合 × 标签（一般是所有在营站 × 某 tag\_code）。
	- 分子： `station_tag_target_value` 中该 tag\_code 的记录，满足：
		- 对应 `enum_code` 在 `tag_enum` 里 `is_default=0` （非兜底），且
		- `qc_value_has_meaning = 1` 。
- 核心设计：
	- **S1 上游承接层** ：
		- 把数仓 / 区域 / 其它系统已经给出的标签结果（主要在 `v_merchant_profile_latest_di` 中）按原样落到 `store_tag_snapshot_di` ；
		- 使用 `tag_enum.is_default` 和 QC 字段区别“业务值 vs 兜底值”；
		- 设置 `evidence_state = FOUND_IN_RAW / CONFIRMED` ，表明“这是外部权威意见”。
	- **S2 本地补洞层** ：
		- 只对“当前不在分子里的样本”动手：
			- 无记录；
			- 或只有兜底值（enum\_code 对应 `is_default=1` ）/ `qc_value_has_meaning=0` ；
		- 通过行为特征（ `store_feature_snapshot_di` ）、结构特征（ `dim_gas_store_info_extend` ）、派生（其它标签）进行推断；
		- 使用 `INSERT ... ON DUPLICATE KEY UPDATE` ， **仅在“空/兜底”场景覆盖** ，不推翻上游业务值；
		- 改写时打清楚 `qc_is_fallback_value=1` 和 reason（例如 `patched_by_algo` ）。
	- **Q/T 层统一落站 & QC** ：
		- 所有标签最终统一落到 `station_tag_target_value` ，遵守三选一协议 + enum\_code 规范；
		- QC 字段在这一层补全，覆盖率计算只看这张表。
- 为了让多人维护、跨团队协作变得可能，我们再加一层“文档骨架”：
	- 一份“标签 ETL 总控文档”，对每张表、每个标签、每类作业给出固定模板；
	- 所有建表语句强制写“标准化表 COMMENT + 关键字段 COMMENT”，和总控文档相互印证。

#### 论据三：落地与风险——从服务标签样板起步，到全标签推广

落地策略很明确：

- 第一阶段：以 open\_hours/open\_24h + 服务标签作为首批样板：
	- 明确它们在各表中的位置（ `v_merchant_profile_latest_di` 字段、 `store_feature_snapshot_di` 行为特征、 `dim_gas_store_info_extend.additional_services` 等）；
	- 按 S1/S2 思路打通 `v_merchant_profile_latest_di → store_tag_snapshot_di → tag_audit_log_di → station_tag_target_value` 的链路；
	- 跑出一版覆盖率曲线：自然覆盖率 / 补洞覆盖率 / 总覆盖率。
- 第二阶段：把同样的骨架推广到品牌/策略标签（大部分为 WAREHOUSE\_DIRECT，S2 仅在需要补洞时启用）。
- 风险控制：
	- 所有“99→业务值”的改写必须打 `qc_is_fallback_value=1` ，覆盖率看板中必须拆分“自然 vs 兜底”；
	- tag\_algo\_config 必须和实际 SQL 同步：rule\_template 与 step 名一一对应，防止“口说一套，脚本一套”；
	- 总控文档不追求一次写完，但要保证每次新增/修改标签时，文档可以在 10 分钟内更新到位。

---

### 3）思维导图结构（文本总控 + 表级血缘）

下面是“需求文档 + 总控文档”的合体版本，更偏“可以直接拿去建一个蓝皮书”的骨架。

---

#### 3.1 项目目标与范围（需求文档视角）

**3.1.1 项目目标**

- 总目标：
	- 在不破坏数仓/区域现有标签结果的前提下，通过统一的 S1/S2 管道和共享特征， **将服务标签等关键 A 类标签的有效覆盖率提升至 ≥90%** 。
- 子目标：  
	1）为所有标签统一 ETL 骨架：S1 承接 → S2 补洞 → Q/T 统一落表 + QC；  
	2）以 `tag_algo_config` 为算法说明中心，以 `station_tag_target_value` 为唯一终表；  
	3）建设一份可长期维护的“标签 ETL 总控文档”和配套的 DDL 注释规范。

**3.1.2 标签范围**

- 营业类： `open_hours`, `open_24h` 。
- 服务类： `convenience_store_available`, `parking_available`, `restroom_available`, `service_carwash_available`, `service_carwash_type` 。
- 基础合作类： `brand_name`, `brand_level`, `is_ka_direct`, `store_life` 。
- 策略/竞争/价格类： `competitive_overlap`, `sme_supplier`, `sme_supplier_partner`, `wyc_pricing_enabled` 。

---

#### 3.2 表级分层与关键血缘（核心部分）

这部分是你要的“非常详细”的表级说明，按层级拆。

---

##### 3.2.1 标签元数据层（定义 & 字典 & 算法配置）

1） `tag_spec` – 标签规格定义表

- 粒度： `tag_code + spec_version`
- 用途：
	- 存储每个标签的定义、值类型、有效期、TTL 等；
	- 提供 `value_type` 和 `value_type_connect` （映射到 target\_value\_bool/number/string）指引终表存储形态。
- 对 ETL 的作用：
	- 决定在 `station_tag_target_value` 中应该填哪个 target\_value\_\* 字段；
	- 决定“兜底值 fallback”的默认语义（业务默认，而非算法兜底）。

2） `tag_enum` – 标签枚举表

- 粒度： `tag_code + spec_version + enum_code`
- 关键字段：
	- `enum_code / enum_label` ：code 与中文展示；
	- `is_default` ：是否默认/兜底值（1=是兜底枚举，0=业务值）；
- 对 ETL 的作用：
	- 映射终表的 `enum_code/enum_label` ；
	- 决定“兜底值”的形式，是覆盖率分子/分母划分的基础。

3） `tag_catalog` – 标签目录/分层表

- 粒度： `tag_code`
- 关键字段： `tier1/tier2/tier3/tag_class/owner_biz/owner_data/is_p0`
- 用途：
	- 用于分类标签（基础合作/站内服务/策略运营等），以及识别 P0 标签。
- 对 ETL 的作用：
	- 帮助我们按业务优先级规划接入顺序（先服务标签，再策略类等）。

4） `tag_algo_config` – 算法配置中心表

- 粒度： `tag_code + algo_version`
- 关键字段：
	- `conf_threshold_store`, `enable_merchant_level/enable_party_level` ， `hierarchy_weight_*` ；
	- `extra_config_json` ：存放 algo\_mode/rule\_template/fallback/derived/warehouse\_source\_field 等。
- 用途：
	- 描述每个标签的算法形态（WAREHOUSE\_DIRECT/MIXED\_INFER/DERIVED/STRUCT\_FLAG/DEFAULT\_TRUE）；
	- 给 S1/S2/Q/T 层的 SQL 提供统一参数来源。

---

##### 3.2.2 源数据 & 上游统一视图层

1） `visit_records_enriched` – 拜访记录富化表

- 粒度：单条拜访记录（ `id / record_id / store_id` ）。
- 关键字段：
	- 现场录入的标签值： `open_24h/open_hours/parking_available/restroom_available/service_carwash_available/service_carwash_type/convenience_store_available/sme_supplier/...`；
	- `data_quality_flag` ：single/consistent/conflict；
	- `is_canonical_record` ：1=该 record\_id 下选定的唯一主记录。
- 在标签 ETL 中的定位：
	- 主要作为数仓/区域生产 `v_merchant_profile_latest_di` 的上游，不是当前 ETL 的直接输入；
	- 将来可作为 S1 的精细来源（例如 region 覆盖时直接 override S2 推断）。

2） `dim_gas_store_info_extend` – 油站扩展维度

- 粒度： `store_id + dt`
- 关键字段：
	- 地址/行政信息：city/county/town 等；
	- 营业时间结构字段： `biz_hours_start/biz_hours_end/biz_hours_note` ；
	- 关键服务结构字段： `additional_services` （0=卫生间,1=洗车,2=早点便当,3=便利店,4=车胎充气,5=修车,6=快餐店）；
- 在标签 ETL 中的定位：
	- 服务标签 S2 的核心结构来源（便利店/洗车有无/卫生间等通过 additional\_services 推断）；
	- 营业时间标签 open\_hours 的结构补充来源（与 is\_zxgj/订单分布一起使用）。

3） `v_merchant_profile_latest_di` – 商户画像统一视图

- 粒度： `store_id + dt`
- 关键字段：
	- 基础信息：store\_id/store\_name/store\_address/lon/lat 等；
	- 行为特征：order\_cnt\_30d/inner\_order\_cnt\_30d/bigc\_order\_cnt\_30d/wyc\_order\_cnt\_30d 等；
	- 品牌/合作类： `brand_name/brand_level/is_storm/is_league_member` 等；
	- 策略类： `competitive_overlap/sme_supplier_partner/sme_supplier/wyc_pricing_enabled` 等；
	- 服务/营业类： `service_carwash_available/service_carwash_type/convenience_store_available/restroom_available/parking_available/open_24h/open_hours/additional_services` 等；
	- 关键分层字段： `party_key/is_agg_blocked_merchant` 等。
- 在标签 ETL 中的定位：
	- **唯一上游入口** ：所有标签的 S1 均从这里承接现有结果；
	- 也是计算 snapshot 表的输入之一（store/merchant/party 特征快照从此视图派生）。

---

##### 3.2.3 特征快照层

1） `store_feature_snapshot_di` – 门店特征快照

- 粒度： `store_id + as_of_date`
- 关键字段：
	- `open_hour_min_30d/open_hour_max_30d` ：近 30 日订单时间分布；
	- `has_order_before_6_30d/has_order_after_20_30d` ：D1 规则所需字段；
	- `order_cnt_30d/total_order_cnt_30d` ：近 30 日订单统计；
	- `pop_id/party_key` ：用于向上聚合。
- 用途：
	- 为 open\_hours/open\_24h 决策提供行为信号；
	- 为服务标签提供“数据占比/有无行为”的佐证（例如便利店订单阈值）。

2） `merchant_feature_snapshot_di` / `party_feature_snapshot_di`

- 虽未在字段明细中展开，但在前置设计中已约定存在，用于：
	- 按 `pop_id` 视角（商户）和 `party_key` 视角（工商主体）对门店特征聚合；
	- 支撑 S2 三层决策时的 conf\_merchant/conf\_party 计算。

---

##### 3.2.4 标签决策 & 审计层

1） `store_tag_snapshot_di` – 门店层标签快照

- 粒度： `store_id + as_of_date + tag_code`
- 关键字段：
	- `target_value_bool/number/string` ：标签值三选一；
	- `enum_code` ：映射 tag\_enum；
	- `source_level` ：STORE/MERCHANT/PARTY，用于三层决策追踪；
	- `evidence_state` ：FOUND\_IN\_RAW/INFERRED/CONFIRMED；
	- `conf/ttl_days/reason/algo_version/target_value_string_back` 。
- 角色：
	- S1：存放数仓/区域/其它系统已给出的结果（source\_level=STORE，evidence\_state=FOUND\_IN\_RAW/CONFIRMED）；
	- S2：存放本地补洞结果（evidence\_state=INFERRED，reason 带 patched 标记）；
	- 三层决策输出：最终会被汇总到 station\_tag\_target\_value。

2） `tag_audit_log_di` – 标签审计日志

- 粒度： `store_id + as_of_date + tag_code + algo_version`
- 关键字段：
	- `chosen_level/chosen_value_string/chosen_enum_code/conf_final` ；
	- `conf_store/conf_merchant/conf_party` ；
	- `candidate_store_string/candidate_merchant_string/candidate_party_string` ；
	- `manual_override_flag/trace_json` 。
- 用途：
	- 记录三层候选与决策过程；
	- 调试/回溯“为什么这个站是这个标签值”。

3） `open_hours_candidate_di` （以及未来的 \*candidate\_di）

- 逻辑上存在：记录 store/merchant/party 三层候选区间 + conf；
- 在新方案中，服务标签也会有类似 candidate\_di，以统一三层候选范式。

---

##### 3.2.5 终表 & QC 层

1） `station_tag_target_value` – 终态标签表

- 粒度： `store_id + as_of_date + tag_code`
- 关键字段：
	- 值 + 枚举： `target_value_bool/number/string` 、 `enum_code/enum_label` ；
	- 来源与证据： `source/evidence_state/closest_source` ；
	- TTL 与置信度： `ttl_days/conf` ；
	- 审计信息： `reason/upload_batch_id/target_value_string_back` ；
	- QC： `qc_value_has_meaning/qc_is_wrong_cleaning/qc_is_same_as_source/qc_is_fallback_value/qc_is_meaningless_non_fallback` 。
- 角色：
	- 所有标签最终汇聚在这里，对齐数仓和运营看板；
	- 覆盖率计算只看这张表及其 QC 字段；
	- S1/S2/Q/T 各层的决策、兜底、改写都通过这张表对外体现结果。

---

#### 3.3 S1/S2 逻辑在表上的落点（以服务标签为例）

这里不展开 SQL，只说清楚“谁负责什么”。

**3.3.1 S1：承接数仓/区域已给结果**

- 输入： `v_merchant_profile_latest_di` 的服务/营业标签字段：
	- `open_hours/open_24h/parking_available/restroom_available/service_carwash_available/service_carwash_type/convenience_store_available` 等。
- 输出： `store_tag_snapshot_di` ：
	- 每个 tag\_code 一条 INSERT 或 UPSERT：
		- 按 tag\_enum 映射 `enum_code/enum_label` ；
		- `target_value_*` 按 value\_type\_connect 选择 bool/number/string；
		- `evidence_state='FOUND_IN_RAW'` 或 `CONFIRMED` ；
		- QC：
			- 如果 enum 对应 `is_default=0` → `qc_value_has_meaning=1` ；
			- 如果 `is_default=1` → `qc_is_fallback_value=1` 。

**3.3.2 S2：本地补洞逻辑**

- 输入：
	- `store_feature_snapshot_di` （行为特征）；
	- `dim_gas_store_info_extend.additional_services` （结构服务特征）；
	- 以及 S1 已写入的 `store_tag_snapshot_di` 。
- 行为：
	- 用 `INSERT ... ON DUPLICATE KEY UPDATE` 只对以下样本覆盖：
		- tag 记录不存在；
		- 或 enum\_code 对应 `tag_enum.is_default=1` / `qc_value_has_meaning=0` ；
	- 例如：
		- convenience：additional\_services 包含 3 或 30 日订单≥阈值时，从 99/空 推到 1；
		- parking：默认真；
		- restroom：additional\_services 包含 0 或有便利店时，从 99/空 推到 1；
		- carwash\_available：additional\_services 包含 1 → 1，否则 0；
		- carwash\_type：依赖 carwash\_available + DW 字段，得出 machine/manual/none/99。
	- 改写后的记录：
		- `evidence_state='INFERRED'` ；
		- `reason` 拼上 `patched_by_algo` ；
		- 若从兜底枚举改写 → `qc_is_fallback_value=1` 。

**3.3.3 Q/T 层：统一 QC 与落终表**

- Q：
	- 如果某标签允许“二道兜底改写”（如 open\_hours 99 → '00:00-24:00'），根据 tag\_algo\_config.extra\_config\_json 控制；
	- 改写后设置 `qc_is_fallback_value=1` 、 `qc_value_has_meaning=1` 。
- T：
	- 将 `store_tag_snapshot_di` 的最终结果转写到 `station_tag_target_value` ：
		- 三选一协议：只能一个 target\_value\_\* 非空；
		- enum\_code/enum\_label 对齐 tag\_enum；
		- source/evidence\_state/conf/ttl\_days/reason/QC 字段全部带过去。

---

#### 3.4 “标签 ETL 总控文档”实际落地形态（知识库蓝本）

在你后续落到 Notion/飞书/Markdown 仓库时，可以按以下结构建库（这次已经补足“关键表清单 + 血缘 + 核心字段”）：

1. 总览（Overview）
	- 项目目标 & 指标；
	- S1/S2/Q/T 模型简介；
	- 一张总血缘图（文字版，按 3.2 的层级）。
2. 表字典（按表）
	- 对每张核心表（上面列出的所有表）各写一页：
		- 表名 + COMMENT（使用标准格式）；
		- 粒度/刷新频率；
		- 与标签 ETL 的角色（S1/S2/Q/T 中的位置）；
		- 和本回答中的说明对应。
3. 标签字典（按 tag\_code）
	- 每个标签一页：
		- 基本信息（tag\_spec + tag\_catalog 摘要）；
		- S1 输入字段（在 v\_merchant\_profile\_latest\_di 中的字段名）；
		- S2 规则（使用了哪些 snapshot/结构表）；
		- 是否允许 fallback 改写；
		- 覆盖率定义 & 特殊说明。
4. 作业/脚本列表
	- 大纲式列出每个 `etl_tag_stepX.Y_*` ：输入表、输出表、逻辑一句话说明。
5. 覆盖率 & QC 口径
	- 把终表 QC 字段的定义和使用方法搬进去（参照 station\_tag\_target\_value 的字段注释）。
6. 变更记录
	- 记录每次对 tag\_algo\_config/ETL/表结构的改动。

---

### 4）迭代日志

- 来源：
	- 本文基于你前一版《标签ETL 双层管道需求说明书 + 总控文档 V1》、服务标签上下游字段明细文档、以及多轮对话对 open\_hours/open\_24h/服务标签链路的讨论。
- 本轮主要增强点：  
	1）从“概念骨架”下沉到“表级血缘”：对每张关键表的粒度、用途、关键字段、在 S1/S2/Q/T 中的角色做了系统梳理；  
	2）明确 `v_merchant_profile_latest_di` 是 S1 唯一入口， `store_tag_snapshot_di` 是中间决策表， `station_tag_target_value` 是唯一终表；  
	3）把服务标签 S1/S2 的行为逻辑与具体表（snapshot/extend/profile）绑死，方便你在写 SQL 时对照；  
	4）给出了实际可用于文档系统的章节结构，可以直接在你已有的 V1 文档基础上扩展为 V2 蓝皮书。
- 下一步建议：  
	1）你可以把这版“总控文档 V2”直接复制到文档系统里，作为蓝皮书的“骨干章节”；  
	2）在此基础上，为每张表补齐 DDL COMMENT（如果有缺失），确保数据库元数据与文档一致；  
	3）从 `convenience_store_available` 入手，把 S1/S2 SQL 对应到这里描述的表和字段，再按这个框架逐一扩展到其他服务标签；  
	4）等服务标签整体覆盖率提升路径跑通后，再用同样的骨架把品牌/策略类标签接进来，做到“所有标签只要看一套文档就能搞清楚从哪来、怎么算、算完去哪”。

20251207\_2359\_服务标签ETL\_convenience\_S1S2规划与首版SQL

tags: #标签ETL #服务标签 #覆盖率90 #双层管道 #convenience\_store

---

### 1）一句话结论

先从 `convenience_store_available` 下手，按「S1 承接数仓/区域结果 + S2 用结构/行为补洞」的双层管道落成一对可直接跑的 SQL step，并同步给出可贴回总控文档的说明模版，后续其它服务标签按同一骨架复制。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

**论据一：现状与问题——上游已有结果，但“补洞逻辑”和 S1/S2 分层未落到 SQL**

- 上游 `v_merchant_profile_latest_di` 已经有 `convenience_store_available` 字段，同时 `dim_gas_store_info_extend.additional_services` 、 `store_feature_snapshot_di.order_cnt_30d` 等结构/行为特征都已准备好。
- 需求侧已经把 convenience 定义为「A 类标签，站点维度，结构 + 行为启发」：
	- S1：尊重数仓/区域给的结果；
	- S2：用附加服务（ `additional_services` 中有 3=便利店）和 30 日订单量 ≥ 阈值，从“未知/空”推到“有便利店”。
- 但目前 SQL 里只有营业时间链路的样板，服务标签虽然定了口径，还没拆成可执行的 step 名称 + 具体 SQL。

**论据二：策略——以 convenience 为样板，显式实现 S1/S2 双层逻辑**

- S1 层策略：
	- 从 `v_merchant_profile_latest_di.convenience_store_available` 直接承接结果；
	- 支持既有编码（1/0/99）与中文（是/否/未知）双写；
	- 只在上游有值时插入；不擅自把 NULL/空推成 99，避免人为放大兜底样本；
	- 落到 `store_tag_snapshot_di` 时， `source_level='STORE'`,`evidence_state='FOUND_IN_RAW'`,`algo_version='convenience_store_v1'` 。
- S2 层策略：
	- 目标样本：
		- 当前业务日下，该站点该标签 **没有记录** ，或者
		- 有记录但 `enum_code='99'` （未知兜底）；
	- 规则：
		- 结构命中： `dim_gas_store_info_extend.additional_services` 中 `FIND_IN_SET('3', ...) > 0` → has\_struct=1；
		- 行为命中： `store_feature_snapshot_di.order_cnt_30d >= 15` → has\_behavior=1；
		- 只要 `has_struct=1 OR has_behavior=1` ，则用算法把值从“未知/空”推到 `enum_code='1'` （有便利店）；
	- 赋值属性：
		- `evidence_state='INFERRED'` ；
		- `conf` 按信号强弱打分（结构+行为 > 单一信号）；
		- `reason` 拼上 `patched_by_algo_convenience_store...` 供审计。

**论据三：落地与风险——按 step 命名 + SQL 规范输出，并预留给终表 QC 做后处理**

- 落地方式：
	- 继续沿用营业时间脚本里的 `@biz_dt_str / @biz_date` 检测方式；
	- 给 convenience 写两段 step：
		- `etl_tag_step4.1a.convenience_store_s1_from_dw`
		- `etl_tag_step4.1b.convenience_store_s2_patch_from_struct_behavior`
	- 两个 step 都向 `store_tag_snapshot_di` 写数据，下一步在统一的 T 层把 snapshot 映射到 `station_tag_target_value` 并补充 QC 字段。
- 风险与兜底：
	- 风险：S2 过于激进，把本该“未知”的站点推成“有便利店”。
		- 缓解：只在“无记录/未知”时改写，且 `evidence_state='INFERRED'` ，后续在终表按 evidence\_state + reason +枚举 is\_default 再做 QC 控制。
	- 风险：S1/S2 混不清。
		- 缓解：S1 全部标记 `reason='s1_from_v_merchant_profile'` 、S2 统一用 `patched_by_algo_convenience_store` 前缀，方便在审计/看板中分拆“自然覆盖率 vs 补洞覆盖率”。

---

### 3）思维导图结构（文本分层）

#### 3.1 本轮实现范围

- 标签范围： `convenience_store_available` （服务标签之一）。
- 表范围：
	- 上游： `v_merchant_profile_latest_di`, `dim_gas_store_info_extend`, `store_feature_snapshot_di` ；
	- 中间层： `store_tag_snapshot_di` ；
	- 终表： `station_tag_target_value` （本轮只铺垫，总迁移 T 层后面单独一轮做）。

#### 3.2 SQL 执行节奏规划（你可以按顺序放进一个脚本里）

1. `etl_tag_step0.detect_biz_date_from_v_merchant_profile`
	- 检测最新业务日期 `@biz_dt_str / @biz_date` （已有可复用）。
2. `etl_tag_step4.1a.convenience_store_s1_from_dw`
	- 从 `v_merchant_profile_latest_di` 萃取已有便利店结果，承接为 S1，自然覆盖率。
3. `etl_tag_step4.1b.convenience_store_s2_patch_from_struct_behavior`
	- 对“无记录/未知”的站点，用 `additional_services` + `order_cnt_30d` 做结构/行为补洞，提升覆盖率。
4. （下一轮） `etl_tag_step4.1c.convenience_store_T_migrate_to_station_tag`
	- 把 snapshot 中 convenience 的结果迁移到 `station_tag_target_value` ，补全 QC 字段（下一轮我们再写）。

下面是本轮你可以直接粘贴进 SQL 文件、在 dev 库里执行/调试的代码草案。

---

### 3.3 可执行 SQL（首版草案）

> 说明：
> 
> - 如你的脚本里已有 `@biz_dt_str/@biz_date` 的 step0，可以只保留一次；
> - 表名、字段名全部从你当前库结构推导而来，如有差异你可以直接在本地小改；
> - 我尽量沿用了你 open\_hours 链路里的写法和命名风格。

#### 3.3.1 step0：获取业务日期（若已有可略过）

---

#### 3.3.2 step4.1a：S1 从 v\_merchant\_profile\_latest\_di 承接便利店标签

```sql
sql-- etl_tag_step4.1a.convenience_store_s1_from_dw 承接数仓/区域便利店结果到 snapshot

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
    t.store_id,
    @biz_date                          AS as_of_date,
    'convenience_store_available'      AS tag_code,

    -- 根据枚举编码落 bool：1/0 落到 target_value_bool；99 作为兜底仅保留在 enum_code
    CASE 
        WHEN t.enum_code_mapped IN ('1','0') THEN CAST(t.enum_code_mapped AS SIGNED)
        ELSE NULL
    END                                 AS target_value_bool,

    NULL                                AS target_value_number,
    NULL                                AS target_value_string,

    t.enum_code_mapped                  AS enum_code,
    'STORE'                             AS source_level,
    'FOUND_IN_RAW'                      AS evidence_state,
    ts.ttl_days                         AS ttl_days,
    1.0000                              AS conf,
    's1_from_v_merchant_profile'        AS reason,
    'convenience_store_v1'              AS algo_version,
    NULL                                AS target_value_string_back
FROM (
    SELECT
        v.store_id,
        CASE
            -- 已是枚举编码的情况
            WHEN v.convenience_store_available IN ('1','0','99') THEN v.convenience_store_available

            -- 中文值容错映射
            WHEN v.convenience_store_available = '是'   THEN '1'
            WHEN v.convenience_store_available = '否'   THEN '0'
            WHEN v.convenience_store_available = '未知' THEN '99'

            ELSE NULL
        END AS enum_code_mapped
    FROM v_merchant_profile_latest_di v
    WHERE v.dt = @biz_dt_str
) t
JOIN tag_spec ts
  ON ts.tag_code      = 'convenience_store_available'
 AND ts.spec_version  = '1.0.0'
WHERE t.enum_code_mapped IS NOT NULL;
```

> 说明：
> 
> - 这里不做 DELETE，本 step 只负责“把上游有明确值的站点写进 snapshot”；
> - 若你希望每天全量重算该标签，可在本 step 前加一句：
> 	然后 S2 用 `INSERT ... ON DUPLICATE KEY UPDATE` 做补洞。

---

#### 3.3.3 step4.1b：S2 用结构 + 行为从兜底/空样本中补洞

```sql
sql-- etl_tag_step4.1b.convenience_store_s2_patch_from_struct_behavior
-- 使用 additional_services + 30日订单，从“未知/空”推断出有便利店的站点

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
    @biz_date                          AS as_of_date,
    'convenience_store_available'      AS tag_code,
    1                                  AS target_value_bool,
    NULL                               AS target_value_number,
    NULL                               AS target_value_string,
    '1'                                AS enum_code,
    'STORE'                            AS source_level,
    'INFERRED'                         AS evidence_state,
    ts.ttl_days                        AS ttl_days,

    -- 简单的置信度规则：结构+行为 > 单一信号
    CASE
        WHEN s.has_struct = 1 AND s.has_behavior = 1 THEN 0.90
        WHEN s.has_struct = 1 OR  s.has_behavior = 1 THEN 0.80
        ELSE 0.70
    END                                 AS conf,

    CONCAT(
        'patched_by_algo_convenience_store;',
        'struct=', s.has_struct,
        ';behavior=', s.has_behavior
    )                                   AS reason,

    'convenience_store_v1'              AS algo_version,
    NULL                                AS target_value_string_back
FROM (
    SELECT
        v.store_id,

        -- 结构信号：附加服务中包含 3（便利店）
        CASE
            WHEN FIND_IN_SET(
                     '3',
                     COALESCE(d.additional_services, '')
                 ) > 0
            THEN 1 ELSE 0
        END AS has_struct,

        -- 行为信号：30 日订单 >= 15
        CASE
            WHEN sf.order_cnt_30d IS NOT NULL
             AND sf.order_cnt_30d >= 15
            THEN 1 ELSE 0
        END AS has_behavior

    FROM v_merchant_profile_latest_di v
    LEFT JOIN dim_gas_store_info_extend d
           ON d.store_id = v.store_id
          AND d.dt       = v.dt
    LEFT JOIN store_feature_snapshot_di sf
           ON sf.store_id   = v.store_id
          AND sf.as_of_date = @biz_date
    WHERE v.dt = @biz_dt_str
) s
LEFT JOIN store_tag_snapshot_di t
       ON t.store_id   = s.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'convenience_store_available'
JOIN tag_spec ts
  ON ts.tag_code      = 'convenience_store_available'
 AND ts.spec_version  = '1.0.0'
WHERE
    -- 需要补洞的样本：S1 没有记录或仅有兜底值
    (t.store_id IS NULL OR t.enum_code = '99')
    -- 且本地推断信号为真
    AND (s.has_struct = 1 OR s.has_behavior = 1)

ON DUPLICATE KEY UPDATE
    target_value_bool         = VALUES(target_value_bool),
    target_value_number       = VALUES(target_value_number),
    target_value_string       = VALUES(target_value_string),
    enum_code                 = VALUES(enum_code),
    source_level              = VALUES(source_level),
    evidence_state            = VALUES(evidence_state),
    ttl_days                  = VALUES(ttl_days),
    conf                      = VALUES(conf),
    -- 原 reason 若存在则拼接，方便审计
    reason                    = CASE
                                    WHEN store_tag_snapshot_di.reason IS NULL 
                                         OR store_tag_snapshot_di.reason = '' 
                                    THEN VALUES(reason)
                                    ELSE CONCAT(store_tag_snapshot_di.reason, '|', VALUES(reason))
                                END,
    algo_version              = VALUES(algo_version),
    -- back 字段保留原值（若原来有）
    target_value_string_back  = store_tag_snapshot_di.target_value_string_back;
```

> 说明：
> 
> - 如果你在 step4.1a 前做了 DELETE，全量重算的情况下，本 step 的 `ON DUPLICATE KEY` 主要用于“同一站点被多次命中”的保护（理论上不会出现）；
> - 如果不做 DELETE，而是希望“可以保留历史/手工干预记录”，则现在这套逻辑只会改写 `enum_code='99'` 或无记录的站点，不会覆盖上游已经给出 0/1 的结果。

---

### 3.4 建议补充回总控文档的片段（方便你复制粘贴）

你可以把下面这段直接贴进《标签 ETL 双层管道\_总控文档》的「按标签说明」里对应 `convenience_store_available` 的小节，再按需微调措辞。

> **标签：convenience\_store\_available（是否有便利店，A 类）**
> 
> - **algo\_mode** ： `MIXED_INFER`
> - **rule\_template** ： `CONVENIENCE_STORE_FROM_DW_AND_STRUCT_BEHAVIOR_V1`
> - **上游依赖** ：
> 	- DW/区域结果： `v_merchant_profile_latest_di.convenience_store_available` （S1，自然覆盖）
> 	- 结构特征： `dim_gas_store_info_extend.additional_services` 中枚举值 3=便利店
> 	- 行为特征： `store_feature_snapshot_di.order_cnt_30d` （30 日订单，门店日均 × 30）
> - **S1 逻辑（etf\_tag\_step4.1a.convenience\_store\_s1\_from\_dw）** ：
> 	- 从 `v_merchant_profile_latest_di` 承接既有结果；
> 	- 支持枚举编码（1/0/99）与中文值（是/否/未知）的容错映射；
> 	- 只在上游有值时写入 `store_tag_snapshot_di` ， `evidence_state='FOUND_IN_RAW'` 。
> - **S2 逻辑（etl\_tag\_step4.1b.convenience\_store\_s2\_patch\_from\_struct\_behavior）** ：
> 	- 目标样本：当前业务日下该标签“无记录或 enum\_code=99”；
> 	- 结构信号： `additional_services` 包含 3 → 认为有便利店；
> 	- 行为信号： `order_cnt_30d >= 15` → 认为“行为上像有便利店”；
> 	- 只要结构或行为命中，即把标签从“未知/空”推断为 `enum_code='1'` ， `evidence_state='INFERRED'` ，并在 reason 中标记 `patched_by_algo_convenience_store` 。
> - **输出路径** ：
> 	- 中间层： `store_tag_snapshot_di` （本轮已实现）；
> 	- 终表层： `station_tag_target_value` （后续通过统一 T 层脚本迁移，并根据 enum.is\_default + evidence\_state + reason 设置 QC 字段和覆盖率口径）。

---

### 4）迭代日志（来源/结论/改动点/下一步建议）

- **来源** ：
	- 你已有的营业时间 ETL 样板 SQL；
	- `v_merchant_profile_latest_di` / `dim_gas_store_info_extend` / `store_feature_snapshot_di` / `store_tag_snapshot_di` / `station_tag_target_value` 的表结构；
	- 前几轮对服务标签 A 类业务口径与 S1/S2 分层的共识。
- **本轮结论** ：
	- convenience 已经被拆成两个可执行、可命名、可维护的 step，完全符合“双层管道 + 覆盖率优先”的设计；
	- 同时给出了可直接贴回总控文档的说明片段，保证“SQL 实现 = 文档说明”。
- **改动点** ：
	- 把「结构 + 行为」口径具体化成了 `additional_services` + `order_cnt_30d` 的逻辑；
	- 在实现层面显式区分了 S1（FOUND\_IN\_RAW）与 S2（INFERRED），并通过 reason 字段标记补洞行为。
- **下一步建议** ：
	1. 先在开发库中只跑 convenience 这两个 step，抽查几条典型站点（有/无便利店、订单高/低、有/无 additional\_services）确认逻辑符合预期；
	2. 如逻辑 OK，我们下一轮按同样的节奏补：
		- `parking_available` ：DEFAULT\_TRUE + 后续用城市/地址做细化；
		- `restroom_available` ：结构（additional\_services 包含 0）+ 便利店派生；
		- `service_carwash_available` / `service_carwash_type` ：严格复用 additional\_services 与 DW 字段；
	3. 再下一轮一起补 T 层迁移脚本，把这几个服务标签统一迁移到 `station_tag_target_value` ，补全 QC 字段与覆盖率统计 SQL。

你可以先在本机把这两个 step 跑一遍，把执行结果和你看到的异常/边缘样本贴给我，我们再一起调整阈值和细节，然后再推广到其它服务标签。

20251208\_0015\_服务标签ETL\_步骤规划与校验规范对齐  
tags: #服务标签 #ETL步骤规划 #校验查询 #convenience\_store

---

### 1）一句话结论

后面所有 SQL 产出我都会：先给你一张「全局步骤进度表（这次到哪一步）」、再给对应 step 的 SQL、本轮推荐的校验查询、以及一段可以直接贴回总控文档的说明，保持节奏统一、命名清晰、人类可读。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 论据一：现状——步骤编号有“跳跃感”，缺一个长期稳定的总步骤蓝图

你提到两个现实问题：

1. 这次我直接用了 `step4.1` ，你会疑惑： `step1/2/3` 是什么？是没用？还是已经被营业时间占了？
2. 没有在开头告诉你「整体分几步 + 当前做到哪一步」，对后面长期协作和回顾会非常不友好。

再加上你已经有一份营业时间链路（open\_hours/open\_24h）的 SQL 脚本（里面已经用了 A/B 等 step 命名），新的服务标签 ETL 必须跟这套体系对齐，而不是另起炉灶。

#### 论据二：策略——固定一套“总步骤规划”，每次回答都说明“全局进度 + 本轮定位”

我给你一个 **长期稳定的 ETL 步骤蓝图** ，后面我们就按这套来：

> 下面是“标签 ETL 脚本”的大纲（可以当未来 SQL 文件的总目录）

1. **Step0：全局环境与业务日期**
	- `etl_tag_step0.detect_biz_date_from_v_merchant_profile`
	- 功能：算出 `@biz_dt_str / @biz_date` ，后续所有 step 共用。
2. **Step1：上游清洗 & 基础特征快照**
	- 1.1 原始字段清洗（如 is\_zxgj → HH-HH 区间）
	- 1.2 三层特征快照：
		- `etl_tag_step1.1.store_feature_snapshot_di`
		- `etl_tag_step1.2.merchant_feature_snapshot_di`
		- `etl_tag_step1.3.party_feature_snapshot_di`
3. **Step2：营业时间候选 &决策（open\_hours/open\_24h 专用）**
	- 2.x 一系列 `open_hours_candidate_di` 构建和三层候选计算。
4. **Step3：营业时间标签规范化 & 落 snapshot**
	- 3.1 `etl_tag_step3.1.open_24h_rebuild_v2`
	- 3.2 `etl_tag_step3.2.open_hours_rebuild_v2`
	- 这部分你那边已经跑通（A/B 链路）。
5. **Step4：服务标签管道（这一批我们正在做）**
	- 4.1 `convenience_store_available`
		- 4.1a S1：承接 DW/区域（v\_merchant\_profile\_latest\_di）
		- 4.1b S2：结构+行为补洞（additional\_services + order\_cnt\_30d）
	- 4.2 `parking_available`
	- 4.3 `restroom_available`
	- 4.4 `service_carwash_available`
	- 4.5 `service_carwash_type`
6. **Step5：其它 A 类标签（品牌/策略等）**
7. **Step6：统一迁移到 station\_tag\_target\_value + QC & 覆盖率统计**
	- 6.1 `etl_tag_step6.1.migrate_snapshot_to_station_tag`
	- 6.2 `etl_tag_step6.2.qc_and_fallback_postprocess`
	- 6.3 `etl_tag_step6.3.coverage_stats_by_tag`

> 以后每一轮，我在开头都会先写：  
> \-「全局规划表（Step0–6）」
> 
> - 标注：✅ 已完成、🟡 进行中、⬜ 未开始
> - 然后说「本轮覆盖：StepX.Y.Z = XXX」。

这样 `step4.1` 这种命名，就能自然落在“Step4 服务标签”这个大块里，而不是凭空跳出来的数字。

#### 论据三：落地——约定“三件事”：总步骤提示 + 校验查询 + 可贴回总控文档的小节

从这条开始，我对每一轮的输出做三个“刚性约定”：

1. **总步骤提示（本轮一开头就给）**
	- 按上面的 Step0–6，列出当前整体进度，并明确「本轮聚焦 StepX.X」。
2. **SQL + 推荐校验查询**
	- 每个新 SQL step，我都会至少配 3–5 条“推荐校验查询”，作用包括：
		- 看行数/分布（enum\_code、evidence\_state、reason 等）；
		- 看 S1/S2 的贡献区间；
		- 看覆盖率分子/分母是否符合直觉。
	- 这些查询会尽量做到：
		- 单条 SQL 就能快速反馈问题；
		- 不依赖你脑补字段含义。
3. **可直接贴回总控文档的小节**
	- 每个标签/步骤，我都会额外写一段「可以直接复制到蓝皮书」的描述小节：
		- 概括 step 名、输入、输出、逻辑要点；
		- 和 tag\_algo\_config / 总控文档里的结构保持统一。

这样，我们既保证脚本是“机器可跑的”，又保证文档是“人能看得懂的”，而你的要求——“长期人类可读可理解的 SQL 脚本”——就有了执行抓手。

---

### 3）思维导图结构（本轮内容分层）

1. 全局步骤蓝图  
	1.1 Step0：业务日期  
	1.2 Step1：特征快照  
	1.3 Step2–3：营业时间链路（已完成）  
	1.4 Step4：服务标签链路（当前重心）  
	1.5 Step5：其它标签  
	1.6 Step6：终表迁移 + QC + 覆盖率
2. 本轮约定  
	2.1 每轮开头给“全局步骤 + 当前进度”  
	2.2 每个 step 提供 SQL + 校验查询  
	2.3 每个标签/步骤提供一段可贴回总控文档的小节
3. convenience\_store 当前状态  
	3.1 Step4.1a S1 SQL 已提供并跑通  
	3.2 Step4.1b S2 SQL 已提供并跑通  
	3.3 待做：  
	\- 提供更系统的校验查询（本轮会补）  
	\- 下一轮做 Step6 迁移到 station\_tag\_target\_value
4. 后续节奏  
	4.1 按 Step4.2–4.5 依次补 parking/restroom/carwash  
	4.2 再进入 Step6 统一迁移 & QC & 覆盖率统计  
	4.3 每做完一块，就同步更新总控文档章节

---

### 4）迭代日志（来源 / 结论 / 改动点 / 下一步建议）

#### 4.1 来源

- 你已经在开发库跑完了 convenience 的 S1/S2 首版 SQL；
- 你提出三个新要求：  
	1）每次给 SQL 时，要附带一组 **可预期验证的查询语句** ；  
	2）step 命名不能“凭空跳号”，需要 **全局步骤规划 + 本轮定位说明** ；  
	3）所有这些要求对本对话是长期有效的约束。

#### 4.2 本轮结论

1. 固定了一套全局 ETL 步骤蓝图（Step0–6），明确 Step4 是服务标签，Step4.1 是 convenience。
2. 明确从本轮开始，每条“SQL 交付”都必须包含：
	- 总步骤提示；
	- SQL + 推荐校验查询；
	- 可贴回总控文档的小节。
3. 已确认 convenience 的 S1/S2 首版 SQL 已运行，通过这轮，我们会再补一组针对 convenience 的“标准校验查询模板”。

#### 4.3 针对 convenience 的标准校验查询（你现在就可以跑）

我先履约一下“校验查询”的约定，以 convenience 为例给一组模板。后面其它标签我会照这个套路给。假设你仍在同一会话中已经设置好 `@biz_date` 和 `@biz_dt_str` 。

1）看 convenience 在 snapshot 的整体分布（S1 vs S2）

你预期大致看到：

- `enum_code IN ('0','1') AND evidence_state='FOUND_IN_RAW'` ：S1 自然覆盖；
- `enum_code='1' AND evidence_state='INFERRED'` ：S2 补洞贡献；
- `enum_code='99'` ：兜底、未覆盖/仍未知。

2）看 S2 补洞样本的数量及占比

你可以和 Q1 的总行数比一下，感知补洞规模是否符合预期。

3）粗算一版“自然覆盖率 vs 总覆盖率”（用 store\_id 数，不引入复杂过滤）

你可以自己算：

- 自然覆盖率 ~ Q4 / Q3
- 总覆盖率 ~ Q5 / Q3  
	短期看 Q5 应该明显>Q4，且 Q5 的增加主要来自 `evidence_state='INFERRED'` 这部分。

4）抽样看 S2 补洞具体站点

你可以肉眼看几条，确认：

- 是否“明显像有便利店”的站点被补上了；
- 有没有很明显不该被补洞的站点（例如 additional\_services 为空且订单很低）。

#### 4.4 下一步建议

1. 你可以先跑 Q1–Q6，拍一两个结果（尤其是 Q1/Q4/Q5/Q6）回来，我们一起微调阈值（比如订单≥15 是否偏高/偏低）。
2. 下一轮，我会严格按照“总步骤蓝图 + 本轮 step 说明 + SQL + 校验 + 文档片段”的模板，继续补：
	- **Step4.2 `parking_available`** 的 S1/S2 SQL + 校验查询 + 文档片段；
3. 等服务标签（4.1–4.5）全部完成，我们再开启 Step6 的统一迁移和覆盖率统计，完成“服务标签覆盖率 90%”这一块闭环。

后面每轮我都会在开头给你一个类似「当前全局步骤进度+本轮覆盖 step」的小节，你不用再重复提醒。

20251208\_0110\_服务标签ETL\_通用vs专用划分与convenience\_S2为0的诊断思路  
tags: #服务标签 #通用管道 #特征快照 #S2补洞 #校验查询

---

### 1）一句话结论

后面整体节奏按“总步骤蓝图 + 通用/专用标注”推进：Step0/1/6 是全标签通用骨架，Step2/3/4 是按标签族的专用管道；当前 `store_feature_snapshot_di` 主要为营业时间设计但已满足服务标签所需的行为特征，S2 补洞条数为 0 不算“必然合理”，需要按我给的一组诊断 SQL 看下是数据本身没有命中，还是条件过严/连接写法问题。

---

### 2）三段论据

#### 2.1 哪些是通用管道，哪些是专用管道？——先把“骨架和挂点”讲清楚

先给你一个 **长期固定的“步骤×通用/专用”视图** ，后面我们都按这个口径说话（括号里标记）：

- **Step0：业务日期 / 全局环境（通用）**
	- `etl_tag_step0.detect_biz_date_from_v_merchant_profile`
	- 作用：所有 ETL 都要用业务日，这一步只跑一次，全标签共用。
- **Step1：上游清洗 & 三层特征快照（通用骨架，当前主要服务于营业时间 & 行为类标签）**
	- 1.1 原始清洗：is\_zxgj → HH-HH 区间等（偏 open\_hours 专用，但可以复用逻辑）
	- 1.2 特征快照：
		- `store_feature_snapshot_di` （门店行为特征）
		- `merchant_feature_snapshot_di`
		- `party_feature_snapshot_di`
	- 本质角色： **所有需要“历史行为特征”的标签（营业时间、服务、活跃度、生命周期等）都应该共用这层，而不是各自重复算。**
- **Step2：营业时间候选（open\_hours/open\_24h 专用）**
	- 一系列 `open_hours_candidate_di` 的构建、三层候选与 conf 计算。
	- 目前只服务 open\_hours/open\_24h，不要求服务标签复用。
- **Step3：营业时间标签规范化 & 落 snapshot（open\_hours/open\_24h 专用）**
	- `open_24h` / `open_hours` 重建、HH:MM-HH:MM 格式、与 `open_24h` 对齐等。
	- 这块就是你之前说的 A/B 已经跑通的链路。
- **Step4：服务标签管道（按“服务标签家族”专用，但内部结构通用）**
	- 4.x 的结构是“ **模式通用，标签专用** ”：
		- 4.1 `convenience_store_available`
			- 4.1a S1 从 v\_merchant\_profile 承接
			- 4.1b S2 结构+行为补洞
		- 4.2 `parking_available` （默认真 + 未来地址细化）
		- 4.3 `restroom_available` （结构 + 便利店派生）
		- 4.4 `service_carwash_available` （additional\_services 结构）
		- 4.5 `service_carwash_type` （依赖 carwash\_available + DW 字段）
	- 管道“套路”是通用的：S1 承接 + S2 补洞 + 终表迁移；具体规则/字段是专用的。
- **Step5：其它标签（品牌/策略等，专用）**
	- 同样挂在这一层，但大多是 `WAREHOUSE_DIRECT` ，主要做 S1 接入和少量 S2 补洞。
- **Step6：统一迁移到 station\_tag\_target\_value + QC & 覆盖率统计（通用）**
	- 6.1 snapshot→station\_tag\_target\_value 的迁移（通用）
	- 6.2 QC & fallback 后处理（通用）
	- 6.3 覆盖率统计视图（通用）

总结一下标签维度：

- **通用骨架（所有标签都挂上来）** ：Step0 / Step1 / Step6
- **标签族专用骨架** ：Step2–3（营业时间族）、Step4（服务标签族）、Step5（其它族）
- **单标签专用逻辑** ：每个 4.x / 5.x 子 step 里面的规则细节

后面我会在每轮开头明确写：本轮动的是“哪一个 Step、属于通用还是专用、挂在哪个标签族”。

---

#### 2.2 Step1 目前只算“营业时间相关特征”，是否合理？其它标签要不要用？

你的观察是对的：

> “Step1 现在主要是为 open\_hours 服务的，store\_feature\_snapshot\_di 里主要是营业时间相关的数据。”

从 **当前状态** 看：

- 你现有的 `store_feature_snapshot_di` 确实是围绕 open\_hours 打造的，里面重点是“近 30 日订单时间分布、是否早于 6 点/晚于 20 点有订单”等字段，这些是 open\_hours 的刚需。
- 但我们在设计 convenience S2 时，刻意复用了一部分“通用特征”：
	- `order_cnt_30d` 本质是门店行为强度指标，不是 open\_hours 专属；
	- 这个字段对“便利店有无”“活跃站/新站/沉默站”等标签也有直接价值。

所以现在的状态可以这样理解：

1. **Step1 = 通用骨架，当前已部分通用化**
	- 行为特征中那类“订单量/订单天数/有无夜间订单”的字段，对营业时间 + 服务标签都可用。
	- 你现在已经在 convenience S2 中实实在在在用 `order_cnt_30d` ，说明 Step1 已经 **开始发挥“跨标签复用”的作用** 。
2. **其它标签是否必须依赖 Step1？**
	- 对结构类、纯 DW 承接类标签（比如 `parking_available` 默认真、 `service_carwash_available` 主要看 `additional_services` ）——可以 **不强依赖** Step1，只用结构表（ `dim_gas_store_info_extend` ）就够；
	- 对行为敏感的标签（convenience、活跃度、生命周期、open\_hours、本地补洞逻辑）—— **应该统一依赖 Step1** ，避免重复算行为特征。
3. **未来演进方向**
	- 当你发现更多标签需要“行为维度”，应优先在 Step1 增加字段，而不是在 Step4/5 再建一块自己的临时特征表。
	- 但这不要求“所有标签都得用 Step1”，而是：
		- “需要行为特征的标签”统一用；
		- 只看结构/DW 字段的标签可以仅用 S1 + 结构表。

所以：

- “Step1 里现在多是 open\_hours 相关字段”是 **历史合理 + 当前可接受** 的；
- 关键是：你已经开始用其中的通用字段（ `order_cnt_30d` ），这就符合我们“共享特征”的设计初衷；
- 后面如果某个标签要用新的行为特征，我们优先往 Step1 补充，而不是在标签自己的 step 里乱建临时表。

---

#### 2.3 S2 补洞数量为 0，是否符合预期？怎么系统排查？

直说：

- “S2 补洞数量 = 0” **不算必然合理** 。
- 从业务预期看，只要有少量站：
	- `additional_services` 有 3（便利店），或者
	- `order_cnt_30d >= 15`  
		且当前 snapshot 中 convenience 为“空/99”，就应该至少出现一些补洞记录。

所以更像是以下几类原因之一：

1. **数据本身确实没有命中条件**
	- 例如：
		- 没有任何站 `FIND_IN_SET('3', additional_services)>0` ；
		- 或者 `order_cnt_30d >= 15` 的站全都在 S1 已经有 0/1 值，没有 99/空的。
2. **连接/过滤条件过严导致“候选站集合=0”**
	- 例如：
		- `dim_gas_store_info_extend` 的 `dt` 与 `v_merchant_profile_latest_di.dt` 不一致，LEFT JOIN 变成了“全 NULL”；
		- `store_feature_snapshot_di.as_of_date` 与 `@biz_date` 不一致；
		- WHERE 里多了一些不该有的过滤。
3. **S1 已经把所有候选样本填满了 0/1，没有 99/空**
	- 如果你在 S1 之前做了 delete + 重算，且 v\_merchant\_profile\_latest\_di 的字段覆盖率已经很高，这种情况也可能发生。
	- 这时候 S2 为 0 其实从“逻辑正确但业务没收益”角度看，也是一个结论：上游已经把洞填完了。

要搞清楚“是 1 还是 2/3”，最直接办法就是跑一组 **统一的诊断 SQL** ，下面我已经给你整理成一个代码块，方便你一次性复制执行和对照。

---

### 3）统一校验与诊断查询（一个代码块，方便复制）

> 说明：
> 
> - 假设你已经按惯例设置好了 `@biz_dt_str` 和 `@biz_date` ；
> - 下面 SQL 分成 4 段：基础 & 分布、S2 补洞数量、候选样本诊断、结构/行为信号覆盖诊断。

```sql
sql/*********************************************
 * Q0：基础信息 - 样本基数 & 快速 sanity check
 *********************************************/

-- Q0-1：今天的业务日、样本站点总数（以 v_merchant_profile_latest_di 为准）
SELECT 
    @biz_dt_str    AS biz_dt_str,
    @biz_date      AS biz_date,
    COUNT(DISTINCT store_id) AS total_store_cnt
FROM v_merchant_profile_latest_di
WHERE dt = @biz_dt_str;

-- Q0-2：store_feature_snapshot_di 中是否有对应 as_of_date 的记录
SELECT 
    @biz_date AS biz_date,
    COUNT(DISTINCT store_id) AS snapshot_store_cnt
FROM store_feature_snapshot_di
WHERE as_of_date = @biz_date;

/*********************************************
 * Q1：snapshot 中 convenience 的整体分布（S1 vs S2）
 *********************************************/

-- Q1-1：按 enum_code + evidence_state 看分布（核心分布表）
SELECT
  enum_code,
  evidence_state,
  COUNT(*) AS cnt
FROM store_tag_snapshot_di
WHERE as_of_date = @biz_date
  AND tag_code   = 'convenience_store_available'
GROUP BY enum_code, evidence_state
ORDER BY enum_code, evidence_state;

-- Q1-2：看 S2 补洞站点数（INFERRED + enum_code=1）
SELECT
  COUNT(*) AS patched_cnt
FROM store_tag_snapshot_di
WHERE as_of_date      = @biz_date
  AND tag_code        = 'convenience_store_available'
  AND evidence_state  = 'INFERRED'
  AND enum_code       = '1'
  AND reason LIKE 'patched_by_algo_convenience_store%';

/*********************************************
 * Q2：覆盖率视角 - 自然覆盖率 vs 总覆盖率（粗略版）
 *********************************************/

-- Q2-1：自然覆盖率（只看 FOUND_IN_RAW + 非兜底）
SELECT COUNT(DISTINCT s.store_id) AS natural_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'convenience_store_available'
  AND s.evidence_state  = 'FOUND_IN_RAW'
  AND e.is_default      = 0;

-- Q2-2：总覆盖率（FOUND_IN_RAW + INFERRED，非兜底）
SELECT COUNT(DISTINCT s.store_id) AS total_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date = @biz_date
  AND s.tag_code   = 'convenience_store_available'
  AND e.is_default = 0;

/*********************************************
 * Q3：S2 为 0 时的关键诊断 - 看“候选样本池”
 *********************************************/

-- Q3-1：从上游视角看，哪些 store 符合“结构/行为命中”的候选（忽略 snapshot）
SELECT
    v.store_id,
    CASE
        WHEN FIND_IN_SET(
                 '3',
                 COALESCE(d.additional_services, '')
             ) > 0
        THEN 1 ELSE 0
    END AS has_struct,
    CASE
        WHEN sf.order_cnt_30d IS NOT NULL
         AND sf.order_cnt_30d >= 15
        THEN 1 ELSE 0
    END AS has_behavior
FROM v_merchant_profile_latest_di v
LEFT JOIN dim_gas_store_info_extend d
       ON d.store_id = v.store_id
      AND d.dt       = v.dt       -- 如果这里 join 不上，可以先改成只按 store_id 看看
LEFT JOIN store_feature_snapshot_di sf
       ON sf.store_id   = v.store_id
      AND sf.as_of_date = @biz_date
WHERE v.dt = @biz_dt_str
LIMIT 200;

-- Q3-2：统计“结构/行为命中”的站点数量（不看 snapshot）
SELECT
    SUM(CASE WHEN has_struct = 1 THEN 1 ELSE 0 END) AS struct_hit_cnt,
    SUM(CASE WHEN has_behavior = 1 THEN 1 ELSE 0 END) AS behavior_hit_cnt,
    SUM(CASE WHEN has_struct = 1 OR has_behavior = 1 THEN 1 ELSE 0 END) AS union_hit_cnt
FROM (
    SELECT
        v.store_id,
        CASE
            WHEN FIND_IN_SET(
                     '3',
                     COALESCE(d.additional_services, '')
                 ) > 0
            THEN 1 ELSE 0
        END AS has_struct,
        CASE
            WHEN sf.order_cnt_30d IS NOT NULL
             AND sf.order_cnt_30d >= 15
            THEN 1 ELSE 0
        END AS has_behavior
    FROM v_merchant_profile_latest_di v
    LEFT JOIN dim_gas_store_info_extend d
           ON d.store_id = v.store_id
          AND d.dt       = v.dt
    LEFT JOIN store_feature_snapshot_di sf
           ON sf.store_id   = v.store_id
          AND sf.as_of_date = @biz_date
    WHERE v.dt = @biz_dt_str
) t;

-- Q3-3：在“候选样本池”里，看哪些站目前是“无记录/兜底”，理论上应该被 S2 命中
SELECT
    v.store_id,
    t.enum_code       AS current_enum_code,
    t.evidence_state  AS current_evidence_state,
    CASE
        WHEN FIND_IN_SET(
                 '3',
                 COALESCE(d.additional_services, '')
             ) > 0
        THEN 1 ELSE 0
    END AS has_struct,
    CASE
        WHEN sf.order_cnt_30d IS NOT NULL
         AND sf.order_cnt_30d >= 15
        THEN 1 ELSE 0
    END AS has_behavior
FROM v_merchant_profile_latest_di v
LEFT JOIN dim_gas_store_info_extend d
       ON d.store_id = v.store_id
      AND d.dt       = v.dt
LEFT JOIN store_feature_snapshot_di sf
       ON sf.store_id   = v.store_id
      AND sf.as_of_date = @biz_date
LEFT JOIN store_tag_snapshot_di t
       ON t.store_id   = v.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'convenience_store_available'
WHERE v.dt = @biz_dt_str
  AND ( 
        -- 结构或行为命中
        FIND_IN_SET('3', COALESCE(d.additional_services, '')) > 0
        OR (sf.order_cnt_30d IS NOT NULL AND sf.order_cnt_30d >= 15)
      )
  AND (
        -- snapshot 中是“无记录/兜底”，即 S2 目标
        t.store_id IS NULL
        OR t.enum_code = '99'
      )
LIMIT 200;

/*********************************************
 * Q4：抽样看已经被 S2 补洞的记录（如果 patched_cnt > 0）
 *********************************************/

SELECT
  s.store_id,
  s.enum_code,
  s.evidence_state,
  s.conf,
  s.reason,
  d.additional_services,
  sf.order_cnt_30d
FROM store_tag_snapshot_di s
LEFT JOIN dim_gas_store_info_extend d
       ON d.store_id = s.store_id
      AND d.dt       = @biz_dt_str
LEFT JOIN store_feature_snapshot_di sf
       ON sf.store_id   = s.store_id
      AND sf.as_of_date = @biz_date
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'convenience_store_available'
  AND s.evidence_state  = 'INFERRED'
  AND s.enum_code       = '1'
ORDER BY s.conf DESC
LIMIT 50;
```

**如何解读这些结果：**

- 如果 Q3-2 的 `union_hit_cnt = 0` ，说明 **数据本身就没有命中结构/行为信号** ，S2 为 0 很可能是“值班没机会干活”；
- 如果 Q3-2 的 `union_hit_cnt > 0` ，但 Q3-3 返回的行数 = 0：
	- 说明这些命中的站点在 snapshot 里都已经有非兜底值（大概率 S1 已经填满），S2 自然无事可做；
- 如果 Q3-3 返回的行数 > 0，但 Q1-2 `patched_cnt = 0` ：
	- 那就更偏向“写法问题”：要么 S2 SQL 的过滤条件写重了，要么主键/唯一键约束没触发 `INSERT ... ON DUPLICATE KEY` （例如 store\_tag\_snapshot\_di 的主键不是你以为的那组字段）。

你跑完这组结果后，拍一两个关键查询结果（比如 Q1-1 / Q1-2 / Q3-2 / Q3-3 的行数概况）给我，我就能更精确地帮你判断是“数据问题”还是“SQL 逻辑要微调”。

---

### 4）迭代日志

- **来源** ：
	- 你反馈 convenience S1/S2 脚本已跑通，但 S2 补洞条数为 0；
	- 提出三个关键诉求：  
		1）明确通用管道 vs 专用管道；  
		2）解释 Step1 目前“偏营业时间”的状态对其它标签是否合理；  
		3）把校验/诊断 SQL 整理在一个代码块里，方便复制。
- **本轮结论** ：  
	1）固定了一张“步骤×通用/专用”蓝图：Step0/1/6 通用骨架，Step2–5 为标签族/单标签的专用管道；  
	2）确认 Step1 虽然源自营业时间设计，但已经在行为特征上开始服务服务标签（尤其 `order_cnt_30d` ），是合理的“渐进通用”；  
	3）S2 补洞为 0 不是必然合理，需要借助一组统一诊断 SQL 来判断是“数据确实无命中”还是“连接/过滤/主键配置上的问题”。
- **下一步建议** ：  
	1）你先跑完整个代码块中的 Q0–Q4，尤其关注：
	- Q1-2 的 `patched_cnt` ；
	- Q3-2 的 `union_hit_cnt` ；
	- Q3-3 是否返回样本。  
		2）把几条关键结果（可以用文字总结行数/比例）发给我，我们再决定：
	- 是调整阈值（例如订单 15 是否过高）；
	- 还是放宽结构条件（比如 additional\_services 的取值情况）；
	- 或者简化 S2 的目标（只对明确有“3”的站点做补洞）；  
		3）一旦 convenience 的 S2 行为符合预期，我们就按同样结构推进 Step4.2（parking），并在每一轮继续把“SQL + 校验查询 + 可贴总控文档段落”都打包好。

20251208\_0200\_服务标签ETL\_convenience数据诊断与节奏对齐

tags: #服务标签 #convenience #补洞效果 #步骤编号规范

---

### 1）一句话结论

从你给的结果看：

- convenience 当前已经有一批 `INFERRED=2492` 的历史补洞值（覆盖率从约 24% 拉到约 40%），说明“有 S2 逻辑在起作用”；
- 但我们刚写的这版 S2（ `patched_by_algo_convenience_store` ） **目前实际贡献为 0** ，是“逻辑没问题但没有新样本可改 / 或没命中 reason 过滤”；
- Step1 作为通用特征层是合理的，现在确实主要服务营业时间和服务标签；后面新增行为特征统一往这里补即可。

下面我按你的习惯，用“自然序号+标识”来说明和引用。

---

### 2）对你这批数据的解读（是否符合预期）

你给的数据（我按你说的自然序号标一下）：

- `3-Q1-1` 分布：
- `4-Q1-2` （patched\_cnt）：
- `7-Q3-2` 结构/行为信号：
- `8-Q3-3` 只贴了表头（ `store_id current_enum_code current_evidence_state has_struct has_behavior` ），可以理解为有返回一些样本。

基于这些数，我们可以推一下一些关键结论（假设 snapshot 里每个站点对这个 tag 只保留一条记录）：

#### 2.1 覆盖率大致水平

总行数 = 1141 + 2805 + 2492 + 9808 = 16246（大概率≈总站点数）。

- 自然覆盖（只看 FOUND\_IN\_RAW 且非兜底）：
	- 自然有值站点 = 1141（0） + 2805（1） = 3946
	- 自然覆盖率 ≈ 3946 / 16246 ≈ 24.3%
- 总覆盖（FOUND\_IN\_RAW + INFERRED，非兜底）：
	- 总有值站点 = 1141 + 2805 + 2492 = 6438
	- 总覆盖率 ≈ 6438 / 16246 ≈ 39.6%

说明两件事：

1. **你目前的 convenience 自然覆盖率很低（约 24%）** ，这是我们要提升的对象；
2. 现在已经有一批 `INFERRED=2492` 在帮你“填洞”，把覆盖率抬到了接近 40%——这批很可能是以前脚本的 S2 逻辑，不是我们刚写的 `patched_by_algo_convenience_store` 。

所以从“整体数据状态”来看：

- 有 S2 补洞在起作用（INFERRED≠0）；
- 但不是我们这轮新补的；
- 依然还有 9808 个 `99` 未知值，后面是我们优化空间。

#### 2.2 行为信号情况（7-Q3-2）

`struct_hit_cnt = 0, behavior_hit_cnt = union_hit_cnt = 4110` ：

- **结构信号 0** ： `dim_gas_store_info_extend.additional_services` 里目前没有任何一条包含编码 `3` （便利店）。
	- 这符合你说的“现在很多服务字段还没在 extend 里填好”的情况，因此我们之前“结构+行为”的设计，在当前数据阶段 **其实只剩下“行为信号”这一条腿** 。
- **行为信号 4110** ：有 4110 个站点 30 日订单 ≥ 15。
	- 这些站看起来是“比较活跃的站”，但不一定都应该被判为“有便利店”；
	- 行为层面的信号强度是存在的。

这一点对现在的结论很重要：

> 数据本身是“有行为信号、没结构信号”的阶段。
> 
> 所以 convenience S2 的设计，在短期内“主要靠行为”，结构那一部分暂时不指望贡献。

#### 2.3 为什么 patched\_cnt = 0 但有 2492 条 INFERRED？

**4-Q1-2 patched\_cnt=0** 的查询是：

但 `3-Q1-1` 里已经有 `1 / INFERRED / 2492` ：

- 说明现在表里确实有 2492 条 `INFERRED` 的 1；
- 但它们的 `reason` **不是** `patched_by_algo_convenience_store...`，很可能是：
	- 历史脚本、数仓逻辑或早期 ETL 写进来的 INFERRED；
	- 或者我们这次脚本没有执行 / 没命中 where 条件；

所以综合来看：

1. 当前这 2492 条 INFERRED **不是本轮脚本补出来的** （不然patched\_cnt不会是0）；
2. 这也解释了为什么“看上去 S2 有数据，但你新逻辑没有贡献”：
	- 现状 = “旧 S2 已经存在，新 S2 还没发挥增量”。

这本身不算“错”，只是说明：

- 你的项目在 convenience 上已经有一条历史补洞链路在跑；
- 我们这轮的新算法，暂时没接管/加强那条链路，而是在旁边“准备接手”。

**是否符合预期？**

- 从“全局状态”看：
	- 有大量未知（99）；
	- 有一部分历史 INFERRED；
	- 行为信号存在但结构信号缺失。  
		→ 这跟你“现在数仓版本不够好，我们要重建链路”的大方向是一致的。
- 从“这轮新 S2 脚本”的角度看：
	- patched\_cnt = 0 → 说明我们这版没有新增补洞；
	- 短期不影响你现有结果，但对“提升覆盖率”来说是“还没开始发力”。

我会把它认定为：

> **业务状态 OK** （有历史 S2、整体逻辑能解释）；  
> **本轮新脚本目前是“空跑”，后面接管/增强历史逻辑时需要专门做迁移和 reason 改造。**

这不会阻塞我们继续做 parking/restroom 等标签，只是要记在总控文档上：

- convenience 当前有历史 INFERRED；
- 新 S2 逻辑尚未接手历史数据，只定义好了“下一代链路”。

---

### 3）关于 Step1 的角色（你的第 2 个问题）

你说：

> Step1 里现在只有营业时间相关的数据，其他标签是否需要执行 step1 呢？

我给一个直接的定位：

1. **Step1 是通用“行为特征层”骨架** ：
	- 现在它的字段设计偏向 open\_hours，是历史遗留；
	- 但像 `order_cnt_30d` 这种已经被 convenience S2 拿来用了，说明它确实在服务“行为敏感标签”。
2. **不是所有标签都必须依赖 Step1** ：
	- 结构/数仓型标签（parking 默认真，carwash 来自 `additional_services` ，brand\_name/level 等）可以只做 S1/S2，不依赖行为特征；
	- 行为驱动型标签（convenience、生命周期、营业时间等）应该统一依赖 Step1，避免重复算。
3. **改造策略** ：
	- 短期：不强行改 Step1，只要能满足 open\_hours + 服务标签的行为特征即可；
	- 中期：如果你发现更多标签要用行为特征，就把字段统一加在 Step1 中，不搞各自一套临时特征；
	- 长期：把 Step1 的设计从“open\_hours 特化”升级为“行为特征公共层”，写进总控文档。

结论：现在 Step1 只算营业时间相关行为特征是 **可以接受的过渡状态** ，你已经在 convenience 上开始复用了其中的通用字段，这是好事。

---

### 4）查询编号约定（自然序号命名）

你说得非常对，光写 “Q1-1/Q1-2/Q3-2/Q3-3” 在一个大代码块里确实不易定位。  
后面我会按你说的格式来：

- `3-Q1-1` ：3 代表第三大段（比如“Q1 分布”），Q1-1 是小编号；
- 或更简单点： **\[1\] \[2\] \[3\]…** 的自然递增编号，注释里直接写对应含义。

后续我会这么写，例如：

你后面只需要回一句“\[3\]/\[4\] 的结果是xxx”就可对齐。

---

### 5）下一步建议与节奏

按当前诊断：

- convenience 的“现状”我们已经看清楚：
	- 历史 S2 已经在发挥作用（2492 INFERRED）；
	- 新 S2 逻辑是“空跑但正确”，主要是给未来统一链路做准备；
	- 数据上暂时缺乏 additional\_services 的结构信号，行为信号已经较充分。

在不立刻重写历史链路的前提下，我建议节奏是：

1. **先不纠缠 convenience 细节，把这个状态如实写入总控文档** ：
	- “当前有历史 INFERRED，覆盖率约 40%；新 S2 逻辑定义好但未接管旧链路”。
2. **开启 Step4.2：parking\_available 的 S1/S2 设计和 SQL** ：
	- parking 本身逻辑简单（默认真 + 未来用城市/地址做例外），非常适合作为第二个“样板标签”；
	- 我会像这次一样：
		- 开头给“全局步骤 + 本轮 step + 通用/专用标注”；
		- 给 parking 的 S1/S2 SQL；
		- 给一套带自然序号标注的校验 SQL；
		- 给一段可贴回总控文档的说明。

等你点头，我们下一条就直接上：

> Step4.2 `parking_available` 的 S1/S2 实现 + 校验查询 + 文档片段。

20251208\_1030\_服务标签ETL\_parking\_S1S2落地与校验SQL

tags: #服务标签 #parking\_available #默认真兜底 #标签ETL #双层管道

---

### 1）一句话结论

本轮我们在既有步骤蓝图下，完成 `parking_available` 的 S1/S2 两段 ETL（S1 承接 v\_merchant\_profile，S2 对空/未知样本默认补为“有停车位”但不覆盖 0），并给出一整块带自然序号标注的校验 SQL，以及一段可直接贴回总控文档的说明。

---

### 2）三段论据

#### 论据一：全局步骤进度 & 本轮定位（通用 vs 专用标注）

先用当前统一蓝图标一下整体位置（你后续可以直接抄到总控文档“步骤总览”里）：

- Step0（通用）：业务日期 & 全局环境
	- `etl_tag_step0.detect_biz_date_from_v_merchant_profile` ✅ 已有并在跑
- Step1（通用骨架，目前主要服务营业时间 + 行为敏感标签）：
	- 门店/商户/工商特征快照（包含 `order_cnt_30d` 等） ✅ 已存在并服务 open\_hours & convenience
- Step2–3（专用：营业时间家族）：
	- open\_hours/open\_24h 的 candidate & 重建链路 ✅ 你那边 A/B 链路已跑通
- Step4（专用：服务标签家族， **当前重心** ）：
	- 4.1 convenience\_store\_available：S1/S2 首版 SQL 已完成 & 已跑 ✅
	- 4.2 parking\_available： **本轮完成 S1/S2** （我们现在做的）
	- 4.3 restroom\_available：待做
	- 4.4 service\_carwash\_available：待做
	- 4.5 service\_carwash\_type：待做
- Step5（专用：基础合作/策略标签家族）：待后续
- Step6（通用）：snapshot→station\_tag\_target\_value 迁移 + QC + 覆盖率视图：待后续

所以本轮精确定位是：

> 「Step4 服务标签家族」中的「4.2 `parking_available` 专用管道」，模式复用 4.1（convenience）的 S1/S2 骨架，但算法逻辑采用“默认真 + 不覆盖显式否”的规则。

#### 论据二：parking\_available 的 S1/S2 设计

结合你之前的口径：

- 业务语义：油站加油一定要能停车，本质上是“基础设施默认有”；
- 但我们保留“明确说明不能停车的站点”的空间（未来可能经由区域反馈或数仓字段标记 0）。

我们约定：

1. **S1（from DW/区域）**
	- 从 `v_merchant_profile_latest_di.parking_available` 承接已有结果；
	- 支持编码值（0/1/99）和中文（是/否/未知）双写；
	- 映射逻辑：
		- 1/“是” → `enum_code='1'` ， `target_value_bool=1`
		- 0/“否” → `enum_code='0'` ， `target_value_bool=0`
		- 99/“未知” → `enum_code='99'` ， `target_value_*` 全 NULL
	- 落地属性：
		- `source_level='STORE'`
		- `evidence_state='FOUND_IN_RAW'`
		- `algo_version='parking_available_v1'`
		- `reason='s1_from_v_merchant_profile'`
2. **S2（默认真补洞，但不覆盖显式 0）**
	- 目标样本：
		- 当前业务日下，在 `store_tag_snapshot_di` 中：
			- 没有 `parking_available` 记录，或
			- `enum_code='99'` （未知兜底）
		- 且上游 v\_merchant\_profile 里 **没有明确否定** （不强行覆盖 0）；
	- 补洞逻辑：
		- 统一补成“有停车位”： `enum_code='1'`, `target_value_bool=1` ；
		- 这是“业务默认真 + 为提升覆盖率的补洞逻辑”；
	- 落地属性：
		- `evidence_state='INFERRED'`
		- `algo_version='parking_available_v1'`
		- `reason` 前缀： `patched_by_algo_parking_default_true`
		- `conf` 可设在 0.7 左右（弱于结构/行为强信号，但足够用于覆盖率统计）
3. **不做的事（明确划界）：**
	- 不覆盖 S1 明确给出的 0（无停车位），保留区域/数仓“否定信息”的优先级；
	- 暂不引入“城市/郊区区分”的复杂逻辑（你之前说这可以作为后续升级点）。

这套逻辑可以快速将 convenience 类似的“高比例 99”压缩，使 parking 的有效覆盖率接近 100%，同时又不破坏未来“区域特殊否定”的空间。

#### 论据三：SQL 设计 & 校验思路

- SQL 层：沿用 convenience S1/S2 的写法，新增：
	- `etl_tag_step4.2a.parking_s1_from_dw`
	- `etl_tag_step4.2b.parking_s2_patch_default_true`
- 校验层：
	- 我用你要求的“3-Q1-1/3-Q1-2/4-Q2-1...”自然编号方式，打一整块方便复制的校验 SQL：
		- \[3-Q1-1\] 看 snapshot 中 `parking_available` 的 enum\_code + evidence\_state 分布；
		- \[3-Q1-2\] 看本轮 S2（默认真补洞）贡献的条数（带 reason 前缀）；
		- \[4-Q2-1\]/\[4-Q2-2\] 粗算自然覆盖率 vs 总覆盖率（非兜底）；
		- \[5-Q3-1\] 抽样看被 S2 补洞的具体站点，确认是否“逻辑上没问题”。

---

### 3）SQL 实现 & 校验（整块代码，已按自然序号标注）

> 说明：
> 
> - 假设 Step0 已经设置好 `@biz_dt_str` 和 `@biz_date` ；
> - 如需全量重算 parking，你可以在 4.2a 前先 DELETE 本业务日的该 tag 记录；
> - 如表/字段名与你真实库略有不同，你在本地调整即可。

```sql
sql/*********************************************
 * 1-Step0：业务日期（如已有可略过）
 *********************************************/

-- etl_tag_step0.detect_biz_date_from_v_merchant_profile
SET @biz_dt_str = (
    SELECT MAX(dt) 
    FROM v_merchant_profile_latest_di
);

SET @biz_date = STR_TO_DATE(@biz_dt_str, '%Y-%m-%d');

/*********************************************
 * 2-Step4.2a：parking S1 - 从 v_merchant_profile 承接
 *********************************************/

-- etl_tag_step4.2a.parking_s1_from_dw
-- 说明：承接数仓/区域 parking_available 结果，FOUND_IN_RAW

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
    t.store_id,
    @biz_date                      AS as_of_date,
    'parking_available'           AS tag_code,

    CASE 
        WHEN t.enum_code_mapped IN ('1','0')
        THEN CAST(t.enum_code_mapped AS SIGNED)
        ELSE NULL
    END                            AS target_value_bool,
    NULL                           AS target_value_number,
    NULL                           AS target_value_string,

    t.enum_code_mapped             AS enum_code,
    'STORE'                        AS source_level,
    'FOUND_IN_RAW'                 AS evidence_state,
    ts.ttl_days                    AS ttl_days,
    1.0000                         AS conf,
    's1_from_v_merchant_profile'   AS reason,
    'parking_available_v1'         AS algo_version,
    NULL                           AS target_value_string_back
FROM (
    SELECT
        v.store_id,
        CASE
            -- 已是枚举编码的情况
            WHEN v.parking_available IN ('1','0','99')
                THEN v.parking_available

            -- 中文容错：是/否/未知
            WHEN v.parking_available = '是'   THEN '1'
            WHEN v.parking_available = '否'   THEN '0'
            WHEN v.parking_available = '未知' THEN '99'

            ELSE NULL
        END AS enum_code_mapped
    FROM v_merchant_profile_latest_di v
    WHERE v.dt = @biz_dt_str
) t
JOIN tag_spec ts
  ON ts.tag_code      = 'parking_available'
 AND ts.spec_version  = '1.0.0'
WHERE t.enum_code_mapped IS NOT NULL;

/*********************************************
 * 3-Step4.2b：parking S2 - 默认真补洞（不覆盖显式 0）
 *********************************************/

-- etl_tag_step4.2b.parking_s2_patch_default_true
-- 说明：对“无记录/未知(99)”样本补为 1，但保留 S1 明确的 0

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
    v.store_id,
    @biz_date                              AS as_of_date,
    'parking_available'                    AS tag_code,
    1                                      AS target_value_bool,
    NULL                                   AS target_value_number,
    NULL                                   AS target_value_string,
    '1'                                    AS enum_code,
    'STORE'                                AS source_level,
    'INFERRED'                             AS evidence_state,
    ts.ttl_days                            AS ttl_days,
    0.7000                                 AS conf,
    'patched_by_algo_parking_default_true' AS reason,
    'parking_available_v1'                 AS algo_version,
    NULL                                   AS target_value_string_back
FROM v_merchant_profile_latest_di v
LEFT JOIN store_tag_snapshot_di t
       ON t.store_id   = v.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'parking_available'
JOIN tag_spec ts
  ON ts.tag_code      = 'parking_available'
 AND ts.spec_version  = '1.0.0'
WHERE v.dt = @biz_dt_str
  AND (
        -- snapshot 中无此标签记录
        t.store_id IS NULL
        OR
        -- 或有记录但为未知兜底值（99）
        t.enum_code = '99'
      )

ON DUPLICATE KEY UPDATE
    target_value_bool         = VALUES(target_value_bool),
    target_value_number       = VALUES(target_value_number),
    target_value_string       = VALUES(target_value_string),
    enum_code                 = VALUES(enum_code),
    source_level              = VALUES(source_level),
    evidence_state            = VALUES(evidence_state),
    ttl_days                  = VALUES(ttl_days),
    conf                      = VALUES(conf),
    reason                    = CASE
                                    WHEN store_tag_snapshot_di.reason IS NULL
                                         OR store_tag_snapshot_di.reason = ''
                                    THEN VALUES(reason)
                                    ELSE CONCAT(store_tag_snapshot_di.reason, '|', VALUES(reason))
                                END,
    algo_version              = VALUES(algo_version),
    target_value_string_back  = store_tag_snapshot_di.target_value_string_back;

/*********************************************
 * 4-校验：parking 标签的覆盖情况与 S2 补洞效果
 *********************************************/

-- [3-Q1-1] parking 标签在 snapshot 中的 enum_code + evidence_state 分布
SELECT
  enum_code,
  evidence_state,
  COUNT(*) AS cnt
FROM store_tag_snapshot_di
WHERE as_of_date = @biz_date
  AND tag_code   = 'parking_available'
GROUP BY enum_code, evidence_state
ORDER BY enum_code, evidence_state;

-- [3-Q1-2] S2 补洞条数：INFERRED + enum_code=1 且 reason 前缀为 patched_by_algo_parking_default_true
SELECT
  COUNT(*) AS patched_cnt
FROM store_tag_snapshot_di
WHERE as_of_date      = @biz_date
  AND tag_code        = 'parking_available'
  AND evidence_state  = 'INFERRED'
  AND enum_code       = '1'
  AND reason LIKE 'patched_by_algo_parking_default_true%';

-- [4-Q2-1] 自然覆盖率（FOUND_IN_RAW + 非兜底）
SELECT COUNT(DISTINCT s.store_id) AS natural_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'parking_available'
  AND s.evidence_state  = 'FOUND_IN_RAW'
  AND e.is_default      = 0;

-- [4-Q2-2] 总覆盖率（FOUND_IN_RAW + INFERRED，非兜底）
SELECT COUNT(DISTINCT s.store_id) AS total_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date = @biz_date
  AND s.tag_code   = 'parking_available'
  AND e.is_default = 0;

-- [5-Q3-1] 抽样查看被 S2 默认真补洞的具体站点
SELECT
  s.store_id,
  s.enum_code,
  s.evidence_state,
  s.conf,
  s.reason
FROM store_tag_snapshot_di s
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'parking_available'
  AND s.evidence_state  = 'INFERRED'
  AND s.enum_code       = '1'
  AND s.reason LIKE 'patched_by_algo_parking_default_true%'
ORDER BY s.conf DESC
LIMIT 50;
```

---

### 4）可直接贴回总控文档的片段（parking 标签小节）

你可以直接拷这段进蓝皮书的 `parking_available` 小节，再按你口味微调措辞：

> **标签：parking\_available（是否有停车位，A 类）**
> 
> - **algo\_mode** ： `DEFAULT_TRUE`
> - **rule\_template** ： `PARKING_DEFAULT_TRUE_WITH_DW_OVERRIDE_V1`
> - **上游依赖** ：
> 	- DW/区域结果： `v_merchant_profile_latest_di.parking_available` （S1，自然覆盖，FOUND\_IN\_RAW）
> - **S1 逻辑（etl\_tag\_step4.2a.parking\_s1\_from\_dw）** ：
> 	- 从 v\_merchant\_profile 承接已有 parking 标记；
> 	- 支持枚举编码（0/1/99）与中文值（是/否/未知）的容错映射；
> 	- 落入 `store_tag_snapshot_di` ， `evidence_state='FOUND_IN_RAW'` ， `algo_version='parking_available_v1'` 。
> - **S2 逻辑（etl\_tag\_step4.2b.parking\_s2\_patch\_default\_true）** ：
> 	- 对“无记录/未知(99)”样本（且未被上游显式标记为 0）的站点，统一默认补成“有停车位”（enum\_code='1'）；
> 	- 补洞记录标记为 `evidence_state='INFERRED'` ， `reason` 前缀 `patched_by_algo_parking_default_true` ， `conf≈0.7` ；
> 	- 不覆盖 S1 已给出的 0（保留未来区域/数仓否定信息的优先级）。
> - **输出路径** ：
> 	- 中间层： `store_tag_snapshot_di` （本轮已实现 S1/S2）；
> 	- 终表层： `station_tag_target_value` （后续通过统一 T 层脚本迁移，并配合 QC 字段与 enum.is\_default 进行覆盖率与质量评估）。

---

### 5）迭代日志

- **本轮输入** ：
	- 你确认 Step 蓝图与“通用 vs 专用”划分 OK，希望继续推进服务标签；
	- 明确要求：
		- 查询要在一个代码块里，并带“3-Q1-1 / 4-Q2-2”这种自然序号，方便口头引用和对照。
- **本轮输出** ：
	1. 完成 Step4.2 `parking_available` 的 S1/S2 SQL，遵循默认真 + 不覆盖显式 0 的业务逻辑；
	2. 给出一整块带自然序号注释的校验 SQL（\[3-Q1-1\]~\[5-Q3-1\]），方便你快速看分布、补洞规模和样本；
	3. 输出一段可以直接贴回总控文档的 parking 标签说明。
- **下一步建议** ：
	1. 你在 dev 库跑完这两段 SQL 后，依次执行上面代码块中的 \[3-Q1-1\]~\[5-Q3-1\]；
	2. 把关键结果用“标签+数字”的方式反馈给我，例如：
		- `[3-Q1-1] 分布：0/1/99 各多少，FOUND_IN_RAW vs INFERRED 情况`
		- `[3-Q1-2] patched_cnt = ?`
		- `[4-Q2-1]/[4-Q2-2] 自然覆盖 vs 总覆盖`
	3. 如果结果符合你的业务直觉，我们下一轮就进入 Step4.3 `restroom_available` 的 S1/S2 设计和 SQL；
	4. 等服务标签 4.1–4.5 全部完成后，一起做 Step6 的统一迁移 + QC + 覆盖率统计闭环。

20251208\_1130\_服务标签ETL\_parking结果解读 & restroom\_S1S2落地

tags: #服务标签 #parking\_available #restroom\_available #标签ETL #覆盖率90

---

### 1）一句话结论

parking 的数据反馈说明：当前已经是“24% 自然覆盖 + 100% 总覆盖”的状态，本轮新 S2 没产生增量是预期内的结果；在此基础上，我们按同样骨架推进 `restroom_available` 的 S1/S2，实现“结构 + 便利店派生 + 默认真兜底”的链路，并统一采用从 1 开始的自然递增查询编号。

---

### 2）三段论据

#### 论据一：parking 结果解读——自然 24% + 总 100%，S2 新逻辑目前是“空跑不背锅”

你给的结果是：

- 分布：
- patched\_cnt = 0
- natural\_cov\_store\_cnt = 3920
- total\_cov\_store\_cnt = 16246

解读：

1. **自然覆盖率**
	- 自然有值站点 = 2035（0） + 1885（1） = 3920
	- 自然覆盖率 ≈ 3920 / 16246 ≈ 24.1%
2. **总覆盖率（FOUND\_IN\_RAW + INFERRED，非兜底）**
	- 总有值站点 = 3920 + 12326 = 16246
	- 总覆盖率 = 16246 / 16246 = 100%
3. **patched\_cnt = 0 的含义**
	- 现在表里已经有 12326 条 `1 / INFERRED` ，但 reason 不以 `patched_by_algo_parking_default_true` 开头，说明：
		- 这 12326 条是历史链路/旧脚本产生的；
		- 我们新加的 S2（默认真补洞）在当前数据状态下没有新增记录（因为已经没有 99/空 的样本可以补了）。

综合来看：

- 从“业务目标”看：parking 已经 100% 覆盖，本轮改造不需要再拉升覆盖率；
- 从“工程形态”看：我们的 S1/S2 SQL 把 parking 的 **逻辑形态固化进了统一管道** ，但出于“已有历史数据”的原因，本轮不会产生增量。
- 在总控文档里，只需要把这点写清楚：parking 当前覆盖率已达 100%，新管道主要是把逻辑收拢到统一骨架，历史 INFERRED 不重写。

这不阻碍我们继续推进下一个服务标签。

#### 论据二：查询编号规范——从 1 开始自然递增，后面统一

你的要求我完全按你说的执行：

- 所有校验/诊断 SQL，以 **`-- [1] ...`、 `-- [2] ...`** 的形式顺序编号；
- 一个查询对应一个唯一编号，不复用，不跨段；
- 你后续反馈时只需要说“\[1\] 的结果是 xxxx、\[3\] 的结果是 xxxx”。

从这一条开始，所有新给的 SQL，我都用这种自然递增编号。

#### 论据三：restroom\_available 的 S1/S2 设计——结构 + 便利店派生 + 默认真

结合之前共识：

- `restroom_available` 业务语义：
	- 有便利店几乎必然有卫生间；
	- extend 结构字段中 `additional_services` 的 0 = 卫生间；
	- 你之前也说：open\_24h/open\_hours/restroom/convenience\_store 默认标记“有”，只是覆盖率计算时需区分兜底。

我们给 restroom 的设计：

1. **S1：承接已有结果（与 convenience/parking 同套路）**
	- 来源： `v_merchant_profile_latest_di.restroom_available` ；
	- 映射：
		- 1/“是” → enum\_code='1'，target\_value\_bool=1；
		- 0/“否” → enum\_code='0'，target\_value\_bool=0；
		- 99/“未知” → enum\_code='99'，三选一全 NULL；
	- 落地：FOUND\_IN\_RAW、algo\_version='restroom\_available\_v1'。
2. **S2：结构 + 便利店派生补洞（不覆盖显式 0）**
	- 信号源：
		- 结构： `dim_gas_store_info_extend.additional_services` 中包含 '0' → has\_struct\_restroom=1；
		- 便利店派生： `store_tag_snapshot_di.convenience_store_available` 最终 enum\_code='1' → has\_convenience=1；
	- 目标样本：
		- 当前业务日下 restroom 在 snapshot：
			- 无记录，或
			- enum\_code='99'；
		- 且不覆盖已有 0。
	- 补洞逻辑：
		- 只要 has\_struct\_restroom=1 或 has\_convenience=1，就补成 1；
		- conf：
			- struct+convenience → 0.90
			- 仅 struct → 0.85
			- 仅 convenience → 0.80
	- 落地：INFERRED，reason 前缀 `patched_by_algo_restroom_from_struct_convenience` 。
3. **默认真策略**
	- 这轮先 **不再额外做“纯默认真兜底”** （即仅依靠 convenience + extend），避免秒拉满而失去辨别力；
	- 真正纯兜底（所有信号都缺，仍强制填 1）的决策放在后面的 Q/T 层，通过 tag\_algo\_config + QC 字段控制（也方便你在覆盖率看板里拆“自然 vs 兜底”）。

---

### 3）restroom\_available S1/S2 SQL + 校验查询（统一自然编号）

> 说明：
> 
> - Step0 同 parking，不再赘述；
> - 如要全量重算，可以在 S1 前加 DELETE 清理当天 restroom 的 snapshot；
> - 以下查询编号从 \[1\] 递增。

```sql
sql/*********************************************
 * 1-Step4.3a：restroom S1 - 从 v_merchant_profile 承接
 *********************************************/

-- etl_tag_step4.3a.restroom_s1_from_dw
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
    t.store_id,
    @biz_date                      AS as_of_date,
    'restroom_available'          AS tag_code,

    CASE 
        WHEN t.enum_code_mapped IN ('1','0')
        THEN CAST(t.enum_code_mapped AS SIGNED)
        ELSE NULL
    END                            AS target_value_bool,
    NULL                           AS target_value_number,
    NULL                           AS target_value_string,

    t.enum_code_mapped             AS enum_code,
    'STORE'                        AS source_level,
    'FOUND_IN_RAW'                 AS evidence_state,
    ts.ttl_days                    AS ttl_days,
    1.0000                         AS conf,
    's1_from_v_merchant_profile'   AS reason,
    'restroom_available_v1'        AS algo_version,
    NULL                           AS target_value_string_back
FROM (
    SELECT
        v.store_id,
        CASE
            WHEN v.restroom_available IN ('1','0','99')
                THEN v.restroom_available

            WHEN v.restroom_available = '是'   THEN '1'
            WHEN v.restroom_available = '否'   THEN '0'
            WHEN v.restroom_available = '未知' THEN '99'

            ELSE NULL
        END AS enum_code_mapped
    FROM v_merchant_profile_latest_di v
    WHERE v.dt = @biz_dt_str
) t
JOIN tag_spec ts
  ON ts.tag_code      = 'restroom_available'
 AND ts.spec_version  = '1.0.0'
WHERE t.enum_code_mapped IS NOT NULL;

/*********************************************
 * 2-Step4.3b：restroom S2 - 结构 + 便利店派生补洞（不覆盖 0）
 *********************************************/

-- etl_tag_step4.3b.restroom_s2_from_struct_and_convenience
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
    @biz_date                                    AS as_of_date,
    'restroom_available'                        AS tag_code,
    1                                            AS target_value_bool,
    NULL                                         AS target_value_number,
    NULL                                         AS target_value_string,
    '1'                                          AS enum_code,
    'STORE'                                      AS source_level,
    'INFERRED'                                   AS evidence_state,
    ts.ttl_days                                  AS ttl_days,
    CASE
        WHEN s.has_struct = 1 AND s.has_convenience = 1 THEN 0.90
        WHEN s.has_struct = 1 AND s.has_convenience = 0 THEN 0.85
        WHEN s.has_struct = 0 AND s.has_convenience = 1 THEN 0.80
        ELSE 0.70
    END                                           AS conf,
    CONCAT(
        'patched_by_algo_restroom_from_struct_convenience;',
        'struct=', s.has_struct,
        ';convenience=', s.has_convenience
    )                                            AS reason,
    'restroom_available_v1'                      AS algo_version,
    NULL                                         AS target_value_string_back
FROM (
    SELECT
        v.store_id,

        -- 结构信号：附加服务中包含 0（卫生间）
        CASE
            WHEN FIND_IN_SET(
                     '0',
                     COALESCE(d.additional_services, '')
                 ) > 0
            THEN 1 ELSE 0
        END AS has_struct,

        -- 便利店派生：convenience_store_available 最终为 1
        CASE
            WHEN c.enum_code = '1' THEN 1 ELSE 0
        END AS has_convenience

    FROM v_merchant_profile_latest_di v
    LEFT JOIN dim_gas_store_info_extend d
           ON d.store_id = v.store_id
          AND d.dt       = v.dt
    LEFT JOIN store_tag_snapshot_di c
           ON c.store_id   = v.store_id
          AND c.as_of_date = @biz_date
          AND c.tag_code   = 'convenience_store_available'
    WHERE v.dt = @biz_dt_str
) s
LEFT JOIN store_tag_snapshot_di t
       ON t.store_id   = s.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'restroom_available'
JOIN tag_spec ts
  ON ts.tag_code      = 'restroom_available'
 AND ts.spec_version  = '1.0.0'
WHERE
    -- 仅对“无记录/未知”样本补洞，不覆盖显式 0/1
    (t.store_id IS NULL OR t.enum_code = '99')
    -- 且结构或便利店信号至少命中一个
    AND (s.has_struct = 1 OR s.has_convenience = 1)

ON DUPLICATE KEY UPDATE
    target_value_bool         = VALUES(target_value_bool),
    target_value_number       = VALUES(target_value_number),
    target_value_string       = VALUES(target_value_string),
    enum_code                 = VALUES(enum_code),
    source_level              = VALUES(source_level),
    evidence_state            = VALUES(evidence_state),
    ttl_days                  = VALUES(ttl_days),
    conf                      = VALUES(conf),
    reason                    = CASE
                                    WHEN store_tag_snapshot_di.reason IS NULL
                                         OR store_tag_snapshot_di.reason = ''
                                    THEN VALUES(reason)
                                    ELSE CONCAT(store_tag_snapshot_di.reason, '|', VALUES(reason))
                                END,
    algo_version              = VALUES(algo_version),
    target_value_string_back  = store_tag_snapshot_di.target_value_string_back;

/*********************************************
 * 3-校验查询（统一自然编号）
 *********************************************/

-- [1] restroom 标签在 snapshot 中的 enum_code + evidence_state 分布
SELECT
  enum_code,
  evidence_state,
  COUNT(*) AS cnt
FROM store_tag_snapshot_di
WHERE as_of_date = @biz_date
  AND tag_code   = 'restroom_available'
GROUP BY enum_code, evidence_state
ORDER BY enum_code, evidence_state;

-- [2] S2 补洞条数：INFERRED + enum_code=1 + reason 前缀为 patched_by_algo_restroom_from_struct_convenience
SELECT
  COUNT(*) AS patched_cnt
FROM store_tag_snapshot_di
WHERE as_of_date      = @biz_date
  AND tag_code        = 'restroom_available'
  AND evidence_state  = 'INFERRED'
  AND enum_code       = '1'
  AND reason LIKE 'patched_by_algo_restroom_from_struct_convenience%';

-- [3] 自然覆盖率（FOUND_IN_RAW + 非兜底）
SELECT COUNT(DISTINCT s.store_id) AS natural_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'restroom_available'
  AND s.evidence_state  = 'FOUND_IN_RAW'
  AND e.is_default      = 0;

-- [4] 总覆盖率（FOUND_IN_RAW + INFERRED，非兜底）
SELECT COUNT(DISTINCT s.store_id) AS total_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date = @biz_date
  AND s.tag_code   = 'restroom_available'
  AND e.is_default = 0;

-- [5] 抽样查看被 S2 补洞的站点 & 对应结构/便利店信号
SELECT
  s.store_id,
  s.enum_code,
  s.evidence_state,
  s.conf,
  s.reason,
  d.additional_services,
  c.enum_code AS convenience_enum_code
FROM store_tag_snapshot_di s
LEFT JOIN dim_gas_store_info_extend d
       ON d.store_id = s.store_id
      AND d.dt       = @biz_dt_str
LEFT JOIN store_tag_snapshot_di c
       ON c.store_id   = s.store_id
      AND c.as_of_date = @biz_date
      AND c.tag_code   = 'convenience_store_available'
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'restroom_available'
  AND s.evidence_state  = 'INFERRED'
  AND s.enum_code       = '1'
  AND s.reason LIKE 'patched_by_algo_restroom_from_struct_convenience%'
ORDER BY s.conf DESC
LIMIT 50;
```

---

### 4）迭代日志

- 本轮你提供了 parking 的分布和覆盖数据，我们确认：
	- parking 已经达到 100% 总覆盖，新管道更多是“统一逻辑形态”，不是强行二次补洞；
	- patched\_cnt=0 是因为历史 INFERRED 已占满样本，新 S2 不再产生增量。
- 你要求统一用「从 1 开始自然递增的查询编号」，不再用 3-Q1-1 这种分段编码，我已经按 \[1\]–\[5\] 的形式调整，并后续都按这个规范来。
- 本轮我们：
	- 完成了 Step4.3 `restroom_available` 的 S1/S2 SQL；
	- 给出 5 条标准校验查询，覆盖分布、补洞数量、自然 vs 总覆盖率、以及样本抽查。

**下一步建议** ：

1. 在 dev 库跑完 restroom 的 S1/S2 两段 SQL；
2. 依次执行 \[1\]–\[5\]，用文字反馈关键数字，例如：
	- `[1] 分布（0/1/99 × FOUND_IN_RAW/INFERRED）`
	- `[2] patched_cnt = ?`
	- `[3]/[4] 覆盖率`
3. 如果结果符合你对“卫生间 = 结构+便利店派生+默认真”的直觉，我们就可以：
	- 把这段 restroom 标签小节也补进总控文档；
	- 下一轮推进 `service_carwash_available` 的 S1/S2，复用 additional\_services=1 的结构逻辑，再之后是 `service_carwash_type` 。

20251208\_1410\_服务标签ETL\_service\_carwash\_available\_S1S2落地

tags: #服务标签 #service\_carwash\_available #additional\_services #标签ETL #覆盖率90

---

### 1）一句话结论

在 parking / restroom 之后，本轮我们完成 `service_carwash_available` 的 S1/S2 管道：S1 承接 v\_merchant\_profile，S2 只在“无记录/未知”样本上利用 `additional_services` 中的 `1=洗车` 做正向补洞，不做“默认无”强兜底，并配套一整块按 1/2/3 自然递增编号的校验 SQL 和总控文档说明。

---

### 2）三段论据

#### 论据一：全局步骤进度 & 本轮具体位置

当前步骤蓝图回顾一下（只标关键点）：

- Step0（通用）：业务日期 & 环境变量 → 已有 ✅
- Step1（通用骨架）：三层特征快照 → 为 open\_hours、convenience 等提供行为特征 ✅
- Step2–3（专用：open\_hours/open\_24h）→ 你的 A/B 链路已跑 ✅
- Step4（专用：服务标签家族）
	- 4.1 `convenience_store_available` ：S1/S2 已有 & 在跑 ✅
	- 4.2 `parking_available` ：S1/S2 已有，当前数据 100% 覆盖 ✅
	- 4.3 `restroom_available` ：S1/S2 SQL 已给，你刚刚跑完并确认结果符合预期 ✅
	- 4.4 `service_carwash_available` ： **本轮实现** （现在这一轮）
	- 4.5 `service_carwash_type` ：下一轮
- Step6（通用）：迁移到 `station_tag_target_value` + QC + 覆盖率统计 → 待做

所以本轮精确定位：

> Step4.4 `service_carwash_available` ，复用“服务标签家族”的 S1/S2 骨架，但算法逻辑是“强结构信号 = additional\_services 中的 1=洗车；默认语义是‘没有结构信号就不乱猜 1’，不在 S2 层做强兜底 0。”

#### 论据二：service\_carwash\_available 的 S1/S2 算法设计

结合你之前给的规则和语义：

- `dim_gas_store_info_extend.additional_services` 含义：
	- 0-卫生间, 1-洗车, 2-早点便当, 3-便利店, 4-车胎充气, 5-修车, 6-快餐店
- 你原话：
	- “命中 1 就是洗车；这个同理可以复用到其他的服务标签；没有标记默认没有。”
- 同时你也说：
	- `service_carwash_available` 默认标记为“无”（相比 convenience / restroom / open\_hours 这几个默认“有”）。

在“覆盖率优先，但不胡猜”的前提下，我们分层这样做：

1. **S1：承接 DW/区域结果（FOUND\_IN\_RAW）**
	- 来源： `v_merchant_profile_latest_di.service_carwash_available` ；
	- 映射：
		- 1 / “是” → enum\_code='1'，target\_value\_bool=1；
		- 0 / “否” → enum\_code='0'，target\_value\_bool=0；
		- 99 / “未知” → enum\_code='99'，target\_value\_\* 全 NULL；
	- 属性： `source_level='STORE'` ， `evidence_state='FOUND_IN_RAW'` ， `algo_version='service_carwash_available_v1'` 。
2. **S2：结构补洞（只为“有洗车”做正向补洞，不在这层做“默认为无”）**
	- 信号源：
		- 结构： `FIND_IN_SET('1', additional_services) > 0` 视为 `has_wash_struct=1` ；
	- 目标样本：
		- 当前业务日下， `store_tag_snapshot_di` 中 `service_carwash_available` ：
			- 无记录，或
			- enum\_code='99'（未知）；
		- 不覆盖已有 0/1。
	- 补洞逻辑：
		- `has_wash_struct=1` → 补成 1（有洗车），INFERRED；
		- 没有结构信号则不动（保持 99 或无记录），把“默认无”的语义留给后续 QC/T 层（统一处理为 fallback 0）。
	- 属性：
		- `evidence_state='INFERRED'` ；
		- `conf=0.90` （结构标签信号强，无需行为加权）；
		- `reason` 前缀： `patched_by_algo_carwash_from_struct` 。
3. **为什么不在 S2 直接给“默认无”？**
- 原话“默认无”的语义我们尊重，但 **从工程上拆成两层** ：
	- S2：只做“有洗车的正向补洞”（结构强信号），确保 1 的可信度；
	- Step6/QC：统一在终表按 tag\_enum.is\_default 及配置判断“兜底无”的逻辑（给 0 但 QC 标记为 fallback），这样你在覆盖率统计里可以拆出“真实无洗车 vs 默认无洗车 vs 未知”。

这样既符合你“默认无”的直觉，又不在当前阶段把大量“没数据的站”直接打成 0 而失去可解释性。

#### 论据三：SQL & 校验设计

- SQL：新建两个 step：
	- `etl_tag_step4.4a.service_carwash_s1_from_dw`
	- `etl_tag_step4.4b.service_carwash_s2_from_struct`
- 校验：
	- 按你要求的“自然从 1 开始递增编号”，提供 5 条查询：
		1. 分布（enum\_code × evidence\_state）
		2. S2 补洞条数（INFERRED + reason 前缀）
		3. 自然覆盖率（FOUND\_IN\_RAW + 非兜底）
		4. 总覆盖率（FOUND\_IN\_RAW + INFERRED + 非兜底）
		5. 抽样观察补洞样本（看 additional\_services 是否真的包含 1）

---

### 3）service\_carwash\_available S1/S2 SQL + 校验（统一自然编号）

> 说明：
> 
> - 仍假设 Step0 已设置好 `@biz_dt_str` 、 `@biz_date` ；
> - 如要全量重算，可在 S1 之前先 DELETE 当天该 tag 的 snapshot 记录；
> - 一条查询一个编号，从 1 开始递增。

```sql
sql/*********************************************
 * Step4.4a：service_carwash S1 - 从 v_merchant_profile 承接
 *********************************************/

-- etl_tag_step4.4a.service_carwash_s1_from_dw
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
    t.store_id,
    @biz_date                            AS as_of_date,
    'service_carwash_available'          AS tag_code,

    CASE 
        WHEN t.enum_code_mapped IN ('1','0')
        THEN CAST(t.enum_code_mapped AS SIGNED)
        ELSE NULL
    END                                  AS target_value_bool,
    NULL                                 AS target_value_number,
    NULL                                 AS target_value_string,

    t.enum_code_mapped                   AS enum_code,
    'STORE'                              AS source_level,
    'FOUND_IN_RAW'                       AS evidence_state,
    ts.ttl_days                          AS ttl_days,
    1.0000                               AS conf,
    's1_from_v_merchant_profile'         AS reason,
    'service_carwash_available_v1'       AS algo_version,
    NULL                                 AS target_value_string_back
FROM (
    SELECT
        v.store_id,
        CASE
            WHEN v.service_carwash_available IN ('1','0','99')
                THEN v.service_carwash_available

            WHEN v.service_carwash_available = '是'   THEN '1'
            WHEN v.service_carwash_available = '否'   THEN '0'
            WHEN v.service_carwash_available = '未知' THEN '99'

            ELSE NULL
        END AS enum_code_mapped
    FROM v_merchant_profile_latest_di v
    WHERE v.dt = @biz_dt_str
) t
JOIN tag_spec ts
  ON ts.tag_code      = 'service_carwash_available'
 AND ts.spec_version  = '1.0.0'
WHERE t.enum_code_mapped IS NOT NULL;

/*********************************************
 * Step4.4b：service_carwash S2 - 结构补洞（只补 1，不做默认 0）
 *********************************************/

-- etl_tag_step4.4b.service_carwash_s2_from_struct
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
    @biz_date                                AS as_of_date,
    'service_carwash_available'             AS tag_code,
    1                                        AS target_value_bool,
    NULL                                     AS target_value_number,
    NULL                                     AS target_value_string,
    '1'                                      AS enum_code,
    'STORE'                                  AS source_level,
    'INFERRED'                               AS evidence_state,
    ts.ttl_days                              AS ttl_days,
    0.9000                                   AS conf,
    'patched_by_algo_carwash_from_struct'    AS reason,
    'service_carwash_available_v1'           AS algo_version,
    NULL                                     AS target_value_string_back
FROM (
    SELECT
        v.store_id,
        CASE
            WHEN FIND_IN_SET(
                     '1',
                     COALESCE(d.additional_services, '')
                 ) > 0
            THEN 1 ELSE 0
        END AS has_wash_struct
    FROM v_merchant_profile_latest_di v
    LEFT JOIN dim_gas_store_info_extend d
           ON d.store_id = v.store_id
          AND d.dt       = v.dt
    WHERE v.dt = @biz_dt_str
) s
LEFT JOIN store_tag_snapshot_di t
       ON t.store_id   = s.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'service_carwash_available'
JOIN tag_spec ts
  ON ts.tag_code      = 'service_carwash_available'
 AND ts.spec_version  = '1.0.0'
WHERE
    -- 仅对“有结构信号”的站点补洞
    s.has_wash_struct = 1
    AND
    -- 且当前为“无记录/未知”，不覆盖显式 0/1
    (t.store_id IS NULL OR t.enum_code = '99')

ON DUPLICATE KEY UPDATE
    target_value_bool         = VALUES(target_value_bool),
    target_value_number       = VALUES(target_value_number),
    target_value_string       = VALUES(target_value_string),
    enum_code                 = VALUES(enum_code),
    source_level              = VALUES(source_level),
    evidence_state            = VALUES(evidence_state),
    ttl_days                  = VALUES(ttl_days),
    conf                      = VALUES(conf),
    reason                    = CASE
                                    WHEN store_tag_snapshot_di.reason IS NULL
                                         OR store_tag_snapshot_di.reason = ''
                                    THEN VALUES(reason)
                                    ELSE CONCAT(store_tag_snapshot_di.reason, '|', VALUES(reason))
                                END,
    algo_version              = VALUES(algo_version),
    target_value_string_back  = store_tag_snapshot_di.target_value_string_back;

/*********************************************
 * 校验查询（自然编号 1..5）
 *********************************************/

-- [1] service_carwash 标签在 snapshot 中的 enum_code + evidence_state 分布
SELECT
  enum_code,
  evidence_state,
  COUNT(*) AS cnt
FROM store_tag_snapshot_di
WHERE as_of_date = @biz_date
  AND tag_code   = 'service_carwash_available'
GROUP BY enum_code, evidence_state
ORDER BY enum_code, evidence_state;

-- [2] S2 补洞条数：INFERRED + enum_code=1 + reason 前缀为 patched_by_algo_carwash_from_struct
SELECT
  COUNT(*) AS patched_cnt
FROM store_tag_snapshot_di
WHERE as_of_date      = @biz_date
  AND tag_code        = 'service_carwash_available'
  AND evidence_state  = 'INFERRED'
  AND enum_code       = '1'
  AND reason LIKE 'patched_by_algo_carwash_from_struct%';

-- [3] 自然覆盖率（FOUND_IN_RAW + 非兜底）
SELECT COUNT(DISTINCT s.store_id) AS natural_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'service_carwash_available'
  AND s.evidence_state  = 'FOUND_IN_RAW'
  AND e.is_default      = 0;

-- [4] 总覆盖率（FOUND_IN_RAW + INFERRED，非兜底）
SELECT COUNT(DISTINCT s.store_id) AS total_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date = @biz_date
  AND s.tag_code   = 'service_carwash_available'
  AND e.is_default = 0;

-- [5] 抽样看被 S2 补洞为 1 的站点，确认 additional_services 中确有 1
SELECT
  s.store_id,
  s.enum_code,
  s.evidence_state,
  s.conf,
  s.reason,
  d.additional_services
FROM store_tag_snapshot_di s
LEFT JOIN dim_gas_store_info_extend d
       ON d.store_id = s.store_id
      AND d.dt       = @biz_dt_str
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'service_carwash_available'
  AND s.evidence_state  = 'INFERRED'
  AND s.enum_code       = '1'
  AND s.reason LIKE 'patched_by_algo_carwash_from_struct%'
ORDER BY s.conf DESC
LIMIT 50;
```

---

### 4）迭代日志（来源 / 结论 / 改动点 / 下一步）

- **来源**
	- 你刚刚确认 restroom 的 S2 补洞结果符合预期，并希望继续按同一套路推进下一标签；
	- 再次强调“查询编号从 1 自然递增，单条 SQL 一个唯一编号”。
- **本轮结论**
	1. 完成 Step4.4 `service_carwash_available` 的 S1/S2 设计与 SQL：
		- S1：承接 v\_merchant\_profile；
		- S2：仅利用 `additional_services` 中的 `1=洗车` 做正向补洞。
	2. 明确把“默认无”的语义留给后续 QC/T 层统一处理，不在 S2 层强行把所有未知标成 0。
	3. 提供了 5 个统一编号的校验查询，方便你快速验证分布、补洞规模和样本合理性。
- **下一步建议**
	1. 你在 dev 库跑完 Step4.4a/b 后，依次执行 \[1\]–\[5\]，用文字反馈：
		- \[1\] enum\_code × evidence\_state 分布；
		- \[2\] patched\_cnt；
		- \[3\]/\[4\] 自然 vs 总覆盖率；
	2. 如果数据看起来“符合你对洗车站分布的直觉”（例如 INFERRED=1 的站基本都在 additional\_services 包含 1），我们就可以：
		- 把 `service_carwash_available` 小节也补进总控文档；
		- 下一轮进入 Step4.5 `service_carwash_type` ：依赖 `service_carwash_available` + DW 字段 + tag\_enum 中的 machine/manual/none 设计 S1/S2。

20251208\_1500\_标签兜底规范\_影响评估与ETL调整方案  
tags: #tag\_spec #tag\_enum #兜底值 #QC #服务标签ETL

---

### 1）一句话结论

这份“兜底值取值规范”对我们的影响不在“业务逻辑”，而在“实现细节”：以后不能再到处写死 `'99'` 当兜底，而是统一通过 `tag_enum.is_default=1` 和 `tag_spec.fallback` 来识别兜底；现有 S1/S2 逻辑可以保留，但需要在几个关键点改写条件和 QC 标记方式，然后再继续推进后续标签和 station\_tag\_target\_value 的迁移。

---

### 2）三段论据

#### 2.1 这份规范到底在说什么？——核心变化提炼

上游通知的关键点我帮你翻译成“对我们有约束力的规则”：

1. **兜底的“真·定义”在 tag\_spec**
	- tag\_spec.fallback 才是兜底语义的唯一来源；
	- tag\_enum 只管“有哪些枚举 + 哪个是默认”。
2. **给下游代码用的“当前有效兜底枚举值”**
	对于 **value\_type in ('enum','bool')** 的标签：
	- 兜底枚举值统一这样取：
	- 平台保证：
		- 每个 tag\_code 全局最多 1 条 `is_default=1 AND is_active=1` ；
		- 历史版本的默认值已经被置 `is_active=0` 。
	对于 **字符串型标签（string）** ：
	- 不玩枚举兜底，直接用 `tag_spec.fallback` 字段定义兜底文本。
3. **隐含效果**
	- 你以前脑子里的“99=未知/兜底” **不能再被写死在代码里** ；
	- “是不是兜底值”，要么看 `tag_enum.is_default` （enum/bool），要么看 `tag_spec.fallback` （string）；
	- 我们之前在 QC 和覆盖率里用 `e.is_default=0` 来代表“非兜底值”，这个逻辑反而是完全对齐新规范的。

所以：

- 方向上，你之前的“覆盖率只看非 default 值”是正确的；
- 需要改的是：所有显式写 `'99'` 当兜底的地方，都要改成“按 is\_default / fallback 识别”，尤其是：
	- S1/S2 的 **WHERE 条件** ；
	- 判断“是不是兜底”的 **QC 字段赋值** ；
	- 以及“未知”场景的 **赋值写法** 。

#### 2.2 对我们当前 ETL 的具体影响点

结合我们这几天做的东西，我把受影响的点列一下：

1. **S1 层显式把“未知”映射为 `'99'` 的地方**
	现在 convenience / parking / restroom / service\_carwash\_available 的 S1 都有类似逻辑：
	严格来说应该改成：
	- 在 S1 上游 mapping 逻辑里，不再写死 `'99'` ；
	- 而是 join 一下该标签的 **默认枚举** ：
	然后把 `'未知'` 映射为 `fallback_enum_code` 。
	实际上，你当前很多标签的默认枚举本来就是 `99` ，所以业务结果不会变，但是：
	- 代码层面不再绑死 99，将来某个标签换默认枚举（比如从 99 调成 'unknown'）也不用改 SQL。
2. **S2 层“只对兜底样本补洞”的条件**
	我们现在的 S2 逻辑普遍写成：
	按新规范，正确的写法应该是：
	- 引入当前标签的兜底枚举：
	- 然后条件写成：
	好处：
	- 只要默认枚举一变，我们不改 SQL，逻辑自然跟着走。
3. **QC & 覆盖率判断里“非兜底”筛选逻辑**
	这里反而是对的，而且是完全对齐新规范的：
	新规范就是把“兜底枚举 = is\_default=1 & is\_active=1”钉死写在平台逻辑里，所以：
	- “分子只数非兜底枚举”这套写法可以保持不动；
	- 甚至可以扩展成 QC 逻辑：
4. **字符串型标签（open\_hours 等）的兜底写法**
	新规范说得很清楚：
	- string 类型不再通过 tag\_enum 玩兜底版本管理；
	- 而是按 `tag_spec.fallback` 直接给兜底值。
	对我们来说意味着：
	- open\_hours 这类 string 标签在“无合法区间 → 未知兜底”时：
		- **不应该依赖枚举 is\_default，而是用 tag\_spec.fallback** （比如 `'UNKNOWN'` 或空串等）；
	- 若你仍保留 `'99'` 这种 enum\_code，仅作为“未知标记”的一种编码，也可以，但兜底语义应该同步写在 tag\_spec.fallback 里：
		- 比如： `tag_spec.fallback = '99'` 或 `'UNKNOWN'` ，由你来统一定义。
	整体而言，就是：
	- bool/enum 标签 → 看 tag\_enum 的 default；
	- string 标签 → 看 tag\_spec.fallback。

#### 2.3 我建议的调整策略——不改策略，只改“兜底识别方式”

我们这套 ETL 的核心策略是“拉高非兜底样本占比”，这一点和上游规范是同向的，不要动。  
调整只做在“如何知道它是不是兜底”上：

1. **短期（本周内，为了交付覆盖率双 90 的那条线）**
	- **不立刻重构所有脚本** ，先从“关键公共逻辑”下手：  
		1）在总控文档里明确写一句规范：
		- “本项目所有标签的兜底枚举值统一通过 `tag_enum.is_default=1 AND is_active=1` 获取；  
			所有字符串型标签的兜底值统一通过 `tag_spec.fallback` 获取；严禁直接写死 '99' 等 magic number。”  
			2）在接下来要写的 **终表迁移 + QC 逻辑（Step6）** 里， **严格按这个规范实现** ：
		- 如： `qc_is_fallback_value` = `e.is_default=1` 或 `target_value_string = tag_spec.fallback` ；
		- 覆盖率统计只看 `qc_value_has_meaning=1` 且 `qc_is_fallback_value=0` 的样本。  
			3）对于已经写好的 convenience / parking / restroom / carwash S2：
		- 保留现有 `'99'` 条件不动（业务一致）；
		- 但在代码注释里标注“后续会替换为基于 tag\_enum default 的判断”。
	换句话说： **本周目标是保证业务效果和行为一致，不为“改魔法数”牺牲交付节奏。**
2. **中期（等这条服务标签线跑顺 & station\_tag\_target\_value 上线后）**
	- 以“统一重构”方式，把以下代码统一替换：
		- S1 中 `'未知' → '99'` 改成 `'未知' → fallback_enum_code` ；
		- S2 中 `enum_code='99'` 改成 `enum_code=default_enum_code` ；
		- 覆盖率/报表中凡是按 `'99'` 判断兜底的地方全部统一成 `e.is_default` 。
	- 这个重构可以一次性做一张 checklist，按 tag\_code 跑脚本替换，不需要你今天手动改来改去。
3. **长期（作为“数据标准”的一部分固化）**
	- 在《标签ETL\_总控文档》中单独拉一个章节：
		- “兜底值与默认枚举使用规范”，把上游邮件 + 本地实践合并写清。
	- 在 tag\_algo\_config.extra\_config\_json 或独立表中， **不再记录任何具体兜底值，只记录兜底策略** （比如：
		- `"fallback_behavior": "COUNT_IN_DENOMINATOR_FALSE"` 之类），把具体枚举值都收敛到 tag\_spec / tag\_enum。

---

### 3）思维导图结构（文本分层）

1. 上游兜底规范要点  
	1.1 兜底语义归属 tag\_spec.fallback  
	1.2 有枚举的标签通过 tag\_enum.is\_default=1 & is\_active=1 获取默认枚举  
	1.3 string 标签不玩枚举兜底，只看 fallback 文本
2. 对我们现有 ETL 的影响点  
	2.1 S1 中“未知→'99'”的硬编码  
	2.2 S2 中“enum\_code='99'”作为兜底判断条件  
	2.3 QC & 覆盖率判断中“非兜底 = e.is\_default=0”的逻辑（目前是正确的）  
	2.4 string 标签（如 open\_hours）的兜底取值方式
3. 调整策略  
	3.1 短期：不改策略，只在 Step6（终表+QC）上严格对齐兜底规范  
	3.2 中期：统一 refactor 去除 `'99'` magic number，改用 tag\_enum default / tag\_spec.fallback  
	3.3 长期：把这套规范写入总控文档 + 标准化配置
4. 对接后续工作  
	4.1 服务标签 4.1–4.4 的 S1/S2 逻辑不变，只在后续迭代中替换兜底判断实现  
	4.2 下一步继续做 4.5 `service_carwash_type` 的 S1/S2，并直接用“新兜底规范”来写 QC 逻辑  
	4.3 然后进入 Step6：station\_tag\_target\_value 的迁移 + QC 字段填充 + 覆盖率统计视图

---

### 4）迭代日志

- **来源**
	- 你转发了“兜底值取值规范更新说明”，问：
		- 对我们现有 ETL 有什么影响？
		- 需要怎么调整？
		- 同时我们还要继续推进服务标签链路。
- **本轮结论**
	1. 业务逻辑不需要改——我们“提升非兜底覆盖率”的方向和这份规范是一致的；
	2. 实现细节必须规整——不能再到处写死 `'99'` 当兜底，而要统一通过 `tag_enum.is_default` 和 `tag_spec.fallback` 识别兜底枚举 / 文本；
	3. 短期以“保证交付为主”：先在 Step6（终表+QC）严格执行新规范，历史 S1/S2 脚本只加注释；中期再统一 refactor，替换 magic number。
- **下一步建议**
	你刚刚已经确认：
	- restroom 的数据“依赖便利店标签”的行为符合预期；
	- carwash\_available 的 S1 先跑完，S2 结构补洞可以先观察一轮结果。
	在这个兜底规范的前提下，我建议 **下一轮我们做两件事：**
	1. **继续推进 Step4.5： `service_carwash_type` 的 S1/S2 方案 + SQL + 校验**
		- 这里恰好可以用“新兜底规范”来设计：
			- `none` 是一个正常枚举值，不一定是兜底；
			- 真正兜底要看 tag\_enum.is\_default=1 的那条；
			- 只在 `service_carwash_available=1` 时才为 type 填值。
	2. **在 `station_tag_target_value` 的设计草稿里，把 QC 字段与兜底规则明确写一版**
		- 比如： `qc_is_fallback_value` 的定义就按新规范写死；
		- 这样后面改“魔法数”时，只需要调整 snapshot→station 的那一层。

如果你同意这个节奏，我下一条就直接给：

- `service_carwash_type` 的 S1/S2 设计、SQL（含新兜底规范）、以及一组从 1 开始编号的校验查询。

OK 啊,你要注意和记忆新的兜底规范,防止我们取到了旧版本的兜底了;能符合预期就行,继续推进把

20251208\_1615\_服务标签ETL\_service\_carwash\_type\_S1S2落地（对齐新兜底规范）  
tags: #服务标签 #service\_carwash\_type #兜底规范 #标签ETL #依赖标签

---

### 1）一句话结论

在完全记住“兜底值只能通过 tag\_enum.is\_default / tag\_spec.fallback 获取”的前提下，本轮我们落地 `service_carwash_type` 的 S1/S2：  
S1 从 v\_merchant\_profile 直接承接类型枚举；  
S2 只在 `service_carwash_available=1` 且类型为空/兜底时，补一个默认类型 `machine` ，严格依赖 tag\_enum 查枚举，不写死 `'99'` ，并附上统一编号的校验 SQL。

---

### 2）三段论据（现状与问题 → 策略 → 落地与风险）

#### 2.1 现状与问题：类型强依赖“是否有洗车”，且兜底规范已更新

我们目前的格局：

- `service_carwash_available` ：
	- 你刚跑完 S1，数据是全 FOUND\_IN\_RAW；
	- S2 结构补洞（additional\_services 中含 1）目前补洞数为 0，说明当前 DW 已经给了比较完整的有/无标记。
- `service_carwash_type` ：
	- 语义上 **严格依赖** `service_carwash_available` ：
		- 有洗车才应该有类型；
		- 没有洗车时，大多数场景类型可以视为“无/未配置”；
	- 字典中有 `machine / manual / none` 等枚举；
	- “none” 是合法业务值（无洗车）， **不是兜底** ；真正的兜底由 `is_default=1 & is_active=1` 决定。

同时，上游已经明确：

- 兜底语义只在 `tag_spec.fallback` 定义；
- 对 enum/bool 类型，代码只能用：
	来拿“当前版本的兜底枚举”，不能再写死 `'99'` 。

所以： `service_carwash_type` 必须：

- 不自己发明兜底值；
- 不把 `none` 当兜底；
- 只在“有洗车 & 类型缺失/兜底”时补一个默认类型。

#### 2.2 策略：S1 承接 + S2 只在“有洗车且类型缺失”时补 machine

我们按标签依赖关系把逻辑拆两层：

1. **S1：DW / 区域结果直通**
	- 来源： `v_merchant_profile_latest_di.service_carwash_type` ；
	- 映射方式：
		- 不写死任何枚举 code，统一通过 `tag_enum` 匹配：
			- v 字段等于 enum\_code 或 enum\_label；
		- 只接收“能匹配到枚举”的值；
		- 结果写入 `store_tag_snapshot_di` ：
			- `target_value_string = enum_code`
			- `enum_code = enum_code`
			- `target_value_bool/number = NULL`
			- `evidence_state='FOUND_IN_RAW'`
			- `algo_version='service_carwash_type_v1'` 。
2. **S2：基于 `service_carwash_available` 的派生补洞（只补 machine，不动 none/其它）**
	- 依赖：
		- `store_tag_snapshot_di` 中 `service_carwash_available` 的最终值（tag\_code='service\_carwash\_available'）；
		- `tag_enum` 中：
			- 当前类型标签的默认枚举 def\_type（is\_default=1,is\_active=1），如果存在；
			- `machine` 对应的枚举记录（enum\_code='machine' 或 enum\_label='机洗'）。
	- 补洞条件：
		- 当前业务日： `as_of_date=@biz_date` ；
		- `service_carwash_available.enum_code='1'` （确认为“有洗车”）；
		- 类型标签上：
			- 没有记录（t\_type.store\_id IS NULL），或
			- 记录存在但为“兜底枚举”（t\_type.enum\_code = def\_type.enum\_code），或
			- 记录存在但 enum\_code 为空（异常兜底形态）；
	- 补洞结果：
		- 统一补为 `machine` 对应的 enum\_code（从 tag\_enum 查，不写死）；
		- 记为 `INFERRED` ；
		- `conf` 设为 0.7 左右；
		- `reason='patched_by_algo_carwash_type_default_machine'` 。
3. **不做的事（刻意不做）**
	- 不在 S2 自动给 `service_carwash_available=0` 的站填 `type=none` ：
		- 遵守你早期的语义：“有洗车才有类型”；
		- 把“无洗车站点类型如何展示”这个问题留给上游 DW 或后续派生规则，不在这轮强拍板。
	- 不在 S2 中判断“兜底枚举的具体 code”，而是统一依赖 `tag_enum.is_default` 。

#### 2.3 落地与风险：如何避免“错用旧兜底 & 错改手工值”

1. **避免错用旧兜底**
	- 所有 S2 补洞条件使用：
		- `t_type.store_id IS NULL`
		- 或 `t_type.enum_code = def_type.enum_code` （通过 tag\_enum 拿 default\_enum，而非写 `'99'` ）。
	- 只在“类型缺失/兜底”场景才补。
2. **避免覆盖手工/上游显式类型**
	- 只要 S1 已经给了 `machine/manual/none` 这类非兜底值（is\_default=0），S2 条件不会命中该记录。
	- 这样可以保证：
		- “DW 写的是人工洗 / 无洗车”不会被这层默认机洗逻辑覆盖。
3. **对兜底规范的适配路径**
	- 本轮在 `service_carwash_type` 上就完全执行新规范：不写 `'99'` ，所有 fallback 只看 tag\_enum.default；
	- 其它标签（convenience/parking/restroom/carwash\_available）的 S1/S2 逻辑短期不重构，只在 Step6（station\_tag\_target\_value + QC）统一用新规范；
	- 后续再做一次“整体去魔法数”的重构，把所有 `'99'` 条件都换成 default\_enum\_code 判断。

---

### 3）SQL 实现 & 校验（编号从 1 自然递增）

> 前提：
> 
> - Step0 已经算好 `@biz_dt_str` 、 `@biz_date` ；
> - 如果你想全量重算 type，可以先 DELETE 当日 `service_carwash_type` 的记录；
> - 下面所有查询都按 `[1] [2] [3] ...` 自然递增编号。

```sql
sql/*********************************************
 * Step4.5a：service_carwash_type S1 - 从 v_merchant_profile 承接
 *********************************************/

-- etl_tag_step4.5a.service_carwash_type_s1_from_dw
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
    m.store_id,
    @biz_date                             AS as_of_date,
    'service_carwash_type'               AS tag_code,
    NULL                                  AS target_value_bool,
    NULL                                  AS target_value_number,
    m.mapped_enum_code                    AS target_value_string,
    m.mapped_enum_code                    AS enum_code,
    'STORE'                               AS source_level,
    'FOUND_IN_RAW'                        AS evidence_state,
    ts.ttl_days                           AS ttl_days,
    1.0000                                AS conf,
    's1_from_v_merchant_profile'          AS reason,
    'service_carwash_type_v1'             AS algo_version,
    NULL                                  AS target_value_string_back
FROM (
    SELECT
        v.store_id,
        -- 通过 tag_enum 映射 code/label，不写死枚举值
        e.enum_code AS mapped_enum_code
    FROM v_merchant_profile_latest_di v
    LEFT JOIN tag_enum e
           ON e.tag_code     = 'service_carwash_type'
          AND e.spec_version = '1.0.0'
          AND e.is_active    = 1
          AND (
                v.service_carwash_type = e.enum_code
             OR v.service_carwash_type = e.enum_label
          )
    WHERE v.dt = @biz_dt_str
) m
JOIN tag_spec ts
  ON ts.tag_code      = 'service_carwash_type'
 AND ts.spec_version  = '1.0.0'
WHERE m.mapped_enum_code IS NOT NULL;

/*********************************************
 * Step4.5b：service_carwash_type S2 - 有洗车但类型缺失/兜底 → 默认机洗
 *********************************************/

-- etl_tag_step4.5b.service_carwash_type_s2_default_machine
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
    a.store_id,
    @biz_date                                         AS as_of_date,
    'service_carwash_type'                           AS tag_code,
    NULL                                              AS target_value_bool,
    NULL                                              AS target_value_number,
    e_machine.enum_code                               AS target_value_string,
    e_machine.enum_code                               AS enum_code,
    'STORE'                                           AS source_level,
    'INFERRED'                                        AS evidence_state,
    ts.ttl_days                                       AS ttl_days,
    0.7000                                            AS conf,
    'patched_by_algo_carwash_type_default_machine'    AS reason,
    'service_carwash_type_v1'                         AS algo_version,
    NULL                                              AS target_value_string_back
FROM store_tag_snapshot_di a
LEFT JOIN store_tag_snapshot_di t_type
       ON t_type.store_id   = a.store_id
      AND t_type.as_of_date = a.as_of_date
      AND t_type.tag_code   = 'service_carwash_type'
LEFT JOIN tag_enum def_type
       ON def_type.tag_code   = 'service_carwash_type'
      AND def_type.is_default = 1
      AND def_type.is_active  = 1
JOIN tag_enum e_machine
   ON e_machine.tag_code      = 'service_carwash_type'
  AND e_machine.spec_version  = '1.0.0'
  AND e_machine.is_active     = 1
  AND e_machine.enum_code     = 'machine'   -- 这里用业务 code，来自字典，不是兜底
JOIN tag_spec ts
  ON ts.tag_code      = 'service_carwash_type'
 AND ts.spec_version  = '1.0.0'
WHERE a.as_of_date = @biz_date
  AND a.tag_code   = 'service_carwash_available'
  AND a.enum_code  = '1'                       -- 仅当“确认为有洗车”
  AND (
        -- 类型标签无记录
        t_type.store_id IS NULL
        OR
        -- 或类型为兜底枚举（通过 is_default 获取，而不是写死 '99'）
        (def_type.enum_code IS NOT NULL AND t_type.enum_code = def_type.enum_code)
        OR
        -- 或类型枚举为空（异常兜底形态）
        t_type.enum_code IS NULL
      )

ON DUPLICATE KEY UPDATE
    target_value_bool         = VALUES(target_value_bool),
    target_value_number       = VALUES(target_value_number),
    target_value_string       = VALUES(target_value_string),
    enum_code                 = VALUES(enum_code),
    source_level              = VALUES(source_level),
    evidence_state            = VALUES(evidence_state),
    ttl_days                  = VALUES(ttl_days),
    conf                      = VALUES(conf),
    reason                    = CASE
                                    WHEN store_tag_snapshot_di.reason IS NULL
                                         OR store_tag_snapshot_di.reason = ''
                                    THEN VALUES(reason)
                                    ELSE CONCAT(store_tag_snapshot_di.reason, '|', VALUES(reason))
                                END,
    algo_version              = VALUES(algo_version),
    target_value_string_back  = store_tag_snapshot_di.target_value_string_back;

/*********************************************
 * 校验查询（自然编号 1..5）
 *********************************************/

-- [1] service_carwash_type 在 snapshot 中的 enum_code + evidence_state 分布
SELECT
  enum_code,
  evidence_state,
  COUNT(*) AS cnt
FROM store_tag_snapshot_di
WHERE as_of_date = @biz_date
  AND tag_code   = 'service_carwash_type'
GROUP BY enum_code, evidence_state
ORDER BY enum_code, evidence_state;

-- [2] S2 补洞条数：INFERRED + reason 前缀为 patched_by_algo_carwash_type_default_machine
SELECT
  COUNT(*) AS patched_cnt
FROM store_tag_snapshot_di
WHERE as_of_date      = @biz_date
  AND tag_code        = 'service_carwash_type'
  AND evidence_state  = 'INFERRED'
  AND reason LIKE 'patched_by_algo_carwash_type_default_machine%';

-- [3] 自然覆盖率（FOUND_IN_RAW + 非兜底）
SELECT COUNT(DISTINCT s.store_id) AS natural_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'service_carwash_type'
  AND s.evidence_state  = 'FOUND_IN_RAW'
  AND e.is_default      = 0;

-- [4] 总覆盖率（FOUND_IN_RAW + INFERRED，非兜底）
SELECT COUNT(DISTINCT s.store_id) AS total_cov_store_cnt
FROM store_tag_snapshot_di s
JOIN tag_enum e
  ON e.tag_code     = s.tag_code
 AND e.enum_code    = s.enum_code
 AND e.spec_version = '1.0.0'
WHERE s.as_of_date = @biz_date
  AND s.tag_code   = 'service_carwash_type'
  AND e.is_default = 0;

-- [5] 抽样看被 S2 补为 machine 的站点，确认均为“有洗车且原类型缺失/兜底”
SELECT
  s.store_id,
  s.enum_code,
  s.evidence_state,
  s.conf,
  s.reason,
  a.enum_code AS carwash_available_enum,
  t_type.enum_code AS old_type_enum
FROM store_tag_snapshot_di s
JOIN store_tag_snapshot_di a
  ON a.store_id   = s.store_id
 AND a.as_of_date = s.as_of_date
 AND a.tag_code   = 'service_carwash_available'
LEFT JOIN (
    SELECT
        store_id,
        as_of_date,
        enum_code
    FROM store_tag_snapshot_di
    WHERE as_of_date = @biz_date
      AND tag_code   = 'service_carwash_type'
) t_type
       ON t_type.store_id   = s.store_id
      AND t_type.as_of_date = s.as_of_date
WHERE s.as_of_date      = @biz_date
  AND s.tag_code        = 'service_carwash_type'
  AND s.evidence_state  = 'INFERRED'
  AND s.reason LIKE 'patched_by_algo_carwash_type_default_machine%'
ORDER BY s.conf DESC
LIMIT 50;
```

---

### 4）思维导图结构（文本分层）

1. 标签定位  
	1.1 `service_carwash_type` ：洗车类型，C 类，强依赖有/无洗车标签  
	1.2 仅在 `service_carwash_available=1` 时需要有值
2. 兜底规范适配  
	2.1 不写死 `'99'` ，兜底通过 `tag_enum.is_default=1 & is_active=1` 获取  
	2.2 `none` 是合法业务值（无洗车），不是兜底  
	2.3 QC/覆盖率依旧用 `e.is_default=0` 识别“非兜底值”
3. 算法路径  
	3.1 S1：DW/区域类型 → 通过 tag\_enum 映射 code/label  
	3.2 S2： `service_carwash_available=1` 且类型缺失/兜底 → 默认补 machine  
	3.3 不处理 `service_carwash_available=0` 的类型填充
4. 执行与校验  
	4.1 Step4.5a/b SQL 融入现有 ETL 框架  
	4.2 \[1\]–\[5\] 统一编号校验分布、补洞条数、自然/总覆盖率、样本合理性  
	4.3 结果稳定后，将本小节写入总控文档 + tag\_algo\_config

---

### 5）迭代日志（来源 / 结论 / 改动点 / 下一步）

- **来源**
	- 你确认 carwash\_available 的结果 OK，要求继续推进 type；
	- 同时强调“必须记住新兜底规范，防止我们取到了旧版本兜底”。
- **本轮结论**
	1. 为 `service_carwash_type` 设计并实现了 S1/S2：完全依赖 tag\_enum 映射和 is\_default 标记，不再写死 `'99'` ；
	2. S2 只在“有洗车 & 类型缺失/兜底”场景补默认 machine，不覆盖 DW 显式类型，也不对无洗车站点强行填 type；
	3. 给出 5 条统一编号的校验 SQL，保证你可以快速验证结果与直觉是否一致。
- **下一步建议**
	1. 在 dev 库依次跑完 Step4.5a / Step4.5b；
	2. 再跑 \[1\]–\[5\]，用“编号 + 结果摘要”的方式反馈给我，比如：
		- `[1] 枚举分布：machine/manual/none × FOUND_IN_RAW/INFERRED 各多少`
		- `[2] patched_cnt = ?`
		- `[3]/[4] 覆盖率（自然 vs 总）` ；
	3. 如果数据和你的业务直觉一致，我们就可以：
		- 在总控文档里补上“洗车类型标签节”；
		- 然后整体收口：开始设计 Step6（snapshot → station\_tag\_target\_value 的统一迁移 + QC 字段填充 + 覆盖率统计），把这条服务标签链路真正闭环到终表。

20251208\_1710\_服务标签ETL\_carwash\_type结果解读与下一步策略

tags: #service\_carwash\_type #覆盖率 #适用范围 #兜底规范 #下一步规划

---

### 1）一句话结论

当前 `service_carwash_type` 的结果基本符合我们之前定的“ **只对有洗车站填类型** ”+“ **不写兜底** ”策略：

- 现在只有 machine/manual 两类有效值，总计 4127 条记录，覆盖的是“ **有洗车且类型有信号/可默认补 machine** ”的那部分站；
- 你没看到兜底，是因为我们刻意没有为“无洗车/无信号”的站写类型记录，这些站仍在“适用范围之外”，后面会在 Step6 用 `service_carwash_available` 做分母限定。

---

### 2）三段论据（现状 → 解释 → 建议）

#### 2.1 先把你给的数字拆开看清楚

你反馈的是：

1. `[1] enum_code × evidence_state 分布`
1. `[2] patched_cnt`
1. \`\[3\]/\[4\] 覆盖率（你简写为 3130 vs 4127）
- 自然覆盖数（FOUND\_IN\_RAW + 非兜底） ≈ 3130
	- 2500（machine / FOUND\_IN\_RAW）
	- 630（manual / FOUND\_IN\_RAW）
- 总覆盖数（FOUND\_IN\_RAW + INFERRED + 非兜底） = 4127
	- 3130 自然
	- - 997 补洞 machine

这几件事可以确定：

- 当前 snapshot 中， **只有 3 种组合** ：
	- machine / FOUND\_IN\_RAW = 2500
	- machine / INFERRED = 997
	- manual / FOUND\_IN\_RAW = 630
- 没有 `none` ，也没有“什么 default/兜底 enum\_code”的记录；
- 自然覆盖率是 `3130 / (适用样本数)` ，总覆盖率是 `4127 / (适用样本数)` 。

你感觉“总站点应该有 1.6 万”，但这里只看到 4127 条记录，这个其实是 **设计使然** ：

> 对 `service_carwash_type` ，我们只在“ **有洗车的站** ”上才考虑类型，其他站不写记录。

#### 2.2 为什么没有兜底值？为什么只有 4127 条记录？

这里要分两层说：

1） **这个标签的“适用范围”不是全量 1.6 万，而是“有洗车的站”**

- 之前我们就定过：
	- `service_carwash_type` 只在 `service_carwash_available=1` 时才有意义；
	- 没洗车（available=0）就算有枚举 `none` ，也只是“业务编码上的无”而不是我们要追的 double-90 覆盖对象。
- 所以：
	- 1.6 万是“全站总数”；
	- 4127 是“当前有洗车并且已经有类型（自然 or 补洞 machine）的站点数”。
- “其他站”——包括无洗车、洗车标记不清楚、类型完全没信号的——在我们当前的策略下是 **不写 `service_carwash_type` 记录的** 。

2）\*\*为什么没有兜底 enum？

- 对这个标签，我们刻意做了几件事：
	1. S1 从 `v_merchant_profile_latest_di` 只接收能映射到 tag\_enum 的合法类型（machine/manual/none 等），没信号就不写；
	2. S2 只在“ `service_carwash_available=1` 且 类型缺失/兜底”时补 machine：
		- 这里兜底是通过 `tag_enum.is_default=1 & is_active=1` 判断的；
		- 我们没再手动塞一条“fallback enum 记录”。
- 再结合你之前给的 tag\_enum 片段可以推断：
	- 目前 `service_carwash_type` 的枚举里 machine/manual/none 都是 `is_default=0` （你之前那段就是 3 行 is\_default=0）；
	- 在新兜底规范下，如果没给这个标签设置 default 枚举， **就不存在我们所谓的“兜底 enum 行”** ，自然也不会出现在统计里。

所以综合起来：

- 没看到兜底值，是因为：
	- 我们没写兜底行（本就不想在 type 上强行写 fallback）；
	- 而且按你目前的 tag\_enum 配置，这个标签暂时 **也没有 default enum 被标出来** 。
- 只有 4127 条记录，是因为：
	- 这个标签的 **业务适用范围就不是 1.6 万** ，而是“有洗车的那批站”；
	- 在这批站里，有 3130 条是上游自然给的 machine/manual，997 条是我们 S2 默认补 machine。

从你给的数据来看， **逻辑上是自洽的** 。

#### 2.3 这对“double-90”意味着什么？接下来怎么用这些数？

关键点在于：

> 对 `service_carwash_type` ，覆盖率的分母应该是“carwash\_available=1 的站点数”，不是全部 1.6 万。

所以下一步我们要做的是：

1） **明确这个标签的 coverage 定义**

例如：

- 分母：
	- `N_den = count(distinct store_id where service_carwash_available = 1)`
- 分子（自然）：
	- `N_num_natural = count(distinct store_id where service_carwash_available=1 AND service_carwash_type 在 {machine,manual} 且 evidence_state='FOUND_IN_RAW')`
- 分子（总）：
	- `N_num_total = count(distinct store_id where service_carwash_available=1 AND service_carwash_type 在 {machine,manual} 且 evidence_state in ('FOUND_IN_RAW','INFERRED'))`

在 Step6（迁移到 `station_tag_target_value` + QC）里，我们会把这种“ **适用范围限定 + 非兜底过滤** ”写死成一个统一模板，算每个标签的 coverage。

2） **当前这 4127 条记录，从质量角度看 OK 吗？**

- FOUND\_IN\_RAW：
	- 2500 machine + 630 manual = 3130，自然信号；
- INFERRED：
	- 997 machine 是我们基于“有洗车但类型缺失/兜底”的默认补；
- 这里真正需要再查的是：
	- “carwash\_available=1 总共有多少站？”
	- 如果它接近 4127，那类型已经相当完整；
	- 如果明显大于 4127，那还有一批“有洗车但 type 完全无信号”的站，目前我们是保守不填的。

我建议你跑一组非常短的诊断 SQL，都是从 1 开始编号：

```sql
sql-- [1] 总站点数（全局）
SELECT COUNT(DISTINCT store_id) AS total_store_cnt
FROM v_merchant_profile_latest_di
WHERE dt = @biz_dt_str;

-- [2] 有洗车的站点数（以最终 snapshot 为准）
SELECT COUNT(DISTINCT store_id) AS carwash_available_store_cnt
FROM store_tag_snapshot_di
WHERE as_of_date = @biz_date
  AND tag_code   = 'service_carwash_available'
  AND enum_code  = '1';

-- [3] 在“有洗车站”中，已经有类型记录的站点数
SELECT COUNT(DISTINCT a.store_id) AS carwash_type_store_cnt
FROM store_tag_snapshot_di a
JOIN store_tag_snapshot_di t
  ON t.store_id   = a.store_id
 AND t.as_of_date = a.as_of_date
 AND t.tag_code   = 'service_carwash_type'
JOIN tag_enum e
  ON e.tag_code     = t.tag_code
 AND e.enum_code    = t.enum_code
 AND e.spec_version = '1.0.0'
WHERE a.as_of_date = @biz_date
  AND a.tag_code   = 'service_carwash_available'
  AND a.enum_code  = '1'
  AND e.is_default = 0;  -- 非兜底枚举

-- [4] 抽样：有洗车但完全没有类型记录的站（如果存在）
SELECT
  a.store_id
FROM store_tag_snapshot_di a
LEFT JOIN store_tag_snapshot_di t
       ON t.store_id   = a.store_id
      AND t.as_of_date = a.as_of_date
      AND t.tag_code   = 'service_carwash_type'
WHERE a.as_of_date = @biz_date
  AND a.tag_code   = 'service_carwash_available'
  AND a.enum_code  = '1'
  AND t.store_id IS NULL
LIMIT 50;
```
- 如果 \[2\] ≈ 4127 且 \[3\] ≈ 4127，说明：
	- 几乎所有“有洗车站”都已经有类型，INFERRED 那 997 条就是我们补出来的增量；
	- `service_carwash_type` 这一条在“适用范围”内已经接近 100% 覆盖，可以视为 double-90 中的“容易项”。
- 如果 \[2\] 明显大于 4127，而 \[4\] 有不少站：
	- 说明还有“有洗车但完全没类型”的站，这部分要不要再 aggressive 一点（例如再用行为/区域信息默认补 machine），就要看你后面对“准确率 vs 覆盖率”的权衡了。

---

### 3）思维导图结构（文本分层）

1. 结果现状  
	1.1 machine/FOUND\_IN\_RAW = 2500  
	1.2 manual/FOUND\_IN\_RAW = 630  
	1.3 machine/INFERRED = 997  
	1.4 总记录数 4127，对应“有洗车且类型有信号/可补”的站
2. 没有兜底值的原因  
	2.1 设计上 `service_carwash_type` 只在 `service_carwash_available=1` 时才写记录  
	2.2 当前 tag\_enum 未配置 default（兜底 enum），我们也没有主动写 fallback 行  
	2.3 无洗车 / 无类型信号的站我们故意留空，不写 type
3. 对 double-90 的意义  
	3.1 覆盖率分母是“有洗车站数”，不是全量 1.6 万  
	3.2 自然覆盖 ≈ 3130，补洞覆盖 +997  
	3.3 还需核实“carwash\_available=1 总有多少站”来判断是否还有补洞空间
4. 下一步动作  
	4.1 跑 \[1\]–\[4\] 四条诊断，确认“有洗车站”的总体规模  
	4.2 若 4127 已接近分母，type 基本 OK，可转入 Step6 设计  
	4.3 若仍有大量“有洗车无类型”的站，再评估是否提高 S2 激进程度或引入更复杂规则

---

### 4）迭代日志

- **来源** ：
	- 你给出了 `service_carwash_type` 的分布、patched\_cnt 和自然/总覆盖（3130 vs 4127），并敏锐地问：“为什么没看到兜底？总站 1.6 万，其他值呢？”
- **本轮结论** ：
	1. 这些结果在我们“只对有洗车站填类型+不写 fallback enum”的策略下是合理的；
	2. 4127 条并不是“覆盖率太低”，而是“适用范围本来就不是 1.6 万，而是 carwash\_available=1 的那一撮”；
	3. 现在真正需要确认的是：carwash\_available=1 的站点到底有多少，我们目前 4127 条是已经接近全部，还是还有一截没补上。
- **下一步建议** ：
	- 你先跑我给的 \[1\]–\[4\] 四条诊断，把“有洗车站的总数”和“有洗车但无类型记录的样本情况”告诉我；
	- 若 4127 ≈ carwash\_available=1，则我们可以认为 carwash\_type 已经完成，只需在总控文档中按“适用范围=有洗车站”写清楚；
	- 然后我们可以正式从 Step4 服务标签收口，进入 Step6：设计 `station_tag_target_value` 的迁移逻辑 + QC 字段填充 + 覆盖率统计模板，把这条服务标签线和 open\_hours 一起挂上终表。

对的,符合预期,那就带来一个问题,整体的覆盖率应该是如何计算的.这个问题.比如我要计算整体的全部标签的覆盖率;我们整体的进度到哪里了,现在回复我,你丢了之前的进度反馈哦.要补全;我需要知道进度,以及覆盖率这个问题我们应该如何去回答他;我下一步应该做什么?

20251208\_2105\_标签ETL进度总览与覆盖率统一口径方案

tags: #标签覆盖率 #双90 #服务标签 #终表设计 #QC口径

---

### 1）一句话结论

当前服务标签（营业时间 + 5 个服务标签）的「算法链路」已经基本跑通，下一步要集中精力做一件事：在 `station_tag_target_value` 层设计统一的「适用范围 + 覆盖率 + 兜底识别 + QC 口径」，把“覆盖率怎么算”这件事一次性说清楚、固化成 SQL 模板和报表口径。

---

### 2）三段论据

#### 论据一：整体进度复盘——我们到底做到哪一步了？

按你这几天所有工作 + 我们刚才的 SQL，帮你把进度梳理成工程视角（你可以直接贴回总控文档，稍微改下措辞即可）：

1. **上游 +特征层**
- `v_merchant_profile_latest_di`
	- 已作为 **唯一上游入口** 统一使用，包含：store\_id / merchant\_id / party\_key / is\_zxgj(06-22) / order\_cnt\_30d / is\_agg\_blocked\_merchant / 区域上报服务标签等。
- 三层特征快照（Step1，已具备基础能力）：
	- store\_feature\_snapshot\_di（门店级）
	- merchant\_feature\_snapshot\_di（商户级）
	- party\_feature\_snapshot\_di（工商级）
	- 目前主要服务：open\_hours / open\_24h / convenience（用 order\_cnt\_30d 等行为特征）。
1. **营业时间家族（open\_24h / open\_hours）**
- A/B 两条链路均已完成并验证：
	- A： `open_24h` 正规化重建（bool + enum\_code + 三选一协议 + 与 24 小时订单特征对齐）；
	- B： `open_hours` 规范化区间（HH:MM-HH:MM），与 `open_24h` 强一致（24 小时站统一 00:00-24:00），保留 `target_value_string_back` 。
- 两个标签当前状态：
	- 已在中间层（snapshot 或等价表）按“三选一 + enum 规范”完成清洗；
	- 尚未统一迁移到 `station_tag_target_value` ，但迁移规则已基本清晰（你前面给的规范）。
1. **服务标签家族（Step4，已完成 S1/S2）**

按 tag\_code 一一列：

- `convenience_store_available`
	- S1：从 v\_merchant\_profile 承接门店/区域结果；
	- S2：使用行为特征（30 日订单等），已有历史 INFERRED（覆盖率已从自然 24% 拉到约 40%），新算法已定义但暂未产生增量。
- `parking_available`
	- S1：承接 DW 结果；
	- S2：默认真补洞（仅对无记录/兜底样本补 1，不覆盖显式 0）；
	- 当前结果：自然覆盖 ~24%，总覆盖已达到 100%，说明历史链路 + 新骨架共同作用。
- `restroom_available`
	- S1：承接 DW 结果；
	- S2：结构 + 便利店派生补洞：
		- `additional_services` 中包含 0（卫生间）；
		- 或 convenience=1；
	- 覆盖率：你刚测的数据看起来合理（自然 + INFERRED 都有）。
- `service_carwash_available`
	- S1：你当前数据是全 FOUND\_IN\_RAW（DW 已给完整）
	- S2：结构补洞（ `additional_services` 含 1）逻辑已经写好，目前补洞条数为 0（符合“上游已给全”的预期）。
- `service_carwash_type`
	- S1：严格通过 tag\_enum 映射（code/label），不写死枚举常量；
	- S2：仅在 `service_carwash_available=1` 且 类型缺失/兜底 时补默认 machine：
		- 3130 条自然值（machine/manual）
		- 997 条 INFERRED machine
		- 总计 4127 条类型值，仅覆盖「有洗车站」这一个适用范围。
1. **config & QC 侧**
- `tag_algo_config` 已初版落表，并为 open\_hours + 服务标签写了一版 demo 行；
- `station_tag_target_value` 表结构已明确，QC 字段含义统一：
	- qc\_value\_has\_meaning
	- qc\_is\_wrong\_cleaning
	- qc\_is\_same\_as\_source
	- qc\_is\_fallback\_value
	- qc\_is\_meaningless\_non\_fallback
- 新的兜底规范也已经对齐：
	- enum/bool 标签兜底枚举通过 tag\_enum.is\_default=1 & is\_active=1 获取；
	- string 标签兜底通过 tag\_spec.fallback；
	- 禁止再写死 `'99'` 表示兜底。

**总结一下进度：**

> 上游入口 + 特征快照 + 营业时间 + 服务标签全家桶的 S1/S2 算法已经跑通；  
> 现在最大的空档是在： **终表迁移、QC 赋值、覆盖率口径统一** 。

#### 论据二：覆盖率「到底怎么算」——要统一成一套可复用口径

你问的是难题里最关键的那个：

> 「整体的全部标签覆盖率，该如何计算？」

我们得把这个问题拆成 3 层：单标签、标签族、整体项目。

1. **单标签覆盖率（Cell Coverage for One Tag）**

每个 tag\_code 要先回答四个问题：

- Q1： **适用范围（denominator scope）是谁？**
	- open\_hours / open\_24h：全量 1.6 万油站；
	- service\_carwash\_available：全量 1.6 万油站（有/无皆有意义）；
	- service\_carwash\_type：仅 `service_carwash_available=1` 的那部分站；
	- future 例：brand\_level 可能只对「已识别品牌站」有意义。
- Q2： **什么样的值算“有意义”？**
	- 非兜底枚举（tag\_enum.is\_default=0）；
	- 且 qc\_value\_has\_meaning=1；
	- 且 qc\_is\_wrong\_cleaning=0；
	- 且（按你要求）不计“和原始值完全相同、没真正纠偏”的样本 → qc\_is\_same\_as\_source=0。
- Q3： **兜底值如何识别？**
	- enum/bool： `tag_enum.is_default=1 & is_active=1` ；
	- string： `target_value_string = tag_spec.fallback` ；
	- 然后写入 qc\_is\_fallback\_value=1。
- Q4： **覆盖率公式写成 SQL 长什么样？**

在 `station_tag_target_value` 层，可以统一写成：

> 对某 tag\_code 的「有效覆盖率」：
> 
> 分母：适用范围内的站点数  
> 分子：满足「有意义 + 非兜底 + 非错误清洗 + 非原样」的站点数

伪 SQL：

其中 `is_applicable` 可以通过两种方式落地：

- 简单型：在 coverage 视图里写 CASE：
	- `open_hours` → 全部 = 1；
	- `service_carwash_type` → `EXISTS(service_carwash_available=1)` = 1，否则 0；
- 规范型：在 tag\_spec 或 tag\_algo\_config 里新增一个字段 `applicable_scope_expr` ，存储“适用范围 SQL 片段”，视图动态解析。短期先用简单 CASE 就够。
1. **标签族覆盖率（Service Tag Bundle / A 类标签整体）**

你想看的“整体服务标签覆盖率”，更合理的定义是：

> 在 A 类标签中，按「标签 × 油站」的有效单元格计算填充率。

举例，一个简化版：

- 假设我们只看 A 类 6 个标签：
	- open\_24h / open\_hours / convenience / parking / restroom / carwash\_available / carwash\_type
- 对每个 tag\_code：
	- 按上述口径算出：
		- applicable\_cell\_cnt（适用单元格数）
		- covered\_cell\_cnt（有效覆盖单元格数）
- 然后在一个视图里 SUM：

这样老板问：

> “现在我们核心服务标签整体覆盖率多少？”

你就可以答：

- “以当前业务日为口径，A 类服务标签在其适用范围内的有效覆盖率是 X%，其中：
	- open\_hours: 92%
	- open\_24h: 95%
	- 便利店/卫生间/洗车有无/洗车类型：xx% …”
1. **整体项目覆盖率（All Tags）**

这个就更抽象，但可以统一用同一个“cell 填充率”思路：

- 维度：
	- tag\_code
	- store\_id
	- as\_of\_date
- 单元格：某日某站的某标签。

整体 A 类覆盖率：

既符合“我们双 90 的逻辑目标”（看非兜底、有意义的结果），又给你后面扩展新标签留足空间。

#### 论据三：你下一步该做什么？——非常具体的 ToDo 列表

我们现在已经不缺算法，缺的是： **统一口径 + 落到终表 + 出监控视图** 。我建议你下一步按这个顺序来：

1. **Step6-口径文档：定死「适用范围 + 分母 + 分子」**

在当前总控文档里新增一节：

> 《标签覆盖率与 QC 口径说明》

内容至少包含：

- 全局规则：
	- enum/bool 的兜底识别 = `tag_enum.is_default=1 & is_active=1` ；
	- string 的兜底识别 = `target_value_string = tag_spec.fallback` ；
	- 覆盖率分子 = `非兜底 + qc_value_has_meaning=1 + qc_is_wrong_cleaning=0 + qc_is_same_as_source=0` ；
- 每个 tag\_code 一行：
	- applicable\_scope（用中文+伪 SQL 写清）
	- coverage\_denominator/coverage\_numerator 定义（以自然语言 + 一个示例 SQL 表达）。
1. **Step6-工程：snapshot → station\_tag\_target\_value 的落地脚本+QC赋值**
- 设计一个统一的插入模板（可以用 REPLACE INTO），对每个标签：
	- 把 snapshot 的值写入 `station_tag_target_value` ；
	- 同时计算并写入 5 个 QC 字段：
		- `qc_value_has_meaning` ：例如“enum\_code 映射到非兜底且业务不为 ‘未知/空’”；
		- `qc_is_fallback_value` ：通过 tag\_enum / tag\_spec 判断是否兜底；
		- `qc_is_wrong_cleaning` ：当前先统一写 0，将来再针对个别标签补逻辑；
		- `qc_is_same_as_source` ：从 source 原始值对比而来（这块你本地已经有实现规划）；
		- `qc_is_meaningless_non_fallback` ：暂时可以根据 value\_is\_meaningful + is\_fallback 的组合判断。
- 短期可以先只对 open\_xx + 服务标签 6 个标签做迁移，跑通一条 end-to-end 流水线。
1. **Step6-视图/报表：构建 `tag_coverage_by_tag` + `tag_coverage_overall` 两张视图**
- `tag_coverage_by_tag` ：
	- 粒度：as\_of\_date, tag\_code；
	- 字段：applicable\_store\_cnt, covered\_store\_cnt, coverage\_ratio；
- `tag_coverage_overall` ：
	- 汇总所有 A 类标签的 cell 级覆盖，输出整体覆盖率。
1. **再往后：新标签接入全部走同一套**
- 后面你接入 brand\_name / brand\_level / lifecycle / competitive\_overlap 等时：
	- 只需要在 tag\_spec 或 tag\_algo\_config 上补 “applicable\_scope + coverage\_rules” 两个字段；
	- 算法只要写到 snapshot 层；
	- 终表迁移和覆盖率统计 **完全不用新开口径** 。

---

### 3）思维导图结构（文本分层）

1. 当前进度总览  
	1.1 v\_merchant\_profile\_latest\_di 作为唯一上游视图  
	1.2 三层特征快照（门店/商户/工商）已具备  
	1.3 open\_24h / open\_hours 正规化输出完成  
	1.4 5 个服务标签（便利店、停车、卫生间、洗车有无、洗车类型）S1/S2 已跑通并局部验证  
	1.5 tag\_algo\_config & station\_tag\_target\_value 结构/QC 字段已经确定
2. 覆盖率统一口径  
	2.1 单标签：适用范围（denominator）、有效值（numerator）、兜底识别方式  
	2.2 标签族（服务标签/A 类标签）：按标签 × 站点 cell 汇总  
	2.3 整体项目：所有 A 类标签 cell 的填充率
3. 工程落地路径（Step6）  
	3.1 口径文档：为每个 tag\_code 写清 applicable\_scope + coverage\_rule  
	3.2 终表迁移：snapshot → station\_tag\_target\_value + QC 五字段赋值  
	3.3 覆盖率视图：tag\_coverage\_by\_tag / tag\_coverage\_overall  
	3.4 后续新标签接入时复用同一套模板
4. 长期可运维性  
	4.1 所有兜底只认 tag\_spec.fallback + tag\_enum.is\_default  
	4.2 覆盖率逻辑完全不依赖具体枚举值（例如不再写死 '99'）  
	4.3 任意新标签接入只需补三块：算法 → snapshot、配置 → tag\_algo\_config、口径 → coverage\_rules

---

### 4）迭代日志

- **来源**
	- 你发现我最近更多在写 SQL，没有显式更新「整体进度」这一层，于是问：
		- 现在整体 ETL 做到哪里了？
		- “整体标签覆盖率”应该如何定义和计算？
		- 你下一步到底该做什么？
- **本轮结论**
	1. 和你一起把当前进度从“SQL 细节”抽象成“工程阶段”：上游、特征层、营业时间家族、服务标签家族、终表/QC 仍待完善；
	2. 明确了覆盖率统一口径：
		- 按标签：适用范围 + 非兜底 + QC 条件；
		- 按标签族/整体项目：按标签×油站 cell 填充率汇总；
	3. 给出非常具体的 Step6 ToDo：
		- 先出口径文档；
		- 再做 snapshot→station\_tag\_target\_value 的统一迁移 + QC 赋值；
		- 然后搭两张 coverage 视图，形成 end-to-end 指标。
- **下一步建议（对你）**
	你接下来可以按这个顺序动手：
	1. 在当前总控文档里，新增一节《覆盖率与 QC 口径说明》，把每个标签的适用范围/分母/分子写一版自然语言口径。
	2. 我们下一轮对话，就直接开始设计并写出：
		- `snapshot → station_tag_target_value` 的统一插入 SQL 模板（先只覆盖 open\_xx + 服务 6 标签）；
		- 第一版 `tag_coverage_by_tag` 视图的 SQL（只看 A 类标签）。
	3. 你本地跑完后，我们再用实际数据来校验“服务标签整体覆盖率”是不是已经接近你心里的 double-90；如果没有，再有针对性地优化某几个标签的 S2。

你如果不想再写文档，我也可以直接先给你「Step6\_终表迁移 + 覆盖率视图」的 SQL 初稿，你边跑边贴回总控文档。

20251208\_2300\_标签覆盖率专项口径方案\_V1

tags: #标签覆盖率 #双90 #tag\_algo\_config #适用范围 #兜底值

---

### 1）一句话结论

覆盖率这件事要被“产品化”：我们用一套统一的规则，把 Q1–Q4 结构化写进 `tag_algo_config` （尤其是 extra\_config\_json），对每个 tag\_code 明确「适用范围」「有意义值」「兜底识别」「分母/分子公式」，然后在终表 `station_tag_target_value` 上用一套 SQL 模板自动计算。

---

### 2）三段论据

#### 2.1 Q1：适用范围（denominator scope）——统一规则 + 落在算法表里

你刚给了两个关键约定，我直接固化成规则：

1. 有 **依赖关系** 的标签（典型： `service_carwash_type` 依赖 `service_carwash_available` ）：
	- 分母 =「依赖标签满足某条件」的站点数；
	- 例：
		- `service_carwash_type` ：
			- 依赖 `service_carwash_available`
			- 条件：enum\_code ∈ {1}（即“有洗车站”）
			- 分母 = “有洗车站”的数量，而不是 1.6w 全量。
2. 没有依赖关系的标签（大多数基础/服务类标签）：
	- 默认分母 =「近 30 天动销站」
	- 即在 `v_merchant_profile_latest_di` 中 `is_trd_30d = 1` 的站点数。
	- 例如：
		- `open_hours` 、 `open_24h` 、 `convenience_store_available` 、 `parking_available` 、 `restroom_available` ，只要你不另行指定，都默认用 is\_trd\_30d=1 作为 coverage 分母。
3. 特殊情况（比如品牌等级只对某些品牌有意义）
	- 以后可以在算法表的 JSON 里单独写一条规则覆盖默认行为。

我建议直接在 **`tag_algo_config.extra_config_json`** 里标准化一个字段块：

预设规则：

- 如果 `coverage_scope.type` 缺失：默认视为 `"ACTIVE_STORE_30D"` ；
- 如果 `coverage_scope.type="DEPEND_ON_TAG"` ：
	- 分母范围 = 在 `station_tag_target_value` 中该 dep\_tag\_code 已有“非兜底 & 有意义值”的 store 集合。

这样 Q1 就不需要靠人记忆，全部落成“机器可读”的规则。

#### 2.2 Q2/Q3：什么是“有意义值” & 怎么识别兜底（你刚确认我理解是对的）

你给的口径我整理成两个层级：

1. 「有意义值」判断（Q2）

**逻辑规则** ：

- 对 enum/bool 标签：
	- 能在 `tag_enum` 中找到对应 enum\_code；
	- 且 `tag_enum.is_default = 0` （非兜底枚举）；
- 对 string 标签：
	- target\_value\_string 不等于 `tag_spec.fallback` ；
	- 且不为空、不在「无意义特殊值」白名单里（比如：“未知”、“空白”等）。

**工程落地** ：

在 `station_tag_target_value` 上写 QC 字段：

- `qc_value_has_meaning = 1` ⇔ 满足上述业务规则；
- 在计算覆盖率时， **分子只数 `qc_value_has_meaning=1` 的值** 。
1. 兜底值识别（Q3）

严格按你/上游下发的规范：

- enum/bool 标签：
	- 兜底枚举 = `SELECT enum_code FROM tag_enum WHERE tag_code=:tag_code AND is_default=1 AND is_active=1` ；
- string 标签：
	- 兜底文本 = `tag_spec.fallback` ；

**工程落地** ：

- `qc_is_fallback_value = 1` ⇔
	- enum/bool： `enum_code = default_enum_code` ；
	- string： `target_value_string = tag_spec.fallback` 。

并在 `extra_config_json` 里给一个开关说明：

这样 Q2/Q3 也不再靠“约定俗成”，而是落回到 `tag_algo_config` + QC 字段上。

#### 2.3 Q4：分母/分子如何计算——用一个统一 SQL 模板解决

你刚重新定义：

> 分母：适用范围内的站点数（Q1）  
> 分子：满足「非兜底」的站点数（叠加 Q2 的“有意义值”判断）

我建议把「单标签覆盖率」固化成一个视图逻辑：

1）先在 `station_tag_target_value` 上，按日拉出每个 tag\_code 的分子：

2）再根据 coverage\_scope 决定分母：

- 对于 `ACTIVE_STORE_30D` ：
- 对于 `DEPEND_ON_TAG` （例如 `service_carwash_type` ）：

3）最后在一个综合视图 `tag_coverage_by_tag` 中，把分子/分母 join 起来：

**关键点：**

- 分母怎么取 → 完全由 `tag_algo_config.extra_config_json.coverage_scope` 决定；
- 分子怎么数 → 固定规则： `qc_value_has_meaning=1 AND qc_is_fallback_value=0` ；
- 以后新增一个标签，只要在 `tag_algo_config` 把 coverage\_scope/coverage\_numerator 这两个 JSON 写好，视图可以“零改动复用”。

---

### 3）思维导图结构（文本分层）

1. 总目标  
	1.1 用统一规则回答“标签覆盖率怎么算”  
	1.2 规则必须机器可读、写入算法表，可长期复用  
	1.3 分解为 Q1–Q4 四个维度
2. Q1 适用范围（denominator scope）  
	2.1 有依赖标签 → 依赖标签有效站点集  
	2.2 无依赖标签 → 默认近30天动销站（is\_trd\_30d=1）  
	2.3 特殊标签可用 CUSTOM\_SQL 扩展  
	2.4 挂在 tag\_algo\_config.extra\_config\_json.coverage\_scope
3. Q2 / Q3 有意义值 & 兜底识别  
	3.1 有意义值：非兜底 + 业务上有实际意义  
	3.2 兜底识别：enum/bool 看 tag\_enum.is\_default=1，string 看 tag\_spec.fallback  
	3.3 挂在 station\_tag\_target\_value 的 QC 字段（qc\_value\_has\_meaning, qc\_is\_fallback\_value 等）  
	3.4 同时在 extra\_config\_json.coverage\_numerator 明确“排不排兜底、要不要 has\_meaning”
4. Q4 分母/分子公式  
	4.1 分母：coverage\_scope 决定的适用站点数  
	4.2 分子： `qc_value_has_meaning=1 AND qc_is_fallback_value=0` 的站点数  
	4.3 单标签覆盖率视图：tag\_coverage\_by\_tag  
	4.4 标签族/整体覆盖率：在 cell 维度上汇总
5. 与现有工程的关系  
	5.1 不改 S1/S2 算法，只加一层终表+口径  
	5.2 先在 open\_xx + 服务标签家族试点，跑通 end-to-end  
	5.3 后续 A 类/B 类标签接入只要填算法表和 JSON 即可扩展

---

### 4）迭代日志

- **来源**
	- 你重新给了 Q1–Q4 的口径偏好：
		- Q1：有依赖就按依赖标签算；无依赖就按近 30 天动销站算；
		- Q2：我刚才对“有意义值”的理解你确认没问题；
		- Q3：兜底识别沿用我们刚对齐的新规范；
		- Q4：分母=适用范围，分子=非兜底（叠加有意义值），要求“写成一个专项、规划细致算法”。
- **本轮结论**
	1. 把 Q1–Q4 从“口头规则”落成“结构化配置”：
		- Q1、Q4 的维度描述写进 `tag_algo_config.extra_config_json.coverage_scope` ；
		- Q2、Q3 在 QC 字段 + `coverage_numerator` 中声明；
	2. 给出可直接落地的 SQL 模板：
		- 单标签分子统计；
		- 按 coverage\_scope 取分母；
		- 汇总为 `tag_coverage_by_tag` 视图。
	3. 把“依赖关系型标签 vs 非依赖标签（默认 is\_trd\_30d=1）”这条红线清晰写进规则体系。
- **下一步建议（你的具体动作）**
	按照你现在的节奏，下一步可以这么干：
	1. **在 tag\_algo\_config 里补 coverage\_scope / coverage\_numerator JSON**
		- 至少先给这 7 个标签写清楚：
			- open\_24h, open\_hours
			- convenience\_store\_available, parking\_available, restroom\_available
			- service\_carwash\_available, service\_carwash\_type
		- 我可以下一条直接帮你写出 INSERT/UPDATE SQL。
	2. **在 station\_tag\_target\_value 的 ETL 脚本里补 QC 字段赋值逻辑**
		- 先实现： `qc_value_has_meaning` 、 `qc_is_fallback_value` ；
		- 其余字段后面逐步填。
	3. **写一版 `tag_coverage_by_tag` 视图 SQL（先只算 A 类标签）**
		- 以我们刚才的模板为基础；
		- 你本地跑一下，看服务标签的 coverage 能不能一眼说“open\_24h/open\_hours/服务标签家族整体覆盖率已经拉到多少”。

如果你愿意，下一轮我可以直接：

- 给出 7 个标签的 `tag_algo_config` 补全 SQL（包含 coverage\_scope / coverage\_numerator JSON）；
- 再给一版 `station_tag_target_value` 的 QC 赋值 SQL 草稿；  
	你只需要在 dev 跑 + 反馈数据，我们再一起微调。

20251209\_0015\_tag\_algo\_config\_覆盖率配置SQL\_V1

tags: #tag\_algo\_config #coverage\_scope #coverage\_numerator #双90 #配置落地

---

### 1）一句话结论

你给的依赖关系表 + 我们前面约定的“有依赖→按依赖标签算分母 / 无依赖→按近30天动销站算分母”，已经足够支撑把全部标签的覆盖率口径写进 `tag_algo_config.extra_config_json` ，我直接给一版可执行的 INSERT/UPDATE SQL，一次性把 14 个标签的 `coverage_scope` / `coverage_numerator` 补齐。

---

### 2）三段论据

#### 2.1 你给的信息已经够了，不需要再看全表

你补充的两块信息，其实刚好是我们下手的关键：

- 覆盖范围定义：
	- “有依赖关系的标签（如洗车类型）→ 按依赖关系算分母”；
	- “没有依赖关系的标签 → 用近30天动销站（ `is_trd_30d=1` ）作为分母”。
- 依赖关系列表：

再结合我们刚刚定的 JSON 结构：

因此：

- 无依赖的标签 → `coverage_scope.type = 'ACTIVE_STORE_30D'` ；
- `service_carwash_type` → 依赖 `service_carwash_available=1` ；
- `sme_supplier_partner` → 依赖 `sme_supplier=1` ；
- 分子统一先按你现在的约定来：
	- “非兜底 & 有意义值” → `exclude_fallback=true` + `require_has_meaning=true` 。

这些都可以完全在 SQL 里表达，不需要你再贴一遍全表数据。

#### 2.2 实现策略：只改 JSON，不动已有阈值

考虑到你之前已经为部分标签（尤其是 open\_hours + 服务标签）手工配过 `conf_threshold_store` 和权重，我采用“ **只 merge JSON，不改其他字段** ”的策略：

- 利用 MySQL 8 的 `JSON_MERGE_PATCH` ：
	- 对已有行：
		- `extra_config_json = JSON_MERGE_PATCH(old_json, new_json)`
		- 原来的键（如 `d1_enabled`, `window_days` ）会被保留，新加 `coverage_scope` / `coverage_numerator` ；
	- 对新行（tag 尚未配置）：
		- 先插入一条只带 `extra_config_json` 的记录；
		- 其他字段走默认值（ `conf_threshold_store=0.9` 等）；
		- 将来如果你想改阈值，再单独 UPDATE。

统一用：

这样：

- open\_hours 之前的 `{"d1_enabled":1,"window_days":30}` 会自动 merge 上 coverage 字段；
- 其他已经存在配置的标签也不会被改阈值，只是多了 coverage 相关配置。

#### 2.3 SQL 设计结果：14 个标签一条语句全部写入

我们把 14 个标签分成三类：

1. **无依赖 + 活跃站分母** （ACTIVE\_STORE\_30D）
	- brand\_level
	- brand\_name
	- competitive\_overlap
	- convenience\_store\_available
	- is\_ka\_direct
	- open\_24h
	- open\_hours
	- parking\_available
	- restroom\_available
	- service\_carwash\_available
	- sme\_supplier
	- store\_life
	- wyc\_pricing\_enabled
2. **有依赖：service\_carwash\_type**
	- coverage\_scope.type = DEPEND\_ON\_TAG
	- dep\_tag\_code = service\_carwash\_available
	- dep\_enum\_in = \['1'\]（有洗车站）
3. **有依赖：sme\_supplier\_partner**
	- coverage\_scope.type = DEPEND\_ON\_TAG
	- dep\_tag\_code = sme\_supplier
	- dep\_enum\_in = \['1'\]（有中小供给名称时才算适用）

extra\_config\_json 的 `coverage_numerator` 部分先统一：

后面如果你要引入诸如 “exclude\_same\_as\_source” 之类的更精细指标，我们再在 JSON 里加字段即可。

---

### 3）可直接执行的 SQL（一次性补齐所有标签）

> 说明：
> 
> - 如果某 tag\_code + algo\_version 已存在，只更新 extra\_config\_json（merge）；
> - 如果不存在，则插入一行，algo\_version 用 'v1'（open\_hours 已是 open\_hours\_v1，这里单独写）；
> - 你可以先在开发库执行，再 `SELECT tag_code, extra_config_json FROM tag_algo_config` 验证一眼。

```sql
sql/*************************************************
 * tag_algo_config 覆盖率配置补齐（全部 14 个标签）
 * 约定：
 *  - 无依赖：coverage_scope.type = 'ACTIVE_STORE_30D'
 *  - service_carwash_type：依赖 service_carwash_available=1
 *  - sme_supplier_partner：依赖 sme_supplier=1
 *************************************************/

INSERT INTO tag_algo_config (tag_code, algo_version, extra_config_json)
VALUES
    -- 1. 无依赖标签：默认按近30天动销站(is_trd_30d=1) 作为分母
    ('brand_level', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('brand_name', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('competitive_overlap', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('convenience_store_available', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('is_ka_direct', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('open_24h', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('open_hours', 'open_hours_v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('parking_available', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('restroom_available', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('service_carwash_available', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('sme_supplier', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('store_life', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),
    ('wyc_pricing_enabled', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'ACTIVE_STORE_30D'
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),

    -- 2. 有依赖标签：service_carwash_type 依赖 service_carwash_available=1
    ('service_carwash_type', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'DEPEND_ON_TAG',
                'dep_tag_code', 'service_carwash_available',
                'dep_enum_in', JSON_ARRAY('1')   -- 有洗车站
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    ),

    -- 3. 有依赖标签：sme_supplier_partner 依赖 sme_supplier=1
    ('sme_supplier_partner', 'v1',
        JSON_OBJECT(
            'coverage_scope', JSON_OBJECT(
                'type', 'DEPEND_ON_TAG',
                'dep_tag_code', 'sme_supplier',
                'dep_enum_in', JSON_ARRAY('1')   -- 有合作中小供给名称
            ),
            'coverage_numerator', JSON_OBJECT(
                'exclude_fallback', TRUE,
                'require_has_meaning', TRUE
            )
        )
    )
ON DUPLICATE KEY UPDATE
    extra_config_json = JSON_MERGE_PATCH(
        COALESCE(extra_config_json, JSON_OBJECT()),
        VALUES(extra_config_json)
    );
```

> 使用建议：
> 
> 1. 在 dev 库执行上述 SQL；
> 2. 用一个快速查询确认结果，例如：

---

### 4）迭代日志

- **来源**
	- 你确认覆盖率逻辑没问题，希望“把 todo 落地，把全部标签写进去，不然不知道怎么算”；
	- 明确给了依赖关系表，并提醒：无依赖→近30天动销站、有依赖→按依赖标签算。
- **本轮结论**
	1. 基于你的依赖关系+约定，确定 coverage\_scope 规则：
		- 无依赖标签： `ACTIVE_STORE_30D` ；
		- `service_carwash_type` ：依赖 `service_carwash_available=1` ；
		- `sme_supplier_partner` ：依赖 `sme_supplier=1` ；
	2. 统一 coverage\_numerator： `exclude_fallback=true` + `require_has_meaning=true` ；
	3. 用一条 INSERT... ON DUP + JSON\_MERGE\_PATCH 的语句，为 14 个标签补齐 extra\_config\_json，不动已有阈值与其他 config。
- **下一步建议**
	1. 你在 dev 库执行这条 SQL 后，截一小段 `tag_algo_config` 的查询结果给我（主要看 extra\_config\_json 是否按预期 merge）；
	2. 确认无误后，我们就可以开始写：
		- `station_tag_target_value` 的终表迁移 + QC 赋值 SQL；
		- 第一版 `tag_coverage_by_tag` 视图，用这 14 个标签直接算出“当前双 90 进度”。

只要这一步做完，“覆盖率怎么算”这件事就算真正落表了，后面所有新标签都可以沿用同一套框架。

20251209\_0025\_tag\_algo\_config\_coverage\_scope\_依赖关系订正

tags: #tag\_algo\_config #coverage\_scope #sme\_supplier #依赖关系更正

---

1）一句话结论  
你这次订正的是依赖方向： `sme_supplier_partner` 没有依赖关系，而 `sme_supplier` 依赖于 `sme_supplier_partner=1` ；我们只需要对这两个 tag 的 `coverage_scope` 做一次 UPDATE/merge，其他标签的配置保持不变。

---

2）三段论据

**论据一：依赖关系的正确语义**

- `sme_supplier_partner` ：
	- 语义：是否合作中小供给（0/1）；
	- 本身是最基础的判断标签，不依赖其他标签。
	- 所以它的覆盖率分母应该是“近 30 天动销站 is\_trd\_30d=1”（无依赖标签通用规则）。
- `sme_supplier` ：
	- 语义：合作中小供给名称（只有在 partner=1 时才有意义）；
	- 显然依赖 `sme_supplier_partner=1` ；
	- 覆盖率分母应该是“那些已经判定为合作中小供给的站点”。

因此， **正确关系应为** ：

- `sme_supplier_partner` → `coverage_scope.type = 'ACTIVE_STORE_30D'`
- `sme_supplier` → `coverage_scope.type = 'DEPEND_ON_TAG'` ， `dep_tag_code='sme_supplier_partner'` ， `dep_enum_in=['1']`

这和你刚刚的订正一致。

---

**论据二：如何在 tag\_algo\_config 中订正，而不影响其他配置**

我们刚才的做法是：

- 用 `INSERT ... ON DUPLICATE KEY UPDATE + JSON_MERGE_PATCH` ：
	- 对已有行，只 merge 新的 JSON 字段，不覆盖已存在的阈值等配置；
- 现在要做的只是把这两个 tag 的 `coverage_scope` 覆盖为最新语义。

做法：

- 对 `sme_supplier` ：
	- 把 `coverage_scope` 改成：
- 对 `sme_supplier_partner` ：
	- 把 `coverage_scope` 改成：

`coverage_numerator` 部分仍保持：

我们继续沿用之前策略：只更新这两个 tag 的 extra\_config\_json，其他字段（阈值/权重）全部保留。

---

**论据三：具体 SQL 订正方式（只动这两行）**

下面这段 SQL 可以直接在 dev 库执行，用来“更正依赖方向”：

执行后可以用这条查询快速确认：

你预期看到的是：

- `sme_supplier_partner` 的 JSON 中： `"coverage_scope":{"type":"ACTIVE_STORE_30D"}`
- `sme_supplier` 的 JSON 中： `"coverage_scope":{"type":"DEPEND_ON_TAG","dep_tag_code":"sme_supplier_partner","dep_enum_in":["1"]}`
- 原有的其他 key（比如之前如果有写别的配置）继续保留。

---

3）思维导图结构（文本分层）

1. 依赖关系订正  
	1.1 sme\_supplier\_partner：基础布尔标签，无依赖  
	1.2 sme\_supplier：名称标签，依赖 partner=1
2. 覆盖率分母规则  
	2.1 无依赖 → ACTIVE\_STORE\_30D（is\_trd\_30d=1）  
	2.2 有依赖 → DEPEND\_ON\_TAG（按依赖标签有效样本算分母）
3. 配置落地  
	3.1 tag\_algo\_config.extra\_config\_json  
	3.2 coverage\_scope、coverage\_numerator 字段结构不变  
	3.3 用 JSON\_MERGE\_PATCH 覆盖这两个 tag 的 coverage\_scope
4. 下一步衔接  
	4.1 所有标签 coverage\_scope 已明确  
	4.2 下一步可以安全开始写：  
	\- station\_tag\_target\_value 的终表迁移 + QC 赋值逻辑  
	\- tag\_coverage\_by\_tag 视图（按照这些配置算 coverage）

---

4）迭代日志

- **来源**
	- 你发现我刚才把 sme\_supplier 和 sme\_supplier\_partner 的依赖方向写反，明确订正：
		- `sme_supplier` 依赖于 `sme_supplier_partner=1` ；
		- `sme_supplier_partner` 没有依赖关系。
- **本轮改动点**
	1. 明确依赖语义并调整 coverage\_scope 的设计：
		- sme\_supplier\_partner： `ACTIVE_STORE_30D` ；
		- sme\_supplier： `DEPEND_ON_TAG` （dep\_tag\_code=sme\_supplier\_partner, dep\_enum\_in=\['1'\]）。
	2. 给出精确的修正 SQL，仅影响这两个 tag 的 extra\_config\_json，其他配置不动。
- **下一步建议**
	你执行这段 SQL 后：
	1. 抽查上述 SELECT 结果确认 JSON 是否符合预期；
	2. 一旦确认没问题，我们就可以正式进入 \*\*Step6：
		- snapshot → station\_tag\_target\_value 的统一迁移脚本（先覆盖 open\_xx + 服务标签 + sme\_supplier/sme\_supplier\_partner）；
		- 同时设计 QC 字段（特别是 `qc_value_has_meaning` / `qc_is_fallback_value` ），为 coverage 视图打基础。\*\*

你这边一旦确认 tag\_algo\_config 已经就位，我下一轮就直接上 “终表迁移 + QC 赋值 + tag\_coverage\_by\_tag 视图” 的第一版 SQL。

我问一下,现在这个插入不会变更我之前的字段内容把.最好在给我一个备份的语句,我前置运行

20251209\_0035\_tag\_algo\_config\_备份与变更范围说明

tags: #tag\_algo\_config #JSON\_MERGE\_PATCH #配置备份 #安全变更

---

### 1）一句话结论

现在这套 `INSERT ... ON DUPLICATE KEY UPDATE` 语句只会改动每个 tag 的 `extra_config_json` 字段：已有行只做 JSON 合并，不会动你之前配好的阈值/权重等其他字段；为安全起见，你可以先完整备份 `tag_algo_config` 表，再执行变更。

---

### 2）三段论据

#### 2.1 这条 INSERT... ON DUP 具体会动哪些字段？

先看我们之前的结构（简化）：

关键点：

1. **INSERT 部分仅提供了 3 个列** ： `tag_code`, `algo_version`, `extra_config_json` 。
	- 如果该 `(tag_code, algo_version)` 组合在表里不存在 → 插入新行：
		- 这 3 列按 VALUES 写入；
		- 其他列（例如 `conf_threshold_store` 、 `hierarchy_weight_*` ）走各自的 **默认值** （表结构里的 DEFAULT）。
2. **ON DUPLICATE KEY UPDATE 只更新 extra\_config\_json 一个字段** ：
	- 对于已经存在的 `(tag_code, algo_version)` ：
		- `extra_config_json` 会被更新为  
			`JSON_MERGE_PATCH(旧 extra_config_json, 新 extra_config_json)` ；
		- 其他字段（ `conf_threshold_store` 、 `enable_merchant_level` 、 `hierarchy_weight_*` 等） **不会出现在 UPDATE 子句里，因此完全不被修改** 。
3. `JSON_MERGE_PATCH` 的行为是：
	- 对已有键：用新值覆盖老值；
	- 对新键：新增；
	- 对没提到的键：保持不变。

所以综合起来：

- 已有配置行： **只有 `extra_config_json` 会被更新，其他全字段不动** ；
- 新增的 tag：
	- 插入一行， `conf_threshold_*` 等用表默认值；
	- 这本来就是我们期望的行为。

只要你现在表的 DEFAULT 配得合理，这条语句不会“意外覆盖”你之前手工调过的数值。

#### 2.2 怎么做一个“保险”的备份？

你说得对，生产习惯上最好还是做个备份，尤其这个表是“核心算法配置表”。最简单、实用的方案：

1） **完整复制一个备份表**

推荐做一个带日期后缀的备份表：

这样：

- 备份表结构 & 数据与当前时刻的 `tag_algo_config` 完全一致；
- 出现任何问题，你都可以：
	- 要么直接用备份表对比差异；
	- 要么把某几个 tag 的配置从备份表恢复回来。

2） **如需恢复单个/部分 tag 的配置**

一旦你发现某个 tag 改错了，可以用类似下面的语句恢复：

如果你懒得一列列写，可以简单粗暴一点：

这两种方式都可以，取决于你是想“全量覆盖”还是“只恢复某些字段”。

#### 2.3 推荐的执行顺序

为了让你心里更有数，我建议的节奏是：

1. **先备份**
1. **再执行上一轮的 INSERT... ON DUP 语句（含 sme\_supplier / sme\_supplier\_partner 订正）**
- 先跑 14 个标签的那条；
- 再跑最后那条订正 sme\_supplier 依赖方向的语句。
1. **检查一下变更结果**

重点检查：

- 之前你手工配置过的阈值（比如 open\_hours 的 `conf_threshold_store` 、 `hierarchy_weight_*` ）是否还保持原值；
- extra\_config\_json 是否出现了我们期望的 `coverage_scope` / `coverage_numerator` 。
1. **发现问题再按备份恢复**
- 如果只个别 tag 不对，用 UPDATE/JOIN 或 DELETE+INSERT 从备份表恢复；
- 如果极端情况“觉得全错了”，也可以：

直接回滚到变更前。

---

### 3）思维导图结构（文本分层）

1. 变更影响范围  
	1.1 INSERT 只写 tag\_code/algo\_version/extra\_config\_json  
	1.2 ON DUPLICATE KEY UPDATE 只更新 extra\_config\_json  
	1.3 其他字段（阈值/权重等）完全不在 UPDATE 子句中 → 不会被改
2. 备份策略  
	2.1 CREATE TABLE... LIKE + INSERT SELECT 完整复制表结构与数据  
	2.2 如需恢复某个 tag，支持：  
	\- UPDATE JOIN 按列恢复  
	\- DELETE + INSERT 全行覆盖
3. 推荐执行顺序  
	3.1 先备份 `tag_algo_config`  
	3.2 再执行 coverage\_scope/coverage\_numerator 插入脚本  
	3.3 查询 spot check 确认 JSON 和阈值  
	3.4 如有异常，从备份表恢复

---

### 4）迭代日志

- **来源**
	- 你担心 ON DUPLICATE KEY 的语句会改掉之前辛苦配的参数，希望在执行前有一个“保险备份”的方案。
- **本轮结论**
	1. 明确解释了这类语句实际只会修改 `extra_config_json` 字段，而不会触碰其他列；
	2. 给出一套非常简单可靠的备份 & 恢复 SQL（建备份表 → 全表复制 → 有问题按 tag 回滚）；
	3. 推荐了一个具体执行顺序：先备份，再变更，再检查，最后按需回滚。

你可以先跑备份 + 14 标签的配置 SQL，跑完后贴一小段 `SELECT tag_code, extra_config_json` 的结果，我们再一起确认下 coverage\_scope/coverage\_numerator 是否完全符合预期，然后就可以开干终表迁移和覆盖率视图了。

20251209\_0105\_tag\_algo\_config\_错误修复与安全改写方案

tags: #tag\_algo\_config #回滚 #coverage\_scope #版本号 #配置治理

---

### 1）一句话结论

确实是我这边设计失误：不该新建 `algo_version='v1'` 的行，而应该在你原有版本号（如 `brand_level_v1` 、 `open_hours_v1` ）那一行上合并 JSON；现在最稳妥的做法是：先用你刚才的备份完整回滚 `tag_algo_config` ，然后用一组 **只按 tag\_code 做 UPDATE、不再 INSERT 新行** 的 SQL，把 `coverage_scope` / `coverage_numerator` 并入现有 `extra_config_json` 。

---

### 2）三段论据

#### 2.1 问题本质：我把“新配置”写成了“新版本行”

你给的现状非常清晰：

这说明两件事：

1. `brand_level` 本来就有一行，版本号是 `brand_level_v1` ，里面已经有 `algo_mode / rule_template / warehouse_source_view` 等关键配置；
2. 我的 upsert 语句用 `algo_version='v1'` 新插了一行，变成同一个 tag\_code 有两个算法版本，这不是你想要的：
	- 上层逻辑会不知道该用哪个版本；
	- 覆盖率配置和算法配置被拆到了两行里，非常难维护。

你说得完全对：

> 正确做法应该是： **在原有 algo\_version（例如 brand\_level\_v1）那一行的 `extra_config_json` 里补 coverage\_scope/coverage\_numerator** ，而不是新增一个 `v1` 。

这是我的锅。好在你已经有备份，我们可以“不留垃圾”地回滚再改。

#### 2.2 推荐修复路径：先完全回滚，再用 UPDATE 按 tag\_code 合并 JSON

既然你已经按我之前建议做好备份（例如 `tag_algo_config_backup_20251209` ），现在最干净的方式是：

1） **Step0：用备份表回滚 tag\_algo\_config**

直接把表恢复到执行“有问题脚本”之前的状态：

执行完这两句后：

- `tag_algo_config` 和当时备份时的状态 **一模一样** ；
- 刚才多出来的 `brand_level / v1` 这类行都会消失；
- 原来的版本号（ `brand_level_v1` 、 `open_hours_v1` 等）全部恢复原状。

2） **Step1：改策略——只 UPDATE，不再 INSERT**

接下来我们不用 INSERT 了，只对现有行做 JSON 合并：

- 以 `tag_code` 为定位键（假设每个 tag\_code 目前只配了一个版本）；
- 在该行的 `extra_config_json` 上做 `JSON_MERGE_PATCH` ，增加 coverage 相关配置。

这样：

- 不会产生新的 `algo_version` ；
- 不会新增行；
- 只是在原有 JSON 上加两个 key： `coverage_scope` 、 `coverage_numerator` 。

3） **Step2：分三类标签做 UPDATE**

按照你之前的依赖关系订正：

- **无依赖（适用范围=近30天动销站，ACTIVE\_STORE\_30D）**
- **有依赖：service\_carwash\_type 依赖 service\_carwash\_available=1**
- **有依赖：sme\_supplier 依赖 sme\_supplier\_partner=1**

全部统一的分子规则：

下面是“只 UPDATE，不 INSERT”的修正版 SQL：

```sql
sql/*************************************************
 * Step1：为无依赖标签新增 coverage_scope/coverage_numerator
 * 说明：
 *  - 只 UPDATE，按 tag_code 定位，不会创建新行
 *  - 对不存在的 tag_code，影响行数=0（后续你可查漏补缺）
 *************************************************/

UPDATE tag_algo_config
SET extra_config_json = JSON_MERGE_PATCH(
    COALESCE(extra_config_json, JSON_OBJECT()),
    JSON_OBJECT(
        'coverage_scope', JSON_OBJECT(
            'type', 'ACTIVE_STORE_30D'
        ),
        'coverage_numerator', JSON_OBJECT(
            'exclude_fallback', TRUE,
            'require_has_meaning', TRUE
        )
    )
)
WHERE tag_code IN (
    'brand_level',
    'brand_name',
    'competitive_overlap',
    'convenience_store_available',
    'is_ka_direct',
    'open_24h',
    'open_hours',
    'parking_available',
    'restroom_available',
    'service_carwash_available',
    'sme_supplier_partner',
    'store_life',
    'wyc_pricing_enabled'
);

/*************************************************
 * Step2：为 service_carwash_type 配置依赖型 coverage_scope
 * 依赖：service_carwash_available=1
 *************************************************/

UPDATE tag_algo_config
SET extra_config_json = JSON_MERGE_PATCH(
    COALESCE(extra_config_json, JSON_OBJECT()),
    JSON_OBJECT(
        'coverage_scope', JSON_OBJECT(
            'type', 'DEPEND_ON_TAG',
            'dep_tag_code', 'service_carwash_available',
            'dep_enum_in', JSON_ARRAY('1')   -- 有洗车站
        ),
        'coverage_numerator', JSON_OBJECT(
            'exclude_fallback', TRUE,
            'require_has_meaning', TRUE
        )
    )
)
WHERE tag_code = 'service_carwash_type';

/*************************************************
 * Step3：为 sme_supplier 配置依赖型 coverage_scope
 * 依赖：sme_supplier_partner=1
 *************************************************/

UPDATE tag_algo_config
SET extra_config_json = JSON_MERGE_PATCH(
    COALESCE(extra_config_json, JSON_OBJECT()),
    JSON_OBJECT(
        'coverage_scope', JSON_OBJECT(
            'type', 'DEPEND_ON_TAG',
            'dep_tag_code', 'sme_supplier_partner',
            'dep_enum_in', JSON_ARRAY('1')   -- 合作中小供给站
        ),
        'coverage_numerator', JSON_OBJECT(
            'exclude_fallback', TRUE,
            'require_has_meaning', TRUE
        )
    )
)
WHERE tag_code = 'sme_supplier';
```

注意几点：

- 这三段 SQL 不会新建任何行；
- 也不会改 `algo_version` 、 `conf_threshold_store` 等字段；
- 只在已有的 `extra_config_json` 上追加/覆盖 coverage 相关 key。

4） **Step3：快速自检 brand\_level / open\_hours 等配置**

执行完后，你可以用类似查询确认：

你预期看到的是（以 brand\_level 为例）：

- 只有一行： `brand_level / brand_level_v1` ；
- `extra_config_json` 里面既有原来的字段：
- 又多了类似：

如果你愿意，可以把某一行完整 JSON 贴给我，我帮你检查有没有逻辑冲突。

---

### 3）思维导图结构（文本分层）

1. 问题识别  
	1.1 错误：为已有 tag 新建了 `algo_version='v1'` 的行  
	1.2 结果：同一 tag\_code 出现多版本，配置拆散  
	1.3 正确预期：在原版本行的 JSON 里补 coverage 配置
2. 修复策略  
	2.1 用备份表全量回滚 tag\_algo\_config  
	2.2 今后严格避免对配置表做 “INSERT + 新版本号” 这种粗暴方式  
	2.3 改用基于 tag\_code 的 UPDATE + JSON\_MERGE\_PATCH
3. 具体 SQL  
	3.1 TRUNCATE + INSERT FROM backup 完整还原  
	3.2 Step1：无依赖标签 → ACTIVE\_STORE\_30D 覆盖范围  
	3.3 Step2：service\_carwash\_type → 依赖 service\_carwash\_available=1  
	3.4 Step3：sme\_supplier → 依赖 sme\_supplier\_partner=1
4. 验证方案  
	4.1 SELECT tag\_code, algo\_version, extra\_config\_json spot check  
	4.2 brand\_level/open\_hours 等确认：只有一条版本行，JSON 中既有原配置又有 coverage 字段

---

### 4）迭代日志

- **来源**
	- 你非常敏锐地抓到：我之前的 upsert 违背了自己的约定，导致多了一行 `tag_code=brand_level, algo_version=v1` ，而不是在 `brand_level_v1` 行上合并 JSON；
	- 你已经有备份，因此“最佳解”就是回滚后重来。
- **本轮结论**
	1. 明确承认：之前的 INSERT 设计不符合你的版本管理预期；
	2. 给出一条“可恢复到备份 → 只 UPDATE 不 INSERT”的完整修复路径；
	3. 新的 SQL 严格遵守：
		- 不创建新行；
		- 不动任何非 JSON 配置；
		- 仅在原有 extra\_config\_json 上追加 coverage\_scope / coverage\_numerator。
- **下一步建议**
	1. 按顺序执行：
		- TRUNCATE+INSERT FROM backup 回滚；
		- 三段 UPDATE（Step1–3）。
	2. 然后把 `SELECT tag_code, algo_version, extra_config_json` 的部分结果（尤其是 brand\_level/open\_hours/service\_carwash\_type/sme\_supplier）贴给我，我们一起确认 coverage 配置长得是不是你心里预期的样子。
	3. 一旦确认无误，我们就可以开始写：
		- `station_tag_target_value` 的迁移脚本 + QC 赋值；
		- `tag_coverage_by_tag` 视图，真正把覆盖率算出来。

20251209\_0115\_tag\_algo\_config\_sme\_supplier\_partner\_配置校验通过

tags: #tag\_algo\_config #coverage\_scope #sme\_supplier\_partner #配置校验

---

### 1）一句话结论

你这条 `sme_supplier_partner` 的配置完全符合我们前面约定的算法+覆盖率设计，可以视为“标准答案样例”，后面其他标签就按这个结构对齐即可。

---

### 2）三段论据

#### （1）核心字段逐项对齐检查

当前行内容：

逐项看：

- `algo_version = sme_supplier_partner_v1` ：沿用你自己的版本命名，OK；
- `algo_mode = "WAREHOUSE_DIRECT"` + `rule_template = "SME_SUPPLIER_PARTNER_FROM_DW_V1"` ：说明主算法是“直接取数仓 + 模板化规则”，符合你之前的设计；
- `coverage_scope = {"type": "ACTIVE_STORE_30D"}` ：
	- 与我们订正后的口径一致：“无依赖标签 → 分母 = 近30天动销站”；
- `coverage_numerator = {"exclude_fallback": true, "require_has_meaning": true}` ：
	- 完全符合我们定义的分子口径：只统计“非兜底 + 有意义值”；
- 其他字段（fallback、warehouse\_source\_ *、derived\_* 、coverage\_strategy）全部保留，没有被覆盖掉；
- JSON 结构是“平铺+局部嵌套”，可读性也不错。

结论：这行配置既没有破坏原算法信息，又完整补上了 coverage 相关配置， **结构与语义都没问题** 。

#### （2）作为“模板样本”的可复用性

从这条 JSON 的形态来看，它其实已经满足我们对“算法表”的全部目标：

- 算法信息（algo\_mode / rule\_template / source\_view/field / derived\_xxx）和
- 覆盖率定义（coverage\_scope / coverage\_numerator）

都在 **同一个 JSON** 里，且字段命名清晰。

后续你要查这个标签：

- “这个值是怎么来的？” → 看 algo\_mode + rule\_template + warehouse\_source\_\*；
- “覆盖率怎么统计？” → 看 coverage\_scope + coverage\_numerator；

对任何接手的人来说，5–10 分钟能搞清楚这条标签的全貌。

#### （3）对整体的提示与下一步

这条示例已经验证：

- 回滚 + UPDATE 方案是安全的（没有多出新版本行）；
- JSON\_MERGE\_PATCH 写法符合预期（原字段在，新增字段也在）。

下一步更关键的动作有两个：

1. 抽查 3–5 个其他标签（比如 `open_hours`, `service_carwash_type`, `sme_supplier` ）：
	- 看是否也是“只有一个 algo\_version 行”；
	- `extra_config_json` 中同样包含 coverage\_scope / coverage\_numerator；
2. 在确认 tag\_algo\_config 配置稳定后，就可以上下一阶段：
	- 从 `store_tag_snapshot_di` 把这批标签统一迁移到 `station_tag_target_value` ；
	- 在迁移过程中写入 QC 字段（至少先做 `qc_value_has_meaning` 和 `qc_is_fallback_value` ）；
	- 基于 station\_tag\_target\_value + tag\_algo\_config 的 coverage\_scope，搭第一版 `tag_coverage_by_tag` 视图。

---

### 3）思维导图结构（文本分层）

1. 校验对象  
	1.1 tag\_code = sme\_supplier\_partner  
	1.2 algo\_version = sme\_supplier\_partner\_v1  
	1.3 extra\_config\_json = 算法信息 + coverage\_scope + coverage\_numerator
2. 检查要点  
	2.1 版本号未新增行，只是原行 JSON 被扩展  
	2.2 coverage\_scope.type = ACTIVE\_STORE\_30D，符合“无依赖标签”口径  
	2.3 coverage\_numerator 与“非兜底 + 有意义值”标准一致  
	2.4 原有字段全部保留，无损信息
3. 结论  
	3.1 配置正确，可作为其他标签的样板  
	3.2 证明 UPDATE+JSON\_MERGE\_PATCH 方案可用、安全
4. 后续衔接  
	4.1 再 spot-check 几个关键标签（open\_hours / service\_carwash\_type / sme\_supplier）  
	4.2 进入 Step6：终表迁移 + QC 赋值 + 覆盖率视图

---

### 4）迭代日志

- **来源** ：
	- 你担心之前的错误脚本影响整体配置，所以先按我们讨论的方案回滚 + UPDATE，然后给我贴了一条 `sme_supplier_partner` 的现状做样本；
- **本轮结论** ：
	1. 这条样本完全符合预期，说明当前配置状态健康；
	2. 我们的 JSON 设计在实战中是可读、可用、可拓展的；
- **建议动作** ：
	- 再给我贴 1–2 个标签（比如 `open_hours` 和 `service_carwash_type` ）的 `tag_code/algo_version/extra_config_json` ，确认整体无偏差后，我们就可以直接开写：
		- `snapshot → station_tag_target_value` 的统一迁移脚本；
		- 第一版覆盖率视图，用来回答“现在这 14 个标签的覆盖率到底多少”。

20251209\_0125\_tag\_algo\_config\_service\_carwash\_type\_配置校验与收口

tags: #service\_carwash\_type #coverage\_scope #派生标签 #依赖关系 #覆盖率口径

---

### 1）一句话结论

这条 `service_carwash_type` 的配置是对的：算法形态、依赖关系、覆盖率范围、分子口径和派生信息全部对齐我们前面定的规则，可以直接作为“依赖型派生标签”的标准模版来用。

---

### 2）三段论据（现状 → 校验 → 启示）

#### 2.1 现状再抄一遍

#### 2.2 关键字段逐项对

1） **算法形态（algo\_* 系）* \*

- `algo_mode = "DERIVED"` ：
	- 明确告诉后人：这是个 **派生标签** ，不是纯 DW 直出；
- `rule_template = "CARWASH_TYPE_FROM_AVAILABLE_AND_DW_V1"` ：
	- 模板名和我们实际逻辑一致：“依赖 available + DW 字段”；
- `warehouse_source_*` ：
	- `view = v_merchant_profile_latest`
	- `field = service_carwash_type`
	- 对应我们 S1 的“DW 承接部分”，信息完整；
- `derived_is_derived = 1` + `derived_source_tags = ["service_carwash_available"]` ：
	- 把依赖关系写死在配置里，不用翻文档；
	- 和我们实际算法（只在 available=1 且类型缺失/兜底时补 machine）一致。

2） **覆盖率相关（coverage\_\*）**

- `coverage_scope = { "type": "DEPEND_ON_TAG", "dep_tag_code": "service_carwash_available", "dep_enum_in": ["1"] }` ：
	- 完全符合我们定义的 **依赖型分母** ：
		- 分母 = “已判定为有洗车的站点数”；
		- 而不是 1.6w 全部油站；
- `coverage_numerator = { "exclude_fallback": true, "require_has_meaning": true }` ：
	- 分子 = “非兜底 + 有意义值”；
	- 顺着我们刚刚的覆盖率专项口径来，一致。

3） **兜底 & QC 相关**

- `fallback_unknown_enum_code = "99"` / `fallback_enable_unknown_rewrite = 0` ：
	- 表示“未知”类枚举用 99，但当前不启用“未知改写”；
- `qc_set_value_has_meaning_on_fallback = 0` ：
	- 很关键，这意味着：
		- 只要是 fallback（兜底）值， `qc_value_has_meaning` 不会被强行设为 1；
		- 和我们“覆盖率分子要排除兜底”是统一的。

整体来看：这条 JSON 没有任何明显冲突，设计是自洽的。

#### 2.3 对整体设计的启示

有了 `sme_supplier_partner_v1` + `service_carwash_type_v1` 这两个样本，其实我们已经有了两个“标准模版”：

- “DW 直出标签 + ACTIVE\_STORE\_30D 分母”的模板（sme\_supplier\_partner）；
- “派生标签 + DEPEND\_ON\_TAG 分母”的模板（service\_carwash\_type）；

后面任何新标签，只要能归类到这两种之一（或者某个变体），都可以直接 copy 这两条 JSON 的骨架。

这对你后续扩展 brand\_name / brand\_level / lifecycle / competitive\_overlap 等，是非常有用的——我们不再依赖“人记得规则”，而是有明确样例可抄。

---

### 3）思维导图结构（文本分层）

1. 样本标签：service\_carwash\_type  
	1.1 派生算法：DERIVED + rule\_template 指向 “AVAILABLE + DW”  
	1.2 来源视图：v\_merchant\_profile\_latest.service\_carwash\_type
2. 覆盖率设计  
	2.1 coverage\_scope：DEPEND\_ON\_TAG + dep\_tag\_code=service\_carwash\_available + dep\_enum\_in=\["1"\]  
	2.2 coverage\_numerator：exclude\_fallback=true + require\_has\_meaning=true
3. 血缘与兜底  
	3.1 derived\_is\_derived=1 + derived\_source\_tags=\["service\_carwash\_available"\]  
	3.2 fallback\_unknown\_enum\_code="99" + qc\_set\_value\_has\_meaning\_on\_fallback=0
4. 结论  
	4.1 配置与实际 ETL 逻辑高度一致  
	4.2 可作为“依赖型派生标签”的标准 JSON 模版  
	4.3 说明 UPDATE+JSON\_MERGE\_PATCH 方案在复杂标签场景下也表现正常

---

### 4）迭代日志 & 下一步建议

- **这轮的作用** ：
	- 你给了一个最复杂的标签（carwash\_type）的实际配置，让我们验证：
		- 覆盖率 JSON 是否会和派生逻辑打架；
		- UPDATE 方案在复杂 JSON 上是否会搞坏原字段。
	- 结论：这条是健康的，组合逻辑清晰，没有损坏任何原有信息。
- **接下来可以做什么** ：
	1. 你可以再 spot-check 一两个关键标签（例如 `open_hours` 、 `brand_level` ）确认 JSON 形态都类似“算法信息 + 覆盖率信息”双栈。
	2. 我们可以正式进入 **Step6：终表迁移 & QC & 覆盖率视图** ，优先目标就是：
		- 把 open\_xx + 服务标签 + sme\_supplier 系列从 snapshot 落到 `station_tag_target_value` ；
		- 在迁移过程中填上 qc\_value\_has\_meaning / qc\_is\_fallback\_value；
		- 基于 `tag_algo_config.coverage_scope` 拉出第一版 `tag_coverage_by_tag` 。

如果你愿意，下一步我直接给你：

- 一版 “snapshot → station\_tag\_target\_value” 的统一 INSERT/UPDATE 模板（针对 A 类标签）；
- 再配一组“覆盖率视图初稿 + 2~3 条校验查询”，你边跑边看覆盖率数字是否符合直觉。

20251209\_0135\_step6\_station\_tag\_target\_value\_迁移与覆盖率统计\_V1

tags: #station\_tag\_target\_value #S1S2双层管道 #QC #覆盖率 #服务标签

---

### 1）一句话结论

接下来这一步，我们把 `store_tag_snapshot_di` 里已经跑通的 open\_24h/open\_hours + 服务标签 + 其它 A 类标签，统一迁移到终表 `station_tag_target_value` ，在落表时一次性补齐基础 QC 字段，并给出一组可直接跑的覆盖率统计/校验 SQL。

---

### 2）三段论据（现状与问题 → 策略 → 落地方案）

#### 2.1 现状与问题：标签已经“算出来”，但终表 & 覆盖率视角还没打通

当前状态你这边已经具备：

- 上游视图： `v_merchant_profile_latest_di` （含 is\_trd\_30d、服务标签 DW 结果等）；
- 特征、候选、决策层：
	- `store_feature_snapshot_di` ：30 天行为特征；
	- `open_hours_candidate_di` ：三层候选 + conf；
	- open\_hours / open\_24h 的 A/B 版重建；
- 标签快照 & 审计：
	- `store_tag_snapshot_di` ： `(store_id, as_of_date, tag_code)` 粒度，已经写入 open\_24h/open\_hours/服务标签等最终决策值；
	- `tag_audit_log_di` ：三层候选 + 决策 trace\_json。

但还缺最后一跳：

- 终表 `station_tag_target_value` 虽然建好了（带三选一值 + enum\_label + 各类 QC 字段），但还没把 snapshot 的结果规范迁移过去；
- 覆盖率逻辑已经在 `tag_algo_config.extra_config_json` 里定义（coverage\_scope / coverage\_numerator），但没有一个统一的“落表+QC”动作让覆盖率统计真正可执行。

换句话说： **标签已经算出来了，但在“统一出口 + 可统计”这一层还差一步封口。**

#### 2.2 策略：统一从 store\_tag\_snapshot\_di 写终表，S1/S2 逻辑在 mapping & QC 里体现

我们这步的设计思路是：

1） **统一入口 → 统一出口**

- 入口：只认 `store_tag_snapshot_di` ，不再直接从数仓视图/上报表写终表；
- 出口：所有标签都落到 `station_tag_target_value` ，后续数仓/报表/覆盖率统计只认这一张表。

2） **S1 / S2 区分通过 evidence\_state → source 映射体现**

- `store_tag_snapshot_di.evidence_state` ：
	- S1：FOUND\_IN\_RAW / CONFIRMED（来自 DW/区域/人工确认）；
	- S2：INFERRED（我们本地算法补洞）；
- 落到终表时：

3） **终表字段映射（我们这一步一次性定死）**

从 `store_tag_snapshot_di` → `station_tag_target_value` 的映射：

- 主键侧：
	- store\_id：从 snapshot.store\_id 转成 BIGINT（ `CAST(s.store_id AS UNSIGNED)` ）；
	- as\_of\_date：直接用 snapshot.as\_of\_date；
	- tag\_code：直接用 snapshot.tag\_code；
- 三选一 & 枚举：
	- target\_value\_bool ← snapshot.target\_value\_bool
	- target\_value\_number ← snapshot.target\_value\_number
	- target\_value\_string ← snapshot.target\_value\_string
	- enum\_code ← snapshot.enum\_code
	- enum\_label ← `LEFT JOIN tag_enum` 拿中文名（tag\_code + enum\_code + is\_active=1）
- 源头 & 置信度 & 说明：
	- source ← 由 evidence\_state 映射 S1/S2；
	- evidence\_state ← snapshot.evidence\_state；
	- ttl\_days ← snapshot.ttl\_days；
	- conf ← snapshot.conf；
	- reason ← snapshot.reason；
	- upload\_batch\_id：统一命名为 `s_tag_etl_YYYYMMDD` （方便分批回溯）；
	- closest\_source：现阶段与 source 保持一致；
	- target\_value\_string\_back ← snapshot.target\_value\_string\_back。

4） **QC 字段先做“基础版”，优先满足覆盖率统计**

在不引入过多复杂逻辑（比如 diff 原值）前提下，先落一版“能支撑覆盖率”的 QC：

- 判定是否兜底：
- 判定结果是否有意义：
- 其它 QC：先保守赋值，后续再细化：

这样一来：

- 覆盖率统计中的“分子”可以直接用：
	- `qc_value_has_meaning=1 AND qc_is_fallback_value=0` ；
- “兜底占比”则可以用 qc\_is\_fallback\_value 独立观察。

#### 2.3 落地方案：统一迁移 SQL + 覆盖率/验算 SQL 一次给全

你现在最需要的是：

- 一段可以直接粘进“总脚本”的 SQL：
	- 约定业务日 `@biz_date` 已经在前序步骤通过 `v_merchant_profile_latest_di` 算出；
	- 一次性清理并落入 open\_24h/open\_hours + 服务标签 + 其它 A 类标签的终表结果；
- 另外配几条“编号清晰”的查询，方便你快速检查：
	- 迁移后终表里值对不对；
	- 覆盖率计算逻辑是否跟你的直觉一致。

下面给你一次性完整脚本（包含迁移 + Q1~Q3 的校验/覆盖率 SQL）。

---

### 3）统一迁移 + QC & 覆盖率统计 SQL（可直接放入主脚本）

> 说明：
> 
> - 默认 `@biz_date` 已通过前序 step0 获得；
> - 覆盖标签集合 = 当前 A 类标签全集：
> 	- `brand_level, brand_name, competitive_overlap, convenience_store_available, is_ka_direct, open_24h, open_hours, parking_available, restroom_available, service_carwash_available, service_carwash_type, sme_supplier, sme_supplier_partner, store_life, wyc_pricing_enabled`
> - 统一按照你的命名规范在首行给出 SQL 名称。

```sql
sql-- etl_tag_step6.station_tag_target_value_sync 统一将 S1/S2 标签快照落表到 station_tag_target_value 并填充基础 QC 字段

/*********************************************
 * 0. 业务日期兜底（如前序未设置 @biz_date）
 *********************************************/
IF @biz_date IS NULL THEN
    SET @biz_dt_str = (SELECT MAX(dt) FROM v_merchant_profile_latest_di);
    SET @biz_date   = STR_TO_DATE(@biz_dt_str, '%Y-%m-%d');
END IF;

/*********************************************
 * 1. 清理当日相关标签的旧记录
 *********************************************/
DELETE FROM station_tag_target_value
WHERE as_of_date = @biz_date
  AND tag_code IN (
        'brand_level',
        'brand_name',
        'competitive_overlap',
        'convenience_store_available',
        'is_ka_direct',
        'open_24h',
        'open_hours',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type',
        'sme_supplier',
        'sme_supplier_partner',
        'store_life',
        'wyc_pricing_enabled'
  );

/*********************************************
 * 2. 从 store_tag_snapshot_di 写入 station_tag_target_value
 *    - S1/S2 区分：来自 evidence_state (FOUND_IN_RAW/CONFIRMED → S1, 其它 → S2)
 *    - enum_label：对齐 tag_enum
 *    - QC 字段：先落“覆盖率可用”的基础版
 *********************************************/
INSERT INTO station_tag_target_value (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    enum_label,
    source,
    evidence_state,
    ttl_days,
    reason,
    conf,
    upload_batch_id,
    closest_source,
    target_value_string_back,
    qc_value_has_meaning,
    qc_is_wrong_cleaning,
    qc_is_same_as_source,
    qc_is_fallback_value,
    qc_is_meaningless_non_fallback
)
SELECT
    CAST(s.store_id AS UNSIGNED)          AS store_id,
    s.as_of_date                          AS as_of_date,
    s.tag_code                            AS tag_code,
    s.target_value_bool                   AS target_value_bool,
    s.target_value_number                 AS target_value_number,
    s.target_value_string                 AS target_value_string,
    s.enum_code                           AS enum_code,
    e.enum_label                          AS enum_label,
    CASE
        WHEN s.evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')
            THEN 'S1'
        ELSE 'S2'
    END                                   AS source,
    s.evidence_state                      AS evidence_state,
    s.ttl_days                            AS ttl_days,
    s.reason                              AS reason,
    s.conf                                AS conf,
    CONCAT('s_tag_etl_', DATE_FORMAT(s.as_of_date, '%Y%m%d'))
                                          AS upload_batch_id,
    -- 当前阶段 closest_source 与 source 保持一致
    CASE
        WHEN s.evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')
            THEN 'S1'
        ELSE 'S2'
    END                                   AS closest_source,
    s.target_value_string_back            AS target_value_string_back,

    -- QC1：结果值是否有实际业务意义（有值且非兜底）
    CASE
        WHEN (s.target_value_bool   IS NOT NULL
           OR s.target_value_number IS NOT NULL
           OR s.target_value_string IS NOT NULL)
         AND (e.tag_code IS NULL OR e.is_default = 0)
        THEN 1
        ELSE 0
    END                                   AS qc_value_has_meaning,

    -- QC2：是否错误清洗（当前不自动识别，先全部置 0）
    0                                      AS qc_is_wrong_cleaning,

    -- QC3：是否与原始值完全相同（当前不对比原值，先全部置 0）
    0                                      AS qc_is_same_as_source,

    -- QC4：是否兜底默认值（命中 tag_enum.is_default=1）
    CASE
        WHEN e.tag_code IS NOT NULL AND e.is_default = 1
        THEN 1
        ELSE 0
    END                                   AS qc_is_fallback_value,

    -- QC5：是否无实际业务意义且非兜底默认值（无值 AND 非兜底）
    CASE
        WHEN (s.target_value_bool   IS NULL
           AND s.target_value_number IS NULL
           AND s.target_value_string IS NULL)
         AND (e.tag_code IS NULL OR e.is_default = 0)
        THEN 1
        ELSE 0
    END                                   AS qc_is_meaningless_non_fallback

FROM store_tag_snapshot_di s
LEFT JOIN tag_enum e
       ON e.tag_code  = s.tag_code
      AND e.enum_code = s.enum_code
      AND e.is_active = 1
WHERE s.as_of_date = @biz_date
  AND s.tag_code IN (
        'brand_level',
        'brand_name',
        'competitive_overlap',
        'convenience_store_available',
        'is_ka_direct',
        'open_24h',
        'open_hours',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type',
        'sme_supplier',
        'sme_supplier_partner',
        'store_life',
        'wyc_pricing_enabled'
  );

/*********************************************
 * 3. 校验 & 覆盖率相关查询（方便你快速检查）
 *********************************************/

-- Q1：终表中某个标签（示例：open_hours）的落表总量 & S1/S2 占比
SELECT
    t.tag_code,
    COUNT(*)                                       AS row_cnt,
    COUNT(DISTINCT t.store_id)                     AS store_cnt,
    SUM(t.source = 'S1')                           AS s1_row_cnt,
    SUM(t.source = 'S2')                           AS s2_row_cnt
FROM station_tag_target_value t
WHERE t.as_of_date = @biz_date
  AND t.tag_code   = 'open_hours'
GROUP BY t.tag_code;

-- Q2：某个标签（示例：service_carwash_available）的“有意义非兜底”覆盖率（以近30天动销站为分母）
SELECT
    'service_carwash_available'                                          AS tag_code,
    COUNT(DISTINCT CASE WHEN base.is_trd_30d = 1 THEN base.store_id END) AS denom_store_cnt,
    COUNT(DISTINCT CASE
        WHEN base.is_trd_30d = 1
         AND t.qc_value_has_meaning = 1
         AND t.qc_is_fallback_value = 0
        THEN base.store_id
    END)                                                                 AS num_store_cnt,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN base.is_trd_30d = 1
             AND t.qc_value_has_meaning = 1
             AND t.qc_is_fallback_value = 0
            THEN base.store_id
        END) / NULLIF(
            COUNT(DISTINCT CASE WHEN base.is_trd_30d = 1 THEN base.store_id END),
            0
        )
    , 4)                                                                 AS coverage_ratio
FROM v_merchant_profile_latest_di base
LEFT JOIN station_tag_target_value t
       ON t.store_id   = base.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'service_carwash_available'
WHERE base.dt = DATE_FORMAT(@biz_date, '%Y-%m-%d');

-- Q3：依赖型标签（示例：service_carwash_type），以“有洗车站”为分母的覆盖率
SELECT
    'service_carwash_type'                                               AS tag_code,
    COUNT(DISTINCT CASE
        WHEN avail.enum_code = '1'
        THEN avail.store_id
    END)                                                                 AS denom_store_cnt,
    COUNT(DISTINCT CASE
        WHEN avail.enum_code = '1'
         AND type_t.qc_value_has_meaning = 1
         AND type_t.qc_is_fallback_value = 0
        THEN avail.store_id
    END)                                                                 AS num_store_cnt,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN avail.enum_code = '1'
             AND type_t.qc_value_has_meaning = 1
             AND type_t.qc_is_fallback_value = 0
            THEN avail.store_id
        END) / NULLIF(
            COUNT(DISTINCT CASE
                WHEN avail.enum_code = '1'
                THEN avail.store_id
            END),
            0
        )
    , 4)                                                                 AS coverage_ratio
FROM station_tag_target_value avail
LEFT JOIN station_tag_target_value type_t
       ON type_t.store_id   = avail.store_id
      AND type_t.as_of_date = avail.as_of_date
      AND type_t.tag_code   = 'service_carwash_type'
WHERE avail.as_of_date = @biz_date
  AND avail.tag_code   = 'service_carwash_available';
```

---

### 4）迭代日志（来源 / 改动点 / 待补充）

- **来源**
	- 你明确提出，已经完成 open\_hours/open\_24h + 服务标签在 `store_tag_snapshot_di` 的决策链路，希望现在进入“Step6：统一迁移到 station\_tag\_target\_value + QC & 覆盖率统计”；
	- 同时要求：
		- 落表逻辑要跟总控文档中的 S1/S2 双层管道保持一致；
		- SQL 命名规范统一（首行标记 etl\_tag\_xxx）；
		- 提供编号明确的校验 SQL，方便你边跑边看。
- **本轮结论与改动点**
	1. 明确了 `store_tag_snapshot_di → station_tag_target_value` 的字段级 mapping，包括 S1/S2 映射、enum\_label 对齐、upload\_batch\_id 命名方式等；
	2. 给出一版“覆盖率可用”的 QC 填充规则：
		- `qc_value_has_meaning` = 有值且非兜底；
		- `qc_is_fallback_value` 来源于 tag\_enum.is\_default；
		- `qc_is_meaningless_non_fallback` = 无值且非兜底；
		- 其它 QC 先全部置 0，后续再细化；
	3. 提供了完整的迁移 SQL（清理 + INSERT）以及 3 条带自然编号的校验/覆盖率查询（Q1–Q3），分别用于：
		- 检查某标签在终表的总量 & S1/S2 占比；
		- 检查非依赖标签的覆盖率（以近30天动销站为分母）；
		- 检查依赖型标签的覆盖率（以“依赖标签有效样本”为分母）。
- **待补充 / 下一步建议**
	1. 你可以先在开发库执行这段 SQL，依次跑：迁移 → Q1/Q2/Q3，看数是否符合你对几个典型标签（例如服务标签、open\_xx）的直觉；
	2. 如果 coverage 口径确认没问题，我们下一步可以：
		- 把 Q2/Q3 的逻辑封装成一个 `tag_coverage_by_tag` 视图 / 汇总表（按 tag\_code 一次性算出全部覆盖率）；
		- 再对 QC 字段做“精修版”（引入 `qc_is_same_as_source` 、 `qc_is_wrong_cleaning` 的真实识别规则，并写回总控文档）。

你先跑一轮这版 Step6，如果有任何数看着不顺眼（比如终表行数、S1/S2 占比、某个标签 coverage 太离谱），我们就围着对应 Qx 的结果继续往下钻。

20251209\_0205\_step6\_QC重构与终表迁移修正版

tags: #station\_tag\_target\_value #store\_tag\_snapshot\_di #QC规则 #覆盖率 #服务标签

---

### 1）一句话结论

你提的两个点都对：  
1）当前只能从 `store_tag_snapshot_di` 里迁 open/open\_hours + 服务标签这些“已经算好的标签”，不能假装全 A 类都在；  
2）5 个 QC 字段必须有“可用语义”，尤其要支持你后面的两个导出脚本，而不是简单填 0。  
下面我重构一版：先把“字段语义 + 上下游用途”讲清，再给新的迁移 SQL（只针对 snapshot 里已有的标签）+ QC 计算方案。

---

### 2）三段论据

#### 2.1 先把链路咬合讲清楚：现在到底“谁能迁”、“谁还没准备好”

你给的这条校验非常关键：

结果：

这说明目前 `store_tag_snapshot_di` ：

- 已经是“终态决策结果”的只有：
	- `open_24h`, `open_hours`
	- `convenience_store_available`, `parking_available`, `restroom_available`
	- `service_carwash_available`, `service_carwash_type`
- 其它 A 类（brand\_xxx / lifecycle / competitive 等）还没入这个 snapshot。

所以现在 **Step6 的“统一迁移”范围，必须限定在这 7 个标签** ：

> 我们这轮 Step6 的出口 =  
> `station_tag_target_value` 中的：  
> `open_24h, open_hours, convenience_store_available, parking_available, restroom_available, service_carwash_available, service_carwash_type` 。

其它标签（brand\_level、store\_life、sme\_supplier 等）：

- 需要先补 Step4/5 的“决策 + snapshot”链路，
- 再参加相同的 Step6 迁移。

这一点我之前是“往前想多了一步”，你指出得对。下面的 SQL 我会严格限定到这 7 个标签。

#### 2.2 重设 5 个 QC 字段的“可用语义”，要能支撑你两个导出脚本

你重点说的第二件事是：

> QC 字段不是装饰品，是 export\_station\_tag\_value\_staging.py 和 export\_station\_tag\_fallback\_feedback.py 的核心筛选条件。

结合前面的讨论，我给这 5 个字段一个 **V1 版的“工程可执行语义”** （偏保守，但能用）：

**字段回顾** （终表里）：

- `qc_value_has_meaning`
- `qc_is_wrong_cleaning`
- `qc_is_same_as_source`
- `qc_is_fallback_value`
- `qc_is_meaningless_non_fallback`

再加上我们已有的信息源：

- `store_tag_snapshot_di.evidence_state` ：
	- FOUND\_IN\_RAW / CONFIRMED → S1（直接用上游/区域/人工值）
	- INFERRED 等 → S2（我们算法改写 / 推断）
- `tag_enum.is_default=1` → 当期版本兜底枚举
- `target_value_*` + `enum_code` + `target_value_string_back`

我给一套 **明确、可写 SQL 的规则** ：

1） `qc_is_fallback_value` （是否兜底值）

> 终表值本身是不是“兜底枚举/兜底文案”？

- enum/bool 标签：
	- `qc_is_fallback_value = 1` 当且仅当：
		- 能在 `tag_enum` 找到 `(tag_code, enum_code)` ，且 `is_default=1 AND is_active=1` ；
- string 标签（目前我们的服务标签几乎都是 bool/enum，string 主要是 open\_hours）：
	- 暂不走 tag\_spec.fallback（避免多 join），先按枚举控制；
	- open\_hours 的兜底是 `'00:00-24:00'` ，但我们已经把它当“有意义值”处理（不是“未知”），所以不把它当 fallback。

2） `qc_value_has_meaning` （结果是否有实际业务意义）

> 这个结果拿去给运营看/给区域用，是否是“一个可用值”？

V1 规则：

- 有值（任一 target\_value\_bool/number/string 非空）；
- 且不是兜底值（ `qc_is_fallback_value = 0` ）。

即：

3） `qc_is_same_as_source` （是否与原始线上值相同）

你说的 staging 脚本要的是：

> “上报本来在线上是无意义或者兜底值，经过我们清洗有效后的数据”

严格来讲要对比“原始值 vs 最终值”，但当前我们在 snapshot 里：

- 并没有系统性保存“原始线上值三选一”，
- 有些标签有 `target_value_string_back` （例如 open\_hours 的决策前值），但统一不强。

在现有信息下， **V1 近似解** ：

- 对 `evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')` 的记录：
	- 视为“直接采用原始/区域值” → `qc_is_same_as_source = 1` ；
- 对 `evidence_state NOT IN ('FOUND_IN_RAW', 'CONFIRMED')` （例如 INFERRED）：
	- 一律认为“我们做了改写/推断” → `qc_is_same_as_source = 0` 。

对应 staging 脚本想捞的是：

→ “原始没用 / 我们改写成有意义”的候选集。  
后面如果你在 snapshot 里加原始值字段，我们再把规则升级成“严格对比值”。

4） `qc_is_wrong_cleaning` （是否疑似错误清洗）

你强调“不能不算”，那我们给一个 **偏保守的“只标红明确异常”的规则** ：

- “算法介入了，但依然得到了无意义非兜底结果” → 高度可疑：

其它情况全部 0。

这些样本，就是 export\_station\_tag\_fallback\_feedback.py 非常值得下发的“疑难杂症”：

- 我们算法已经试过，但依然给不出有意义值；
- 且不是“明牌兜底”；
- 很可能要区域人工判断 / 修复。

5） `qc_is_meaningless_non_fallback` （无意义 & 非兜底）

> 我们对“无值”的进一步分类，用于后续精细筛选。

- `qc_is_meaningless_non_fallback = 1` 当且仅当：
	- 所有 target\_value\_\*\*\* 都 NULL；
	- 且 `qc_is_fallback_value = 0` 。

这样就有：

- “无值 + 兜底” → qc\_is\_fallback\_value=1（经典 unknown）；
- “无值 + 非兜底” → qc\_is\_meaningless\_non\_fallback=1（异常情况）。

汇总一下 V1 关系：

- 分子（覆盖率）： `qc_value_has_meaning=1 AND qc_is_fallback_value=0` ；
- staging 导出： `qc_value_has_meaning=1 AND qc_is_same_as_source=0` ；
- 兜底反馈： `qc_value_has_meaning=0 AND (qc_is_fallback_value=1 OR qc_is_wrong_cleaning=1 OR qc_is_meaningless_non_fallback=1)` 。

这套规则 **在现有字段下能完整落地，不需要额外表结构** 。

#### 2.3 基于这两个修正，重写 Step6 的 TODO & SQL

你说“我们重新来做这个部分 todo 拆解”，我按“目标→逻辑→落表”来拆一遍：

**Step6 总目标（这轮只做 7 个标签）：**

- 从 `store_tag_snapshot_di` 把这 7 个标签迁到 `station_tag_target_value` ；
- 按上面 V1 规则填齐 5 个 QC 字段；
- 提供能支撑覆盖率 + staging 导出 + fallback 反馈的结构。

**Step6-1：清理当日这 7 个标签在终表的旧记录**

- 避免重复插入；
- 范围只限：
	- `open_24h`, `open_hours`
	- `convenience_store_available`, `parking_available`, `restroom_available`
	- `service_carwash_available`, `service_carwash_type` 。

**Step6-2：从 snapshot 一次性 INSERT 到 station\_tag\_target\_value**

- 字段映射：和你预期的一致（store\_id/as\_of\_date/tag\_code + 三选一 + enum\_code/enum\_label + conf/ttl 等）；
- `source` / `closest_source` ：S1/S2；
- 5 个 QC 按 V1 规则计算。

**Step6-3：给你 3 条校验 SQL**

- ① 终表行数 vs snapshot 行数是否一致；
- ② 单标签覆盖率（非依赖），以 is\_trd\_30d=1 为分母；
- ③ 依赖型标签覆盖率（service\_carwash\_type），以“有洗车站”为分母。

---

### 3）修正版 Step6 SQL（只针对 7 个 snapshot 已有标签 + 新 QC 规则）

```sql
sql-- etl_tag_step6.1.station_tag_target_value_sync_from_snapshot
-- 统一将 snapshot 中已完工的 7 个标签落表到 station_tag_target_value，并补齐 QC 字段

/*********************************************
 * 0. 业务日期兜底
 *********************************************/
IF @biz_date IS NULL THEN
    SET @biz_date = (
        SELECT MAX(as_of_date) FROM store_tag_snapshot_di
    );
END IF;

/*********************************************
 * 1. 清理当日 7 个标签的旧记录
 *********************************************/
DELETE FROM station_tag_target_value
WHERE as_of_date = @biz_date
  AND tag_code IN (
        'open_24h',
        'open_hours',
        'convenience_store_available',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type'
  );

/*********************************************
 * 2. 从 store_tag_snapshot_di 写入 station_tag_target_value
 *********************************************/
INSERT INTO station_tag_target_value (
    store_id,
    as_of_date,
    tag_code,
    target_value_bool,
    target_value_number,
    target_value_string,
    enum_code,
    enum_label,
    source,
    evidence_state,
    ttl_days,
    reason,
    conf,
    upload_batch_id,
    closest_source,
    target_value_string_back,
    qc_value_has_meaning,
    qc_is_wrong_cleaning,
    qc_is_same_as_source,
    qc_is_fallback_value,
    qc_is_meaningless_non_fallback
)
SELECT
    CAST(s.store_id AS UNSIGNED)          AS store_id,
    s.as_of_date                          AS as_of_date,
    s.tag_code                            AS tag_code,
    s.target_value_bool                   AS target_value_bool,
    s.target_value_number                 AS target_value_number,
    s.target_value_string                 AS target_value_string,
    s.enum_code                           AS enum_code,
    e.enum_label                          AS enum_label,

    -- source / closest_source：S1 / S2
    CASE
        WHEN s.evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')
            THEN 'S1'
        ELSE 'S2'
    END                                   AS source,
    s.evidence_state                      AS evidence_state,

    s.ttl_days                            AS ttl_days,
    s.reason                              AS reason,
    s.conf                                AS conf,
    CONCAT('s_tag_etl_', DATE_FORMAT(s.as_of_date, '%Y%m%d'))
                                          AS upload_batch_id,
    CASE
        WHEN s.evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')
            THEN 'S1'
        ELSE 'S2'
    END                                   AS closest_source,

    s.target_value_string_back            AS target_value_string_back,

    /********** QC 字段计算 **********/

    -- 1) 是否兜底默认值（命中 tag_enum.is_default=1 & is_active=1）
    -- 这里先放到子表达式里，避免重复 CASE
    CASE
        WHEN e.tag_code IS NOT NULL AND e.is_default = 1
        THEN 1
        ELSE 0
    END                                   AS qc_is_fallback_value,

    -- 2) 结果是否有实际业务意义（有值且非兜底）
    CASE
        WHEN (s.target_value_bool   IS NOT NULL
           OR s.target_value_number IS NOT NULL
           OR s.target_value_string IS NOT NULL)
         AND NOT (e.tag_code IS NOT NULL AND e.is_default = 1)
        THEN 1
        ELSE 0
    END                                   AS qc_value_has_meaning,

    -- 3) 是否与原始值完全相同（V1：FOUND_IN_RAW/CONFIRMED 视作 same）
    CASE
        WHEN s.evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')
        THEN 1
        ELSE 0
    END                                   AS qc_is_same_as_source,

    -- 4) 是否错误清洗（V1：S2 且无意义且非兜底 → 可疑清洗）
    CASE
        WHEN s.evidence_state NOT IN ('FOUND_IN_RAW', 'CONFIRMED')
         AND (
             (s.target_value_bool   IS NULL
           AND s.target_value_number IS NULL
           AND s.target_value_string IS NULL)
             OR (e.tag_code IS NOT NULL AND e.is_default = 1)
         )
        THEN 1
        ELSE 0
    END                                   AS qc_is_wrong_cleaning,

    -- 5) 无意义且非兜底（无值 AND 非兜底）
    CASE
        WHEN (s.target_value_bool   IS NULL
           AND s.target_value_number IS NULL
           AND s.target_value_string IS NULL)
         AND NOT (e.tag_code IS NOT NULL AND e.is_default = 1)
        THEN 1
        ELSE 0
    END                                   AS qc_is_meaningless_non_fallback

FROM store_tag_snapshot_di s
LEFT JOIN tag_enum e
       ON e.tag_code  = s.tag_code
      AND e.enum_code = s.enum_code
      AND e.is_active = 1
WHERE s.as_of_date = @biz_date
  AND s.tag_code IN (
        'open_24h',
        'open_hours',
        'convenience_store_available',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type'
  );

/*********************************************
 * 3. 校验查询（自然编号）
 *********************************************/

-- 1）校验1：snapshot vs 终表，各标签门店数是否一致（考虑依赖型标签 carwash_type）
SELECT
    '1'                                   AS check_id,
    'snapshot_vs_station_row_cnt'         AS check_name,
    s.tag_code,
    COUNT(DISTINCT s.store_id)            AS snapshot_store_cnt,
    COUNT(DISTINCT t.store_id)            AS station_store_cnt
FROM store_tag_snapshot_di s
LEFT JOIN station_tag_target_value t
       ON t.store_id   = s.store_id
      AND t.as_of_date = s.as_of_date
      AND t.tag_code   = s.tag_code
WHERE s.as_of_date = @biz_date
  AND s.tag_code IN (
        'open_24h',
        'open_hours',
        'convenience_store_available',
        'parking_available',
        'restroom_available',
        'service_carwash_available',
        'service_carwash_type'
  )
GROUP BY s.tag_code;

-- 2）校验2：服务标签（示例：restroom_available）覆盖率，以 is_trd_30d=1 为分母
SELECT
    '2'                                         AS check_id,
    'coverage_restroom_available'              AS check_name,
    COUNT(DISTINCT CASE
        WHEN v.is_trd_30d = 1 THEN v.store_id END
    )                                          AS denom_store_cnt,
    COUNT(DISTINCT CASE
        WHEN v.is_trd_30d = 1
         AND t.qc_value_has_meaning = 1
         AND t.qc_is_fallback_value = 0
        THEN v.store_id
    END)                                       AS num_store_cnt
FROM v_merchant_profile_latest_di v
LEFT JOIN station_tag_target_value t
       ON t.store_id   = v.store_id
      AND t.as_of_date = @biz_date
      AND t.tag_code   = 'restroom_available'
WHERE v.dt = DATE_FORMAT(@biz_date, '%Y-%m-%d');

-- 3）校验3：依赖型标签 service_carwash_type 覆盖率，以“有洗车站”为分母
SELECT
    '3'                                         AS check_id,
    'coverage_service_carwash_type'            AS check_name,
    COUNT(DISTINCT CASE
        WHEN avail.enum_code = '1'
        THEN avail.store_id
    END)                                       AS denom_store_cnt,
    COUNT(DISTINCT CASE
        WHEN avail.enum_code = '1'
         AND type_t.qc_value_has_meaning = 1
         AND type_t.qc_is_fallback_value = 0
        THEN avail.store_id
    END)                                       AS num_store_cnt
FROM station_tag_target_value avail
LEFT JOIN station_tag_target_value type_t
       ON type_t.store_id   = avail.store_id
      AND type_t.as_of_date = avail.as_of_date
      AND type_t.tag_code   = 'service_carwash_type'
WHERE avail.as_of_date = @biz_date
  AND avail.tag_code   = 'service_carwash_available';
```

---

### 4）迭代日志

- **来源**
	- 你指出两个关键问题：  
		1） `store_tag_snapshot_di` 目前只有 7 个标签，不能“嘴上说所有 A 类标签都迁”；  
		2）QC 字段必须有明确、可用于下游导出脚本的语义，不能简单全 0。
- **本轮改动点**
	1. 收紧 Step6 迁移范围到 snapshot 已完工的 7 个标签，其他标签留待后续补链路；
	2. 为 5 个 QC 字段给出一组 V1 规则（基于 evidence\_state + enum 兜底 + 有无值），可以支持：
		- 覆盖率分子计算；
		- staging 导出“我们改写过且有意义”的数据；
		- fallback 反馈导出“兜底/疑似清洗错误/无意义”的数据；
	3. 重写终表迁移 SQL + 给出 3 条自然编号的校验 SQL。
- **下一步建议**
	1. 你在 dev 环境照顺序跑：
		- 设置 @biz\_date（或让 SQL 自动兜底）；
		- 执行整个 Step6 脚本；
		- 运行校验 1/2/3 看结果是否满足你对这 7 个标签的直觉。
	2. 如果数看起来合理，我们下一步可以：
		- 基于终表 + tag\_algo\_config 抽象出一个 `tag_coverage_by_tag` 视图，把这 7 个标签的覆盖率一次性算出来；
		- 然后再回头对“QC 字段 + 导出脚本”做专门一轮设计，让 export\_station\_tag\_value\_staging.py / export\_station\_tag\_fallback\_feedback.py 直接站在这套 QC 语义上工作。

你先跑一轮这版 Step6，有任何异常（比如 QC 分布怪、覆盖率太离谱等），我们再一起对着具体查询结果微调规则。

20251209\_0230\_整体标签上游接入规划\_V1

tags: #station\_tag\_target\_value #store\_tag\_snapshot\_di #标签全覆盖 #S1S2管道 #项目卡点

---

### 1）一句话结论

要把“覆盖率/准确率”从局部样板变成全局能力，接下来核心不是再多写几条 SQL，而是：按统一范式把所有标签都接入 S1/S2 管道（至少 S1 级别），全部落到 `store_tag_snapshot_di → station_tag_target_value` ，并围绕这个目标识别清楚 3 类卡点：数据输入、算法定义、工程能力。

---

### 2）三段论据

#### 2.1 现状：我们已经有了“闭环样板”，但只覆盖了 7 个标签

目前这条从上游到终表的链路， **在 open\_24h / open\_hours + 服务标签家族上是跑通的** ：

- 上游统一入口： `v_merchant_profile_latest_di`
	- 已有营业时间、部分服务设施、生命周期等 DW 字段；
- 中间层：
	- 三层特征快照（store / merchant / party）；
	- open\_hours\_candidate\_di（三层候选 + conf）；
	- 决策器（门店优先 + 跨层权重）；
- 决策快照： `store_tag_snapshot_di`
	- 对这 7 个标签（open\_xx + service\_xxx）已经是“最终决策值”；
- 终表： `station_tag_target_value`
	- 结构、QC 字段、coverage\_scope/coverage\_numerator 口径都已经定义清楚；
	- open\_xx + 服务标签已经能走完 S2 → 终表 → 覆盖率统计。

问题在于：

- 其他标签（brand\_xxx、store\_life、competitive\_overlap、sme\_\*、wyc\_pricing\_enabled 等）
	- 有的只在 DW/视图里（S1 有，但没进 snapshot / 终表）；
	- 有的逻辑在另一个系统里跑（你本地算好再同步数仓）；
	- 有的 S2 算法根本还没设计。

所以你现在的直觉是对的：

> “全量的计算才有价值” = 至少要做到： **所有标签都出现在终表里、能算 coverage** 。  
> 现在只接入了 7 个标签，整体 coverage 报表只能算是局部试点。

#### 2.2 策略：把“接入终表”拆成两个层次目标（先 S1 全覆盖，再 S2 提升）

想一次性“所有标签都有 S2 算法”会直接把项目压垮。更稳的路径是两层目标：

1） **Level 1：S1 全接入（终表维度全覆盖）**

目标：让 **所有 tag\_code** 至少有一条“忠实反映现在 DW/区域结果”的 S1 流程，跑进：

- `store_tag_snapshot_di` （只复制 S1 值，不做复杂推断）；
- `station_tag_target_value` （写入终表 + 基础 QC + coverage\_scope）。

只要做到这一层：

- 你就能给老板一张“ **当前真实世界的标签覆盖率基线** ”：
	- 哪些标签本来就接近 90%；
	- 哪些标签 DW 侧/区域上报严重缺失，连 50% 都不到；
- 后面所有 S2 算法，都是“在这个基线上做提升”，而不是盲人摸象。

这层的关键动作：

- 对每个 tag\_code，在 `tag_algo_config` 中先明确：
	- `algo_mode = 'WAREHOUSE_DIRECT'` 或 `'EXTERNAL_SYNC'` ；
	- `warehouse_source_view / field` 或 “外部同步表/字段”；
- 为这类标签写一个“超薄版 snapshot 逻辑”：
	- 直接从 DW/视图把 value 三选一拷贝到 `store_tag_snapshot_di` ， `evidence_state='FOUND_IN_RAW'` ；
- 然后复用我们刚搭好的 Step6，把它们落入终表。

这一步 **不需要新算法，只需要梳理字段映射 + 填清 config** 。

2） **Level 2：S2 精细提升（双 90 真正靠它）**

等 Level 1 做完，你会发现：

- 有些标签（例如：部分运营类标签）天然 coverage 已经很高；
- 有些标签（例如：营业时间、设施情况、竞争关系）DW 覆盖很一般，需要我们用行为和推断补洞；

这时候再选 **A 类 + P0 标签** 做 S2：

- 样板就是我们现在的 open\_24h/open\_hours + 服务标签；
- 对每个选中的标签，在 `tag_algo_config` 写清：
	- `algo_mode = 'DERIVED' / 'HYBRID'` ；
	- `rule_template` 指向具体逻辑；
	- `derived_source_tags` 指明依赖谁；
- 在 snapshot 层按“决策器”组合：
	- S1 和 S2 的冲突解决（谁优先、何时 override）；
	- conf / evidence\_state / reason 的维护。

**总结一下策略** ：

> 先做到： **所有标签都有 S1，全部出现在终表里** ；  
> 再做到： **重要标签有 S2，coverage 拉升到 90%+** 。

这也回答了“现在卡点在哪儿”：很多标签连 Level 1 都没上车。

#### 2.3 卡点与要素：现在缺的不是 SQL，而是这 4 类“资产”

从你现在的项目状态看，要把“全标签接入终表”跑起来，卡点主要是这 4 块：

1） **标签分类与责任归属还没完全固化**

我们在对话里大致讨论了 A/B 类、部分标签的来源；但要动全盘，需要一张更正式的“标签责任矩阵”：

- 每个 tag\_code 明确：
	- 归属业务条线（owner\_biz）；
	- 数据 owner（owner\_data：DW、你这边 local、区域等）；
	- 算法模式（WAREHOUSE\_DIRECT / DERIVED / HYBRID / EXTERNAL\_SYNC）；
	- 是否必须接入 S2（A & P0）。

**你缺的是：一张对齐到老板的“标签分层责任表”，放进总控文档。**

2） **上游字段接入不完全（尤其 B 类和外部系统字段）**

很多 B 类标签“逻辑已经在数仓算好了”，但有几个现实问题：

- 不一定都已经集中到 `v_merchant_profile_latest_di` ；
- 有些是你本地另一个系统算好再同步，但视图中未统一口径。

要 S1 全接入，上游必须满足：

- 每个 tag\_code，在某个 **单一可信视图** 里，有一组清晰字段：
	- value 三选一 / enum\_code / as\_of\_date；
- 或者至少你能稳定找到 DW 表 + join 规则。

**这块需要你拉一次“DW/数据同学对齐会”：**

- 把 A/B 标签逐个对，看：
	- 哪些已在 `v_merchant_profile_latest_di` ；
	- 哪些只在单独 DW 表，还没进视图；
	- 哪些压根没有 S1，需要你这边或区域新增。

3） **算法定义的“配置化资产”刚起步，还没全覆盖**

`tag_algo_config` 现在对 open\_xx / 服务标签 / sme 系列已经有了比较规范的 JSON，但对其余标签：

- 有些连 algo\_mode 都没写清；
- coverage\_scope 也没完全配；
- 没有统一的 rule\_template 约定（比如 brand\_level\_from\_dw\_v1）。

要让全标签能“一键接入”，你需要：

- 针对全量 tag\_code，把 algo\_config 至少补到 Level 1：
	- `algo_mode` 、 `warehouse_source_view/field` 、 `coverage_scope` 、 `coverage_numerator` ；
- 然后才有可能用“一套通用 SQL 模版”把 snapshot → station\_tag\_target\_value 做成可复用的。

4） **工程节奏与演进策略**

如果你试图“一次性为所有标签写 snapshot + 迁移”，一定会炸：

- 你一个人要维护几十段 SQL，后续每改一个字段都很痛苦；
- 与 DW/区域的协调成本会爆炸。

更现实的节奏：

- 先选一条主线：
	- 比如先把“基础合作 + 站内服务 + 生命周期”这 3 个一级类目全部接入；
- 对每个标签：
	- 先只做 S1 snapshot（WAREHOUSE\_DIRECT），用统一模板写；
	- 接入终表后，让覆盖率报表先跑起来；
- 再按优先级补 S2：
	- 营业时间 + 服务标签已经做了；
	- 下一个批次可以是 brand\_name/brand\_level/store\_life/competitive\_overlap。

---

### 3）思维导图结构（文本分层）

1. 目标：全标签“接入终表”  
	1.1 station\_tag\_target\_value 成为唯一出口  
	1.2 覆盖率/准确率基线可视化  
	1.3 S2 提升效果可量化
2. 当前可用资产  
	2.1 open\_24h / open\_hours / 服务标签：S2 端到端打样完成  
	2.2 store\_tag\_snapshot\_di：这 7 个标签已是“最终决策值”  
	2.3 station\_tag\_target\_value：结构 + QC + coverage\_scope 已经设计完成  
	2.4 tag\_algo\_config：已有若干规范样板（WAREHOUSE\_DIRECT / DERIVED）
3. 策略分层  
	3.1 Level 1：S1 全接入  
	\- 给每个标签一个 WAREHOUSE\_DIRECT 或 EXTERNAL\_SYNC 的配置  
	\- 写 ultra-thin snapshot job 把 S1 值写进 store\_tag\_snapshot\_di  
	\- 统一迁移到 station\_tag\_target\_value  
	3.2 Level 2：S2 精细提升  
	\- 只选 A & P0 标签做算法  
	\- 用 open\_xx + 服务标签样板复制三层特征 + 决策器  
	\- 在 snapshot 替换或增强 S1 值  
	3.3 持续治理  
	\- 覆盖率报表驱动优先级（先救坑最深的标签）  
	\- merchant\_feedback\_stats + CSV 导出闭环
4. 项目卡点  
	4.1 标签责任矩阵不完整（谁负责算 / 谁有 S1 / 谁要 S2）  
	4.2 上游视图不统一（tag 对应字段分散在多张 DW 表或外部系统）  
	4.3 algo\_config 未全覆盖（很多标签缺 algo\_mode/coverage\_scope）  
	4.4 工程节奏风险（一口吃太多标签）
5. 建议的推进顺序  
	5.1 先补一张“全量标签责任 & 来源”表，写入总控文档  
	5.2 和 DW 对齐：确保 A/B 标签都有明确 S1 来源字段  
	5.3 用统一模板为所有标签补齐 tag\_algo\_config Level 1 配置  
	5.4 批次化接入 snapshot & station\_tag\_target\_value（按一级类目分批）  
	5.5 覆盖率报表跑起来后，按数据结果决定下一批 S2 投入

---

### 4）迭代日志

- **来源**
	- 你肯定了 Step6 的方向，但指出：“全指标才有意义”，而现在只接入了 7 个标签；
	- 同时强调这轮更重要的是对齐框架和逻辑，而不是继续堆 SQL。
- **本轮改动点**
	1. 明确了“现在跑通的是样板，而不是全量”：
		- 终表和 QC 设计没问题，缺的是 **全标签接入 S1/S2 管道** ；
	2. 把“接入终表”拆成两个层次：
		- Level 1：S1 全接入（所有标签至少有 DW 直出的 snapshot & 终表记录）；
		- Level 2：S2 精细提升（只对重要标签设计算法提高 coverage）；
	3. 梳理出当前 4 类关键卡点：责任矩阵、上游字段统一、algo\_config 全覆盖、工程节奏。
- **下一步建议（你可以直接选一个方向让我具体落地）**
	如果你愿意，我建议下一轮做这件事之一：
	1. **一起整理“标签责任 & 来源表”的结构模版** ：
		- 我给你一个表头设计（适合放进总控文档/CSV）；
		- 你填几行样例（brand/open/store\_life/competitive），我们一起快速 iterate。
	2. 或者： **直接从 A 类标签开始，设计 Level 1 的 snapshot 模板** ：
		- 我不写具体 SQL，只梳理一个“任意标签接入 snapshot 的 checklist”；
		- 你按 checklist 自评哪些标签可以马上接 / 哪些还缺字段或对齐。

选哪条路，你只要说“先干 1”或“先干 2”，我就按那个方向推到可执行级别。

20251209\_0315\_标签ETL\_双90\_承上启下Prompt\_V1  
tags: #商户画像 #标签ETL #station\_tag\_target\_value #覆盖率 #QC

---

### 1）一句话结论

下面这段 Prompt 是对当前整条“标签双90”ETL 的完整压缩版：从上游视图 → 三层特征 → S1/S2 → snapshot → station\_tag\_target\_value → QC → 覆盖率口径 → 下一步待做事项，都写清楚了，你可以直接在新对话框里粘贴，让模型无缝续上现在的工作。

---

### 2）三段论据

#### 2.1 现状与问题：我们已经有“样板链路”，但还不是“全标签工程”

- 已经跑通的链路（从 S1 到终表）主要集中在：
	- `open_24h` / `open_hours` （营业时间家族）；
	- 服务标签 5 个： `convenience_store_available`, `parking_available`, `restroom_available`, `service_carwash_available`, `service_carwash_type` 。
- 这些标签已经走完：
	- 上游统一入口： `v_merchant_profile_latest_di` ；
	- S1/S2 算法与决策；
	- store 级决策快照： `store_tag_snapshot_di` ；
	- 终表： `station_tag_target_value` ；
	- QC 字段的 V1 语义 + 覆盖率口径（分母/分子逻辑）。
- 但其他标签（brand\_xxx、store\_life、competitive\_overlap、sme\_\*、wyc\_pricing\_enabled 等）还没有统一接入 snapshot/终表，覆盖率只能算“局部样板”，离“全标签双90”还有一段路。

在新对话中，需要让模型先“完整读取我们已经打好的骨架”，再帮你系统性地把剩余标签接入这条链路，而不是从头再发明一套。

#### 2.2 关键逻辑：完整承上启下 Prompt（可直接复制到新对话）

> 下面这段是你要复制到新对话里的 Prompt 正文。

```markdown
text【角色与目标】

你现在扮演一名「互联网业务策略顾问 + 增长产品经理 + 数据分析负责人」，专注于“商户画像标签 ETL + 双 90%（覆盖率 & 准确率）”项目。

我的最终目标：  
- 面向约 1.6 万动销油站，为一组核心标签（品牌、生命周期、营业时间、服务设施、竞争关系等），  
- 在统一 ETL 管道下，把「标签覆盖率 & 准确率」都拉到 ≥ 90%，  
- 并通过 \`station_tag_target_value\` 作为唯一出口，支撑：  
  - 数仓入仓 &报表  
  - 区域校验反馈  
  - 线上标签投放&运营。

本轮新对话开始时，你要完整继承以下“既有共识和工程骨架”，在此基础上继续往前推。

--------------------------------
【一、核心数据表与分层设计】
--------------------------------

1. 上游统一入口视图：\`v_merchant_profile_latest_di\`

- 粒度：store（油站）；  
- 关键字段（只列与标签 ETL 高相关的）：  
  - 主键 & 基础维度：\`store_id\`, \`merchant_id\`, \`party_key\`, \`dt\`；  
  - 动销标记：\`is_trd_30d\`（近 30 天有交易）；  
  - 营业时间相关：\`is_zxgj\`（诸如 06-22 这样的字段）、\`open_hours_raw\`（上游原始文案/区间）；  
  - 服务标签初始结果：  
    - \`convenience_store_available\`（是否有便利店，DW/区域上报结果）；  
    - \`parking_available\`（是否有停车位）；  
    - \`restroom_available\`（是否有卫生间）；  
    - \`service_carwash_available\`（是否有洗车）；  
    - \`service_carwash_type\`（洗车类型，DW 结果）；  
  - 运营标签原始值（brand_name, brand_level, store_life, competitive_overlap, sme_supplier[_partner], wyc_pricing_enabled 等）——有些在我本地算好再同步，但在视图中已经有值；  
  - 行为特征：\`order_cnt_30d\`（近 30 天订单数）、\`is_agg_blocked_merchant\` 等。

2. 中间特征层（特征快照 / 候选 / 决策）

- \`store_feature_snapshot_di\`  
  - 粒度：store_id + as_of_date；  
  - 存放门店级行为特征（如 30 天订单分布、早晚订单、is_zxgj 拆解结果等）；  

- \`merchant_feature_snapshot_di\` / \`party_feature_snapshot_di\`  
  - 粒度：merchant_id / party_key + as_of_date；  
  - 由门店聚合而来，用于三层特征（门店/商户/工商）打分和聚合。  

- \`open_hours_candidate_di\`  
  - 粒度：store_id / merchant_id / party_key + as_of_date + tag_code=open_hours；  
  - 存三层候选区间（如 "06:00-22:00"）及 conf_store/conf_merchant/conf_party；  
  - 决策逻辑：  
    - 如果 conf_store ≥ 阈值（来自 tag_algo_config）→ 直接用门店；  
    - 否则在 merchant/party 间按 conf×weight 选最大；  
    - 再叠加 D1 规则（例如 06 点前/20 点后有订单 → 00:00-24:00）；  
    - 得到 chosen_level + chosen_range。  

3. store 级标签快照：\`store_tag_snapshot_di\`

- 粒度：\`store_id, as_of_date, tag_code\`；  
- 含字段：  
  - target_value_bool / target_value_number / target_value_string（三选一协议：有且仅有一个非空）；  
  - enum_code（若有枚举）；  
  - evidence_state（FOUND_IN_RAW / INFERRED / CONFIRMED 等）；  
  - conf, ttl_days, reason, algo_version, target_value_string_back 等；  
- 当前已经“算完并写入”的标签（非常关键）：  
  - \`open_24h\`  
  - \`open_hours\`  
  - \`convenience_store_available\`  
  - \`parking_available\`  
  - \`restroom_available\`  
  - \`service_carwash_available\`  
  - \`service_carwash_type\`  
- 统计结果（示例，说明现状）：  
  - 对 2025-12-05：  
    - open_24h / open_hours / 便利店 / 停车 / 卫生间 / 洗车有无 —— 16246 家站均有决策记录；  
    - service_carwash_type —— 4127 家站有类型（覆盖的是“有洗车站”的子集）。  

4. 终表：\`station_tag_target_value\`（双 90 的唯一出口）

结构（简化版）：  

- 主键：\`store_id, as_of_date, tag_code\`；  
- 三选一值：  
  - \`target_value_bool\` / \`target_value_number\` / \`target_value_string\`（有且仅有一个非空）；  
- 枚举：  
  - \`enum_code\`（英文/数字 enum code）  
  - \`enum_label\`（中文展示，对齐 tag_enum）；  
- 来源 & 算法：  
  - \`source\`（例如 S1/S2）  
  - \`evidence_state\`（FOUND_IN_RAW/INFERRED/CONFIRMED）  
  - \`conf\`, \`ttl_days\`, \`reason\`, \`algo_version\`, \`upload_batch_id\`, \`closest_source\`  
  - \`target_value_string_back\`（如 open_hours 原始决策区间）  
- QC 字段（质检 & 后续导出要用）：  
  - \`qc_value_has_meaning\`        （结果是否有实际业务意义）  
  - \`qc_is_wrong_cleaning\`        （是否疑似错误清洗）  
  - \`qc_is_same_as_source\`        （是否与原始线上/上游值完全相同）  
  - \`qc_is_fallback_value\`        （是否兜底默认值）  
  - \`qc_is_meaningless_non_fallback\`（无意义且非兜底的异常值）  

我们已经完成了：  
- \`store_tag_snapshot_di → station_tag_target_value\` 的统一迁移逻辑（先只覆盖上述 7 个标签），  
- 并且给 5 个 QC 字段定义了明确的 V1 语义（见下）。  

--------------------------------
【二、标签语义与算法共识】
--------------------------------

1. 三选一协议（终表 & snapshot）

- 每条记录：\`target_value_bool / number / string\` 有且仅有一个非空，其余为 NULL；  
- 任意算法/SQL 在写入时，必须自觉遵守此约束；  
- 枚举/布尔类标签：通常占用 \`target_value_bool\` 或 \`target_value_string\` 搭配 \`enum_code\`。  

2. 兜底值规范（新规则，禁止 hard-code '99'）

- 兜底语义的来源：  
  - tag_spec.fallback —— 定义“兜底值”的业务语义；  
  - 对 enum/bool 标签：当前有效的兜底枚举值统一这样取：  
    \`\`\`sql
    SELECT enum_code
    FROM tag_enum
    WHERE tag_code   = :tag_code
      AND is_default = 1
      AND is_active  = 1;
    \`\`\`  
  - 对 string 标签：兜底文本直接看 \`tag_spec.fallback\`；  
- 禁止行为：  
  - 代码中不可再写死 \`'99'\` 表示兜底；  
  - 是否兜底必须通过 tag_enum.is_default / tag_spec.fallback 来判断。  

3. open_24h / open_hours 规范（A 类标杆标签）

- \`open_24h\`：  
  - value_type=bool → 写入 \`target_value_bool\`（0/1）；  
  - 枚举：enum_code ∈ {'0','1','99'}，\`'99'\` 为 unknown 兜底（通过 tag_enum 标记 is_default=1）；  
  - 三选一：只有 target_value_bool 非空；  
  - evidence_state：FOUND_IN_RAW（上游给定）或 INFERRED（通过订单分布/D1 规则推断）；  
  - algo_version：\`open_24h_v1\`。  

- \`open_hours\`：  
  - value_type=string → 写 \`target_value_string\`，格式统一 \`HH:MM-HH:MM\`；  
  - 与 open_24h 强一致：  
    - 若 open_24h=1，则 final_range 强制为 \`'00:00-24:00'\`；  
    - \`target_value_string_back\` 保留“原始决策区间”（不受 24h 覆盖影响）；  
  - 无合法区间时：enum_code 用兜底（tag_enum default / tag_spec.fallback），但我们在 coverage 中不把兜底算进分子；  
  - algo_version：\`open_hours_v2\`。  

4. 服务标签家族逻辑（已完成 S1/S2）  

- \`convenience_store_available\`（是否有便利店，A）：  
  - S1：DW/视图直接给的布尔/枚举值；  
  - S2：利用结构特征（\`dim_gas_store_info_extend.additional_services\` 包含“便利店”）+ 行为特征（订单>一定阈值且品牌）补洞；  
  - 覆盖率对于“近 30 天动销站”分母已经有明显提升。  

- \`parking_available\`（是否有停车位，B 偏基础）：  
  - S1：DW 原始结果；  
  - S2：目前采用“汽油站默认能停车”的极简假设，只对 S1 缺失 / 兜底的样本补 TRUE，不覆盖显式 FALSE；  
  - 后续预留能力，用“地址 → 城市/郊区”再区分真/假。  

- \`restroom_available\`（是否有卫生间，A）：  
  - S1：DW 原始结果；  
  - S2：  
    - additional_services 中含卫生间（码 0）；  
    - 或 convenience_store_available=1；  
  - 逻辑上“有便利店基本就有厕所”，这部分被视作派生补全。  

- \`service_carwash_available\`（是否有洗车，C）：  
  - S1：DW 原始数据，目前你环境中几乎全站 FOUND_IN_RAW，S2 补洞数为 0；  
  - S2：预留结构补洞逻辑：additional_services 中含“洗车”（码 1）时可补 TRUE。  

- \`service_carwash_type\`（洗车类型，C）：  
  - 强依赖 \`service_carwash_available\`：只有 available=1 才有类型；  
  - 枚举（tag_enum）：\`machine\`（机洗）、\`manual\`（人工）、\`none\`（无）等；  
  - S1：从 v_merchant_profile_latest_di 映射到 tag_enum（支持 code/label）；  
  - S2：  
    - 当 \`service_carwash_available=1\` 且 type 缺失/兜底时，默认补 \`machine\`；  
    - 不会覆盖 S1 给出的非兜底值（例如 manual/none）；  
  - 覆盖率分母 = “有洗车站数”；  
  - extra_config_json 中：  
    - \`"coverage_scope": {"type":"DEPEND_ON_TAG","dep_tag_code":"service_carwash_available","dep_enum_in":["1"]}\`  
    - \`"derived_is_derived":1, "derived_source_tags":["service_carwash_available"]\`。  

5. 其它标签与依赖关系（coverage_scope 已定义）

当前标签全集（至少包括）：  

- brand_level（B）、brand_name（A）、competitive_overlap（A）、is_ka_direct（A）、store_life（B）、wyc_pricing_enabled（B）、sme_supplier（A）、sme_supplier_partner（A）。  

依赖关系（用于 coverage_scope）：  

- 无依赖标签（分母=近30天动销站 is_trd_30d=1）：  
  - brand_level / brand_name / competitive_overlap / convenience_store_available / is_ka_direct / open_24h / open_hours / parking_available / restroom_available / service_carwash_available / sme_supplier_partner / store_life / wyc_pricing_enabled。  

- 有依赖标签：  
  - service_carwash_type 依赖 service_carwash_available=1；  
  - sme_supplier 依赖 sme_supplier_partner=1；  

这些关系已经写入 \`tag_algo_config.extra_config_json.coverage_scope\` 中。  

--------------------------------
【三、tag_algo_config 与覆盖率口径】
--------------------------------

1. \`tag_algo_config\` 表结构核心字段

- \`tag_code, algo_version\`（主键）；  
- \`conf_threshold_store, enable_merchant_level, min_merchant_data_ratio, ...\`（算法阈值与层级权重）；  
- \`extra_config_json\` —— 半结构化字段，承载：  
  - 算法形态：\`algo_mode\`（WAREHOUSE_DIRECT / DERIVED / HYBRID / EXTERNAL_SYNC）；  
  - 规则模板：\`rule_template\`（如 \`OPEN_HOURS_FROM_IS_ZXGJ_AND_ORDERS_V2\`）；  
  - 派生信息：\`derived_is_derived\`, \`derived_source_tags\`；  
  - 上游视图：\`warehouse_source_view\`, \`warehouse_source_field\`；  
  - D1 配置：\`d1_enabled\`, \`window_days\`；  
  - 覆盖率定义：  
    - \`coverage_scope\`:  
      - \`{"type":"ACTIVE_STORE_30D"}\` 或  
      - \`{"type":"DEPEND_ON_TAG","dep_tag_code":"XXX","dep_enum_in":["1",...]}\`
    - \`coverage_numerator\`:  
      - \`{"exclude_fallback":true,"require_has_meaning":true}\`  

2. 覆盖率口径（Q1–Q4 已统一）  

- Q1 适用范围（Denominator Scope）：  
  - \`ACTIVE_STORE_30D\`：  
    - 分母 = \`v_merchant_profile_latest_di\` 中 \`is_trd_30d = 1\` 的 store 数；  
  - \`DEPEND_ON_TAG\`：  
    - 分母 = 依赖标签（dep_tag_code）在 \`station_tag_target_value\` 中“有意义 & 非兜底 & enum_code ∈ dep_enum_in”的 store 集合大小（例如有洗车、合作中小供给站）；  

- Q2 “有意义值”定义：  
  - 在终表上：  
    - 有值（任一 target_value_* 非空）；  
    - 且非兜底（\`qc_is_fallback_value=0\`）；  
    → \`qc_value_has_meaning=1\`。  

- Q3 兜底识别：  
  - enum/bool 标签：通过 \`tag_enum.is_default=1 & is_active=1\`；  
  - string 标签：后续通过 \`tag_spec.fallback\`；  
  → 在终表上：\`qc_is_fallback_value=1\`。  

- Q4 分母/分子：  
  - 分母：按 coverage_scope 产生 applicable_store_cnt；  
  - 分子：\`qc_value_has_meaning=1 AND qc_is_fallback_value=0\` 的 store 数；  
  - 单标签覆盖率：\`coverage_ratio = num / denom\`；  
  - 整体 A 类覆盖率：对标签×站点 cell 做加总。  

--------------------------------
【四、终表 QC 字段的 V1 语义与导出用途】
--------------------------------

当前我们在 \`station_tag_target_value\` 中约定如下 QC 规则（V1，可迭代，但新对话必须继承）：  

1. \`qc_is_fallback_value\`  

- =1 当且仅当：  
  - 在 tag_enum 能找到 \`(tag_code, enum_code)\` 且 \`is_default=1 AND is_active=1\`；  
- enum/bool 标签兜底完全由 tag_enum 决定，不再写死 \`'99'\`。  

2. \`qc_value_has_meaning\`  

- =1 当且仅当：（有值 AND 非兜底）  
  - \`(target_value_bool IS NOT NULL OR number IS NOT NULL OR string IS NOT NULL)\`  
  - 且 \`qc_is_fallback_value=0\`；  

3. \`qc_is_same_as_source\`  

- V1 近似规则：  
  - \`evidence_state IN ('FOUND_IN_RAW', 'CONFIRMED')\` → 视作 same（1）；  
  - 其它（如 INFERRED）→ 视作改写（0）；  
- 用途：  
  - staging 导出脚本想找的是“原始线上值无意义/兜底，但我们清洗成有意义”的样本，  
  - 可通过：\`qc_value_has_meaning=1 AND qc_is_same_as_source=0\` 近似获得。  

4. \`qc_is_wrong_cleaning\`  

- V1 明确标红“算法已介入但结果仍疑似无意义”的情况：  
  - \`evidence_state NOT IN ('FOUND_IN_RAW','CONFIRMED')\`（即 S2 介入）  
  - 且（无值 或 仍是兜底值）；  
- 这些样本非常适合作为 export_station_tag_fallback_feedback.py 的优先下发对象。  

5. \`qc_is_meaningless_non_fallback\`  

- =1 当且仅当：  
  - 所有 target_value_* 皆 NULL；  
  - 且 \`qc_is_fallback_value=0\`；  
- 表示“无意义且非兜底”的异常情况，用于进一步筛选问题样本。  

结合 QC 字段，两类导出脚本的大致筛选思路（给你做参考，新对话里可以展开成更具体的规则）：  

- \`export_station_tag_value_staging.py\` —— 导出“需要/可以直接上报数仓、替代上游兜底值”的记录：  
  - 典型过滤：  
    - \`qc_value_has_meaning=1\`  
    - \`qc_is_same_as_source=0\`  
    - \`qc_is_fallback_value=0\`  

- \`export_station_tag_fallback_feedback.py\` —— 导出“我们和线上都搞不定，需要区域人工校验”的记录：  
  - 典型过滤：  
    - \`qc_value_has_meaning=0\`  
    - AND (\`qc_is_fallback_value=1\` OR \`qc_is_wrong_cleaning=1\` OR \`qc_is_meaningless_non_fallback=1\`)  

--------------------------------
【五、我们已经完成了什么 & 下一步你要帮我做什么】
--------------------------------

1. 已完成（需要你继承的成果）

- 打样成功的完整链路：  
  - open_24h / open_hours（包括候选生成 / 三层决策 / 区间标准化 / 与 24h 强一致 / 三选一落表）；  
  - 服务标签 5 个（便利店、停车、卫生间、洗车有无、洗车类型）的 S1/S2 算法、store_tag_snapshot_di 决策结果；  
  - \`tag_algo_config\` 中对上述标签的算法配置 + coverage_scope/coverage_numerator；  
  - \`store_tag_snapshot_di → station_tag_target_value\` 的迁移逻辑 + QC 字段 V1 赋值规则；  
  - coverage 口径（适用范围/分母/分子）的统一方案。  

2. 当前卡点（你在新对话要先帮我解的题）

- 只有 7 个标签已经接入 snapshot + station_tag_target_value，其他标签还停留在“DW 已算好”或“另一个系统计算”的状态；  
- \`tag_algo_config\` 对全量标签的 algo_mode / warehouse_source_view/field / coverage_scope 虽有基础但尚未彻底统一；  
- 缺一张“全量标签责任 & 来源矩阵”（谁负责算、在哪算、是否需要 S2）；  
- 覆盖率报表目前只能在这 7 个标签上跑试点，需要扩展到全 A 标签才有战略价值。  

3. 下一步希望你在新对话里帮我做的事（优先级顺序）：

- Step 6.1：  
  - 帮我梳理一份「全量标签责任 & 来源矩阵」的结构模版（可以用表头+示例的方式）；  
  - 用这份矩阵把每个 tag_code 的：owner_biz / owner_data / algo_mode / warehouse_source_field / 是否需要 S2 / coverage_scope 等信息写清楚。  

- Step 6.2：  
  - 基于矩阵，先设计“Level 1：S1 全接入”的 snapshot 模板：  
    - 对于 WAREHOUSE_DIRECT / EXTERNAL_SYNC 标签，如何用统一 SQL 把 S1 值写进 \`store_tag_snapshot_di\`；  
    - 如何保证三选一协议 + evidence_state=FOUND_IN_RAW；  
    - 怎么与现有的 S2 决策不打架。  

- Step 6.3：  
  - 在现有 Step6（snapshot → station_tag_target_value + QC）的基础上，扩展迁移范围到**全部 S1 标签**；  
  - 帮我构建一个 \`tag_coverage_by_tag\` 视图：  
    - 能按 tag_code 输出 as_of_date / denom_store_cnt / num_store_cnt / coverage_ratio；  
    - 并且支持 ACTIVE_STORE_30D / DEPEND_ON_TAG 两种 coverage_scope。  

- Step 6.4：  
  - 结合 QC 语义，细化两类导出脚本的筛选逻辑（先写成 SQL/伪代码），确保：  
    - staging 导出的是“我们有自信可以直接上报覆盖率分子的值”；  
    - fallback 反馈导出的是“我们和上游都搞不定，需要区域判定”的样本。  

在新对话中，不要推翻以上共识，而是在这套骨架上迭代。所有新的建议 / SQL / 设计，都要保证：  
- 兼容当前 station_tag_target_value 结构与 QC 语义；  
- 遵守三选一协议 & 新兜底规范（tag_enum.is_default / tag_spec.fallback，禁止写死 '99'）；  
- 可以逐步扩展到“全标签 Level 1 接入 + 核心 A 标签 Level 2 覆盖率提升”。  

--------------------------------

（以上是承上启下的完整上下文，请你在新对话中默认这些都已经成立，不要重复问我要这些前提信息。）
```

#### 2.3 路径方案：新对话的工作节奏建议

在新对话里，你可以先让模型：

1. 用这份 Prompt 回顾整体骨架，然后优先帮你设计：
	- “全量标签责任 & 来源矩阵”结构；
	- “S1 全接入 snapshot”的通用 SQL 模板（逻辑优先，SQL 次之）。
2. 接着，再扩展 Step6 的终表迁移范围和 coverage 视图，让覆盖率变成 **全标签级别** ；
3. 最后，用 QC 字段 + coverage\_scope 把 staging 导出和 fallback 反馈两个 Python 脚本背后的逻辑结构化出来，做到“任何人看一眼 QC + 配置就知道这条记录该去哪条流”。

---

### 3）思维导图结构（文本分层）

1. 本次对话沉淀的核心资产  
	1.1 上游视图与三层特征快照设计  
	1.2 open\_24h/open\_hours + 五个服务标签的 S1/S2 完整链路  
	1.3 store\_tag\_snapshot\_di 与 station\_tag\_target\_value 的映射 & 三选一协议  
	1.4 tag\_algo\_config 的 algo\_config + coverage\_scope 约定  
	1.5 QC 五字段的 V1 语义与导出用途
2. 承上启下 Prompt 的主体内容  
	2.1 数据表与分层结构  
	2.2 标签语义与算法规范  
	2.3 覆盖率与 coverage\_scope/cov\_numerator 配置  
	2.4 QC 字段与两个导出脚本的关系  
	2.5 已完工范围 + 待接入标签 + 下一步任务列表
3. 下一阶段工作节奏  
	3.1 Level 1：所有标签 S1 接入 snapshot & station\_tag\_target\_value  
	3.2 Level 2：核心 A 标签 S2 算法优化，提升 coverage & accuracy  
	3.3 覆盖率视图 + 运维化文档 + 导出脚本逻辑固定

---

### 4）迭代日志

- 来源：
	- 你觉得当前对话窗口已经非常拥挤，希望把「所有关键链路 & 逻辑」打包成一段“承上启下 Prompt”，在新对话中继续推进双 90 目标。
- 本轮做了什么：
	- 把这整个长链路抽象为一个可复制的 Prompt，覆盖：数据层次、标签语义、S1/S2 算法、终表结构、QC 字段、覆盖率口径、导出用途、以及下一步的工程节奏。
- 下一步建议：
	- 直接复制我给你的代码块内容，到一个全新的 Chat 中开局；
	- 在新对话里，先说一句类似：“从 Level 1：所有标签 S1 接入 snapshot 开始，我们按你刚才那套节奏往下做”，然后我们就能够在那边继续细拆 TODO 和 SQL，而不再被这条长对话的历史拖累。