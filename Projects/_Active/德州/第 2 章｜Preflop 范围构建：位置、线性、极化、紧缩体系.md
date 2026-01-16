**一句话结论：**  
Preflop 范围不是「这一手能不能开」的问题，而是「整套范围是不是线性稳健、能扛住翻后压力、还能让对手在结构上难受」的问题——谁在这里把范围结构打明白，谁就从翻牌前开始领先一个维度。

---

# 第 2 章｜Preflop 范围构建：位置、线性、极化、紧缩体系

---

## 1. 章节目的：你学完这一章，具体要多会什么？

这一章有三个硬目标，不达成就算白看：

1. 把「线性 / 极化 / 紧缩」从抽象概念，变成你对每个位置的**具体范围标签**。
    
2. 让你知道：
    
    - UTG/MP/CO/BTN/SB/BB 六个位置，各自的 preflop 范围应该**长什么形状**；
        
    - 这些形状翻到 flop 上，会导出怎样的 GTO 倾向（谁更爱 cbet、谁常被 capped）。
        
3. 针对微级别 / 线下松散池，给出一套**可执行的 exploit 版开局与 3bet/4bet 结构**，而不是 solver 式记频率。
    

换句话说：这一章结束后，你看到任何一手翻前行动，先习惯性问自己——

> “这条线的范围结构应该是线性的、极化的，还是已经被封顶了？”

这才是专业玩家在 preflop 的视角。

---

## 2. GTO 基线：Preflop 的三件事

基于 Poker OS v1.0/2.0 的总纲：Preflop 的工作只有三件：

1. 构建各位置**稳定、线性且可防守的范围**，避免翻后被动挨打。
    
2. 用合理的 3bet/4bet 结构，抢占范围优势和位置优势（谁拿「范围优势 + 位置优势」，谁就是故事的主角）。
    
3. 控制决策复杂度：你的级别不需要完美 GTO，只需要「明显 +EV 且可执行」的线。
    

---

### 2.1 范围类型在 Preflop 的具体含义

在第 1 章我们抽象过范围结构，这里把它压进 preflop 语境：

1. **线性范围（Linear）**
    
    - 从最强牌往下，连续取一段。
        
    - 典型：
        
        - UTG/MP 的 open；
            
        - SB/BB vs BTN 的线性 3bet（QQ–TT、AK–AQ、AJs–ATs 等）。
            
    - 逻辑：
        
        - 你希望「范围整体比对手好」，而不是靠极端 bluff 做 EV。
            
2. **极化范围（Polarized）**
    
    - 顶部强牌 + 底端 bluff，中间一截直接弃牌。
        
    - 典型：
        
        - BTN 对抗 CO/MP 的 3bet；
            
        - 再往上的 4bet 体系：QQ+/AK + A5s/A4s 这种「高权益 bluff」。
            
3. **紧缩/封顶范围（Condensed/Capped）**
    
    - 顶端强牌很少，中等牌一堆（TT–88、AQ/AJ、KQ 之类），成了「不好 fold 又不好打大底池」的区域。
        
    - 典型：
        
        - 各种冷跟范围（flat），尤其是 UTG/MP open 后 CO/BTN 只 call；
            
        - 被 3bet 后只 flat 而不 4bet 的范围，在很多牌面上就被 solver 当作 capped。
            

> 记住一个实用翻译：
> 
> - **线性 =「整体强，吃死你」**
>     
> - **极化 =「顶端强 + 底端 bluff」**
>     
> - **紧缩/封顶 =「看起来还行，但不敢打大底池」**
>     

后面 Exploit 很多就是「让对手范围变紧缩，而自己保持极化/线性」。

---

## 3. 六个位置的 GTO 结构理解（不背牌谱，背结构）

基于 v1.0/v2.0 的 Preflop 总纲，对六个位置做结构拆解：

---

### 3.1 UTG：全桌最紧、最线性的位置

- GTO 大致 open：12–15% 左右；实战建议区间同样在 12–15%。
    
- **价值主干**：
    
    - 大对：AA–TT（部分 99–88）
        
    - 高牌：AKs–AQs、AKo、少量 AQo
        
    - suited broadway：KQs、QJs，T9s、98s 少量
        

**结构结论：**

