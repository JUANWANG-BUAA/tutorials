# 3.5 逆微分运动学

[3.4 节](sec3-4.md)将线性速度方程 $J\dot{\boldsymbol q}=\boldsymbol v$ 的全部解写为特解加零空间向量。实际规划与控制中还需回答三个问题：当方阵 $J$ 满秩时如何用数值积分求关节轨迹？当机构冗余、解有无穷多组时，如何依据关节代价挑出最合适的那一组？当靠近奇点导致最小奇异值极小时，如何抑制关节速度飙升？本节依次解决这三类问题（固定当前位形，记选定任务方程 $\boldsymbol v=J\dot{\boldsymbol q}$，其中 $J\in\mathbb R^{r\times n},\ \boldsymbol v\in\mathbb R^r,\ \dot{\boldsymbol q}\in\mathbb R^n$）。

<a id="sec-3.5.0"></a>

## 3.5.1 方阵情形与欧拉数值积分

当任务维数等于关节自由度（$r=n$）且当前非奇异（$J$ 满秩）时，速度方程存在唯一精确解：

$$\dot{\boldsymbol q} = J^{-1}(\boldsymbol q)\boldsymbol v.$$

已知初始关节位置 $\boldsymbol q(0)$ 时，理论上沿时间积分 $\boldsymbol q(t)=\boldsymbol q(0)+\int_0^t\dot{\boldsymbol q}(\tau)\,\mathrm d\tau$ 即可求得整段关节运动。数字控制器采用固定步长 $\Delta t$ 离散推进，最基本的前向欧拉（Euler）格式在每步重新计算 $J(\boldsymbol q_k)$ 后更新：

$$\boldsymbol q_{k+1} = \boldsymbol q_k + J^{-1}(\boldsymbol q_k)\boldsymbol v_k\Delta t.$$

这一方法利用了速度关系的线性性，能避开复杂构型闭合位姿逆解的解析困难；但须注意**瞬时速度精确不保证有限时间步不发生位姿漂移**（存在 $O(\Delta t^2)$ 单步截断漂移）。

::: ex 例 3.5.A · 平面两连杆臂的前向欧拉步长漂移检验
两杆长均为 $1\,\mathrm m$，处于 $\boldsymbol q_k=[0,\pi/2]^{\mathrm T}$（笔尖位于 $(1,1)\,\mathrm m$），期望速度 $\boldsymbol v=[0,1]^{\mathrm T}\,\mathrm{m/s}$。此时位置雅可比 $J=\begin{bmatrix}-1&-1\\1&0\end{bmatrix}$，解得 $\dot{\boldsymbol q}=[1,-1]^{\mathrm T}\,\mathrm{rad/s}$。

1. 取 $\Delta t=0.1\,\mathrm s$：更新 $\boldsymbol q_{k+1}=[0.1,\pi/2-0.1]^{\mathrm T}$，因第二杆绝对角 $\vartheta_1+\vartheta_2=\pi/2$，正运动学实际末端位置为 $[\cos 0.1,\,1+\sin 0.1]^{\mathrm T}\approx[0.995004,\,1.099833]^{\mathrm T}\,\mathrm m$，相比理想直线终点 $(1,\,1.1)\,\mathrm m$ 产生了 $0.004996\,\mathrm m$ 横向偏移。
2. 将步长减半取 $\Delta t=0.05\,\mathrm s$：同起点一步得 $[\cos 0.05,\,1+\sin 0.05]^{\mathrm T}\approx[0.998750,\,1.049979]^{\mathrm T}\,\mathrm m$，横向偏移降至 $1-\cos 0.05\approx 0.001250\,\mathrm m$（约为步长减半前的 $1/4$，印证首项误差为 $\frac12\Delta t^2$）。实际闭环控制常配合误差反馈抑制累积漂移（见 [3.7 节](sec3-7.md)）。
:::

<a id="sec-3.5.1"></a>

## 3.5.2 冗余情形：加权最小范数优化与右伪逆

