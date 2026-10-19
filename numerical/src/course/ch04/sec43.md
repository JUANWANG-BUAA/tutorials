# 4.2 非线性方程组的迭代解法

> 对应教材 4.2.1–4.2.4、定理 4.10–4.15、例 6–7、习题 10–11。**老师课堂未讲**，按教材补齐，标“教材有、课堂未讲”。
> 主线：一元方法搬到方程组，关键是 Jacobian 与压缩/谱半径。

<a id="sec-4.2.1"></a>
## 4.2.1 非线性方程组与可微性

设
$$
F(\boldsymbol x)=\begin{pmatrix}f_1(x_1,\dots,x_n)\\\vdots\\f_n(x_1,\dots,x_n)\end{pmatrix}=\boldsymbol0.
$$
Jacobian 矩阵
$$
F'(\boldsymbol x)=\begin{pmatrix}
\frac{\partial f_1}{\partial x_1}&\cdots&\frac{\partial f_1}{\partial x_n}\\
\vdots&&\vdots\\
\frac{\partial f_n}{\partial x_1}&\cdots&\frac{\partial f_n}{\partial x_n}
\end{pmatrix}.
$$
教材定理 4.10–4.12 给出：$F$ 可微的充要条件是各分量可微；中值定理
$$
F(\boldsymbol x)-F(\boldsymbol y)=\int_0^1F'(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))(\boldsymbol x-\boldsymbol y)\,dt
$$
（或牛顿–莱布尼茨型公式）；以及压缩条件的矩阵版本。

<a id="sec-4.2.2"></a>
## 4.2.2 不动点迭代

把 $F(\boldsymbol x)=0$ 改写成 $\boldsymbol x=G(\boldsymbol x)$，迭代
$$
\boldsymbol x^{(k+1)}=G(\boldsymbol x^{(k)}).
$$

**定理 4.13（压缩映像原理）**：设 $D\subset\mathbb R^n$ 闭，$G:D\to D$，且存在 $L\lt1$，使
$$
\lVert G(\boldsymbol x)-G(\boldsymbol y)\rVert\le L\lVert\boldsymbol x-\boldsymbol y\rVert,\qquad \forall \boldsymbol x,\boldsymbol y\in D.
$$
则 $G$ 在 $D$ 内有唯一不动点 $\boldsymbol x^*$，且对任意 $\boldsymbol x^{(0)}\in D$，迭代收敛到 $\boldsymbol x^*$，并有
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\frac{L^k}{1-L}\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert.
$$

**定理 4.14（线性迭代）**：若 $G(\boldsymbol x)=B\boldsymbol x+\boldsymbol d$，则迭代对任意初值收敛的充要条件是 $\rho(B)\lt1$；$\lVert B\rVert\lt1$ 是充分条件。

**例 6（教材 4.2.2）**：教材用一个 $2\times2$ 非线性方程组，把它写成 $\boldsymbol x=G(\boldsymbol x)$，验证 $G$ 在某个区域上压缩（或 $\rho(G')\lt1$），再用迭代求解；数值表展示线性收敛。

<a id="sec-4.2.3"></a>
## 4.2.3 Newton 法（方程组）

在 $\boldsymbol x^{(k)}$ 处线性化：
$$
F(\boldsymbol x)\approx F(\boldsymbol x^{(k)})+F'(\boldsymbol x^{(k)})(\boldsymbol x-\boldsymbol x^{(k)}),
$$
令其为零：
$$
\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}-F'(\boldsymbol x^{(k)})^{-1}F(\boldsymbol x^{(k)}).
$$
实际计算不显式求逆，而是解线性方程组
$$
F'(\boldsymbol x^{(k)})\Delta\boldsymbol x^{(k)}=-F(\boldsymbol x^{(k)}),\qquad
\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta\boldsymbol x^{(k)}.
$$

**定理 4.15**：设 $F$ 在解 $\boldsymbol x^*$ 的邻域内二阶连续可微，$F(\boldsymbol x^*)=0$，$F'(\boldsymbol x^*)$ 非奇异。则存在 $\delta\gt0$，当 $\boldsymbol x^{(0)}$ 充分接近 $\boldsymbol x^*$ 时，Newton 迭代收敛，且至少平方收敛。

**例 7（教材 4.2.3）**：教材对例 6 的方程组用 Newton 法，每步解一个 $2\times2$ 线性方程组；与不动点迭代相比，Newton 步数少，但每步要算 Jacobian 并解线性系统。

<a id="sec-4.2.4"></a>
## 4.2.4 离散 Newton 与 Newton–Steffensen

若 Jacobian 难算，用差商近似：
$$
J(\boldsymbol x^{(k)},h^{(k)})_{ij}=\frac{f_i(\boldsymbol x^{(k)}+h_j^{(k)}e_j)-f_i(\boldsymbol x^{(k)})}{h_j^{(k)}},
$$
再解
$$
J(\boldsymbol x^{(k)},h^{(k)})\Delta\boldsymbol x^{(k)}=-F(\boldsymbol x^{(k)}).
$$
这就是离散 Newton 法。取 $h_j^{(k)}=c\lVert F(\boldsymbol x^{(k)})\rVert$ 时，称为 Newton–Steffensen 方法；在定理 4.15 的条件下，适当选 $c$ 仍至少平方收敛。

<a id="sec-4.2.5"></a>
## 4.2.5 习题（教材习题 10–11）

::: ex 4.10 · 方程组简单迭代（教材习题 10）
用简单迭代法求教材习题 10 的非线性方程组。
:::

::: sol 参考答案
先把方程组写成 $\boldsymbol x=G(\boldsymbol x)$，在根附近验证 $\lVert G'(\boldsymbol x)\rVert\lt1$ 或 $\rho(G')\lt1$，再迭代；停机用相邻差。若范数不满足，换等价形式或改用 Newton。
:::

::: ex 4.11 · 方程组 Newton 法（教材习题 11）
用 Newton 法求教材习题 11 的非线性方程组。
:::

::: sol 参考答案
写 Jacobian $F'$，每步解 $F'(\boldsymbol x^{(k)})\Delta\boldsymbol x=-F(\boldsymbol x^{(k)})$，更新 $\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta\boldsymbol x$；初值要靠近根，验证 $F'(\boldsymbol x^*)$ 非奇异。
:::

::: note 覆盖核对
本节覆盖教材 4.2.1–4.2.4、定理 4.10–4.15、例 6–7、习题 10–11；**老师课堂未讲**。下一节：[第 4 章习题](exercises.md)。
:::