- UTG open 是非常典型的**线性范围**：
    
    - 几乎没有垃圾牌，也几乎没有为了「花活」加入的 bluff 牌。
        
- 面对 3bet：继续范围必须极强，UTG vs 3bet 是一个**极化的继续结构**：
    
    - 4bet for value：AA–QQ、AKs/AKo；
        
    - JJ–TT/AQs 等大多 fold 或极少数平跟，微级别甚至直接砍掉 4bet bluff。
        

> 翻后含义：
> 
> - UTG 的「中段牌」其实已经很强（TT、AQ），但因为位置差，一旦被 3bet 平跟进去，经常被 GTO 视作「勉强防守」，翻后很难打。
>     
> - 这就是为什么 v1.0 推荐：UTG 对大 3bet，除了 QQ+/AK 以外多数都该弃。
>     

---

### 3.2 MP：UTG 的自然扩展

- 定位：**UTG 范围的自然扩展，略宽但仍线性为主。**
    
- 结构：
    
    - 在 UTG 的基础上，加：
        
        - 更多同花 Ax（AJs–ATs、A5s–A2s）；
            
        - 更多同花连子（T9s–87s）；
            
        - 少量 KQo。
            

**关键点：**

- GTO 会让 MP open 略偏松，但 OS 建议：
    
    - 不熟 Flop/Turn 时，可以「用近似 UTG 范围 + 少量 AJs/ATs/T9s/98s」即可，控制总 open 在 15–18%。
        
- vs 3bet 时，MP 比 UTG 多一点继续空间，但本质仍是「**宁愿 tight，不要进一堆难打局**」。
    

---

### 3.3 CO：从正常范围到偷盲范围的过渡位

- v1.0/v2.0 的定位：**CO 是从「标准范围」向「偷盲范围」过渡的关键位置。**
    
- GTO：26–30% open；
    
- 实战建议：20–24% 即足够有压制力。
    

**结构层次：**

1. 核心价值层：
    
    - AA–66、AK–AT（s/o）、KQs–KJs、QJs、JTs。
        
2. 扩展层：
    
    - suited：A9s–A2s、KTs–K9s、QTs–Q9s、T9s–65s（部分）；
        
    - offsuit：KQo、部分 KJo/QJo。
        

**结构结论：**

- CO 开始明显向**更宽的线性范围 + 部分 exploit 式宽牌**过渡。
    
- Solver 理论上可以在 A5s–A2s 等做 4bet bluff；v1.0/2.0 明确建议微级别可以**直接删掉很多花活组合**，保证翻后可打性。
    

---

### 3.4 BTN：全桌最宽、EV 最高

- GTO：45–55% open；
    
- 实战建议：35–45% 足够。
    

**结构分层（v1.0/v2.0 一致）：**

1. 核心价值层：
    
    - AA–22、所有 AK–AT（s/o）、所有 suited Ax、KQs/KJs/QJs/JTs/T9s。
        
2. 扩展偷盲层：
    
    - suited：K9s–K8s、Q9s–Q8s、J9s–J8s、T8s–54s；
        
    - offsuit：KQo/QJo/JTo 等。
        

**关键结构理解：**

- BTN open 范围**本身是线性的，但靠近扩展层时，开始承担更多 exploit 任务**：
    
    - 这些牌翻前略亏或接近盈亏平衡，但因为你有位置，还能吃到 SB/BB 的 postflop 错误，所以整体 EV 变正。
        
- BTN vs SB/BB 3bet：
    
    - 理论：用 QQ+/AK 做 4bet value，辅以 A5s/A4s/K5s/Q5s 这类极化 4bet bluff；
        
    - 微级别：大量对手 3bet 不够、3bet 之后也不 fold → 建议砍掉大部分 4bet bluff，几乎只保留 QQ+/AK 做 value 4bet。
        

> 范围解读角度：
> 
> - BTN open 本身是「宽线性」，但其 4bet 结构是典型**极化**；
>     
> - BB/SB vs BTN 3bet 往往是**线性**，这在翻后直接体现为：SB/BB 在某些 A-high 干面有明显范围优势，GTO+GO 明确给出 SB 全范围小注 cbet 模板。
>     

---

### 3.5 SB：最烂位置，翻后几乎永远 OOP

- v2.0：**SB 无人入池，理论是 raise-only，open ~35–45%；微级别建议收紧一点，删掉难打组合。**
    

