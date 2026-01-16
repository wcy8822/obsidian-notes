# 📊 全局 Dashboard

> 把 Daily / Weekly / Monthly / Quarterly / Yearly 的任务和里程碑汇总在一张总览表里。

---

## 🔹 今日任务
```tasks
not done
due today
sort by priority then by due
```

## 🔹 本周任务
```tasks
not done
due after <% tp.date.now("YYYY-MM-DD", -7) %>
due before <% tp.date.now("YYYY-MM-DD") %>
sort by due
```

## 🔹 本月任务
```tasks
not done
due after <% tp.date.now("YYYY-MM-01") %>
due before <% tp.date.now("YYYY-MM-DD") %>
sort by due
```

## 🔹 本季度任务
```dataview
table length(filter(file.tasks, (t) => !t.completed)) as 未完,
      length(filter(file.tasks, (t) => t.completed)) as 已完
from "Daily"
where dateformat(file.day, "YYYY-[Q]Q") = dateformat(date(today), "YYYY-[Q]Q")
```

## 🔹 本年度任务
```dataview
table length(filter(file.tasks, (t) => !t.completed)) as 未完,
      length(filter(file.tasks, (t) => t.completed)) as 已完
from "Daily"
where dateformat(file.day, "YYYY") = dateformat(date(today), "YYYY")
```

---

## 📌 项目里程碑总览
```dataview
table without id
  file.link as 项目,
  m.name as 里程碑,
  m.status as 状态,
  m.owner as 负责人,
  m.due as 到期
from "Projects"
where milestones
flatten milestones as m
sort m.due asc
```

## 📌 本月到期的里程碑
```dataview
table file.link as 项目, m.name as 里程碑, m.status as 状态, m.due as 到期
from "Projects"
where milestones
flatten milestones as m
where dateformat(m.due, "yyyy-MM") = dateformat(date(today), "yyyy-MM")
sort m.due asc
```

## 📌 按状态分组的里程碑
```dataview
table file.link as 项目, m.name as 里程碑, m.due as 到期
from "Projects"
where milestones
flatten milestones as m
group by m.status
```

