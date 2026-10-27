# 作业三：教材习题 3-3 / 3-7（附详细解答与验算）

::: note 作业信息（据录播）
- **题号**：教材第 3 章习题 **3.3、3.7**（录播 2:28:00「最后咱们有两道作业的习题，就是一周的时间，3.3 和 3.7」；课件末页同为「作业：习题 3.3，3.7」）；
- **原文**（教材 p.159）：
  > **3.3** Compute the Jacobian of the SCARA manipulator in Fig. 2.36.
  > **3.7** Find the singularities of the SCARA manipulator in Fig. 2.36.
- **提交**：一周内。
:::

![课堂幻灯片 · 02:28:01：作业页「习题 3.3，3.7」](../assets/ch03/homework.jpg)

两题是同一条链的两环：**3.3 求雅可比 → 3.7 让它退化**（$\det J=0$ 解奇点位形）。SCARA 是四轴全平行（$\alpha_i\equiv0$）的「平面臂 + 竖直伸缩 + 腕转」结构，正好把 [3.1](sec3-1.md) 的绿框公式、[3.2](sec3-2.md) 的流水线与 [3.3](sec3-3.md) 的判据一次串完。

## 准备：DH 表与正运动学（第 2 章 C3 已建）

### 这道题的几何前提

SCARA 是 R–R–P–R 四轴机械手：两个水平转动臂、一个竖直移动的 quill、一个绕竖直轴的腕转。**四根关节轴两两平行且全部竖直**——这一条几何事实决定了后面两题的全部结构：

- 因为相邻 $z$ 轴平行，所有 **$\alpha_i=0$**，DH 矩阵退化为平面形式；
- 因为所有 $z_{i-1}$ 都同向，雅可比的两个转动列都是「竖直轴叉乘矢径」，只有水平分量；
- 因为腕转轴过腕心，第 4 列的位置部分为零。

**符号约定（本页统一）**：$z_0$ 竖直**向上**，$d_3$ 沿 $+z$ 方向量取（quill 向上伸出为正）。这与 `tools/verify_ch03_jac.py` 的 `SCARA_DH` 完全一致。若按教材图 2.36 把 $d_3$ 定义为**向下**伸出，只需把下文所有 $d_3$ 换成 $-d_3$、把第 3 列的方向取反——**物理内容不变，符号随约定**。上一版正文在这里一处写 $-d_3$、另一处写 $+1$，是自相矛盾的，本页已统一。

### DH 参数表

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ | 关节类型 |
|:--:|:--:|:--:|:--:|:--:|:--:|
| 1 | $a_1$ | 0 | 0 | $\vartheta_1$ | 转动 |
| 2 | $a_2$ | 0 | 0 | $\vartheta_2$ | 转动 |
| 3 | 0 | 0 | $d_3$ | 0 | 移动 |
| 4 | 0 | 0 | 0 | $\vartheta_4$ | 转动 |

**逐行说明「为什么是这个数」**（用 [@method-2.8.dh] 的四条建系规则）：

- **$a_i$**：$a_1=a_2$ 是两节臂长（相邻 $z$ 轴沿 $x$ 方向的距离）；$a_3=a_4=0$，因为腕心就在第 2、3 轴的交点上，公垂线长度为零。
- **$\alpha_i$**：四轴全平行 ⇒ 相邻 $z$ 轴夹角为 0 ⇒ $\alpha_1=\alpha_2=\alpha_3=0$。这是「能零则零」原则的极致情形。
- **$d_i$**：$d_1=d_2=0$（两节臂在同一水平面内，$x$ 轴沿臂长方向，无沿 $z$ 的偏置）；$d_3$ 是移动关节的变量；$d_4=0$（腕转不改变腕心位置）。
- **$\vartheta_i$**：转动关节把角写成变量；移动关节的第 3 行把角列**置常数 0**（这是 DH 表最容易填错的一格）。

### 各连杆变换矩阵（逐个写出，不用通式跳过）

通式（$\alpha_i=0$ 时）：

$$A_i^{i-1}=\begin{bmatrix}
c_i&-s_i&0&a_ic_i\\
s_i&c_i&0&a_is_i\\
0&0&1&d_i\\
0&0&0&1
\end{bmatrix},\qquad c_i=\cos\vartheta_i,\ s_i=\sin\vartheta_i .$$

逐个代入：

$$A_1^0=\begin{bmatrix}c_1&-s_1&0&a_1c_1\\ s_1&c_1&0&a_1s_1\\ 0&0&1&0\\ 0&0&0&1\end{bmatrix},\qquad
A_2^1=\begin{bmatrix}c_2&-s_2&0&a_2c_2\\ s_2&c_2&0&a_2s_2\\ 0&0&1&0\\ 0&0&0&1\end{bmatrix},$$

