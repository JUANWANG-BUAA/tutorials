# 2.3 旋转矩阵的合成

上一节能算出一次旋转。现在让工具先绕 $y$ 转 $90^\circ$，再绕 $z$ 转 $90^\circ$：第二次的 $z$ 是固定在工作台上的轴，还是随工具一起转过的轴？两种指令得到的终态可能不同。

本节要把每次指令写成明确的姿态更新，再用矩阵、三轴方向和分步演示互相核对。原书对应 §2.3，印刷页 45–48。所有坐标系均为右手系，角度按右手定则取正；本节只处理朝向，不处理偏置转轴引起的位置变化。

<a id="sec-2.3.1"></a>

## 2.3.1 记号与合成规则

### 先用坐标换算确定乘积顺序

记 $\boldsymbol p^i$ 为同一点在系 $i$ 中的坐标；记 $R_j^i$ 为系 $j$ 相对系 $i$ 的姿态，它的第 1、2、3 列依次为 $j$ 系三根轴在 $i$ 系中的坐标。对三个共原点系 $0,1,2$（原书式 2.12–2.15）：

$$\boldsymbol p^1=R_2^1\boldsymbol p^2,\qquad \boldsymbol p^0=R_1^0\boldsymbol p^1\ \Rightarrow\ \boldsymbol p^0=R_1^0R_2^1\boldsymbol p^2\ \Rightarrow\ \boxed{R_2^0=R_1^0R_2^1}$$

从输入 $\boldsymbol p^2$ 开始读：先经右边的 $R_2^1$ 换到系 1，再经左边的 $R_1^0$ 换到系 0。等式对任意输入列都成立，才可把系数矩阵写成最后一项；只用一个向量试算相等，不能证明两姿态相同。

### 再把新指令接到已有姿态上

令 $R$ 表示工具当前相对固定系的姿态，初始值为 $R_0$，不一定是单位阵。下列规则区分的是**新增转动在哪个系中描述**。

