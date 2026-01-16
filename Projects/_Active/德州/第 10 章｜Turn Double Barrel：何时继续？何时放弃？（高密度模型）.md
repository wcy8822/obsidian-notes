
**上一章：** 第 9 章｜转牌信息价值最大化：权益压缩、范围极化、阻挡与临界点  
**本 章：** 第 10 章｜Turn Double Barrel：何时继续？何时放弃？（高密度模型）  
**下一章：** 第 11 章｜Turn 超池下注（Overbet）：数学与结构的完整重建

---

# 第 10 章｜Turn Double Barrel：何时继续？何时放弃？（高密度模型）

（来源设计：

- 《全范围 C-Bet 策略指南 I/II》——固定 flop 小注（30%）后 turn double barrel 频率与牌面分类
    
- 《超池下注指南》——BB 被 capped 的牌面上，IP turn 极化二次开火与 overbet 的结构
    
- 《千算标准行动路线 / 行动路线》——简化 double barrel 规则（哪些牌“必须二枪”，哪些牌“自动关枪”））
    

---

## 10.1 一句话结论

**Turn double barrel 本质是一个“高密度过滤器”：在权益压缩之后，用第二枪把自己范围压缩成“能走到河牌的候选”，同时把对手的中段牌直接逼出局——该打就打满，该关枪就彻底关，不能在模糊地带拖泥带水。**

---

## 10.2 章节目的：这一章到底要帮你搞懂什么？

这章只解决三个问题：

1. **GTO 视角：**
    
    - 在固定 flop 小注策略下（30% pot），
        
    - turn 上不同行为（bet/check）的标准频率与典型牌型是什么？
        
    - 哪些牌面是“高频 double barrel 板”，哪些是“自然放弃板”？
        
2. **玩家池现实：**
    
    - 微级别 / 线下常见的错误：
        
        - 有人 flop cbet 过多，turn 也机械二枪；
            
        - 有人 flop cbet 还可以，turn 永远怂。
            
    - 如何利用这些偏差，既不被 over-barrel 碾压，又把别人“自动关枪”当成提款机？
        
3. **高密度模型：**
    
    - 把 double barrel 决策压缩成一个高密度 checklist：
        
        - 牌面类型（blank / scare / range shift）、
            
        - 范围结构（谁 capped / 谁 nuts 重）、
            
        - 牌型类别（强 value / 中 value / 强听牌 / 空气）、
            
        - 对手类型（fold too much / call too much / 不会 XR），
            
    - 让你在 turn 用同一套结构做出“继续 or 放弃”的决策，而不是“感觉好就打”。
        

---

## 10.3 GTO 基线：从 C-Bet I/II 看 double barrel 的大盘

在《全范围 C-Bet I/II》里，有一个隐含但非常重要的设定：

- flop：
    
    - 多数场景统一假设 IP 用 **30% pot 高频 cbet**（甚至接近全范围），
        
- turn / river：
    
    - 统一用 **70% pot** 继续 bet 的尺寸。
        

在这个框架下，solver 会给出：

- 不同牌面下 IP turn double barrel 的频率（多在 40–70% 区间）；
    
- 对应的牌型分类：
    
    - 哪些 turn 是“高频继续”（auto-DB）；
        
    - 哪些 turn 是“高频 check”（auto-check）；
        
    - 哪些 turn 是“混频”（mix）。
        

抽象出来的 GTO 大盘结论可以简化为：

1. **高干 A/K 牌面 + blank turn：高频 double barrel**
    
    - 这类牌面 IP flop 有明显范围优势，
        
    - blank turn 不改变 nuts / 范围关系，
        
    - double barrel 频率一般偏高（~60%+），用来继续压榨 BB 的 capped 范围。
        
2. **中低连牌 + 较 dynamic turn：混频 double barrel**
    
    - 如 T98 / 765 类型牌面，turn 出高张 / 同花 / 顺子补牌时：
        
        - IP 与 BB 的 nuts / equity 重新洗牌，
            
        - solver 通常给出中等频率 double barrel（~40–60%），并混入大量 check 控制锅。
            
