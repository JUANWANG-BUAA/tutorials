# Summary

[封面与导览](index.md)

# 卷首

- [为什么写这本书](preface.md)
- [范围、边界与架构聚焦](scope.md)
- [能力矩阵与技术全景路线](roadmap.md)
- [符号、寄存器记号与时序约定](notation.md)
- [实验环境与交叉编译工具链](env.md)

# 第 1 篇 · 处理器架构、启动与实时内核

- [1 从 Linux 到 MCU：资源边界、特权级与确定性实时性](part1/ch01.md)
- [2 MCU 架构、内存映射、链接脚本与系统启动流](part1/ch02.md)
- [3 中断、异常系统、NVIC/PLIC 与硬件时钟](part1/ch03.md)
- [4 RTOS 内核：任务上下文切换、抢占式调度与同步原语](part1/ch04.md)

# 第 2 篇 · 高速总线、外设通信与信号链路

- [5 高性能总线、DMA 引擎与高速串行接口 (UART/SPI/I2C)](part2/ch05.md)
- [6 CAN / CAN FD 协议栈、控制器寄存器与总线故障诊断](part2/ch06.md)
- [7 ADC 寄存器、Q 格式与跨架构定点滤波/FFT](part2/ch07.md)
- [8 高速数据采集系统架构、总线吞吐与存储流式管道](part2/ch08.md)

# 第 3 篇 · 功耗管理、安全容错与边缘智能

- [9 芯片功耗模型、低功耗模式转换与动态调频调压](part3/ch09.md)
- [10 功能安全、硬件看门狗、异常捕获与故障恢复](part3/ch10.md)
- [11 边缘张量推理：向量指令扩展、INT8 量化与内存预算](part3/ch11.md)
- [12 固件空中升级 (OTA)、双区 Flash 分区与原子回滚](part3/ch12.md)

# 第 4 篇 · 综合工程实战

- [项目总览与硬件靶机验收路线](projects/overview.md)
- [13 项目一：工业级 CAN 节点 + RTOS 实时调度 + 边缘 INT8 故障诊断系统](part4/ch13.md)
- [14 项目二：多通道高速数据采集、DMA 流式管道与低功耗故障自愈小系统](part4/ch14.md)

# 附录

- [A 母本覆盖矩阵](appendix/coverage.md)
- [B 硬件架构参考与常见陷阱速查](appendix/errata.md)
- [C 寄存器索引与工具链延伸指南](appendix/references.md)
