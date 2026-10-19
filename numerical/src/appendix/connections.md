# 附录 C · 跨学科联系与应用拓展

第一章造了尺子（误差、范数、条件数），补充篇造了工具箱（正交、投影、QR、谱、SVD）。本附录回答一个正向的问题：**这套工具在别的学科里以什么形态出现？**每一节都给一个小推导或一张映射表，而不是口号；正文出处全部链接。阅读本附录不需要先学过那些学科——把每一节当成「同一个数学结构的另一份说明书」即可。

<a id="app-c-1"></a>

## C.1 统计学：最小二乘的另一张脸

[2.2.4](../ch02/sec22.md#sec-2.2.4) 的最小二乘在统计里叫**线性回归**：观测 $\boldsymbol{y}=A\boldsymbol{x}+\boldsymbol{\varepsilon}$（$A$ 叫设计矩阵，$\boldsymbol{\varepsilon}$ 是噪声）。几何与统计在这里是同一件事的两面。

### C.1.1 Gauss–Markov 定理（推导）

假设 $\mathbb{E}\,\boldsymbol{\varepsilon}=\boldsymbol{0}$、$\operatorname{Var}(\boldsymbol{\varepsilon})=\sigma^2I$（无偏、等方差、不相关），$A$ 列满秩。最小二乘估计 $\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{y}$。

**无偏。**$\mathbb{E}\,\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\mathbb{E}(A\boldsymbol{x}+\boldsymbol{\varepsilon})=\boldsymbol{x}$。

**方差。**$\hat{\boldsymbol{x}}-\boldsymbol{x}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{\varepsilon}$，故

$$\operatorname{Var}(\hat{\boldsymbol{x}})=\sigma^2(A^{\mathrm T}A)^{-1}A^{\mathrm T}A(A^{\mathrm T}A)^{-1}=\sigma^2(A^{\mathrm T}A)^{-1} .$$

**最优（BLUE）。**任取另一个线性无偏估计 $\tilde{\boldsymbol{x}}=C\boldsymbol{y}$：无偏性 $\Leftrightarrow CA=I$。记 $C_0=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$，$D=C-C_0$，则 $DA=0$，且交叉项消失（$C_0D^{\mathrm T}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}D^{\mathrm T}=(DA)^{\mathrm T}(\,)^{\mathrm T}$……直接验证 $A^{\mathrm T}D^{\mathrm T}=(DA)^{\mathrm T}=O$），于是

$$\operatorname{Var}(\tilde{\boldsymbol{x}})=\sigma^2CC^{\mathrm T}=\sigma^2\bigl[C_0C_0^{\mathrm T}+DD^{\mathrm T}\bigr]=\sigma^2(A^{\mathrm T}A)^{-1}+\sigma^2DD^{\mathrm T}\ \succeq\ \operatorname{Var}(\hat{\boldsymbol{x}}),$$

其中 $\succeq$ 指差 $DD^{\mathrm T}$ 半正定。∎

