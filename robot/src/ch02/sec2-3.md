# 2.3 旋转矩阵的合成

[2.1](sec2-1.md)–[2.2](sec2-2.md) 已建立单个旋转矩阵及其三重身份。接下来自然要问：把**多个**旋转接在一起时，它们该如何合成？本节回答这个问题，给出两条规则——绕当前轴**右乘**、绕固定轴**左乘**——并建立贯穿全章的性质：合成**不可交换**。本节内容对应录播第 1 周 2:18–2:24（链式合成与不可交换），以及第 2 周 0:02:47–0:08:54 的回顾与 0:30:07–0:30:54 的收束。

<a id="sec-2.3.1"></a>

## 2.3.1 记号与合成规则

先把记号约定清楚。记 $\boldsymbol p^i$ 为同一点（向量）在坐标系 $i$ 中的表示；记 $R_j^i$ 为坐标系 $j$ 相对坐标系 $i$ 的旋转矩阵，它的每一列就是 $j$ 系各轴在 $i$ 系中的方向余弦。有了这套记号，链式合成可以写得很紧凑。对三个共原点系 $0,1,2$（原书式 2.12–2.15）：

$$\boldsymbol p^1=R_2^1\boldsymbol p^2,\qquad \boldsymbol p^0=R_1^0\boldsymbol p^1\ \Rightarrow\ \boldsymbol p^0=R_1^0R_2^1\boldsymbol p^2\ \Rightarrow\ \boxed{R_2^0=R_1^0R_2^1}$$