3. **range shift 明显利好防守方的 turn：低频 double barrel / auto-check**
    
    - 如：
        
        - flop 高牌你有优势，turn 补成低端顺子 / 三同花 / 极利 OOP 的牌，
            
    - GTO 倾向：大幅削减 barrel 频率，多用 check，甚至接近 auto-check。
        

**关键：**

- flop 全范围小注只是“压住 preflop 优势”的起点；
    
- 真正的 EV 差异，在 turn 的 double barrel 决策里被放大。
    

---

## 10.4 玩家池现实：常见 double barrel 三种风格

结合实战与“千算行动路线”里的经验总结，玩家池 turn double barrel 大致分三类人：

1. **机械二枪型（over-DB）：**
    
    - flop 只要中一点、turn 只要不明显变糟，就继续打；
        
    - 几乎不考虑：
        
        - 这张 turn 是否利好对手？
            
        - 自己是否已被 capped？
            
        - 对手是否已经明显不肯弃？
            
    - 特征：
        
        - 在“range shift 利好防守方”的 turn 上持续犯错，
            
        - 给防守方巨额 exploit 空间（尤其是 call + 让他 river 自爆）。
            
2. **一枪就怂型（under-DB）：**
    
    - flop 30% 小注 cbet 很勤奋，
        
    - turn 只要没明显 hit nuts，就大量 check-back；
        
    - 特征：
        
        - 放弃了很多在 GTO 下本该继续 double 的高 EV 牌型（强听牌 / top pair / overpair），
            
        - 让对手的 flop 被动 defend 变“非常轻松”：只要扛一枪就进河牌。
            
3. **只看自己牌力，不看牌面 / 范围结构型：**
    
    - double barrel 的逻辑完全是：“我觉得我牌还不错，就继续打”；
        
    - 不看：
        
        - 对手 range 是否已经被 capped；
            
        - 自己 flop 的线路是否已经曝露过多信息；
            
        - turn 是否适合极化 / 是否适合改用 check-range 保护。
            

**你要做的是：**

- 自己先避免变成这三种人之一；
    
- 然后针对不同类型对手，把 double barrel 变成 exploit 工具，而不是被 exploit 的漏洞。
    

---

## 10.5 “高密度模型”：Turn Double Barrel 决策的核心框架

把上一章的“turn 四要素”（权益压缩 / 范围极化 / 阻挡 / 临界点）压缩成 double barrel 决策模型，可以得到一个六步 checklist：

### Step 1｜牌面分类：这张 turn 属于哪一类？

延续第 9 章的分类：

- **blank：**
    
    - 不补顺、不补花、不改变高牌结构（例如 A Q 4 → 2）；
        
- **scare card：**
    
    - 补成三同花、四顺子、高牌重击对手范围的牌（A/K/Q/J）；
        
- **range shift：**
    
    - 明显利好防守方（BB 成顺 / 成同花 / 成两对），让原有进攻方被封顶。
        

### Step 2｜谁被 capped？谁有 nuts advantage？

- 看 flop 线路：
    
    - 谁在 flop 只有小注线？谁有 XR 线？谁有 check-back 线？
        
- 看 turn 牌：
    
    - 这张牌是否让原先被动的一方突然有大量 nuts？
        
    - 还是强化了原有进攻方的 nuts 密度？
        

### Step 3｜权益压缩：我范围里的哪些牌已经“没未来”？

- flop 某些带 backdoor 的牌，到 turn 已经彻底 miss：
    
    - 这些牌大概率应该直接放弃；
        
- 某些中段牌（第二对 / 裸 top pair）
    
    - 在利好你的 blank 上依然可 double；
        
    - 在利好对手的 scare card 上应更多 check 控制锅。
        

### Step 4｜我的这手牌属于哪类？

最少分为四类：

1. 强 value：ready to stack off（两对+ / 很强 top pair / overpair + 安全结构）；
    
2. 中 value：一对牌中上部分（普通 top pair / overpair 但牌面危险）；
    
3. 强听牌：NFD / combo draw / OESD + BDFD；
    
4. 空气 / 边缘听牌：无摊牌价值或弱 backdoor。
    

### Step 5｜对手类型：fold too much / call too much / 不会 XR？

