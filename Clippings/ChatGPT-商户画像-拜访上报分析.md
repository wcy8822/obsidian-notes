---
title: ChatGPT
source: https://chatgpt.com/g/g-p-692abef2079c81918c16c22b66aec849-shang-hu-hua-xiang/c/6932f910-b270-8320-908c-3d825160cb15
author:
  - "[[ChatGPT-非油品-2期BRD草稿]]"
published:
created: 2025-12-23
description: ChatGPT 是一款供日常使用的 AI 聊天机器人。与最先进的 AI 模型互动，探索创意、解决问题以及提升学习效率。
tags:
  - clippings
---
\[-- ========== 省区 / 拜访者 / 全国整体 人维度上报率 + 排名（多级排序版） ========== -- 时间窗口：最近 12 周 SET @start\_date:= DATE\_SUB(CURDATE(), INTERVAL 12 WEEK); WITH -- 1. 基准油站：复用 v3，带历史上报标记 base\_store AS ( SELECT store\_id, province, has\_submit AS has\_submit\_history FROM station\_tag\_coverage\_analysis\_v3 ), -- 2A. 按「店 × 省 × 周」聚合的拜访（供省整体 / 全国整体用） visit\_store\_week AS ( SELECT b.store\_id, b.province, YEARWEEK(v.visit\_date, 1) AS week\_key, MIN(DATE\_SUB(v.visit\_date, INTERVAL WEEKDAY(v.visit\_date) DAY)) AS week\_start\_date, MAX(b.has\_submit\_history) AS has\_submit\_history FROM uir\_visit\_records v JOIN base\_store b ON v.station\_id = b.store\_id WHERE v.visit\_date >= @start\_date GROUP BY b.store\_id, b.province, YEARWEEK(v.visit\_date, 1) ), -- 2B. 按「店 × 省 × 拜访者 × 周」聚合的拜访（供省×拜访者用） visit\_store\_week\_visitor AS ( SELECT b.store\_id, b.province, v.visitor\_name, YEARWEEK(v.visit\_date, 1) AS week\_key, MIN(DATE\_SUB(v.visit\_date, INTERVAL WEEKDAY(v.visit\_date) DAY)) AS week\_start\_date, MAX(b.has\_submit\_history) AS has\_submit\_history FROM uir\_visit\_records v JOIN base\_store b ON v.station\_id = b.store\_id WHERE v.visit\_date >= @start\_date AND v.visitor\_name IS NOT NULL AND v.visitor\_name <> '' GROUP BY b.store\_id, b.province, v.visitor\_name, YEARWEEK(v.visit\_date, 1) ), -- 3. 按「店 × 省 × 周」聚合的成功上报 submit\_store\_week AS ( SELECT b.store\_id, b.province, YEARWEEK(s.create\_time, 1) AS week\_key FROM visit\_records\_enriched s JOIN base\_store b ON s.store\_id = b.store\_id WHERE s.create\_time >= @start\_date AND s.processing\_status = 'success' GROUP BY b.store\_id, b.province, YEARWEEK(s.create\_time, 1) ), -- 4. 省 × 拜访者 × 周：底层计数 agg\_province\_visitor AS ( SELECT v.province, v.visitor\_name, v.week\_key, MIN(v.week\_start\_date) AS week\_start\_date, COUNT(\*) AS visit\_station\_cnt, SUM(CASE WHEN v.has\_submit\_history = 1 THEN 1 ELSE 0 END) AS visit\_with\_history\_submit\_station\_cnt, SUM(CASE WHEN v.has\_submit\_history = 0 OR v.has\_submit\_history IS NULL THEN 1 ELSE 0 END) AS visit\_never\_submit\_station\_cnt, SUM(CASE WHEN s.store\_id IS NOT NULL THEN 1 ELSE 0 END) AS visit\_submit\_station\_cnt FROM visit\_store\_week\_visitor v LEFT JOIN submit\_store\_week s ON v.store\_id = s.store\_id AND v.province = s.province AND v.week\_key = s.week\_key GROUP BY v.province, v.visitor\_name, v.week\_key ), -- 5. 省 × 拜访者 × 周：先算比例 prov\_visitor\_rates AS ( SELECT province, visitor\_name, week\_key, week\_start\_date, visit\_station\_cnt, visit\_submit\_station\_cnt, visit\_with\_history\_submit\_station\_cnt, visit\_never\_submit\_station\_cnt, ROUND( visit\_submit\_station\_cnt / NULLIF(visit\_station\_cnt, 0) \* 100, 2 ) AS submit\_same\_period\_rate\_from\_visit\_pct, -- 同周闭环率 ROUND( visit\_with\_history\_submit\_station\_cnt / NULLIF(visit\_station\_cnt, 0) \* 100, 2 ) AS submit\_history\_rate\_from\_visit\_pct, -- 历史支撑率 ROUND( visit\_never\_submit\_station\_cnt / NULLIF(visit\_station\_cnt, 0) \* 100, 2 ) AS never\_submit\_rate\_from\_visit\_pct -- 首上报缺失率 FROM agg\_province\_visitor ), -- 6. 省 × 拜访者 × 周：加 rank（多级排序） prov\_visitor\_with\_rate AS ( SELECT 'PROVINCE\_VISITOR' AS dim\_level, province, visitor\_name, week\_key, week\_start\_date, visit\_station\_cnt, visit\_submit\_station\_cnt, visit\_with\_history\_submit\_station\_cnt, visit\_never\_submit\_station\_cnt, submit\_same\_period\_rate\_from\_visit\_pct, submit\_history\_rate\_from\_visit\_pct, never\_submit\_rate\_from\_visit\_pct, RANK() OVER ( PARTITION BY province, week\_key ORDER BY submit\_same\_period\_rate\_from\_visit\_pct DESC, -- 1. 同周闭环率 submit\_history\_rate\_from\_visit\_pct DESC, -- 2. 历史支撑率 never\_submit\_rate\_from\_visit\_pct ASC, -- 3. 问题盘占比（越低越好） visit\_station\_cnt DESC -- 4. 拜访盘子大小 ) AS rank\_in\_province FROM prov\_visitor\_rates ), -- 7. 省整体 × 周 agg\_province\_overall AS ( SELECT v.province, v.week\_key, MIN(v.week\_start\_date) AS week\_start\_date, COUNT(\*) AS visit\_station\_cnt, SUM(CASE WHEN v.has\_submit\_history = 1 THEN 1 ELSE 0 END) AS visit\_with\_history\_submit\_station\_cnt, SUM(CASE WHEN v.has\_submit\_history = 0 OR v.has\_submit\_history IS NULL THEN 1 ELSE 0 END) AS visit\_never\_submit\_station\_cnt, SUM(CASE WHEN s.store\_id IS NOT NULL THEN 1 ELSE 0 END) AS visit\_submit\_station\_cnt FROM visit\_store\_week v LEFT JOIN submit\_store\_week s ON v.store\_id = s.store\_id AND v.province = s.province AND v.week\_key = s.week\_key GROUP BY v.province, v.week\_key ), prov\_overall\_with\_rate AS ( SELECT 'PROVINCE\_OVERALL' AS dim\_level, province, '整体' AS visitor\_name, week\_key, week\_start\_date, visit\_station\_cnt, visit\_submit\_station\_cnt, visit\_with\_history\_submit\_station\_cnt, visit\_never\_submit\_station\_cnt, ROUND( visit\_submit\_station\_cnt / NULLIF(visit\_station\_cnt, 0) \* 100, 2 ) AS submit\_same\_period\_rate\_from\_visit\_pct, ROUND( visit\_with\_history\_submit\_station\_cnt / NULLIF(visit\_station\_cnt, 0) \* 100, 2 ) AS submit\_history\_rate\_from\_visit\_pct, ROUND( visit\_never\_submit\_station\_cnt / NULLIF(visit\_station\_cnt, 0) \* 100, 2 ) AS never\_submit\_rate\_from\_visit\_pct, CAST(NULL AS SIGNED) AS rank\_in\_province FROM agg\_province\_overall ), -- 8. 全国整体 × 周（由省整体汇总） national\_overall AS ( SELECT 'NATIONAL\_OVERALL' AS dim\_level, '全国' AS province, '整体' AS visitor\_name, week\_key, MIN(week\_start\_date) AS week\_start\_date, SUM(visit\_station\_cnt) AS visit\_station\_cnt, SUM(visit\_submit\_station\_cnt) AS visit\_submit\_station\_cnt, SUM(visit\_with\_history\_submit\_station\_cnt) AS visit\_with\_history\_submit\_station\_cnt, SUM(visit\_never\_submit\_station\_cnt) AS visit\_never\_submit\_station\_cnt, ROUND( SUM(visit\_submit\_station\_cnt) / NULLIF(SUM(visit\_station\_cnt), 0) \* 100, 2 ) AS submit\_same\_period\_rate\_from\_visit\_pct, ROUND( SUM(visit\_with\_history\_submit\_station\_cnt) / NULLIF(SUM(visit\_station\_cnt), 0) \* 100, 2 ) AS submit\_history\_rate\_from\_visit\_pct, ROUND( SUM(visit\_never\_submit\_station\_cnt) / NULLIF(SUM(visit\_station\_cnt), 0) \* 100, 2 ) AS never\_submit\_rate\_from\_visit\_pct, CAST(NULL AS SIGNED) AS rank\_in\_province FROM agg\_province\_overall GROUP BY week\_key ) -- 9. 合并三类维度：全国整体 / 省整体 / 省×拜访者 SELECT dim\_level, -- NATIONAL\_OVERALL / PROVINCE\_OVERALL / PROVINCE\_VISITOR province, visitor\_name, week\_key, week\_start\_date, visit\_station\_cnt, visit\_submit\_station\_cnt, visit\_with\_history\_submit\_station\_cnt, visit\_never\_submit\_station\_cnt, submit\_same\_period\_rate\_from\_visit\_pct, submit\_history\_rate\_from\_visit\_pct, never\_submit\_rate\_from\_visit\_pct, rank\_in\_province FROM ( SELECT \* FROM national\_overall UNION ALL SELECT \* FROM prov\_overall\_with\_rate UNION ALL SELECT \* FROM prov\_visitor\_with\_rate ) t ORDER BY week\_key, CASE dim\_level WHEN 'NATIONAL\_OVERALL' THEN 1 WHEN 'PROVINCE\_OVERALL' THEN 2 WHEN 'PROVINCE\_VISITOR' THEN 3 ELSE 99 END, province, rank\_in\_province, visitor\_name; \]帮我修正迭代这个 SQL,本次允许使用 with 语法;不需要调整;需求是,我需要把 week\_key,映射派生出一个 week\_data,用开始日期\_结束日期来表示,比如 202549,表示开始是 12/01\_\_12/05,理解吗?;同时需要在针对这个构建一个物理实体表,表名你自己取一个;在对这个物理表,做一个视图查询,查询的一个交叉表,看省区/拜访者,week\_data依次铺开,从低到高排列,指标查询历史上报率/首次上报率,能理解吗?先说理解需求

20251205\_2100\_周维度上报率周区间与交叉表落地方案

tags:: #周维度分析 #标签上报率 #数据建模 #交叉表 #实体表设计

---

**一句话结论：**  
你的需求我完全理解：在现有“省区 / 拜访者 / 全国整体 周维度上报率”SQL 基础上，新增一个「周区间 week\_data」字段，并基于该结果落地一张物理表和一个面向省区×拜访者×周区间的分析视图（含历史上报率、首次上报率），用于做交叉分析和可视化透视。

---

## 三段论据（逻辑闭环）

### 论据一：现状与问题

1. 你现在这段 SQL 已经完成了比较完整的周维度统计：
	- 三个粒度：全国整体 / 省整体 / 省×拜访者；
	- 指标：同周闭环率、历史支撑率、首上报缺失率等；
	- 排名：按省内拜访者，多级排序+rank。
2. 当前缺口主要有两块：
	- 缺少一个显式的「周区间」字段（如 `12/01__12/05` ），不方便人读和报表展示；
	- 没有沉淀成物理实体表和标准视图，交叉表（省区×拜访者×周）分析只能靠临时 SQL。
3. 你希望在保持现有逻辑基本不动的前提下做“增量改造”，避免大动结构，只做字段派生 + 建表 + 视图。

### 论据二：策略选择与推演

1. **week\_data 派生口径** ：
	- 沿用你现有的 `week_start_date` （通过 `WEEKDAY()` 算出的周一）；
	- 周结束日期按“工作周”处理： `week_end_date = week_start_date + 4天` → 对应你举的例子 `202549 => 12/01__12/05` ；
	- `week_data` 文本形态定义为： `MM/DD__MM/DD` ，方便报表展示。
2. **指标口径对齐** ：
	- 历史上报率：沿用现有 `visit_with_history_submit_station_cnt / visit_station_cnt` （即 `submit_history_rate_from_visit_pct` ）；
	- 首次上报率：在原有基础上新增一个指标  
		`first_submit_rate_from_visit_pct = (visit_station_cnt - visit_never_submit_station_cnt)/visit_station_cnt`  
		→ 可以理解为“有历史上报 + 本期首上报”的站点占比，等价于 `100 - 首上报缺失率` 。
3. **交叉表实现方式** ：
	- 物理表负责沉淀所有维度+指标（长表结构）；
	- 视图对物理表做“省区×拜访者×周区间”的统一抽象；
	- 交叉表本身（矩阵形式）在 MySQL 中做“动态列”很别扭，所以：
		- 视图输出长表（行：省区×拜访者×week\_data，列：两类指标）；
		- 你在 BI / 报表工具中直接透视即可；
		- 如果确实要 SQL 级别的矩阵，我会再给一个“固定近 N 周”的条件聚合示例。

### 论据三：落地与风险

1. 落地节奏建议：
	- 第一步：改造现有 SQL，增加 `week_end_date` + `week_data` + `first_submit_rate_from_visit_pct` 字段，先跑 ad-hoc 验证结果；
	- 第二步：按我下面给的 DDL 建 `visit_submit_weekly_stats` 实体表，并通过 `INSERT … WITH … SELECT` 灌首批数据；
	- 第三步：创建视图 + 在 BI 中建立一个交叉表模板（省区 / 拜访者 / week\_data）。
2. 主要风险和注意点：
	- **周结束日期口径** ：我按“周一到周五”给你写，如果你后续想改为周一到周日，只要把 `+ INTERVAL 4 DAY` 改成 `+ INTERVAL 6 DAY` 即可；
	- **首次上报率口径** ：这里按“1 - 首上报缺失率”处理，如果你后续想改成“首上报成功站点 / 首上报站点”，需要增加新的计数逻辑；
	- **交叉表动态列问题** ：视图里无法动态生成列名=week\_data 的矩阵，因此我会用“长表视图 + 示例 pivot SQL”这套组合拳。
3. 一旦这套实体表 + 视图稳定下来，你后面要做“区域对比 / 拜访人排行榜 / 周趋势分析”等，都可以直接复用，不再重复造轮子。

---

## 3.1 需求拆解与口径对齐

你的关键需求拆成 3 件事：

1. **在现有 SQL 中增加 week\_data 字段**
	- 字段： `week_end_date` （DATE）、 `week_data` （VARCHAR）；
	- 口径：
		- `week_start_date` 已有（周一）；
		- `week_end_date = week_start_date + 4天` ；
		- `week_data = DATE_FORMAT(week_start_date, '%m/%d') || '__' || DATE_FORMAT(week_end_date, '%m/%d')` 。
2. **新增“首次上报率”指标**
	- 已有：
		- `visit_station_cnt`
		- `visit_never_submit_station_cnt` （首上报缺失数）
	- 新增：
		- `first_submit_rate_from_visit_pct = (visit_station_cnt - visit_never_submit_station_cnt)/visit_station_cnt` （×100%并四舍五入）。
3. **沉淀实体表 + 视图 + 交叉查询**
	- 实体表： `visit_submit_weekly_stats` （你可以根据习惯改名）；
	- 视图：只暴露省区×拜访者×周区间 + 两个关键指标；
	- 交叉表：
		- 日常使用：BI 透视（行=省/拜访者，列=week\_data）；
		- SQL 示例：按“最近 N 周”写死若干列的示例，用条件聚合实现。

---

## 3.2 改造后的周维度 SQL（增加 week\_data 与首次上报率）

下面是在你原 SQL 基础上“增量改造”的版本（只增加字段 & 指标，不动核心逻辑）。  
关键变化点我用注释标出来了。

