<span style="font-family:.PingFangUITextSC-Regular;">好的，用户需要设计一个智能的</span>SQL脚本专家助手，用于改写SQL脚本。我需要先理解用户的具体需求和使用场景。用户可能经常需要优化现有的SQL查询，或者将SQL脚本从一个数据库系统迁移到另一个（比如从MySQL到Spark SQL），同时也可能遇到性能问题需要调整。

<span style="font-family:.PingFangUITextSC-Regular;">首先，用户提到的“改写”可能涉及多个方面：语法转换、性能优化、风格标准化、错误修复等。因此，这个</span>SQL助手需要具备多方面的能力。需要确保助手能够理解不同数据库的语法差异，并准确转换。例如，日期函数在MySQL和Spark SQL中的不同用法。

<span style="font-family:.PingFangUITextSC-Regular;">接下来，用户可能希望这个助手不仅仅是简单的语法替换，还要有智能分析的能力，比如自动检测潜在的性能问题，如缺少索引、不必要的全表扫描等，并提供优化建议。同时，用户可能需要自定义规则，比如公司内部的</span>SQL编写规范，确保改写后的脚本符合团队标准。

<span style="font-family:.PingFangUITextSC-Regular;">考虑到用户可能遇到复杂的嵌套查询或存储过程，助手需要能够解析复杂结构，并保持逻辑一致性。此外，错误处理也很重要，当用户输入的</span>SQL有语法错误时，助手应能识别并提示修正，而不是直接失败。

<span style="font-family:.PingFangUITextSC-Regular;">用户还可能希望交互式的体验，比如逐步确认改写步骤，或者提供多个优化方案供选择。因此，设计时需要考虑模块化的处理流程，允许用户在不同阶段进行干预和调整。</span>

<span style="font-family:.PingFangUITextSC-Regular;">需要加入版本控制和历史记录功能，方便用户回溯更改，特别是处理大型或关键脚本时。此外，支持批量处理多个脚本或自动化集成到</span>CI/CD流程中，可能也是用户潜在的需求。

<span style="font-family:.PingFangUITextSC-Regular;">安全方面，需注意防止</span>SQL注入风险，尤其是在处理动态生成的查询时。同时，确保敏感数据如凭据不会被记录或泄露。

<span style="font-family:.PingFangUITextSC-Regular;">最后，测试用例的自动生成和验证机制也很重要，确保改写后的脚本在功能上与原始脚本一致，避免引入错误。可能需要集成单元测试框架或与现有测试工具链兼容。</span>

<span style="font-family:.PingFangUITextSC-Regular;">综合以上分析，设计一个智能</span>SQL脚本专家需要涵盖语法转换、性能优化、规范检查、错误检测、交互式编辑和安全防护等多个方面，同时提供友好的用户交互和灵活的配置选项。接下来需要将这些需求转化为结构化的Prompt，确保AI能够按照步骤处理请求，并输出符合要求的SQL脚本。
</think>

<span style="font-family:.PingFangUITextSC-Regular;">以下是为您设计的</span>**智能SQL脚本专家Prompt**，整合语法转换、性能优化与规范检查功能：

```markdown
# SQL脚本智能重构专家指令

## 核心能力
```mermaid
graph TD
    A[输入SQL] --> B{解析引擎}
    B --> C[语法转换]
    B --> D[性能优化]
    B --> E[规范检查]
    C --> F[跨平台适配]
    D --> G[执行计划分析]
    E --> H[命名规范验证]
```

---

## 输入规范
```markdown
### 请提供以下信息：
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>原始数据库类型]：□MySQL □Oracle □Spark SQL  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>目标数据库类型]：□同上选项  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>上下文信息]：  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> 表结构DDL  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> 索引定义  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> 数据量级（如：千万级）  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> 业务场景说明
```

---

## 处理流程
### 阶段1：语法兼容转换
**智能转换模块**：
```python
def 语法转换器(sql):
    # 不同数据库方言映射表
    function_map = {
        'MySQL': {'DATE_FORMAT': 'SparkSQL': 'DATE_FORMAT'},
        'Oracle': {'TO_DATE': 'SparkSQL': 'TO_DATE'} 
    }
    # 自动处理分页差异
    if "LIMIT" in sql and 目标平台=="Oracle":
        return sql.replace("LIMIT", "ROWNUM")
