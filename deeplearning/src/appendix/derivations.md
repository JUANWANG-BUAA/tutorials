# 附录 C · 补充推导与实现细节

正讲为了节奏，把一些推导压成了「结论 + 直觉」。这一页把那些推导**补全到可以独立跟读**的程度，并补上几处工程实现的关键细节。**只在你需要「更严格」或「更工程」时读它。**

::: note 本页收录与否的判据
收录标准是「**正文给了结论但没给完推导，且这个推导值得自己写一遍**」。过于冗长的证明（如通用逼近定理的测度论证明）不在其列，只给出处。
:::

## 一、反向传播与自动微分

### C.1 矩阵形式的反向传播（含批维）

设第 $l$ 层：$\boldsymbol Z^{(l)}=\boldsymbol A^{(l-1)}W^{(l)}+\mathbf 1\boldsymbol b^{(l)\mathrm T}$，$\boldsymbol A^{(l)}=\phi(\boldsymbol Z^{(l)})$，$\boldsymbol A^{(0)}=\boldsymbol X\in\mathbb R^{B\times d_0}$。定义**误差信号矩阵**

$$\Delta^{(l)}\triangleq\frac{\partial\mathcal L}{\partial\boldsymbol Z^{(l)}}\in\mathbb R^{B\times d_l}.$$

**① 输出层**。设 $\mathcal L$ 对输出激活的梯度已知（记为 $G^{(L)}=\partial\mathcal L/\partial\boldsymbol A^{(L)}$，与 $\boldsymbol A^{(L)}$ 同形）。因 $\boldsymbol A^{(L)}$ 是 $\boldsymbol Z^{(L)}$ 的逐元素函数：

$$\Delta^{(L)}=G^{(L)}\odot\phi'\bigl(\boldsymbol Z^{(L)}\bigr).$$

**② 逐层回传**。由 $\boldsymbol Z^{(l+1)}=\boldsymbol A^{(l)}W^{(l+1)}+\cdots$ 得 $\dfrac{\partial\mathcal L}{\partial\boldsymbol A^{(l)}}=\Delta^{(l+1)}W^{(l+1)\mathrm T}$，再穿一次逐元素激活：

