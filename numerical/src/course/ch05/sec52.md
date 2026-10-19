# 5.4 曲线拟合

> 对应教材 5.4、定理 5.3、例 3。**老师课堂未讲**，按教材补齐，标“教材有、课堂未讲”。
> 与插值的区别：插值要求曲线**穿过**每个点；拟合只要求**整体误差最小**，适合有噪声的数据。

<a id="sec-5.4"></a>
## 5.4.1 最小二乘问题

给定数据 $(x_i,y_i)$，$i=1,\dots,m$，选一组基函数 $\varphi_0,\dots,\varphi_n$，令
$$
p(x)=\sum_{k=0}^n c_k\varphi_k(x),
$$
使残差平方和
$$
Q(c_0,\dots,c_n)=\sum_{i=1}^m\left(y_i-\sum_{k=0}^n c_k\varphi_k(x_i)\right)^2
$$
最小。写成矩阵形式：$A_{ik}=\varphi_k(x_i)$，$\boldsymbol y=(y_1,\dots,y_m)^{\mathrm T}$，则
$$
Q=\lVert A\boldsymbol c-\boldsymbol y\rVert_2^2.
$$

**定理 5.3（法方程）**：$\boldsymbol c$ 是最小二乘解的充要条件是
$$
A^{\mathrm T}A\boldsymbol c=A^{\mathrm T}\boldsymbol y.
$$
若 $A$ 列满秩，则 $A^{\mathrm T}A$ 对称正定，最小二乘解唯一：
$$
\boldsymbol c=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol y.
$$

**证明要点**：$Q(\boldsymbol c)=\boldsymbol c^{\mathrm T}A^{\mathrm T}A\boldsymbol c-2\boldsymbol c^{\mathrm T}A^{\mathrm T}\boldsymbol y+\boldsymbol y^{\mathrm T}\boldsymbol y$ 是二次函数；梯度为零即法方程。$A$ 列满秩时 $A^{\mathrm T}A$ 正定，二阶条件保证极小。$\blacksquare$

## 5.4.2 多项式拟合

取 $\varphi_k(x)=x^k$，则 $A$ 是范德蒙德型矩阵。实际计算**不要**直接解 $A^{\mathrm T}A$（条件数会平方），而用 QR 分解或正规化；对低次多项式（$n=1,2,3$）法方程仍常用。

**例 3（教材 5.2）**：教材给一组数据，分别作一次/二次多项式拟合。步骤：

1. 设 $p(x)=c_0+c_1x$（或 $c_0+c_1x+c_2x^2$）；
2. 算 $A^{\mathrm T}A$ 与 $A^{\mathrm T}\boldsymbol y$；
3. 解法方程得 $c$；
4. 比较不同次数的残差平方和，次数不是越高越好（过拟合）。

具体数值按教材数据复算；核心是“法方程 + 残差检验”，不是背公式。

## 5.4.3 非线性拟合的线性化

若模型是 $y=ae^{bx}$，取对数：
$$
\ln y=\ln a+bx,
$$
对 $(\ln y_i,x_i)$ 作线性最小二乘，再指数回代。类似地，$y=ax^b$ 取 $\ln y=\ln a+b\ln x$。注意：线性化后的最小二乘不等价于原问题的非线性最小二乘，数据误差结构会变；精度要求高时用 Gauss–Newton/Levenberg–Marquardt。

::: note 覆盖核对
本节覆盖教材 5.4、定理 5.3、例 3；**老师课堂未讲**。下一节：[5.3 三次样条](sec53.md)。
:::