::: thm 原理 2.3.A · 相对当前轴的连续旋转 → 右乘 {#thm-2.3.A}
若每次旋转都绕**上一个旋转产生的新坐标系**的轴进行（「当前轴」），则按旋转发生顺序**依次右乘**：

$$R_2^0=R_1^0R_2^1,\qquad\text{一般地 } R_n^0=R_1^0R_2^1\cdots R_n^{n-1}.$$

且逆关系就是上下标对换（原书式 2.16）：

$$R_1^0=(R_0^1)^{-1}=(R_0^1)^T .$$
:::

::: thm 原理 2.3.B · 相对固定轴的连续旋转 → 左乘 {#thm-2.3.B}
若每次旋转都绕**固定参考系**的轴进行，则规则恰好相反：**新旋转依次左乘（前乘）**。以两次旋转为例，先绕固定系转 $\vartheta_1$、再绕固定系转 $\vartheta_2$，总旋转为

$$R=R_{\vartheta_2}\,R_{\vartheta_1}\qquad(\text{先转的在右边}).$$

这一点原书也有对应表述（式 2.17 后一句）：固定系下的连续旋转合成，是「按给定旋转顺序对各单个旋转矩阵**依次前乘**」（premultiplication in the order of the given sequence）。
:::

::: proof 原理 2.3.B 的证明（两种看法）
**看法一 · 映射复合（一行证完）**：姿态矩阵 $R_1^0$ 把刚体坐标映到固定系坐标；而绕固定系某轴的新旋转，是作用在**固定系坐标**上的映射 $R_{\vartheta_2}$（也就是可直接查表的基本旋转矩阵）。于是合成映射「先 $R_{\vartheta_1}$、后 $R_{\vartheta_2}$」按复合写法就是 $R_{\vartheta_2}\,R_{\vartheta_1}$——后作用的映射写在左边。推广到任意多次：第 $k$ 次固定轴旋转到来时 $R_k^0=R_{\vartheta_k}R_{k-1}^0$，归纳即得「按发生顺序依次左乘」。

**看法二 · 原书三步，翻译成当前轴（原书式 2.17 的推导思路）**：换一个角度，绕固定轴转 $R_{\vartheta_2}$ 可等价拆成三步**当前轴**旋转：① 把刚体系转回与固定系对齐（转 $(R_1^0)^{-1}$）→ ② 在对齐姿态下施加 $R_{\vartheta_2}$（此刻「当前轴」恰与固定轴重合）→ ③ 再把刚体系转回原位（转 $R_1^0$）。三步都按 2.3.A 依次右乘：

$$\bar R_2^0=R_1^0\,\underbrace{(R_1^0)^{-1}}_{\text{①}}\;R_{\vartheta_2}\;\underbrace{R_1^0}_{\text{③}}=R_{\vartheta_2}\,R_1^0 ,$$

与看法一的结果一致，证毕。□
:::

::: intuition 一句话记住两条规则
**右乘 = 「转完再在新位置上接着转」（站在刚体上看）；左乘 = 「始终绕原地那几根定轴转」（站在地上看）。** 两条规则的**时序互为镜像**：当前轴「先 $z$ 后 $y'$」与固定轴「先 $y$ 后 $z$」给出同一个终态，而且**乘积写出来完全相同**（$R_z(\varphi)R_y(\vartheta)$，先转的在右端）——固定轴的时序与乘积排列互为逆序。哪一条用得更多？录播 0:25:40 老师点明：用得最多的是绕固定轴左乘，如 2.5 节的角和轴；而机器人关节则是典型的绕当前轴右乘，见 2.8 节。
:::

录播 0:30:07 老师把这条规则落回到机器人上：对关节链 $0\to1\to2\to3$，「从 3 的指向到 0 的指向」就是

$$R_3^0=R_1^0R_2^1R_3^2,$$

这就是「一次右乘、依次连乘」的含义；而它正是 2.8 节正运动学 $T_n^0=A_1^0A_2^1\cdots A_n^{n-1}$ 的旋转部分。

另外，$R_j^i$ 的行同样有几何意义（原书）：**列**是动系轴在固定系中的方向余弦，**行（即 $R^T$ 的列）**是固定系轴在动系中的方向余弦——也就是说，逆矩阵免费给出了反向变换。

两条规则到这里就齐了。下一个问题自然浮现：既然左乘、右乘各对应一种参照系，那么把两次旋转的先后顺序换一换，终态会不会变？下面用原书例 2.3 来回答。

<a id="sec-2.3.2"></a>

## 2.3.2 旋转不可交换（原书例 2.3）

::: ex 例 2.3（原书）· 先 $\vartheta_1$ 后 $\vartheta_2$ ≠ 先 $\vartheta_2$ 后 $\vartheta_1$ {#ex-book-2.3}
对同一物体施加同样的两次基本旋转，只要交换顺序，终态姿态一般就不同——无论绕当前轴还是绕固定轴：绕当前轴时，「先 $\vartheta_1$ 后 $\vartheta_2$」与「先 $\vartheta_2$ 后 $\vartheta_1$」结果不同（原书图 2.6）；绕固定轴同理（原书图 2.7）。**有趣的对偶**：绕固定轴按序 $(\vartheta_1,\vartheta_2)$ 的终态 = 绕当前轴按序 $(\vartheta_2,\vartheta_1)$ 的终态——因为固定轴左乘顺序恰好是当前轴右乘顺序的逆序排列。
:::

::: ex 例 2.3.C · 90°+90° 数值验证（本教程补） {#ex-2.3.C}
取 $\vartheta_1$ 为绕 $y$ 转 90°、$\vartheta_2$ 为绕 $z$ 转 90°。先看**固定轴**（先 $y$ 后 $z$）：新旋转左乘，$R=R_z(90^\circ)R_y(90^\circ)$——先转的 $R_y$ 落在右边。再看**当前轴**：要得到同一终态必须反着来，先绕 $z$ 转 90°、再绕**新的** $y'$ 转 90°，依次右乘同样得到 $R_z(90^\circ)R_y(90^\circ)$。两条路线数值完全一致（代入 [2.2](sec2-1.md) 的基本旋转矩阵即可验证），这正是上面那条「对偶」。反过来，若固定轴也按「先 $z$ 后 $y$」走，得到的是 $R_y(90^\circ)R_z(90^\circ)\ne R_z(90^\circ)R_y(90^\circ)$——不可交换。
:::

把例 2.3 画出来就是下图：同一初始姿态、同样两把「90°」，只交换先后顺序，终态的三根体轴指向就完全不同——这就是「角度集合不能当向量相加」的几何根源。

<figure>
<svg class="figure-svg" viewBox="0 0 920 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-23-title fig-23-desc">
<title id="fig-23-title">旋转顺序交换，终态姿态不同</title>
<desc id="fig-23-desc">三个立方体：左为初始姿态，体轴与固定系重合；中为先绕固定 y 轴再绕固定 z 轴各转 90 度后的终态；右为先 z 后 y 的终态。两终态的体轴指向不同，说明旋转不可交换。</desc>
<defs>
<marker id="f23-b" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-blue)"/></marker>
<marker id="f23-n" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-green)"/></marker>
<marker id="f23-g" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-gold)"/></marker>
<marker id="f23-m" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--muted)"/></marker>
</defs>
<text class="diagram-text" x="150" y="36" text-anchor="middle">初始姿态</text>
<text class="diagram-text" x="470" y="36" text-anchor="middle">先 y 后 z（固定轴）</text>
<text class="diagram-text" x="790" y="36" text-anchor="middle">先 z 后 y（固定轴）</text>
<!-- panel 0 -->
<g fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1" stroke-linejoin="round">
<polygon points="150,215 129.3,203 129.3,157 150,169"/>
<polygon points="150,215 194.2,227 194.2,181 150,169"/>
<polygon points="150,169 194.2,181 173.5,169 129.3,157"/>
</g>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f23-b)" x1="150" y1="215" x2="207" y2="231"/>
<line stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#f23-n)" x1="150" y1="215" x2="123" y2="200"/>
<line stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#f23-g)" x1="150" y1="215" x2="150" y2="155"/>
<text class="diagram-text" fill="var(--fig-blue)" x="214" y="240">x</text>
<text class="diagram-text" fill="var(--fig-green)" x="112" y="202" text-anchor="end">y</text>
<text class="diagram-text" fill="var(--fig-gold)" x="150" y="148" text-anchor="middle">z</text>
<text class="diagram-note" x="150" y="272" text-anchor="middle">体系 x y z 与固定系重合</text>
<!-- panel A -->
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#f23-m)">
<line x1="470" y1="215" x2="492" y2="221"/>
<line x1="470" y1="215" x2="460" y2="209"/>
<line x1="470" y1="215" x2="470" y2="193"/>
</g>
<text class="diagram-mono" x="496" y="228">x<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="456" y="206" text-anchor="end">y<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="478" y="196">z<tspan class="sp">0</tspan></text>
<g fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1" stroke-linejoin="round">
<polygon points="470,215 470,261 425.8,249 425.8,203"/>
<polygon points="470,215 425.8,203 405.1,191.1 449.3,203"/>
<polygon points="425.8,203 425.8,249 405.1,237.1 405.1,191.1"/>
</g>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f23-b)" x1="470" y1="215" x2="470" y2="275"/>
<line stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#f23-n)" x1="470" y1="215" x2="413" y2="199"/>
<line stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#f23-g)" x1="470" y1="215" x2="443" y2="199"/>
<text class="diagram-text" fill="var(--fig-blue)" x="470" y="290" text-anchor="middle">x</text>
<text class="diagram-text" fill="var(--fig-green)" x="406" y="196" text-anchor="end">y</text>
<text class="diagram-text" fill="var(--fig-gold)" x="449" y="191" text-anchor="end">z</text>
<!-- panel B -->
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#f23-m)">
<line x1="790" y1="215" x2="812" y2="221"/>
<line x1="790" y1="215" x2="780" y2="209"/>
<line x1="790" y1="215" x2="790" y2="193"/>
</g>
<g fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1" stroke-linejoin="round">
<polygon points="790,215 790,169 834.2,181 834.2,227"/>
<polygon points="790,169 769.3,157 813.5,169 834.2,181"/>
<polygon points="790,215 769.3,203 769.3,157 790,169"/>
</g>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f23-b)" x1="790" y1="215" x2="763" y2="199"/>
<line stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#f23-n)" x1="790" y1="215" x2="790" y2="155"/>
<line stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#f23-g)" x1="790" y1="215" x2="847" y2="231"/>
<text class="diagram-text" fill="var(--fig-blue)" x="756" y="196" text-anchor="end">x</text>
<text class="diagram-text" fill="var(--fig-green)" x="790" y="148" text-anchor="middle">y</text>
<text class="diagram-text" fill="var(--fig-gold)" x="854" y="240">z</text>
<!-- contrasts -->
<text fill="var(--fig-red)" font-size="26" font-weight="700" x="310" y="222" text-anchor="middle">≠</text>
<text fill="var(--fig-red)" font-size="26" font-weight="700" x="630" y="222" text-anchor="middle">≠</text>
<text class="diagram-mono" x="470" y="312" text-anchor="middle">R = Rz(90°)·Ry(90°)</text>
<text class="diagram-mono" x="790" y="312" text-anchor="middle">R = Ry(90°)·Rz(90°)</text>
<text class="diagram-text" x="460" y="356" text-anchor="middle">同样的两次旋转，交换顺序 → 终态姿态不同：旋转不可交换</text>
<text class="diagram-note" x="460" y="382" text-anchor="middle">灰虚线 = 固定系的轴；先转的因子落在乘积右端，同一终态也可读成「绕当前轴按逆序右乘」（左 / 右乘对偶）</text>
</svg>
<figcaption>例 2.3 的几何（本教程绘）：绕固定轴「先 y 后 z」与「先 z 后 y」给出两个不同终态——彩色体轴指向一目了然。同一终态 R = Rz(90°)Ry(90°) 还可读成绕当前轴「先 z 后 y′」，这就是 [@thm-2.3.B] 与 [@thm-2.3.A] 的镜像关系。</figcaption>
</figure>

