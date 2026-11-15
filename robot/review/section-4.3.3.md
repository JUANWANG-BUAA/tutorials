# §4.3.3 指向 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`robot/src/ch04/sec4-3-3.md`。上一节出口读了 `sec4-3-2.md` 末尾，下一章入口读了 `ch05/sec5-1.md` 开头；对照第 5 周课堂录播（`2:22:28–2:28:51`）与 `9b6c8f5` 之前版本补齐欧拉角速率换算、叉乘矩阵共轭推导、五次时间律跟算中间式、默写点与常见错误清单。

### 问题与改法

| §4.3.3.2 定义与换算（:27–:44） | 终端时刻用 $T$，易与变换矩阵 $T(\varphi_e)$ 混淆；$\dot\omega_e=\dot T\dot\varphi_e+T\ddot\varphi_e$ 未提示来自乘积求导 | 改为 $t_f$ 避免撞名；注明角加速度须对 $T(\varphi_e)\dot\varphi_e$ 用乘积法则，链接 [@thm-3.6.A] 说明 $\sin\vartheta=0$ 奇点 |
| §4.3.3.3 角轴法（:76–:89） | $\dot R_eR_e^{\mathrm T}=R_i\dot R'R'^{\mathrm T}R_i^{\mathrm T}=S(R_ir')\dot\theta$ 跳过了转置展开与叉乘矩阵共轭；五次时间律只给 $(0,15\pi/32,0)$，没写 $u=1/2$ 处导数怎么来的 | 补出 $(R_iR')^{\mathrm T}=R'^{\mathrm T}R_i^{\mathrm T}$ 与 [@thm-2.3.A] 共轭恒等式 $R_iS(r')R_i^{\mathrm T}=S(R_ir')$；补出 $u=1/2$ 时 $\dot\theta=\frac{\pi}{2}\cdot\frac{30(1/4)(1/4)}{2}=\frac{15\pi}{32}\ \mathrm{rad/s}$ 中间式；在 $\theta_f=\pi$ 处链接 [@thm-2.5.B] 对角元取轴法 |
| 节末（:91–:96） | 9b6c8f5 删去了默写点与常见错误清单 | 恢复默写点（3 问 3 答）与常见错误清单（3 条），小结收束两种姿态规划并交接第五章 |

### 清单核对

- 锚点：`sec-4.3.3.1`、`thm-4.3.E`、`sec-4.3.3.2`、`def-4.3.6`、`sec-4.3.3.3`、`thm-4.3.F`、`sec-4.3.3` 全部保留。
- 图片与 SVG：`orient-euler.jpg`、`orient-axis-angle.jpg` 与角轴合成流形 SVG 图全部保留。
- 语法检查：`:::` 围栏配平（深度 0），行内 `$` 218 个、块级 `$$` 14 个均成对。
- 测试兼容：`verify_teaching_examples.py:1874` 检查的 `15\pi/32` 保留并通过测试。

### 一次性 Python 复算

- 五次时间律 $\theta(t)=(\pi/2)(10u^3-15u^4+6u^5)$（$u=t/2$）：在 $t=1\ \mathrm s$（$u=0.5$）时 $\theta=\pi/4$，$\dot\theta=(\pi/2)\cdot(30u^2-60u^3+30u^4)/2=(\pi/2)\cdot(15/8)/2=15\pi/32\approx1.4726\ \mathrm{rad/s}$。

