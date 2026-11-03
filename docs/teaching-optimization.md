# 八卷教学优化记录

第一轮修改八本教程的 32 个既有页面：27 个知识讲解页，以及 5 个诊断、总结、勘误、回忆卡或学习路线页。三名子代理分别负责矩阵与数值、机器人与深度学习、Linux 与 Agent；主代理负责分布式与编译器，并统一审阅、构建和检查。第二轮增量见本文末尾。

重点是让读者能从定义走到独立解题：补齐中间步骤，用两条路径核对同一结果，给出改变条件后的迁移题，并按错误原因指向需要重读的概念。没有新建重复的章节或调整原有导航。

## 各卷落点

| 教程 | 正文改进与可直接阅读的入口 |
|:--|:--|
| 矩阵论 | [非标准基坐标](../matrix/src/ch01/sec13.md)、[斜投影](../matrix/src/ch01/sec16.md)、[映射换基](../matrix/src/ch02/sec23.md)、[QR 最小二乘](../matrix/src/ch03/sec34.md)：从坐标路线解释乘法方向，重建向量与残差核对答案。 |
| 数值分析 | [条件数与残差](../numerical/src/course/ch02/sec23.md)、[压缩迭代](../numerical/src/course/ch04/sec41.md)、[复化求积](../numerical/src/course/ch06/sec62.md)、[ODE 单步法](../numerical/src/course/ch07/sec71.md)：连接误差界、计算步骤与停止准则，区分精度和稳定性。 |
| 机器人 | [齐次变换](../robot/src/ch02/sec2-7.md)、[2R 雅可比](../robot/src/ch03/sec3-1.md)、[单摆重力](../robot/src/ch06/sec6-1-2.md)、[保持与加速](../robot/src/ch06/sec6-1-3.md)：用变换重建、叉乘与偏导、势能与虚功分别核对。同步修订诊断与章末材料。 |
| 深度学习 | [共享参数反传](../deeplearning/src/lectures/lec01/sec15.md)、[因果注意力](../deeplearning/src/lectures/lec02/sec24.md)、[感受野](../deeplearning/src/lectures/lec03/sec32.md)：完整手算、改变未来值与层序的迁移题，连接损失归约、掩码与递推。同步回忆卡与学习路线。 |
| Linux | [文件 I/O](../linux/src/part2/ch02.md)、[fork 与 COW](../linux/src/part2/ch07.md)、[epoll](../linux/src/part2/ch18.md)：逐步追踪打开文件描述的偏移、短写进度、物理页与 RSS/PSS，以及 ET 读到暂停或结束的时序。 |
| Agent 系统 | [循环验收](../agent-systems/src/part1/ch01.md)、[上下文预算](../agent-systems/src/part2/ch05.md)、[配对评估](../agent-systems/src/part3/ch09.md)：把成功证据、预算裁剪与统计推断落实到完整数据表和核对题。 |
| 分布式系统 | [deadline 账本](../distributed/src/part1/ch02.md)、[quorum 读回退](../distributed/src/part2/ch03.md)、[线性一致历史](../distributed/src/part2/ch04.md)：区分总预算与每次尝试、集合相交与实际版本、单次解释与共同合法全序。 |
| 编译器 | [Pratt 递归追踪](../compilers/src/part1/ch02.md)、[名字绑定与赋值](../compilers/src/part1/ch03.md)、[phi 并行复制](../compilers/src/part1/ch04.md)：用调用栈、BindingId 表和回边值追踪解释原有算法。 |

## 本轮确认并纠正的问题

- 矩阵：相似变换的中间矩阵乘积有误；Gram 矩阵正定不能推出浮点计算稳定。
- 数值：Simpson 的 `S_10` 及求和边界、压缩迭代误差尾和、ODE 存在性与误差阶的适用条件需要纠正或补齐。
- 机器人：实际重力广义力与方程左端补偿项符号混用；2R 工作空间和转轴方向的部分诊断表述不准确。重力约定已同步正文、总结与勘误。
- 深度学习：感受野首层被重复计数；softmax、全掩码行、互相关核合并及转置算子的若干解释需要修正。同步相关回忆卡。
- Linux：COW 复制物理页不意味着子进程 RSS 翻倍；稀疏地址空间的 fork 成本不能只按虚拟大小推断。修复 COW 示例的缓冲与状态处理。
- Agent：上下文可行性证明的一处不等号反向；配对四格表的方向与净提升不一致；精确 McNemar 值需要截在 1。
- 分布式：待定操作不能随意补结果；线性一致是安全性质，不保证活性。预算不等式需要实际耗时上界和完整计账前提，p99 不能充当硬上界。