**结构要点：**

- SB 无人入池：
    
    - 强牌：AA–88、AK–AT（s/o）、KQ/KJ/QJ suited 作为主干；
        
    - 大量 marginal hand 在微级别干脆 fold，避免「SB limp 多人烂局」。
        
- SB vs BTN open：
    
    - 理论：线性 3bet（QQ–TT、AK–AQ、AJs–ATs、KQs）；
        
    - Exploit：采用「3bet or fold」策略，几乎不冷跟。
        

> 范围解读：
> 
> - SB 如果平跟太多，会形成大量「紧缩 + 封顶」范围，翻后很难保护。
>     
> - SB 用线性 3bet，则进入翻后时反而是**范围更强的一方**，哪怕位置在劣势。
>     

---

### 3.6 BB：翻前防守核心

- BB 有最好的 pot odds，也有最多烂牌——防守责任最大。
    
- v2.0 的观点：你直觉上 defend 的范围通常**偏窄**，理论上 BB 需要 defend 比你想象中更宽的范围，尤其是 vs 小尺寸 open。
    

**结构理解：**

- vs 各位置 open：
    
    - 对 UTG/MP：主要是宽但不离谱的 call 范围 + 偏极化或线性的 3bet。
        
    - 对 CO/BTN：可加入更多宽 defend（同花连子、Ax、Kx 等），并用适度线性 3bet 惩罚过宽 open。
        

**关键：**

- BB preflop 范围看起来是「乱七八糟一堆牌」，但你必须在脑中划分：
    
    - 3bet 线性块；
        
    - call 防守块（总体紧缩，但不可太窄，否则让 IP 自动盈利）；
        
    - 直接弃牌块。
        

---

## 4. 玩家池现实偏差：他们的 Preflop 到底错在哪？

结合 OS 2.0 对玩家池的描述和 Exploit 概览：

典型微级别 / 线下池的 preflop 偏差：

1. **3bet 频率严重不足，多冷跟**
    
    - 特别是 CO/BTN vs UTG/MP，常常用紧缩冷跟范围（KQ、AJ、TT–88）代替本该存在的 3bet 线性/极化块。
        
    - 结果：自己被 capped，对手 UTG/MP 的线性范围保持完好。
        
2. **SB 爱 limp，多人烂局**
    
    - 大量 SB 完全没有「3bet or fold」概念，用一堆 Q9o、JTo、76s limp 进池，形成超级紧缩、翻后极难防守的范围。
        
3. **BB 防守太窄**
    
    - 对小 open 尤其如此：明明 pot odds 要求 defend 很宽，却为了「不想玩烂牌」直接过度弃牌，让 IP open 自动盈利。
        
4. **前位范围扭曲：UTG/MP 不够线性，混入太多 trash**
    
    - 一些玩家在 UTG/MP 混入过多边缘 suited/offsuit 宽牌（KJo、QTo、A9o），导致：
        
        - 遇到 3bet 无法防守；
            
        - 翻后被 IP 强线性范围压制。
            
5. **过度尊重大 size 3bet / 4bet**
    
    - 面对一些极度 value-heavy 的大 size 3bet，即便理论上应该 defend，玩家也因为「怕陷入大底池」直接弃掉很多原本 +EV 的 hand（QQ/AK 都会被打掉一部分）。
        

这些偏差，后面 exploit 章节会系统展开；在 Preflop 这一章，我们先建立**方向性修正**。

---

## 5. Exploit 调整：给实战版本的 Preflop 范围结构

结合 v1.0/v2.0 和千算行动路线的建议，我们可以给出一套「专家 exploit 版」预设：

### 5.1 UTG/MP：宁可少开一成，也不要多开一成

- 把 UTG/MP 统一看成**偏线性的 value 位置**：
    
    - 直接采用 v1.0 建议的「UTG 核心范围 + MP 略扩展」。
        
- 实战建议：
    
    - **UTG：12–15%**，删掉大部分花哨 suited/连子；
        
    - **MP：15–18%**，在 UTG 基础上加少量 AJs–ATs/T9s/98s。
        

**Exploit 核心：**

- 你所在池子里，几乎没人 exploit 你「稍微偏紧的 UTG/MP」；
    
- 但你多开的那 3–5% 垃圾牌，会在大底池里持续烧钱。
    

