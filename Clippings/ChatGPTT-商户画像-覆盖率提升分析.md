---
title: ChatGPT
source: https://chatgpt.com/g/g-p-692abef2079c81918c16c22b66aec849-shang-hu-hua-xiang/c/69318d80-4aa4-8323-a1be-4e052573031d
author:
  - "[[ChatGPT-非油品-2期BRD草稿]]"
published:
created: 2025-12-23
description: ChatGPT 是一款供日常使用的 AI 聊天机器人。与最先进的 AI 模型互动，探索创意、解决问题以及提升学习效率。
tags:
  - clippings
---
\[-- ################################################################ -- # # -- # 标签覆盖率提升 - 多层漏斗推断系统（完整版） # -- # # -- # 核心逻辑：先精算，再推断 # -- # 层级：L1原始值 → L2精细计算 → L3同源推断 → L4人工核验 # -- # # -- ################################################################ -- ================================================================ -- 第一部分：建表（推断结果存档表） -- ================================================================ -- ================================================================ -- 修正版：推断结果存档表（主键包含分区字段） -- ================================================================ DROP TABLE IF EXISTS `station_tag_inference_result`; CREATE TABLE `station_tag_inference_result` ( `id` BIGINT AUTO\_INCREMENT COMMENT '自增ID', `dt` DATE NOT NULL COMMENT '推断日期（分区字段）', -- 油站基础信息 `store_id` VARCHAR(50) NOT NULL COMMENT '油站ID', `store_name` VARCHAR(100) COMMENT '油站名称', `province` VARCHAR(50) COMMENT '省区', `province_name` VARCHAR(50) COMMENT '省份', `city_name` VARCHAR(50) COMMENT '城市', `is_key_store` TINYINT(1) COMMENT '是否重点站', -- 推断依据字段 `pop_id` VARCHAR(50) COMMENT 'POP ID', `brand_name` VARCHAR(100) COMMENT '品牌名称', `brand_level` VARCHAR(50) COMMENT '品牌等级', `is_small_brand` TINYINT(1) COMMENT '是否小散品牌（1=是，不参与推断）', -- 标签信息 `tag_name` VARCHAR(50) NOT NULL COMMENT '标签名称', `tag_field_name` VARCHAR(50) COMMENT '对应字段名', -- 当前状态 `current_value` VARCHAR(100) COMMENT '当前值', `current_covered` TINYINT(1) COMMENT '当前是否覆盖', -- 漏斗层级 `process_level` TINYINT COMMENT '处理层级（1=原始值,2=精细计算,3=同源推断,4=无法推断）', `process_method` VARCHAR(50) COMMENT '处理方式', -- 推断结果 `inferred_value` VARCHAR(100) COMMENT '推断值/计算值', `confidence_level` VARCHAR(20) COMMENT '置信度（高/中/低）', -- JSON追溯字段（核心） `inference_detail` JSON COMMENT '推断详情（JSON格式，完整追溯信息）', -- 校验状态 `verify_status` VARCHAR(20) DEFAULT '待校验' COMMENT '校验状态', `verify_time` DATETIME COMMENT '校验时间', `verify_user` VARCHAR(50) COMMENT '校验人', `verify_value` VARCHAR(100) COMMENT '校验后确认值', `verify_remark` VARCHAR(200) COMMENT '校验备注', -- 时间戳 `create_time` DATETIME DEFAULT CURRENT\_TIMESTAMP, `update_time` DATETIME DEFAULT CURRENT\_TIMESTAMP ON UPDATE CURRENT\_TIMESTAMP, -- ★ 修正：主键包含分区字段 dt PRIMARY KEY (`id`, `dt`), -- 索引 INDEX idx\_dt\_store (dt, store\_id), INDEX idx\_store\_tag (store\_id, tag\_name), INDEX idx\_level (process\_level), INDEX idx\_verify (verify\_status), INDEX idx\_province (province) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_0900\_ai\_ci COMMENT='标签推断结果存档表（多层漏斗处理，含JSON追溯）' PARTITION BY RANGE (TO\_DAYS(dt)) ( PARTITION p202401 VALUES LESS THAN (TO\_DAYS('2024-02-01')), PARTITION p202402 VALUES LESS THAN (TO\_DAYS('2024-03-01')), PARTITION p202403 VALUES LESS THAN (TO\_DAYS('2024-04-01')), PARTITION p202404 VALUES LESS THAN (TO\_DAYS('2024-05-01')), PARTITION p202405 VALUES LESS THAN (TO\_DAYS('2024-06-01')), PARTITION p202406 VALUES LESS THAN (TO\_DAYS('2024-07-01')), PARTITION p202407 VALUES LESS THAN (TO\_DAYS('2024-08-01')), PARTITION p202408 VALUES LESS THAN (TO\_DAYS('2024-09-01')), PARTITION p202409 VALUES LESS THAN (TO\_DAYS('2024-10-01')), PARTITION p202410 VALUES LESS THAN (TO\_DAYS('2024-11-01')), PARTITION p202411 VALUES LESS THAN (TO\_DAYS('2024-12-01')), PARTITION p202412 VALUES LESS THAN (TO\_DAYS('2025-01-01')), PARTITION p202501 VALUES LESS THAN (TO\_DAYS('2025-02-01')), PARTITION p202502 VALUES LESS THAN (TO\_DAYS('2025-03-01')), PARTITION p202503 VALUES LESS THAN (TO\_DAYS('2025-04-01')), PARTITION p202504 VALUES LESS THAN (TO\_DAYS('2025-05-01')), PARTITION p202505 VALUES LESS THAN (TO\_DAYS('2025-06-01')), PARTITION p202506 VALUES LESS THAN (TO\_DAYS('2025-07-01')), PARTITION pmax VALUES LESS THAN MAXVALUE ); -- ================================================================ -- 修正版：推断确认表（无分区，保持简单） -- ================================================================ DROP TABLE IF EXISTS `station_tag_inference_confirmed`; CREATE TABLE `station_tag_inference_confirmed` ( `id` BIGINT AUTO\_INCREMENT PRIMARY KEY, `inference_id` BIGINT COMMENT '关联推断结果表ID', `dt` DATE NOT NULL COMMENT '确认日期', `store_id` VARCHAR(50) NOT NULL, `store_name` VARCHAR(100), `province` VARCHAR(50), `tag_name` VARCHAR(50) NOT NULL, `tag_field_name` VARCHAR(50), `confirmed_value` VARCHAR(100) NOT NULL COMMENT '确认值', `process_level` TINYINT COMMENT '来源层级', `process_method` VARCHAR(50) COMMENT '来源方式', `confidence_level` VARCHAR(20), `confirm_type` VARCHAR(20) COMMENT '确认方式（自动/人工确认/人工修正）', `confirm_user` VARCHAR(50), `confirm_time` DATETIME, `inference_detail` JSON COMMENT '推断详情（继承）', `is_synced` TINYINT(1) DEFAULT 0 COMMENT '是否已同步到主表', `sync_time` DATETIME, `create_time` DATETIME DEFAULT CURRENT\_TIMESTAMP, UNIQUE KEY uk\_store\_tag (store\_id, tag\_name), INDEX idx\_dt (dt), INDEX idx\_sync (is\_synced), INDEX idx\_level (process\_level) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_0900\_ai\_ci COMMENT='标签推断确认表（校验通过）'; -- ================================================================ -- 第二部分：数据准备（临时表） -- ================================================================ -- 2.1 创建推断基础表（整合所有需要的字段） DROP TABLE IF EXISTS tmp\_infer\_base; CREATE TABLE tmp\_infer\_base AS SELECT d.store\_id, d.store\_name, d.province, d.province\_name, d.city\_name, d.is\_key\_store, d.total\_covered\_tags, d.order\_cnt\_30d, -- 标签覆盖状态（10个标签） d.tag\_brand\_covered, d.tag\_competitive\_covered, d.tag\_sme\_covered, d.tag\_carwash\_available\_covered, d.tag\_carwash\_type\_covered, d.tag\_convenience\_covered, d.tag\_restroom\_covered, d.tag\_parking\_covered, d.tag\_open\_24h\_covered, d.tag\_open\_hours\_covered, -- 标签原始值 d.brand\_name\_value, d.competitive\_overlap\_value, d.sme\_supplier\_value, d.carwash\_available\_value, d.carwash\_type\_value, d.convenience\_store\_value, d.restroom\_value, d.parking\_value, d.open\_24h\_value, d.open\_hours\_value, -- 推断依据字段（从源表获取） m.pop\_id, m.brand\_name, m.brand\_level, m.is\_zxgj, -- 营业时间计算字段 -- 小散品牌标记 CASE WHEN m.brand\_name IN ('其他', '未知', '') OR m.brand\_name IS NULL THEN 1 ELSE 0 END AS is\_small\_brand, -- 解析 is\_zxgj（格式如 "1-23"） CASE WHEN m.is\_zxgj IS NOT NULL AND m.is\_zxgj LIKE '%-%' THEN CAST(SUBSTRING\_INDEX(m.is\_zxgj, '-', 1) AS SIGNED) ELSE NULL END AS zxgj\_start\_hour, CASE WHEN m.is\_zxgj IS NOT NULL AND m.is\_zxgj LIKE '%-%' THEN CAST(SUBSTRING\_INDEX(m.is\_zxgj, '-', -1) AS SIGNED) ELSE NULL END AS zxgj\_end\_hour FROM station\_operation\_detail\_daily d LEFT JOIN ( SELECT mp.store\_id, mp.pop\_id, mp.brand\_name, mp.brand\_level, mp.is\_zxgj FROM merchant\_profile\_analysis mp INNER JOIN ( SELECT store\_id, MAX(dt) AS max\_dt FROM merchant\_profile\_analysis GROUP BY store\_id ) latest ON mp.store\_id = latest.store\_id AND mp.dt = latest.max\_dt ) m ON d.store\_id = m.store\_id WHERE d.dt = (SELECT MAX(dt) FROM station\_operation\_detail\_daily); ALTER TABLE tmp\_infer\_base ADD PRIMARY KEY (store\_id); ALTER TABLE tmp\_infer\_base ADD INDEX idx\_pop\_id (pop\_id); ALTER TABLE tmp\_infer\_base ADD INDEX idx\_brand (brand\_name); ALTER TABLE tmp\_infer\_base ADD INDEX idx\_brand\_level (brand\_level); ALTER TABLE tmp\_infer\_base ADD INDEX idx\_match\_group (brand\_name, brand\_level, pop\_id); -- 2.2 计算营业时间标记 DROP TABLE IF EXISTS tmp\_zxgj\_flags; CREATE TABLE tmp\_zxgj\_flags AS SELECT store\_id, is\_zxgj, zxgj\_start\_hour, zxgj\_end\_hour, -- 凌晨营业标记（起始<6） CASE WHEN zxgj\_start\_hour IS NOT NULL AND zxgj\_start\_hour < 6 THEN 1 ELSE 0 END AS is\_early\_morning, -- 深夜营业标记（结束>=22） CASE WHEN zxgj\_end\_hour IS NOT NULL AND zxgj\_end\_hour >= 22 THEN 1 ELSE 0 END AS is\_late\_night, -- 24小时营业判断 CASE WHEN zxgj\_start\_hour IS NOT NULL AND zxgj\_end\_hour IS NOT NULL AND zxgj\_start\_hour < 6 AND zxgj\_end\_hour >= 22 THEN 1 ELSE 0 END AS is\_24h, -- 推断的营业时间格式 CASE WHEN zxgj\_start\_hour IS NOT NULL AND zxgj\_end\_hour IS NOT NULL THEN CASE WHEN zxgj\_start\_hour < 6 AND zxgj\_end\_hour >= 22 THEN '00:00-24:00' ELSE CONCAT(LPAD(zxgj\_start\_hour, 2, '0'), ':00-', LPAD(LEAST(zxgj\_end\_hour + 1, 24), 2, '0'), ':00') END ELSE NULL END AS inferred\_open\_hours FROM tmp\_infer\_base WHERE is\_zxgj IS NOT NULL AND is\_zxgj!= ''; ALTER TABLE tmp\_zxgj\_flags ADD PRIMARY KEY (store\_id); -- 2.3 构建三条件一致的参照组 DROP TABLE IF EXISTS tmp\_match\_groups; SET SESSION group\_concat\_max\_len = 1000000; CREATE TABLE tmp\_match\_groups AS SELECT brand\_name, brand\_level, pop\_id, COUNT(DISTINCT store\_id) AS group\_store\_count, GROUP\_CONCAT(DISTINCT store\_id) AS group\_store\_ids, -- 各可推断标签的众数 -- 便利店 (SELECT convenience\_store\_value FROM tmp\_infer\_base t2 WHERE t2.brand\_name = t1.brand\_name AND t2.brand\_level = t1.brand\_level AND t2.pop\_id = t1.pop\_id AND t2.tag\_convenience\_covered = 1 AND t2.convenience\_store\_value NOT IN ('', '未知') GROUP BY convenience\_store\_value ORDER BY COUNT(\*) DESC LIMIT 1) AS mode\_convenience, -- 卫生间 (SELECT restroom\_value FROM tmp\_infer\_base t2 WHERE t2.brand\_name = t1.brand\_name AND t2.brand\_level = t1.brand\_level AND t2.pop\_id = t1.pop\_id AND t2.tag\_restroom\_covered = 1 AND t2.restroom\_value NOT IN ('', '未知') GROUP BY restroom\_value ORDER BY COUNT(\*) DESC LIMIT 1) AS mode\_restroom, -- 停车场 (SELECT parking\_value FROM tmp\_infer\_base t2 WHERE t2.brand\_name = t1.brand\_name AND t2.brand\_level = t1.brand\_level AND t2.pop\_id = t1.pop\_id AND t2.tag\_parking\_covered = 1 AND t2.parking\_value NOT IN ('', '未知') GROUP BY parking\_value ORDER BY COUNT(\*) DESC LIMIT 1) AS mode\_parking, -- 24小时营业 (SELECT open\_24h\_value FROM tmp\_infer\_base t2 WHERE t2.brand\_name = t1.brand\_name AND t2.brand\_level = t1.brand\_level AND t2.pop\_id = t1.pop\_id AND t2.tag\_open\_24h\_covered = 1 AND t2.open\_24h\_value NOT IN ('', '未知') GROUP BY open\_24h\_value ORDER BY COUNT(\*) DESC LIMIT 1) AS mode\_open\_24h, -- 营业时间 (SELECT open\_hours\_value FROM tmp\_infer\_base t2 WHERE t2.brand\_name = t1.brand\_name AND t2.brand\_level = t1.brand\_level AND t2.pop\_id = t1.pop\_id AND t2.tag\_open\_hours\_covered = 1 AND t2.open\_hours\_value NOT IN ('', '未知') GROUP BY open\_hours\_value ORDER BY COUNT(\*) DESC LIMIT 1) AS mode\_open\_hours FROM tmp\_infer\_base t1 WHERE brand\_name IS NOT NULL AND brand\_name NOT IN ('', '未知', '其他') AND brand\_level IS NOT NULL AND brand\_level NOT IN ('', '未知') AND pop\_id IS NOT NULL AND pop\_id!= '' GROUP BY brand\_name, brand\_level, pop\_id HAVING COUNT(DISTINCT store\_id) >= 2; -- 至少2个油站才能形成参照组 ALTER TABLE tmp\_match\_groups ADD INDEX idx\_match (brand\_name, brand\_level, pop\_id); -- ================================================================ -- 第三部分：多层漏斗处理 - 生成推断结果 -- ================================================================ -- 清空当天数据 DELETE FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE(); -- ================================================================ -- 3.1 第1层（L1）：已有实际值 - 所有10个标签 -- ================================================================ -- L1: 品牌名称（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '品牌名称', 'brand\_name\_value', brand\_name\_value, tag\_brand\_covered, 1, '原始值', brand\_name\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', brand\_name\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_brand\_covered = 1; -- L1: 竞争重叠（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '竞争重叠', 'competitive\_overlap\_value', competitive\_overlap\_value, tag\_competitive\_covered, 1, '原始值', competitive\_overlap\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', competitive\_overlap\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_competitive\_covered = 1; -- L1: SME供应商（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, 'SME供应商', 'sme\_supplier\_value', sme\_supplier\_value, tag\_sme\_covered, 1, '原始值', sme\_supplier\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', sme\_supplier\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_sme\_covered = 1; -- L1: 洗车服务可用（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '洗车服务可用', 'carwash\_available\_value', carwash\_available\_value, tag\_carwash\_available\_covered, 1, '原始值', carwash\_available\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', carwash\_available\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_carwash\_available\_covered = 1; -- L1: 洗车服务类型（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '洗车服务类型', 'carwash\_type\_value', carwash\_type\_value, tag\_carwash\_type\_covered, 1, '原始值', carwash\_type\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', carwash\_type\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_carwash\_type\_covered = 1; -- L1: 便利店可用（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '便利店可用', 'convenience\_store\_value', convenience\_store\_value, tag\_convenience\_covered, 1, '原始值', convenience\_store\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', convenience\_store\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_convenience\_covered = 1; -- L1: 卫生间可用（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '卫生间可用', 'restroom\_value', restroom\_value, tag\_restroom\_covered, 1, '原始值', restroom\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', restroom\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_restroom\_covered = 1; -- L1: 停车场可用（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '停车场可用', 'parking\_value', parking\_value, tag\_parking\_covered, 1, '原始值', parking\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', parking\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_parking\_covered = 1; -- L1: 24小时营业（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '24小时营业', 'open\_24h\_value', open\_24h\_value, tag\_open\_24h\_covered, 1, '原始值', open\_24h\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', open\_24h\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_open\_24h\_covered = 1; -- L1: 营业时间（已覆盖） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '营业时间', 'open\_hours\_value', open\_hours\_value, tag\_open\_hours\_covered, 1, '原始值', open\_hours\_value, '确定', JSON\_OBJECT( 'level', 1, 'method', '原始值', 'source', '源数据', 'current\_value', open\_hours\_value, 'timestamp', NOW() ), '已覆盖' FROM tmp\_infer\_base WHERE tag\_open\_hours\_covered = 1; -- ================================================================ -- 3.2 第2层（L2）：精细计算 - 基于is\_zxgj计算营业时间/24h营业 -- ================================================================ -- L2: 24小时营业（精细计算） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '24小时营业', 'open\_24h\_value', b.open\_24h\_value, b.tag\_open\_24h\_covered, 2, '精细计算', CASE WHEN z.is\_24h = 1 THEN '是' ELSE '否' END, '高', JSON\_OBJECT( 'level', 2, 'method', '精细计算', 'source', 'is\_zxgj', 'source\_value', b.is\_zxgj, 'parsed', JSON\_OBJECT('start\_hour', z.zxgj\_start\_hour, 'end\_hour', z.zxgj\_end\_hour), 'flags', JSON\_OBJECT('is\_early\_morning', z.is\_early\_morning = 1, 'is\_late\_night', z.is\_late\_night = 1), 'logic', CASE WHEN z.is\_24h = 1 THEN '凌晨营业(起始<6)+深夜营业(结束>=22)→24小时营业' WHEN z.is\_early\_morning = 1 THEN '仅凌晨营业' WHEN z.is\_late\_night = 1 THEN '仅深夜营业' ELSE '常规营业时间' END, 'inferred\_value', CASE WHEN z.is\_24h = 1 THEN '是' ELSE '否' END, 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_zxgj\_flags z ON b.store\_id = z.store\_id WHERE b.tag\_open\_24h\_covered = 0; -- 未覆盖的才处理 -- L2: 营业时间（精细计算） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '营业时间', 'open\_hours\_value', b.open\_hours\_value, b.tag\_open\_hours\_covered, 2, '精细计算', z.inferred\_open\_hours, '高', JSON\_OBJECT( 'level', 2, 'method', '精细计算', 'source', 'is\_zxgj', 'source\_value', b.is\_zxgj, 'parsed', JSON\_OBJECT('start\_hour', z.zxgj\_start\_hour, 'end\_hour', z.zxgj\_end\_hour), 'flags', JSON\_OBJECT('is\_early\_morning', z.is\_early\_morning = 1, 'is\_late\_night', z.is\_late\_night = 1, 'is\_24h', z.is\_24h = 1), 'logic', CONCAT('根据is\_zxgj(', b.is\_zxgj, ')计算得出'), 'inferred\_value', z.inferred\_open\_hours, 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_zxgj\_flags z ON b.store\_id = z.store\_id WHERE b.tag\_open\_hours\_covered = 0 AND z.inferred\_open\_hours IS NOT NULL; -- ================================================================ -- 3.3 第3层（L3）：同源推断 - 三条件一致 -- ================================================================ -- L3: 便利店可用（同源推断） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '便利店可用', 'convenience\_store\_value', b.convenience\_store\_value, b.tag\_convenience\_covered, 3, '同源推断', g.mode\_convenience, '高', JSON\_OBJECT( 'level', 3, 'method', '同源推断', 'match\_conditions', JSON\_OBJECT( 'brand\_name', b.brand\_name, 'brand\_level', b.brand\_level, 'pop\_id', b.pop\_id ), 'reference\_store\_count', g.group\_store\_count, 'reference\_store\_ids', g.group\_store\_ids, 'reference\_value', g.mode\_convenience, 'logic', CONCAT('三条件一致的', g.group\_store\_count, '个油站众数为:', g.mode\_convenience), 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_convenience\_covered = 0 AND b.is\_small\_brand = 0 AND g.mode\_convenience IS NOT NULL -- 排除已在L1/L2处理的 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '便利店可用' ); -- L3: 卫生间可用（同源推断） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '卫生间可用', 'restroom\_value', b.restroom\_value, b.tag\_restroom\_covered, 3, '同源推断', g.mode\_restroom, '高', JSON\_OBJECT( 'level', 3, 'method', '同源推断', 'match\_conditions', JSON\_OBJECT( 'brand\_name', b.brand\_name, 'brand\_level', b.brand\_level, 'pop\_id', b.pop\_id ), 'reference\_store\_count', g.group\_store\_count, 'reference\_store\_ids', g.group\_store\_ids, 'reference\_value', g.mode\_restroom, 'logic', CONCAT('三条件一致的', g.group\_store\_count, '个油站众数为:', g.mode\_restroom), 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_restroom\_covered = 0 AND b.is\_small\_brand = 0 AND g.mode\_restroom IS NOT NULL AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '卫生间可用' ); -- L3: 停车场可用（同源推断） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '停车场可用', 'parking\_value', b.parking\_value, b.tag\_parking\_covered, 3, '同源推断', g.mode\_parking, '高', JSON\_OBJECT( 'level', 3, 'method', '同源推断', 'match\_conditions', JSON\_OBJECT( 'brand\_name', b.brand\_name, 'brand\_level', b.brand\_level, 'pop\_id', b.pop\_id ), 'reference\_store\_count', g.group\_store\_count, 'reference\_store\_ids', g.group\_store\_ids, 'reference\_value', g.mode\_parking, 'logic', CONCAT('三条件一致的', g.group\_store\_count, '个油站众数为:', g.mode\_parking), 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_parking\_covered = 0 AND b.is\_small\_brand = 0 AND g.mode\_parking IS NOT NULL AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '停车场可用' ); -- L3: 24小时营业（同源推断，补充L2未覆盖的） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '24小时营业', 'open\_24h\_value', b.open\_24h\_value, b.tag\_open\_24h\_covered, 3, '同源推断', g.mode\_open\_24h, '高', JSON\_OBJECT( 'level', 3, 'method', '同源推断', 'match\_conditions', JSON\_OBJECT( 'brand\_name', b.brand\_name, 'brand\_level', b.brand\_level, 'pop\_id', b.pop\_id ), 'reference\_store\_count', g.group\_store\_count, 'reference\_store\_ids', g.group\_store\_ids, 'reference\_value', g.mode\_open\_24h, 'logic', CONCAT('三条件一致的', g.group\_store\_count, '个油站众数为:', g.mode\_open\_24h), 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_open\_24h\_covered = 0 AND b.is\_small\_brand = 0 AND g.mode\_open\_24h IS NOT NULL -- 排除已在L2处理的 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '24小时营业' ); -- L3: 营业时间（同源推断，补充L2未覆盖的） INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '营业时间', 'open\_hours\_value', b.open\_hours\_value, b.tag\_open\_hours\_covered, 3, '同源推断', g.mode\_open\_hours, '高', JSON\_OBJECT( 'level', 3, 'method', '同源推断', 'match\_conditions', JSON\_OBJECT( 'brand\_name', b.brand\_name, 'brand\_level', b.brand\_level, 'pop\_id', b.pop\_id ), 'reference\_store\_count', g.group\_store\_count, 'reference\_store\_ids', g.group\_store\_ids, 'reference\_value', g.mode\_open\_hours, 'logic', CONCAT('三条件一致的', g.group\_store\_count, '个油站众数为:', g.mode\_open\_hours), 'confidence', '高', 'timestamp', NOW() ), '待校验' FROM tmp\_infer\_base b INNER JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_open\_hours\_covered = 0 AND b.is\_small\_brand = 0 AND g.mode\_open\_hours IS NOT NULL AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '营业时间' ); -- ================================================================ -- 3.4 第4层（L4）：无法推断 - 人工核验 -- ================================================================ -- L4: 不可推断标签（品牌、竞争、洗车、SME）- 未覆盖的 INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) -- 品牌名称 SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '品牌名称', 'brand\_name\_value', brand\_name\_value, tag\_brand\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', 'NOT\_INFERRABLE\_TAG', 'reason\_desc', '品牌名称为不可推断标签，必须来自源数据或人工填写', 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base WHERE tag\_brand\_covered = 0 UNION ALL -- 竞争重叠 SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '竞争重叠', 'competitive\_overlap\_value', competitive\_overlap\_value, tag\_competitive\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', 'NOT\_INFERRABLE\_TAG', 'reason\_desc', '竞争重叠为不可推断标签，必须实地调研', 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base WHERE tag\_competitive\_covered = 0 UNION ALL -- SME供应商 SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, 'SME供应商', 'sme\_supplier\_value', sme\_supplier\_value, tag\_sme\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', 'NOT\_INFERRABLE\_TAG', 'reason\_desc', 'SME供应商为不可推断标签', 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base WHERE tag\_sme\_covered = 0 UNION ALL -- 洗车服务可用 SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '洗车服务可用', 'carwash\_available\_value', carwash\_available\_value, tag\_carwash\_available\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', 'NOT\_INFERRABLE\_TAG', 'reason\_desc', '洗车服务可用为不可推断标签', 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base WHERE tag\_carwash\_available\_covered = 0 UNION ALL -- 洗车服务类型 SELECT CURRENT\_DATE(), store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, '洗车服务类型', 'carwash\_type\_value', carwash\_type\_value, tag\_carwash\_type\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', 'NOT\_INFERRABLE\_TAG', 'reason\_desc', '洗车服务类型为不可推断标签', 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base WHERE tag\_carwash\_type\_covered = 0; -- L4: 可推断标签但无法推断的情况 INSERT INTO station\_tag\_inference\_result ( dt, store\_id, store\_name, province, province\_name, city\_name, is\_key\_store, pop\_id, brand\_name, brand\_level, is\_small\_brand, tag\_name, tag\_field\_name, current\_value, current\_covered, process\_level, process\_method, inferred\_value, confidence\_level, inference\_detail, verify\_status ) -- 便利店（未被L3推断的） SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '便利店可用', 'convenience\_store\_value', b.convenience\_store\_value, b.tag\_convenience\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', CASE WHEN b.is\_small\_brand = 1 THEN 'SMALL\_BRAND' WHEN g.pop\_id IS NULL THEN 'NO\_MATCH\_GROUP' WHEN g.mode\_convenience IS NULL THEN 'REF\_NO\_VALUE' ELSE 'UNKNOWN' END, 'reason\_desc', CASE WHEN b.is\_small\_brand = 1 THEN '小散品牌，不参与推断' WHEN g.pop\_id IS NULL THEN '无三条件一致的参照组' WHEN g.mode\_convenience IS NULL THEN '参照组便利店标签均无有效值' ELSE '未知原因' END, 'match\_conditions', CASE WHEN g.pop\_id IS NOT NULL THEN JSON\_OBJECT( 'brand\_name', b.brand\_name, 'brand\_level', b.brand\_level, 'pop\_id', b.pop\_id ) ELSE NULL END, 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base b LEFT JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_convenience\_covered = 0 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '便利店可用' ) UNION ALL -- 卫生间（未被L3推断的） SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '卫生间可用', 'restroom\_value', b.restroom\_value, b.tag\_restroom\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', CASE WHEN b.is\_small\_brand = 1 THEN 'SMALL\_BRAND' WHEN g.pop\_id IS NULL THEN 'NO\_MATCH\_GROUP' WHEN g.mode\_restroom IS NULL THEN 'REF\_NO\_VALUE' ELSE 'UNKNOWN' END, 'reason\_desc', CASE WHEN b.is\_small\_brand = 1 THEN '小散品牌，不参与推断' WHEN g.pop\_id IS NULL THEN '无三条件一致的参照组' WHEN g.mode\_restroom IS NULL THEN '参照组卫生间标签均无有效值' ELSE '未知原因' END, 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base b LEFT JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_restroom\_covered = 0 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '卫生间可用' ) UNION ALL -- 停车场（未被L3推断的） SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '停车场可用', 'parking\_value', b.parking\_value, b.tag\_parking\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', CASE WHEN b.is\_small\_brand = 1 THEN 'SMALL\_BRAND' WHEN g.pop\_id IS NULL THEN 'NO\_MATCH\_GROUP' WHEN g.mode\_parking IS NULL THEN 'REF\_NO\_VALUE' ELSE 'UNKNOWN' END, 'reason\_desc', CASE WHEN b.is\_small\_brand = 1 THEN '小散品牌，不参与推断' WHEN g.pop\_id IS NULL THEN '无三条件一致的参照组' WHEN g.mode\_parking IS NULL THEN '参照组停车场标签均无有效值' ELSE '未知原因' END, 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base b LEFT JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_parking\_covered = 0 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '停车场可用' ) UNION ALL -- 24小时营业（未被L2/L3推断的） SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '24小时营业', 'open\_24h\_value', b.open\_24h\_value, b.tag\_open\_24h\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', CASE WHEN b.is\_small\_brand = 1 THEN 'SMALL\_BRAND' WHEN b.is\_zxgj IS NULL OR b.is\_zxgj = '' THEN 'NO\_ZXGJ\_DATA' WHEN g.pop\_id IS NULL THEN 'NO\_MATCH\_GROUP' WHEN g.mode\_open\_24h IS NULL THEN 'REF\_NO\_VALUE' ELSE 'UNKNOWN' END, 'reason\_desc', CASE WHEN b.is\_small\_brand = 1 THEN '小散品牌，不参与推断' WHEN b.is\_zxgj IS NULL OR b.is\_zxgj = '' THEN '无is\_zxgj数据，无法精细计算' WHEN g.pop\_id IS NULL THEN '无三条件一致的参照组' WHEN g.mode\_open\_24h IS NULL THEN '参照组24h标签均无有效值' ELSE '未知原因' END, 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base b LEFT JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_open\_24h\_covered = 0 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '24小时营业' ) UNION ALL -- 营业时间（未被L2/L3推断的） SELECT CURRENT\_DATE(), b.store\_id, b.store\_name, b.province, b.province\_name, b.city\_name, b.is\_key\_store, b.pop\_id, b.brand\_name, b.brand\_level, b.is\_small\_brand, '营业时间', 'open\_hours\_value', b.open\_hours\_value, b.tag\_open\_hours\_covered, 4, '无法推断', NULL, NULL, JSON\_OBJECT( 'level', 4, 'method', '无法推断', 'reason\_code', CASE WHEN b.is\_small\_brand = 1 THEN 'SMALL\_BRAND' WHEN b.is\_zxgj IS NULL OR b.is\_zxgj = '' THEN 'NO\_ZXGJ\_DATA' WHEN g.pop\_id IS NULL THEN 'NO\_MATCH\_GROUP' WHEN g.mode\_open\_hours IS NULL THEN 'REF\_NO\_VALUE' ELSE 'UNKNOWN' END, 'reason\_desc', CASE WHEN b.is\_small\_brand = 1 THEN '小散品牌，不参与推断' WHEN b.is\_zxgj IS NULL OR b.is\_zxgj = '' THEN '无is\_zxgj数据，无法精细计算' WHEN g.pop\_id IS NULL THEN '无三条件一致的参照组' WHEN g.mode\_open\_hours IS NULL THEN '参照组营业时间标签均无有效值' ELSE '未知原因' END, 'action', '人工核验', 'timestamp', NOW() ), '待人工核验' FROM tmp\_infer\_base b LEFT JOIN tmp\_match\_groups g ON b.brand\_name = g.brand\_name AND b.brand\_level = g.brand\_level AND b.pop\_id = g.pop\_id WHERE b.tag\_open\_hours\_covered = 0 AND NOT EXISTS ( SELECT 1 FROM station\_tag\_inference\_result r WHERE r.dt = CURRENT\_DATE() AND r.store\_id = b.store\_id AND r.tag\_name = '营业时间' ); -- ================================================================ -- 第四部分：漏斗统计分析 -- ================================================================ -- 4.1 漏斗各层汇总统计 SELECT '漏斗各层汇总统计' AS 分析项; SELECT process\_level AS 处理层级, process\_method AS 处理方式, COUNT(\*) AS 记录数, COUNT(DISTINCT store\_id) AS 涉及油站数, COUNT(DISTINCT tag\_name) AS 涉及标签数, ROUND(COUNT(\*) / SUM(COUNT(\*)) OVER () \* 100, 2) AS 占比 FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE() GROUP BY process\_level, process\_method ORDER BY process\_level; -- 4.2 按标签分层统计 SELECT '按标签分层统计' AS 分析项; SELECT tag\_name AS 标签名称, SUM(IF(process\_level = 1, 1, 0)) AS L1\_原始值, SUM(IF(process\_level = 2, 1, 0)) AS L2\_精细计算, SUM(IF(process\_level = 3, 1, 0)) AS L3\_同源推断, SUM(IF(process\_level = 4, 1, 0)) AS L4\_无法推断, COUNT(\*) AS 合计, ROUND(SUM(IF(process\_level IN (1,2,3), 1, 0)) / COUNT(\*) \* 100, 2) AS 可覆盖率 FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE() GROUP BY tag\_name ORDER BY 可覆盖率 DESC; -- 4.3 L4无法推断原因分析 SELECT 'L4无法推断原因分析' AS 分析项; SELECT tag\_name AS 标签, JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.reason\_code')) AS 原因代码, JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.reason\_desc')) AS 原因说明, COUNT(\*) AS 数量, COUNT(DISTINCT store\_id) AS 涉及油站数 FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE() AND process\_level = 4 GROUP BY tag\_name, JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.reason\_code')), JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.reason\_desc')) ORDER BY 数量 DESC; -- 4.4 推断效果预估 SELECT '推断效果预估' AS 分析项; SELECT '推断前' AS 状态, COUNT(DISTINCT store\_id) AS 油站数, SUM(IF(process\_level = 1, 1, 0)) AS 已覆盖标签数, ROUND(SUM(IF(process\_level = 1, 1, 0)) / COUNT(\*) \* 100, 2) AS 覆盖率 FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE() UNION ALL SELECT '推断后预估', COUNT(DISTINCT store\_id), SUM(IF(process\_level IN (1, 2, 3), 1, 0)), ROUND(SUM(IF(process\_level IN (1, 2, 3), 1, 0)) / COUNT(\*) \* 100, 2) FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE(); -- ================================================================ -- 第五部分：导出清单 -- ================================================================ -- 5.1 可推断清单（L2+L3，待区域校验） SELECT '可推断清单（待区域校验）' AS 导出项; SELECT store\_id AS 油站ID, store\_name AS 油站名称, province AS 省区, city\_name AS 城市, is\_key\_store AS 是否重点站, tag\_name AS 标签名称, current\_value AS 当前值, inferred\_value AS 推荐值, process\_level AS 处理层级, process\_method AS 处理方式, confidence\_level AS 置信度, JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.logic')) AS 推断逻辑, verify\_status AS 校验状态 FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE() AND process\_level IN (2, 3) ORDER BY province, is\_key\_store DESC, store\_id, tag\_name; -- 5.2 人工核验清单（L4） SELECT '人工核验清单' AS 导出项; SELECT store\_id AS 油站ID, store\_name AS 油站名称, province AS 省区, city\_name AS 城市, is\_key\_store AS 是否重点站, tag\_name AS 标签名称, current\_value AS 当前值, JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.reason\_code')) AS 无法推断原因, JSON\_UNQUOTE(JSON\_EXTRACT(inference\_detail, '$.reason\_desc')) AS 原因说明, brand\_name AS 品牌, brand\_level AS 品牌等级, pop\_id, is\_small\_brand AS 是否小散品牌 FROM station\_tag\_inference\_result WHERE dt = CURRENT\_DATE() AND process\_level = 4 ORDER BY province, is\_key\_store DESC, store\_id, tag\_name; -- ================================================================ -- 第六部分：清理临时表 -- ================================================================ -- DROP TABLE IF EXISTS tmp\_infer\_base; -- DROP TABLE IF EXISTS tmp\_zxgj\_flags; -- DROP TABLE IF EXISTS tmp\_match\_groups;\]帮我解读一下这个 SQL 查询的逻辑,用人类可理解的语言表达;

20251204\_2100  
标签覆盖率多层漏斗推断SQL整体逻辑解读  
tags:: #标签覆盖 #多层漏斗 #推断系统 #油站画像

---

**一句话结论：**  
这整段 SQL 干的事，就是围绕“油站 10 个标签的覆盖率”，搭了一套「L1 原始值 → L2 精细计算 → L3 同源推断 → L4 人工核验」的多层漏斗系统，把每一个站、每一个标签的来龙去脉和推断理由，都结构化沉淀进一张结果表里，再配好统计分析和导出清单。

---

## 一、现状与问题：为“标签覆盖率提升”建一套可追溯的推断工厂

先说这段 SQL 想解决什么问题：

1. **核心业务问题**
	- 油站有 10 个关键标签（品牌、竞争、SME、洗车、便利店、卫生间、停车场、24 小时、营业时间等），现在有一部分是已经有真实值的，一部分缺失。
	- 你不满足于只看“有没有值”，而是要：
		- 尽可能用规则和同类站信息把缺失的标签“推出来”；
		- 同时要 **记录清楚每一次推断是怎么来的** ，方便后续区域核验、人工修正。
2. **为这个目的建了两张“结果仓”表**
	- `station_tag_inference_result` ：
		- 按天分区（字段 `dt` ），每天跑一次推断，把当天所有「油站 × 标签」的状态写进来。
		- 每条记录对应“某站的某个标签在今天的处理结果”，包括：
			- 当前值是否已覆盖
			- 在哪一层（L1/L2/L3/L4）被处理
			- 推断出的新值（若有）
			- 置信度
			- 最重要： `inference_detail` JSON，记录完整推断逻辑和理由
			- 校验状态 + 人工校验信息（谁什么时候确认/修正）
	- `station_tag_inference_confirmed` ：
		- 存“终局的确认结果”（无分区，结构简单）：
			- 有 `inference_id` 回指推断结果表
			- 有 `confirm_type` （自动通过 / 人工确认 / 人工修正）
			- `is_synced` 标记是否同步回主画像表
		- 理解为“运营+系统校验完之后的最终商户画像标签表（确认层）”。
3. **为推断做的数据准备：三个临时表就是你的“原材料工厂”**
	- `tmp_infer_base` ：推断基础盘子
		- 从 `station_operation_detail_daily` 拿到：
			- 油站基础信息（省市、是否重点站、最近 30 天订单等）
			- 10 个标签的“是否覆盖”标记 + 当前值（ `tag_xxx_covered` / `xxx_value` ）
		- 从 `merchant_profile_analysis` 拿到最近一天的：
			- `pop_id` 、 `brand_name` 、 `brand_level` 、 `is_zxgj` （营业时间编码）
		- 额外衍生：
			- `is_small_brand` ：品牌是 “其他/未知/空” 则视为小散，不参与同源推断
			- 把 `is_zxgj` 这种 `"1-23"` 的字符串拆成 `zxgj_start_hour` 、 `zxgj_end_hour`
		- 给 `store_id` 做主键，并建索引（pop\_id、brand、brand\_level、三条件组合），方便后面 JOIN。
	- `tmp_zxgj_flags` ：专门服务“营业时间/24 小时”的精细计算
		- 基于 `is_zxgj` 解析出：
			- 是否凌晨营业（起始 < 6）
			- 是否深夜营业（结束 >= 22）
			- 是否满足“24 小时营业”（起始 < 6 且 结束 >= 22）
			- 推导出的营业时间字符串 `inferred_open_hours` ：
				- 如果是 24 小时 ⇒ `00:00-24:00`
				- 否则： `起始:00-结束+1:00` 这样的区间字符串
		- 以 `store_id` 为主键，用于后面 L2 精细计算。
	- `tmp_match_groups` ：三条件一致的“同源参照组”
		- 以 `(brand_name, brand_level, pop_id)` 三个字段作为“同源条件”：
			- 只有同一品牌 + 同一品牌等级 + 同一 POP ID 的油站才算一组
			- 每组至少要有 2 个不同油站才能用于推断
		- 对组内已覆盖的站，分别算出这些标签的“众数”（mode）：
			- 便利店、卫生间、停车场、24 小时营业、营业时间
			- 前提：该标签已覆盖，且值不为空/“未知”
		- 额外记录 `group_store_count` 和 `group_store_ids` ，方便追溯和给运营解释“这不是我瞎猜，是多站一致的结果”。

这一块基本是： **把数据清洗齐，把可以支撑推断的“参照体系”和“规则输入”都准备好** 。

---

## 二、策略选择与推演：L1–L4 多层漏斗是怎么一层层走的

核心逻辑是你在注释里写的那句： **“先精算，再推断”** 。整套推断就是一个 4 层漏斗：

### 1\. L1：原始值（process\_level = 1）

- 目标：
	- 把所有“已经有真实数据”的油站标签，完整搬到结果表里，视为“已覆盖”，不做任何改动。
- 做法：
	- 对 10 个标签分别执行 INSERT：
		- 条件是对应的 `tag_xxx_covered = 1`
		- `process_level = 1` ， `process_method = '原始值'`
		- `inferred_value` 就等于原始值
		- `confidence_level = '确定'`
		- `verify_status = '已覆盖'`
		- `inference_detail` 写清：
			- `level:1` 、 `method:'原始值'` 、 `source:'源数据'` 、 `current_value` 、 `timestamp`
- 含义：
	- L1 是“地基”，给后面的统计提供“推断前”的基线。
	- 任何一个标签，只要 L1 已经有值，后面 L2/L3 不会再重复插入（L3 和 L4 都有 NOT EXISTS 限制）。

### 2\. L2：精细计算（process\_level = 2）

- 目标：
	- 利用 `is_zxgj` 编码，把「24 小时营业」与「营业时间」这两个标签，从结构化时间段精算出来。
- 逻辑：
	- 对于 `24小时营业` ：
		- 条件：该站 `tag_open_24h_covered = 0` （原始没填），且在 `tmp_zxgj_flags` 中有记录。
		- 如果 `is_24h = 1` ⇒ 推断值 = “是”；否则 = “否”。
		- 置信度设为“高”。
		- `inference_detail` 里：
			- 原始 `is_zxgj` 值
			- 解析后的起止小时
			- 是否凌晨/深夜/24 小时
			- 一段中文逻辑解释，如“凌晨营业(起始<6)+深夜营业(结束>=22)→24小时营业”。
	- 对于 `营业时间` ：
		- 条件： `tag_open_hours_covered = 0` 且 `inferred_open_hours` 不为 NULL
		- 直接用 `tmp_zxgj_flags.inferred_open_hours` 作为推断值
		- 同样给“高”置信度，并把计算逻辑写进 JSON。
- 含义：
	- L2 是“规则精算层”，用结构化字段做函数计算，输出确定性很强的标签。
	- 这层走的是“数据逻辑严格可解释”的路线，适合直接给区域看“逻辑链路”。

### 3\. L3：同源推断（process\_level = 3）

- 目标：
	- 对“可以通过同类油站推出来”的标签，用“品牌+品牌等级+POP 三条件一致”的参照组众数来做推断。
- 逻辑通用模板：
	- 以某个标签为例（比如“便利店可用”）：
		- 条件：
			- 该站标签未覆盖（ `tag_convenience_covered = 0` ）
			- 不是小散品牌（ `is_small_brand = 0` ）
			- 在 `tmp_match_groups` 中能找到对应组，且该组该标签的众数 `mode_convenience` 非空
			- 同时，结果表里还没有这个站+标签（NOT EXISTS，避免和 L2/L1 冲突）
		- 处理：
			- 推断值 = 该组的众数
			- `process_level = 3` ， `process_method = '同源推断'`
			- `confidence_level = '高'`
			- `inference_detail` ：
				- 记录匹配条件（品牌、品牌等级、POP ID）
				- 参照组油站数量和 ID 列表
				- 众数值
				- 一段中文描述：“三条件一致的 X 个油站众数为 Y”。
- 对象标签：
	- 便利店可用
	- 卫生间可用
	- 停车场可用
	- 24 小时营业（在没有被 L2 精算出的情况下，用同源补位）
	- 营业时间（同样作为 L2 的补充方案）
- 含义：
	- L3 是“同源推断层”，利用“同品牌+同等级+同 POP”来做 group-level 的共性补全。
	- 这就把“局部结构化信息不足”的问题，变成“用同类样本的统计众数来推”，属于典型商户画像里的 **群体推断** 。

### 4\. L4：无法推断 + 人工核验（process\_level = 4）

L4 分两类场景：

1. **本质上不可推断的标签**
	- 包括：品牌名称、竞争重叠、SME 供应商、洗车服务可用、洗车服务类型。
	- 条件：对应标签未覆盖。
	- 直接写入结果表：
		- `process_level = 4` ， `process_method = '无法推断'`
		- `inferred_value = NULL`
		- `reason_code = 'NOT_INFERRABLE_TAG'`
		- `reason_desc` 说明“必须来自源数据/实地调研/人工填写”
		- `verify_status = '待人工核验'`
	- 含义： **不给运营错觉** ——这些字段不能靠规则瞎推，只能人工。
2. **理论上可推断，但当前数据不足以推断的标签**
	- 范围：便利店、卫生间、停车场、24 小时营业、营业时间。
	- 条件：
		- 标签仍未覆盖
		- 同时也不在 L2/L3 结果中（NOT EXISTS）
	- 具体分原因打标：
		- 若 `is_small_brand = 1` ⇒ 原因：小散品牌，不参与推断
		- 若同源组不存在 ⇒ 原因： `NO_MATCH_GROUP` ，“无三条件一致的参照组”
		- 若同源组存在但该标签众数为 NULL ⇒ 原因： `REF_NO_VALUE` ，“参照组该标签均无有效值”
		- 对 24 小时/营业时间，还多一个：没有 `is_zxgj` ⇒ `NO_ZXGJ_DATA` ，“无 is\_zxgj 数据，无法精细计算”
		- 其它情况 ⇒ `UNKNOWN`
	- 结果：
		- 全部 `process_level = 4` 、 `method = '无法推断'` 、 `action = '人工核验'` 、 `verify_status = '待人工核验'` 。
- 总结：
	- L4 把所有“机器搞不定”的情况，按照明确的 **原因代码 + 原因说明** 归类，为后面运营制定“采集/整改动作”提供依据。
	- 同时保证： **每个站 × 每个标签当天一定会有一条记录** ，不是要么有，要么消失。

---

## 三、落地与风险：统计、导出、运营闭环怎么接上

这套 SQL 不是只为了“推断完就完了”，后面还有一轮“量化 & 导出”，把结果给运营/老板看。

### 1\. 漏斗统计分析（第四部分）

你设计了 3 类统计 + 1 个效果预估：

1. **4.1 漏斗各层汇总统计**
	- 维度： `process_level` + `process_method`
	- 指标：记录数、涉及油站数、涉及标签数、占比
	- 用窗口函数算出各层级占整体的百分比。
	- 用途：让老板一眼看到“有多少标签靠原始值、多少靠精算、多少靠同源、多少彻底推不出来”。
2. **4.2 按标签分层统计**
	- 维度： `tag_name`
	- 指标：
		- 各层级数量（L1/L2/L3/L4）
		- 总数
		- 可覆盖率 = (L1+L2+L3)/总数
	- 用途：
		- 哪些标签天然好补（比如便利店、停车场），哪些很难补（比如某些高度依赖线下勘察的标签）。
		- 可以直接挂到“标签覆盖率提升”项目的周报/看板里。
3. **4.3 L4 无法推断原因分析**
	- 针对 `process_level = 4` 的记录，按标签 + reason\_code + reason\_desc 聚合：
		- 看“因为小散品牌导致无法推断的有多少站/标签”
		- 看“缺 is\_zxgj 的站有多少”
		- 看“找不到同源组的占比多少”
	- 用途：
		- 直接指导“下一步数据治理/采集优先级”。
4. **4.4 推断效果预估**
	- 分两行对比：
		- “推断前”：只看 L1（原始值）的覆盖情况
		- “推断后预估”：看 L1+L2+L3 的覆盖情况
	- 指标：
		- 油站数
		- 已覆盖标签数
		- 覆盖率（已覆盖标签数 / 总标签数）
	- 用途：
		- 直接给出一个“自动推断整体帮我们多补了多少标签”的量化结果，非常适合往 OKR 里写。

### 2\. 导出清单（第五部分）：给运营的“作战名单”

你把结果拆成两类清单，方便区域/运营团队动作：

1. **可推断清单（L2+L3，待区域校验）**
	- 范围： `process_level IN (2,3)`
	- 字段：
		- 站信息：ID、名称、省区、城市、是否重点站
		- 标签信息：名称、当前值、推荐值、处理层级、处理方式、置信度
		- 推断逻辑：从 JSON 里把 `$.logic` 抽出来，给运营一句话解释
		- 当前校验状态
	- 排序：省区 → 是否重点站（优先看重点站） → 站 → 标签
	- 用途：
		- 给区域经理一份列表，告诉他“这些是系统给你的推荐值，请核对+批量确认/修正”。
2. **人工核验清单（L4）**
	- 范围： `process_level = 4`
	- 字段：
		- 站信息：同上
		- 标签名称、当前值（一般是空或无效）
		- 无法推断原因代码 + 说明
		- 品牌、品牌等级、POP、是否小散
	- 排序：同上
	- 用途：
		- 这是运营真正要“下场采集/走访”的名单，优先可以盯重点站 +数量最多的原因类型。

### 3\. 风险与前瞻建议（技术 + 业务）

从这个 SQL 的实现看，有几个值得提前注意的点：

1. **分区表维护**
	- `station_tag_inference_result` 只预建到了 `p202506` + `pmax` ，后面如果 dt 持续往 2025 下半年跑，按你们 DBA 策略要提前规划扩分区，不然会落到 `pmax` ，影响管理和压缩。
2. **数据量与性能**
	- 你在 `tmp_match_groups` 里把 `group_concat_max_len` 提高到了 1000000，用于记录参照站 ID 列表，这在油站量不特别大的前提下 OK，但：
		- 如果将来规模很大，这个字段会膨胀，查询时要谨慎使用。
		- 真正要做线上查询时，可以考虑只展示前 N 个参照站，完整列表存在日志/离线表。
3. **规则的灰度和回溯**
	- 现在所有逻辑写死在 SQL 里，优点是清晰；但将来如果要迭代规则（比如 24 小时的判定标准变了），要做好：
		- 版本管理（在 `inference_detail` 里加一个 `rule_version` ）
		- 按版本回溯（知道某次推断是基于 V1 还是 V2）
4. **人工闭环怎么写回主画像表**
	- 你已经设计了 `station_tag_inference_confirmed` 和 `is_synced` 字段，但是脚本里还没写“从确认表同步到主表”的 SQL。
	- 后续需要增加一段：
		- 从确认表把最新确认值更新回主画像（比如 `station_operation_detail_daily` 或专门的标签主表），
		- 同时在 `inference_result` 标记这些记录已被确认。

---

## 思维导图结构（可直接用来画脑图）

- 标签覆盖率多层漏斗推断系统
	- 一、目标与定位
		- 提升油站 10 个标签覆盖率
		- 形成可追溯、可核验的推断闭环
	- 二、数据准备层
		- `tmp_infer_base`
			- 站点基础信息
			- 10 个标签覆盖标志与原值
			- 品牌、POP、品牌等级
			- `is_zxgj` 及拆解
			- 小散品牌标记
		- `tmp_zxgj_flags`
			- 凌晨营业 / 深夜营业标记
			- 24 小时营业判断
			- 推导营业时间字符串
		- `tmp_match_groups`
			- 三条件一致参照组（品牌+等级+POP）
			- 组内油站数量与 ID
			- 便利店/卫生间/停车场/24h/营业时间众数
	- 三、多层漏斗推断
		- L1 原始值
			- 条件：标签已覆盖
			- 行为：直接入库，标记“已覆盖”
		- L2 精细计算
			- 基于 `is_zxgj` 推断 24h 与营业时间
			- 输出推断值 + 高置信度 + 详细逻辑
		- L3 同源推断
			- 依据：三条件一致参照组
			- 对便利店/卫生间/停车场/24h/营业时间做众数推断
			- 排除小散品牌与已处理记录
		- L4 无法推断
			- 不可推断标签：品牌、竞争、SME、洗车
			- 可推断但缺数据的标签：便利店、卫生间、停车场、24h、营业时间
			- 输出原因代码 + 人工核验动作
	- 四、统计与导出
		- 漏斗层级汇总
		- 按标签分层统计与覆盖率
		- L4 无法推断原因分析
		- 推断前后覆盖率对比
		- 导出清单
			- L2+L3 可推断清单（待区域校验）
			- L4 人工核验清单
	- 五、风险与演进
		- 分区维护
		- 性能与字段膨胀
		- 规则版本化与回溯
		- 人工确认写回主画像表

---

## 《迭代日志》

- 【来源】
	- 基于你提供的完整 SQL 脚本（建表 + 三个临时表 + L1–L4 漏斗 + 统计分析 + 导出清单），未额外引入其他资料。
- 【结论】
	- 这段 SQL 已经搭起了一个结构完整、可追溯的“标签覆盖率提升多层漏斗系统”，从入参数据准备、规则推断、同源补全，到人工核验、效果评估、清单输出，逻辑闭环是完整的，可以直接拿去跟老板讲“我们怎么从 1→N 提升画像标签覆盖”。
- 【改动点】
	- 本轮我做的是 **逻辑解构和人话翻译** ：
		- 把每个临时表的角色、每一层漏斗的意图都拆开说明；
		- 明确 L1–L4 各自的边界和触发条件；
		- 补充了在项目推进视角下的风险点和演进建议（分区、规则版本、人工闭环写回等）。
- 【待补充】
	- 暂未看到：
		- 与“主画像表”的最终同步逻辑（如何把确认结果写回）
		- 你们现在真实的“标签覆盖率”基线数据（比如每个标签目前 L1 覆盖率是多少）
		- 区域侧预期的“校验动作”（是看 Excel、看看板，还是在系统里点确认）
- 【下一步建议】
	1. 如果你下一步要跟老板/评审沟通这个方案：
		- 我们可以基于这套解读，缩成一份“一页纸方案”，重点讲三件事：
			- 现状：L1 覆盖率多少
			- 方案：L1–L4 漏斗 + 三条件同源推断
			- 效果：推断后预估覆盖率 & 区域需要做的动作。
	2. 如果你要把它真正接入商户画像项目：
		- 可以再一起拆一下：
			- 和你现有标签体系的字段映射（业务命名 vs 技术字段）
			- 与商户分群/精细化运营的后续联动（比如“24 小时+便利店+停车场”的高服务能力站怎么用）。
	3. 若你希望对 SQL 本身做“加固”（性能、可配置化、异常兜底），可以下一轮直接告诉我：
		- 当前数据量级、执行频率（每天/每周）
		- 有无线上实时查询需求
		- 我们可以再做一版“工程化改造清单”。

如果你愿意，下一步我可以帮你把这套逻辑直接浓缩成一页纸对老板的汇报稿，或者整理成“标签推断规则说明文档 V1”。

20251204\_2130  
标签目标值证据表\_建表与导入工具  
tags:: #标签体系 #标签落地 #数据导入 #商户画像

---

**一句话结论：**  
这张新表可以作为「油站 × 标签」的目标值 + 证据总表，用 `(store_id, as_of_date, tag_code, source)` 做幂等主键，并配套一个命令行 Python 导入工具，从你指定的表格路径把数据自动入库、支持重复导入覆盖更新。

---

## 一、现状与问题：需要一张「目标值+证据」标准落地表

1. 你现在多了一个更贴近业务语义的记录：  
	`store_id + as_of_date + tag_code + target_value_xxx + source + evidence_state + ttl_days + reason + conf + upload_batch_id + enum_code` 。  
	这张表的角色，本质上是「业务认可的目标值 + 证据链」，既要支撑画像对外展示，也要支撑你之前那套推断/核验体系做对比和校准。
2. 字段维度已经覆盖了三个关键视角：
	- 值形态：bool / 数值 / 文本 + enum\_code（和 tag\_enum 对齐）；
	- 证据与来源：source、evidence\_state、reason、closest\_source、upload\_batch\_id；
	- 生命周期：ttl\_days、conf，用来管控有效期和置信度。
3. 现在缺的就是两件事：
	- 一个规范的建表语句（含主键/索引设计，方便和现有画像/推断表 JOIN）；
	- 一个可循环使用的导入工具，让你手动指定文件路径就能把 Excel/CSV 导进去，并且支持幂等更新。

---

## 二、策略选择与推演：表结构以「多来源幂等 + 与标签规范对齐」为主

1. 表结构上，我建议：
	- 保留自增 `id` 作为技术主键，方便后续扩展；
	- 用 `(store_id, as_of_date, tag_code, source)` 做唯一键，天然支持：同一个站、同一天、同一个标签，可以有多来源（s1/s2/region），但同一来源只能有一条记录，可被后续导入覆盖（ON DUPLICATE KEY UPDATE）。
2. 字段类型上：
	- `store_id` 用 `BIGINT` ，兼容你现在的油站 ID；
	- `as_of_date` 用 `DATE` ，导入时把 `2025/7/24` 统一转成 `2025-07-24` ；
	- `target_value_number` 用 `DECIMAL(18,4)` ，够用且兼容金额/比例；
	- `target_value_string/target_value_string_back` 用 `VARCHAR(512)` ，避免 TEXT 带来的一些索引问题；
	- `enum_code` 对齐 `/mnt/data/tag_enum.csv` 里的 `enum_code` ，用 `VARCHAR(128)` 足够。
3. 关联关系上：
	- 与标签规范：
		- `tag_code` ↔ `tag_spec.tag_code` / `tag_catalog.tag_code` （管理层面是强关系，DB 可以先不强制外键）；
		- `enum_code` ↔ `tag_enum.enum_code` （语义上是一致的枚举值）。
	- 与之前的推断结果表（比如 `station_tag_inference_result` ）：
		- 用 `store_id` + `as_of_date` （或 `dt` ）+ `tag_code` （或 `tag_name` 标准化后）JOIN，
		- 这张新表可以作为“人工/外部数据修正后的目标值”，用于对比机器推断的 `inferred_value` ，决定是否同步覆盖。

---

## 三、落地与风险：导入工具走「命令行 + 幂等 upsert」路线

1. 导入工具设计：
	- 使用 Python + `pymysql` ，只要你输入文件路径（CSV 为主，Excel 可扩展），就能逐行导入；
	- 假设表头和字段名一致（ `store_id, as_of_date, tag_code, ... enum_code` ），减少中间 mapping 的复杂性；
	- 采用 `INSERT ... ON DUPLICATE KEY UPDATE` ，保证重复导入是更新而不是报错。
2. 风险点提前说清楚：
	- 日期格式：表格里是 `2025/7/24` ，需要在导入时统一转为 `DATE` ；
	- 布尔型： `target_value_bool` 需要把 `1/0/true/false/是/否` 等做统一映射；
	- 空值处理：空字符串要转成 `NULL` ，避免影响聚合统计；
	- 大批量导入时要注意批次大小（比如每 1000 行提交一次），防止事务过大。
3. 与画像体系的后续衔接：
	- 后续你可以用这张表作为「人工/外源标签」的主表，和推断结果做对比分析：
		- 看某标签在不同来源下的一致性；
		- 看机器推断与人工目标值的偏差（模型评估）。

---

## 3.1 建表 SQL（MySQL，无 WITH，带注释）

表名先建议为： `station_tag_target_value` ，你可以按自己实际命名调整。

```sql
sqlCREATE TABLE IF NOT EXISTS station_tag_target_value (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',

    store_id BIGINT NOT NULL COMMENT '油站ID',
    as_of_date DATE NOT NULL COMMENT '业务日期（标签生效日期）',
    tag_code VARCHAR(64) NOT NULL COMMENT '标签编码（英文名，对齐tag_spec.tag_code）',

    target_value_bool TINYINT(1) NULL COMMENT '标签值-布尔形态（0/1）',
    target_value_number DECIMAL(18,4) NULL COMMENT '标签值-数值形态',
    target_value_string VARCHAR(512) NULL COMMENT '标签值-文本形态',
    enum_code VARCHAR(128) NULL COMMENT '标签枚举值编码（对齐tag_enum.enum_code）',

    source VARCHAR(64) NOT NULL COMMENT '数据来源标识（如s1/s2/region等）',
    evidence_state VARCHAR(64) NOT NULL COMMENT '证据状态（如FOUND_IN_RAW/INFERRED/CONFIRMED等）',
    ttl_days INT NULL COMMENT '当前剩余有效期（天）',
    reason VARCHAR(512) NULL COMMENT '修正/生成原因（如region_full_0919等）',
    conf DECIMAL(5,4) NULL COMMENT '置信度，0-1之间，示例：1.0000',

    upload_batch_id VARCHAR(128) NULL COMMENT '数据源批次ID（如outputs_real_prod_20250923_093500_v1.8）',
    closest_source VARCHAR(64) NULL COMMENT '最近似参考来源（如s1/s2/region等）',
    target_value_string_back VARCHAR(512) NULL COMMENT '标签值-文本形态备份（修正前或原始值）',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (id),

    -- 业务唯一性：同一油站 + 业务日期 + 标签 + 来源 只保留一条，便于幂等导入
    UNIQUE KEY uk_store_date_tag_source (store_id, as_of_date, tag_code, source),

    KEY idx_as_of_date (as_of_date),
    KEY idx_tag_code (tag_code),
    KEY idx_store_id (store_id),
    KEY idx_upload_batch_id (upload_batch_id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='油站标签目标值与证据表（多来源 + TTL + 枚举编码）';
```

如果你希望直接在 DB 层加外键（可选），可以后续再补：

---

## 3.2 与现有表 & tag\_spec/tag\_enum 的关联建议

1. 与标签规范表（CSV 那几张）：
	- `/mnt/data/tag_spec.csv` → 规范层：
		- `tag_code` 一致；
		- 可以通过 JOIN 补上标签含义、TTL 默认值、来源权重（ `w_source_s1/s2/s3` ）；
	- `/mnt/data/tag_enum.csv` → 枚举层：
		- `tag_code + enum_code` 一致，可拿到 `enum_label` 做对外展示；
	- `/mnt/data/tag_catalog.csv` → 分类层：
		- 用 `tag_code` 补 `tier1/tier2/tier3` 和 `tag_class` ，支撑你后面画像看板和维度汇总。
2. 与推断结果表（你上一版的 `station_tag_inference_result` 一类表）
	- 推荐统一用 `tag_code` 表达标签，而不是中文 `tag_name` ，可以加一层映射。
	- 典型 JOIN 模式（示意）：

这样你就可以做：

- 模型效果评估：推断值 vs 目标值的一致率；
- 决策规则：某些标签当目标值存在且 TTL/置信度更高时，优先目标值覆盖推断。

（JOIN 的精细 SQL 我先不展开，等你把主表名/字段名完全定下来再一起写。）

---

## 3.3 自动化表格导入工具（Python 脚本示例）

下面是一个偏工程化但足够轻量的版本：

- 依赖： `pymysql` （ `pip install pymysql` ）
- 特点：
	- 运行时让你手动输入文件路径（满足你“路径我来手工输入”的偏好）；
	- 支持 CSV（UTF-8，首行是表头）；
	- 按表头 → 字段名一一对应导入；
	- 使用 `ON DUPLICATE KEY UPDATE` 做幂等导入。

你可以保存为 `import_station_tag_target_value.py` 。

```python
python#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
import pymysql
from datetime import datetime, date

# ======== 1. 根据实际环境修改这里的配置 ========
DB_CONFIG = {
    "host": "127.0.0.1",
    "port": 3306,
    "user": "your_user",
    "password": "your_password",
    "database": "your_database",
    "charset": "utf8mb4",
}

TABLE_NAME = "station_tag_target_value"

# ======== 2. 通用工具函数 ========

def parse_date(value):
    """将字符串转成 date；支持 2025-07-24 / 2025/7/24 等"""
    if value is None:
        return None
    v = str(value).strip()
    if not v:
        return None
    v = v.replace("/", "-")
    try:
        # date.fromisoformat 支持 YYYY-M-D
        return date.fromisoformat(v)
    except Exception:
        # 兜底
        for fmt in ("%Y-%m-%d", "%Y-%m-%d %H:%M:%S"):
            try:
                return datetime.strptime(v, fmt).date()
            except Exception:
                continue
    raise ValueError(f"无法解析日期: {value}")

def parse_bool(value):
    """将多种表达转换成 0/1 或 None"""
    if value is None:
        return None
    v = str(value).strip().lower()
    if v == "":
        return None
    truthy = {"1", "true", "t", "yes", "y", "是", "对", "有"}
    falsy = {"0", "false", "f", "no", "n", "否", "无"}
    if v in truthy:
        return 1
    if v in falsy:
        return 0
    # 其他情况按 None 处理，避免脏值
    return None

def parse_int(value):
    if value is None:
        return None
    v = str(value).strip()
    if v == "":
        return None
    return int(v)

def parse_float(value):
    if value is None:
        return None
    v = str(value).strip()
    if v == "":
        return None
    return float(v)

def normalize_str(value):
    if value is None:
        return None
    v = str(value).strip()
    return v if v != "" else None

# ======== 3. 主导入逻辑 ========

def import_csv(file_path):
    conn = pymysql.connect(**DB_CONFIG)
    cursor = conn.cursor()

    sql = f"""
    INSERT INTO {TABLE_NAME} (
        store_id,
        as_of_date,
        tag_code,
        target_value_bool,
        target_value_number,
        target_value_string,
        source,
        evidence_state,
        ttl_days,
        reason,
        conf,
        upload_batch_id,
        closest_source,
        target_value_string_back,
        enum_code
    ) VALUES (
        %(store_id)s,
        %(as_of_date)s,
        %(tag_code)s,
        %(target_value_bool)s,
        %(target_value_number)s,
        %(target_value_string)s,
        %(source)s,
        %(evidence_state)s,
        %(ttl_days)s,
        %(reason)s,
        %(conf)s,
        %(upload_batch_id)s,
        %(closest_source)s,
        %(target_value_string_back)s,
        %(enum_code)s
    )
    ON DUPLICATE KEY UPDATE
        target_value_bool = VALUES(target_value_bool),
        target_value_number = VALUES(target_value_number),
        target_value_string = VALUES(target_value_string),
        source = VALUES(source),
        evidence_state = VALUES(evidence_state),
        ttl_days = VALUES(ttl_days),
        reason = VALUES(reason),
        conf = VALUES(conf),
        upload_batch_id = VALUES(upload_batch_id),
        closest_source = VALUES(closest_source),
        target_value_string_back = VALUES(target_value_string_back),
        enum_code = VALUES(enum_code),
        updated_at = CURRENT_TIMESTAMP;
    """

    inserted = 0
    updated = 0
    failed = 0

    with open(file_path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for line_no, row in enumerate(reader, start=2):  # 从第2行开始算（跳过表头）
            try:
                data = {
                    "store_id": parse_int(row.get("store_id")),
                    "as_of_date": parse_date(row.get("as_of_date")),
                    "tag_code": normalize_str(row.get("tag_code")),

                    "target_value_bool": parse_bool(row.get("target_value_bool")),
                    "target_value_number": parse_float(row.get("target_value_number")),
                    "target_value_string": normalize_str(row.get("target_value_string")),

                    "source": normalize_str(row.get("source")),
                    "evidence_state": normalize_str(row.get("evidence_state")),
                    "ttl_days": parse_int(row.get("ttl_days")),
                    "reason": normalize_str(row.get("reason")),
                    "conf": parse_float(row.get("conf")),

                    "upload_batch_id": normalize_str(row.get("upload_batch_id")),
                    "closest_source": normalize_str(row.get("closest_source")),
                    "target_value_string_back": normalize_str(row.get("target_value_string_back")),
                    "enum_code": normalize_str(row.get("enum_code")),
                }

                # 基础校验（必要字段）
                if data["store_id"] is None:
                    raise ValueError("store_id 为空")
                if data["as_of_date"] is None:
                    raise ValueError("as_of_date 为空或格式错误")
                if not data["tag_code"]:
                    raise ValueError("tag_code 为空")
                if not data["source"]:
                    raise ValueError("source 为空")
                if not data["evidence_state"]:
                    raise ValueError("evidence_state 为空")

                cursor.execute(sql, data)
                # rowcount == 1 新插入；== 2 更新（ON DUPLICATE KEY）
                if cursor.rowcount == 1:
                    inserted += 1
                else:
                    updated += 1

            except Exception as e:
                failed += 1
                print(f"[WARNING] 第 {line_no} 行导入失败: {e}")

            # 可选：每 1000 行提交一次
            if (inserted + updated + failed) % 1000 == 0:
                conn.commit()

    conn.commit()
    cursor.close()
    conn.close()

    print(f"导入完成：新插入 {inserted} 条，更新 {updated} 条，失败 {failed} 条。")

if __name__ == "__main__":
    file_path = input("请输入要导入的 CSV 文件路径：").strip()
    if not file_path:
        print("文件路径不能为空。")
    else:
        import_csv(file_path)
```

> 说明：
> 
> - 默认只支持 CSV，如果你要直接读 Excel，可以用 `pandas.read_excel` 替换 `csv.DictReader` ，逻辑一样；
> - 你可以根据实际情况在上面加一个 `upload_batch_id` 默认值（比如命令行参数），在文件里缺省时自动填充。

---

## 思维导图结构

- 油站标签目标值证据表 & 导入工具
	- 一、定位与角色
		- 存放「油站 × 日期 × 标签」的业务目标值
		- 记录来源、证据状态、TTL、置信度
		- 和 tag\_spec / tag\_enum / 画像推断结果表联动
	- 二、表结构设计
		- 主键
			- 自增 id
			- 唯一键：store\_id + as\_of\_date + tag\_code + source
		- 标签值字段
			- target\_value\_bool / number / string
			- enum\_code（对齐 tag\_enum）
		- 证据与生命周期字段
			- source / evidence\_state / reason
			- ttl\_days / conf / upload\_batch\_id / closest\_source / string\_back
		- 元数据字段
			- created\_at / updated\_at
	- 三、关联关系
		- 与 tag\_spec/tag\_catalog：
			- tag\_code 对齐，补含义/分类/TTL 等
		- 与 tag\_enum：
			- tag\_code + enum\_code → enum\_label
		- 与推断结果表：
			- store\_id + as\_of\_date + tag\_code JOIN
			- 用目标值评估和覆盖机器推断
	- 四、导入工具
		- 技术栈：Python + pymysql
		- 输入：手动输入表格路径（CSV），首行表头
		- 逻辑：行级解析 → 类型转换 → INSERT... ON DUPLICATE KEY UPDATE
		- 校验：必填字段校验，日期/布尔/数值解析
		- 输出：插入/更新/失败行数统计
	- 五、风险与演进
		- 日期/编码格式不统一风险
		- 大批量导入的性能和事务控制
		- 后续扩展 Excel 支持/批次校验/干跑模式（dry run）

---

## 《迭代日志》

- 【来源】
	- 基于你提供的字段定义和 demo 数据行（brand\_name + other + s2...），以及现有标签规范 CSV（ `tag_spec.csv` / `tag_enum.csv` / `tag_catalog.csv` ）推演出来的建表和导入方案。
- 【结论】
	- 已给出一份兼容你当前标签体系的 `station_tag_target_value` 建表 SQL，以及一个可直接在本地运行的 Python 导入脚本（按文件路径导入 CSV，支持幂等更新），可以作为「油站标签目标值与证据」的标准落地方案。
- 【改动点】
	- 把原本散落在 demo 里的业务含义结构化成建表字段和注释；
	- 设计了 `(store_id, as_of_date, tag_code, source)` 唯一键，满足你多来源和幂等导入的需求；
	- 把导入逻辑做了类型解析和基础校验，避免脏数据直接进入主表。
- 【待补充】
	- 实际的 DB 实例信息（host/user/database），需要你在脚本里替换；
	- 你那边最终确定的表名、是否跨库与 tag\_spec/tag\_enum 关联；
	- 真实生产文件格式（Excel 还是 CSV、编码、分隔符），如果和这里假设不完全一致，需要轻微调整。
- 【下一步建议】
	1. 先在测试库按这个 SQL 建表，拿你那条 demo 数据做一份小 CSV，跑一遍导入脚本，确认：
		- 字段类型/长度是否合适；
		- 导入逻辑是否符合你对空值、布尔值、日期的预期。
	2. 确认无误后，可以：
		- 针对 Excel 源数据再写一个轻量的「Excel → CSV」转换（或者直接用 pandas 版本导入）；
		- 补几条和 `tag_enum` 对齐的联调 SQL，验证 `enum_code` → `enum_label` 展示链路。
	3. 等你把表真正建好、跑过一版数据，我们可以在下一轮直接基于这个表，写几条和推断结果表的 JOIN SQL，用来做“机器推断 vs 目标值”的质量评估看板。

如果你愿意，下一步我可以帮你把这个导入工具升级成一个通用的「标签目标值上报 CLI」，顺带加上 dry-run 模式和简单的统计报表（比如按 tag\_code / source 汇总导入量）。

\["潜新站","新站","活跃站","沉默站","流失站","未知"\],翻译成问一个字段,注意简洁,写进数据库的;用英文前中文后,来展示

20251204\_2145  
站点生命周期分层\_中英结合枚举值  
tags:: #枚举设计 #站点分层 #标签取值

---

**一句话结论：**  
建议用简洁的英文枚举 + 下划线 + 中文名称的形式入库，既方便机器处理，也满足前端直接展示中英文。

---

按你给的顺序，对应字段值可以这样写进数据库（字符串）：

- `potential_new_潜新站` ：潜新站
- `new_新站` ：新站
- `active_活跃站` ：活跃站
- `dormant_沉默站` ：沉默站（用 dormant 表示“休眠/沉默”）
- `churned_流失站` ：流失站（churned 是比较标准的“流失”说法）
- `unknown_未知` ：未知

如果你希望英文部分作为 `enum_code` ，中文部分作为展示文案，也可以把这串拆成两列，用下划线前后拆分就行。

---

## 《迭代日志》

- 【来源】
	- 基于你提供的六个中文状态词及前面标签枚举三合一的设计思路。
- 【结论】
	- 产出了适合入库的中英结合枚举字符串方案（ `english_chinese` ），兼顾可读性与可维护性。
- 【改动点】
	- 对“沉默站”选择了更贴近画像语境的英文单词 `dormant` ；对“流失站”使用了常见用户生命周期用语 `churned` 。
- 【待补充】
	- 是否需要再加一个纯英文枚举列（只存 `potential_new` 等），当前方案已经可以直接拆分实现。
- 【下一步建议】
	- 在 `tag_enum` 或对应枚举表里，把这 6 个值登记为标准枚举；
	- 后续如有更多站点生命周期分层（例如“唤醒站”），按照同样规则扩展即可。