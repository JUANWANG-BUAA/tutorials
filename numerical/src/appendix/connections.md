# 附录 C · 跨学科联系与应用拓展

第一章讨论误差、范数和条件数，补充篇进一步介绍正交、投影、QR、谱与 SVD。本附录从统计、优化、信号和控制等问题出发，说明这些工具怎样使用。各节保留简短推导和正文链接；遇到陌生背景时，先看变量的定义与数学假设。

<a id="app-c-1"></a>

## C.1 统计学：最小二乘的另一张脸

[2.2.4](../supplement/sec22.md#sup-2.2.4) 的最小二乘在统计里用于**线性回归**（linear regression）：观测模型为 $\boldsymbol y=A\boldsymbol x+\boldsymbol\varepsilon$。这里 $A\in\mathbb R^{m\times n}$ 是已知且固定的设计矩阵，$\boldsymbol y\in\mathbb R^m$ 是观测，$\boldsymbol x\in\mathbb R^n$ 是未知但固定的参数，$\boldsymbol\varepsilon$ 是随机噪声。估计量随观测变化；几何上的拟合残差与统计上的参数估计误差不是同一个量。

### C.1.1 Gauss–Markov 定理（推导）

假设 $\mathbb E\boldsymbol\varepsilon=\boldsymbol0$、$\operatorname{Var}(\boldsymbol\varepsilon)=\sigma^2I_m$，即噪声均值为零、等方差且彼此不相关；这里 $\operatorname{Var}$ 对向量表示协方差矩阵。再设 $A$ 列满秩，故 $m\ge n$，$A^{\mathrm T}A$ 可逆。最小二乘估计为 $\hat{\boldsymbol x}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol y$。以下公式用于推导；实际计算优先用 QR 或 SVD，不必形成逆矩阵，也不必假设噪声为高斯分布。

**无偏。**$\mathbb{E}\,\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\mathbb{E}(A\boldsymbol{x}+\boldsymbol{\varepsilon})=\boldsymbol{x}$。

**方差。**$\hat{\boldsymbol{x}}-\boldsymbol{x}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{\varepsilon}$，故

$$\operatorname{Var}(\hat{\boldsymbol{x}})=\sigma^2(A^{\mathrm T}A)^{-1}A^{\mathrm T}A(A^{\mathrm T}A)^{-1}=\sigma^2(A^{\mathrm T}A)^{-1} .$$

**最优（BLUE，best linear unbiased estimator，最佳线性无偏估计）。**任取另一个线性估计 $\tilde{\boldsymbol x}=C\boldsymbol y$，其中 $C\in\mathbb R^{n\times m}$ 不依赖观测；要求它对所有参数 $\boldsymbol x$ 都无偏，等价于 $CA=I_n$。记 $C_0=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$，$D=C-C_0$，则 $DA=0$，且交叉项消失：$C_0D^{\mathrm T}=(A^{\mathrm T}A)^{-1}(DA)^{\mathrm T}=0$。于是

$$\operatorname{Var}(\tilde{\boldsymbol{x}})=\sigma^2CC^{\mathrm T}=\sigma^2\bigl[C_0C_0^{\mathrm T}+DD^{\mathrm T}\bigr]=\sigma^2(A^{\mathrm T}A)^{-1}+\sigma^2DD^{\mathrm T}\ \succeq\ \operatorname{Var}(\hat{\boldsymbol{x}}),$$

其中 $\succeq$ 表示两个协方差矩阵之差半正定：任取 $\boldsymbol a$，估计线性组合 $\boldsymbol a^{\mathrm T}\boldsymbol x$ 时，另一估计的方差至少多出 $\sigma^2\|D^{\mathrm T}\boldsymbol a\|_2^2\ge0$。这就是「最优」的含义；它只比较线性无偏估计，不宣称在所有可能的估计中误差最小。∎

**数值侧面。**各系数的方差由 $\sigma^2(A^{\mathrm T}A)^{-1}$ 的对角元给出。小奇异值对应的方向会放大观测噪声；条件数只衡量相对敏感性，单凭它不能确定方差的绝对大小。多重共线性是若干列之间近似线性相关，不限于某两列几乎平行；列尺度悬殊也可能使未缩放矩阵的条件数变大（见[例 2.4.1](../supplement/sec24.md#ex-sup-2.4.1)）。

### C.1.2 广义最小二乘：换内积 = 换噪声模型（对应 [定理 2.2.7](../supplement/sec22.md#thm-sup-2.2.7)）

若噪声仍为零均值，但 $\operatorname{Var}(\boldsymbol\varepsilon)=\sigma^2\Omega$，其中已知的 $\Omega$ 对称正定，则高方差观测应少信一些，相关观测也不能当成独立信息重复利用。因此最小化加权残差 $\|A\boldsymbol x-\boldsymbol y\|_{\Omega^{-1}}^2=(A\boldsymbol x-\boldsymbol y)^{\mathrm T}\Omega^{-1}(A\boldsymbol x-\boldsymbol y)$，其正规方程给出

$$\hat{\boldsymbol x}_{\mathrm{GLS}}=(A^{\mathrm T}\Omega^{-1}A)^{-1}A^{\mathrm T}\Omega^{-1}\boldsymbol y.$$

这称为广义最小二乘（generalized least squares，GLS），仍假设 $A$ 列满秩。若再假设噪声服从高斯分布，其对数似然为
$$\log p(\boldsymbol{y}\mid\boldsymbol{x})=-\frac{1}{2\sigma^2}(\boldsymbol{y}-A\boldsymbol{x})^{\mathrm T}\Omega^{-1}(\boldsymbol{y}-A\boldsymbol{x})+\text{const},$$
故它也是最大似然估计。取 Cholesky 分解 $\Omega^{-1}=L^{\mathrm T}L$，问题化为对 $(LA,L\boldsymbol{y})$ 的普通最小二乘，变换后的噪声协方差为 $\sigma^2I$，称为白化。协方差的逆决定权矩阵；有相关噪声时，权矩阵一般不是对角阵。这里的高斯假设用于似然解释，白化和线性无偏估计的方差比较本身不要求高斯分布。

### C.1.3 岭回归 = SVD 滤波（推导）

最小二乘无偏，却可能因小奇异值放大噪声。岭回归（ridge regression）允许引入偏差来压低这种方差。令本节 $\boldsymbol b$ 表示上一节的观测 $\boldsymbol y$，取 $\lambda>0$，最小化 $\|A\boldsymbol x-\boldsymbol b\|_2^2+\lambda\|\boldsymbol x\|_2^2$；对 $\boldsymbol x$ 求梯度并令其为零，得 $(A^{\mathrm T}A+\lambda I_n)\hat{\boldsymbol x}_\lambda=A^{\mathrm T}\boldsymbol b$。因为 $A^{\mathrm T}A+\lambda I_n$ 正定，即使 $A$ 不列满秩也有唯一解。代入秩为 $r$ 的紧致 SVD，$A=U_r\Sigma_rV_r^{\mathrm T}$，其中 $\Sigma_r\in\mathbb R^{r\times r}$；在 $A$ 的零空间方向，右端为零，解的分量也为零，于是

$$\hat{\boldsymbol{x}}_\lambda=V_r(\Sigma_r^2+\lambda I_r)^{-1}\Sigma_r U_r^{\mathrm T}\boldsymbol{b}=\sum_{i=1}^{r}\underbrace{\frac{\sigma_i^2}{\sigma_i^2+\lambda}}_{=:f_i}\cdot\frac{\boldsymbol{u}_i^{\mathrm T}\boldsymbol{b}}{\sigma_i}\,\boldsymbol{v}_i .$$

**读法：岭回归对每个 SVD 分量乘上滤波因子 $f_i\in(0,1)$**——大奇异值方向（$f_i\approx1$）原样保留，小奇异值方向（$\sigma_i^2\ll\lambda$，$f_i\approx\sigma_i^2/\lambda$）被压制。对比：

| 方法 | 小奇异值方向的处理 | $f_i$ 的形状 |
|:--|:--|:--|
| 截断 SVD / 截断伪逆（[2.6.4](../supplement/sec26.md#sup-2.6.4)） | 直接丢弃（$f_i=0$） | 硬阈值 |
| 岭回归（Tikhonov） | 平滑压制 | 平滑收缩，不是分段的软阈值算子 |

两者都在治同一个病：$1/\sigma_i$ 对小 $\sigma_i$ 的爆炸放大。$\lambda$ 的选择就是[2.6.4 思考题](../supplement/sec26.md#sup-2.6.4)里「按噪声水平截断」的连续版。

偏差与方差的取舍也可在一个奇异方向上直接算出。若 $\boldsymbol b=A\boldsymbol x^*+\boldsymbol\varepsilon$、$\mathbb E\boldsymbol\varepsilon=0$、$\operatorname{Var}(\boldsymbol\varepsilon)=\sigma_\varepsilon^2I$，令 $\theta_i=\boldsymbol v_i^{\mathrm T}\boldsymbol x^*$，则该方向的岭估计为 $f_i\theta_i+\frac{\sigma_i}{\sigma_i^2+\lambda}\boldsymbol u_i^{\mathrm T}\boldsymbol\varepsilon$。它的偏差是 $(f_i-1)\theta_i$，方差是 $\sigma_\varepsilon^2\sigma_i^2/(\sigma_i^2+\lambda)^2$，均方误差等于两者的“偏差平方加方差”。例如 $\sigma_i^2=\lambda$ 时，信号分量缩成一半，噪声方差缩成普通最小二乘的四分之一；总均方误差是否减小，还取决于未知信号 $\theta_i$。零空间方向则无法从观测辨识，岭估计将其置零，并不代表真实参数在那里必为零。

### C.1.4 PCA 的两种说法是一个定理

主成分分析（principal component analysis，PCA）既可描述为保留方差，也可描述为减少重建误差。设中心化数据矩阵 $X\in\mathbb R^{n\times p}$ 的行是样本，$n\ge2$，各列均值为零，样本协方差矩阵为 $C=X^{\mathrm T}X/(n-1)$。沿单位方向 $\boldsymbol v$ 的样本投影方差为 $\boldsymbol v^{\mathrm T}C\boldsymbol v$；必须限制 $\|\boldsymbol v\|_2=1$，否则仅放大 $\boldsymbol v$ 就能任意增大方差。

推广到 $k$ 维子空间，令 $V\in\mathbb R^{p\times k}$ 满足 $V^{\mathrm T}V=I_k$，每个样本的正交投影合起来为 $XVV^{\mathrm T}$。由勾股定理（[定理 2.2.3](../supplement/sec22.md#thm-sup-2.2.3)），

$$\|X-XVV^{\mathrm T}\|_F^2=\|X\|_F^2-\|XV\|_F^2
=\|X\|_F^2-(n-1)\operatorname{tr}(V^{\mathrm T}CV).$$

所以最大化保留的总方差恰好等价于最小化重建误差。对 $X$ 作 SVD 并取前 $k$ 个右奇异向量，即得到 Eckart–Young 定理的最佳秩 $k$ 逼近（[定理 2.6.4](../supplement/sec26.md#thm-sup-2.6.4)）。这些右奇异向量是主成分方向，$XV$ 的列才是样本的主成分得分；若截断位置有重奇异值，最优方向可以不唯一。协方差特征值与奇异值满足 $\lambda_i=\sigma_i^2/(n-1)$，故解释方差比为 $\sum_{i=1}^k\sigma_i^2/\sum_i\sigma_i^2$（总方差非零时；见 [2.7.3](../supplement/sec27.md#sup-2.7.3) 实验三）。

<a id="app-c-2"></a>

## C.2 机器学习与优化

<a id="app-c-2-1"></a>

### C.2.1 条件数决定训练快慢：梯度下降的收敛因子（推导）

训练常可表述为对损失 $f$ 做迭代最小化。先看二次模型 $f(\boldsymbol x)=\tfrac12\boldsymbol x^{\mathrm T}A\boldsymbol x-\boldsymbol b^{\mathrm T}\boldsymbol x$，其中 $A$ 对称正定，$\nabla f=A\boldsymbol x-\boldsymbol b$，最优解 $\boldsymbol x^*=A^{-1}\boldsymbol b$，即解一个线性方程组。梯度下降取固定步长 $\alpha>0$，由 $\boldsymbol x_{k+1}=\boldsymbol x_k-\alpha\nabla f(\boldsymbol x_k)$ 得误差 $\boldsymbol e_k=\boldsymbol x_k-\boldsymbol x^*$ 满足 $\boldsymbol e_{k+1}=(I-\alpha A)\boldsymbol e_k$。在 $A$ 的正交特征基下，第 $i$ 个分量乘以 $1-\alpha\lambda_i$；所有分量都收缩的条件是 $0<\alpha<2/\lambda_{\max}$。令 $\kappa=\mathrm{cond}_2(A)=\lambda_{\max}/\lambda_{\min}$，取 $\alpha=1/\lambda_{\max}$，在欧氏范数下：

$$|1-\alpha\lambda_i|\in\Bigl[0,\ 1-\frac{\lambda_{\min}}{\lambda_{\max}}\Bigr]=\Bigl[0,\ 1-\frac1\kappa\Bigr]\qquad\Longrightarrow\qquad
\lVert\boldsymbol{e}_k\rVert_2\le\Bigl(1-\frac1\kappa\Bigr)^k\lVert\boldsymbol{e}_0\rVert_2 .$$

对同一个对称正定二次问题，下面统一比较 $A$-范数下的误差上界。记 $\kappa=\mathrm{cond}_2(A)$、$E_k=\|\boldsymbol e_k\|_A$；上面的定步长估计在该范数下同样成立。

| 方法 | 第 $k$ 步误差上界 | 出处 |
|:--|:--|:--|
| 梯度下降，定步长 $\alpha=1/\lambda_{\max}$ | $E_k\le(1-1/\kappa)^kE_0$ | 本节 |
| 最速下降，每步精确线搜索 | $E_k\le\bigl((\kappa-1)/(\kappa+1)\bigr)^kE_0$ | [附录 A.2.8](derivations.md#app-a-2-8)（平方范数界开方） |
| 共轭梯度（CG） | $E_k\le2\bigl((\sqrt\kappa-1)/(\sqrt\kappa+1)\bigr)^kE_0$ | [附录 C.6.1](#app-c-6-1) |

$\kappa=10^4$ 时，三个几何底数分别约为 $0.9999$、$0.9998$、$0.9802$。第二行若比较平方误差，才会出现 $0.9996$；CG 的全局上界另有系数 2，不能将其底数当作每一步的精确压缩比。这些界说明条件数如何影响这类二次问题的收敛保证，实际速度还受初值和特征值分布影响。推广到非凸训练时，不能据此断言动量、Adam 或二阶法必然降低同一个条件数。

固定步长还可以取 $\alpha_*=2/(\lambda_{\min}+\lambda_{\max})$：使两个谱端点的因子 $1-\alpha\lambda_{\min}$ 与 $1-\alpha\lambda_{\max}$ 等大反号，就得到最小的最坏收缩因子 $(\kappa-1)/(\kappa+1)$。它与表中精确线搜索的保证相同，但需要极端特征值的信息，也不表示两种方法产生相同的迭代点。

### C.2.2 低秩的世界：从 Eckart–Young 到 LoRA 与推荐系统

低秩模型用较少的自由参数表示矩阵。下面三类应用都与低秩结构有关，但 [定理 2.6.4](../supplement/sec26.md#thm-sup-2.6.4) 只保证给定矩阵的最佳低秩逼近，不能直接保证各类训练任务的效果：

- **推荐系统 / 矩阵补全**：评分矩阵 $R$（用户×物品）假设近似低秩（口味由少数隐因子决定），于是「补全缺失评分」=「在已知元素约束下找低秩矩阵」——Eckart–Young 保证若观测完整，最优低秩就是截断 SVD；观测残缺时问题非凸，Netflix Prize 时代的经典做法仍以 SVD / 矩阵分解为骨架。
- **LoRA（大模型低秩适配）**：对 $m\times n$ 权重矩阵，令更新 $\Delta W=BA$、秩至多为 $r$，可训练参数由 $mn$ 个减为 $r(m+n)$ 个。若已知一个理想更新，截断 SVD 可求它在指定范数下的最佳低秩逼近；实际训练并不知道该更新，任务损失的优化也不是这一逼近定理。
- **语言与图像的谱衰减**：若具体数据矩阵的奇异值衰减较快，少数分量就能保留较大比例的平方能量（[2.6.6](../supplement/sec26.md#sup-2.6.6)）。是否足以完成下游任务，需要检查数据和任务误差，不能只由矩阵所属的数据类型判断。

### C.2.3 预条件：Adam、牛顿法与「换度量」

[2.4.5](../supplement/sec24.md#sup-2.4.5) 的行均衡化通过缩放方程改善数值尺度。更一般地，**预条件**（preconditioning）把 $A\boldsymbol x=\boldsymbol b$ 改写为 $P^{-1}A\boldsymbol x=P^{-1}\boldsymbol b$，其中 $P$ 可逆，且求解 $P\boldsymbol z=\boldsymbol r$ 要比原问题便宜；实际无需显式形成 $P^{-1}$。目的在于改善变换后问题的谱或尺度，但并非任意 $P\approx A$ 都有同样效果，非正规问题的收敛也不能只看条件数。下表把线性求解中的预条件与优化中的梯度缩放作比较：

| 场景 | $P$ 的取法 | 效果 |
|:--|:--|:--|
| 迭代法（[第 2 章](../course/ch02/overview.md)） | 不完全 Cholesky / 块对角 | 选得合适时，可减少 Krylov 迭代数；仍须计入构造和应用成本 |
| 牛顿法 | 局部 Hessian $H$，每步求解 $H\boldsymbol p=-\nabla f$ | 非退化极小点附近、Hessian 局部 Lipschitz 且初值足够近时局部二阶收敛；非凸时还需处理不定 Hessian |
| Adam 优化器 | 按梯度二阶矩估计构造 $\operatorname{diag}(\sqrt{\hat v}+\epsilon)$，$\epsilon>0$ | 与偏差修正后的动量一起给出各坐标的自适应缩放，可类比对角预条件 |

当 $P$ 对称正定时，可定义内积 $\langle\boldsymbol u,\boldsymbol v\rangle_P=\boldsymbol u^{\mathrm T}P\boldsymbol v$。因为 $\langle P^{-1}\nabla f,\boldsymbol d\rangle_P=\nabla f^{\mathrm T}\boldsymbol d$，$P^{-1}\nabla f$ 正是该内积下的梯度，这给出了「换度量」的具体含义。Adam 的 $P$ 随迭代变化，更新还包含动量，不能直接套用固定预条件矩阵的收敛结论，更不保证条件数下降。一般非对称或不定的 $P$ 不能直接用来定义内积。

<a id="app-c-3"></a>

## C.3 信号与图像

### C.3.1 DFT 是酉矩阵：正交不变性的复数版（推导）

离散 Fourier 变换（discrete Fourier transform，DFT）把 $N$ 个样本变为频率系数。本节用单位化约定 $\hat{\boldsymbol x}=F\boldsymbol x$，其中 $F=\dfrac1{\sqrt N}(\omega^{jk})_{j,k=0}^{N-1}$、$\omega=e^{-2\pi i/N}$，$i^2=-1$，上标 $\mathrm H$ 表示共轭转置。验证酉性 $F^{\mathrm H}F=I$，只须计算两列的复内积：

$$(F^{\mathrm H}F)_{jk}=\frac1N\sum_{n=0}^{N-1}\omega^{n(k-j)}=\frac1N\begin{cases}N,&j=k,\\[2pt]\dfrac{\omega^{N(k-j)}-1}{\omega^{k-j}-1}=0,&j\ne k\end{cases}=\delta_{jk}.$$

当 $j\ne k$ 时，分子为零而分母非零，这是等比数列求和。于是逆变换为 $F^{\mathrm H}$，且 $\|F\boldsymbol x\|_2^2=\boldsymbol x^{\mathrm H}F^{\mathrm H}F\boldsymbol x=\|\boldsymbol x\|_2^2$，即 **Parseval 恒等式**「时域能量等于频域能量」（[定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4) 与[定理 2.1.6](../supplement/sec21.md#thm-sup-2.1.6) 的复数版）。若软件采用未单位化的 DFT，能量等式会相应带上 $N$ 的因子。

快速 Fourier 变换（fast Fourier transform，FFT）是计算同一变换的快速算法，并非另一种近似。以 $N=2^q$ 为例，按输入的偶、奇下标拆成两个长度 $N/2$ 的 DFT，再乘旋转因子并做蝶形合并；代价满足 $T(N)=2T(N/2)+O(N)=O(N\log N)$。它不是简单地先后复合两个半长变换。

### C.3.2 匹配滤波：加权 Cauchy–Schwarz（推导）

雷达/通信的一个经典问题是：含噪声的实向量观测为 $\boldsymbol y=\boldsymbol s+\boldsymbol n$，已知非零信号 $\boldsymbol s$，噪声均值为零、协方差为 $R$。选择非零滤波向量 $\boldsymbol h$，把观测压缩为标量 $\boldsymbol h^{\mathrm T}\boldsymbol y$，使输出信噪比（signal-to-noise ratio，SNR）

$$\mathrm{SNR}=\frac{(\boldsymbol{h}^{\mathrm T}\boldsymbol{s})^2}{\operatorname{Var}(\boldsymbol{h}^{\mathrm T}\boldsymbol{n})}=\frac{(\boldsymbol{h}^{\mathrm T}\boldsymbol{s})^2}{\boldsymbol{h}^{\mathrm T}R\boldsymbol{h}}$$

最大。以下假设 $R$ 对称正定。令 $\tilde{\boldsymbol{h}}=R^{1/2}\boldsymbol{h}$、$\tilde{\boldsymbol{s}}=R^{-1/2}\boldsymbol{s}$，SNR $=\dfrac{(\tilde{\boldsymbol{h}}^{\mathrm T}\tilde{\boldsymbol{s}})^2}{\lVert\tilde{\boldsymbol{h}}\rVert^2}$，由 Cauchy–Schwarz（[引理 1.3.1](../ch01/sec13.md#sec-1.3.1)）$\le\lVert\tilde{\boldsymbol{s}}\rVert^2$，取等 $\tilde{\boldsymbol{h}}\propto\tilde{\boldsymbol{s}}$，即

$$\boxed{\ \boldsymbol{h}\ \propto\ R^{-1}\boldsymbol{s}\ },\qquad\max\mathrm{SNR}=\boldsymbol{s}^{\mathrm T}R^{-1}\boldsymbol{s} .$$

白噪声 $R=\sigma^2I$ 时，最优滤波器与信号本身平行；相关噪声下，则先由 $R^{-1/2}$ 白化，再沿白化信号方向取内积。这与 C.1.2 的广义最小二乘共享「先白化，再用欧氏几何」的步骤。声呐信号检测、GPS 伪距拟合（[GPS 误差预算](../ch01/application.md)）和最小二乘定位的任务不同，但都可利用已知协方差调整权重。

### C.3.3 压缩的谱系：为什么「平滑 ⟹ 可压缩」

压缩要在允许的失真下少存一些系数。离散余弦变换（discrete cosine transform，DCT，JPEG 中采用的变换）、小波和 SVD 压缩（[2.6.6](../supplement/sec26.md#sup-2.6.6)）都利用能量集中：换一种表示，使少数系数或分量携带大部分平方能量。对正交基展开 $\boldsymbol x=\sum_j a_j\boldsymbol q_j$，丢弃集合 $J$ 中的系数时，Parseval 给出精确失真 $\|\boldsymbol x-\tilde{\boldsymbol x}\|_2^2=\sum_{j\in J}|a_j|^2$。因此「尾项能量小」才是可压缩的直接条件；平滑性在合适基、边界条件下有助于系数衰减，但并非所有表示中都如此。各方法的区别还在于基从哪里来：

| 方法 | 基 | 依赖的结构 | 最优性 |
|:--|:--|:--|:--|
| SVD / PCA | 数据自适应（$\boldsymbol u_i,\boldsymbol v_i$） | 定理对任意矩阵成立；压缩有效需奇异值能量集中 | 给定秩下，对该矩阵的谱范数、Frobenius 范数误差最优 |
| DCT（JPEG） | 固定余弦基 | 自然图像的局部平滑与相关性 | 在特定相关模型下接近 Karhunen–Loève 变换（协方差特征基）；不是任意图像的最优基 |
| 小波 | 固定多分辨基 | 局部性、多尺度及分段光滑结构 | 在相应函数类与噪声模型下有稀疏逼近、阈值去噪保证 |

[2.6.6](../supplement/sec26.md#sup-2.6.6) 报告的「$20\%$ 存储换 $50.8$ dB」是其中一个 SVD 实验，不能直接作为同图 DCT 的测量结果。SVD 的最佳逼近定理无需平滑假设，但要计算并存储自适应基，稠密全 SVD 的运算量通常为 $O(mn\min\{m,n\})$；固定变换基无需逐图重新学习，计算快，却也需要数据能量在该基下集中。基的存储、系数量化和编码代价都应计入实际压缩率。

<a id="app-c-4"></a>

## C.4 物理与工程

### C.4.1 量子力学：谱定理、投影与变分原理的字典

先限于有限维、离散谱模型：可观测量以 Hermitian 矩阵 $H=H^{\mathrm H}$ 表示，状态 $\psi$ 是复单位向量。此时量子力学的几项数学关系可与本课程补充篇对应；无限维算子的定义域和连续谱问题不在此表范围内。

| 量子力学 | 本教程 | 出处 |
|:--|:--|:--|
| 可观测量 = Hermitian 算子 $H$，测量值只能是特征值 $\lambda_i$（**必为实数**） | 对称矩阵特征值全实、可正交对角化 | [定理 2.5.1](../supplement/sec25.md#thm-sup-2.5.1)（5） |
| 状态 $\psi$ 按 $\lVert\psi\rVert=1$ 归一；测量第 $i$ 个本征态的概率 $=\lvert\langle e_i,\psi\rangle\rvert^2$ | 单位向量的正交基展开与 **Parseval**：$\sum\lvert\langle\psi,\boldsymbol{q}_i\rangle\rvert^2=\lVert\psi\rVert^2=1$ | [定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4) |
| 理想投影测量得到非简并特征值后，状态变为对应本征态 | 正交投影后再归一化；重特征值时投影到整个本征子空间 | [定理 2.2.3](../supplement/sec22.md#thm-sup-2.2.3) |
| 能量期望 $\langle\psi\vert H\vert\psi\rangle$ | **Rayleigh 商** $R(\psi)$，必落在 $[\lambda_{\min},\lambda_{\max}]$ | [定理 2.5.4](../supplement/sec25.md#thm-sup-2.5.4) |
| 变分原理：基态能量 $=\min_\psi R(\psi)$，试探波函数给出能量上界 | $\lambda_{\min}=\min R$ | [定理 2.5.4](../supplement/sec25.md#thm-sup-2.5.4) |
| Rayleigh–Ritz 法（在子空间内找最优试探） | 投影到子空间 + 子空间内的谱 | [定理 2.2.5](../supplement/sec22.md#thm-sup-2.2.5) + C–F 定理 |

计算量子化学中的许多离散模型需要求大型 Hermitian 矩阵的最低几个特征对（基态及低激发态），可使用[反幂法 / Lanczos 类方法](../supplement/sec25.md#sup-2.5.3)。Weyl 定理（[定理 2.5.6](../supplement/sec25.md#thm-sup-2.5.6)）给出 $|\lambda_i(H+E)-\lambda_i(H)|\le\|E\|_2$，其中 $E$ 也须 Hermitian，特征值按同一顺序排列。它控制给定离散矩阵的特征值扰动，不能单独保证化学能量准确：物理模型、基组截断及求解残差还要分别检查。

### C.4.2 结构振动：广义特征值问题的对称化（推导）

无阻尼结构的自由振动满足 $M\ddot{\boldsymbol u}+K\boldsymbol u=\boldsymbol0$，其中质量阵 $M$ 对称正定，刚度阵 $K$ 对称半正定。寻找单一频率振动 $\boldsymbol u(t)=\boldsymbol\varphi\cos(\omega t)$，代入并约去时间因子，得到**广义特征值问题** $K\boldsymbol\varphi=\omega^2M\boldsymbol\varphi$。其特征值为 $\lambda_i=\omega_i^2\ge0$，$\omega_i$ 是固有角频率，$\boldsymbol\varphi_i$ 是振型；零特征值对应零频率模态。为保留对称结构，不直接把 $M^{-1}K$ 当成欧氏内积下的对称矩阵，而用 Cholesky 分解 $M=LL^{\mathrm T}$，令 $\boldsymbol\psi=L^{\mathrm T}\boldsymbol\varphi$（联系[例 2.1.1](../supplement/sec21.md#ex-sup-2.1.1) / [定理 2.2.7](../supplement/sec22.md#thm-sup-2.2.7)）：

$$K L^{-\mathrm T}\boldsymbol{\psi}=\omega^2LL^{\mathrm T}\boldsymbol{\varphi}=\omega^2L\boldsymbol{\psi}\qquad\Longrightarrow\qquad
\underbrace{L^{-1}KL^{-\mathrm T}}_{=:K',\ \text{对称}}\ \boldsymbol{\psi}=\omega^2\boldsymbol{\psi}.$$

对称化后的 $K'$ 仍半正定，故 $\omega_i^2\ge0$，可选标准正交的 $\boldsymbol\psi_i$；还原后原振型关于 $M$ 正交：$\boldsymbol\varphi_i^{\mathrm T}M\boldsymbol\varphi_j=\delta_{ij}$。令 $\Phi$ 由这些振型组成，代入 $\boldsymbol u=\Phi\boldsymbol q$ 并左乘 $\Phi^{\mathrm T}$，得到互相解耦的 $\ddot q_i+\omega_i^2q_i=0$，这就是模态叠加的基础（[定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4) 坐标公式的工程应用）。在许多低频响应分析中只保留最低若干阶，但所需阶数取决于载荷频谱和误差要求，不能固定为几十阶。Courant–Fischer 定理（[定理 2.5.5](../supplement/sec25.md#thm-sup-2.5.5)）说明子空间 Ritz 值的变分界；子空间能否准确逼近低端谱，还取决于它能否逼近相应特征向量。

### C.4.3 控制系统：谱的位置就是稳定性
这里讨论有限维、常系数线性系统的**渐近稳定性**，即任意初值的无外力响应最终趋于零；它不同于只要求响应始终有界。连续系统的解是 $e^{tA}\boldsymbol x(0)$，离散系统的解是 $G^k\boldsymbol x_0$，因此两者的判据分别落在左半平面和单位圆内。


| 模型 | 稳定判据 | 本课程工具 |
|:--|:--|:--|
| 连续 $\dot{\boldsymbol{x}}=A\boldsymbol{x}$ | 特征值全在左半复平面 | Gerschgorin 圆盘快速验证（[定理 2.5.2](../supplement/sec25.md#thm-sup-2.5.2) 用法 2） |
| 离散 $\boldsymbol{x}_{k+1}=G\boldsymbol{x}_k$ | $\rho(G)\lt1$ | [2.5.1](../supplement/sec25.md#sup-2.5.1)；但见瞬态增长警告 |
| 对 $\dot{\boldsymbol x}=A\boldsymbol x+B\boldsymbol u$ 加反馈 $\boldsymbol u=-K\boldsymbol x$ | 闭环矩阵为 $A-BK$，仍须检查其谱是否在左半平面 | 特征值计算 + 条件数；任意极点配置还要求相应可控性 |

两点限制尤其重要。① **瞬态增长**（[例 2.5.6](../supplement/sec25.md#ex-sup-2.5.6)、[附录 A.2.7](derivations.md#app-a-2-7)）：$\rho(G)<1$ 只保证最终趋于零，非正规的 $G$ 在此之前仍可能大幅放大扰动。在选定的诱导范数下，$\|G\|<1$ 是每步收缩的充分条件，却不是渐近稳定的必要条件。Gerschgorin 圆盘全部位于左半平面也只是连续系统稳定的充分检验，圆盘越界不能直接判为不稳定。② **特征值敏感性**：若矩阵可对角化为 $A=V\Lambda V^{-1}$，Bauer–Fike 定理（[定理 2.5.6](../supplement/sec25.md#thm-sup-2.5.6)（二））用 $\mathrm{cond}(V)\|E\|$ 界住扰动后特征值到原谱的距离。大的特征向量条件数表示可能敏感，不是每个方向扰动都会造成同样放大；缺陷矩阵也不能直接套用该分解。因此鲁棒性不能只由极点位置或一个条件数决定。

### C.4.4 电路仿真（SPICE）：一切归结为「解方程有多准」

SPICE（电路仿真程序）的三类分析都要反复求解方程：直流工作点常通过牛顿法求解非线性代数方程，每步解一个大型稀疏线性方程组；交流小信号分析在工作点线性化后，解频率扫描下的复线性方程组；瞬态分析用隐式方法离散微分—代数方程，每个时间步又可能形成「非线性方程 → 牛顿迭代 → 线性方程组」的求解链（相关 ODE 方法见[路线图第 7 章](../ch01/sec11.md#roadmap)）。线性电路不必额外做非线性迭代。可信度检查包括主元选取与线性求解的稳定性（[路线图第 2 章](../ch01/sec11.md#roadmap)）、矩阵条件数与必要的尺度均衡（[2.4.5](../supplement/sec24.md#sup-2.4.5)）、非线性迭代的残差和停机范数（[1.3.6](../ch01/sec13.md#sec-1.3.6)）。这些检查不能替代对时间离散误差和电路模型误差的评估。

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

潜在语义分析（latent semantic analysis，LSA）从词—文档矩阵 $X$ 出发，行对应词，列对应文档，元素可为词频或加权词频。截断 SVD 写成 $X_k=U_k\Sigma_kV_k^{\mathrm T}$，用 $k$ 个分量近似 $X$；例如文档在词空间正交基 $U_k$ 下的坐标为 $U_k^{\mathrm T}X=\Sigma_kV_k^{\mathrm T}$，不能只把不带奇异值的右奇异向量当成这一坐标。Eckart–Young 定理保证该近似在谱范数和 Frobenius 范数下最优，但不保证每个分量都是可解释的「概念」，也不保证被丢弃的成分全是噪声。语义检索效果仍须用具体任务评估。它与推荐系统、低秩适配（C.2.2）共享矩阵分解工具，各自的观测模型和优化目标则不同。

<a id="app-c-6"></a>

## C.6 数值分析自身的延长线

<a id="app-c-6-1"></a>

### C.6.1 Krylov 子空间一瞥：投影 + 正交化 + 条件数开方

对大规模稀疏方程组，Krylov 方法通过投影构造迭代近似，与[第 2 章](../course/ch02/overview.md)的定常迭代采用不同的搜索空间。先取初值为零，则在 Krylov 子空间

$$\mathcal{K}_k(A,\boldsymbol{b})=\operatorname{span}\{\boldsymbol{b},\ A\boldsymbol{b},\ A^2\boldsymbol{b},\ \dots,\ A^{k-1}\boldsymbol{b}\}$$

里找近似解。非零初值时，要改在仿射空间 $\boldsymbol x_0+\mathcal K_k(A,\boldsymbol r_0)$ 中搜索，$\boldsymbol r_0=\boldsymbol b-A\boldsymbol x_0$。不同方法的「最像」含义不同：

- **Arnoldi 过程**逐次计算 $A\boldsymbol q_j$，再对已有基做 Gram–Schmidt 正交化（[2.3.1](../supplement/sec23.md#sup-2.3.1)），构造 Krylov 空间的正交基，不必显式保存所有幂 $A^j$。
- **GMRES**（广义最小残差法）最小化 $\|\boldsymbol b-A\boldsymbol x_k\|_2$，因而残差正交于 $A\mathcal K_k$，是一个投影后的最小二乘问题。**CG**（共轭梯度法）要求 $A$ 对称正定，最小化 $\|\boldsymbol x_k-\boldsymbol x^*\|_A$，故误差在 $A$ 内积下正交于搜索空间，等价于残差正交于 $\mathcal K_k$。两种正交条件不同，不能笼统称为同一种斜投影。
- **CG 收敛界**（精确算术）：令 $\kappa=\lambda_{\max}(A)/\lambda_{\min}(A)$，则 $\|\boldsymbol e_k\|_A\le2((\sqrt\kappa-1)/(\sqrt\kappa+1))^k\|\boldsymbol e_0\|_A$。与 C.2.1 的最速下降界相比，它依赖 $\sqrt\kappa$；这不是每一步的精确压缩比，实际速度还取决于谱分布。

条件数开方来自多项式逼近。记 $\boldsymbol x^*=A^{-1}\boldsymbol b$、$\boldsymbol e_k=\boldsymbol x_k-\boldsymbol x^*$，若 $\boldsymbol e_0=0$ 则无需迭代；以下设它非零。任意该空间中的候选解，其误差可写为 $p_k(A)\boldsymbol e_0$，其中 $\deg p_k\le k$ 且 $p_k(0)=1$。

具体地，候选解可写成 $\boldsymbol x_0+q_{k-1}(A)\boldsymbol r_0$，其中 $q_{k-1}$ 的次数至多为 $k-1$。由 $\boldsymbol r_0=-A\boldsymbol e_0$，其误差为 $[I-Aq_{k-1}(A)]\boldsymbol e_0$，所以 $p_k(z)=1-zq_{k-1}(z)$，自然满足 $p_k(0)=1$。反过来，每个满足该条件的 $p_k$ 都能这样表示。这说明多项式不是额外假设，而是 Krylov 搜索空间的另一种写法。

由于 CG 在这些候选解中最小化误差，在正交特征基下有

$$\frac{\|\boldsymbol e_k\|_A}{\|\boldsymbol e_0\|_A}\le
\min_{\deg p\le k,\ p(0)=1}\max_{\lambda\in[\lambda_{\min},\lambda_{\max}]}|p(\lambda)|.$$

令 $a=\lambda_{\min}$、$b=\lambda_{\max}$。Chebyshev 多项式由 $T_k(\cos\theta)=\cos(k\theta)$ 定义，因此在 $[-1,1]$ 上满足 $|T_k|\le1$。$b>a$ 时选取缩放多项式

$$p(\lambda)=\frac{T_k((b+a-2\lambda)/(b-a))}{T_k((b+a)/(b-a))}.$$

分子的自变量落在 $[-1,1]$，故绝对值不超过 $1$；又由 $T_k(z)=((z+\sqrt{z^2-1})^k+(z-\sqrt{z^2-1})^k)/2$（$z>1$），得分母的倒数不超过 $2((\sqrt\kappa-1)/(\sqrt\kappa+1))^k$，于是得到上述界。若 $a=b$，则 $A=aI$，CG 一步即可求解。算法本身不必先知道这些特征值；多项式只用于证明收敛保证。

### C.6.2 预条件：把「好解的矩阵」藏在背后

对称正定问题可选对称正定的预条件矩阵 $P$，使每步容易求解 $P\boldsymbol z=\boldsymbol r$。预条件 CG 等价于在对称系统 $P^{-1/2}AP^{-1/2}$ 上使用 CG，其收敛界中的条件数是 $\mathrm{cond}_2(P^{-1/2}AP^{-1/2})$。$P^{-1}A$ 与该矩阵相似，但一般不对称，不能直接把它的谱条件比与欧氏范数条件数混用。好的预条件能改善谱分布；是否减少总计算量，还要比较预条件的构造、每步求解成本和实际迭代数。

::: note 怎么用本附录
各节使用的线性代数工具主要来自第一章和补充篇，应用背景及噪声模型另在本节说明：内积与投影（2.1–2.2）、正交化（2.3）、条件数（1.2.6、2.4）、谱（2.5）、SVD（2.6）。写课程报告或综述时，建议的结构是「先复述正文工具，再给本附录的对应推导，最后回到自己领域的一句话总结」——数学结构是桥，走过去时别忘了桥墩在哪。
:::
