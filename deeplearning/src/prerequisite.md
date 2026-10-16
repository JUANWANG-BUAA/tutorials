# 先修工具箱：数学、张量与自动微分

这一页只装**这本书真正会用到的**数学与工程前置知识，按「哪里缺补哪里」的方式组织。**不需要通读**——遇到卡壳时回来查，每个条目都指向它在正文里的用处。

::: note 三条使用建议
1. **先做[入学诊断](entry-test.md)**：得分决定你要不要完整读这一页。
2. **公式不背，要看懂**：所有公式后面都写了「它在第几讲用」，读那一段比背公式有用。
3. **动手验一遍**：每个小节末尾有 1–2 道两分钟小练习，做完再走。
:::

## 一、线性代数：一切张量运算的语法

| 概念 | 记法与要点 | 用在哪 |
|:--|:--|:--|
| 向量与矩阵 | $\boldsymbol x\in\mathbb R^n$（列向量）、$A\in\mathbb R^{m\times n}$ | 全书 |
| 矩阵乘 | $(AB)_{ij}=\sum_k A_{ik}B_{kj}$；形状规则：$(m\times n)(n\times p)=(m\times p)$ | [1.1](lectures/lec01/sec11.md) 前向传播 |
| 转置 | $(AB)^{\mathrm T}=B^{\mathrm T}A^{\mathrm T}$——**顺序反转**，这是反传公式里转置出现的原因 | [1.5](lectures/lec01/sec15.md) |
| 逐元素乘 | $\odot$（Hadamard 积）；反传里 $\boldsymbol\delta\odot\phi'(\boldsymbol z)$ 就是它 | [1.5](lectures/lec01/sec15.md) |
| 范数 | $\lVert\boldsymbol x\rVert_2=\sqrt{\sum x_i^2}$；矩阵范数见[数值分析教程](../../numerical/book/index.html) 1.3 节 | 正则化、梯度裁剪 |
| 内积与相似度 | $\boldsymbol x\cdot\boldsymbol y=\boldsymbol x^{\mathrm T}\boldsymbol y$；cos 相似度 = 归一化内积 | [2.4](lectures/lec02/sec24.md) 注意力的 $QK^{\mathrm T}$ |
| 特征值/特征向量 | $A\boldsymbol v=\lambda\boldsymbol v$；对称矩阵可正交对角化 | 谱半径→梯度稳定性（[2.2](lectures/lec02/sec22.md)） |
| 奇异值分解 | $A=U\Sigma V^{\mathrm T}$；$\sigma_i$ 度量各方向的伸缩 | 低秩视角（LoRA 的动机，[9.5](lectures/lec09/sec95.md)） |

**两分钟练习**：$A\in\mathbb R^{3\times4}$、$B\in\mathbb R^{4\times2}$、$\boldsymbol x\in\mathbb R^{4}$——$AB$、$A\boldsymbol x$、$\boldsymbol x^{\mathrm T}B$ 里哪些能算、形状各是什么？（答案：$AB\to3\times2$；$A\boldsymbol x\to3$；$\boldsymbol x^{\mathrm T}B\to2$。）

## 二、微积分与优化：梯度从哪来

| 概念 | 要点 | 用在哪 |
|:--|:--|:--|
| 偏导与梯度 | $\nabla_{\boldsymbol x}f=\bigl(\partial f/\partial x_1,\dots\bigr)$；指向增长最快方向 | [1.5](lectures/lec01/sec15.md) |
| 链式法则 | $\dfrac{d}{dx}f(g(x))=f'(g(x))g'(x)$——**反向传播的全部数学** | [1.5](lectures/lec01/sec15.md) |
| 雅可比 | $J_{ij}=\partial y_i/\partial x_j$：向量函数的「导数矩阵」 | [2.2](lectures/lec02/sec22.md) BPTT |
| 向量-雅可比积（VJP） | 反向模式一次得到一个 VJP（$J^{\mathrm T}\boldsymbol v$），所以反传代价与输出维度无关而与参数维度相关 | [1.5](lectures/lec01/sec15.md) |
| 凸性 | 凸函数局部极小即全局极小；深度学习目标通常**非凸** | [1.6](lectures/lec01/sec16.md) |
| 拉格朗日乘子 | 约束优化的标准工具 | [附录 C.13](appendix/derivations.md) DPO 推导 |
| 中心差分 | $f'(x)\approx\frac{f(x+h)-f(x-h)}{2h}$，用于梯度检查 | [附录 C.2](appendix/derivations.md) |

