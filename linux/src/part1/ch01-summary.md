# 1.1 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、hello 的一生**（1.1.1–1.1.4） | 源文件怎样变成进程？ | 预处理→编译→汇编→链接；ELF 有段/节/入口；Shell `fork` + `execve` + `wait` 把程序变成进程。 | 把编译当一个黑盒；把 ELF 当“二进制乱码”；以为 `exec` 会返回。 |
| **二、进程与系统**（1.1.5–1.1.8） | 进程看到什么？系统提供什么？ | 地址空间有代码/数据/堆/栈/共享库/内核；存储层次差几个数量级；OS 三个抽象：进程、虚拟内存、文件；网络也是 I/O。 | 把虚拟地址当物理地址；忽略 cache；把网络当“特殊东西”。 |
| **三、性能与证据**（1.1.9–1.1.10） | 优化哪一段？怎样证明？ | Amdahl：加速比受未优化部分限制；用 `gcc`/`readelf`/`objdump`/`strace`/`perf` 串证据链。 | 只优化热点的一小段；不看整体；用单次数字下结论。 |
| **四、深水区**（1.1.11–1.1.23） | 链接/加载/缓存的底层？ | `execve`→loader→`_start`→libc→`main`→`printf`→`write`；`_start` 栈有 argc/argv/envp/auxv；静态/动态链接、重定位、PLT/GOT、`LD_PRELOAD`；Little/CPI。 | 把 `_start` 当 `main`；忽略 auxv；PLT/GOT 混淆；缓存测量不预热。 |
| **五、收口**（1.1.24） | 怎样自检？ | 章末自检把“能说清链路/能拿证据/能算性能”分开验收。 | 只背结论不做实验。 |

## 一条主线

这一章用一条 `hello` 串起计算机系统：**源文件经过四阶段变成 ELF，Shell 用 `fork/execve/wait` 把它变成进程，进程在地址空间里跑，CPU 在存储层次里取数，OS 用进程/虚拟内存/文件三个抽象管理，网络也是 I/O**。第一遍看完整链路；第二遍下潜到 `execve→printf` 时间线、`_start`/auxv、静态/动态链接、重定位、PLT/GOT、Little/CPI 与三份 ELF。最后用章末自检确认“能说清、能取证、能计算”。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| 想看预处理/汇编/目标文件 | `gcc -E/-S/-c` | 四阶段各停一次，别一次 `gcc` 到底。 |
| 想看 ELF 布局/入口 | `readelf -h/-S/-l` | 段/节/入口/程序头。 |
| 想看符号/重定位 | `nm`、`readelf -r`、`objdump -t` | 符号表/重定位表。 |
| 想看反汇编 | `objdump -d`/`gdb disassemble` | 机器码与汇编对照。 |
| 想看动态依赖 | `readelf -d`、`ldd` | NEEDED/SONAME/RPATH；`ldd` 会执行 loader。 |
| 想看系统调用 | `strace -f` | `execve`/`openat`/`write` 的真实顺序。 |
| 想看 CPU 账 | `perf stat` | cycles/instructions/IPC/cache-misses。 |
| 想看启动/栈 | `gdb` 在 `_start` 断点、`info auxv` | argc/argv/envp/auxv。 |
| 想跨架构对比 | `file`、`readelf -h` | 机器类型/入口/ABI。 |
| 想估算优化收益 | Amdahl/CPI | 先算上限，再决定做不做。 |

## 能否讲出这八句话

1. 四阶段：预处理（`-E`）→编译（`-S`）→汇编（`-c`）→链接；每阶段产物不同。
2. ELF 有 header、section/segment、入口；`readelf -h/-S/-l` 看布局。
3. Shell 用 `fork` 复制进程、`execve` 换映像、`wait` 收状态；`exec` 成功不返回。
4. 进程地址空间有代码/数据/堆/栈/共享库/内核；虚拟地址由页表映射。
5. 存储层次从寄存器到磁盘差几个数量级；局部性让 cache 有效。
6. OS 三个抽象：进程、虚拟内存、文件；网络也是 I/O 设备。
7. Amdahl：加速比 = 1/((1-p)+p/s)；CPI = cycles/instructions。
8. `_start` 栈有 argc/argv/envp/auxv；静态/动态链接、重定位、PLT/GOT 决定“怎么加载”。

## 学完之后

1. **[闭卷回忆卡](ch01-recall.md)**：先合上正文，把四阶段、ELF、fork/exec、地址空间、存储层次、Amdahl 六组结论从空白纸上叫出来。
2. **[习题集](ch01-exercises.md)**：A 组检查概念，B 组诊断“为什么程序跑不起来/为什么优化没收益”，C 组做 `gcc`/`readelf`/`strace`/`perf` 实验。
3. **[学习目标自检表](ch01-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch01-errata.md)**：把编译器/链接器/架构的版本差异过一遍。
5. **下一站**：[1.2 信息的表示与运算](ch02.md) 会从“程序怎么跑”转到“数据怎么表示”；本章的字节账会在那里接到整数/浮点。
