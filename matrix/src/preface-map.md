# 全章知识地图

第一章六节（七份）课件的概念链条一环扣一环：前三节先搭好线性结构与坐标系统，第 [1.4](ch01/sec14.md) 节用内积为这个坐标世界加入几何，[1.5](ch01/sec15.md) 从内积里提炼出长度、夹角与正交并给出正交化算法，[1.6](ch01/sec16.md) 研究拆法唯一的和与投影——从幂等矩阵一直收束到正交补与四个基本子空间。学习时建议按箭头顺序自检「前一环是否真正懂了」。

<figure>
<svg aria-labelledby="fig-map-title fig-map-desc" role="img" height="470" viewBox="0 0 920 470" width="920" xmlns="http://www.w3.org/2000/svg">
<title id="fig-map-title">第一章概念链条地图</title>
<desc id="fig-map-desc">按箭头顺序展示第一章六节的概念依赖：1.1 线性空间 → 1.2 线性子空间 → 1.3 基与坐标 → 1.4 内积空间 → 1.5 长度与夹角 → 1.6 直和与投影；每个方框内是该节的枢纽概念。</desc>
<defs>
<marker id="arr" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<!-- 第0行 -->
<g font-size="13.5" text-anchor="middle">
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="150" x="10" y="18"></rect><text fill="var(--fig-blue)" x="85" y="43">数域 F（1.1）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="170" x="200" y="18"></rect><text fill="var(--fig-blue)" x="285" y="43">集合 + 运算（1.1）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="200" x="410" y="18"></rect><text fill="var(--fig-purple)" x="510" y="43">线性空间（八条公理，1.1）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="650" y="18"></rect><text fill="var(--fig-blue)" x="750" y="43">常见空间例库（1.1）</text>
<!-- 第1行 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="220" x="30" y="128"></rect><text fill="var(--fig-blue)" x="140" y="153">线性组合 / 线性表示（1.1）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="330" y="128"></rect><text fill="var(--fig-green)" x="430" y="153">子空间 + 判定定理（1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="250" x="600" y="128"></rect><text fill="var(--fig-green)" x="725" y="153">交空间 / 和空间（1.2）</text>
<!-- 第2行 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="180" x="10" y="238"></rect><text fill="var(--fig-gold)" x="100" y="263">span 张成（1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="230" y="238"></rect><text fill="var(--fig-gold)" x="315" y="263">N(A) 零空间（1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="440" y="238"></rect><text fill="var(--fig-gold)" x="525" y="263">R(A) 列空间（1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="200" x="650" y="238"></rect><text fill="var(--fig-purple)" x="750" y="263">线性相关 / 无关（1.3）</text>
<!-- 第3行 -->
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="180" x="90" y="348"></rect><text fill="var(--fig-purple)" x="180" y="373">极大无关组与秩（1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="140" x="330" y="348"></rect><text fill="var(--fig-purple)" x="400" y="373">基（1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="140" x="510" y="348"></rect><text fill="var(--fig-purple)" x="580" y="373">坐标（1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="200" x="690" y="348"></rect><text fill="var(--fig-purple)" x="790" y="373">过渡矩阵（1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="260" x="380" y="420"></rect><text fill="var(--fig-green)" x="510" y="445">维数 + 维数公式（1.3）</text>
</g>
<g fill="none" marker-end="url(#arr)" stroke="var(--muted)" stroke-width="1.4">
<path d="M160,38 L200,38"></path>
<path d="M370,38 L410,38"></path>
<path d="M610,38 L650,38"></path>
<path d="M660,58 L660,80 L480,80 L480,128"></path>
<path d="M300,58 L300,90 L180,90 L180,128"></path>
<path d="M510,58 L510,100 L430,100 L430,128"></path>
<path d="M250,168 L330,168"></path>
<path d="M250,148 L330,148"></path>
<path d="M530,168 L600,168"></path>
<path d="M140,168 L110,200 L100,238"></path>
<path d="M330,168 L318,238"></path>
<path d="M530,168 L524,238"></path>
<path d="M750,168 L750,238"></path>
<path d="M100,278 L100,310 L180,348"></path>
<path d="M270,278 L330,348"></path>
<path d="M400,368 L470,368 L470,348"></path>
<path d="M470,368 L510,368"></path>
<path d="M580,368 L690,368"></path>
<path d="M250,368 L300,440"></path>
<path d="M600,388 L580,420"></path>
<path d="M790,388 L620,440"></path>
</g>
</svg>
<figcaption>图 0-1 · 第一章线性结构主干（1.1 → 1.2 → 1.3）</figcaption>
</figure>