---

### 5.2 CO/BTN：结构要宽，但别打成瞎松

- CO：以 20–24% open 为基线；BTN：35–45%。
    
- Exploit 逻辑：
    
    - 如果盲位 3bet 频率很低 → 你可以向 GTO 靠近，多开一些 suited/连子；
        
    - 如果盲位 3bet 激进 → 用更线性的 open + 更紧的 call vs 3bet，减少边缘 offsuited 宽牌。
        

**简单做法：**

- 先有「核心价值层」：所有你愿意 vs 3bet 决策的牌；
    
- 再小步增加「偷盲层」：只在桌子很被动时启用这层。
    

---

### 5.3 SB：强行进化到「3bet or fold」

- 理论：SB open ~35–45% raise-only；
    
- 微级别实战版：
    
    - 大量 SB limp 其实是 -EV 的，直接换成「合理 3bet 线性范围 + fold 其余」会立刻提升 winrate。
        

**SB vs BTN open 具体建议：**

- 把 QQ–99、AK–AQ、AJs–ATs、KQs 这一块当作**线性 3bet 主干**；
    
- 中弱牌（KJo、QTo、98s 这类）基本全部 fold，而不是 limp 进去找事。
    

---

### 5.4 BB：提高防守密度，别送死盲

- 理论上，BB vs 2.5x open 的 pot odds 非常好（后面会算）；
    
- 微级别 exploit：
    
    - vs 正常 size open（2.2–2.5x），BB 应比你直觉 defend 更宽一截；
        
    - vs 超大 open（3.5–4x+），则可以比 GTO 更弃（对手已经极度偏价值）。
        

---

## 6. 数学小节：BB 防守需要多宽，才不让别人白赢盲？

给你一个最常见场景：CO open 2.5bb，BB 要不要 defend？

- 盲注：0.5/1（SB=0.5，BB=1，为简单起见）。
    
- CO open 到 2.5bb，SB fold，BB 面临 1.5bb（已经下了 1bb，还需再投 1.5bb）。
    
- 底池现在大小：
    
    - SB 0.5 + BB 1 + CO 2.5 = 4bb。
        
- BB call 后，实际总底池：
    
    - 4bb + 1.5bb = 5.5bb。
        

BB 为了争取 5.5bb，要投入 1.5bb：  
[  
\text{所需胜率} = \frac{1.5}{5.5} = \frac{15}{55} = \frac{3}{11}  
]

3÷11 ≈ 0.2727… ≈ 27.3%。

也就是说：**只要 BB 的手牌在「对抗对手 open 范围」的胜率 ≥ 27.3%，call 就不会亏太多。**

这就是为什么 GTO 建议 BB 要 defend 比你想象中更宽：

- 很多你觉得「垃圾」的同花连子、Ax、Kx，在对抗 CO/BTN 宽 open 时，胜率其实足够支撑一个翻前 call，只要你翻后不乱来。
    

---

## 7. 高频场景：用 GTO+GO 的几个 spot 看 Preflop 影响

### 7.1 SRP EP vs BB：A♠4♣2♥ 牌面上的范围结构

在 GTO+GO 的 EP vs BB 合集中：

- EP open（线性强范围）vs BB defend。
    
- Flop A♥4♣2♥：
    
    - 双方 equity：58% vs 42%；EP 明显范围优势；
        
    - 但 EP 范围中 2 Pair+ 和强 FD 占比并不明显高，主要是强 showdown 一对 → solver 建议**高频 check，全范围 check** 更合理，而不是一味 cbet。
        

> 解读：
> 
> - 虽然 EP preflop 范围线性且整体更强，但在这个具体牌面上 nuts 分布并不压倒性 → 选择高频 check，而不是滥用「进攻者优势」。
>     

---

### 7.2 SRP BTN vs BB：A♠A♦4♣ 板上的极端范围优势

同样在 GTO+GO BTN vs BB 合集中：

- BTN open（宽线性），BB defend。
    
- Flop A♠A♦4♣：
    
    - IP equity：64% vs 36%；
        
    - 结论：BTN 全范围 1/3 pot 高频 cbet，几乎不 check。
        

