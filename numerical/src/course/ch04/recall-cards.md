# 闭卷回忆卡 · 第 4 章：非线性方程的迭代解法

## A. 定义卡

**A1.** 什么叫不动点迭代？把 $f(x)=0$ 变成迭代问题的关键是什么？
::: sol
找等价形式 $x=\varphi(x)$，迭代 $x_{k+1}=\varphi(x_k)$。关键在**选 $\varphi$**：不同的 $\varphi$ 给出完全不同的收敛速度（甚至不收敛）。常用构造：① 移项 $\varphi(x)=x+\lambda(x)f(x)$；② Newton 的 $\varphi(x)=x-\dfrac{f(x)}{f'(x)}$ 就是取 $\lambda(x)=-1/f'(x)$。（✓ / △ / ×）
:::

**A2.** 收敛阶怎么定义？阶越高越好吗？
::: sol
若 $e_{k+1}\approx C e_k^p$（$C$ 为常数、$p\ge1$），称迭代是 **$p$ 阶收敛**。$p$ 越大越好：线性（$p=1$）误差按固定比例缩小，二阶（$p=2$）误差被平方。要注意 $C$ 的大小也重要，且 $p>1$ 要求初值足够近。（✓ / △ / ×）
:::

## B. 定理卡

**B1.** 压缩映射不动点定理的条件与结论是什么？
::: sol
条件：$\varphi:\,[a,b]\to[a,b]$（**自映射**）且存在 $L<1$ 使 $\lvert\varphi'(x)\rvert\le L$（**压缩**）。
结论：存在**唯一**不动点 $s$；任意初值 $x_0\in[a,b]$ 的迭代都收敛到 $s$；且有先验估计 $\lvert x_k-s\rvert\le\dfrac{L^k}{1-L}\lvert x_1-x_0\rvert$ 与后验估计 $\lvert x_k-s\rvert\le\dfrac{L}{1-L}\lvert x_k-x_{k-1}\rvert$。（✓ / △ / ×）
:::

**B2.** Newton 法的全局收敛四条件是什么？
::: sol
设 $f\in C^2[a,b]$：① $f(a)f(b)<0$（异号）；② $f''$ 在 $[a,b]$ 上不变号；③ $f'\ne0$；④ 初值 $x_0$ 与 $b-a$ **同号**。则 Newton 迭代收敛到区间内唯一根。（✓ / △ / ×）
:::

**B3.** Newton 法为什么至少二阶？重根时为什么掉阶？
::: sol
取 $\varphi(x)=x-f(x)/f'(x)$，则 $\varphi'(x)=\dfrac{f(x)f''(x)}{[f'(x)]^2}$，在单根 $s$ 处 $f(s)=0$ 故 $\varphi'(s)=0$，按收敛阶定理至少二阶。若 $s$ 是 $m$ 重根，则 $f(s)=f'(s)=0$ 而 $f''(s)\ne0$，此时 $\varphi'(s)=1-\dfrac1m\ne0$，退化为**一阶**收敛；修正 Newton 法 $\varphi(x)=x-m\dfrac{f(x)}{f'(x)}$ 可恢复二阶。（✓ / △ / ×）
:::

## C. 方法卡

**C1.** 课堂自选题 $x-\ln x=2$（$[2,4]$）的验证四步是什么？
::: sol
取 $\varphi(x)=2+\ln x$。① 连续性与异号：$f(x)=x-\ln x-2$，$f(2)=-\ln2<0$，$f(4)=2-\ln4\approx0.614>0$，端点异号；② **自映射**：$\varphi([2,4])=[2+\ln2,\,2+\ln4]\subset[2,4]$；③ **压缩**：$\varphi'(x)=1/x\le1/2<1$；④ 收敛与误差估计。答案区间在 $[2,4]$，迭代 $x_{k+1}=2+\ln x_k$ 收敛。（✓ / △ / ×）
:::

**A4.** 非线性方程组的 Newton 法怎么写？每步代价是什么？
::: sol
设 $F(\boldsymbol x)=\boldsymbol 0$，Jacobi 矩阵 $J(\boldsymbol x)=\partial F/\partial\boldsymbol x$。Newton 步为

$$
J(\boldsymbol x^{(k)})\Delta\boldsymbol x=-F(\boldsymbol x^{(k)}),\qquad
\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta\boldsymbol x .
$$

每步解一个 $n$ 元线性方程组（不是显式求 $J^{-1}$）；$J$ 非奇异且初值足够近时平方收敛。离散 Newton 用差商矩阵代替 $J$，每步 $n$ 次函数向量求值，超线性收敛。（✓ / △ / ×）
:::