<figure class="concept-figure">
<svg aria-labelledby="fig-map14-title fig-map14-desc" role="img" viewBox="0 0 920 210" xmlns="http://www.w3.org/2000/svg">
<title id="fig-map14-title">从线性结构到内积几何的概念链</title>
<desc id="fig-map14-desc">基与坐标连接到内积，再连接到正定 Hermite 矩阵和度量矩阵；换基时度量矩阵作合同变换。</desc>
<defs><marker id="arr14" markerHeight="10" markerWidth="10" orient="auto" refX="8" refY="3"><path d="M0,0 L8,3 L0,6 Z" fill="var(--muted)"></path></marker></defs>
<g text-anchor="middle">
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="164" x="22" y="44"></rect><text fill="var(--fig-purple)" font-size="15" x="104" y="69">基与坐标</text><text fill="var(--fig-purple)" font-size="12" x="104" y="90">线性结构（1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="164" x="240" y="44"></rect><text fill="var(--fig-gold)" font-size="15" x="322" y="69">内积四公理</text><text fill="var(--fig-gold)" font-size="12" x="322" y="90">加入几何（1.4）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="186" x="458" y="22"></rect><text fill="var(--fig-green)" font-size="15" x="551" y="47">正定 Hermite 矩阵</text><text fill="var(--fig-green)" font-size="12" x="551" y="68">构造内积</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="186" x="458" y="112"></rect><text fill="var(--fig-blue)" font-size="15" x="551" y="137">度量（Gram）矩阵</text><text fill="var(--fig-blue)" font-size="12" x="551" y="158">坐标中的内积</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 12%, transparent)" height="58" rx="12" stroke="var(--line)" width="190" x="704" y="75"></rect><text fill="var(--fig-gold)" font-size="15" x="799" y="100">换基：合同变换</text><text fill="var(--muted)" font-size="12" x="799" y="121">同一几何，不同坐标</text>
</g>
<g fill="none" marker-end="url(#arr14)" stroke="var(--muted)" stroke-width="1.6"><path d="M186 73H232"></path><path d="M404 63L450 52"></path><path d="M404 84L450 126"></path><path d="M644 141L696 113"></path></g>
</svg>
<figcaption>图 0-2 · 第 1.4 节把「抽象内积」翻译成「坐标里的正定 Hermite 矩阵」</figcaption>
</figure>

