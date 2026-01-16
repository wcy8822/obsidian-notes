
# Poker OS v1.0：德州扑克策略操作系统

> 本文档是一个「可落地」「可复盘」「可迭代」的德州扑克策略操作系统纲要，
> 目标不是给出某一手牌的标准答案，而是给出一整套可复用的决策框架。

---

## 0. 方法论与全局约束

### 0.1 文档目的

1. 形成一份**统一的策略总纲**，整合：GTO 思路、Solver 输出、千算行动路线、进攻/防守锦囊、河牌诈唬/抓诈系列。
2. 让任何一手牌都可以用同一套流程来复盘：  
   - 先看 Preflop 范围是否合理；  
   - 再看 Flop/Turn/River 是否遵守牌面结构与范围优势；  
   - 最后用数学与玩家池 exploit 做修正。
3. 支持长期迭代：你可以在此基础上继续增删改，形成自己的 Poker OS v2.0、v3.0。

### 0.2 使用方式

建议你这样使用本 OS：

- 打牌前：选 1 个章节精读（例如「SB vs BB 总结」）。
- 打牌中：只记住几个 checklist，不要带着整本 OS 上桌。
- 打牌后：把当天印象深刻的 1–3 手牌，用第 7 章的复盘模板走一遍。
- 每周：挑一类典型 spot（例如「3BP BTN vs BB」），集中做 3–5 手牌的深入复盘。

### 0.3 知识来源（抽象化说明）

本 OS 抽象整合了以下类型的内容：

- GTO+GO：各位置 SRP/3BP 的 Solver 行动模板。
- 千算行动路线：适用于微级别/线下局的简化标准线。
- 千算抓诈锦囊：进攻篇与防守篇的 bluff / bluffcatcher 选择方法。
- Lillian 系列文章：全范围 C-Bet、隐藏范围、河牌诈唬/抓诈、对抗激进玩家。
- Janda 风格理论：范围结构、equity vs EV、混合策略等。

本 OS 不逐条还原任何单一文档，而是提炼其可复用逻辑。

### 0.4 全局约束

1. **GTO 是基线，不是圣经**：  
   - Solver 结果用于理解结构与范围，而不是记频率。
2. **千算行动路线是微级别默认方案**：  
   - 如果你在 NL2–NL50 或线下松散局，不必为「完美平衡」焦虑，先保证 exploit 有效。
3. **所有建议都需结合玩家池偏差**：  
   - 玩家过度弃牌 → 偏向 value。  
   - 玩家跟注站 → 减少 bluff，增加 thin value。
4. **必须可执行**：  
   - 若一个策略很「优雅」但实战极难执行，本 OS 会优先推荐更简单的替代方案。

---

## 1. Preflop 总纲（专家版）

### 1.1 Preflop 的核心目标

1. 构建各位置的**稳定、线性且可防守的范围**，避免翻后被动挨打。
2. 通过合理的 3bet/4bet 体系，抢占范围优势与位置优势。
3. 控制翻前决策复杂度：在你当前注级，只保留「明显 +EV」且易执行的线。

### 1.2 范围类型：线性 / 极化 / 紧缩

- **线性范围**：从最强牌往下，按强度连续往下选（如前位 open/线性 3bet）。
- **极化范围**：顶部强牌 + 底端 bluff，中间牌多弃（如 BTN 对抗 CO 的 3bet/4bet）。
- **紧缩/封顶范围**：缺乏顶端强牌，中段居多（如某些平跟范围）。

理解自己和对手在某个 spot 的范围形态，是后续 Flop/Turn/River 策略的前提。

### 1.3 位置结构

六个位置按「信息与盈利潜力」排序：

UTG < MP < CO < BTN < SB < BB（从最紧到最宽的 open 位）

- UTG/MP：主要任务是「不犯大错」，线性稳健。
- CO/BTN：开始偷盲、运用位置优势。
- SB：翻后几乎总是 OOP，要格外小心。
- BB：翻前成本最低，需承担更多防守责任。

---

### 1.4 UTG（专家版）

#### 1.4.1 UTG 开局范围（SRP）

**UTG = 全桌最紧、最线性的位置。**

