# 原教材习题摘要记录（教材 1–12）

本页保留参考教材第 3 章的题号、主题与旧稿摘要，供查找编写材料。按本书条件编写的完整题目与解答见[本章练习](exercises.md)。

| 题 | 主题 | 题面摘要 | 答案 / 提示 |
|:--:|:--|:--|:--|
| 1 | 幂法乘法次数 | 比较 $A^ku_0$ 与逐步乘 | 逐步乘 $kn^2$；先算 $A^k$ 约 $(k-1)n^3$。 |
| 2 | 幂法求主特征值 | 两个矩阵，相对差 $\le10^{-4}$ | 规范化幂法；$\beta_k\to\lambda_1$，$y_{k-1}$ 为特征向量。 |
| 3 | 商序列收敛 | 证明 $\frac{v^{\mathrm T}A^ku_0}{v^{\mathrm T}A^{k-1}u_0}\to\lambda_1$ | 展开 $A^ku_0$，同除 $\lambda_1^{k-1}$，其余项含 $(\lambda_j/\lambda_1)^k\to0$。 |
| 4 | 反幂法 | 第 2 题 (1) 的模最小特征值 | 每步解 $Au_k=y_{k-1}$，$\lambda_n\approx1/\beta_k$。 |
| 5 | 反幂法精修 | 已知 $\lambda\approx9$ | 对 $A-9I$ 反幂法，$\lambda\approx9+1/\beta_k$。 |
| 6 | 实特征值算法选择 | $-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots$ | 对 $A+50I$ 幂法求 $\lambda_n$、反幂法求 $\lambda_1$；求 $\lambda_2$ 前先消去第一特征方向或验证合适的位移，见[3.6](sec31.md)。 |
| 7 | Jacobi 方法 | $A=\begin{pmatrix}1&1&0.5\\1&1&0.25\\0.5&0.25&2\end{pmatrix}$，$\varepsilon=10^{-5}$ | Jacobi 迭代得特征值 $2.536526,\ 1.480121,\ -0.016647$（和 $=4=$ 迹）；特征向量由累积旋转矩阵的列给出。 |
| 8 | 分块三角矩阵 | 证明 $P,Q$ 的特征值可延拓 | 用 $\det(\lambda I-T)=\det(\lambda I-P)\det(\lambda I-Q)$ 证明谱的并集；右下块的向量一般不能直接补零。 |
| 9 | Householder 映射 | $s=(-2,1,2)^{\mathrm T}$，$r=(4,3,0)^{\mathrm T}$ | $u=s-v=(-4.4,-0.8,2)^{\mathrm T}$，$v=(2.4,1.8,0)^{\mathrm T}$；$H=I-2uu^{\mathrm T}/(u^{\mathrm T}u)$。 |
| 10 | Householder 化三对角 | $A=\begin{pmatrix}1&2&1&2\\2&1&2&-1\\1&2&0&3\\2&-1&3&1\end{pmatrix}$ | 两次 Householder 相似变换得三对角矩阵，见[例 3.3.2](sec33.md#ex-3.3.2)；次对角线为 $(-3,\ 2.759943,\ -1.016207)$。 |
| 11 | Householder 化拟上三角 | $A=\begin{pmatrix}2&1&3&4\\1&-1&2&1\\-1&2&1&2\\1&0&-1&3\end{pmatrix}$ | 两次相似变换得拟上三角，见[例 3.3.3](sec33.md#ex-3.3.3)；第 1 列第 3、4 行与第 2 列第 4 行为零。 |
| 12 | 基本 QR 方法 | $A=\begin{pmatrix}3&1&0\\1&2&1\\0&1&1\end{pmatrix}$ | 基本 QR 迭代收敛到特征值 $2+\sqrt3,\ 2,\ 2-\sqrt3$（即 $3.732051,\ 2,\ 0.267949$），迭代表见[例 3.3.4](sec33.md#ex-3.3.4)。 |
