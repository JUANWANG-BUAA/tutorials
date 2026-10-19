# A.5 参考文献与延伸阅读

## 1. 十本母本

本书按知识依赖重新组织，不按原书顺序讲。下表给出母本信息与「怎么用」，方便你回查原文。

| 代号 | 书名 | 作者/译者 | 版本 | 出版方 | 本书用法 |
|:--|:--|:--|:--|:--|:--|
| K | Linux/UNIX 系统编程手册（上、下册） | Michael Kerrisk 著；郭光伟等译 | 第 1 版（覆盖 Linux 3.2） | 人民邮电出版社 | 第 2 篇的 API 语义与边界；第 1/3 篇的接口对照 |
| C | 深入理解计算机系统 | Randal E. Bryant, David R. O'Hallaron 著；龚奕利、贺莲译 | 原书第 3 版 | 机械工业出版社 | 第 1 篇的表示/汇编/链接/内存/并发底座 |
| O | 操作系统导论 | Remzi H. Arpaci-Dusseau, Andrea C. Arpaci-Dusseau 著；王海鹏译 | 第 1 版 | 人民邮电出版社 | 第 1.13 与第 3 篇的理论骨架（虚拟化/并发/持久化） |
| L | 操作系统原理、实现与实践 | 李治军、刘宏伟 | 第 1 版 | 高等教育出版社 | 第 3 篇的「从零实现」侧写；8 个实践项目 |
| R | 奔跑吧 Linux 内核——基于 Linux 4.x 内核源代码问题分析 | 张天飞 | 第 1 版 | 人民邮电出版社 | 第 3 篇的源码路径；内存/进程/并发/中断/调试 |
| N | 深入理解 Linux 网络：修炼底层内功，掌握高性能原理 | 张彦飞 | 第 1 版 | 电子工业出版社 | 第 4 篇 4.8–4.12；socket/epoll/收发包/调优 |
| G | 鸟哥的 Linux 私房菜·基础学习篇 | 鸟哥 | 第 4 版（CentOS 7 时代） | 人民邮电出版社 | 第 0 篇的使用与运维；文件/权限/磁盘/服务/启动 |
| S | Linux 命令行大全 | William E. Shotts, Jr. 著；门佳、李伟译 | 第 2 版 | 人民邮电出版社 | 第 0 篇的命令行基本功与 Shell 语法 |
| B | Linux 命令行与 shell 脚本编程大全 | Richard Blum, Christine Bresnahan 著；门佳、武海峰译 | 第 4 版 | 人民邮电出版社 | 第 0 篇的 Shell 工程、sed/awk、实用脚本 |
| W | 计算机网络 | 谢希仁 | 第 8 版 | 电子工业出版社 | 第 1.11 与第 4 篇 4.1–4.7 的协议分层 |

> 版本与页码会随印次变化；本书只在「母本对应」里写章节号，不写页码。若你手里的版本章节划分不同，以主题为准。

## 2. 规范与官方文档（优先级高于教材）

遇到教材与规范冲突，以规范为准。

### 2.1 POSIX / Linux

| 文档 | 用途 | 入口 |
|:--|:--|:--|
| POSIX.1-2017 / SUSv4 | 系统调用与 Shell 的规范语义 | `man 7 posixoptions`；The Open Group 官网 |
| Linux man-pages | 每个系统调用/库函数/文件格式 | `man 2 open`、`man 7 epoll`、`man 5 proc` |
| Linux 内核文档 | 子系统设计、ABI、调试 | `Documentation/` 目录；docs.kernel.org |
| LFS / FHS | 目录布局 | `man 7 hier`；FHS 3.0 |
| RFC | 协议报文与状态机 | RFC 791/793/1122/4291/8446/9110/9113/9114 |
| OCI spec | 容器运行时与镜像 | opencontainers.org |

### 2.2 硬件与工具

| 文档 | 用途 |
|:--|:--|
| Intel SDM / AMD APM | x86-64 指令、页表、异常、MSR |
| ARM Architecture Reference Manual | AArch64 异常级、页表、系统寄存器 |
| ACPI / UEFI spec | 启动、设备枚举 |
| `perf` wiki / `bpftrace` 文档 | 性能与追踪 |
| `systemd` man pages | unit、target、journal、cgroup 集成 |

## 3. 延伸阅读（按篇）

### 第 0 篇 · 命令行与 Shell

- *The Linux Command Line*（Shotts）——免费英文版，适合对照命令细节。
- *Classic Shell Scripting*（Robbins & Beebe）——可移植 Shell 的严谨写法。
- `shellcheck` 的 wiki——每条警告都有反例与修复。
- Google Shell Style Guide——工程约定，不是规范。