当机构冗余（$r<n$）且 $J\in\mathbb R^{r\times n}$ 行满秩时，精确满足任务的关节速度解有无穷多组。取对称正定权重矩阵 $W\in\mathbb R^{n\times n}$（$W=W^{\mathrm T}\succ O$，对希望尽量少动的关节赋予较大对角权重），构造带约束的瞬时二次优化问题：

$$\min_{\dot{\boldsymbol q}}\ C(\dot{\boldsymbol q})=\frac12\dot{\boldsymbol q}^{\mathrm T}W\dot{\boldsymbol q},\qquad \text{s.t.}\quad J\dot{\boldsymbol q}=\boldsymbol v.$$

### 拉格朗日乘子求解与 $G=JW^{-1}J^{\mathrm T}$ 可逆性证明

引入乘子向量 $\boldsymbol\lambda\in\mathbb R^r$ 构造增广泛函 $\mathcal L(\dot{\boldsymbol q},\boldsymbol\lambda)=\frac12\dot{\boldsymbol q}^{\mathrm T}W\dot{\boldsymbol q}+\boldsymbol\lambda^{\mathrm T}(\boldsymbol v-J\dot{\boldsymbol q})$。对未知向量求梯度置零得一阶驻点条件：

$$W\dot{\boldsymbol q}-J^{\mathrm T}\boldsymbol\lambda=\boldsymbol 0,\qquad J\dot{\boldsymbol q}=\boldsymbol v.$$

由第一式解出 $\dot{\boldsymbol q}=W^{-1}J^{\mathrm T}\boldsymbol\lambda$ 并代入约束，得 $G\boldsymbol\lambda=\boldsymbol v$，其中 $G=JW^{-1}J^{\mathrm T}\in\mathbb R^{r\times r}$。

- **为什么 $G$ 必对称正定可逆？** 因 $W\succ O \implies W^{-1}\succ O$；又因 $J$ 行满秩等价于 $J^{\mathrm T}$ 列满秩（对任意非零 $\boldsymbol a\in\mathbb R^r$ 必有 $J^{\mathrm T}\boldsymbol a\neq\boldsymbol 0$），故二次型 $\boldsymbol a^{\mathrm T}G\boldsymbol a=(J^{\mathrm T}\boldsymbol a)^{\mathrm T}W^{-1}(J^{\mathrm T}\boldsymbol a)>0$ 严格成立，从而 $G\succ O$ 可逆。（不可含糊声称“矩阵相乘不改变秩”，因为长方矩阵相乘必须借助正定二次型论证满秩性。）

解出 $\boldsymbol\lambda=G^{-1}\boldsymbol v$ 并回代，得到唯一驻点候选解及**加权右伪逆** $J_W^\#$：

$$\dot{\boldsymbol q}_W = J_W^\#\boldsymbol v,\qquad J_W^\# = W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T})^{-1}\in\mathbb R^{n\times r}.$$

- **全局唯一最优性验证**：任取另一可行解 $\dot{\boldsymbol q}_W+\boldsymbol z$（必满足 $J\boldsymbol z=\boldsymbol 0$），作代价函数差：

$$C(\dot{\boldsymbol q}_W+\boldsymbol z)-C(\dot{\boldsymbol q}_W) = \boldsymbol z^{\mathrm T}W\dot{\boldsymbol q}_W+\frac12\boldsymbol z^{\mathrm T}W\boldsymbol z = (J\boldsymbol z)^{\mathrm T}\boldsymbol\lambda + \frac12\boldsymbol z^{\mathrm T}W\boldsymbol z = \frac12\boldsymbol z^{\mathrm T}W\boldsymbol z > 0\ (\boldsymbol z\neq\boldsymbol 0).$$

因此 $\dot{\boldsymbol q}_W$ 在固定当前 $(J,\boldsymbol v)$ 下唯一实现加权速度范数最小（这是瞬时局部最优，不代表积分所得整条关节轨迹总能耗最小）。

