# A.6 勘误与版本记录

## 1. 版本基线

本书正文默认以下环境；与你的机器不同时，先看差异，不要直接照搬数字。

| 项 | 本书基线 | 说明 |
|:--|:--|:--|
| 发行版 | Ubuntu 24.04 LTS | Debian 12 / Fedora 40 差异在文中标注 |
| 内核 | Linux 6.8 | 内核篇以 6.x 为主；4.x/5.x 差异标注 |
| libc | glibc 2.39 | musl 在容器/嵌入式处标注 |
| 编译器 | GCC 13.2 / Clang 18 | C17 + POSIX.1-2008 |
| 架构 | x86-64 | ARM64 在 1.3/1.4、3.7/3.8、4.8 对照 |
| systemd | 255 | unit 字段随版本增加，旧系统可能不认 |
| 容器 | Docker 26 / containerd 1.7 / runc 1.1 | cgroups v2 |

## 2. 母本的时效差异

### 2.1 Kerrisk《Linux/UNIX 系统编程手册》

母本覆盖 Linux 3.2 左右。以下接口/行为在 6.x 有变化或新增：

| 主题 | 母本 | 今天 |
|:--|:--|:--|
| `epoll` 惊群 | 未涉及 `EPOLLEXCLUSIVE` | 4.5+ 支持 `EPOLLEXCLUSIVE`；多线程 `accept` 还可配 `SO_REUSEPORT` |
| 创建进程 | `clone()` | 5.3+ 有 `clone3()`；`fork()` 仍可用 |
| 进程监控 | `waitpid` | 5.1+ 有 `pidfd_open`/`pidfd_send_signal`/`waitid(P_PIDFD)` |
| 异步 I/O | POSIX AIO / `io_submit` | 5.1+ `io_uring`；本书 2.18 讲 |
| 路径解析 | `openat` | 5.6+ `openat2()` 支持 `RESOLVE_BENEATH` 等约束 |
| 关闭 fd | `close` | 5.9+ `close_range()` |
| 内存映射锁 | `mmap_sem` | 5.8+ 改为 `mmap_lock`（读写锁语义调整） |
| `getdents` | `getdents64` | 仍以 `getdents64` 为主；`readdir` 仍是 libc 封装 |
| `sysctl` | `/proc/sys` | 仍是主接口；`/sys` 与 netlink 补充 |
| 时间 | `gettimeofday` | 新代码用 `clock_gettime(CLOCK_MONOTONIC)`；`gettimeofday` 不推荐 |
| 信号 | `signal()` | 新代码一律 `sigaction()` |

### 2.2 CSAPP 3e

- 以 x86-64 为主，未覆盖 ARM64、RISC-V；本书在 1.3/1.4 补 ARM64 对照。
- Y86-64 是教学 ISA，不对应真实处理器；不要把它当“简化版 x86”去写生产代码。
- 未覆盖现代缓解机制：CET/Shadow Stack、`-fstack-protector`、ASLR 细节、`seccomp`；本书在 1.8/2.9/5.5 补充。
- `malloc` 实现以教科书隐式/显式链表为主；glibc 的 `ptmalloc` 有 per-thread arena、tcache，行为不同。本书 1.9 讲原理，2.3 讲 `mmap`/`brk` 边界。
- 浮点部分以 IEEE 754 为主；现代编译器默认 `-mfma`/AVX 的融合乘加会改变舍入，书中例子用 `-O2` 未开 fast-math。

### 2.3 OSTEP

- 调度部分以 CFS/MLFQ 为主；Linux 6.6+ 默认 EEVDF，`/proc/sched_debug` 字段与调参项有变化。本书 3.5 讲 CFS 思想 + EEVDF。
- 持久化部分以磁盘/RAID/日志为主；NVMe、`io_uring`、持久内存（PMEM）未展开。本书 3.13/4.9 补。
- 分布式部分（NFS/AFS）只作背景；本书不展开 RPC/一致性协议。

### 2.4 李治军《操作系统原理、实现与实践》

- 实验基于 32 位 x86 与较早内核；本书只取“实现视角”，不要求复刻其代码。
- `int 0x80` 与现代 `syscall` 的入口不同；本书 2.1/3.3 讲差异。
- 进程创建路径中的 `do_fork()` 在 5.x 后改为 `kernel_clone()`；本书标注。
- 内存管理中的 `mmap_sem` 在 5.8+ 改为 `mmap_lock`。

### 2.5 奔跑吧 Linux 内核

- 以 Linux 4.x 为主；6.x 的 CFS→EEVDF、`struct page` 布局、`mmap_lock`、`do_fork` 改名、`ksoftirqd` 调度策略都有变化。
- `per-CPU` 页框缓存、伙伴系统水位、`slab` 的 `slub` 默认实现细节随版本变化；本书给路径与观测方法，不背常量。
- 书中的 ARM 平台细节（Cortex-A9/A15）只作体系结构对照；实验以 QEMU x86-64 为主。