$$\boxed{\ \Delta^{(l)}=\bigl(\Delta^{(l+1)}W^{(l+1)\mathrm T}\bigr)\odot\phi'\bigl(\boldsymbol Z^{(l)}\bigr)\ }\qquad l=L-1,\dots,1 .$$

**③ 参数梯度**。由 $\partial\boldsymbol Z^{(l)}_{bj}/\partial W^{(l)}_{ik}=\mathbf 1[b\ \text{行}]\cdot A^{(l-1)}_{bi}\cdot\mathbf 1[j=k]$，写成矩阵形式即

$$\frac{\partial\mathcal L}{\partial W^{(l)}}=\boldsymbol A^{(l-1)\mathrm T}\Delta^{(l)}\in\mathbb R^{d_{l-1}\times d_l},\qquad
\frac{\partial\mathcal L}{\partial\boldsymbol b^{(l)}}=\Delta^{(l)\mathrm T}\mathbf 1=\sum_{b=1}^{B}\Delta^{(l)}_{b,:}\in\mathbb R^{d_l}.$$

**④ 为什么是「线性时间」**。前向一次、反向一次，每次每层只需两次矩阵乘（$O(Bd_{l-1}d_l)$）——总代价是参数量的常数倍。若改用逐参数数值微分，需要「参数量次前向」，在 $10^9$ 参数规模下完全不可行。

> **工程要点**：反传的中间量 $\Delta^{(l)}$ 通常**不显式保存**，而是与反向计算交错产生（这就是 PyTorch 的 autograd 引擎做的事）。真正占显存的是前向激活 $\boldsymbol A^{(l)}$ —— 这也是**激活重计算**的用武之地（[9.5](../lectures/lec09/sec95.md)）。

### C.2 梯度检查（grad check）的原理

数值梯度用中心差分：$\dfrac{\partial f}{\partial\theta_i}\approx\dfrac{f(\theta_i+h)-f(\theta_i-h)}{2h}$，误差 $O(h^2)$。

在 float64 下 $h=10^{-6}$ 量级最稳（$h$ 太小被舍入误差淹没，太大截断误差显著）。判据：相对误差 $\dfrac{|g_{\text{num}}-g_{\text{auto}}|}{\max(1,|g_{\text{num}}|,|g_{\text{auto}}|)}<10^{-5}$。

**注意**：梯度检查必须在 **float64 + 关闭 dropout/BN 的训练模式** 下做；否则差异来自随机性或精度，而不是实现错误。

## 二、注意力与 Transformer

### C.3 为什么是 $\sqrt{d_k}$：方差论证

设 $q,k\in\mathbb R^{d_k}$ 各分量独立、均值 0、方差 1。则点积 $s=\boldsymbol q\cdot\boldsymbol k=\sum_{i=1}^{d_k}q_ik_i$ 满足

$$\mathbb E[s]=0,\qquad \mathrm{Var}(s)=\sum_i \mathbb E[q_i^2]\mathbb E[k_i^2]=d_k .$$

于是 $s$ 的**标准差是 $\sqrt{d_k}$**：维度越大，logits 分布越宽，softmax 越容易进入饱和区（少数分量接近 1，其余接近 0），其雅可比趋近于 0，梯度消失。除以 $\sqrt{d_k}$ 后方差归一为 1，尺度与 $d_k$ 解耦。

> **推广**：这也是「**温度**」在注意力里的一种表现形式——除数是显式的逆温度。同理，模型输出层的 logits 若尺度异常，也会出现同类饱和问题。

### C.4 因果掩码与实现细节

自回归注意力的掩码把未来位置的对数权重置为 $-\infty$（实现里用 `-1e9` 或 `finfo(dtype).min`）：

$$\tilde S=\frac{QK^{\mathrm T}}{\sqrt{d_k}}+M,\qquad M_{ij}=\begin{cases}0,&j\le i\\ -\infty,&j\gt i\end{cases}.$$

**实现要点**：① 必须用足够大的负数（不能直接用 `-inf`，否则与 NaN 相遇会污染整行）；② 训练与推理掩码形状不同（推理时若用 KV cache，只需最后一行）；③ FlashAttention 类的分块实现要在块内维护「行最大值 + 指数和」的在线更新（online softmax），否则分块后无法拼接。

### C.5 KV cache 的显存与带宽账

推理时每步只需算一个新 token 的 $q$，但需要**历史上全部** $k,v$。缓存大小：

$$\text{bytes}=2\ (\text{K,V})\times L\times H_{kv}\times d_h\times T\times B\times \text{sizeof(dtype)} .$$

以 12 层、$d=512$、8 头（$d_h=64$）、fp16、$B=8$、$T=1024$ 为例：$2\times12\times8\times64\times1024\times8\times2\approx201\ \text{MB}$；把 $T$ 换成 32768 则约 **6.4 GB**——这就是长上下文推理的显存主因。**GQA** 把 $H_{kv}$ 从 8 降到 2，直接降到 1/4。

**为什么推理是 memory-bound**：每步计算量只有 $O(LH_{kv}d_h)$ 级别，却要读遍权重（$2N$ 字节）与整个 KV cache；GPU 的算力用不满，瓶颈在显存带宽。

## 三、生成模型

### C.6 ELBO 的第二种推导（重要性采样视角）

对任意 $q(z\mid x)$：

$$\log p(x)=\log \mathbb E_{q}\!\left[\frac{p(x,z)}{q(z\mid x)}\right]\ \ge\ \mathbb E_{q}\!\left[\log\frac{p(x,z)}{q(z\mid x)}\right]\quad(\text{Jensen}) .$$

展开右侧：

$$\mathbb E_{q}\!\left[\log p(x\mid z)\right]+\mathbb E_{q}\!\left[\log\frac{p(z)}{q(z\mid x)}\right]
=\underbrace{\mathbb E_{q}[\log p(x\mid z)]}_{\text{重建}}-\underbrace{\mathrm{KL}\bigl(q(z\mid x)\,\|\,p(z)\bigr)}_{\text{正则}} .$$

**间隙**：$\log p(x)-\mathrm{ELBO}=\mathrm{KL}(q(z\mid x)\|p(z\mid x))\ge0$，因此后验越准（$q$ 越接近真后验），下界越紧——这也解释了为什么要用更强的后验族（如 Normalizing Flow 后验）。

### C.7 扩散：从变分下界到「噪声预测」

前向过程 $q(\boldsymbol x_t\mid\boldsymbol x_{t-1})=\mathcal N\bigl(\sqrt{\alpha_t}\boldsymbol x_{t-1},(1-\alpha_t)I\bigr)$，累乘得闭式

$$q(\boldsymbol x_t\mid\boldsymbol x_0)=\mathcal N\bigl(\sqrt{\bar\alpha_t}\boldsymbol x_0,(1-\bar\alpha_t)I\bigr)
\ \Longrightarrow\ \boldsymbol x_t=\sqrt{\bar\alpha_t}\boldsymbol x_0+\sqrt{1-\bar\alpha_t}\boldsymbol\varepsilon .$$

反向也近似为高斯：$p_\theta(\boldsymbol x_{t-1}\mid\boldsymbol x_t)=\mathcal N\bigl(\boldsymbol\mu_\theta(\boldsymbol x_t,t),\sigma_t^2I\bigr)$。变分下界分解为

$$\mathcal L_{\text{VLB}}=\sum_{t=2}^{T}\underbrace{\mathbb E_q\bigl[\mathrm{KL}\bigl(q(\boldsymbol x_{t-1}\mid\boldsymbol x_t,\boldsymbol x_0)\,\|\,p_\theta(\boldsymbol x_{t-1}\mid\boldsymbol x_t)\bigr)\bigr]}_{\text{每步两个高斯的 KL}}+C .$$

两个高斯之间的 KL 只依赖均值差：$\propto\lVert\tilde{\boldsymbol\mu}_t-\boldsymbol\mu_\theta\rVert^2$。而 $\tilde{\boldsymbol\mu}_t$ 与 $\boldsymbol\mu_\theta$ 都能写成「$\boldsymbol x_t$ 与噪声的函数」，代入并忽略权重系数（DDPM 的关键简化）即得

$$\mathcal L_{\text{simple}}=\mathbb E_{t,\boldsymbol x_0,\boldsymbol\varepsilon}\Bigl[\bigl\lVert\boldsymbol\varepsilon-\boldsymbol\varepsilon_\theta(\boldsymbol x_t,t)\bigr\rVert^2\Bigr] .$$

**直觉**：模型不直接回归 $\boldsymbol\mu$，而是回归**当时注入的噪声**；等价地，它学会「给定含噪图与噪声水平，判断这一层的噪声长什么样」。

### C.8 无分类器引导（CFG）的来历

无条件与有条件模型的得分函数可以线性外推：

$$\tilde{\boldsymbol\varepsilon}=\boldsymbol\varepsilon_\varnothing+s\,(\boldsymbol\varepsilon_{\boldsymbol c}-\boldsymbol\varepsilon_\varnothing),\qquad s\ge1 .$$

把它看成「沿条件方向放大」：$s=1$ 是纯条件模型，$s\gt1$ 加强条件作用（更贴提示但更易过饱和、多样性下降），$s=0$ 退化为无条件。**代价**：每次采样要跑两遍前向（除非训练时随机丢弃条件以支持单次前向近似）。

## 四、决策与对齐

### C.9 贝尔曼最优算子：为什么唯一

定义算子 $(\mathcal TV)(s)=\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V(s')\bigr]$。对任意 $V,U$：

$$\lVert\mathcal TV-\mathcal TU\rVert_\infty\le\gamma\lVert V-U\rVert_\infty$$

（因 $|\max_a f(a)-\max_a g(a)|\le\max_a|f(a)-g(a)|$）。故 $\mathcal T$ 是压缩映射，由 Banach 不动点定理，存在**唯一**不动点 $V^\star$，且值迭代以 $\gamma^k$ 的几何速率收敛。**这条压缩性也是「折扣因子必须小于 1」的数学理由**。

### C.10 策略梯度定理：按轨迹展开的证明

目标 $J(\theta)=\mathbb E_{\tau\sim\pi_\theta}[R(\tau)]$，其中轨迹概率 $\pi_\theta(\tau)=\rho(s_0)\prod_t\pi_\theta(a_t\mid s_t)P(s_{t+1}\mid s_t,a_t)$。因为**环境项与 $\theta$ 无关**，$\nabla_\theta\log\pi_\theta(\tau)=\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)$，于是

$$\nabla_\theta J=\mathbb E_{\tau}\Bigl[R(\tau)\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)\Bigr]
=\mathbb E\Bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\underbrace{G_t}_{\text{回报-to-go}}\Bigr].$$

