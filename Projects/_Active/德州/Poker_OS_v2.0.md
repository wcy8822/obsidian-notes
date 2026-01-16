
---

# Poker OS 2.0（专家版初稿）

> 德州扑克策略操作系统（Poker OS）v2.0
> 核心：以 GTO 结构为地图，以玩家池偏差为风向，以「可执行模板」为落点。

---

## 0. 方法论与全局约束

### 0.1 一句话结论

**Poker OS 2.0 的目标不是记答案，而是给你一套「任何牌局都能套进去跑一遍」的决策系统。**

### 0.2 三点核心原则

1. **GTO 是地图，不是脚本**

   * Solver 告诉你结构：谁有范围优势、谁有坚果优势、标准 size 倾向是什么。
   * 但人类在牌桌上的决策要加上：对手频率、情绪、电量、赌桌结构。

2. **玩家池偏差是盈利来源**

   * 微级别、线下局的典型特点：

     * 3bet 不够，多冷跟；
     * flop cbet 过多，turn/river 放弃过多；
     * 河牌 bluff 明显少于理论。
   * 你的钱，赚的就是这些偏差。

3. **一切策略都要变成「Checklist + 模板」**

   * 不做“感觉型打牌”；
   * 用固定的问题列表来检查自己的行动，比如：

     * 这里谁有范围优势？
     * 这张 turn 是 blank 还是改变了 nuts？
     * 这手牌在我整体范围里处在中上还是中下？

---

## 1. Preflop 总纲（专家版）

### 1.1 一句话结论

**Preflop 的工作只有两件：给自己造出一个「能稳稳扛到河牌」的范围结构，顺手让对手的范围尽量难受。**

### 1.2 三点原则

1. **前位线性、后位放松**

   * UTG/MP：只打高质量线性范围（AA–TT、AK/AQ 等），不玩花活。
   * CO/BTN：开始利用位置，多加 suited/连子/边缘宽牌。

2. **盲注位职责不同**

   * SB：翻后永远几乎 OOP，对局难度最高 → 少 limp，多 3bet or fold。
   * BB：赔率好，防守责任最大 → 需要比你直觉更宽的 defend。

3. **3bet/4bet 结构决定后面的一切**

   * 线性 3bet：用强线性范围「吃死」对手宽 open（SB/BB vs BTN）。
   * 极化 3bet/4bet：用顶部强牌 + 一截 bluff 去攻击前位（BTN vs CO/MP/UTG）。

---

### 1.3 六个位置的结构简表（方向性，不死背牌谱）

> 下面不是精准表，而是「结构理解」，你可以在自己工具里填具体组合。

#### 1.3.1 UTG / MP：线性稳健

* 范围特征：

  * 高口袋对：AA–TT（部分 99–88）。
  * 高牌：AK/AQ（s/o）、少量 AJs。
  * 同花：KQs/QJs/T9s/98s 少量。
* 3bet vs 后位：

  * 继续范围 = QQ+/AK。
  * JJ/AQs 根据对手 3bet 尺寸与倾向调整（多弃少 call）。

**Checklist：**

* 这手牌 UTG 开了会不会太花？如果会，那 MP 也不该开。
* 面对大号 3bet（>4x），除了 QQ+/AK 以外，基本不该硬抗。

---

#### 1.3.2 CO：过渡位

* 比 MP 多：

  * 更多 suited Ax（A9s–A2s）；
  * 更多同花连子（T9s–76s）；
  * 少量额外 offsuit 宽牌（KQo、QJo）。
* 核心任务：

  * 既能偷盲，又不至于被 BTN/SB/BB 3bet 打爆。

**Checklist：**

* 我在 CO，用的是否还是偏「UTG/MP 范」？那就太紧了。
* 我是否把 CO 打成 BTN？那就是过松，3bet 一来翻后全是大坑局。

---

#### 1.3.3 BTN：全桌最宽、EV 最高

