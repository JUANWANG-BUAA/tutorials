# 2.5 角和轴与李代数 $so(3)$

> **本节定位**：`重点掌握` ｜ 用单位转轴 $\boldsymbol r$ 与转角 $\vartheta$ 参数化三维旋转；从五步固定轴辅助构造严格推导出 Rodrigues 旋转公式及其 3D 锥面矢量分解；建立由 $R$ 反求 $(\vartheta,\boldsymbol r)$ 的一般公式与零角／半圈退化处理（最大对角主元 $+$ 非对角交叉项）；进一步引入李代数 $so(3)$、指数映射 $\exp$、对数映射 $\operatorname{Log}$ 与相对旋转路径插值。原书对应 §2.5。

<a id="sec-2.5.1"></a>

## 2.5.1 定义、五步合成与 Rodrigues 公式推导

::: def 定义 2.5.1 · 角和轴表示与叉乘反对称算子 {#def-2.5.1}
任一三维旋转均可由参考系下的单位转轴 $\boldsymbol r=[r_x,r_y,r_z]^{\mathrm T}$（满足 $r_x^2+r_y^2+r_z^2=1$，原书式 2.29）与右手转角 $\vartheta$ 描述，记作 $R(\vartheta,\boldsymbol r)$（按主动旋转约定 $\boldsymbol p_{\rm new}=R\boldsymbol p$，角度以弧度计）。该表示共有 $4$ 个参数并受 $1$ 条单位约束，局部独立参数仍为 $3$。
:::

::: def 定义 2.5.2 · 叉乘反对称算子 $S(\boldsymbol\omega)$ {#def-2.5.2}
对任意三维向量 $\boldsymbol\omega=[\omega_x,\omega_y,\omega_z]^{\mathrm T}\in\mathbb R^3$，定义其**叉乘反对称矩阵**（亦记作 $[\boldsymbol\omega]_\times$ 或 $\hat{\boldsymbol\omega}$）：
$$S(\boldsymbol\omega)=\begin{bmatrix}0&-\omega_z&\omega_y\\ \omega_z&0&-\omega_x\\ -\omega_y&\omega_x&0\end{bmatrix},\qquad
S(\boldsymbol\omega)\boldsymbol p\equiv\boldsymbol\omega\times\boldsymbol p\quad (\forall\boldsymbol p\in\mathbb R^3).$$
矩阵 $S(\boldsymbol\omega)$ 满足 $S^{\mathrm T}(\boldsymbol\omega)=-S(\boldsymbol\omega)$（对角线全为零，非对角元素成对反号）及 $S(-\boldsymbol\omega)=-S(\boldsymbol\omega)$。第 3 章将把物理角速度写入 $S(\boldsymbol\omega)=\dot R R^{\mathrm T}$；本节先将其作为连接叉积与矩阵代数的标准算子。
:::

为将绕任意轴 $\boldsymbol r$ 的旋转化归为基本坐标轴旋转，采用**五步固定轴辅助构造**（原书图 2.10、式 2.24；由 [@thm-2.3.B] 从右向左依次左乘）：
1. 先绕固定 $z$ 转 $-\alpha$、再绕固定 $y$ 转 $-\beta$，使辅助轴与固定 $+z$ 轴重合；
2. 在对齐后的辅助姿态下绕固定 $+z$ 转 $\vartheta$；
3. 再绕固定 $y$ 转 $+\beta$、绕固定 $z$ 转 $+\alpha$，将旋转轴恢复回原指向 $\boldsymbol r$。

其中 $\rho=\sqrt{r_x^2+r_y^2}$，$\alpha$ 为 $xy$ 面投影方位角，$\beta\in[0,\pi]$ 为自 $+z$ 轴量至 $\boldsymbol r$ 的极角（当 $\rho=0$ 即 $\boldsymbol r=\pm\boldsymbol z$ 时约定 $\alpha=0$ 并分别取 $\beta=0,\pi$）：
$$R(\vartheta,\boldsymbol r)=R_z(\alpha)\,R_y(\beta)\,R_z(\vartheta)\,R_y(-\beta)\,R_z(-\alpha),\qquad
\sin\alpha=\frac{r_y}{\rho},\ \cos\alpha=\frac{r_x}{\rho},\ \sin\beta=\rho,\ \cos\beta=r_z.$$

<figure>
<svg class="figure-svg" viewBox="0 0 920 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-25-title fig-25-desc">
<title id="fig-25-title">方位角 α、极角 β 与五步固定轴合成</title>
<desc id="fig-25-desc">左侧俯视 xy 面，α 从正 x 轴量到 r 的投影；中间在包含 z 与 r 的竖直平面内，β 从正 z 轴量到 r。右侧按发生顺序列出五次固定轴旋转；仅第 5 步的净效果等于绕原轴旋转。</desc>
<defs><marker id="f25-m" markerWidth="8" markerHeight="8" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<text class="diagram-text" x="150" y="34" text-anchor="middle">① xy 面俯视：方位角 α</text>
<text class="diagram-text" x="444" y="34" text-anchor="middle">② 竖直截面：极角 β</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.5" marker-end="url(#f25-m)">
<path d="M65 238 H264"/><path d="M65 238 V70"/>
<path d="M360 238 H554"/><path d="M360 238 V70"/>
</g>
<text class="diagram-note" x="267" y="255">x</text><text class="diagram-note" x="50" y="67">y</text>
<text class="diagram-note" x="343" y="67">z</text><text class="diagram-note" x="545" y="261">ρ 方向</text>
<path d="M65 238 L205 118" stroke="var(--fig-blue)" stroke-width="2.8" marker-end="url(#f25-m)"/>
<text class="diagram-note" x="162" y="97">r 在 xy 面的投影</text>
<path d="M111 238 A46 46 0 0 0 100 208" fill="none" stroke="var(--fig-green)" stroke-width="2"/>
<text class="diagram-text" x="124" y="216">α</text>
<path d="M360 238 L474 104" stroke="var(--fig-blue)" stroke-width="2.8" marker-end="url(#f25-m)"/>
<path d="M474 104 V238" stroke="var(--line)" stroke-dasharray="5 4"/>
<path d="M360 188 A50 50 0 0 1 392 200" fill="none" stroke="var(--fig-purple)" stroke-width="2"/>
<text class="diagram-text" x="375" y="176">β</text><text class="diagram-text" x="484" y="100">r</text>
<text class="diagram-note" x="149" y="291" text-anchor="middle">α = atan2(ry, rx)</text>
<text class="diagram-note" x="444" y="291" text-anchor="middle">β = atan2(ρ, rz)</text>
<text class="diagram-note" x="298" y="328" text-anchor="middle">ρ = √(rx² + ry²)；β 从 +z 量起，范围 0 到 π</text>
<text class="diagram-note" x="298" y="354" text-anchor="middle">r = ±z 时约定 α = 0，β 分别为 0、π</text>
<text class="diagram-text" x="752" y="34" text-anchor="middle">③ 五步时序：每次左乘</text>
<g>
<rect class="diagram-node" x="619" y="58" width="265" height="44" rx="7"/>
<text class="diagram-text" x="752" y="85" text-anchor="middle">1 · Rz(−α)：投影对齐 x</text>
<rect class="diagram-node" x="619" y="113" width="265" height="44" rx="7"/>
<text class="diagram-text" x="752" y="140" text-anchor="middle">2 · Ry(−β)：轴对齐 z</text>
<rect class="diagram-node" x="619" y="168" width="265" height="44" rx="7"/>
<text class="diagram-text" x="752" y="195" text-anchor="middle">3 · Rz(ϑ)：辅助姿态旋转</text>
<rect class="diagram-node" x="619" y="223" width="265" height="44" rx="7"/>
<text class="diagram-text" x="752" y="250" text-anchor="middle">4 · Ry(β)：撤销倾斜</text>
<rect class="diagram-node" x="619" y="278" width="265" height="44" rx="7"/>
<text class="diagram-text" x="752" y="305" text-anchor="middle">5 · Rz(α)：撤销方位变化</text>
</g>
<g stroke="var(--line-strong)" marker-end="url(#f25-m)"><path d="M752 102 V111"/><path d="M752 157 V166"/><path d="M752 212 V221"/><path d="M752 267 V276"/></g>
<text class="diagram-note" x="752" y="352" text-anchor="middle">最终净效果：绕原轴 r 转 ϑ</text>
</svg>
<figcaption>球坐标角 $(\alpha,\beta)$ 量测平面与五步固定轴辅助构造时序（本教程绘）。</figcaption>
</figure>

消去辅助角 $\alpha,\beta$ 即得绕任意轴旋转的显式矩阵（原书式 2.25，即 **Rodrigues 旋转公式**）：

$$R(\vartheta,\boldsymbol r)=\begin{bmatrix}
r_x^2(1-c_\vartheta)+c_\vartheta & r_xr_y(1-c_\vartheta)-r_zs_\vartheta & r_xr_z(1-c_\vartheta)+r_ys_\vartheta\\
r_xr_y(1-c_\vartheta)+r_zs_\vartheta & r_y^2(1-c_\vartheta)+c_\vartheta & r_yr_z(1-c_\vartheta)-r_xs_\vartheta\\
r_xr_z(1-c_\vartheta)-r_ys_\vartheta & r_yr_z(1-c_\vartheta)+r_xs_\vartheta & r_z^2(1-c_\vartheta)+c_\vartheta
\end{bmatrix}.$$

::: proof 证明 · 由五步合成推导 Rodrigues 紧凑形式与 9 元展开（原书习题 2.4） {#pf-2.5.rodrigues}
1. **旋转保持叉积的共轭恒等式**：对任意 $R\in SO(3)$ 与向量 $\boldsymbol a,\boldsymbol b,\boldsymbol c\in\mathbb R^3$，混合积满足 $(R\boldsymbol a\times R\boldsymbol b)\cdot(R\boldsymbol c)=\det(R)\det[\boldsymbol a,\boldsymbol b,\boldsymbol c]=(\boldsymbol a\times\boldsymbol b)\cdot\boldsymbol c=[R(\boldsymbol a\times\boldsymbol b)]\cdot(R\boldsymbol c)$。由 $\boldsymbol c$ 任意得 $R(\boldsymbol a\times\boldsymbol b)=R\boldsymbol a\times R\boldsymbol b$，进而对任意 $\boldsymbol p\in\mathbb R^3$ 有
   $$R S(\boldsymbol\omega)R^{\mathrm T}\boldsymbol p = R(\boldsymbol\omega\times R^{\mathrm T}\boldsymbol p) = (R\boldsymbol\omega)\times(RR^{\mathrm T}\boldsymbol p) = S(R\boldsymbol\omega)\boldsymbol p \implies R\,S(\boldsymbol\omega)\,R^{\mathrm T} = S(R\boldsymbol\omega).$$
2. **相似变换化简**：令 $M=R_z(\alpha)R_y(\beta)$。由 $R_k(-\vartheta)=R_k^{\mathrm T}(\vartheta)$ 得 $R_y(-\beta)R_z(-\alpha)=M^{\mathrm T}$，故 $R(\vartheta,\boldsymbol r)=M R_z(\vartheta)M^{\mathrm T}$。直接计算 $M$ 的第 $3$ 列：
   $$M\boldsymbol z = R_z(\alpha)\begin{bmatrix}s_\beta\\ 0\\ c_\beta\end{bmatrix} = \begin{bmatrix}c_\alpha s_\beta\\ s_\alpha s_\beta\\ c_\beta\end{bmatrix} = \begin{bmatrix}r_x\\ r_y\\ r_z\end{bmatrix} = \boldsymbol r.$$
3. **三项分解与搬运**：将 $R_z(\vartheta)$ 拆为 $R_z(\vartheta)=c_\vartheta I_3+(1-c_\vartheta)\boldsymbol z\boldsymbol z^{\mathrm T}+s_\vartheta S(\boldsymbol z)$，代入 $M(\cdot)M^{\mathrm T}$：第一项 $M I_3 M^{\mathrm T}=I_3$；第二项 $M(\boldsymbol z\boldsymbol z^{\mathrm T})M^{\mathrm T}=(M\boldsymbol z)(M\boldsymbol z)^{\mathrm T}=\boldsymbol r\boldsymbol r^{\mathrm T}$；第三项由共轭恒等式得 $M S(\boldsymbol z)M^{\mathrm T}=S(M\boldsymbol z)=S(\boldsymbol r)$。合并即得 **Rodrigues 紧凑形式**：
   $$R(\vartheta,\boldsymbol r) = c_\vartheta I_3 + (1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T} + s_\vartheta S(\boldsymbol r).$$
   逐元素展开即还原上述 $9$ 元素矩阵。□
:::

**3D 锥面矢量分解直觉**：将任意向量 $\boldsymbol p\in\mathbb R^3$ 分解为平行 $\boldsymbol r$ 的分量 $\boldsymbol p_\parallel=(\boldsymbol r\cdot\boldsymbol p)\boldsymbol r$ 与垂直 $\boldsymbol r$ 的分量 $\boldsymbol p_\perp=\boldsymbol p-\boldsymbol p_\parallel$。绕 $\boldsymbol r$ 旋转 $\vartheta$ 保持 $\boldsymbol p_\parallel$ 不变，并将 $\boldsymbol p_\perp$ 在法平面内朝 $\boldsymbol r\times\boldsymbol p_\perp$ 方向旋转 $\vartheta$：
$$R(\vartheta,\boldsymbol r)\boldsymbol p = \boldsymbol p_\parallel + \cos\vartheta\,\boldsymbol p_\perp + \sin\vartheta\,(\boldsymbol r\times\boldsymbol p_\perp).$$
特别地，$R\boldsymbol r=\boldsymbol r$，即旋转轴 $\boldsymbol r$ 是特征值 $+1$ 的不变特征向量。

<a id="sec-2.5.2"></a>

## 2.5.2 表示不唯一性与角轴逆解

::: thm 定理 2.5.A · 同步反号等价与周期性（原书式 2.26） {#thm-2.5.A}
$$R(-\vartheta,-\boldsymbol r) = R(\vartheta,\boldsymbol r), \qquad R(\vartheta+2k\pi,\boldsymbol r)=R(\vartheta,\boldsymbol r)\quad(k\in\mathbb Z).$$
通常取**主角** $\vartheta\in[0,\pi]$：在开区间 $0<\vartheta<\pi$ 内轴唯一；在零角 $\vartheta=0$ 处轴完全任意；在半圈 $\vartheta=\pi$ 处 $\pm\boldsymbol r$ 仍对应同一旋转。
:::

已知 $R=[r_{ij}]\in SO(3)$（数值计算应先独立检验 $R^{\mathrm T}R\approx I_3$ 与 $\det R\approx +1$，不能用归一化轴掩盖非法矩阵），由紧凑形式分别取迹与反对称差消元（原书式 2.27–2.28）：
- **取迹求角**：由 $\operatorname{tr}(\boldsymbol r\boldsymbol r^{\mathrm T})=\|\boldsymbol r\|^2=1$、$\operatorname{tr}S(\boldsymbol r)=0$ 得 $\operatorname{tr}R=1+2\cos\vartheta$；
- **取反对称部分求轴**：令 $\boldsymbol v = \frac12[r_{32}-r_{23},\ r_{13}-r_{31},\ r_{21}-r_{12}]^{\mathrm T} = \sin\vartheta\,\boldsymbol r$，于常规区 $0<\vartheta<\pi$ 有：
  $$\cos\vartheta = \frac{\operatorname{tr}R - 1}{2},\qquad
  \vartheta = \operatorname{Atan2}\!\left(\|\boldsymbol v\|,\ \frac{\operatorname{tr}R-1}{2}\right),\qquad
  \boldsymbol r = \frac{\boldsymbol v}{\|\boldsymbol v\|}\quad (\sin\vartheta\neq 0).$$

::: thm 定理 2.5.B · 逆解边界退化与半圈主元法 {#thm-2.5.B}
式 (2.28) 在主角端点 $\vartheta=0,\pi$ 处分母 $\sin\vartheta=0$ 而失效，须分支处理：
1. **零角退化（$\vartheta=0$）**：$R=I_3$，转轴 $\boldsymbol r$ 任意，但主旋转向量 $\boldsymbol\phi=\vartheta\boldsymbol r=\boldsymbol 0$ 唯一；
2. **半圈退化（$\vartheta=\pi$）**：$R=2\boldsymbol r\boldsymbol r^{\mathrm T}-I_3$，令对称矩阵 $B=\frac{R+I_3}{2}=\boldsymbol r\boldsymbol r^{\mathrm T}$。因 $\operatorname{tr}B=1$，必存在最大对角元 $B_{kk}\ge 1/3$。取 $r_k=\sqrt{B_{kk}}>0$，其余两分量由**非对角交叉项**恢复：
   $$r_i = \frac{B_{ik}}{r_k}\quad(i\neq k).$$
   全体取反 $-\boldsymbol r$ 亦等价；**严禁对三个对角元各自直接开正平方根**，否则丢失分量间的相对负号。近半圈处可取 $B=\frac{(R+R^{\mathrm T})/2-\cos\vartheta\,I_3}{1-\cos\vartheta}=\boldsymbol r\boldsymbol r^{\mathrm T}$ 以同一主元法求轴，再按 $\boldsymbol r\cdot\boldsymbol v$ 符号确定方向。
:::

::: ex 例 2.5.C · 三轴循环换位与半圈混合符号检验 {#ex-2.5.C}
1. **循环换位**：取 $\boldsymbol r=(1,1,1)^{\mathrm T}/\sqrt{3},\ \vartheta=120^\circ=2\pi/3$（$c=-1/2,\ s=\sqrt{3}/2$），代入 Rodrigues 公式得：
   $$R=\begin{bmatrix}0&0&1\\1&0&0\\0&1&0\end{bmatrix},\qquad
   R(1,0,0)^{\mathrm T}=(0,1,0)^{\mathrm T},\qquad
   R(1,2,3)^{\mathrm T}=(3,1,2)^{\mathrm T}.$$
   该旋转将基轴按 $x\to y\to z\to x$ 循环并保持 $R\boldsymbol r=\boldsymbol r$。反解时 $\operatorname{tr}R=0$、$\boldsymbol v=(1,1,1)^{\mathrm T}/2$，恢复 $\vartheta=\operatorname{Atan2}(\sqrt{3}/2,-1/2)=120^\circ$ 与原轴。若保持轴不变再多转 $120^\circ$（共 $240^\circ$），再左乘一次 $R$ 得 $R(3,1,2)^{\mathrm T}=(2,3,1)^{\mathrm T}$。
2. **$90^\circ$ 旋转验证**：取 $\boldsymbol r=\frac{1}{3}[2,2,1]^{\mathrm T},\ \vartheta=90^\circ$，得 $R=\boldsymbol r\boldsymbol r^{\mathrm T}+S(\boldsymbol r)=\frac{1}{9}\begin{bmatrix}4&1&8\\7&4&-4\\-4&8&1\end{bmatrix}$，$\operatorname{tr}R=1$，点 $\boldsymbol p=[1,2,2]^{\mathrm T}\,\mathrm m$ 像为 $\frac{1}{9}[22,7,14]^{\mathrm T}\,\mathrm m$（模长仍为 $3\,\mathrm m$）。
:::

<a id="lab-2.5"></a>

<div class="lab" data-lab="axisangle3d" hidden></div>

<noscript><p>无脚本模式下可直接核对例 2.5.C 及下方半圈练习。</p></noscript>

::: think 练习 1 · 半圈混合符号的相对恢复 {#practice-2.5.halfturn}
给定半圈旋转矩阵 $R=\begin{bmatrix}0&-1&0\\-1&0&0\\0&0&-1\end{bmatrix}$。直接对 $B=(R+I_3)/2$ 的对角元全部开正根有何错误？按主元法求全部合法单位轴。

::: sol 核对
$B=\begin{bmatrix}1/2&-1/2&0\\-1/2&1/2&0\\0&0&0\end{bmatrix}$。若三对角元全取正根得 $\frac{1}{\sqrt 2}(1,1,0)^{\mathrm T}$，重建矩阵 $(1,2)$ 元错为 $+1$。取最大对角主元 $k=1$、$r_x=1/\sqrt 2$，由 $B_{21}=-1/2$ 得 $r_y=-1/\sqrt 2,\ r_z=0$，故合法轴为 $\pm\frac{1}{\sqrt 2}(1,-1,0)^{\mathrm T}$。
:::
:::

<a id="sec-2.5.3"></a>

## 2.5.3 李代数 $so(3)$、指数映射与相对旋转插值

::: def 定义 2.5.3 · 李代数 $so(3)$ {#def-2.5.3}
全体 $3\times 3$ 实反对称矩阵构成的 $3$ 维线性空间称为 $SO(3)$ 的**李代数**：
$$so(3)\triangleq\bigl\{S\in\mathbb R^{3\times 3} : S^{\mathrm T}=-S\bigr\}.$$
装帽（hat）与摘帽（vee）给出 $so(3)$ 与 $\mathbb R^3$ 的线性同构：$\hat{\boldsymbol\omega}=S(\boldsymbol\omega)\in so(3)$、$(S(\boldsymbol\omega))^\vee=\boldsymbol\omega\in\mathbb R^3$，其一组自然基为绕三轴无穷小生成元：
$$S_x=\begin{bmatrix}0&0&0\\0&0&-1\\0&1&0\end{bmatrix},\quad
S_y=\begin{bmatrix}0&0&1\\0&0&0\\-1&0&0\end{bmatrix},\quad
S_z=\begin{bmatrix}0&-1&0\\1&0&0\\0&0&0\end{bmatrix},\qquad
S(\boldsymbol\omega)=\omega_x S_x+\omega_y S_y+\omega_z S_z.$$
在单位元 $I_3$ 处，小角度展开给出 $R(\delta,\boldsymbol r)=I_3+\delta S(\boldsymbol r)+O(\delta^2)$；在一般姿态 $R(t)$ 处，$\dot R$ 通常不反对称，必须右乘 $R^{\mathrm T}$ 拉回至 $I_3$ 切空间得 $\dot R R^{\mathrm T}=S(\boldsymbol\omega)\in so(3)$。
:::

::: thm 定理 2.5.D · 指数映射 $\exp:so(3)\to SO(3)$ {#thm-2.5.D}
对单位轴 $\boldsymbol r$（$\|\boldsymbol r\|=1$），记 $S=S(\boldsymbol r)$，由二重叉积公式可得 $S^2=\boldsymbol r\boldsymbol r^{\mathrm T}-I_3$，再左乘 $S$ 得 $S^3=-S$（非零幂呈**四项周期**：$S,S^2,-S,-S^2,\dots$）。将矩阵指数泰勒级数按奇偶次幂收集，即得指数映射与 Rodrigues 公式的第二来历：
$$\exp\bigl(\vartheta S(\boldsymbol r)\bigr)=I_3+\vartheta S+\frac{\vartheta^2 S^2}{2!}+\frac{\vartheta^3 S^3}{3!}+\cdots = I_3+\sin\vartheta\,S+(1-\cos\vartheta)\,S^2 = R(\vartheta,\boldsymbol r).$$
称三维向量 $\boldsymbol\phi=\vartheta\boldsymbol r\in\mathbb R^3$ 为**旋转向量（指数坐标）**。映射 $\exp:so(3)\to SO(3)$ 单值但非单射（$2k\pi S(\boldsymbol r)$ 均映至 $I_3$）。
:::

::: thm 定理 2.5.E · 对数映射分支 $\operatorname{Log}$ {#thm-2.5.E}
取定主角区间 $0<\vartheta<\pi$，选定分支的**旋转对数映射**定义为：
$$\operatorname{Log} R = \vartheta S(\boldsymbol r) = \frac{\vartheta}{2\sin\vartheta}(R-R^{\mathrm T}), \qquad
(\operatorname{Log} R)^\vee = \vartheta\boldsymbol r \in \mathbb R^3.$$
零角处平滑延拓为 $\operatorname{Log} I_3=O$（主旋转向量为 $\boldsymbol 0$）；半圈边界处取 $\pm\pi S(\boldsymbol r)$ 作为边界代表（不跨越半圈连续）。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-2la-t fig-2la-d">
<title id="fig-2la-t">旋转向量、李代数矩阵与旋转矩阵</title>
<desc id="fig-2la-d">先将角与单位轴相乘得到三维旋转向量 φ，再装帽得到反对称矩阵 S(φ)，经指数映射得到 R。摘帽只返回三维向量。反向 Log 需要选择分支，零点主向量为零，半圈有正负两个边界代表。</desc>
<defs><marker id="f2la-m" markerWidth="8" markerHeight="8" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<text class="diagram-text" x="460" y="32" text-anchor="middle">先乘成三维向量，再装帽；反解必须声明分支</text>
<g>
<rect class="diagram-node" x="30" y="75" width="230" height="85" rx="8"/>
<text class="diagram-text" x="145" y="107" text-anchor="middle">φ = ϑr ∈ ℝ³</text>
<text class="diagram-note" x="145" y="139" text-anchor="middle">旋转向量（指数坐标）</text>
<rect class="diagram-node" x="345" y="75" width="230" height="85" rx="8"/>
<text class="diagram-text" x="460" y="107" text-anchor="middle">S(φ) = ϑS(r) ∈ so(3)</text>
<text class="diagram-note" x="460" y="139" text-anchor="middle">反对称矩阵（I 处切空间）</text>
<rect class="diagram-node" x="660" y="75" width="230" height="85" rx="8"/>
<text class="diagram-text" x="775" y="107" text-anchor="middle">R = exp(S(φ)) ∈ SO(3)</text>
<text class="diagram-note" x="775" y="139" text-anchor="middle">旋转矩阵（完整姿态）</text>
</g>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.5" marker-end="url(#f2la-m)">
<path d="M264 95 H339"/><path d="M339 150 H264"/><path d="M579 95 H654"/><path d="M654 150 H579"/>
</g>
<text class="diagram-note" x="302" y="80" text-anchor="middle">hat</text><text class="diagram-note" x="302" y="174" text-anchor="middle">vee</text>
<text class="diagram-note" x="617" y="80" text-anchor="middle">exp</text><text class="diagram-note" x="617" y="174" text-anchor="middle">Log</text>
<text class="diagram-note" x="460" y="210" text-anchor="middle">exp 单值但非单射；0 ≤ ϑ &lt; π 的主旋转向量唯一，ϑ = π 时选 ±πr 代表</text>
<text class="diagram-note" x="460" y="242" text-anchor="middle">角速度 ω ∈ ℝ³；S(ω) = ṘRᵀ ∈ so(3)，一般 Ṙ 本身不反对称</text>
<text class="diagram-note" x="460" y="274" text-anchor="middle">so(3) 对加法封闭，但 exp(A+B) 一般不等于 exp(A)exp(B)</text>
</svg>
<figcaption>指数坐标 $\mathbb R^3$、李代数 $so(3)$ 与旋转群 $SO(3)$ 的映射关系（本教程绘）。</figcaption>
</figure>

::: note 李括号即叉积及全书接口 {#note-2.5.payoff}
在 $so(3)$ 上定义矩阵交换子（李括号）$[A,B]=AB-BA$。利用 $S(\boldsymbol a)S(\boldsymbol b)=\boldsymbol b\boldsymbol a^{\mathrm T}-(\boldsymbol a\cdot\boldsymbol b)I_3$，互换相减消去对称常数项，立得：
$$[S(\boldsymbol a),S(\boldsymbol b)] = \boldsymbol b\boldsymbol a^{\mathrm T}-\boldsymbol a\boldsymbol b^{\mathrm T} = S(\boldsymbol a\times\boldsymbol b).$$
这是旋转乘法不可交换性在无穷小切空间中的代数体现；第 3 章角速度推导 $\dot R=S(\boldsymbol\omega)R$（[@thm-3.1.A]）与 [§2.7](sec2-7.md#note-2.7.se3) 的 $se(3)$ 螺旋运动均直接复用上述算子体系。
:::

**相对旋转路径插值**：给定首末姿态 $R_0,R_1\in SO(3)$，不能对两者的旋转向量逐分量线性插值。应先在初始工具系中算出相对旋转 $\Delta=R_0^{\mathrm T}R_1$，取对数 $A=\operatorname{Log}\Delta=\vartheta S(\boldsymbol r)$，再沿固定轴构造合法连续路径（$s=t/T$ 时在初始工具系绕 $\boldsymbol r$、在固定系绕 $R_0\boldsymbol r$ 以恒角速度 $\vartheta/T$ 转动）：
$$R(s) = R_0\exp(sA) = R_0\exp\bigl(s\operatorname{Log}(R_0^{\mathrm T}R_1)\bigr), \qquad 0\le s\le 1.$$

::: think 练习 2 · 零角主对数与非单位基准求导 {#practice-2.5.log}
$R=I_3$ 处主旋转向量为何？对轨迹 $R(t)=R_z(t+\pi/2)$，分别求 $\dot R(0)$ 与 $\dot R(0)R(0)^{\mathrm T}$ 并判别哪一个属于 $so(3)$。

::: sol 核对
主旋转向量唯一为 $\boldsymbol 0$（转轴任意不影响乘积 $\vartheta\boldsymbol r$）。对轨迹 $R(0)=\begin{bmatrix}0&-1&0\\1&0&0\\0&0&1\end{bmatrix}$，$\dot R(0)=\begin{bmatrix}-1&0&0\\0&-1&0\\0&0&0\end{bmatrix}$（对称，非 $so(3)$），而 $\dot R(0)R(0)^{\mathrm T}=\begin{bmatrix}0&-1&0\\1&0&0\\0&0&0\end{bmatrix}=S(\boldsymbol e_z)\in so(3)$。
:::
:::

::: think 练习 3 · 相对旋转插值中的初始姿态 {#practice-2.5.interpolate}
取 $R_0=R_z(90^\circ)$、$R_1=R_z(180^\circ)$。求 $\Delta$、中点 $R(1/2)$ 与固定系旋转轴，说明为何不能漏乘 $R_0$ 写成 $\exp(\frac12\operatorname{Log}R_1)$。

::: sol 核对
$\Delta=R_0^{\mathrm T}R_1=R_z(90^\circ)$，$A=(\pi/2)S(\boldsymbol e_z)$，故 $R(1/2)=R_z(135^\circ)$，固定系转轴仍为 $\boldsymbol e_z$。而 $\exp(\frac12\operatorname{Log}R_1)=R_z(90^\circ)$ 是从 $I_3$ 出发转到 $R_1$ 的中点，漏掉了初态 $R_0$。
:::
:::

<a id="sec-2.5"></a>

::: think 默写点 · 合上书再写 {#sec-2.5-recall}
1. 写出绕任意轴 $(\vartheta,\boldsymbol r)$ 的五步固定轴合成序列及极角 $\beta$ 的起始轴。
2. 写出 Rodrigues 紧凑形式与由 $R$ 求 $\vartheta,\boldsymbol r$ 的逆解式；说明 $\vartheta=\pi$ 时如何恢复轴符号。
3. 写出 $S^2$、$S^3$ 周期关系及指数映射 $\exp(\vartheta S(\boldsymbol r))$ 闭式。

::: sol 核对
1. $R_z(\alpha)R_y(\beta)R_z(\vartheta)R_y(-\beta)R_z(-\alpha)$（左乘）；$\beta\in[0,\pi]$ 从 $+z$ 量起。
2. $c_\vartheta I_3+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$；$\cos\vartheta=(\operatorname{tr}R-1)/2$、$\boldsymbol r=\frac{1}{2\sin\vartheta}[r_{32}-r_{23},r_{13}-r_{31},r_{21}-r_{12}]^{\mathrm T}$；$\vartheta=\pi$ 时从 $B=(R+I_3)/2$ 最大对角主元取正根，再用非对角交叉项 $r_i=B_{ik}/r_k$ 恢复相对符号。
3. $S^2=\boldsymbol r\boldsymbol r^{\mathrm T}-I_3$、$S^3=-S$（四项周期）；$\exp(\vartheta S)=I_3+\sin\vartheta\,S+(1-\cos\vartheta)\,S^2$。
:::
:::

## 2.5 小结与常见错误

**主线**：任意空间旋转均可化归为绕单位轴 $\boldsymbol r$ 转 $\vartheta$；五步固定轴合成与指数映射殊途同归地给出 Rodrigues 公式，迹与反对称差分别解出角和轴，半圈处改用 $(R+I_3)/2$ 主元交叉项恢复符号。

| 公式 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $R_z(\alpha)R_y(\beta)R_z(\vartheta)R_y(-\beta)R_z(-\alpha)$ | 固定轴右起左乘；$\beta\in[0,\pi]$ 从 $+z$ 量起 | 极点 $\boldsymbol r=\pm\boldsymbol z$ 另取 $\alpha=0,\beta=0,\pi$ |
| $R=c_\vartheta I_3+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$ | $\|\boldsymbol r\|=1$，右手叉积约定 | $\vartheta=\pi$ 反对称差为零；不可用对角元全开正根求轴 |
| $\exp(\vartheta S)=I_3+s_\vartheta S+(1-c_\vartheta)S^2$ | $S\in so(3)$，$\|\boldsymbol r\|=1$ | $\exp$ 单值非单射；一般姿态 $\dot R\notin so(3)$，应算 $\dot R R^{\mathrm T}$ |
| $R(s)=R_0\exp(s\operatorname{Log}(R_0^{\mathrm T}R_1))$ | $0\le s\le 1$，取定主对数分支 | 不可忽略 $R_0$ 或对两个旋转向量逐分量线性插值 |

::: think 本节的课堂幻灯片（源料对照）
| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 0:25:05–0:25:51 | [axisangle-derivation.jpg](../assets/ch02/axisangle-derivation.jpg) | 五步序列与球坐标角消元 | 按原书图 2.10 写出五步左乘推导与方位/极角图 |
| — | [axisangle-matrix.jpg](../assets/ch02/axisangle-matrix.jpg) | Rodrigues 9 元阵与反号等价 | 补全相似变换证明（[@pf-2.5.rodrigues]）与 [@thm-2.5.A] |
:::
