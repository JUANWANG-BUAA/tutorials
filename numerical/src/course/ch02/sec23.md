# 2.3 条件数与病态线性方程组

> 对应教材 2.3.1–2.3.2、定理 2.6、例 4–5、习题 9–12；对应老师第 3 讲 §一（点到）。
> 本节回答：**数据有微小扰动时，解会坏多少？** 答案由条件数 $\mathrm{cond}(A)$ 决定。

<a id="sec-2.3.1"></a>
## 2.3.1 条件数与扰动界

::: def 定义 2.3.1 · 矩阵条件数 {#def-2.3.1}
对非奇异矩阵 $A$，称
$$
\mathrm{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert
$$
为 $A$ 的条件数。常用 $\mathrm{cond}_1,\mathrm{cond}_\infty,\mathrm{cond}_2$；其中
$$
\mathrm{cond}_2(A)=\frac{\sigma_{\max}(A)}{\sigma_{\min}(A)}
=\sqrt{\frac{\lambda_{\max}(A^{\mathrm T}A)}{\lambda_{\min}(A^{\mathrm T}A)}}.
$$
:::

**性质**：$\mathrm{cond}(A)\ge1$；$\mathrm{cond}(kA)=\mathrm{cond}(A)\ (k\ne0)$；正交矩阵 $\mathrm{cond}_2(Q)=1$；实对称非奇异矩阵 $\mathrm{cond}_2(A)=\max_i|\lambda_i|/\min_i|\lambda_i|$。这里要先取绝对值再取极值；只有正定时才能直接写成代数最大、最小特征值之比。例如 $\operatorname{diag}(-10,1)$ 的条件数为 $10$，不是 $|1|/|-10|=0.1$。

::: note 算 $\mathrm{cond}_1$、$\mathrm{cond}_\infty$ 的快捷路径（老师第 3 讲 §一）
条件数的定义只用范数与逆，手算的瓶颈在范数。第 3 讲 §一完整推得两条公式（推导见 [1.3.4](../../ch01/sec13.md#sec-1.3.4)）：

- $\lVert A\rVert_1=\max_j\sum_i\lvert a_{ij}\rvert$——**最大列和**；
- $\lVert A\rVert_\infty=\max_i\sum_j\lvert a_{ij}\rvert$——**最大行和**。

于是 $\mathrm{cond}_1(A)=\lVert A\rVert_1\lVert A^{-1}\rVert_1$ 就是“$A$ 的最大列和 × $A^{-1}$ 的最大列和”，$\mathrm{cond}_\infty$ 同理换成最大行和——会算两个行和/列和，就会算这两个条件数，不必碰奇异值。
:::

::: thm 定理 2.6 · 扰动界 {#thm-2.6}
设 $A$ 非奇异，$\boldsymbol x$ 是 $A\boldsymbol x=\boldsymbol b$ 的解，$\boldsymbol b\ne0$。若 $\mathrm{cond}(A)\rho_A=\lVert A^{-1}\rVert\lVert\Delta A\rVert\lt1$，则 $A+\Delta A$ 非奇异，且
$$
\frac{\lVert\Delta\boldsymbol x\rVert}{\lVert\boldsymbol x\rVert}
\le
\frac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}
\left(\rho_A+\rho_b\right),
\qquad
\rho_A=\frac{\lVert\Delta A\rVert}{\lVert A\rVert},\quad
\rho_b=\frac{\lVert\Delta\boldsymbol b\rVert}{\lVert\boldsymbol b\rVert}.
$$
:::

::: proof 证明
由 $(A+\Delta A)(\boldsymbol x+\Delta\boldsymbol x)=\boldsymbol b+\Delta\boldsymbol b$ 减去 $A\boldsymbol x=\boldsymbol b$，得
$$
\Delta\boldsymbol x=A^{-1}\Delta\boldsymbol b-A^{-1}\Delta A\,\boldsymbol x-A^{-1}\Delta A\,\Delta\boldsymbol x.
$$
取范数，把最后一项移到左边，用 $\lVert\boldsymbol b\rVert\le\lVert A\rVert\lVert\boldsymbol x\rVert$ 放缩，即得。$\blacksquare$
:::

::: note 读法 · 条件数把「输入扰动」放大成「输出扰动」的上界
$\mathrm{cond}(A)$ 大，问题病态；此时**换算法救不了**，只能换提法（换基、正则化、提高精度）。这与 [1.2.6](../../ch01/sec12.md#sec-1.2.6) 的四象限表一致：病态是**问题**的属性，不稳定才是**算法**的属性——本节管前者。
:::

::: ex 例 4（教材 2.3.1） · 右端微小扰动引起解的巨大变化 {#ex-2.3-textbook4}
教材用
$$
A=\begin{pmatrix}1&1\\1&1.0001\end{pmatrix}
$$
展示右端微小扰动引起解的巨大变化；其 $\mathrm{cond}_\infty(A)\approx4.0\times10^4$，右端 $0.005\%$ 的扰动可带来约 $50\%$ 的解误差。

条件数验算（编者按定义核算）：$\det A=10^{-4}$，$A^{-1}=10^4\begin{pmatrix}1.0001&-1\\-1&1\end{pmatrix}$；$\lVert A\rVert_\infty=2.0001$、$\lVert A^{-1}\rVert_\infty=2.0001\times10^4$（最大行和），故 $\mathrm{cond}_\infty(A)=(2.0001)^2\times10^4\approx4.0\times10^4$。两行几乎成比例，正是条件数爆表的几何原因。
:::

::: ex 例 5（教材 2.3.1–2.3.2） · 先均衡化，再谈病态 {#ex-2.3-textbook5}
系数矩阵元素数量级悬殊时，先做**行均衡化**（每行除以该行最大元素）再算条件数/求解；否则“病态”可能只是量纲造成的假象。
:::

<a id="sec-2.3.2"></a>
## 2.3.2 病态方程组的处置

::: method 病态方程组的四条处置办法（教材 2.3.2）
1. **提高精度**：双精度/多精度能减轻舍入，但不能改变条件数；条件数很大并不意味着方程无解；例如 $A=\operatorname{diag}(1,10^{-20})$、$\boldsymbol b=(1,10^{-20})^{\mathrm T}$ 仍有唯一解 $(1,1)^{\mathrm T}$。是否能算准取决于输入误差、工作精度与算法，不能只按条件数断言“无解”。
2. **行（列）均衡化**：把每行/列缩放到同一量级，降低人为病态。
3. **残差校正（迭代精化）**：用当前解算残差 $\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$，解 $A\Delta\boldsymbol x=\boldsymbol r$，令 $\hat{\boldsymbol x}\leftarrow\hat{\boldsymbol x}+\Delta\boldsymbol x$；在条件数不太大且残差计算足够精确时有效。
4. **换提法**：正则化（Tikhonov）、换基（如插值从范德蒙德基换到拉格朗日基）、增广方程等。
:::

**关键区分**：残差小 $\ne$ 误差小。$\boldsymbol e=A^{-1}\boldsymbol r$，所以
$$
\frac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}
\le \mathrm{cond}(A)\frac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}.
$$
条件数大时，残差可以很小而误差仍然很大。停机判据只能保证“残差小”，不能保证“解准”。

::: ex 例 2.3.1 · 同一残差，误差可以相差一万倍 {#ex-2.3.1}

先把误差界里的每个量落到可计算的数上。取

$$A=\begin{pmatrix}1&0\\0&10^{-4}\end{pmatrix},\qquad \boldsymbol b=\begin{pmatrix}1\\10^{-4}\end{pmatrix},\qquad \boldsymbol x^*=\begin{pmatrix}1\\1\end{pmatrix}.$$

在 $\infty$-范数下，$\|A\|_\infty=1$、$\|A^{-1}\|_\infty=10^4$，所以 $\mathrm{cond}_\infty(A)=10^4$。比较两个候选解：

| 候选解 | $\boldsymbol r=\boldsymbol b-A\widetilde{\boldsymbol x}$ | 相对残差 | 相对解误差 |
|:--|:--|:--|:--|
| $(1,0)^{\mathrm T}$ | $(0,10^{-4})^{\mathrm T}$ | $10^{-4}$ | $1$ |
| $(1-10^{-4},1)^{\mathrm T}$ | $(10^{-4},0)^{\mathrm T}$ | $10^{-4}$ | $10^{-4}$ |

两者残差范数相同，但第一个残差落在 $A^{-1}$ 会放大 $10^4$ 倍的第二方向，第二个落在只放大 $1$ 倍的第一方向。条件数控制**最坏方向**，不是说每次误差都会放大这么多。上界对第一个候选解恰取等号，对第二个则很保守。

这也解释了“残差小”能作什么保证：候选解恰好满足 $A\widetilde{\boldsymbol x}=\boldsymbol b-\boldsymbol r$，因此相对残差衡量了只改变右端时的相对向后误差；要把它转为原问题的解误差保证，仍需乘条件数。若目标相对解误差至多 $10^{-3}$，本例用这条界要求相对残差至多 $10^{-7}$。
:::

::: ex 例 2.3.2 · 把“误差大”追到具体方向 {#ex-2.3.2}

仍用上述 $A,\boldsymbol b$。只把右端改为 $\boldsymbol b+\delta\boldsymbol b$，分别取 $\delta\boldsymbol b=(10^{-6},0)^{\mathrm T}$ 与 $(0,10^{-6})^{\mathrm T}$。求两个新解的相对变化。若想仅靠相对残差保证解的相对误差至多 $10^{-2}$，阈值应设为多少？
:::

::: sol 核对与回查

由 $\delta\boldsymbol x=A^{-1}\delta\boldsymbol b$ 得变化分别为 $(10^{-6},0)^{\mathrm T}$ 与 $(0,10^{-2})^{\mathrm T}$；因 $\|\boldsymbol x^*\|_\infty=1$，相对变化为 $10^{-6}$ 与 $10^{-2}$。残差阈值为 $10^{-2}/10^4=10^{-6}$，这是充分条件，并非必要条件。若不会算矩阵范数，先回到 [1.3 的矩阵范数](../../ch01/sec13.md)；若量都算对却仍混淆两种误差，回看本节 $\boldsymbol e=A^{-1}\boldsymbol r$ 的方向。能解释阈值为何只是保证后，再读 [2.4 迭代法](sec24.md)，把它用于停止准则。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| 条件数 | $\lVert A\rVert\lVert A^{-1}\rVert\ge1$，把输入相对扰动放大成输出相对扰动的上界 | [@def-2.3.1] | [1.2.6](../../ch01/sec12.md#sec-1.2.6) 函数版条件数；[1.3.6](../../ch01/sec13.md#sec-1.3.6) 矩阵版推导 |
| $\mathrm{cond}_2$ | $\sigma_{\max}/\sigma_{\min}$；SPD 时才等于 $\max\lvert\lambda_i\rvert/\min\lvert\lambda_i\rvert$ | [@def-2.3.1] | [补充篇 2.4](../../supplement/sec24.md) Skeel 与成分条件数 |
| 扰动界 | $\dfrac{\lVert\Delta\boldsymbol x\rVert}{\lVert\boldsymbol x\rVert}\le\dfrac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}(\rho_A+\rho_b)$ | [@thm-2.6] | [2.4.1](sec24.md#sec-2.4.1) 迭代法停机判据的误差语言 |
| 残差 $\ne$ 误差 | $\boldsymbol e=A^{-1}\boldsymbol r$，$\dfrac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}$ | [2.3.2](#sec-2.3.2) | [例 2.3.1](#ex-2.3.1) 同残差误差差一万倍 |
| 行均衡化 | 每行除以行内最大元，拆穿量纲造成的假病态 | [例 5](#ex-2.3-textbook5) | [补充篇 2.4](../../supplement/sec24.md) 行缩放反例 |
:::

::: think 本节常见错误
1. **把条件数当特征值之比。**只有实对称（一般地，正规）矩阵才有 $\mathrm{cond}_2=\max\lvert\lambda_i\rvert/\min\lvert\lambda_i\rvert$；一般矩阵必须先取绝对值再取极值——$\operatorname{diag}(-10,1)$ 的条件数是 $10$，不是 $0.1$。
2. **残差小就当误差小。**$\boldsymbol e=A^{-1}\boldsymbol r$，条件数大时两者可以差几个数量级（[例 2.3.1](#ex-2.3.1)）。
3. **条件数大就断言“无解”。**$\operatorname{diag}(1,10^{-20})$ 的条件数 $10^{20}$，仍有唯一解 $(1,1)^{\mathrm T}$；能否算准取决于输入误差、工作精度与算法。
4. **量纲悬殊不均衡化就判病态。**先做行（列）均衡化再算条件数（[例 5](#ex-2.3-textbook5)），否则治的是假象。
5. **以为换算法能治百态。**病态是问题的属性：$\mathrm{cond}$ 不变，稳定算法也只能把误差控制在 $\mathrm{cond}\times u$ 量级。
:::

<a id="sec-2.3-exercises"></a>
## 习题（教材习题 9–12）

::: ex 2.9 · 八位十进制列主元 + 条件数（教材习题 9）
用八位十进制列主元 Gauss 消去求解教材习题 9 的方程组，并求系数矩阵的行范数条件数；结果说明什么？
:::

::: sol 参考答案
列主元保证乘数 $\le1$，但若 $\mathrm{cond}_\infty(A)$ 很大，解的相对误差仍会被放大；条件数大说明问题是病态的，换算法只能避免额外误差，不能把病态变良态。
:::

::: ex 2.10 · 正交矩阵的条件数（教材习题 10）
设 $A$ 是正交矩阵，证明 $\mathrm{cond}_2(A)=1$。
:::

::: sol 参考答案
正交矩阵满足 $A^{\mathrm T}A=I$，故 $\sigma_i(A)=1$，于是 $\mathrm{cond}_2(A)=\sigma_{\max}/\sigma_{\min}=1$。几何上，正交变换不改变长度，最坏放大倍数就是 1。
:::

::: ex 2.11 · 残差与误差界（教材习题 11）
设 $A$ 非奇异、$\boldsymbol b\ne0$，$\tilde{\boldsymbol x}$ 是 $A\boldsymbol x=\boldsymbol b$ 的近似解，$\boldsymbol r=\boldsymbol b-A\tilde{\boldsymbol x}$。证明
$$
\frac{\lVert\boldsymbol x^{*}-\tilde{\boldsymbol x}\rVert}{\lVert\boldsymbol x^{*}\rVert}
\le \mathrm{cond}(A)\frac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}.
$$
:::

::: sol 参考答案
$\boldsymbol x^{*}-\tilde{\boldsymbol x}=A^{-1}\boldsymbol r$，取范数得 $\lVert\boldsymbol x^{*}-\tilde{\boldsymbol x}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol r\rVert$；又 $\lVert\boldsymbol b\rVert\le\lVert A\rVert\lVert\boldsymbol x^{*}\rVert$，相除即得。
:::

::: ex 2.12 · 条件数与残差反例（教材习题 12）
对教材习题 12 的 $A,\boldsymbol b$，计算行范数条件数，并比较两个近似解的残差与误差；说明什么？
:::

::: sol 参考答案
$A$ 的两行近似线性相关，$\mathrm{cond}_\infty(A)$ 很大；两个近似解的残差都可能很小，但误差可以相差很大。结论：**残差不是误差**，条件数大时尤其不能用残差小来判断解准。
:::

::: note 覆盖核对
本节覆盖教材 2.3.1–2.3.2、定理 2.6、例 4–5、习题 9–12；老师第 3 讲 §一（矩阵 1-范数 = 最大列和、∞-范数 = 最大行和——条件数手算的范数基础；可逆性判据见 [2.1 先修](sec21.md#sec-2.1-prereq)）。下一节：[2.4.1 迭代法引论](sec24.md)。
:::