* 目标 open：35–45%（不必追求 GTO 的 50%+）。
* 结构分层：

  1. 核心价值：AA–22、AK–AT（s/o）、所有 suited Ax、KQs/KJs/QJs/JTs/T9s。
  2. 扩展偷盲层：K9s–K8s、Q9s–Q8s、J9s–J8s、T8s–54s、KQo/QJo/JTo。

**BTN vs SB/BB 3bet：**

* 标准模式：

  * 4bet value：QQ+/AK。
  * 高水平 4bet bluff：A5s–A4s、少量 K5s/Q5s。
  * call：JJ–77、AQs–ATs、KQs–KJs、QJs、JTs、T9s 等。
* 微级别建议：

  * 砍掉大部分 4bet bluff，只保留 QQ+/AK 做 value 4bet；
  * 面对小 3bet（3x），尽量多用 call，少轻率 4bet shove。

---

#### 1.3.4 SB：最差位置，翻后几乎永远 OOP

**SB 无人入池：**

* 理论：raise-only，open ~35–45%。
* 微级别执行版：

  * 强牌：AA–88、AK–AT（s/o）、KQ/KJ/QJ suited。
  * 中弱牌：绝大多数直接 fold，不搞 limp 多人局。

**SB vs BTN open：**

* 理论：线性 3bet（QQ–TT、AK–AQ、AJs–ATs、KQs 等）。
* Exploit 版：

  * 采用「3bet or fold」策略：

    * 3bet = value 主导（QQ–99、AK–AQ、AJs–ATs、KQs）。
      -少 flat，避免 SB call vs BTN 的烂局。

---

#### 1.3.5 BB：翻前防守核心

* 对 UTG/MP：tight defend（Ax suited、KQs、JJ–88、少量同花连子）。
* 对 CO：适当放宽，加入更多 suited Ax/KJs/QJs/JTs/T9s。
* 对 BTN/SB：必须明显更宽 defend，否则让对方无限印钱。

**粗略防守逻辑：**

* 所有口袋对。
* 所有 suited Ax。
* 大多数 suited Kx/Q8s+/J9s+/T8s+/98s–54s。
* 部分 offsuit broadway（KQo/QJo/JTo）。

**Checklist：**

* 这手牌如果丢掉，我给对方的「偷盲 EV」是不是太高？
* 我是不是 defend 了太多纯垃圾 offsuit（J4o、T3o 这种）？那是无谓 leak。

---

### 1.4 Preflop 3bet / 4bet 体系（方向版）

**线性 3bet：**

* SB/BB vs BTN open；
* CO vs BTN steal 有时也可偏线性。

**极化 3bet：**

* BTN vs CO/MP/UTG；
* BB vs CO 某些结构。

**4bet：**

* 大多数场景：QQ+/AK 为稳定 value 核心；
* Solver 式 4bet bluff（A5s–A4s 等）在微级别要严格控制使用频率。

**Preflop 复盘问题：**

1. 我这手牌在这个位置 open/3bet 合理吗？
2. 面对 3bet/4bet，我的继续范围是否过松/过紧？
3. 我是不是用「BTN 的思路」打 UTG/MP 导致一堆难玩局面？

---

## 2. Flop 体系（专家版）

### 2.1 一句话结论

**Flop 的本质是：谁在这个牌面上握着结构优势，谁就用 size 与频率把这个优势兑现出来。**

### 2.2 三问法（任何 Flop 必问）

1. **Range Advantage：谁 Preflop 范围更强？**
2. **Nuts Advantage：谁有更多 nuts/top-end 组合？**
3. **Texture：牌面是干燥 vs 湿润、静态 vs 动态？**

这三点决定你是：range bet、低频大注、check-back、还是 XR。

---

### 2.3 牌面分类 + 策略倾向

#### 2.3.1 A/K 高干面（A72r / K83r）

* 大多数 SRP/3BP 中：开局者/3bettor 有明显范围优势 + 较多 A/K 高牌。
* Solver 倾向：高频小注 Cbet（甚至全范围小注），1/3 pot 是主流。

**IP：**

* BTN vs BB 在 A72r → 高频 1/3 Cbet。

**OOP：**

* SB 3bet vs BTN 在 AsQc4h → 近乎全范围小注（全范围 Cbet 思想）。