$$A_3^2=\begin{bmatrix}1&0&0&0\\ 0&1&0&0\\ 0&0&1&d_3\\ 0&0&0&1\end{bmatrix}\ (\vartheta_3=0,\ a_3=0),\qquad
A_4^3=\begin{bmatrix}c_4&-s_4&0&0\\ s_4&c_4&0&0\\ 0&0&1&0\\ 0&0&0&1\end{bmatrix}\ (a_4=d_4=0).$$

**读法**：$A_3^2$ 是纯平移（沿 $z$ 走 $d_3$，不转），$A_4^3$ 是纯转动（绕 $z$ 转 $\vartheta_4$，不走）——这两句就是「升降与腕转解耦」在矩阵层面的样子。

### 连乘：一步一步乘，不跳中间结果

**第一步：$A_1^0A_2^1$**（两个平面转动块相乘）。

第 1 行：

$$[c_1c_2+(-s_1)s_2,\ c_1(-s_2)+(-s_1)c_2,\ 0,\ a_1c_1+a_2(c_1c_2-s_1s_2)]
=[c_{12},\ -s_{12},\ 0,\ a_1c_1+a_2c_{12}],$$

这里用了和角公式 $c_1c_2-s_1s_2=\cos(\vartheta_1+\vartheta_2)=c_{12}$、$s_1c_2+c_1s_2=\sin(\vartheta_1+\vartheta_2)=s_{12}$。第 2 行同理：

$$[s_1c_2+c_1s_2,\ (-s_1)s_2+c_1c_2,\ 0,\ a_1s_1+a_2(s_1c_2+c_1s_2)]
=[s_{12},\ c_{12},\ 0,\ a_1s_1+a_2s_{12}].$$

第 3、4 行是 $[0,0,1,0]$ 与 $[0,0,0,1]$。所以

$$T_2^0=A_1^0A_2^1=\begin{bmatrix}
c_{12}&-s_{12}&0&a_1c_1+a_2c_{12}\\
s_{12}&c_{12}&0&a_1s_1+a_2s_{12}\\
0&0&1&0\\
0&0&0&1
\end{bmatrix}.$$

**这一步的物理含义**：$T_2^0$ 的平移列就是**肘点（腕心）在基系中的位置**，旋转块的角度是**两节臂的绝对姿态角** $\vartheta_1+\vartheta_2$。

**第二步：右乘 $A_3^2$**。$A_3^2$ 只改第三行第四列：

$$T_3^0=T_2^0A_3^2=\begin{bmatrix}
c_{12}&-s_{12}&0&a_1c_1+a_2c_{12}\\
s_{12}&c_{12}&0&a_1s_1+a_2s_{12}\\
0&0&1&d_3\\
0&0&0&1
\end{bmatrix}.$$

**为什么平移列的前两个分量不变？** 因为 $A_3^2$ 的旋转块是单位阵，它只把 $d_3$ 加到第三行。**这一步已经能读出「$d_3$ 不影响平面位置」**——后面雅可比第 3 列没有水平分量，根就在这里。

**第三步：右乘 $A_4^3$**。$A_4^3$ 无平移，只把旋转块转 $\vartheta_4$：

$$T_4^0=T_3^0A_4^3=\begin{bmatrix}
c_{124}&-s_{124}&0&a_1c_1+a_2c_{12}\\
s_{124}&c_{124}&0&a_1s_1+a_2s_{12}\\
0&0&1&d_3\\
0&0&0&1
\end{bmatrix},\qquad c_{124}=\cos(\vartheta_1+\vartheta_2+\vartheta_4).$$

**为什么平移列又不变？** 因为旋转块作用在**相对位置**上，而 $A_4^3$ 的相对平移为零：腕转只改姿态、不改腕心位置。这就是第 4 列位置部分为零的矩阵证据。

于是得到本作业要用的正运动学：

$$\boxed{\;p_e=\begin{bmatrix}a_1c_1+a_2c_{12}\\ a_1s_1+a_2s_{12}\\ d_3\end{bmatrix},\qquad
R_4^0=\begin{bmatrix}c_{124}&-s_{124}&0\\ s_{124}&c_{124}&0\\ 0&0&1\end{bmatrix}.\;}$$

**三项自检**（每次手算完都该做）：

1. 令 $\vartheta_2=0,\vartheta_4=0$：$p_e=[(a_1+a_2)c_1,(a_1+a_2)s_1,d_3]^T$——臂伸直，正确；
2. 令 $\vartheta_1=\vartheta_2=0$：$p_e=[a_1+a_2,0,d_3]^T$——沿 $x_0$ 指向，符合零位约定；
3. $R_4^0$ 正交、$\det=+1$（绕 $z$ 的平面旋转，显然）。

动笔前先看一眼这道题的**全部几何**（下图）：四根轴竖直平行意味着雅可比没有「空间项」，四个列在俯视图里就能画出来——右下的两个小图就是 3.7 要解的两个奇异位形。


