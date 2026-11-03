# 1.1 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：hello 的一生

### D1 · 四阶段

预处理、编译、汇编、链接各做什么？`gcc -E/-S/-c` 各停在哪？链接器输入输出是什么？

::: sol D1 核对

预处理：展开宏/头文件/条件编译，输出 `.i`；编译：C→汇编，输出 `.s`；汇编：汇编→目标文件，输出 `.o`；链接：合并目标文件/库、重定位，输出可执行 ELF。`gcc -E` 停在预处理，`-S` 停在汇编，`-c` 停在目标文件。链接器输入 `.o`/`.a`/`.so`，输出可执行/共享库。
:::

### D2 · ELF

ELF 里有什么？section 与 segment 差在哪？入口在哪看？

::: sol D2 核对

ELF 有 header、section（`.text`/`.data`/`.bss`/`.rodata`/`.symtab`/`.rela` 等）、program header（segment：LOAD/DYNAMIC/INTERP 等）、入口 `e_entry`。section 给链接器/调试器看，segment 给加载器看；`readelf -h` 看入口/类型，`-S` 看 section，`-l` 看 segment。
:::

### D3 · fork/exec/wait

Shell 怎样运行一条命令？`fork`/`execve`/`wait` 各做什么？`exec` 成功会返回吗？

::: sol D3 核对

Shell `fork` 复制子进程，子进程 `execve` 把映像换成目标程序，父 Shell `wait` 收退出码。`execve` 成功不返回（当前进程映像被替换）；失败返回 -1。`fork` 后父子各自执行，fd 表复制但共享打开文件描述。
:::

### D4 · 地址空间

进程的地址空间有哪些区域？虚拟地址与物理地址差在哪？页表做什么？

::: sol D4 核对

代码（`.text`）、只读数据（`.rodata`）、已初始化数据（`.data`）、未初始化数据（`.bss`）、堆（`brk`/`mmap`）、共享库、栈、内核（高地址）。虚拟地址是进程看到的地址，页表把它翻译成物理地址；每个进程有独立页表，所以同一虚拟地址可映射不同物理页。
:::

### D5 · 存储层次

存储层次从快到慢有哪些？为什么 cache 有效？局部性是什么？

::: sol D5 核对

寄存器 → L1/L2/L3 → DRAM → SSD/HDD → 网络/磁带。每层容量越大越慢；cache 利用时间/空间局部性，把常用数据放在近处。局部性：刚用过的/相邻的数据更可能再用；顺序访问数组比随机跳快。
:::

### D6 · OS 抽象与网络

OS 的三个抽象是什么？为什么说网络也是 I/O？文件描述符在哪一层？

::: sol D6 核对

进程（CPU/执行的抽象）、虚拟内存（地址空间的抽象）、文件（I/O 的抽象）。网络通过 socket fd 读写，和文件 I/O 共用 fd/read/write 模型，所以也是 I/O。fd 是进程内打开文件表的下标，socket/pipe/文件都走它。
:::

## B. 第二遍：深水区与证据

### D7 · Amdahl 与 CPI

Amdahl 公式是什么？CPI 是什么？为什么“优化一小段”收益有限？

::: sol D7 核对

加速比 = 1/((1-p)+p/s)，p 是优化部分占比，s 是该部分加速比；上限 1/(1-p)。CPI = cycles/instructions；CPU 时间 = 指令数 × CPI × 周期。只优化小 p，整体受未优化部分限制；先算上限再决定值不值得。
:::

### D8 · execve→printf 时间线

从 `execve` 到 `printf` 返回，大致经过哪些步骤？`_start`/libc/`main` 各做什么？

::: sol D8 核对

`execve` → 内核加载 ELF/映射段/设置栈 → 跳到入口 `_start` → libc 启动代码（初始化、`__libc_start_main`）→ 调 `main` → `printf` 格式化到 stdio 缓冲 → 满/换行/`fflush` 时 `write` → `main` 返回 → `exit`/`_exit` 清理。`_start` 不是 `main`；它准备参数/环境再调 libc。
:::

### D9 · `_start` 栈与 auxv

`_start` 时栈上有什么？`argc`/`argv`/`envp`/`auxv` 各是什么？auxv 里常见 `AT_*` 有哪些？

::: sol D9 核对

栈顶：`argc`、`argv[]`（以 NULL 结尾）、`envp[]`（NULL 结尾）、`auxv`（类型/值对，以 AT_NULL 结尾）。`auxv` 常见：`AT_PHDR`（程序头）、`AT_ENTRY`（入口）、`AT_BASE`（解释器基址）、`AT_RANDOM`（随机字节）、`AT_PAGESZ`。动态加载器/libc 靠它找程序头/入口。
:::

### D10 · 静态/动态链接与 PLT/GOT

静态链接与动态链接差在哪？PLT/GOT 是什么？`LD_PRELOAD`/`LD_DEBUG` 做什么？

::: sol D10 核对

静态链接把库代码复制进可执行；动态链接运行时加载 `.so`，可共享/升级。PLT 是跳转桩，GOT 存函数/数据地址；首次调用经 PLT→GOT→动态加载器解析（lazy），`BIND_NOW` 立即绑定。`LD_PRELOAD` 预加载库（覆盖符号），`LD_DEBUG=libs/bindings` 看加载/绑定。
:::

### D11 · Little 定律与指针追逐

Little 定律是什么？指针追逐为什么测延迟？MLP 是什么？

::: sol D11 核对

Little：L = λW（并发数 = 到达率 × 停留时间）。指针追逐是串行依赖的随机访存，测的是内存延迟而非带宽；MLP（memory-level parallelism）是同时未完成的访存数，乱序/多线程可提高。测 cache 要先预热、控制频率/ASLR。
:::

### D12 · 跨架构 hello

x86-64/ARM64/RISC-V 的 hello 在入口/系统调用/ELF 上有什么不同？`file`/`readelf` 看什么？

::: sol D12 核对

入口都是 `_start`，但 ABI 不同：x86-64 用 `syscall`，调用号 `rax`；ARM64 用 `svc #0`，号 `x8`；RISC-V 用 `ecall`，号 `a7`。ELF header 的 `e_machine`/`e_entry`/ABI 不同；`file` 看架构/类型，`readelf -h` 看 machine/entry，`objdump -d` 看指令。
:::
