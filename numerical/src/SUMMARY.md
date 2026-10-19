# Summary

[封面与导览](index.md)

# 卷首

- [范围与目标](preface.md)
- [范围声明与使用方法](preface-scope.md)
- [学习目标（K / S / A）](preface-objectives.md)
- [符号表](preface-notation.md)
- [先修与自测：线性代数 · 微积分 · 编程 · 记号](prerequisite.md)
- [工程工具箱：误差诊断 · 算法选型 · 停止准则 · 函数地图](toolbox.md)

# 学前准备

- [入学诊断自测](entry-test.md)
- [课程知识地图](preface-map.md)

# 第一部分 · 课堂主线（按庞刚老师 2026 秋顺序）

## 第 1 章 绪论：误差、算法与范数

- [第一章导览](ch01/overview.md)
  - [1.1 数值分析的研究对象](ch01/sec11.md)
  - [1.2 误差知识与算法知识](ch01/sec12.md)
  - [1.3 向量范数与矩阵范数](ch01/sec13.md)
- [全章总结](ch01/summary.md)
- [勘误与补注（对应原书）](ch01/errata.md)
- [习题集](ch01/exercises.md)
- [真实应用案例：GPS 定位的误差预算](ch01/application.md)
- [学习目标自检表](ch01/checklist.md)
- [闭卷回忆卡（第一章）](ch01/recall-cards.md)
- [综合自测卷（第一章 · 100 分）](ch01/mock-exam.md)
- [第 1 讲（09-07）：数值分析对象与误差理论](lectures/lec01.md)
- [第 2 讲（09-09）：有效数字、精度技巧与范数](lectures/lec02.md)

## 第 2 章 线性方程组的解法

- [第 2 章导览](course/ch02/overview.md)
- [第 2 章覆盖矩阵](course/ch02/coverage.md)
- [2.1 高斯消去与列主元](course/ch02/sec21.md)
- [2.2 直接三角分解](course/ch02/sec22.md)
- [2.3 条件数与病态方程组](course/ch02/sec23.md)
- [2.4.1 迭代法引论](course/ch02/sec24.md)
- [2.4.2–2.4.4 Jacobi、Gauss–Seidel 与 SOR](course/ch02/sec25.md)
- [第 2 章习题（教材 1–24）](course/ch02/exercises.md)
- [第 3 讲（09-14）：矩阵范数与高斯消去](lectures/lec03.md)
- [第 4 讲（09-16）：LU 分解与迭代法引论](lectures/lec04.md)
- [第 5 讲（09-21）：收敛理论、误差估计与 Jacobi / Gauss–Seidel](lectures/lec05.md)
- [第 6 讲（09-23）：SOR 与特征值问题开篇](lectures/lec06.md)

## 第 3 章 矩阵特征值与特征向量的计算

- [第 3 章导览](course/ch03/overview.md)
- [第 3 章覆盖矩阵](course/ch03/coverage.md)
- [3.1 幂法与反幂法](course/ch03/sec31.md)
- [3.2 Jacobi 方法](course/ch03/sec32.md)
- [3.3 QR 方法](course/ch03/sec33.md)
- [第 3 章习题（教材 1–12）](course/ch03/exercises.md)
- [第 7 讲（09-28）：幂法、反幂法与位移反幂法](lectures/lec07.md)

## 第 4 章 非线性方程与非线性方程组的迭代解法

- [第 4 章导览](course/ch04/overview.md)
- [第 4 章覆盖矩阵](course/ch04/coverage.md)
- [4.1 对分法、简单迭代与收敛阶](course/ch04/sec41.md)
- [4.1.5–4.1.8 Newton 法与割线法](course/ch04/sec42.md)
- [4.2 非线性方程组的迭代解法](course/ch04/sec43.md)
- [第 4 章习题（教材 1–11）](course/ch04/exercises.md)
- [第 8 讲（10-12）：唯一性、收敛阶与牛顿法（材料已归，页面待补）](lectures/lec08.md)
- [第 9 讲（10-14）：牛顿法全局收敛、割线法与单点割线法](lectures/lec09.md)