**两分钟练习**：$f(\boldsymbol x)=\lVert A\boldsymbol x-\boldsymbol b\rVert^2$，求 $\nabla_{\boldsymbol x}f$。（答案：$2A^{\mathrm T}(A\boldsymbol x-\boldsymbol b)$。）

## 三、概率：损失函数的来源

| 概念 | 要点 | 用在哪 |
|:--|:--|:--|
| 期望与方差 | $\mathbb E[X]$、$\mathrm{Var}(X)=\mathbb E[X^2]-\mathbb E[X]^2$ | 批大小与梯度噪声（[1.6](lectures/lec01/sec16.md)） |
| 常见分布 | 伯努利/类别（分类）、高斯（回归与扩散）、均匀（初始化） | [1.4](lectures/lec01/sec14.md)、[4.5](lectures/lec04/sec45.md) |
| 条件概率与贝叶斯 | $p(z\mid x)=p(x\mid z)p(z)/p(x)$ | [4.3](lectures/lec04/sec43.md) 后验 |
| 最大似然 | 最小化负对数似然 = 最大化似然；**它决定损失函数的形式** | [1.4](lectures/lec01/sec14.md) |
| 交叉熵与 KL | $\mathrm{KL}(p\|q)=\sum p\log\frac pq$；交叉熵 = 熵 + KL | [1.4](lectures/lec01/sec14.md)、[4.3](lectures/lec04/sec43.md) |
| 重参数化 | 从 $\mathcal N(\mu,\sigma^2)$ 采样写作 $\mu+\sigma\varepsilon$，$\varepsilon\sim\mathcal N(0,1)$ | [4.3](lectures/lec04/sec43.md) |
| 重要性采样 | $\mathbb E_p[f]=\mathbb E_q[f\,p/q]$；ELBO 就是它的应用 | [附录 C.6](appendix/derivations.md) |

**两分钟练习**：$X$ 服从 $\mathcal N(0,1)$，求 $\mathbb E[X^2]$。（答案：$1$——方差定义即得；这个结论在注意力的 $\sqrt{d_k}$ 论证里直接用到了。）

## 四、张量与形状：排错的第一技能

本书统一采用 **「批优先」（batch-first）** 约定：张量第 0 维永远是批维，且**前向过程中批维不变**。

| 记号 | 含义 | 典型出现 |
|:--|:--|:--|
| $B\times n$ | 一批特征向量 | 表格数据、[1.1](lectures/lec01/sec11.md) |
| $B\times T\times d$ | 批 × 序列长 × 模型维 | 序列、[2.5](lectures/lec02/sec25.md) |
| $B\times C\times H\times W$ | 批 × 通道 × 高 × 宽 | 图像、[3.2](lectures/lec03/sec32.md) |
| $B\times H\times T\times T$ | 注意力权重矩阵 | [2.4](lectures/lec02/sec24.md) |

**广播（broadcasting）**：从**右侧**对齐形状，逐维比较：相等或其中一个为 1 才可广播，否则报错。

```python
(32, 10) + (10,)      # OK：后者被当作 (1, 10) 广播到 (32, 10)
(32, 1)  + (32,)      # ⚠️ 得到 (32, 32)：容易静默出错
(32, 10) + (32,)      # ❌ 报错
```

**两分钟练习**：$\boldsymbol X\in\mathbb R^{32\times784}$、$W\in\mathbb R^{784\times128}$、$\boldsymbol b\in\mathbb R^{128}$——$\boldsymbol XW+\boldsymbol b$ 的形状？（答案：$32\times128$；偏置按最后一维广播。）

## 五、自动微分：为什么梯度能「一次算完」

**计算图**：把前向写成有向无环图（每个节点是一个算子），反向就在图上按拓扑逆序做链式法则。

| 模式 | 一次传递得到 | 何时用 |
|:--|:--|:--|
| **前向模式** | 一个输入方向的 $\partial\text{输出}/\partial x_j$ | 输入少、输出多 |
| **反向模式**（深度学习默认） | 一个输出方向的 $\nabla_\theta f$（全部参数的梯度） | 参数极多、输出是标量（损失） |

**核心结论**：深度学习「参数百万到千亿、输出是一个标量损失」，因此**反向模式是唯一可行的选择**；一次前向 + 一次反向即可拿到全部梯度（代价 ≈ 2–3 倍前向）。

