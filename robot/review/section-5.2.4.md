# §5.2.4 位置控制 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`robot/src/ch05/sec5-2-4.md`。上一节出口读了 `sec5-2-3.md`，下一节入口读了 `sec5-3.md`。对照第 6 周课堂转录 01:32:12–01:39:20。下表行号指 HEAD 中的原文。

### 问题与改法

| 位置 | 读者会卡在哪 | 怎么改 |
|:--|:--|:--|
| :3 | 开头没把第四章期望轨迹、上一节折算后的电机轴模型与本节的位置／速度反馈串起来 | 首段承接 [§5.2.3](sec5-2-3.md) 折算模型与第四章期望轨迹，点明本节依次加入比例、积分和速度反馈，看各项如何改变误差微分方程及抵消恒定负载 |
| :11–24 `def-5.2.5` | 框后直接写 $I_{eq}\ddot\theta+b\dot\theta=ku-d$，没有交代每个符号的单位及 $b$ 合并了哪些物理阻尼（机械黏滞摩擦与速度控制模式下的反电动势阻尼） | 在正文首次出现处标明 $I_{eq}$（$\mathrm{kg\cdot m^2}$）、$b$（合并机械黏滞摩擦与反电动势阻尼，$\mathrm{N\cdot m\cdot s/rad}$）、输入力矩增益 $k$ 与正转阻碍负载 $d$；补全开环传递函数只有一个原点极点 $s=0$ 和一个实极点 $s=-b/I_{eq}$ 的说明 |
| :28–42 | 比例控制部分只写“增大 $K_P$ 会改变无阻尼自然频率与阻尼比”，没写出 $\omega_n$ 和 $\zeta$ 的具体式子，读者看不出为什么只调大 $K_P$ 会导致超调振荡 | 补出固定目标下 $\dot\theta=-\dot e,\ddot\theta=-\ddot e$ 代入得 $I_{eq}\ddot e+b\dot e+kK_Pe=d$，写出 $\omega_n=\sqrt{kK_P/I_{eq}}$ 与 $\zeta=\frac{b}{2\sqrt{I_{eq}kK_P}}$，让读者一眼看到 $\zeta\propto1/\sqrt{K_P}$ 随 $K_P$ 增大而下降（01:36:20–01:37:53）；保留 $e_{ss}=d/(kK_P)=0.1\ \mathrm{rad}$ 算例 |
| :44–56 `thm-5.2.D` | 从 $u=K_Pe+K_Iz$ 直接跳到三阶方程 $I_{eq}e^{(3)}+b\ddot e+kK_P\dot e+kK_Ie=0$ 和不等式 $bK_P>I_{eq}K_I$，跨过了对时间求导消去 $z$ 及列 Routh 表第一列的步骤 | 在 `thm-5.2.D` 中补出 $I_{eq}\ddot e+b\dot e+kK_Pe+kK_Iz=d$ 两边对时间求导（恒定负载 $\dot d=0$，用 $\dot z=e$）得三阶方程，并写出 Routh 阵列第一列 $I_{eq},\ b,\ kK_P-\frac{I_{eq}kK_I}{b},\ kK_I$，使稳定条件 $bK_P>I_{eq}K_I$ 从计算本身直接得出 |
| :62–86 `method-5.2.E` | 串级控制只给出三阶方程 (80)，未交代如何从外环 $\omega_d=K_xe$ 与内环 $u=K_ve_v+K_{Iv}\int e_v\mathrm dt$ 代入求导得出 | 在 `method-5.2.E` 中补明 $K_x,K_v,K_{Iv}$ 的含义，写出把 $e_v=K_xe+\dot e$ 与 $\dot z_v=e_v$ 代回对象方程并对时间求导得到三阶误差方程及 Routh 条件 $(b+kK_v)(K_vK_x+K_{Iv})>I_{eq}K_{Iv}K_x$ 的中间步 |
| 节末 | 缺少小结与常见错误清单 | 补齐“5.2.4 小结与常见错误”及三条自查项 |

### 清单核对

- 知识点：独立关节近似 `def-5.2.5`；单轴简化模型与开环极点；纯比例控制的二阶误差方程、阻尼比与恒定负载稳态误差 $e_{ss}=d/(kK_P)$；PI 控制消除常值误差、升为三阶及 Routh 稳定条件 $bK_P>I_{eq}K_I$；直接测速反馈增大阻尼系数 $b+kK_D$；外位置 P + 内速度 PI 串级控制及其三阶特征方程；电流控制模式与减速器折算两条推广 `note-5.2.1`。全部保留。
- 框：`def-5.2.5`、`thm-5.2.D`、`method-5.2.E`、`note-5.2.1`、`think`/`sol` 类型、编号和锚点全部保留。
- 公式与数值：$I_{eq}\ddot\theta+b\dot\theta=ku-d$、$e_{ss}=d/(kK_P)$、$bK_P>I_{eq}K_I$、串级三阶方程；算例 $I_{eq}=b=k=1,K_P=4,d=0.4\Rightarrow e_{ss}=0.1$，$K_I=1$ vs $5$；检查题 $I_{eq}=2,b=3,k=1,K_P=4\Rightarrow0<K_I<6$，$b+kK_D=5$ 全部保留。
- 图：`pos-feedback.jpg`、`pos-vel-feedback.jpg` 2 张全部保留。
- 锚点：`sec-5.2.4.1`–`sec-5.2.4.3`、`sec-5.2.4` 及各框 id 均与 HEAD 一致。
- 语法与测试：无脚本直接解析 `sec5-2-4.md`；`:::` 深度归零，`$$` 20 个、`$` 198 个（均配平），破折号清零。

### 复算（一次性 python）

- $I_{eq}=b=k=1,K_P=4,d=0.4\Rightarrow e_{ss}=0.4/(1\times4)=0.1\ \mathrm{rad}$；$bK_P=4$，$K_I=1\Rightarrow I_{eq}K_I=1<4$（稳定），$K_I=5\Rightarrow5>4$（失稳）。
- 检查题：$bK_P>I_{eq}K_I\Rightarrow 3\times4>2K_I\Rightarrow 0<K_I<6$；$b+kK_D=3+1\times2=5$。
- 串级三阶方程验证：$I_{eq}(-\dddot e)+b(-\ddot e)=k[K_v(K_x\dot e+\ddot e)+K_{Iv}(K_xe+\dot e)]\Rightarrow I_{eq}e^{(3)}+(b+kK_v)\ddot e+k(K_vK_x+K_{Iv})\dot e+kK_{Iv}K_xe=0$。

### 需要同步的配套页（只列出，未改）

- 配套页 `summary.md:32`、`recall-cards.md`（B5、C5）、`exercises.md`（A4、D3）、`mock-exam.md`（判断 8）与本节口径一致。
- 图片：`pos-feedback.jpg`、`pos-vel-feedback.jpg` 右侧均带 SPOC 平台侧栏（教师姓名、签到、互动等按钮），未修改图片。