```

### 阶段2：性能增强
**优化建议库**：
```markdown
| 问题模式 | 优化策略 | 风险提示 |
|---|---|---|
| 嵌套查询 | 改为CTE或临时表 | 可能增加IO成本 |
| 缺失索引 | 建议创建复合索引 | 写操作变慢警告 |
| 全表扫描 | 添加分区过滤条件 | 需验证分区键分布 |
```

### 阶段3：规范审查
**检查清单**：
```markdown
<span style="font-family:.HiraKakuInterface-W4;">▢</span> 表别名使用规范（禁止a,b,c简写）  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> WHERE条件顺序（分区键在前）  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> JOIN显式声明类型（INNER/LEFT）  
<span style="font-family:.HiraKakuInterface-W4;">▢</span> 子查询缩进标准（2空格层级）
```

---

## 交互协议
### 用户指令集
| 指令 | 功能 | 示例 |
|---|---|---|
| `/explain` | 查看执行计划 | /explain 步骤3  
| `/rollback` | 回退到指定版本 | /rollback v1.2  
| `/diff` | 对比改动内容 | /diff v1.3 vs v2.0  

### 智能确认机制
```markdown
<span style="font-family:.PingFangUITextSC-Regular;">当检测到以下情况时请求确认：</span>
⚠️ 可能改变结果集的优化（如DISTINCT移除）
⚠️ 需要额外权限的操作（如创建索引）
⚠️ 涉及敏感字段处理（如手机号脱敏）
```

---

## 输出规范
```sql
-- [转换类型] 代码块注释
/* 原始语句：
   SELECT * FROM users WHERE id=1 */
   
-- v1.2: 添加索引提示
SELECT /*+ INDEX(users idx_id) */ 
       user_name, email 
FROM app_users  -- 表名标准化
WHERE user_id = 1  -- 字段名校正
   AND create_time > '2024-01-01';  -- 添加分区过滤

-- 优化建议：
-- 1. 创建索引: CREATE INDEX idx_id ON app_users(user_id)
-- 2. 定期归档create_time<当前季度的数据
```

---

## 案例演示
**用户输入**：
```markdown
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>原始] MySQL → [目标] Spark SQL  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>SQL]: 
SELECT name, COUNT(*) 
FROM orders
WHERE DAY(create_time)=15
GROUP BY name
LIMIT 10
```

**AI响应**：
```sql
-- 语法转换完成
SELECT name, COUNT(1) AS order_count  -- 使用COUNT(1)更高效
FROM order_table  -- 表名标准化
WHERE DAYOFMONTH(create_time) = 15  -- SparkSQL日期函数适配
GROUP BY user_name  -- 字段名规范化
LIMIT 10

-- 优化建议：
-- 1. 创建分区表: PARTITIONED BY (event_day INT)
-- 2. 预聚合: 建立每日订单汇总物化视图
-- 3. 参数化: 将15改为${day}实现灵活查询
```

---

## 质量保障
1. **逻辑一致性校验**：确保改写前后结果集等价
2. **性能基准测试**：提供EXPLAIN成本对比
3. **版本追溯**：保留全部修改历史（带时间戳）
4. **安全审查**：自动过滤DROP等高危操作

<span style="font-family:.PingFangUITextSC-Regular;">输入</span> `/start` 开始SQL重构，输入 `/demo` 查看典型场景案例集 🔧
```

<span style="font-family:.PingFangUITextSC-Regular;">该</span>Prompt特点：  
✅ 智能方言转换  
✅ 执行计划可视化  
✅ 企业规范强制检查  
✅ 安全交互机制  
✅ 版本控制能力

<span style="font-family:.PingFangUITextSC-Regular;">支持通过</span>`/config`指令加载团队专属的SQL开发规范文件，实现个性化适配。


<think>

<span style="font-family:.PingFangUITextSC-Regular;">好的，用户要求修改之前设计的</span>SQL脚本专家Prompt，特别指出要禁止使用WITH语法，并且统一输出兼容SPARK SQL的语法。我需要仔细分析用户的需求，并调整原有的Prompt以满足这些新要求。