第二行用到**因果性**：$t$ 之前动作的得分函数与 $t$ 之后的回报无关，$\mathbb E[R(\tau)\mid a_t]$ 可替换为 $G_t=\sum_{k\ge t}\gamma^{k-t}r_k$（只依赖 $a_t$ 之后的部分），这正是方差缩减的第一刀。加上基线 $b(s)$ 再做一刀（对 $b$ 的期望贡献为 0）：

$$\nabla_\theta J=\mathbb E\Bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\bigl(G_t-b(s_t)\bigr)\Bigr] .$$

> **严格性说明**：更完整的证明需要处理**状态分布本身依赖 $\theta$** 这一项。Sutton 等（*Policy Gradient Methods for Reinforcement Learning with Function Approximation*, 2000）给出了这部分抵消的标准论证；本教程正文采用按轨迹的直观版，结论一致。

### C.11 GAE：在偏差与方差之间插一个旋钮

TD 残差 $\delta_t=r_t+\gamma V(s_{t+1})-V(s_t)$ 是优势的「单步」无偏+高偏差估计。把 $n$ 步回报展开：

$$\hat A_t^{(n)}=\sum_{l=0}^{n-1}\gamma^{l}\delta_{t+l} .$$

对所有 $n$ 做指数加权（权重 $(1-\lambda)\lambda^{n-1}$）：

