# 学习目标自检表

本页对应第二章 20 条[学习目标](../preface-objectives.md)。每次先写出推导或带数结果，再展开题目答案核对；能独立说明适用条件后，才在自己的笔记中打勾。表中的方框供纸笔记录，不会在网页中保存进度。

| 目标 | 打勾 | 依据与习题 |
|:--|:--:|:--|
| K2.0 位姿与方向余弦 | □ | [@def-2.1.1]、[@thm-2.1.A]；[§2.1 练习 1：点与方向](sec2-1.md#practice-2.1.point)、[练习 2：右手性](sec2-1.md#practice-2.1.handedness) |
| K2.1 旋转矩阵三重身份 | □ | [§2.2 数值对照与练习](sec2-2.md#ex-2.2.compare)；[A1](exercises.md#exercise-2.A1) 区分三重身份，[B2](exercises.md#exercise-2.B2) 证明保长但不能代替方向检查 |
| K2.2 合成规则与初始姿态 | □ | [@ex-2.3.C]；[§2.3 演示与练习](sec2-3.md#practice-2.3.composition)；[A3](exercises.md#exercise-2.A3) 保留一般初始姿态并写清时序 |
| K2.3 两支重建与四个奇点的和/差 | □ | [2.4.4](sec2-4.md#sec-2.4.4)、[2.4.5](sec2-4.md#sec-2.4.5)；[B3](exercises.md#exercise-2.B3) 检查和/差，[C5](exercises.md#exercise-2.C5) 做两支正逆闭环 |
| K2.4 Atan2 象限、输入半径与边界 | □ | [@thm-2.4.A]；[§2.4 练习](sec2-4.md#sec-2.4.6)、[C5](exercises.md#exercise-2.C5) 的近奇点检查 |
| K2.5 角和轴 | □ | [@ex-2.5.C]；[§2.5 半圈练习](sec2-5.md#practice-2.5.halfturn)；[B4](exercises.md#exercise-2.B4) 恢复相对符号，[C1](exercises.md#exercise-2.C1) 验证 Rodrigues 公式 |
| K2.5b 四元数稳定提取、乘序与符号对齐（补充） | □ | [@method-2.6.extract]、[@ex-2.6.C]；[练习 1](sec2-6.md#practice-2.6.extract)、[练习 2](sec2-6.md#practice-2.6.product)、[练习 3](sec2-6.md#practice-2.6.interpolate) 分别检查提取、乘序和插值 |
| K2.5c 李代数与指数映射（补充） | □ | [§2.5 练习 2](sec2-5.md#practice-2.5.log) 区分零轴/零主向量，[练习 3](sec2-5.md#practice-2.5.interpolate) 检查非单位初始姿态的相对插值 |
| K2.6 齐次变换：点/方向、逆与零平移边界、连乘接口 | □ | [@ex-2.7.B]、[@ex-2.7.C]；[练习 1](sec2-7.md#practice-2.7.inverse)、[练习 2](sec2-7.md#practice-2.7.chain)、[练习 3](sec2-7.md#practice-2.7.distance)；[B6](exercises.md#exercise-2.B6) 推导逆矩阵 |
| K2.7 DH 建系、R/P 常数与活动量、基座/工具接口 | □ | [@ex-2.8.B]、[§2.8 混合链练习](sec2-8.md#practice-2.8.chain)、[特殊轴对练习](sec2-8.md#practice-2.8.axes)；[A4](exercises.md#exercise-2.A4) 检查常数与活动量 |
| K2.8 典型结构、腕心/工具、接口与被动角 | □ | [零位与直角核对](sec2-9.md#ex-2.9.A)、[练习 2.9.B](sec2-9.md#ex-2.9.B)；八个演示的预测与读数；回忆卡 B6/C7 |
| K2.9 两空间、边界候选与有条件的自运动 | □ | [§2.10 五项练习](sec2-10.md#practice-2.10)、三种限位预设与定点反例；[C4](exercises.md#exercise-2.C4) 区分采样与边界证明 |
| K2.10 标定 | □ | [2R 标定演示](sec2-11.md#lab-2.11.calibration)、[§2.11 四项练习](sec2-11.md#practice-2.11)；说明方程数只是必要条件，再检查列秩、条件数和独立验证 |
| K2.11 逆运动学 | □ | [@thm-2.12.A]–[@thm-2.12.C]；[例 2.12.D](sec2-12.md#ex-2.12.D) 的两支、无解与退化；[导览检查 3](overview.md#checkpoint-2.inverse)；[C6](exercises.md#exercise-2.C6) 的正解回代 |
| S2.1 建表基本功 | □ | [§2.8 特殊轴对练习](sec2-8.md#practice-2.8.axes)；[C2](exercises.md#exercise-2.C2) 独立建圆柱臂的表；[导览检查 2](overview.md#checkpoint-2.chain) 核对工具点 |
| S2.2 公式实现 | □ | [C1](exercises.md#exercise-2.C1)、[C5](exercises.md#exercise-2.C5)、[C6](exercises.md#exercise-2.C6)；任选一项实现并设计错误乘序或无解输入对照 |
| S2.3 解读工作空间与精度指标的口径 | □ | [§2.10 练习 2–4](sec2-10.md#practice-2.10)：参考点、方向集合、采样边界、目标偏差与散布 |
| A2.1 奇点意识 | □ | [B3](exercises.md#exercise-2.B3) 的表示奇点；[例 2.12.D](sec2-12.md#ex-2.12.D) 的腕心退化；解释角参数不唯一与关节解不唯一的区别 |
| A2.2 约定意识 | □ | [勘误 E2.4](errata.md#errata-2.4)；[C2](exercises.md#exercise-2.C2) 对照零位径向方向与关节正方向 |
| A2.3 验算习惯 | □ | [C1](exercises.md#exercise-2.C1) 查正交与行列式，[C6](exercises.md#exercise-2.C6) 查每支逆解的正解误差 |

第二次复习只重做未能独立完成的条目，并换一组输入再验算。操作演示时先预测结果、再改参数；仅能复述结论或看懂展开的答案，还不足以勾选该项。
