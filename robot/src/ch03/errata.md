# 第三章勘误与记号对照

本章梳理第三章与原书教材、常见讲义记号及计算约定之间最易引起混淆的关键条目，作为正文推导与习题校验的统一依据。

<a id="errata-3.1"></a>

## E3.1 拟人臂位置雅可比 $J_P$ 第三行的余弦形式

- **核对结论**：在[3.2.2 节](sec3-2.md#sec-3.2.2)拟人臂模型下，基座系竖直速度（$J_P$ 第三行）经由叉乘公式、原书式 (3.37)–(3.38) 及 `tools/verify_ch03_jac.py` 中心差分（误差 $<10^{-9}$）三路互校，确认为**余弦**组合：

$$J_{P,\text{row }3} = \begin{bmatrix}0 & a_2\cos\vartheta_2+a_3\cos(\vartheta_2+\vartheta_3) & a_3\cos(\vartheta_2+\vartheta_3)\end{bmatrix},$$

由此分解 $\det J_P = -a_2a_3\sin\vartheta_3\,(a_2\cos\vartheta_2+a_3\cos(\vartheta_2+\vartheta_3))$，精确对应肘奇点 $s_3=0$ 与肩奇点 $a_2c_2+a_3c_{23}=0$（[3.3.3 节](sec3-3.md#sec-3.3.3)）。

<a id="errata-3.3"></a>

## E3.3 原书延伸：类人机械手（双树结构）的雅可比组装

原书 §3.2 除平面臂、拟人臂与斯坦福机械手外，还讨论了具有分叉双链的类人结构，其几何结构已在[2.9 节](../ch02/sec2-9.md)介绍；实际求雅可比时仍直接沿用[五步标准流程](sec3-2.md#method-3.2.A)，对各末端分支仅累积其上游关节列即可。

<a id="errata-3.4"></a>

## E3.4 可操作椭球与工程选修边界

可操作度 $w(\boldsymbol q)=\sqrt{\det(JJ^{\mathrm T})}$ 及速度/力椭球半轴对偶在工业机构灵巧性评价中常用于次目标优化（见 [3.5.2](sec3-5.md#sec-3.5.1) 与 [3.8.3](sec3-8.md#sec-3.8.3)）；实际用于混合平动/转动任务或混合 R/P 关节时，必须先统一特征长度或量纲权重，不可把无量纲缩放前的线速度、角速度或 $\mathrm N,\mathrm{N\cdot m}$ 混入同一欧氏范数。

<a id="errata-3.6"></a>

## E3.6 记号与逆算子约定统一表

- **向量排布与基系**：本教程列向量统一采用粗体 $\boldsymbol z,\boldsymbol p$（手写板书常用下划线 $\underline{z}$ 等价对应）；几何雅可比中的关节轴向 $\boldsymbol z_{i-1}$ 一律指**基坐标系 $\{0\}$** 下 $R_{i-1}^0$ 的第三列，绝不可不经检验预设为 $[0,0,1]^{\mathrm T}$（[3.1.3 节](sec3-1.md#sec-3.1.3)）。
- **伪逆 vs 阻尼广义逆**：$J^\dagger$ 为 Moore–Penrose 伪逆（行满秩时右伪逆闭式 $J^{\mathrm T}(JJ^{\mathrm T})^{-1}$，一般秩下以正奇异值 SVD 定义）；$J^*=W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T}+K^{-1})^{-1}$ 为正则化阻尼广义逆（见 [@def-3.5.1] 与 [@def-3.5.2]）。
- **任务维数 $r$、空间维数 $m$ 与自由度 $n$**：任务冗余判定看 $n>r$，而非简单比较关节数与几何构型最大维数 $m$（见[2.10 节](../ch02/sec2-10.md)与[@def-3.4.1]）。

<a id="errata-3.7"></a>

## E3.7 转动关节局部平移矢量求导与表达基换基边界

- **连杆线速度递推项**：对于标准 DH 参数中的局部相对平移 $\boldsymbol r_{i-1,i}^{i-1}=[a_i\cos\vartheta_i,a_i\sin\vartheta_i,d_i]^{\mathrm T}$，即使杆长 $a_i$ 与偏距 $d_i$ 为常数，转动关节仍具有非零局部导数 $\dot{\boldsymbol r}_{i-1,i}^{i-1}=\dot\vartheta_i(\boldsymbol z_{i-1}^{i-1}\times\boldsymbol r_{i-1,i}^{i-1})$。只有将这一相对项与牵连项 $\boldsymbol\omega_{i-1}\times\boldsymbol r_{i-1,i}$ 合并后，转动关节才化简为 $\dot{\boldsymbol p}_i=\dot{\boldsymbol p}_{i-1}+\boldsymbol\omega_i\times\boldsymbol r_{i-1,i}$（参见[3.1.2 节](sec3-1.md#practice-3.1.recursion)）。
- **换基与换参考点区分**：[3.1.3 节](sec3-1.md#sec-3.1.3)中的 $J^u=\operatorname{diag}(R^u,R^u)J$ 仅切换**同一参考点、同一物理速度**的表达坐标系分量；同时移动参考点必须额外加入由叉乘构成的平移耦合块（[3.8.2 节](sec3-8.md#sec-3.8.2)的 $A_v$ 与 $A_v^{-\mathrm T}$）。
