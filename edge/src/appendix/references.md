# 附录 C · 寄存器索引与工具链延伸指南

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>全书核心控制寄存器与架构缩写去哪里快速查阅？哪些官方硬件白皮书与技术规范是最终依据？如何进阶延伸学习？</p></div>
<div><span class="ci-label">读完你会</span><p>建立完整的嵌入式硬件寄存器与架构规范索引字典；掌握高效查阅 ARM Technical Reference Manual 与 RISC-V Privileged Spec 的方法。</p></div>
</div>

## C.1 核心架构寄存器与缩写速查表

| 缩写 | 英文全称 | 核心作用与定位 | 详细解析章节 |
|:--|:--|:--|:--|
| **NVIC** | Nested Vectored Interrupt Controller | ARM Cortex-M 嵌套向量中断控制器，硬件自动压栈与咬尾 | 第 3 章 |
| **PLIC** | Platform-Level Interrupt Controller | RISC-V 平台级中断控制器，处理外部设备全局中断路由与仲裁 | 第 3 章 |
| **CLINT** | Core-Local Interruptor | RISC-V 核心局部中断器，处理机器模式软件中断与定时器中断 | 第 3 章 |
| **VTOR** | Vector Table Offset Register | ARM Cortex-M 向量表偏移寄存器，支持双区 OTA 固件向量表重映射 | 第 2、12 章 |
| **PMP** | Physical Memory Protection | RISC-V 物理内存保护单元，硬件级隔离内存区域读写执行权限 | 第 2 章 |
| **MPU** | Memory Protection Unit | ARM 内存保护单元，提供分块访问权限控制与特权隔离 | 第 2 章 |
| **PendSV** | Pendable Service Call | ARM Cortex-M 可悬起系统调用异常，用于执行无锁低延迟上下文切换 | 第 4 章 |
| **mscratch** | Machine Scratch Register | RISC-V 机器模式暂存寄存器，用于中断入口原子交换运行栈指针 | 第 4 章 |
| **IWDG** | Independent Watchdog | 独立看门狗，基于专用低速内部时钟 (LSI)，防时钟失效死锁 | 第 10 章 |
| **WWDG** | Window Watchdog | 窗口看门狗，要求在精确的时间窗口内刷新，防止程序时序跑飞 | 第 10 章 |
| **SJA1000** | Stand-alone CAN Controller | 经典工业级独立 CAN 控制器，其寄存器与滤波模型为行业事实标准 | 第 6 章 |
| **M_CAN** | Bosch Modular CAN Controller | 现代车规级 CAN / CAN FD 控制器 IP，集成 64 字节 Message RAM | 第 6 章 |

## C.2 权威官方技术规范与延伸阅读

1. **ARM 架构规范**：
   - *ARMv7-M Architecture Reference Manual* (ARM DDI 0403E.e) —— Cortex-M3/M4/M7 中断、异常、调试与内存模型权威指南。
   - *ARM Architecture Reference Manual ARMv8, for ARMv8-A architecture profile* (ARM DDI 0487) —— 深入了解 AArch64 特权级、异常模型与内存屏障。
   - *Procedure Call Standard for the Arm Architecture (AAPCS)* —— 函数参数传递、寄存器易失性与栈 8 字节对齐标准。
2. **RISC-V 架构规范**：
   - *The RISC-V Instruction Set Manual, Volume I: User-Level ISA* —— RV32I/RV64I 基础指令集与向量扩展规范。
   - *The RISC-V Instruction Set Manual, Volume II: Privileged Architecture* —— 机器模式（M-Mode）、CSR 寄存器定义与 PMP 规范。
3. **车载与工业总线标准**：
   - *ISO 11898-1:2015* —— Road vehicles — Controller area network (CAN) — Part 1: Data link layer and physical signalling (含 CAN FD 规范)。
   - *Bosch CAN FD Specification Version 1.0* —— 详细阐述 64 字节载荷与位速率切换补偿机制。
4. **功能安全与软件可靠性标准**：
   - *IEC 61508* —— Functional safety of electrical/electronic/programmable electronic safety-related systems。
   - *MISRA C:2012* —— Guidelines for the use of the C language in critical systems。
