# Obsidian 四件事落地手册 · v1.1（含复盘方法论）

> 目标：不仅解决 QuickAdd / 任务顺延 / 统计复盘 / 数据清洗，还要固化 **DALL·E 方法论**，形成从 Daily → Project → Deliverable → Playbook 的闭环，并提供 **周总结模板 + AI Prompt**，方便 AI 批量投喂。

---

## 0) DALL·E 方法论（Daily → AI → Layered → Learn → Extract）

* **Daily**：叙事流写作，贴近人脑思维（“我做了什么 → 得到什么 → 沉淀什么”）。
* **AI**：事后用 AI 帮忙补齐“总结 / 结论 / 沉淀”。
* **Layered**：在叙事中随手插入锚点（总结 / 结论 / 沉淀），既保留故事流，又可抽取。
* **Learn**：AI 辅助 + 人工判断，确保结论可靠。
* **Extract**：从 Daily 抽取 → Project 聚合 → Deliverable 成果 → Playbook 知识。

---

## 1) Daily 模板（融合版）

```markdown
## 标签治理项目
昨天和区域开了两场会，讨论准确率提升…（叙事）

**总结**：准确率提升关键在双人校验。
**结论**：需要建立区域改动审批机制。
**沉淀**：未来可形成 Playbook《区域改动应对 SOP》。

---

## 品牌标签项目
协助战略做清洗与建设…（叙事）

**总结**：数据冗余高，清洗是战略对齐前提。
**结论**：下周形成初步清洗方案。
**沉淀**：可沉淀方法《标签字段收敛流程》。
```

写的时候自然叙事，关键处随手加锚点。AI 在周总结时自动抽这些锚点。

---

## 2) Project 模板强化

```markdown
# 投喂笔记
- [[Daily/2025-09/2025-09-13]] 等

# 阶段总结
从 Daily 聚合而来。

# 阶段结论
AI/人工提炼出的明确结论。
```

---

## 3) Deliverable 模板强化

```markdown
# 背景
项目缘起。

# 详细论证
AI 辅助展开逻辑推演。

# 输出结论
一句话结论 + 三段论据。

# 沉淀总结
抽象出可迁移的方法 → [[Playbook/xxx]]
```

---

## 4) Playbook 模板强化

```markdown
# 方法论
场景 → 框架 → 判断逻辑。

# SOP
逐步执行步骤（checklist）。

# 案例
来源项目 / Deliverable 链接。
```

---

## 5) AI 投喂池（聚合最近 Daily 总结/结论/沉淀）

### `AI投喂池.md`


```dataviewjs
// 最近 7 天 Daily
const start = moment().subtract(7,'days');
const pages = dv.pages("Daily").where(p => moment(p.file.name).isAfter(start));

let rows = [];
for (const p of pages) {
  const text = await dv.io.load(p.file.path);
  const lines = text.split("\n");
  for (const l of lines) {
    if (/\*\*(总结|结论|沉淀)\*\*/.test(l)) {
      rows.push({file: p.file.link, content: l});
    }
  }
}

dv.table(["来源","内容"], rows.map(r => [r.file, r.content]));
```

这样 AI 投喂池就是一个“最近 7 天的提炼表”，你只要把这页丢给 AI 即可。

---

## 6) 周总结模板 + AI Prompt

### 周总结模板 `Weekly/YYYY-WW.md`

```markdown
---
title: "Weekly-2025-W37"
type: "weekly"
---

# 本周 Daily 摘要
- 自动聚合最近 7 天 Daily 总结/结论/沉淀 → [[AI投喂池]]

# AI 提炼
(此处粘贴 AI 生成的内容)

# 我的确认
- ✅ 有价值 → 移到 Project / Deliverable。
- ❌ 无价值 → 丢弃。

# 下周关注
- ...
```

### 建议 Prompt

```
请你帮我阅读以下一周 Daily 的“总结 / 结论 / 沉淀”。
任务：
1. 按项目聚合，提炼共识和差异。
2. 输出每个项目的阶段性结论（1 句话）。
3. 标注潜在可沉淀为 Playbook 的方法 / SOP。
输出格式：项目名 → 结论 → 方法 → 待补充。
```

这样你每周只需一次粘贴，就能批量生成结构化结论。

---

# 《迭代日志》

【来源】上一轮对话+你的需求：叙事流写作 + AI 自动补齐结论沉淀 + 降低手动复制摩擦。
【结论】形成融合方案：**叙事流 + 锚点标记 + 周总结批量 AI 提炼**，并固化为 DALL·E 方法论。
【改动点】新增 Daily/Project/Deliverable/Playbook 模板增强版、`AI投喂池.md` 查询、周总结模板+Prompt。
【待补充】需要确认：你更想把 AI 投喂池作为**自动聚合展示**，还是要在其中人工筛选再喂给 AI。
【下一步建议】挑一个真实项目（如“标签治理”），用这个方法跑一周，生成首个 Deliverable + Playbook 条目。