```sql
sql-- 时间窗口：最近 12 周
SET @start_date := DATE_SUB(CURDATE(), INTERVAL 12 WEEK);

WITH
-- 1. 基准油站：复用 v3，带历史上报标记
base_store AS (
    SELECT 
        store_id,
        province,
        has_submit AS has_submit_history
    FROM station_tag_coverage_analysis_v3
),

-- 2A. 按「店 × 省 × 周」聚合的拜访（供省整体 / 全国整体用）
visit_store_week AS (
    SELECT
        b.store_id,
        b.province,
        YEARWEEK(v.visit_date, 1) AS week_key,
        MIN(DATE_SUB(v.visit_date, INTERVAL WEEKDAY(v.visit_date) DAY)) AS week_start_date,
        MAX(b.has_submit_history) AS has_submit_history
    FROM uir_visit_records v
    JOIN base_store b 
      ON v.station_id = b.store_id
    WHERE v.visit_date >= @start_date
    GROUP BY
        b.store_id,
        b.province,
        YEARWEEK(v.visit_date, 1)
),

-- 2B. 按「店 × 省 × 拜访者 × 周」聚合的拜访（供省×拜访者用）
visit_store_week_visitor AS (
    SELECT
        b.store_id,
        b.province,
        v.visitor_name,
        YEARWEEK(v.visit_date, 1) AS week_key,
        MIN(DATE_SUB(v.visit_date, INTERVAL WEEKDAY(v.visit_date) DAY)) AS week_start_date,
        MAX(b.has_submit_history) AS has_submit_history
    FROM uir_visit_records v
    JOIN base_store b 
      ON v.station_id = b.store_id
    WHERE v.visit_date >= @start_date
      AND v.visitor_name IS NOT NULL
      AND v.visitor_name <> ''
    GROUP BY
        b.store_id,
        b.province,
        v.visitor_name,
        YEARWEEK(v.visit_date, 1)
),

-- 3. 按「店 × 省 × 周」聚合的成功上报
submit_store_week AS (
    SELECT
        b.store_id,
        b.province,
        YEARWEEK(s.create_time, 1) AS week_key
    FROM visit_records_enriched s
    JOIN base_store b 
      ON s.store_id = b.store_id
    WHERE s.create_time >= @start_date
      AND s.processing_status = 'success'
    GROUP BY
        b.store_id,
        b.province,
        YEARWEEK(s.create_time, 1)
),

-- 4. 省 × 拜访者 × 周：底层计数
agg_province_visitor AS (
    SELECT
        v.province,
        v.visitor_name,
        v.week_key,
        MIN(v.week_start_date) AS week_start_date,
        COUNT(*) AS visit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 1 THEN 1 ELSE 0 END) 
            AS visit_with_history_submit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 0 OR v.has_submit_history IS NULL THEN 1 ELSE 0 END) 
            AS visit_never_submit_station_cnt,
        SUM(CASE WHEN s.store_id IS NOT NULL THEN 1 ELSE 0 END) 
            AS visit_submit_station_cnt
    FROM visit_store_week_visitor v
    LEFT JOIN submit_store_week s
      ON v.store_id = s.store_id
     AND v.province = s.province
     AND v.week_key = s.week_key
    GROUP BY
        v.province,
        v.visitor_name,
        v.week_key
),

-- 5. 省 × 拜访者 × 周：先算比例（新增首次上报率）
prov_visitor_rates AS (
    SELECT
        province,
        visitor_name,
        week_key,
        week_start_date,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        ROUND(
            visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_same_period_rate_from_visit_pct,   -- 同周闭环率
        ROUND(
            visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_history_rate_from_visit_pct,       -- 历史支撑率（历史上报率）
        ROUND(
            visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS never_submit_rate_from_visit_pct,         -- 首上报缺失率
        ROUND(
            (visit_station_cnt - visit_never_submit_station_cnt) / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS first_submit_rate_from_visit_pct          -- 首次上报率（新增）
    FROM agg_province_visitor
),

-- 6. 省 × 拜访者 × 周：加 rank（多级排序）+ week_end_date / week_data
prov_visitor_with_rate AS (
    SELECT
        'PROVINCE_VISITOR' AS dim_level,
        province,
        visitor_name,
        week_key,
        week_start_date,
        DATE_ADD(week_start_date, INTERVAL 4 DAY) AS week_end_date,  -- 工作周结束日期
        CONCAT(
            DATE_FORMAT(week_start_date, '%m/%d'),
            '__',
            DATE_FORMAT(DATE_ADD(week_start_date, INTERVAL 4 DAY), '%m/%d')
        ) AS week_data,                                              -- 例如 12/01__12/05
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        submit_same_period_rate_from_visit_pct,
        submit_history_rate_from_visit_pct,
        never_submit_rate_from_visit_pct,
        first_submit_rate_from_visit_pct,
        RANK() OVER (
            PARTITION BY province, week_key
            ORDER BY
                submit_same_period_rate_from_visit_pct DESC,  -- 1. 同周闭环率
                submit_history_rate_from_visit_pct     DESC,  -- 2. 历史支撑率
                never_submit_rate_from_visit_pct       ASC,   -- 3. 问题盘占比（越低越好）
                visit_station_cnt                      DESC   -- 4. 拜访盘子大小
        ) AS rank_in_province
    FROM prov_visitor_rates
),

-- 7. 省整体 × 周
agg_province_overall AS (
    SELECT
        v.province,
        v.week_key,
        MIN(v.week_start_date) AS week_start_date,
        COUNT(*) AS visit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 1 THEN 1 ELSE 0 END) 
            AS visit_with_history_submit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 0 OR v.has_submit_history IS NULL THEN 1 ELSE 0 END) 
            AS visit_never_submit_station_cnt,
        SUM(CASE WHEN s.store_id IS NOT NULL THEN 1 ELSE 0 END) 
            AS visit_submit_station_cnt
    FROM visit_store_week v
    LEFT JOIN submit_store_week s
      ON v.store_id = s.store_id
     AND v.province = s.province
     AND v.week_key = s.week_key
    GROUP BY
        v.province,
        v.week_key
),

prov_overall_with_rate AS (
    SELECT
        'PROVINCE_OVERALL' AS dim_level,
        province,
        '整体' AS visitor_name,
        week_key,
        week_start_date,
        DATE_ADD(week_start_date, INTERVAL 4 DAY) AS week_end_date,
        CONCAT(
            DATE_FORMAT(week_start_date, '%m/%d'),
            '__',
            DATE_FORMAT(DATE_ADD(week_start_date, INTERVAL 4 DAY), '%m/%d')
        ) AS week_data,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        ROUND(
            visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS never_submit_rate_from_visit_pct,
        ROUND(
            (visit_station_cnt - visit_never_submit_station_cnt) / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS first_submit_rate_from_visit_pct,
        CAST(NULL AS SIGNED) AS rank_in_province
    FROM agg_province_overall
),

-- 8. 全国整体 × 周（由省整体汇总）
national_overall AS (
    SELECT
        'NATIONAL_OVERALL' AS dim_level,
        '全国' AS province,
        '整体' AS visitor_name,
        week_key,
        MIN(week_start_date) AS week_start_date,
        DATE_ADD(MIN(week_start_date), INTERVAL 4 DAY) AS week_end_date,
        CONCAT(
            DATE_FORMAT(MIN(week_start_date), '%m/%d'),
            '__',
            DATE_FORMAT(DATE_ADD(MIN(week_start_date), INTERVAL 4 DAY), '%m/%d')
        ) AS week_data,
        SUM(visit_station_cnt) AS visit_station_cnt,
        SUM(visit_submit_station_cnt) AS visit_submit_station_cnt,
        SUM(visit_with_history_submit_station_cnt) AS visit_with_history_submit_station_cnt,
        SUM(visit_never_submit_station_cnt) AS visit_never_submit_station_cnt,
        ROUND(
            SUM(visit_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            SUM(visit_with_history_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            SUM(visit_never_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
            2
        ) AS never_submit_rate_from_visit_pct,
        ROUND(
            (SUM(visit_station_cnt) - SUM(visit_never_submit_station_cnt)) 
                / NULLIF(SUM(visit_station_cnt), 0) * 100,
            2
        ) AS first_submit_rate_from_visit_pct,
        CAST(NULL AS SIGNED) AS rank_in_province
    FROM agg_province_overall
    GROUP BY
        week_key
)

-- 9. 合并三类维度：全国整体 / 省整体 / 省×拜访者
SELECT
    dim_level,                              -- NATIONAL_OVERALL / PROVINCE_OVERALL / PROVINCE_VISITOR
    province,
    visitor_name,
    week_key,
    week_start_date,
    week_end_date,
    week_data,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    first_submit_rate_from_visit_pct,
    rank_in_province
FROM (
    SELECT * FROM national_overall
    UNION ALL
    SELECT * FROM prov_overall_with_rate
    UNION ALL
    SELECT * FROM prov_visitor_with_rate
) t
ORDER BY
    week_key,
    CASE dim_level
        WHEN 'NATIONAL_OVERALL' THEN 1
        WHEN 'PROVINCE_OVERALL' THEN 2
        WHEN 'PROVINCE_VISITOR' THEN 3
        ELSE 99
    END,
    province,
    rank_in_province,
    visitor_name;
```

---

## 3.3 物理实体表 visit\_submit\_weekly\_stats 设计与灌数

### 3.3.1 建表 DDL（实体表）

表名我先定为： `visit_submit_weekly_stats` ，你可以按规范再调整。

### 3.3.2 灌数据 SQL（INSERT + WITH）

直接复用上面的 CTE 逻辑，用 `INSERT INTO … WITH … SELECT` 即可：

```sql
sqlINSERT INTO visit_submit_weekly_stats (
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    week_end_date,
    week_data,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    first_submit_rate_from_visit_pct,
    rank_in_province
)
WITH
    -- 这里直接复制上一段查询中的 CTE 定义（base_store ~ national_overall 全部）
    base_store AS ( ... 同上 ... ),
    visit_store_week AS ( ... ),
    visit_store_week_visitor AS ( ... ),
    submit_store_week AS ( ... ),
    agg_province_visitor AS ( ... ),
    prov_visitor_rates AS ( ... ),
    prov_visitor_with_rate AS ( ... ),
    agg_province_overall AS ( ... ),
    prov_overall_with_rate AS ( ... ),
    national_overall AS ( ... )
SELECT
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    week_end_date,
    week_data,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    first_submit_rate_from_visit_pct,
    rank_in_province
FROM (
    SELECT * FROM national_overall
    UNION ALL
    SELECT * FROM prov_overall_with_rate
    UNION ALL
    SELECT * FROM prov_visitor_with_rate
) t;
```

> 实操建议：先在临时表或直接 SELECT 检查结果没问题，再执行 INSERT。

---

## 3.4 基于实体表的视图与交叉表查询

### 3.4.1 面向省区×拜访者×周区间的视图（长表）

这个视图只保留你最常用的维度和两个核心指标，专注在“省区×拜访者”这条线：

常规查询（长表形式）：

这张长表直接丢到 BI / Excel 里做透视，就是你要的“省区 / 拜访者 × week\_data 的交叉表”。

### 3.4.2 SQL 级别的交叉表（示例：最近 4 周）

如果你确实想在 SQL 层做一个“固定近 4 周”的交叉表，可以按下面模板来（示例，仅示意）：

```sql
sql-- 最近 4 个自然周（按 week_start_date 升序）
WITH recent_weeks AS (
    SELECT DISTINCT week_data, week_start_date
    FROM v_visit_submit_weekly_province_visitor
    ORDER BY week_start_date DESC
    LIMIT 4
),
ordered_weeks AS (
    SELECT
        week_data,
        week_start_date,
        ROW_NUMBER() OVER (ORDER BY week_start_date) AS rn
    FROM recent_weeks
)
SELECT
    v.province,
    v.visitor_name,
    MAX(CASE WHEN ow.rn = 1 THEN v.history_submit_rate_pct END) AS wk1_history_rate,
    MAX(CASE WHEN ow.rn = 1 THEN v.first_submit_rate_pct   END) AS wk1_first_rate,
    MAX(CASE WHEN ow.rn = 2 THEN v.history_submit_rate_pct END) AS wk2_history_rate,
    MAX(CASE WHEN ow.rn = 2 THEN v.first_submit_rate_pct   END) AS wk2_first_rate,
    MAX(CASE WHEN ow.rn = 3 THEN v.history_submit_rate_pct END) AS wk3_history_rate,
    MAX(CASE WHEN ow.rn = 3 THEN v.first_submit_rate_pct   END) AS wk3_first_rate,
    MAX(CASE WHEN ow.rn = 4 THEN v.history_submit_rate_pct END) AS wk4_history_rate,
    MAX(CASE WHEN ow.rn = 4 THEN v.first_submit_rate_pct   END) AS wk4_first_rate
FROM v_visit_submit_weekly_province_visitor v
JOIN ordered_weeks ow
  ON v.week_data = ow.week_data
GROUP BY
    v.province,
    v.visitor_name
ORDER BY
    v.province,
    v.visitor_name;
```

> 注意：列名里没办法直接动态带上 `week_data` ，这个层面建议交给 BI 工具处理；SQL 这边保证数据口径正确就行。

---

## 思维导图结构（文字版）

- 周维度上报率 & 交叉表方案
	- 需求拆解
		- 新增 week\_data（week\_start\_date + week\_end\_date）
		- 新增首次上报率指标
		- 实体表 + 视图 + 交叉表
	- SQL 改造
		- CTE 保持不变
		- prov\_visitor\_rates：新增 first\_submit\_rate\_from\_visit\_pct
		- 三个维度结果：统一补充 week\_end\_date & week\_data
	- 实体表设计 `visit_submit_weekly_stats`
		- 维度：dim\_level / province / visitor\_name / week\_key / week\_data
		- 指标：visit\_\* 计数 + 4 个比例指标
		- 主键：dim\_level + province + visitor\_name + week\_key
		- 灌数：INSERT … WITH … SELECT
	- 视图与交叉表
		- 视图： `v_visit_submit_weekly_province_visitor` （长表）
		- 常规分析：省区×拜访者×week\_data 趋势
		- SQL 交叉表：最近 N 周条件聚合示例
		- BI 透视：动态列头 = week\_data

---

## 《迭代日志》

- 【来源】
	- 你提供的原始周维度 SQL（省区 / 拜访者 / 全国整体），以及新增需求说明（week\_key → week\_data 映射、实体表、交叉表）。
- 【结论】
	- 在现有逻辑基础上，增量增加 `week_end_date` 与 `week_data` 字段，新增“首次上报率”指标；
	- 落地一张实体表 `visit_submit_weekly_stats` 和一个省区×拜访者维度视图 `v_visit_submit_weekly_province_visitor` ；
	- 交叉表推荐通过 BI 透视实现，同时提供一个 SQL 级“近 4 周”交叉表示例。
- 【改动点】
	1. CTE `prov_visitor_rates` 新增 `first_submit_rate_from_visit_pct` ；
	2. 三个结果 CTE（ `prov_visitor_with_rate` / `prov_overall_with_rate` / `national_overall` ）新增 `week_end_date` 和 `week_data` 字段；
	3. 最终 SELECT 和 实体表字段 对齐，保证可以一键插入；
	4. 新增实体表 DDL + INSERT 逻辑 + 省区×拜访者视图定义。
- 【待补充】
	1. 周结束日期是否最终就按“周一到周五”定稿，还是改为“周一到周日”；
	2. “首次上报率”的业务口径是否需要更精准（比如只统计“历史未上报且本周首次上报成功的站点”）；
	3. 实体表是否需要补充额外字段（如大区、拜访人 ID、组织层级等），方便后续更多维度分析。
- 【下一步建议】
	1. 先在测试环境跑一版改造后的 SELECT，对比几周数据（week\_key→week\_data、几个核心指标）是否符合你心中预期；
	2. 在确认周区间口径 & 首次上报率口径之后，再执行建表 + INSERT，跑足最近一年数据；
	3. 在 BI 中基于视图 `v_visit_submit_weekly_province_visitor` 搭一个标准看板：
		- 行：省区 / 拜访者；列：week\_data；值：历史上报率 / 首次上报率；
	4. 下一轮如果你愿意，可以把一两周实际业务解读的截图 / 看板效果发过来，我可以再帮你把指标解释和老板话术打磨成一页纸版本。

如果你愿意，下一步我可以帮你再把“首次上报率”的业务口径拉齐得更严谨（比如精确区分“历史上报支撑”和“本周新增首报”两类盘子），这样对商户画像项目的“站点补数策略”会更有价值。

20251205\_2135\_week\_data计算字段与周维度视图SQL方案

tags:: #周维度统计 #计算字段 #MySQL视图 #拜访上报率

---

**一句话结论：**  
不动你现有那段大 SQL，只在落地实体表时加一个基于 `week_start_date` 的计算列 `week_data` ，再基于实体表建一个“单指标 + 维度排序”的视图即可满足你现在的展示需求。

---

## 三段论据

### 论据一：week\_data 只在建表时做计算列，完全不入侵原 SQL

- 你现在的大 SQL 已经产出了 `week_key` 和 `week_start_date` 等所有底层字段，只是少一个“周区间”的可读文本展示。
- 我给出的方案是：建表时声明一个 **生成列** （Generated Column） `week_data` ，公式就是：
	> `week_data = DATE_FORMAT(week_start_date, '%m/%d') || '__' || DATE_FORMAT(week_start_date + 4天, '%m/%d')`
- 这样你在 `INSERT INTO ... SELECT ...` 时，保持原 SQL 完全不动，不插入 `week_data` ，MySQL 会自动根据 `week_start_date` 计算并存到表里（ `STORED` 生成列）。

### 论据二：视图只保留 1 个指标，通过维度+“整体优先”排序

- 根据你的习惯，视图只暴露一个核心指标，我这里先默认为 “历史上报率” 对应字段： `submit_history_rate_from_visit_pct` ，并统一别名为 `metric_value` 。
- 视图维度字段： `province / visitor_name / week_data` ，再加上这个单一指标。
- 排序策略：查询视图时，按  
	1）省区；  
	2） `visitor_name = '整体'` 的行优先；  
	3）同省区其它拜访人按 `metric_value` 降序；  
	4）再按 `visitor_name` 排个稳定顺序。

### 论据三：使用方式简单，后续要换指标只改视图一处

- 实体表只落一次结构，后面你可以定期用当前版本的 SQL 全量 / 增量刷新， `week_data` 会自动跟着算，不影响上游逻辑。
- 视图层只引用实体表，你想换指标（比如改成“同周闭环率”或“首次上报率”）时，只要改一行 `metric_value` 的来源字段即可，不动表结构。
- 报表/透视层（Excel 或 BI 工具）直接把视图丢进去，就可以做你截图那种“行=省区/拜访者，列=各周（week\_data/或 week\_key）”的交叉表。

---

## 一、实体表：带 week\_data 计算字段的建表 SQL

> 假设实体表名： `visit_submit_weekly_stats` （你可按命名规范调整）。

几点说明（跟你现在的 SQL 对齐）：

- 没有改动你的任何指标字段，只是多了一个 `week_data` 生成列；
- `week_data` 完全基于 `week_start_date` 计算，不需要你在插数 SQL 里手写；
- 如果哪天你想把“周一到周五”改成“周一到周日”，只要在 DDL 中把 `INTERVAL 4 DAY` 改成 `INTERVAL 6 DAY` 即可。

---

## 二、用你现有 SQL 往实体表灌数据（不改一行逻辑）

> 关键点： **不要把 `week_data` 写在 INSERT 列表里** ，让 MySQL 自己算。