<figure class="concept-figure">
<svg aria-labelledby="fig-map156-title fig-map156-desc" role="img" viewBox="0 0 920 240" xmlns="http://www.w3.org/2000/svg">
<title id="fig-map156-title">从内积到长度、正交、直和与投影</title>
<desc id="fig-map156-desc">内积给出长度与 Cauchy–Schwarz，由此得到夹角与正交；正交化把基化为标准正交基，使度量矩阵成为单位矩阵；子空间的和在交为零时成为直和，直和分解给出投影，幂等矩阵把投影编码进矩阵；正交补让投影成为「垂直落下」的法定运算，任意方阵自带 N(A) 与 R(Aᴴ) 的正交分解。</desc>
<defs><marker id="arr156" markerHeight="10" markerWidth="10" orient="auto" refX="8" refY="3"><path d="M0,0 L8,3 L0,6 Z" fill="var(--muted)"></path></marker></defs>
<g text-anchor="middle">
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="18" y="90"></rect><text fill="var(--fig-gold)" font-size="15" x="103" y="115">内积四公理</text><text fill="var(--fig-gold)" font-size="12" x="103" y="136">几何的起点（1.4）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="180" x="230" y="20"></rect><text fill="var(--fig-green)" font-size="15" x="320" y="45">长度 + C-S 不等式</text><text fill="var(--fig-green)" font-size="12" x="320" y="66">全部几何不等式的源头（1.5）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="180" x="230" y="160"></rect><text fill="var(--fig-blue)" font-size="15" x="320" y="185">夹角 + 正交</text><text fill="var(--fig-blue)" font-size="12" x="320" y="206">夹角限实空间，正交通用（1.5）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="196" x="454" y="20"></rect><text fill="var(--fig-purple)" font-size="15" x="552" y="45">正交组 / Gram–Schmidt</text><text fill="var(--fig-purple)" font-size="12" x="552" y="66">正交组必无关；正交化（1.5）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="180" x="454" y="160"></rect><text fill="var(--fig-green)" font-size="15" x="544" y="185">标准正交基 ⟺ G = I</text><text fill="var(--fig-green)" font-size="12" x="544" y="206">内积退化为坐标内积（1.5）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="210" x="694" y="20"></rect><text fill="var(--fig-blue)" font-size="15" x="799" y="45">直和（交为零 + 维数相加）</text><text fill="var(--fig-blue)" font-size="12" x="799" y="66">拆法唯一的和（1.6）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="58" rx="12" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="210" x="694" y="160"></rect><text fill="var(--fig-gold)" font-size="15" x="799" y="185">投影：幂等 A² = A</text><text fill="var(--fig-gold)" font-size="12" x="799" y="206">R(A) ∔ N(A)；例 1.6.7（1.6）</text>
</g>
<g fill="none" marker-end="url(#arr156)" stroke="var(--muted)" stroke-width="1.6">
<path d="M188 110 L222 60"></path>
<path d="M188 130 L222 178"></path>
<path d="M410 36 L446 44"></path>
<path d="M410 182 L446 190"></path>
<path d="M660 44 L686 44"></path>
<path d="M660 190 L686 190"></path>
<path d="M799 78 L799 152"></path>
</g>
</svg>
<figcaption>图 0-3 · 第 1.5 节把内积「榨」成几何量，第 1.6 节把子空间的和升级为直和与投影，并收束到四个基本子空间</figcaption>
</figure>

一句话主线：**先规定「什么样的集合能做线性运算」（[1.1](ch01/sec11.md)），再找出其中封闭的部分（[1.2](ch01/sec12.md)），用基给空间装上坐标系并得到维数（[1.3](ch01/sec13.md)）；内积赋予长度、夹角与正交（[1.4](ch01/sec14.md)），从中提炼出 Cauchy–Schwarz、正交化与标准正交基（[1.5](ch01/sec15.md)）；最后研究拆法唯一的和（直和）与投影——幂等矩阵 $A^2=A$ 一次把分解与投影全部编码，正交补让投影「垂直落下」，任意方阵自带 $\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$（[1.6](ch01/sec16.md)）。**

## 第二章 · 线性映射与矩阵（2.1–2.5）

第一章给单个空间装上坐标；第二章把两个空间**连起来**。已整理部分的概念链：

> **先备好映射的语言（[2.1](ch02/sec21.md)：单射 / 满射 / 双射 → 复合与逆 → 变换，并用「双射」这把尺子量无穷集合；多项式工具箱就位）→ 再给映射加上与线性运算相容的要求（[2.2](ch02/sec22.md)：定义 → 十二个例子 → 保持线性组合 → 单射判据 → 线性映射空间 $L(V,W)$）→ 用零空间与值域两个不变量收束，亏加秩定理给出维数守恒：$\dim N(T)+\dim R(T)=\dim V$ → 取定基，把这一切「翻译」成矩阵（[2.3](ch02/sec23.md)：矩阵的列就是基像的坐标 → 存在唯一性 → 同构 ⟺ 维数相等 → 坐标公式 $\beta=A\alpha$ → 换基 $B=P^{-1}AQ$ 与相似）→ 面对相似，自然要问「能否相似于对角阵」，于是把「方向不变」翻译成特征值与特征向量（[2.4](ch02/sec24.md)：特征对 → 特征子空间 → 几何 / 代数重数 → 设计基使矩阵为指定形式）→ 在内积空间里进一步要求基变换保持长度与夹角，得到正交与酉变换（[2.5](ch02/sec25.md)：正交 / 酉矩阵 → 四条等价刻画 → Givens 旋转与 Householder 反射）。**

2.3 是三件事的合流：**映射的语言**（2.1）、**线性与不变量**（2.2）、**坐标与基**（第一章 1.3）在「矩阵」这个对象上会师——从此抽象的线性问题可以拿笔算。