- 价值主干：AA–TT、AKs–AQs、AKo、部分 AQo。
- Suited broadway：KQs、QJs，KJs 低频。
- 少量强同花连子：T9s、98s（再低基本不进）。
- Solver 会在 A5s–A2s 上混合少量频率，供 4bet bluff 使用（实战可简化）。

**实战/千算微级别建议：**

- 删掉大部分花哨组合：87s 以下、A5s–A2s等。
- 保持总 open 范围在 12–15% 区间。
- 简化记忆：  
  - 所有大对（TT+）、中对（99–88）  
  - AK/AQ（s/o）、少量 AJs  
  - KQs/QJs/T9s/98s

#### 1.4.2 UTG 面对 3bet

原则：UTG 对抗 3bet 时，**继续范围必须极强**。

- 对抗 CO/BTN/盲位：
  - 4bet for value：AA–QQ、AKs、部分 AKo。
  - 4bet bluff（理论）：A5s–A4s（但微级别多数对手不弃 → 建议取消）。
  - call：JJ–TT、AQs（少量），大部分中段牌直接弃。

**微级别/实战建议：**

- 继续范围简化为：AA–QQ + AKs/AKo。
- JJ/AQs/TT 视 3bet 尺寸与对手倾向做混合（多弃少 call）。
- 面对超大 3bet（>4x），哪怕 QQ/AKo 也要适当 tighten。

#### 1.4.3 UTG Checklist

1. 这手牌是否在我预设的 UTG 核心范围内？
2. 如果被 3bet：对手来源位置？尺寸多大？
3. 我继续是否会陷入 OOP 大底池困境？若是 → 宁可弃。

---

### 1.5 MP（专家版）

#### 1.5.1 MP 开局范围（SRP）

**MP = UTG 的自然扩展位，略宽但仍以线性为主。**

- 增加：更多同花 Ax（AJs–ATs、A5s–A2s）、更多同花连子（T9s–87s）。
- Offsuit 宽牌：KQo 进入，KJo/QJo 仍基本不进。

**实战简化版：**

- 若你不熟悉 Flop/Turn 的复杂 spot，可以：
  - 用近似 UTG 的范围开局，再略加 AJs–ATs/T9s/98s。
  - 控制总 open 量在 15–18%。

#### 1.5.2 MP vs 3bet 结构

- vs CO/BTN：位置劣势明显，继续范围应比 GTO 更紧。
- 推荐：
  - 4bet for value：AA–QQ、AKs/AKo。
  - call：JJ–TT/AQs/AJs/KQs（视对手 3bet 倾向调整）。
  - 取消大部分 solver 式 4bet bluff。

#### 1.5.3 MP Checklist

1. 这手牌放在 UTG 会不会开？如果不会，MP 开它有充分理由吗？
2. 面对 3bet，我弃牌是否真亏？还是只是「不甘心」？
3. 记住：MP 最大 leak 是「用 UTG 强度在中后位桌子玩复杂局」。

---

### 1.6 CO（专家版）

#### 1.6.1 CO 开局范围（SRP）

**CO 是从「正常范围」向「偷盲范围」过渡的位置。**

- GTO 开局约 26–30%。
- 实战建议：20–24% 已足够有压制力。

**结构：**

- 核心价值：AA–66、AK–AT（s/o）、KQs–KJs、QJs、JTs。
- 扩展：
  - Suited：A9s–A2s、KTs–K9s、QTs–Q9s、T9s–65s（部分）。
  - Offsuit：KQo、部分 KJo/QJo。

**微级别调整：**

- 删掉太多低端同花连子（65s、54s 等）和弱 offsuit 宽牌。
- 保证：CO open 进的牌，你对抗盲位 3bet 时不会「完全蒙圈」。

#### 1.6.2 CO vs 3bet

- vs BTN 3bet（极化）：
  - call：JJ–99、AQs–ATs、KQs、QJs；
  - value 4bet：QQ+/AK；
  - bluff 4bet：高水平可混入少量 A5s/A4s。
- vs SB/BB 3bet（偏线性）：
  - 继续范围更紧：JJ+/AK，AQs/AJs 部分，很多边缘牌直接弃。

