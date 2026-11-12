# 第二章小结：解方程组与检查结果

解线性方程组时，首先要选合适的求解方法。一般稠密矩阵可以用列主元消去或 LU 分解；三对角矩阵可以利用追赶法减少存储和运算；迭代法则通过反复更新近似解求解。

| 方法或概念 | 需要记住的关系 | 使用条件与作用 |
|:--|:--|:--|
| 列主元消去 | 每步在当前列选择绝对值最大的主元 | 控制消元乘数，仍需注意元素增长 |
| LU 分解 | $QA=LU$，先解 $L\boldsymbol y=Q\boldsymbol b$，再解 $U\boldsymbol x=\boldsymbol y$ | 矩阵不变时，可对多个右端复用分解 |
| 追赶法 | 每行只处理相邻元素 | 三对角结构，各步分母非零；计算量为 $O(n)$ |
| 定常迭代 | $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$ | 对任意初值收敛到同一解的充要条件为 $\rho(G)<1$ |
| 残差 | $\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$ | 衡量方程被满足的程度 |
| 误差界 | $\lVert\boldsymbol x-\hat{\boldsymbol x}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol r\rVert$ | 还需考虑问题的敏感性 |

残差容易计算，却不等于解误差。病态矩阵会使小残差对应较大误差；选主元减少的是算法引入的额外误差，并不改变原矩阵的条件数。

迭代法停止时，也要分清相邻两步的差与残差。若已知某个从属范数下 $q=\lVert G\rVert<1$，可用后验界 $\lVert\boldsymbol e_k\rVert\le q\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert/(1-q)$。只看“数字不再明显变化”，不足以保证达到误差要求。

接着做[本章练习](exercises.md)。下一章求特征值时，反幂法的每一步都要求解一个线性方程组，本章的分解方法会再次用到。