2.4–2.5 把「选一组好基」变成一门正经的学问：**相似不变的是特征值**，而**在保持度量的前提下换基**（正交 / 酉变换）既不改变长度与夹角，也把特征值逼到单位圆上——Givens 与 Householder 是两种可精确控制、可手算的初等酉变换。

向下游：应用：图的矩阵表示（2.6）→ 章节测验（2.7）。**待素材到位后，本节地图与结构图将同步补全。**

## 第三章 · 矩阵分解（3.1–3.2、3.4–3.7）

前两章把矩阵讲成「线性映射的坐标版」；第三章换一个方向：**不再问矩阵表示什么，而问它能拆成什么**。已整理六节，概念链可以按三组读：

**第一组 · 相抵 → 满秩（3.1–3.2）**

> 把矩阵分解为较简单或具有某种特性的若干矩阵的乘积或和（课件的类比：$36=4\times9=2^2\times3^2$——同一个对象，换一种写法就多看见一层性质）→ 最朴素的分解是「相抵」：左右各乘可逆矩阵，把任何矩阵压成只由秩决定的标准形 $\Gamma$（[3.1](ch03/sec31.md)：$A=P^{-1}\Gamma Q$ → 分解式不唯一、标准形唯一 → 相抵 $\iff$ 同秩 → 分块矩阵法求 $P$、$Q$ → 用它解方程组、判单侧逆 → 秩等式 $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 给出闭式单侧逆）→ 再换一副「眼镜」：不许乘可逆矩阵，把 $A$ 直接写成两个满秩矩阵之积 $A=BC$（[3.2](ch03/sec32.md)：$B$ 的列是 $R(A)$ 的基、$C$ 是坐标表 → 两条构造与 RREF 算法 → 不唯一的精确刻画：相差可逆因子 $D$ → 应用 $AXA=A$ 与伪逆雏形）。

**第二组 · QR → Schur（3.4–3.5）**

> 第三副眼镜把骨架**掰直**：左因子换成标准正交基（[3.4](ch03/sec34.md)：QR 分解定义与「正线」约定 → QR 分解定理：GS 即算法、$R$ 是过渡矩阵、正线下唯一 → 去正线差对角酉阵 → 不满秩与长方阵的推广 → QR 算法：反复分解把特征值挤上对角线）→ 第四副眼镜把「对角化」放松成「三角化」：**人人有份**（[3.5](ch03/sec35.md)：两个 Schur 引理 → 实阵边界（旋转阵反例）→ 谱映射 → Hamilton–Cayley 定理 → 逆矩阵公式 → 零化多项式与最小多项式）。

**第三组 · 对角化 → 谱分解（3.6–3.7）**

> 第五副眼镜把 Schur 型上方的 $\ast$ 逐个消掉：**什么时候能真正对角化**（[3.6](ch03/sec36.md)：五条等价判据 → 两条判别口诀 → 幂与线性 ODE → 酉相似对角化 → Hermite / 实对称谱定理 → 正规矩阵与谱定理）→ 第六副眼镜把对角化按特征值拆开重装：$A=\sum_j\lambda_jE_j$（[3.7](ch03/sec37.md)：谱阵三步法 → 五条性质与唯一性 → 函数演算与 Lagrange 公式 → 正规谱阵 = 正交投影 → 预解式与矩阵函数）。

六副眼镜都由同一个动作造出来：**选基**——3.1 选一组让映射变成 $\Gamma$ 的基，3.2 选列空间的一组基，3.4 用 Gram–Schmidt 把基掰成正交，3.5 逐个吃掉特征向量再正交化，3.6 要求特征向量「够用且正交」，3.7 把特征子空间当作投影的落点；而选基的学问正是第一章的主题（[1.3](ch01/sec13.md)）。章内也形成了闭环：3.5 的证明回头借 3.4 的 QR 分解，3.6 的五条等价把 2.4 的重数不等式与 3.5 的最小多项式接在一起，3.7 的谱阵公式又反过来给 3.6.1 的（5）$\Rightarrow$（1）提供构造性证明。

考试向的收束在[考场竞技场](ch03/arena.md)：必考点清单 + 三轮限时赛（概念 / 计算 / 证明）+ S6–S8 加练 + 步骤分引擎——把「会做」练成「限时拿分」。

向下游：三角分解（3.3，课件暂缺）、奇异值分解、广义逆——**待素材到位后，本节地图与结构图将同步补全。**
