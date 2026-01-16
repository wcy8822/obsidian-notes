**上一章：** 第 6 章（Flop 下注尺寸与极化体系：小注 / 大注 / 极化 / merged）  
**本 章：** 第 7 章（Check 体系：XC / XF / XR 的结构化应用）  
**下一章计划：** 第 8 章（Turn 体系：blank / scare card & 小注树 → 超池树的转换）

---

## 7.1 一句话结论

**Check 不是“没牌才过”，而是你用 XC / XF / XR 三个动作，把整条范围重新分配和再极化的核心工具：谁把 check 体系玩明白，谁就真正有了“范围感”和“河牌 EV 控制权”。**

---

## 7.2 章节定位：为什么专门要一章讲 Check？

上一章我们解决的是一个问题：

> 我有范围优势 / nuts 优势（或没有），那我 Flop 应该用多大的下注尺寸？

但你会在 solver 和玩家池数据里发现一件很刺眼的事：

- 真正的高赢率玩家，Flop 出现的频率最高的动作，不是 bet，而是 **check**：
    
    - BB vs BTN / CO 的 OOP，在大量 SRP 中执行接近 100% check 作为基础策略；
        
    - IP 在不少牌面（EP vs BB 的 A♥4♣2♥）GTO 甚至建议接近「全范围 check-back」。
        

本章的目标，是把「Check 体系」拆成三个可执行模块：

1. **XC（check-call）：**
    
    - 什么时候应该用 XC 承接对手的极化范围，把底池控制在一个你能承受的 SPR？
        
    - 河牌“抓诈”本质上都是 XC 的延伸，《河牌抓诈进阶指南》里那一整套选抓诈牌的方法，都是 XC 逻辑。
        
2. **XF（check-fold）：**
    
    - 你要允许多少比例的范围在某一街“直接放弃 EV”？
        
    - 放弃到什么程度属于健康 MDF（最低防守频率），什么程度属于直接自残？
        
3. **XR（check-raise）：**
    
    - 哪些牌属于 XR 的“价值+诈唬核心模板”？
        
    - GTO+GO 在 A♠4♦2♠、A♥9♥2♣ 等牌面上给了非常具体的 XR 范围，我们要把这些简化成「XR 清单」。
        

**本章在全书中的角色：**

- 它是 Flop 系统的“另一半”：上一章讲「什么时候打、打多大」，这一章讲「什么时候不打、check 后用哪条线继续游戏」。
    
- 它也是 River 诈唬 / 抓诈章节的前置：河牌 XC/XR 是否赚钱，很大程度由前面几街的 check 结构决定。
    

---

## 7.3 核心概念：Check 体系三件事

### 7.3.1 XC：用最便宜的价格买“继续游戏权”

XC 的功能：

1. **防止被 exploit：**
    
    - 当对手用极化范围下注（两极：强 value + air），你如果只 XF、不 XC，自己的范围会被压缩到太靠上的区间，对方可以无限 bluff。
        
2. **控制底池：**
    
    - 很多中等牌（顶对弱 kicker、overpair 但牌面非常 dynamic）用 bet 会把自己“推上树”，XC 让你在 SPR 可控的情况下，继续看 turn / river。
        
3. **为后续 XR / lead 做准备：**
    
    - XC–XR（如 BB XC flop，turn scare card XR）在 GTO+GO 的不少牌面都存在。
        

《河牌抓诈进阶指南》中，把“抓诈牌”定义为：领先对手 bluff，落后对手 value 的牌，用来去 XC 对手极化大注；本质就是在河牌上执行一次极端的 **XC**。

### 7.3.2 XF：承认一部分范围没有未来

XF 的功能很简单：**承认这条线的 EV 已经接近 0 或为负**。

- 任何健康的 GTO 策略都会含有大量 XF：
    
    - 在 A♠4♦2♠ 上，BB vs BTN 的 F/C/R 比例仍然包含 40% 左右的 fold；
        
- 问题在于：
    
    - 玩家池要么 XF 过多（OOP 面对小注轻易弃牌）；
        
    - 要么 XF 过少（面对大注死不弃）。
        

我们要做的，是把 XF 放到一个 **“既不被 exploit，又不死撑亏钱”** 的区间。

### 7.3.3 XR：用极化把底池“重新抢回来”

XR 是 check 体系里最具攻击性的一条线，也是玩家池做得最差的一条线：