<figure>
<svg class="figure-svg" viewBox="0 0 920 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-hw3-t fig-hw3-d">
<title id="fig-hw3-t">SCARA 的雅可比几何与两个奇异位形</title>
<desc id="fig-hw3-d">左图俯视：两节臂加竖直伸缩与腕转，四根 z 轴全部指出纸面；第一、二列速度垂直于各自矢径，第三列沿竖直方向，第四列位置贡献为零。右侧两个小图：臂伸直与臂折回时两列共线，行列式为零。</desc>
<defs>
<marker id="fh3-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="fh3-b" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-blue)"/></marker>
<marker id="fh3-n" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-green)"/></marker>
</defs>
<text class="diagram-text" x="230" y="30" text-anchor="middle">俯视：四轴全平行（z 全部 ⊙）</text>
<g stroke="var(--line-strong)" stroke-width="1.1" marker-end="url(#fh3-m)">
<line x1="200" y1="275" x2="285" y2="275"/>
<line x1="200" y1="275" x2="200" y2="200"/>
</g>
<line stroke="var(--line)" stroke-dasharray="4 4" x1="200" y1="275" x2="269.5" y2="120.6"/>
<line stroke="var(--line)" stroke-dasharray="4 4" x1="284.3" y1="204.3" x2="269.5" y2="120.6"/>
<line stroke="var(--accent)" stroke-width="5" x1="200" y1="275" x2="284.3" y2="204.3"/>
<line stroke="var(--accent)" stroke-width="5" x1="284.3" y1="204.3" x2="269.5" y2="120.6"/>
<line stroke="var(--fig-green)" stroke-width="2.8" marker-end="url(#fh3-n)" x1="269.5" y1="120.6" x2="214.8" y2="96"/>
<line stroke="var(--fig-green)" stroke-width="2.8" marker-end="url(#fh3-n)" x1="269.5" y1="120.6" x2="222.2" y2="128.9"/>
<text class="diagram-text" fill="var(--fig-green)" x="206" y="90">J<tspan class="sb">1</tspan> = z×r<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--fig-green)" x="214" y="146">J<tspan class="sb">2</tspan> = z×r<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="236" y="216">r<tspan class="sb">1</tspan></text>
<text class="diagram-note" x="288" y="164">r<tspan class="sb">2</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="236" y="252">a<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="290" y="158">a<tspan class="sb">2</tspan></text>
<g>
<circle cx="200" cy="275" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="200" cy="275" r="2.2" fill="var(--ink-2)"/>
<circle cx="284.3" cy="204.3" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="284.3" cy="204.3" r="2.2" fill="var(--ink-2)"/>
<circle cx="269.5" cy="120.6" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="269.5" cy="120.6" r="2.2" fill="var(--ink-2)"/>
</g>
<text class="diagram-text" x="184" y="296" text-anchor="end">z<tspan class="sb">0</tspan> ⊙</text>
<text class="diagram-text" x="302" y="210">z<tspan class="sb">1</tspan> ⊙</text>
<text class="diagram-text" x="288" y="106">z<tspan class="sb">2</tspan> z<tspan class="sb">3</tspan> ⊙</text>
<text class="diagram-note" x="300" y="330" text-anchor="middle">四列读法：J<tspan class="sb">1</tspan>、J<tspan class="sb">2</tspan> = 竖直叉乘（⊥ 各自矢径）；J<tspan class="sb">3</tspan> = [0,0,1]</text>
<text class="diagram-note" x="300" y="352" text-anchor="middle">第 4 列位置部分 = 0：腕转不改位置，只给末行一个 1</text>
<text class="diagram-text" x="690" y="52" text-anchor="middle">伸直 ϑ<tspan class="sb">2</tspan> = 0：外边界</text>
<g stroke="var(--line)" stroke-dasharray="4 4"><line x1="520" y1="150" x2="700" y2="106"/></g>
<line stroke="var(--accent)" stroke-width="4.5" x1="520" y1="150" x2="595.3" y2="129.8"/>
<line stroke="var(--accent)" stroke-width="4.5" x1="595.3" y1="129.8" x2="651.4" y2="114.8"/>
<circle cx="520" cy="150" r="7" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.3"/><circle cx="520" cy="150" r="1.8" fill="var(--ink-2)"/>
<circle cx="595.3" cy="129.8" r="7" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.3"/><circle cx="595.3" cy="129.8" r="1.8" fill="var(--ink-2)"/>
<circle cx="651.4" cy="114.8" r="4.5" fill="var(--accent)"/>
<line stroke="var(--fig-green)" stroke-width="2.4" marker-end="url(#fh3-n)" x1="651.4" y1="114.8" x2="639.7" y2="71.3"/>
<line stroke="var(--fig-green)" stroke-width="2.4" marker-end="url(#fh3-n)" x1="655" y1="113.7" x2="647.7" y2="92.3"/>
<text class="diagram-text" fill="var(--fig-green)" x="600" y="98" text-anchor="end">J<tspan class="sb">1</tspan> ∥ J<tspan class="sb">2</tspan></text>
<text class="diagram-mono" x="600" y="180" text-anchor="middle">det = a<tspan class="sb">1</tspan>a<tspan class="sb">2</tspan>s<tspan class="sb">2</tspan> = 0</text>
<text class="diagram-text" x="690" y="225" text-anchor="middle">折回 ϑ<tspan class="sb">2</tspan> = π：内边界</text>
<g stroke="var(--line)" stroke-dasharray="4 4"><line x1="595.3" y1="269.8" x2="525" y2="288"/></g>
<line stroke="var(--accent)" stroke-width="4.5" x1="520" y1="290" x2="595.3" y2="269.8"/>
<line stroke="var(--accent)" stroke-width="4.5" x1="595.3" y1="269.8" x2="539.3" y2="284.8"/>
<circle cx="520" cy="290" r="7" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.3"/><circle cx="520" cy="290" r="1.8" fill="var(--ink-2)"/>
<circle cx="595.3" cy="269.8" r="7" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.3"/><circle cx="595.3" cy="269.8" r="1.8" fill="var(--ink-2)"/>
<circle cx="539.3" cy="284.8" r="4.5" fill="var(--accent)"/>
<line stroke="var(--fig-green)" stroke-width="2.4" marker-end="url(#fh3-n)" x1="539.3" y1="284.8" x2="549.7" y2="246.2"/>
<line stroke="var(--fig-green)" stroke-width="2.4" marker-end="url(#fh3-n)" x1="543" y1="290" x2="528.9" y2="323.4"/>
<text class="diagram-text" fill="var(--fig-green)" x="556" y="242">两列仍共线（反号）</text>
<text class="diagram-mono" x="700" y="300" text-anchor="middle">det = 0；末端落在 r = |a<tspan class="sb">1</tspan>−a<tspan class="sb">2</tspan>| 处</text>
<text class="diagram-note" x="690" y="352" text-anchor="middle">两个奇点都与 ϑ<tspan class="sb">1</tspan>、d<tspan class="sb">3</tspan>、ϑ<tspan class="sb">4</tspan> 无关——边界奇点，规划时避开臂展极限即可</text>
</svg>
<figcaption>SCARA 雅可比与奇点的全部几何（本教程绘，对照原书图 2.36）：左——四轴平行使每一列都能在俯视图中画出，第 4 列位置部分为零是「腕轴过腕点」的直接结果；右——伸直与折回两支 $\vartheta_2$ 使 $\det J^{(2)}=a_1a_2\sin\vartheta_2=0$，两列共线、径向速度不可产生（[@ex-book-3.2] 的 SCARA 版）。</figcaption>
</figure>

