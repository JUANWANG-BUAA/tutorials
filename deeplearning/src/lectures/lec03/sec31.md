# 3.1 为什么是卷积：归纳偏置的力量

第 1 讲给了我们一个通用范式：**结构 + 损失 + 梯度下降**。按这个范式，处理图像最直接的做法就是把图像展平成一个长向量，喂给多层感知机（MLP）。这个做法在数学上完全合法，在工程上却是一场灾难——本节要把它失败的原因算清楚，由此引出整个第 3 讲的主角：**卷积**。

更值得注意的是失败的**方式**：把每张图都用随机平移再补零的方式扩增，MLP 也能「学会」平移不变，只是要为此付出多几个数量级的样本与参数。也就是说，MLP 缺的不是能力，而是**把「图像该长什么样」的先验写进结构**这一步。这个先验就是本讲反复出现的词：**归纳偏置**（inductive bias）。

这一节的结论会成为后九节的地基：**卷积 = 局部连接 + 权值共享 + 平移等变**，它用「关于图像的先验假设」换来了「参数量的四个数量级」与「泛化所需样本量」。

## 3.1.1 全连接处理图像的两宗罪

先把账算出来。一张 $224\times224$ 的 RGB 图有 $224\times224\times3=150{,}528$ 个数。

::: ex 例 3.1.1 · 全连接第一层的参数量 {#ex-3.1.1}
把 $224\times224\times3$ 的图像**展平**成一个向量，接一层 $1000$ 维的全连接隐层（不带偏置）。求这一层的参数量；并回答：若改用 $3\times3$ 卷积（输入输出都是 $64$ 通道），参数量是多少？

::: proof 解
**全连接层**：每个输出单元都连到全部的 $150{,}528$ 个输入像素，

$$150{,}528\times1000=1.50528\times10^{8}\approx1.5\times10^{8}\ \text{个权重}.$$

这还只是**第一层**。若再接一层 $1000\to1000$，又是 $10^6$ 个参数；参数量的大头被结构性地锁在「输入维数 × 隐层维数」这个乘积里。

**卷积层**：$3\times3$ 核、$C_{in}=C_{out}=64$ 时（公式见 [3.2.4](sec32.md#sec-3.2.4)）

$$C_{out}\times C_{in}\times k^2=64\times64\times9=36{,}864 .$$

两者之比

$$\frac{1.5\times10^{8}}{3.7\times10^{4}}\approx4000 .$$

**差三个半到四个数量级**。这就是第一宗罪：**参数爆炸**。

:::
:::

参数多本身还不是致命的——如果数据足够多，参数多只是贵。真正致命的是第二宗罪。

::: def 定义 3.1.1 · 展平丢弃空间结构 {#def-3.1.1}
把图像 $X\in\mathbb R^{H\times W\times C}$ 按固定顺序拉直成 $\boldsymbol x\in\mathbb R^{HWC}$ 的操作称为**展平**（flatten）。展平后：

1. 相邻像素（如 $(i,j)$ 与 $(i,j+1)$）在向量里可能相邻，也可能跨行远离；**「谁挨着谁」这一信息只以「下标差」的形式隐式保留**，而全连接层对下标没有任何偏好——它给每一对（输入维，输出维）独立分配权重。
2. 于是「同一图案出现在不同位置」被当成**完全不同的输入模式**：网络必须为左上角的眼睛和右下角的眼睛各学一套权重。
:::

::: intuition 展平这件事到底丢掉了什么
图像是一个**二维网格**，网格上相邻的像素在物理世界中也是相邻的——这是最强的先验。展平把它变成了一条线性的下标序列，于是「相邻」只剩下「下标差 1」这一种形式。

后果有两个，都很具体：**① 参数冗余**——同一个图案出现在不同位置时，网络为每一个位置各记一套权重（同一概念被重复学几百遍）；**② 对平移没有结构性的对策**——模型只能靠看到大量"同一物体出现在不同位置"的样本，自己归纳出这个规律。这两点加起来，就是「用数据换结构」的代价。下一节的卷积会用一条假设（**同一个检测器在所有位置都适用**）把这两个代价同时消掉。

一个值得记住的判断：**把先验写进结构，等于提前排除了大量不可能的假设**，因此能用少得多的样本学到规律——但前提是这个先验在你的任务上确实成立（[定义 3.1.3](#def-3.1.3) 会给出代价的表述）。
:::

::: intuition 两宗罪其实是一回事
参数爆炸与无视空间结构是同一个原因的两个后果：**全连接层假设输入的每一个维度都同等重要、彼此可任意组合**（所谓「置换等变」）。这个假设对表格数据是合理的——把「身高、体重、年龄」三列换个顺序，任务不该变；但图像不是这样：把像素顺序打乱，图像就毁了。**结构没有告诉网络「哪些维度是邻居」，网络只能靠海量参数与样本自己学出来**，这就是代价的来源。
:::

## 3.1.2 卷积的三种归纳偏置

卷积用三件武器同时处理这两宗罪。

::: def 定义 3.1.2 · 卷积的三种归纳偏置 {#def-3.1.2}
设输入图像为 $x$，卷积核（filter / kernel）为一个小窗口 $w\in\mathbb R^{k\times k}$，输出 $y$ 为核在输入上滑动得到（严格定义见 [定义 3.2.1](sec32.md#def-3.2.1)）。

- **局部连接**（local connectivity）：输出位置 $(i,j)$ 只与输入的 $k\times k$ 邻域相连，而不是与整张图相连。
- **权值共享**（weight sharing）：**同一个**核在图像上逐位置滑动，所有空间位置共用这 $k^2$ 个权重。
- **平移等变**（translation equivariance）：把输入整体平移 $\Delta$，输出也只是被平移 $\Delta$（在边界处理允许的范围内），

$$f\bigl(\mathrm{shift}_\Delta(x)\bigr)=\mathrm{shift}_\Delta\bigl(f(x)\bigr).$$
:::

::: intuition 为什么「共享一个核」既省参数又给出等变
**省参数**：局部连接把每个输出位置的连接数从 $HWC$ 降到 $k^2C$（降了约 $10^4$ 倍）；权值共享再让所有位置**共用同一组**权重，于是参数量只剩 $k^2C$ 与「输出通道数」有关，**与图像尺寸完全无关**。两层压缩叠起来，就是例 3.1.1 里那 4000 倍。

**平移等变**：核在所有位置用的是同一套权重，那么「眼睛」这个局部图案无论出现在左上角还是右下角，都会激活同一个检测器，输出只是把激活**搬到了对应位置**。这正是视觉世界的基本事实：**物体是什么，与它在哪里无关**。

一句话：局部连接回答「看多大范围」，权值共享回答「在哪学、在哪用」，等变是这两条的直接推论。
:::

::: prop 命题 3.1.1 · 平移等变的来源（为什么必须是权值共享） {#prop-3.1.1}
设卷积算子 $f$（无边界填充，或填充足够大到平移不越界）。则对任意整数平移 $\Delta$，

$$f(\mathrm{shift}_\Delta x)=\mathrm{shift}_\Delta f(x).$$

反之，若一个线性、局部（每个输出只看 $k\times k$ 邻域）、且**与平移可交换**的算子，则它是某个核的卷积。

::: proof 推导（可跳）
**充分性**：卷积在 $y$ 的某个位置 $(i,j)$ 的输出是 $y_{i,j}=\sum_{u,v}w_{u,v}x_{i+u,j+v}$。把输入平移 $\Delta$ 得 $\tilde x_{i,j}=x_{i-\Delta_i,\,j-\Delta_j}$，则

$$\tilde y_{i,j}=\sum_{u,v}w_{u,v}\tilde x_{i+u,j+v}=\sum_{u,v}w_{u,v}x_{i+u-\Delta_i,\,j+v-\Delta_j}=y_{i-\Delta_i,\,j-\Delta_j}=\bigl(\mathrm{shift}_\Delta y\bigr)_{i,j}.$$

即输出被同样平移——这就是等变。

**必要性（要点）**：设线性算子 $f$ 满足 $f(\mathrm{shift}_\Delta x)=\mathrm{shift}_\Delta f(x)$。考察脉冲输入 $x=(\text{在第 }0\text{ 个位置取 }1\text{，其余 }0)$，其响应 $\boldsymbol h=f(x)$ 完全刻画了算子；由平移可交换性，任意输入 $x=\sum_t x_t\,\mathrm{shift}_t(\text{脉冲})$ 的响应为

$$f(x)=\sum_t x_t\,\mathrm{shift}_t(\boldsymbol h),$$

这正是「以 $\boldsymbol h$ 为核」的卷积（相关）。因此**在「线性 + 平移等变」这两个条件下，卷积不是一种选择，而是唯一的形态**。$\blacksquare$
:::
:::

::: note 等变（equivariance）与不变（invariance）不是一回事
**平移等变**：输入平移，**输出特征图跟着平移**——这是卷积自带的性质，见 [命题 3.1.1](#prop-3.1.1)。
**平移不变**：物体在哪都给出**同一个标签**——这是分类任务需要的性质。

卷积**只给等变**。把等变升级为不变的是后续的池化与全局池化（[3.3 节](sec33.md)）：它们把「在哪里」这个信息逐步抹掉。二者混用是本章最常见的概念错误（见本节陷阱 4）。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 900 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-ib-title fig-ib-desc">
<title id="fig-ib-title">全连接与卷积：连接数、权值共享与平移等变</title>
<desc id="fig-ib-desc">上：全连接结构中每个输出单元与全部输入像素相连（此处示意 16 个输入像素），权重不共享，参数量随图像尺寸增长。下：卷积结构中同一个 3×3 核在所有位置滑动，权重被整张图共享，参数只与核大小和通道数有关；同一图案出现在不同位置时，激活只是跟着平移，即平移等变。</desc>
<defs>
<marker id="mk-ib-neutral" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-neutral)"/></marker>
<marker id="mk-ib-green" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-green)"/></marker>
</defs>
<text class="diagram-note" fill="var(--fig-red)" x="60" y="26" font-weight="700" font-size="14px">① 全连接：每个输出连到全部输入，权重互不共享</text>
<g>
<rect x="60"  y="60" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="90"  y="60" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="120" y="60" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="150" y="60" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="60"  y="90" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="90"  y="90" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="120" y="90" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="150" y="90" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="60"  y="120" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="90"  y="120" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="120" y="120" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="150" y="120" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="60"  y="150" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="90"  y="150" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="120" y="150" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
<rect x="150" y="150" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)"/>
</g>
<text class="diagram-note" fill="muted" x="118" y="196" text-anchor="middle" font-size="12.5px">输入 4×4（真实场景 150528 维）</text>
<circle cx="290" cy="80" r="11" fill="var(--fig-red)" fill-opacity="0.15" stroke="var(--fig-red)"/>
<circle cx="290" cy="140" r="11" fill="var(--fig-red)" fill-opacity="0.15" stroke="var(--fig-red)"/>
<text class="diagram-mono" fill="var(--fig-red)" x="290" y="85" text-anchor="middle" font-size="12px">h₁</text>
<text class="diagram-mono" fill="var(--fig-red)" x="290" y="145" text-anchor="middle" font-size="12px">h₂</text>
<path d="M 180 72 C 220 70 240 74 277 78" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<path d="M 180 92 C 230 96 250 80 278 80" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<path d="M 180 112 C 230 108 250 82 279 82" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<path d="M 180 132 C 230 130 250 84 280 84" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<path d="M 180 152 C 230 158 250 86 281 86" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<path d="M 180 92 C 230 106 250 134 278 138" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<path d="M 180 132 C 230 140 250 140 279 142" fill="none" stroke="var(--fig-red)" stroke-opacity="0.45" stroke-width="1.1"/>
<text class="diagram-mono" fill="var(--fig-red)" x="360" y="86" font-size="12.5px">每对（输入, 输出）一个独立权重</text>
<text class="diagram-mono" fill="var(--fig-red)" x="360" y="110" font-size="12.5px">→ 参数量 = 输入维 × 输出维</text>
<text class="diagram-mono" fill="var(--fig-red)" x="360" y="134" font-size="12.5px">→ 224×224×3 接 1000 维 ≈ 1.5×10⁸</text>
<text class="diagram-mono" fill="var(--fig-red)" x="360" y="158" font-size="12.5px">→ 「位置」信息必须由数据自己学</text>
<line x1="60" y1="214" x2="840" y2="214" stroke="var(--line-strong)" stroke-dasharray="5 5"/>
<text class="diagram-note" fill="var(--fig-green)" x="60" y="242" font-weight="700" font-size="14px">② 卷积：一个 3×3 核在所有位置滑动，权重共享</text>
<rect x="60" y="262" width="200" height="64" fill="none" stroke="var(--fig-green)" stroke-width="1.4"/>
<rect x="80" y="272" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.25" stroke="var(--line-strong)"/>
<rect x="102" y="272" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.25" stroke="var(--line-strong)"/>
<rect x="124" y="272" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.25" stroke="var(--line-strong)"/>
<rect x="80" y="294" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.25" stroke="var(--line-strong)"/>
<rect x="102" y="294" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.25" stroke="var(--line-strong)"/>
<rect x="124" y="294" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.25" stroke="var(--line-strong)"/>
<rect x="212" y="286" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.55" stroke="var(--line-strong)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="158" y="336" text-anchor="middle" font-size="12.5px">同一个核 → 同一组 9 个权重</text>
<line x1="280" y1="294" x2="330" y2="294" stroke="var(--fig-neutral)" stroke-width="1.6" marker-end="url(#mk-ib-neutral)"/>
<text class="diagram-note" fill="muted" x="305" y="284" text-anchor="middle" font-size="12px">滑动</text>
<rect x="350" y="262" width="200" height="64" fill="none" stroke="var(--fig-green)" stroke-width="1.4"/>
<g fill="var(--paper-soft)" stroke="var(--line-strong)">
<rect x="370" y="272" width="22" height="22"/><rect x="392" y="272" width="22" height="22"/><rect x="414" y="272" width="22" height="22"/>
<rect x="370" y="294" width="22" height="22"/><rect x="392" y="294" width="22" height="22"/><rect x="414" y="294" width="22" height="22"/>
</g>
<rect x="392" y="294" width="22" height="22" fill="var(--fig-green)" fill-opacity="0.55" stroke="var(--fig-green)" stroke-width="1.6"/>
<text class="diagram-mono" fill="var(--fig-green)" x="450" y="336" text-anchor="middle" font-size="12.5px">激活随图案一起平移 = 平移等变</text>
<text class="diagram-mono" fill="var(--fig-green)" x="600" y="278" font-size="12.5px">参数量 = k²·C_in·C_out + C_out</text>
<text class="diagram-mono" fill="var(--fig-green)" x="600" y="302" font-size="12.5px">与 H×W 无关（省 3–4 个数量级）</text>
<text class="diagram-mono" fill="var(--fig-green)" x="600" y="326" font-size="12.5px">局部性 + 权值共享 → 等变是推论</text>
</svg>
<figcaption>本教程绘制。上：全连接给每一对（输入像素, 输出单元）独立权重，位置信息要靠数据硬学。下：卷积让同一个 $3\times3$ 核在所有位置复用，参数量只与核与通道有关；图案平移时激活跟着平移（等变）。这张图对应 [定义 3.1.2](#def-3.1.2) 与 [命题 3.1.1](#prop-3.1.1)。</figcaption>
</figure>

## 3.1.3 归纳偏置：定义、收益与代价

到这里我们可以把「卷积为什么省」上升为一条通用原理。

::: def 定义 3.1.3 · 归纳偏置（inductive bias） {#def-3.1.3}
一个学习算法（或模型族）在**假设空间之外**额外携带的、用于在等价假设之间做选择的先验约束，称为它的**归纳偏置**。模型族 $\mathcal F$ 与真实规律 $f^\star$ 之间的差距受两部分影响：

$$\underbrace{\mathcal R(f)-\mathcal R(f^\star)}_{\text{泛化差距}}\ \le\ \underbrace{\min_{f\in\mathcal F}\bigl(\mathcal R(f)-\mathcal R(f^\star)\bigr)}_{\text{近似误差：}\mathcal F\text{ 是否装得下真解}}+\underbrace{\text{估计误差}}_{\text{样本不足导致的选错}}.$$

归纳偏置是**双向的工具**：它把「与先验相符的解」提前排除在候选之外，**降低估计误差**；但如果真实规律不满足这个先验，它会**抬高近似误差**。
:::

::: intuition 归纳偏置就是「用先验换样本」
想象要在一个巨大的假设空间里找一个解，样本有限。归纳偏置相当于提前说：「别在那一片区域找，据我所知没有答案。」——如果这个信念是对的，你需要的样本量会下降几个数量级；如果错了，你永远找不到正确答案。

卷积的信念是三条：**像素的重要性是局部的**、**同一图案在任何位置含义相同**、**低层特征是可复用的**. 对自然图像，这三条几乎是定义性的；对「把像素随机打乱之后的数据集」，它们就是错的——那时卷积会输给 MLP。这就是「偏置的代价」。
:::

::: ex 例 3.1.2 · 归纳偏置的收益有多大（数据视角） {#ex-3.1.2}
某任务是「在手写数字图上检测一条竖线，位置无关」。用全连接网络与用单核卷积网络实现，写出各自的参数量，并说明为什么两者的**样本需求**差别是数量级的。

::: proof 解
**全连接实现**：输入 $28\times28$。若隐层尺寸为 $784$（与输入同规模），第一层参数量为 $784\times784\approx6.1\times10^5$；对每一个位置，网络都要从数据中**独立地**学「竖线」这一模式，等于把同一个概念学了 700 多遍。

**卷积实现**：一个 $3\times3$ 核，参数量 $9$（加偏置 $10$），它**在所有位置同时**检测竖线。要教会它「什么是竖线」，只需要训练样本中在**任意位置**出现过竖线即可。

**样本需求的差别**：卷积把「位置」这一无关变量**从假设空间里消掉了**（消去而非忽略），因此它需要的样本量与「有多少种图案」有关，而与「图案能出现在多少位置」无关；全连接则要覆盖「图案 × 位置」的组合。这就是 3.4 节要见的实证现象的结构性原因：**在中小数据上，一个好先验可以顶几倍的参数量与数据集**。

:::
:::

::: errata 本节常见误解
1. **「卷积一定能比全连接更好」**：错。这是**条件结论**——数据具有平移统计结构（自然图像、音频频谱图、部分时序）时成立；对「位置本身携带语义」的任务（如人类姿态的关键点编号、表格中带列序的字段），强行卷积会抬高近似误差。
2. **「参数共享意味着所有位置的输出一样」**：错。共享的是**权重**，不是输出；不同位置的输入不同，输出自然不同。共享带来的是「检测器一致」，不是「响应一致」。
3. **「卷积天生平移不变」**：错。卷积给的是**等变**（见 [命题 3.1.1](#prop-3.1.1)）；分类要的不变要靠池化 / 全局池化换取，且由于下采样、边界效应、padding 的存在，实际网络的平移不变性**只是局部的、有限的**（平移几个像素可能不变，平移半个感受野通常会变）。
4. **「全连接层已经能表达卷积，所以卷积没有本质增益」**：半对半错。全连接**能**表示卷积（把大部分权重置零并令其余位置相等即可），但那是「表示能力」层面；卷积的价值在**统计效率与优化难度**层面——这个等效解在全连接参数化下极难被梯度法找到。
5. **「卷核大小越大约好」**：错。核越大感受野越大但参数量按 $k^2$ 涨、非线性层数变少。堆小核是更划算的做法（见 [3.2.5 节](sec32.md#sec-3.2.5) 与 [3.4 节](sec34.md)）。
:::

::: method 即时自测 · 3.1
**Q1** 一张 $224\times224\times3$ 的图像接一层 $4096$ 维全连接隐层，参数量是多少（不算偏置）？换成 $3\times3$ 卷积、$64\to64$ 通道呢？

**Q2** 「卷积具有平移不变性」这句话哪里不对？请给出正确的两句表述，并指明「不变」是哪一步换来的。

**Q3** 为什么说归纳偏置是「用先验换样本」？请举一个**先验不成立**从而导致卷积吃亏的具体数据形态。

**Q4** 全连接层能否表达卷积？如果能，为什么工程上不这么干？

::: sol 参考要点
**Q1** $150{,}528\times4096\approx6.2\times10^{8}$（约 6 亿）；卷积为 $64\times64\times9=36{,}864$。比值约 $1.7\times10^4$。

**Q2** 错在把等变当不变。正确表述：① 卷积具有**平移等变**——输入平移，输出特征图跟着平移；② 分类任务需要的**平移不变**由池化 / 全局平均池化 / 后续的下采样步骤逐步换来（[3.3 节](sec33.md)）。补充：真实 CNN 的不变性是局部的，受 padding 与下采样影响。

**Q3** 归纳偏置把先验不符的解提前排除，从而降低估计误差、减少所需样本；先验错时抬高近似误差。反例：把每张图像的像素按固定随机置换打乱后再训练（位置信息被人为破坏）、或者把「关键点编号」这类位置语义当作图像通道输入——此时局部性与平移等变都不成立，MLP 或带位置编码的结构更合适。

**Q4** 能。把卷积核权重填进一个稀疏的大矩阵（每行只有 $k^2C$ 个非零，且这些非零值在不同行之间相等）即可。但这样参数化后：① 参数量并未真正减少（大矩阵仍然要存储）；② 梯度下降要在巨大的参数空间里「自动发现」这种稀疏且跨行相等的结构，优化上远比直接参数化困难。**卷积的价值在于给出了正确的参数化，而不只是更大的假设空间。**
:::
:::

::: note[skip] 延伸阅读
- LeCun, Bottou, Bengio & Haffner, *Gradient-Based Learning Applied to Document Recognition*（1998，Proc. IEEE）——LeNet-5 原文，卷积 + 权值共享用于手写数字识别的奠基文献。
- Fukushima, *Neocognitron: A Self-organizing Neural Network Model for a Mechanism of Pattern Recognition Unaffected by Shift in Position*（1980）——局部连接与层次化特征的早期神经科学启发模型。
- Hubel & Wiesel, *Receptive Fields of Single Neurones in the Cat's Striate Cortex*（1959）——简单细胞 / 复杂细胞，局部感受野的实验来源。
- Zhang et al., *Understanding Deep Learning Requires Rethinking Generalization*（2017，arXiv:1611.03530）——关于「参数化与隐式正则」的经典讨论，帮助理解为什么「表达得下」不等于「学得到」。
- 3Blue1Brown 卷积与 CNN 章节、以及 CS231n（`cs231n.stanford.edu`）卷积笔记——建立滑窗手感的最快路径。
:::

**本节小结**：全连接处理图像的两宗罪是**参数爆炸**（$1.5\times10^8$ 量级）与**无视空间结构**；卷积用**局部连接 + 权值共享**把参数量压到与图像尺寸无关，并顺带得到**平移等变**（[命题 3.1.1](#prop-3.1.1)）；这三条合起来是「把图像先验写进结构」的归纳偏置，它降低样本需求、也带来先验不符时的代价。下一节把这句「核在图上滑动」写成精确的公式，并把通道、步幅、填充、感受野逐项算清。