<a id="sec-2.3"></a>

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先自己写出下面几条，再展开核对。写不出来，就说明这一节还没真正「拿走」。

1. 绕当前轴、绕固定轴，分别用左乘还是右乘？
2. 写出 ZYZ 与 RPY 的乘积顺序，并说明各属哪一族。
3. $\boldsymbol\phi=[\varphi\ \vartheta\ \psi]^{\mathrm T}$ 能像向量一样相加吗？为什么？

::: sol 核对

绕**当前**轴用右乘，绕**固定**轴用左乘。口诀：右乘当前轴、左乘固定轴。

ZYZ：$R_z(\varphi)R_{y'}(\vartheta)R_{z''}(\psi)$——三个因子都绕当前轴，依次右乘；RPY：$R_z(\varphi)R_y(\vartheta)R_x(\psi)$——都绕固定轴，依次左乘。两者互为左乘 / 右乘对偶。

不能。角度集合只是**打包记号**，而旋转不可交换（$R_1R_2\neq R_2R_1$），所以它没有向量加法。

:::

:::

## 2.3 小结与常见错误

- **一条主线**：右乘（当前轴）/ 左乘（固定轴）两条规则 → 合成不可交换（[@ex-2.3.C]）；而且两条规则互为镜像（固定轴顺序 = 当前轴逆序）。
- **一句口诀**：「转完接着转 = 右乘」「原地定轴转 = 左乘」；另外记住，$R_j^i$ 的**列**是 $j$ 系轴在 $i$ 系中的像（上下标读反即全错）。

::: think 常见错误清单 · 自查三条
1. 把 $\boldsymbol\phi=[\varphi\ \vartheta\ \psi]^T$ 当向量——角度集合只是「打包记号」，而旋转不满足交换律，所以它**没有**向量加法（录播 0:06:51–0:07:20 老师专门澄清；习题 B5 把这一点算给你看）；
2. 背错乘法方向：口诀是「当前右、固定左」，检验方法是把序列复述成中文——「在转完的基础上再绕它的 $y'$ 转」就是右乘；
3. 忘记 $R^{-1}=R^T$ 只对旋转矩阵成立——2.7 节的齐次变换矩阵就**不再**有此性质。
:::
