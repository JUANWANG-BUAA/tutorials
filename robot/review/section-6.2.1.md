# §6.2.1 $\dot B-2C$ 的反对称性 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-2-1.md` 全文。上下文读了 §6.1.3 出口、§6.2.2 入口、第 7 周转录 01:19:40–01:30:20 与 `git show 9b93dd0:robot/src/ch06/sec6-2-1.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| §6.2.1.1 L7–15 | 直接给 $H(\boldsymbol q,\boldsymbol v)\boldsymbol v=\boldsymbol 0$，未先写 $C$ 在运动方程中只受哪条式子约束；“反对称矩阵未必满足 $H\boldsymbol v=\boldsymbol 0$”无反例 | 先写出 $\sum_j c_{ij}\dot q_j=\sum_{j,k}h_{ijk}\dot q_k\dot q_j$；补二维反对称阵 $\begin{bmatrix}0&1\\-1&0\end{bmatrix}\begin{bmatrix}1\\0\end{bmatrix}=\begin{bmatrix}0\\-1\end{bmatrix}\neq\boldsymbol 0$；保留课上变式 $H(\boldsymbol v)=\begin{bmatrix}-v_2&v_1\\0&0\end{bmatrix}$ |
| §6.2.1.2 L36–55 | 从 $c_{ij}=\sum_k c_{ijk}\dot q_k$ 直接跳到 $c_{ij}=\frac12\dot b_{ij}+\cdots$ 和 $n_{ij}$ | 补齐将 $c_{ijk}$ 拆成 $\frac12(\partial b_{ij}/\partial q_k)\dot q_k$ 与后两项的中间式，写出 $\dot b_{ij}-2c_{ij}$ 消去 $\dot b_{ij}$ 的步骤，再对调 $i,j$ 推出 $N^{\mathrm T}=-N$ 与 $\boldsymbol w^{\mathrm T}N\boldsymbol w=0$ |
| §6.2.1.3 定理 6.2.1 与数值反例 | 定理中只说“(B) 不能推出 (A)”，数值反例跳过矩阵乘法过程 | 在定理中写明原因（$N(\boldsymbol q,\dot{\boldsymbol q})$ 本身依赖 $\dot{\boldsymbol q}$）；数值反例写出 $[1,2]\begin{bmatrix}4&-2\\0&0\end{bmatrix}\begin{bmatrix}1\\2\end{bmatrix}=0$ 与 $\boldsymbol w=(1,0)^{\mathrm T}$ 时 $N'_{11}=4\neq 0$、$N'_{12}=-2\neq -N'_{21}=0$ |
| 能量式 L78–95 | 从 $\dot T$ 与 $\frac{\mathrm d}{\mathrm dt}(T+U)=\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\xi$ 之间的代数方向不够直白；末尾带防御性否定句 | 写出 $\dot U=\dot{\boldsymbol q}^{\mathrm T}\boldsymbol g$，与 $\dot T=\dot{\boldsymbol q}^{\mathrm T}(\boldsymbol\xi-\boldsymbol g)+\frac12\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q}$ 相减直接得出 $\frac12\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q}=0$；正面说明惯性项与速度耦合项在关节间搬运能量、总功率平衡与第七章无源性的关系 |
| §6.2.1.4 | 上一轮删去了常见错误清单与默写点；检查理解的 3 个答案挤成一段 | 恢复常见错误清单 4 条与默写点 4 条；检查理解核对改为 1–3 分条对应 |

### 清单核对

- 锚点：`{#thm-6.2.1}` 框类型、标题与编号不变（被 `exercises.md`、`checklist.md`、`recall-cards.md` 引用）。
- 原书式号：(7.48)、(7.49) 关系保留。
- 图：2 张课件图（`skew.jpg`、`christoffel.jpg`）原样保留。
- 框与公式：`:::` 开 5 闭 5，`$$` 28 个，行内 `$` 300 个，全部配平。

### 复算（一次性 python）

- 反例矩阵：$v=(1,2)^{\mathrm T}$，$H=[[-2,1],[0,0]]$，$Hv=(0,0)^{\mathrm T}$；$N'=-2H=[[4,-2],[0,0]]$，$v^{\mathrm T}N'v=0$，$w=(1,0)^{\mathrm T}$ 时 $w^{\mathrm T}N'w=4$。
- 随机 $3\times 3$ 对称阵 $B(q)$ 与多项式依赖，验证 Christoffel 构造下 $N+N^{\mathrm T}=O$。

### 需要同步的配套页（只列出，未改）

- `exercises.md`（B5）、`homework06.md`（7-2）、`errata.md`（E6.7）、`recall-cards.md` 均与本节一致。
