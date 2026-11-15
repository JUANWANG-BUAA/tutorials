# §6.1.1 动能计算 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-1-1.md` 全文。上下文读了 §6.1 出口、§6.1.2 入口、第 7 周转录 00:49:30–01:09:10 与 `git show 9b93dd0:robot/src/ch06/sec6-1-1.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首 L3 | 只说“将运动速度统一写成关节速度”，没说单摆与多连杆的差别 | 从 $n$ 连杆各杆既平动又转动、速度耦合前面各关节切入，说明为何要写成二次型 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}$ |
| §6.1.1.2 L34–38 | 从 $\dot{\boldsymbol p}_i^*$ 直接跳到三项积分，未写展开式，也没说为什么要引入反对称矩阵 $S(\boldsymbol\omega_i)$ | 写出 $\dot{\boldsymbol p}_i^{*\mathrm T}\dot{\boldsymbol p}_i^*$ 的三项展开；点明 $\boldsymbol\omega_i$ 夹在 $S(\boldsymbol\omega_i)\boldsymbol r_i$ 左端无法直接提出积分 |
| 交叉项与转动项 L44–56 | 只写“用到 $S(\boldsymbol\omega)\boldsymbol r=-S(\boldsymbol r)\boldsymbol\omega$”，跳过转置符号变化；“不是忽略小量”偏防御 | 写出 $\boldsymbol\omega_i\times\boldsymbol r_i=-S(\boldsymbol r_i)\boldsymbol\omega_i$ 及转置 $\boldsymbol r_i^{\mathrm T}S^{\mathrm T}(\boldsymbol\omega_i)=\boldsymbol\omega_i^{\mathrm T}S(\boldsymbol r_i)$（两处负号相消），把 $\boldsymbol\omega_i$ 移到积分两侧；补对称矩阵 6 个独立分量与对齐长方体惯性积为零的例子 |
| note 框 L69–80 | $\boldsymbol I_i=\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}$ 与平行轴定理直接给结论，缺推导与检验 | 补 $\boldsymbol r_i=\boldsymbol R_i\boldsymbol r_i^i$ 与 $S(\boldsymbol R_i\boldsymbol r_i^i)=\boldsymbol R_iS(\boldsymbol r_i^i)\boldsymbol R_i^{\mathrm T}$ 代入积分的步骤；平行轴定理补距轴 $d$ 的质点检验 $I_O=md^2$ |
| §6.1.1.3 L107–115 | 从 $\dot{\boldsymbol p}_i=J_P^{(i)}\dot{\boldsymbol q}$ 直接跳到二次型 | 补平动项与转动项各自的转置展开中间式，标明 $3\times n$ 到 $n\times n$ 的维度 |
| §6.1.1.4 L140–152 | $J_O^{(m_i)}$ 只说“在 $j=i$ 处多出 $k_{r_i}\boldsymbol z_{m_i}$”，未写出矩阵列结构，也未说明 $k_{r_i}^2$ 与一次项 $k_{r_i}$ 怎么进入 $B$ | 写出 $J_O^{(m_i)}$ 的显式列分块，说明对角元出 $k_{r_i}^2$、与上游连杆交叉项出 $k_{r_i}$（链向 §6.3.2 的 $b_{12}$） |
| §6.1.1.5–6.1.1.6 | $B$ 的三条性质过于简略；上一轮删去了默写点，常见错误缺完整说明 | 补齐对称、正定（单杆半正定 vs 总和正定）、位形依赖的理由；恢复常见错误 4 条完整表述与默写点 4 条 |

### 清单核对

- 知识点：总动能拆分、连杆三项分解、叉乘反对称矩阵 $S(\cdot)$、惯性张量定义与对称性、连杆系常数惯量变换、平行轴定理、截取到连杆 $i$ 的质心雅可比、2 kg 质点二次型算例、转子动能与减速比、$B(\boldsymbol q)$ 四块求和与三条性质。全部保留。
- 图：5 张课件图（`inertia-tensor.jpg`、`inertia-def.jpg`、`kinetic-rotor.jpg`、`kinetic-link.jpg`、`inertia-matrix.jpg`）原样保留。
- 框与公式：`:::` 开 3 闭 3，`$$` 56 个，行内 `$` 294 个，全部配平。
- 测试：`robot/tools/` 无脚本直接正则解析 `sec6-1-1.md`。

### 复算（一次性 python）

- 2 kg 质点算例：$J_P=[[-1,-1],[1,0]]$，$B_{\text{point}}=2J_P^{\mathrm T}J_P=[[4,2],[2,2]]$，$\dot q=(1,-1)^{\mathrm T}$ 时 $v=(0,1)^{\mathrm T}$，$\frac12 m\|v\|^2=\frac12\dot q^{\mathrm T}B_{\text{point}}\dot q=1\ \mathrm J$。
- 反交换恒等式：随机三维向量 $\boldsymbol\omega,\boldsymbol r$，验证 $\boldsymbol r^{\mathrm T}S^{\mathrm T}(\boldsymbol\omega)S(\boldsymbol\omega)\boldsymbol r=\boldsymbol\omega^{\mathrm T}S^{\mathrm T}(\boldsymbol r)S(\boldsymbol r)\boldsymbol\omega$ 恒成立。

### 需要同步的配套页（只列出，未改）

- 无新增冲突；`summary.md`、`checklist.md`（K6.3–K6.5）与本节一致。