```sql
sqlINSERT INTO visit_submit_weekly_stats (
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
)
-- 下面这段直接粘你“当前版本”的 SQL 即可，不需要任何改动
WITH
    base_store AS (
        SELECT 
            store_id,
            province,
            has_submit AS has_submit_history
        FROM station_tag_coverage_analysis_v3
    ),
    visit_store_week AS (
        SELECT
            b.store_id,
            b.province,
            YEARWEEK(v.visit_date, 1) AS week_key,
            MIN(DATE_SUB(v.visit_date, INTERVAL WEEKDAY(v.visit_date) DAY)) AS week_start_date,
            MAX(b.has_submit_history) AS has_submit_history
        FROM uir_visit_records v
        JOIN base_store b 
          ON v.station_id = b.store_id
        WHERE v.visit_date >= @start_date
        GROUP BY
            b.store_id,
            b.province,
            YEARWEEK(v.visit_date, 1)
    ),
    visit_store_week_visitor AS (
        SELECT
            b.store_id,
            b.province,
            v.visitor_name,
            YEARWEEK(v.visit_date, 1) AS week_key,
            MIN(DATE_SUB(v.visit_date, INTERVAL WEEKDAY(v.visit_date) DAY)) AS week_start_date,
            MAX(b.has_submit_history) AS has_submit_history
        FROM uir_visit_records v
        JOIN base_store b 
          ON v.station_id = b.store_id
        WHERE v.visit_date >= @start_date
          AND v.visitor_name IS NOT NULL
          AND v.visitor_name <> ''
        GROUP BY
            b.store_id,
            b.province,
            v.visitor_name,
            YEARWEEK(v.visit_date, 1)
    ),
    submit_store_week AS (
        SELECT
            b.store_id,
            b.province,
            YEARWEEK(s.create_time, 1) AS week_key
        FROM visit_records_enriched s
        JOIN base_store b 
          ON s.store_id = b.store_id
        WHERE s.create_time >= @start_date
          AND s.processing_status = 'success'
        GROUP BY
            b.store_id,
            b.province,
            YEARWEEK(s.create_time, 1)
    ),
    agg_province_visitor AS (
        SELECT
            v.province,
            v.visitor_name,
            v.week_key,
            MIN(v.week_start_date) AS week_start_date,
            COUNT(*) AS visit_station_cnt,
            SUM(CASE WHEN v.has_submit_history = 1 THEN 1 ELSE 0 END) 
                AS visit_with_history_submit_station_cnt,
            SUM(CASE WHEN v.has_submit_history = 0 OR v.has_submit_history IS NULL THEN 1 ELSE 0 END) 
                AS visit_never_submit_station_cnt,
            SUM(CASE WHEN s.store_id IS NOT NULL THEN 1 ELSE 0 END) 
                AS visit_submit_station_cnt
        FROM visit_store_week_visitor v
        LEFT JOIN submit_store_week s
          ON v.store_id = s.store_id
         AND v.province = s.province
         AND v.week_key = s.week_key
        GROUP BY
            v.province,
            v.visitor_name,
            v.week_key
    ),
    prov_visitor_rates AS (
        SELECT
            province,
            visitor_name,
            week_key,
            week_start_date,
            visit_station_cnt,
            visit_submit_station_cnt,
            visit_with_history_submit_station_cnt,
            visit_never_submit_station_cnt,
            ROUND(
                visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
                2
            ) AS submit_same_period_rate_from_visit_pct,
            ROUND(
                visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
                2
            ) AS submit_history_rate_from_visit_pct,
            ROUND(
                visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
                2
            ) AS never_submit_rate_from_visit_pct
        FROM agg_province_visitor
    ),
    prov_visitor_with_rate AS (
        SELECT
            'PROVINCE_VISITOR' AS dim_level,
            province,
            visitor_name,
            week_key,
            week_start_date,
            visit_station_cnt,
            visit_submit_station_cnt,
            visit_with_history_submit_station_cnt,
            visit_never_submit_station_cnt,
            submit_same_period_rate_from_visit_pct,
            submit_history_rate_from_visit_pct,
            never_submit_rate_from_visit_pct,
            RANK() OVER (
                PARTITION BY province, week_key
                ORDER BY
                    submit_same_period_rate_from_visit_pct DESC,
                    submit_history_rate_from_visit_pct     DESC,
                    never_submit_rate_from_visit_pct       ASC,
                    visit_station_cnt                      DESC
            ) AS rank_in_province
        FROM prov_visitor_rates
    ),
    agg_province_overall AS (
        SELECT
            v.province,
            v.week_key,
            MIN(v.week_start_date) AS week_start_date,
            COUNT(*) AS visit_station_cnt,
            SUM(CASE WHEN v.has_submit_history = 1 THEN 1 ELSE 0 END) 
                AS visit_with_history_submit_station_cnt,
            SUM(CASE WHEN v.has_submit_history = 0 OR v.has_submit_history IS NULL THEN 1 ELSE 0 END) 
                AS visit_never_submit_station_cnt,
            SUM(CASE WHEN s.store_id IS NOT NULL THEN 1 ELSE 0 END) 
                AS visit_submit_station_cnt
        FROM visit_store_week v
        LEFT JOIN submit_store_week s
          ON v.store_id = s.store_id
         AND v.province = s.province
         AND v.week_key = s.week_key
        GROUP BY
            v.province,
            v.week_key
    ),
    prov_overall_with_rate AS (
        SELECT
            'PROVINCE_OVERALL' AS dim_level,
            province,
            '整体' AS visitor_name,
            week_key,
            week_start_date,
            visit_station_cnt,
            visit_submit_station_cnt,
            visit_with_history_submit_station_cnt,
            visit_never_submit_station_cnt,
            ROUND(
                visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
                2
            ) AS submit_same_period_rate_from_visit_pct,
            ROUND(
                visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
                2
            ) AS submit_history_rate_from_visit_pct,
            ROUND(
                visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
                2
            ) AS never_submit_rate_from_visit_pct,
            CAST(NULL AS SIGNED) AS rank_in_province
        FROM agg_province_overall
    ),
    national_overall AS (
        SELECT
            'NATIONAL_OVERALL' AS dim_level,
            '全国' AS province,
            '整体' AS visitor_name,
            week_key,
            MIN(week_start_date) AS week_start_date,
            SUM(visit_station_cnt) AS visit_station_cnt,
            SUM(visit_submit_station_cnt) AS visit_submit_station_cnt,
            SUM(visit_with_history_submit_station_cnt) AS visit_with_history_submit_station_cnt,
            SUM(visit_never_submit_station_cnt) AS visit_never_submit_station_cnt,
            ROUND(
                SUM(visit_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
                2
            ) AS submit_same_period_rate_from_visit_pct,
            ROUND(
                SUM(visit_with_history_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
                2
            ) AS submit_history_rate_from_visit_pct,
            ROUND(
                SUM(visit_never_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
                2
            ) AS never_submit_rate_from_visit_pct,
            CAST(NULL AS SIGNED) AS rank_in_province
        FROM agg_province_overall
        GROUP BY
            week_key
    )
SELECT
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
FROM (
    SELECT * FROM national_overall
    UNION ALL
    SELECT * FROM prov_overall_with_rate
    UNION ALL
    SELECT * FROM prov_visitor_with_rate
) t;
```

> 这里你只要把这段和你现在线上跑的版本保持一致即可，逻辑上是 1:1 的，只是加了一个 INSERT 外壳。

---

## 三、基于实体表的“单指标视图”与排序查询

### 3.1 视图：只暴露 1 个指标 + 维度字段

> 这里我以“历史上报率”为例，统一别名为 `metric_value` 。  
> 如果你要改成其它指标，只要换一下字段即可。

### 3.2 查询视图时按“整体优先 + 指标降序”排序

> 这个 SELECT 就对应你截图里的排布逻辑。

后续你在 BI / Excel 里，把 `week_data` 拿去做列头透视，就能得到和你截图类似的交叉表（行=省区/拜访者，列=各周）。

---

## 思维导图结构（文字版）

- 目标：在不改原 SQL 的前提下补充 week\_data + 标准视图
	- 实体表设计
		- 维度：dim\_level / province / visitor\_name / week\_key / week\_start\_date
		- 计算列：week\_data = 周一 ~ 周五区间
		- 指标：visit\_\* 计数 + 3 个比例 + rank
	- 数据灌入
		- 使用现有 WITH SQL
		- INSERT INTO … SELECT
		- 不插入 week\_data，让 MySQL 自动算
	- 视图设计
		- 维度：province / visitor\_name / week\_data
		- 单指标：history\_rate → metric\_value
		- 过滤 dim\_level in (OVERALL, VISITOR)
	- 查询与排序
		- 排序规则：省区 → “整体”优先 → 指标降序 → 姓名
		- 透视：在报表工具里将 week\_data 做列头

---

## 《迭代日志》

- 【来源】
	- 上一轮周维度 SQL 改造方案；
	- 你补充的需求：
		- 不入侵原 SQL，只在实体表层用计算字段生成 week\_data；
		- 基于实体表建“单指标视图”，并支持按省区+整体优先+指标降序排序。
- 【结论】
	- 用一个 `GENERATED ALWAYS AS` 计算列在物理表中生成 `week_data` ，完全不改原有 CTE 逻辑；
	- 实体表通过 `INSERT INTO ... SELECT` 从现有 SQL 灌数；
	- 视图 `v_visit_submit_weekly_history` 只暴露一个指标 `metric_value` ，查询时按“整体优先 + 指标降序”进行排序。
- 【改动点】
	1. 新增实体表建表 SQL，包含 week\_data 生成列；
	2. 封装了你现有 SQL 的 INSERT 版本，保证你直接粘贴即可；
	3. 新建视图，只保留 1 个指标字段，并提供排序查询模板。
- 【待补充】
	1. 最终你决定在视图里用哪一个指标作为 `metric_value` （同周闭环率 / 历史上报率 / 首次上报率）；
	2. 是否需要再建一个“首上报率专用视图”，方便后续做两个指标的对比；
	3. 如果有多层组织（大区 / 省区 / 小组），是否要在实体表里再补充组织维度字段。
- 【下一步建议】
	1. 先在测试库按上述建表 + INSERT + 视图，跑一版数据，对比几周结果和你现有报表是否一致；
	2. 把视图丢进你现在做截图的那套报表工具里，看一下 `week_data` 展示效果是否符合预期；
	3. 如果你确定某个指标（比如“历史上报率”）是老板要看的主指标，我可以帮你再写一版“老板话术 + 视图字段说明”，做成一页纸说明文档。

20251205\_2210\_INSERT无数据问题修正方案

tags:: #MySQL #CTE #INSERT\_SELECT #周维度统计

---

**一句话结论：**  
你这次 0 行写入，最可能原因是 `@start_date` 没生效导致整条链路过滤掉了所有数据，我直接把变量改成表达式内联到 CTE 里，给你一版「自包含、可直接跑」的 INSERT 语句。

---

### 关键说明（先说人话）

1. 之前的 INSERT 版本依赖 `SET @start_date := ...` 这句，如果客户端没执行到/没开多语句，就等价于 `visit_date >= NULL` ，结果全被过滤掉，SELECT 自然是 0 行。
2. 现在这版不再用用户变量，全部改成：
	- `WHERE v.visit_date >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)`
	- `WHERE s.create_time >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)`  
		这样只要跑这一条 INSERT，就一定会有数据（前提是你原来那条 SELECT 有数据）。
3. 表结构不变， `week_data` 仍然是生成列，不需要你在 INSERT 里管它。

---

## 一、确认一下表结构（不需要改）

如果你已经建好就不用再执行；只是方便你对一下字段顺序。

---

## 二、修正后的 INSERT…WITH…SELECT（不再依赖 @start\_date）

> 这条可以整条直接丢进 MySQL 跑，不需要额外的 `SET` 。

```sql
sqlINSERT INTO visit_submit_weekly_stats (
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
)
WITH
-- 1. 基准油站
base_store AS (
    SELECT 
        store_id,
        province,
        has_submit AS has_submit_history
    FROM station_tag_coverage_analysis_v3
),

-- 2A. 按「店 × 省 × 周」聚合的拜访（省整体 / 全国整体用）
visit_store_week AS (
    SELECT
        b.store_id,
        b.province,
        YEARWEEK(v.visit_date, 1) AS week_key,
        MIN(DATE_SUB(v.visit_date, INTERVAL WEEKDAY(v.visit_date) DAY)) AS week_start_date,
        MAX(b.has_submit_history) AS has_submit_history
    FROM uir_visit_records v
    JOIN base_store b 
      ON v.station_id = b.store_id
    WHERE v.visit_date >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)   -- 直接用表达式
    GROUP BY
        b.store_id,
        b.province,
        YEARWEEK(v.visit_date, 1)
),

-- 2B. 按「店 × 省 × 拜访者 × 周」聚合的拜访（省×拜访者用）
visit_store_week_visitor AS (
    SELECT
        b.store_id,
        b.province,
        v.visitor_name,
        YEARWEEK(v.visit_date, 1) AS week_key,
        MIN(DATE_SUB(v.visit_date, INTERVAL WEEKDAY(v.visit_date) DAY)) AS week_start_date,
        MAX(b.has_submit_history) AS has_submit_history
    FROM uir_visit_records v
    JOIN base_store b 
      ON v.station_id = b.store_id
    WHERE v.visit_date >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)   -- 直接用表达式
      AND v.visitor_name IS NOT NULL
      AND v.visitor_name <> ''
    GROUP BY
        b.store_id,
        b.province,
        v.visitor_name,
        YEARWEEK(v.visit_date, 1)
),

-- 3. 按「店 × 省 × 周」聚合的成功上报
submit_store_week AS (
    SELECT
        b.store_id,
        b.province,
        YEARWEEK(s.create_time, 1) AS week_key
    FROM visit_records_enriched s
    JOIN base_store b 
      ON s.store_id = b.store_id
    WHERE s.create_time >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)  -- 直接用表达式
      AND s.processing_status = 'success'
    GROUP BY
        b.store_id,
        b.province,
        YEARWEEK(s.create_time, 1)
),

-- 4. 省 × 拜访者 × 周：底层计数
agg_province_visitor AS (
    SELECT
        v.province,
        v.visitor_name,
        v.week_key,
        MIN(v.week_start_date) AS week_start_date,
        COUNT(*) AS visit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 1 THEN 1 ELSE 0 END) 
            AS visit_with_history_submit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 0 OR v.has_submit_history IS NULL THEN 1 ELSE 0 END) 
            AS visit_never_submit_station_cnt,
        SUM(CASE WHEN s.store_id IS NOT NULL THEN 1 ELSE 0 END) 
            AS visit_submit_station_cnt
    FROM visit_store_week_visitor v
    LEFT JOIN submit_store_week s
      ON v.store_id = s.store_id
     AND v.province = s.province
     AND v.week_key = s.week_key
    GROUP BY
        v.province,
        v.visitor_name,
        v.week_key
),

-- 5. 省 × 拜访者 × 周：算比例
prov_visitor_rates AS (
    SELECT
        province,
        visitor_name,
        week_key,
        week_start_date,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        ROUND(
            visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS never_submit_rate_from_visit_pct
    FROM agg_province_visitor
),

-- 6. 省 × 拜访者 × 周：加 rank
prov_visitor_with_rate AS (
    SELECT
        'PROVINCE_VISITOR' AS dim_level,
        province,
        visitor_name,
        week_key,
        week_start_date,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        submit_same_period_rate_from_visit_pct,
        submit_history_rate_from_visit_pct,
        never_submit_rate_from_visit_pct,
        RANK() OVER (
            PARTITION BY province, week_key
            ORDER BY
                submit_same_period_rate_from_visit_pct DESC,
                submit_history_rate_from_visit_pct     DESC,
                never_submit_rate_from_visit_pct       ASC,
                visit_station_cnt                      DESC
        ) AS rank_in_province
    FROM prov_visitor_rates
),

-- 7. 省整体 × 周
agg_province_overall AS (
    SELECT
        v.province,
        v.week_key,
        MIN(v.week_start_date) AS week_start_date,
        COUNT(*) AS visit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 1 THEN 1 ELSE 0 END) 
            AS visit_with_history_submit_station_cnt,
        SUM(CASE WHEN v.has_submit_history = 0 OR v.has_submit_history IS NULL THEN 1 ELSE 0 END) 
            AS visit_never_submit_station_cnt,
        SUM(CASE WHEN s.store_id IS NOT NULL THEN 1 ELSE 0 END) 
            AS visit_submit_station_cnt
    FROM visit_store_week v
    LEFT JOIN submit_store_week s
      ON v.store_id = s.store_id
     AND v.province = s.province
     AND v.week_key = s.week_key
    GROUP BY
        v.province,
        v.week_key
),

prov_overall_with_rate AS (
    SELECT
        'PROVINCE_OVERALL' AS dim_level,
        province,
        '整体' AS visitor_name,
        week_key,
        week_start_date,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        ROUND(
            visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100, 
            2
        ) AS never_submit_rate_from_visit_pct,
        CAST(NULL AS SIGNED) AS rank_in_province
    FROM agg_province_overall
),

-- 8. 全国整体 × 周
national_overall AS (
    SELECT
        'NATIONAL_OVERALL' AS dim_level,
        '全国' AS province,
        '整体' AS visitor_name,
        week_key,
        MIN(week_start_date) AS week_start_date,
        SUM(visit_station_cnt) AS visit_station_cnt,
        SUM(visit_submit_station_cnt) AS visit_submit_station_cnt,
        SUM(visit_with_history_submit_station_cnt) AS visit_with_history_submit_station_cnt,
        SUM(visit_never_submit_station_cnt) AS visit_never_submit_station_cnt,
        ROUND(
            SUM(visit_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            SUM(visit_with_history_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            SUM(visit_never_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100, 
            2
        ) AS never_submit_rate_from_visit_pct,
        CAST(NULL AS SIGNED) AS rank_in_province
    FROM agg_province_overall
    GROUP BY
        week_key
)

-- 9. 合并三类维度：全国整体 / 省整体 / 省×拜访者
SELECT
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
FROM (
    SELECT * FROM national_overall
    UNION ALL
    SELECT * FROM prov_overall_with_rate
    UNION ALL
    SELECT * FROM prov_visitor_with_rate
) t;
```

建议你在执行前，先用相同的 WITH + 最后一段 SELECT 单独跑一下，看是否有结果数（应该是 >0），再执行 INSERT。

---

## 三、视图这块不用改（提醒一下用法）

之前给你的视图可以继续用，核心就是：从 `visit_submit_weekly_stats` 取 `week_data` + 单指标，然后按省区 / “整体优先”排序即可，例如：

查询排序：

---

## 《迭代日志》

- 【来源】
	- 上轮的实体表 + INSERT + 视图方案；
	- 你反馈“INSERT 执行成功但写入 0 行”。
- 【结论】
	- 问题高概率出在 `@start_date` 变量没有生效，导致所有记录都被 `WHERE v.visit_date >= @start_date` 过滤掉；
	- 改成在 CTE 里直接使用 `DATE_SUB(CURDATE(), INTERVAL 12 WEEK)` 后，INSERT 将不再依赖外部变量。
- 【改动点】
	1. 删除所有 `@start_date` 变量使用；
	2. 直接在 `visit_store_week` 、 `visit_store_week_visitor` 、 `submit_store_week` 的 WHERE 子句中内联时间表达式；
	3. 其它逻辑保持不变。
- 【待补充】
	- 如果你修改时间窗口（比如固定按自然周号 202542-202548），可以再给我口径，我帮你改成“写死周号”的版本。
- 【下一步建议】
	- 先按上面这条 INSERT 跑一遍，看 `affected rows` 是否 >0，再 `SELECT * FROM visit_submit_weekly_stats LIMIT 10` 验证；
	- 如果还有问题，把“单独跑 WITH…SELECT 的结果行数”和“INSERT 影响行数”告诉我，我直接帮你查链路哪一层被卡住。

20251205\_2305\_数仓一键产出周维表所需信息清单

tags:: #数仓建模 #ETL链路 #SQL需求澄清 #数据血缘

---

**一句话结论：**  
把现在“下载+本地加工”的逻辑收回数仓，用一条（或一套）SQL 任务一键产出周维结果表是更合理的，但要做到这一点，你需要先补齐：目标表定义、上游表结构与关联关系、加工步骤/规则三大块信息，我再帮你还原成完整的数仓 SQL 链路。

---

## 一、先肯定方向：从“本地脚本”升级到“数仓链路”是必要的

1. 现在的模式：
	- 上游在线表 → 你手工下载/导出 → 本地加工（脚本/Excel）→ 导入到当前 MySQL 表，再在上面做周维统计。
	- 问题：链路不可追溯、难自动化、任何逻辑变更都要你本地改一遍。
2. 进阶目标（你刚提的）：
	- 直接在数仓任务里写一个完整 SQL（或 SQL DAG），从数仓原始表出发，一键产出我们刚才设计的 `visit_submit_weekly_stats` 这种结果表；
	- 上游在线表/接口 → 数仓 ODS/DWD 表 → 一条任务跑完直接落结果，彻底消除“本地黑盒加工”。
3. 实话实说：
	- “完全单条超长 SQL”在数仓里不一定是最佳实践，更推荐拆成 2–3 个逻辑清晰的层（ODS → 明细宽表 → 周维汇总）再由调度编排；
	- 但从你的角度，只要你把上游信息补全，我这边可以先按“一条可执行 SQL”的标准去写，再根据性能/可维护性决定要不要拆层。

---

## 二、你需要提供的关键信息：三大板块 + 一个加分项

可以直接理解为：只要你把下面东西给齐，我就能帮你把“周维结果表”的整条数仓 SQL 链路写出来。

### 1\. 目标表定义（我们现在这个周维结果）

这块其实我们已经有 80%，但还是建议你整理成一页清单发给我：

- 1）目标表名（数仓里的正式命名）
	- 例如： `dws_visit_submit_weekly_stats_d` 或你们现有规范里的命名。
- 2）字段列表（字段名 + 类型 + 业务含义）
	- 包含：
		- 维度： `dim_level / province / visitor_name / week_key / week_start_date / week_data`
		- 指标： `visit_station_cnt / visit_submit_station_cnt / visit_with_history_submit_station_cnt / visit_never_submit_station_cnt / submit_*_rate_* / rank_in_province`
	- 哪些字段是生成列（比如 `week_data` ）、哪些是物理存储。
- 3）主键 / 唯一键
	- 现在我们设计的是 `(dim_level, province, visitor_name, week_key)` ，你看是否要加业务主键（比如加大区、组织等）。
- 4）分区字段 & 调度周期
	- 按周分区还是按日分区？
	- 任务是周调度还是日调度（每天滚动更新最近 12 周）？

> 这部分其实主要是“确认口径”。我已经有一版草案，你只要把你们数仓规范告诉我，我可以顺手帮你重命名、调字段类型。

