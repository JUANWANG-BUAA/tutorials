# 符号、寄存器记号与时序约定

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>书中的寄存器位段、内存基地址、汇编语法、时序参数与数学公式遵循什么通用约定？如何正确理解各个架构中专用缩写的微观含义？</p></div>
<div><span class="ci-label">读完你会</span><p>能够迅速、毫无歧义地解读全书所有硬件手册级寄存器表、汇编代码片段、波形时序图与定点运算表达式。</p></div>
</div>

## 0.1 寄存器与位域记号

在描述硬件外设与系统寄存器时，本书严格采用标准半导体规范的记法：

| 记法 | 含义说明 | 实例 |
|:--|:--|:--|
| `REG[n]` | 寄存器的第 $n$ 个比特（从 0 计起，0 为最低有效位 LSB） | `NVIC_ISER[5]` 表示使能 5 号中断 |
| `REG[m:n]` | 寄存器从第 $m$ 位到第 $n$ 位的连续位段 ($m \ge n$) | `TIMx_CR1[9:8]` 表示时钟分频系数 CKD |
| `0xABCD_EF01` | 十六进制常数，下划线用于增强长位宽地址的可读性 | `0x4001_3800` (USART1 基地址) |
| `rw` / `ro` / `wo` | 访问属性：读写 (Read/Write)、只读 (Read Only)、只写 (Write Only) | 状态寄存器标志位多为 `ro` 或写 1 清零 (`rc_w1`) |
| `(1 << n)` | C 语言位掩码操作，置位第 $n$ 位 | `USART_CR1 |= (1U << 13)` |

## 0.2 三大架构汇编指令与寄存器对照

| 架构体系 | 通用寄存器记号 | 特殊控制寄存器 | 函数调用栈指针 | 系统调用 / 特权陷入指令 |
|:--|:--|:--|:--|:--|
| **ARM Cortex-M (Thumb-2)** | `R0`–`R12`, `LR` (R14), `PC` (R15) | `PRIMASK`, `FAULTMASK`, `BASEPRI`, `CONTROL`, `xPSR` | `MSP` (主栈), `PSP` (进程栈) | `SVC #imm8` (陷入), `BX LR` / `EXC_RETURN` (异常返回) |
| **ARMv8-A (AArch64)** | `X0`–`X30` (64位), `W0`–`W30` (32位) | `PSTATE`, `SPSR_ELn`, `ELR_ELn`, `VBAR_ELn`, `ESR_ELn` | `SP_EL0`, `SP_ELn` | `SVC #imm16`, `ERET` (从异常返回) |
| **RISC-V (RV32/RV64)** | `x0`–`x31` (`zero`, `ra`, `sp`, `gp`, `tp`, `t0-t6`, `s0-s11`, `a0-a7`) | `mstatus`, `mie`, `mip`, `mtvec`, `mepc`, `mcause`, `mtval`, `mscratch` | `sp` (`x2`) | `ecall` (环境调用), `mret` / `sret` (特权返回) |
| **x86_64** | `%rax`, `%rbx`, `%rcx`, `%rdx`, `%rsi`, `%rdi`, `%rbp`, `%rsp`, `%r8`–`%r15` | `CR0`, `CR3`, `CR4`, `RFLAGS`, `IA32_EFER`, `IA32_LSTAR` | `%rsp` (栈顶指针) | `syscall`, `sysretq` / `iretq` |

## 0.3 内存与时序符号约定

- **地址分类**：
  - `VMA` (Virtual Memory Address)：程序执行时访问的虚拟或运行期地址。
  - `LMA` (Load Memory Address)：程序镜像烧录在 Flash 或 ROM 中的加载存储地址。
- **时序参数**：
  - $T_{clk}$：系统主时钟周期 ($T_{clk} = 1 / f_{clk}$)。
  - $T_{prop}$：信号在物理传输线上的单向传播延迟（通常双绞线约为 $5\,\text{ns/m}$）。
  - $T_{sample}$：采样保持时间，ADC 采样开关闭合进行电容充电所需的最小时长。
  - $T_{latency}$：中断发生至执行中断服务程序第一条指令所消耗的确定性时钟周期数。
- **定点数学**：
  - $\text{Q}m.n$：定点数格式，其中 1 位符号位，$m$ 位整数位，$n$ 位小数位。若未指明 $m$，则 $\text{Q}n$ 代表总位宽 $N$ 位且有 $n$ 位小数的定点数（例如 Q15 即 16 位有符号数，15 位小数，数值范围 $[-1, 1 - 2^{-15}]$）。
