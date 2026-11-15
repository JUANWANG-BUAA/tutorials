# §6.3.2 两连杆平面臂 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-3-2.md` 全文。上下文读了 §6.3.1 出口、§6.4 入口、第 7 周转录 01:23:45–02:17:20、`verify_homework06.py` 与 `git show 9b93dd0:robot/src/ch06/sec6-3-2.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首 L3–7 | 三小段略零散 | 先对比上一节正交笛卡儿臂，引出转动关节的甩动与半径变化，再保留“第一关节加速、$\ddot\vartheta_2=0$ 时第二关节是否出力”的悬念及两连杆第七关入口 |
| §6.3.2.2 L53–62 | 从 $J_P^{(2)}$ 直接跳到 $\|v_2\|^2$，未写 $v_{2x},v_{2y}$ 分量及 $c_1c_{12}+s_1s_{12}=c_2$ 合并过程 | 补出 $v_{2x},v_{2y}$ 显式分量，写明用 $s_1^2+c_1^2=1,s_{12}^2+c_{12}^2=1$ 与余弦差角公式得 $2a_1\ell_2c_2$，并集齐 $\dot\vartheta_1^2$ 与 $\dot\vartheta_1\dot\vartheta_2$ 的系数 |
| §6.3.2.3 L90–96 | 三个差别写成提纲碎句，且未明确回应节首悬念 | 合并为连贯解释，并专设一段回应节首问题：$\ddot\vartheta_2=0,\dot\vartheta=0$ 时关节 2 仍须输出 $b_{21}(\vartheta_2)\ddot\vartheta_1$ 抵抗惯性耦合 |
| §6.3.2.4 L107–125 | 直接列出非零 Christoffel 符号，跳过 $B$ 的六个偏导和全部 $c_{ijk}$、$c_{ij}$ 的逐项代入 | 先写出 $\partial b_{ij}/\partial\vartheta_1=0$ 与 $\partial b_{11}/\partial\vartheta_2=2h,\partial b_{12}/\partial\vartheta_2=h,\partial b_{22}/\partial\vartheta_2=0$，再按 $i=1,2$ 逐一算出 $c_{111},c_{112},c_{122},c_{211},c_{212},c_{222}$ 及 $c_{11},c_{12},c_{21},c_{22}$ |
| §6.3.2.6 L180 | 教材例 7.2 末端 $(0.2,0)$ m 肘下垂未写出对应的初始关节角数值 | 补注 $q_1=1.4706\ \mathrm{rad},\ q_2=-2.9413\ \mathrm{rad}$（与 `errata.md` E6.5、`verify_homework06.py` 一致） |
| §6.3.2.8 | 上一轮删去了默写点 5 条 | 完善小结与常见错误 5 条，恢复默写点 5 条 |

### 清单核对

- 锚点：`{#note-6.3.2.3.b11}`、`{#note-6.3.2.4.C}` 框类型、标题与 id 原样保留。
- 原书式号：(7.82)、(7.83)/(7.84)、例 7.2 参数与图 7.4–7.7 对照全部保留。
- 演示与图：`<div class="lab" data-lab="dyn3d"></div>` 宿主行原样未动；3 张课件图（`planar.jpg`、`planar-B.jpg`、`planar-torque.jpg`）原样保留。
- 框与公式：`:::` 开 6 闭 6，`$$` 62 个，行内 `$` 374 个，全部配平。
- 测试：`verify_homework06.py` 与 `verify_teaching_examples.py` 数值与本节公式完全一致。

### 复算（一次性 python）

- 符号复算：$v_{2x}^2+v_{2y}^2=a_1^2\dot\vartheta_1^2+\ell_2^2(\dot\vartheta_1+\dot\vartheta_2)^2+2a_1\ell_2\cos\vartheta_2\dot\vartheta_1(\dot\vartheta_1+\dot\vartheta_2)$；Christoffel 符号给出 $C=[[h\dot\vartheta_2,h(\dot\vartheta_1+\dot\vartheta_2)],[-h\dot\vartheta_1,0]]$，$\dot B-2C=[[0,-2h\dot\vartheta_1-h\dot\vartheta_2],[2h\dot\vartheta_1+h\dot\vartheta_2,0]]$ 反对称。
- 例 7.2 初值：$\cos q_2=(0.04-2)/2=-0.98\Rightarrow q_2=-2.941256\ \mathrm{rad}$，$q_1=1.470628\ \mathrm{rad}$。

### 需要同步的配套页（只列出，未改）

- `homework06.md`、`exercises.md`、`errata.md`（E6.5）均与本节一致。
