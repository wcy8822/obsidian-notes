---
type: yearly
year: <% tp.date.now("YYYY") %>
created: <% tp.date.now("YYYY-MM-DD") %>
tags: [yearly]
---

  

# <% tp.date.now("YYYY") %> 年度总结

  

## 年度目标回顾

-

  

## 主要里程碑回顾

```dataview

table m.name as 里程碑, m.status as 状态, m.due as 到期, file.link as 项目

from "Projects"

where milestones

flatten milestones as m

where dateformat(m.due, "YYYY") = dateformat(date(today), "YYYY")

sort m.due asc

```

  

## 年度任务统计

```dataview

table length(filter(file.tasks, (t) => !t.completed)) as 未完,

length(filter(file.tasks, (t) => t.completed)) as 已完

from "Daily"

where dateformat(file.day, "YYYY") = dateformat(date(today), "YYYY")

```

  

## 自我评价

- 成就：

- 不足：

- 改进：