- GTO+GO 的简化策略里，XR 总是极化：
    
    - 强 value：set / 两对 / nuts 及其近邻；
        
    - bluff：最强听牌（CD、FD+SD、带好 blocker 的 gutshot）。
        
- 实战里，大多数人：
    
    - XR 几乎只拿到 nuts 才做；
        
    - 听牌只跟不加；
        
    - 结果：IP 小注 cbet 没有任何成本，范围从 flop 就开始被“压扁”。
        

我们的目标，是用几个模板，把 XR 做成你熟练、自然的一条线，而不是“偶尔暴起一次”。

---

## 7.4 GTO 基线：各角色的标准 Check 结构

### 7.4.1 OOP 在 SRP：BB 的“100% check 基准策略”

在《不让对手看透你范围的技巧》里，Lillian 直接给了一个非常典型的例子：

> BTN open，BB call 的 SRP，**BB 在 flop 执行 100% 过牌策略**。

这是一种极其简单但 GTO 友好的策略：

- OOP 在多数牌面很难构建多 size 的 lead 线；
    
- 统一用 check，把所有行动权交回 IP，然后在 **vs Cbet** 这一节点做 XC/XF/XR 的范围拆分；
    
- 在 GTO+GO 的 SRP BTN vs BB 报告中，我们也看到：
    
    - 所有牌面都以 BB check 开局，然后再拆 BB vs Cbet 和 BTN vs XR。
        

**结论：**  
在你还没有把 donk 体系练熟之前，“SRP OOP（BB）= 翻牌 100% check 起手”是非常可行、且接近 GTO 的 baseline。

---

### 7.4.2 IP 在 SRP：什么时候「应该 check-back」？

GTO+GO 的 EP vs BB 合集中，有一个非常重要的结论：

- Board = A♥4♣2♥，EP vs BB；
    
- IP（EP）虽然有 equity 优势（58% vs 42%），但范围里 2Pair+ 和稳健 FD 占比不高，主要是强一对；
    
- Solver 建议：**Round 前 75% check，Round 后高达 94% check，实战可以近似全范围 check-back**。
    

这说明：

1. **“我是翻前进攻方” ≠ “我必须 cbet”**；
    
2. 当你 equity 领先但 **nuts 不明显领先**、而且自己多是“强一对”时，GTO 倾向用 check 来保护范围 + 控制底池。
    

类似的结构在 BTN vs BB 的 A♠4♦2♠ 牌面也出现：

- IP 一部分范围（带♦的 A2o、无♠的中 pocket、部分 KQ 等）被分配到 check-back 用来保护；
    
- 同样是“强但不极端”的牌被放到 check-range。
    

**模板：**

> IP 在 Flop 有轻微 equity 优势但 nuts 优势不明显、牌面较 low / dynamic 时——  
> 「高频 check-back + 少量 value/保护型 bet」是 GTO 方案，而不是 autopilot cbet。

---

### 7.4.3 XR 在 SRP：GTO+GO 给的“IP vs OP XR 解读”

看两个典型的 IP vs OP XR 截图：

1. **BTN vs BB，Board = A♠4♦2♠（IP 面对 BB flop XR）**
    

- IP vs OP XR：R/C/F=0 / 58(55) / 42(33)；
    
- 简化 IP Call Range：**所有 Pair+ + 所有 GT+ 听牌**；
    
- 结论：
    
    - OOP XR 极化（set + straight + CD 等）；
        
    - IP 必须用非常宽的 defend（所有对子 + 够强的 draw）来防止被 XR 过度剥削。
        

2. **EP vs BB，Board = A♥9♥2♣，IP 面对 XR**
    

- IP vs OP XR：R/C/F=0 / 56(50) / 44(19)；
    
- Call Range：2Pair+、AQ+、9x 等成牌；
    

这些数据告诉你三个 GTO 事实：

- OOP 的 XR 不是“只拿 nuts”，是有一整套极化 bluff 配置的；
    
- IP 面对 XR 的 XC（call XR）是非常宽的，否则 XR EV 会炸裂；
    
- 如果你现实里 XR 只拿 nuts，对手 IP Cbet 理论上可以无限 over-bluff，你的 XC 也会被迫缩到极窄。
    

---

### 7.4.4 3BP / 4BP 中的 Check 结构：IP vs OP Check

以 3BP BTN vs BB, Board = T♥4♣2♦ 为例（3BP 合集）：

- OP Cbet 2/3 | Check=71/29；
    
