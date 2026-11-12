# 2.6 单位四元数

[2.5](sec2-5.md) 用单位轴和转角描述姿态。本节的**[单位四元数](../recall.md#quaternion)**（unit quaternion，又称欧拉参数）将半角与轴打包：同步反号的两组角轴参数会映到同一个四元数，零角时也不再需要指定轴。但它仍保留 $Q\sim-Q$ 的双重覆盖，半圈提取需选择稳定支路；不能把换表示理解为消除全部不唯一。

::: note 本节定位（教材补充 · 课程未授）
本节对应原书 §2.6，先修内容是[旋转矩阵](../recall.md#rotation)与角轴。学习重点是：把四元数变回可检查的矩阵、从半圈矩阵正确提取四元数、读对乘法顺序，以及保持相邻时刻的符号连续。课程覆盖范围见[范围声明](../preface-scope.md)。
:::



<a id="sec-2.6.1"></a>

## 2.6.1 定义与单位约束

::: def 定义 2.6.1 · 单位四元数 {#def-2.6.1}
**单位四元数**（欧拉参数）定义为四元组 $Q=\{\eta,\boldsymbol\epsilon\}$，其中

$$\eta=\cos\frac{\vartheta}{2},\qquad \boldsymbol\epsilon=\sin\frac{\vartheta}{2}\,\boldsymbol r\qquad(\text{原书式 }2.30\text{–}2.31)$$

$\eta$ 称**标量部分**，$\boldsymbol\epsilon=[\epsilon_x\ \epsilon_y\ \epsilon_z]^T$ 称**向量部分**，二者受单位约束

$$\eta^2+\epsilon_x^2+\epsilon_y^2+\epsilon_z^2=1\qquad(\text{原书式 }2.32)$$

本文采用 **Hamilton 乘法、标量在前**的存储顺序 $q=(\eta,\epsilon_x,\epsilon_y,\epsilon_z)$，并沿用主动列向量约定 $p_{\rm new}=R(q)p$。软件可能把标量放在最后，调用前必须核对顺序；不能直接照抄四个数。

四个参数受一个单位约束，位于 $\mathbb R^4$ 中的三维单位球面 $S^3$，局部独立参数为 3；它仍是带约束的四参数表示，并通过 $q\sim-q$ 双重覆盖 $SO(3)$。零四元数没有方向，也不能归一化成单位四元数。
:::

::: thm 原理 2.6.A · 四元数修掉了哪些缺陷 {#thm-2.6.A}
关键差别在**半角打包**：代入 $-\vartheta$ 与 $-\boldsymbol r$，得 $\cos\frac{-\vartheta}{2}=\cos\frac{\vartheta}{2}$、$\sin\frac{-\vartheta}{2}(-\boldsymbol r)=\sin\frac{\vartheta}{2}\boldsymbol r$——**同一结果**。
1. **合并同步反号的参数组**：$(\vartheta,\boldsymbol r)$ 与 $(-\vartheta,-\boldsymbol r)$ 映到同一个 Q。这是原书式 2.26 所列重复参数的消除，不意味着所有重复表示都消失。
2. **仍保留 $Q\sim-Q$**：转角加 $2\pi$ 使四元数整体反号，旋转不变。非半圈处可取 $\eta>0$ 定符号；半圈 $\eta=0$ 时还需额外约定，不能仅靠 $\eta\ge0$ 选出唯一代表。
3. **提取算法仍需分支**：零角可用单位四元数代表，半圈也有合法四元数，但含除法的提取公式必须避开小分母；下一部分分别检查其适用范围。
:::

下图区分同步反号的参数合并与仍保留的 Q/−Q 双重覆盖。非半圈可由标量部分符号选代表，半圈边界还需额外约定。

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-26-title fig-26-desc">
<title id="fig-26-title">角轴参数到四元数，再到旋转矩阵</title>
<desc id="fig-26-desc">第一行与第二行的同步反号角轴参数给出同一个 Q；第三行转角增加整圈得到 −Q。Q 与 −Q 均正向映射到同一旋转矩阵 R。右侧文字说明单位四元数在四维空间的三维单位球面上。</desc>
<defs><marker id="f26-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<text class="diagram-text" x="130" y="38" text-anchor="middle">角轴参数</text>
<text class="diagram-text" x="360" y="38" text-anchor="middle">半角打包</text>
<text class="diagram-text" x="590" y="38" text-anchor="middle">旋转矩阵</text>
<g class="diagram-node">
<rect x="35" y="65" width="190" height="45" rx="8"/>
<rect x="35" y="150" width="190" height="45" rx="8"/>
<rect x="35" y="235" width="190" height="45" rx="8"/>
<rect x="300" y="105" width="120" height="50" rx="8"/>
<rect x="300" y="235" width="120" height="45" rx="8"/>
<rect x="535" y="165" width="110" height="50" rx="8"/>
</g>
<g class="diagram-text" text-anchor="middle">
<text x="130" y="94">(ϑ, r)</text>
<text x="130" y="179">(−ϑ, −r)</text>
<text x="130" y="264">(ϑ + 2π, r)</text>
<text x="360" y="137">Q</text>
<text x="360" y="264">−Q</text>
<text x="590" y="197">同一个 R</text>
</g>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f26-m)">
<path d="M225 87 L298 120"/>
<path d="M225 173 L298 140"/>
<path d="M225 257 H298"/>
<path d="M420 130 L533 180"/>
<path d="M420 257 L533 200"/>
</g>
<g class="diagram-note">
<text x="690" y="105">Q 与 −Q 是 S³ 上的对径点</text>
<text x="690" y="143">S³ 位于四维空间 R⁴ 中</text>
<text x="690" y="181">η² + ‖ε‖² = 1</text>
<text x="690" y="219">它们表示同一物理姿态</text>
<text x="690" y="257">逆向提取需要选代表</text>
</g>
<text class="diagram-note" x="460" y="320" text-anchor="middle">同步反号合并成同一个 Q；增加 2π 得到 −Q；增加 4π 才回到 Q。</text>
</svg>
<figcaption>本教程绘：同步反号的角轴参数映到同一个 Q；转角加 $2\pi$ 则仍给出 Q 与 −Q 两个代表。非半圈取 $\eta>0$ 可定符号，半圈必须另作约定。</figcaption>
</figure>

<a id="sec-2.6.2"></a>

## 2.6.2 正解、逆解与乘法

### 正解：单位四元数到旋转矩阵

以下公式假设 $\eta^2+\|\boldsymbol\epsilon\|^2=1$。已确认输入表示旋转、仅因数值误差略偏离单位长度时，可以先归一化；零输入必须拒绝。给定单位四元数，旋转矩阵为（原书式 2.33）

$$R(\eta,\boldsymbol\epsilon)=\begin{bmatrix}
2(\eta^2+\epsilon_x^2)-1 & 2(\epsilon_x\epsilon_y-\eta\epsilon_z) & 2(\epsilon_x\epsilon_z+\eta\epsilon_y)\\
2(\epsilon_x\epsilon_y+\eta\epsilon_z) & 2(\eta^2+\epsilon_y^2)-1 & 2(\epsilon_y\epsilon_z-\eta\epsilon_x)\\
2(\epsilon_x\epsilon_z-\eta\epsilon_y) & 2(\epsilon_y\epsilon_z+\eta\epsilon_x) & 2(\eta^2+\epsilon_z^2)-1
\end{bmatrix}$$

::: proof 证明 · 式 2.33 是 Rodrigues 紧凑形式的半角改写（本编补充）
把 $\eta=\cos\frac\vartheta2$、$\boldsymbol\epsilon=\sin\frac\vartheta2\,\boldsymbol r$ 代入 [2.5.1](sec2-5.md#sec-2.5.1) 的紧凑形式 $R=c_\vartheta I+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$。用倍角公式 $c_\vartheta=2\eta^2-1=1-2\sin^2\frac\vartheta2$、$s_\vartheta=2\sin\frac\vartheta2\cos\frac\vartheta2$，三项逐个改写：

$$c_\vartheta I=(2\eta^2-1)I,\qquad
(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}=2\sin^2\tfrac\vartheta2\ \boldsymbol r\boldsymbol r^{\mathrm T}=2\,\boldsymbol\epsilon\,\boldsymbol\epsilon^{\mathrm T},\qquad
s_\vartheta S(\boldsymbol r)=2\sin\tfrac\vartheta2\cos\tfrac\vartheta2\ S(\boldsymbol r)=2\eta\,S(\boldsymbol\epsilon).$$

（$S(\boldsymbol\epsilon)=\sin\frac\vartheta2\,S(\boldsymbol r)$——$S(\cdot)$ 对参数线性。）合并得**四元数紧凑形式**

$$R=(2\eta^2-1)I+2\,\boldsymbol\epsilon\,\boldsymbol\epsilon^{\mathrm T}+2\eta\,S(\boldsymbol\epsilon),$$

逐元素展开：对角线 $=2\eta^2-1+2\epsilon_i^2=2(\eta^2+\epsilon_i^2)-1$；非对角 $(i,j)=2\epsilon_i\epsilon_j+2\eta\,S(\boldsymbol\epsilon)_{ij}$，而 $S(\boldsymbol\epsilon)_{xy}=-\epsilon_z$ 等——即式 2.33 的九个元素。□
:::

### 逆解：先求平方，再从最大分量提取

由紧凑形式可直接得到

$$\operatorname{tr}R=4\eta^2-1,\qquad
r_{ii}=2\eta^2-1+2\epsilon_i^2,\qquad
R-R^{\mathrm T}=4\eta S(\boldsymbol\epsilon).$$

因此，在**选取 $\eta>0$** 时，原书式 2.34–2.35 的分量符号法为

$$\eta=\tfrac12\sqrt{\operatorname{tr}R+1},\qquad
\boldsymbol\epsilon=\tfrac12\begin{bmatrix}
\operatorname{sgn}(r_{32}-r_{23})\sqrt{1+r_{11}-r_{22}-r_{33}}\\
\operatorname{sgn}(r_{13}-r_{31})\sqrt{1-r_{11}+r_{22}-r_{33}}\\
\operatorname{sgn}(r_{21}-r_{12})\sqrt{1-r_{11}-r_{22}+r_{33}}
\end{bmatrix}.$$

这里沿用原书 $\operatorname{sgn}(0)=+1$ 的约定。对 $\eta>0$，反对称部分确实给出每个 $\epsilon_i$ 的符号；但在**精确半圈 $\eta=0$** 时，反对称部分全零，不能再由它确定各分量的相对符号。逐个把零符号取正不能修复这个问题。

::: ex 例 2.6.B · 原书分量符号公式的半圈反例 {#ex-2.6.B}
取

$$R_\pi=\begin{bmatrix}0&-1&0\\-1&0&0\\0&0&-1\end{bmatrix},\qquad
\boldsymbol r=(1,-1,0)^{\mathrm T}/\sqrt2.$$

这是绕该轴转半圈的合法旋转，正确四元数可取 $q=(0,1/\sqrt2,-1/\sqrt2,0)$ 或其整体相反数。原书符号法却把三个反对称差都读成 0，给出

$$q_{\rm sign}=(0,1/\sqrt2,1/\sqrt2,0),\qquad
R(q_{\rm sign})=\begin{bmatrix}0&1&0\\1&0&0\\0&0&-1\end{bmatrix}\ne R_\pi.$$

两者不是整体反号，不能代表同一个姿态。原书“式 2.34–2.35 无奇点”的说明在此边界不足以支持直接使用，见[勘误 E2.7](errata.md#errata-2.7)。
:::

::: method 稳定提取：选最大的四元数分量 {#method-2.6.extract}
先确认 $R^{\mathrm T}R\approx I$、$\det R\approx1$。令 $q=(\eta,\epsilon_x,\epsilon_y,\epsilon_z)^{\mathrm T}$，由正解构造

$$H=\begin{bmatrix}
1+r_{11}+r_{22}+r_{33}&r_{32}-r_{23}&r_{13}-r_{31}&r_{21}-r_{12}\\
r_{32}-r_{23}&1+r_{11}-r_{22}-r_{33}&r_{12}+r_{21}&r_{13}+r_{31}\\
r_{13}-r_{31}&r_{12}+r_{21}&1-r_{11}+r_{22}-r_{33}&r_{23}+r_{32}\\
r_{21}-r_{12}&r_{13}+r_{31}&r_{23}+r_{32}&1-r_{11}-r_{22}+r_{33}
\end{bmatrix}=4qq^{\mathrm T}.$$

例如 $H_{01}=r_{32}-r_{23}=4\eta\epsilon_x$，$H_{12}=r_{12}+r_{21}=4\epsilon_x\epsilon_y$。$H$ 用 **0–3 下标**对应四元数分量；$R$ 仍用 1–3 下标。

1. 取最大对角元 $H_{kk}$；
2. 设 $q_k=\tfrac12\sqrt{H_{kk}}>0$；
3. 用该列恢复其余分量：$q_i=H_{ik}/(4q_k)$；
4. 检查单位长度并重建矩阵，不能只归一化就宣称输入合法。

因为 $\sum H_{ii}=4$，最大项至少 1，所以选出的 $q_k\ge1/2$，分母不接近零。这个分支法在零角、半圈及一般姿态都能使用；半圈时向量分量间的**对称交叉项**仍保留相对符号。

本节默认保留“最大分量取正”的代表。如要 $\eta\ge0$，在 $\eta<0$ 时整体反号；$\eta=0$ 时仍需额外规则。选择最大项发生切换时，代表可能整体变号，后面的连续跟踪还要做符号对齐。含噪矩阵若不满足旋转条件，应先单独处理，不在这里悄悄修正。
:::

对例 2.6.B，$H$ 的对角为 $(0,2,2,0)$；取 $k=1$，$q_1=1/\sqrt2$，再由 $H_{21}=-2$ 得 $q_2=-1/\sqrt2$。交叉项给出了原符号法丢失的负号。

<a id="lab-2.6"></a>

### 操作：看见双重覆盖，也检查反解是否重建

演示默认加载例 2.6.B 的**精确矩阵**。先预测：把四元数整体反号，哪些数会变、哪些几何量应保持不变？

1. 比较最大分量提取与原书分量符号法的重建残差。前者应重建原矩阵，后者在这个精确反例中失败。
2. 切换 Q 与 −Q，核对四个数一起反号，但画面、矩阵和点的像保持不变。
3. 调节轴或角度后，输入改由角轴生成。固定轴，比较 $0^\circ$、$360^\circ$、$720^\circ$：姿态相同，四元数依次为 $+1,-1,+1$。
4. 试 $179.99^\circ$ 与 $180.01^\circ$，观察生成四元数的标量部分连续越过 0。再载入“精确半圈反例”，不要依靠浮点数中偶然残留的极小反对称差来定符号。
5. 把轴输入全设为 0，观察错误；按“重置四元数与视角”恢复默认反例、符号、控件与相机。

<div class="lab" data-lab="quaternion3d" hidden></div>

没有脚本时，用上面的精确矩阵和下面三份独立练习完成相同核对；不会只剩一个空操作框。

::: think 练习 1 · 零角、半圈与四参数的顺序 {#practice-2.6.extract}
$R=I$ 时最大分量法选哪个分量？对例 2.6.B，若把向量部分按“全部非负”恢复，错在哪里？最后把正确四元数从标量在前换写成标量在后。

::: sol 核对
$I$ 给出 $\operatorname{diag}H=(4,0,0,0)$，可取 $q=(1,0,0,0)$。半圈的对角项只给绝对值，必须用 $H_{21}=-2$ 恢复相对负号。标量在前为 $(0,1/\sqrt2,-1/\sqrt2,0)$；标量在后为 $(1/\sqrt2,-1/\sqrt2,0,0)$。四个数的次序改变，不代表换了姿态。
:::
:::
逆四元数由转置关系给出（原书式 2.36）：

$$Q^{-1}=\{\eta,-\boldsymbol\epsilon\}\quad\Longleftrightarrow\quad R^{-1}=R^T .$$

（把 $\{\eta,-\boldsymbol\epsilon\}$ 代入式 2.33：$\boldsymbol\epsilon\to-\boldsymbol\epsilon$ 使反对称件反号、对称件不变，恰好逐元素转置。）

### 乘法：右侧旋转先施加

在本文 Hamilton、主动列向量约定下，四元数乘法满足 **$R(Q_1\otimes Q_2)=R_1R_2$**。作用到点时，**先施加右侧的 $R_2$，再施加左侧的 $R_1$**。若题目按时间说“先 $R_1$，后 $R_2$”，结果应为 $Q_2\otimes Q_1$。原书式 2.37 为

$$Q_1\otimes Q_2=\{\eta_1\eta_2-\boldsymbol\epsilon_1^T\boldsymbol\epsilon_2,\ \ \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\}.$$

::: note 乘法公式从哪来——「标量 + 向量」的数（本编补充）
四元数是形如 $\eta+\epsilon_x i+\epsilon_y j+\epsilon_z k$ 的数：标量加三个虚部，虚单位满足 $i^2=j^2=k^2=ijk=-1$（等价地 $ij=k,\ jk=i,\ ki=j$，反序差一负号）。按分配律相乘，再把标量与向量部分分别收集，得到

$$(a,\boldsymbol u)\otimes(b,\boldsymbol v)=\big(ab-\boldsymbol u\cdot\boldsymbol v,\ \ a\boldsymbol v+b\boldsymbol u+\boldsymbol u\times\boldsymbol v\big).$$

式 2.37 就是这个乘法规则。交换顺序会使叉积项反号，因而**一般不可交换**；同轴等特殊情形可以交换，不能写成任意两次乘法都不相等。共轭 $\bar Q=\{\eta,-\boldsymbol\epsilon\}$ 满足 $Q\otimes\bar Q=\{\eta^2+\|\boldsymbol\epsilon\|^2,\boldsymbol0\}$；对单位四元数结果为 $\{1,\boldsymbol0\}$，所以共轭就是逆。由纯向量四元数 $(0,p)$ 的夹乘 $Q\otimes(0,p)\otimes Q^{-1}=(0,R(Q)p)$ 也可检查合成顺序：先夹乘 $Q_2$，再夹乘 $Q_1$，合并就是 $Q_1\otimes Q_2$。
:::

::: ex 例 2.6.C · 两个 90° 旋转，顺序不能省略 {#ex-2.6.C}
令 $Q_x=(\tfrac1{\sqrt2},\tfrac1{\sqrt2},0,0)$、$Q_z=(\tfrac1{\sqrt2},0,0,\tfrac1{\sqrt2})$，分别表示绕固定 $x,z$ 转 $90^\circ$。

$$Q_z\otimes Q_x=(\tfrac12,\tfrac12,\tfrac12,\tfrac12),\qquad
Q_x\otimes Q_z=(\tfrac12,\tfrac12,-\tfrac12,\tfrac12).$$

第一式对应 $R_z(90^\circ)R_x(90^\circ)$，先 $x$ 后 $z$，将 $p=(0,1,0)^{\mathrm T}$ 送到 $(0,0,1)^{\mathrm T}$；交换顺序则将同一点送到 $(-1,0,0)^{\mathrm T}$。四元数中的叉积符号与矩阵时序相互核对。
:::

::: think 练习 2 · 逆、乘法和点的像 {#practice-2.6.product}
先绕固定 $z$ 转 $90^\circ$，再绕固定 $x$ 转 $90^\circ$。用例 2.6.C 的符号写出合成四元数和逆四元数，并求 $p=(0,1,0)^{\mathrm T}$ 的像；最后验证逆变换把点带回去。

::: sol 核对
按时间顺序应写 $Q_x\otimes Q_z=(1,1,-1,1)/2$，逆为 $(1,-1,1,-1)/2$。合成矩阵为

$$R_x(90^\circ)R_z(90^\circ)=\begin{bmatrix}0&-1&0\\0&0&-1\\1&0&0\end{bmatrix}.$$

第二列给出 $Rp=(-1,0,0)^{\mathrm T}$，再乘 $R^{\mathrm T}$ 回到 $(0,1,0)^{\mathrm T}$。若写 $Q_z\otimes Q_x$，结果会变成 $(0,0,1)^{\mathrm T}$。
:::
:::

::: note 用 2.5.3 的语言读四元数（本编补充）
令纯向量四元数 $U=(0,\boldsymbol u)$。由乘法规则，$U^2=(-\|\boldsymbol u\|^2,\boldsymbol0)$，所以指数级数的偶次项合成余弦、奇次项合成正弦。当 $\boldsymbol u\ne0$ 时，

$$\exp\big((0,\boldsymbol u)\big)=\Big(\cos|\boldsymbol u|,\ \ \sin|\boldsymbol u|\,\frac{\boldsymbol u}{|\boldsymbol u|}\Big),$$

$\boldsymbol u=0$ 时单独取 $\exp(0)=(1,\boldsymbol0)$，也等于上式的连续极限。于是 $Q=\exp((0,\tfrac\vartheta2\boldsymbol r))=(\cos(\vartheta/2),\sin(\vartheta/2)\boldsymbol r)$。转角增加 $2\pi$ 时，四元数整体反号；增加 $4\pi$ 才回到原四元数，而物理姿态每增加 $2\pi$ 就已重复。这里用的是四元数自身的幂，不是叉积矩阵的“三循环”。
:::


<a id="sec-2.6.3"></a>

## 2.6.3 连续跟踪与姿态插值（本编补充）

### 相邻姿态先对齐符号

从每一帧矩阵独立提取四元数，可能先得到 $q$，下一帧却选中接近 $-q$ 的代表。姿态没有跳变，四个参数却会跳变。**单位球面光滑不等于提取算法会自动选到连续代表**。

对已归一化的相邻四元数，计算四维点积 $d=q_{\rm prev}^{\mathrm T}q_{\rm new}$：若 $d<0$，将 $q_{\rm new}$ 整体反号。这会选到离上一代表更近的符号。$d=0$ 对应物理上的半圈差，两条最短路径同样长，必须按任务选路；若采样间转动太大，仅凭两个姿态也无法恢复实际转过几圈。

例如固定 $z$ 轴从 $170^\circ$ 转到 $190^\circ$，连续表示为

$$q_{170}=(\cos85^\circ,0,0,\sin85^\circ),\quad
q_{190}=(\cos95^\circ,0,0,\sin95^\circ).$$

二者点积为 $\cos10^\circ>0$。若每帧强制 $\eta\ge0$，第二个代表会被翻成 $-q_{190}$，两帧点积反而变负。连续跟踪时应保留符号历史；数值积分后还要检查单位长度，不能把四元数表示本身当作稳定性的保证。

### SLERP：沿单位球面插值

对单位端点先按上述规则对齐符号，令 $d=q_0^{\mathrm T}q_1\in[0,1]$、$\Omega=\arccos d$。在 $0<\Omega\le\pi/2$ 时，

$$q(s)=\frac{\sin((1-s)\Omega)}{\sin\Omega}q_0+
\frac{\sin(s\Omega)}{\sin\Omega}q_1,\qquad 0\le s\le1.$$

这叫**球面线性插值**（SLERP）。球面角为 $\Omega$，物理转角为 $2\Omega$；$s$ 随时间线性增长时，对应绕固定轴以恒角速度走最短姿态路径，和 [§2.5 的相对旋转插值](sec2-5.md#sec-2.5.3) 表达同一条选定路径。

当 $d=1$ 时端点相同，直接取常量 $q_0$，不能除以 $\sin\Omega=0$；非常接近 1 时可用归一化线性插值近似，**它一般不严格恒角速度**。$d=0$ 时物理转角是 $\pi$，两种符号对应两条等长路径，选定后再插。实现中应将点积限制到合法区间，但不能用截断掩盖非单位输入。

::: think 练习 3 · 同一姿态为什么会插值出零？ {#practice-2.6.interpolate}
取 $q_0=(1,0,0,0)$、$q_1=(-1,0,0,0)$。直接做四个分量的线性插值，在 $s=1/2$ 得到什么？正确的姿态路径是什么？再求上面 $170^\circ\to190^\circ$ 的中点姿态。

::: sol 核对
直接线性插值得到零四元数，不能归一化。两端其实是同一姿态；先将 $q_1$ 反号，与 $q_0$ 对齐后，路径保持单位姿态不动。

$170^\circ\to190^\circ$ 的连续端点点积为 $\cos10^\circ$，SLERP 中点为 $(0,0,0,1)$，即 $R_z(180^\circ)$。若没有先纠正人为的相反符号，就可能沿另一条长路径插值；连续表示的标量部分经过 0 是正常的。
:::
:::

<a id="sec-2.6"></a>

::: think 默写点 · 合上书再写（主动回忆）



1. 写出 $(\vartheta,\boldsymbol r)\to(\eta,\boldsymbol\epsilon)$ 的换算与单位约束。
2. 四元数的独立参数是几个？为什么？
3. 半角打包合并了哪些参数？它是否消除了全部不唯一性？
4. 为什么精确半圈不能用反对称差逐个定符号？如何选择稳定提取分支？
5. $Q_1\otimes Q_2$ 谁先作用？SLERP 前为何要先比较四维点积？

::: sol 核对

$\eta=\cos\frac{\vartheta}{2}$、$\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\boldsymbol r$；约束 $\eta^2+\epsilon_x^2+\epsilon_y^2+\epsilon_z^2=1$。

3 个（4 参数 − 1 约束），与最简表示的要求不矛盾。

同步反号的角轴参数映到同一个 Q；零角可直接用单位四元数代表。Q 与 −Q 仍表示同一姿态，半圈提取须避开小分母，不能把某一支公式当成处处可直接计算。

半圈时 $R-R^{\mathrm T}=0$，分量相对符号要从对称交叉项读出。构造 $H=4qq^{\mathrm T}$，选最大对角元，再由其所在列恢复其他分量。

$Q_1\otimes Q_2$ 对应 $R_1R_2$，右侧的 $Q_2$ 先作用。插值先将负点积的端点整体反号，避免把同一或相近姿态的相反代表当作远端点；半圈差另定路径。

:::

:::

## 2.6 小结与常见错误

- **一条主线**：半角打包与单位约束 → 矩阵正解 → 最大分量提取与重建 → Hamilton 乘法/共轭逆 → 符号对齐与球面插值。原书式 2.34–2.35 的分量符号法不能直接用于所有精确半圈。
- **参数与边界**：同步反号的参数合并，但 Q/−Q 双重覆盖保留；半圈须另定符号与选择稳定提取支路。
- **一个取舍**：4 参数受单位约束；计算方便，但符号选取与提取分支仍需明确。

::: think 常见错误清单 · 自查四条
1. 未核对 Hamilton/其他乘法口径、标量在前/在后的顺序，就直接交换四个数或复制公式。
2. 把分量符号法的三个零都取正，当成精确半圈的合法补救；或写“先 Q₁ 后 Q₂”却算 Q₁⊗Q₂。
3. 认为 $\eta\ge0$ 保证全局唯一且连续；或不对齐符号就直接插值 q 与 −q。
4. 忘记单位约束，甚至把零四元数也拿去归一化；符号连续和数值稳定性仍需单独检查。
:::

下一节 [2.7 齐次变换](sec2-7.md) 加入平移，把完整位姿写成一个矩阵。这里的单位四元数描述指向，不包含平移。