::: def 定义 3.5.1 · 等权右伪逆与指定附加速度最近可行解 {#def-3.5.1}
1. 取单位权重阵 $W=I_n$，行满秩下 Moore–Penrose 右伪逆闭式及最小欧氏范数解为

$$J^\dagger = J^{\mathrm T}(JJ^{\mathrm T})^{-1}\in\mathbb R^{n\times r},\qquad \dot{\boldsymbol q}_{\min}=J^\dagger\boldsymbol v,$$

   满足 $JJ^\dagger=I_r$；若 $J$ 恰好为满秩方阵，自动退化为 $J^{-1}$。（注：降秩奇异处闭式失效，但一般 SVD 定义下的 Moore–Penrose 伪逆依然存在，见下小节。）

2. 若已知期望附加关节速度 $\dot{\boldsymbol q}_0\in\mathbb R^n$，求解尽量逼近 $\dot{\boldsymbol q}_0$ 的最近可行解 $\min\frac12(\dot{\boldsymbol q}-\dot{\boldsymbol q}_0)^{\mathrm T}W(\dot{\boldsymbol q}-\dot{\boldsymbol q}_0)$（$\text{s.t.}\ J\dot{\boldsymbol q}=\boldsymbol v$），做变量平移 $\boldsymbol d=\dot{\boldsymbol q}-\dot{\boldsymbol q}_0$ 化为 $J\boldsymbol d=\boldsymbol v-J\dot{\boldsymbol q}_0$ 后直接套用加权公式得：

$$\dot{\boldsymbol q} = J_W^\#\boldsymbol v + (I_n-J_W^\# J)\dot{\boldsymbol q}_0 \quad\xrightarrow{W=I_n}\quad \dot{\boldsymbol q} = J^\dagger\boldsymbol v + (I_n-J^\dagger J)\dot{\boldsymbol q}_0.$$
:::

当 $W=I_n$ 时，$P=I_n-J^\dagger J$ 正是 [3.4 节](sec3-4.md)中到零空间 $\mathcal N(J)$ 的欧氏正交投影阵 $NN^{\mathrm T}$；而在一般非单位对角/正定权重 $W$ 下，$I_n-J_W^\#J$ 为 $W$-斜投影而非欧氏正交投影。

### 梯度法构造次目标 $\dot{\boldsymbol q}_0=k_0\nabla_{\boldsymbol q}g(\boldsymbol q)\ (k_0>0)$

利用零空间实现局部二次优化（见 3.4 节证明 $\dot g_{\mathrm{null}}=k_0\|P\nabla g\|^2\ge 0$），常见光滑指标包括：
- **可操作度指标**：$g(\boldsymbol q)=w(\boldsymbol q)=\sqrt{\det(JJ^{\mathrm T})}$（提高速度椭球体积，注意体积增大并不保证远离每个奇异子空间或增大最小奇异值）；
- **远离关节上下限（靠近行程中点）**：设上下限 $q_{iM},q_{im}$，中点 $\bar q_i=(q_{iM}+q_{im})/2$，行程 $\Delta_i=q_{iM}-q_{im}>0$，定义负偏离平方

$$g(\boldsymbol q) = -\frac{1}{2n}\sum_{i=1}^n\left(\frac{q_i-\bar q_i}{\Delta_i}\right)^2,\qquad \frac{\partial g}{\partial q_i}=-\frac{q_i-\bar q_i}{n\Delta_i^2}.$$

  （超过中点给负梯度推回，低于中点给正梯度推高；最大化的是负偏离平方，且投影与主任务运动共同决定最终关节是否越限。）
- **避障距离指标**：臂上关键点到障碍物表面（球心距离须减去障碍半径）的最小光滑距离 $d(\boldsymbol q)$；注意最近点切换处不可微，且局部指标不自动保证整条全局路径避障。

::: ex 例 3.5.B · 3R 平面位置任务右伪逆与加权解手工对照
沿用 [3.4 节](sec3-4.md#ex-3.4.A) 的三连杆算例：$a_1=a_2=a_3=1\,\mathrm m$，$\boldsymbol q_*=[0,\pi/2,-\pi/2]^{\mathrm T}$，位置雅可比 $J=\begin{bmatrix}-1&-1&0\\2&1&1\end{bmatrix}$，期望笔尖速度 $\boldsymbol v=[0,1]^{\mathrm T}\,\mathrm{m/s}$。

1. **等权最小范数解**：计算 $JJ^{\mathrm T}=\begin{bmatrix}2&-3\\-3&6\end{bmatrix}$，逆阵 $(JJ^{\mathrm T})^{-1}=\frac13\begin{bmatrix}6&3\\3&2\end{bmatrix}=\begin{bmatrix}2&1\\1&2/3\end{bmatrix}$，于是

$$J^\dagger = J^{\mathrm T}(JJ^{\mathrm T})^{-1} = \begin{bmatrix}0&1/3\\-1&-1/3\\1&2/3\end{bmatrix},\qquad \dot{\boldsymbol q}_{\min}=J^\dagger\boldsymbol v = \begin{bmatrix}1/3\\-1/3\\2/3\end{bmatrix}\,\mathrm{rad/s}.$$

   与上节一般解族 $[1-\lambda,-1+\lambda,\lambda]^{\mathrm T}$ 直接求最小 $2(1-\lambda)^2+\lambda^2 \implies -4+6\lambda=0\implies\lambda=2/3$ 完全吻合。
2. **加权解与最近可行解**：若对第 3 关节施加重惩罚 $W=\operatorname{diag}(1,1,4)$，求得 $\dot{\boldsymbol q}_W=[2/3,-2/3,1/3]^{\mathrm T}\,\mathrm{rad/s}$（第 3 关节转速减半，与最小化 $2(1-\lambda)^2+4\lambda^2$ 得 $\lambda=1/3$ 一致）。若取 $W=I_3$ 并指定参考 $\dot{\boldsymbol q}_0=[1,0,0]^{\mathrm T}$，加上 3.4 节投影 $P\dot{\boldsymbol q}_0=[1/3,-1/3,-1/3]^{\mathrm T}$ 同样得 $[2/3,-2/3,1/3]^{\mathrm T}\,\mathrm{rad/s}$（注意一般并非精确实现 $\dot{\boldsymbol q}_0$）。
:::

::: think 独立练习 · 权重与次目标手算检验 {#practice-3.5.redundancy}
沿用例 3.5.B 的 3R 矩阵 $J$ 与任务速度 $\boldsymbol v=[0,1]^{\mathrm T}\,\mathrm{m/s}$：
1. 取 $W=\operatorname{diag}(1,1,9)$，直接利用一般解族 $[1-\lambda,-1+\lambda,\lambda]^{\mathrm T}$ 求加权最优关节速度；
2. 设 $W=I_3$、参考附加速度 $\dot{\boldsymbol q}_0=[0,0,1]^{\mathrm T}$，无需计算伪逆直接求最近可行解并说明原因；
3. 若 3 关节臂某轴处于 $q_i=0.8$（上下限为 $[0,1]$），计算中点保持指标的梯度分量。

::: sol 答案与解析
1. 代价函数 $2(1-\lambda)^2+9\lambda^2$ 对 $\lambda$ 求导置零得 $-4+22\lambda=0\implies\lambda=2/11$，最优关节速度为 $[9/11,-9/11,2/11]^{\mathrm T}\,\mathrm{rad/s}$。
2. 因 $J\dot{\boldsymbol q}_0=[0,1]^{\mathrm T}=\boldsymbol v$，$\dot{\boldsymbol q}_0$ 本身就在可行集内，最近可行解即其自身 $[0,0,1]^{\mathrm T}\,\mathrm{rad/s}$。
3. $\bar q_i=0.5,\ \Delta_i=1$，代入公式得 $\partial g/\partial q_i = -(0.8-0.5)/(3\times 1^2) = -0.1$，负号推动关节回落向行程中点。
:::
:::

<a id="sec-3.5.2"></a>

## 3.5.3 奇点与邻域处理：一般 SVD 伪逆与阻尼最小二乘（DLS）

### 一般 Moore–Penrose 伪逆与奇点邻域局限

当 $J\in\mathbb R^{r\times n}$ 降秩（$s=\operatorname{rank}J<r$）时，$(JJ^{\mathrm T})^{-1}$ 不存在，但由正奇异值展开的奇异值分解（SVD）仍可定义一般 Moore–Penrose 伪逆：

$$J = \sum_{i=1}^{s}\sigma_i\boldsymbol u_i\boldsymbol v_i^{\mathrm T}\ (\sigma_i>0) \implies J^\dagger = \sum_{i=1}^{s}\frac{1}{\sigma_i}\boldsymbol v_i\boldsymbol u_i^{\mathrm T}.$$

将目标分解为 $\boldsymbol v = \sum_{i=1}^s b_i\boldsymbol u_i + \boldsymbol v_\perp$（$b_i=\boldsymbol u_i^{\mathrm T}\boldsymbol v$，$\boldsymbol v_\perp\perp\mathcal R(J)$），则 $J^\dagger\boldsymbol v=\sum_{i=1}^s (b_i/\sigma_i)\boldsymbol v_i$ 在最小化残差 $\|J\dot{\boldsymbol q}-\boldsymbol v\|_2$ 的所有解中进一步最小化 $\|\dot{\boldsymbol q}\|_2$（在恰好 $\sigma_i=0$ 时逆增益定义为 $0$，并非把 $1/0$ 代入）。然而，在奇点邻域内当某正奇异值 $\sigma_i$ 尚未归零却极小时，非零 $b_i$ 会引发 $b_i/\sigma_i$ 急剧放大。

### 阻尼最小二乘（DLS）与阻尼广义逆 $J^*$

为了彻底遏制奇点邻域的关节超速，**阻尼最小二乘（Damped Least-Squares, DLS）** 放弃严格无误差跟踪，引入任务残差惩罚与速度惩罚的折中目标（阻尼因子 $k>0$）：

$$\min_{\dot{\boldsymbol q}}\ F(\dot{\boldsymbol q}) = \frac12\|\boldsymbol v-J\dot{\boldsymbol q}\|_2^2 + \frac12k^2\|\dot{\boldsymbol q}\|_2^2.$$

求导置零得正规方程 $(J^{\mathrm T}J+k^2I_n)\dot{\boldsymbol q}=J^{\mathrm T}\boldsymbol v$。对任意非零 $\boldsymbol z\in\mathbb R^n$ 有 $\boldsymbol z^{\mathrm T}(J^{\mathrm T}J+k^2I_n)\boldsymbol z=\|J\boldsymbol z\|_2^2+k^2\|\boldsymbol z\|_2^2>0$，故系数阵在任何秩下恒严格正定可逆；再利用恒等式 $(J^{\mathrm T}J+k^2I_n)J^{\mathrm T}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I_r)$ 变形，得到两种等价逆算子形式：

$$\dot{\boldsymbol q} = (J^{\mathrm T}J+k^2I_n)^{-1}J^{\mathrm T}\boldsymbol v = J^{\mathrm T}(JJ^{\mathrm T}+k^2I_r)^{-1}\boldsymbol v.$$

若引入对称正定关节权阵 $W\succ O$ 与误差权阵 $K\succ O$ 并令 $\boldsymbol\delta=\boldsymbol v-J\dot{\boldsymbol q}$，构造增广优化 $\min_{\dot{\boldsymbol q},\boldsymbol\delta}\frac12\dot{\boldsymbol q}^{\mathrm T}W\dot{\boldsymbol q}+\frac12\boldsymbol\delta^{\mathrm T}K\boldsymbol\delta$（s.t. $J\dot{\boldsymbol q}+\boldsymbol\delta=\boldsymbol v$），将 $[J\ I_r]$ 视为行满秩增广矩阵并代回加权右伪逆公式，即得一般**阻尼广义逆**：

::: def 定义 3.5.2 · 阻尼广义逆算子 $J^*$ {#def-3.5.2}
对于任意秩的雅可比 $J\in\mathbb R^{r\times n}$ 及对称正定权阵 $W\in\mathbb R^{n\times n},\ K\in\mathbb R^{r\times r}$，定义阻尼广义逆为

$$J^* = W^{-1}J^{\mathrm T}\bigl(JW^{-1}J^{\mathrm T}+K^{-1}\bigr)^{-1}\in\mathbb R^{n\times r},\qquad \dot{\boldsymbol q} = J^*\boldsymbol v.$$

当取欧氏尺度 $W=I_n,\ K=k^{-2}I_r\ (k>0)$ 时简化为 $J^*=J^{\mathrm T}(JJ^{\mathrm T}+k^2I_r)^{-1}$。注意增大阻尼 $k$ 等价于降低误差权重 $K$；远离奇点时减小 $k\to 0^+$（即 $K\to\infty$）可使 $J^*$ 逼近精确逆或右伪逆，但不恒有 $JJ^*=I_r$。
:::

### 方向增益界 $1/(2k)$、数值对照与选型汇总

沿 SVD 正奇异方向代入得每个主方向上的逆映射增益及残差因子：

$$g_k(\sigma_i) = \frac{\sigma_i}{\sigma_i^2+k^2},\qquad \delta_i = b_i - \sigma_i g_k(\sigma_i)b_i = \frac{k^2}{\sigma_i^2+k^2}b_i.$$

对增益函数求导 $g_k'(\sigma)=\frac{k^2-\sigma^2}{(\sigma^2+k^2)^2}$ 可知，**在 $\sigma=k$ 处达到全局最大值 $g_k(k)=\frac{1}{2k}$**，由此保证统一尺度下的关节速度全局上界 $\|\dot{\boldsymbol q}_{\mathrm{DLS}}\|_2 \le \frac{\|\boldsymbol v\|_2}{2k}$；当 $\sigma_i=0$ 时增益自动降为零，对应丧失方向全部保留在任务误差 $\delta_i=b_i$ 中（阻尼只是柔顺让步，不能恢复缺失自由度）。

下表给出二维通道模型 $J=\operatorname{diag}(1,\epsilon)$、输入 $\boldsymbol v=[1,1]^{\mathrm T}$、阻尼 $k=0.1$ 下的数值对比：

| $\epsilon$ | Moore–Penrose $\dot{\boldsymbol q}_{\mathrm{MP}}$ | DLS $\dot{\boldsymbol q}_{\mathrm{DLS}}$ | DLS 实际任务速度 $J\dot{\boldsymbol q}_{\mathrm{DLS}}$ |
|--:|:--:|:--:|:--:|
| $1$ | $(1,\,1)$ | $(0.99010,\,0.99010)$ | $(0.99010,\,0.99010)$ |
| $0.1$（$=k$ 峰值点） | $(1,\,10)$ | $(0.99010,\,5.00000)$ | $(0.99010,\,0.50000)$ |
| $0.01$ | $(1,\,100)$ | $(0.99010,\,0.99010)$ | $(0.99010,\,0.00990)$ |
| $0$（完全退化） | $(1,\,0)$（最小二乘） | $(0.99010,\,0)$ | $(0.99010,\,0)$ |

::: think 操作实验 · 阻尼 $k$ 对关节速度峰值与任务误差的影响 {#lab-3.5.dls}
固定 $k=0.1$，拖动 $\epsilon$ 由 $0.1$ 降至 $0.01$，核对第二关节速度如何越过峰值 $1/(2k)=5$ 后回落，以及实际任务速度如何随之减为残差。也可换用更大阻尼比较远离奇点时引入的稳态跟踪牺牲。

<div class="lab" data-lab="dls2d"></div>
:::

::: think 独立练习 · 增益峰值与伪逆退化校验 {#practice-3.5.dls}
1. 取 $J=[0.2]$、$v=2$、$k=0.1$，分别求伪逆解、DLS 关节速度、实际任务速度及残差；
2. 若上题退化为 $J=[0]$、$v=2$，比较上述四个量的变化；
3. 统一欧氏尺度下已知 $\|v\|_2\le 2$，欲借助 DLS 范数上界确保 $\|\dot q\|_2\le 5$，阻尼常数 $k$ 至少应取多大？

::: sol 答案与核对
1. 伪逆解 $2/0.2=10$；DLS 解 $\frac{0.2}{0.04+0.01}\times 2=8$，实现任务速度 $1.6$，残差 $0.4$。
2. $J=[0]$ 时伪逆为零矩阵故解与实际速度均为 $0$，残差 $2$；DLS 同样为 $0$，残差 $2$（零奇异值切勿误算为 $\lim_{\sigma\to 0^+}1/\sigma=\infty$）。
3. 由 $\|v\|_2/(2k) = 2/(2k)\le 5 \implies k\ge 0.2$；该界仅限制最大速度幅值，各方向跟踪误差仍须按 $k^2/(\sigma_i^2+k^2)$ 检查。
:::
:::

<a id="sec-3.5"></a>

## 本节小结

- **算子选型原则**：满秩方阵用 $J^{-1}$；冗余行满秩用加权/等权右伪逆 $J_W^\#,J^\dagger$（可叠加 $(I-J_W^\#J)\dot{\boldsymbol q}_0$ 满足次目标）；任意秩或奇点邻域改用恒可逆的 DLS 算子 $J^*$ 以有界残差换取平顺有界速度。

| 算子 | 适用条件 | 核心公式 | 易错点 |
|:--|:--|:--|:--|
| 方阵逆 | $r=n$ 且 $\det J\neq 0$ | $\dot{\boldsymbol q}=J^{-1}\boldsymbol v$ | Euler 离散存在 $O(\Delta t^2)$ 单步漂移，须重算 $J$ 或加闭环反馈 |
| 加权右伪逆 | $r<n$，$J$ 行满秩，$W\succ O$ | $J_W^\#=W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T})^{-1}$ | $JW^{-1}J^{\mathrm T}$ 正定性须由二次型证明；$W\neq I$ 时 $I-J_W^\#J$ 非欧氏正交投影 |
| 阻尼广义逆 | 任意秩，$W\succ O,\,K\succ O$ | $J^*=W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T}+K^{-1})^{-1}$ | $g_k(\sigma)$ 最大值 $1/(2k)$ 在 $\sigma=k$ 处取得；$k$ 增大相当于权重 $K$ 减小 |

**下一节**：[3.6 分析雅可比矩阵](sec3-6.md)处理物理角速度与欧拉角参数导数之间的换算关系与姿态表示奇点。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 01:59:02 | [lagrange-pseudo.jpg](../assets/ch03/lagrange-pseudo.jpg) | 加权二次优化与乘子求解 | 3.5.2 完整推导并严格论证 $G$ 正定性与全局最优性 |
| 02:03:58 | [right-pseudoinv.jpg](../assets/ch03/right-pseudoinv.jpg) | 单权右伪逆与指定附加速度 | 定义 3.5.1 + 例 3.5.B 3R 跟算 |
| 02:06:15 | [q0-solution.jpg](../assets/ch03/q0-solution.jpg) | 主任务项与零空间次目标 | 3.5.2 区分可实现任务与内部投影项 |
| 02:08:04 | [q0-choices.jpg](../assets/ch03/q0-choices.jpg) | 可操作度、关节极限、避障距离三指标 | 逐一写出梯度并补充局部边界条件 |
| 02:14:57 | [dls-augmented.jpg](../assets/ch03/dls-augmented.jpg) | 增广变量与加权阻尼推导 | 3.5.3 统一 $J^*$ 增广推导 |
| 02:17:37 | [dls-jstar.jpg](../assets/ch03/dls-jstar.jpg) | 阻尼广义逆公式与方向增益 | 定义 3.5.2 + 峰值 $1/(2k)$ 推导 + 数值对照实验 |
:::
