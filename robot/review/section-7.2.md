# §7.2 分散（独立关节）控制 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`robot/src/ch07/sec7-2.md`。对照 `git show HEAD:robot/src/ch07/sec7-2.md`、第 8 周转录（02:10:28–02:19:00）与第 9 周转录（00:09:46–00:55:30）及课件 §8.2–§8.4 审核。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|---|---|---|
| 节首与 §7.2.1 :1–40 | 开篇直接给抽象步骤，未承接 §7.1.5 算出的 $k_r=100$ 下耦合比值 $0.08\text{–}0.12$；$\bar B$ 与 $\Delta B(q)$ 的物理分工及老师 00:12:53–00:14:26 对忽略耦合何时合算的说明交代不清 | 从 §7.1.5 的两杆减速比耦合比值自然引入单轴独立设计；补清 $\tau_m=K_r^{-1}\tau$ 的虚功来源、$\bar B$（常对角标称惯量）与 $\Delta B(q)$（构形变化与非对角耦合）的分工，以及老师关于先按无 $d$ 定常系统设计再验算 $d$ 的课堂说明 |
| §7.2.2 :43–56 | “这些反馈环并非只能选一个”“不能任意串接多个PID”回应隐含反驳，未讲清课上三套并列方案（位置／速度／加速度）与工业内环的关系 | 结合第 9 周 00:19:42–00:21:45 与 00:38:08–00:39:41，正面说明课件三套方案按反馈量选一套、工业伺服内环已含高速电流／速度环的衔接关系，以及滤波微分 (7.2-7) 在低频 $|s|\ll 1/T_a$ 与高频 $|s|\gg 1/T_a$ 的幅值行为 |
| §7.2.3 :81–105 | :95 从三阶特征多项式 $T_ms^3+s^2+\kappa T_ps+\kappa=0$ 直接跳到“Routh 第一列为 $T_m,1,\kappa(T_p-T_m),\kappa$”，省去了构造三阶 Routh 表和交叉相乘的步骤；渐近线交点 (7.2-9) 缺极点之和减零点之和的中间式 | 补出完整的 $s^3,s^2,s^1,s^0$ 三阶 Routh 表，写出第三行首列 $\frac{1\cdot(\kappa T_p)-T_m\cdot\kappa}{1}=\kappa(T_p-T_m)$ 的代数来历；写出渐近线实轴交点 $\sigma_a=\frac{(0+0-1/T_m)-(-1/T_p)}{3-1}$ 的完整计算 |
| §7.2.4 :109–125 | 积分作用的动机与 §7.2.3 的常负载余差 $e_{\rm ss}=d/k_p=0.1\ \mathrm{rad}$ 脱节；三阶 Routh 条件 $(b+k_d)k_p>Jk_i$ 缺第一列说明 | 承接 §7.2.3 转矩 PD 在常负载下必须靠 $e\ne0$ 出力的问题，引出用积分状态 $z(t)$ 在 $e=0$ 处顶住常负载 $k_iz(\infty)=d_0$；补出三阶 Routh 第一列 $J,b+k_d,\frac{(b+k_d)k_p-Jk_i}{b+k_d},k_i$ 与终值定理极限式，并说明电压环干扰抑制因子 $X_R=K_Pk_{tp}$ 的课堂上下文（00:28:44–00:31:27） |
| §7.2.5 :129–156 | 驱动五式消元缺中间电流表达式 $i_a=R_a^{-1}(G_vv_c-K_vK_r\dot q)$；定理 7.2.A 与电流环转矩接口的对比充斥“不能单凭……”“并不限制……”防御句 | 补齐由 $v_a=R_ai_a+K_v\dot q_m=G_vv_c$ 解出 $i_a$ 再代回 $\tau=K_rK_ti_a$ 的中间步；按第 8 周 02:10:28–02:18:00 讲清“大减速比、小电阻、小转矩用电压速度近似（定理 7.2.A）”与“高速、大加速度、大转矩加电流环形成受控转矩源 $\tau\approx K_rK_tG_iv_c$”两条接口路线；保留全部单轴数值算例（$0.05\ \mathrm A,20\ \mathrm V,0.5\ \mathrm V,20.5\ \mathrm V,0.1025\ \mathrm{rad/s},2.5\%$） |
| §7.2.6–§7.2.8 :172–218 | 单轴前馈与计算转矩前馈的递进关系不够连贯，检查步骤框（`method-7.2.A`）为笼统长段 | 串起“固定目标 PD $\to$ 时变参考出现 $J\ddot q_{md}+b\dot q_{md}$ 滞后 $\to$ 单轴前馈 (7.2-17) $\to$ 整机计算转矩前馈 (7.2-18) 补耦合与重力 $\to$ 电压接口换算”；将 `method-7.2.A` 整理为 4 步可执行的检查清单并自然指向 §7.3 |

### 清单核对

- 锚点：`sec-7.2.1`–`sec-7.2.8`、`{#thm-7.2.A}`、`{#method-7.2.A}` 全部保留。
- 公式：式 (7.2-1)–(7.2-11)、(7.2-14)–(7.2-18) 编号与表达式全部保留。
- 例题与数值：转矩 PD 算例（$J=0.02,b=0.1,\omega_n=10,\zeta=0.8\Rightarrow k_p=2,k_d=0.22,d=0.2\Rightarrow e_{\rm ss}=0.1\ \mathrm{rad}$）、电压 PI Routh 算例（$T_m=0.5,T_p=2,\kappa=0.5\Rightarrow 0.5(s+1)(s^2+s+1)$）、电机电枢压降算例（$k_r=100,k_t=k_v=2,R_a=10,G_v=1,\dot q=0.1,\tau=10\Rightarrow i_a=0.05\ \mathrm A,20\ \mathrm V,0.5\ \mathrm V,20.5\ \mathrm V,0.1025\ \mathrm{rad/s},2.5\%$）全部保留。
- 图：`<details>` 内 6 张课件图（`joint-eom.jpg`、`drive-model.jpg`、`tau-vc.jpg`、`decentral-assume.jpg`、`centralized-reason.jpg`、`current-loop.jpg`）全部保留。
- 检查：`:::` 2 开 2 闭，块级 `$$` 与行内 `$` 全部配平；`robot/tools/*.py` 不对 `sec7-2.md` 做脆弱正则切片。

### 复算（一次性 python）

- 转矩 PD：$J=0.02,b=0.1,\omega_n=10,\zeta=0.8\Rightarrow k_p=2.0\ \mathrm{N\cdot m/rad},k_d=0.22\ \mathrm{N\cdot m\cdot s/rad}$；$d=0.2\Rightarrow e_{\rm ss}=0.1\ \mathrm{rad}$。
- 电压 PI：$T_m=0.5,T_p=2,\kappa=0.5\Rightarrow \kappa(T_p-T_m)=0.75>0$，根为 $-1,-0.5\pm\mathrm j 0.8660$，$\sigma_a=-0.75\ge -1/(2T_m)=-1.0$。
- 驱动电压换算：$\tau_m=0.1\ \mathrm{N\cdot m},i_a=0.05\ \mathrm A,K_vk_r\dot q=20.0\ \mathrm V,R_ai_a=0.5\ \mathrm V,v_a=20.5\ \mathrm V$；忽略电阻压降估速 $0.1025\ \mathrm{rad/s}$，相对偏差 $2.5\%$。

### 需要同步的配套页（只列出，未改）

- 无（`summary.md`、`recall-cards.md`、`exercises.md`、`checklist.md` 与本节公式及结论一致）。
