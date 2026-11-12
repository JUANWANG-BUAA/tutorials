# 第 4 章学习目标自检表

## K · 知识

| 编号 | 目标 | 自检标准 | ✓ |
|:--|:--|:--|:--|
| K4.1 | 写出压缩映射不动点定理 | 自映射 + $\lVert\varphi'\rVert\le L<1$ ⟹ 存在唯一解且任意初值收敛 | ☐ |
| K4.2 | 写出 Newton 法 | $x_{k+1}=x_k-\dfrac{f(x_k)}{f'(x_k)}$ | ☐ |
| K4.3 | 说明 Newton 至少二阶 | 在 $C^2$ 单根邻域用 Taylor 证明误差平方界；不能从单根推出 $f''(s)\ne0$ | ☐ |
| K4.4 | 说明重根掉阶 | $m$ 重根时 $\varphi'(s)=1-\dfrac1m$，阶降为 1 | ☐ |
| K4.5 | 写出割线法 | $x_{k+1}=x_k-\dfrac{f(x_k)(x_k-x_{k-1})}{f(x_k)-f(x_{k-1})}$，阶 1.618 | ☐ |
| K4.6 | 写出 Newton 全局收敛四条件 | 端点异号、$f''$ 不变号、$f'\ne0$、$x_0\in[a,b]$ 且 $f(x_0)f''(x_0)>0$ | ☐ |
| K4.7 | 写出非线性方程组的 Newton 法 | $J(\boldsymbol x^{(k)})\Delta\boldsymbol x=-F(\boldsymbol x^{(k)})$，$\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta\boldsymbol x$；$J$ 非奇异且初值足够近时平方收敛 | ☐ |

## S · 技能

| 编号 | 目标 | 自检标准 | ✓ |
|:--|:--|:--|:--|
| S4.1 | 验证迭代收敛 | 给 $\varphi$ 与区间，能验证自映射与压缩并给误差估计 | ☐ |
| S4.2 | 手推一次 Newton | 给例子能算 3 步并说明误差为何平方下降 | ☐ |
| S4.3 | 选初值 | 能验证自映射与压缩，或 Newton 的区间四条件，再用误差界选停止阈值 | ☐ |
| S4.4 | 判重根 | 能用 $f(x)=0,\ f'(x)=0$ 判别并给出修正 Newton 公式 | ☐ |
| S4.5 | 设计迭代函数 | 给一个方程，能设计两个不同 $\varphi$ 并比较收敛速度 | ☐ |
| S4.6 | 做一步方程组 Newton | 给 $2\times2$ 方程组，能写出 Jacobi 矩阵并算一步 Newton 修正 | ☐ |

## A · 态度

| 编号 | 目标 | 自检标准 | ✓ |
|:--|:--|:--|:--|
| A4.1 | 先验估计优先 | 报告解之前先给初值与误差界，而不是只报结果 | ☐ |
| A4.2 | 警惕「迭代不收敛＝无解」 | 区分「迭代发散」与「方程无解」 | ☐ |
| A4.3 | 方程组用范数判收敛 | 标量看 $\lvert x_k-s\rvert$，方程组看 $\lVert\boldsymbol x^{(k)}-\boldsymbol s\rVert$；不要逐分量各说各话 | ☐ |

## 用具体任务自检

表中“会”应当对应一份可复核的作答：先遮住答案独立完成，再按结果回查。

| 自检任务 | 达标证据 | 练习落点 |
|:--|:--|:--|
| 给一个正例与一个反例验证自映射 | 不仅检查端点，还说明如何控制整个像区间 | [对数迭代训练](mock-exam.md#extra-log-contraction) |
| 验证二阶而非只看小数位数 | 写出误差恒等式，使用未提前舍入的误差比 | [开方训练](mock-exam.md#extra-sqrt-five-order) |
| 在四种符号组合中选初值 | 每行由 $f(x_0)f''(x_0)>0$ 推出，并指出不适用的区间 | [四幅图回忆卡](recall-cards.md#recall-newton-four-cases)、[端点训练](mock-exam.md#extra-newton-interval) |
| 比较算法的真实成本 | 统一更新次数和停止准则，计入初值求值、缓存与最终验收 | [函数调用训练](mock-exam.md#extra-root-cost) |
| 独立完成两条证明链 | 存在、唯一、误差界分别给依据；Newton 写清局部邻域 | [证明回忆卡](recall-cards.md#recall-root-proof-chain) |
