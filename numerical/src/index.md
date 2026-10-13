<section class="chapter-cover">
<div class="kicker">数 值 分 析 · 定 制 教 程</div>
<h1>从误差到谱：数值方法的语言</h1>
<div class="subtitle">第一章 绪论：误差、算法与范数 · 第二章 数值线性代数基础：内积、正交、投影与 SVD —— 依据颜庆津《数值分析》（第 4 版）整理扩充的定制教程</div>
<div class="cover-chips">
<span>2 章 · 11 节正文 + 课堂精编 7 讲 + 复习层 4 页</span>
<span>第一卷：原书 p.1–13 全收录 · 0 勘误 · 4 处证明补全</span>
<span>第二卷：内积 / 投影 / QR / 条件数 / 谱 / SVD</span>
<span>课堂精编：2026 秋《数值分析 I》庞刚 · 逐讲实录归纳</span>
<span>40 道习题 · 全部附解</span>
<span>7 组可复现数值实验</span>
<span>阅读分层：定义 / 定理 / 速查表标为「必记骨架」，一键切到「只看核心」</span>
</div>
<div class="meta">
依据 <b>颜庆津《数值分析》（第 4 版）</b>整理扩充：第一章对应原书第 1 章，原书定理 1.1–1.5、例 1–6、习题 1–15 全部收录，括注中保留原编号，可逐条对照<br>
第二章对标原书 1.3 节并大幅扩充（内积与正交、四个基本子空间与投影、QR 分解、条件数与扰动、谱理论、SVD）——现代数值线性代数的最小完备工具箱<br>
所有例题与实验数值均经 Python 逐条复算，书中输出都是真实运行结果 · 整理日期：2026 年 9 月
</div>
</section>

<section class="study-paths" aria-label="建议学习路径">
<article class="study-path">
<span class="path-kicker">25 MIN · QUICK START</span>
<strong>先看懂主线</strong>
<p>先读课程知识地图与两章导览，建立「误差 → 尺子 → 正交结构 → 谱」的全局图。</p>
<a href="preface-map.md">开始快速预习 →</a>
</article>
<article class="study-path">
<span class="path-kicker">ENTRY TEST · 15 MIN</span>
<strong>先测出自己的起点</strong>
<p>先做入学诊断自测，按得分决定从 1.1 通读，还是直接跳到第二章。</p>
<a href="entry-test.md">进入诊断自测 →</a>
</article>
<article class="study-path">
<span class="path-kicker">120 MIN · STANDARD</span>
<strong>按概念链通读</strong>
<p>每节先看学习简报，顺着蓝色「直觉」框读懂每个概念的白话版；证明第一遍跳过，二刷再亲手补全。</p>
<a href="ch01/sec11.md">从 1.1 开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">MASTERY · PRACTICE</span>
<strong>用题目与实验检验掌握</strong>
<p>先独立作答每章 A / B / C / D 四组题，再展开解答；跑通全部七组实验并提交报告。</p>
<a href="ch02/exercises.md">进入第二章习题 →</a>
</article>
<article class="study-path">
<span class="path-kicker">REVIEW · 2 HOURS</span>
<strong>考前一晚只看这四页</strong>
<p>公式与结论卡 → 易混对照卡 → 自检表 → 三句话带走；精确到页的路线见「最小必读路径」。</p>
<a href="review/study-paths.md">进入复习层 →</a>
</article>
<article class="study-path">
<span class="path-kicker">COURSE · 跟课堂</span>
<strong>对照老师讲的逐讲复习</strong>
<p>2026 秋《数值分析 I》七讲精编：每讲页首是「10 分钟复习版」（结论 + 公式 + 考点），页身是板书例题、推导细节与 AI 转写订正。</p>
<a href="lectures/overview.md">进入课堂精编 →</a>
</article>
</section>

## 本教材怎么读

全书按「卷首 → 学前准备 → 各章正文 → 各章章末 → 课堂精编 → 复习与查阅」组织。**正文是「学」的地方，复习层是「记」和「查」的地方**——公式卡、易混对照、术语索引、最小必读路径这四页，专门解决「内容都读过、却记不住也找不到」。正在跟课的同学，可在每章章末之后接着读对应的讲座精编（对照关系见[知识地图](preface-map.md)末尾的课堂精编对照表）。左侧目录是唯一的导航入口，页面顶部有全文搜索（或按 <kbd>/</kbd>），页脚与键盘 <kbd>←</kbd> <kbd>→</kbd> 可翻页；下面按阅读顺序列出各页。