- fold too much：
    
    - 对 turn、river 大注特别敏感，弃牌太多；
        
- call too much：
    
    - 不肯在 turn 弃掉中对 / top pair，不信你的故事；
        
- 不会 XR：
    
    - turn 甚至不 XR nuts，只会被动 call，河牌才行动。
        

### Step 6｜算临界点：这枪打下去，值不值？

- 下注 size B vs pot P：
    
    - 我需要对手弃牌率 ≈ B / (P + B)；
        
    - 我需要自己对其继续范围的 equity ≥ B / (P + B) 才能 call。
        
- 如果在你主观判断中：
    
    - 对手实际弃牌率或 bluff 率远离这个临界点，你就应该 exploit 偏移（多打 or 少打 / 多 call or 多 fold）。
        

**高密度模型的关键：**

- 不是塞更多花哨细节，而是让你 turn 每一枪都以这六步为骨架思考。
    

---

## 10.6 GTO 视角下的三类 double barrel 板型

基于 C-Bet I/II + overbet 的典型解，可以把 turn double barrel 的整体环境拆成三类牌面模板：

### 10.6.1 模板 A：高频 double barrel（“自动二枪板”）

特征：

- flop：你有明显范围优势（多见于 A/K 高干面，IP vs BB）；
    
- turn：blank 或轻微 scare，但整体仍偏利你；
    
- BB 在 flop 未 XR 的线中，范围在 turn 明显 capped（很多 top pair 不多、以中段牌为主）。
    

GTO 下：

- IP turn double barrel 频率很高（~60–70%），
    
- 使用 2/3–70% pot 尺度继续“强压”：
    
    - value：top pair 优质 kicker+、overpair、两对+；
        
    - bluff：未成的强听牌 + 部分无摊牌价值、带 blocker 的组合。
        

你可以把这些牌面默认打成：

> “只要结构不崩坏，就把 flop 这条线里的大量价值与强 bluff 延伸到 turn。”

### 10.6.2 模板 B：混频 double barrel（“翻倍检查板”）

特征：

- flop：中高协面（如 JTx / T98 / 987）、双方 nuts 分布相对接近；
    
- turn：
    
    - 有些牌导致 nuts 大幅转向一方，
        
    - 有些牌只是继续保持 dynamic，使双方 equity 尚未完全压缩。
        

GTO 下：

- IP 在这些牌面上的 double barrel 频率一般在 40–60% 中间，
    
- 大量加入 check-back：
    
    - 把部分中 value / marginal draw 收归 check-range，
        
    - 保证河牌仍有 bluffcatch / thin value 的空间。
        

你在实战要接受：

> 不是所有 turn 都适合“要么打要么弃”，混频才是主流。

### 10.6.3 模板 C：低频 double barrel / auto-check 板

特征：

- flop：你 range 稍占优势或持平；
    
- turn：
    
    - scare card 明显利好防守方（BB）；
        
    - 或补成低端顺子 / 三同花，BB 在这类结构上的 nuts 明显更多。
        

GTO 倾向：

- 明显收缩 double barrel 频率，很多线直接 auto-check；
    
- 留下继续 double 的牌：
    
    - 极强 nuts / near nuts；
        
    - 极强听牌；
        
- 其余大量中 value / marginal 牌全部用 check 控制锅，甚至走向 check-fold。
    

**玩家池典型错误：**

- 机械二枪型在这些牌面继续高频 double，给防守方送巨大 EV；
    
- 一枪怂型则在模板 A 的牌面过早放弃。
    

---

## 10.7 double barrel 牌型分配：强 value / 中 value / 听牌 / 空气

结合 C-Bet I/II 的思路（flop 全局小注 → turn 固定 70%），我们可以给出一个实用的 double barrel 牌型分配方法：

### 10.7.1 强 value：大多数情况下继续 double

- 条件：
    
    - 你的这手牌在自己当前范围里接近顶端：两对+ / 高质量 top pair / overpair；
        
    - turn 没有严重改善对手 nuts（非明显 range shift）。
        

策略：

- 模板 A 牌面：
    
    - 高频 double，甚至可以考虑计划三街 value。
        
- 模板 B 牌面：
    
    - 混频，在极端 scare card 上降低频率，但多数情况仍要继续压。
        