> 这里能看出：
> 
> - Preflop BTN open 范围在线性宽度和 A 相关牌的数量上，远远优于 BB defend 范围；
>     
> - 导致在某些 A-high 公共牌面上，直接形成极端的范围优势，GTO 让 BTN 直接全范围小注「吃死」BB。
>     

---

### 7.3 EP vs BB：Q♥7♣7♦ 公对面的封顶 / 极化博弈

同一个 EP vs BB 合集里，Q♥7♣7♦ 牌面：

- EP 仍有 equity 优势（58% vs 42%），全范围 1/3 cbet 高频；
    
- BB 对应的防守结构是：
    
    - call：full house、K7–T7、44+、一些高牌；
        
    - raise：quads、A7、部分 97–57、22–33 等。
        
- 你可以看到：
    
    - EP 的 cbet 范围仍以全范围小注为主（线性范围持续施压）；
        
    - BB 的 XR 范围则是强 value + 少量 bluff，是典型极化结构。
        

> 这类例子说明：
> 
> - Preflop 谁线性、更强，Flop 上往往就能跑出更高频的 range bet 模型；
>     
> - 被压制一方通过 XR / 过牌加注，用「极化范围」对抗线性优势。
>     

---

## 8. Checklist：你在各位置 Preflop 的思考模板

这一节直接给你行为模板，打牌时尽量用问句扫描一下。

### 8.1 通用四问（任何位置）

1. 我现在这个位置（UTG/MP/CO/BTN/SB/BB）在这个池里，**应当整体是线性、极化、还是紧缩？**
    
2. 这手牌在我预设的这个位置范围里，属于**核心价值层、扩展偷盲层，还是干脆不该出现？**
    
3. 若遇到 3bet：
    
    - 对手来自哪里？（前位/后位/盲位）
        
    - 他典型 3bet 范围是偏线性还是极化？
        
4. 我的继续策略最该是：
    
    - 线性（继续大量中强牌）；
        
    - 极化（只保留顶部强牌 + 少量 bluff）；
        
    - 还是直接收缩？
        

---

### 8.2 位置专用问题

- **UTG/MP：**
    
    1. 这手牌如果放在 CO/BTN，我会因为位置好而 open 吗？如果答案是「只有在 CO/BTN 才敢开」，那现在就不该在 UTG/MP 开。
        
    2. 若被 CO/BTN/盲位大号 3bet，我继续是否必然陷入 OOP 烂局？
        
- **CO：**
    
    1. 我现在用的是「UTG 范」还是「BTN 范」？
        
    2. 桌子 3bet 非常少吗？若是，可以多加一些 suited/连子 进扩展层。
        
- **BTN：**
    
    1. 我是否把所有 marginal trash 都加进 open？
        
    2. vs SB/BB 3bet，我的 4bet 线是否「只剩 QQ+/AK + 少量 bluff」，还是在自己不会 handle 的前提下硬上花哨极化？
        
- **SB：**
    
    1. 这手牌我选择 limp 的理由是什么？
        
    2. 有没有更好的「3bet or fold」方案？如果没有，那这手牌很可能干脆该 fold。
        
- **BB：**
    
    1. 对手的 open 尺寸是多少？
        
    2. 按 pot odds 算，这手牌如果 call，理论上需要的胜率是多少？（简单记：2.5x open 对 BB → 27% 左右）
        
    3. 这手牌 vs 对手 open 范围的权益，大概能不能达到这个数字？
        

---

## 9. 复盘模板：专门针对 Preflop 的诊断

以后你复盘任意一手牌，先别急着看 flop：

1. 这手牌所在位置（UTG/MP/CO/BTN/SB/BB），在我设定的 RFI 范围里是**核心 / 扩展 / 越界**？
    
2. 我的 open / call / 3bet 决策，让自己的范围在这个 spot 下：
    
    - 更线性？
        
    - 更极化？
        
    - 还是更紧缩/封顶？
        
3. 对手这条线（冷跟 / 3bet / call 3bet），在结构上是：
    
    - 用哪些牌撑起顶部？
        
    - 是否放弃了应有的 bluff 层或 value 层？
        
4. 如果我照 v1.0/v2.0 的建议（比如 UTG 多弃一些边缘 hand、SB 采用 3bet or fold、BB 多 defend 一些 suited/连子），这一手牌的**翻后局面会不会明显变轻松**？
    

当你能在复盘中稳定回答这 4 个问题，说明你已经从「牌表记忆」升级到「范围结构理解」。

