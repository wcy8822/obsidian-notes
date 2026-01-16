
### 经典视图：直接可用的五个查询

**1) 今日焦点**

```tasks
not done
due today
sort by priority then by due

```

2) 逾期未完成


```tasks
not done
due before today
sort by due
```


3) 接下来 7 天（含今天）


```tasks
not done
due after yesterday
due before in 7 days
sort by due


```


4) 只看 Projects 目录里的任务
```tasks
not done
path includes Projects
sort by due

```

5) 只看 Daily 里写出来的任务（把每日输入汇总出来）

```tasks
not done
path includes Daily
sort by due

```


### 按“项目”聚合（两种绑定方式，二选一或混用）

**A. 用标签法（推荐稳健）**  
在任务里写 `#project/营销活动优化`，查询如下：

```tasks
not done
tag includes #project/营销活动优化
sort by due

```

要换项目，复制一段把标签换一下就行。也可以写成多项目：
```tasks
not done
(tag includes #project/营销活动优化) OR (tag includes #project/双11投放)
sort by due

```


**B. 用 Wiki 链接法（在项目页自动“自我聚合”）**  
在任务里把项目名作为链接写进描述：`- [ ] …… [[营销活动优化]] 📅 2025-09-20`。  
然后在**项目模板**里放这段（Templater 会把文件名替换进去）：

```tasks
not done
description includes [[<% tp.file.title %>]]
sort by due

```

### 进阶筛选（需要时加上）

- 只看高优先级：
```tasks
not done
priority is high
sort by due

```

只看带某关键词：
```tasks
not done
description includes 海报

```
隐藏模板目录的任务：
```tasks
not done
path does not include Templates

```



