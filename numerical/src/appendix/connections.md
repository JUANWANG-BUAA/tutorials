# 附录 C · 跨学科联系与应用拓展

第一章讨论误差、范数和条件数，补充篇进一步介绍正交、投影、QR、谱与 SVD。本附录从统计、优化、信号和控制等问题出发，说明这些工具怎样使用。各节保留简短推导和正文链接；遇到陌生背景时，先看变量的定义与数学假设。

<a id="app-c-1"></a>

## C.1 统计学：最小二乘的另一张脸

[2.2.4](../supplement/sec22.md#sup-2.2.4) 的最小二乘在统计里叫**线性回归**：观测 $\boldsymbol{y}=A\boldsymbol{x}+\boldsymbol{\varepsilon}$（$A$ 叫设计矩阵，$\boldsymbol{\varepsilon}$ 是噪声）。几何与统计在这里是同一件事的两面。

### C.1.1 Gauss–Markov 定理（推导）

假设 $\mathbb{E}\,\boldsymbol{\varepsilon}=\boldsymbol{0}$、$\operatorname{Var}(\boldsymbol{\varepsilon})=\sigma^2I$（无偏、等方差、不相关），$A$ 列满秩。最小二乘估计 $\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{y}$。

**无偏。**$\mathbb{E}\,\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\mathbb{E}(A\boldsymbol{x}+\boldsymbol{\varepsilon})=\boldsymbol{x}$。

**方差。**$\hat{\boldsymbol{x}}-\boldsymbol{x}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{\varepsilon}$，故

$$\operatorname{Var}(\hat{\boldsymbol{x}})=\sigma^2(A^{\mathrm T}A)^{-1}A^{\mathrm T}A(A^{\mathrm T}A)^{-1}=\sigma^2(A^{\mathrm T}A)^{-1} .$$

**最优（BLUE）。**任取另一个线性无偏估计 $\tilde{\boldsymbol{x}}=C\boldsymbol{y}$：无偏性 $\Leftrightarrow CA=I$。记 $C_0=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$，$D=C-C_0$，则 $DA=0$，且交叉项消失：由 $DA=O$ 得 $A^{\mathrm T}D^{\mathrm T}=(DA)^{\mathrm T}=O$，故 $C_0D^{\mathrm T}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}D^{\mathrm T}=O$。于是

$$\operatorname{Var}(\tilde{\boldsymbol{x}})=\sigma^2CC^{\mathrm T}=\sigma^2\bigl[C_0C_0^{\mathrm T}+DD^{\mathrm T}\bigr]=\sigma^2(A^{\mathrm T}A)^{-1}+\sigma^2DD^{\mathrm T}\ \succeq\ \operatorname{Var}(\hat{\boldsymbol{x}}),$$

其中 $\succeq$ 表示两个协方差矩阵之差半正定。∎

