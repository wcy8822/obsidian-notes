**需要你反馈的 todo**：
**阶段 0：明确品牌标签业务目标（基础前提）**


1. 这个品牌标签的具体用途是什么?商户侧的基建,需要做标签建设
2. 最终标签结果将支撑哪些具体业务决策？做供给基本面的看清,做商户侧的策略的决策(比如费率/营销)
3. 计划的更新频率是？（每周 / 每月，动态更新,按自动识别逻辑做更新）

**阶段 1：数据源准入阶段需求对焦**

1. 实际涉及的数据源有哪些？（数据源配置表读取）
2. 每个数据源必须包含的字段是哪些？（store_id,pop_id,pop_name,brand_name）
3. 数据源的格式 / 类型是否有特殊要求？（数据源格式,xlsx,csv）
4. 数据源的存储路径 / 获取方式是？（数据源配置表读取））


**阶段 2：清洗转换阶段需求对焦**


1. 实际数据中，（store_id,pop_id,pop_name,brand_name） 存在哪些具体的 “脏数据” 问题？（例如：无乱码,都是）
2. 需要定义哪些具体的清洗规则？（有一个数据字典）
3. 是否需要保留原始值与清洗值的对应关系？（需要，保留清洗规则）
字典数据表


| <span style="font-family:.PingFangUITextSC-Regular;">字段名</span> | <span style="font-family:.PingFangUITextSC-Regular;">说明</span> | <span style="font-family:.PingFangUITextSC-Regular;">示例</span> | <span style="font-family:.PingFangUITextSC-Regular;">备注</span> |
| -- | -- | -- | -- |
| **brand_id** | <span style="font-family:.PingFangUITextSC-Regular;">品牌唯一</span>ID，用于标识品牌。通常是一个12位数字或字符串（UUID）。 | 949392393395 | <span style="font-family:.PingFangUITextSC-Regular;">必须唯一，主键；确保品牌数据的唯一性。</span> |
| **brand_name** | <span style="font-family:.PingFangUITextSC-Regular;">品牌标准名称，品牌的官方名称。</span> | <span style="font-family:.PingFangUITextSC-Regular;">壳牌</span> | <span style="font-family:.PingFangUITextSC-Regular;">用于精确匹配的品牌名称，必须完全一致。</span> |
| **brand_aliases** | <span style="font-family:.PingFangUITextSC-Regular;">品牌的别名，多个别名之间用逗号分隔。</span> | <span style="font-family:.PingFangUITextSC-Regular;">壳牌</span>,SHELL | <span style="font-family:.PingFangUITextSC-Regular;">品牌名称的不同表示形式、缩写或拼音等。用于匹配时的别名比对。</span> |
| **exclusion_field** | <span style="font-family:.PingFangUITextSC-Regular;">排除字段，品牌匹配时，如果命中此字段，排除主品牌。</span> | <span style="font-family:.PingFangUITextSC-Regular;">新壳石化</span> | <span style="font-family:.PingFangUITextSC-Regular;">如果品牌匹配到该字段中的关键词，则不进行匹配，防止误识别。</span> |
| **brand_type** | <span style="font-family:.PingFangUITextSC-Regular;">品牌类型，指定品牌的类别（例如</span> KA、CKA、区域品牌等）。 | KA | <span style="font-family:.PingFangUITextSC-Regular;">用于分类管理品牌类型，决定品牌的优先级和策略。</span> |
| **brand_category** | <span style="font-family:.PingFangUITextSC-Regular;">品牌所属行业类别。</span> | <span style="font-family:.PingFangUITextSC-Regular;">石油</span> | <span style="font-family:.PingFangUITextSC-Regular;">品牌的行业类别，例如石油、能源、科技等，支持根据行业进行品牌的分类管理。</span> |
| **keywords** | <span style="font-family:.PingFangUITextSC-Regular;">品牌相关的关键词，用于模糊匹配和搜索优化。</span> | <span style="font-family:.PingFangUITextSC-Regular;">石油</span>,能源 | <span style="font-family:.PingFangUITextSC-Regular;">与品牌相关的关键词，用于更灵活的模糊匹配，例如行业名称、产品名称等。</span> |
| **is_active** | <span style="font-family:.PingFangUITextSC-Regular;">是否激活，指示品牌是否仍然有效或活跃。</span> | 0/1 | <span style="font-family:.PingFangUITextSC-Regular;">标记品牌是否处于有效状态。</span>1 表示激活，0 表示停用。 |
| **parent_brand_id** | <span style="font-family:.PingFangUITextSC-Regular;">父品牌</span>ID（如果是子品牌或合资品牌，指向父品牌的 brand_id）。 | NULL | <span style="font-family:.PingFangUITextSC-Regular;">如果品牌是子品牌或合资品牌，则该字段指向母品牌的</span> brand_id。 |
| **priority** | <span style="font-family:.PingFangUITextSC-Regular;">品牌匹配优先级，数字越小优先级越高。</span> | 1 | <span style="font-family:.PingFangUITextSC-Regular;">用于决定品牌匹配的优先顺序，值越小，优先级越高。</span> |
| **match_method** | <span style="font-family:.PingFangUITextSC-Regular;">品牌匹配方法，定义品牌匹配使用的算法或方式（如精确匹配、别名匹配、模糊匹配等）。</span> | 0/1/2 | <span style="font-family:.PingFangUITextSC-Regular;">描述匹配品牌时使用的方法，例如</span>0精确匹配、1别名匹配或2模糊匹配。 |
| **match_score_threshold** | <span style="font-family:.PingFangUITextSC-Regular;">匹配的置信度阈值，适用于模糊匹配。</span> | 0.8 | <span style="font-family:.PingFangUITextSC-Regular;">如果使用模糊匹配，定义匹配成功的最低置信度。</span> |
| **white_list** | <span style="font-family:.PingFangUITextSC-Regular;">是否为白名单品牌。</span> | 0/1 | <span style="font-family:.PingFangUITextSC-Regular;">指示品牌是否在白名单中，如果是，则该品牌在匹配时会优先考虑。</span> |
| **black_list** | <span style="font-family:.PingFangUITextSC-Regular;">是否为黑名单品牌。</span> | 0/1 | <span style="font-family:.PingFangUITextSC-Regular;">指示品牌是否在黑名单中，如果是，则该品牌会被排除在匹配之外。</span> |
| **last_updated** | <span style="font-family:.PingFangUITextSC-Regular;">品牌数据的最后更新时间。</span> | 2025-08-01 | <span style="font-family:.PingFangUITextSC-Regular;">记录品牌信息的最后更新日期，用于追踪品牌数据的更新历史。</span> |
| **created_at** | <span style="font-family:.PingFangUITextSC-Regular;">品牌信息的创建时间。</span> | 2025-01-01 | <span style="font-family:.PingFangUITextSC-Regular;">记录本表品牌信息第一次创建日期，用于追溯品牌的创建历史。</span> |
| **remark** | <span style="font-family:.PingFangUITextSC-Regular;">品牌修改或更新的备注信息。</span> | <span style="font-family:.PingFangUITextSC-Regular;">更新了品牌类别，由石油改为能源</span> | <span style="font-family:.PingFangUITextSC-Regular;">描述每次品牌信息更新的原因或背景。</span> |



