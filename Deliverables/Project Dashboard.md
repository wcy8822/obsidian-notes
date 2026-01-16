（1）所有项目的里程碑总览（按到期排序）

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

（2）本月到期的里程碑


```dataview
table file.link as 项目, m.name as 里程碑, m.status as 状态, m.due as 到期
from "Projects"
where milestones
flatten milestones as m
where dateformat(m.due, "yyyy-MM") = dateformat(date(today), "yyyy-MM")
sort m.due asc
```


（3）按状态分组


```dataview
table file.link as 项目, m.name as 里程碑, m.due as 到期
from "Projects"
where milestones
flatten milestones as m
group by m.status

```