::: thm 原理 2.3.A · 相对当前轴的连续旋转 → 右乘 {#thm-2.3.A}
若新增转动 $B$ 相对**当前工具系的轴**描述，则

$$R_{\rm new}=RB.$$

例如当前系先后绕其 $y$、再绕新的 $z$ 轴转 $\alpha,\beta$，得到 $R_0R_y(\alpha)R_z(\beta)$。新因子在右侧追加，称为**右乘**。从 $R_0=I$ 出发，逐级编号便得到原书式 2.15 的形式：

$$R_2^0=R_1^0R_2^1,\qquad\text{一般地 } R_n^0=R_1^0R_2^1\cdots R_n^{n-1}.$$

且逆关系就是上下标对换（原书式 2.16）：

$$R_1^0=(R_0^1)^{-1}=(R_0^1)^T .$$
:::

::: thm 原理 2.3.B · 相对固定轴的连续旋转 → 左乘 {#thm-2.3.B}
若新增转动 $S$ 相对**固定参考系的轴**描述，则

$$R_{\rm new}=SR.$$

新因子从左侧接入，称为**左乘**。从 $R_0$ 出发，先绕固定 $y$、再绕固定 $z$ 轴转 $\alpha,\beta$，得到 $R_z(\beta)R_y(\alpha)R_0$。只有在这样的固定轴时序中，才把“先转的增量在右边”作为读法。
:::

::: proof 为什么一个左乘、一个右乘？
设 $\boldsymbol u$ 是工具系内不变的一个方向，其固定系坐标为 $R\boldsymbol u$。

若指令 $S$ 作用在固定系，转后为 $S(R\boldsymbol u)=(SR)\boldsymbol u$；它对三根工具轴都成立，因此新姿态是 $SR$。若指令 $B$ 作用在工具局部坐标，转后为 $R(B\boldsymbol u)=(RB)\boldsymbol u$，所以新姿态是 $RB$。

描述**同一次实际转动**时，两种增量由

$$B=R^{\mathrm T}SR,\qquad RB=R(R^{\mathrm T}SR)=SR$$

联系。这里 $R$ 必须取转动前的姿态。不能把同一个数值的 $R_y(\alpha)$ 不作换算地同时叫作固定轴指令和当前轴指令。

这也解释原书式 2.17 的虚拟三步分解：$R\,R^{-1}\,S\,R=SR$。先抵消已有姿态、施加固定轴转动、再补偿前面的抵消；它是推导用的等价分解，最后一步不意味着把物体恢复到转动前的终态。
:::

::: intuition 反序等价的适用条件
从**同向的初始姿态 $I$** 出发，固定轴依次做 $A$、$B$，得到 $BA$；当前轴依次做 $B$、$A$，也得到 $BA$。倒过来的是完整的**轴名与角度配对**，不是只交换角度数值。

若初始姿态为一般的 $R_0$，前者是 $BAR_0$，后者是 $R_0BA$，不能保证相等。ZYZ 与 RPY 是两种不同的三角约定，也不能仅因一个右乘、一个左乘，就把同一组三个角直接互换使用。
:::

对坐标系链 $0\to1\to2\to3$，连续坐标换算给出

$$R_3^0=R_1^0R_2^1R_3^2,$$

这是 [§2.8](sec2-8.md) 正运动学矩阵链的旋转部分。即使各系原点不同，朝向仍按这条矩阵链合成；点的位置还需要平移部分。

另外，$R_j^i$ 的行同样有几何意义（原书）：**列**是动系轴在固定系中的方向余弦，**行（即 $R^T$ 的列）**是固定系轴在动系中的方向余弦——也就是说，逆矩阵免费给出了反向变换。

两条规则到这里就齐了。下一个问题自然浮现：既然左乘、右乘各对应一种参照系，那么把两次旋转的先后顺序换一换，终态会不会变？下面用原书例 2.3 来回答。

<a id="sec-2.3.2"></a>

## 2.3.2 旋转不可交换（原书例 2.3）

::: ex 例 2.3（原书）· 先 $\vartheta_1$ 后 $\vartheta_2$ ≠ 先 $\vartheta_2$ 后 $\vartheta_1$ {#ex-book-2.3}
交换两次转动的顺序，终态**一般不同**：当前轴的 $AB$ 与 $BA$ 通常不等，固定轴也一样。原书图 2.6、2.7 分别给出当前轴与固定轴的例子。

“一般不同”不等于“每一对都不同”。同轴转动满足 $R_z(\alpha)R_z(\beta)=R_z(\alpha+\beta)=R_z(\beta)R_z(\alpha)$；若某次角度为零，也会相等。要否定普遍交换律，给出一对不相等的例子即可。
:::

::: ex 例 2.3.C · 90°+90° 数值验证（本教程补） {#ex-2.3.C}
从 $I$ 出发，取 $\alpha=90^\circ$ 为 $y$ 轴指令，$\beta=90^\circ$ 为 $z$ 轴指令。代入 [§2.2 的基本矩阵](sec2-2.md#sec-2.2.2)：

$$R_A=R_z(\beta)R_y(\alpha)=\begin{bmatrix}0&-1&0\\0&0&1\\-1&0&0\end{bmatrix},\qquad
R_B=R_y(\alpha)R_z(\beta)=\begin{bmatrix}0&0&1\\1&0&0\\0&1&0\end{bmatrix}.$$

| 指令（按实际发生顺序） | 乘积 | 转后三轴在固定系中的方向 |
|---|---|---|
| 固定 $y\to z$；或当前 $z\to y'$ | $R_A=R_zR_y$ | $x_2=-z_0,\ y_2=-x_0,\ z_2=+y_0$ |
| 固定 $z\to y$；或当前 $y\to z'$ | $R_B=R_yR_z$ | $x_2=+y_0,\ y_2=+z_0,\ z_2=+x_0$ |

只看第一列已经能发现差别：$R_A(1,0,0)^{\mathrm T}=(0,0,-1)^{\mathrm T}$，而 $R_B(1,0,0)^{\mathrm T}=(0,1,0)^{\mathrm T}$。三列及矩阵都由同一组转动得出，可用下面的图与演示交叉检查。
:::

下面的三幅图使用同一投影：蓝、绿、金依次标本体 $x,y,z$ 轴，灰虚线标固定系。读右两图时，可用上表逐根核对方向；屏幕上的投影夹角不等于真实三维夹角。

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
<text class="diagram-mono" x="816" y="228">x<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="776" y="206" text-anchor="end">y<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="798" y="196">z<tspan class="sp">0</tspan></text>
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
<text class="diagram-note" x="460" y="382" text-anchor="middle">灰虚线 = 固定轴；彩色 = 工具轴。两例均从单位姿态出发。</text>
</svg>
<figcaption>例 2.3 的几何（本教程绘）：彩色轴都是完成两步后的工具轴，按上表可逐一核对。两例从 $I$ 出发，绕固定轴「先 y 后 z」与「先 z 后 y」给出不同终态。其中 $R_A$ 也可由当前轴「先 z 后新 y」得到；倒序时，轴与角必须一起倒序。</figcaption>
</figure>

<a id="practice-2.3.composition"></a>

### 动手核对：第二步到底绕哪根轴？

先预测，再操作下方演示：

1. 保持默认 $\alpha=\beta=90^\circ$、初始 $I$、固定轴「先 y 后 z」。把步数调到 0、1、2，分别核对 $I$、$R_y(90^\circ)$、$R_A$；第二步红色转轴应沿固定 $+z_0$。
2. 改成当前轴，仍先 y 后 z。第二步的转轴现在沿固定 $+x_0$：第一步已把工具的 $z$ 轴转到那里。检查终态是否变成 $R_B$，再把顺序改为先 z 后 y，看是否回到 $R_A$。
3. 把初始姿态切为 $R_x(45^\circ)$。观察「改用另一轴约定并倒序」的终态差，解释为何不再保证为零。最后设 $\alpha=0$ 或两角均为 $180^\circ$，检查交换两步后的终态差。

<div class="lab" data-lab="composition3d" hidden></div>

无脚本时，上面的完整矩阵与轴方向表仍可独立使用。画布是投影示意，精确三维方向以读数为准；拖动视角不会改变矩阵。

::: ex 练习 · 初始姿态不能丢
令 $R_0=R_x(90^\circ)$。方案 A：绕固定 $y$、固定 $z$ 各转 $90^\circ$；方案 B：绕当前 $z$、新的当前 $y$ 各转 $90^\circ$。两方案终态相同吗？各自的工具 $x$ 轴最后朝哪里？

::: sol 核对
记 $M=R_z(90^\circ)R_y(90^\circ)=R_A$。方案 A 为 $MR_0$，方案 B 为 $R_0M$，不能把两端的 $R_0$ 消掉。因为 $R_0\boldsymbol e_x=\boldsymbol e_x$、$M\boldsymbol e_x=-\boldsymbol e_z$，A 的 $x$ 轴朝 $-z_0$；B 的 $x$ 轴为 $R_0(-\boldsymbol e_z)=+\boldsymbol e_y$。两终态不同。若从 $I$ 出发，二者才都简化为 $M$；某些特殊 $R_0$ 也可能与 $M$ 可交换。
:::
:::

::: ex 练习 · 「一般不交换」的边界
判断并给出理由：(a) 同轴两次旋转可交换；(b) 不同轴就一定不可交换；(c) 两矩阵对一个测试向量作用相同，就表示同一姿态。

::: sol 核对
(a) 对，例如 $R_z(\alpha)R_z(\beta)=R_z(\alpha+\beta)$，两角相加与顺序无关。

(b) 错。零角给单位阵；即使两角都非零，也有 $R_y(180^\circ)R_z(180^\circ)=R_z(180^\circ)R_y(180^\circ)=\operatorname{diag}(1,-1,-1)=R_x(180^\circ)$。不可交换的意思是不能对任意两旋转都使用交换律。

(c) 错。$I$ 与 $R_x(90^\circ)$ 都保持 $\boldsymbol e_x$ 不变，却把 $\boldsymbol e_y$ 分别变成 $\boldsymbol e_y$ 与 $\boldsymbol e_z$。比较三列可直接检查整个矩阵；一个向量足以给出不相等的反例，不足以证明相等。
:::
:::

<a id="sec-2.3"></a>

::: think 默写点 · 合上书再写（主动回忆）

不看正文，先写出下面三条，再展开核对。

1. 当前姿态为 $R$，新增当前系转动 $B$ 或固定系转动 $S$，分别怎样更新？
2. 从 $I$ 出发，固定轴先 $y(\alpha)$ 后 $z(\beta)$，怎样改为当前轴序列得到同一终态？一般 $R_0$ 呢？
3. 把姿态写成三个角的列，逐分量相加就等于合成旋转吗？

::: sol 核对

当前系转动右乘：$R_{\rm new}=RB$；固定系转动左乘：$R_{\rm new}=SR$。

从 $I$ 出发，当前轴先 $z(\beta)$ 后新的 $y(\alpha)$，与题中固定轴序列都得到 $R_z(\beta)R_y(\alpha)$。一般初始姿态时，二者为 $R_z(\beta)R_y(\alpha)R_0$ 与 $R_0R_z(\beta)R_y(\alpha)$，不保证相同。

三个数当然可以逐分量相加，但得到的三元组一般不表示两次旋转的合成。合成须按轴的约定乘旋转矩阵；两个三元组相加可交换，旋转合成一般不可交换。选定连续、避开奇点的角度分支后也可作局部插值，但不能把它当成全局姿态空间的向量运算；三角表示见下一节。

:::

:::

## 2.3 小结与常见错误

- **一条主线**：坐标换算链确定乘积；新增转动按当前轴右乘、固定轴左乘；再用具体向量或三列核对结果。
- **逆序等价的条件**：从 $I$ 出发，固定轴序列与轴角成对倒序的当前轴序列终态相同；一般 $R_0$ 不能直接省略。
- **下一节**：用三个角参数化姿态。每遇到一套角，先写轴、角和发生顺序，再写矩阵。

::: think 常见错误清单 · 自查三条
1. 用角度三元组相加代替旋转合成，或把「一般不交换」误读成「任何两旋转都不交换」。
2. 只背「先转在右边」，漏问转轴在哪个系中描述，或漏掉初始姿态 $R_0$。
3. 把 $R^{-1}=R^{\mathrm T}$ 推广到任意矩阵。它对所有正交矩阵成立；[2.7](sec2-7.md) 的一般齐次变换含平移块，求逆须另用分块公式。
:::