## 3.3 · 求 SCARA 机械手的雅可比

**题目**（教材 p.159，Problem 3.3）：Compute the Jacobian of the SCARA manipulator in Fig. 2.36.

**要求**：写出 $6\times4$ 的几何雅可比 $J(\boldsymbol q)$，把关节速度 $\dot{\boldsymbol q}=[\dot\vartheta_1,\dot\vartheta_2,\dot d_3,\dot\vartheta_4]^{\mathrm T}$ 映射为末端六维速度 $[v_e;\omega_e]$。

### 第 1 步：几何雅可比的公式从哪来

不背公式，先推一遍。末端速度是各关节贡献的**叠加**（速度是线性的）：

$$v_e=\sum_{i=1}^{n}v_i^{(i)},\qquad \omega_e=\sum_{i=1}^{n}\omega_i^{(i)},$$

其中 $v_i^{(i)}$、$\omega_i^{(i)}$ 是第 $i$ 个关节单独运动时在末端产生的速度与角速度。

**转动关节 $i$**（绕 $z_{i-1}$ 转 $\dot\vartheta_i$）：

- 它让整条下游链绕 $z_{i-1}$ 转，角速度贡献 $\omega_i^{(i)}=z_{i-1}\dot\vartheta_i$；
- 下游任意点 $p$ 的速度是 $\omega_i^{(i)}\times(p-p_{i-1})$，取 $p=p_e$，得 $v_i^{(i)}=z_{i-1}\times(p_e-p_{i-1})\,\dot\vartheta_i$。

**移动关节 $i$**（沿 $z_{i-1}$ 移 $\dot d_i$）：

- 它不让下游转，$\omega_i^{(i)}=0$；
- 它让下游整体平移，$v_i^{(i)}=z_{i-1}\dot d_i$。

把系数提出来，就得到「绿框公式」：

$$\text{转动 }i:\ J_{P_i}=z_{i-1}\times(p_e-p_{i-1}),\ J_{O_i}=z_{i-1};\qquad
\text{移动 }i:\ J_{P_i}=z_{i-1},\ J_{O_i}=0. \tag{3.3-1}$$

**这一步交代了什么**：公式不是天上掉的，它是「刚体上一点的速度 = 基点的速度 + 角速度 × 相对位矢」。$p_{i-1}$ 是**关节 $i$ 轴上的一点**（取在原点即可），$z_{i-1}$ 是**关节 $i$ 的轴向**。所以求雅可比只剩下两件事：从 $T_i^0$ 读出 $z_{i-1}$ 与 $p_{i-1}$，再做叉乘。

