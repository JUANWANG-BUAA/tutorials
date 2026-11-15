# §6.1.3 运动方程 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-1-3.md` 全文。上下文读了 §6.1.2 出口、§6.2.1 入口、第 7 周转录 01:15:30–01:22:30 与 `git show 9b93dd0:robot/src/ch06/sec6-1-3.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首 L3 | 开头直接叮嘱求和下标改名，还未交代本节任务 | 先承接前两节的 $T,U$，说明本节代入拉格朗日方程拆出加速度项、速度二次项和重力项；下标说明移入 §6.1.3.1 求导处 |
| §6.1.3.1 L8–15 | 二次型对 $\dot q_i$ 求偏导为什么拆成两个 $1/2$ 求和，读者首次见指标运算容易卡住 | 补两变量展开式 $\frac12(b_{11}\dot q_1^2+b_{12}\dot q_1\dot q_2+b_{21}\dot q_2\dot q_1+b_{22}\dot q_2^2)$ 对 $\dot q_1$ 求导的具象示范，再写一般哑指标改名与 $b_{ji}=b_{ij}$ 合并；时间导数处写出 $\frac{\mathrm d}{\mathrm dt}b_{ij}=\sum_k(\partial b_{ij}/\partial q_k)\dot q_k$ |
| §6.1.3.4 表与 intuition 框 | 离心项中 $h_{iii}=\frac12\partial b_{ii}/\partial q_i$ 何时为零只写反面警告 | 正面点明仅当 $b_{ii}$ 不依赖 $q_i$（如常规开链转动关节或平面臂）时为零，并用标量模型 $T=\frac12 b(q)\dot q^2$ 的 $b'\dot q^2-\frac12 b'\dot q^2=\frac12 b'\dot q^2$ 算清 $1/2$ 的来源 |
| §6.1.3.5 L133–140 | 第 2 条末尾两句话重复同一层意思 | 合并为连贯表述：算出 $B(\boldsymbol q)$ 与 $U(\boldsymbol q)$ 即可按偏导自动生成其余项，只知 $B$ 恢复不出重力 |
| §6.1.3.6 | 上一轮删去了默写点，常见错误第 4 条未写出 $+J^{\mathrm T}\boldsymbol f$ | 补齐小结与常见错误第 4 条（环境反力 $\boldsymbol f=-\boldsymbol h_e$ 时写 $+\boldsymbol J^{\mathrm T}\boldsymbol f$），恢复默写点 4 条 |

### 清单核对

- 知识点：二次型代入拉格朗日方程、$h_{ijk}$ 定义与分量方程、矩阵形式 $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})+\boldsymbol g=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e$、各项物理意义表、“锁住其他关节”解释框、速度二次项系数 $1/2$ 直觉框、例 6.1.3.A（`{#ex-6.1.3.A}`）与迁移练习、引出 §6.2 的两个结构问题。全部保留。
- 图：2 张课件图（`eom-forces.jpg`、`eom-compact.jpg`）原样保留。
- 框与公式：`:::` 开 9 闭 9，`$$` 24 个，行内 `$` 286 个，全部配平。

### 复算（一次性 python）

- 例 6.1.3.A：$B=ml^2=2\times 0.25=0.5\ \mathrm{kg\cdot m^2}$，$g=4.905\ \mathrm{N\cdot m}$；(a) $\ddot q=0\Rightarrow\tau=4.905$；(b) $\tau=0\Rightarrow\ddot q=-4.905/0.5=-9.81\ \mathrm{rad/s^2}$；(c) $\ddot q=2\Rightarrow\tau=0.5\times 2+4.905=5.905\ \mathrm{N\cdot m}$；迁移练习 $\ddot q=-2\Rightarrow\tau=3.905\ \mathrm{N\cdot m}$。

### 需要同步的配套页（只列出，未改）

- `summary.md`、`checklist.md`（K6.7、S6.1）均与本节一致。
