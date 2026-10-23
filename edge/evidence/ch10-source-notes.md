# 第十章来源核读与纠偏（原创归纳）

## 方法与范围

- 本章涉及的硬件看门狗时序、故障状态寄存器、异常压栈以及复位原因排查，严格映射自经典母本与厂商官方硬件手册：
  1. 《TI Stellaris LM3S6965 Microcontroller》：物理页 90、176、194、371–382。
  2. 《ARMv7-M Architecture Ref Manual》：Chapter B1.5.6 (Fault Status Registers) 与 Chapter B1.5.8 (HardFault Handling)。
  3. 《The RISC-V Privileged Architecture》：Chapter 3.1.15 (Machine Cause & Trap Value)。
  4. 《ARM64体系结构编程与实践》：第 11 章 11.4 节（物理页 170）。
- 抽取的文本在本地忽略目录 `.qa/edge/sources/ch10/`，不发布母本原页或复制其插图与代码。
- 以下记录各单元在正文中的技术落实与边界说明。

## 详细核读与章节落点

| 来源单元 | 实际物理页 / 章节 | 本章技术落实与纠偏 | 落点节号 |
|:--|:--|:--|:--|
| TI LM3S6965：看门狗定时器 | 371–382 | 详细核查 32 位递减计数器（WDTLOAD/WDTVALUE）、控制寄存器（WDTCTL 中断使能与二次超时复位使能），以及 `WDTLOCK` 寄存器。在正文 §10.2 与固件中严格落实必须先写 `0x1ACCE551` 密钥方可解除写保护的防御机制，并在变异测试中验证了密钥错误导致的硬件保护生效。 | §10.2 |
| TI LM3S6965：复位原因寄存器 (RESC) | 176、194 | 详细核查 `RESC` 寄存器中 WDT (Bit 3)、POR (Bit 1)、BOR (Bit 2)、SW (Bit 4)、EXT (Bit 5)、MOSCFAIL (Bit 0) 的硬件锁存条件。在正文 §10.8 中落实复位自愈决策状态机，并纠偏了必须在读取后立即执行 W1C 写清零的规则，防止历史复位状态污染后续引导。 | §10.8 |
| TI LM3S6965：故障状态与地址寄存器 | 90 | 梳理 CFSR (UFSR/BFSR/MMFSR)、HFSR 与 MMFAR/BFAR 故障地址锁存微架构。在正文 §10.4 中详细分析了异步不精确总线错误（Imprecise BusFault）导致 PC 漂移的微架构根因，给出通过 `SCB->ACTLR.DISDEFWBUF` 禁用写缓冲以强制精准暴露错误的工程对策。 | §10.4 |
| ARMv7-M ARM：基础异常栈帧布局 | Chapter B1.5.6 | 严格核查异常进入时硬件自动压栈的 8 双字布局（R0-R3, R12, LR, PC, xPSR）。在正文 §10.4 中纠正了“HardFault 必然使用 MSP”的普遍认知误区，编写了基于 `LR` (EXC_RETURN) 的 Bit 2 动态判定 MSP 与 PSP 的严谨纯汇编入口。 | §10.4 |
| RISC-V Privileged：异常原因与故障值 | Chapter 3.1.15 | 严格核查 `mcause` 寄存器的同步异常编码表（Cause 2 非法指令, Cause 3 断点, Cause 5 读访问故障, Cause 7 写访问故障），以及 `mepc` 与 `mtval` 的锁存语义。在正文 §10.5 给出基于三寄存器的轻量级故障捕获分发器，并在 QEMU RV32 目标机上验证了 `ebreak` 捕获与 `mepc += 4` 自愈返回。 | §10.5 |
| ARM64 体系结构：11.4 节 异常现场保存 | 170 | 提取异常现场保存与内存故障排查的通用分级模型，在正文 §10.6 与 §10.7 中延伸至 x86-64 的 `#PF`/`#GP`/`#DF` 纯净双重错误栈与非易失 RAM 崩溃转储设计。 | §10.6、§10.7 |

## 验证与限制边界

- 实验一为主机 C11 仿真，通过 ASan/UBSan 监控，量化验证多任务代际 Token 窗口监管、提前喂狗违约拦截（`FAULT_WDT_EARLY_KICK`）、超时饥饿拦截（`FAULT_WDT_TIMEOUT`）、非易失 RAM 崩溃快照校验，以及 20 ms 总反应时间满足 50 ms 汽车电子节气门 FTTI 安全预算。
- 实验二为 QEMU Cortex-M3 与 RV32IM 虚拟目标机固件，实际配置硬件看门狗密钥解锁、故意触发未定义指令运行 HardFault 解码器（提取并验证栈帧 PC 与 CFSR），并在 RV32 上捕获 `ebreak` 异常；变异测试验证了密钥写保护与状态断言的确定性拦截。
- 本轮未连接物理高压脉冲发生器或外部硬件注入台，所有时间预算与故障状态均明确标示为数学模型或目标机仿真。
- 来源清单库继续保持未全部逐节录入的真实状态，不宣称“缺口 0”。