## 验证口径

新增例题已分别采用精确分数、数值复算、符号推导或小程序核对。编译器的 Pratt 例直接调用仓库解析器验证；绑定与赋值例按 C17 严格编译并核对实际输出；三操作历史枚举全部候选顺序，核对反例及修复后的见证。

仓库统一非浏览器门禁 `check.sh --no-browser` 通过：33 项 SMT-LIB 义务、既有数学表复算、31 项前端测试、13 项 Python 检查、四卷结构与覆盖检查、配套项目测试、八卷构建、632 页资源检查及 49,559 条站内链接检查。新增例题复算与这些既有形式核验是不同范围，不能将既有义务数量解释为本轮所有新例题都已形式化证明。

最后两页调整后重新执行八卷完整构建，资源和站内链接检查再次通过，确认所有修改源文件均早于最终 HTML。`git diff --check` 通过。本记录内 27 个正文入口也已检查存在。

第一轮浏览器回归未完成：Playwright CLI 在启动前触发 npm `EALLOWREMOTE`，其依赖指向被当前配置禁止的远程 tarball；使用官方 npm registry 进行进程级重试仍失败。未放宽远程包限制，也未将历史浏览器结果记为该轮通过。第二轮已用进程级官方 registry 与独立 npm 缓存解决启动问题，最终回归结果见下文。

Agent 章节实验报告 `PASS=18 FAIL=0 SKIP=4`；机器人第六章作业回归通过。宿主为 macOS，COW 示例完成严格编译与可移植行为运行，但没有在 Linux 上实测 `/proc` 的 RSS/PSS 或 epoll。相关语义已对照 Linux man-pages。没有逐题审校八卷全部正文，也没有执行全部正文代码。

## 第二轮：条件、反例与答案一致性

继续由原三名子代理分组执行，主代理负责分布式与编译器，并汇总复核。本轮新增审校 56 个既有页面，其中 25 个正文页、31 个配套页；两轮累计修改 88 个既有页面。配套页同步练习答案、回忆卡、总结、模拟卷、作业与勘误，避免正文已经纠正而复习材料仍重复旧结论。

| 教程 | 第二轮正文入口与教学改进 |
|:--|:--|
| 矩阵论 | [参数特征空间](../matrix/src/ch02/sec24.md)、[Schur 分解](../matrix/src/ch03/sec35.md)、[正交化边界](../matrix/src/ch03/sec36.md)：区分代数与几何重数，用实际换基核对上三角矩阵，并展示跨特征值 Gram–Schmidt 会破坏特征向量的反例。 |
| 数值分析 | [消元舍入实验](../numerical/src/course/ch02/sec21.md)、[带主元 LU](../numerical/src/course/ch02/sec22.md)、[Newton 插值](../numerical/src/course/ch05/sec51.md)、[最小二乘](../numerical/src/course/ch05/sec52.md)：逐步三位十进制运算，核对后续换行时的 L 乘子、增量差商、有效数字界与残差正交。 |
| 机器人 | [3R 逆解](../robot/src/ch02/sec2-12.md)、[轨迹最优性](../robot/src/ch04/sec4-2-1.md)、[执行器折算](../robot/src/ch05/sec5-2-3.md)：补全双分支正解回代与退化情况，限定三次轨迹和 LSPB 代价结论的前提，用能量与功率核对减速器坐标折算。 |
| 深度学习 | [损失函数](../deeplearning/src/lectures/lec01/sec14.md)、[泛化与正则化](../deeplearning/src/lectures/lec01/sec17.md)、[VAE](../deeplearning/src/lectures/lec04/sec43.md)：重算平方损失和标签平滑，纠正风险分解、Gaussian KL 单维非负性，给出路径梯度方差并非普遍更低的解析反例。 |
| Linux | [页表解析](../linux/src/part1/ch09.md)、[信号](../linux/src/part2/ch10.md)、[条件变量](../linux/src/part2/ch13.md)：拆解地址位段和页表页计数，澄清信号安全函数及 pending/sigsuspend 时序，用双消费者例题解释唤醒后仍需重检条件。 |
| Agent 系统 | [工具权限](../agent-systems/src/part1/ch02.md)、[检索排序](../agent-systems/src/part2/ch06.md)、[预算树](../agent-systems/src/part2/ch08.md)：区分 schema、scope 与对象授权，精确复算 RRF 并修正召回诊断，补上父节点自身支出的预算限制与回收例题。 |
| 分布式系统 | [MVCC](../distributed/src/part3/ch06.md)、[消费提交](../distributed/src/part3/ch07.md)、[fencing token](../distributed/src/part4/ch09.md)：纠正 InnoDB 默认隔离级别和快照字段，用完成顺序而非最大 offset 求安全前缀，区分 token 已签发与资源已观察到，以及 epoch 与幂等标识的职责。 |
| 编译器 | [数据流收敛](../compilers/src/part2/ch05.md)、[支配与优化](../compilers/src/part2/ch06.md)、[程序验证](../compilers/src/part3/ch11.md)：补齐极值初始化和公平调度前提，纠正直接支配者及 LICM 安全条件，修复 Hoare 赋值推理方向、步长循环后置与变体。 |