$$\hat A_t^{\text{GAE}(\gamma,\lambda)}=\sum_{l\ge0}(\gamma\lambda)^l\delta_{t+l} .$$

- $\lambda=0$：单步 TD（偏差大、方差小）；
- $\lambda=1$：蒙特卡洛（偏差小、方差大）。

**这就是 PPO 里那个 $\lambda$ 的全部含义**——一个偏差-方差的旋钮，与折扣 $\gamma$ 共同出现在 $\gamma\lambda$ 中。

### C.12 PPO 裁剪：为什么它替代了 KL 约束

定义概率比 $\rho_t=\pi_\theta(a_t\mid s_t)/\pi_{\theta_{\text{old}}}(a_t\mid s_t)$，PPO 的目标

$$\mathcal L^{\text{clip}}=\mathbb E\bigl[\min\bigl(\rho_tA_t,\ \mathrm{clip}(\rho_t,1-\epsilon,1+\epsilon)A_t\bigr)\bigr] .$$

**分两种情形看梯度**：

| 情形 | 未越界时 | 越界后 | 结果 |
|:--|:--|:--|:--|
| $A_t\gt0$（好动作） | $\mathcal L=\rho_tA_t$，鼓励增大 $\rho$ | 当 $\rho\gt1+\epsilon$，$\min$ 取 $(1+\epsilon)A_t$（常数） | **梯度为 0**：不再鼓励继续增大概率 |
| $A_t\lt0$（坏动作） | $\mathcal L=\rho_tA_t$，鼓励减小 $\rho$ | 当 $\rho\lt1-\epsilon$，$\min$ 取 $(1-\epsilon)A_t$（常数） | **梯度为 0**：不再鼓励继续减小概率 |