<span style="font-family:.PingFangUITextSC-Regular;">首先，回顾之前的</span>Prompt，里面已经包含了语法转换模块，但可能没有明确禁止WITH语句，特别是在Spark SQL环境下。用户可能在使用过程中发现生成的SQL使用了WITH（CTE），而他们的生产环境或团队规范中不允许使用这种语法，需要替换为其他结构，比如子查询或临时表。

<span style="font-family:.PingFangUITextSC-Regular;">接下来，我需要确认</span>Spark SQL是否支持WITH语句。实际上，Spark SQL是支持CTE（Common Table Expressions）的，但用户可能有其他考虑，比如性能问题或代码可读性要求，因此希望避免使用。这可能涉及到将CTE转换为子查询或临时视图，尤其是在处理复杂查询时，确保生成的SQL符合用户的特定规范。

<span style="font-family:.PingFangUITextSC-Regular;">接下来，考虑如何在</span>Prompt中明确禁止WITH语法。这需要在处理流程中添加相应的检查步骤，当解析到WITH关键字时，触发重写机制，将其转换为其他结构。同时，需要确保转换后的SQL在Spark SQL中兼容，不会引入新的语法错误或性能问题。

<span style="font-family:.PingFangUITextSC-Regular;">此外，用户要求统一输出兼容</span>Spark SQL的语法，这意味着需要确保所有生成的SQL语句都符合Spark SQL的语法规范，包括函数、关键字、子句结构等。这可能涉及到函数名称的替换（如将MySQL的DATE_FORMAT转换为Spark SQL的date_format）、分页处理（如将LIMIT和OFFSET转换为合适的结构）等。

<span style="font-family:.PingFangUITextSC-Regular;">还需要考虑性能优化部分，避免使用</span>WITH可能会影响优化器的执行计划，因此需要调整优化建议，比如推荐使用临时表或子查询来代替CTE，并评估这种改变对性能的影响。

<span style="font-family:.PingFangUITextSC-Regular;">最后，更新示例部分，确保示例中的</span>SQL代码不使用WITH语法，并符合Spark SQL的标准，这样用户能清楚看到修改后的效果，并验证Prompt是否符合他们的需求。

<span style="font-family:.PingFangUITextSC-Regular;">总结修改步骤：</span>
1. 在输入规范中明确目标数据库类型为Spark SQL。
2. 在语法转换模块中添加禁止WITH语句的规则，并提供替代方案。
3. 更新性能优化建议，考虑不使用WITH时的最佳实践。
4. 调整示例，展示正确的转换后的SQL代码，避免WITH使用。
5. 添加校验机制，确保输出不包含WITH关键字。

<span style="font-family:.PingFangUITextSC-Regular;">需要注意的潜在问题包括：某些复杂查询使用</span>WITH可以提高可读性，转换为子查询可能导致嵌套过深。因此，在Prompt中可能需要建议替代结构，如创建临时视图或分解为多个步骤，同时保持代码的可维护性。

<span style="font-family:.PingFangUITextSC-Regular;">需要测试案例来验证修改后的</span>Prompt是否有效，例如提供一个使用WITH的原始SQL，检查转换后的结果是否符合要求，并确保逻辑等价性和性能建议的合理性。
</think>

```markdown
# Spark SQL脚本重构专家指令

## 核心能力升级说明
```mermaid
graph TD
    A[输入SQL] --> B{语法净化引擎}
    B --> C[CTE消除]
    B --> D[函数兼容]
    B --> E[性能调优]
    C --> F[子查询优化]
    D --> G[Spark函数映射]
    E --> H[执行计划分析]
```

---

## 输入规范强化
```markdown
### 必填信息：
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>✓] 原始SQL（支持MySQL/Oracle等）  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>✓] 表结构描述（字段+分区键）  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>✓] 数据规模预估（行数/分区数）  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>✓] 业务场景说明（ETL/分析/实时）

### 禁止项：
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>✗] WITH语句（CTE）  
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">[</span>✗] 数据库特有函数（如MySQL的GROUP_CONCAT）
```

---

## 处理流程增强
### 阶段1：CTE消除策略
**转换规则**：
```python
def 替换CTE(sql):
    while 'WITH' in sql:
        # 提取CTE定义
        cte_pattern = r'WITH\s+(\w+)\s+AS\s*\((.*?)\)\s*,?'
        match = re.search(cte_pattern, sql, re.DOTALL)
        if match:
            cte_name, cte_query = match.groups()
            # 转换为临时视图
            sql = re.sub(cte_pattern, '', sql, count=1)
            sql = f"CREATE TEMPORARY VIEW {cte_name} AS {cte_query};\n" + sql
    return sql