- IP vs OP Check：B/X=50(57)/50(57)；
    
- 简化 IP Bet Range：Set 44/22、JJ overpair、TP、55、4x、33、部分非同花 2 overcard；
    
- 简化 IP Check Range：Set TT、66-99、部分同花 2 overcard。
    

意思是：

- 在 3bet pot，IP 面对 OOP check，不是“中了就全 bet，没中就 check”；
    
- Solver 会把一部分强牌（Set TT、部分 overpair）刻意留在 check 里，保证 IP check-back 线不会被一眼看穿；
    
- 这也是后来河牌抓诈 / bluffcatch 的前提：你 check-back 的手，不必全是 garbage。
    

---

## 7.5 玩家池典型错误（Check 体系方向）

结合上面 PDF + 实战经验，玩家池在 XC / XF / XR 上最常见的 5 个 Leak：

1. **Check = 我没牌（check-range 被 capping 到底部）**
    
    - IP：只拿空气 or marginal 才 check-back，所有“像样的牌”都 cbet；
        
    - OOP：只拿完全 air XF，一有 equity 就直接 lead；
        
    - 结果：任何行动（bet / check）都在裸奔地暴露范围结构。
        
2. **XR 几乎只拿 nuts，从不拿听牌**
    
    - GTO+GO 里 XR 的 bluff 端是 CD / FD+SD / 有 blocker 的弱牌组合；
        
    - 玩家池 XR 几乎等同「我有 nuts，请你弃牌」→ IP 可以放心 fold 大量 bluff catch。
        
3. **面对小注，XF 过多；面对大注，XF 过少**
    
    - 小注（1/3） vs Flop：理论上 OOP 应该 defend ≥67% 范围，现实很多人 FVP 接近 50% 甚至更低；
        
    - 河牌 vs 大注（pot / 1.5x）：玩家池普遍成为“hero call 机器”，特别是 top pair。
        
4. **不会用 XC 做抓诈，只会“看牌面绝对牌力”**
    
    - 《河牌抓诈进阶指南》和《进阶指南 (2)》都强调：
        
        - 优秀的 bluffcatch 不是绝对牌力最强，而是 **block value 少、block bluff 少** 的牌
            
    - 玩家池：拿 AA/KK 乱抓诈，拿中对 / 弱 top pair 放弃——完全反着来。
        
5. **IP 对 OOP check 的 stab 意愿太低**
    
    - GTO+GO 的「IP vs OP Check」页，很多牌面都是 IP 以 50–70% 频率 stab；
        
    - 玩家池：看到 OOP check 就自动 check-back，错过大量“free money stab”机会。
        

这一章要做的，就是把这 5 个点全部拆成可训练的决策模板。

---

## 7.6 结构化决策树：XC / XF / XR 怎么分配？

### 7.6.1 OOP vs Cbet：从范围顶/腰/底开始切

面对 IP 小注 cbet，OOP 可以用一个非常简单的三层结构来分配 XC/XF/XR：

1. **范围顶端（nuts+ / near nuts）→ XR 为主，部分 XC 混频**
    
    - 典型：set / 两对 / nut straight；
        
    - 部分强牌混入 XC，避免 XR 线被过度 caps。
        
2. **范围腰部（top pair / overpair / 含高权益听牌）→ XC 为主，少量 XR / XF**
    
    - XC：绝大多数强一对 + 稳健 draw；
        
    - XR：少量带 nuts potential 的听牌（CD、FD+SD）；
        
    - XF：边缘中对、无后门的 bottom pair。
        
3. **范围底端（空气 / 边缘听牌）→ XF 为主，选一截有 blocker 的组合进 XR-bluff**
    
    - 选择标准：
        
        - 阻挡对手部分 value；
            
        - 不阻挡对手 bluff；
            
        - 有一定 backdoor 机会。
            

GTO+GO 在 A♠4♦2♠、A♥9♥2♣ 等牌面上的 XR 行为，本质就是在做这一层切割，只是分得更细。

---

### 7.6.2 IP vs 自己的 Miss Cbet：decide stab or check-back

当 OOP check 给你，你可以按这样的流程来决定是 stab 还是 check-back：

1. **这块牌面谁有范围 / nuts 优势？**
    
    - 如果优势明显在你这边（A♠A♦4♣ / K♠Q♦T♠），GTO 倾向：IP 高频 stab、甚至全范围 stab；
        
    - 如果 nuts 更偏向 OOP（7♠5♦4♠ / Q♣7♠7♦），GTO 则是：IP 小频率 stab + 大量 check-back。
        
