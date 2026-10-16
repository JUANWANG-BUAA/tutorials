# 1.5 梯度下降与反向传播

[1.4 节](sec14.md)把任务翻译成了一个标量损失 $\mathcal L(\theta)$。剩下的问题是纯计算问题：如何得到 $\nabla_\theta\mathcal L$，并沿着它的反方向移动参数。

先做一个量级上的判断。一个中等规模的网络有 $10^6\sim10^8$ 个参数。如果按定义求梯度——对每个参数单独做一次「扰动—重算损失」，那就需要百万到亿次前向传播，在真实训练里完全不可行。而实践中我们每步只花**一次前向加一次反向**的代价就拿到了全部梯度。这个从 $O(\text{参数量})$ 到 $O(1)$ 的跨越，是深度学习能成立的技术前提。

这一节要讲清三件事：梯度下降为什么会收敛；**反向传播到底是什么**（答案：链式法则 + 中间结果复用，本质是动态规划）；以及一个被很多人忽略的实践环节——**梯度检查**，它是在你怀疑自己手写的算子出错时唯一可靠的验证手段。

## 1.5.1 梯度下降与随机梯度下降

::: def 定义 1.5.1 · 梯度下降（gradient descent） {#def-1.5.1}
设损失 $\mathcal L(\theta)$ 关于参数 $\theta\in\mathbb R^{P}$ 可微。**全批梯度下降（batch gradient descent）**的更新为

$$\theta_{t+1}=\theta_t-\eta\,\nabla_\theta\mathcal L(\theta_t),$$

其中 $\eta\gt0$ 为**学习率**（learning rate）。**随机梯度下降（stochastic gradient descent, SGD）**用一个小批量 $\mathcal B\subset\{1,\dots,N\}$（$|\mathcal B|=B$）上的平均梯度代替全批梯度：

$$\theta_{t+1}=\theta_t-\eta\,\widehat{\boldsymbol g}_t,\qquad \widehat{\boldsymbol g}_t=\frac1B\sum_{i\in\mathcal B}\nabla_\theta\mathcal L_i(\theta_t),\qquad \mathbb E_{\mathcal B}\bigl[\widehat{\boldsymbol g}_t\bigr]=\nabla_\theta\mathcal L(\theta_t).$$
:::

::: intuition 梯度下降低头走：为什么小批量反而更好
梯度下降只用了损失的一阶信息：它把参数朝「局部最陡下降方向」推一小步。学习率是步长——步长过大就冲过谷底来回震荡，过小就慢得等在原地（[1.6 节](sec16.md)会给出判据）。

小批量为什么反而常常比全批更好？三层原因：① **代价**：一批 $B$ 个样本的梯度估计把每步的代价从「扫全数据集」降到 $O(B)$，同样时间内能做多得多的更新；② **噪声是良性扰动**：小批量梯度是真实梯度的无偏估计，带方差，而这份噪声会阻止参数停在尖锐的极小值上，倾向于找到更平坦的解；③ **硬件友好**：批内样本的运算是天然并行的矩阵乘法。注意第 ② 条是**经验规律性的解释**，不是定理——噪声也可能把模型推出一个本来稳定的好解，这取决于噪声尺度与学习率的搭配。
:::

::: thm 定理 1.5.1 · 梯度下降在光滑凸问题上的下降保证 {#thm-1.5.1}
设 $\mathcal L$ 可微、梯度 $\beta$-Lipschitz 连续（即 $\lVert\nabla\mathcal L(\theta)-\nabla\mathcal L(\theta')\rVert\le\beta\lVert\theta-\theta'\rVert$），则取步长 $\eta\le 1/\beta$ 时

$$\mathcal L(\theta_{t+1})\le\mathcal L(\theta_t)-\frac{\eta}{2}\bigl\lVert\nabla\mathcal L(\theta_t)\bigr\rVert^2 .$$

若进一步假设 $\mathcal L$ 是 $\mu$-强凸，则 $\lVert\theta_t-\theta^\star\rVert^2$ 以速率 $\bigl(1-\eta\mu\bigr)^{t}$ 几何收敛；若只假设凸，则需 $O(1/\varepsilon)$ 步使梯度范数降到 $\varepsilon$。
:::

::: proof 推导（下降引理的来源）
对 $\mathcal L(\theta_{t+1})$ 在 $\theta_t$ 处作一阶泰勒展开并利用 Lipschitz 条件控制余项：

$$\mathcal L(\theta_{t+1})\le\mathcal L(\theta_t)+\nabla\mathcal L(\theta_t)^{\mathrm T}(\theta_{t+1}-\theta_t)+\frac{\beta}{2}\lVert\theta_{t+1}-\theta_t\rVert^2 .$$

代入 $\theta_{t+1}-\theta_t=-\eta\nabla\mathcal L(\theta_t)$：

$$\mathcal L(\theta_{t+1})\le\mathcal L(\theta_t)-\eta\lVert\nabla\mathcal L\rVert^2+\frac{\beta\eta^2}{2}\lVert\nabla\mathcal L\rVert^2=\mathcal L(\theta_t)-\eta\Bigl(1-\frac{\beta\eta}{2}\Bigr)\lVert\nabla\mathcal L\rVert^2 .$$

当 $\eta\le1/\beta$ 时 $\eta(1-\beta\eta/2)\ge \eta/2$，即得所述下降量。几何收敛速率来自强凸性给出的 $\lVert\nabla\mathcal L\rVert^2\ge 2\mu(\mathcal L-\mathcal L^\star)$。$\blacksquare$
:::

::: intuition 这条定理的三个工程含义
① **步长有一个硬上限**：$\eta\le1/\beta$，其中 $\beta$ 度量损失曲面的最大曲率。曲率越大的方向（往往是「参数取值差异悬殊」的方向）允许的步长越小——这是**归一化层与良好初始化能提高可用学习率**的根本原因：它们把各方向的曲率拉平。② **下降保证是局部的**：定理不保证到达全局最优，只保证每步不上升（对非凸损失，$\beta$-光滑只能保证到驻点附近）。③ **强凸才给出速率**：深度学习问题既不强凸也不凸，所以定理的作用是给出**判据与直觉**（如「学习率过大→震荡」），不能当作收敛证明。
:::

## 1.5.2 计算图、雅可比与 VJP {#sec-1.5.2}

反向传播在现代框架里被实现为「自动微分」，它的核心数据结构是**计算图**。

::: def 定义 1.5.2 · 计算图与雅可比 {#def-1.5.2}
**计算图（computational graph）**是把计算表示成有向无环图：节点是中间量（张量），边是基本运算。设某运算 $f$ 把输入 $\boldsymbol u\in\mathbb R^{n}$ 映射为输出 $\boldsymbol v\in\mathbb R^{m}$，则其**雅可比矩阵（Jacobian）**为

$$J=\frac{\partial\boldsymbol v}{\partial\boldsymbol u}\in\mathbb R^{m\times n},\qquad J_{kj}=\frac{\partial v_k}{\partial u_j}.$$

反向传播要做的是：已知「损失对 $f$ 输出的梯度」$\bar{\boldsymbol v}=\partial\mathcal L/\partial\boldsymbol v\in\mathbb R^{m}$，求「损失对 $f$ 输入的梯度」$\bar{\boldsymbol u}=\partial\mathcal L/\partial\boldsymbol u\in\mathbb R^{n}$。这个乘积

$$\bar{\boldsymbol u}=J^{\mathrm T}\bar{\boldsymbol v}\qquad\text{（即 }\bar u_j=\sum_{k}\bar v_k\frac{\partial v_k}{\partial u_j}\text{）}$$

称为**向量-雅可比积（vector-Jacobian product, VJP）**。反向传播就是**沿计算图逆序执行一串 VJP**。
:::

::: intuition 为什么是 VJP，而不是把雅可比算出来
对一层 $d_{\text{in}}\to d_{\text{out}}$ 的线性层，雅可比是 $d_{\text{out}}\times d_{\text{in}}$ 的矩阵（$d=1000$ 时是个 $10^6$ 元素的稠密矩阵），但**我们从来不需要它**：我们只需要它与某个具体向量 $\bar{\boldsymbol v}$ 的乘积，而这个乘积可以用两个矩阵乘法（或一次矩阵-向量乘）在 $O(d_{\text{in}}d_{\text{out}})$ 内算完，不需要显式构造 $J$。这就是自动微分「免费」的地方——**永远在向量与雅可比的乘积这一层工作，绝不停留在雅可比本身**。
:::

::: thm 定理 1.5.2 · 前向模式 vs 反向模式 {#thm-1.5.2}
设计算图从输入到输出包含 $n$ 个输入变量与 $m$ 个输出变量，正反向计算单个基本运算的代价均为 $c$：

- **前向模式（forward mode, JVP）**：从输入侧向输出侧累积导数 $\dot{\boldsymbol v}=J\dot{\boldsymbol u}$，一次传播给出**一个输入方向**的导数。求完整雅可比需 $n$ 次传播，总代价 $O(n\cdot c\cdot\text{图规模})$。
- **反向模式（reverse mode, VJP）**：从输出侧向输入侧累积 $\bar{\boldsymbol u}=J^{\mathrm T}\bar{\boldsymbol v}$，一次传播给出**一个输出方向**的导数。求完整雅可比需 $m$ 次传播，总代价 $O(m\cdot c\cdot\text{图规模})$。

**结论（选择依据）**：输入多、输出少（$n\gg m$，典型如「上亿参数 → 一个标量损失」，$m=1$）用**反向模式**；输入少、输出多（$n\ll m$，如「少数参数 → 大量预测」、隐式方程求解）用**前向模式**。深度学习属于前一种，因此训练一律用反向模式。
:::

::: proof 推导（代价的数量级来源）
以标量链式法则为例，设 $y=f_3(f_2(f_1(x)))$，链式法则给出 $\frac{dy}{dx}=f_3'f_2'f_1'$。

**朴素做法**：把三个因子展成多项式后相乘——如果每层导数本身还是多变量函数（例如 Jacobian 乘积），展开会随层数**指数膨胀**。

**前向模式**：定义 $\dot v^{(l)}=\frac{\partial v^{(l)}}{\partial x}$（对某个输入方向），逐步按 $\dot v^{(l)}=J_l\dot v^{(l-1)}$ 传播。每次传播代价 $O(\text{图规模})$，对 $n$ 个输入方向需 $n$ 次，故 $O(n\cdot\text{图规模})$。

**反向模式**：定义 $\bar v^{(l)}=\frac{\partial y}{\partial v^{(l)}}$，从输出端反向按 $\bar v^{(l-1)}=J_l^{\mathrm T}\bar v^{(l)}$ 传播。每次传播代价同样是 $O(\text{图规模})$，而对 $m$ 个输出方向需 $m$ 次。

深度学习里 $n=P$（参数量，可达 $10^{8}$）、$m=1$（标量损失），因此反向模式只需**一次**反向传播即可得到全部梯度，而前向模式需要 $P$ 次。$\blacksquare$
:::

::: think 内存换速度：反向模式真正的代价
反向模式一次传播就拿到全部梯度，代价是**必须保存前向的中间结果**（每层的激活值、门控值等），因为反向时要拿它们参与乘法。对 $L$ 层网络，激活显存约为 $O(L\cdot B\cdot d)$ 量级——这是训练显存比推理显存大得多的主因（推理只需保存当前层的输入输出）。

工程上的三条缓解路径：① **激活重计算（activation checkpointing / gradient checkpointing）**——只保留少数「检查点」的激活，反向时把中间段重算一遍，用时间换显存；② **混合精度**——用 BF16/FP16 保存激活，显存减半（见 [第 9 讲](../lec09/overview.md)）；③ **融合算子**——把「前向 + 反向」写成一个内核，避免把中间量写回显存。前向模式没有这个包袱（不需要保存全部中间结果），所以在**内存紧张而输入维度很小**的场景（如逐参数优化、隐式微分）反而有优势。
:::

## 1.5.3 反向传播的完整推导

现在把上面的机制落到 MLP 上。设 $L$ 层网络，批大小 $B$，损失 $\mathcal L$ 对所有样本取平均。

::: def 定义 1.5.3 · 误差信号（error signal） {#def-1.5.3}
第 $l$ 层的**误差信号**定义为损失对该层预激活的梯度：

$$\boldsymbol\delta^{(l)}\triangleq\frac{\partial\mathcal L}{\partial\boldsymbol Z^{(l)}}\in\mathbb R^{B\times d_l},\qquad\text{约定对批内样本求和（即 }\mathcal L=\sum_{i}\mathcal L_i\text{ 的约定）。}$$
:::

注意这里有一个**约定选择**，它决定了批量形状是否出现。若 $\mathcal L$ 取「批平均值」，则 $\boldsymbol\delta^{(l)}=\frac1B\partial\sum_i\mathcal L_i/\partial\boldsymbol Z^{(l)}$；本书为公式简洁采用「批求和」约定，实际代码里在损失处除以 $B$ 即可，两种约定只差一个常数因子。

::: thm 定理 1.5.3 · 反向传播递推（MLP） {#thm-1.5.3}
设各层 $\boldsymbol Z^{(l)}=\boldsymbol A^{(l-1)}W^{(l)}+\mathbf 1\boldsymbol b^{(l)\mathrm T}$、$\boldsymbol A^{(l)}=\phi(\boldsymbol Z^{(l)})$，$\odot$ 为逐元素积。则：

$$\boldsymbol\delta^{(L)}=\frac{\partial\mathcal L}{\partial\boldsymbol A^{(L)}}\odot\phi'\bigl(\boldsymbol Z^{(L)}\bigr)\qquad\text{（输出层）},$$

$$\boldsymbol\delta^{(l)}=\Bigl(\boldsymbol\delta^{(l+1)}W^{(l+1)\mathrm T}\Bigr)\odot\phi'\bigl(\boldsymbol Z^{(l)}\bigr)\qquad(l=L-1,\dots,1)\ \text{（逐层回传）},$$

$$\frac{\partial\mathcal L}{\partial W^{(l)}}=\boldsymbol A^{(l-1)\mathrm T}\boldsymbol\delta^{(l)}\in\mathbb R^{d_{l-1}\times d_l},\qquad \frac{\partial\mathcal L}{\partial\boldsymbol b^{(l)}}=\sum_{i=1}^{B}\boldsymbol\delta^{(l)}_{i,:}\in\mathbb R^{d_l}\ \text{（沿批维求和）}.$$
:::

::: proof 推导（逐层用链式法则，含形状核对）
**前提**：已知 $\dfrac{\partial\mathcal L}{\partial\boldsymbol A^{(L)}}$（由损失的形式决定；对 softmax + 交叉熵，它就是 $\hat{\boldsymbol Y}-\boldsymbol Y$，见 [定理 1.4.2](sec14.md#thm-1.4.2)）。

**第 1 步：输出层。** $\boldsymbol A^{(L)}=\phi(\boldsymbol Z^{(L)})$ 是逐元素运算，其雅可比为对角矩阵 $\partial A^{(L)}_{ij}/\partial Z^{(L)}_{ij}=\phi'(Z^{(L)}_{ij})$（非对角为零）。VJP 因此退化为逐元素乘法：

$$\boldsymbol\delta^{(L)}=\frac{\partial\mathcal L}{\partial\boldsymbol Z^{(L)}}=\frac{\partial\mathcal L}{\partial\boldsymbol A^{(L)}}\odot\phi'\bigl(\boldsymbol Z^{(L)}\bigr).$$

形状：$B\times d_L$ 与 $B\times d_L$ 的逐元素积，仍是 $B\times d_L$。

**第 2 步：回传一层（从 $\boldsymbol Z^{(l+1)}$ 到 $\boldsymbol Z^{(l)}$）。** 依赖链为 $\boldsymbol Z^{(l)}\to\boldsymbol A^{(l)}\to\boldsymbol Z^{(l+1)}$。先求对激活的梯度。由 $\boldsymbol Z^{(l+1)}=\boldsymbol A^{(l)}W^{(l+1)}+\mathbf 1\boldsymbol b^{(l+1)\mathrm T}$，视 $\boldsymbol Z^{(l+1)}$ 关于 $\boldsymbol A^{(l)}$ 为线性映射，其雅可比（在 VJP 方向上）给出

$$\frac{\partial\mathcal L}{\partial\boldsymbol A^{(l)}}=\frac{\partial\mathcal L}{\partial\boldsymbol Z^{(l+1)}}\cdot\frac{\partial\boldsymbol Z^{(l+1)}}{\partial\boldsymbol A^{(l)}}=\boldsymbol\delta^{(l+1)}W^{(l+1)\mathrm T}.$$

形状核对：$(B\times d_{l+1})\times(d_{l+1}\times d_l)=B\times d_l$，正确。

再穿过激活：$\boldsymbol\delta^{(l)}=\dfrac{\partial\mathcal L}{\partial\boldsymbol A^{(l)}}\odot\phi'(\boldsymbol Z^{(l)})$，即得递推式。

**第 3 步：参数梯度。** 由 $\boldsymbol Z^{(l)}=\boldsymbol A^{(l-1)}W^{(l)}+\cdots$，对 $W$ 的偏导可直接用矩阵微分：因 $Z_{ij}=\sum_k A_{ik}W_{kj}$，有 $\dfrac{\partial Z_{ij}}{\partial W_{kj}}=A_{ik}$，于是

$$\frac{\partial\mathcal L}{\partial W_{kj}}=\sum_{i,j'}\frac{\partial\mathcal L}{\partial Z_{ij'}}\frac{\partial Z_{ij'}}{\partial W_{kj}}=\sum_{i}\delta_{ij}A_{ik}=\bigl(\boldsymbol A^{(l-1)\mathrm T}\boldsymbol\delta^{(l)}\bigr)_{kj}.$$

形状核对：$(d_{l-1}\times B)\times(B\times d_l)=d_{l-1}\times d_l$，与 $W^{(l)}$ 同形，正确。对偏置同理：$\partial Z_{ij}/\partial b_j=1$，故 $\partial\mathcal L/\partial b_j=\sum_i\delta_{ij}$，形状 $d_l$，正确（**注意是沿批维求和，不是复制**）。$\blacksquare$
:::

::: intuition 一条误差信号，两个用途
递推式里最该记住的是：$\boldsymbol\delta^{(l)}$ **只依赖** $\boldsymbol\delta^{(l+1)}$。同一份误差信号被本层用于两件事——① 乘以 $W^{(l+1)\mathrm T}$ 继续往上游传，② 与 $\boldsymbol A^{(l-1)\mathrm T}$ 相乘算出本层参数梯度。**共享中间结果是复杂度从指数降到线性的关键**，这与动态规划的做法完全同构（用表格保存子问题解，避免重复计算）。所以正确的说法是：反向传播不是「新的数学」，它是**链式法则 + 记忆化**。
:::

::: ex 例 1.5.1 · 手推两层网络的一个参数梯度 {#ex-1.5.1}
一个两层网络：$d_0=2$，$d_1=2$（tanh），$d_2=1$（线性输出），批大小 $B=1$。输入 $\boldsymbol x=(1.0,\,2.0)$，真值 $y=1.0$，损失用 $\mathcal L=\frac12(\hat y-y)^2$（单样本、系数 $\frac12$）。

取 $W^{(1)}=\begin{pmatrix}0.5 & -0.5\\ 1.0 & 0.5\end{pmatrix}$，$\boldsymbol b^{(1)}=\boldsymbol 0$，$W^{(2)}=\begin{pmatrix}1.0\\ -1.0\end{pmatrix}$，$b^{(2)}=0.5$。

(1) 前向算出 $\hat y$ 与损失；(2) 算 $\delta^{(2)}$；(3) 回传到第 1 层得 $\delta^{(1)}$；(4) 给出 $\partial\mathcal L/\partial W^{(1)}$ 与 $\partial\mathcal L/\partial W^{(2)}$；(5) 用**中心差分**核对 $\partial\mathcal L/\partial W^{(2)}_1$（把该权重扰动 $\pm10^{-5}$ 重算损失）。

::: proof 解
**(1) 前向。** $\boldsymbol z^{(1)}=\boldsymbol x W^{(1)}=(1\cdot0.5+2\cdot1.0,\ 1\cdot(-0.5)+2\cdot0.5)=(2.5,\ 0.5)$。

$\boldsymbol a^{(1)}=\tanh(\boldsymbol z^{(1)})=(\tanh 2.5,\ \tanh 0.5)=(0.98661,\ 0.46212)$。

$\boldsymbol z^{(2)}=\boldsymbol a^{(1)}W^{(2)}+b^{(2)}=0.98661\times1.0+0.46212\times(-1.0)+0.5=1.02450$（四舍五入到 $10^{-5}$）。

$\mathcal L=\frac12(1.02450-1)^2=\frac12(0.02450)^2=3.0005\times10^{-4}$。

**(2) 输出层。** $\dfrac{\partial\mathcal L}{\partial\hat y}=\hat y-y=0.02450$；输出层为恒等，$\phi'=1$，故 $\delta^{(2)}=0.02450$（形状 $1\times1$）。

**(3) 回传。** $\dfrac{\partial\mathcal L}{\partial\boldsymbol a^{(1)}}=\delta^{(2)}W^{(2)\mathrm T}=0.02450\times(1.0,\,-1.0)=(0.02450,\,-0.02450)$。

$\tanh'=1-\tanh^2$：$\phi'(z_1)=1-0.98661^2=0.02660$，$\phi'(z_2)=1-0.46212^2=0.78644$。

$\boldsymbol\delta^{(1)}=(0.02450\times0.02660,\ -0.02450\times0.78644)=(6.51\times10^{-4},\ -1.93\times10^{-2})$。

**(4) 参数梯度。** $\dfrac{\partial\mathcal L}{\partial W^{(2)}}=\boldsymbol a^{(1)\mathrm T}\delta^{(2)}=(0.98661,\ -0.46212)^{\mathrm T}\times0.02450=(0.02417,\ -0.01132)^{\mathrm T}$（一列，形状 $2\times1$，与 $W^{(2)}$ 一致）。

$$\frac{\partial\mathcal L}{\partial W^{(1)}}=\boldsymbol x^{\mathrm T}\boldsymbol\delta^{(1)}=\begin{pmatrix}1.0\\ 2.0\end{pmatrix}\bigl(6.51\times10^{-4},\ -1.93\times10^{-2}\bigr)=\begin{pmatrix}6.51\times10^{-4} & -1.93\times10^{-2}\\ 1.30\times10^{-3} & -3.85\times10^{-2}\end{pmatrix}.$$

**(5) 数值核对（中心差分，$h=10^{-5}$）。** 只扰动 $W^{(2)}_1$：

$$W^{(2)}_1=1.0+10^{-5}\ \Rightarrow\ \mathcal L_+=3.00054\times10^{-4},\qquad W^{(2)}_1=1.0-10^{-5}\ \Rightarrow\ \mathcal L_-=2.99555\times10^{-4},$$

$$\frac{\mathcal L_+-\mathcal L_-}{2h}\approx0.02417,\qquad\text{解析值 }a^{(1)}_1\delta^{(2)}=0.98661\times0.02450=0.02417 .$$

两者吻合到 $10^{-5}$ 的精度。**顺带说明为什么必须用中心差分**：若改用前向差分（$h=10^{-3}$），得到的是 $0.02466$，与解析值差约 $2\%$——这个误差来自二阶余项 $\frac12\mathcal L''h\approx\frac12\times1\times10^{-3}$，与实现是否正确无关。**这也是 [1.5.4](#sec-1.5.4) 里「阈值要配合差分格式理解」的原因**。

**顺带读出一个重要现象**：$\boldsymbol\delta^{(1)}$ 的第一个分量比第二个小约 30 倍（$6.5\times10^{-4}$ 对 $1.9\times10^{-2}$），因为它乘上了 $\tanh$ 在 $z_1=2.5$ 处的导数 $0.0266$——那只有最大值 $1$ 的 $2.7\%$。**这就是 [1.3.3](sec13.md) 梯度消失的数值形态**：一个本该被更新的权重，实际只收到千分之几的梯度。$\blacksquare$
:::
:::

## 1.5.4 梯度检查：把解析梯度与数值梯度对齐 {#sec-1.5.4}

公式推对了不代表实现写对了。**梯度检查（gradient check）**用有限差分近似数值梯度，与解析（或自动微分）梯度比对，是把「实现错误」从「超参不对」里区分出来的标准手段。

::: def 定义 1.5.4 · 中心差分与相对误差 {#def-1.5.4}
**中心差分（central difference）**给出数值梯度

$$\frac{\partial\mathcal L}{\partial\theta_j}\approx\frac{\mathcal L(\theta_j+h)-\mathcal L(\theta_j-h)}{2h},$$

其误差为 $O(h^2)$（前向差分为 $O(h)$，但只需一次额外前向）。**相对误差**判据为

$$\text{rel\_err}=\frac{\bigl\lvert g^{\text{num}}_j-g^{\text{ana}}_j\bigr\rvert}{\max\bigl(1,\lvert g^{\text{num}}_j\rvert,\lvert g^{\text{ana}}_j\rvert\bigr)} .$$

经验阈值：$h=10^{-5}\sim10^{-6}$、**双精度**下，$\text{rel\_err}\lt10^{-7}$ 认为实现正确，$10^{-5}$ 量级可疑，$10^{-3}$ 及以上基本可以确定有 bug。
:::

::: method 梯度检查的标准流程与四类坑 {#method-1.5.1}
**流程**（顺序很重要）：

1. **降到单精度更容易对**：把模型、数据、损失全部转成 `float64`（`torch.float64`）。float32 下差分噪声本身就是 $10^{-4}$ 量级，无法分辨真假错误。
2. **用极小的规模**：$B\le4$、每层宽度 $\le16$、层数 $\le3$。梯度检查是 $O(P)$ 次前向，规模一大就跑不完。
3. **先检查损失值**：把实现和参考实现在**同一输入**上的损失打印出来。损失不一致时检查梯度没有意义。
4. **打开梯度累积**：`param.grad = None` 后做**一次**前向 + 一次反向（不要多步累加，也不要做任何 `zero_grad()` 干扰），然后与 `torch.autograd.gradcheck` 或自己写的中心差分对比。
5. **逐参数看相对误差而不是只看最大值**：随机抽若干参数打印 `(索引, 解析值, 数值值, rel_err)`；错误常常集中在某几个参数上（形状广播错误的典型信号）。
6. **检查通过后再开 `float32`、加大规模、打开正则项**：注意带 L2 正则的项也要计入损失，否则差分与解析会对不上一个常数倍。

**四类坑**：

| 坑 | 症状 | 处置 |
|:--|:--|:--|
| 在 ReLU/kink 点上检查 | 少数参数的 rel_err 忽大忽小、无规律 | 换 `Sigmoid`/`Tanh` 做检查，或扰动样本直到所有预激活离零点有距离 |
| float32 下检查 | 所有参数 rel_err 都在 $10^{-4}$ 量级 | 转 `float64`；必要时把 $h$ 调到 $10^{-5}$ |
| 忘记除以批大小 | 所有梯度恰好差 $1/B$ | 确认损失里是否有 `.mean()`；差分也走同一条损失代码 |
| 在 `no_grad` 或推理模式下检查 | 解析梯度为 `None` | 确认 `requires_grad_(True)` 且没有 `torch.no_grad()` 包裹 |
:::

## 1.5.5 代码：手写反传、自动微分与梯度检查

```python
import numpy as np, torch

# ============ ① 纯 numpy 手写两层网络：与例 1.5.1 同一套公式 ============
rng = np.random.default_rng(0)
N, D, H, C = 64, 2, 32, 2
X = rng.normal(0, 1, (N, D))
y = (X[:, 0] * X[:, 1] > 0).astype(int)        # XOR 型标签：线性不可分（见 1.1.3）

W1, b1 = rng.normal(0, np.sqrt(2/D), (D, H)), np.zeros(H)   # Kaiming 尺度（见 1.2.5）
W2, b2 = rng.normal(0, np.sqrt(2/H), (H, C)), np.zeros(C)
eta = 0.5

for step in range(2001):
    z1 = X @ W1 + b1                            # (N,H)
    a1 = np.maximum(0, z1)                      # ReLU：形状不变
    z2 = a1 @ W2 + b2                           # (N,C)
    z2 = z2 - z2.max(axis=1, keepdims=True)     # 数值稳定：先减行最大，softmax 结果不变
    p = np.exp(z2); p /= p.sum(axis=1, keepdims=True)
    L = -np.log(p[np.arange(N), y]).mean()      # 交叉熵（对批取平均）
    # 反向：定理 1.5.3 的三行 —— softmax+CE 的 δ 就是残差
    d2 = p.copy(); d2[np.arange(N), y] -= 1; d2 /= N      # 除以 N 对应 .mean()
    gW2, gb2 = a1.T @ d2, d2.sum(0)                        # ∂L/∂W = Aᵀδ；∂L/∂b = Σ_batch δ
    da1 = d2 @ W2.T                                        # 回传：δ⁽¹⁾ 的前一半
    dz1 = da1 * (z1 > 0)                                   # 乘 ReLU 导数（0/1 掩码）
    gW1, gb1 = X.T @ dz1, dz1.sum(0)
    W1 -= eta * gW1; b1 -= eta * gb1; W2 -= eta * gW2; b2 -= eta * gb2
    if step % 500 == 0:
        print(f"[numpy] step {step:4d} loss {L:.4f} acc {(p.argmax(1)==y).mean():.2%}")

# ============ ② 同样的网络用 PyTorch 自动微分：核对梯度 ============
net = torch.nn.Sequential(torch.nn.Linear(D, H), torch.nn.ReLU(), torch.nn.Linear(H, C)).double()
# 把 numpy 权重灌进去，保证两个实现初始状态一致，才能逐位比对
with torch.no_grad():
    net[0].weight.copy_(torch.tensor(W1.T)); net[0].bias.copy_(torch.tensor(b1))
    net[2].weight.copy_(torch.tensor(W2.T)); net[2].bias.copy_(torch.tensor(b2))

Xt, yt = torch.tensor(X), torch.tensor(y)
logits = net(Xt)
loss = torch.nn.functional.cross_entropy(logits, yt)      # 内部含 log_softmax，勿再手动加
net.zero_grad(); loss.backward()                          # 一次反向即得全部梯度
print("autograd ∇W1 形状:", tuple(net[0].weight.grad.shape))   # 应为 (H, D)：框架用“输出×输入”约定

# ============ ③ 梯度检查：中心差分 vs 自动微分 ============
def check_grad(model, x, y, h=1e-6, n_check=8):
    """对随机抽取的若干参数做中心差分，返回最大相对误差"""
    model.zero_grad()
    torch.nn.functional.cross_entropy(model(x), y).backward()
    worst = 0.0
    with torch.no_grad():
        for p in model.parameters():
            idx = [tuple(torch.randint(0, s, (1,)).item() for s in p.shape) for _ in range(n_check)]
            for i in idx:
                orig = p[i].item()
                p[i] = orig + h
                lp = torch.nn.functional.cross_entropy(model(x), y).item()
                p[i] = orig - h
                lm = torch.nn.functional.cross_entropy(model(x), y).item()
                p[i] = orig                                  # 必须复原，否则后续检查全部污染
                num = (lp - lm) / (2 * h)
                ana = p.grad[i].item()
                rel = abs(num - ana) / max(1.0, abs(num), abs(ana))
                worst = max(worst, rel)
    return worst

print("max rel_err =", check_grad(net, Xt, yt))   # 期望 <1e-9（float64）；>1e-5 说明实现有错

# ④ 直接用框架自带的 check，作为对照（更严格，逐个参数检查）
print(torch.autograd.gradcheck(
    lambda w1, b1, w2, b2: torch.nn.functional.cross_entropy(
        torch.nn.functional.relu(Xt @ w1.T + b1) @ w2.T + b2, yt),
    (net[0].weight, net[0].bias, net[2].weight, net[2].bias),
    eps=1e-6, atol=1e-8))   # 期望输出 True
```

::: method 这段代码的预期输出与自查判据 {#method-1.5.2}
**第一部分（numpy 手写）**在本教程环境（NumPy 2.x、种子 0）下的实测曲线：step 0 时 loss ≈ $1.092$、准确率 $43.75\%$；step 500 时 loss ≈ $0.0205$、准确率 $100\%$。跑出这个形状说明前向、损失、反向、更新四步都对上了。（若你的环境里曲线不同，先核对 NumPy 版本与 `default_rng(0)` 的用法——`RandomState` 与 `default_rng` 的随机数流不同。）

**第二部分（PyTorch 自动微分）**：`∇W1` 的形状应为 $(H,D)$，即「输出维在前」。**这一步是形状约定最容易搞错的地方**：本节公式里 $\partial\mathcal L/\partial W^{(l)}=\boldsymbol A^{(l-1)\mathrm T}\boldsymbol\delta^{(l)}$ 的形状是 $(d_{l-1},d_l)$，而框架内部存的是它的转置。只要核对一次形状，就能避免「公式对、实现差一个转置」这类最难查的错误。

**第三部分（梯度检查）**：期望 `max rel_err` 在 $10^{-9}$ 量级（float64 + 中心差分），`gradcheck` 返回 `True`。若你的 `rel_err` 在 $10^{-4}$ 量级或更大，按 [1.5.4 方法框](sec15.md)的四类坑逐条排查。

**一个重要的实践提醒**：这段代码是为了讲解而写成「手写差分」的；实际工程里不需要自己写，直接用 `torch.autograd.gradcheck`（逐参数、带容差、支持非标量输出）即可。本书保留手写版本是因为**它把判据（相对误差公式）显式展示出来了**，而不是藏在一个布尔返回值后面。
:::

## 1.5.6 陷阱与勘误

::: errata 本节七个高频错误
1. **「反向传播是一种近似 / 一种新数学」**：它是链式法则的**精确**实现，唯一近似之处在你是否用有限差分去近似它。误差来自数值方法，不来自反向传播本身。
2. **梯度累积**。PyTorch 的 `.grad` 默认**累加**：忘记 `zero_grad()` 会让梯度跨步叠加，表现为「学习率看起来太大」。判据：有效学习率约为设定值的 $k$ 倍而 $k$ 等于遗漏的步数。
3. **损失里对批求了两次平均**。若损失已 `mean` 过，又在反向里除以 $B$，梯度整体偏小 $B$ 倍，症状是「学习率调大才动」。
4. **把 $\partial\mathcal L/\partial\boldsymbol b=\boldsymbol\delta$ 写成不求和**。批量下的偏置梯度必须沿批维求和（定理 1.5.3），因为同一个偏置被批内所有样本共享。写成不求和会得到 $B\times d_l$ 的形状，框架会报错或（更糟）静默广播。
5. **没有梯度检查就调超参**。当损失不下降时，先做一次梯度检查，把「实现错」这一整类病因排除，再去调学习率。
6. **在 ReLU 折点上做梯度检查**。折点处导数不存在，中心差分与解析值必然不符，会浪费大量时间追查一个不存在的 bug。
7. **显存不够就只想着减小批大小**。激活显存是主因，更有效的是激活重计算或混合精度（[1.5.2](#sec-1.5.2)）；减小批大小会改变有效学习率，需要同步调整（[1.6.7](sec16.md)）。
:::

::: method 即时自测 · 1.5
**Q1** 说出「反向模式自动微分」相对「前向模式」的适用条件，并解释为什么深度学习训练一定选它。

**Q2** 写出 $\boldsymbol\delta^{(l)}$ 的递推式，并指出它在每层被用于哪两件事。

**Q3** 一个两层网络的批量大小为 $B$，偏置梯度为什么不等于 $\boldsymbol\delta^{(l)}$ 本身？正确形式是什么，形状是什么？

**Q4** 你在自己写的算子上做梯度检查，发现 rel_err ≈ 1e-3，且参数中只有一部分明显不一致。你会先检查哪三件事？

::: sol 参考要点
**Q1** 反向模式适合「输入多、输出少」（$n\gg m$）：一次反向传播给出对**全部输入**的导数，代价是 $O(m\cdot\text{图规模})$；前向模式适合「输入少、输出多」（$n\ll m$）。深度学习里输入维度是参数量 $P$（$10^6$ 到 $10^{11}$），输出是**一个标量损失**（$m=1$），因此反向模式一次传播就得到全部梯度；前向模式需要 $P$ 次，量级上不可行（见定理 1.5.2）。代价是反向模式需要保存前向中间结果，即显存开销。

**Q2** $\boldsymbol\delta^{(l)}=\bigl(\boldsymbol\delta^{(l+1)}W^{(l+1)\mathrm T}\bigr)\odot\phi'(\boldsymbol Z^{(l)})$，输出层用 $\boldsymbol\delta^{(L)}=\frac{\partial\mathcal L}{\partial\boldsymbol A^{(L)}}\odot\phi'(\boldsymbol Z^{(L)})$。两件事：① 与 $W^{(l+1)\mathrm T}$ 相乘后继续往上游（传给第 $l-1$ 层）；② 与 $\boldsymbol A^{(l-1)\mathrm T}$ 相乘得到本层权重梯度 $\partial\mathcal L/\partial W^{(l)}$。共享同一个 $\boldsymbol\delta^{(l)}$ 是复杂度降到线性的原因。

**Q3** 因为偏置 $\boldsymbol b^{(l)}$ 被批内 $B$ 个样本**共享**：每个样本对同一个 $b_j$ 都有贡献，链式法则要求把这些贡献相加。正确形式是沿批维求和 $\partial\mathcal L/\partial\boldsymbol b^{(l)}=\sum_{i=1}^{B}\boldsymbol\delta^{(l)}_{i,:}$，形状 $d_l$（与偏置同形）。若写成 $\boldsymbol\delta^{(l)}$ 本身，形状是 $B\times d_l$——维度不匹配，或经广播后被静默放大 $B$ 倍。

**Q4** 优先检查：① **是否在 float64 下检查**（float32 的差分噪声量级就在 $1e-4$，会掩盖真实误差）；② **损失是否与参考实现一致**（损失不一致时梯度检查没有意义，先对齐损失）；③ **是否存在广播 / 形状约定错误**——「只有一部分参数对不上」是这类错误的典型信号，尤其是权重形状的转置约定（框架是「输出×输入」，而教科书常写「输入×输出」）。若这三项都正常，再检查是否在 ReLU 折点附近采样、以及是否有某个中间量被原地修改后再参与反向。
:::
:::

::: note[skip] 延伸阅读
- Rumelhart, Hinton & Williams, *Learning Representations by Back-Propagating Errors*（1986，Nature）——反向传播用于多层网络的奠基性论文。
- Baydin, Pearlmutter, Radul & Siskind, *Automatic Differentiation in Machine Learning: a Survey*（2018，JMLR；arXiv:1502.05767）——前向/反向模式、VJP/JVP 与代价分析的权威综述，本节的定理 1.5.2 属于该领域的标准结论。
- Griewank & Walther, *Evaluating Derivatives: Principles and Techniques of Algorithmic Differentiation*（2008，SIAM）——自动微分的系统性专著（含反向模式的内存下界分析）。
- 课程：MIT 6.S191 的 TensorFlow / PyTorch 教程与 `github.com/aamini/introtodeeplearning` 的 Lab 1 前导部分——动手把「前向→损失→反向→更新」跑通。
:::

**本节小结**：训练的本质是「用一次前向 + 一次反向拿到全部梯度」，而这不是任何近似——反向传播是链式法则在计算图上逆序执行 VJP 的精确实现，其复杂度与图规模成线性，靠的是**中间结果复用**。前向模式与前向维度的数量成正比、反向模式与输出维度的数量成正比，深度学习里输出就是一个标量，所以选反向模式。误差信号 $\boldsymbol\delta^{(l)}$ 是全部推导的核心对象：它一份两用（继续回传 + 计算本层参数梯度），参数梯度是「输入转置 × 误差信号」，偏置梯度沿批维求和。最后，把解析梯度与中心差分对齐的**梯度检查**是区分「实现错」与「超参错」的唯一可靠手段。下一节的问题是：拿到梯度之后，**怎么走才最快**。