于是「超出信任域的更新」被**截断**而不是被惩罚——这就是与 TRPO 的差别：TRPO 显式解一个带 KL 约束的优化问题（需二阶近似），PPO 用一个分段线性的替代目标达到类似效果，实现简单得多。

### C.13 DPO：从 KL 正则目标到偏好分类损失

**第一步：写出带 KL 约束的目标**（在偏好数据上最大化奖励、同时不偏离参考模型太远）

$$\max_{\pi}\ \mathbb E_{x\sim\mathcal D,\,y\sim\pi}\bigl[r(x,y)\bigr]-\beta\,\mathrm{KL}\bigl(\pi(\cdot\mid x)\,\|\,\pi_{\text{ref}}(\cdot\mid x)\bigr) .$$

**第二步：求闭式最优解**（对每个 $x$，这是一个带熵正则的线性规划/变分问题）

$$\pi^\star(y\mid x)=\frac{1}{Z(x)}\pi_{\text{ref}}(y\mid x)\exp\!\bigl(r(x,y)/\beta\bigr)
\ \Longrightarrow\
r(x,y)=\beta\log\frac{\pi^\star(y\mid x)}{\pi_{\text{ref}}(y\mid x)}+\beta\log Z(x) .$$

**第三步：代入 Bradley–Terry 模型** $P(y_w\succ y_l\mid x)=\sigma\bigl(r(x,y_w)-r(x,y_l)\bigr)$。因为 $Z(x)$ **只依赖 $x$**，在差值中抵消：

$$P(y_w\succ y_l\mid x)=\sigma\!\left(\beta\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}\right).$$

**第四步：取负对数似然**即得 DPO 损失：

$$\mathcal L_{\text{DPO}}=-\mathbb E_{(x,y_w,y_l)}\left[\log\sigma\!\left(\beta\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}\right)\right] .$$

**值得注意的三点**：① 奖励被「隐式」参数化了（$\hat r=\beta\log(\pi_\theta/\pi_{\text{ref}})$），所以不需要奖励模型；② $\beta$ 控制「允许偏离参考模型多远」——太大则几乎不学，太小则迅速过拟合偏好数据；③ DPO 的失败模式是**偏好数据本身的偏差**直接进入模型（没有 RM 作为缓冲）。

## 五、数值与工程

### C.14 fp16 / bf16 的动态范围与 loss scaling

| 格式 | 指数位 | 尾数位 | 动态范围 | 相对精度 |
|:--|:--|:--|:--|:--|
| fp32 | 8 | 23 | $\sim10^{\pm38}$ | $\sim10^{-7}$ |
| fp16 | 5 | 10 | $\sim\pm6.5\times10^{4}$，最小正规数 $\sim6\times10^{-5}$ | $\sim10^{-3}$ |
| bf16 | 8 | 7 | 同 fp32 | $\sim10^{-2}$ |

**fp16 的问题**：反向传播中大量梯度小于 $6\times10^{-5}$，会**下溢为零**，训练直接卡住。**Loss scaling** 的解法：把损失放大 $2^{k}$（如 $k=16$）再反向，使梯度也放大同样倍数、落进可表示范围，更新前再缩回。Kahan/动态缩放会周期性检查是否溢出（出现 inf）并自动调整 $k$。

**bf16 的问题与优势**：范围与 fp32 相同（不需要 loss scaling），但尾数只有 7 位（精度约百分之一）——对梯度累加、softmax 归一化这类需要精细数值的操作，仍建议在 fp32 中完成（`torch.autocast` 会自动处理常见算子）。

### C.15 Adam 偏差修正的推导

设 $m_t=\beta_1m_{t-1}+(1-\beta_1)g_t$，$m_0=0$。展开：

$$m_t=(1-\beta_1)\sum_{i=0}^{t-1}\beta_1^{\,i}g_{t-i} .$$

