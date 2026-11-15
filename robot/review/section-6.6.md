# §6.6 轨迹的动态标度 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-6.md` 全文。上下文读了 §6.5 出口、§6.7 入口、第 8 周转录 01:27:15–01:36:48、`verify_teaching_examples.py:1700` 与 `git show 9b93dd0:robot/src/ch06/sec6-6.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首与 §6.6.1 | 开头只给原则，缺少从第四章平滑轨迹到第六章逆动力学验算超限的具体场景 | 从“第四章规划只保运动平滑，经 6.5 逆动力学验算发现加速段力矩超峰值，不想重画无碰几何路径而拉长时间”进入，点出动态项、重力与库仑摩擦随时间缩放规律不同 |
| §6.6.2 L17–24 | 二阶导数 $\ddot{\boldsymbol q}=\bar{\boldsymbol q}''\dot r^2+\bar{\boldsymbol q}'\ddot r$ 一步跳过乘积求导 | 写出 $\frac{\mathrm d}{\mathrm dt}\bigl(\bar{\boldsymbol q}'(r)\bigr)\dot r+\bar{\boldsymbol q}'(r)\ddot r=\bar{\boldsymbol q}''(r)\dot r^2+\bar{\boldsymbol q}'(r)\ddot r$，并明确撇号对路径参数 $r$、点号对新时间 $t$ |
| §6.6.3 L30–40 | $\Gamma(\boldsymbol q)[\dot{\boldsymbol q},\dot{\boldsymbol q}]$ 直接提取 $\dot r^2$ 未展示代入步骤 | 补出两行对齐展开式，先代入 $\dot r\bar{\boldsymbol q}'$，再利用双线性齐二次性质提出 $\dot r^2$，与 $\bar{\boldsymbol q}''\dot r^2$ 合并 |
| §6.6.5 L60–83 | 课件用 $r=ct$（$c<1$ 变慢），而老师口述（01:36:53–01:37:13）常把时间拉长两倍说成“$c=2$、力矩降为 $1/4$”，学生看课件和听录播容易搞反 | 明确 $c$ 与时间拉长倍数 $T=t_f/\bar t_f=1/c$ 互为倒数，同时写出 $r=ct$ 与 $r=t/T$ 两套式子，并补齐两组带重力算例的中间不等式化简与 01:33:48–01:34:01 逐点取交集流程 |
| §6.6.7 | 上一轮删去了常见错误清单与默写点；检查理解 3 个答案挤成一段 | 恢复常见错误清单 5 条与默写点 4 条；检查理解核对改为 1–3 分条对应 |

### 清单核对

- 测试解析：`verify_teaching_examples.py:1701` 正则 `g=(\d+),a=(-?\d+),\\tau_\{\\max\}=(\d+)` 在本节精确匹配 2 处：`[('4', '8', '6'), ('8', '-6', '5')]`（检查理解第 2 题特意加空格写成 `$g=8,\ a=-6,\ \tau_{\max}=5$`，避免产生第 3 处无空格匹配）。
- 知识点：时间标度函数 $r(t)$、一阶与二阶链式求导、双线性速度项代入、动态力矩分量 $\bar{\boldsymbol\tau}_s(r)$ 与重力项分离、线性标度 $r=ct=t/T$、带重力可行区间不等式与两组正反算例、优缺点与端点检查。全部保留。
- 图：6 张纯课件图（`dynscale-goal.jpg`、`dynscale-def.jpg`、`dynscale-subst.jpg`、`dynscale-tau-s.jpg`、`dynscale-linear.jpg`、`dynscale-proscons.jpg`）全部存在且保留（不存在的课堂实拍断图 `dynscale-board.jpg` 已移除）。
- 框与公式：`:::` 开 4 闭 4，`$$` 18 个，行内 `$` 242 个，全部配平。

### 复算（一次性 python）

- 算例 1：$g=4,a=8,\tau_{\max}=6$，$-6\le 4+8z\le 6\Rightarrow z\le 1/4\Rightarrow T\ge 2$；$T=2$ 时 $\tau=6$，$T=3$ 时 $\tau=4.889<6$，$T=1.5$ 时 $\tau=7.556>6$。
- 算例 2：$g=8,a=-6,\tau_{\max}=5$，$-5\le 8-6z\le 5\Rightarrow z\ge 1/2\Rightarrow T\le\sqrt2$；$T=\sqrt2$ 时 $\tau=5$，$T=1.1$ 时 $\tau=3.041<5$，$T=2$ 时 $\tau=6.5>5$。

### 需要同步的配套页（只列出，未改）

- `summary.md` 与本节一致。