### 第 2 步：从各个 $T_i^0$ 读出 $z_{i-1}$ 与 $p_{i-1}$

$T_i^0$ 的**第三列**是 $z_i$ 在基系中的方向，**第四列**是原点 $p_i$ 的位置。由第 1 步的连乘结果：

$$T_1^0:\ p_1=\begin{bmatrix}a_1c_1\\ a_1s_1\\ 0\end{bmatrix},\qquad
T_2^0:\ p_2=\begin{bmatrix}a_1c_1+a_2c_{12}\\ a_1s_1+a_2s_{12}\\ 0\end{bmatrix},\qquad
T_3^0=T_4^0:\ p_3=p_4=\begin{bmatrix}a_1c_1+a_2c_{12}\\ a_1s_1+a_2s_{12}\\ d_3\end{bmatrix},$$

$$z_0=z_1=z_2=z_3=\begin{bmatrix}0\\0\\1\end{bmatrix}.$$

**两个必须解释的事实**：

- **所有 $z$ 相同**：四轴全平行且都与基系 $z_0$ 同向。这不是巧合，是 SCARA 的定义性几何——也正是它让后面两行恒为零。
- **$p_3=p_4$**：腕转轴过腕心，转动不移动该点。所以第 4 列的位置部分必然是零。
- **$p_2$ 与 $p_3$ 的差别只在 $z$**：$d_3$ 是纯竖直位移。

末端点取 $p_e=p_4$。

### 第 3 步：逐列做叉乘（每一列都展开）

用恒等式 $[0,0,1]^{\mathrm T}\times[X,Y,Z]^{\mathrm T}=[-Y,\ X,\ 0]^{\mathrm T}$。**这个恒等式值得记**：竖直轴叉乘任何矢量，结果的 $z$ 分量必为零——这就是「SCARA 只能产生水平末端速度」的代数表达。

**第 1 列（$\vartheta_1$，转动）**。取 $p_0=p_1$ 在关节 1 轴上，最简单取 $p_0=[0,0,0]^{\mathrm T}$：

$$p_e-p_0=\begin{bmatrix}a_1c_1+a_2c_{12}\\ a_1s_1+a_2s_{12}\\ d_3\end{bmatrix}
\;\Longrightarrow\;
z_0\times(p_e-p_0)=\begin{bmatrix}-(a_1s_1+a_2s_{12})\\ a_1c_1+a_2c_{12}\\ 0\end{bmatrix},\qquad J_{O_1}=z_0=\begin{bmatrix}0\\0\\1\end{bmatrix}.$$

**几何读法**：这个矢量垂直于「基座到末端」的矢径，长度等于矢径的水平投影——正是「绕基座转一圈，末端沿切向走多远」。

**第 2 列（$\vartheta_2$，转动）**：

$$p_e-p_1=\begin{bmatrix}a_2c_{12}\\ a_2s_{12}\\ d_3\end{bmatrix}
\;\Longrightarrow\;
z_1\times(p_e-p_1)=\begin{bmatrix}-a_2s_{12}\\ a_2c_{12}\\ 0\end{bmatrix},\qquad J_{O_2}=z_1=\begin{bmatrix}0\\0\\1\end{bmatrix}.$$

**注意 $d_3$ 消失了**：竖直分量在叉乘里被 $z$ 轴「吃掉」（$[0,0,1]\times[0,0,d_3]=0$）。这说明**升降不影响水平速度的力臂**——第 2 列的模长只由 $a_2$ 与两臂夹角决定。

**第 3 列（$d_3$，移动）**：移动关节的公式直接给

$$J_{P_3}=z_2=\begin{bmatrix}0\\0\\1\end{bmatrix},\qquad J_{O_3}=\begin{bmatrix}0\\0\\0\end{bmatrix}.$$

**注意不要套转动公式**：如果误用 $z_2\times(p_e-p_2)$，会得到零（因为 $p_e-p_2$ 恰好沿 $z$），第 3 列整列为零，雅可比立刻降秩——这是「$d_3$ 是移动关节」这一格填错的直接后果。

**第 4 列（$\vartheta_4$，转动）**：

$$p_e-p_3=\begin{bmatrix}0\\0\\0\end{bmatrix}
\;\Longrightarrow\;
J_{P_4}=z_3\times 0=\begin{bmatrix}0\\0\\0\end{bmatrix},\qquad J_{O_4}=z_3=\begin{bmatrix}0\\0\\1\end{bmatrix}.$$

**读法**：腕转不移动末端点，只给角速度。这是 SCARA「装配用腕」的几何本质——位置由前三个关节定，姿态由第 4 个关节定。

### 第 4 步：组装

把四列按行拼起来：

