# Summary

[封面与导览](index.md)

# 卷首

- [为什么写这本书](preface.md)
- [范围、取舍与淘汰内容](scope.md)
- [能力矩阵与学习目标](objectives.md)
- [三条学习路线](roadmap.md)
- [符号、命令与代码约定](notation.md)
- [实验环境](env.md)
- [入学诊断](entry-test.md)

# 第 0 篇 · 命令行与 Shell 工程

- [0.1 Linux 世界观：内核、GNU、发行版与标准](part0/ch01.md)
- [0.2 终端、Shell 与命令行工作流](part0/ch02.md)
- [0.3 文件系统导航与文件操作](part0/ch03.md)
- [0.4 权限与安全模型](part0/ch04.md)
- [0.5 重定向、管道与文本流](part0/ch05.md)
- [0.6 正则表达式与 grep/sed/awk](part0/ch06.md)
- [0.7 Bash 编程基础](part0/ch07.md)
- [0.8 Bash 编程进阶与工程化](part0/ch08.md)
- [0.9 进程、作业控制与信号](part0/ch09.md)
- [0.10 磁盘、文件系统、挂载与 LVM/RAID](part0/ch10.md)
- [0.11 软件包、编译、库与镜像](part0/ch11.md)
- [0.12 systemd、启动、日志与定时任务](part0/ch12.md)
- [0.13 网络配置与排障](part0/ch13.md)
- [0.14 性能工具与命令行工程化](part0/ch14.md)

# 第 1 篇 · 计算机系统

- [1.1 计算机系统漫游：从源文件到进程](part1/ch01.md)
- [1.2 信息的表示与运算](part1/ch02.md)
- [1.3 机器级程序：x86-64 汇编](part1/ch03.md)
- [1.4 处理器体系结构：从 Y86-64 到乱序执行](part1/ch04.md)
- [1.5 程序性能优化](part1/ch05.md)
- [1.6 存储层次与缓存](part1/ch06.md)
- [1.7 链接、加载与库](part1/ch07.md)
- [1.8 异常控制流：进程与信号](part1/ch08.md)
- [1.9 虚拟内存](part1/ch09.md)
- [1.10 系统级 I/O](part1/ch10.md)
- [1.11 网络编程与协议基础](part1/ch11.md)
- [1.12 并发编程](part1/ch12.md)
- [1.13 操作系统导论：虚拟化、并发与持久化](part1/ch13.md)
- [1.14 计算机组成与三套 ISA：x86-64 / ARM64 / RISC-V 64](part1/ch14.md)
- [1.15 汇编与调用约定：三架构并排](part1/ch15.md)
- [1.16 编译、链接与优化：C 与 Rust 的工具链](part1/ch16.md)
- [1.17 Rust 系统编程：所有权、错误、FFI 与 C 对照](part1/ch17.md)
- [1.18 RISC-V 裸机：SBI、三特权级与 trap](part1/ch18.md)
- [1.19 从 rCore 看内核：任务、地址空间与文件系统](part1/ch19.md)

# 第 2 篇 · Unix/Linux 系统编程

- [2.1 系统编程基础：系统调用、错误与可移植性](part2/ch01.md)
- [2.2 文件 I/O](part2/ch02.md)
- [2.3 高级文件 I/O：原子性、fcntl、mmap 与文件锁](part2/ch03.md)
- [2.4 缓冲与 stdio](part2/ch04.md)
- [2.5 文件属性、扩展属性与 ACL](part2/ch05.md)
- [2.6 目录、链接与文件事件](part2/ch06.md)
- [2.7 进程创建与终止](part2/ch07.md)
- [2.8 程序执行与子进程监控](part2/ch08.md)
- [2.9 进程凭证、用户、组与能力](part2/ch09.md)
- [2.10 信号](part2/ch10.md)
- [2.11 定时器与休眠](part2/ch11.md)
- [2.12 线程](part2/ch12.md)
- [2.13 线程同步与线程安全](part2/ch13.md)
- [2.14 管道、FIFO 与消息队列](part2/ch14.md)
- [2.15 共享内存与信号量](part2/ch15.md)
- [2.16 套接字基础](part2/ch16.md)
- [2.17 套接字高级与网络编程](part2/ch17.md)
- [2.18 备选 I/O：select/poll/epoll/io_uring](part2/ch18.md)
- [2.19 终端、pty、作业控制与守护进程](part2/ch19.md)