<div class="index-cards">
<a href="entry-test.md">
  <span class="no">0</span>
  <span class="t">学前准备 · 诊断自测与知识地图</span>
  <span class="d">12 道诊断题（含答案与去向建议） · 先修工具箱 · 两章概念主干图</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec11.md">
  <span class="no">1.1</span>
  <span class="t">数值分析的研究对象</span>
  <span class="d">科学计算的翻译链条 · 四个关键词 · 预告实验：$(\sqrt2-1)^6$ 六个等价公式差 5 个数量级</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec12.md">
  <span class="no">1.2</span>
  <span class="t">误差知识与算法知识</span>
  <span class="d">误差四分类 · 绝对/相对误差与有效数字 · 误差传播与四则公式 · 秦九韶 · 设计四原则 · IEEE 754 · 向后误差</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec13.md">
  <span class="no">1.3</span>
  <span class="t">向量范数与矩阵范数</span>
  <span class="d">三公理与四公理 · $\lVert\boldsymbol{x}\rVert_p$ 与五个矩阵范数 · 等价与相容（补全证明） · 定理 1.3.6 与 Neumann 级数</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/application.md">
  <span class="no">1.末</span>
  <span class="t">第一章 · 真实应用案例</span>
  <span class="d">GPS 定位的误差预算 · 灾难性抵消的工程事故 · 从有效数字到定位精度</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec21.md">
  <span class="no">2.1</span>
  <span class="t">内积、正交性与正交矩阵</span>
  <span class="d">内积公理与加权内积 · 正交 / 标准正交基 · 正交矩阵十条件 · 正交变换保范数</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec22.md">
  <span class="no">2.2</span>
  <span class="t">四个基本子空间与投影</span>
  <span class="d">列空间 / 零空间 / 行空间 / 左零空间 · 正交分解定理 · 投影矩阵 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ · 最小二乘</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec23.md">
  <span class="no">2.3</span>
  <span class="t">正交化与 QR 分解</span>
  <span class="d">Gram–Schmidt 与修正 Gram–Schmidt · Householder 反射 · Givens 旋转 · 复杂度与稳定性对比</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec24.md">
  <span class="no">2.4</span>
  <span class="t">条件数与扰动分析</span>
  <span class="d">$\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$ · 右端 / 系数扰动界 · 成分条件数与 Skeel 条件数 · Hilbert 矩阵</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec25.md">
  <span class="no">2.5</span>
  <span class="t">特征值、谱半径与对称谱理论</span>
  <span class="d">特征值 / 谱半径 / $\rho(A)\le\lVert A\rVert$ · Gerschgorin 圆盘 · Rayleigh 商与 Courant–Fischer · Jordan 敏感性</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec26.md">
  <span class="no">2.6</span>
  <span class="t">奇异值分解与低秩逼近</span>
  <span class="d">SVD 的两种几何读法 · 与四子空间的关系 · von Neumann 迹不等式 · Eckart–Young · 数值秩与伪逆 · PCA 预告</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec27.md">
  <span class="no">2.7</span>
  <span class="t">第二章 · 数值实验</span>
  <span class="d">四种 QR 方法的正交性实测 · 条件数与有效数字 · 低秩逼近与图像压缩</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/summary.md">
  <span class="no">末</span>
  <span class="t">两章总结 · 习题集 · 自检表</span>
  <span class="d">主线回顾 · 三句话带走 · 每章 20 题全部附解（默认折叠） · 学习目标自检</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/overview.md">
  <span class="no">课</span>
  <span class="t">课堂精编 · 2026 秋实录（庞刚）</span>
  <span class="d">七讲逐讲归纳：误差理论 → 范数 → 高斯消去与列主元 → LU 分解 → 迭代收敛理论与 Jacobi / Gauss–Seidel → SOR → 幂法与反幂法、非线性方程开篇 · 每讲页首有「10 分钟复习版」· 板书例题全公式还原 · 口述错词订正表</span>
  <span class="go">进入 →</span>
</a>
<a href="review/formula-cards.md">
  <span class="no">复</span>
  <span class="t">复习层 · 公式卡 / 对照卡 / 术语索引 / 必读路径</span>
  <span class="d">两章必记公式压成一页 · 16 对易混概念逐对辨析 · 约 90 条术语中英对照 · 按时间与目的规划的四条精确路线</span>
  <span class="go">进入 →</span>
</a>
</div>

<p class="kbd-hint">提示：解答默认折叠，点击「解答」展开；习题页有「展开全部解答」按钮；打印时自动展开全部解答。正文开头有<b>「只看核心」</b>开关，可折叠全部证明与课程预告，只留定义、定理、速查表与错误清单。</p>
