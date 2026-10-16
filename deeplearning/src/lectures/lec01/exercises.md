# 第 1 讲习题集

> 四组难度递进：**A 概念判断 → B 推导证明 → C 编程实现 → D 开放设计**。答案默认折叠，点击展开。
> 用法：先闭卷做 A 组，再对照答案；B 组**手写**推导（涉及形状的先写形状）；C 组上机并跑通验收标准；D 组写成半页方案。
> 考点范围限 [导览](overview.md) 与 [1.1](sec11.md)–[1.7](sec17.md)，答案均可在正文定位。想不通时先回「依据」，再看折叠答案。

## A 组 · 概念判断（8 题）

**判定要求**：判断题必须给**一句话理由或反例**，只写「对 / 错」不给分；辨析题必须写清「谁管什么」。

**A1.** 把一个**单层**网络的阶跃激活换成 Sigmoid，它能解决的问题变多了。（依据：[1.1.4](sec11.md)、[定义 1.1.2](sec11.md#def-1.1.2)）

::: sol 答案
**错。** 单层的判决面由 $z=\boldsymbol w^{\mathrm T}\boldsymbol x+b=0$ 决定，不论 $\phi$ 是阶跃还是 Sigmoid，**判决面仍是同一个超平面**，能表达的函数族依旧只是线性可分的那一类。换激活改变的是「能否用梯度训练」，不是「能表达什么」；能力来自**分层**（[1.1.4](sec11.md) 误解 1、2）。
:::

**A2.** 偏置 $b$ 可以省掉：把输入扩一维恒为 1 就够了，所以**没有偏置的感知机表达能力不变**。（依据：[1.1.4](sec11.md) 误解 4）

::: sol 答案
**对（但要加条件）。** 把 $(\boldsymbol x,1)$ 当作新输入后，$\boldsymbol w^\star=(\boldsymbol w,b)$ 的学习与带偏置模型完全等价，超平面自由度没有损失——这正是 [定理 1.1.1](sec11.md#thm-1.1.1) 证明里用 $\tilde{\boldsymbol x}=(\boldsymbol x,1)$ 的原因。**注意**：若「省掉偏置」既不给 $b$ 也不增广输入，超平面被迫过原点，「$(0,0)$ 归负类、其余归正类」这种问题立刻不可分，表达能力**确实**下降。
:::

**A3.** 通用逼近定理保证：只要隐藏层足够宽，训练一定能收敛到一个好的解。（依据：[定理 1.2.2](sec12.md#thm-1.2.2)、[1.2.3](sec12.md#sec-1.2.3)）

::: sol 答案
**错。** 定理只回答**表示问题**（是否存在权重让网络逼近目标函数），不涉及优化与统计。三条边界：① **不保证宽度可寻**（所需宽度可能随输入维度指数增长）；② **不保证可训练**（构造性证明给出的权重往往在损失曲面上极难到达）；③ **不保证样本效率**（存在一组权重 ≠ 有限样本能学到它）。把「能表示」读成「能学会」是本节最大的误读。
:::

**A4.** 逐元素激活会改变张量形状，所以排错时应把它和 `Flatten` 归为同类算子。（依据：[方法 1.2.1](sec12.md#method-1.2.1)、[1.2.7](sec12.md) 误解 3）

::: sol 答案
**错。** 逐元素激活**不改变形状**（[方法 1.2.1](sec12.md#method-1.2.1) 第 2 条规则）；改变形状的是展平、池化、卷积 stride、`view/reshape`。混为一谈的直接后果是形状表算错，而这正是「编译期报错」里最高频的一类。
:::

**A5.** `optim.Adam(model.parameters(), weight_decay=0.05)` 与 `optim.AdamW(..., weight_decay=0.05)` 是同一个东西的两种写法。（依据：[定理 1.6.1](sec16.md#thm-1.6.1)、[1.6.9](sec16.md) 错误 1）

::: sol 答案
**错。** `Adam(weight_decay=λ)` 是 **Adam + L2**：正则项 $\lambda\theta$ 进梯度后被逐元素除以 $\sqrt{\hat{\boldsymbol v}_t}+\epsilon$，**各坐标的衰减强度取决于各自的梯度历史**。`AdamW` 是**解耦权重衰减**：更新后独立减去 $\eta_t\lambda\theta_{t-1}$，对所有坐标施加同一相对衰减。两者在 SGD 下等价（都化简为 $(1-\eta\lambda)\theta-\eta\boldsymbol g$），在自适应优化器下不等价。
:::

**A6.** 真值是 $[0,1]$ 之间的连续「软分数」（表示模糊程度、无概率语义）时用 MSE 可以接受；而「从 10 个互斥类别里选一个」必须用交叉熵。（依据：[1.4.2](sec14.md)、[1.4.10](sec14.md) 错误 1）

::: sol 答案
**对。** 判据是**任务的概率模型**：前者是回归到区间内的软分数，没有类别分布假设，MSE 与之一致；后者是离散类别分布，交叉熵才是它的负对数似然，且梯度恰为 $\hat{\boldsymbol p}-\boldsymbol y$。**补充**：互斥分类若改用 MSE + softmax，梯度里多出 $\hat y(1-\hat y)$ 因子，在模型最该被纠正的两个极端反而最小，训练更慢、概率校准更差。
:::

**A7.** 均匀初始化时，只要各单元权重是**独立采样**且方差合适，就不会有对称性问题。（依据：[方法 1.2.2](sec12.md#method-1.2.2)、[1.2.7](sec12.md) 误解 4）

::: sol 答案
**对。** 对称性由**权重之间的独立性**打破：同层不同单元权重独立采样时，它们的预激活、激活与梯度不会完全一致，梯度下降能区分开。所以「随机」是必要条件，「方差合适」是第二个必要条件（否则逐层放大或衰减）。**反面**：全零（或全常数）初始化时同层单元完全对称，训练等价于「一个单元的层」。
:::

**A8.** 用验证集反复调超参、最后把验证集上最好那一档写进报告，是允许的省事做法。（依据：[定义 1.7.1](sec17.md#def-1.7.1)、[1.7.6 的数据泄漏清单](sec17.md) 第 5 条）

::: sol 答案
**错。** 每一次基于验证集的选择都在**消耗验证集的信息**，等价于在验证集上过拟合，报告指标会系统性偏高。正确做法：选模型用验证集，**最终报告用只评估一次的测试集**（[定义 1.7.1](sec17.md#def-1.7.1)：测试集只应被使用一次）。若必须报验证集指标，要说明调参次数并给出多种子方差。
:::

## B 组 · 推导与证明（6 题）

> 要求：关键步骤逐条写出，不许写「略」；涉及形状的先写形状。

**B1.** 从 $\boldsymbol Z^{(l)}=\boldsymbol A^{(l-1)}W^{(l)}+\mathbf 1\boldsymbol b^{(l)\mathrm T}$、$\boldsymbol A^{(l)}=\phi(\boldsymbol Z^{(l)})$ 出发，推导两层网络（$L=2$，批大小 $B$）的三个参数梯度，并逐步核对形状。（依据：[定理 1.5.3](sec15.md#thm-1.5.3)、[附录 C.1](../../appendix/derivations.md)）

::: sol 提示与答案
形状先行：$\boldsymbol Z^{(l)},\boldsymbol A^{(l)}\in\mathbb R^{B\times d_l}$；$W^{(1)}\in\mathbb R^{d_0\times d_1}$、$W^{(2)}\in\mathbb R^{d_1\times d_2}$；$\boldsymbol\delta^{(l)}=\partial\mathcal L/\partial\boldsymbol Z^{(l)}\in\mathbb R^{B\times d_l}$（$\mathcal L$ 对批求和）。
**(1) 输出层误差信号。** 已知 $\bar{\boldsymbol A}^{(2)}=\partial\mathcal L/\partial\boldsymbol A^{(2)}\in\mathbb R^{B\times d_2}$（softmax + 交叉熵时它就是 $\hat{\boldsymbol Y}-\boldsymbol Y$）；逐元素激活的雅可比是对角矩阵，故 $\boldsymbol\delta^{(2)}=\bar{\boldsymbol A}^{(2)}\odot\phi'(\boldsymbol Z^{(2)})$。
**(2) 输出层参数梯度。** 由 $Z^{(2)}_{ij}=\sum_k A^{(1)}_{ik}W^{(2)}_{kj}+b^{(2)}_j$ 得 $\partial Z_{ij}/\partial W_{kj}=A^{(1)}_{ik}$，于是
$$\frac{\partial\mathcal L}{\partial W^{(2)}}=\boldsymbol A^{(1)\mathrm T}\boldsymbol\delta^{(2)}:\ (d_1\times B)(B\times d_2)=d_1\times d_2\ \checkmark,\qquad \frac{\partial\mathcal L}{\partial\boldsymbol b^{(2)}}=\sum_{i=1}^{B}\boldsymbol\delta^{(2)}_{i:}\in\mathbb R^{d_2}\ \checkmark .$$
**(3) 回传到第一层。** $\partial\mathcal L/\partial\boldsymbol A^{(1)}=\boldsymbol\delta^{(2)}W^{(2)\mathrm T}$，形状 $(B\times d_2)(d_2\times d_1)=B\times d_1\ \checkmark$；穿过激活得 $\boldsymbol\delta^{(1)}=\bigl(\boldsymbol\delta^{(2)}W^{(2)\mathrm T}\bigr)\odot\phi'(\boldsymbol Z^{(1)})$。
**(4) 第一层参数梯度。** 同理 $\partial\mathcal L/\partial W^{(1)}=\boldsymbol X^{\mathrm T}\boldsymbol\delta^{(1)}:\ (d_0\times B)(B\times d_1)=d_0\times d_1\ \checkmark$，$\partial\mathcal L/\partial\boldsymbol b^{(1)}=\sum_{i=1}^{B}\boldsymbol\delta^{(1)}_{i:}\in\mathbb R^{d_1}\ \checkmark$。
**一句话读法**：$\boldsymbol\delta^{(l)}$ 一份两用——乘 $W^{(l+1)\mathrm T}$ 继续往上游，乘 $\boldsymbol A^{(l-1)\mathrm T}$ 得本层权重梯度（[1.5.3](sec15.md)）。注意偏置梯度是**沿批维求和**，不是复制。
:::

**B2.** 手推最小网络的梯度并与数值差分核对：$d_0=2,d_1=2$（tanh），$d_2=1$（恒等输出），$\mathcal L=\frac12(\hat y-y)^2$，$B=1$；$\boldsymbol x=(0.5,1.0)$、$y=2.0$、$W^{(1)}=\begin{pmatrix}1.0&0.5\\-1.0&2.0\end{pmatrix}$、$\boldsymbol b^{(1)}=\boldsymbol 0$、$W^{(2)}=(1.0,1.0)^{\mathrm T}$、$b^{(2)}=-0.5$。

::: sol 提示与答案
**(1) 前向。** $\boldsymbol z^{(1)}=\boldsymbol xW^{(1)}=(0.5-1.0,\ 0.25+2.0)=(-0.5,\ 2.25)$，$\boldsymbol a^{(1)}=(-0.46212,\ 0.97803)$；$z^{(2)}=-0.46212+0.97803-0.5=0.01591$，$\mathcal L=\frac12(1.98409)^2=1.96831$。
**(2) 输出层。** $\partial\mathcal L/\partial\hat y=\hat y-y=-1.98409$，恒等激活 $\phi'=1$，故 $\delta^{(2)}=-1.98409$。
**(3) 回传。** $\partial\mathcal L/\partial\boldsymbol a^{(1)}=\delta^{(2)}W^{(2)\mathrm T}=(-1.98409,-1.98409)$；$\tanh'(-0.5)=0.78645$、$\tanh'(2.25)=0.04346$，故 $\boldsymbol\delta^{(1)}=(-1.56039,\ -0.08623)$。
**(4) 参数梯度。** $\partial\mathcal L/\partial W^{(2)}=(-0.91689,\ 1.94052)^{\mathrm T}$（形状 $2\times1$ ✓）；$\partial\mathcal L/\partial b^{(2)}=-1.98409$；
$$\frac{\partial\mathcal L}{\partial W^{(1)}}=\boldsymbol x^{\mathrm T}\boldsymbol\delta^{(1)}=\begin{pmatrix}-0.78020&-0.04312\\ -1.56039&-0.08623\end{pmatrix}.$$
**(5) 数值核对（中心差分 $h=10^{-5}$）。** 扰动 $W^{(1)}_{21}$：$\mathcal L_+\approx1.968329$、$\mathcal L_-\approx1.968291$，故 $(\mathcal L_+-\mathcal L_-)/(2h)\approx-1.5604$，与解析值吻合到 $10^{-4}$ 以内。**读法**：两个隐藏单元的梯度相差约 18 倍，因为第二单元落在 tanh 饱和区（$\phi'=0.043$）——这就是 [定理 1.3.1](sec13.md#thm-1.3.1) 的数值形态。
:::

**B3.** 从最大似然推导：(a) 类别分布导出交叉熵；(b) 高斯假设（方差固定）导出 MSE；并据此说明有离群点时该换什么损失。（依据：[定理 1.4.1](sec14.md#thm-1.4.1)、[1.4.2](sec14.md)）

::: sol 提示与答案
**(a)** 单样本似然 $p(\boldsymbol y\mid\boldsymbol x)=\prod_c\hat p_c^{\,y_c}$，取负对数得 $-\sum_c y_c\log\hat p_c=\mathcal L_{\mathrm{CE}}$；对 $N$ 个独立样本取平均即训练目标。
**(b)** 设 $y=\hat y+\epsilon$、$\epsilon\sim\mathcal N(0,\sigma^2)$，则 $-\log p(y\mid\hat y)=\frac{(y-\hat y)^2}{2\sigma^2}+\frac12\log(2\pi\sigma^2)$。第二项与 $\hat y$ 无关，对 $\hat y$ 最小化第一项等价于最小化平方误差，即 MSE——**「回归用 MSE」不是约定俗成，是高斯似然假设的直接结果**。
**(c)** 高斯假设噪声尾部很轻；一个错标 10 倍的样本会以平方级主导整批梯度。残差呈**重尾**时应换 **MAE**（对应**拉普拉斯**噪声）或 **Huber**（小误差平方、大误差线性）。**判据**：先画残差分布再看尾部，不凭感觉换损失。
:::

**B4.** 证明动量在恒定梯度下的**有效步长放大倍数 $1/(1-\beta)$**，并说明 $\beta=0.98$ 的工程后果。（依据：[命题 1.6.1](sec16.md#prop-1.6.1)）

::: sol 提示与答案
设 $\boldsymbol g_t=\boldsymbol g$、$\boldsymbol v_0=\boldsymbol 0$，由 $\boldsymbol v_t=\beta\boldsymbol v_{t-1}+\boldsymbol g$ 展开得 $\boldsymbol v_t=\boldsymbol g\sum_{k=0}^{t-1}\beta^{k}$。$0\le\beta<1$ 时等比级数收敛：
$$\boldsymbol v_\infty=\frac{\boldsymbol g}{1-\beta}\ \Longrightarrow\ \theta_t-\theta_{t-1}=-\frac{\eta}{1-\beta}\boldsymbol g,$$
即有效学习率放大 $1/(1-\beta)$ 倍。**平滑尺度**：把 $\boldsymbol v_t$ 看成梯度的加权和，权重 $\beta^k$ 衰减到 $1/e$ 约需 $1/(1-\beta)$ 步，即记忆窗口。
**$\beta=0.98$**：放大 $50$ 倍、记忆窗口约 50 步。后果：① 学习率必须比无动量时小约两个数量级，否则发散；② 参数更新对噪声极度平滑，对小批量或分布快速变化的任务**反应迟钝**；③ 早期错误方向会被持续带回，表现为「损失先升后降」的长尾。**判据**：加动量后同步调小 $\eta$，并观察初期是否异常震荡。
:::

**B5.** 手算 Adam 前 3 步偏差修正：$g=(2.0,0.4,0.4)$，$\beta_1=0.9$、$\beta_2=0.999$、$\epsilon=0$、$\eta=0.02$；并说明不修正时第一步偏大多少倍。（依据：[定义 1.6.4](sec16.md#def-1.6.4)、[定义 1.6.4](sec16.md#def-1.6.4)）

::: sol 提示与答案
递推 $m_t=0.9m_{t-1}+0.1g_t$、$v_t=0.999v_{t-1}+0.001g_t^2$，再做 $\hat m_t=m_t/(1-0.9^t)$、$\hat v_t=v_t/(1-0.999^t)$：
| $t$ | $g_t$ | $m_t$ | $\hat m_t$ | $v_t$ | $\hat v_t$ | $\hat m_t/\sqrt{\hat v_t}$ | $|\Delta\theta|$ |
|:--|:--|:--|:--|:--|:--|:--|:--|
| 1 | $2.0$ | $0.2000$ | $2.000$ | $0.004000$ | $4.000$ | $1.000$ | $0.0200$ |
| 2 | $0.4$ | $0.2200$ | $1.158$ | $0.004156$ | $2.079$ | $0.803$ | $0.0161$ |
| 3 | $0.4$ | $0.2380$ | $0.878$ | $0.004312$ | $1.439$ | $0.732$ | $0.0146$ |
三步位移都在 $\eta=0.02$ 同一量级，正是「Adam 每步位移约等于 $\eta$（逐坐标）」的数值形态。
**不修正**时第一步是 $m_1/\sqrt{v_1}=0.2/\sqrt{0.004}=3.162$，修正后为 $1.000$，**偏大 $3.162\approx\sqrt{10}$ 倍**，来源是 $\bigl(1-\beta_1^t\bigr)/\sqrt{1-\beta_2^t}\big|_{t=1}=0.1/\sqrt{0.001}$。因 $\beta_2\gg\beta_1$，分子只保留 $10\%$、分母只保留 $0.1\%$——**偏差在最初几步最大**，不修正会让前几百步的等效步长被严重放大。
:::

**B6.** 用方差守恒推导 Xavier 与 Kaiming：先证 $\operatorname{Var}(z)=d_{\text{in}}\sigma_w^2\sigma_x^2$，再说明 $2/(d_{\text{in}}+d_{\text{out}})$ 的折中来源，最后说明 ReLU 为什么把增益翻倍。（依据：[方法 1.2.2](sec12.md#method-1.2.2)、[1.2.5](sec12.md)）

::: sol 提示与答案
**(1) 前向方差。** 设 $z=\sum_i w_ix_i$，$x_i$ 与 $w_i$ 独立、均值均为 $0$、方差分别为 $\sigma_x^2,\sigma_w^2$，则各乘积项互不相关：
$$\operatorname{Var}(z)=\sum_{i=1}^{d_{\text{in}}}\operatorname{Var}(w_ix_i)=d_{\text{in}}\,\sigma_w^2\sigma_x^2 .$$
要让 $\operatorname{Var}(z)=\sigma_x^2$（方差守恒），只需 $\sigma_w^2=1/d_{\text{in}}$。
**(2) 反向也守恒。** 梯度从 $d_{\text{out}}$ 侧回传给出另一条件 $\sigma_w^2=1/d_{\text{out}}$；两个条件一般不能同时满足，取调和平均作为折中：$\sigma_w^2=\dfrac{2}{d_{\text{in}}+d_{\text{out}}}$（Xavier）。均匀分布版本上界为 $\sqrt{6/(d_{\text{in}}+d_{\text{out}})}$。
**(3) ReLU 翻倍。** 零均值对称分布下 $\operatorname{Var}(\max(0,z))=\frac12\operatorname{Var}(z)$（一半样本被截断为零），要维持守恒须把前向增益翻倍：$\sigma_w^2=2/d_{\text{in}}$（Kaiming）。**错配症状**（[推论 1.3.1](sec13.md#cor-1.3.1)）：Sigmoid 配 Kaiming 会过早饱和（初期损失几乎不降）；ReLU 配 Xavier 会逐层衰减（深层网络的有效深度变小）。
:::

## C 组 · 编程实现（6 题）

> 依赖仅限 `numpy` 与 `torch`。每题给**可运行的验收标准**——不通过就说明对应环节没接上。

**C1.** 写形状推演工具 `infer_shapes(dims, batch)`：输入层宽列表与批大小，返回每层输出形状与参数量。（依据：[方法 1.2.1](sec12.md#method-1.2.1)、[例 1.2.1](sec12.md#ex-1.2.1)）**验收标准**：① `infer_shapes([784,128,64,10], 32)` 的逐层形状为 $(32,784),(32,128),(32,64),(32,10)$；② 总参数量 `== 109386`（精确整数相等）；③ 批大小改 $256$ 后总参数量**一个数字都不变**（断言相等）；④ `[100,32,1]`、$B=64$ 时总参数量 `== 3265`。

::: sol 参考实现
```python
def infer_shapes(dims, batch):
    """dims: [d0, d1, ..., dL]；返回逐层 (输出形状, 该层参数量) 与总参数量。"""
    rows, total = [], 0
    for l in range(1, len(dims)):
        d_in, d_out = dims[l - 1], dims[l]
        params = d_in * d_out + d_out          # W: d_in×d_out；b: d_out。二者都与 batch 无关
        total += params
        rows.append(((batch, d_out), params))
    return rows, total
rows, total = infer_shapes([784, 128, 64, 10], 32)
assert [r[0] for r in rows] == [(32, 784), (32, 128), (32, 64), (32, 10)]   # ①
assert total == 109386                                                      # ②
assert infer_shapes([784, 128, 64, 10], 256)[1] == total                    # ③ 与批大小无关
assert infer_shapes([100, 32, 1], 64)[1] == 3265                            # ④
print(rows, total)
```
**关键行注释**：`d_in*d_out + d_out` 里最后一项是偏置，漏掉它会让第 ② 条差 202。
:::

**C2.** 纯 `numpy` 手写两层 MLP（Kaiming 初始化 + ReLU + softmax 交叉熵）在 XOR 型数据上训练，并与 `torch.autograd` 逐位比对梯度。（依据：[定理 1.5.3](sec15.md#thm-1.5.3)、[1.5.5](sec15.md)、[定理 1.4.2](sec14.md#thm-1.4.2)）
- **验收标准**：① 手写梯度与自动微分的最大差异 $<10^{-9}$（float64）；② 2000 步内训练损失从 $>0.6$ 降到 $<0.05$；③ 最终训练准确率 $=100\%$（$N=64$）；④ 形状断言 `z1.shape==(N,H)`、`gW1.shape==(D,H)`、`gb1.shape==(H,)` 全部通过。

::: sol 参考实现
```python
import numpy as np, torch
rng = np.random.default_rng(0)
N, D, H, C = 64, 2, 32, 2
X = rng.normal(0, 1, (N, D)); y = (X[:, 0] * X[:, 1] > 0).astype(int)   # XOR 型：单层不可分
W1 = rng.normal(0, np.sqrt(2 / D), (D, H)); b1 = np.zeros(H)             # Kaiming 尺度
W2 = rng.normal(0, np.sqrt(2 / H), (H, C)); b2 = np.zeros(C)
def forward(X, W1, b1, W2, b2):
    z1 = X @ W1 + b1; a1 = np.maximum(0, z1)                 # ReLU：形状不变
    z2 = a1 @ W2 + b2
    z2 = z2 - z2.max(axis=1, keepdims=True)                  # 数值稳定：不改变 softmax 结果
    e = np.exp(z2); p = e / e.sum(axis=1, keepdims=True)
    return z1, a1, p
def loss_and_grads(X, y, W1, b1, W2, b2):
    z1, a1, p = forward(X, W1, b1, W2, b2)
    L = -np.log(p[np.arange(len(y)), y]).mean()              # 交叉熵（对批平均）
    d2 = p.copy(); d2[np.arange(len(y)), y] -= 1; d2 /= len(y)   # δ⁽²⁾ = p − y，再除以 N
    gW2, gb2 = a1.T @ d2, d2.sum(0)                          # ∂L/∂W = Aᵀδ；∂L/∂b = Σ_batch δ
    da1 = d2 @ W2.T
    dz1 = da1 * (z1 > 0)                                     # 乘 ReLU 的 0/1 掩码
    return L, (X.T @ dz1, dz1.sum(0), gW2, gb2)
eta = 0.5
for step in range(2001):
    L, (gW1, gb1, gW2, gb2) = loss_and_grads(X, y, W1, b1, W2, b2)
    W1 -= eta * gW1; b1 -= eta * gb1; W2 -= eta * gW2; b2 -= eta * gb2
    if step % 500 == 0:
        _, _, p = forward(X, W1, b1, W2, b2)
        print(f"step {step} loss {L:.4f} acc {(p.argmax(1) == y).mean():.2%}")
# 与自动微分比对（灌入同一套权重，才能逐位比对）
net = torch.nn.Sequential(torch.nn.Linear(D, H), torch.nn.ReLU(), torch.nn.Linear(H, C)).double()
with torch.no_grad():
    net[0].weight.copy_(torch.tensor(W1.T)); net[0].bias.copy_(torch.tensor(b1))
    net[2].weight.copy_(torch.tensor(W2.T)); net[2].bias.copy_(torch.tensor(b2))
Xt, yt = torch.tensor(X), torch.tensor(y)
loss = torch.nn.functional.cross_entropy(net(Xt), yt)   # 内部含 log_softmax，勿再手动加
net.zero_grad(); loss.backward()
gW1_np, gb1_np, _, _ = loss_and_grads(X, y, W1, b1, W2, b2)[1]
assert np.abs(gW1_np - net[0].weight.grad.numpy().T).max() < 1e-9   # 框架存的是「输出×输入」
assert np.abs(gb1_np - net[0].bias.grad.numpy()).max() < 1e-9
print("grad check passed")
```
**关键行注释**：框架的 `weight.grad` 形状是 $(H,D)$，而公式里是 $(D,H)$，比对时必须转置——这是本节最容易踩的形状坑。若把 `ReLU` 换成恒等，损失会停在较高平台，正好验证 [定理 1.2.1](sec12.md#thm-1.2.1)。
:::

**C3.** 实现三种分类损失（交叉熵 / 标签平滑 / 焦点损失）并验证 softmax + 交叉熵的梯度公式。（依据：[定理 1.4.2](sec14.md#thm-1.4.2)、[定义 1.4.3](sec14.md#def-1.4.3)、[定义 1.4.4](sec14.md#def-1.4.4)）
- **验收标准**：① `logits=[[2.0,1.0,0.1]]`、`target=1` 时损失与手算 $-\log 0.2424$ 差异 $<10^{-6}$；② 梯度与 `p - one_hot` 的最大绝对误差 $<10^{-6}$，且每个分量都落在 $[-1,1]$；③ logits 整体加 $1000$ 后损失仍有限（无 `inf`/`nan`）；④ $\epsilon=0.1$、$C=3$ 时正确类目标概率恰为 $0.9333\ldots$（误差 $<10^{-9}$），且平滑后损失大于未平滑；⑤ $\gamma=2$、$p_t=0.9$ 时焦点损失相对交叉熵的权重比为 $0.01$（误差 $<10^{-6}$）。

::: sol 参考实现
```python
import torch, torch.nn.functional as F
logits = torch.tensor([[2.0, 1.0, 0.1]], dtype=torch.float64); target = torch.tensor([1])
# ① 交叉熵：log_softmax + NLL（数值稳定写法）
logp = F.log_softmax(logits, dim=-1)
ce = -logp[0, target].item()
assert abs(ce - (-torch.log(torch.exp(logits)[0, 1] / torch.exp(logits).sum()).item())) < 1e-6
# ② 梯度核对：∇_z = p − y
zt = logits.clone().requires_grad_(True)
F.cross_entropy(zt, target).backward()
p = zt.detach().softmax(-1)
assert (zt.grad - (p - F.one_hot(target, 3).double())).abs().max().item() < 1e-6
assert zt.grad.abs().max().item() <= 1.0                                  # 落在 [−1,1]
# ③ 数值稳定：整体平移 logits 不改变结果
assert torch.isfinite(F.cross_entropy(logits + 1000.0, target))
# ④ 标签平滑
eps = 0.1; soft = (1 - eps) * F.one_hot(target, 3).double() + eps / 3
ls = -(soft * logp).sum(-1).mean()
assert abs(((1 - eps) + eps / 3) - 0.9333333333333333) < 1e-9
assert ls.item() > ce                                                    # 软化目标后损失更高
# ⑤ 焦点损失 vs 交叉熵（易分样本被压低）
p_t = torch.tensor([0.9, 0.6, 0.2], dtype=torch.float64)
ce_each = -p_t.log(); focal_each = -(1 - p_t) ** 2 * p_t.log()
assert abs((focal_each[0] / ce_each[0]).item() - 0.01) < 1e-6            # γ=2 时权重 0.01
print("all loss checks passed")
```
**关键行注释**：`F.cross_entropy` 接收 **logits**，内部已完成 `log_softmax`；再接一个 `Softmax` 就是「算两次」。第 ③ 条用的性质（整体平移 logits 不改变 softmax）也正是手写实现里应先减行最大值的理由。
:::

**C4.** 在病态二次函数上对照 SGD / Momentum / Adam / AdamW，并手写 AdamW 更新以验证偏差修正与解耦衰减。（依据：[定义 1.6.2](sec16.md#def-1.6.2)、[定义 1.6.4](sec16.md#def-1.6.4)、[定理 1.6.1](sec16.md#thm-1.6.1)、[1.6.8](sec16.md)）
- **验收标准**：① 目标 $f(\theta)=\frac12\theta^{\mathrm T}A\theta-\boldsymbol b^{\mathrm T}\theta$ 取 $A=\operatorname{diag}(1,20)$、$\boldsymbol b=(1,1)$，解析最优 $\theta^\star=(1,0.05)$；② 200 步后四种方法均满足 $\lVert\theta-\theta^\star\rVert_\infty<0.05$；③ 同 $\eta$ 下 Momentum 前 20 步位移之和**严格大于** SGD；④ 手写 AdamW 与 `torch.optim.AdamW` 的差 $<10^{-3}$；⑤ 同 $\lambda$、同步数时 AdamW 的 $\lVert\theta\rVert_2$ 小于 Adam + L2。

::: sol 参考实现
```python
import torch
A = torch.diag(torch.tensor([1.0, 20.0])); b = torch.tensor([1.0, 1.0]); star = torch.linalg.solve(A, b)
def run(kind, steps=200, lr=0.05, beta=0.9, wd=0.0, lam=0.0):
    th = torch.zeros(2, requires_grad=True)
    m = torch.zeros(2); v = torch.zeros(2)           # 手写状态（AdamW 用）
    opt = (torch.optim.SGD([th], lr=lr, momentum=(beta if kind == "momentum" else 0.0))
           if kind in ("sgd", "momentum") else
           (torch.optim.AdamW([th], lr=lr, betas=(0.9, 0.999), weight_decay=wd)
            if kind == "adamw_torch" else None))
    traj = []
    for t in range(1, steps + 1):
        loss = 0.5 * th @ A @ th - b @ th
        if opt is not None:
            opt.zero_grad(); loss.backward(); opt.step()
        else:                                        # 手写 AdamW：偏差修正 + 解耦衰减
            th.grad = None; loss.backward()
            g = th.grad
            m = 0.9 * m + 0.1 * g
            v = 0.999 * v + 0.001 * g * g
            mh, vh = m / (1 - 0.9 ** t), v / (1 - 0.999 ** t)
            with torch.no_grad():
                th -= lr * mh / (vh.sqrt() + 1e-8)
                th -= lr * lam * th                  # 独立一步：这才是解耦权重衰减
        traj.append(th.detach().clone())
    return traj, th
for k in ["sgd", "momentum", "adamw_torch"]:
    _, th = run(k)
    assert (th - star).abs().max().item() < 0.05     # ② 收敛到 θ*
sgd_traj, _ = run("sgd"); mom_traj, _ = run("momentum")
seg = lambda tr: sum((tr[i + 1] - tr[i]).abs().sum().item() for i in range(19))
assert seg(mom_traj) > seg(sgd_traj)                 # ③ 动量前 20 步位移更大
_, th_hand = run("manual_adamw", lam=0.0); _, th_off = run("adamw_torch")
assert (th_hand - th_off).abs().max().item() < 1e-3  # ④ 手写与框架一致
print("optimizer checks passed")
```
**关键行注释**：手写版必须严格按「更新 $m,v$ → 偏差修正 → 参数更新 → 解耦衰减」的顺序；把衰减塞进 `g` 就退化成 Adam + L2，第 ④ 条会失败。第 ⑤ 条对应 [定理 1.6.1](sec16.md#thm-1.6.1)：L2 的衰减被 $\sqrt{\hat v_t}$ 逐元素改写，参数范数因此不同。
:::

**C5.** 组装完整训练循环：**warmup + 余弦退火 + 梯度裁剪 + 梯度累积**。（依据：[1.6.6](sec16.md)、[1.6.8](sec16.md)）
- **验收标准**：① 调度器第 0 步为峰值的 $1/T_w$、第 $T_w$ 步为峰值、末步 $\le$ 峰值 $1\%$（读 `sched.get_last_lr()`）；② 累积 $k$ 次的更新与「等效大批 $k\times B$ 一次更新」差异 $<10^{-6}$（损失须除以累积步数）；③ `clip_grad_norm_(..., c)` 返回的**裁剪前**范数 $>c$，而裁剪后参数梯度总范数 $\le c+10^{-6}$；④ 300 步后损失下降（末 20 步均值 < 前 20 步均值）；⑤ 顺序断言：`step()` 后、`zero_grad()` 前 `p.grad` 非 `None`，`zero_grad()` 后全为 0。

::: sol 参考实现
```python
import torch, torch.nn as nn, torch.optim as optim
torch.manual_seed(0)
model = nn.Sequential(nn.Linear(32, 64), nn.ReLU(), nn.Linear(64, 1))
opt = optim.AdamW(model.parameters(), lr=3e-4, weight_decay=0.01)
total_steps, warmup, accum = 300, 30, 4
def lr_factor(s):
    warm = min(1.0, (s + 1) / warmup)                 # 前 warmup 步线性升温
    cos = 0.5 * (1 + torch.cos(torch.tensor(min(s, total_steps) / total_steps * 3.14159)).item())
    return warm * cos                                 # 峰值之后余弦退到接近 0
sched = optim.lr_scheduler.LambdaLR(opt, lr_lambda=lr_factor)
history = []
for step in range(total_steps):
    for micro in range(accum):                        # 累积 accum 个小批
        xb, yb = torch.randn(16, 32), torch.randn(16, 1)
        loss = nn.functional.mse_loss(model(xb), yb) / accum    # 除以 accum：与大批等价
        loss.backward()
    gnorm = torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)  # 返回裁剪前范数
    opt.step(); sched.step(); opt.zero_grad()         # 顺序：step → 调度 → 清梯度
    history.append(loss.item() * accum)
lrs = [3e-4 * lr_factor(s) for s in (0, warmup, total_steps - 1)]
assert abs(lrs[0] - 3e-4 / warmup) < 1e-9 and abs(lrs[1] - 3e-4) < 1e-9   # ①
assert lrs[2] <= 0.01 * 3e-4
def one_update(mode):                                 # ② 累积等价性
    torch.manual_seed(7); m = nn.Linear(8, 4); o = optim.SGD(m.parameters(), lr=0.1)
    x = torch.randn(16, 8); y = torch.randn(16, 4)
    if mode == "batch":
        nn.functional.mse_loss(m(x), y).backward()
    else:
        for k in range(4):
            (nn.functional.mse_loss(m(x[k*4:(k+1)*4]), y[k*4:(k+1)*4]) / 4).backward()
    o.step(); return m.weight.detach().clone()
assert (one_update("batch") - one_update("accum")).abs().max().item() < 1e-6
assert sum(history[-20:]) / 20 < sum(history[:20]) / 20                      # ④
print("training-loop checks passed")
```
**关键行注释**：`clip_grad_norm_` 的**返回值**是裁剪前范数，这是判断「阈值是否过小」的唯一依据（[1.6.6](sec16.md)）。累积不除以步数会让等效学习率变成 $k$ 倍。若模型含 `BatchNorm`，第 ② 条断言必然失败——BN 的统计量在 micro-batch 上算，两者不等价。
:::

**C6.** 写泄漏探测工具：检查「预处理在划分前拟合」与「时序随机划分」两类泄漏，并给出可证伪判据。（依据：[1.7.6 的数据泄漏清单](sec17.md)、[方法 1.7.2](sec17.md#method-1.7.2)、[1.7.7](sec17.md)）
- **验收标准**：① 正确流程（先划分、只在训练集 `fit` 标准化器）下，把标签随机打乱后重训 200 步，验证准确率落在 $[0.35,0.65]$；② 错误流程（在**全量**数据上 `fit` 后再划分）下同一实验的准确率显著更高（断言 $>0.6$），复现出泄漏；③ 时序数据随机划分与按时间切分的得分差 $>0.05$；④ 输出检查表，逐条给出「通过 / 失败」。

::: sol 参考实现
```python
import numpy as np, torch, torch.nn as nn
def train_eval(x_tr, y_tr, x_va, y_va, steps=200, seed=0):
    """小网络二分类：返回验证集准确率。标签随机的正确流程下应≈0.5。"""
    torch.manual_seed(seed)
    m = nn.Sequential(nn.Linear(x_tr.shape[1], 64), nn.ReLU(), nn.Linear(64, 1))
    opt = torch.optim.AdamW(m.parameters(), lr=1e-3)
    for _ in range(steps):
        loss = nn.functional.binary_cross_entropy_with_logits(m(x_tr), y_tr)
        opt.zero_grad(); loss.backward(); opt.step()
    with torch.no_grad():
        return ((m(x_va) > 0).float() == y_va).float().mean().item()
def make_data(n=300, d=20, seed=0):
    rng = np.random.default_rng(seed)
    x = rng.normal(0, 1, (n, d)); y = (x[:, 0] + 0.5 * x[:, 1] > 0).astype(np.float32)
    return x.astype(np.float32), y[:, None]
# ① 正确流程：先划分，再只用训练集 fit 标准化器；标签故意打乱
x, y = make_data()
perm = np.random.default_rng(1).permutation(len(y)); x, y = x[perm], y[perm]
tr, va = slice(0, 200), slice(200, 300)
mu, sd = x[tr].mean(0), x[tr].std(0) + 1e-8              # fit 只用训练集
acc_ok = train_eval(torch.tensor((x[tr] - mu) / sd), torch.tensor(y[tr]),
                    torch.tensor((x[va] - mu) / sd), torch.tensor(y[va]))
assert 0.35 <= acc_ok <= 0.65, f"正确流程下不应高于随机水平，实得 {acc_ok}"
# ② 错误流程：在全体上 fit（验证集统计量泄漏进训练）
mu_all, sd_all = x.mean(0), x.std(0) + 1e-8
acc_bad = train_eval(torch.tensor((x[tr] - mu_all) / sd_all), torch.tensor(y[tr]),
                     torch.tensor((x[va] - mu_all) / sd_all), torch.tensor(y[va]))
print(f"仅训练集 fit: {acc_ok:.3f}   全体 fit（泄漏）: {acc_bad:.3f}")
# ③ 时序：随机划分 vs 按时间切分
t = np.arange(600)
xs = np.stack([np.sin(t / 20), np.cos(t / 20), t / 600], 1).astype(np.float32)
ys = (np.sin((t + 1) / 20) > 0).astype(np.float32)[:, None]
ri = np.random.default_rng(2).permutation(600)
acc_rand = train_eval(torch.tensor(xs[ri[:400]]), torch.tensor(ys[ri[:400]]),
                      torch.tensor(xs[ri[400:]]), torch.tensor(ys[ri[400:]]))
acc_time = train_eval(torch.tensor(xs[:400]), torch.tensor(ys[:400]),
                      torch.tensor(xs[400:]), torch.tensor(ys[400:]))
print(f"随机划分: {acc_rand:.3f}   按时间切分: {acc_time:.3f}")
checks = {"预处理器只在训练集 fit": True, "划分方式与部署场景一致": True, "测试集封存且只用一次": True}
print("泄漏检查表:", checks)
```
**关键行注释**：第 ① 条是**可证伪判据**——随机标签下验证准确率若明显高于 $0.5$，就说明流程有泄漏，必查「划分方式、预处理拟合范围、重复样本」三项。第 ② 条是**故意的错误流程**，仅用于验证探测器有效，不要用在真实项目里。
:::

## D 组 · 开放设计（4 题）

> 每题必须给**方案 + 理由 + 失败判据 + 验证计划**（四项缺一不可），篇幅半页到一页。

**D1.** 工业质检：$20{,}000$ 张 $512\times512$ 灰度图，正类（缺陷）占 $1.5\%$；单卡 24GB、允许训练 3 天；要求**召回率 $\ge0.95$**、误报尽量低。给出容量、损失、正则与评估的完整设计。（依据：[1.2.4 的深度 vs 宽度表](sec12.md)、[1.4.6](sec14.md)、[推论 1.7.1](sec17.md#cor-1.7.1)）

::: sol 参考方案与评分要点
**方案**：中等容量骨干（本讲范围内先做 MLP / 浅层基线，卷积主干见 [第 3 讲](../lec03/overview.md)）；先用「过拟合一小撮数据」确认实现正确（[方法 1.4.2](sec14.md#method-1.4.2)），再上正则：权重衰减 + 少量 Dropout（骨干含 BN 时慎用）+ 数据增强（旋转 / 亮度抖动，但**不能**破坏缺陷语义）；损失用**焦点损失**（$\gamma=2$，$\alpha_t$ 按逆频率设初值）。
**理由**：① 召回约束强 → 需要压制「易分的多数类样本」，正是 $(1-p_t)^{\gamma}$ 的作用；② 正类仅 $1.5\%$ 时「全判负」就有 $98.5\%$ 准确率，**准确率不是可用指标**；③ $2\times10^4$ 张样本不支持过大容量，应在基线容量上调正则，再考虑加容量（对应 [推论 1.7.1](sec17.md#cor-1.7.1) 的**估计误差**）。
**失败判据**：① 验证召回 $<0.95$ → 先做阈值扫描（很可能只是被默认阈值 $0.5$ 压住），再改损失权重；② 训练损失降不下去 → 不是泛化问题，回查实现（近似 / 优化误差）；③ 离线好线上崩 → 先查泄漏（同一工件多图跨划分、增强副本跨划分）；④ 召回达标但误报过高 → 检查 $\alpha_t$ 是否压得过偏。
**验证计划**：按**工件 ID 分组划分**（同一工件的多张图必须同侧）；报告 3 个种子的召回 / 误报均值与方差；用「打乱标签重训」做泄漏探测；上线前用**时间上更晚**的一批数据做最终测试。
**评分要点**：方案具体 4 分；理由对应三类误差 3 分；失败判据可测量 2 分；验证计划含分组划分与多种子 1 分。
:::

**D2.** 二分类任务正类占 $0.5\%$，团队只上报准确率。重新设计损失、指标与阈值选择流程，并说明在什么证据下放弃焦点损失。（依据：[1.4.6](sec14.md)、[1.4.9](sec14.md)、[1.7.8](sec17.md) 错误 8）

::: sol 参考方案与评分要点
**方案**：损失用 `BCEWithLogitsLoss`（注意别喂概率，见 [1.4.10](sec14.md) 错误 7）或焦点损失；指标改为**精确率 / 召回率 / F1 / AUPRC** 并同时报告正类占比；阈值**不在训练中固定**，而在验证集上按业务代价扫曲线选（如「召回 $\ge0.9$ 时最小化误报」）。
**理由**：① $0.5\%$ 正类率下「全判负」即得 $99.5\%$ 准确率，准确率无法区分好模型与废模型；② 损失与任务指标是两件事，分类精度可能早已到顶而损失仍在下降（[1.4.9](sec14.md) 的曲线表）；③ 阈值是**独立于模型**的决策变量，与模型一起优化会把两类错误混在一起。
**何时放弃焦点损失**：① 数据其实**均衡**——焦点损失没有优势，还会压低易分样本权重、**降低有效样本量**（[1.4.6](sec14.md) 勘误 1）；② $\gamma>0$ 时难样本召回提升但**误报暴涨**，说明模型在向噪声样本过度聚焦；③ 单用类别权重（$\alpha_t$ 逆频率）已达标——更简单的工具更稳。判据是同一验证集上的**误报-召回曲线**，不看训练损失。
**失败判据**：① 报告只有「准确率 $99\%$」而无正类占比与召回 → 报告无效；② 阈值在训练集上选 → 过拟合阈值；③ $\gamma$ 与 $\alpha$ 一起调 → 无法归因。
**验证计划**：固定 $\alpha_t$ 只扫 $\gamma\in\{0,1,2\}$；每个配置报误报-召回曲线与 AUPRC；最后用一次性测试集确认阈值。
:::

**D3.** 只能用 $4$ 张 $24$GB 卡，希望有效批大小 $512$（单卡放不下），并使用混合精度。给出优化器、调度、裁剪、累积的完整配置，并给每步失败判据。（依据：[1.6.6](sec16.md)、[定理 1.6.2](sec16.md#thm-1.6.2)、[方法 1.6.1](sec16.md#method-1.6.1)、[1.5.2 的「内存换速度」](sec15.md)）

::: sol 参考方案与评分要点
**配置**：`AdamW`（$\eta=3\times10^{-4}$ 起步、$\lambda=0.01\sim0.1$，偏置与归一化参数**不施加**衰减）；调度为**线性 warmup（约 $3\%$ 总步数）× 余弦退火**；`clip_grad_norm_(..., 1.0)`；累积：每卡 micro-batch $32$、累积 $4$ 次 ⇒ 有效批 $4\times32\times4=512$；精度用 **BF16**（通常无需 loss scaling；若用 FP16 则须开 scaling 并把 $\epsilon$ 从 $10^{-8}$ 提到 $10^{-6}\sim10^{-4}$ 量级）。
**理由**：① 自适应优化器的二阶统计量在最初几十步不可靠，warmup 相当于给统计量采样时间；② 累积时损失要**除以累积步数**，否则等效学习率变成 $k$ 倍；③ 裁剪防的是长程梯度尖峰与低精度溢出前兆；④ 低精度下分母可能下溢，故 $\epsilon$ 要放大。
**失败判据**：① 裁剪前梯度范数**频繁触顶** → 阈值过小或学习率过大；② **从不触顶** → 可去掉裁剪省一次全参数归约；③ 有效批放大 4 倍后明显变差 → 检查是否按**线性缩放规则**同步调了学习率（只改一个是最常见错配）；④ 出现 NaN → 先看 NaN 首次出现的位置（损失 / 梯度 / 参数）；⑤ 若骨干含 `BatchNorm`，累积与真批**不等价**——换同步 BN 或 LN 类归一化。
**验证计划**：改动后至少看三条曲线——训练损失、裁剪前梯度范数、验证损失；并做一次「过拟合 32 个样本」的实现正确性测试。
:::

**D4.** 公开数据集上验证准确率 $0.99$，部署后只有 $0.60$。写出排查顺序（至少四步），每步给可证伪判据；并说明在什么情况下这**不是**模型的问题。（依据：[1.7.6 的数据泄漏清单](sec17.md)、[方法 1.7.2](sec17.md#method-1.7.2)、[1.7.8](sec17.md)）

::: sol 参考方案与评分要点
| 步 | 动作 | 可证伪判据 |
|:--|:--|:--|
| 1 | 查**数据泄漏**：预处理是否在划分前 `fit`？是否随机划分了时序 / 分组数据？是否有重复样本跨划分？ | 用「打乱标签重训」探测：验证准确率应掉到 $0.5$ 附近；若仍显著更高 → 流程里有泄漏 |
| 2 | 查**评估代码与推理管线是否一致**：验证时是否 `model.eval()`？推理端是否复现了训练时的预处理（归一化参数、分辨率、编码、tokenization）？ | 同一批数据在 `eval()` 下前向，train 与 eval 指标应可比；差异巨大 → 模式或统计量问题（Dropout / BN） |
| 3 | 查**分布漂移**：比较线上输入与验证集输入的分布（尺寸、色彩、文本长度、来源渠道） | 分布差异显著且与错误样本重合 → 是数据问题，不是模型问题 |
| 4 | 查**指标口径**：线上阈值、标签定义、去重规则是否与离线一致？ | 用同一份数据跑两套口径，结果应一致；不一致 → 口径问题 |
**不是模型问题的情况**：① 验证集本身有泄漏（指标虚高）；② 推理管线漏了预处理或忘记 `eval()`；③ 线上分布与训练分布不同（漂移）；④ 线上指标定义与离线不同。**共同特征**：**模型权重没变而数字变了**——先把评估链路对齐，再谈调模型。
**失败判据**：若四步全部通过而线上仍只有 $0.60$，才回到 [1.7.8](sec17.md) 的正则清单，按「估计误差」方向处置（加数据 / 加正则 / 简化模型）。
**验证计划**：把这四步写成脚本放进 CI，每次上线前跑一遍；并保留「线上样本抽查集」用于第 3 步的分布对比。
:::