$$\boxed{\;J(\boldsymbol q)=\begin{bmatrix}
-a_1s_1-a_2s_{12} & -a_2s_{12} & 0 & 0\\
a_1c_1+a_2c_{12} & a_2c_{12} & 0 & 0\\
0 & 0 & 1 & 0\\
0 & 0 & 0 & 0\\
0 & 0 & 0 & 0\\
1 & 1 & 0 & 1
\end{bmatrix}\in\mathbb R^{6\times4}\;}$$

**逐块读这个矩阵**：

| 块 | 内容 | 为什么 |
|:--|:--|:--|
| 第 1–2 行 | $2\times2$ 平面臂块 | 两转动臂只在水平面内产生速度 |
| 第 3 行 | $[0,0,1,0]$ | 只有移动关节 $d_3$ 产生竖直速度 |
| 第 4–5 行 | 全零 | 四轴都竖直 ⇒ 角速度只有 $z$ 分量，$x,y$ 方向永不产生 |
| 第 6 行 | $[1,1,0,1]$ | 绕 $z$ 的总角速度 = 三个转动关节之和；移动关节不贡献 |

**第 6 行是怎么来的**：$J_{O_i}=z_{i-1}$ 对三个转动关节都是 $[0,0,1]^{\mathrm T}$，移动关节是零，所以叠起来就是 $[1,1,0,1]$——**它不是「凑出来的」，是三个 $[0,0,1]$ 相加**。

### 第 5 步：结构读法（这道题真正要带走的东西）

- **稀疏性是结构给的**：四轴平行 ⇒ 第 4、5 行恒零、第 3 行只有一个 1、臂块是 $2\times2$。参数表越整齐，雅可比越稀疏。
- **秩最多为 4**：$6\times4$ 矩阵的秩不超过 4；而第 4、5 行恒零，实际可用的只有 4 行（1、2、3、6）。所以 SCARA **在任意非奇异位形下都满列秩 4**，任务空间只是六维中的四维子空间。
- **可操作度看臂块**：$\det J=\sqrt{\det(JJ^{\mathrm T})}$ 在 $6\times4$ 上不好直接写，但秩亏只可能来自臂块的 $2\times2$ 行列式——这是下一题的全部入口。

### 验算

`tools/verify_ch03_jac.py` 的 `test_scara_jacobian` 做三件事：

1. **数值对照**：中心差分算 $J_P$（位置）与 $J_O$（用 $S=\dot RR^{\mathrm T}$ 提取角速度），与解析式逐元素比对，最大偏差 $<10^{-8}$；
2. **结构断言**：第 4、5 行恒零；第 6 行为 $[1,1,0,1]$；第 3 列只有竖直分量；
3. **行列式**：取 $a_1=0.4$、$a_2=0.3$、$q=(0.5,1.1,0.2,-0.7)$，验证臂块 $\det=a_1a_2\sin\vartheta_2$。

解析式与数值差分两条独立路线互相印证，说明叉乘没有算错、$z_i$ 与 $p_i$ 没有读错。

::: note 与教材答案的一致性
教材官方解答（Solution Manual, Problem 3.3）给出的 SCARA 雅可比与本页逐列结果一致，差异只在 $z$ 轴方向与 $d_3$ 正负的约定。**约定不同不是错误，混用才是**——写作业时把约定写在最前面，答案就唯一了。
:::


## 3.7 · 求 SCARA 机械手的奇异位形

**题目**（教材 p.159，Problem 3.7）：Find the singularities of the SCARA manipulator in Fig. 2.36.

**要求**：找出使 $J(\boldsymbol q)$ 不满秩的所有位形，并说明它们的几何含义。

### 第 1 步：先把「奇异」翻译成「秩亏」

对 $n$ 关节机械手，$J$ 是 $6\times n$。**满秩 = $\operatorname{rank}J=n$**（列满秩），此时对任意期望的末端速度（在其可达子空间内）都能解出唯一的关节速度。奇异位形就是

$$\operatorname{rank}J(\boldsymbol q)<n.$$

对 SCARA，$n=4$，所以奇异 ⇔ $\operatorname{rank}J\le3$。**注意不是 $\det J=0$**——$J$ 是 $6\times4$ 长方阵，没有行列式。这是本题第一个容易出错的地方。

### 第 2 步：把 $6\times4$ 的秩拆成「臂块 + 两个独立方向」

上一题得到的四列有一个关键结构：

$$\text{col}_1,\text{col}_2\in\operatorname{span}\{e_1,e_2\},\qquad
\text{col}_3=e_3,\qquad
\text{col}_4=e_6.$$

$e_3$ 与 $e_6$ 都不在 $\operatorname{span}\{e_1,e_2\}$ 里，而且彼此独立。所以

$$\operatorname{rank}J=\operatorname{rank}[\text{col}_1\ \text{col}_2]+1+1
=\operatorname{rank}[\text{col}_1\ \text{col}_2]+2. \tag{3.7-1}$$

**这一步的意义**：竖直平移（第 3 列）与绕竖轴转动（第 4 列）**永不退化**——它们各自贡献一个独立方向。奇异性只可能来自**两节水平臂的位置块**。这就是为什么只需研究一个 $2\times2$ 矩阵。