---

## 10. 常见错误（Preflop 专属）

1. **把 CO 打成 UTG，失去位置红利**
    
    - 过紧，不敢用 suited/连子偷盲，导致 CO/BTN 的潜在 EV 被浪费。
        
2. **把 CO 打成 BTN，导致对 3bet 无法防守**
    
    - 过松，混入太多 offsuit 宽牌，一旦 SB/BB 3bet 就沦为弃牌机器。
        
3. **SB 只 limp、不 3bet**
    
    - 形成超级紧缩范围，让 BTN/BB 在翻后自动打钱。
        
4. **BB 防守只看自己牌，不看 pot odds**
    
    - 明明 2.5x open 只要 27% equity 就可以 call，却因为「不想玩烂牌」过度弃牌，让对手自动盈利。
        
5. **UTG/MP 为了「不被看出太紧」加入一堆 trash**
    
    - 这在高额对抗高手可以考虑（混合策略），但在微级别/线下池几乎 100% 只是自残。
        

---

## 11. 本章与后续章节的接口

- 与 **Flop 章节（5–8 章）**：
    
    - 本章对「线性 vs 极化 vs 紧缩」的 Preflop 结构理解，直接支撑后面 Flop 上的 cbet/ check / XR 策略：
        
        - 谁 preflop 更线性 → 谁在很多牌面有范围优势，可以高频小注；
            
        - 谁 preflop 多冷跟 → 谁更容易在很多牌面被 capped，被迫用极化 XR 来自救。
            
- 与 **Turn/Overbet 章节（9–11 章）**：
    
    - 极化 3bet/4bet 结构决定谁在高 SPR turn spot 有更大的 overbet 空间；
        
    - 许多「Turn 超池」的前提，其实在 preflop 就已经写好了。
        
- 与 **River/抓诈章节（12–14 章）**：
    
    - Preflop 决定了最终谁在 river 上更容易拥有 nuts 密度优势，从而敢在大底池中做 bluff/call 决策。
        

---

## 《迭代日志》

**【来源】**

- Poker_OS_v1.0.md：Preflop 总纲、各位置专家版范围结构与微级别建议。
    
- Poker_OS_v2.0.md：Preflop 三大原则、六位置结构简表、SB/BB 对抗结构与 Exploit 总览。
    
- 2.GTO+GO SRP EP vs BB / 4.GTO+GO SRP BTN vs BB：EP/BTN vs BB 在不同牌面上的 equity/EV 和 cbet 策略，用于展示 Preflop 范围结构对 Flop 的影响。
    
- 千算标准行动路线 & 抓诈/进攻资料：对微级别 exploit 的默认推荐。
    

**【结论】**

- 第 2 章在第 1 章的「范围结构 + equity/EV」之上，把 Preflop 范围做了结构化重建：
    
    - 以线性/极化/紧缩为底层标签；
        
    - 用各位置 RFI/3bet/4bet 结构 + GTO+GO 牌面示例，解释「为什么这样的 Preflop 结构会导致后面那些 Flop/Turn 策略」。
        

**【改动点】**

- 相比 Poker OS v1.0/v2.0 里零散的 Preflop 段落，本章：
    
    - 更强调整体「结构理解」，而不是牌表；
        
    - 补充了 BB pot odds 的数学推导，说明 defend 宽度的底层逻辑；
        
    - 把「玩家池偏差」和「位置结构」组合成较完整的 exploit 建议。
        

**【待补充】**

- 目前没有展开具体「位置×位置」的 3bet 频率表，只给了结构与方向；
    
- 后续若你需要，我可以追加一个「简化 3bet/4bet 表」，作为附录或独立小节。
    

**【下一步建议】**

- 下一章建议进入 **3bet / 4bet 架构**（原目录第 3 章），把本章的「范围结构」进一步压缩成：
    
    - 对不同位置 open 的 3bet 模式（线性 vs 极化）；
        
    - 4bet value / bluff 的组合思路；
        
    - 以及在玩家池偏差下的简化版本（比如微级别几乎废掉 4bet bluff）。
        

如果你对这一章的深度和风格 OK，我们就按同一套模板推进第 3 章。你不用客气，有哪块你觉得还不够「解构范围」，直接点名，我下一章顺便一起加深。