# Summary

[封面与导览](index.md)

# 卷首

- [阅读方法与课程安排](preface.md)
- [范围声明与使用方法](preface-scope.md)
- [学习目标（K / S / A）](preface-objectives.md)
- [符号与缩略语表](preface-notation.md)
- [全书知识地图](preface-map.md)

# 学前准备

- [入学诊断：你该从哪一章开始](entry-test.md)

# 复习层

- [指令与要点速查卡](preface-formulas.md)
- [术语索引](preface-index.md)
- [易错点总表](preface-pitfalls.md)

# 第一章 · 绪论（课件待发布，占位）

- [第一章 · 绪论（占位）](ch01/overview.md)

# 第二章 · ARM 微处理器体系结构

- [第二章 · ARM 微处理器体系结构](ch02/overview.md)
  - [2.1 ARM 公司与体系结构族谱](ch02/sec2-1.md)
  - [2.2 AMBA 总线与系统互联](ch02/sec2-2.md)
  - [2.3 Cortex-A9 微架构](ch02/sec2-3.md)
  - [2.4 数据类型：字节、半字与字](ch02/sec2-4.md)
  - [2.5 处理器状态：ARM 与 Thumb](ch02/sec2-5.md)
  - [2.6 处理器模式：特权与异常的分层](ch02/sec2-6.md)
  - [2.7 内部寄存器组：37 个寄存器的分组设计](ch02/sec2-7.md)
  - [2.8 程序状态寄存器：CPSR 与 SPSR](ch02/sec2-8.md)
  - [2.9 异常：向量、优先级与响应流程](ch02/sec2-9.md)
  - [2.10 复位](ch02/sec2-10.md)
  - [2.11 存储器与存储器映射 I/O](ch02/sec2-11.md)

- [第二章章末](ch02/summary.md)
  - [勘误与补注（对照课件）](ch02/errata.md)
  - [习题集](ch02/exercises.md)
  - [学习目标自检表](ch02/checklist.md)
  - [闭卷回忆卡](ch02/recall-cards.md)
  - [综合自测卷](ch02/mock-exam.md)

# 第三章 · ARM 指令集

- [第三章 · ARM 指令集](ch03/overview.md)
  - [3.1 指令集概览与条件域](ch03/sec3-1.md)
  - [3.2 寻址方式](ch03/sec3-2.md)
  - [3.3 存储器访问指令：单寄存器加载与存储](ch03/sec3-3.md)
  - [3.4 存储器访问指令：多寄存器与数据交换](ch03/sec3-4.md)
  - [3.5 数据处理指令与桶形移位器](ch03/sec3-5.md)
  - [3.6 乘法指令](ch03/sec3-6.md)
  - [3.7 分支指令与状态切换](ch03/sec3-7.md)
  - [3.8 杂项指令：SWI 与程序状态寄存器访问](ch03/sec3-8.md)
  - [3.9 伪指令](ch03/sec3-9.md)
  - [3.10 Thumb 指令集与 ARM/Thumb 互操作](ch03/sec3-10.md)
  - [3.11 汇编程序结构与 C 互调](ch03/sec3-11.md)

- [第三章章末](ch03/summary.md)
  - [勘误与补注（对照课件）](ch03/errata.md)
  - [习题集](ch03/exercises.md)
  - [学习目标自检表](ch03/checklist.md)
  - [闭卷回忆卡](ch03/recall-cards.md)
  - [综合自测卷](ch03/mock-exam.md)

# 第四章 · 嵌入式操作系统

- [第四章 · 嵌入式操作系统](ch04/overview.md)
  - [4.1 嵌入式系统与安全关键系统](ch04/sec4-1.md)
  - [4.2 航电标准谱系：DO-178B/C 与 ARINC 653](ch04/sec4-2.md)
  - [4.3 嵌入式操作系统的结构：单内核、微内核与混合内核](ch04/sec4-3.md)
  - [4.4 微内核与 seL4](ch04/sec4-4.md)
  - [4.5 主流嵌入式操作系统全景](ch04/sec4-5.md)
  - [4.6 RT-Thread 与国产 RTOS 生态](ch04/sec4-6.md)
  - [4.7 进程、线程与任务模型](ch04/sec4-7.md)
  - [4.8 任务调度：非抢占、抢占与上下文切换](ch04/sec4-8.md)
  - [4.9 实时调度算法：RMS、EDF 与 LLF](ch04/sec4-9.md)
  - [4.10 进程间通信与同步](ch04/sec4-10.md)
  - [4.11 中断管理与时钟节拍](ch04/sec4-11.md)
  - [4.12 实时性：硬实时、软实时与确定性指标](ch04/sec4-12.md)
  - [4.13 实时 Linux](ch04/sec4-13.md)

- [第四章章末](ch04/summary.md)
  - [勘误与补注（对照课件）](ch04/errata.md)
  - [习题集](ch04/exercises.md)
  - [学习目标自检表](ch04/checklist.md)
  - [闭卷回忆卡](ch04/recall-cards.md)
  - [综合自测卷](ch04/mock-exam.md)

# 第五章 · AArch64 与内存系统（延伸阅读）

- [第五章 · AArch64 与内存系统](ch05/overview.md)
  - [5.1 从 ARMv7-A 到 ARMv8-A：版本演进](ch05/sec5-1.md)
  - [5.2 AArch64 执行状态与寄存器组](ch05/sec5-2.md)
  - [5.3 A64 指令集：与 A32 的关键差异](ch05/sec5-3.md)
  - [5.4 AArch64 异常体系：异常级与向量表](ch05/sec5-4.md)
  - [5.5 中断控制器 GIC](ch05/sec5-5.md)
  - [5.6 MMU 与多级页表](ch05/sec5-6.md)
  - [5.7 TLB：地址转换缓存](ch05/sec5-7.md)
  - [5.8 高速缓存：映射方式与共享性](ch05/sec5-8.md)
  - [5.9 缓存一致性：MESI 与维护指令](ch05/sec5-9.md)
  - [5.10 内存屏障与原子操作](ch05/sec5-10.md)
  - [5.11 链接器、链接脚本与 AAPCS64](ch05/sec5-11.md)

- [第五章章末](ch05/summary.md)
  - [勘误与补注（对照素材来源）](ch05/errata.md)
  - [习题集](ch05/exercises.md)
  - [闭卷回忆卡](ch05/recall-cards.md)