---

### 1.7 BTN（专家版）

#### 1.7.1 BTN 开局范围（SRP）

**BTN = 全桌最宽、EV 最高的位置。**

- GTO：45–55% open。
- 实战建议：35–45% 即可保证高盈利+可控难度。

**推荐划分：**

1. 核心价值层：  
   - 所有口袋对（AA–22）；  
   - 所有同花 Ax；  
   - AK–AT（offsuit）、KQs–KTs、QJs–QTs、JTs–T9s。  
2. 扩展价值层：  
   - 同花 K9s–K8s、Q9s–Q8s、J9s–J8s、T8s–54s；  
   - 部分 broadway offsuit（KQo、QJo、JTo）。  
3. 轻偷盲层：  
   - 对抗多盲位过度弃牌桌，可加宽至任意 two broadway、部分 97s、T7s 等。  

#### 1.7.2 BTN vs SB/BB 3bet

核心模式：**宽 call + 极化 4bet**。

- 4bet for value：QQ+/AK。
- 4bet bluff（高水平可用）：A5s–A4s、少量 K5s/Q5s。  
- Call：
  - JJ–77、AQs–ATs、KQs–KJs、QJs、JTs、T9s 等。

**微级别建议：**

- 删掉大部分 4bet bluff，只保留 QQ+/AK 做 value 4bet。
- 对抗过小 3bet 尺寸（如 3x）：多用 call，少 4bet。

---

### 1.8 SB（专家版）

#### 1.8.1 SB 开局策略（无人入池）

SB 是全桌翻后最难打的位置，因此：

- GTO 推荐：SB raise-only（不 limp），open 约 35–45%。
- 实战/微级别：不建议照搬。推荐：
  - 强牌：AA–88、AK–AT（s/o）、KQ/KJ/QJ suited。
  - 中弱牌：大部分直接 fold，不做 limp 场景，减少翻后多路 OOP 灾难。

#### 1.8.2 SB vs BTN open

- Solver：SB 使用较线性的 3bet：QQ–TT、AK–AQ（s/o）、AJs–ATs、KQs、KJs 等。
- 微级别：
  - 倾向「3bet 或 fold」结构：
    - 3bet：QQ–99、AK–AQ、AJs–ATs、KQs；
    - 放弃大量纯 call，避免构造 SB flat vs BTN 的难打局面。

---

### 1.9 BB（专家版）

#### 1.9.1 BB 防守基础原则

- BB 已经投入 1bb → 防守成本最低。
- 必须比其他位置更宽 defend，否则对手偷盲盈利极高。

**对不同位置 open 的 defend 大致思路：**

- vs UTG/MP：更加紧（10–15% 左右），以强同花 Ax、KQs、中高口袋为主。
- vs CO：中等（18–22%），加入更多 suited Ax、KJs、QJs、JTs、T9s 等。
- vs BTN：极宽（25–35%+），几乎所有 suited Ax/宽牌、所有口袋对与大部分同花连子。
- vs SB：类似 vs BTN，但注意 SB 尺寸（过大时适当 tighten）。

#### 1.9.2 微级别 defend 建议

- 同花：所有 Ax、Kx（K2s+）、Q8s+、J9s+、T8s+、98s–54s。
- 口袋：所有对（22+）。
- Offsuit：KQo、QJo、JTo 等部分宽牌。  
- 很差的 offsuit（如 J5o、T4o、92o）——直接 fold。

---

### 1.10 3bet / 4bet 系统鸟瞰

（简要文字版，细节可按不同对抗再展开）：

- 前位 vs 后位 open：多用线性 3bet（价值为主）。
- 后位 vs 前位 open：多用极化 3bet（顶部价值 + 底端 bluff）。
- SB/BB vs BTN open：倾向线性 3bet（惩罚 BTN 宽 open）。
- 4bet：大多数情况下为「顶部价值 + 少量 A5s/A4s 这类 solver bluff」。  
- 微级别：大量 4bet bluff 不必要，容易被人“全跟到底”。

---

### 1.11 Preflop 总结 Checklist

