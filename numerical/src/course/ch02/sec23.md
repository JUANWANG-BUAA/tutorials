# 2.3 条件数与病态线性方程组

> 对应教材 2.3.1–2.3.2、定理 2.6、例 4–5、习题 9–12；对应老师第 3 讲 §一（点到）。
> 本节回答：**数据有微小扰动时，解会坏多少？** 答案由条件数 $\mathrm{cond}(A)$ 决定。

<a id="sec-2.3.1"></a>
## 2.3.1 条件数与扰动界

**定义**：对非奇异矩阵 $A$，称
$$
\mathrm{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert
$$
为 $A$ 的条件数。常用 $\mathrm{cond}_1,\mathrm{cond}_\infty,\mathrm{cond}_2$；其中
$$
\mathrm{cond}_2(A)=\frac{\sigma_{\max}(A)}{\sigma_{\min}(A)}
=\sqrt{\frac{\lambda_{\max}(A^{\mathrm T}A)}{\lambda_{\min}(A^{\mathrm T}A)}}.
$$

**性质**：$\mathrm{cond}(A)\ge1$；$\mathrm{cond}(kA)=\mathrm{cond}(A)\ (k\ne0)$；正交矩阵 $\mathrm{cond}_2(Q)=1$；实对称矩阵 $\mathrm{cond}_2(A)=|\lambda_{\max}|/|\lambda_{\min}|$。

**定理 2.6（扰动界）**：设 $A$ 非奇异，$\boldsymbol x$ 是 $A\boldsymbol x=\boldsymbol b$ 的解，$\boldsymbol b\ne0$。若 $\lVert A^{-1}\rVert\lVert\Delta A\rVert\lt1$，则 $A+\Delta A$ 非奇异，且
$$
\frac{\lVert\Delta\boldsymbol x\rVert}{\lVert\boldsymbol x\rVert}
\le
\frac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}
\left(\rho_A+\rho_b\right),
\qquad
\rho_A=\frac{\lVert\Delta A\rVert}{\lVert A\rVert},\quad
\rho_b=\frac{\lVert\Delta\boldsymbol b\rVert}{\lVert\boldsymbol b\rVert}.
$$

**证明要点**：由 $(A+\Delta A)(\boldsymbol x+\Delta\boldsymbol x)=\boldsymbol b+\Delta\boldsymbol b$ 减去 $A\boldsymbol x=\boldsymbol b$，得
$$
\Delta\boldsymbol x=A^{-1}\Delta\boldsymbol b-A^{-1}\Delta A\,\boldsymbol x-A^{-1}\Delta A\,\Delta\boldsymbol x.
$$
取范数，把最后一项移到左边，用 $\lVert\boldsymbol b\rVert\le\lVert A\rVert\lVert\boldsymbol x\rVert$ 放缩，即得。$\blacksquare$

**读法**：条件数把“输入的相对扰动”放大成“输出的相对扰动”的上界。$\mathrm{cond}(A)$ 大，问题病态；此时**换算法救不了**，只能换提法（换基、正则化、提高精度）。

**例 4（教材 2.3.1）**：教材用
$$
A=\begin{pmatrix}1&1\\1&1.0001\end{pmatrix}
$$
展示右端微小扰动引起解的巨大变化；其 $\mathrm{cond}_\infty(A)\approx4.0\times10^4$，右端 $0.005\%$ 的扰动可带来约 $50\%$ 的解误差。

**例 5（教材 2.3.1–2.3.2）**：系数矩阵元素数量级悬殊时，先做**行均衡化**（每行除以该行最大元素）再算条件数/求解；否则“病态”可能只是量纲造成的假象。

<a id="sec-2.3.2"></a>
## 2.3.2 病态方程组的处置

教材 2.3.2 给出四条常用办法：

1. **提高精度**：双精度/多精度能减轻舍入，但不能改变条件数；条件数 $10^{20}$ 时仍然无解。
2. **行（列）均衡化**：把每行/列缩放到同一量级，降低人为病态。
3. **残差校正（迭代精化）**：用当前解算残差 $\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$，解 $A\Delta\boldsymbol x=\boldsymbol r$，令 $\hat{\boldsymbol x}\leftarrow\hat{\boldsymbol x}+\Delta\boldsymbol x$；在条件数不太大且残差计算足够精确时有效。
4. **换提法**：正则化（Tikhonov）、换基（如插值从范德蒙德基换到拉格朗日基）、增广方程等。

**关键区分**：残差小 $\ne$ 误差小。$\boldsymbol e=A^{-1}\boldsymbol r$，所以
$$
\frac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}
\le \mathrm{cond}(A)\frac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}.
$$
条件数大时，残差可以很小而误差仍然很大。停机判据只能保证“残差小”，不能保证“解准”。

<a id="sec-2.3.3"></a>
## 2.3.3 习题（教材习题 9–12）

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
设 $A$ 非奇异，$\tilde{\boldsymbol x}$ 是 $A\boldsymbol x=\boldsymbol b$ 的近似解，$\boldsymbol r=\boldsymbol b-A\tilde{\boldsymbol x}$。证明
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
本节覆盖教材 2.3.1–2.3.2、定理 2.6、例 4–5、习题 9–12；老师第 3 讲 §一（条件数的范数语言）。下一节：[2.4.1 迭代法引论](sec24.md)。
:::
