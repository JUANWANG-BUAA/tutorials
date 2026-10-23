# 本轮修订边界

用户修订主线为 x86、ARM、RISC-V 架构与汇编；数电、模电、IC 不作独立教学主线。
不以行数达标替代事实核查。不把模型常量、QEMU 虚拟时钟或主机 wall time 写成硬件实测。

旧草稿已知阻断项（未全部修复，禁止宣称交付）：

- ch01: 纠正 BASEPRI 原始优先级编码与 BASEPRI_MAX 嵌套保护，补充 QEMU Cortex-M3 真实运行与削弱变异；澄清 AArch64 架构示意；移除绝对零抖动与无依据示波器数字，明确 CYCCNT 为观测 HWM 而非数学 WCET。
- ch02: 纠正 VTOR 对齐规则与移交条件；纠正 mtvec 槽宽与 norvc/norelax 约束；新增 Cortex-M3 与 RV32 目标机真实 CRT0 固件（奇数 27 字节 .data 与 31 字节 .bss 尾部测试），跳过搬移与 BSS 污染变异明确 FAIL。
- ch03: 替换虚构 12 周期压栈甘特图为标准阶段；替换 5 寄存器残缺 RV32 入口为可运行 144 字节完整现场，QEMU virt 实际执行 ECALL 与异步 MTIP，坏 a1 与坏 mepc 变异通过；忙等不称非阻塞，修复单次回绕 LOAD+1 丢失，双读时间戳倒退反例模型化。
- ch04: 原 PendSV 未逐任务保存 EXC_RETURN，原 PIP 主机测试丢弃同优先级队列任务；本轮替换为有反例测试的教学实现。
- ch05: 补充 UART IRQ5 字符注入目标执行，保留 DMA/Cache/SPI/I2C 离散模型边界。
- ch06: 新增经典 CAN/SJA1000 模型、独立位流对照与 x86 长模式核心执行；初版 SRR/IDE=01 的错误由边界测试发现并改为 11。核读 2000-01-04 原始 SJA1000 手册，明确八位 TXERR 恢复复用。
- ch07: 新增 ADC 采样接口、Q15、FIR/IIR、FFT64 与 32 块复数 double DFT 参照；QEMU Cortex-M3 定时器触发 ADC IRQ17 + SMULL，RV32 MULH/MUL 执行；无符号乘法与漏确认变异明确 FAIL；保留合成 ADC 噪声、模拟器 16 项 FIFO 与无实体传感器证据边界。
- ch08: 新增多级 DAQ 存储流式管道（5 ms 块擦除停顿 16 块 vs 4 块丢弃对照、缓存失效模型、容量预算定理）；QEMU Cortex-M3 128 块 Ping-Pong 固件、RV32 SPSC 队列固件；序列颠倒与预算算法变异明确 FAIL。
- ch09: 新增动态 CMOS 翻转与漏电功耗模型、DVFS 二次方能耗定理与降频反例；PLL 唤醒损益平衡（682 µs）与 Tickless 节电仿真；QEMU Cortex-M3 SCB->SCR/SLEEPONEXIT 与时钟门控固件、RV32 机器模式 WFI 定时唤醒固件；非法 SCR 配置与唤醒计数变异明确 FAIL。
- ch10: 新增功能安全 FTTI 预算模型与多任务窗口看门狗代际监管；非易失 RAM 崩溃快照与 RESC 复位原因自愈分流；QEMU Cortex-M3 硬件看门狗密钥解锁（0x1ACCE551）与 HardFault 栈帧解码（MSP/PSP 识别与 CFSR 诊断）、RV32 ebreak/mtval 故障捕获固件；WDT 写保护与 mcause 颠倒变异明确 FAIL。
- ch11: 新增 INT8 仿射定点量化、Q31 重量化乘法与对称舍入、零点偏置离线融合；Tensor Arena 静态内存池与双激活缓冲复用（64B 峰值）；标度因子失准引发隐藏层全饱和分类反转反例；QEMU Cortex-M3 与 RV32 纯整型 2 层振动分类 MLP 前向推理固件；预测颠倒变异明确 FAIL。
- ch12: 新增双区 Direct-XIP 物理分区拓扑、NOR Flash 1变0 与扇区擦除特性、寿命倍率定理；代际双页轮换、二阶段原子提交与 2184 组断电注入自愈仿真；OpenSSL P-256 签名验签与单调 Version Floor 防降级测试；QEMU Cortex-M3 与 RV32IM 真实 Bootloader 到应用程序标准六步硬件移交（关中断、清 SysTick、清 NVIC、切换 MSP、重设 VTOR/mtvec）、Mode 0/1/2 自检与看门狗自动回滚固件；缺少提交标记、未落盘试运行与 VTOR 遗漏变异明确 FAIL。
- ch13: 综合项目一（工业级 CAN 节点 + RTOS 实时调度 + 边缘 INT8 故障诊断系统）；RMS 调度定理与 RTA 迭代收敛（总负载 29.50%）；8 阶 Q15 FIR 滤波无溢出证明、SPSC 无锁环形队列零拷贝解耦；CAN 0x050 突发最高仲裁特权告警帧与 0x200 周期状态帧；多任务代际 Token 监视器联合打卡；200ms 全链路仿真、正常工况/轴承损伤注入/自愈三阶段验证与分类反转变异明确 FAIL。
- ch14: 综合项目二（多通道高速数据采集、DMA 流式管道与低功耗故障自愈小系统）；1 MSPS 采样抖动 SNR 退化推导与 AFE 运放阻抗匹配；循环双缓冲 DMA 引擎与按地址强制失效（Invalidate by Address）Cache 维护规约；定理 14.4.1 存储队列容量预算定理与 5ms Flash 擦除停顿背压吸收（16 槽位吸收 8 块突发，0 丢块）；WFI 动态待机与 Tickless 钩子（节能 >85%）；窗口看门狗刷新率上下限双向审查与 NOLOAD 崩溃黑匣子自愈流水线；数据块校验和破坏变异明确 FAIL。
- 旧 COVERAGE 生成器只核锚点，没有页级证据；已替换为严格页级台账生成器，当前 102 条记录/30 个未关闭门槛，明确失败，不生成“缺口 0”。附录 A 同步生成 `src/appendix/coverage.md`，整书 mdBook 成功构建，全站 27 页面、1833 条链接 0 断链。

后续需逐项以可定位来源和可执行回归关闭。独立审计两轮尚未完成。
