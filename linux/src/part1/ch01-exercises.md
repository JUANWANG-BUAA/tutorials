# 1.1 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 四阶段

预处理、编译、汇编、链接各做什么？`gcc -E/-S/-c` 各停在哪？链接器输入输出是什么？

::: sol 解答

预处理：展开宏/头文件/条件编译，输出 `.i`；编译：C→汇编，输出 `.s`；汇编：汇编→目标文件，输出 `.o`；链接：合并目标文件/库、重定位，输出可执行 ELF。`-E` 停预处理，`-S` 停汇编，`-c` 停目标文件。链接器输入 `.o`/`.a`/`.so`，输出可执行/共享库。

:::
:::

::: ex A2 · ELF

ELF 里有什么？section 与 segment 差在哪？入口在哪看？

::: sol 解答

ELF 有 header、section（`.text`/`.data`/`.bss`/`.rodata`/`.symtab`/`.rela`）、program header（LOAD/DYNAMIC/INTERP 等）、入口 `e_entry`。section 给链接器/调试器，segment 给加载器；`readelf -h` 看入口/类型，`-S` 看 section，`-l` 看 segment。

:::
:::

::: ex A3 · fork/exec/wait

Shell 怎样运行一条命令？`fork`/`execve`/`wait` 各做什么？`exec` 成功会返回吗？

::: sol 解答

Shell `fork` 复制子进程，子进程 `execve` 换映像，父 Shell `wait` 收退出码。`execve` 成功不返回；失败返回 -1。`fork` 后父子各自执行，fd 表复制但共享打开文件描述。

:::
:::

::: ex A4 · 地址空间

进程的地址空间有哪些区域？虚拟地址与物理地址差在哪？页表做什么？

::: sol 解答

代码 `.text`、只读数据 `.rodata`、已初始化 `.data`、未初始化 `.bss`、堆、共享库、栈、内核。虚拟地址是进程看到的地址，页表翻译成物理地址；每个进程独立页表，同一虚拟地址可映射不同物理页。

:::
:::

::: ex A5 · 存储层次

存储层次从快到慢有哪些？为什么 cache 有效？局部性是什么？

::: sol 解答

寄存器 → L1/L2/L3 → DRAM → SSD/HDD → 网络/磁带。每层越大越慢；cache 利用时间/空间局部性，把常用数据放近处。局部性：刚用过的/相邻的数据更可能再用；顺序访问数组比随机跳快。

:::
:::

::: ex A6 · OS 抽象与网络

OS 的三个抽象是什么？为什么说网络也是 I/O？文件描述符在哪一层？

::: sol 解答

进程、虚拟内存、文件。网络通过 socket fd 读写，和文件 I/O 共用 fd/read/write 模型，所以也是 I/O。fd 是进程内打开文件表的下标，socket/pipe/文件都走它。

:::
:::

::: ex A7 · Amdahl 与 CPI

Amdahl 公式是什么？CPI 是什么？为什么“优化一小段”收益有限？

::: sol 解答

加速比 = 1/((1-p)+p/s)，p 是优化部分占比，s 是该部分加速比；上限 1/(1-p)。CPI = cycles/instructions；CPU 时间 = 指令数 × CPI × 周期。只优化小 p，整体受未优化部分限制；先算上限再决定值不值得。

:::
:::

::: ex A8 · 静态/动态链接

静态链接与动态链接差在哪？PLT/GOT 是什么？`LD_PRELOAD`/`LD_DEBUG` 做什么？

::: sol 解答

静态链接把库代码复制进可执行；动态链接运行时加载 `.so`，可共享/升级。PLT 是跳转桩，GOT 存函数/数据地址；首次调用经 PLT→GOT→动态加载器解析（lazy），`BIND_NOW` 立即绑定。`LD_PRELOAD` 预加载库覆盖符号，`LD_DEBUG=libs/bindings` 看加载/绑定。

:::
:::

## B 组 · 诊断推理

::: ex B1 · 程序 `not found`

一个 ELF 在别的机器上执行报 `not found`，`ls` 能看到文件。列出至少三种原因与验证。

::: sol B1 核对

① 动态加载器/interpreter 不存在：`file`/`readelf -l` 看 interpreter；② 依赖 `.so` 缺失：`readelf -d`/`ldd`；③ 架构不对：`file`；④ `noexec` 挂载/权限；⑤ 脚本 shebang 解释器缺失。修：装兼容库/静态链接/容器固定 rootfs/改 interpreter（有风险）。

:::
:::

::: ex B2 · 优化没收益

你把一个占 10% 时间的函数加速 2 倍，整体只快了 5%。为什么？Amdahl 上限是多少？

::: sol B2 核对

Amdahl：p=0.1，s=2，加速比 = 1/(0.9+0.05)=1.0526，约 5.3%；上限 1/(1-0.1)=1.111（约 11%）。剩余 90% 未优化，整体受限。要更大收益，优化更大占比或减少调用/算法复杂度。

:::
:::

::: ex B3 · 静态 vs 动态

