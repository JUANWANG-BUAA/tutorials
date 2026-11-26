# 全章总结 · 第二章：运动学

## 十二节架构与知识总览

| 节 | 核心内容与重要结论 | 常见陷阱 |
|:--|:--|:--|
| **[2.1](sec2-1.md) 刚体的位姿** | 位姿 $=$ 原点位置 $\boldsymbol o'\in\mathbb R^3$（带单位 m）$+$ 方向余弦阵 $R\in SO(3)$（无量纲）；6 条正交约束与右手条件 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$ 留出 3 个独立姿态自由度（[@thm-2.1.A]） | 用单根单位轴代替完整三维姿态；将平移加到自由方向向量上；忽略 $\det R=+1$ |
| **[2.2](sec2-2.md) 旋转矩阵** | 三列为动系三轴在参考系的坐标；$R^{\mathrm T}R=I_3,\ R^{-1}=R^{\mathrm T},\ \det R=1$；三重几何身份（姿态、换基、主动旋转，[@thm-2.2.B]） | 不分主动旋转（$R$）与被动换基（$R^{\mathrm T}$）；仅凭模长或 $180^\circ$ 对称角检验矩阵正反 |
| **[2.3](sec2-3.md) 旋转的合成** | 当前轴复合**右乘**（[@thm-2.3.A]），固定轴复合**左乘**（[@thm-2.3.B]）；绕非正交轴乘法不可交换（[@ex-2.3.C]） | 漏写初始非单位姿态；直接把绕不同轴的角度相加；把某向量的碰巧重合误作矩阵相等 |
| **[2.4](sec2-4.md) 欧拉角** | ZYZ 绕当前轴右乘、RPY 绕固定轴左乘；$\operatorname{Atan2}(y,x)$ 保留四象限；两支孤立解与万向锁表示奇异（$s_\vartheta=0$ 或 $c_\vartheta=0$，[@thm-2.4.B]） | RPY 负俯仰角支误用符号；将表示奇异误作姿态不可达或误认为 Atan2 能消除奇异 |
| **[2.5](sec2-5.md) 角和轴** | Rodrigues 旋转公式与李代数指数/对数映射（[@thm-2.5.D]、[@thm-2.5.E]）；$(\vartheta,\boldsymbol r)\sim(-\vartheta,-\boldsymbol r)$ 同步反号；半圈最大对角主元提取（[@thm-2.5.B]） | 认为半圈反对称差 $R-R^{\mathrm T}$ 能定符号；把矢量 $\boldsymbol\omega$ 与反对称阵 $S(\boldsymbol\omega)$ 混淆 |
| **[2.6](sec2-6.md) 单位四元数** | 半角打包 $Q=(\cos\frac{\vartheta}{2},\sin\frac{\vartheta}{2}\boldsymbol r)$；双重覆盖 $Q\sim -Q$；$H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ 无奇异提取（[@method-2.6.extract]）；符号对齐短弧 SLERP | 用对角外非对角差在 $\eta=0$ 处提取向量；忘记在插值前检查 $\boldsymbol q_1\cdot\boldsymbol q_2<0$ |
| **[2.7](sec2-7.md) 齐次变换** | 点 $[\boldsymbol p;1]$ 与方向 $[\boldsymbol d;0]$；$A_0^1=\begin{bmatrix}R^{\mathrm T}&-R^{\mathrm T}\boldsymbol o\\\boldsymbol 0^{\mathrm T}&1\end{bmatrix}$；非零平移时 $A^{-1}\ne A^{\mathrm T}$；空间速度 $\boldsymbol v_s=\dot{\boldsymbol o}-\boldsymbol\omega_s\times\boldsymbol o$ | 机械将纯正交转置用于一般 $SE(3)$ 求逆；修改基座顺序仍误用原坐标标签 |
| **[2.8](sec2-8.md) 正运动学与 DH 法** | 开链连乘 $T_e^b=T_0^b T_n^0 T_e^n$（[@thm-2.8.A]）；看守模型（$z_{i-1}$ 沿关节 $i$，[@method-2.8.watch]）；标准 DH 四规则与「3 常 1 变」矩阵 $A_i^{i-1}$；闭链切口化归树链 | 混淆标准 DH 与改进 DH；将 P 关节的 $\vartheta_i$ 写成变量；写错 $T_0^b$ 左右接口顺序 |
| **[2.9](sec2-9.md) 典型机械结构** | 平面 3R、闭链平行臂、球形臂（含偏距 $d_2$）、拟人臂、球形腕（ZYZ 等价，腕奇异 $s_5=0$）、斯坦福、带腕拟人臂（接口重定 $a_3\to d_4$）、7R DLR 与 17-DOF 类人树 | 未校准 $\{3\}$ 接口就将无腕拟人臂与球腕直接相乘；遗漏零位和特殊构型校验 |
| **[2.10](sec2-10.md) 关节与操作空间** | $n,m,r\le\min(n,m)$；可达域 $\mathcal W_R$ 与灵活域 $\mathcal W_D\subseteq\mathcal W_R$；重复精度 vs 准确度；本质/功能冗余 $\dim\mathcal N(\boldsymbol J_{\mathrm{task}})=n-\operatorname{rank}\boldsymbol J_{\mathrm{task}}$ | 把关节空间边界全当成工作空间边界；把一阶奇异零空间误当成可积有限自运动 |
| **[2.11](sec2-11.md) 运动学标定** | 参数辨识模型 $\boldsymbol x_e=\boldsymbol k(\boldsymbol\xi,\boldsymbol q)\ (p\le 4n)$；矩阵对数姿态误差；QR/SVD 加权迭代法（[@method-2.11.steps]）与独立校验集评估 | 不做可辨识分析盲套 $p=4n$；仅在局部狭窄区域采点使条件数恶化；混淆开机回零与标定 |
| **[2.12](sec2-12.md) 逆运动学** | 四难点（[@thm-2.12.A]）；Pieper 准则（[@thm-2.12.B]）与球腕解耦 $\boldsymbol p_W=\boldsymbol p_e-d_6\boldsymbol a_e$（[@method-2.12.decouple]）；平面 3R、球臂有向径向解、拟人 4 支与球腕 2 支、SCARA 闭式解 | 把充分条件误作必要条件；各分支角张冠李戴；遇到零分母误判“无解”而漏掉连续解族 |

## 全章一条数学主线

刚体姿态需要 $SO(3)$ 的 9 个正交方向余弦全局无奇异表示；Euler 角、角轴和四元数是从工程坐标最小化、几何直观、无奇异插值三个方向给出的等价局部参数化。齐次变换把姿态与三维平移统一放进仿射群 $SE(3)$，Denavit–Hartenberg 规则进一步将其规范为仅含单变量的串联开链乘积 $T_e^b(\boldsymbol q)$。面对工程逆向求解时，工作空间与标定先保证模型有界、准确、满秩可观，逆运动学随后借助几何拆解与腕心解耦求出全部构型分支；下一章（[第三章](../ch03/overview.md)）将对这条完整的非线性映射求微分，研究末端速度雅可比与奇异矩阵秩亏损。

## 自查与下一章入口

请先合上本表完成[导览三项核心计算核对](overview.md#checkpoint-2)与[过关清单](checklist.md)，最后对照[第三章导览](../ch03/overview.md)进入微分运动学：同样到达平面点 $(1,1)\,\mathrm m$ 的两支两连杆姿势，速度雅可比矩阵将解释为什么靠近边界 $\vartheta_2=0$ 时关节速度会无穷放大。