# 第 3 篇 · Linux 内核

- [3.1 内核架构、源码、构建与调试环境](part3/ch01.md)
- [3.2 启动与初始化](part3/ch02.md)
- [3.3 中断、异常与系统调用](part3/ch03.md)
- [3.4 进程描述与创建](part3/ch04.md)
- [3.5 调度器：CFS、EEVDF 与实时调度](part3/ch05.md)
- [3.6 多核、NUMA 与负载均衡](part3/ch06.md)
- [3.7 物理内存管理](part3/ch07.md)
- [3.8 虚拟内存与页表](part3/ch08.md)
- [3.9 slab、vmalloc 与内核内存分配](part3/ch09.md)
- [3.10 页回收、RMAP、KSM 与页面迁移](part3/ch10.md)
- [3.11 并发与同步](part3/ch11.md)
- [3.12 VFS 与文件系统](part3/ch12.md)
- [3.13 块层、I/O 调度与持久化](part3/ch13.md)
- [3.14 设备驱动](part3/ch14.md)
- [3.15 内核调试、观测与性能分析](part3/ch15.md)

# 第 4 篇 · 网络

- [4.1 网络分层与报文之旅](part4/ch01.md)
- [4.2 物理层与数据链路层](part4/ch02.md)
- [4.3 网络层：IP、路由与分片](part4/ch03.md)
- [4.4 运输层：UDP 与 TCP](part4/ch04.md)
- [4.5 TCP 连接建立与关闭](part4/ch05.md)
- [4.6 TCP 可靠传输与拥塞控制](part4/ch06.md)
- [4.7 应用层：HTTP、DNS 与 TLS](part4/ch07.md)
- [4.8 内核收包路径](part4/ch08.md)
- [4.9 内核发包路径](part4/ch09.md)
- [4.10 socket 与 epoll 的内核协作](part4/ch10.md)
- [4.11 本机网络、连接队列与百万连接](part4/ch11.md)
- [4.12 网络性能优化与容器网络](part4/ch12.md)

# 第 5 篇 · 云原生

- [5.1 容器原理：隔离、限制与镜像](part5/ch01.md)
- [5.2 namespace 深入](part5/ch02.md)
- [5.3 cgroups v2](part5/ch03.md)
- [5.4 overlayfs 与镜像分层](part5/ch04.md)
- [5.5 OCI 运行时与容器生命周期](part5/ch05.md)
- [5.6 容器网络与 Kubernetes 原语](part5/ch06.md)

# 第 6 篇 · 项目复现

- [项目总览与工程规范](projects/overview.md)
- [工程手册：构建、测试、压测与交付](projects/engineering.md)
- [项目 A · 云原生主线：容器运行时 · HTTP 服务器 · eBPF 观测](projects/pa.md)
- [项目 B · 存储主线：Redis 复现 · B+ 树/WAL 引擎](projects/pb.md)
- [项目 C · 网络主线：用户态 TCP/IP · 反向代理 · 抓包分析](projects/pc.md)
- [项目 D · 工具链主线：POSIX Shell · BusyBox · Git 对象库](projects/pd.md)

# 复习层

- [R.1 命令行速查](review/cheatsheet-cli.md)
- [R.2 系统编程速查](review/cheatsheet-sysprog.md)
- [R.3 内核速查](review/cheatsheet-kernel.md)
- [R.4 网络速查](review/cheatsheet-net.md)
- [R.5 易混对照](review/compare.md)
- [R.6 术语表](review/glossary.md)
- [R.7 闭卷回忆卡](review/recall.md)
- [R.8 综合自测卷](review/mock-exam.md)
- [R.9 面试竞技场](review/interview.md)

# 附录

- [A.1 历史与兼容：被淘汰的内容怎么读](appendix/legacy.md)
- [A.2 工具箱：命令、调试器与观测工具](appendix/toolbox.md)
- [A.3 排错手册：症状 → 假设 → 证据](appendix/debugging.md)
- [A.4 母本覆盖矩阵](appendix/coverage.md)
- [A.5 参考文献与延伸阅读](appendix/references.md)
- [A.6 勘误与版本记录](appendix/errata.md)
