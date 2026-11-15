# §6.5 动力学正解与逆解 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-5.md` 全文。上下文读了 §6.4 出口、§6.6 入口、第 8 周转录 01:20:24–01:28:15 与 `git show 9b93dd0:robot/src/ch06/sec6-5.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首与定义 6.5.1 | 偏置项只记作 $b$，未与课件和 `summary.md` 的 $\boldsymbol\tau'$ 对上；“同样使用‘正、逆’命名，并不表示……”是防御句 | 定义中同时给出课件记号 $\boldsymbol\tau'(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol h_e)$（或简记为 $\boldsymbol b$）；正面对比运动学（正易逆难）与动力学（逆易正难：逆解只需代数代入，正解需解线性方程组再数值积分，01:26:23–01:27:01） |
| §6.5.2–6.5.3 | 正逆互代算例与 §6.4.7 的两杆质点模型衔接不够紧密 | 显式写出 $\boldsymbol\tau-\boldsymbol\tau'=(8,4)^{\mathrm T}$ 与二元一次方程组消元步骤，再在 §6.5.3 反代 $\ddot{\boldsymbol q}=(2,0)^{\mathrm T}$ 恢复 $(27.62,4)^{\mathrm T}\ \mathrm{N\cdot m}$，点明正逆互代是写仿真与控制代码的第一道单元测试 |
| §6.5.4 L58–70 | 提取 $B(\boldsymbol q)$ 第 $i$ 列时，未写出 $\boldsymbol\tau_0=\boldsymbol g(\boldsymbol q)$ 与 $\boldsymbol\tau_i=B(\boldsymbol q)\boldsymbol e_i+\boldsymbol g(\boldsymbol q)$ 的显式右端 | 写出两式的显式右端，说明相减自动消去重力 $\boldsymbol g(\boldsymbol q)$，无需改动算法里的重力开关 |
| §6.5.5–6.5.6 | 课件 $O(n^2)$ 与递推 $O(n)$ 口径差异只用反面句带过；上一轮删去了常见错误清单与默写点；检查理解 3 个答案挤成一段 | 正面说明 01:27:31 课件 $O(n^2)$ 对应已构造 $n\times n$ 封闭矩阵再求值（或 $n$ 次逆解拼出 $B$），而单次牛顿–欧拉递推求 $\boldsymbol\tau$ 为 $O(n)$；恢复常见错误清单 5 条与默写点 4 条；检查理解核对改为 1–3 分条对应 |

### 清单核对

- 锚点：`{#def-6.5.1}` 框类型、标题与 id 原样保留。
- 知识点：正/逆动力学定义、偏置项 $\boldsymbol\tau'$、$B\succ 0$ 与线性方程组求解、一阶状态方程与 Euler/RK4 数值积分、两杆质点正逆互代算例、用 $\operatorname{ID}(\boldsymbol q,\boldsymbol 0,\boldsymbol e_i)-\operatorname{ID}(\boldsymbol q,\boldsymbol 0,\boldsymbol 0)$ 逐列提取 $B(\boldsymbol q)$、$O(n)$ 与 $O(n^2)$ 复杂度口径对比。全部保留。
- 图：5 张纯课件图（`dyn-def.jpg`、`dyn-qddot.jpg`、`dyn-integration.jpg`、`dyn-B-ne.jpg`、`dyn-complexity.jpg`）全部存在且保留（不存在的课堂实拍断图 `dyn-board-compare.jpg` 已移除）。
- 框与公式：`:::` 开 5 闭 5，`$$` 16 个，行内 `$` 208 个，全部配平。

### 复算（一次性 python）

- 正逆互代：$B=[[4,2],[2,2]]$，$g=[19.62,0]^{\mathrm T}$，$\tau=[27.62,4]^{\mathrm T}\Rightarrow B^{-1}(\tau-g)=[2,0]^{\mathrm T}$；$B[1,0]^{\mathrm T}=[4,2]^{\mathrm T}$，$B[0,1]^{\mathrm T}=[2,2]^{\mathrm T}$。

### 需要同步的配套页（只列出，未改）

- `summary.md`、`checklist.md`（K6.15）均与本节一致。
