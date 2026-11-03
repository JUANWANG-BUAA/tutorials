# 0.1 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 分层与身份

### D1 · 内核

不看书写出：内核运行在什么特权级？它至少管理哪五类资源？用户态进入内核的唯一合法入口是什么？

::: sol D1 核对

内核常驻内存，运行在 CPU 最高特权级（x86-64 的 ring 0）。它管理进程与调度、虚拟内存、文件系统、网络协议栈、设备与中断。用户态只能通过**系统调用**进入内核；不能直接访问页表、中断控制器或磁盘控制器。易漏：把「内核模块」当成用户态插件——模块仍跑在 ring 0。
:::

### D2 · 发行版

发行版由哪五样东西组成？判断两个系统是不是同一个发行版，主要看哪几件事？

::: sol D2 核对

发行版 = 内核 + C 库 + 用户态工具 + 包管理器 + 初始化系统与默认配置，并且有集成测试、签名和安全更新渠道。判断时看：内核策略、C 库、包格式、init、默认策略与支持周期。**差异主要不在内核，而在 libc、包管理、默认配置与支持周期。** 易错：把发行版当成「换个桌面主题」。
:::

### D3 · 三个版本号

`uname -r`、`ldd --version`、`/etc/os-release` 各回答什么问题？为什么它们可以互相不一致？

::: sol D3 核对

`uname -r` 是内核 release；`ldd --version` 是 C 库版本；`/etc/os-release` 是用户态发行版版本。三者独立维护：内核可以单独升级/降级，libc 随发行版大版本变化，发行版号描述的是用户态组合。`6.8.0-45-generic` 里 `6.8.0` 是上游基线，`-45` 是发行版 ABI 编号，不是上游第 45 个版本。
:::

### D4 · 标准

POSIX、FHS、LSB 各保证什么、不保证什么？各举一个「不在保证范围内」的例子。

::: sol D4 核对

POSIX 保证系统调用、C 库接口、Shell 语法与工具行为的源码级可移植；不保证性能、错误文本、扩展接口与默认配置（`epoll`、`grep -P`、systemd 都不在 POSIX 里）。FHS 约定目录层级与用途（`/etc`、`/var`、`/usr`），不规定具体文件和包管理器布局。LSB 是旧式发行版二进制接口与初始化脚本，systemd 普及后基本废弃。易错：把 POSIX 认证当成「行为完全一致」。
:::

### D5 · 容器与内核

为什么容器里不能「升级内核」？容器里的 `uname -r` 显示的是谁的内核？

::: sol D5 核对

容器与宿主机共享同一个内核；namespace 和 cgroup 只改变进程看到的视图与资源限制，不替换内核。容器里的 `uname -r` 显示宿主机内核，`/etc/os-release` 才显示镜像里的用户态。需要不同内核时用虚拟机，不是容器。
:::

## B. 一条命令与系统调用

### D6 · 四层路径

把 `ls /etc` 拆成至少四个关键步骤，并说出每步是谁做的。

::: sol D6 核对

① Shell `fork` 出子进程，再 `execve("/usr/bin/ls", ...)`；② 动态加载器打开 `/etc/ld.so.cache` 和 `libc.so.6`；③ `ls` 打开 `/etc`（`openat`，带 `O_DIRECTORY`），用 `getdents64` 读目录项；④ libc 格式化结果，用 `write(1, ...)` 写到标准输出。`ls` 不直接读磁盘；目录内容由内核页缓存提供。
:::

### D7 · 系统调用 ABI

x86-64 上系统调用号、参数、返回值分别放在哪些寄存器？内核怎样表示错误？glibc 又做了什么？

::: sol D7 核对

x86-64：调用号在 `rax`，参数在 `rdi`、`rsi`、`rdx`、`r10`、`r8`、`r9`，返回值在 `rax`，陷入指令是 `syscall`。内核用 `rax ∈ [-4095, -1]` 表示错误，其绝对值是 `errno`。glibc 把负返回值翻译成 `-1` 并设置线程局部的 `errno`。裸汇编没有 `errno`，只有返回寄存器里的负值。
:::

### D8 · vDSO 与 `strace`

为什么 `strace` 有时看不到 `clock_gettime`？这能说明程序没有调用它吗？

::: sol D8 核对

不能。`clock_gettime`、`gettimeofday`、`time`、`getcpu` 在支持时由内核映射一段用户态代码（`linux-vdso.so.1`），直接执行，不陷入内核，所以 `strace` 看不到。`ldd` 输出里出现 `linux-vdso.so.1` 就是线索。
:::

## C. 模块、启动与目录

### D9 · 内建与模块

怎样判断一个功能是编进内核（built-in）还是可加载模块？为什么 `lsmod` 里看不到 `ext4` 却能用 ext4 根文件系统？

::: sol D9 核对

查 `/lib/modules/$(uname -r)/modules.builtin` 是否有该名字；或 `modinfo -F filename <m>` 看是否输出 `(builtin)`；`/proc/filesystems` 也能证明内核支持。内建模块编在 `vmlinuz` 里，不出现在 `lsmod`，也不能卸载。`lsmod` 只列已加载的可加载模块。
:::

### D10 · 启动五段

从按下电源到登录提示符，控制权经过哪五段？每段给一条证据命令。

::: sol D10 核对

① 固件 UEFI/BIOS：`efibootmgr -v`、`ls /sys/firmware/efi`；② 引导器 GRUB/systemd-boot：`grep menuentry /boot/grub/grub.cfg`；③ 内核：`cat /proc/cmdline`、`dmesg`；④ initramfs：`lsinitramfs /boot/initrd.img-$(uname -r)`；⑤ init/systemd：`systemctl get-default`、`systemd-analyze`。排障时先找「最后一段有证据的地方」，问题在它和下一段之间。
:::

### D11 · FHS 与可变性

`/etc`、`/var`、`/run`、`/usr` 各放什么？用「可变性」解释为什么这样分。

::: sol D11 核对

`/etc` 放主机配置，要能改；`/var` 放可变状态（日志、缓存、队列、数据库），要持久化和备份；`/run` 放本次启动的运行时状态（tmpfs），重启即清；`/usr` 放只读的程序、库和共享数据，随包升级、可整体做镜像。判断新目录时问三件事：可变吗？要备份吗？重启要清吗？
:::

### D12 · 跨层误判

任选三个本章的跨层误判，说出「看起来像」与「实际是」，并各给一条验证命令。

::: sol D12 核对

示例：① 改了 `/usr/lib` 下的 unit 没生效——实际是 `/etc` 下有同名文件或 drop-in 覆盖，用 `systemctl cat <unit>` 查；② `ldd` 只是「看依赖」——它会用 loader 执行目标，来源不明的二进制改用 `readelf -d` 或 `objdump -p`；③ `strace` 没看到 `clock_gettime` 就是没调用——vDSO 在用户态完成，`ldd` 里有 `linux-vdso.so.1` 即可证明。其他可任选：`lsmod` 看不到内建模块、`syscall()` 与 `write()` 只差前缀、页大小不是常量。
:::
