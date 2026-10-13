<section class="chapter-cover">
<div class="kicker">矩 阵 论 · 第 一 章 · 第 二 章（2.1–2.5）· 第 三 章（3.1–3.2）</div>
<h1>线性空间引论 · 线性映射与矩阵 · 矩阵分解</h1>
<div class="subtitle">第一章：从「什么能相加」走到「怎样唯一分解」——建立线性代数的语言、坐标与几何 · 第二章：从「两个空间怎么连」走到「映射与矩阵是一回事」——映射的语言、线性映射、矩阵与同构、特征值与特征向量、正交与酉变换 · 第三章：从「能拆成什么」走到「秩与列空间的骨架」——相抵分解与满秩分解</div>
<div class="cover-chips">
<span>先讲问题，再给定义</span>
<span>例子与反例成对出现</span>
<span>证明解释「为什么这样想」</span>
<span>提示、解答、验算分层</span>
<span>读完即可自测与反查</span>
</div>
<div class="meta">
依据本课程六节（七份）课件整理扩充：<b>1.1 线性空间（31 页）· 1.2 线性子空间（21 页）· 1.3 基与坐标（25 页）· 1.4 内积空间（18 页）· 1.5 向量长度与夹角（19 页）· 1.6 直和与投影（14+18 页，上 / 下两份）</b><br>
全部定义、定理、例题保留原编号，可与课件逐条对照 · 补全关键证明 · 原课件问题已修正并列入勘误表<br>
<b>第二章（2.1–2.5）</b>：2.1–2.2 依据第二章课件与第 3 周录播（2026-09-22，王振乾）整理（亏加秩定理证明已按课堂路线补完）；<b>2.3 矩阵与同构</b>依据同期入库的官方课件整理（无录播，课件省略的证明已补全）；<b>2.4 特征值与特征向量 · 2.5 正交变换与酉变换</b>依据第 5 周录播（2026-10-08）转录整理（课件尚未入库，盒子自动编号）· 2.6–2.7 待素材到位续写<br>
<b>第三章（3.1–3.2）</b>：<b>3.1 相抵分解 · 3.2 满秩分解</b>依据同期入库的官方课件整理（两节均无录播；课件省略的证明已补全，记号循环与表述问题已列入勘误）· 3.3 及以后待素材到位续写<br>
新增例题与习题均不超出本课程所讲授的概念范围 · 整理日期：2026 年 9 月（2.4–2.5 补于 2026-10-11，3.1–3.2 补于 2026-10-13）
</div>
</section>

## 这一章其实只做三件事

1. **规定规则。**线性空间回答「哪些对象、按什么运算，可以稳定地做加法与数乘」；子空间回答「哪些局部仍守同一套规则」。
2. **压缩信息。**基挑出一组不冗余的生成元，坐标把抽象向量压缩成一列数，维数记录需要多少个独立方向。
3. **加入几何并学会分解。**内积带来长度、夹角与正交；直和保证拆法唯一，投影把「取出某个分量」变成可计算的操作。

读到任何一节感到名词变多时，回到这三件事，问一句：**眼前这个定义究竟在解决规则、表示，还是分解的问题？**

<section class="study-paths" aria-label="建议学习路径">
<article class="study-path">
<span class="path-kicker">15 MIN · 先定位</span>
<strong>入学诊断</strong>
<p>14 道小题测一测先修与本章预诊，据此决定从哪一节开始读。</p>
<a href="entry-test.md">开始诊断 →</a>
</article>
<article class="study-path">
<span class="path-kicker">25 MIN · QUICK START</span>
<strong>先看懂主线</strong>
<p>读知识地图与六节总结，先建立「空间 → 子空间 → 基 → 内积 → 度量与正交 → 直和」的全局图。</p>
<a href="preface-map.md">开始快速预习 →</a>
</article>
<article class="study-path">
<span class="path-kicker">90 MIN · STANDARD</span>
<strong>按概念链通读</strong>
<p>每节先看学习简报，再读定义、定理与例题，节末做「即时自测」回忆一遍。</p>
<a href="ch01/sec11.md">从 1.1 开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">90 MIN · MASTERY</span>
<strong>自测卷验收</strong>
<p>闭卷计时做完综合自测卷（100 分制），按评分标准反查薄弱概念。</p>
<a href="ch01/mock-exam.md">进入自测卷 →</a>
</article>
</section>