**数值侧面。**各系数的方差由 $\sigma^2(A^{\mathrm T}A)^{-1}$ 的对角元给出。小奇异值对应的方向会放大观测噪声；条件数只衡量相对敏感性，单凭它不能确定方差的绝对大小。多重共线性是若干列之间近似线性相关，不限于某两列几乎平行；列尺度悬殊也可能使未缩放矩阵的条件数变大（见[例 2.4.1](../supplement/sec24.md#ex-sup-2.4.1)）。

### C.1.2 广义最小二乘：换内积 = 换噪声模型（对应 [定理 2.2.7](../supplement/sec22.md#thm-sup-2.2.7)）

若 $\operatorname{Var}(\boldsymbol{\varepsilon})=\sigma^2\Omega$，其中 $\Omega$ 对称正定，可最小化 $\lVert A\boldsymbol{x}-\boldsymbol{y}\rVert_{\Omega^{-1}}^2$，得到广义最小二乘估计。若再假设噪声服从高斯分布，其对数似然为
$$\log p(\boldsymbol{y}\mid\boldsymbol{x})=-\frac{1}{2\sigma^2}(\boldsymbol{y}-A\boldsymbol{x})^{\mathrm T}\Omega^{-1}(\boldsymbol{y}-A\boldsymbol{x})+\text{const},$$
故它也是最大似然估计。取 Cholesky 分解 $\Omega^{-1}=L^{\mathrm T}L$，问题化为对 $(LA,L\boldsymbol{y})$ 的普通最小二乘，变换后的噪声协方差为 $\sigma^2I$，称为白化。协方差的逆决定权矩阵；有相关噪声时，权矩阵一般不是对角阵。这里的高斯假设用于似然解释，白化和线性无偏估计的方差比较本身不要求高斯分布。

### C.1.3 岭回归 = SVD 滤波（推导）

取 $\lambda>0$，考虑带惩罚项的最小二乘：最小化 $\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2^2+\lambda\lVert\boldsymbol{x}\rVert_2^2$，解满足 $(A^{\mathrm T}A+\lambda I)\hat{\boldsymbol{x}}_\lambda=A^{\mathrm T}\boldsymbol{b}$。代入秩为 $r$ 的薄 SVD，$A=U_r\Sigma_rV_r^{\mathrm T}$，其中 $\Sigma_r\in\mathbb R^{r\times r}$：

$$\hat{\boldsymbol{x}}_\lambda=V_r(\Sigma_r^2+\lambda I_r)^{-1}\Sigma_r U_r^{\mathrm T}\boldsymbol{b}=\sum_{i=1}^{r}\underbrace{\frac{\sigma_i^2}{\sigma_i^2+\lambda}}_{=:f_i}\cdot\frac{\boldsymbol{u}_i^{\mathrm T}\boldsymbol{b}}{\sigma_i}\,\boldsymbol{v}_i .$$

**读法：岭回归对每个 SVD 分量乘上滤波因子 $f_i\in(0,1)$**——大奇异值方向（$f_i\approx1$）原样保留，小奇异值方向（$\sigma_i^2\ll\lambda$，$f_i\approx\sigma_i^2/\lambda$）被压制。对比：

| 方法 | 小奇异值方向的处理 | $f_i$ 的形状 |
|:--|:--|:--|
| 截断 SVD / 截断伪逆（[2.6.4](../supplement/sec26.md#sup-2.6.4)） | 直接丢弃（$f_i=0$） | 硬阈值 |
| 岭回归（Tikhonov） | 平滑压制 | 软阈值 |

两者都在治同一个病：$1/\sigma_i$ 对小 $\sigma_i$ 的爆炸放大。$\lambda$ 的选择就是[2.6.4 思考题](../supplement/sec26.md#sup-2.6.4)里「按噪声水平截断」的连续版。

### C.1.4 PCA 的两种说法是一个定理

设数据中心化后为 $X$（行=样本）。统计说法：找方向 $\boldsymbol{v}$ 使投影方差 $\operatorname{Var}(X\boldsymbol{v})=\boldsymbol{v}^{\mathrm T}C\boldsymbol{v}$ 最大（$C=X^{\mathrm T}X/(n-1)$）。逼近说法：找 $k$ 维子空间使重建误差 $\sum_i\lVert\boldsymbol{x}_i-\operatorname{proj}_{\mathcal{S}}\boldsymbol{x}_i\rVert^2$ 最小。两者等价：投影方差最大 ⟺ 垂直余项最小（勾股定理，[定理 2.2.3](../supplement/sec22.md#thm-sup-2.2.3)），而「全体样本的最优秩 $k$ 逼近」恰是 Eckart–Young（[定理 2.6.4](../supplement/sec26.md#thm-sup-2.6.4)）。所以**主成分 = 数据矩阵的前 $k$ 个右奇异向量**，「解释方差比 = 前奇异值能量占比」（[2.7.3](../supplement/sec27.md#sup-2.7.3) 实验三的实测）。统计教科书里的「协方差矩阵特征分解」与本教程的「$X$ 的 SVD」是同一枚硬币：$\sigma_i^2=(n-1)\lambda_i$。

<a id="app-c-2"></a>

## C.2 机器学习与优化

<a id="app-c-2-1"></a>

### C.2.1 条件数决定训练快慢：梯度下降的收敛因子（推导）

训练的本质常是对某个损失 $f$ 做迭代最小化；一切从最简单的二次模型看起：$f(\boldsymbol{x})=\frac12\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}-\boldsymbol{b}^{\mathrm T}\boldsymbol{x}$（$A$ 对称正定，$\nabla f=A\boldsymbol{x}-\boldsymbol{b}$，最优解 $\boldsymbol{x}^{*}=A^{-1}\boldsymbol{b}$——正是本课程第一章的方程组）。梯度下降 $\boldsymbol{x}_{k+1}=\boldsymbol{x}_k-\alpha\nabla f$ 给误差递推 $\boldsymbol{e}_{k+1}=(I-\alpha A)\boldsymbol{e}_k$；在 $A$ 的特征基下第 $i$ 个分量按 $|1-\alpha\lambda_i|$ 收缩。取 $\alpha=1/\lambda_{\max}$：

$$|1-\alpha\lambda_i|\in\Bigl[0,\ 1-\frac{\lambda_{\min}}{\lambda_{\max}}\Bigr]=\Bigl[0,\ 1-\frac1\kappa\Bigr]\qquad\Longrightarrow\qquad
\lVert\boldsymbol{e}_k\rVert\le\Bigl(1-\frac1\kappa\Bigr)^k\lVert\boldsymbol{e}_0\rVert .$$

对同一个对称正定二次问题，下面统一比较 $A$-范数下的误差上界。记 $\kappa=\mathrm{cond}_2(A)$、$E_k=\|\boldsymbol e_k\|_A$；上面的定步长估计在该范数下同样成立。

| 方法 | 第 $k$ 步误差上界 | 出处 |
|:--|:--|:--|
| 梯度下降，定步长 $\alpha=1/\lambda_{\max}$ | $E_k\le(1-1/\kappa)^kE_0$ | 本节 |
| 最速下降，每步精确线搜索 | $E_k\le\bigl((\kappa-1)/(\kappa+1)\bigr)^kE_0$ | [附录 A.2.8](derivations.md#app-a-2-8)（平方范数界开方） |
| 共轭梯度（CG） | $E_k\le2\bigl((\sqrt\kappa-1)/(\sqrt\kappa+1)\bigr)^kE_0$ | [附录 C.6.1](#app-c-6-1) |

$\kappa=10^4$ 时，三个几何底数分别约为 $0.9999$、$0.9998$、$0.9802$。第二行若比较平方误差，才会出现 $0.9996$；CG 的全局上界另有系数 2，不能将其底数当作每一步的精确压缩比。这些界说明条件数如何影响这类二次问题的收敛保证，实际速度还受初值和特征值分布影响。推广到非凸训练时，不能据此断言动量、Adam 或二阶法必然降低同一个条件数。

### C.2.2 低秩的世界：从 Eckart–Young 到 LoRA 与推荐系统

低秩模型用较少的自由参数表示矩阵。下面三类应用都与低秩结构有关，但 [定理 2.6.4](../supplement/sec26.md#thm-sup-2.6.4) 只保证给定矩阵的最佳低秩逼近，不能直接保证各类训练任务的效果：

- **推荐系统 / 矩阵补全**：评分矩阵 $R$（用户×物品）假设近似低秩（口味由少数隐因子决定），于是「补全缺失评分」=「在已知元素约束下找低秩矩阵」——Eckart–Young 保证若观测完整，最优低秩就是截断 SVD；观测残缺时问题非凸，Netflix Prize 时代的经典做法仍以 SVD / 矩阵分解为骨架。
- **LoRA（大模型低秩适配）**：对 $m\times n$ 权重矩阵，令更新 $\Delta W=BA$、秩至多为 $r$，可训练参数由 $mn$ 个减为 $r(m+n)$ 个。若已知一个理想更新，截断 SVD 可求它在指定范数下的最佳低秩逼近；实际训练并不知道该更新，任务损失的优化也不是这一逼近定理。
- **语言与图像的谱衰减**：若具体数据矩阵的奇异值衰减较快，少数分量就能保留较大比例的平方能量（[2.6.6](../supplement/sec26.md#sup-2.6.6)）。是否足以完成下游任务，需要检查数据和任务误差，不能只由矩阵所属的数据类型判断。

### C.2.3 预条件：Adam、牛顿法与「换度量」

[2.4.5](../supplement/sec24.md#sup-2.4.5) 的行均衡化说：给方程组的行乘上适当常数，条件数可以大幅下降。抽象版是**预条件**：解 $A\boldsymbol{x}=\boldsymbol{b}$ 改为解 $P^{-1}A\boldsymbol{x}=P^{-1}\boldsymbol{b}$（$P\approx A$ 但易于求逆），$\mathrm{cond}$ 由 $P^{-1}A$ 决定。三个学科实例共享这一个结构：

| 场景 | $P$ 的取法 | 效果 |
|:--|:--|:--|
| 迭代法（[第 2 章](../course/ch02/overview.md)） | 不完全 Cholesky / 块对角 | Krylov 迭代步数骤减 |
| 牛顿法 | 局部 Hessian $H$，实际作用为 $H^{-1}$ | 在相应光滑性和非奇异条件下局部至少二阶；非凸时还需处理不定 Hessian |
| Adam 优化器 | 梯度二阶矩的对角阵 $\operatorname{diag}(\sqrt{v})$ | 每维自适应步长 ≈ 对角预条件 |

当 $P$ 对称正定时，可用它定义加权内积；合适的预条件有助于改善谱分布和迭代速度。Adam 的按分量缩放可作类似解释，但不保证条件数下降。一般非对称或不定的 $P$ 不能直接当作内积矩阵。

<a id="app-c-3"></a>

## C.3 信号与图像

### C.3.1 DFT 是酉矩阵：正交不变性的复数版（推导）

离散 Fourier 矩阵 $F=\dfrac{1}{\sqrt N}\bigl(\omega^{jk}\bigr)_{j,k=0}^{N-1}$（$\omega=e^{-2\pi i/N}$）。验证 $F^{\mathrm H}F=I$：

$$(F^{\mathrm H}F)_{jk}=\frac1N\sum_{n=0}^{N-1}\omega^{n(j-k)}=\frac1N\begin{cases}N,&j=k\\[2pt]\dfrac{\omega^{N(j-k)}-1}{\omega^{\,j-k}-1}=0,&j\neq k\end{cases}=\delta_{jk}$$

（$j\neq k$ 时 $\omega^{N(j-k)}=e^{-2\pi i(j-k)}=1$ 而分母非零——等比数列求和）。于是 Fourier 变换是**酉变换**：[定理 2.1.6](../supplement/sec21.md#thm-sup-2.1.6) 的复数版成立，**Parseval 恒等式**「时域能量 = 频域能量」就是 [定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4)（3）的复数版。FFT 的 $O(N\log N)$ 来自「偶奇分裂 + 两个半长 DFT」的分治——把变换写成两个半长酉变换的复合。

### C.3.2 匹配滤波：加权 Cauchy–Schwarz（推导）

雷达/通信的经典问题：含噪声观测 $\boldsymbol{y}=\boldsymbol{s}+\boldsymbol{n}$（信号 $\boldsymbol{s}$ 已知，噪声协方差 $R$），设计滤波器 $\boldsymbol{h}$ 使输出信噪比

$$\mathrm{SNR}=\frac{(\boldsymbol{h}^{\mathrm T}\boldsymbol{s})^2}{\operatorname{Var}(\boldsymbol{h}^{\mathrm T}\boldsymbol{n})}=\frac{(\boldsymbol{h}^{\mathrm T}\boldsymbol{s})^2}{\boldsymbol{h}^{\mathrm T}R\boldsymbol{h}}$$

最大。以下假设 $R$ 对称正定。令 $\tilde{\boldsymbol{h}}=R^{1/2}\boldsymbol{h}$、$\tilde{\boldsymbol{s}}=R^{-1/2}\boldsymbol{s}$，SNR $=\dfrac{(\tilde{\boldsymbol{h}}^{\mathrm T}\tilde{\boldsymbol{s}})^2}{\lVert\tilde{\boldsymbol{h}}\rVert^2}$，由 Cauchy–Schwarz（[引理 1.3.1](../ch01/sec13.md#sec-1.3.1)）$\le\lVert\tilde{\boldsymbol{s}}\rVert^2$，取等 $\tilde{\boldsymbol{h}}\propto\tilde{\boldsymbol{s}}$，即

$$\boxed{\ \boldsymbol{h}\ \propto\ R^{-1}\boldsymbol{s}\ },\qquad\max\mathrm{SNR}=\boldsymbol{s}^{\mathrm T}R^{-1}\boldsymbol{s} .$$

**加权 Cauchy–Schwarz / 白化变换第二次出场**（C.1.2 是第一次）：「协方差定义度量，度量之内正交即最优」。声呐、GPS 伪距拟合（[GPS 误差预算](../ch01/application.md)）、最小二乘定位全是它的化身。

### C.3.3 压缩的谱系：为什么「平滑 ⟹ 可压缩」

JPEG（DCT）、小波、SVD 压缩（[2.6.6](../supplement/sec26.md#sup-2.6.6)）共用一句话：**换到一组好基，系数谱快速衰减，丢掉尾巴代价小**。区别只在「基从哪来」：

| 方法 | 基 | 依赖的结构 | 最优性 |
|:--|:--|:--|:--|
| SVD / PCA | 数据自适应（$\boldsymbol{u}_i,\boldsymbol{v}_i$） | 无（纯代数） | 对该矩阵**最优**（Eckart–Young） |
| DCT（JPEG） | 固定余弦基 | 自然图像的局部平滑性 | 渐近接近 Karhunen–Loève 最优基 |
| 小波 | 固定多分辨基 | 局部性 + 多尺度 | 稀疏表示，阈值去噪的理论保证 |

[2.6.6](../supplement/sec26.md#sup-2.6.6) 的实测「$20\%$ 存储换 $50.8$ dB」是 SVD 列；同一张图用 DCT 也能压得很好——因为图平滑，两种基都抓到了衰减的谱。SVD 更通用（无需结构假设）但基要现算（$O(mn\min)$），固定基快但要求信号配合：**自适应 vs 高效，是压缩算法设计的基本权衡**。

<a id="app-c-4"></a>

## C.4 物理与工程

### C.4.1 量子力学：谱定理、投影与变分原理的字典

量子力学的数学骨架与本课程补充篇几乎逐条对应：

| 量子力学 | 本教程 | 出处 |
|:--|:--|:--|
| 可观测量 = Hermitian 算子 $H$，测量值只能是特征值 $\lambda_i$（**必为实数**） | 对称矩阵特征值全实、可正交对角化 | [定理 2.5.1](../supplement/sec25.md#thm-sup-2.5.1)（5） |
| 状态 $\psi$ 按 $\lVert\psi\rVert=1$ 归一；测量第 $i$ 个本征态的概率 $=\lvert\langle e_i,\psi\rangle\rvert^2$ | 单位向量的正交基展开与 **Parseval**：$\sum\lvert\langle\psi,\boldsymbol{q}_i\rangle\rvert^2=\lVert\psi\rVert^2=1$ | [定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4) |
| 测量后状态「塌缩」到本征态 | **正交投影**到该本征方向 | [定理 2.2.3](../supplement/sec22.md#thm-sup-2.2.3) |
| 能量期望 $\langle\psi\vert H\vert\psi\rangle$ | **Rayleigh 商** $R(\psi)$，必落在 $[\lambda_{\min},\lambda_{\max}]$ | [定理 2.5.4](../supplement/sec25.md#thm-sup-2.5.4) |
| 变分原理：基态能量 $=\min_\psi R(\psi)$，试探波函数给出能量上界 | $\lambda_{\min}=\min R$ | [定理 2.5.4](../supplement/sec25.md#thm-sup-2.5.4) |
| Rayleigh–Ritz 法（在子空间内找最优试探） | 投影到子空间 + 子空间内的谱 | [定理 2.2.5](../supplement/sec22.md#thm-sup-2.2.5) + C–F 定理 |

计算量子化学的日常工作就是大规模 Hermitian 特征值问题：求最低几个特征对（基态与前几个激发态）——正是[幂法反着用 / Lanczos](../supplement/sec25.md#sup-2.5.3) 的主场。**为什么化学软件能算准能量**：对称（Hermitian）特征值是 $1$-Lipschitz 的（Weyl，[定理 2.5.6](../supplement/sec25.md#thm-sup-2.5.6)）——补充篇「对称矩阵的世界格外好」在物理里价值千金。

### C.4.2 结构振动：广义特征值问题的对称化（推导）

无阻尼结构的自由振动 $M\ddot{\boldsymbol{u}}+K\boldsymbol{u}=\boldsymbol{0}$（$M$ 为质量阵、$K$ 为刚度阵，$M$ 对称正定、$K$ 对称半正定）化为**广义特征值问题** $K\boldsymbol{\varphi}=\omega^2M\boldsymbol{\varphi}$：固有频率 $\omega_i=\sqrt{\lambda_i}$，振型 $\boldsymbol{\varphi}_i$。处理它的标准手法正是加权内积（[例 2.1.1](../supplement/sec21.md#ex-sup-2.1.1) / [定理 2.2.7](../supplement/sec22.md#thm-sup-2.2.7)）：Cholesky 分解 $M=LL^{\mathrm T}$，令 $\boldsymbol{\psi}=L^{\mathrm T}\boldsymbol{\varphi}$：

$$K L^{-\mathrm T}\boldsymbol{\psi}=\omega^2LL^{\mathrm T}\boldsymbol{\varphi}=\omega^2L\boldsymbol{\psi}\qquad\Longrightarrow\qquad
\underbrace{L^{-1}KL^{-\mathrm T}}_{=:K',\ \text{对称}}\ \boldsymbol{\psi}=\omega^2\boldsymbol{\psi}.$$

对称化后的 $K'$ 走对称谱理论的全部绿灯：$\omega_i^2$ 全实、$\boldsymbol{\psi}_i$ 标准正交（⟺ 原振型**关于 $M$ 正交**：$\boldsymbol{\varphi}_i^{\mathrm T}M\boldsymbol{\varphi}_j=\delta_{ij}$）。**模态叠加法**（地震/桥梁分析的标准流程）= 把响应投影到振型基上逐模态求解——[定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4) 坐标公式的工程名。工程上只关心**最低的几十阶**模态（共振风险），Courant–Fischer（[定理 2.5.5](../supplement/sec25.md#thm-sup-2.5.5)）保证「子空间投影逼近低端谱」——Lanczos 类算法由此成为有限元软件的心脏。

### C.4.3 控制系统：谱的位置就是稳定性

| 模型 | 稳定判据 | 本课程工具 |
|:--|:--|:--|
| 连续 $\dot{\boldsymbol{x}}=A\boldsymbol{x}$ | 特征值全在左半复平面 | Gerschgorin 圆盘快速验证（[定理 2.5.2](../supplement/sec25.md#thm-sup-2.5.2) 用法 2） |
| 离散 $\boldsymbol{x}_{k+1}=G\boldsymbol{x}_k$ | $\rho(G)\lt1$ | [2.5.1](../supplement/sec25.md#sup-2.5.1)；但见瞬态增长警告 |
| 反馈 $\boldsymbol{u}=-K\boldsymbol{x}$ 改配极点 | 闭环谱 = $A-BK$ 的特征值 | 特征值计算 + 条件数 |

两条与本课程深度绑定的告诫：① **瞬态增长**（[例 2.5.6](../supplement/sec25.md#ex-sup-2.5.6)、[附录 A.2.7](derivations.md#app-a-2-7)）：$\rho\lt1$ 只保证渐近收敛，非正规的 $G$ 可先放大数万倍再收敛——高频颤振、数值天气预报的初始误差爆发都见过它；工程上用 $\lVert G\rVert\lt1$ 才买到「每步都收缩」。② **特征值的敏感性由特征向量矩阵的条件数决定**（Bauer–Fike，[定理 2.5.6](../supplement/sec25.md#thm-sup-2.5.6)（二））：非正规系统的「极点」对参数摄动极敏感，控制器鲁棒性分析的第一步就是算 $\mathrm{cond}(V)$。

### C.4.4 电路仿真（SPICE）：一切归结为「解方程有多准」

SPICE 的三类分析在数值上分别是：直流分析 = 牛顿法，**每步解一个线性方程组**（节点导纳矩阵，大型稀疏）；交流小信号 = 频率扫描下的复线性方程组；瞬态分析 = 隐式积分（[路线图第 7 章](../ch01/sec11.md#roadmap)），每个时间步解一个（非线性 → 牛顿 → 线性）方程组。这些求解结果是否可信，需要检查：线性求解器的稳定性（列主元，[路线图第 2 章](../ch01/sec11.md#roadmap)）、导纳矩阵的条件数（电源/地节点电导悬殊 → 行均衡化，[2.4.5](../supplement/sec24.md#sup-2.4.5)）、停机判据的范数选择（[1.3.6](../ch01/sec13.md#sec-1.3.6)）。这些检查分别控制离散模型、线性求解和迭代停止造成的误差。

<a id="app-c-5"></a>

## C.5 网络与信息

### C.5.1 PageRank：幂法 + 一条五行的谱定理（推导）

把网页超链接写成矩阵：$S_{ij}=$ 「页面 $j$ 的链接中有多少份额指向 $i$」（每列和为 $1$，无出链的列改成均匀分布）。PageRank 向量 $\boldsymbol{r}$ 定义为 Google 矩阵

$$G=\alpha S+(1-\alpha)\,\frac{\boldsymbol{e}\boldsymbol{e}^{\mathrm T}}{n}\qquad(\alpha\approx0.85,\ \boldsymbol{e}=(1,\dots,1)^{\mathrm T})$$

的特征值 1 对应的正特征向量，并归一化为分量和为 1。这里 $0<\alpha<1$ 且传送分布为正，故该归一化向量唯一。为估计其他特征值，设 $G\boldsymbol{y}=\lambda\boldsymbol{y}$、$\lambda\ne1$。由 $\boldsymbol e^{\mathrm T}G=\boldsymbol e^{\mathrm T}$ 得 $(\lambda-1)\boldsymbol e^{\mathrm T}\boldsymbol y=0$，所以 $\boldsymbol e^{\mathrm T}\boldsymbol y=0$；这一步也适用于 $\lambda=0$，无须除以 $\lambda$。于是传送项消失：

$$G\boldsymbol{y}=\alpha S\boldsymbol{y}+\underbrace{(1-\alpha)\tfrac{\boldsymbol{e}}{n}\,(\boldsymbol{e}^{\mathrm T}\boldsymbol{y})}_{=\boldsymbol{0}}=\alpha S\boldsymbol{y}\qquad\Longrightarrow\qquad
\lvert\lambda\rvert\,\lVert\boldsymbol{y}\rVert_1=\lVert G\boldsymbol{y}\rVert_1\le\alpha\lVert S\boldsymbol{y}\rVert_1\le\alpha\lVert\boldsymbol{y}\rVert_1,$$

因为 $S$ 非负且列和为 1，$\|S\|_1=1$，故其他特征值均满足 $|\lambda|\le\alpha$。对分量和相同的两个概率向量，其差的传送项也消失，直接得到 $\|G\boldsymbol r-G\boldsymbol s\|_1\le\alpha\|\boldsymbol r-\boldsymbol s\|_1$。这给出[幂法](../supplement/sec25.md#sup-2.5.3)的收缩界；$\alpha$ 是沿链接移动的概率，传送概率为 $1-\alpha$。

### C.5.2 潜在语义分析（LSA）与矩阵分解家族

词-文档矩阵 $X$ 的行对应词，列对应文档。截断 SVD 用 $k$ 个分量近似 $X$；左右奇异向量分别给出词和文档在这些分量上的坐标。Eckart–Young 定理保证这一近似在谱范数和 Frobenius 范数下最优，但不保证每个分量都是可解释的「概念」，也不保证被丢弃的成分全是噪声。语义检索效果仍须用具体任务评估。它与推荐系统、低秩适配（C.2.2）共享矩阵分解工具，各自的观测模型和优化目标则不同。

<a id="app-c-6"></a>

## C.6 数值分析自身的延长线

<a id="app-c-6-1"></a>

### C.6.1 Krylov 子空间一瞥：投影 + 正交化 + 条件数开方

对大规模稀疏方程组，Krylov 方法通过投影构造迭代近似，与[第 2 章](../course/ch02/overview.md)的定常迭代采用不同的搜索空间。先取初值为零，则在 Krylov 子空间

$$\mathcal{K}_k(A,\boldsymbol{b})=\operatorname{span}\{\boldsymbol{b},\ A\boldsymbol{b},\ A^2\boldsymbol{b},\ \dots,\ A^{k-1}\boldsymbol{b}\}$$

里找「最像解」的向量（残差最小 = GMRES；误差的 $A$-范数最小 = 共轭梯度 CG，要求 $A$ 对称正定）。三个熟悉的名字各就各位：

- **Arnoldi 过程** = 对 Krylov 序列做 Gram–Schmidt（[2.3.1](../supplement/sec23.md#sup-2.3.1)）——正交化不是备考技巧，是大规模计算的承重墙；
- **GMRES/CG** = 残差/误差到子空间的（斜）投影（[定理 2.2.3](../supplement/sec22.md#thm-sup-2.2.3) 的双侧推广）；
- **收敛率**（$A$ 对称正定、精确算术时）：$\lVert\boldsymbol{e}_k\rVert_A\le2\Bigl(\dfrac{\sqrt\kappa-1}{\sqrt\kappa+1}\Bigr)^k\lVert\boldsymbol{e}_0\rVert_A$。与 C.2.1 的最速下降界相比，这个上界依赖 $\sqrt\kappa$。CG 在当前仿射 Krylov 空间中最小化 $A$-范数误差，证明用多项式逼近估计这一最小值；算法不需要每步求解一个小特征值问题，也不能仅由条件数断言某次任务能否完成。

### C.6.2 预条件：把「好解的矩阵」藏在背后

对称正定问题可选对称正定的预条件矩阵 $P$，使每步容易求解 $P\boldsymbol z=\boldsymbol r$。预条件 CG 等价于在对称系统 $P^{-1/2}AP^{-1/2}$ 上使用 CG，其收敛界中的条件数是 $\mathrm{cond}_2(P^{-1/2}AP^{-1/2})$。$P^{-1}A$ 与该矩阵相似，但一般不对称，不能直接把它的谱条件比与欧氏范数条件数混用。好的预条件能改善谱分布；是否减少总计算量，还要比较预条件的构造、每步求解成本和实际迭代数。

::: note 怎么用本附录
各节使用的线性代数工具主要来自第一章和补充篇，应用背景及噪声模型另在本节说明：内积与投影（2.1–2.2）、正交化（2.3）、条件数（1.2.6、2.4）、谱（2.5）、SVD（2.6）。写课程报告或综述时，建议的结构是「先复述正文工具，再给本附录的对应推导，最后回到自己领域的一句话总结」——数学结构是桥，走过去时别忘了桥墩在哪。
:::
