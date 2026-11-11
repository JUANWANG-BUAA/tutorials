# 5.4 AArch64 异常体系：异常级与向量表

第二章 2.9 讲 ARMv7 的异常：7 种异常、固定在 0x0–0x1C 的八个 4 字节向量、模式切换时 CPSR 与 SPSR 的配合。AArch64 把这套机制整体重做：**异常分级（Exception Level）、可编程向量表（VBAR_ELx）、系统寄存器取代专用状态寄存器**。本节是全章骨架，建议先读。（依据素材书第 11 章）

## 5.4.1 异常级 EL0–EL3

ARMv8-A 定义了 **4 个异常级**：

| 异常级 | 名称 | 典型角色 |
|:--|:--|:--|
| **EL0** | 用户态 | 用户程序运行的最低特权级 |
| **EL1** | 内核态 | 操作系统内核 |
| **EL2** | 虚拟化 | 虚拟机监控器（hypervisor） |
| **EL3** | 安全态 | 最高安全级（可信执行环境、安全固件） |

每级有**自己的异常向量表**（EL3、EL2、EL1 各一张，EL0 没有——EL0 产生的异常总是进入 EL1）。

**特权级的方向**：数值越大权限越高。EL0 不能访问 EL1 及以上的系统寄存器；EL1 也不能随便动 EL2/EL3 的寄存器——这正是 AArch64 权限模型的分层基础。

## 5.4.2 异常向量表：从 8 项 4 字节到 16 项 128 字节

这是 AArch64 与 AArch32 差别最大的一处。

**AArch32（2.9.2）**：向量表固定在低地址 0x00000000（或高向量 0xFFFF0000），每项 **4 字节**，放一条跳转指令，共 8 项（其中 0x14 保留）。

**AArch64**：每级异常各有自己的向量表，基址由 **VBAR_ELx**（Vector Base Address Register）设定；**每项 128 字节**（可容纳 32 条 32 位指令），共 **16 项**。表项按"来源异常级"与"使用的栈指针"分组：

| 偏移 | 异常类型 | 来源/栈 |
|:--|:--|:--|
| +0x000 | 同步异常 | 当前 EL，使用 **SP_EL0** |
| +0x080 | IRQ / vIRQ | 同上 |
| +0x100 | FIQ / vFIQ | 同上 |
| +0x180 | SError / vSError | 同上 |
| +0x200 | 同步异常 | 当前 EL，使用 **SP_ELx** |
| +0x280 | IRQ / vIRQ | 同上 |
| +0x300 | FIQ / vFIQ | 同上 |
| +0x380 | SError / vSError | 同上 |
| +0x400 | 同步异常 | **EL0**，AArch64 执行状态 |
| +0x480 | IRQ / vIRQ | 同上 |
| +0x500 | FIQ / vFIQ | 同上 |
| +0x580 | SError / vSError | 同上 |
| +0x600 | 同步异常 | **EL0**，AArch32 执行状态 |
| +0x680 | IRQ / vIRQ | 同上 |
| +0x700 | FIQ / vFIQ | 同上 |
| +0x780 | SError / vSError | 同上 |