- 模板 C 牌面：
    
    - 更倾向于 check control，只有最强 value 继续压。
        

### 10.7.2 中 value：根据牌面与对手类型灵活分配

中 value 典型是：

- 单纯 top pair（kicker 一般）；
    
- 危险结构中的 overpair；
    
- 第二对 + 某些 backdoor。
    

逻辑：

- 在模板 A/blank turn 上：
    
    - 面对 fold too much 的对手，可以倾向 double（赚他弃太多）；
        
    - 面对 call too much 的对手，更多转为 check 控制，再在河牌打 thin value / bluffcatch。
        
- 在模板 C / range shift 明显利好防守方的 turn：
    
    - 大量中 value 直接 check，甚至在面对大注时大胆 XF。
        

### 10.7.3 强听牌：GTO 倾向 high-frequency double

强听牌包括：

- nut flush draw / 双向顺子+花；
    
- combo draw（两头顺 + NFD / OESD + overcards 等）。
    

GTO 的逻辑：

- 这些牌，**在你被跟注时 equity 也不差**；
    
- 同时还能利用 fold equity 抢 EV；
    
- 因此在大部分结构中：
    
    - 强听牌是 turn double barrel 的主力 bluff 端。
        

实战中：

- 对 fold too much 的对手：
    
    - 可以更激进 double，甚至用大尺⼨（配合第 11 章 overbet）。
        
- 对 call too much 的对手：
    
    - 有时更适合 check-back / XC，利用拆牌率而不是纯 FE。
        

### 10.7.4 空气 / 弱听牌：Turn 是“砍掉”的主要场所

弱听牌 / 空气，一般在 turn：

- 因为权益压缩，已难以靠 river 自然补出有意义的牌力；
    
- 在没有强阻挡 / 没有对手弃很多的 read 时，
    
    - 大部分应该在 turn 被直接放弃（check-back 或 XF），
        
    - 而不是硬顶到 river 再被迫发疯式 bluff。
        

**千算行动路线类的简化规则：**

- flop 纯空气 cbet，turn 多数情况 **“关枪 + 便宜摊牌”**，
    
- 不鼓励在没有结构 / 阻挡支持下，盲目进行第二枪甚至第三枪。
    

---

## 10.8 数学与频率：double barrel 背后最简算账

这里不做复杂推导，只给你两条硬算账思路：

### 10.8.1 作为 bluff：需要多少弃牌率？

同第 9 章，turn 单枪 bluff 的 break-even 条件：

> 对手弃牌率 f ≥ B / (P + B)

示例：

- pot=100，turn 下注 70：
    
    - 需要对手弃 ≥ 70 / 170 ≈ 41%；
        
- pot=100，turn overbet 150：
    
    - 需要对手弃 ≥ 150 / 250 = 60%。
        

Double barrel 时你可以粗略这样想：

- flop bluff 已经付出一次成本；
    
- turn 再 bluff，一定要确保：
    
    - ① 对手的“到 turn 继续范围”里，弃牌比例仍然足够；
        
    - ② 你这手 bluff 有一定 equity 或极佳阻挡。
        

如果你心里很清楚：

> 这个人 turn 不怎么弃，而且结构又偏向他，  
> 那第二枪 bluff 基本是在送钱。

### 10.8.2 作为 value：我能从多少更差牌收多少钱？

价值 double barrel 的算账思路是：

1. **对手继续跟注的部分里，有多少是你真正赢的？**
    
    - 如果你打下去，别人只用比你好的牌跟，那这枪只是帮他筛走垃圾。
        
2. **你是否有足够多 worse hand 跟你两街？**
    
    - 如果你打 double 的时候，对手愿意用一堆更差的 top pair / 第二对 / draw 跟，那才是真的 value。
        

所以你在 turn 打 value，应该习惯问：

- “他用哪些更差的牌继续跟两枪？”
    
- “我打这个 size，他的那些更差牌真的会 call 吗？”
    

**很多微级别 double value 的问题是：**

- 尺寸错：打太大把 worse hand 都吓跑；
    
- 频率错：在 range shift 明显利好对手的 turn 仍然想 thin value 两街。
    