**数值侧面。**$(A^{\mathrm T}A)^{-1}$ 的对角元是各系数方差的放大器：$\operatorname{cond}(A)$ 大 ⟹ 回归系数又不准又不稳。统计上的「多重共线性」**就是**数值分析上的病态——列空间里有两根几乎平行的轴（[例 2.4.1](../ch02/sec24.md#ex-2.4.1) 的几何读法）。

### C.1.2 广义最小二乘：换内积 = 换噪声模型（对应 [定理 2.2.7](../ch02/sec22.md#thm-2.2.7)）

噪声不均匀或相关时 $\operatorname{Var}(\boldsymbol{\varepsilon})=\sigma^2\Omega$（$\Omega$ 对称正定）。高斯对数似然 $\log p(\boldsymbol{y}\mid\boldsymbol{x})=-\frac{1}{2\sigma^2}(\boldsymbol{y}-A\boldsymbol{x})^{\mathrm T}\Omega^{-1}(\boldsymbol{y}-A\boldsymbol{x})+\text{const}$，最大化它 ⟺ 最小化 $\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_{\Omega^{-1}}^2$——**正是加权最小二乘**（权矩阵 $W=\Omega^{-1}$）。取 Cholesky 分解 $\Omega^{-1}=L^{\mathrm T}L$，则问题化为对 $(LA,\ L\boldsymbol{b})$ 的普通最小二乘：噪声被「漂白」，[2.2.5](../ch02/sec22.md#sec-2.2.5) 的全部结论原样适用。**「换内积」在统计里读作「按测量精度加权」**——本教程正文那句「换内积 ⟹ 换几何」的第一次兑现。

### C.1.3 岭回归 = SVD 滤波（推导）

病态问题的标准疗法：最小化 $\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2^2+\lambda\lVert\boldsymbol{x}\rVert_2^2$，解满足 $(A^{\mathrm T}A+\lambda I)\hat{\boldsymbol{x}}_\lambda=A^{\mathrm T}\boldsymbol{b}$。代入 $A=U\Sigma V^{\mathrm T}$（$A^{\mathrm T}A=V\Sigma^2V^{\mathrm T}$，$A^{\mathrm T}\boldsymbol{b}=V\Sigma U^{\mathrm T}\boldsymbol{b}$）：

$$\hat{\boldsymbol{x}}_\lambda=V(\Sigma^2+\lambda I)^{-1}\Sigma U^{\mathrm T}\boldsymbol{b}=\sum_{i=1}^{r}\underbrace{\frac{\sigma_i^2}{\sigma_i^2+\lambda}}_{=:f_i}\cdot\frac{\boldsymbol{u}_i^{\mathrm T}\boldsymbol{b}}{\sigma_i}\,\boldsymbol{v}_i .$$

**读法：岭回归对每个 SVD 分量乘上滤波因子 $f_i\in(0,1)$**——大奇异值方向（$f_i\approx1$）原样保留，小奇异值方向（$\sigma_i^2\ll\lambda$，$f_i\approx\sigma_i^2/\lambda$）被压制。对比：

| 方法 | 小奇异值方向的处理 | $f_i$ 的形状 |
|:--|:--|:--|
| 截断 SVD / 截断伪逆（[2.6.4](../ch02/sec26.md#sec-2.6.4)） | 直接丢弃（$f_i=0$） | 硬阈值 |
| 岭回归（Tikhonov） | 平滑压制 | 软阈值 |

两者都在治同一个病：$1/\sigma_i$ 对小 $\sigma_i$ 的爆炸放大。$\lambda$ 的选择就是[2.6.4 思考题](../ch02/sec26.md#sec-2.6.4)里「按噪声水平截断」的连续版。

### C.1.4 PCA 的两种说法是一个定理

设数据中心化后为 $X$（行=样本）。统计说法：找方向 $\boldsymbol{v}$ 使投影方差 $\operatorname{Var}(X\boldsymbol{v})=\boldsymbol{v}^{\mathrm T}C\boldsymbol{v}$ 最大（$C=X^{\mathrm T}X/(n-1)$）。逼近说法：找 $k$ 维子空间使重建误差 $\sum_i\lVert\boldsymbol{x}_i-\operatorname{proj}_{\mathcal{S}}\boldsymbol{x}_i\rVert^2$ 最小。两者等价：投影方差最大 ⟺ 垂直余项最小（勾股定理，[定理 2.2.3](../ch02/sec22.md#thm-2.2.3)），而「全体样本的最优秩 $k$ 逼近」恰是 Eckart–Young（[定理 2.6.4](../ch02/sec26.md#thm-2.6.4)）。所以**主成分 = 数据矩阵的前 $k$ 个右奇异向量**，「解释方差比 = 前奇异值能量占比」（[2.7.3](../ch02/sec27.md#sec-2.7.3) 实验三的实测）。统计教科书里的「协方差矩阵特征分解」与本教程的「$X$ 的 SVD」是同一枚硬币：$\sigma_i^2=(n-1)\lambda_i$。

<a id="app-c-2"></a>

## C.2 机器学习与优化

<a id="app-c-2-1"></a>

### C.2.1 条件数决定训练快慢：梯度下降的收敛因子（推导）

训练的本质常是对某个损失 $f$ 做迭代最小化；一切从最简单的二次模型看起：$f(\boldsymbol{x})=\frac12\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}-\boldsymbol{b}^{\mathrm T}\boldsymbol{x}$（$A$ 对称正定，$\nabla f=A\boldsymbol{x}-\boldsymbol{b}$，最优解 $\boldsymbol{x}^{*}=A^{-1}\boldsymbol{b}$——正是本课程第一章的方程组）。梯度下降 $\boldsymbol{x}_{k+1}=\boldsymbol{x}_k-\alpha\nabla f$ 给误差递推 $\boldsymbol{e}_{k+1}=(I-\alpha A)\boldsymbol{e}_k$；在 $A$ 的特征基下第 $i$ 个分量按 $|1-\alpha\lambda_i|$ 收缩。取 $\alpha=1/\lambda_{\max}$：

$$|1-\alpha\lambda_i|\in\Bigl[0,\ 1-\frac{\lambda_{\min}}{\lambda_{\max}}\Bigr]=\Bigl[0,\ 1-\frac1\kappa\Bigr]\qquad\Longrightarrow\qquad
\lVert\boldsymbol{e}_k\rVert\le\Bigl(1-\frac1\kappa\Bigr)^k\lVert\boldsymbol{e}_0\rVert .$$

三种攻击 $\kappa$ 的迭代法并排：

| 方法 | 每步压缩因子（$A$-范数或谱意义） | 出处 |
|:--|:--|:--|
| 梯度下降，定步长 $\alpha=1/\lambda_{\max}$ | $1-\dfrac1\kappa$ | 本节 |
| 最速下降 / 梯度下降，最优步长 | $\Bigl(\dfrac{\kappa-1}{\kappa+1}\Bigr)^2$ | [附录 A.2.8](derivations.md#app-a-2-8)（Kantorovich） |
| 共轭梯度（CG） | $\Bigl(\dfrac{\sqrt\kappa-1}{\sqrt\kappa+1}\Bigr)$（注意是 $\sqrt\kappa$ 与一次幂） | [附录 C.6.1](#app-c-6-1) |

$\kappa=10^4$ 时三个因子分别为 $0.9999$、$0.9996$、$0.96$——同一问题，快慢差三个数量级。深度学习的损失曲面**高度病态**（各方向曲率悬殊），动量法、Adam、二阶法统统是在压 $\kappa$（C.2.3）；「为什么我的模型训练得慢」的第一嫌疑人常常不是学习率，而是**曲率条件数**。

### C.2.2 低秩的世界：从 Eckart–Young 到 LoRA 与推荐系统

「用低维结构近似高维对象」是当代机器学习的通用范式，其数学内核全部指向 [定理 2.6.4](../ch02/sec26.md#thm-2.6.4)：

- **推荐系统 / 矩阵补全**：评分矩阵 $R$（用户×物品）假设近似低秩（口味由少数隐因子决定），于是「补全缺失评分」=「在已知元素约束下找低秩矩阵」——Eckart–Young 保证若观测完整，最优低秩就是截断 SVD；观测残缺时问题非凸，Netflix Prize 时代的经典做法仍以 SVD / 矩阵分解为骨架。
- **LoRA（大模型低秩适配）**：微调大模型时更新 $\Delta W=BA$（秩 $r\ll n$），参数量从 $n^2$ 降到 $r(m+n)$。其有效性依赖经验事实：**预训练权重的「改动量」本身近似低秩**——若改动恰为低秩，截断 SVD 就是最优压缩（[定理 2.6.4](../ch02/sec26.md#thm-2.6.4)），LoRA 用随机优化去搜一个「接近最优低秩」的因子。
- **语言与图像的谱衰减**：自然图像、词-文档矩阵、注意力矩阵的奇异值普遍快速衰减（平滑/相关性 ⟹ 低秩），这是「少数主成分抓住大部分信息」（[2.6.6](../ch02/sec26.md#sec-2.6.6) 能量表）在各数据模态上的重演。

### C.2.3 预条件：Adam、牛顿法与「换度量」

[2.4.5](../ch02/sec24.md#sec-2.4.5) 的行均衡化说：给方程组的行乘上适当常数，条件数可以大幅下降。抽象版是**预条件**：解 $A\boldsymbol{x}=\boldsymbol{b}$ 改为解 $P^{-1}A\boldsymbol{x}=P^{-1}\boldsymbol{b}$（$P\approx A$ 但易于求逆），$\mathrm{cond}$ 由 $P^{-1}A$ 决定。三个学科实例共享这一个结构：

| 场景 | $P$ 的取法 | 效果 |
|:--|:--|:--|
| 迭代法（[第 2 章](../course/ch02/overview.md)） | 不完全 Cholesky / 块对角 | Krylov 迭代步数骤减 |
| 牛顿法 | 局部 Hessian 逆 $H^{-1}$ | 二次收敛；曲率被精确「拉圆」 |
| Adam 优化器 | 梯度二阶矩的对角阵 $\operatorname{diag}(\sqrt{v})$ | 每维自适应步长 ≈ 对角预条件 |

「换 $P$」在几何上等价于「换内积/范数」（加权最小二乘 [定理 2.2.7](../ch02/sec22.md#thm-2.2.7) 的机制），在优化上等价于「把病态的椭球等距看成球」。Adam 并不保证 $\kappa$ 下降（它是启发式），但成功的直觉来自这里——**度量改好，收敛变快**。

<a id="app-c-3"></a>

## C.3 信号与图像

### C.3.1 DFT 是酉矩阵：正交不变性的复数版（推导）

离散 Fourier 矩阵 $F=\dfrac{1}{\sqrt N}\bigl(\omega^{jk}\bigr)_{j,k=0}^{N-1}$（$\omega=e^{-2\pi i/N}$）。验证 $F^{\mathrm H}F=I$：

$$(F^{\mathrm H}F)_{jk}=\frac1N\sum_{n=0}^{N-1}\omega^{n(j-k)}=\frac1N\begin{cases}N,&j=k\\[2pt]\dfrac{\omega^{N(j-k)}-1}{\omega^{\,j-k}-1}=0,&j\neq k\end{cases}=\delta_{jk}$$

（$j\neq k$ 时 $\omega^{N(j-k)}=e^{-2\pi i(j-k)}=1$ 而分母非零——等比数列求和）。于是 Fourier 变换是**酉变换**：[定理 2.1.6](../ch02/sec21.md#thm-2.1.6) 的复数版成立，**Parseval 恒等式**「时域能量 = 频域能量」就是 [定理 2.1.4](../ch02/sec21.md#thm-2.1.4)（3）的复数版。FFT 的 $O(N\log N)$ 来自「偶奇分裂 + 两个半长 DFT」的分治——把变换写成两个半长酉变换的复合。

### C.3.2 匹配滤波：加权 Cauchy–Schwarz（推导）

雷达/通信的经典问题：含噪声观测 $\boldsymbol{y}=\boldsymbol{s}+\boldsymbol{n}$（信号 $\boldsymbol{s}$ 已知，噪声协方差 $R$），设计滤波器 $\boldsymbol{h}$ 使输出信噪比

$$\mathrm{SNR}=\frac{(\boldsymbol{h}^{\mathrm T}\boldsymbol{s})^2}{\operatorname{Var}(\boldsymbol{h}^{\mathrm T}\boldsymbol{n})}=\frac{(\boldsymbol{h}^{\mathrm T}\boldsymbol{s})^2}{\boldsymbol{h}^{\mathrm T}R\boldsymbol{h}}$$

最大。令 $\tilde{\boldsymbol{h}}=R^{1/2}\boldsymbol{h}$、$\tilde{\boldsymbol{s}}=R^{-1/2}\boldsymbol{s}$，SNR $=\dfrac{(\tilde{\boldsymbol{h}}^{\mathrm T}\tilde{\boldsymbol{s}})^2}{\lVert\tilde{\boldsymbol{h}}\rVert^2}$，由 Cauchy–Schwarz（[引理 1.3.1](../ch01/sec13.md#sec-1.3.1)）$\le\lVert\tilde{\boldsymbol{s}}\rVert^2$，取等 $\tilde{\boldsymbol{h}}\propto\tilde{\boldsymbol{s}}$，即

$$\boxed{\ \boldsymbol{h}\ \propto\ R^{-1}\boldsymbol{s}\ },\qquad\max\mathrm{SNR}=\boldsymbol{s}^{\mathrm T}R^{-1}\boldsymbol{s} .$$

**加权 Cauchy–Schwarz / 白化变换第二次出场**（C.1.2 是第一次）：「协方差定义度量，度量之内正交即最优」。声呐、GPS 伪距拟合（[GPS 误差预算](../ch01/application.md)）、最小二乘定位全是它的化身。

### C.3.3 压缩的谱系：为什么「平滑 ⟹ 可压缩」

JPEG（DCT）、小波、SVD 压缩（[2.6.6](../ch02/sec26.md#sec-2.6.6)）共用一句话：**换到一组好基，系数谱快速衰减，丢掉尾巴代价小**。区别只在「基从哪来」：

| 方法 | 基 | 依赖的结构 | 最优性 |
|:--|:--|:--|:--|
| SVD / PCA | 数据自适应（$\boldsymbol{u}_i,\boldsymbol{v}_i$） | 无（纯代数） | 对该矩阵**最优**（Eckart–Young） |
| DCT（JPEG） | 固定余弦基 | 自然图像的局部平滑性 | 渐近接近 Karhunen–Loève 最优基 |
| 小波 | 固定多分辨基 | 局部性 + 多尺度 | 稀疏表示，阈值去噪的理论保证 |

[2.6.6](../ch02/sec26.md#sec-2.6.6) 的实测「$20\%$ 存储换 $50.8$ dB」是 SVD 列；同一张图用 DCT 也能压得很好——因为图平滑，两种基都抓到了衰减的谱。SVD 更通用（无需结构假设）但基要现算（$O(mn\min)$），固定基快但要求信号配合：**自适应 vs 高效，是压缩算法设计的基本权衡**。

<a id="app-c-4"></a>

## C.4 物理与工程

### C.4.1 量子力学：谱定理、投影与变分原理的字典

量子力学的数学骨架与本课程补充篇几乎逐条对应：

| 量子力学 | 本教程 | 出处 |
|:--|:--|:--|
| 可观测量 = Hermitian 算子 $H$，测量值只能是特征值 $\lambda_i$（**必为实数**） | 对称矩阵特征值全实、可正交对角化 | [定理 2.5.1](../ch02/sec25.md#thm-2.5.1)（5） |
| 状态 $\psi$ 按 $\lVert\psi\rVert=1$ 归一；测量第 $i$ 个本征态的概率 $=\lvert\langle e_i,\psi\rangle\rvert^2$ | 单位向量的正交基展开与 **Parseval**：$\sum\lvert\langle\psi,\boldsymbol{q}_i\rangle\rvert^2=\lVert\psi\rVert^2=1$ | [定理 2.1.4](../ch02/sec21.md#thm-2.1.4) |
| 测量后状态「塌缩」到本征态 | **正交投影**到该本征方向 | [定理 2.2.3](../ch02/sec22.md#thm-2.2.3) |
| 能量期望 $\langle\psi\vert H\vert\psi\rangle$ | **Rayleigh 商** $R(\psi)$，必落在 $[\lambda_{\min},\lambda_{\max}]$ | [定理 2.5.4](../ch02/sec25.md#thm-2.5.4) |
| 变分原理：基态能量 $=\min_\psi R(\psi)$，试探波函数给出能量上界 | $\lambda_{\min}=\min R$ | [定理 2.5.4](../ch02/sec25.md#thm-2.5.4) |
| Rayleigh–Ritz 法（在子空间内找最优试探） | 投影到子空间 + 子空间内的谱 | [定理 2.2.5](../ch02/sec22.md#thm-2.2.5) + C–F 定理 |

计算量子化学的日常工作就是大规模 Hermitian 特征值问题：求最低几个特征对（基态与前几个激发态）——正是[幂法反着用 / Lanczos](../ch02/sec25.md#sec-2.5.3) 的主场。**为什么化学软件能算准能量**：对称（Hermitian）特征值是 $1$-Lipschitz 的（Weyl，[定理 2.5.6](../ch02/sec25.md#thm-2.5.6)）——补充篇「对称矩阵的世界格外好」在物理里价值千金。

### C.4.2 结构振动：广义特征值问题的对称化（推导）

无阻尼结构的自由振动 $M\ddot{\boldsymbol{u}}+K\boldsymbol{u}=\boldsymbol{0}$（$M$ 质量阵、$K$ 刚度阵，均对称正定/半正定）化为**广义特征值问题** $K\boldsymbol{\varphi}=\omega^2M\boldsymbol{\varphi}$：固有频率 $\omega_i=\sqrt{\lambda_i}$，振型 $\boldsymbol{\varphi}_i$。处理它的标准手法正是加权内积（[例 2.1.1](../ch02/sec21.md#ex-2.1.1) / [定理 2.2.7](../ch02/sec22.md#thm-2.2.7)）：Cholesky 分解 $M=LL^{\mathrm T}$，令 $\boldsymbol{\psi}=L^{\mathrm T}\boldsymbol{\varphi}$：

$$K L^{-\mathrm T}\boldsymbol{\psi}=\omega^2LL^{\mathrm T}\boldsymbol{\varphi}=\omega^2L\boldsymbol{\psi}\qquad\Longrightarrow\qquad
\underbrace{L^{-1}KL^{-\mathrm T}}_{=:K',\ \text{对称}}\ \boldsymbol{\psi}=\omega^2\boldsymbol{\psi}.$$

对称化后的 $K'$ 走对称谱理论的全部绿灯：$\omega_i^2$ 全实、$\boldsymbol{\psi}_i$ 标准正交（⟺ 原振型**关于 $M$ 正交**：$\boldsymbol{\varphi}_i^{\mathrm T}M\boldsymbol{\varphi}_j=\delta_{ij}$）。**模态叠加法**（地震/桥梁分析的标准流程）= 把响应投影到振型基上逐模态求解——[定理 2.1.4](../ch02/sec21.md#thm-2.1.4) 坐标公式的工程名。工程上只关心**最低的几十阶**模态（共振风险），Courant–Fischer（[定理 2.5.5](../ch02/sec25.md#thm-2.5.5)）保证「子空间投影逼近低端谱」——Lanczos 类算法由此成为有限元软件的心脏。

### C.4.3 控制系统：谱的位置就是稳定性

| 模型 | 稳定判据 | 本课程工具 |
|:--|:--|:--|
| 连续 $\dot{\boldsymbol{x}}=A\boldsymbol{x}$ | 特征值全在左半复平面 | Gerschgorin 圆盘快速验证（[定理 2.5.2](../ch02/sec25.md#thm-2.5.2) 用法 2） |
| 离散 $\boldsymbol{x}_{k+1}=G\boldsymbol{x}_k$ | $\rho(G)\lt1$ | [2.5.1](../ch02/sec25.md#sec-2.5.1)；但见瞬态增长警告 |
| 反馈 $\boldsymbol{u}=-K\boldsymbol{x}$ 改配极点 | 闭环谱 = $A-BK$ 的特征值 | 特征值计算 + 条件数 |

两条与本课程深度绑定的告诫：① **瞬态增长**（[例 2.5.6](../ch02/sec25.md#ex-2.5.6)、[附录 A.2.7](derivations.md#app-a-2-7)）：$\rho\lt1$ 只保证渐近收敛，非正规的 $G$ 可先放大数万倍再收敛——高频颤振、数值天气预报的初始误差爆发都见过它；工程上用 $\lVert G\rVert\lt1$ 才买到「每步都收缩」。② **特征值的敏感性由特征向量矩阵的条件数决定**（Bauer–Fike，[定理 2.5.6](../ch02/sec25.md#thm-2.5.6)（二））：非正规系统的「极点」对参数摄动极敏感，控制器鲁棒性分析的第一步就是算 $\mathrm{cond}(V)$。

### C.4.4 电路仿真（SPICE）：一切归结为「解方程有多准」

SPICE 的三类分析在数值上分别是：直流分析 = 牛顿法，**每步解一个线性方程组**（节点导纳矩阵，大型稀疏）；交流小信号 = 频率扫描下的复线性方程组；瞬态分析 = 隐式积分（[路线图第 10 章](../ch01/sec11.md#roadmap)），每个时间步解一个（非线性 → 牛顿 → 线性）方程组。芯片设计一天跑百万次仿真，每次的解是否可信，取决于：线性求解器的稳定性（列主元，[路线图第 3 章](../ch01/sec11.md#roadmap)）、导纳矩阵的条件数（电源/地节点电导悬殊 → 行均衡化，[2.4.5](../ch02/sec24.md#sec-2.4.5)）、停机判据的范数选择（[1.3.6](../ch01/sec13.md#sec-1.3.6)）。**「数值分析是 EDA 的地基」不是修辞，是供应链。**

<a id="app-c-5"></a>

## C.5 网络与信息

### C.5.1 PageRank：幂法 + 一条五行的谱定理（推导）

把网页超链接写成矩阵：$S_{ij}=$ 「页面 $j$ 的链接中有多少份额指向 $i$」（每列和为 $1$，无出链的列改成均匀分布）。PageRank 向量 $\boldsymbol{r}$ 定义为 Google 矩阵

$$G=\alpha S+(1-\alpha)\,\frac{\boldsymbol{e}\boldsymbol{e}^{\mathrm T}}{n}\qquad(\alpha\approx0.85,\ \boldsymbol{e}=(1,\dots,1)^{\mathrm T})$$

的最大特征向量（特征值 $1$；$G$ 列随机 ⟹ $1$ 是特征值，Perron–Frobenius 保证对应正向量唯一）。**收敛速度由第二特征值决定，而它被 $\alpha$ 钉死**：设 $G\boldsymbol{y}=\lambda\boldsymbol{y}$，$\lambda\neq1$。由 $G^{\mathrm T}\boldsymbol{e}=\boldsymbol{e}$（列随机），$\boldsymbol{e}^{\mathrm T}\boldsymbol{y}=\tfrac1\lambda\boldsymbol{e}^{\mathrm T}G\boldsymbol{y}=\tfrac1\lambda\boldsymbol{e}^{\mathrm T}\boldsymbol{y}$，故 $\boldsymbol{e}^{\mathrm T}\boldsymbol{y}=0$。于是传送项失效：

$$G\boldsymbol{y}=\alpha S\boldsymbol{y}+\underbrace{(1-\alpha)\tfrac{\boldsymbol{e}}{n}\,(\boldsymbol{e}^{\mathrm T}\boldsymbol{y})}_{=\boldsymbol{0}}=\alpha S\boldsymbol{y}\qquad\Longrightarrow\qquad
\lvert\lambda\rvert\,\lVert\boldsymbol{y}\rVert_1=\lVert G\boldsymbol{y}\rVert_1\le\alpha\lVert S\boldsymbol{y}\rVert_1\le\alpha\lVert\boldsymbol{y}\rVert_1,$$

（$S$ 列随机 ⟹ $1$-范数不增）即 $\lvert\lambda_2\rvert\le\alpha$。**幂法（[2.5.3](../ch02/sec25.md#sec-2.5.3)）的收敛因子 $\le0.85$，与网络规模无关**——这是 Google 当年能「一遍一遍乘到收敛」的原因，也是「传送概率 $\alpha$」在数学上的真实作用：它买的不是公平，是**谱隙**。

### C.5.2 潜在语义分析（LSA）与矩阵分解家族

词-文档矩阵 $X$（行=词，列=文档，元素=词频）：$X\approx X_k$（截断 SVD）把「词 × 文档」压缩成「$k$ 个概念 × 文档」——$\boldsymbol{v}_i$ 是概念在文档上的分布，$\boldsymbol{u}_i$ 是概念用哪些词表达。截断甩掉的部分恰是同义词共现的噪声与偶然搭配，于是「car」与「automobile」自动靠近：**Eckart–Young 的「最优低秩」在信息检索里读作「最优概念抽象」**。词嵌入（GloVe 本质是对共现矩阵做低秩分解）、推荐系统（C.2.2）、LoRA（C.2.2）是同一母题在三个年代的变奏。

<a id="app-c-6"></a>

## C.6 数值分析自身的延长线

<a id="app-c-6-1"></a>

### C.6.1 Krylov 子空间一瞥：投影 + 正交化 + 条件数开方

大规模稀疏方程组 $A\boldsymbol{x}=\boldsymbol{b}$（$n\sim10^7$，$O(n^3)$ 直接法不可行）的现代解法不是迭代逼近（[第 2 章](../course/ch02/overview.md)的经典格式），而是**投影**：在 Krylov 子空间

$$\mathcal{K}_k(A,\boldsymbol{b})=\operatorname{span}\{\boldsymbol{b},\ A\boldsymbol{b},\ A^2\boldsymbol{b},\ \dots,\ A^{k-1}\boldsymbol{b}\}$$

里找「最像解」的向量（残差最小 = GMRES；误差的 $A$-范数最小 = 共轭梯度 CG，要求 $A$ 对称正定）。三个熟悉的名字各就各位：

- **Arnoldi 过程** = 对 Krylov 序列做 Gram–Schmidt（[2.3.1](../ch02/sec23.md#sec-2.3.1)）——正交化不是备考技巧，是大规模计算的承重墙；
- **GMRES/CG** = 残差/误差到子空间的（斜）投影（[定理 2.2.3](../ch02/sec22.md#thm-2.2.3) 的双侧推广）；
- **收敛率**（$A$ 对称正定时）：$\lVert\boldsymbol{e}_k\rVert_A\le2\Bigl(\dfrac{\sqrt\kappa-1}{\sqrt\kappa+1}\Bigr)^k\lVert\boldsymbol{e}_0\rVert_A$——**条件数开了平方**，与梯度下降的 $\bigl(\frac{\kappa-1}{\kappa+1}\bigr)^k$（C.2.1）并排读：同样的 $k$ 步预算，CG 对付得了 $\kappa=10^6$，梯度下降对付不了 $\kappa=10^3$。直觉：CG 的第 $k$ 步在 $k$ 维子空间里**最优**（近似解一个 $k\times k$ 小特征值问题，最优多项式 ≈ Chebyshev 多项式），而梯度下降每步只看局部斜率。

### C.6.2 预条件：把「好解的矩阵」藏在背后

CG 的 $\sqrt\kappa$ 还不够时，解 $P^{-1}A\boldsymbol{x}=P^{-1}\boldsymbol{b}$：取 $P\approx A$ 而易于求解（不完全 Cholesky、块对角、多重网格），$\mathrm{cond}(P^{-1}A)\ll\mathrm{cond}(A)$。这就是 C.2.3 那张表的算法库版本——**「换度量」是贯穿统计（加权最小二乘）、优化（Adam/牛顿）、数值代数（预条件）三个领域的同一招式**：问题没变，看问题的坐标系变了，条件数就变了。

::: note 怎么用本附录
每节的推导都只需要本课程第一章 + 补充篇的内容：内积与投影（2.1–2.2）、正交化（2.3）、条件数（1.2.6、2.4）、谱（2.5）、SVD（2.6）。写课程报告或综述时，建议的结构是「先复述正文工具，再给本附录的对应推导，最后回到自己领域的一句话总结」——数学结构是桥，走过去时别忘了桥墩在哪。
:::
