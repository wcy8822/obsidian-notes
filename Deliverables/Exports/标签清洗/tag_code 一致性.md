能办。把“tag_code 一致性”做成**制度 + 机制**两层：上有“唯一真相源（SoT）”，下有“强约束 + 自动同步 + 可回放”。下面是可直接落地的设计。

# <font color="#f79646">一句话结论</font>

以 `tag_catalog` 作为**唯一真相源**（决定 `tag_id/tag_code`），所有生产表**只存 `tag_id`**；`tag_code` 一律通过“当前生效视图”联查获得，并用触发器/校验视图、发版表、变更日志保证“改一次、处处生效、可回滚”。Tall 写 `tag_value_fact`，Hot 宽层列名在发布时由 `tag_code` 动态生成【】【】【】。

---

## 1) 统一“唯一真相源”

- **唯一主表**：`tag_catalog(tag_id, tag_code, tier1/2/3, tag_class, status…)`，这里的 `tag_code` 是**唯一权威**【】。
    
- **当前口径视图**：`vw_tag_spec_current` 提供当期生效规格；下游只查视图拿 `value_type/取值口径`【】。
    
- **规则当前视图**：`vw_tag_rule_active` 提供当前激活规则版本【】。
    

> 原则：**运行时只认 tag_id**。`tag_code` 只是**展示/生成列名/拼SQL**时通过联查拿到。

---

## 2) 生产表的约束与引用

- **事实表（Tall）**：`tag_value_fact(as_of_date, station_gid, tag_id, value_*, source, conf, ver, …)`，**不存 `tag_code`**，并保证“**仅一个值槽位非空**”的互斥校验【】。
    
- **证据表**：`tag_trace(trace_id, station_gid, tag_id, as_of_date, trace_json…)`【】。
    
- **Hot 宽层**：`tag_wide_daily` 的七件套列通过**白名单**从 Tall 透视生成，列前缀来自 `tag_catalog.tag_code`【】。
    

**外键/校验建议**

```sql
-- 1) Tall 只允许 catalog 中已登记的 tag_id
ALTER TABLE tag_value_fact
  ADD CONSTRAINT fk_tag_id
  FOREIGN KEY (tag_id) REFERENCES tag_catalog(tag_id);

-- 2) 槽位互斥（不同引擎语法略有差异，示意）
ALTER TABLE tag_value_fact
  ADD CONSTRAINT only_one_value CHECK (
    (value_string IS NOT NULL)::int +
    (value_number IS NOT NULL)::int +
    (value_bool   IS NOT NULL)::int = 1
);
```

---

## 3) “改一次、处处生效”的同步机制

**A. 订正入口（可灰度）**

- 新建表 `tag_code_correction(tag_id, old_code, new_code, reason, approved_by, approved_at, status)`；
    
- 只有当 `status='approved'` 时触发“发布”。
    

**B. 发布流程（两步）**

1. **登记发版**：写入 `tag_release(tag_id, rule_version, region_scope, metrics, rollback_point…)`，形成回滚锚点【】。
    
2. **原子切换**：事务内更新 `tag_catalog.tag_code=new_code`，同时写 `tag_change_log` 留痕【】。
    

**C. 下游自动生效**

- Tall 表**不受影响**（按 `tag_id` 取数）；
    
- Hot 宽层在次日物化时依据**最新的 `tag_code`** 重新生成列名（由调度器读取 `tag_catalog/tag_wide_hot_list` 拼接 SQL）【】。
    

---

## 4) “不一致”防呆

**校验视图（巡检）**

```sql
-- 下游误把 tag_code 当主键写死的巡检（应为 0 行）
CREATE VIEW anti_pattern_tagcode_leak AS
SELECT DISTINCT f.tag_id
FROM tag_value_fact f
LEFT JOIN tag_catalog c ON f.tag_id=c.tag_id
WHERE c.tag_id IS NULL;  -- 发现孤儿即告警
```

**发布前合规检查**

- `CASE 1`：若 `tag_code` 变更将导致 Hot 宽层列名变化 → 调度器在预跑阶段比对“新旧列清单”，**生成兼容视图** `tag_wide_daily_compat` 保持老列 1–2 个发布周期【】【】。
    
- `CASE 2`：存在旧消费者 → 通过 `compat` 视图平滑迁移，文档化“截止日期”。
    

---

## 5) 四源 RAW 到治理的关联

- 四源 RAW（S1/2/3/4）里**也只出现 tag_id**；任何 “别名/老 code” 仅存在于**临时映射表**，在加载 RAW→STD 时统一转成 `tag_id`。
    
- 若确需在 RAW 里投 `tag_code`，也要**同时投 `tag_id` 并以 `tag_id` 为准**，加载时校验 `(tag_id, tag_code)` 是否与 `tag_catalog` 一致，不一致则进错误队列。
    

---

## 6) 具体怎么开始做（落地步骤）

1. **把主维建起来**
    
    - 落库 `tag_catalog/tag_spec/tag_enum`（先装 P0=13），并建立 `vw_tag_spec_current`【】。
        
2. **改 Tall 写法**
    
    - 所有 ETL/规则产线**只写 `tag_value_fact(tag_id,…)`**，禁止把 `tag_code` 落到事实里【】。
        
3. **改 Hot 生成器**
    
    - Hot 宽层生成 SQL 中的列前缀全部来自 `tag_catalog.tag_code`；白名单由 `tag_wide_hot_list` 管控【】。
        
4. **上线校验与回滚**
    
    - 任何 `tag_code` 调整都走 `tag_code_correction → tag_release → tag_change_log` 三联单；
        
    - 需要回滚，按 `rollback_point` 回切老版本【】。
        
5. **巡检与告警**
    
    - 每日跑 `anti_pattern_tagcode_leak`，发现孤儿/不一致立刻告警（钉钉/飞书机器人）。
        

---

## 7) 兼容历史：给你一段迁移脚本骨架

```sql
-- A. 用当前 catalog 构建“字典快照”
CREATE VIEW vw_tag_dict_current AS
SELECT c.tag_id, c.tag_code, s.value_type
FROM tag_catalog c
JOIN vw_tag_spec_current s USING(tag_id);

-- B. 校验历史 Tall 是否有未知 tag_id
SELECT f.tag_id, COUNT(*) cnt
FROM tag_value_fact f
LEFT JOIN vw_tag_dict_current d USING(tag_id)
WHERE d.tag_id IS NULL
GROUP BY f.tag_id;

-- C. 生成 Hot 宽层列清单（调度侧模板化）
-- 根据 vw_tag_dict_current 与白名单拼接 MAX(CASE WHEN tag_id=... THEN ...)
```

---

### 小结

- **只在一个地方改 `tag_code`**（`tag_catalog`），其他所有层都**不存 code、只认 id**；
    
- **发布-变更-回滚**全链条记录在案；
    
- **Hot 宽层**通过白名单 + 代码生成解耦“列名 ↔ 规则”；
    
- **防呆巡检**兜底，发现“不一致”立即告警。
    

你把当前的 `tag_catalog/tag_spec/tag_enum` 初版表给我（或我先用 P0 的模板帮你落一版），我按这套机制把 Hot 宽层生成器、巡检 SQL、以及 `tag_code_correction` 的三联工作流一起配好，接着就能把你现在的 RAW→STD→Tall→Hot 全链路跑起来。