**阶段 3：业务规则应用阶段需求对焦（基于你的反馈细化）**

1. 多数据源的优先级是否需要与品牌自身priority叠加？（例如：数据源 A 优先级高于数据源 B，但数据源 B 中的品牌priority更高，此时应取哪个？通过优先级表来定义,读取表,表字段,来区分优先级,具体的你的todo,跟我去人这个表的字段详情）
2. 同一store_id/pop_id匹配到多个有效品牌时，除了priority，是否需要其他辅助规则（如按last_updated取最新更新的品牌）？是的,需要.
3. “待确认” 的store_id/pop_id后续如何处理？（例如：自动触发人工审核，或加入下一轮动态更新的重点匹配池？）待确认的数据,产出一份中间表,读取待确认数据的全量数据,生成一个中间表,具体细节再确认.


**阶段 4：结果治理与追踪阶段需求对焦**

1. 最终输出表brand_tags_final的字段是否需要调整？（例如：是否需要包含parent_brand_id、is_active等字段？）不需要,确认这些字段.
2. 归档内容是否有特殊要求？（例如：原始数据需保留多久？中间表是否需要脱敏处理？）坦白说,是否需要保留,我没有想好,你可以详细给些建议,我们后面来讨论一下,待定
3. 质量监控指标的阈值（如待确认率预警阈值）是否有业务侧的明确要求？没有,但是可能需要有个监控,你给我一些建议和方案
4. 动态更新的触发条件除了 “新增品牌” 和 “待确认率超阈值”，是否还有其他（如 “数据源更新”“人工触发”）？是的,按周期自动扫描更新,人工更新和数据源都需要更新