### 2\. 上游源表信息：不仅是表名字段，还要“这列到底啥意思”

目前我看到的 `station_tag_coverage_analysis_v3 / uir_visit_records / visit_records_enriched` 都是你本地加工后的表。  
要写数仓 SQL，需要的是它们在数仓里的“原型”，大致分三类：

1. **站点主数据 / 画像基础表** （对应现在的 `station_tag_coverage_analysis_v3` ）
	- 数仓表名（ODS/DWD）：例如 `dwd_station_base_di` 之类；
	- 关键字段：
		- `store_id` （主键）、 `province` 、大区、所属组织、是否 KA、是否在营等；
		- 当前用的 `has_submit` 在数仓里的来源字段是什么？是标记“历史是否有过成功上报”还是别的。
	- 字段含义：每个字段 1 句话就行，特别是 `has_submit` 这类衍生字段的计算逻辑。
2. **拜访记录明细表** （对应 `uir_visit_records` ）
	- 数仓表名：例如 `dwd_visit_record_di` ；
	- 关键字段：
		- `station_id` / `store_id` 、 `visit_date` 、 `visit_time` 、 `visitor_id` 、 `visitor_name` 、拜访类型、渠道来源等；
	- 特别重要的信息：
		- 一天同一个站点多次拜访怎么处理？
		- 是否已经在数仓层做过去重 / 合并？
3. **标签上报记录表** （对应 `visit_records_enriched` ）
	- 数仓表名：例如 `dwd_tag_submit_record_di` ；
	- 关键字段：
		- `store_id` 、 `create_time` 、 `processing_status` 、上报来源（APP、小程序等）、上报批次、错误码等；
	- 关键逻辑：
		- “成功上报”在数仓层的判断条件是什么？是只看 `processing_status = 'success'` ，还是还要筛掉某些错误/回滚？

你给我的最少信息标准：

> 每张源表： **表名 + 业务含义 + 关键字段列表（字段名/类型/含义/是否可为空）+ 主键/索引 + 取数范围（分区字段）** 。

如果你愿意多给一点：

> 提供一小段“从线上到数仓这张表的大致迁移逻辑”（比如是接口入库还是 binlog），我可以更准确地考虑延迟、增量等问题。

### 3\. 加工步骤 / 业务规则：把现在本地脚本在做的事讲清楚

你可以不用给代码，只要按“步骤+规则”把逻辑说清楚即可，我再翻译成 SQL。

建议你按下面维度整理：

1. **时间窗口规则**
	- 现在我们默认“最近 12 周”：是否固定？还是按自然周号 `202542 ~ 当前周` ？
	- 每周起始日是否永远是“周一”？有没有节假日特殊处理？
2. **拜访层去重规则**
	- 一站一周是不是只算 1 次拜访？（看你现在的 `visit_store_week` 是按站×周聚合的）；
	- 如果一天有多条拜访记录，怎么算“有效”？你本地有没有做过筛选（比如只保留最新一笔）？
3. **站点盘子筛选规则**
	- 有没有过滤掉停运站、黑名单站（加盟已解约等）？
	- `base_store` 是所有站点还是“某个业务线的站点子集”？
4. **上报匹配规则**
	- 拜访和上报是按 “站点+省份+week\_key” 匹配的，还是还有别的条件？
	- “同周闭环”是不是只要在同一自然周有一条成功上报就算闭环？
5. **历史支撑 / 首次上报 的业务定义**
	- `has_submit_history = 1` ：是“截止本周之前曾有过任何成功上报”？
	- `visit_with_history_submit_station_cnt` 是“拜访时已经有历史上报的盘子”；
	- `visit_never_submit_station_cnt` 是“拜访时从未上报过的盘子”；
	- 有无特别业务要求，比如：某些标签上报不算在“历史支撑”里。

你可以直接用自然语言描述，比如：

> - 历史上报：以标签主表 X，看该站点是否在当前周之前有任意成功记录；
> - 拜访盘子：从拜访记录表取最近 12 周，有拜访的站点视为纳入盘子；
> - 一周内有多次拜访/上报，按“是否存在”标记，不做次数统计。

这种程度就足够我翻译成 SQL 了。

### 4\. 加分项：示例数据 / 现有报表截图

- 你刚发的那张“省区 / 拜访人 / 周号 202542-202548”的截图就很有价值；
- 如果再给我：
	- 1 个站点的“拜访明细 + 上报明细”样例；
	- 对应它在结果表里的几周指标；
- 我可以拿来做“单站点回放校验”，确保数仓 SQL 的口径 100% 贴合你现在的结果。

---

## 三、从信息到 SQL 的落地路径（给你一个心理预期）

1. **第一步：还原本地黑盒逻辑**
	- 你把“上游表 + 字段 + 规则”按上面三个模块丢给我；
	- 我先用伪代码/流程图还原出：
		- 源表 → 拜访周表 → 上报周表 → 站点属性 → 周维汇总。
2. **第二步：按数仓风格重写 SQL 链路**
	- 先写一条“全量周维结果 SQL”，确保在你本地现有表上结果一致；
	- 再映射到数仓表名和字段，产出 “ODS→DWD→DWS→结果表” 的标准 SQL。
3. **第三步：考虑增量 & 调度**
	- 决定按天/按周增量刷新方式（比如每天重算最近 N 周，或者只算最新一周）；
	- 给出任务依赖关系（上游哪些表要先就绪、需要的分区日期参数等）。

---

## 思维导图结构（文字版）

- 目标：数仓里一键产出周维结果表
	- 方向确认
		- 从本地脚本迁移到数仓任务
		- 逻辑集中、可追溯、可自动化
	- 需要补充的信息
		- 目标表定义
			- 表名、字段、主键、分区、调度周期
		- 上游源表信息
			- 站点主数据表
			- 拜访明细表
			- 上报明细表
			- 各字段含义 & 主键/分区
		- 加工规则
			- 时间窗口、周定义
			- 拜访去重与盘子口径
			- 上报匹配规则
			- 历史上报/首次上报定义
		- 加分项
			- 单站点样例数据
			- 现有报表截面
	- 落地路径
		- 还原黑盒逻辑
		- 重写数仓 SQL 链路
		- 设计增量与调度依赖

---

## 《迭代日志》

- 【来源】
	- 你反馈：当前周维结果表是由“下载在线数据 → 本地加工 → 导入”生成；
	- 新问题：是否可以在数仓中用一条完整 SQL 直接产出结果表，并询问“需要给你哪些信息”才能写出这条 SQL。
- 【结论】
	- 方向是正确的：应当把逻辑上收到数仓中，形成可调度、可回溯的标准任务；
	- 为了写出完整 SQL，需要你补齐：  
		1）目标结果表的正式定义；  
		2）数仓中对应的站点、拜访、上报等上游源表的结构与含义；  
		3）本地加工的业务规则（时间窗口、去重、盘子、匹配、历史/首报定义）；  
		4）最好附带一两个样例用来验证口径。
- 【改动点】
	- 从“直接改 SQL”转为“先梳理数据血缘和规则，再重写数仓链路”；
	- 给出了一个具体的“信息收集清单”，方便你一次性把材料准备好。
- 【待补充】
	- 数仓类型（MySQL / ClickHouse / Hive / StarRocks 等），会影响一些函数/日期写法；
	- 上游具体表名和你们内部的数据分层规范（ODS/DWD/DWS 命名），方便我直接按规范输出。
- 【下一步建议】
	1. 先按“三大板块”整理一个简版文档（可以直接在对话里贴：目标表定义 + 3 张源表结构 + 规则说明）；
	2. 我先基于“你当前本地表”写一条对等的全量 SQL，验证口径完全一致；
	3. 再把这条 SQL 映射到数仓的真实表名/字段，顺便帮你拆成合理的 2–3 层，形成最终可以放进调度系统的脚本。

你可以先从最简单的开始：把“数仓里的拜访明细表 + 上报明细表”的建表语句（或字段清单）直接贴一版给我，我们就可以开始还原上游链路了。

20251206\_0030\_拜访表与上报表组合生成周维统计表visit\_submit\_weekly\_stats

tags:: #拜访数据 #标签上报 #周维统计 #SQL链路 #字段映射

---

**一句话结论：**  
完全可以只用你给的两张上游表 a（拜访）和 b（标签上报）在数仓里一键生成 `visit_submit_weekly_stats` ，关键是先约定好字段映射和“历史上报 / 首次上报”的业务口径，再按这个口径写一条分层清晰的 SQL 链路。

---

## 一、核心映射逻辑（a、b → visit\_submit\_weekly\_stats）

先说清楚“谁变成谁”。

### 1\. 维度字段映射

| 结果表字段 | 来自哪张表 | 字段/规则 |
| --- | --- | --- |
| `store_id` | a / b | 主键字段，a.store\_id = b.store\_id |
| `province` | a | 从 `sign_address` 解析省份：如 `SUBSTRING(sign_address,1,LOCATE('省',sign_address))` ，若没有“省”，可退化用 `city_name` |
| `visitor_name` | a | `visitor_name` （拜访人姓名） |
| `week_key` | a/b | `YEARWEEK(visit_date,1)` ， `visit_date = DATE(visiting_start_time)` （缺失时退化用 sign\_time/create\_time） |
| `week_start_date` | a | 该周周一： `DATE_SUB(visit_date, INTERVAL WEEKDAY(visit_date) DAY)` |
| `week_data` | 结果表 | 由 `week_start_date` 计算的生成列： `MM/DD__MM/DD` （周一~周五） |
| `dim_level` | 逻辑生成 | `'PROVINCE_VISITOR'` （省×拜访人）、 `'PROVINCE_OVERALL'` （省整体）、 `'NATIONAL_OVERALL'` （全国整体） |

> 说明：
> 
> - 省份这块我用 `sign_address` 拆省，如果你后面有正式“省区维表”，直接 join 那张表会更稳。
> - `week_data` 仍然放在物理表里做计算字段，不在 SQL 里手算，避免入侵。

### 2\. 统计口径映射（计数怎么来的）

我们把 a 表理解为“拜访记录表”，b 表理解为“标签上报成功记录表”。

1. 先把 a 表按 “店 × 省 × 拜访人 × 周” 聚合，得到基础拜访盘子：
	- 每一行 = 一个拜访人在某周拜访了某个站（去重后的站粒度）；
	- 记作 `visit_store_week_visitor` 。
2. 再把 b 表按 “店 × 周” 聚合，得到周维上报盘子：
	- 每一行 = 某站在某周是否有上报（只关心有没有，不关心次数）；
	- 记作 `submit_store_week` 。
3. 历史上报口径（关键变化点，直说）：
	- 从 b 表算 `first_submit_week_key = MIN(YEARWEEK(create_time,1))` ，表示“这个站第一次发生上报是在第几周”；
	- 对于拜访发生在周 `W` 的记录：
		- 如果 `first_submit_week_key < W` ⇒ 该站在本周拜访前“已有历史上报”，算入 `visit_with_history_submit_station_cnt` ；
		- 如果 `first_submit_week_key IS NULL` 或 `first_submit_week_key >= W` ⇒ 视作“历史无上报”，算入 `visit_never_submit_station_cnt` 。
4. 同周闭环：
	- 只要该站在同一周存在上报记录（ `submit_store_week` 有行），就算 1 个闭环站，计入 `visit_submit_station_cnt` 。

### 3\. 汇总到省、全国维度

在有了 “省×拜访人×周” 这层明细之后：

1. 省×拜访人×周（ `PROVINCE_VISITOR` ）：
	- `visit_station_cnt` = 该拜访人该周拜访到的站点数（行数）；
	- `visit_submit_station_cnt` 、 `visit_with_history_submit_station_cnt` 、 `visit_never_submit_station_cnt` 都是上面说的按条件求和；
	- 比例：
		- `submit_same_period_rate_from_visit_pct = visit_submit_station_cnt / visit_station_cnt`
		- `submit_history_rate_from_visit_pct = visit_with_history_submit_station_cnt / visit_station_cnt`
		- `never_submit_rate_from_visit_pct = visit_never_submit_station_cnt / visit_station_cnt`
	- 排名：在同省同周内按“同周闭环率 ↓，历史上报率 ↓，首上报盘占比 ↑，拜访盘子 ↓”排序求 `rank_in_province` 。
2. 省整体×周（ `PROVINCE_OVERALL` ）：
	- 在省内聚合所有拜访人，逻辑完全一样，只是去掉 `visitor_name` 维度，统一写成 `'整体'` 。
3. 全国整体×周（ `NATIONAL_OVERALL` ）：
	- 在所有省维度上再聚一次，把省级指标按加总/加权重新算一遍比例。

---

## 二、基于表 a/b 的完整 SQL 链路示例（生成 visit\_submit\_weekly\_stats）

下面给你一条“自包含”的 SQL：

- 只用两张表： `a` （拜访）、 `b` （上报）；
- 直接 `INSERT` 到我们之前建好的 `visit_submit_weekly_stats` （有 week\_data 生成列）；
- 时间窗口：最近 12 周，你可以替换成固定周号。
```sql
sqlINSERT INTO visit_submit_weekly_stats (
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
)
WITH
-- 0. 拜访原始表的标准化：抽出访日期、省份
visit_source AS (
    SELECT
        v.store_id,
        -- 省份：优先从详细地址拆“XX省”，没有就退化用城市名
        CASE 
            WHEN v.sign_address LIKE '%省%' THEN SUBSTRING(v.sign_address, 1, LOCATE('省', v.sign_address))
            ELSE v.city_name
        END AS province,
        v.visitor_name,
        -- 访日期：优先用 visiting_start_time，其次 sign_time，再次 create_time
        DATE(
            COALESCE(
                v.visiting_start_time,
                v.sign_time,
                v.create_time
            )
        ) AS visit_date
    FROM a v
    WHERE DATE(
            COALESCE(
                v.visiting_start_time,
                v.sign_time,
                v.create_time
            )
          ) >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)
),

-- 1A. 店 × 省 × 周 明细（省整体用）
visit_store_week AS (
    SELECT
        store_id,
        province,
        YEARWEEK(visit_date, 1) AS week_key,
        MIN(DATE_SUB(visit_date, INTERVAL WEEKDAY(visit_date) DAY)) AS week_start_date
    FROM visit_source
    GROUP BY
        store_id,
        province,
        YEARWEEK(visit_date, 1)
),

-- 1B. 店 × 省 × 拜访人 × 周 明细（省×拜访人用）
visit_store_week_visitor AS (
    SELECT
        store_id,
        province,
        visitor_name,
        YEARWEEK(visit_date, 1) AS week_key,
        MIN(DATE_SUB(visit_date, INTERVAL WEEKDAY(visit_date) DAY)) AS week_start_date
    FROM visit_source
    WHERE visitor_name IS NOT NULL
      AND visitor_name <> ''
    GROUP BY
        store_id,
        province,
        visitor_name,
        YEARWEEK(visit_date, 1)
),

-- 2A. 上报原始明细
submit_source AS (
    SELECT
        s.store_id,
        DATE(s.create_time) AS submit_date,
        YEARWEEK(DATE(s.create_time), 1) AS submit_week_key
    FROM b s
),

-- 2B. 每站第一次上报周（用于判断“历史上报”）
first_submit_per_store AS (
    SELECT
        store_id,
        MIN(submit_week_key) AS first_submit_week_key
    FROM submit_source
    GROUP BY store_id
),

-- 2C. 店 × 周 上报明细（只看最近 12 周，用于“同周闭环”）
submit_store_week AS (
    SELECT
        store_id,
        submit_week_key AS week_key
    FROM submit_source
    WHERE submit_date >= DATE_SUB(CURDATE(), INTERVAL 12 WEEK)
    GROUP BY
        store_id,
        submit_week_key
),

-- 3. 省 × 拜访人 × 周 聚合
agg_province_visitor AS (
    SELECT
        v.province,
        v.visitor_name,
        v.week_key,
        MIN(v.week_start_date) AS week_start_date,
        COUNT(*) AS visit_station_cnt,  -- 一行就是一个“站×周”，直接计数即可

        -- 历史上报站点数：第一次上报周 < 当前拜访周
        SUM(
            CASE
                WHEN fs.first_submit_week_key IS NOT NULL
                 AND fs.first_submit_week_key < v.week_key
                THEN 1 ELSE 0
            END
        ) AS visit_with_history_submit_station_cnt,

        -- 历史无上报站点数：从未上报或第一次上报周 >= 当前拜访周
        SUM(
            CASE
                WHEN fs.first_submit_week_key IS NULL
                  OR fs.first_submit_week_key >= v.week_key
                THEN 1 ELSE 0
            END
        ) AS visit_never_submit_station_cnt,

        -- 同周有上报的站点数（闭环）
        SUM(
            CASE
                WHEN s.store_id IS NOT NULL THEN 1 ELSE 0
            END
        ) AS visit_submit_station_cnt
    FROM visit_store_week_visitor v
    LEFT JOIN first_submit_per_store fs
      ON v.store_id = fs.store_id
    LEFT JOIN submit_store_week s
      ON v.store_id = s.store_id
     AND v.week_key = s.week_key
    GROUP BY
        v.province,
        v.visitor_name,
        v.week_key
),

-- 4. 省 × 拜访人 × 周 计算比率 + 排名
prov_visitor_with_rate AS (
    SELECT
        'PROVINCE_VISITOR' AS dim_level,
        province,
        visitor_name,
        week_key,
        week_start_date,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        ROUND(
            visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS never_submit_rate_from_visit_pct,
        RANK() OVER (
            PARTITION BY province, week_key
            ORDER BY
                -- 1. 同周闭环率高优先
                visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) DESC,
                -- 2. 历史上报率高优先
                visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) DESC,
                -- 3. 首报盘占比低优先
                visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) ASC,
                -- 4. 拜访盘子大优先
                visit_station_cnt DESC
        ) AS rank_in_province
    FROM agg_province_visitor
),

-- 5. 省整体 × 周 聚合
agg_province_overall AS (
    SELECT
        v.province,
        v.week_key,
        MIN(v.week_start_date) AS week_start_date,
        COUNT(*) AS visit_station_cnt,
        SUM(
            CASE
                WHEN fs.first_submit_week_key IS NOT NULL
                 AND fs.first_submit_week_key < v.week_key
                THEN 1 ELSE 0
            END
        ) AS visit_with_history_submit_station_cnt,
        SUM(
            CASE
                WHEN fs.first_submit_week_key IS NULL
                  OR fs.first_submit_week_key >= v.week_key
                THEN 1 ELSE 0
            END
        ) AS visit_never_submit_station_cnt,
        SUM(
            CASE
                WHEN s.store_id IS NOT NULL THEN 1 ELSE 0
            END
        ) AS visit_submit_station_cnt
    FROM visit_store_week v
    LEFT JOIN first_submit_per_store fs
      ON v.store_id = fs.store_id
    LEFT JOIN submit_store_week s
      ON v.store_id = s.store_id
     AND v.week_key = s.week_key
    GROUP BY
        v.province,
        v.week_key
),

prov_overall_with_rate AS (
    SELECT
        'PROVINCE_OVERALL' AS dim_level,
        province,
        '整体' AS visitor_name,
        week_key,
        week_start_date,
        visit_station_cnt,
        visit_submit_station_cnt,
        visit_with_history_submit_station_cnt,
        visit_never_submit_station_cnt,
        ROUND(
            visit_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            visit_with_history_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            visit_never_submit_station_cnt / NULLIF(visit_station_cnt, 0) * 100,
            2
        ) AS never_submit_rate_from_visit_pct,
        CAST(NULL AS SIGNED) AS rank_in_province
    FROM agg_province_overall
),

-- 6. 全国整体 × 周
national_overall AS (
    SELECT
        'NATIONAL_OVERALL' AS dim_level,
        '全国' AS province,
        '整体' AS visitor_name,
        week_key,
        MIN(week_start_date) AS week_start_date,
        SUM(visit_station_cnt) AS visit_station_cnt,
        SUM(visit_submit_station_cnt) AS visit_submit_station_cnt,
        SUM(visit_with_history_submit_station_cnt) AS visit_with_history_submit_station_cnt,
        SUM(visit_never_submit_station_cnt) AS visit_never_submit_station_cnt,
        ROUND(
            SUM(visit_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100,
            2
        ) AS submit_same_period_rate_from_visit_pct,
        ROUND(
            SUM(visit_with_history_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100,
            2
        ) AS submit_history_rate_from_visit_pct,
        ROUND(
            SUM(visit_never_submit_station_cnt) / NULLIF(SUM(visit_station_cnt), 0) * 100,
            2
        ) AS never_submit_rate_from_visit_pct,
        CAST(NULL AS SIGNED) AS rank_in_province
    FROM agg_province_overall
    GROUP BY
        week_key
)

SELECT
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
FROM (
    SELECT * FROM national_overall
    UNION ALL
    SELECT * FROM prov_overall_with_rate
    UNION ALL
    SELECT * FROM prov_visitor_with_rate
) t;
```