**微级别 exploit：**

* 大量玩家在此类牌面「一看是 A 面就直接弃非 A 牌」，IP/OOP 的小注 EV 异常高 → 可以放心地保持高频小注，搭配少量 turn 继续开火。

---

#### 2.3.2 中高连接面（QJT / T98 / 987）

* 防守者（BB、flat caller）往往有更多连子、两头顺、低 set → nuts advantage 倾斜。
* GTO：

  * PFR 降低 Cbet 频率，更多 check。
  * 防守者 XR 变多，用 nuts + 强 draw 极化。

**实战 exploit：**

* 大多数人这里还是机械 1/2 pot cbet → 你作为 OOP 可以增加 XR；
* 作为 IP，如果对手 XR 很少，只要 Cbet 不过度频繁，也可以偏简单打。

---

#### 2.3.3 低牌干面（962r / 842r）

* PFR 拥有 overpair（JJ+），但防守者拥有更多低 set/两对。
* 策略：

  * PFR 低频小注 + 部分 check-back → 防止自己 range 太容易被 XR 攻击。
  * 防守者选一部分强牌 XR，其余 check-call。

**微级别 exploit：**

* 很多 IP 玩家根本不 XR，只 check-call 强牌，导致你的小注可以轻松回收大量弃牌 → IP 可以适度提高 cbet 频率；
* 但不要在这类面做“超级高频 XR bluff”，大部分对手不会在 flop 放弃 overpair。

---

#### 2.3.4 公对面 / 同花面

* 公对面（K99、772）：

  * PFR 通常有更多 overpair → 高频 1/3 小注非常合理。
* 三同花：

  * 拥有更多高同花的一方有 nuts advantage → 倾向小注 Cbet，但频率要根据双方结构微调。

---

### 2.4 IP 策略（BTN/CO）

1. 有范围优势 → 高频小注；
2. 劣势牌面 → 多 check-back + 延迟 Cbet；
3. 面对 OOP cbet → raise 使用「强价值 + 强 draw + 部分 bluff」。

**Flop IP Checklist：**

1. 这是我有优势的面吗？
2. 若是优势：我是否用小注全范围或高频？
3. 若是劣势：我是否过度用“小注试一发”送 EV？

---

### 2.5 OOP 策略（SB/BB）

**核心：不能只 check-call。**

* 如果 IP 的策略是「高频小注」，OOP 必须通过：

  * 部分 XR，再构建一条极化线：强 value + strong draw + blocker bluff；
  * 少量 check-raise bluff 组合（BDFD + GS 等）。

**Flop OOP Checklist：**

1. 对手 cbet 是否明显过高？
2. 我是否有足够强的 value 组合去 XR？
3. 我是否找到了一些「无摊牌价值但有好 blocker」的 XR bluff？

---

## 3. Turn 体系（专家版）

### 3.1 一句话结论

**Turn 是范围开始极化、故事开始变贵的地方；Flop 轻率的一个小注，很可能要到 Turn 才付出代价。**

### 3.2 Turn 牌面类型

1. **Blank**：几乎不改变任何人范围（如 A72r → 5♣）。
2. **完成听牌**：顺子/同花到位。
3. **公对**：第二张某点出现，使牌面配对。
4. **高牌落下**：改变顶对等级，可能重新洗牌范围顶端。

---

### 3.3 极化 vs Merge 的决策

* **在 Blank 上：**

  * 若你已在 Flop 表达强势 → Turn 通常用极化范围继续开火（强 value + bluff），size 可加大。
* **在 完成听牌上：**

  * 更多 merge 小/中注，用中上 value 收薄利，避免被 check-raise all in。

**Turn Checklist：**

1. 这张 turn 对双方 nuts / range 有何影响？
2. 我的 flop 线，能否自然延伸到 turn 极化？
3. 我的 size 是在讲“极化故事”，还是在讲“控制故事”？

---

### 3.4 超池下注（Turn 简版）

* 必要条件：

  1. 你有坚果优势；
  2. 对手在前一街已经没太多 nuts；
  3. SPR 允许你用超池施压。
