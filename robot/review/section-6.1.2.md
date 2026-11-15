# §6.1.2 势能计算 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-1-2.md` 全文。上下文读了 §6.1.1 出口、§6.1.3 入口、第 7 周转录 01:09:10–01:15:30 与 `git show 9b93dd0:robot/src/ch06/sec6-1-2.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首 L3 | 开篇抽象，未衔接上一节已算出的二次型动能 | 从 $L=T-U$ 还缺势能 $U$ 切入，点出左端重力项 $\boldsymbol g(\boldsymbol q)$ 与重力实际广义力差一个负号的问题 |
| §6.1.2.2 L35–42 | 位置偏导为什么不能省去 $\partial T/\partial q_i$ 只给警告 | 正面说明 $B(\boldsymbol q)$ 随位形变，故 $\partial T/\partial q_i$ 非零并进入 [6.1.3](sec6-1-3.md) 的速度二次项 |
| §6.1.2.3 L52 | $\partial\boldsymbol p_j/\partial q_i=j_{Pi}^{(j)}$ 直接给出，未写为什么等于雅可比第 $i$ 列 | 补 $\dot{\boldsymbol p}_j=J_P^{(j)}\dot{\boldsymbol q}=\sum_i j_{Pi}^{(j)}\dot q_i$ 与全微分 $\sum_i(\partial\boldsymbol p_j/\partial q_i)\dot q_i$ 比较系数一步 |
| intuition 框 L65–72 | 连续否定句“不要把两个方向相反的量都不加区分地叫作……” | 补虚功 $\sum_j m_j\boldsymbol g_0^{\mathrm T}J_P^{(j)}\delta\boldsymbol q$ 导出 $\boldsymbol\tau_{\mathrm{grav}}=-\partial U/\partial\boldsymbol q$，正面说明左端 $\boldsymbol g=\partial U/\partial\boldsymbol q$ 是静止托住机械臂所需的电机保持力矩 |
| §6.1.2.4 | 上一轮删去了默写点 | 完善小结与常见错误 3 条，恢复默写点 3 条 |

### 清单核对

- 锚点与例题：`{#ex-6.1.2.A}` 及特征数值 `4.905` 原样保留（满足 `verify_teaching_examples.py:1517`）。
- 迁移练习（换角度定义 $\alpha=q-\pi/2$）、两张课件图（`energy-intro.jpg`、`potential.jpg`）全部保留。
- 框与公式：`:::` 开 7 闭 7，`$$` 22 个，行内 `$` 138 个，全部配平。

### 复算（一次性 python）

- 例 6.1.2.A：$m=2,l=0.5,g=9.81,q=\pi/6$，$mgl\sin q=2\times 9.81\times 0.5\times 0.5=4.905\ \mathrm{N\cdot m}$；$\alpha=-\pi/3$ 时 $mgl\cos\alpha=4.905\ \mathrm{N\cdot m}$。

### 需要同步的配套页（只列出，未改）

- `summary.md`、`errata.md`（E6.8、E6.9）、`checklist.md`（K6.6）均与本节符号约定一致。