你只需要把 `a` / `b` 分别替换成你真实的“拜访表 / 上报表”表名即可。

---

## 三、思维导图结构（文字版）

- 目标：用 a（拜访表）+ b（上报表）直接生成 `visit_submit_weekly_stats`
	- 维度映射
		- store\_id 一致
		- province 从 sign\_address/城市拆
		- visitor\_name 来自拜访表
		- week\_key & week\_start\_date 来自 visit\_date
		- week\_data 作为结果表生成列
	- 统计口径
		- visit\_store\_week\_visitor：店×省×拜访人×周
		- submit\_store\_week：店×周上报
		- first\_submit\_per\_store：每站首次上报周
		- 历史上报站：first\_submit\_week\_key < 当前周
		- 同周闭环：当前周有上报
	- 汇总层级
		- PROVINCE\_VISITOR：省×拜访人×周
		- PROVINCE\_OVERALL：省整体×周
		- NATIONAL\_OVERALL：全国整体×周
	- 结果表落地
		- INSERT INTO visit\_submit\_weekly\_stats
		- week\_data 自动计算

---

## 《迭代日志》

- 【来源】
	- 你提供的两张上游表（拜访表、标签上报表）样例字段；
	- 之前我们已经有的 `visit_submit_weekly_stats` 表结构与统计口径设计。
- 【结论】
	- 只用这两张表，我们可以在数仓里直接推导出“拜访周维 + 上报周维 + 历史上报/首报”指标，产出 `visit_submit_weekly_stats` ；
	- 核心是：用 `first_submit_per_store` 还原“历史上报”；用 `visit_store_week_visitor` 和 `submit_store_week` 做同周闭环；维度则直接来自拜访表。
- 【改动点】
	1. 不再依赖之前的 `station_tag_coverage_analysis_v3` ，改为直接从 b 表计算“首次上报周”；
	2. 把“历史上报”的判断改成“首次上报周 < 当前拜访周”，更加贴近日常业务理解；
	3. SQL 链路完全收敛到两张表 a/b，方便你迁移到数仓任务。
- 【待补充】
	1. `visit_date` 的最终字段选择（visiting\_start\_time / sign\_time / create\_time）需要你给一个正式口径；
	2. 省区是否有专门维表（大区、省份映射），如果有，可以替换掉 `sign_address` 的字符串切分；
	3. 时间窗口目前写死“最近 12 周”，如果你希望按周号参数化（例如 `WHERE week_key BETWEEN :start_week AND :end_week` ），可以再改一版。
- 【下一步建议】
	1. 先在测试库直接跑这条 SELECT（去掉 INSERT），看抽样几行是否符合你现有报表；
	2. 如果对“历史上报”的新口径没有问题，把这条 SQL 放到调度里，每天/每周跑一次，替换掉本地脚本；
	3. 下一轮你可以把“最终结果表的一小段数据 + 老报表同一周的截图”给我，我帮你做一次对账，看看是否还有口径偏差需要校正。

base\_store AS ( SELECT store\_id, province, has\_submit AS has\_submit\_history FROM station\_tag\_coverage\_analysis\_v3 ),\[-- ========== 一键执行脚本 ========== -- 清理临时表 DROP TABLE IF EXISTS `tmp_max_dt`; DROP TABLE IF EXISTS `tmp_latest_merchant`; DROP TABLE IF EXISTS `tmp_visit_stats`; DROP TABLE IF EXISTS `tmp_submit_stats`; DROP TABLE IF EXISTS `station_tag_coverage_analysis_v3`; -- 1. 每个store的最新dt CREATE TABLE `tmp_max_dt` AS SELECT store\_id, MAX(dt) AS max\_dt FROM `merchant_profile_analysis` GROUP BY store\_id; ALTER TABLE `tmp_max_dt` ADD PRIMARY KEY (store\_id); -- 2. 最新商户记录 CREATE TABLE `tmp_latest_merchant` AS SELECT mp.store\_id, mp.store\_name, mp.province\_name, mp.city\_name, mp.province, mp.brand\_name, mp.competitive\_overlap, mp.sme\_supplier, mp.service\_carwash\_available, mp.service\_carwash\_type, mp.convenience\_store\_available, mp.restroom\_available, mp.parking\_available, mp.open\_24h, mp.open\_hours, mp.order\_cnt\_30d, mp.gmv\_mtd, mp.dt FROM `merchant_profile_analysis` mp INNER JOIN `tmp_max_dt` t ON mp.store\_id = t.store\_id AND mp.dt = t.max\_dt; ALTER TABLE `tmp_latest_merchant` ADD PRIMARY KEY (store\_id); -- 3. 拜访统计 CREATE TABLE `tmp_visit_stats` AS SELECT station\_id AS store\_id, COUNT(\*) AS visit\_count FROM `uir_visit_records` WHERE visit\_date >= DATE\_SUB(CURRENT\_DATE(), INTERVAL 3 MONTH) GROUP BY station\_id; ALTER TABLE `tmp_visit_stats` ADD PRIMARY KEY (store\_id); -- 4. 上报统计 CREATE TABLE `tmp_submit_stats` AS SELECT store\_id, COUNT(\*) AS submission\_count FROM `visit_records_enriched` WHERE processing\_status = 'success' AND create\_time >= DATE\_SUB(CURRENT\_DATE(), INTERVAL 3 MONTH) GROUP BY store\_id; ALTER TABLE `tmp_submit_stats` ADD PRIMARY KEY (store\_id); -- 5. 计算阈值 SET @service\_cov\_avg = ( SELECT AVG(( IF(service\_carwash\_available NOT IN ('', '未知') AND service\_carwash\_available IS NOT NULL, 1, 0) + IF(service\_carwash\_type NOT IN ('', '未知') AND service\_carwash\_type IS NOT NULL, 1, 0) + IF(convenience\_store\_available NOT IN ('', '未知') AND convenience\_store\_available IS NOT NULL, 1, 0) + IF(restroom\_available NOT IN ('', '未知') AND restroom\_available IS NOT NULL, 1, 0) + IF(parking\_available NOT IN ('', '未知') AND parking\_available IS NOT NULL, 1, 0) + IF(open\_24h NOT IN ('', '未知') AND open\_24h IS NOT NULL, 1, 0) + IF(open\_hours NOT IN ('', '未知') AND open\_hours IS NOT NULL, 1, 0) ) / 7) FROM `tmp_latest_merchant`); SET @overall\_cov\_avg = ( SELECT AVG(( IF(brand\_name NOT IN ('未知', '') AND brand\_name IS NOT NULL, 1, 0) + IF(competitive\_overlap NOT IN ('', '未知') AND competitive\_overlap IS NOT NULL, 1, 0) + IF(sme\_supplier NOT IN ('其他', '未知', '') AND sme\_supplier IS NOT NULL, 1, 0) + IF(service\_carwash\_available NOT IN ('', '未知') AND service\_carwash\_available IS NOT NULL, 1, 0) + IF(service\_carwash\_type NOT IN ('', '未知') AND service\_carwash\_type IS NOT NULL, 1, 0) + IF(convenience\_store\_available NOT IN ('', '未知') AND convenience\_store\_available IS NOT NULL, 1, 0) + IF(restroom\_available NOT IN ('', '未知') AND restroom\_available IS NOT NULL, 1, 0) + IF(parking\_available NOT IN ('', '未知') AND parking\_available IS NOT NULL, 1, 0) + IF(open\_24h NOT IN ('', '未知') AND open\_24h IS NOT NULL, 1, 0) + IF(open\_hours NOT IN ('', '未知') AND open\_hours IS NOT NULL, 1, 0) ) / 10) FROM `tmp_latest_merchant`); -- 6. 创建目标表 CREATE TABLE `station_tag_coverage_analysis_v3` ( `store_id` VARCHAR(50) PRIMARY KEY, `store_name` VARCHAR(100), `province_name` VARCHAR(50), `city_name` VARCHAR(50), `province` VARCHAR(50), `visit_count_3m` INT, `tag_submission_count_3m` INT, `tag_brand_name_covered` TINYINT(1), `brand_name_original` VARCHAR(100), `tag_competitive_overlap_covered` TINYINT(1), `competitive_overlap_original` VARCHAR(100), `tag_sme_supplier_covered` TINYINT(1), `tag_service_carwash_covered` TINYINT(1), `service_carwash_available_original` VARCHAR(50), `tag_service_carwash_type_covered` TINYINT(1), `service_carwash_type_original` VARCHAR(50), `tag_convenience_store_covered` TINYINT(1), `convenience_store_available_original` VARCHAR(50), `tag_restroom_covered` TINYINT(1), `restroom_available_original` VARCHAR(50), `tag_parking_covered` TINYINT(1), `parking_available_original` VARCHAR(50), `tag_open_24h_covered` TINYINT(1), `open_24h_original` VARCHAR(50), `tag_open_hours_covered` TINYINT(1), `open_hours_original` VARCHAR(100), `total_covered_tags` INT, `order_cnt_30d` DECIMAL(10,2), `gmv_mtd` DECIMAL(15,2), `latest_dt` VARCHAR(20), `has_visit` TINYINT(1), `has_submit` TINYINT(1), `has_store` TINYINT(1), `brand_coverage_level` VARCHAR(20), `competitive_coverage_level` VARCHAR(20), `service_coverage_level` VARCHAR(20), `overall_coverage_level` VARCHAR(20) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; -- 7. 插入数据 INSERT INTO `station_tag_coverage_analysis_v3` SELECT m.store\_id, m.store\_name, m.province\_name, m.city\_name, m.province, COALESCE(v.visit\_count, 0), COALESCE(s.submission\_count, 0), IF(m.brand\_name IN ('未知', '') OR m.brand\_name IS NULL, 0, 1), m.brand\_name, IF(m.competitive\_overlap IN ('', '未知') OR m.competitive\_overlap IS NULL, 0, 1), m.competitive\_overlap, IF(m.sme\_supplier NOT IN ('其他', '未知', '') AND m.sme\_supplier IS NOT NULL, 1, 0), IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0), m.service\_carwash\_available, IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0), m.service\_carwash\_type, IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0), m.convenience\_store\_available, IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0), m.restroom\_available, IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0), m.parking\_available, IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0), m.open\_24h, IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0), m.open\_hours, ( IF(m.brand\_name NOT IN ('未知', '') AND m.brand\_name IS NOT NULL, 1, 0) + IF(m.competitive\_overlap NOT IN ('', '未知') AND m.competitive\_overlap IS NOT NULL, 1, 0) + IF(m.sme\_supplier NOT IN ('其他', '未知', '') AND m.sme\_supplier IS NOT NULL, 1, 0) + IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0) + IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0) + IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0) + IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0) + IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0) + IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0) + IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0) ), m.order\_cnt\_30d, m.gmv\_mtd, m.dt, IF(COALESCE(v.visit\_count, 0) > 0, 1, 0), IF(COALESCE(s.submission\_count, 0) > 0, 1, 0), IF(m.store\_id IS NOT NULL AND m.dt IS NOT NULL AND ( IF(m.brand\_name NOT IN ('未知', '') AND m.brand\_name IS NOT NULL, 1, 0) + IF(m.competitive\_overlap NOT IN ('', '未知') AND m.competitive\_overlap IS NOT NULL, 1, 0) + IF(m.sme\_supplier NOT IN ('其他', '未知', '') AND m.sme\_supplier IS NOT NULL, 1, 0) + IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0) + IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0) + IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0) + IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0) + IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0) + IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0) + IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0) ) > 0, 1, 0), IF(m.brand\_name IN ('未知', '') OR m.brand\_name IS NULL, '0覆盖', '高覆盖'), IF(m.competitive\_overlap IN ('', '未知') OR m.competitive\_overlap IS NULL, '0覆盖', '高覆盖'), CASE WHEN (IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0) + IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0) + IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0) + IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0) + IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0) + IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0) + IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0)) = 0 THEN '0覆盖' WHEN (IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0) + IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0) + IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0) + IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0) + IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0) + IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0) + IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0)) / 7 < @service\_cov\_avg THEN '低覆盖' ELSE '高覆盖' END, CASE WHEN (IF(m.brand\_name NOT IN ('未知', '') AND m.brand\_name IS NOT NULL, 1, 0) + IF(m.competitive\_overlap NOT IN ('', '未知') AND m.competitive\_overlap IS NOT NULL, 1, 0) + IF(m.sme\_supplier NOT IN ('其他', '未知', '') AND m.sme\_supplier IS NOT NULL, 1, 0) + IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0) + IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0) + IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0) + IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0) + IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0) + IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0) + IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0)) = 0 THEN '0覆盖' WHEN (IF(m.brand\_name NOT IN ('未知', '') AND m.brand\_name IS NOT NULL, 1, 0) + IF(m.competitive\_overlap NOT IN ('', '未知') AND m.competitive\_overlap IS NOT NULL, 1, 0) + IF(m.sme\_supplier NOT IN ('其他', '未知', '') AND m.sme\_supplier IS NOT NULL, 1, 0) + IF(m.service\_carwash\_available NOT IN ('', '未知') AND m.service\_carwash\_available IS NOT NULL, 1, 0) + IF(m.service\_carwash\_type NOT IN ('', '未知') AND m.service\_carwash\_type IS NOT NULL, 1, 0) + IF(m.convenience\_store\_available NOT IN ('', '未知') AND m.convenience\_store\_available IS NOT NULL, 1, 0) + IF(m.restroom\_available NOT IN ('', '未知') AND m.restroom\_available IS NOT NULL, 1, 0) + IF(m.parking\_available NOT IN ('', '未知') AND m.parking\_available IS NOT NULL, 1, 0) + IF(m.open\_24h NOT IN ('', '未知') AND m.open\_24h IS NOT NULL, 1, 0) + IF(m.open\_hours NOT IN ('', '未知') AND m.open\_hours IS NOT NULL, 1, 0)) / 10 < @overall\_cov\_avg THEN '低覆盖' ELSE '高覆盖' END FROM `tmp_latest_merchant` m LEFT JOIN `tmp_visit_stats` v ON m.store\_id = v.store\_id LEFT JOIN `tmp_submit_stats` s ON m.store\_id = s.store\_id; -- 8. 清理临时表 DROP TABLE IF EXISTS `tmp_max_dt`; DROP TABLE IF EXISTS `tmp_latest_merchant`; DROP TABLE IF EXISTS `tmp_visit_stats`; DROP TABLE IF EXISTS `tmp_submit_stats`; -- 9. 查看结果 SELECT COUNT(\*) AS 总记录数 FROM station\_tag\_coverage\_analysis\_v3; \]现在线下的逻辑是这样的,省区,历史上报的逻辑逻辑来自于 V3,V3 的逻辑如上;省区,以后都叫省区,业务逻辑,记住就行了.按这个输入在综合理解一下;

20251206\_0120\_将V3表逻辑纳入周维脚本的统一口径说明

tags:: #station\_tag\_coverage\_analysis\_v3 #历史上报口径 #省区维度 #数据血缘 #周维统计

---

**一句话结论：**  
现在线下的“省区 + 历史上报”全部由 `station_tag_coverage_analysis_v3` 决定：我们后续在周维脚本里就应该把 V3 当成唯一的基础维表，只从 V3 取 `store_id / 省区 / has_submit` ，其他历史判断都围绕这张表来做，而不是再从原始上报表临时推导一套新的“历史上报”口径。

---

## 三段论据

### 论据一：V3 已经是你当前的“总控维表”

从你的一键脚本可以看出来， `station_tag_coverage_analysis_v3` 的角色其实是“商户画像基础维表 + 标签覆盖度评估”，它整合了三类信息：

1. **商户画像快照（最新 dt）**
	- 来源： `merchant_profile_analysis`
	- 通过 `tmp_max_dt` 找每个 `store_id` 最大 `dt` ，得到一条“最新画像”（ `tmp_latest_merchant` ）。
	- 在 V3 里保留： `store_name / province_name / city_name / province / brand_name / 设施标签 / order_cnt_30d / gmv_mtd / latest_dt` 等。
2. **最近 3 个月的行为统计**
	- 拜访统计： `tmp_visit_stats` ，来源 `uir_visit_records` → `visit_count_3m` 。
	- 上报统计： `tmp_submit_stats` ，来源 `visit_records_enriched` → `tag_submission_count_3m` 。
	- 这两者在 V3 中分别落到 `visit_count_3m` 、 `tag_submission_count_3m` 字段，但不直接参与 `has_submit` 计算。
3. **标签覆盖度 + has\_submit 逻辑**
	- 一大段 `IF(...)` 判断，逐字段计算标签是否有值，并做汇总：
		- 品牌、竞对、供货商、洗车、便利店、卫生间、停车、24h、营业时间等等；
	- `has_submit` 的定义实际上是：
		> 只要这个站在最新 dt 快照中，有任意一个“关键标签字段”不是空/未知，就认为该站“有有效标签”（历史上报过）， `has_submit = 1` ，否则为 0。
	- 同时还根据平均覆盖度阈值算出了 `service_coverage_level` 、 `overall_coverage_level` 等等级字段。

也就是说： **你现在所有“这个站有没有历史标签”“这个站归属哪个省区”的权威来源就是 V3** ，而不是单纯的上报明细表。

### 论据二：周维脚本的 base\_store 理应完全对齐 V3 口径

你之前的周维脚本里开头这段：

现在可以明确解释成：

- `store_id` ：商户/油站主键，来自画像快照；
- `province` ：这里就是你说的“省区”，以后统一用这个字段作为省区维度；
- `has_submit_history` ：严格等价于 V3 里的 `has_submit` ，即“最新画像层面至少有一个有效标签字段有值”，代表“这站历史上有过有效标签”，不受最近 3 个月窗口限制。

这意味着：

1. 在周维统计里，我们区分：
	- `visit_with_history_submit_station_cnt` ：本周被拜访，且在 V3 里 `has_submit = 1` 的站点数；
	- `visit_never_submit_station_cnt` ：本周被拜访，但在 V3 里 `has_submit = 0` 的站点数；
2. 周维脚本不再自己去算什么“首次上报周 first\_submit\_week\_key”，而是直接信任 V3 对“有没有历史标签”的定义；
3. 这样你线上、线下所有报表在“历史上报/首次上报缺失”这件事上，都会走同一套判断，而不会出现：
	- 上游报表说“这站有历史标签”，
	- 周维报表却说“历史未上报”的口径冲突。

