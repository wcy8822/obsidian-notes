---
status: active
owner: ixu
created: <% tp.date.now("YYYY-MM-DD") %>
tags: [project]
---

```
status: active
owner: ixu
created: <% tp.date.now("YYYY-MM-DD") %>
tags: [project]
milestones:
  - name: 里程碑示例
    due: <% tp.date.now("YYYY-MM-DD", +14) %>
    owner: ixu
    status: planned
```


# 项目名称

## 目标
- [ ] 明确目标

## 里程碑
- [ ] 

## 工作分解
- [ ] 

## 风险与对策
- [ ] 

## 交付标准
- [ ] 

---

## 任务追踪
```dataview
table status, due, priority
from "Daily"
where contains(tags, "daily")
where contains(text, this.file.name)
sort due asc
```


## 关联任务

```tasks

not done
description includes [[<% tp.file.title %>]]
sort by due


```


解释：  
- `description includes [[<% tp.file.title %>]]` → 会把当前项目文件名替换进去，比如在 `营销活动优化.md` 里就会变成 `description includes [[营销活动优化]]`。  
- 这样，每个项目笔记都会自动聚合所有写了 `[[项目名]]` 的任务。  

---


# 投喂笔记
- [[Daily/2025-09-13]]

# 阶段总结
对 Daily 投喂内容的归纳。

# 阶段结论
AI 推理 + 自己判断后的定论（能否做 / 怎么做）。