静态链接和动态链接各适合什么？为什么容器里常用静态/distroless？

::: sol B3 核对

静态：依赖少、部署简单、启动快，但体积大、库升级要重编、多进程不共享；动态：共享库、体积小、可独立升级，但依赖/ABI/加载器问题多。容器里静态/distroless 减少 rootfs/依赖/攻击面，但调试/证书/时区要自己带。

:::
:::

::: ex B4 · cache 测量不对

你测 cache 延迟，结果忽高忽低。列出至少三种原因。

::: sol B4 核对

① 没预热/缓存冷；② 频率/ turbo/节能变化；③ ASLR/页对齐/跨页；④ 中断/其他进程干扰；⑤ 指针追逐依赖链/MLP；⑥ 测量开销/时钟精度。先预热、绑核、控制频率、多次取分布。

:::
:::

::: ex B5 · `_start` 与 `main`

`_start` 和 `main` 差在哪？谁调用 `main`？`argc/argv` 从哪来？

::: sol B5 核对

`_start` 是 ELF 入口（内核跳到这里），不是 `main`；它从栈上取 `argc/argv/envp/auxv`，调 libc 启动代码（`__libc_start_main`），后者再调 `main`。`main` 返回后走 `exit`/`_exit`。`gdb` 在 `_start` 断点看栈/auxv。

:::
:::

::: ex B6 · 跨架构构建

在 x86-64 上编译 ARM64 程序，为什么不能直接运行？需要什么？

::: sol B6 核对

指令集/ABI/ELF machine 不同；需要交叉编译器（`aarch64-linux-gnu-gcc`）生成 ARM64 ELF，运行时需要 ARM64 机器/qemu 用户态模拟/容器 `--platform`。`file`/`readelf -h` 看架构；模拟下性能/系统调用可能有差异。

:::
:::

## C 组 · 动手实验

::: ex C1 · 四阶段与 ELF

对 `hello.c` 跑 `gcc -E/-S/-c`，用 `readelf -h/-S/-l` 看 ELF 布局与入口。

::: sol C1 核对

```bash
gcc -E hello.c -o hello.i
gcc -S hello.c -o hello.s
gcc -c hello.c -o hello.o
gcc hello.o -o hello
readelf -h hello
readelf -S hello | head -30
readelf -l hello | head -30
```

对比 `.i/.s/.o/ELF` 大小；`readelf -h` 看 `Entry point`/`Machine`；`-S` 看 `.text/.data/.bss`；`-l` 看 LOAD/INTERP。验收：能说出入口与 interpreter 路径。

:::
:::

::: ex C2 · strace/objdump

用 `strace -f -e trace=execve,openat,write ./hello` 看系统调用；用 `objdump -d` 看 `main` 反汇编。

::: sol C2 核对

```bash
strace -f -e trace=execve,openat,write ./hello
objdump -d ./hello | sed -n '/<main>:/,+20p'
```

`strace` 看 `execve`、加载器 `openat`、`write(1,"hello\n",6)`；`objdump` 看 `main` 的调用/栈帧。验收：能把源码行与汇编/系统调用对上。

:::
:::

::: ex C3 · perf 与 Amdahl

用 `perf stat ./hello` 看 cycles/instructions/IPC；假设某函数占 30%、加速 3 倍，算 Amdahl 收益。

::: sol C3 核对

```bash
perf stat -e cycles,instructions,cache-misses ./hello
```

`perf stat` 给 cycles/instructions/IPC/cache-misses；Amdahl：p=0.3,s=3 → 1/(0.7+0.1)=1.25（25%）；上限 1/(0.7)=1.43。验收：能解释 IPC 与优化上限。

:::
:::

::: ex C4 · `_start`/auxv

用 `gdb` 在 `_start` 断点，`info registers`/`x/20gx $rsp`/`info auxv` 看 argc/argv/envp/auxv。

::: sol C4 核对

```bash
gdb ./hello
(gdb) break _start
(gdb) run
(gdb) info registers rsp
(gdb) x/20gx $rsp
(gdb) info auxv
```

栈顶是 argc，其后 argv 指针数组、NULL、envp、NULL、auxv；`info auxv` 列 AT_PHDR/AT_ENTRY/AT_BASE/AT_RANDOM。验收：能指出入口与 auxv 的关系。

:::
:::

::: ex C5 · 跨架构 hello

用 `file`/`readelf -h` 对比 x86-64 与 ARM64 的 hello（可用交叉编译器/qemu），列出入口/机器/ABI 差异。

::: sol C5 核对

```bash
aarch64-linux-gnu-gcc hello.c -o hello-arm64
file hello hello-arm64
readelf -h hello | grep -E 'Machine|Entry|Class|Data'
readelf -h hello-arm64 | grep -E 'Machine|Entry|Class|Data'
qemu-aarch64 ./hello-arm64   # 需要 qemu/库
```

差异：`Machine`（x86-64 vs AArch64）、入口地址、指令集/ABI；系统调用寄存器不同（`syscall` vs `svc`）。验收：能说出为什么不能直接运行。

:::
:::
