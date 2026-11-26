# 10.7 符号口径与参考勘误说明

本页汇总第十章的数学记号约定、定理编号对照，以及对参考教材及讲义部分印刷版常见笔误的核正说明。

## 一、章节定理编号重构说明

原参考体系中，部分资料先后出现两处相同的「定义 11.3」（分别指向李括号定义与无漂移系统可控性定义），并在同一序列下穿插「定义 11.4」「定义 11.5」。为保证全书按节编号唯一可查，本章统一重编如下：

- [定义 10.3.1](sec10-3.md#def-10.3.1)（完整约束）与 [定义 10.3.2](sec10-3.md#def-10.3.2)（运动学约束与 Pfaffian 约束）；
- [定义 10.4.1](sec10-4.md#def-10.4.1)（李括号）、[定义 10.4.2](sec10-4.md#def-10.4.2)（对合性与对合闭包）、[定义 10.4.3](sec10-4.md#def-10.4.3)（完整/非完整分类）与 [定义 10.4.5](sec10-4.md#def-10.4.4)（无漂移系统可控性）。

## 二、约束矩阵转置记号与大小写角标约定

1. **约束矩阵 $A^{\mathrm T}(q)\dot q = 0$ 与 $A(q)\dot q = 0$**：
   - 在 [§10.3](sec10-3.md) 运动学约束与零空间建模阶段，记单约束列向量 $a_i(q)\in\mathbb R^n$，矩阵形式写作 $A^{\mathrm T}(q)\dot q = 0$（即 $A(q)\in\mathbb R^{n\times k}$，$A^{\mathrm T}\in\mathbb R^{k\times n}$）；
   - 在 [§10.6.3](sec10-6.md#sec-10.6.3) 引入带约束的 Euler–Lagrange 动力学方程时，习惯将约束方程写作 $A(q)\dot q = 0$（此时 $A(q)\in\mathbb R^{k\times n}$），从而广义约束反力写成一致的 $Q_c = A^{\mathrm T}(q)\lambda \in\mathbb R^n$。两处仅为矩阵是否预先转置的约定差异，切勿把两种记法的行数与列数混用。
2. **世界系/载体系角标大小写**：正文中旋转变换一律写作 $R_B^W(\theta)$ 与其正交逆变换 $R_W^B(\theta) = R_B^W(\theta)^{\mathrm T}$；部分推导公式曾写作小写角标 $R_w^b(\theta)$，均指同一世界坐标系 $W$ 与载体坐标系 $B$。

## 三、两轮车 $(2,4)$-链式输入变换公式勘正

部分参考讲义在导出后轮驱动两轮车 $(2,4)$-链式标准形 $\dot z_1 = v_1,\,\dot z_2 = v_2,\,\dot z_3 = z_2 v_1,\,\dot z_4 = z_3 v_1$ 时（坐标选取 $z_1 = x,\,z_2 = \frac{1}{l}\sec^3\theta\tan\phi,\,z_3 = \tan\theta,\,z_4 = y$），将第二个输入分量印刷为：

$$\omega = -\frac{3}{l}v_1\sec\theta\sin^2\phi + \frac{1}{l}v_2\cos^3\theta\cos^2\phi.$$

对 $z_2$ 直接求时间导数 $\dot z_2 = \frac{\mathrm d}{\mathrm dt}\!\left(\frac{1}{l}\sec^3\theta\tan\phi\right)$，并代入 $\dot\theta = \frac{v}{l}\tan\phi$ 与 $v = v_1/\cos\theta$，令 $\dot z_2 = v_2$ 反解转向角速度 $\dot\phi$，严格结果应当为（见 [§10.6.2 式 (10.6-4)](sec10-6.md#sec-10.6.2)）：

$$\dot\phi = -\frac{3}{l}v_1\sec\theta\tan\theta\sin^2\phi + l\,v_2\cos^3\theta\cos^2\phi.$$

可见原印刷式存在三处笔误：其一将输入变量名 $\dot\phi$ 误印作车身角速度符号 $\omega$；其二因漏写 $(\sec^3\theta)' = 3\sec^3\theta\tan\theta$ 中的 $\tan\theta$ 因子；其三将轴距因子 $l$ 误印为其倒数 $\frac{1}{l}$。该修正已由符号与数值求导验算脚本 [verify_homework10.py](../../tools/verify_homework10.py) 验证通过（残差 $< 10^{-14}$）。