2. **我的这手牌处于范围的哪一截？**
    
    - 顶端成牌：更偏向下注（尤其在你有范围优势时）；
        
    - 腰部成牌：取决于牌面 dynamic；
        
    - 空气：有后门权益 / blocker → 可以 stab；否则直接 check。
        
3. **我是否需要在 check-range 留强牌？**
    
    - 如果你在 KQTs / Q77 这类面上把所有强牌都打出去，你 check-range 就会被对手随便 stab；
        
    - GTO+GO 很多「IP vs OP Check」页都刻意放入 set / top set 在 IP 的 check-range 中：例如 T♥4♣2♦ 上 IP check 中有 Set TT。
        

---

### 7.6.3 River：XC vs XF vs XR 的特别逻辑

河牌是 check 体系的终局：

- **XC**：真正意义上的“抓诈动作”，参考《河牌抓诈进阶指南》的“三原则”：
    
    1. 你能赢对手 bluff 范围的一大部分；
        
    2. 不要过多阻挡对手 bluff；
        
    3. 尽量阻挡对手 value。
        
- **XF**：当对手 value 很多、bluff 很少时，哪怕你有“不错牌力”，仍然必须 XF。
    
- **XR（all-in / raise）：** 极度极化动作：
    
    - 只能由 nuts / 极强价值 + 极少数 blocker bluff 组合；
        
    - 玩家池整体 bluff 严重不足，这条线往往更偏 value-only exploit。
        

河牌 XC/XR 的详细内容，会在后面 River 章节展开，这里重点是：**从 flop 开始，你就要为河牌的 XC/XR 预留合适的候选牌**，而不是一路混乱到河牌才“拍脑袋抓诈”。

---

## 7.7 数学验证区：XC / XF / XR 背后的算账

### 7.7.1 面对下注时 XF 的下限：简单 MDF（最低防守频率）

当对手用 size = S（相对底池 P）下注时，如果你完全不考虑反击能力，理论上为了不被无限 bluff，你需要 defend 的频率是：

> MDF ≈ P / (P + S)

例如：

- 底池 100，对手下注 50（1/2 pot） → MDF = 100 / (100+50) ≈ 67%；
    
- 底池 100，对手下注 100（pot） → MDF = 100 / 200 = 50%。
    

这意味着：

- 面对 1/2 pot，小注 cbet，你如果 XF > 33%，对手 bluff 的 EV 会被放大；
    
- 面对 pot bet，如果你 XF > 50%，对手理论上可以用任意两张牌盈利 bluff。
    

所以：

- **XF 不是越多越好，除非你确信对手 bluff 严重不足**（河牌抓诈指南里提到的“NL25z–100z 许多弱 reg 河牌 pot 注 bluff 严重不足”就是 exploit XF 的例子）。
    

### 7.7.2 XR 的 bluff : value 比例

当你 XR 到一个 size S（相对底池 P），给对手的 pot odds 也是：

> 对手需要胜率 = S / (P + 2S)（因为 XR 后底池 = P + 2S）

在极化范围情况下：

- 如果你希望对手 indifferent（无差别），你能选择的 bluff:value 比例大致 = 对手需要放弃的频率。
    
- 实战你不需要记公式，只要知道：
    
    - XR 尺寸越大，你在 GTO 下可以放的 bluff 就越多；
        
    - 但玩家池 XR-bluff 远远少于 GTO，所以大多数情况下你 XR 线可以 **偏 value-heavy** 而不被 exploit。
        

### 7.7.3 XC 抓诈：用赔率反推“我需要赢多少”

河牌面对对手 bet S（相对底池 P），你 call 的胜率门槛：

> 所需胜率 ≈ S / (P + S)

配合《进阶指南 (2)》的观点：

- 如果你判断对手 value:bluff 比例接近平衡，那一手“抓诈牌”在理论上 EV 接近 0；
    
- exploit 上，你要做的是：
    
    - 对 bluff 明显不足的对手 → 减少 XC，更多 XF；
        
    - 对 bluff 明显过多的对手 → 增加 XC，甚至用更 marginal 的 bluffcatch。
        

---

## 7.8 高频场景模板（3 个）

### 场景 1：SRP EP vs BB，A♥4♣2♥ —— IP 全范围 check-back 模板