**为什么还要懂它**：① 理解 `detach()`、`no_grad()`、`requires_grad` 的语义；② 理解为什么有些操作（如采样）必须重参数化才能传梯度（[4.3](lectures/lec04/sec43.md)）；③ 理解激活重计算为什么能省显存（[9.5](lectures/lec09/sec95.md)）。

```python
import torch
x = torch.tensor(2.0, requires_grad=True)
y = x**3 + 2*x          # 前向：构建计算图
y.backward()            # 反向：沿图做链式法则
print(x.grad)           # dy/dx = 3x² + 2 = 14（x=2）
```

**两分钟练习**：把上式改成 `y = (x**3 + 2*x).detach()`，`x.grad` 会怎样？（答案：`backward()` 会报错——图被切断，没有可求导的路径。）

## 六、一张速查表：从数学到代码

| 数学写法 | PyTorch 写法 | 备注 |
|:--|:--|:--|
| $\boldsymbol XW+\boldsymbol b$ | `x @ w + b` | `@` 是矩阵乘，`*` 是逐元素 |
| $\mathrm{softmax}(\boldsymbol z)$ | `F.softmax(z, dim=-1)` | **必须指定维度**（常错点） |
| $\odot$ | `a * b` | 逐元素 |
| $\sum_i$（沿某轴） | `x.sum(dim=...)` | 想清「对哪一维求和」 |
| $\lVert\boldsymbol x\rVert_2^2$ | `(x**2).sum()` | 梯度裁剪用 `clip_grad_norm_` |
| $\nabla_\theta\mathcal L$ | `loss.backward()` 后 `p.grad` | 记得 `optimizer.zero_grad()` |
| 批维不变 | `x.shape[0]` 恒为 $B$ | 排错第一检查项 |

::: errata 初学者最常卡的六处
1. **`dim` 写错**：`softmax`/`mean`/`sum` 不写 `dim` 会沿所有维度计算，结果往往形状不对且**不报错**。
2. **视图与转置混用**：`transpose`/`permute` 后张量**不再连续**，直接 `view` 会报错或产生错误结果（用 `reshape` 或先 `contiguous()`）。
3. **忘记清零梯度**：PyTorch 默认**累积**梯度；不清零会让更新量越滚越大。
4. **训练/推理模式未切换**：`model.eval()` 影响 Dropout 与 BatchNorm 的行为；评估时不切换会得到错误的指标。
5. **在 `no_grad` 里做本该训练的事**：评估时用 `torch.no_grad()` 省显存，但训练里误用会导致梯度为 `None`。
6. **把张量当标量**：`if loss > 0.5` 在 0 维张量上可用，但 `if tensor_with_many_elements` 会报错——用 `.item()`。
:::

## 七、五分钟自测（做完即可开始第 1 讲）

1. $A\in\mathbb R^{5\times3}$、$B\in\mathbb R^{3\times7}$，$AB$ 的形状？$B^{\mathrm T}A^{\mathrm T}$ 呢？
2. $f(x)=\log(1+e^{x})$，求 $f'(x)$。
3. 一句话说明「反向模式自动微分」为什么适合深度学习。
4. $\boldsymbol X\in\mathbb R^{B\times T\times d}$ 过 `Linear(d, 4d)` 后形状？参数量（含偏置）？
5. 写出交叉熵的定义，并说明它和「最大似然」的关系。
6. 为什么 `softmax` 要指定 `dim`？

::: sol 自测答案
1. 均为 $5\times7$。
2. $f'(x)=\dfrac{e^{x}}{1+e^{x}}=\sigma(x)$（Sigmoid 的导数形式，正是它在网络里好用的原因）。
3. 参数极多而损失是标量：一次反向传播即可得到**全部**参数的梯度，代价与参数量成正比（前向模式的代价与输入维度成正比，无法承受）。
4. 形状 $B\times T\times4d$；参数量 $d\times4d+4d=4d^2+4d$。
5. $\mathcal L=-\sum_c y_c\log\hat y_c$；它等于负对数似然（离散情形），因此最小化交叉熵 = 最大似然估计。
6. 因为 softmax 是「对哪一维做归一化」的选择：序列 logits 的最后一维才是类别/词表维，写错维度会得到错误分布且**不一定报错**。
:::

**下一步**：从[第 1 讲导览](lectures/lec01/overview.md)开始。如果你更想先动手，先读[工程工具箱](toolbox.md)第一节把环境搭好，再回来读第 1 讲。
