# 符号与缩略语表

正文沿用课件与 ARM 文档的通用缩写。首次出现处都有展开；本表供随时回查，按主题分组。

## 处理器与体系结构（第二章）

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| RISC / CISC | Reduced / Complex Instruction Set Computer | 精简 / 复杂指令集计算机 |
| ISA | Instruction Set Architecture | 指令集体系结构 |
| ALU | Arithmetic Logic Unit | 算术逻辑单元 |
| PC | Program Counter（R15） | 程序计数器 |
| LR | Link Register（R14） | 链接寄存器 |
| SP | Stack Pointer（R13） | 堆栈指针（习惯用法） |
| CPSR / SPSR | Current / Saved Program Status Register | 当前 / 备份程序状态寄存器 |
| MMU | Memory Management Unit | 存储器管理单元 |
| VMSA | Virtual Memory System Architecture | 虚拟存储系统架构 |
| SCU | Snoop Control Unit | 侦测控制单元（多核一致性） |
| ACP | Accelerator Coherency Port | 加速器一致性端口 |
| AMBA | Advanced Microcontroller Bus Architecture | 高级微控制器总线架构 |
| AHB / ASB / APB / AXI | Advanced High-performance / System / Peripheral Bus; Advanced eXtensible Interface | 高性能 / 系统 / 外围总线；可扩展接口 |
| Jazelle / ThumbEE | Java 字节码硬件加速 / Thumb-2 运行时扩展（执行状态，见 §2.3、§2.5） | —— |

## 异常与模式（第二章）

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| usr / sys / svc | User / System / Supervisor（模式） | 用户 / 系统 / 管理 |
| fiq / irq | Fast Interrupt reQuest / Interrupt reQuest | 快中断 / 普通中断 |
| abt / und | Abort / Undefined | 中止 / 未定义 |
| SWI | Software Interrupt | 软件中断（后来的 SVC） |
| ISR | Interrupt Service Routine | 中断服务程序 |

## 指令集（第三章）

| 缩写 / 记号 | 含义 |
|:--|:--|
| LDR / STR | 加载 / 存储（LoaD Register / STore Register） |
| LDM / STM | 多寄存器加载 / 存储 |
| SWP | 数据交换指令 |
| MRS / MSR | 状态寄存器读 / 写（Move to Register from Status / Move to Status from Register） |
| `{cond}` | 可选条件域，如 EQ、NE、GT；缺省为 AL（无条件） |
| `S` 后缀 | 更新 CPSR 标志位（如 ADDS） |
| Rd / Rn / Rm / Rs | 目的寄存器 / 第一操作数寄存器 / 第二操作数寄存器 / 移位量寄存器 |
| `#imm` | 立即数（8 位循环右移偶数位构造，见 §3.2） |
| IA / IB / DA / DB | 递增先/后、递减先/后（多寄存器寻址） |
| FD / ED / FA / EA | 满递减等四种栈类型（§3.4） |
| ADR / ADRL | 小范围 / 大范围地址读取伪指令 |

## 操作系统（第四章）

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| RTOS | Real-Time Operating System | 实时操作系统 |
| IPC | Inter-Process Communication | 进程（任务）间通信 |
| RMS | Rate-Monotonic Scheduling | 单调速率调度 |
| EDF | Earliest Deadline First | 最早截止期优先 |
| LLF | Least Laxity First | 最短空闲时间优先 |
| DO-178B/C | 航空软件审定标准 | —— |
| ARINC 653 | 航电分区操作系统标准 | —— |
| DAL A–E | Development Assurance Level | 开发保证等级 |
| MMU / MPU | 见上 / Memory Protection Unit | 存储器保护单元（无 MMU 场景） |
| TCB | Task Control Block | 任务控制块 |

## 记号约定

- 十六进制数前缀 `0x`（如 `0xE3A00001`），二进制前缀 `0b`；指令编码一律 32 位，按 `[31:28]` 这类位段区间书写。
- 寄存器写作 R0–R15 时指当前模式下可见的那组物理寄存器；带后缀（如 R13_irq）指特定模式的分组副本。
- 时长单位 ns/µs/ms；频率 Hz/MHz/GHz。任务参数沿用 $T$（周期）、$C$（计算时间）、$D$（截止期）、$U$（利用率）。
