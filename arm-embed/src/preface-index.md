# 术语索引

按章列出核心术语，链接到首次系统讲解的小节。查表类内容（模式表、向量表、条件码）直接进[速查卡](preface-formulas.md)。

## 第二章 · ARM 微处理器体系结构

| 术语 | 去处 |
|:--|:--|
| ARM 公司与授权模式 / RISC 与 CISC / 8–2 原则 | [2.1](ch02/sec2-1.md) |
| 体系结构版本 v1–v9 / Cortex-A、R、M 家族 | [2.1](ch02/sec2-1.md) |
| AMBA / AHB / ASB / APB / AXI | [2.2](ch02/sec2-2.md) |
| 八级乱序流水线 / 超标量 / 动态分支预测 | [2.3](ch02/sec2-3.md) |
| SCU / ACP / 多核一致性 / VMSA / 多级 Cache | [2.3](ch02/sec2-3.md) |
| 字节 / 半字 / 字 / 对齐 / 符号扩展与零扩展 | [2.4](ch02/sec2-4.md) |
| ARM 状态 / Thumb 状态 / BX 切换 | [2.5](ch02/sec2-5.md) |
| 特权模式 / 异常模式 / 七种模式 | [2.6](ch02/sec2-6.md) |
| 37 寄存器 / 分组（banked）/ R13 SP / R14 LR / R15 PC | [2.7](ch02/sec2-7.md) |
| N Z C V 标志 / I F T 位 / M[4:0] / SPSR | [2.8](ch02/sec2-8.md) |
| 异常向量 / 优先级 / 进入与退出流程 / LR 偏移 | [2.9](ch02/sec2-9.md) |
| nRESET / 复位后状态 | [2.10](ch02/sec2-10.md) |
| 冯·诺依曼结构 / 统一编址 / 存储器映射 I/O / 大端小端 | [2.11](ch02/sec2-11.md) |

## 第三章 · ARM 指令集

| 术语 | 去处 |
|:--|:--|
| 指令 32 位编码 / cond 条件域 / S 后缀 | [3.1](ch03/sec3-1.md) |
| 九种寻址方式 / 立即数构造（8 位循环右移偶数位） | [3.2](ch03/sec3-2.md) |
| LDR / STR / 前索引 / 后索引 / T 后缀 | [3.3](ch03/sec3-3.md) |
| LDM / STM / 四种栈类型 / SWP 交换 | [3.4](ch03/sec3-4.md) |
| 数据处理指令 / 桶形移位器 / LSL LSR ASR ROR RRX | [3.5](ch03/sec3-5.md) |
| MUL / MLA / 64 位乘法 UMULL SMULL | [3.6](ch03/sec3-6.md) |
| B / BL / BX 与状态切换 / 返回地址 | [3.7](ch03/sec3-7.md) |
| SWI 软中断 / MRS / MSR | [3.8](ch03/sec3-8.md) |
| ADR / ADRL / LDR 伪指令 / NOP | [3.9](ch03/sec3-9.md) |
| Thumb 指令集 / 互操作 / veneer | [3.10](ch03/sec3-10.md) |
| 源程序格式 / AREA·ENTRY·END / 指示符 / 内嵌汇编 / APCS | [3.11](ch03/sec3-11.md) |

## 第四章 · 嵌入式操作系统

| 术语 | 去处 |
|:--|:--|
| 嵌入式系统定义 / 安全关键系统 / 确定性 | [4.1](ch04/sec4-1.md) |
| DO-178B/C / DAL A–E / ARINC 653 分区 | [4.2](ch04/sec4-2.md) |
| 单内核 / 微内核 / 混合内核 / 外内核 | [4.3](ch04/sec4-3.md) |
| 微内核三代 / L4 家族 / seL4 / capability / Retype | [4.4](ch04/sec4-4.md) |
| 嵌入式 Linux / μC Linux / VxWorks / QNX / μC/OS / RTEMS / TinyOS | [4.5](ch04/sec4-5.md) |
| RT-Thread / 国产 RTOS 谱系 / 华为产品线 | [4.6](ch04/sec4-6.md) |
| 进程 / 线程 / 任务 / 任务状态机 / 前后台系统 / 临界区 | [4.7](ch04/sec4-7.md) |
| 上下文切换 / 非抢占（协作式）/ 抢占 / 时间片 / VxWorks 调度 | [4.8](ch04/sec4-8.md) |
| RMS / EDF / LLF / 可调度性判定 | [4.9](ch04/sec4-9.md) |
| 共享内存 / 消息邮箱 / 消息队列 / 信号量 / 死锁 / 优先级反转 / 可重入 | [4.10](ch04/sec4-10.md) |
| ISR / 中断嵌套 / 时钟节拍 / 中断与调度时延 | [4.11](ch04/sec4-11.md) |
| 实时性定义 / 硬实时 / 软实时 / IEEE 七特征 | [4.12](ch04/sec4-12.md) |
| 实时 Linux / 瘦内核 / 超微内核 / 资源内核 / PREEMPT_RT | [4.13](ch04/sec4-13.md) |

## 第五章 · AArch64 与内存系统（延伸阅读）

| 术语 | 去处 |
|:--|:--|
| AArch32 / AArch64 / ARMv9 演进 | [5.1](ch05/sec5-1.md) |
| x0–x30 / w 视图 / XZR 零寄存器 | [5.2](ch05/sec5-2.md) |
| MOVZ/MOVK / CSEL / ADRP / STP·LDP | [5.3](ch05/sec5-3.md) |
| 异常级 EL0–EL3 / VBAR_ELx / ESR_ELx / SPSel / ERET | [5.4](ch05/sec5-4.md) |
| GIC / SGI·PPI·SPI / Distributor | [5.5](ch05/sec5-5.md) |
| 四级页表 / 恒等映射 / Device vs Normal | [5.6](ch05/sec5-6.md) |
| ASID / 重名与同名 / VIPT | [5.7](ch05/sec5-7.md) |
| 组相连 / 共享属性 / PoU 与 PoC / DC·IC 维护 | [5.8](ch05/sec5-8.md) |
| MESI / ACE / clean 与 invalidate | [5.9](ch05/sec5-9.md) |
| DMB·DSB·ISB / LDAR·STLR / LDXR·STXR / 自旋锁 | [5.10](ch05/sec5-10.md) |
| 链接地址 / AAPCS64 / LP64 陷阱 | [5.11](ch05/sec5-11.md) |

## 人名与机构

ARM（Acorn RISC Machine → Advanced RISC Machines）、Wind River、NICTA、AUTOSAR 联盟等背景见对应小节的"来历"段，不单列。