## 本教程怎么读

全书按「卷首 → 学前准备 → 三章正文 → 章末 → 附录」组织（第一章六节、第二章五节、第三章两节，另有两个附录：正文悬置结论的完整推导与跨学科联系）。左侧目录是唯一的导航入口，页面顶部有全文搜索（或按 <kbd>/</kbd>），页脚与键盘 <kbd>←</kbd> <kbd>→</kbd> 可翻页。下面按阅读顺序列出各页：

<div class="index-cards">
<a href="entry-test.md">
  <span class="no">测</span>
  <span class="t">入学诊断 · 先修工具箱</span>
  <span class="d">14 道小题定位起点 · 矩阵乘法列观点、可逆等价、秩与自由未知量等先修事实集中复习</span>
  <span class="go">进入 →</span>
</a>
<a href="preface.md">
  <span class="no">0</span>
  <span class="t">先读这一页 · 学习方法</span>
  <span class="d">三条阅读路线 · 六个概念问题 · 三遍阅读法 · 怎样读证明与使用查阅页</span>
  <span class="go">进入 →</span>
</a>
<a href="proof-workshop.md">
  <span class="no">证</span>
  <span class="t">证明怎么下笔 · 六种骨架</span>
  <span class="d">已知—要证—桥梁—收口 · 子空间、唯一性、无关性、集合相等、等价命题与维数证明的固定入口</span>
  <span class="go">开始练 →</span>
</a>
<a href="ch01/sec11.md">
  <span class="no">1.1</span>
  <span class="t">线性空间</span>
  <span class="d">数域 · 加群与八条公理 · 基本性质四条 · 线性组合与表示（含勘误 E1）· 常见空间例库</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec12.md">
  <span class="no">1.2</span>
  <span class="t">线性子空间</span>
  <span class="d">子空间判定定理 · 交空间与和空间 · 对称/反对称分解 · 零空间 N(A) 与列空间 R(A)</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec13.md">
  <span class="no">1.3</span>
  <span class="t">基与坐标</span>
  <span class="d">线性相关性（Casorati）· 唯一表示定理 · 基与坐标 · 过渡矩阵 · 维数公式（含勘误 E2）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec14.md">
  <span class="no">1.4</span>
  <span class="t">内积空间</span>
  <span class="d">内积公理 · 标准内积 · Hermite 与正定矩阵 · Gram 矩阵 · 换基与矩阵合同（含勘误 E3 / E4）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec15.md">
  <span class="no">1.5</span>
  <span class="t">向量长度与夹角</span>
  <span class="d">长度与四条性质 · Cauchy–Schwarz 不等式 · 夹角与正交 · Gram 行列式 = 面积² · Gram–Schmidt 正交化 · 代数基与完备正交系的边界（含勘误 E5–E8、E10）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec16.md">
  <span class="no">1.6</span>
  <span class="t">直和与投影</span>
  <span class="d">直和与直和分解 · 判定定理四条等价 · 投影与求法 · 幂等矩阵 $A^2=A$ 的值域 $\dotplus$ 零空间分解 · 正交子空间与正交补 · 正交投影两法与投影公式 · Gram–Schmidt 正线上三角过渡矩阵 · $\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$（含勘误 E9、E11–E13）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/summary.md">
  <span class="no">末</span>
  <span class="t">全章总结 · 勘误表</span>
  <span class="d">六节一览与概念主线 · 解题决策表 · 原课件十五处问题（E1–E15）及理由</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/recall-cards.md">
  <span class="no">忆</span>
  <span class="t">闭卷回忆卡 · 定义与定理</span>
  <span class="d">11 张定义卡 · 12 张定理卡 · 条件、结论、证明第一行 · 当天 / 1 / 3 / 7 天间隔复习</span>
  <span class="go">开始回忆 →</span>