### 论据三：数仓链路上应拆成“V3构建层 + 周维汇总层”两级

基于你现在的一键脚本和我们之前的周维 SQL，最合理的数仓设计是两层而不是一条超长 SQL：

1. **层 A：构建 `station_tag_coverage_analysis_v3`**
	- 逻辑就是你发的这一整段一键脚本：
		- 从 `merchant_profile_analysis` 生成 `tmp_max_dt` 、 `tmp_latest_merchant` ；
		- 从 `uir_visit_records` 、 `visit_records_enriched` 计算近 3 个月计数；
		- 算覆盖率阈值，生成各类 coverage\_level；
		- 最终插入 V3。
	- 在数仓里可以落成一张 DWD/DIM 表，比如 `dwd_station_tag_coverage_v3_di` 。
2. **层 B：在 V3 基础上做周维拜访/上报统计**
	- 周维脚本的 `base_store` 就是从 V3 抽 `store_id / province / has_submit` ；
	- 再和拜访表、上报表按“站×周”去 join，产出 `visit_submit_weekly_stats` ；
	- 周维脚本里不再自己算什么“有没有历史上报”，只做“在历史上有标签 vs 没标签的盘子拆解”。

好处非常直接：

- 你以后如果要调整“has\_submit”的定义（比如要加上某个新标签、或引入 TTL 逻辑），只需要改 V3 的构建脚本，周维层不用动；
- 任何报表（站点详情页、覆盖率看板、周维运营看板）只要统一引用 V3 的 `has_submit` ，口径自然一致；
- 省区维度也只在 V3 里定义一次（从画像/地址/省区维表来），下游都不再单独拆地址字符串。

---

## 思维导图结构（文字版）

- 目标：统一“省区 + 历史上报”口径
	- V3 的角色
		- 汇总画像快照（merchant\_profile\_analysis）
		- 统计近 3 个月拜访/上报
		- 计算标签覆盖程度 + has\_submit
	- 关键字段口径
		- province = 省区（统一叫法）
		- has\_submit = 最新画像层面只要有一个有效标签 → 历史上报站
	- 周维脚本对齐
		- base\_store 仅从 V3 取 store\_id/province/has\_submit
		- visit\_with\_history\_submit\_station\_cnt / visit\_never\_submit\_station\_cnt 全部基于 has\_submit
		- 周维层不再自算“首次上报周”
	- 数仓链路
		- 层A：构建 station\_tag\_coverage\_analysis\_v3
		- 层B：以 V3 为底坐周维统计表 visit\_submit\_weekly\_stats

---

## 《迭代日志》

- 【来源】
	- 你贴出了完整的 `station_tag_coverage_analysis_v3` 一键构建脚本；
	- 明确说明：当前线下“历史上报 + 省区”逻辑都来自 V3。
- 【结论】
	- V3 应被视作“省区 + 历史上报”的唯一权威维表；
	- 周维统计脚本中 `base_store` 的 `province` 、 `has_submit_history` 必须直接、唯一地来源于 V3；
	- 周维层不再重复实现一套历史判断逻辑，而是只使用 V3 的结果进行盘子拆分和比例计算。
- 【改动点】
	- 相比上一轮我用上报表 b 反推出“first\_submit\_week\_key”的方案，现在明确回归 V3 的 has\_submit 定义；
	- 统一将“省/省份/省区”在下游语义上都叫“省区”，字段上继续沿用 V3 的 `province` 。
- 【待补充】
	- 如果你希望在周维报表中同时看到“V3 口径的历史上报率”和“严格按上报明细算出来的首报率”，我们可以再设计一套并行指标，但口径要在文档中写清楚。
- 【下一步建议】
	1. 我可以基于这套 V3 逻辑，帮你出一个“数仓链路总览”：
		- 层 A：V3 生成 SQL（基本就是你的一键脚本做轻量清理）；
		- 层 B：周维统计表 `visit_submit_weekly_stats` ；
	2. 下一步你如果希望“把两层都搬进数据仓库调度”，可以告诉我使用的数仓类型（MySQL/Hive/StarRocks 等），我会按对应语法给你完整的 A+B 脚本版本。

先帮我分析一下,has\_submit 的具体逻辑,很关键.

20251206\_1205\_has\_submit逻辑\_近三个月成功上报标记而非“有标签”

tags:: #has\_submit #历史上报口径 #3个月窗口 #标签覆盖 #数据血缘

---

**一句话结论：**  
在 `station_tag_coverage_analysis_v3` 里， `has_submit` 的真实含义是「这个油站在 **最近 3 个月内** ，是否出现过至少一次 `processing_status='success'` 的上报记录」，它跟“是否已有标签画像（有值标签）”是两回事，这块不能混。

---

## 一、从脚本链路还原 has\_submit 的生成过程

我们先沿着你的一键脚本，把 `has_submit` 的来源从下游往上游捋一遍。

1. 第 4 步： `tmp_submit_stats` （上报统计）
	这里有几个关键点：
	- 数据源： `visit_records_enriched` （你之前周维脚本里用的同一张上报富化表）；
	- 过滤条件：
		- `processing_status = 'success'` → 只算处理成功的上报；
		- `create_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)` → 只看 **当前日期往前 3 个月内** 的记录；
	- 统计结果：
		- 每个 `store_id` 聚合为一行， `submission_count` 是这 3 个月内成功上报的次数（>=0）。
2. 第 7 步：把 `tmp_submit_stats` 填充进 V3
	在最终 `INSERT INTO station_tag_coverage_analysis_v3` 时，相关段是：
	和目标表字段顺序对齐：
	所以可以明确映射为：
	- `has_visit = IF(COALESCE(v.visit_count, 0) > 0, 1, 0)`
	- `has_submit = IF(COALESCE(s.submission_count, 0) > 0, 1, 0)`
	- `has_store = IF(m.store_id IS NOT NULL AND m.dt IS NOT NULL AND (标签覆盖计数) > 0, 1, 0)`
	其中 `s.submission_count` 正是前面 `tmp_submit_stats` 里的 3 个月内成功上报次数。
3. 总结链路：
	- `visit_records_enriched` （原始上报明细）  
		→ 过滤成功 + 最近 3 个月  
		→ 按站聚合得到 `submission_count`  
		→ `submission_count > 0` → `has_submit = 1` ，否则 `has_submit = 0` 。

---

## 二、has\_submit 的业务含义与边界条件（精确到语义）

结合上面的 SQL，我们可以把 `has_submit` 的业务语义拆开讲清楚：

1. **时间窗口：强绑定“最近 3 个月”**
	- 取数条件是： `create_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)` 。
	- 不是自然季度，也不是“某个固定月份区间”，而是以当前日期为基点的滑动 3 个月窗口。
	- 这意味着：
		- 站点如果在 4 个月前有过大量成功上报，但过去 3 个月零上报，那么今天跑脚本时：
			- `submission_count = 0` ， `has_submit = 0` ；
		- 站点如果本周刚上报过一次，那么 `submission_count >= 1` ， `has_submit = 1` 。
2. **成功判定：只看 processing\_status = 'success'**
	- 所有非 success 的记录（超时、失败、待处理等）都会被忽略；
	- 只要有一条 success，就算有上报，无论内容是不是有效、字段是否为“未知”。
3. **维度：只按 store\_id 聚合，和标签字段内容无关**
	- `tmp_submit_stats` 只统计“成功上报次数”，完全不看上报内容 `input_info` 里的字段是否填写完整；
	- 因此：
		- 站点可以 `has_submit = 1` ，但所有关键标签字段仍然是“未知/空”，也就是说“上报动作发生了，但画像并没有真的补上”；
		- 站点也可以 `has_store = 1` （画像里有标签），但 `has_submit = 0` （最近 3 个月无上报），因为标签可能来自更早的上报或其他渠道。
4. **Left Join 方式：没有上报记录的站点自动视为 0**
	最终 `INSERT` 是这样：
	- 对于在 `tmp_latest_merchant` 中存在、但 `tmp_submit_stats` 中没有的 `store_id` ：
		- `s.submission_count` 为 NULL， `COALESCE(NULL, 0) = 0` → `has_submit = 0` ；
	- 也就是说，只要站点在 V3 的画像快照里出现，但近 3 个月内没有任何成功上报，就会被打成“has\_submit = 0”。

---

## 三、has\_submit vs has\_store / has\_visit：不要混淆的三件事

为了避免后面再踩坑，我们把三个布尔字段放在一起对比一下：

1. **has\_visit（近 3 个月有拜访）**
	- 来源： `tmp_visit_stats`
	- 逻辑：3 个月内有拜访记录 → `has_visit = 1` ，否则 0。
2. **has\_submit（近 3 个月有成功上报）**
	- 来源： `tmp_submit_stats` + `has_submit = IF(COALESCE(s.submission_count, 0) > 0, 1, 0)` ；
	- 逻辑：3 个月内有 `processing_status='success'` 的上报记录 → `has_submit = 1` ，否则 0。
3. **has\_store（拥有至少一个有效标签画像）**
	- 来源：那段长 IF 里对 10 个标签的覆盖判断之和 > 0：
		```sql
		sqlIF(m.store_id IS NOT NULL AND m.dt IS NOT NULL AND (
		    IF(m.brand_name NOT IN ('未知', '') AND m.brand_name IS NOT NULL, 1, 0) +
		    IF(m.competitive_overlap NOT IN ('', '未知') AND m.competitive_overlap IS NOT NULL, 1, 0) +
		    IF(m.sme_supplier NOT IN ('其他', '未知', '') AND m.sme_supplier IS NOT NULL, 1, 0) +
		    IF(m.service_carwash_available NOT IN ('', '未知') AND m.service_carwash_available IS NOT NULL, 1, 0) +
		    IF(m.service_carwash_type NOT IN ('', '未知') AND m.service_carwash_type IS NOT NULL, 1, 0) +
		    IF(m.convenience_store_available NOT IN ('', '未知') AND m.convenience_store_available IS NOT NULL, 1, 0) +
		    IF(m.restroom_available NOT IN ('', '未知') AND m.restroom_available IS NOT NULL, 1, 0) +
		    IF(m.parking_available NOT IN ('', '未知') AND m.parking_available IS NOT NULL, 1, 0) +
		    IF(m.open_24h NOT IN ('', '未知') AND m.open_24h IS NOT NULL, 1, 0) +
		    IF(m.open_hours NOT IN ('', '未知') AND m.open_hours IS NOT NULL, 1, 0)
		) > 0, 1, 0)
		```
	- 逻辑：
		- 只要这 10 个关键字段中，有至少一个是“非空且非‘未知’”，就认为这个站“在最新画像快照里有有效标签画像”；
		- 与上报时间无关，和最近 3 个月是否上报无关。
4. 结论：
	- 如果你说“历史上报”的业务含义是“这个站 **曾经** 有过成功上报动作（不管有没有沉淀成画像）”，那严格来说应该看 `has_submit` （但注意它现在只看最近 3 个月）；
	- 如果你说“画像已沉淀”的业务含义是“这个站当前已经有至少一个有效标签在画像里”，那应该看 `has_store` ；
	- 你之前在周维脚本中用 `has_submit AS has_submit_history` ，实际上是把“最近 3 个月有成功上报”当成了“历史上报”的 proxy，这个口径要非常小心：超过 3 个月没动的老画像站，会被你当成“历史从未上报”。

---

## 思维导图结构（文字版）

- has\_submit 逻辑解析
	- 数据源链路
		- visit\_records\_enriched → 成功上报过滤
		- 3 个月窗口（create\_time >= current\_date - 3 month）
		- 每站计数 → tmp\_submit\_stats.submission\_count
		- submission\_count > 0 → has\_submit = 1
	- 业务含义与边界
		- 滑动 3 个月窗口
		- 只认 processing\_status='success'
		- 与标签内容无关
		- Left join → 没有记录 = 0
	- 与 has\_visit / has\_store 的区别
		- has\_visit：3 个月有拜访
		- has\_submit：3 个月有成功上报动作
		- has\_store：当前画像里有至少一个有效标签
		- “历史上报”如果用 has\_submit，需要注意 3 个月时间窗的偏差

---

## 《迭代日志》

- 【来源】
	- 你贴出的 `station_tag_coverage_analysis_v3` 全量构建脚本；
	- 你现在明确提问：“先帮我分析一下，has\_submit 的具体逻辑，很关键。”
- 【结论】
	- `has_submit` 在 V3 中的定义是：
		> 最近 3 个月内在 `visit_records_enriched` 中出现过至少一条 `processing_status='success'` 的上报记录。
	- 它不看标签内容是否“未知/空”，也不看更早时间的上报；
	- 判断“这个站有没有画像”的逻辑其实是在 `has_store` 里，而不是 `has_submit` 。
- 【改动点】
	- 相比之前默认把 V3 的 `has_submit` 理解为“历史是否有标签”的直观认知，这里明确拆开：
		- “行为层历史上报” → has\_submit（但目前只看 3 个月）；
		- “画像层是否有标签” → has\_store；
	- 给你把三者（has\_visit / has\_submit / has\_store）的边界和差异明确标出来。
- 【待补充】
	- 你实际业务里说的“历史上报”到底想表达的是：  
		1）最近 3 个月内有过上报；还是  
		2）曾经有过上报（不限时间）；还是  
		3）当前画像里有标签（不管什么时候上的）；
	- 不同答案，对应需要改造的字段会不一样（是改 has\_submit 的计算逻辑，还是改周维脚本用哪个字段）。
- 【下一步建议】
	1. 你先用一句话定一下：“我们对 ‘历史上报’ 的业务口径，到底想看哪一种？”
	2. 如果你希望真正的“曾经有过任何一次成功上报”，我们需要基于 `visit_records_enriched` 再设计一个 `has_submit_ever` 字段，而不是复用现在 3 个月窗口的 has\_submit；
	3. 如果你希望“只要画像里有任意有效标签就当作历史上报站”，那周维脚本应该改用 V3 的 `has_store` ，而不是 `has_submit` 。

你先告诉我一句话：你脑子里“历史上报”的理想定义是哪种，我下一步就直接给你对应的字段改造方案和周维脚本的替换方案。

20251206\_1235\_has\_submit指标漂移\_成功上报比率变化与分布排查SQL

tags:: #has\_submit #processing\_status #success漂移 #质量排查 #SQL查询

---

**一句话结论：**  
你现在要做的是“证明问题存在”，所以先用几条只读 SQL，把 `visit_records_enriched` 里 `processing_status='success'` 的占比随时间的变化、以及最近 3 个月各站点成功上报次数的分布打出来，就能直观看到 has\_submit 指标是怎么漂的。

---

下面我直接给 SQL，不搞花活，全部基于 `visit_records_enriched` ，你可以先在分析库跑一遍看结果感受一下。

---

## 一、按自然日看 success 占比的时间序列（最近 180 天）

用途：先看有没有明显“某一天开始 success 比例突然掉了/变高了”，帮助你定位变更时间点。

看法建议：

- `success_rate` 画成折线图，肉眼找“结构性断点”（明显跳变的那几天，很可能就是你处理逻辑变更日）；
- `non_success_cnt` 如果突然从几乎 0 变成大量值，也说明前后对失败/异常上报的处理方式变了。

---

## 二、按自然周看 success 占比（更平滑，避免日级波动干扰）

如果日级有点太抖，可以再看周级趋势。

- 这里是最近 12 个月的周级 success 占比；
- 如果 has\_submit 漂移是因为“某个时间之后很多记录不再标 success”，你会在这个表里看到一个拐点：
	- 之前 `success_rate` 可能是 0.9+；
	- 某周开始掉到 0.3、0.4 甚至更低。

---

## 三、看 processing\_status 各枚举值的占比变化（是不是多了新状态）

用途：确认是不是新增/替换了某些状态，导致原来被算 success 的现在变成了其他字符串。

### 3.1 最近 90 天各状态分布

### 3.2 对比“最近 90 天”和“之前 90 天”的枚举分布

看法建议：

- 如果你发现 `prev_90d` 里 `success` 占比极高，而 `last_90d` 里大量跑到了某个新的 status（比如 `COMPLETED` 、 `DONE` 、 `OK` 、或某种错误码），那就能基本确认“处理方改了 status 写法，而你还在用老的 success 口径”。

---

## 四、从 has\_submit 角度看：最近 3 个月“成功上报站数”的分布变化

因为 `has_submit` 的本质是“最近 3 个月内成功上报次数 > 0”，我们可以直接用 visit\_records\_enriched 看“成功上报站数”的变化。

### 4.1 最近 3 个月：按站点看成功上报次数分布

- `success_cnt = 0` 的站不会出现在这个结果里（因为 WHERE 已经筛了 success），所以这一张表是“最近 3 个月至少成功上报一次的站的次数分布”；
- 和你原来脚本里的 `submission_count > 0 → has_submit=1` 是一一对应的。

### 4.2 对比“最近 90 天”和“之前 90 天”的站点层分布（关键）

解读方式：

- 看 `prev_90d` vs `last_90d` ：
	- 总的 `store_cnt` 是否大幅下降（说明 has\_submit=1 的站急剧减少）；
	- `success_cnt` =1、2、3 这些低次数档位有没有明显变化；
- 如果你发现 `prev_90d` 有很多站 `success_cnt >= 1` ，但 `last_90d` 基本没多少站，那就是典型“口径变了但你脚本还按老口径算”的情况。

---

## 五、下一步怎么用这些结果

建议你这样用：

1. 先跑「日级/周级 success\_rate」看是否有明显拐点；
2. 再跑「status 枚举分布对比」确认是不是 status 写法/枚举本身变了；
3. 最后用「按站点成功上报次数分布」验证 has\_submit 对“站点层盘子”的影响有多大——这能量化告诉你：
	- 多少站本来在 prev\_90d 有 success，现在 last\_90d 没有；
	- 也就对上了“我 miss 掉多少站”的直观感受。

如果你愿意，下一步你可以把其中一两张查询结果（比如周级 success\_rate + status 对比）截个统计口径给我，我可以帮你写一段“问题说明 + 口径修复建议”的老板可读版本。

---

## 《迭代日志》

- 【来源】
	- 你刚刚确认： `processing_status = 'success'` 的变更导致 has\_submit 指标漂移，造成部分站点被误判为“无上报”；
	- 你希望用 SQL 查清楚“这个指标的变化情况、分布情况”。
- 【结论】
	- 核心是直接围绕 `visit_records_enriched` 做三件事：  
		1）按日/周看 `success_rate` 的时间序列，定位变更时间；  
		2）比对 `processing_status` 枚举在前后两个 90 天窗口的分布；  
		3）在站点层面，对比“最近 90 天 vs 之前 90 天”的 `success_cnt` 分布，直观看 has\_submit 的盘子缩水情况。
- 【改动点】
	- 从“分析 has\_submit 逻辑”正式进入“用只读 SQL 做时间与分布维度的指标漂移排查”；
	- 提供了多条可以独立执行的排查 SQL，全部基于你现有的上报明细表。
- 【待补充】
	- 真正的变更日期（通过这些 SQL 一跑就能看出来）；
	- 是否有新的 status 枚举需要并入“成功”的定义（比如把 `COMPLETED` 也视为 success）。
- 【下一步建议】
	1. 先跑一遍日级/周级 success\_rate，把拐点时间抠出来；
	2. 然后跑枚举分布对比，确认“变更前后 status 文本级变化”；
	3. 再回来，我们可以针对实际的变更情况，重写一版“对历史 AND 未来都兼容”的 has\_submit 计算逻辑，并给一条“历史纠偏 + 未来改造”的完整方案。

20251206\_1305\_has\_submit修正策略\_不要只删条件要先定口径