---

## 10.9 训练与复盘模板：把 double barrel 变成“可复训技能”

### 10.9.1 实战中即时练习（session 内）

给自己定两个小任务：

1. **每个 session 至少有 5 手 turn 前认真跑一遍 6 步模型：**
    
    - 分类 turn（blank / scare / range shift）；
        
    - 判断谁 capped / 谁有 nuts advantage；
        
    - 列出当前这手牌在自己范围的层级；
        
    - 给出“继续 or 放弃”的理由。
        
2. **刻意练习“关枪”：**
    
    - 找 2–3 手 flop 已经 cbet，但 turn 明显是 range shift 利好对手的牌；
        
    - 强迫自己选择 check / XF，而不是情绪 double。
        

### 10.9.2 复盘模板（每手牌事后写出来）

对任何到达 turn 的牌，复盘时写这几个点：

1. flop 上你选择了哪条线（小注 / 大注 / check / XR）？
    
2. turn 牌属于哪一类？（blank / scare / range shift）
    
3. 谁的范围被 capped？谁有 nuts advantage？
    
4. 你的当前牌属于强 value / 中 value / 强听牌 / 空气哪一类？
    
5. 你当时为什么 double / 为什么 check？
    
6. 用临界点粗算：
    
    - 你这枪 bluff 需要对手弃多少？他现实会弃多少？
        
    - 你这枪 value 指望对方用多少 worse hand 跟住？
        
7. 如果再来一次，你会调整成什么线？为什么？
    

### 10.9.3 长期训练方向

- 从数据库中筛选：**“Hero flop cbet，turn 选择 bet 或 check 的所有牌”**：
    
    - 分牌面类别，统计各类 turn 下自己的 double 频率；
        
    - 对比：
        
        - 是否在模板 A（高频 DB 板）double 太少；
            
        - 是否在模板 C（应当收手板）double 过多。
            
- 结合 solver / 标准路线：
    
    - 对于少数典型牌面（A 高干 / 高协面 / 中低连），
        
    - 做专门的 double barrel drill，
        
    - 让你的直觉与 GTO 越来越接近。
        

---

## 10.10 常见错误（至少 6 条）

1. **把 double barrel 当作“没 hit 就 bluff”的延长线**
    
    - 不看 turn 结构 / 范围变化，只要 flop 开了就机械二枪。
        
2. **在 BB nuts 明显提升的 turn 继续高频 double**
    
    - 典型：低端顺子 / 三同花补上，
        
    - 仍然无视对手范围 shift，继续“我代表强牌”，被强 value 轻松慢捞。
        
3. **对 fold too much 玩家不 double，对 call too much 玩家乱 double**
    
    - exploit 方向完全反：
        
        - 应该多打前者的二枪 bluff / value，
            
        - 少打后者的 bluff，多打 thin value。
            
4. **不肯在 turn 砍掉 flop bluff**
    
    - flop 用大量空气小注 cbet，
        
    - turn 明显没有好阻挡、没有好结构，仍硬着头皮再打一枪。
        
5. **强听牌 turn 不敢 double，错失 fold equity**
    
    - 只会 check-call 强 draw，
        
    - 放弃了 turn 给对手施压的主要机会，导致自己 equity realize 不足。
        
6. **所有 top pair 一律 double，不看 turn 牌面 / 对手类型**
    
    - 在模板 C / range shift 利好对手的 turn 上，
        
    - 顶对只是中 value，却被当成强 value 打 ，
        
    - 长期被极强 value 和 hidden nuts farm。
        

---

## 10.11 与其它章节的接口关系

- **与第 6 章（Flop 尺寸体系）**
    
    - flop 你选择小注 / 大注，决定了 turn double barrel 的自然延续线：
        
        - 小注树常与“turn 70% 合并”或“turn 极化 overbet”衔接；
            
        - flop 已极化大注的线，turn double barrel 会更偏 value-heavy。
            
- **与第 7 章（Check 体系）**
    
    - turn double barrel 决策与 XC / XR / XF 的选择直接绑定：
        
        - flop XC 的牌，到 turn 再面对 double barrel，
            
        - 你是否应该继续 XC / XR / XF？
            
    - 本章提供的是“何时二枪”的视角，
        
        - 第 7 章提供“对二枪怎么防守”的视角。
            
