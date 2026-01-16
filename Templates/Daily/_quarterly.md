---

type: quarterly

quarter: <% tp.date.now("YYYY-[Q]Q") %>

created: <% tp.date.now("YYYY-MM-DD") %>

tags: [quarterly]

---
# <% tp.date.now("YYYY-[Q]Q") %> 季度复盘

  

## 季度目标回顾

-

  

## 项目里程碑复盘

```dataview

table m.name as 里程碑, m.status as 状态, m.due as 到期, file.link as 项目

from "Projects"

where milestones

flatten milestones as m

where dateformat(m.due, "YYYY-[Q]Q") = dateformat(date(today), "YYYY-[Q]Q")

sort m.due asc

```

  

## 季度任务完成率

```dataview

table length(filter(file.tasks, (t) => !t.completed)) as 未完,

length(filter(file.tasks, (t) => t.completed)) as 已完

from "Daily"

where dateformat(file.day, "YYYY-[Q]Q") = dateformat(date(today), "YYYY-[Q]Q")

```

  

## 改进方向

-

  

---