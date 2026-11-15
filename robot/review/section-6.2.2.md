# §6.2.2 动力学参数的线性性 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-2-2.md` 全文。上下文读了 §6.2.1 出口、§6.3.1 入口、第 7 周转录 01:30:20–01:54:30 与 `git show 9b93dd0:robot/src/ch06/sec6-2-2.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首与小例子 L3–14 | 先列结论，单摆例子拆成三段且未写出与例 7.1 参数的对应 | 先从连杆质量/质心/惯量测不准而角度含 $\sin q,\cos q$ 的矛盾引入，再用例 7.1 的 $\pi_1=I+I_mk_r^2,\pi_2=mgl,\pi_3=F+F_mk_r^2$ 写成矩阵积，把三次采样 $[1,0,0],[0,1,0],[0,0,1]$ 与全程静止秩亏对比合为一段 |
| §6.2.2.1 L24–33 | 从两条质心速度直接跳到扩展连杆动能；“下面将参考点移到连杆原点后，应改用原点惯量”没说为什么质心惯量不线性 | 补质心定义 $m_{\text{link }i}\boldsymbol r_{C_i,i}+m_{m_{i+1}}\boldsymbol r_{C_i,m_{i+1}}=\boldsymbol 0$ 消交叉项、平行轴定理合到 $C_i$ 的说明；解释若直接用 $\bar{\boldsymbol I}_i$ 会残留 $m_i\ell_{C_i}^2$ 二次项，换到连杆原点惯量 $\boldsymbol I_i^O=\bar{\boldsymbol I}_i^i+m_iS^{\mathrm T}(\boldsymbol\ell_{C_i})S(\boldsymbol\ell_{C_i})$ 才拆成线性参数 |
| §6.2.2.2 L52–56 | 只写动能对参数线性，漏了势能 $U_i$ 为何也对同组参数线性 | 补 $U_i=-\boldsymbol g_0^{\mathrm T}\boldsymbol p_{O_i}\,m_i-\boldsymbol g_0^{\mathrm T}\boldsymbol R_i\,(m_i\boldsymbol\ell_{C_i})$ 对质量 $m_i$ 和一阶矩 $m_i\boldsymbol\ell_{C_i}$ 线性的表达式 |
| §6.2.2.3 L75 | 9b6c8f5 删去了回归矩阵的上三角分块矩阵式，只留一句反面警告“开链结构本身并不能保证……” | 恢复开链标准分组下 $j<i$ 时 $\boldsymbol y_{ij}=\boldsymbol 0$ 的上三角分块矩阵，并正面注明该稀疏块源于开链运动学因果顺序（改参数分组或闭链时零块位置相应变化） |
| §6.2.2.4–6.2.2.5 | `::: note 这条性质有什么用` 与正文割裂；上一轮删去了默写点 | 将离线最小二乘辨识（含零列/相关列筛选）与在线自适应控制融为连贯正文段；完善常见错误 4 条并恢复默写点 4 条 |

### 清单核对

- 知识点：单摆三参数线性算例、扩展连杆定义与动能四项、11 个刚体参数表、原点惯量线性化机制、拉格朗日算子线性性与上三角回归块、$\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi$、11 / 13 / 最小参数集（平面臂 8 个、式 (7.83)、习题 7.4 的 5 个）三层口径、参数辨识与自适应控制应用。全部保留。
- 图：3 张课件图（`linearity-tau.jpg`、`linearity.jpg`、`regressor.jpg`）原样保留。
- 框与公式：`:::` 开 2 闭 2，`$$` 22 个，行内 `$` 214 个，全部配平。

### 复算（一次性 python）

- 单摆三状态 $(q,\dot q,\ddot q)=(0,0,1),(\pi/2,0,0),(0,1,0)$ 时 $Y=I_3$，$\det Y=1$；静止 $(q_k,0,0)$ 时 $\operatorname{rank}\mathcal Y\le 1<3$。

### 需要同步的配套页（只列出，未改）

- `errata.md`（E6.6）、`checklist.md`（K6.11、K6.12、S6.5）均与本节一致。
