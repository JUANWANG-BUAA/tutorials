# 必考点竞技场

> **练和赛的地方。** 复习层解决「记和查」，这里解决「**在压力下还答得对**」——把老师
> 反复强调的必考点做成**限时、计分、连击、分关解锁**的答题场，答错的题自动进错题本，
> 直到你把它清空。目标很直白：**把这些题做到条件反射，考场才不会临时卡壳。**

::: method[core] 怎么玩（30 秒读完）

**规则**：5 关逐关解锁，每关限时（题数 × 30 秒），题目每次随机打乱。

| 机制 | 说明 |
|:--|:--|
| ✅ 计分 | 每题基础 100 分，**乘以当前连击倍率**；提前交卷还有时长奖励 |
| 🔥 连击 | 连续答对连击 +1，倍率最高 ×5（第 5 连起封顶）；答错清零 |
| 🏅 段位 | 按**正确率**评定：王者 / 钻石 / 铂金 / 黄金 / 白银 / 青铜 |
| 🚪 解锁 | 正确率 ≥ 70% 判定通关，解锁下一关 |
| 📕 错题本 | 答错自动收录（存在浏览器本地），随时回来重刷；**答对即自动移出** |
| ⌨️ 键盘 | <kbd>1</kbd>–<kbd>9</kbd> 选选项，<kbd>Enter</kbd> 下一题 |

**为什么这样设计**：考试丢分多半不是「不会」，而是**概念混淆**（必要 vs 充分、线性 vs 二阶、
特征向量 vs 特征值）与**记串**（范数取错、顺序反了）。所以这里的题专门盯**易混点**，
用「答错进错题本 + 连击清零」制造一点代价，逼你把分辨标准想起来，而不是靠模糊印象蒙对。

:::

## 段位与通关线

| 段位 | 正确率 | 含义 |
|:--|:--:|:--|
| 🥉 青铜 | $<50\%$ | 概念还没成网，回对应的「10 分钟复习版」 |
| 🥈 白银 | $\ge 50\%$ | 骨架有了，错题本要清 |
| 🥇 黄金 | $\ge 65\%$ | 基本能过线 |
| 💎 铂金 | $\ge 80\%$ | 稳 |
| 💠 钻石 | $\ge 90\%$ | 很强 |
| 👑 王者 | $100\%$ | 全对，且通常连击不断 |

**通关线**：正确率 $\ge 70\%$ 解锁下一关。分数受连击与时间影响会波动，**看正确率**判断掌握程度。

## 必考点总表（老师课堂反复强调）

这张表是题库的**出处**，也是考前最后一小时该扫的清单。每条都能在对应讲座页的「老师强调」
一节找到原话。