</a>
<a href="ch01/exercises.md">
  <span class="no">练</span>
  <span class="t">习题集 · 自检表</span>
  <span class="d">A 概念 16 题 · B 证明 14 题 · C 计算 17 题，全部附解答（默认折叠，难题另给提示）· 学习目标自检表</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/mock-exam.md">
  <span class="no">考</span>
  <span class="t">综合自测卷 · 100 分</span>
  <span class="d">概念 10 题 · 计算 5 题 · 证明 2 题（共 17 题、90 分钟、100 分），全部新增且附评分标准与复盘方法</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec21.md">
  <span class="no">2.1</span>
  <span class="t">映射与多项式</span>
  <span class="d">映射 → 单 / 满 / 双射 → 复合与逆 → 变换与置换 · 等势与可数性 · 带余除法、公因式、友矩阵 · 第 3 周录播</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec22.md">
  <span class="no">2.2</span>
  <span class="t">线性映射</span>
  <span class="d">定义与十二例 · 保持线性组合 · 单射判据（去年考题）· $L(V,W)$ · 零空间与值域 · 亏加秩定理（基扩充证明）· 第 3 周录播</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec23.md">
  <span class="no">2.3</span>
  <span class="t">矩阵与同构</span>
  <span class="d">矩阵的读法（第 $j$ 列 $=$ 基像的坐标）· 存在唯一性 · 同构 ⟺ 维数相等 · $\beta=A\alpha$ · 换基 $B=P^{-1}AQ$ 与相似 · 矩阵的秩 $=$ 映射的秩 · 官方课件</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec24.md">
  <span class="no">2.4</span>
  <span class="t">特征值与特征向量</span>
  <span class="d">特征值与特征向量的翻译 · 特征子空间 · 几何重数与代数重数 · 相似不变量 · 设计基使矩阵为指定形式 · 依第 5 周录播整理</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec25.md">
  <span class="no">2.5</span>
  <span class="t">正交变换与酉变换</span>
  <span class="d">正交矩阵与酉矩阵 · 四条等价刻画 · 特征值的模为 1 · Givens 旋转 · Householder 反射 · 依第 5 周录播整理</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/summary.md">
  <span class="no">二末</span>
  <span class="t">第二章总结（2.1–2.5）</span>
  <span class="d">五节一览 · 主线与四句话 · 母题 · 素材状态与后续 · 勘误与口述订正 · 习题 · 自检表</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec31.md">
  <span class="no">3.1</span>
  <span class="t">相抵分解</span>
  <span class="d">相抵分解式 $A=P^{-1}\Gamma Q$ 与标准形 · 分解不唯一 / 标准形唯一 · 分块矩阵法求 $P$、$Q$ · 用标准形解方程组 · 右逆与左逆 · $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ · 官方课件</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec32.md">
  <span class="no">3.2</span>
  <span class="t">满秩分解</span>
  <span class="d">满秩分解定理 $A=BC$（基 $\times$ 坐标）· 两条构造与 RREF 算法 · 不唯一 $=$ 相差可逆因子 $D$ · 矩阵方程 $AXA=A$ · 伪逆预告 · 官方课件</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/summary.md">
  <span class="no">三末</span>
  <span class="t">第三章总结（3.1–3.2）</span>
  <span class="d">两节一览 · 主线与四句话 · 母题 · 勘误与补注（E3.1–E3.4）· 习题 38 题 · 自测卷 · 自检表 26 条</span>
  <span class="go">进入 →</span>
</a>
<a href="appendix/appendix-a.md">
  <span class="no">附 A</span>
  <span class="t">附录 A · 延伸证明与推导</span>
  <span class="d">极化恒等式 · Gram 行列式与 Hadamard 不等式 · 迹与行列式 · 几何重数 ≤ 代数重数 · Cayley–Hamilton · 正定矩阵开方 · Bessel 与 Parseval · Moore–Penrose 伪逆（超出考核范围）</span>
  <span class="go">进入 →</span>
</a>
<a href="appendix/appendix-b.md">
  <span class="no">附 B</span>
  <span class="t">附录 B · 走向其他学科</span>
  <span class="d">量子力学（C–S 即概率合法）· 信号处理（DFT 酉性）· 最小二乘与 PCA · 数值分析（QR 路线）· 微分方程（$\mathrm e^{At}$）· 低秩近似与推荐系统（超出考核范围）</span>
  <span class="go">进入 →</span>
</a>
</div>

<p class="kbd-hint">提示：解答默认折叠，点击「解答」展开；难题另有「提示」层，先看提示再自己推；习题页有「展开全部解答」按钮；打印时会自动展开全部折叠内容。</p>