* 用途：

  * 把对手的 bluffcatcher 逼到极限；
  * 放大利润区间，特别是对抗「过度跟注型」玩家。

---

## 4. River 体系（专家版）

### 4.1 一句话结论

**河牌是「把故事结账」的地方，所有 equity 已固定，只有频率和范围在互相博弈。**

### 4.2 诈唬三原则（记住就够用）

1. 几乎没有摊牌价值；
2. 阻挡对手的跟注范围（比如挡住 top pair / 2nd pair）；
3. 不阻挡对手的弃牌范围（不要挡掉他 miss 的听牌）。

### 4.3 Bluffcatcher 三原则

1. 阻挡对手的 value 组合（例如挡住 nuts 同花/顺子）。
2. 不阻挡对手的 bluff（例如别拿掉他所有 miss FD）。
3. 在自己范围中属于中上游，而不是最差的一档 bluffcatcher。

---

### 4.4 简易数学：pot odds 与所需胜率

例：底池 100，对手下注 75，你需要跟 75，最终底池 250。

* 所需胜率 = 75 / (100 + 75 + 75) = 75 / 250 = 30%。
* 问自己：

  * 在我整体范围里，这手牌作为 call，赢过对手 bluff 的频率有没有 30%？

**逻辑要点：**

* 别凭「感觉」hero call，要能给自己一个大致的赢率估计：

  * 对手常 bluff？某些 blocker 对我有利？→ 可以 call 多一些。
  * 对手河牌基本不 bluff？那即便 pot odds 很诱人，也要 fold。

---

### 4.5 River Checklist

1. 我当前扮演的是哪个角色？value / bluff / bluffcatcher / fold？
2. 若 bluff：是否满足「无摊牌价值+好阻挡」的组合？
3. 若 bluffcatch：对手在这个线下，有没有足够 bluff，使得我的 call 不会长期 -EV？

---

## 5. 位置对抗概览（重点：SB vs BB / BTN vs BB）

### 5.1 SB vs BB（盲注之战）

**一句话：**
SB 永远 OOP；BB 永远 IP → SB 要靠 preflop 结构 + flop 小注保护范围，BB 要靠宽 defend + 适当 raise 惩罚。

**结构要点：**

* Preflop：

  * SB 不宜过宽 open；大量 marginal hand 会陷入 OOP 深水区。
  * SB vs BB 的 3bet 要线性、偏 value。
* Flop：

  * SB 在很多「range advantage + 干面」上，用全范围小注保护范围。
  * BB 对小注，用 call + 少量 raise 极化（强 value + 听牌）。
* Turn/River：

  * SB 的范围容易被 capped；
  * BB 作为 IP 有较多「加压」机会，包括 overbet 和 raise vs thin value。

**复盘问题：**

1. SB 是否在一个特别难打的 flop 面盲目 cbet？
2. BB 是否 defend 足够宽（别轻易让 SB 免费印盲注）？

---

### 5.2 BTN vs BB

* BTN 有位置 & 范围优势；BB 有赔率优势。
* BTN：高频小注 Cbet；
* BB：用 XR+float 防止 BTN 自动盈利；
* River：不少局面中，BTN 被 capped，BB 有 bluff raise 机会，但玩家池里几乎没人去找。

---

## 6. Exploit 系统概览

### 6.1 常见玩家类型

1. **过度弃牌型**：

   * 看到大注、看到 scare card 就秒弃。
2. **跟注站（calling station）**：

   * 只要有一对，哪怕是 bottom pair，也不肯弃。
3. **激进型（aggro）**：

   * 频繁 3bet / double barrel / triple barrel。
4. **被动型（passive）**：

   * 几乎只打 value，不 bluff。

---

### 6.2 调整模板

* vs 过度弃牌型：

  * **增加 bluff，减少 thin value。**
  * 特别是在 scare card（A/K/成同花/成顺）出来时，加大 bluff 密度。

* vs 跟注站：

  * **增加 value，几乎废除 bluff。**
  * 任何 top pair / overpair / 两对，都敢打 2/3 pot 或 overbet 收价值。

