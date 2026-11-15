# §6.4 牛顿–欧拉递推 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-4.md` 全文。上下文读了 §6.3.2 出口、§6.5 入口、第 8 周转录 00:04:30–01:25:50、`verify_homework06b.py` 与 `git show 9b93dd0:robot/src/ch06/sec6-4.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首与 §6.4.1 | 开篇未说明为何有了拉格朗日封闭方程还需要第二种方法；课件 §7.5 与教材 §7.4 编号错位未提醒原因 | 从实时控制/仿真内环求单次 $\boldsymbol\tau$ 时 $n\times n$ 封闭式随 $n$ 膨胀切入，引出两遍递推 $O(n)$；注明课件把参数辨识编为 §7.4 故牛顿–欧拉顺延为 §7.5；补课上 00:04:30–00:05:52、00:16:26–00:17:06 单刚体与多连杆对比 |
| §6.4.2 L16–28 | 动量与角动量的积分来源（00:16–00:37）被删得只剩两行定义；“不能无条件写成 $\mu_O=\dot k_O$”偏防御 | 恢复线动量 $\boldsymbol l=m\dot{\boldsymbol p}_C$ 与空间参考点角动量 $\boldsymbol k_\Omega=\boldsymbol I_C\boldsymbol\omega+m\dot{\boldsymbol p}_C\times(\boldsymbol p_\Omega-\boldsymbol p_C)$，说明为何统一对质心 $C$ 写欧拉方程再用力臂迁移（避免非质心参考点的 $\dot{\boldsymbol p}_O\times\boldsymbol l$ 修正项，00:33:52–00:35:50） |
| §6.4.3 L32–52 | 相对位置向量未与教材 $\boldsymbol r_{i-1,i},\boldsymbol r_{i,C_i},\boldsymbol r_{i-1,C_i}$ 对齐；质心欧拉方程的叉乘方向与转子角动量项未写清 | 写出 $\boldsymbol r_{i-1,i},\boldsymbol r_{i,C_i},\boldsymbol r_{i-1,C_i}$（并给出手算简写 $\boldsymbol r_i,\boldsymbol c_i$），逐步算出 $(\boldsymbol p_{O_{i-1}}-\boldsymbol p_{C_i})\times\boldsymbol f_i=\boldsymbol f_i\times\boldsymbol r_{i-1,C_i}$ 与 $-\boldsymbol f_{i+1}\times\boldsymbol r_{i,C_i}$，写出含扩展连杆转子项的完整单杆欧拉方程（00:39:19–00:39:45） |
| §6.4.4 L56–78 | $\frac{\mathrm d}{\mathrm dt}(\bar{\boldsymbol I}_i\boldsymbol\omega_i)$ 与转子项求导跳步 | 写出 $\dot{\bar{\boldsymbol I}}_i=S(\boldsymbol\omega_i)\bar{\boldsymbol I}_i-\bar{\boldsymbol I}_iS(\boldsymbol\omega_i)$ 及 $S(\boldsymbol\omega_i)\boldsymbol\omega_i=\boldsymbol 0$ 消项，合并出带框完整欧拉展开式，解释角动量中一次 $k_r$ 与投影虚功再乘一次 $k_r$ 合为 $k_r^2I_m$ |
| §6.4.6–6.4.7 | $a_0=-\boldsymbol g_0$ 的等价加速参考系解释（01:07:46–01:08:22）缺失；后向递推 $\boldsymbol\mu_i$ 从质心方程到近端原点的力臂合并跳步 | 补加速参考系解释；补 $-(\boldsymbol F_i+\boldsymbol f_{i+1})\times(\boldsymbol r_i+\boldsymbol c_i)+\boldsymbol f_{i+1}\times\boldsymbol c_i=(\boldsymbol r_i+\boldsymbol c_i)\times\boldsymbol F_i+\boldsymbol r_i\times\boldsymbol f_{i+1}$ 的代数变形与四项物理账目；跟算例补齐 $a_1,a_2,\boldsymbol\mu_2,\boldsymbol\mu_1$ 每一步叉乘分量 |
| §6.4.8–6.4.10 | “好推难算 vs 难推好算”（01:23:20–01:25:45）与当前连杆系递推说明被删；常见错误与默写点缺失；检查理解 4 个答案挤成一段 | 恢复“好推难算 vs 难推好算”及当前连杆系旋转说明（与式 (7.107)–(7.114) 对照）；恢复常见错误 6 条与默写点 5 条；检查理解核对改为 1–4 分条对应 |

### 清单核对

- 知识点：动量与角动量定理、力系简化、扩展连杆约定、单杆牛顿与欧拉方程、$\dot{\bar{\boldsymbol I}}_i$ 与陀螺项、转子角动量导数、关节轴虚功投影（式 (7.114)）、前向递推（转动/移动关节、科氏加速度系数 2、$a_0=-\boldsymbol g_0$、质心与转子角加速度）、后向递推（$\boldsymbol f_i,\boldsymbol\mu_i$）、2 kg 质点两杆完整跟算例（与拉格朗日互校）、两遍循环伪代码与 $O(n)$ 复杂度、与拉格朗日法对比。全部保留。
- 图：已移除不存在的课堂实拍断图（`ne-board-momentum.jpg`、`ne-board-balance.jpg`），确认现存 10 张纯课件图（`ne-variables.jpg`、`ne-link-equations.jpg`、`ne-joint-tau.jpg`、`ne-velocities.jpg`、`ne-accelerations.jpg`、`ne-centroid-acc.jpg`、`ne-forward.jpg`、`ne-backward.jpg`、`ne-structure.jpg`、`ne-compare.jpg`）全部存在且完整。
- 框与公式：`:::` 开 4 闭 4，`$$` 42 个，行内 `$` 612 个，全部配平。

### 复算（一次性 python）

- 两杆质点跟算：$r_1=(1,0,0),r_2=(0,1,0),g_0=(0,-9.81,0),\alpha_1=\alpha_2=(0,0,2)$；$a_0=(0,9.81,0)$，$a_1=(0,11.81,0)$，$a_2=(-2,11.81,0)$，$F_2=(-4,23.62,0)$；$\mu_2=r_2\times F_2=(0,0,4)$，$\mu_1=\mu_2+r_1\times F_2=(0,0,27.62)$；与 $B\ddot q+g=[[4,2],[2,2]][2,0]^{\mathrm T}+[19.62,0]^{\mathrm T}=[27.62,4]^{\mathrm T}$ 完全一致。
- PR 臂三条路线互校（`verify_homework06b.py` 7-8）一致。

### 需要同步的配套页（只列出，未改）

- `homework06b.md`（7-8）、`summary.md` 均与本节一致。