| 模块 | 必考点（一句话结论） | 出处 |
|:--|:--|:--|
| 误差 | 判断递推是否稳定，**只看舍入误差放大因子是否 $>1$**，不看递推式本身 | 第 1 讲 |
| 误差 | **相近数相减**最危险；改写如 $a^2-b^2=(a-b)(a+b)$ | [1.2.4](../ch01/sec12.md#sec-1.2.4) |
| 误差 | 有效数字判据 $\tfrac12\times10^{m-n}\le\varepsilon(a)$，从**第一位非零数字**数起 | [1.2.2](../ch01/sec12.md#sec-1.2.2) |
| 范数 | **相容关系** $\lVert AB\rVert\le\lVert A\rVert\lVert B\rVert$ 是后面一切的起点 | 第 2 讲 |
| 范数 | **范数等价性只在有限维成立**（无穷维不成立） | 第 2 讲 |
| 范数 | 判 $I\pm A$ 可逆，**找到一个范数使 $\lVert A\rVert<1$ 即可，不碰行列式** | [1.3.4](../ch01/sec13.md#sec-1.3.4) |
| 范数 | $\lVert A\rVert_1=$ 列和最大，$\lVert A\rVert_\infty=$ 行和最大；$\lVert A\rVert_F$ **不从属** | [1.3.4](../ch01/sec13.md#sec-1.3.4) |
| 条件数 | $\mathrm{cond}(A)\ge1$；$\mathrm{cond}(I)=1$；残差小 $\ne$ 误差小 | [补充篇 2.4](../ch02/sec24.md) |
| 线代 | 列主元的作用是**避免小主元放大舍入误差** | 第 3 讲 |
| 线代 | Doolittle（LU）需要**各阶顺序主子式非零** | 第 4 讲 |
| 线代 | 稀疏 / 三对角用 $O(n)$ 追赶法，**实际没人用朴素高斯消去** | 第 4 讲 |
| 迭代 | 收敛**充要**条件 $\rho(G)<1$；实际用**充分**条件 $\lVert G\rVert<1$ | 第 5 讲 |
| 迭代 | 误差递推盯「**下标 $+$ 幂次 $=$ 常数**」；拆法即名字（$A=N-P$） | 第 5 讲 |
| 迭代 | $\lVert G\rVert$ 接近 1 时，**相邻迭代值差小不能断定接近真解** | 第 5 讲 |
| 迭代 | SOR **必要**条件 $\omega\in(0,2)$：区间外一定不收敛，区间内不保证 | 第 6 讲 |
| 特征值 | 幂法**先单位化、再乘 $A$**，顺序不能反 | 第 7 讲 |
| 特征值 | 求**特征向量**范数任取；求**特征值必须取 2-范数**（$y_k^{\mathrm T}Ay_k\to\lambda_1$） | 第 7 讲 |
| 特征值 | 「**严格**按模最大」这个前提缺不得；实矩阵的它**必为实数** | 第 7 讲 |
| 特征值 | 反幂法**不构造 $A^{-1}$**，每步解 $Au_{k+1}=y_k$；位移 $A-pI$ 求最接近 $p$ 的特征值 | 第 7 讲 |
| 非线性 | **必要 / 充分分清**：牛顿一般定理只**局部**；四条件给**全局** | 第 9 讲 |
| 非线性 | 不动点两条件：**自映射**管不越界、**压缩**管收敛 | 第 7 讲 |
| 非线性 | 割线法**必须两个初值**，收敛阶**黄金比 $1.618$**（$r^2-r-1=0$） | 第 9 讲 |
| 插值 | $n+1$ 点确定**唯一** $n$ 次插值多项式；范德蒙德矩阵**存在唯一但病态** | 第 9 讲 |
| 插值 | 换基到**拉格朗日基**：$l_i(x_i)=1,\ l_i(x_j)=0$，系数**直接就是 $f(x_i)$** | 第 9 讲 |

## 竞技场

<div id="arena-mount"></div>

<p class="arena-bank-note">下面是完整题库（含答案与解析），既是竞技场的题源，也是一份可直接查阅的问答清单——<b>关掉脚本、打印出来读都没问题</b>。竞技场开启后它会被折叠以免剧透，点开即可对照。</p>

<div class="arena-bank" id="arena-bank">
<div class="arena-q" data-id="e1" data-lv="1" data-a="1" data-tag="误差与精度" data-point="有效数字判据" data-src="1.2.2 · 第 1–2 讲" data-href="../ch01/sec12.html#sec-1.2.2">
<p class="aq-hd"><span class="aq-id">e1</span><span class="aq-tag">误差与精度 · 有效数字判据</span></p>
<p class="aq-prompt">$a=0.0316$ 是某真值 $x$ 的近似值，绝对误差限 $\varepsilon(a)=0.00005$。$a$ 有几位有效数字？</p>
<ol class="aq-opts">
<li>2 位</li>
<li>3 位</li>
<li>4 位</li>
<li>由误差限无法确定</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>规格化 $a=0.316\times10^{-1}$，故 $m=-1$；要求 $\tfrac12\times10^{m-n}=\tfrac12\times10^{-4}=0.00005$，得 $n=3$。有效数字从**第一位非零数字**数起，小数点后紧跟的 $0$ 不算。<b>答案 B（3 位）</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e2" data-lv="1" data-a="2" data-tag="误差与精度" data-point="递推稳定性方向" data-src="1.2.4 · 第 1 讲" data-href="../ch01/sec12.html#sec-1.2.4">
<p class="aq-hd"><span class="aq-id">e2</span><span class="aq-tag">误差与精度 · 递推稳定性方向</span></p>
<p class="aq-prompt">递推 $y_n=\dfrac1n-\beta y_{n-1}$，已知 $\lvert\beta\rvert=3$。要算 $y_{100}$，应当怎样递推？</p>
<ol class="aq-opts">
<li>正向递推（由 $y_0$ 出发）</li>
<li>正反向都可以，结果一样</li>
<li>反向递推（由 $y_{100}$ 的估计出发）</li>
<li>与递推方向无关</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>误差满足 $\delta_n=-\beta\delta_{n-1}$，即 $\lvert\delta_n\rvert=3^n\lvert\delta_0\rvert$——**正向每步放大 3 倍**，$3^{100}$ 天文数字。改写 $y_{n-1}=\dfrac{1}{\beta n}-\dfrac1\beta y_n$ 后误差每步缩为 $1/3$，**反向才稳定**。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e3" data-lv="1" data-a="0" data-tag="误差与精度" data-point="灾难性抵消" data-src="1.2.4 · 第 1 讲" data-href="../ch01/sec12.html#sec-1.2.4">
<p class="aq-hd"><span class="aq-id">e3</span><span class="aq-tag">误差与精度 · 灾难性抵消</span></p>
<p class="aq-prompt">下列哪种运算最容易造成**有效数字大量流失**（灾难性抵消）？</p>
<ol class="aq-opts">
<li>两个相近的数相减</li>
<li>两个同号的大数相加</li>
<li>一个数乘上 $10^k$</li>
<li>把 $0.1$ 存成双精度浮点数</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>相近数相减时，高位有效数字相互抵消，相对误差被急剧放大。典型如 $a=1.01,b=1.00$ 时 $a^2-b^2$：应改写为 $(a-b)(a+b)$ 保住精度。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e4" data-lv="1" data-a="2" data-tag="误差与精度" data-point="误差传播" data-src="1.2.3 · 第 1 讲" data-href="../ch01/sec12.html">
<p class="aq-hd"><span class="aq-id">e4</span><span class="aq-tag">误差与精度 · 误差传播</span></p>
<p class="aq-prompt">已知 $a=2.00\pm0.005$，$b=1.00\pm0.005$。$u=a^2-b^2$ 的**相对误差限**约为多少？</p>
<ol class="aq-opts">
<li>$0.5\%$</li>
<li>$0.33\%$</li>
<li>$1\%$</li>
<li>$3\%$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>$\dfrac{\partial u}{\partial a}=2a=4$，$\dfrac{\partial u}{\partial b}=-2b=-2$，故 $\varepsilon(u)\approx4\times0.005+2\times0.005=0.03$，$u=3.00$，相对误差 $0.03/3=1\%$。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e5" data-lv="1" data-a="1" data-tag="误差与精度" data-point="有效数字与相对误差" data-src="1.2.2 · 第 1 讲" data-href="../ch01/sec12.html#sec-1.2.2">
<p class="aq-hd"><span class="aq-id">e5</span><span class="aq-tag">误差与精度 · 有效数字与相对误差</span></p>
<p class="aq-prompt">若近似值有 $n$ 位有效数字（首位数字为 $a_1$），则其**相对误差限**大致是</p>
<ol class="aq-opts">
<li>$\dfrac{1}{a_1}\times10^{-n}$</li>
<li>$\dfrac{1}{2a_1}\times10^{-(n-1)}$</li>
<li>$\dfrac{1}{2}\times10^{-n}$</li>
<li>$a_1\times10^{-(n-1)}$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>有效数字越多，相对误差限越小：$n$ 位有效数字对应 $\varepsilon_{\mathrm r}\lesssim\dfrac{1}{2a_1}\times10^{-(n-1)}$（$a_1$ 为首位）。常数因子因教材而异，但**指数 $-(n-1)$ 与首位数 $a_1$ 的位置**是考点。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e6" data-lv="1" data-a="0" data-tag="误差与精度" data-point="秦九韶（Horner）" data-src="1.2.6 · 第 1–2 讲" data-href="../ch01/sec12.html">
<p class="aq-hd"><span class="aq-id">e6</span><span class="aq-tag">误差与精度 · 秦九韶（Horner）</span></p>
<p class="aq-prompt">用秦九韶（Horner）算法求多项式的值，相比逐项求和，主要好处是</p>
<ol class="aq-opts">
<li>乘法次数由 $O(n^2)$ 降到 $O(n)$，且数值更稳</li>
<li>能自动求出多项式的根</li>
<li>把除法变成乘法</li>
<li>与逐项求和完全等价，没有任何区别</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>Horner 把 $a_0+a_1x+\cdots+a_nx^n$ 改写成嵌套形式，乘法次数降到 $n$ 次（而非 $O(n^2)$），且减少了中间量的误差累积。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e7" data-lv="1" data-a="2" data-tag="误差与精度" data-point="误差四分类" data-src="1.1 · 第 1 讲" data-href="../lectures/lec01.html">
<p class="aq-hd"><span class="aq-id">e7</span><span class="aq-tag">误差与精度 · 误差四分类</span></p>
<p class="aq-prompt">在数值分析的四类误差中，**本课程能控制、也正是要研究的对象**是</p>
<ol class="aq-opts">
<li>模型误差</li>
<li>观测误差</li>
<li>截断误差</li>
<li>舍入误差</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>模型误差、观测误差来自问题本身，无法消除；舍入误差由机器字长决定（但其**传播**可控）；**截断误差**来自算法对无穷过程的截断，是算法设计的核心研究对象。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e8" data-lv="2" data-a="2" data-tag="范数与条件数" data-point="矩阵范数计算" data-src="1.3.4 · 第 2–3 讲" data-href="../ch01/sec13.html#sec-1.3.4">
<p class="aq-hd"><span class="aq-id">e8</span><span class="aq-tag">范数与条件数 · 矩阵范数计算</span></p>
<p class="aq-prompt">设 $A=\begin{pmatrix}1&-2\\3&4\end{pmatrix}$。$\lVert A\rVert_\infty$（行和范数）等于多少？</p>
<ol class="aq-opts">
<li>4</li>
<li>6</li>
<li>7</li>
<li>$\sqrt{1+4+9+16}$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>$\lVert A\rVert_\infty$ 取**行和最大**：第 1 行 $1+2=3$，第 2 行 $3+4=7$，故为 $7$。注意 $\lVert A\rVert_1$ 才是列和最大（此例为 $\max(1+3,\ 2+4)=6$）。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e9" data-lv="2" data-a="1" data-tag="范数与条件数" data-point="F-范数非从属" data-src="1.3.4 · 第 2–3 讲" data-href="../ch01/sec13.html#sec-1.3.4">
<p class="aq-hd"><span class="aq-id">e9</span><span class="aq-tag">范数与条件数 · F-范数非从属</span></p>
<p class="aq-prompt">Frobenius 范数 $\lVert A\rVert_F$ 是否从属于某个向量范数（即是否算子范数）？</p>
<ol class="aq-opts">
<li>是，从属于 2-范数</li>
<li>不是——$\lVert I\rVert_F=\sqrt2\neq1$，任何算子范数都要求 $\lVert I\rVert=1$</li>
<li>是，从属于 $F$ 范数</li>
<li>只有当 $A$ 对称时才是</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>算子范数必满足 $\lVert I\rVert=1$；而 $\lVert I_n\rVert_F=\sqrt n\neq1\ (n>1)$，故 $\lVert\cdot\rVert_F$ **不从属**于任何向量范数。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e10" data-lv="2" data-a="0" data-tag="范数与条件数" data-point="相容性不等式" data-src="1.3.5 · 第 2 讲" data-href="../ch01/sec13.html">
<p class="aq-hd"><span class="aq-id">e10</span><span class="aq-tag">范数与条件数 · 相容性不等式</span></p>
<p class="aq-prompt">矩阵范数与向量范数**相容**的含义，以及矩阵范数之间的乘积不等式是</p>
<ol class="aq-opts">
<li>$\lVert A\boldsymbol{x}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$，$\lVert AB\rVert\le\lVert A\rVert\lVert B\rVert$</li>
<li>$\lVert A\boldsymbol{x}\rVert\ge\lVert A\rVert\lVert\boldsymbol{x}\rVert$</li>
<li>$\lVert AB\rVert=\lVert A\rVert\lVert B\rVert$ 恒成立</li>
<li>$\lVert AB\rVert\ge\lVert A\rVert\lVert B\rVert$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>相容性即 $\lVert A\boldsymbol{x}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$，由此推出**次乘性** $\lVert AB\rVert\le\lVert A\rVert\lVert B\rVert$。老师强调这是**后面全部内容的起点**（$\lVert A\rVert<1\Rightarrow I\pm A$ 可逆、迭代收敛定理都靠它）。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e11" data-lv="2" data-a="1" data-tag="范数与条件数" data-point="‖A‖＜1 可逆" data-src="1.3.4 · 第 3 讲" data-href="../ch01/sec13.html#sec-1.3.4">
<p class="aq-hd"><span class="aq-id">e11</span><span class="aq-tag">范数与条件数 · ‖A‖＜1 可逆</span></p>
<p class="aq-prompt">已知 $\lVert A\rVert_1=0.7$。下列结论哪个**正确且最省事**？</p>
<ol class="aq-opts">
<li>要算 $\det A$ 才知道 $I+A$ 是否可逆</li>
<li>$I+A$ 可逆（因 $\lVert A\rVert_1<1$，Neumann 级数收敛）</li>
<li>$I+A$ 一定不可逆</li>
<li>$\lVert A\rVert_1<1$ 与可逆性无关</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>$\lVert A\rVert<1\Rightarrow I\pm A$ 可逆且 $(I-A)^{-1}=\sum A^k$。**判可逆只需找到一个范数使 $\lVert A\rVert<1$，完全不用算行列式**——这正是老师强调的考点。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e12" data-lv="2" data-a="2" data-tag="范数与条件数" data-point="条件数下界" data-src="补充 2.4 · 第 2–3 讲" data-href="../ch02/sec24.html">
<p class="aq-hd"><span class="aq-id">e12</span><span class="aq-tag">范数与条件数 · 条件数下界</span></p>
<p class="aq-prompt">对可逆矩阵 $A$，条件数 $\mathrm{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert$ 的下界是</p>
<ol class="aq-opts">
<li>$0$</li>
<li>$\dfrac1n$</li>
<li>$1$，且 $\mathrm{cond}(I)=1$</li>
<li>$\lVert A\rVert$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>由 $I=AA^{-1}$ 得 $1=\lVert I\rVert\le\lVert A\rVert\lVert A^{-1}\rVert=\mathrm{cond}(A)$；等号在 $A=\alpha I$ 处取得，故 $\mathrm{cond}(I)=1$（最良态）。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e13" data-lv="2" data-a="1" data-tag="范数与条件数" data-point="范数等价性" data-src="1.3.3 · 第 2 讲" data-href="../ch01/sec13.html">
<p class="aq-hd"><span class="aq-id">e13</span><span class="aq-tag">范数与条件数 · 范数等价性</span></p>
<p class="aq-prompt">关于向量范数的等价性，下列说法正确的是</p>
<ol class="aq-opts">
<li>任意两个范数在任何线性空间上都等价</li>
<li>有限维空间上任意两个范数等价；**无穷维空间上不一定**</li>
<li>只有 1-范数与 2-范数等价</li>
<li>范数等价性是个假命题</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>范数等价性依赖**有限维**（单位球紧性）。无穷维空间（如函数空间）上不同范数可以不等价。老师特别点出这一限定的适用范围。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e14" data-lv="2" data-a="0" data-tag="范数与条件数" data-point="算子范数定义" data-src="1.3.4 · 第 2–3 讲" data-href="../ch01/sec13.html#sec-1.3.4">
<p class="aq-hd"><span class="aq-id">e14</span><span class="aq-tag">范数与条件数 · 算子范数定义</span></p>
<p class="aq-prompt">矩阵的**算子范数**（从属范数）的定义是</p>
<ol class="aq-opts">
<li>$\lVert A\rVert=\max\limits_{\boldsymbol{x}\neq\boldsymbol{0}}\dfrac{\lVert A\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}$</li>
<li>$\lVert A\rVert=\sum_{i,j}\lvert a_{ij}\rvert$</li>
<li>$\lVert A\rVert=\max_{i,j}\lvert a_{ij}\rvert$</li>
<li>$\lVert A\rVert=\sqrt{\operatorname{tr}(A^{\mathrm T}A)}$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>算子范数由向量范数诱导：$\lVert A\rVert=\max_{\boldsymbol x\ne 0}\lVert A\boldsymbol x\rVert/\lVert\boldsymbol x\rVert=\max_{\lVert\boldsymbol x\rVert=1}\lVert A\boldsymbol x\rVert$。选项 D 是 $\lVert A\rVert_F$，它**不是**算子范数。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e15" data-lv="3" data-a="1" data-tag="线性方程组与迭代法" data-point="列主元的作用" data-src="第 3 讲" data-href="../lectures/lec03.html">
<p class="aq-hd"><span class="aq-id">e15</span><span class="aq-tag">线性方程组与迭代法 · 列主元的作用</span></p>
<p class="aq-prompt">高斯消去法中采用**列主元**（部分选主元）的主要目的是</p>
<ol class="aq-opts">
<li>把算法复杂度从 $O(n^3)$ 降到 $O(n^2)$</li>
<li>避免小主元作除数放大舍入误差，提高数值稳定性</li>
<li>使消去过程一定能用整数运算完成</li>
<li>让矩阵变成三对角</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>列主元通过交换行，选绝对值最大的元素作主元，避免「除以很小的数」把舍入误差放大。复杂度仍是 $O(n^3)$，与是否选主元无关。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e16" data-lv="3" data-a="2" data-tag="线性方程组与迭代法" data-point="LU 分解条件" data-src="第 4 讲" data-href="../lectures/lec04.html">
<p class="aq-hd"><span class="aq-id">e16</span><span class="aq-tag">线性方程组与迭代法 · LU 分解条件</span></p>
<p class="aq-prompt">对方阵 $A$ 做 Doolittle（$L$ 单位下三角、$U$ 上三角）分解，**无需换行即可进行**的充分条件是</p>
<ol class="aq-opts">
<li>$A$ 对称正定</li>
<li>$A$ 是严格对角占优的</li>
<li>$A$ 的各阶顺序主子式均非零</li>
<li>$A$ 的行列式不为零</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>Doolittle 分解能逐步进行，当且仅当各阶顺序主子式均非零（$\det A\ne0$ 不够——那只是可逆）。严格对角占优是更强的**充分**条件（能保证非奇异），但标准表述是顺序主子式。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e17" data-lv="3" data-a="0" data-tag="线性方程组与迭代法" data-point="迭代收敛充要条件" data-src="第 5 讲" data-href="../lectures/lec05.html">
<p class="aq-hd"><span class="aq-id">e17</span><span class="aq-tag">线性方程组与迭代法 · 迭代收敛充要条件</span></p>
<p class="aq-prompt">对迭代式 $\boldsymbol{x}^{(k+1)}=G\boldsymbol{x}^{(k)}+\boldsymbol{d}$，其收敛的**充要**条件是</p>
<ol class="aq-opts">
<li>$\rho(G)<1$</li>
<li>$\lVert G\rVert<1$（某个范数）</li>
<li>$G$ 对称正定</li>
<li>$\lVert G\rVert_\infty<1$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>**充要**条件是谱半径 $\rho(G)<1$（[第 5 讲](../lectures/lec05.html)）。$\lVert G\rVert<1$ 只是**充分**条件——因为 $\rho(G)\le\lVert G\rVert$，范数小必收敛，但收敛不要求范数小。大规模问题算不出特征根，才退而用范数充分条件。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e18" data-lv="3" data-a="2" data-tag="线性方程组与迭代法" data-point="对角占优与收敛" data-src="第 5 讲" data-href="../lectures/lec05.html">
<p class="aq-hd"><span class="aq-id">e18</span><span class="aq-tag">线性方程组与迭代法 · 对角占优与收敛</span></p>
<p class="aq-prompt">若 $A$ 是**严格对角占优**矩阵，则</p>
<ol class="aq-opts">
<li>只有 Jacobi 迭代收敛，Gauss–Seidel 不保证</li>
<li>只有 Gauss–Seidel 收敛，Jacobi 不保证</li>
<li>Jacobi 与 Gauss–Seidel 迭代**都**收敛</li>
<li>两种迭代都可能发散</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>严格对角占优 $\Rightarrow$ 非奇异，且 Jacobi 与 Gauss–Seidel 的迭代矩阵谱半径都 $<1$，**两者都收敛**（对角占优是“万金油”式充分条件）。注意一般不占优时，二者没有“谁推出谁”的关系。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e19" data-lv="3" data-a="1" data-tag="线性方程组与迭代法" data-point="SOR 必要条件" data-src="第 6 讲" data-href="../lectures/lec06.html">
<p class="aq-hd"><span class="aq-id">e19</span><span class="aq-tag">线性方程组与迭代法 · SOR 必要条件</span></p>
<p class="aq-prompt">逐次超松弛（SOR）法收敛的**必要**条件是松弛因子满足</p>
<ol class="aq-opts">
<li>$\omega>0$</li>
<li>$0<\omega<2$</li>
<li>$1<\omega<2$（超松弛）</li>
<li>$\omega\ne0$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>SOR 收敛的必要条件是 $0<\omega<2$：**区间外一定不收敛，区间内不保证收敛**——这正是老师强调「必要 / 充分必须分清」的地方。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e20" data-lv="3" data-a="0" data-tag="线性方程组与迭代法" data-point="误差估计规律" data-src="第 5 讲" data-href="../lectures/lec05.html">
<p class="aq-hd"><span class="aq-id">e20</span><span class="aq-tag">线性方程组与迭代法 · 误差估计规律</span></p>
<p class="aq-prompt">由迭代误差递推 $\lVert \boldsymbol{e}^{(k)}\rVert\le\lVert G\rVert^k\lVert \boldsymbol{e}^{(0)}\rVert$，老师提醒盯的规律是</p>
<ol class="aq-opts">
<li>「下标 $+$ 幂次 $=$ 常数」——误差按 $\lVert G\rVert^k$ 收敛</li>
<li>误差与 $k$ 无关</li>
<li>误差每步增加 $\lVert G\rVert$ 倍</li>
<li>只要相邻两次迭代值差很小，就一定接近真解</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>误差以 $\lVert G\rVert^k$ 衰减，看递推式时盯「下标 + 幂次 = 常数」能快速写出误差界。**注意选项 D 是陷阱**：$\lVert G\rVert$ 接近 1 时，相邻迭代值差小**不能**断定接近真解。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e21" data-lv="3" data-a="1" data-tag="线性方程组与迭代法" data-point="矩阵分裂" data-src="第 5 讲" data-href="../lectures/lec05.html">
<p class="aq-hd"><span class="aq-id">e21</span><span class="aq-tag">线性方程组与迭代法 · 矩阵分裂</span></p>
<p class="aq-prompt">「拆法即名字」——Jacobi、Gauss–Seidel、SOR 三者都由 $A=N-P$ 的分裂决定。它们对 $A=L+D+U$ 的**分裂方式**，共同点是</p>
<ol class="aq-opts">
<li>都取 $N=L+U$、$P=D$</li>
<li>都取 $P$ 包含对角部分 $D$（严格三角部分归入 $N$）</li>
<li>都把整个 $A$ 当作 $P$</li>
<li>都要求 $A$ 对称</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>三种方法都把**对角部分 $D$ 留在 $P$**、把严格的上下三角部分放进 $N$（Gauss–Seidel 再取 $P=D+L$、SOR 用 $\omega$ 加权）。名字由「怎么拆」决定——这就是「拆法即名字」。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e22" data-lv="3" data-a="2" data-tag="线性方程组与迭代法" data-point="稀疏与复杂度" data-src="第 4 讲" data-href="../lectures/lec04.html">
<p class="aq-hd"><span class="aq-id">e22</span><span class="aq-tag">线性方程组与迭代法 · 稀疏与复杂度</span></p>
<p class="aq-prompt">对**三对角**线性方程组，工程上主流的直接解法是</p>
<ol class="aq-opts">
<li>朴素高斯消去（$O(n^3)$）</li>
<li>先算 $A^{-1}$ 再乘（$O(n^3)$）</li>
<li>追赶法（Thomas 算法，$O(n)$）</li>
<li>二分法</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>三对角结构下，追赶法利用稀疏性把工作量降到 $O(n)$。老师反复强调：**实际中没人用朴素高斯消去**，「稀疏 / 三对角 $O(n)$ 方法才是工程主流」。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e23" data-lv="4" data-a="2" data-tag="特征值与幂法" data-point="幂法顺序" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e23</span><span class="aq-tag">特征值与幂法 · 幂法顺序</span></p>
<p class="aq-prompt">规范化幂法（power method）每步的正确操作顺序是</p>
<ol class="aq-opts">
<li>先乘 $A$，再单位化</li>
<li>只乘 $A$，不需要单位化</li>
<li>先单位化，再乘 $A$</li>
<li>顺序无所谓，结果一样</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>**先单位化、再乘 $A$**：$y_k=u_k/\lVert u_k\rVert$，$u_{k+1}=Ay_k$。顺序反了就会溢出（$\lambda_1^k$ 增长过快）。老师原话：「你要记住是先单位化，单位化之后的那个东西我再给它乘 $A$。」<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e24" data-lv="4" data-a="1" data-tag="特征值与幂法" data-point="特征值的 2-范数提取" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e24</span><span class="aq-tag">特征值与幂法 · 特征值的 2-范数提取</span></p>
<p class="aq-prompt">用幂法求特征值时，$y_k^{\mathrm T}Ay_k\to\lambda_1$ 这一公式**必须**在什么范数下才成立？</p>
<ol class="aq-opts">
<li>任何范数都行</li>
<li>2-范数（此时 $\lVert y_k\rVert_2=1$，故比值化简为 $y_k^{\mathrm T}Ay_k$）</li>
<li>必须 $\infty$-范数</li>
<li>必须 1-范数</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>计算**特征向量**时范数任取；计算**特征值**时必须取 **2-范数**：只有 2-范数下 $y_k^{\mathrm T}y_k=\lVert y_k\rVert_2^2=1$，$y_k^{\mathrm T}Ay_k$ 才恰好趋于 $\lambda_1$。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e25" data-lv="4" data-a="0" data-tag="特征值与幂法" data-point="严格按模最大" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e25</span><span class="aq-tag">特征值与幂法 · 严格按模最大</span></p>
<p class="aq-prompt">幂法推导的全部依据建立在哪个前提上？</p>
<ol class="aq-opts">
<li>存在一个按模**严格**最大的特征值：$\lvert\lambda_1\rvert>\lvert\lambda_2\rvert\ge\cdots\ge\lvert\lambda_n\rvert$</li>
<li>$A$ 是对称矩阵</li>
<li>所有特征值互不相同</li>
<li>$A$ 可逆</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>「**严格**按模最大」这个前提缺不得：它保证 $\lvert\lambda_i/\lambda_1\rvert<1$，主特征分量才能压过其余。且实矩阵的按模严格最大特征值**必为实数**（否则共轭特征值模相同，矛盾）。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e26" data-lv="4" data-a="2" data-tag="特征值与幂法" data-point="反幂法实现" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e26</span><span class="aq-tag">特征值与幂法 · 反幂法实现</span></p>
<p class="aq-prompt">反幂法求按模最小的特征值，实际计算时应当</p>
<ol class="aq-opts">
<li>先显式求出 $A^{-1}$，再套幂法</li>
<li>用 $\det A$ 和伴随矩阵求 $A^{-1}$</li>
<li>**不构造 $A^{-1}$**，每步解线性方程组 $Au_{k+1}=y_k$</li>
<li>直接对 $A$ 用幂法即可</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>「我们并不知道 $A$ 逆，我们只知道 $A$。」把 $u_{k+1}=A^{-1}y_k$ 改写成**每步解一个方程组** $Au_{k+1}=y_k$，用 LU 分解或迭代法解——这才与第 3、4 讲衔接。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e27" data-lv="4" data-a="1" data-tag="特征值与幂法" data-point="位移反幂法" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e27</span><span class="aq-tag">特征值与幂法 · 位移反幂法</span></p>
<p class="aq-prompt">已知 $\lambda_k$ 的一个近似值 $p$，想精确求出 $\lambda_k$，应当对哪个矩阵用反幂法？</p>
<ol class="aq-opts">
<li>$A$ 本身</li>
<li>$A-pI$（位移后，$p$ 最接近的那个特征值变成模最小的）</li>
<li>$A^{-1}$</li>
<li>$pA$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>位移法：$A-pI$ 的特征值是 $\lambda_i-p$，其中 $\lvert\lambda_k-p\rvert$ 最小。对 $A-pI$ 用反幂法求出 $\lambda_k-p$，再加回 $p$ 得 $\lambda_k$。这是量子力学能级「精修」的标准手段。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e28" data-lv="4" data-a="0" data-tag="特征值与幂法" data-point="谱半径与范数" data-src="补充 2.5 · 第 6–7 讲" data-href="../ch02/sec25.html">
<p class="aq-hd"><span class="aq-id">e28</span><span class="aq-tag">特征值与幂法 · 谱半径与范数</span></p>
<p class="aq-prompt">对任意矩阵 $A$ 与任意**算子**范数，谱半径满足</p>
<ol class="aq-opts">
<li>$\rho(A)\le\lVert A\rVert$（等号对正规矩阵成立）</li>
<li>$\rho(A)\ge\lVert A\rVert$</li>
<li>$\rho(A)=\lVert A\rVert$ 恒成立</li>
<li>二者没有确定的大小关系</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>$\rho(A)\le\lVert A\rVert$ 对一切算子范数成立；正规矩阵（含对称、正交）取等号。这正是「$\lVert G\rVert<1$ 是收敛的**充分**条件」的由来（因为 $\rho(G)\le\lVert G\rVert$）。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e29" data-lv="5" data-a="1" data-tag="非线性方程与插值" data-point="二分法" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e29</span><span class="aq-tag">非线性方程与插值 · 二分法</span></p>
<p class="aq-prompt">设 $f$ 在 $[a,b]$ 上连续且 $f(a)f(b)<0$。二分法经 $n$ 次折半后的误差限是</p>
<ol class="aq-opts">
<li>$\dfrac{b-a}{n}$</li>
<li>$\dfrac{b-a}{2^n}$</li>
<li>$\dfrac{b-a}{2n}$</li>
<li>$(b-a)^n$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>由介值定理有根；每折半一次区间长度减半，故 $n$ 次后 $|[a_n,b_n]|=\dfrac{b-a}{2^n}$。根始终被夹在其中，误差随区间长度一起变小。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e30" data-lv="5" data-a="2" data-tag="非线性方程与插值" data-point="不动点迭代两条件" data-src="第 7 讲" data-href="../lectures/lec07.html">
<p class="aq-hd"><span class="aq-id">e30</span><span class="aq-tag">非线性方程与插值 · 不动点迭代两条件</span></p>
<p class="aq-prompt">不动点迭代 $x_{k+1}=\varphi(x_k)$ 收敛定理的两个条件，**各自的作用**是</p>
<ol class="aq-opts">
<li>两个条件都只用来保证唯一性</li>
<li>第一条管收敛速度，第二条管存在性</li>
<li>第一条（自映射）管迭代值**不越出区间**，第二条（压缩 $\lvert\varphi'\rvert\le L<1$）管**收敛**</li>
<li>两条缺一不可，但都与越界无关</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>自映射 $\varphi([a,b])\subseteq[a,b]$ 保证 $x_k$ 始终留在 $[a,b]$ 内（不越界）；压缩条件 $\lvert\varphi'(x)\rvert\le L<1$ 把误差逐次缩小，保证收敛到**唯一**不动点。老师强调**两条各管什么**别记串。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e31" data-lv="5" data-a="0" data-tag="非线性方程与插值" data-point="牛顿法二阶收敛" data-src="第 8 讲" data-href="../lectures/lec09.html">
<p class="aq-hd"><span class="aq-id">e31</span><span class="aq-tag">非线性方程与插值 · 牛顿法二阶收敛</span></p>
<p class="aq-prompt">牛顿法 $x_{k+1}=x_k-\dfrac{f(x_k)}{f'(x_k)}$ 具有（至少）二阶收敛，其根本原因是</p>
<ol class="aq-opts">
<li>对应迭代函数 $\varphi(x)=x-\dfrac{f(x)}{f'(x)}$ 在根处 $\varphi'(s)=0$</li>
<li>它每步都做除法</li>
<li>它用了二阶导数</li>
<li>它与二分法等价</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>收敛阶定理说：$\varphi'(s)=\cdots=\varphi^{(m-1)}(s)=0,\ \varphi^{(m)}(s)\ne0\Rightarrow m$ 阶。牛顿法 $\varphi'(s)=\dfrac{f(s)f''(s)}{[f'(s)]^2}=0$（因 $f(s)=0$），故**至少二阶**。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e32" data-lv="5" data-a="1" data-tag="非线性方程与插值" data-point="牛顿全局收敛四条件" data-src="第 9 讲" data-href="../lectures/lec09.html">
<p class="aq-hd"><span class="aq-id">e32</span><span class="aq-tag">非线性方程与插值 · 牛顿全局收敛四条件</span></p>
<p class="aq-prompt">牛顿法**全局收敛定理**的四条条件中，核心是「**凸性与单调性都不变**」。下列哪条**不属于**这四条？</p>
<ol class="aq-opts">
<li>$f(a)f(b)<0$</li>
<li>$f''(x_0)\neq0$ 且 $f''$ 在 $[a,b]$ 上变号</li>
<li>$f'(x)$ 在 $[a,b]$ 上不为零</li>
<li>$f(x_0)f''(x_0)>0$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>四条件是：(1) 端点异号；(2) $f''$ 不变号（凸性不变）；(3) $f'$ 在 $[a,b]$ 上不为零（严格单调，且牛顿步分母非零）；(4) $f(x_0)f''(x_0)>0$。选项 B 说 $f''$ **变号**，与条件 (2) 相反，**不属于**四条件——注意题目问的是「不属于」。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e33" data-lv="5" data-a="2" data-tag="非线性方程与插值" data-point="割线法两初值" data-src="第 9 讲" data-href="../lectures/lec09.html">
<p class="aq-hd"><span class="aq-id">e33</span><span class="aq-tag">非线性方程与插值 · 割线法两初值</span></p>
<p class="aq-prompt">割线法 $x_{k+1}=x_k-\dfrac{f(x_k)(x_k-x_{k-1})}{f(x_k)-f(x_{k-1})}$ 需要几个初值？</p>
<ol class="aq-opts">
<li>一个（$x_0$ 即可）</li>
<li>三个</li>
<li>两个（$x_0,x_1$，因为用到前两步）</li>
<li>不需要初值</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>割线法用**差商**代替导数，公式里同时出现 $x_k$ 与 $x_{k-1}$，故**必须提供两个初值**。它比牛顿法省一次求导，代价是收敛阶从 2 降到 $1.618$。<b>答案 C</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e34" data-lv="5" data-a="1" data-tag="非线性方程与插值" data-point="割线法收敛阶" data-src="第 9 讲" data-href="../lectures/lec09.html">
<p class="aq-hd"><span class="aq-id">e34</span><span class="aq-tag">非线性方程与插值 · 割线法收敛阶</span></p>
<p class="aq-prompt">割线法的收敛阶 $r$ 满足</p>
<ol class="aq-opts">
<li>$r=2$（与牛顿法相同）</li>
<li>$r^2-r-1=0$，$r=\dfrac{1+\sqrt5}{2}\approx1.618$</li>
<li>$r=1$（线性）</li>
<li>$r=3$</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>割线法的阶是**黄金比** $1.618$，由 $r^2=r+1$ 定出——介于线性（1）与二阶（2）之间的**超线性**收敛。别按整数记。<b>答案 B</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e35" data-lv="5" data-a="0" data-tag="非线性方程与插值" data-point="单点割线法" data-src="第 9 讲" data-href="../lectures/lec09.html">
<p class="aq-hd"><span class="aq-id">e35</span><span class="aq-tag">非线性方程与插值 · 单点割线法</span></p>
<p class="aq-prompt">把割线法中的 $x_{k-1}$ **钉死为固定点 $x_0$**，得到单点割线法，其收敛阶变为</p>
<ol class="aq-opts">
<li>一阶（线性收敛）</li>
<li>仍为黄金比 $1.618$</li>
<li>二阶</li>
<li>不收敛</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>单点割线法每次都用固定点 $(x_0,f(x_0))$ 与当前点连线，**收敛阶降为一阶**。这是「松一步、掉一档」的又一例：牛顿（2）→ 割线（1.618）→ 单点割线（1）。<b>答案 A</b>。</p></div></details>
</div>
<div class="arena-q" data-id="e36" data-lv="5" data-a="2" data-tag="非线性方程与插值" data-point="拉格朗日基" data-src="第 9 讲" data-href="../lectures/lec09.html">
<p class="aq-hd"><span class="aq-id">e36</span><span class="aq-tag">非线性方程与插值 · 拉格朗日基</span></p>
<p class="aq-prompt">拉格朗日基函数 $l_i(x)=\prod_{j\neq i}\dfrac{x-x_j}{x_i-x_j}$ 的关键性质，以及插值公式 $L_n(x)=\sum_i f(x_i)l_i(x)$ 中系数为何**直接读出**，正确的是</p>
<ol class="aq-opts">
<li>$l_i(x)$ 在所有节点上都等于 1</li>
<li>$l_i(x_i)=0,\ l_i(x_j)=1\ (j\neq i)$</li>
<li>$l_i(x_i)=1,\ l_i(x_j)=0\ (j\neq i)$，故第 $i$ 个插值条件只剩 $b_i=f(x_i)$</li>
<li>系数需要解范德蒙德方程组才能确定</li>
</ol>
<details class="aq-exp"><summary>解析</summary><div class="exp-body"><p>拉格朗日基是「点灯」基：在**自己的节点取 1、其他节点取 0**。代入节点 $x_i$ 时其余项全为 0，方程退化为 $b_i=f(x_i)$——**系数就是函数值**，一步不用解病态的范德蒙德方程组。<b>答案 C</b>。</p></div></details>
</div>
</div>

## 练完去哪

- 想做**整卷、计分、限时**的模拟：进[考场模拟卷](exam-sprint.md)（100 分制，含评分标准与真实场景题）。
- 概念还是含糊：回[易混对照卡](../review/contrast-cards.md)与[公式结论卡](../review/formula-cards.md)。
- 某一关错得多：点错题本里的链接回到对应讲座页的「老师强调」一节精读，再重刷该关。