1. 我在这个位置 open 的牌，是否在一个**稳定可防守的范围**之内？
2. 面对 3bet，我的继续范围是否过松或过紧？
3. 若不确定：宁可在前位偏紧，也不要在 SB/MP 就玩花活。

---

## 2. Flop 体系（专家版）

### 2.1 三大核心问题

每到 Flop，你应该优先回答三个问题：

1. **谁有范围优势？**  
   - Preflop 3bettor vs flat caller？  
   - 开局者 vs BB defend？
2. **谁有坚果优势？**  
   - 谁有更多最强组合（set/两对/nuts 同花/顺子）？
3. **牌面动态如何？**  
   - 干燥（A72r）还是湿润（T98hh）？  
   - 转牌/河牌能不能剧烈改变局势？

### 2.2 牌面分类 + Cbet 策略（概览）

#### 2.2.1 A/K 高干面

例：A72r、K83r

- 多数 SRP/3BP 中：开局者/3bettor 拥有范围优势与更多 top pair 组合。
- GTO 倾向：高频小注 Cbet（1/3 pot，70–90% 范围）。
- 微级别：直接使用「全范围小注」策略即可。

#### 2.2.2 中高连接湿面

例：QJTss、T98r、987hh

- 防守者（BB、冷跟者）往往有更多 65s/76s/98s 类型牌 → 坚果优势偏向防守者。
- 开局者 Cbet 频率明显下降，更多 check。
- 防守者获得 check-raise 的核心舞台。

#### 2.2.3 低牌干面

例：962r、842r

- 开局者有更多 overpair；防守者有更多中对/两对/低 set。
- 策略：开局者不能盲目全范围 Cbet，需要混合 check-back，保护中段范围。

#### 2.2.4 公对面 / 同花面

- 公对面（K99、772）：开局者范围优势显著 → 高频 1/3 Cbet 合理。
- 三同花面：拥有更多高同花的那一方有明显坚果优势 → 小注 Cbet 为主。

### 2.3 IP Flop 策略

作为 IP（BTN/CO 等）：

- 范围优势 + 干面 → 高频小注。  
- 坚果优势极强 + 动态牌面 → 可考虑较大 size 或极化策略。  
- 劣势牌面（T98 vs BB defend）→ 多 check-back + 延迟 Cbet。

### 2.4 OOP Flop 策略

作为 OOP（SB/BB）：

- check 为默认起点。
- 对抗高频小注 Cbet：构建极化 check-raise 范围：
  - Value：两对、set、强 top pair、强 draw。  
  - Bluff：带 BDFD + GS 的组合，或几乎无摊牌价值但阻挡对手继续的牌。  
- 不能永远 check-call，否则 IP 可以随意印钞。

### 2.5 Flop Checklist

1. 我这边在这个牌面有范围优势吗？
2. 我是否有一套合理的 value + bluff Cbet 结构？
3. 若我是 OOP：我是否有一些 XR bluff 来制衡 IP 高频 Cbet？

---

## 3. Turn 体系（专家版）

### 3.1 Turn 的角色

- 从「小额信息对碰」升级为「范围表态回合」。  
- 极化范围在 Turn 真正开始显现：继续进攻 vs 就此停手。

### 3.2 Turn 牌面类型

1. Blank：对双方范围影响极小的牌（如 A72r → 5♣）。  
2. 完成听牌：顺子/同花到位。  
3. 公对：第二张同点牌出现。  
4. 高牌落下：T 以上牌面改变顶对结构。

### 3.3 极化与 Merge 的运用

- Blank 上继续极化进攻（用强 value + bluff），迫使对手弃掉大量中段牌。  
- 完成听牌面倾向 merge：用中上强牌小到中注，避免被 check-raise all in 套牢。

### 3.4 超池下注（Turn 简析）

符合条件：

1. 你有明显坚果优势；  
2. Turn 没有显著改善对手范围；  
3. 你在 Flop 已经构造了极化结构。

应用：  
- 利用超池下注放大对手「带 bluffcatcher 跟注」的成本，迫使其过度弃牌。

### 3.5 Turn Checklist

1. Turn 这张牌对双方范围的影响是「blank」还是「变化巨大」？
2. 我是在延续一个可信的故事，还是在凭空胡来？
3. 我选择的 size，与我想表达的极化/merge 结构是否一致？