{{#include ../assets/figures/arm-exlevels.md}}

为什么"当前 EL 的异常"要分 SP_EL0 与 SP_ELx 两组？见下一节。

**VBAR_ELx 的对齐要求**：基地址存放在 Bit[63:11]，Bit[10:0] 保留——所以**异常向量表的起始地址必须 2 KB 对齐**。这是写内核时的硬性约束。

::: note 为什么每项 128 字节
AArch32 的向量项只有 4 字节（放一条 B 指令），所以每个异常都要"再跳一次"。AArch64 给足 128 字节，让处理程序可以直接写在里面，省掉一次跳转——这与 2.9.2 提到的 "FIQ 向量在表末可省一次跳转" 是同一个思路，但 AArch64 把它推广到了所有异常。
:::

## 5.4.3 栈的选择：SP_EL0 / SP_ELx 与 SPSel

AArch64 没有 2.7.2 那种"每模式一套 R13/R14"的分组寄存器。它用**按异常级划分的栈指针寄存器**：

| 异常级 | 栈指针 |
|:--|:--|
| EL0 | SP_EL0 |
| EL1 | SP_EL1t、SP_EL1h |
| EL2 | SP_EL2t、SP_EL2h |
| EL3 | SP_EL3t、SP_EL3h |

后缀含义：

- **t（tied）**：该异常级使用**当前 EL 的栈指针**（SP_ELx）；
- **h（hyp）**：该异常级使用**SP_EL0**。

到底用哪个，由 **SPSel** 寄存器的第 0 位决定：

- SPSel = **0**：所有 EL 都使用 **SP_EL0**；
- SPSel = **1**：使用 **SP_ELx**（各 EL 用自己的栈）。

于是 AArch64 的栈选择规则可以表述为：**异常发生时，CPU 自动选择目标异常级对应的栈指针**——若当前在 EL0 跑用户程序时突然来了中断、陷入 EL1，CPU 就自动改用 SP_EL1 指向的栈空间。

::: note 栈必须 16 字节对齐
AArch64 要求 SP **16 字节对齐**，否则函数调用（用栈传参与保存寄存器）会出问题。可以用 `SCTLR_ELx.SA` 位让 CPU **自动检测 SP 是否对齐**，不对齐则触发 **SP alignment fault**。这是 AArch64 新增的异常类型之一。
:::

**为什么要有 t/h 两套**：内核想在异常发生时用"与被打断代码无关的独立栈"（h 语义），还是"沿用用户栈"（t 语义），由内核自己选。Linux 内核默认让内核态用 SP_EL1、EL0 的 AArch64 异常用 SP_EL0。

## 5.4.4 异常现场：保存什么、存哪里

异常发生时需要保存被打断现场的上下文，避免破坏正在处理的数据和程序状态。AArch64 的异常现场包含：

- **PSTATE** 寄存器（处理器状态，含 NZCV、中断屏蔽位 D/A/I/F、执行状态等）；
- **PC** 值（返回地址）；
- **SP** 值；
- **x0–x30** 寄存器的值。

存放位置：**目标异常级的内核栈**（每个进程都有自己的内核栈空间）。

对照第二章 2.9.3：AArch32 由硬件自动保存的只有 **CPSR→SPSR、LR、模式位**——**通用寄存器不自动保存**，要由中断处理程序自己压栈（这就是 2.9.4 那段 `STMFD SP!, {R0-R3, LR}` 的由来）。AArch64 同样不自动保存通用寄存器，但把 PSTATE、ELR（返回地址）、SPSR_ELx 这些**状态信息放进了系统寄存器**，不再需要 SPSR 那种"每模式一份"的硬件分组。

::: ex 例 5.4.1 · AArch32 与 AArch64 保存现场的责任划分 {#ex-5.4.1}
| | AArch32（2.9） | AArch64 |
|:--|:--|:--|
| 硬件自动做 | LR←返回地址；CPSR→SPSR；改模式位；PC←向量 | PSTATE→SPSR_ELx；ELR_ELx←返回地址；选栈；PC←VBAR+偏移 |
| 软件要做 | 压栈保存用到的通用寄存器（含 LR） | 压栈保存 x0–x30（及 x29/x30 帧指针） |
| 状态寄存器在哪 | 专用寄存器 SPSR（分组） | **系统寄存器** SPSR_ELx / ELR_ELx / ESR_ELx |

差别不在"要不要保存"，而在**状态信息从专用寄存器搬进了系统寄存器**——这是一条贯穿全章的主线。
:::

## 5.4.5 异常综合寄存器 ESR_ELx：判断"出了什么事"

AArch32 里，异常处理程序靠"当前处于哪个模式"就知道大概发生了什么（2.9.2 的模式表）。AArch64 异常来源多得多（几十种），需要更细的判别——靠 **ESR_ELx（Exception Syndrome Register）**。

结构（4 个字段）：

| 字段 | 位 | 含义 |
|:--|:--|:--|
| 保留 | Bit[63:32] | —— |
| **EC**（Exception Class） | Bit[31:26] | **异常类**：指示异常分类，同时索引 ISS 字段 |
| **IL**（Instruction Length） | Bit[25] | 同步异常的指令长度（0 = 16 位，1 = 32 位） |
| **ISS**（Instruction Specific Syndrome） | Bit[24:0] | 具体异常信息，**编码格式随异常类型而变** |

常用 EC 编码（部分）：

| EC | 名称 | 含义 |
|:--|:--|:--|
| 0x0E | ILL | 非法的执行状态（未定义指令） |
| 0x15 | SVC64 | AArch64 的 SVC 指令异常（系统调用） |
| 0x18 | SYS64 | AArch64 的 MSR/MRS 等系统指令异常 |
| 0x20 / 0x21 | IABT_LOW / IABT_CUR | 低级别/当前级的取指中止 |
| 0x22 | PC_ALIGN | PC 未对齐 |
| 0x24 / 0x25 | DABT_LOW / DABT_CUR | 低级别/当前级的数据中止 |
| 0x26 | SP_ALIGN | SP 未对齐 |
| 0x2F | SERROR | 系统错误 |

数据异常时，ISS 字段进一步细分（Bit[5:0] 为 **DFSC** 数据异常状态码，Bit[6] 为 **WnR** 读写标志，Bit[7] 为 **S1PTW** 表示异常是否发生在页表遍历中，Bit[15] 为 **SF** 表示访问宽度是 32 位还是 64 位）。

```asm
        ; 读 ESR_EL1 的 EC 字段
        MRS   x0, ESR_EL1
        LSR   x0, x0, #26        ; EC 在 Bit[31:26]
        AND   x0, x0, #0x3f     ; 取 6 位
```

## 5.4.6 异常返回：ERET 与 SPSR

异常处理结束时用 **ERET** 指令返回（不是 AArch32 的"写 PC"）。返回到哪里，由 **SPSR_ELx** 记录：

| SPSR 字段 | 含义 |
|:--|:--|
| **M[3:0]** | 返回哪个异常级，以及用哪个栈指针 |
| **M[4]** | 返回哪个执行状态（0 = AArch64，1 = AArch32） |

M[3:0] 的编码（节选）：

| 编码 | 含义 |
|:--|:--|
| 0b0000 | EL0t |
| 0b0100 | EL1t |
| 0b0101 | EL1h |
| 0b1000 | EL2t |
| 0b1001 | EL2h |
| 0b1100 | EL3t |
| 0b1101 | EL3h |

::: note AArch64 里"执行状态"仍可能变化
AArch64 处理器**可以同时实现 AArch32 与 AArch64**。此时从 EL0 跑 AArch32 程序、发生中断陷入 EL1，异常处理程序可能运行在 AArch64 状态——这由 **HCR_EL2.RW** 位（Bit[31]）控制：RW=1 表示 EL1 用 AArch64 执行状态、EL0 的执行状态由 PSTATE.nRW 决定；RW=0 表示 EL0 与 EL1 都用 AArch32。
:::

**一次典型的 EL2 → EL1 切换**（素材书的案例）要设置五个寄存器：

```asm
        ldr   x0, =HCR_RW            ; HCR_EL2.RW = 1 → EL1 用 AArch64
        msr   hcr_el2, x0
        ldr   x0, =SCTLR_VALUE       ; 设置大小端、关闭 MMU
        msr   sctlr_el1, x0
        ldr   x0, =SPSR_EL1          ; SPSR_EL2.M = EL1h
        msr   spsr_el2, x0
        adr   x0, el1_entry          ; ELR_EL2 ← el1_entry
        msr   elr_el2, x0
        eret                        ; 按 SPSR/ELR 返回
```

## 5.4.7 Linux 的异常向量表长什么样

素材书以 Linux 5.0 内核的 `arch/arm64/kernel/entry.S` 为例。它的结构与上表完全对应：

```asm
        .align 11                    ; 2 KB 对齐（VBAR_EL1 的要求）
ENTRY(vectors)
        kernel_ventry 1, sync_invalid     ; EL1t 模式下的同步异常
        kernel_ventry 1, irq_invalid      ; EL1t 模式下的 IRQ
        kernel_ventry 1, fiq_invalid      ; EL1t 模式下的 FIQ
        kernel_ventry 1, error_invalid    ; EL1t 模式下的 SError
        kernel_ventry 1, sync             ; EL1h 模式下的同步异常
        ...
        kernel_ventry 0, sync             ; 64 位 EL0 下的同步异常
        ...
END(vectors)
```

`kernel_ventry` 是个宏：

```asm
        .macro kernel_ventry, el, label, regsize = 64
        .align 7                       ; 128 字节对齐（每个表项）
        sub  sp, sp, #S_FRAME_SIZE     ; 预留 pt_regs 帧
        b    el\()\el\()_\label
        .endm
```

宏里的 `\()` 是个 GNU as 语法技巧：**告诉汇编器"参数到这里结束"**。因为 `el\()\el\()_\label` 里连续出现两次 `el`，汇编器无法判断参数边界，需要用 `\()` 显式终止。素材书专门讲了这个点——它是 GNU 汇编宏里最常见的"看不懂"来源之一。

::: note 与第三章 3.11 的呼应
3.11 讲了 ARM 汇编的行格式与常用指示符；这里的 `.align 11`（2 KB 对齐）、`.align 7`（128 字节对齐）、`.macro/.endm` 都出自那一节。`.align` 的参数是 **2 的幂次**：11 → 2¹¹ = 2048 字节，7 → 2⁷ = 128 字节。
:::

## 本节小结

AArch64 的异常体系 = **4 个异常级**（EL0–EL3）+ **每级一张 16 项 × 128 字节的向量表**（基址由 VBAR_ELx 设定、2 KB 对齐）+ **系统寄存器**（SPSR_ELx / ELR_ELx / ESR_ELx）取代 AArch32 的分组状态寄存器 + **SP_EL0/SP_ELx 两套栈指针**（由 SPSel 选择）。异常返回用 ERET。理解了这四件，5.5 的中断控制器才有落点。
