---
type: monthly
month: <% tp.date.now("YYYY-MM") %>
created: <% tp.date.now("YYYY-MM-DD") %>
tags: [monthly]

---


# <% tp.date.now("YYYY-MM") %> 月度总结

  

## 1. 本月目标回顾

- 目标 1：✅ / ❌

- 目标 2：✅ / ❌

- 目标 3：✅ / ❌

  

## 2. 本月完成的项目里程碑

```dataview

table m.name as 里程碑, m.status as 状态, m.due as 到期, file.link as 项目

from "Projects"

where milestones

flatten milestones as m

where dateformat(m.due, "yyyy-MM") = dateformat(date(today), "yyyy-MM")

sort m.due asc

```
## 3. 本月任务统计
### 已完成
```tasks
done
due after <% tp.date.now("YYYY-MM-01") %>
due before <% tp.date.now("YYYY-MM-DD") %>
```

### 未完成
```tasks
not done
due after <% tp.date.now("YYYY-MM-01") %>
due before <% tp.date.now("YYYY-MM-DD") %>
```

## 4. 本月复盘
- 成功经验：
- 遇到问题：
- 下月改进：

## 5. 下月展望
- [ ] 