### 2.6 深入理解 Linux 网络

- `tcp_tw_recycle` 在 4.12 已移除；不要再用。`tcp_tw_reuse` 仍可用但有条件。
- `RPS/RFS`、`GRO/GSO`、`XDP` 的默认值与驱动相关；本书给查看命令。
- `epoll` 的 `EPOLLEXCLUSIVE`、`io_uring` 在母本中未展开；本书 2.18/4.10 补。
- `sk_buff` 的字段与 `tcp_sendmsg_locked` 等函数名随版本变化；读源码时以 6.8 为准。

### 2.7 鸟哥的 Linux 私房菜 4e

- 以 CentOS 7 为背景：`firewalld`、`systemctl`、`xfs` 默认、`NetworkManager`。
- Ubuntu 24.04 的差异：`netplan`、`ufw`、`apt`、`apparmor`、`systemd-resolved`；本书在 0.10–0.13 标注。
- 书中仍有 `ifconfig`/`netstat` 示例；本书主线用 `ip`/`ss`，旧命令在 A.1 对照。
- `X Window` 章（第 23 章）不属于本书范围，只作历史。

### 2.8 Shotts / shell-book

- 两书都以 bash 4.x 为背景；bash 5.0+ 陆续新增 `EPOCHSECONDS`（5.0）、`SRANDOM`（5.1）、`wait -n` 等；本书用 5.2。
- `local` 不是 POSIX；`#!/bin/sh` 在 Debian/Ubuntu 是 dash，行为与 bash 不同。本书脚本默认 `#!/usr/bin/env bash`，可移植写法单独标注。
- `echo -e` 不可移植；新代码用 `printf`。
- `set -e` 的语境例外（`if`、`&&`、`||`、`!`）必须记住；本书 0.7/0.8 讲。
- shell-book 第 18 章（图形化桌面脚本）已淘汰，本书不展开。

### 2.9 计算机网络 8e

- 以传统 TCP/IP 为主；QUIC、HTTP/3、TLS 1.3 只作延伸，本书 4.7 补。
- 第 8 章（音频/视频）、第 9 章（无线）只作背景；本书不展开编解码与 802.11 细节。
- 网络安全章（第 7 章）与本书 4.12/5.6 有交叉；本书只讲与 Linux 配置相关的部分。

## 3. 常见误读更正

| 说法 | 更正 |
|:--|:--|
| “`write()` 返回就落盘了” | 只到 page cache；`fsync`/`O_SYNC` 才保证持久化 |
| “`fork()` 复制整个内存” | COW；只复制页表，写时才复制页 |
| “`O_APPEND` 保证多进程日志不交错” | 只保证单次 `write` 原子追加；多条写/stdio 缓冲仍会交错 |
| “`close()` 失败可以重试” | 不要重试；fd 可能已被复用 |
| “`epoll` ET 只要 `EPOLLIN` 就读一次” | 必须循环读到 `EAGAIN`，且 fd 非阻塞 |
| “`listen` 的 backlog 限制 SYN 队列” | backlog 主要限制 accept 队列；SYN 队列由 `tcp_max_syn_backlog` 控制 |
| “`TIME_WAIT` 是 bug” | 是主动关闭方的正常状态；`CLOSE_WAIT` 多才是应用没 close |
| “`load average` 只看 CPU” | 包含不可中断睡眠（D 状态），I/O 卡住也会高 |
| “`%util` 100% 就是磁盘饱和” | NVMe 多队列下不一定；看 `aqu-sz`、`await`、延迟分布 |
| “容器是轻量虚拟机” | 共享内核，隔离靠 namespace/cgroups；不是虚拟化 |
| “`setuid` 是提权的最安全方式” | 现代优先 capability/seccomp/namespace；setuid 面太大 |
| “`malloc` 返回的指针就是物理内存” | 是虚拟地址；首次写才分配物理页 |
| “`volatile` 能解决多线程竞争” | 只阻止编译器优化，不提供原子性/内存序；用 `atomic`/锁 |
| “`SA_RESTART` 能让所有系统调用自动重启” | `poll`/`epoll_wait`/`select` 等不会；库仍要处理 `EINTR` |

## 4. 本书更正记录

| 日期 | 位置 | 原文 | 更正 | 原因 |
|:--|:--|:--|:--|:--|
| 2026-10 | 全书 | — | 初版 | 建立基线 |

> 发现错误请按页脚「编辑此页」提 PR；若涉及版本差异，请附 `uname -r`、`ldd --version` 与复现命令。