### 第 1 篇 · 计算机系统

- *Computer Systems: A Programmer's Perspective*（CSAPP）配套 labs：Data Lab、Bomb Lab、Attack Lab、Cache Lab、Shell Lab、Malloc Lab、Proxy Lab。本书第 6 篇的 B2/D1 与这些 lab 同源但更大。
- *Computer Organization and Design*（Patterson & Hennessy）——流水线与存储层次。
- Agner Fog 的优化手册——x86 指令延迟/吞吐的实测表。
- `perf` 的 examples 与 Brendan Gregg 的火焰图。

### 第 2 篇 · 系统编程

- *Advanced Programming in the UNIX Environment*（APUE, 3e）——与 Kerrisk 互补，偏 POSIX 全貌。
- *The Linux Programming Interface*（Kerrisk）——本书第 2 篇的母本；建议通读第 1–5、20–33、44、52–64 章。
- *UNIX Network Programming, Vol. 1*（Stevens）——socket 编程的经典。
- `man 7 signal`、`man 7 pthreads`、`man 7 socket`——比教材更准。

### 第 3 篇 · Linux 内核

- *Linux Kernel Development*（Love）——概念清晰，但版本较旧。
- *Understanding the Linux Kernel*（Bovet & Cesati）——结构细节，版本更旧。
- *Linux Kernel Programming*（Kaiwan Billimoria）——模块与调试实践。
- 内核源码 + `Documentation/` + `git log`——最终依据。
- `kernelnewbies.org`——版本变更摘要。

### 第 4 篇 · 网络

- *TCP/IP Illustrated, Vol. 1*（Stevens）——协议细节。
- *Computer Networking: A Top-Down Approach*（Kurose & Ross）——自顶向下。
- *High Performance Browser Networking*（Grigorik）——HTTP/2、TLS、移动网络。
- RFC 5681（拥塞控制）、RFC 6298（RTO）、RFC 7323（窗口缩放/时间戳）、RFC 8446（TLS 1.3）。

### 第 5 篇 · 云原生

- *Container Security*（Liz Rice）——隔离与攻击面。
- *Kubernetes Patterns*——控制器与声明式设计。
- OCI runtime/image spec、runc/containerd 源码。
- `Documentation/admin-guide/cgroup-v2.rst`、`Documentation/filesystems/overlayfs.rst`。

### Rust / RISC-V / rCore

- **rCore-Tutorial-Book-v3**（清华 rCore 社区，GPLv3）：<https://github.com/rcore-os/rCore-Tutorial-Book-v3>。本书只参考其「应用需求驱动、逐步建 OS」的组织方式与 RISC-V 特权级/trap 概念；**不摘录正文、不复制代码**，示例为独立编写。
- **rCore-Tutorial-v3**（GPLv3）：<https://github.com/rcore-os/rCore-Tutorial-v3>。读完整实现时按章对照，注意 GPLv3 的传染性；不要把其代码直接并入非 GPL 项目。
- *The Rust Programming Language*（官方书）、*Rust for Rustaceans*、*Programming Rust*。
- RISC-V 非特权/特权规范、SiFive FU740 手册、QEMU `virt` 机器文档。

### 项目

- nginx / Redis / SQLite / lwIP / Git 的源码——读一个模块，不要从头读到尾。
- *The Architecture of Open Source Applications*——架构取舍。
- *Designing Data-Intensive Applications*（Kleppmann）——存储/分布式系统的取舍。

## 4. 怎么读源码

1. **先读文档与测试**：`README`、`Documentation/`、`tests/` 比源码更快建立地图。
2. **找一个入口**：`main()`、`init()`、系统调用表、协议入口；不要从第一个文件开始。
3. **画调用链**：每读一个函数，只记「谁调用它、它调用谁、改了什么状态」。
4. **用工具验证**：`gdb`、`ftrace`、`bpftrace`、`perf`；静态阅读容易漏掉运行时分支。
5. **读提交历史**：`git log -p -- path` 看一个功能怎么演化，比读最终代码更能理解设计。

## 5. 引用与版权

本书正文、示例、图与项目代码为重新撰写；母本仅用于事实核对与结构参考。引用规范或 RFC 时标注编号；引用母本观点时在「母本对应」表中标注章节，不摘录大段原文。

若你是某本母本的作者或译者，认为某处归属标注不清，请通过仓库 issue 指出。

> **下一站**：[A.6 勘误与版本记录](errata.md)列出本书已知的版本差异与修正。