* vs 激进型：

  * OOP：多用 check-call + XR 惩罚过度 cbet。
  * IP：减少裸 bluff，多用 bluffcatcher 抓他的三枪。

* vs 被动型：

  * 对手大下注 → 极高比例是真货 → 要敢弃。
  * 自己要主动开火，别指望他 bluff 把钱送来。

---

## 7. 复盘体系（模板）

### 7.1 复盘输入结构

1. 牌局环境：盲注级别 / 有效筹码 / 赛制。
2. 玩家池 & 对手标签：松紧、激进/被动、跟注/弃牌倾向。
3. 手牌过程：Preflop–Flop–Turn–River 行动 + size。
4. 当时真实想法：每一街为什么做这个选择。
5. 复盘重点：你最纠结的 1–3 个决策点。

---

### 7.2 复盘输出结构（每手牌）

1. **一句话结论**：这手牌最大的核心问题/亮点是什么。
2. **GTO 基线 vs 玩家池现实**：

   * 如果按 GTO，你大概该怎么打；
   * 结合玩家池，这样打是否最赚。
3. **逐街节点分析**：

   * Preflop 是否选对范围线；
   * Flop 是否符合牌面结构；
   * Turn 是否胡乱极化；
   * River 是否 bluff/call 过度。
4. **数学验证**：

   * pot odds、必要胜率、rough equity。
5. **抽象策略模板**：

   * 这手牌属于哪一类 spot，例如：
     -「3BP SB vs BTN，A-high 干面」
     -「SRP BTN vs BB，T-high 湿面」
6. **个人提升建议**：

   * 下一次在同类 spot，要刻意练什么？

---

## 8. Poker OS 2.0 总结与下一步

### 8.1 一句话结论

**Poker OS 2.0 给你的不是答案，而是“有答案的那种人”的思路和结构。**

### 8.2 三点总结

1. **Preflop 决定了整个故事的「角色配置」**

   * 位置、范围结构、线性/极化决定翻后你是主动还是被动。

2. **Flop/Turn 决定了「故事的走向」**

   * 谁在这种牌面有优势，谁就用合理 size 兑现；
   * Turn 是极化与超池最关键的一街。

3. **River 决定了「故事的账单是谁付」**

   * 你要么收价值，要么诈唬，要么抓诈，要么认输；
   * 所有决策必须服从：范围结构 + 玩家池偏差 + 基础数学。

---

### 8.3 下一步怎么用这份 OS？

非常现实的用法建议：

1. **选一个模块做专精**

   * 例如先对「SB vs BB」或「河牌抓诈」做深挖，
   * 把其中的 checklist 背下来，用在下一次实战中。

2. **每周挑 3–5 手牌，按第 7 章模板复盘**

   * 固定节奏，慢慢形成你的私人“漏洞清单”。

3. **在这份 OS 上继续加内容**

   * 你可以往这份框架里塞：

     * solver 截图；
     * 你所在玩家池的真实数据；
     * 你自己常犯错误的案例。
   * 这时候它就不是我写的 OS，而是你的 Poker OS 3.0 了。

---

## 《迭代日志》

【来源】

* 基于你对「深度、专家版、按全局 Prompt 重构」的要求，重写 Poker OS，强调结构完整 + 逻辑可执行。

【结论】

* 当前输出的是一个**结构化、可落地、可迭代的 v2.0 初稿**：

  * 有方法论（0章）
  * 有 Preflop–Flop–Turn–River 主干
  * 有位置对抗与 exploit 概览
  * 有复盘模板

【缺口】

* 还没有逐位置、逐牌面、逐 3BP/ SRP 给出具体范围图与精确频率；
* SB vs BB / BTN vs BB 等高频 spot 还可以进一步展开成独立「专题章」。

【下一步建议】

* 如果你愿意，可以指定：

  * “先把 SB vs BB 写成一个完整专题（单独文档）”，
  * 或 “先把河牌 bluff/call 部分写成训练手册”，
    我就按这个 OS 框架在上面继续加深一层，写出真正“看完就能直接练”的版本。