## 第 5 章 插值与逼近

- [第 5 章导览](course/ch05/overview.md)
- [第 5 章覆盖矩阵](course/ch05/coverage.md)
- [5.1 代数插值](course/ch05/sec51.md)
- [5.2 Hermite 插值](course/ch05/secHermite.md)
- [5.3 三次样条插值](course/ch05/sec53.md)
- [5.4 曲线拟合](course/ch05/sec52.md)
- [5.5–5.6 正交多项式与最佳平方逼近](course/ch05/sec54.md)
- [第 5 章习题](course/ch05/exercises.md)

## 第 6 章 数值积分与数值微分

- [第 6 章导览](course/ch06/overview.md)
- [第 6 章覆盖矩阵](course/ch06/coverage.md)
- [6.1–6.3 插值型求积与 Newton–Cotes](course/ch06/sec61.md)
- [6.5–6.6 复化求积与 Romberg](course/ch06/sec62.md)
- [6.7–6.8 Gauss 求积与数值微分](course/ch06/sec63.md)
- [第 6 章习题（教材 1–12）](course/ch06/exercises.md)

## 第 7 章 常微分方程初值问题的数值解法

- [第 7 章导览](course/ch07/overview.md)
- [第 7 章覆盖矩阵](course/ch07/coverage.md)
- [7.1–7.2 初值问题与单步法](course/ch07/sec71.md)
- [7.3 线性多步法](course/ch07/sec72.md)
- [7.4–7.5 方程组、刚性与边值问题](course/ch07/sec73.md)
- [第 7 章习题（教材 1–12）](course/ch07/exercises.md)

# 第二部分 · 补充篇：数值线性代数工具箱（课堂未讲）

> 以下内容是原书 §1.3 的现代扩充，**不是课堂第 2 章**；节号 2.1–2.8 为补充篇内部编号。需要时从第 2、3、5 章的“补充”链接进入。

- [补充篇导览](ch02/overview.md)
  - [2.1 内积、正交性与正交矩阵](ch02/sec21.md)
  - [2.2 四个基本子空间与投影](ch02/sec22.md)
  - [2.3 正交化与 QR 分解](ch02/sec23.md)
  - [2.4 条件数与扰动分析](ch02/sec24.md)
  - [2.5 特征值、谱半径与对称谱理论](ch02/sec25.md)
  - [2.6 奇异值分解与低秩逼近](ch02/sec26.md)
  - [2.7 数值实验：亲手看见正交与谱](ch02/sec27.md)
  - [2.8 小结与常见陷阱](ch02/sec28.md)
- [全篇总结](ch02/summary.md)
- [勘误与补注（对应原书）](ch02/errata.md)
- [习题集](ch02/exercises.md)
- [学习目标自检表](ch02/checklist.md)
- [闭卷回忆卡（补充篇）](ch02/recall-cards.md)
- [综合自测卷（补充篇 · 100 分）](ch02/mock-exam.md)

# 第三部分 · 课堂精编 · 复习与练习

- [课堂精编导览](lectures/overview.md)
- [课堂 vs 教材 · 对齐审计](lectures/audit.md)
- [课堂精编 · 复习页](lectures/review.md)
- [课堂精编 · 练习与自测](lectures/practice.md)

# 复习与查阅

- [一页速览 · 公式与结论卡](review/formula-cards.md)
- [易混对照卡](review/contrast-cards.md)
- [术语索引（中英对照）](review/glossary.md)
- [最小必读路径](review/study-paths.md)

# 特训 · 竞技与考场

- [必考点竞技场](training/arena.md)
- [考场模拟卷 · 100 分制](training/exam-sprint.md)

# 附录 · 拓展与推导

- [附录 A · 补充推导](appendix/derivations.md)
- [附录 B · 浮点算术的进一步推导](appendix/float.md)
- [附录 C · 跨学科联系与应用拓展](appendix/connections.md)

# 查阅页

- [延伸阅读](reading.md)