### 第 3 步：算臂块的行列式

取第 1、2 行与第 1、2 列：

$$J^{(2)}=\begin{bmatrix}
-a_1s_1-a_2s_{12} & -a_2s_{12}\\
a_1c_1+a_2c_{12} & a_2c_{12}
\end{bmatrix}.$$

按 $2\times2$ 行列式展开：

$$\det J^{(2)}
=(-a_1s_1-a_2s_{12})(a_2c_{12})-(-a_2s_{12})(a_1c_1+a_2c_{12}).$$

逐项展开：

$$=-a_1a_2s_1c_{12}-a_2^2s_{12}c_{12}+a_1a_2s_{12}c_1+a_2^2s_{12}c_{12}.$$

**$a_2^2$ 两项精确抵消**（这是关键，不能跳）：

$$=a_1a_2(s_{12}c_1-s_1c_{12}).$$

用差角公式 $\sin(A-B)=\sin A\cos B-\cos A\sin B$，取 $A=\vartheta_1+\vartheta_2$、$B=\vartheta_1$：

$$s_{12}c_1-s_1c_{12}=\sin\big((\vartheta_1+\vartheta_2)-\vartheta_1\big)=\sin\vartheta_2.$$

所以

$$\boxed{\;\det J^{(2)}=a_1a_2\sin\vartheta_2\;} \tag{3.7-2}$$

**读法**：行列式里没有 $\vartheta_1$、没有 $d_3$、没有 $\vartheta_4$——**只有肘关节角决定奇异性**。这不是化简的巧合，而是「两节臂构成的三角形面积」：$\frac12 a_1a_2\sin\vartheta_2$ 正是由两臂与连线围成的三角形面积，面积为零时两臂共线。

### 第 4 步：解奇点条件

$$\det J^{(2)}=0\iff a_1a_2\sin\vartheta_2=0\iff \sin\vartheta_2=0
\iff \vartheta_2=0\ \text{或}\ \pi\ (\mathrm{mod}\ 2\pi).$$

（$a_1,a_2>0$，不会为零。）由 (3.7-1)，此时 $\operatorname{rank}J=1+2=3$，从 4 降到 3——**恰好丢一个自由度**。

### 第 5 步：两个奇点的几何——两列为什么共线

秩亏的等价说法是「两列线性相关」。逐一代入验证，顺便得到比例系数：

**$\vartheta_2=0$（臂伸直）**：$s_{12}=s_1$、$c_{12}=c_1$，于是

$$\text{col}_1=\begin{bmatrix}-(a_1+a_2)s_1\\ (a_1+a_2)c_1\end{bmatrix}
=\frac{a_1+a_2}{a_2}\,\text{col}_2,\qquad
\text{col}_2=a_2\begin{bmatrix}-s_1\\ c_1\end{bmatrix}.$$

两列同向、比例 $(a_1+a_2)/a_2>1$。

**$\vartheta_2=\pi$（臂折回）**：$s_{12}=-s_1$、$c_{12}=-c_1$，于是

$$\text{col}_1=(a_1-a_2)\begin{bmatrix}-s_1\\ c_1\end{bmatrix},\qquad
\text{col}_2=-a_2\begin{bmatrix}-s_1\\ c_1\end{bmatrix}
\;\Longrightarrow\;
\text{col}_1=-\frac{a_1-a_2}{a_2}\,\text{col}_2.$$

两列反向（$a_1>a_2$ 时）。

**一个必须注意的退化子情形**：若 $a_1=a_2$ 且 $\vartheta_2=\pi$，则 $\text{col}_1=0$——末端恰好落在基座轴线上（$p_e=[0,0,d_3]^{\mathrm T}$），第 1 列整列为零。此时秩仍是 3，但原因是「一列为零」而不是「两列成比例」。**两种机理，同一个结论**，写作业时若只提「共线」会漏掉这一支。

**几何含义**（对应上图右侧两个小图）：

- $\vartheta_2=0$：工作空间的**外边界**（水平投影半径 $a_1+a_2$）；
- $\vartheta_2=\pi$：**内边界**（半径 $|a_1-a_2|$）；
- 两者都是两臂共线，末端只能沿**切向**运动，**径向速度不可产生**——因为径向正是两列张成的那一维的「法向」。

### 第 6 步：为什么与其它三个关节无关

- $\vartheta_1$：只是整体绕竖轴转，不改变两臂的**相对夹角**，因此不改变 $\sin\vartheta_2$；
- $d_3$：纯竖直平移，只改第 3 行，不进臂块；
- $\vartheta_4$：腕转只改第 6 行第 4 列，不影响位置块。

**这也解释了 SCARA 的工程优点**：奇异性只由 $\vartheta_2$ 决定，与升降高度、腕转角都无关——**规划时只需盯住肘角**，避开 $0$ 与 $\pi$ 即可。