- GTO+GO 报告：
    
    - Equity：EP 58% vs BB 42%；
        
    - 但范围中 2Pair+ 和有稳健权益的 FD 占比没有明显优势；
        
    - Solver：前期 75% check，round 简化后 ≈94% check，实战可全范围 check-back。
        

**实战模板（IP）：**

- 默认：Flop 100% check-back；
    
- Turn：
    
    - 砖牌（2–9 无花/顺）：对方 lead 再按牌力 / 阶段作 XC/XF；
        
    - scare card（♥、A/K/Q 等）：再开启极化 bet 树。
        

### 场景 2：SRP BTN vs BB，A♠4♦2♠ —— OOP XR & IP vs XR

- IP Cbet 1/3，Check=45/55；IP check-range 里保留部分 A2♦、KK-TT 等强牌。
    
- OOP vs Cbet：F/C/R=42/49/9；XR 强 value（set / straight）+ CD 为主；
    
- IP vs XR：Call range=所有 pair+ + GT+ 听牌。
    

**实战模板：**

- OOP：
    
    - XR：set 22 / 44、5♠3♠ 这类 CD；
        
    - XC：A4、A5s–A3s、带♠的中 pocket；
        
    - XF：无 backdoor 的空气。
        
- IP：
    
    - 面对 XR 要用所有顶对 + 合理听牌 defend，不能只用 2Pair+ 才 call，否则被 exploit。
        

### 场景 3：3BP BTN vs BB，T♥4♣2♦ —— IP vs OP Check

- OP Cbet 2/3≈71%，Check≈29%；
    
- IP vs OP Check：Bet≈50%，Check≈50%；
    
- Bet range：set 44/22、JJ、TP、55、4x、33、部分 2 overcard；
    
- Check range：set TT、66–99、同花 2 overcard。
    

**实战模板（IP）：**

- 面对 OOP check：
    
    - 用一半范围 stab，另一半“保护性 check-back”；
        
    - 确保你的 check-back 里永远有一部分强牌（这里是 TT、mid pocket），让对手 turn 不能随便 over-bluff 你的 check line。
        

---

## 7.9 个人提升 & 训练建议

短期（下一次上桌就能用）：

1. **OOP：固定一条「SRP BB 100% check 开局」策略**
    
    - 所有 SRP BB vs BTN/CO，Flop 一律 check；
        
    - 把注意力全部放在 vs cbet 的 XC/XF/XR 分配。
        
2. **IP：强制每局都问自己一次——“我 check-back 的牌里有没有强牌？”**
    
    - 如果答案总是“没有”，强行把一部分中强牌（top pair / overpair）混进 check-back。
        

中期训练（1–3 个月）：

1. 用 GTO+GO 的「IP vs OP XR / IP vs OP Check」页，做固定牌面 drill：
    
    - A♠4♦2♠、A♥9♥2♣、Q♣7♠7♦、7♠5♦4♠ 等；
        
    - 记住每个牌面上：
        
        - 哪些牌进 XR；
            
        - 哪些牌进 XC；
            
        - 哪些牌被迫 XF。
            
2. 河牌：用《河牌抓诈进阶指南》做抓诈 XC 的专门训练：
    
    - 对每个牌例，先不看作者结论，自己列 value / bluff 范围，再选抓诈牌。
        

长期方向：

- 把「Check 体系」升级成你的 **风格标签**：
    
    - 你的 check 不再等于“我没牌”，而是：
        
        - 有些 check 里藏着 nuts；
            
        - 有些 check 是为了抢回 XR 的主动；
            
        - 有些 check 是为了在 turn/river 打出一条你自己的 exploit 线。
            

---

## 7.10 本章复盘模板（给你用）

以后你复盘任何一手牌，关于 Check 体系，可以固定问这 7 个问题：

1. 我在那一街选择了 check？当时是 IP 还是 OOP？
    
2. 这块牌面上，谁有范围 / nuts 优势？（对照 GTO+GO 特征牌面）
    
3. 我的 check 属于：为了控制底池？保护范围？还是纯粹不知道该下注还是弃牌？
    
4. 如果我是 OOP，对手下注时，我这手牌更应该走 XC、XF 还是 XR？
    
5. 如果我是 IP，对手 check 时，我 stab 的频率是否太低 / 太高？我是否在 check-back 里留了足够强度？
    
6. 从 MDF / pot odds 角度看，我的 XF 是否明显过多或过少？
    
