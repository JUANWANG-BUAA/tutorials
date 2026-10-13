# 勘误表（对应原课件）

整理时对原课件逐题复核，发现以下数学错误、论证缺口与概念边界问题；正文相应位置已按正确内容改写，此处集中列出供对照。

编号 | 位置 | 原文 | 勘误与理由
:--:|:--|:--|:--
E1 | 1.1 课件页 30（例 1.1.5 思考） | $A^3=A(2A-I)=5A-2I$ | 应为 $A^3=3A-2I$。直接计算 $A^3=\begin{pmatrix}1&3\\0&1\end{pmatrix}=3A-2I$；或由 $A^3=A(2A-I)=2A^2-A=2(2A-I)-A$。一般地 $A^k=kA-(k-1)I$（归纳证明见 [1.1.6](sec11.md#sec-1.1.6)）。
E2 | 1.3 课件页 20（例 1.3.6） | 「观察知 $\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3$ 线性无关」，得 $\dim W_1=3$，答案 $\dim(W_1\cap W_2)=2$ | $\boldsymbol{\alpha}_1-2\boldsymbol{\alpha}_2+\boldsymbol{\alpha}_3=\boldsymbol{\theta}$，三向量**相关**（课件矩阵第 1、3 行相同），$\dim W_1=2$；正确答案 $\dim(W_1\cap W_2)=2+2-3=1$，且 $W_1\cap W_2=\operatorname{span}\{(0,1,0)^{\mathrm T}\}$。完整解法见 [1.3.9](sec13.md#sec-1.3.9)。
E3 | 1.4 课件页 15–16（定义 1.4.4） | 紧接「第一变元线性」约定写 $A=((\boldsymbol{\varepsilon}_i,\boldsymbol{\varepsilon}_j))$，同时又写 $(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm H}A\boldsymbol{\xi}$ | 两式的下标次序不一致。若 $\boldsymbol{\xi},\boldsymbol{\eta}$ 分别是 $\boldsymbol{x},\boldsymbol{y}$ 的坐标，并坚持第一变元线性，则应定义 $A_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$，此时才有 $(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm H}A\boldsymbol{\xi}$。另一种定义也可用，但矩阵公式必须相应改变。
E4 | 1.4 课件页 16（注 4） | 「内积与度量矩阵存在一一对应关系」 | 需补上「**固定一组基以后**」。同一个内积在不同基下有不同的度量矩阵，且按 $G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P$ 作合同变换；不固定基时不能把内积与某一个矩阵直接一一对应。
E5 | 1.5 课件页 4（命题 1.5.1 (4)） | 三角不等式处只有示意图，证明为「在此处键入公式。」占位框 | 课件未给证明，且**按课件顺序此时证不了**：三角不等式依赖 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})\leq|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\|\boldsymbol{y}\|$，而 Cauchy–Schwarz 在下一页才出现。本教程先证 (1)–(3)，把 (4) 悬置到 C-S 之后补全。详见 [1.5.2](sec15.md#sec-1.5.2)。
E6 | 1.5 课件页 8（定义 1.5.2） | 夹角定义写在一般内积空间上 | 复空间中 $(\boldsymbol{x},\boldsymbol{y})$ 是复数，$\arccos$ 无定义。夹角限实内积空间；复空间可改用 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})$，或只保留定义无歧义的「正交」。详见 [1.5.3](sec15.md#sec-1.5.3)。
E7 | 1.5 课件页 11（注 5） | 正交**当且仅当**勾股等式 | 「当且仅当」在复空间不成立：$x=1,y=i\in\mathbb C^1$ 满足勾股等式但 $(x,y)=-i\neq0$。只保留「正交 $\Rightarrow$ 勾股」，反向限实空间。
E8 | 1.5 课件注编号 | 注 1、2、3、4、5，页 18 又出现「注 4」，无「注 6」 | 编号重复且缺号；本教程按出现顺序重排为注 1–6。
E9 | 1.6 课件页 11（例 1.6.4 证明 (1)） | 由「$A\boldsymbol{x}=\boldsymbol{x}$、$A\boldsymbol{y}=\boldsymbol{0}$」直接「令 $\boldsymbol{y}=\boldsymbol{x}$」 | 缺关键交代：$\boldsymbol{x}\in R(A)$ 与 $\boldsymbol{y}\in R(I-A)$ 取自不同子空间。应取 $\boldsymbol{w}\in R(A)\cap R(I-A)$，则 $A\boldsymbol{w}=\boldsymbol{w}$ 且 $A\boldsymbol{w}=\boldsymbol{0}$，故 $\boldsymbol{w}=\boldsymbol{0}$。详见 [1.6.4](sec16.md#sec-1.6.4)。
E10 | 1.5 课件例 1.5.2 | 由三角函数系两两正交，直接称其为光滑函数空间 $S$ 的「正交基」 | 混淆了本章的 Hamel 基与傅里叶分析中的完备正交系。有限线性组合只能得到三角多项式，不能覆盖全部光滑函数；在 $L^2[-\pi,\pi]$ 中可把规范化三角函数系称为完备正交系，并在 $L^2$ 收敛意义下讨论展开。详见 [1.5.7](sec15.md#sec-1.5.7)。
E11 | 1.6（下）课件页 4–6（定理 1.6.2–1.6.4、定义 1.6.5–1.6.7） | 前提写作「线性空间 $V$」 | 应为**内积空间**：「$W_1\perp W_2$」「$W_1^{\perp}$」离开内积没有定义（课件自己在定义 1.6.3、1.6.4 处写的是内积空间）。详见 [1.6.5](sec16.md#sec-1.6.5)。
E12 | 1.6（下）课件页 9（例 1.6.6 方法二） | 提前使用下一页命题 1.6.1 的投影公式，且未指出 $\boldsymbol{x}_1\perp\boldsymbol{x}_2$ | 公式 $\operatorname{Proj}_{W}\boldsymbol{x}=\sum\frac{(\boldsymbol{x},\boldsymbol{x}_i)}{\|\boldsymbol{x}_i\|^2}\boldsymbol{x}_i$ **只对正交基成立**；本题基恰好正交使公式合法，但课件未交代。基不正交时须先正交化或解 Gram 方程组。详见 [1.6.7](sec16.md#sec-1.6.7)。
E13 | 1.6（下）课件页 10（定理 1.6.5） | 「内积空间必存在标准正交基」，未限定维数 | 按 Hamel 基理解，该陈述在无限维**不**成立：可分无穷维 Hilbert 空间的正交向量组至多可数，而其 Hamel 基必不可数（Baire 纲论证）。应限定「$n$ 维（有限维）内积空间」，与 E10 的「完备正交系」边界呼应。详见 [1.6.8](sec16.md#sec-1.6.8)。
E14 | 1.6（下）课件页 16–17（页眉） | 页眉作「向量长度与夹角」 | 两页（小结、例 1.6.7）系沿用 1.5 课件模板未改页眉，应为「直和与投影」。
E15 | 1.6（下）课件页 4、8、14–16 | 排版与图文小疵若干 | ① 小结「基本概念」以顿号收尾、「重要结论」漏收定理 1.6.3、1.6.4；② 页 4 插图含正文未定义的 $W_3$；③ 页 15 矩阵下三角的 $0$ 只印出左下角一个；④ 页 8 上标误用粗体数字、页 14 末尾 $\boldsymbol{y}_i$ 误排细体、原点记号 $O$/$o$ 不一致。均不影响数学内容，详见 [1.6.10](sec16.md#sec-1.6.10)。

::: note 非错误的两点说明（避免误会的澄清）

① 1.2 课件页 9 定理 1.2.1 条件 (2)a 中「$\forall k\in F$」并非多余——$k=0$ 正是「零元 $\in W$」的隐藏来源。
② 1.1 课件页 4 例 1.1.5 中 $A^2=2A-I$ 本身正确，错误仅出现在页 30 的 $A^3$。
③ 1.5 课件页 5 定理 1.5.1 的等号条件、页 9 例 1.5.1 的面积公式**均无错误**（前者原本就写了模 $|(\boldsymbol{x},\boldsymbol{y})|=\|\boldsymbol{x}\|\|\boldsymbol{y}\|$，后者明确限定 $\mathbb R^2$）——这两处曾因 PDF 文本层丢失符号而疑似有误，逐页核对图片后确认原课件正确，特此说明。
:::