### 例题复算

新增 8 份标准库核验脚本，共 37 组检查全部通过：

| 脚本 | 组数 |
|:--|--:|
| [matrix/tools/verify_teaching_examples.py](../matrix/tools/verify_teaching_examples.py) | 3 |
| [numerical/tools/verify_teaching_examples.py](../numerical/tools/verify_teaching_examples.py) | 4 |
| [robot/tools/verify_teaching_examples.py](../robot/tools/verify_teaching_examples.py) | 7 |
| [deeplearning/tools/verify_teaching_examples.py](../deeplearning/tools/verify_teaching_examples.py) | 8 |
| [linux/tools/verify_teaching_examples.py](../linux/tools/verify_teaching_examples.py) | 4 |
| [agent-systems/tools/verify_teaching_examples.py](../agent-systems/tools/verify_teaching_examples.py) | 4 |
| [distributed/tools/verify_teaching_round2.py](../distributed/tools/verify_teaching_round2.py) | 3 |
| [compilers/tools/verify_teaching_round2.py](../compilers/tools/verify_teaching_round2.py) | 4 |

在仓库根目录使用 `python3 <脚本路径>` 运行。脚本核对选定例题及部分第一轮公式；采用精确分数、Decimal、独立数值路径、有限枚举和实际代码执行。分布式脚本直接提取正文的简化可见性函数与条件扣款代码；SQLite 只验证单语句例题，不模拟 PostgreSQL/InnoDB 的完整隔离行为，也未连接 Kafka 服务。Linux 页表、信号和条件变量检查包含模型枚举，不等于内核实测。VAE Monte Carlo 例同时报告标准误差，不把随机近似当作解析等式。

编译器既有 `ch05/dataflow_lab.py`、`ch06/opt_lab.py` 与 `ch11/proof_lab.py` 均通过；最后一项明确报告有界域无反例，不将其表述为无界证明。八卷例题日志位于 `.qa/teaching-round2-examples.log`。

### 全站验证

第二轮所有正文修改冻结后，统一运行 `check.sh --no-browser` 并通过：33 项既有 SMT-LIB 义务、196 个既有数学表值、31 项前端测试、13 项工具 Python 测试、四卷结构与覆盖检查、配套项目测试、八卷完整构建、632 页资源检查、49,607 条站内链接检查，以及 Agent 与编译器 HTML 检查。资源与链接检查没有发现缺失资源、重复 ID 或断链。日志位于 `.qa/teaching-round2-quality.log`。

在此最新构建上，`tools/check_browser.mjs` 退出码为 0，99 项浏览器检查全部通过：交互 47 项、阅读器变体 15 项、导览页 28 项、缓存 9 项。日志位于 `.qa/teaching-round2-browser.log`。启动时只为该进程设置官方 npm registry 和仓库内独立缓存，未放宽远程包限制或修改全局 npm 配置。`git diff --check` 通过。

这些检查与正文审校覆盖不同范围：本轮没有逐页验证全部公式或运行全部正文代码，也没有把既有形式化义务算作新例题的形式化证明。