### 第 7 步：奇点类型

按 [3.3.1](sec3-3.md#sec-3.3.1) 的分类，SCARA 的两个奇点都是**边界奇点**（boundary singularity）：

- 它们位于工作空间的**边界**（外缘 / 内缘），不是工作空间内部的「空洞」；
- 在边界上，末端**沿法向**（径向）的速度不可产生，但沿切向仍可运动，控制器不会失控；
- 教材指出这类奇点「在操作空间中被很好地识别、可在规划阶段避开」——所以工程上通常不作为严重问题处理。

**对比**：球形腕机械手的「腕奇异」（两轴共线）是**内部奇点**，位于工作空间内部，无法靠「不走到边界」规避，必须用阻尼最小二乘等算法处理。SCARA 没有球形腕，因此**没有内部奇点**——这是它的结构优势。

### 第 8 步：验算与一个记号提醒

`tools/verify_ch03_jac.py` 在 $s_2=0$ 的两支（$\vartheta_2=0,\pi$）及随机非奇异位形上做 SVD：

- 非奇异位形：最小奇异值 $>0$，四个奇异值之积 $=|a_1a_2\sin\vartheta_2|$；
- $\vartheta_2=0,\pi$：$\operatorname{rank}(J^{(2)})=1$、$\operatorname{rank}J=3$。

**关于可操作度的一个提醒**：常见的 $w=\sqrt{\det(JJ^{\mathrm T})}$ 只对**方阵** $J$ 有意义。SCARA 的 $J$ 是 $6\times4$，$JJ^{\mathrm T}$ 是 $6\times6$ 且秩最多 4，$\det(JJ^{\mathrm T})\equiv0$——直接套公式会得到「处处奇异」的荒谬结论。正确做法是把任务空间限制在 $J$ 的列空间（4 维），此时可操作度等于四个非零奇异值之积，即 $|a_1a_2\sin\vartheta_2|$。**公式的适用条件与公式本身同样重要**。

::: think 3.7 自检 · 四个问题 {#hw3-37-selfcheck}

1. 为什么不能写 $\det J=0$？$6\times4$ 的矩阵「满秩」是什么意思？
2. 为什么竖直与腕转两部分「永不退化」？用列向量的位置说明。
3. $\det J^{(2)}=a_1a_2\sin\vartheta_2$ 的推导里，哪两项抵消了？如果不抵消会得到什么错误结论？
4. $a_1=a_2$、$\vartheta_2=\pi$ 时秩亏的机理与一般情形有什么不同？

::: sol 核对

1. $J$ 是 $6\times4$ 长方阵，没有行列式；满秩指列满秩 $\operatorname{rank}J=4$，奇异指 $\operatorname{rank}J<4$。
2. $\text{col}_3=e_3$、$\text{col}_4=e_6$ 分别落在 $z$ 平移与 $z$ 转动方向，与臂块所在的 $\operatorname{span}\{e_1,e_2\}$ 直和，所以只要臂块满秩，整体秩就是 $2+1+1=4$。
3. $a_2^2s_{12}c_{12}$ 两项抵消，剩下 $a_1a_2(s_{12}c_1-s_1c_{12})=a_1a_2\sin\vartheta_2$。若不抵消，会误以为 $\vartheta_1$ 也影响奇异性。
4. 一般情形是两列成比例（共线）；$a_1=a_2,\vartheta_2=\pi$ 时第 1 列整列为零（末端在基座轴线上），秩仍为 3，但机理是「零列」而非「成比例」。

:::

:::

::: think 3.7 易错点 · 四条 {#hw3-37-pitfalls}

1. **用 $\det J$ 判奇异**。$J$ 非方阵，必须用秩或 $\det J^{(2)}$。
2. **漏掉 $\vartheta_2=\pi$ 支**。$\sin\vartheta_2=0$ 有两个根，只写 $0$ 会丢掉内边界奇点。
3. **以为 $d_3$ 会影响奇异性**。$d_3$ 只进第 3 行，与臂块无关；升降到任何高度，奇点仍在同样的肘角。
4. **把「边界奇点」当缺陷**。SCARA 的两个奇点都可规划规避，不是必须用复杂算法处理的内部奇异。

:::


## 两题一图的心智模型

> **3.3 把「关节速度 → 末端六维速度」写成一张稀疏矩阵：四轴平行使它只有 4 列非零、2 行有效；3.7 只需让那张矩阵的「臂块」退化——$\det J^{(2)}=a_1a_2s_2=0$ 的两个根，就是 SCARA 手臂伸直与折回的两个位形。**

**易错点清单**：① 把第 3 列当转动列（$d_3$ 是移动关节）；② 第 4 列忘了 $p_e-p_3=0$（腕转不改位置）；③ 奇点判定漏掉「与 $\vartheta_1$ 无关」这一结构特征（对比两连杆 [@ex-book-3.2] 的 $\det J=a_1a_2s_2$，公式形式相同、含义随结构）。