若梯度近似平稳（$\mathbb E[g_i]\approx\bar g$），则 $\mathbb E[m_t]=(1-\beta_1^t)\bar g$ —— 早期（$t$ 小）它**系统性偏小**。于是定义 $\hat m_t=m_t/(1-\beta_1^t)$，使 $\mathbb E[\hat m_t]=\bar g$。二阶动量 $v_t$ 同理用 $1-\beta_2^t$ 修正。**这就是为什么 Adam 的更新式里有两个 $1-\beta^t$ 因子**（$\beta_1=0.9,\beta_2=0.999$ 时，前几步的修正量非常显著）。

### C.16 卷积的 im2col：为什么它快、贵在哪

把每个输出位置对应的感受野展平成一行，得到矩阵 $\tilde{\boldsymbol X}\in\mathbb R^{(H_{\text{out}}W_{\text{out}})\times(C_{\text{in}}K^2)}$，卷积即

$$\boldsymbol Y=\tilde{\boldsymbol X}\,\boldsymbol W_{\text{col}},\qquad \boldsymbol W_{\text{col}}\in\mathbb R^{C_{\text{in}}K^2\times C_{\text{out}}} .$$

**好处**：直接调用高度优化的 GEMM 内核（cuBLAS），工程上最容易快。
**代价**：$\tilde{\boldsymbol X}$ 的数据量是原始输入特征的 $K^2$ 倍（相邻滑动窗口重复存储），显存与带宽放大。现代实现（cuDNN、CUTLASS）用隐式 GEMM 与分块寄存器复用避免真正落地该矩阵。

### C.17 缩放律的拟合形式与「计算最优」的推导

Chinchilla 型缩放律（拟合形式）：

$$L(N,D)=E+\frac{A}{N^{\alpha}}+\frac{B}{D^{\beta}},\qquad \alpha\approx0.34,\ \beta\approx0.28,\ E\approx1.69 .$$

训练算力近似 $C\approx6ND$（前向 2 + 反向 4 次乘加）。在固定 $C$ 下最小化 $L$，用拉格朗日乘子可得

$$N^\star\propto C^{\frac{\beta}{\alpha+\beta}},\qquad D^\star\propto C^{\frac{\alpha}{\alpha+\beta}} .$$

因 $\alpha\approx\beta$，两者近似**等比例**扩张：$N^\star,D^\star\propto C^{1/2}$，经验上换算成「每个参数配约 20 个 token」（$D\approx20N$）。**注意**：这是「给定算力下的最优配比」，不是「越大越好」；且这些系数来自特定数据分布与训练配方，跨数据/跨目标外推时要谨慎。

### C.18 显存五账单的逐项推导（复算用）

设参数量 $N$，优化器为 Adam 系，混合精度（低精度前向反向 + fp32 主权重）：

| 项 | 组成 | 字节 |
|:--|:--|:--|
| 参数 | 低精度副本 | $2N$ |
| 梯度 | 低精度副本 | $2N$ |
| 一阶动量 $m$ | fp32 | $4N$ |
| 二阶动量 $v$ | fp32 | $4N$ |
| 主权重 | fp32 | $4N$ |
| **静态合计** | | $\mathbf{16N}$ |
| 激活 | $\propto B\cdot T\cdot L$（注意力含 $B\cdot H\cdot T^2$ 项） | 与批、序列长、层数成正比 |

若用 8-bit 优化器（块量化 $m,v$）：$8N\to\sim2N$，静态降到 $\sim10N$。若用纯 fp32 + SGD：$12N$（无主权重）。**报告显存预算时一定要写清口径**，否则数字不可比。

---

::: method[core] 本页的用法
1. **不要通读**：按需进入（正讲里遇到「推导见附录」的引用时来查）。
2. **推一遍再对**：先自己写，再对照，差异处往往就是理解漏洞。
3. **改一个符号再用**：把批维去掉、把多头换成单头、把 $\lambda$ 设成 0 或 1——检验自己是否真懂公式的每一部分。
4. **回到正文**：每条推导都在正文有对应的「直觉框」，两者对照读最有效。
:::