---

## 4. River 体系（专家版）

### 4.1 河牌下的三种角色

1. 价值下注者（Value bettor）  
2. 诈唬者（Bluffer）  
3. 抓诈者（Bluffcatcher）  

你的牌必须清晰归类为其中一类（或弃牌）。

### 4.2 诈唬三原则

1. 几乎没有摊牌价值。  
2. 阻挡对手的跟注范围。  
3. 不阻挡对手的弃牌范围。  

### 4.3 Bluffcatcher 三原则

1. 阻挡对手的价值组合。  
2. 不阻挡对手的 bluff 组合。  
3. 在自己整体范围中位于中上游（不是最差，也不是最好）。  

### 4.4 Blocker 正确 vs 错误使用

- 正确：用阻挡 nuts 的牌 bluff 或 call；例如你有一张高花色牌，挡住对手部分坚果组合。
- 错误：用阻挡对手 bluff 的牌去 bluff 或 call，结果对手更少 bluff，你的 bluff/call 更亏。

### 4.5 River Checklist

1. 我现在下注/跟注的理由是否清晰？是价值还是 bluffcatch？
2. 这手牌在我全范围中位置如何？是否配得上一个 hero call？
3. 我的阻挡牌效果，是在帮助还是在害我？

---

## 5. 位置对抗概览（简版）

详细版可以在后续成为独立模块，这里给出思路框架。

### 5.1 SB vs BB

- Preflop：SB open/3bet vs BB defend。  
- Flop：SB 通常 OOP，小注策略重要；BB IP 可以用 raise vs Cbet 进行极化反击。  
- Turn/River：谁被 capped，谁有 nuts advantage。  

### 5.2 BTN vs BB

- BTN 宽 open + 位置优势。  
- BB 宽 defend + OOP 劣势 → 需用 XR 平衡。  
- 高频小注 + 合理 XR，是典型结构。  

其余对抗（CO vs BB、SB vs BTN 等）可以在未来版本中细化。

---

## 6. Exploit 系统概览

### 6.1 常见玩家类型

1. 过度弃牌型：看到大注就秒弃。  
2. 跟注站：几乎不弃 top pair 与任意同花。  
3. 激进型：爱 3bet、爱 barrell。  
4. 被动型：只用强牌行动，几乎不 bluff。  

### 6.2 对应 Exploit 模板

- 过度弃牌型 → 增加 bluff，减少 thin value。  
- 跟注站 → 增加 thin value，削减 bluff。  
- 激进型 → 增加 check-call + XR，减少裸下。  
- 被动型 → 多频率 value bet，小 bluff。  

---

## 7. 复盘体系

### 7.1 输入模板

1. 牌局基础：盲注、筹码、赛制、位置。  
2. 玩家池 & 对手画像。  
3. 街-by-街行动与 size。  
4. 当时想法（诚实记录）。  
5. 你最想搞清楚的 1–3 个关键问题。  

### 7.2 输出结构（复盘时的目标）

1. 一句话结论：这手牌的本质问题是什么。  
2. GTO 基线 vs 玩家池现实：理论 vs 真实。  
3. 逐街节点分析：Preflop/Flop/Turn/River。  
4. 数学验证：pot odds、equity 粗算。  
5. 抽象策略模板：这手牌属于哪类通用 spot。  
6. 个人提升建议：未来类似 spot 应如何调整。  

---

## 8. Poker OS v1.0 总结

- 本 OS 不是一本「完整教科书」，而是一个可以不断被你升级的**操作系统**。  
- 你可以：
  - 在 Preflop 章节中加入自己的范围表；  
  - 在位置对抗处增加 solver 截图或线下经验；  
  - 在 Exploit 章节记录你所在玩家池的真实偏差；  
  - 在复盘章节中沉淀自己的常见 leak。  

当你能用这套 OS：

- 解释自己每一手牌的决策；  
- 用统一语言与他人讨论策略；  
- 在新 spot 中，借助框架快速推导出一个「足够好」的决策；  

那这份 Poker OS v1.0 就真正发挥了它的价值。