- **与第 8 章（Flop raise / donk）**
    
    - flop XR / raise 过的牌，到 turn 在结构上往往已经极化；
        
    - turn double barrel 更偏向：
        
        - nuts + combo draw 的极化持续，
            
        - 很多中段牌在 flop 已经被筛掉。
            
- **与下一章第 11 章（Turn overbet）**
    
    - 本章假设 turn 主要使用 2/3–70% 合理尺寸；
        
    - 第 11 章会专门处理：
        
        - 什么时候要把第二枪直接放大成 overbet / 150% pot；
            
        - 数学上 overbet 所需弃牌率、bluff:value 结构；
            
        - 微级别中 overbet 的 exploit 应用。
            

---

## 《迭代日志》（第 10 章）

【来源】

- 《全范围 C-Bet 策略指南 I/II》
    
    - 用统一的 flop 30% 小注 / turn 70% cbet 模型，展示了不同牌面下 IP turn double barrel 频率与应当继续的牌型类别；
        
    - 为本章构建 “模板 A/B/C 牌面” 提供了 GTO 基线直觉。
        
- 《超池下注指南》
    
    - 在 BB 范围被 capped 的结构中，展示了 turn 极化二次开火、甚至 overbet 的思路；
        
    - 说明在 blank turn 且进攻方保留 nuts 优势时，高频 double + 大尺⼨是合理的。
        
- 《千算标准行动路线 / 行动路线》
    
    - 用简化规则划分出：
        
        - 哪些 flop hit 情况下 turn “必须二枪”；
            
        - 哪些结构中 turn 应该自动收手（特别是利好防守方的 range shift）；
            
    - 为本章的“强 value / 中 value / 强听牌 / 空气”的 double 策略提供了实战模板。
        
- 第 9 章 Poker OS v2.0 文稿
    
    - 提供“权益压缩 / 范围极化 / 阻挡 / 临界点”的 turn 框架，本章在此基础上专门收缩到 double barrel 场景。
        

【结论】

- 本章把 Turn Double Barrel 从“第二枪本能动作”变成一个结构化决策：
    
    - 在牌面层面，用模板 A/B/C 区分高频 double / 混频 / auto-check 牌面；
        
    - 在牌型层面，明确强 value / 中 value / 强听牌 / 空气在不同牌面下的标准去留；
        
    - 在数学层面，用必要弃牌率 / 必要胜率这两个临界点来约束你的 barrel / call；
        
    - 在训练层面，用高密度 checklist 和复盘模板，帮助你让 double barrel 变成可重复训练的技能，而不是随机发挥。
        

【改动点】

- 相比 v1.0 对 double barrel 的零散描述，这一版：
    
    - 严格对齐你给的目录标题与来源（C-Bet I/II + 超池 + 千算行动路线）；
        
    - 把第 9 章的 turn 抽象框架压缩成 double barrel 专用的 6 步高密度模型；
        
    - 明确给出三类牌面模板（自动二枪板 / 混频板 / 收手板）和牌型分配规则；
        
    - 增加了训练 / 复盘建议，使之在项目中可持续 drill。
        

【待补充】

- 后续可以在附录中增加几个具体 solver 牌例：
    
    - 指定 flop/turn/行动历史，
        
    - 展示 IP GTO double barrel 频率与牌型分布，
        
    - 并对比“玩家池常见打法”的偏差。
        
- 也可以配合你的数据库，选一批“Hero flop cbet → turn 到达的牌”，按本章模型分类，看看你当前 double barrel 偏向哪种极端（over-DB / under-DB）。
    

【下一步建议】

- 按目录，下一章写 **第 11 章｜Turn 超池下注（Overbet）：数学与结构的完整重建**：
    
    - 在本章“普通 double barrel”基础上，
        
    - 专门拆解：
        
        - 什么时候用 150% pot overbet 替代 70% pot；
            
        - overbet 下 bluff:value 比例、所需弃牌率与 nuts advantage 的关系；
            
        - 在微级别针对“怕钱玩家”的 overbet exploit 策略。