tags:: #has\_submit修正 #指标漂移 #历史回刷 #V3重算 #口径统一

---

**一句话结论：**  
不能直接“粗暴去掉条件再重跑 V3”，正确做法是先把 has\_submit 的业务口径定清楚（近期上报 vs 曾经上报），然后按新口径改 SQL、全量回刷 V3，同时加一列新指标，避免和历史口径混在一起。

---

## 一、先确认：现在的问题到底出在哪里

你现在发现的“重大缺陷”，本质上是两个问题叠加：

1. **技术层变化： `processing_status = 'success'` 含义变了**
	- 之前很多“有效上报”可能都记在 `success` 里；
	- 现在部分“成功场景”被挪到新的状态值（或者某些异常不再标记为 success），导致你用 `= 'success'` 这条线抓不到上报记录。
	- 结果：同一个站在业务上“明明上报过”，但在你脚本眼里变成了 `submission_count = 0 → has_submit = 0` 。
2. **业务口径设计：has\_submit 只看“最近 3 个月”**
	- SQL 写的是： `create_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)` ；
	- 因此两个站：
		- A：一年前上报很多，最近 3 个月没动；
		- B：本周刚上报 1 次；
	- 按现在脚本：A → has\_submit=0，B → has\_submit=1，这跟你心里“历史上报站”的直觉很容易冲突。

所以现在 has\_submit 的问题不是一个简单的“条件写窄了”，而是：

> 状态枚举变了 + 时间窗口过窄 → 指标漂移 + 盘子 miss。

---

## 二、是不是“去掉这个限制重新跑 V3”就行？——风险直说

你问的“是不是我去掉这个限制重新跑一遍 V3 可以”，大概率指的是这段：

直接删掉，会有几种极端情况：

1. **只删 3 个月窗口，保留 success：**
	效果：
	- has\_submit 变成“ **只要历史上任何时候出现过 success** 就算 1”；
	- 优点：不再受 3 个月窗口影响，老站不会因为最近不动就掉成 0；
	- 风险：
		- 如果现在线上为了兼容新逻辑，很多记录不再标 success，那老问题依然存在；
		- 而且你没有区分“最近有动作”和“历史曾经有动作”。
2. **只删 `processing_status` 限制，保留 3 个月窗口：**
	效果：
	- 3 个月内所有记录，不管成功失败，都算在 submission\_count 里；
	- 风险：
		- 很多失败 / 重试 / 垃圾记录也算上；
		- 只要有一条失败记录，has\_submit 也变成 1，完全脱离“有效上报”的含义。
3. **两个都删：不看状态、不看时间：**
	效果：
	- 只要这个站在 visit\_records\_enriched 里出现过任何记录，就算 has\_submit=1；
	- 基本失去“上报成功”这个判断能力，含义变成“曾经被系统处理过”。

结论：

> 你肯定需要重跑 V3，但不能只是“随便删一个条件”，而是要先定好 has\_submit 的新业务定义，再按这个定义重写那一段 SQL，然后再全量回刷。

---

## 三、给你一套更稳的修正方案（建议照这个思路定口径）

先说一个我建议的“分层定义”，你比较一下是不是贴合你现在的使用场景：

1. **has\_submit\_ever：历史上是否有过有效上报（不限时间）**
	- 口径建议：
		- 数据源： `visit_records_enriched` ；
		- 状态： `processing_status IN ('success', 'xxx_new_success', ...)` ，把现在所有“被视作成功的状态”都列出来；
		- 时间： **不限制 create\_time** ，整表回看；
	- 用途：
		- 判断“这站到底有没有过上报行为”；
		- 在你周维脚本里的“历史上报/从未上报”拆盘场景，更适合用这个字段。
2. **has\_submit\_3m：最近 3 个月是否有有效上报**
	- 口径建议：
		- 同样的成功状态集合；
		- 加上 `create_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)` ；
	- 用途：
		- 看“近期是否有维护动作”；
		- 例如你需要做“最近 3 个月没动过的老站要被运营点名”的场景。
3. **has\_store：当前画像是否有有效标签（你现在已经有）**
	- 不动：继续用你那段 10 个标签字段“是否有值”来判。

然后，对 V3 做个小重构（思路）：

- 原先的 `has_submit` 拆成两个： `has_submit_ever` + `has_submit_3m` ；
- 现有字段 `has_submit` ：
	- 短期内可以保留，用 `has_submit_3m` 去覆盖旧逻辑，保证历史报表不崩；
	- 或者直接废弃，只在下游使用新字段（更干净，但要沟通好）。

### 对应 SQL 改造示意（只看 tmp\_submit\_stats 那段）

原始版本：

建议新版本（示意）：

然后在 V3 里：

短期兼容方案可以是：

> 真正那句 SQL 你要我写我可以整套改，但你现在问的是“能不能去掉条件重跑”，我先把策略层面掰清楚。

---

## 四、回答你的问题：要不要重跑 V3？怎么重跑才不翻车

结论两句说死：

1. **是的，一定要重跑 V3**
	- 因为 has\_submit 的旧口径已经不可信了，继续在此基础上做任何“历史上报 vs 首次上报缺失”的分析都会偏；
	- 你现在发现的是“指标漂移”，实质上是“定义已经不再稳定”。
2. **但不能只是“删掉某个 WHERE 条件再重跑”**
	- 正确动作顺序应该是：  
		1）先用你刚才那几条排查 SQL，确认 status 枚举到底是怎么变的；  
		2）和业务一起拍板：
		- has\_submit 想代表“曾经有成功上报”还是“最近有成功上报”；  
			3）在脚本里显式拆成两个字段（ever & 3m），把“成功状态集”写死；  
			4）全量重跑 V3（最好落新版本表，比如 `_v4` ），先对账再替换。

---

## 思维导图结构（文字版）

- 核心问题
	- processing\_status 含义变了 → success 占比漂移
	- has\_submit 只看最近3个月 → 老站被错误打成0
- 风险评估
	- 直接删 success 条件 → 垃圾记录也算上
	- 直接删3个月窗口 → 时效性口径变化、趋势断层
	- 两个都删 → has\_submit 失去“有效上报”含义
- 推荐策略
	- 明确业务定义：历史上报 vs 近期上报
	- 派生两个字段：has\_submit\_ever / has\_submit\_3m
	- 改 tmp\_submit\_stats 汇总逻辑
	- 在 V3 中新增字段或替换旧的 has\_submit
	- 全量回刷 V3，新旧版本并存对账
- 执行顺序
	- 用现有排查 SQL 找 status 变更点
	- 确认要纳入的“成功状态集”
	- 改 SQL + 回刷 V3（或建 v4 表）
	- 下游周维脚本改用新字段

---

## 《迭代日志》

- 【来源】
	- 之前分析了 has\_submit 的计算过程：来自 3 个月内 `processing_status='success'` 的上报统计；
	- 你发现 status 逻辑变更导致 has\_submit 指标漂移，问“是不是去掉这个限制重跑 V3 就可以”。
- 【结论】
	- 必须重跑 V3，但不能简单地“删 WHERE 重跑”；
	- 正确方案是：先定 has\_submit 的新业务口径（ever vs 3m），再在脚本中显式拆为两个字段、扩展“成功状态集合”，最后全量回刷 V3。
- 【改动点】
	- 从“是否去掉条件”升级为“拆分指标 + 重构口径”，避免一刀切引入新的偏差；
	- 建议在 V3 层面引入 `has_submit_ever` 和 `has_submit_3m` ，而不是继续混用一个 has\_submit。
- 【待补充】
	- 你们线上现在到底有哪几个状态是“可以视为成功”的（除了 success 还有没有别的枚举）；
	- 你希望“历史上报”的最终定义是哪一个（曾经 vs 近期）。
- 【下一步建议】
	1. 你可以先一句话定一下：has\_submit 在你心中最好代表哪种含义（ever / 3m / 其它）；
	2. 如果你拍板“我要 has\_submit\_ever + has\_submit\_3m 双口径”，我下一步直接给你：
		- 完整改造版的 tmp\_submit\_stats + V3 INSERT SQL；
		- 以及对周维 visit\_submit\_weekly\_stats 的字段替换方案。

20251206\_1350\_visit\_submit\_station\_cnt零值排查与修复思路

tags:: #visit\_submit\_station\_cnt #同周闭环率 #processing\_status #数据质量排查 #SQL修复

---

**一句话结论：**  
`visit_submit_station_cnt` 掉成 0，本质上是“拜访周盘子还在，但同周上报匹配不到了”，九成是 `visit_records_enriched` 里 `processing_status='success'` 口径/数据变了，导致 `submit_store_week` 这层几乎为空，需要先用一组核查 SQL 把问题锁死，再改成功口径并重算周维表。

---

## 一、先把现有逻辑点亮：visit\_submit\_station\_cnt 是怎么来的

你现在的周维逻辑里， `visit_submit_station_cnt` 出现在两层聚合里（省×拜访人×周、省整体×周），核心计算都是这一句：

而 `submit_store_week` 的来源是：

也就是说：

> `visit_submit_station_cnt` = “该省 / 该拜访人 / 该周的拜访站点中，有多少站在同一周在 `visit_records_enriched` 里出现了 `processing_status='success'` 的记录”。

近两周全国都变 0，直观地看，就是 “最近两周 `submit_store_week` 里几乎没有站点记录” → 根因大概率在 `visit_records_enriched` 这一侧。

---

## 二、先验证问题在哪里：三组排查 SQL（只读）

下面这几条建议你直接在分析库跑一轮，先把现状看清楚，再动刀。

### 1\. 拜访盘子有没有问题：最近 6 周每周拜访站点数

如果这里最近两周的 `visit_store_cnt` 正常（不是 0 或极低），说明“拜访有，闭环没了”——问题不在拜访链路，而是在上报链路或 join 条件。

### 2\. 同周“成功上报站点数”：看 submit\_store\_week 的源头是不是空了

重点看最近两周：

- 如果最近两周 `submit_success_store_cnt` 直接变成 0 或接近 0，就基本确认：
	- 要么这两周根本没塞上报数据；
	- 要么“成功”不再写成 `'success'` ；
- 如果这里数字正常，而你周维表里的 `visit_submit_station_cnt` 仍然是 0，那问题就转移到“join 逻辑（store\_id / week\_key 计算）”这一侧。

### 3\. 最近 4 周处理状态枚举分布：看成功状态是否“换名字”

看法：

- 找出最近两周中 “站点数最多的几个 status”；
- 和前几周对比，判断是不是：
	- 之前成功都写 `'success'` ；
	- 最近变成比如 `'COMPLETED'` 、 `'S2'` 、 `'DONE'` 之类的新枚举；
- 一旦确认“成功状态换名”，就可以有针对性地改 `submit_store_week` 的过滤条件。

---

## 三、给你一条“直击 join 效果”的对比查询

上面是从源表角度看。你可能还需要一条直接模拟“拜访 × 上报” join 的查询，看 join 后到底是不是全空了。

如果结果是：

- `visit_store_cnt` 正常，
- 但最近两周 `visit_submit_store_cnt = 0` ，  
	基本就和你周维表里的现象完全对齐了。

你还能再跑一条“去掉 status 限制”的对比：

- 如果“去掉 status”之后，最近两周 `visit_anystatus_store_cnt` 又恢复到正常数量，则 100% 说明： **问题就是 `processing_status='success'` 这个条件写窄了** 。

---

## 四、修复思路：改 submit\_store\_week 的“成功口径”+ 回刷周维表

在上面几条 SQL 跑完之后，你基本会得到两类结论之一：

1. **结论 A：最近两周压根没有上报数据**
	- 这种情况属于上游 ETL/接口出问题，得找数据侧；
	- 周维逻辑本身是正常的， `visit_submit_station_cnt = 0` 只是如实反映“没上报”。
2. **结论 B：最近两周有上报数据，但 status 不再是 `'success'`**
	- 这才是你现在说的“指标 miss”的典型情况，修复方式和 has\_submit 那一套类似：  
		1）先通过第 3 条枚举分布 SQL，列出所有“应该被视为成功”的状态值；  
		2）把 `submit_store_week` 里的条件从
		改成例如：
		3）全量重跑 `visit_submit_weekly_stats` （或当前这张周维表），把最近 12 周甚至更长周期的数据全部刷新一遍。

修复后 `submit_store_week` 的示意版本：

> 真正需要填的是括号里的状态集合，必须根据你跑出来的枚举分布结果、结合业务确认。

之后，整条周维 SQL 不用大改，只要这个 CTE 修正了，上游 `visit_submit_station_cnt` 自然会恢复。

---

## 思维导图结构（文字版）

- 问题现象
	- `visit_submit_station_cnt` 最近两周全国为 0
	- 拜访盘子大概率正常 → 闭环统计失效
- 逻辑定位
	- 指标来自 agg\_province\_\* 对 submit\_store\_week 的 LEFT JOIN
	- submit\_store\_week 只看 `processing_status='success'`
- 排查查询
	- 最近 6 周拜访站点数（是否正常）
	- 最近 6 周成功上报站点数（当前 success 口径）
	- 最近 4 周 status 枚举分布（是否新增/改名）
	- 直接模拟“拜访×上报” join：有无成功，有无去掉 status 后恢复
- 修复路径
	- 情况 A：根本没上报数据 → 找 ETL/接口
	- 情况 B：status 改名 → 扩展成功状态集（IN (...))
	- 修改 submit\_store\_week success 口径
	- 回刷 visit\_submit\_weekly\_stats 周维表

---

## 《迭代日志》

- 【来源】
	- 你反馈： `visit_submit_station_cnt` 最近两周全国掉到 0；
	- 上文已经分析过 has\_submit 和 `processing_status='success'` 漂移问题。
- 【结论】
	- 逻辑上， `visit_submit_station_cnt` = “拜访站点中，同周在 visit\_records\_enriched 里出现成功上报的站点数”；
	- 最近两周变成 0，极大概率是 `submit_store_week` 由于 `processing_status='success'` 口径不再覆盖当前“成功状态”，导致 join 侧空；
	- 修复必须从源头重新定义“成功状态集”，修改 `submit_store_week` 的 WHERE 条件并回刷周维表。
- 【改动点】
	- 明确了 `visit_submit_station_cnt` 的计算链路及其对 `submit_store_week` 的依赖；
	- 提供了 4 组只读 SQL，用于从拜访盘子、成功盘子、状态枚举、join 效果四个角度验证问题；
	- 给出修改 `submit_store_week` 成功口径的示意代码。
- 【待补充】
	- 你实际线上“可以视为成功”的 `processing_status` 枚举列表；
	- 是否需要兼容历史老状态（例如历史用 success，新版本用 COMPLETED），做一个“向前兼容”的状态集合。
- 【下一步建议】
	1. 先按我给的 4 组 SQL 跑一遍，把最近 4–6 周的情况看清楚（特别是 status 枚举）；
	2. 把“前 2–3 周 vs 最近 2 周”的 status 分布差异截图/摘要给我，我们一起明确成功状态集合；
	3. 我再帮你把周维大 SQL 做一次“正式修订版”，顺带输出一份“口径变更说明”，方便你对齐老板和数据侧。

20251206\_1430\_processing\_status修正与去重主键标记方案

tags:: #processing\_status #success订正 #去重逻辑 #record\_id主键 #MySQL更新

---

**一句话结论：**  
可以直接用一组 UPDATE/ALTER/UPDATE SQL，把 `visit_records_enriched` 里所有 `processing_status` 订正为 `'success'` ，同时按 `record_id + 最早业务日期` 标记出唯一主记录和重复记录，后续所有查询只认“主记录”即可完成去重。

---

## 一、先做状态订正：把所有记录统一成 processing\_status='success'

你现在已经确定：所有下游逻辑都只认 `processing_status='success'` ，且短期没精力逐个调整下游，这种情况下可以在表上做一次“强制对齐”。

建议你这样做（一步到位）：

说明：

- 第一步是“保险丝”：把原始 `processing_status` 先复制到 `processing_status_old` ，以后如果要回溯或重新设计口径，还有恢复空间；
- 第二步才是真正把所有记录“洗成 success”；
- 执行前可以先跑一条：
	看看现在有多少种状态、各自记录量有多少，心里有数再更新。

---

## 二、设计去重主键逻辑：以 record\_id 分组，取“最早业务日期 + 最小 id”为主记录

你给的字段里，关键的信息是：

- `id` ：自增主键（物理主键）；
- `record_id` ：一条上报的业务主键（你说“相同的 record\_id 视为同一条记录”）；
- 时间相关字段： `visit_date_only` 、 `visit_date` 、 `create_time` 、 `created_at` ；
- 质量相关字段： `is_primary_record` 、 `data_quality_flag` 、 `duplicate_flag` （但这些现在已经不可信了，你希望重新打标）。

你提的规则是：

> “相同的 record\_id 视为同一条记录，取 dt 最早的一天，标记为 1，最后去标记 1 的就是去重后的记录”。

结合表结构，我给你一个偏稳妥的排序规则：

- 优先用业务日期： `visit_date_only` ；
- 其次： `visit_date` ；
- 再次： `DATE(create_time)` ；
- 最后才用 `DATE(created_at)` ；
- 同一天多条时，用 `id` 最小的那条当主记录。

### 2.1 新增一个“主记录标记列”（不改你原来的字段，以免混乱）

说明：

- 不去复用 `is_primary_record` 和 `duplicate_flag` ，因为你现在已经不信任它们了；
- 新建 `is_canonical_record` ，语义非常明确：
	- 1 = 这个 `record_id` 下面被选中的“唯一主记录”；
	- 0 = 这个 `record_id` 下的其他重复记录。

### 2.2 用窗口函数计算“每个 record\_id 下的主记录”

我们利用 MySQL 8 的窗口函数来做，遵守你的偏好：不用 `WITH` ，只用子查询。

这段逻辑：

- 按 `record_id` 分组；
- 在每个组里按“最早业务日期优先、id 最小优先”排序；
- `rn = 1` 的那条就是你要的“dt 最早的一天 + 最小 id”的主记录；
- 这条记录会被标记为 `is_canonical_record = 1` ，其它全部是 0。

### 2.3 如果你还想同步更新 duplicate\_flag（可选）

你示例里 `duplicate_flag` 已经有值（例如 `duplicate` ），但逻辑明显不对，可以重置成更清晰的状态：

---

## 三、验证与使用：如何检查结果、如何“只用唯一记录”

### 3.1 快速验证标记是否正确

1）看每个 `record_id` 是否只有一个主记录：

如果这条查询返回 0 行，说明：每个 `record_id` 正好有且只有一条 `is_canonical_record = 1` 的记录，逻辑是自洽的。

2）看整体重复情况分布：

你会看到：

- `is_canonical_record=1` 的行数 = 业务唯一记录数；
- `is_canonical_record=0` 的行数 = 被判定为重复的记录行数。

### 3.2 下游如何“只用去重后的记录”

以后不管是生成 V3 也好、算周维也好，凡是用到 `visit_records_enriched` 的地方，都可以简单做一层过滤：

或者如果你懒得改很多 SQL，可以建一个“去重视图”：

然后：

- 原来用 `visit_records_enriched` 的查询，逐步换成 `visit_records_enriched_dedup` ；
- 这样你既保留了所有原始记录（以备未来需要），又能确保所有指标只基于“去重后的唯一记录”计算。

---

## 思维导图结构（文字版）

- 目标
	- 统一 `processing_status` 以兼容所有下游
	- 对 `visit_records_enriched` 做稳定的去重主键标记
- 状态订正
	- 备份列： `processing_status_old`
	- 全表统一： `UPDATE ... SET processing_status='success'`