7. 下一次遇到完全同构的 spot，我准备强制执行哪条默认线？
    

---

## 7.11 《迭代日志》

【来源】

- 《1.不让对手看透你范围的技巧》：
    
    - BB 在 SRP vs BTN/CO 的 flop 100% check 策略，用于说明 OOP range-check 的 GTO 友好性与简化作用；
        
    - 关于“混入对手意料之外的行动”防止范围被看透的讨论，为 check-range 中混入强牌提供理论动机。
        
- 《GTO+GO SRP BTN vs BB 合集》：
    
    - A♠A♦4♣、A♠4♦2♠、K♠Q♦T♠、Q♣7♠7♦ 等牌面中 IP vs OP Check / IP vs OP XR / OP vs Cbet 的频率和简化范围，为 XC/XF/XR 模板提供具体结构。
        
- 《GTO+GO SRP EP vs BB 合集》：
    
    - A♥4♣2♥ 牌面上 IP 虽有 equity 优势但 GTO 建议高频 check、实战甚至可以全范围 check-back 的示例，是 IP check-back 模板的核心依据。
        
- 《5.GTO+GO - 3BP BTN vs BB 合集》：
    
    - T♥4♣2♦ 牌面 IP vs OP Check 中，IP 以 50/50 频率 bet/check，并在 check-range 中保留 set TT、mid pocket 的策略，用于说明“check-range 必须有强牌”。
        
- 《6.河牌抓诈进阶指南》：
    
    - 抓诈三原则（领先 bluff、尽量不阻挡 bluff、阻挡 value）、玩家池在河牌大注 bluff 明显不足的现象，用于构建河牌 XC/XF 的 exploit 策略。
        
- 《1.+进阶指南 (2)》：
    
    - 关于“抓诈牌通常 EV 接近不亏不盈”“选择抓诈牌要看阻挡效果”的分析，为 XC 抓诈的数学和策略逻辑提供支撑。
        
- 《Poker_OS_prompt.md》：
    
    - 提供章节结构模板（一句话结论 / GTO 基线 / 玩家池偏差 / 模板 / 训练 / 迭代日志），本章严格按该模板组织。
        

【结论】

- 本章把 Check 从“默认动作”拆成了一个完整体系：
    
    - XC = 用最低成本买继续游戏权 + 抓诈；
        
    - XF = 在合适的频率上承认放弃 EV，以避免被 exploit；
        
    - XR = 用极化范围把底池在你处于结构优势的牌面上重新抢回来。
        
- 通过 GTO+GO 的具体牌面 + 河牌抓诈/进阶指南，本章给出了：
    
    - OOP vs Cbet 的 XC/XF/XR 三层切割模板；
        
    - IP vs OOP Check 的 stab vs check-back 决策树；
        
    - 河牌 XC/XR 的基础框架。
        

【改动点】

- 相比 v1.0 / 旧版本中对 Check 的零散描述，本章：
    
    - 明确了「Check 体系」在整本 OS 中的章节定位（承接 Flop 尺寸、连接 Turn/ River）；
        
    - 用多个 GTO+GO 牌面（A4x、A9x、T42、Q77）具体展示了 check-range 如何保留强牌、XR 如何配置 bluff；
        
    - 把河牌抓诈的理论嵌入 XC 逻辑，而不是单独挂在 River 章节。
        

【待补充】

- 可以进一步为每个特征牌面制作「Check 速查卡」，标明：
    
    - OOP / IP 的 Cbet vs Check 基线；
        
    - XR 的 value / bluff 清单；
        
    - IP vs XR 的 defend 范围。
        
- 在 Exploit 专题中，可以单独写一节「针对不 XR / 不 XC / 过度 XF 玩家」的 exploit 流程图。
    

【下一步建议】

- **下一章（第 8 章）建议写 Turn 体系**：
    
    - 重点放在「什么时候从 flop 小注树切到 turn 超池树」，结合《超池下注指南》的 turn 牌例；
        
    - 同时把本章的 Check 体系延伸到 turn：
        
        - turn XC / XR 的角色；
            
        - blank vs scare card；
            
        - 如何在 turn 规划河牌 bluff / bluffcatch 候选。
            
- 你这边如果方便，可以下一轮直接带 2–3 手“Flop 打了小注 / check-back，Turn 犹豫要不要大注 / 超池”的实战牌，我们用刚写完的第 6/7/8 章思路一起跑一次完整复盘。