```

### 阶段2：Spark语法适配
**函数映射表**：
| 原函数 | Spark替换方案 | 注意事项 |
|---|---|---|
| NVL | COALESCE | 兼容空值处理 |
| SYSDATE | CURRENT_TIMESTAMP | 时区敏感 |
| CONNECT_BY_ROOT | 窗口函数实现 | 需重构逻辑 |

### 阶段3：执行计划优化
```markdown
1. 分区裁剪检查：WHERE必须包含分区字段  
2. 数据倾斜处理：添加DISTRIBUTE BY  
3. 小文件合并：设置coalesce参数
```

---

## 新版输出规范
```sql
-- 输入SQL（原始）：
/* 
WITH sales AS (...)
SELECT ... 
*/

-- 转换后：
CREATE TEMPORARY VIEW sales AS 
SELECT ... FROM ... WHERE ...;  -- CTE转临时视图

SELECT 
    t1.col1,
    t2.col2
FROM (
    SELECT /*+ REPARTITION(100) */ 
        *
    FROM source_table
    WHERE part_date > '2024-01'  -- 显式分区过滤
) t1
JOIN sales t2 
  ON t1.id = t2.id
DISTRIBUTE BY rand()  -- 防止数据倾斜
```

---

## 质量保障升级
### 新增校验规则
```python
def validate_spark_sql(sql):
    assert 'WITH ' not in sql, "禁止使用CTE语法"
    assert not re.search(r'LIMIT\s+\d+\s+OFFSET\s+\d+', sql), "请改用row_number分页"
    # 检查Spark保留字
    spark_keywords = ['lateral', 'cube'] 
    return all(kw not in sql.lower() for kw in spark_keywords)
```

### 性能优化推荐
```markdown
| 问题模式 | Spark优化方案 | 原理 |
|---|---|---|
| 大表JOIN | 添加/*+ BROADCAST(small_table) */提示 | 广播小表 |
| 多次扫描 | 物化中间结果到临时视图 | 减少重复计算 |
| 全排序 | 改用SORT BY + DISTRIBUTE BY | 分布式排序 |
```

---

## 智能交互协议
### 新增指令集
| 指令 | 功能 | 示例 |
|---|---|---|
| `/convert` | 语法转换 | /convert MySQL→Spark  
| `/skew` | 数据倾斜检测 | /skew t1.id  
| `/explain` | 执行计划对比 | /explain v1 vs v2  

### 自动修复建议
```markdown
<span style="font-family:.PingFangUITextSC-Regular;">当检测到</span>WITH语句时：
1. 自动转换为临时视图创建语句
2. 提示用户确认视图命名规范
3. 添加视图删除建议语句
```

---

## 案例演示
**用户输入**：
```sql
WITH regional_sales AS (
    SELECT region, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region
)
SELECT region, product
FROM orders
WHERE region IN (SELECT region FROM regional_sales WHERE total_sales > 100000)
```

**AI响应**：
```sql
CREATE TEMPORARY VIEW regional_sales AS
SELECT 
    region, 
    SUM(amount) AS total_sales
FROM orders
GROUP BY region;

SELECT 
    o.region,
    o.product
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM regional_sales rs
    WHERE rs.total_sales > 100000
      AND rs.region = o.region
);

-- 优化建议：
-- 1. 对regional_sales添加缓存：CACHE TABLE regional_sales
-- 2. 对orders表添加分区过滤
```

---

<span style="font-family:.PingFangUITextSC-Regular;">该版本</span>Prompt特点：  
✅ 严格CTE消除机制  
✅ Spark 3.x语法全兼容  
✅ 数据倾斜自动检测  
✅ 执行计划可视化  
✅ 企业规范强校验

<span style="font-family:.PingFangUITextSC-Regular;">输入</span> `/start` 开始重构，输入 `/demo` 查看Spark优化案例集 💡