- 去重设计
	- 业务主键： `record_id`
	- 排序规则：最早业务日期（visit\_date\_only/visit\_date/create\_time/created\_at）+ 最小 id
	- 新列： `is_canonical_record` （1=主记录, 0=重复）
- 实现步骤
	- ALTER TABLE 增加 is\_canonical\_record
	- UPDATE + 窗口函数 ROW\_NUMBER() 标主记录
	- 可选：重置 duplicate\_flag 为 primary/duplicate
- 使用方式
	- 验证：每个 record\_id 仅 1 条 is\_canonical\_record=1
	- 下游：只用 is\_canonical\_record=1，或通过视图 visit\_records\_enriched\_dedup

---

## 《迭代日志》

- 【来源】
	- 你确认所有下游都依赖 `processing_status='success'` ，且不想逐条修改下游逻辑；
	- 同时发现 `visit_records_enriched` 存在大量重复记录，希望按 `record_id + 最早日期` 定义“唯一真实记录”，并实现标记与去重。
- 【结论】
	- 可以在表级做一次“状态统一 + 去重主键标记”：
		- 新增 `processing_status_old` ，备份旧状态，再把所有 `processing_status` 统一改为 `'success'` ；
		- 新增 `is_canonical_record` ，按 `record_id` + 最早业务日期 + 最小 id 标出唯一主记录；
		- 下游全部基于 `is_canonical_record=1` 的记录进行统计，逻辑干净可控。
- 【改动点】
	- 明确不直接篡改已有 `is_primary_record` / `duplicate_flag` 的语义，而是用一个全新的 `is_canonical_record` 做“去重金标准”；
	- 使用窗口函数 + 子查询，而非 WITH，兼容你的 SQL 习惯。
- 【待补充】
	- 你如果有明确的“业务日期字段优先级”（比如必须以 visit\_date\_only 为准），可以再微调排序规则；
	- 如果后续打算重新设计 `processing_status` 多状态语义，可以利用 `processing_status_old` 做回溯和再分类。
- 【下一步建议】
	1. 在测试库先跑一遍这组 ALTER + UPDATE + 验证查询，确认没有奇怪的 `record_id` 异常；
	2. 确认没问题后，再在生产库分批执行（尤其是 UPDATE 全表那一步）；
	3. 如果你希望，我可以再帮你给 V3 构建脚本、周维脚本出一版“只用去重视图”的完整改写方案，顺手把历史指标重新算一遍。

视图是否能自动更新,怕忘记了更新

20251206\_1458\_视图是否需要手动更新

tags:: #数据库视图 #自动更新 #去重视图 #物化视图概念

---

**一句话结论：**  
你按我给的那种“普通视图”（ `CREATE VIEW ... AS SELECT ...`）建出来之后，不需要任何手动更新，视图本身不存数据，只要底层表 `visit_records_enriched` 变了、标记变了，视图结果就会自动跟着变。

---

## 三段论据

### 论据一：普通视图是“实时透视”，不是一张要刷新的表

在 MySQL 里，像下面这样的：

属于“普通视图”（非物化），特点是：

- 视图不存数据，只存一段 SQL 定义；
- 每次你 `SELECT * FROM visit_records_enriched_dedup` ，数据库会等价执行：
- 所以：
	- 新插入的记录、更新的 `is_canonical_record` 标记，只要在原表里生效，视图查询立刻反映最新结果；
	- 不存在“忘记刷新视图”这个问题。

你真正需要记得的是：什么时候需要重跑“去重标记那条 UPDATE”，而不是刷新视图。

### 论据二：你真正要维护的是“标记过程”，不是视图本身

现在我们的设计是：

1. 原始/主表： `visit_records_enriched`
	- 原始所有上报记录都在这；
	- 新增列： `is_canonical_record` （去重标记）、 `processing_status_old` （备份状态）。
2. 去重过程（你执行的 UPDATE + 窗口函数）
	- 逻辑：按 `record_id + 最早业务日期 + 最小 id` 算出唯一主记录；
	- 只要这段 UPDATE 跑过一次，表里标记就稳定了；
	- 以后如果你又导入了一批新数据，只要再跑一遍这个过程，标记会重新收敛，视图会自动跟着变。
3. 视图： `visit_records_enriched_dedup`
	- 只是把“去重后的视图”标准化给下游使用；
	- 下游不再操心 `is_canonical_record` 字段，只认这个视图；
	- 你也不用在每个下游 SQL 里重复 `WHERE is_canonical_record = 1` 。

换句话说：

- 视图 = 把“过滤条件封装起来”；
- 你怕忘的是“过滤条件”，不是“视图刷新”；
- 我们已经把过滤条件固化在视图里了，这块你不用再记。

### 论据三：只有“快照表/物化表”才需要手动刷新

你现在担心的那种 “会不会忘了更新” 的情况，其实对应的是另一种模式：

这种是“物理表快照”（有点像物化视图），特点：

- 数据真的复制了一份；
- 之后原表有新数据，这张表不会自动同步；
- 必须手动重跑 `INSERT OVERWRITE...` or `TRUNCATE + INSERT` 之类操作更新它。

我现在给你的方案是：

- 核心明细只保留一张表 `visit_records_enriched` ；
- 用 `is_canonical_record` 标记 + 视图来完成“去重后的统一入口”；
- 不再多搞一张“去重结果表”，也就没有“记不住刷新”的问题。

如果以后你真的有性能瓶颈、或者要在 Hive/Kafka 那种环境做物化表，那再单独设计刷新策略，不在你现在这个 MySQL 场景里纠结。

---

## 思维导图结构（文字版）

- 视图是否自动更新？
	- 普通视图
		- `CREATE VIEW ... AS SELECT ...`
		- 不存数据，只存 SQL 定义
		- 每次查询实时从底层表算 → 自动反映最新数据
	- 你要维护的是
		- 去重 UPDATE 逻辑（标记 is\_canonical\_record）
		- 而不是视图本身
	- 容易混淆的情况
		- `CREATE TABLE AS SELECT` 快照表
		- 这种才需要手动刷新，不是我们当前方案

---

## 《迭代日志》

- 【来源】
	- 上一轮给你设计了：
		- 统一 `processing_status='success'` ；
		- 在 `visit_records_enriched` 上通过 `is_canonical_record` 做去重标记；
		- 建议创建视图 `visit_records_enriched_dedup` 给下游统一使用。
	- 你现在担心：“视图会不会不自动更新，我怕忘记刷新”。
- 【结论】
	- MySQL 普通视图是虚拟的，每次查询都会实时读底层表，不存在“忘记更新视图”的问题；
	- 你只要记得在导入/修正数据后，再跑一遍“去重标记 UPDATE”，视图会自动反映新标记。
- 【下一步建议】
	1. 在测试库先建一个 `visit_records_enriched_dedup` 视图，随便插几条新数据、改几条 `is_canonical_record` ，验证它确实实时变化；
	2. 确认没问题后，在生产库落这套：
		- 一次性补全 `processing_status_old` + `is_canonical_record` 标记；
		- 建视图；
		- 把后续所有新 SQL 慢慢迁移到使用视图，底层去重逻辑以后就只改一处。

20251206\_1515\_周维结果表使用ON\_DUPLICATE\_KEY实现幂等写入

tags:: #MySQL #主键冲突1062 #幂等更新 #ON\_DUPLICATE\_KEY\_UPDATE #周维统计

---

**一句话结论：**  
你这个 1062 报错就是因为 `visit_submit_weekly_stats` 已经有同一个主键（ `NATIONAL_OVERALL-全国-整体-202542` ），解决办法是把原来的 `INSERT ... SELECT` 换成 `INSERT ... SELECT ... ON DUPLICATE KEY UPDATE` ，让同主键时改为更新已有行、无主键时再插入。

---

## 一、先确认一下现状（逻辑层面）

1. 当前表 `visit_submit_weekly_stats` 的主键是：
	所以同一个 `(dim_level, province, visitor_name, week_key)` 只能有一行。
2. 报错信息：
	很直接地说明：
	- 表里已经有 `dim_level='NATIONAL_OVERALL'` 、 `province='全国'` 、 `visitor_name='整体'` 、 `week_key=202542` 这一行；
	- 你再次用 `INSERT` 想插入同样主键的数据，所以冲突了。
3. 你的需求是幂等的调度口径：
	> “如果有数据就更新它，没有就插入它。”
	这就是 MySQL 典型的 `INSERT ... ON DUPLICATE KEY UPDATE` 场景。

---

## 二、把你的 INSERT 包一层 ON DUPLICATE KEY UPDATE（保留原 CTE 不动）

你现在的结构大致是这样的（简化版）：

你只需要在最后加上 `ON DUPLICATE KEY UPDATE` ，把指标字段全部用“新值覆盖旧值”，就实现了“有就更新、无就插入”：

```sql
sqlINSERT INTO visit_submit_weekly_stats (
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
)
WITH
    base_store AS (
        SELECT 
            store_id,
            province,
            has_submit AS has_submit_history
        FROM station_tag_coverage_analysis_v3
    ),
    visit_store_week AS (... 省略你的原有 CTE ...),
    visit_store_week_visitor AS (...),
    submit_store_week AS (...),
    agg_province_visitor AS (...),
    prov_visitor_rates AS (...),
    prov_visitor_with_rate AS (...),
    agg_province_overall AS (...),
    prov_overall_with_rate AS (...),
    national_overall AS (...)
SELECT
    dim_level,
    province,
    visitor_name,
    week_key,
    week_start_date,
    visit_station_cnt,
    visit_submit_station_cnt,
    visit_with_history_submit_station_cnt,
    visit_never_submit_station_cnt,
    submit_same_period_rate_from_visit_pct,
    submit_history_rate_from_visit_pct,
    never_submit_rate_from_visit_pct,
    rank_in_province
FROM (
    SELECT * FROM national_overall
    UNION ALL
    SELECT * FROM prov_overall_with_rate
    UNION ALL
    SELECT * FROM prov_visitor_with_rate
) t
ON DUPLICATE KEY UPDATE
    -- 主键维度不需要更新，它们已经相等
    week_start_date                          = VALUES(week_start_date),
    visit_station_cnt                        = VALUES(visit_station_cnt),
    visit_submit_station_cnt                 = VALUES(visit_submit_station_cnt),
    visit_with_history_submit_station_cnt    = VALUES(visit_with_history_submit_station_cnt),
    visit_never_submit_station_cnt           = VALUES(visit_never_submit_station_cnt),
    submit_same_period_rate_from_visit_pct   = VALUES(submit_same_period_rate_from_visit_pct),
    submit_history_rate_from_visit_pct       = VALUES(submit_history_rate_from_visit_pct),
    never_submit_rate_from_visit_pct         = VALUES(never_submit_rate_from_visit_pct),
    rank_in_province                         = VALUES(rank_in_province);
```

说明几点：

1. `ON DUPLICATE KEY UPDATE` 生效条件：
	- 你的 `PRIMARY KEY(dim_level, province, visitor_name, week_key)` 冲突时触发；
	- 这时不会报 1062，而是执行 UPDATE，按右边的赋值覆盖字段。
2. `VALUES(col)` ：
	- 代表“这次 INSERT 语句里 SELECT 出来的新值”；
	- 虽然在 MySQL 8.0+ 官方说这个函数未来会废弃，但目前还可用，语义非常清晰。
	- 如果你以后想更规范，可以用别名版写法（我下面给一个参考）。
3. 维度列（主键列）不需要在 UPDATE 部分改动：
	- 冲突行的主键已经是你想要的那一行；
	- 更新时只需要覆盖统计指标和 week\_start\_date 这类非主键字段。

---

## 三、如果你想避开 VALUES()，可以用别名版（备选方案）

有的团队对 `VALUES()` 比较敏感，希望用“来源别名”的写法，也给你一版：

注意这里我给目标表起了别名 `dst` ，SELECT 子查询起了别名 `src` ，然后在 UPDATE 子句中直接用 `src.xxx` 引用新值，这在 MySQL 8.0 里是合法的写法。

---

## 思维导图结构（文字版）

- 问题
	- 1062 Duplicate entry for PRIMARY KEY
	- 原因：同一 `(dim_level, province, visitor_name, week_key)` 已存在记录
- 目标
	- 实现“有则更新、无则插入”的幂等写入
- 方案
	- 用 `INSERT ... SELECT ... ON DUPLICATE KEY UPDATE`
	- 主键： `dim_level + province + visitor_name + week_key`
	- 更新字段： `week_start_date + 各种 cnt + rate + rank`
- 实现
	- 保留原 CTE 与 SELECT 逻辑不动
	- 在末尾追加 `ON DUPLICATE KEY UPDATE ...`
	- 可选：用 `VALUES(col)` 或 `AS src` 别名引用新值

---

## 《迭代日志》

- 【来源】
	- 你执行向 `visit_submit_weekly_stats` 的 INSERT，报错 1062 主键冲突；
	- 主键为 `(dim_level, province, visitor_name, week_key)` ，冲突值是 `NATIONAL_OVERALL-全国-整体-202542` ；
	- 你希望改成“如果已存在就更新，否则插入”的写法。
- 【结论】
	- 表结构是对的，问题在于目前使用的是纯 INSERT；
	- 直接在当前 `INSERT ... WITH ... SELECT ...` 语句后追加 `ON DUPLICATE KEY UPDATE` ，用新计算结果覆盖旧指标，就能实现幂等写入；
	- 我给出了两种写法： `VALUES(col)` 版和 `AS src` 别名版，你选一种固定用。
- 【下一步建议】
	1. 先在测试库用 `LIMIT` 或缩小时间窗口跑一版带 `ON DUPLICATE KEY UPDATE` 的版本，确认不会再报 1062；
	2. 如果你后面会定期滚动刷新“最近 12 周”，就用这条 upsert 语句直接挂调度，哪怕重复跑也不会引起冲突；
	3. 如需，我可以再帮你改一版“只刷新指定周段（传入 start\_week / end\_week）”的参数化 SQL，进一步缩小写入范围。

20251206\_1535\_week\_data生成列的更新机制与回滚方案

tags:: #MySQL生成列 #stored\_generated\_column #ALTER\_TABLE #visit\_submit\_weekly\_stats #week\_data格式

---

**一句话结论：**  
`week_data` 是一个基于 `week_start_date` 的「生成列」，不会在业务 SQL 里手写计算，只要用 `ALTER TABLE ... MODIFY COLUMN ...` 改回你想要的表达式，MySQL 会自动重新计算所有行的值，以后也会按新规则实时更新，无需再手动 UPDATE。

---

### 1\. 先说明白：week\_data 为啥不需要在 SQL 里计算

你现在的定义是这样的（我整理一下）：

关键点：

1. **GENERATED ALWAYS AS (...) STORED = 生成列（存储型）**
	- `week_data` 的值由表达式自动计算出来：  
		`MM/DD` + `连接符` + `MM/DD` （周一到周五）。
	- 你插入/更新时，只要写 `week_start_date` ， **不要** 插入 `week_data` ，MySQL 会自己算。
	- 你如果尝试 `UPDATE ... SET week_data = 'xxx'` ，会报错，因为生成列不能直接改值。
2. **为什么你在 INSERT 语句里看不到计算逻辑？**
	- 因为逻辑在表结构里，不在业务 SQL 里；
	- 每条 `INSERT` / `UPDATE` 写入 `week_start_date` 时，MySQL 内部会按这个表达式重算一遍 `week_data` ，然后存入表。
3. **STORED 的含义**
	- `STORED` ：值真的存到磁盘（类似普通列，但由表达式维护）；
	- 每次改 `week_start_date` ，都会触发表达式重算再存一遍；
	- 查询时就像查普通列一样，不会重新计算，提高查询性能。

---

### 2\. 你把连接符从 \_\_ 改成 ~，怎么改回去？

你现在看到的是：

之前你想要的是类似： `12/01__12/05` 这样的格式。  
要改回去，只需要对表做一次 `ALTER TABLE ... MODIFY COLUMN` ，把表达式改回去：

说明：

- 这条 DDL 执行后：
	- 表结构中的表达式会更新；
	- MySQL 会在重建这列表结构的过程中，按照新表达式重新算一遍所有行的 `week_data` （因为是 STORED）。
- 你不用再写什么 `UPDATE` 去挨个改 `week_data` ，只要这个 ALTER 成功，表里所有旧数据、新数据都会统一用 `__` 这个规则。

如果你想验证一下：

你应该能看到 `week_data` 已经变成 `12/01__12/05` 这类格式。

---

### 3\. 如果还是不放心，可以强制“重算一遍”（可选）

正常情况下， **只要 ALTER TABLE 成功，MySQL 就会自动重算 STORED 生成列** 。  
但如果你心理上不踏实，可以再做一步“强制触发重算”的保险动作：

- 这条 UPDATE 在数值上没有变化，但会触发一遍行级更新；
- 对每行来说， `week_start_date` 写入一次 → 生成列表达式被触发 → `week_data` 再按新规则算一遍；
- 对当前这种场景来说，其实多此一举，但作为兜底手段是安全的。

如果数据量非常大（上百万行），这一步就慎用，绝大多数情况下只改 DDL 就够了。

---

## 思维导图结构（文字版）

- 核心对象： `visit_submit_weekly_stats.week_data`
	- 定义
		- `GENERATED ALWAYS AS (...) STORED`
		- 基于 `week_start_date` 自动生成周区间字符串
	- 更新机制
		- 插入/更新 `week_start_date` 时自动计算
		- 不需要在业务 SQL 里写计算
		- 不允许直接 UPDATE `week_data`
	- 改连接符
		- 用 `ALTER TABLE ... MODIFY COLUMN ...` 改表达式
		- 示例：从 `'~'` 改回 `'__'`
		- MySQL 会在 DDL 时重算 STORED 生成列
	- 可选兜底
		- `UPDATE ... SET week_start_date = week_start_date` 强制重算
		- 一般不需要，只给心理安全垫

---

## 《迭代日志》

- 【来源】
	- 你发现 `week_data` 在表结构里是一个 STORED 生成列，表达式里连接符从 `__` 被改成了 `~` ；
	- 你注意到在业务 SQL 里看不到任何关于 `week_data` 的计算逻辑，担心“不知道它是怎么更新的”，并且现在想改回 `__` 格式。
- 【结论】
	- `week_data` 完全由表结构里的「生成列表达式」驱动，跟业务 SQL 无关；
	- 正确的回滚方式是：用 `ALTER TABLE ... MODIFY COLUMN` 把表达式改回原来的连接符，MySQL 会自动重算所有行的 `week_data` ，以后所有新数据也会按新规则生成；
	- 不需要写逐行 UPDATE 去改 `week_data` ，除非你对自动重算不放心，可以额外用一次自更新触发。
- 【改动点】
	- 给出了完整的 `ALTER TABLE` 改回 `__` 连接符的 DDL；
	- 明确了 STORED 生成列的更新机制，解释了为什么在 INSERT / UPDATE 语句里看不到计算逻辑。
- 【待补充】
	- 如果你后续还想对 `week_data` 做国际化（比如 `YYYY-MM-DD` 形式），只要在表达式里改 `DATE_FORMAT` 即可；
	- 如果未来这张表行数非常大，可以考虑把 `week_data` 改成 `VIRTUAL` 生成列，只在查询时算，不存盘（前提是这列不会频繁作为索引/排序关键字段）。
- 【下一步建议】
	1. 先在测试库跑一遍 `ALTER TABLE ... MODIFY COLUMN week_data` ，确认 `SHOW CREATE TABLE` 和样例 SELECT 的格式都对；
	2. 确认无误后再在线上执行，避免长时间锁表窗口选择在业务低峰期；
	3. 后面如果再要改 week\_data 展示样式，优先改表达式，不要在业务 SQL 里硬改。