**阶段 3：业务规则应用阶段 - 细化对焦（针对你的反馈）**
**1. 优先级配置表字段详情（核心待确认）**

更正,

| **priority** | <span style="font-family:.PingFangUITextSC-Regular;">品牌匹配优先级，数字越大优先级越高。</span> |
| -- | -- |



- 上述字段是否满足需求？不满足,从总表里读取信息.
	- 配置表路径
	- 配置表字段

| <span style="font-family:.PingFangUITextSC-Regular;">大类</span> | <span style="font-family:.PingFangUITextSC-Regular;">大类基准优先级（固定值）</span> | <span style="font-family:.PingFangUITextSC-Regular;">小类别</span> | <span style="font-family:.PingFangUITextSC-Regular;">小类别叠加值</span> | <span style="font-family:.PingFangUITextSC-Regular;">最终优先级（基准</span>+<span style="font-family:.PingFangUITextSC-Regular;">叠加）</span> |
| -- | -- | -- | -- | -- |


- “叠加逻辑” 是否合理？或是否需要其他计算方式（如 “数据源优先级 × 权重 + 品牌优先级 × 权重”）？
	- <span style="font-family:.PingFangUITextSC-Regular;">最终优先级（基准</span>+叠加）,就是叠加逻辑,直接取值值越大优先级越高.

**2. 同一 store_id/pop_id 匹配多个品牌的辅助规则（细化）**
- 辅助规则的顺位是否合理？是否需要调整
	- <span style="font-family:.PingFangUITextSC-Regular;">优先</span>优先按match_method精确匹配＞别名匹配＞模糊匹配
**3. 待确认数据中间表细节（细化）**
- 中间表字段是否满足需求？不满足
	- <span style="font-family:.PingFangUITextSC-Regular;">逻辑按</span>,<span style="font-family:.PingFangUITextSC-Regular;">读取</span>brand_tags_pending用于记录匹配失败的记录中的store_id的数据来源,直接取来源的全量数据.比如数据来源与历史结果,就取数据结果的全量数据.
	- 中间表命名,中间表+待确认+时间戳

**阶段 4：结果治理与追踪阶段 - 细化对焦（针对你的反馈）**

**2. 归档内容建议（供讨论）**
同意你的方案
**3. 质量监控指标方案（建议）**
- 指标是否覆盖核心需求？建议阈值是否需要调整（如业务侧可接受更高的待确认率）？
	- 建议阈值先看看数据再定,先统计
	- 按**match_method的维度拆分看数据**
- 监控报表的形式（Excel/BI/ 邮件）是否有偏好？
产出EXCLE

**4. 动态更新触发条件（细化）**
- 周期扫描的频率（每日 / 每周）是否合适？ 周/月更新
- 数据源更新的监测方式（文件修改时间 / 数据库时间戳）是否与实际数据源类型匹配？ 给一个监测方案.



对名称的清洗增加,清洗规则-停用词,历遍停用词,名称里面包含原始值,且是否停用=1,排除规则有值,且名称里面不包含排除规则,名称包含原始值就停用,举例,江苏贝林达投资管理有限公司常熟利农加油站,清洗后,贝林达利农.江苏/投资/管理/有限/公司/加油站都被停用了

清洗规则配置表,路径:/Users/didi/Downloads/panth/tag_ct/kacka/04_配置文件/3清洗规则配置表.xlsx,字段如下:


| <p style="text-align:center;margin:0"><span style="font-family:.PingFangUITextSC-Regular;">序号</span></p> | <p style="text-align:center;margin:0"><span style="font-family:.PingFangUITextSC-Regular;">原始值类型</span></p> | <p style="text-align:center;margin:0"><span style="font-family:.PingFangUITextSC-Regular;">原始值</span></p> | <p style="text-align:center;margin:0"><span style="font-family:.PingFangUITextSC-Regular;">是否停用</span></p> | <p style="text-align:center;margin:0"><span style="font-family:.PingFangUITextSC-Regular;">排除规则</span></p> |
| -- | -- | -- | -- | -- |