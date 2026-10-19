# R.6 术语表

> 收「读代码/排障会遇到」的术语；一句话定义 + 出处。按主题分组，组内按中文排序。

## A. 命令行与 Shell

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| POSIX | Portable Operating System Interface | IEEE 定义的系统接口标准，规定 API/Shell/工具的最小行为 | 0.1 |
| FHS | Filesystem Hierarchy Standard | Linux 目录布局约定，如 `/etc` 配置、`/var` 可变数据 | 0.3 |
| inode | index node | 文件元数据对象，保存类型、权限、大小、数据块位置；文件名在目录项里 | 0.3 |
| 目录项 | dentry | 路径中一个名字到 inode 的映射，是 dcache 的节点 | 0.3 |
| 硬链接 | hard link | 同一 inode 的另一个目录项；`nlink` 计数，删到 0 才释放数据 | 0.3 |
| 软链接 | symbolic link | 内容是目标路径的独立 inode；可跨文件系统、可悬空 | 0.3 |
| umask | user file-creation mask | 创建文件时被清掉的权限位；最终权限 = mode & ~umask | 0.4 |
| ACL | Access Control List | 在属主/属组/other 之外追加的按用户/组授权；mask 限制有效权限 | 0.4 |
| capability | Linux capability | 把 root 特权拆成细粒度位，如 `cap_net_bind_service` | 0.4 |
| setuid | set user ID | 执行时以文件属主身份运行；现代优先 capability/seccomp | 0.4 |
| 会话 | session | 一组进程组的集合，最多一个控制终端；`setsid` 创建 | 0.9 |
| 作业控制 | job control | Shell 对前台/后台进程组的管理，涉及 `SIGTTIN/SIGTTOU` | 0.9 |
| 伪终端 | pseudo-terminal, pty | 一对 master/slave 设备，让程序像操作终端一样与 Shell 交互 | 0.2 |
| shebang | hash-bang | 脚本首行 `#!` 指定解释器；内核据此 `execve` | 0.7 |
| glob | pathname expansion | Shell 的通配符展开，如 `*.c`；不是正则 | 0.7 |
| 正则 | regular expression | 文本模式；BRE/ERE/PCRE 语法不同 | 0.6 |
| here-doc | here document | `<<EOF` 把一段文本作为 stdin | 0.5 |
| 退出状态 | exit status | 进程返回给父进程的 0–255 整数；`$?` 读取 | 0.7 |
| SIGPIPE | broken pipe signal | 向读端已关闭的管道/套接字写时内核发送的信号，默认终止 | 0.5 |
| systemd unit | unit | systemd 管理的最小配置单元，如 service/socket/target/timer | 0.12 |
| target | target | systemd 的“状态组”，替代 SysV runlevel | 0.12 |

## B. 系统编程

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 系统调用 | system call | 用户态进入内核的唯一合法入口；x86-64 用 `syscall` 指令 | 2.1 |
| errno | error number | 线程局部的错误码；仅在返回值表明失败后有意义 | 2.1 |
| 文件描述符 | file descriptor | 进程 fd 表的下标，指向打开文件描述 | 2.2 |
| 打开文件描述 | open file description | 内核 `struct file`，保存偏移、flags、引用计数 | 2.2 |
| 短读 | short read | `read` 返回少于请求字节数；合法，必须循环处理 | 2.2 |
| 短写 | short write | `write` 只写入部分字节；必须循环写剩余 | 2.2 |
| 原子性 | atomicity | 操作不可被观察到中间态；如 `O_CREAT\|O_EXCL`、`rename` | 2.2 |
| `O_CLOEXEC` | close-on-exec | `exec` 时自动关闭 fd，防止泄漏给子进程 | 2.2 |
| `O_APPEND` | append mode | 每次写原子定位到文件末尾 | 2.2 |
| `EINTR` | interrupted system call | 阻塞调用被信号打断；通常重试 | 2.2 |
| `EAGAIN` | try again | 非阻塞 fd 当前不可用；等事件再试 | 2.2 |
| 写时复制 | copy-on-write, COW | `fork` 后父子共享物理页，写时才复制 | 2.7 |
| 僵尸进程 | zombie | 已退出但父进程未 `wait`，只剩 `task_struct` | 2.7 |
| 孤儿进程 | orphan | 父进程先退出，被 init/systemd 收养 | 2.7 |
| 守护进程 | daemon | 脱离控制终端、在后台长期运行；`setsid` + 二次 fork | 2.19 |
| 信号处理器 | signal handler | 信号递送时执行的函数；只能调用 async-signal-safe 函数 | 2.10 |
| async-signal-safe | async-signal-safe | 可在信号处理器中安全调用的函数集合（POSIX 列表） | 2.10 |
| self-pipe | self-pipe trick | 信号处理器写一个字节到管道，主循环用 `poll/epoll` 读，把信号转成 fd 事件 | 2.10 |
| `signalfd` | signal file descriptor | 把信号变成可读 fd，避免处理器 | 2.10 |
| futex | fast userspace mutex | 用户态原子操作 + 内核等待队列实现的锁原语 | 2.13 |
| 互斥锁 | mutex | 睡眠等待的互斥原语；临界区可阻塞 | 2.13 |
| 条件变量 | condition variable | 等待条件成立；必须配互斥锁并 `while` 循环 | 2.13 |
| 信号量 | semaphore | 计数同步原语；`sem_wait/sem_post` | 2.13 |
| 屏障 | barrier | 多个线程到齐后才继续 | 2.13 |
| 线程局部存储 | thread-local storage, TLS | 每线程独立副本；`__thread` 或 `pthread_key` | 2.12 |
| 惊群 | thundering herd | 多个等待者被同一事件唤醒，只有一个能处理 | 2.18 |
| 水平触发 | level-triggered, LT | 只要就绪就持续通知 | 2.18 |
| 边缘触发 | edge-triggered, ET | 状态变化时通知一次；必须读到 `EAGAIN` | 2.18 |
| `io_uring` | io_uring | Linux 5.1+ 的异步 I/O 接口，SQ/CQ 环形队列 | 2.18 |
| 零拷贝 | zero-copy | 减少用户/内核态数据拷贝，如 `sendfile/splice` | 2.3 |
| `sendfile` | sendfile | 文件到套接字的内核内传输，避免用户态缓冲 | 2.3 |
| `mmap` | memory map | 把文件/匿名页映射到地址空间 | 2.3 |
| `fsync` | file sync | 把文件数据和元数据刷到持久介质 | 2.2 |
| `fdatasync` | data sync | 只刷数据及必要元数据 | 2.2 |
| `O_DIRECT` | direct I/O | 绕过 page cache，要求地址/偏移/长度对齐 | 2.3 |
| `flock` | file lock | 整文件建议锁；随 fd 复制 | 2.3 |
| 记录锁 | record lock | `fcntl(F_SETLK)` 对字节范围加锁 | 2.3 |
| UNIX domain socket | AF_UNIX | 本机进程间双向通信；可传 fd/凭据 | 2.16 |
| 辅助数据 | ancillary data | `sendmsg/recvmsg` 携带的 `SCM_RIGHTS`/`SCM_CREDENTIALS` | 2.17 |
| COW 页 | COW page | 写时复制页；`do_wp_page` 处理 | 3.8 |

## C. 计算机系统

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 补码 | two's complement | 有符号整数表示；`-x = ~x + 1` | 1.2 |
| IEEE 754 | IEEE 754 | 浮点表示标准；符号/阶码/尾数，含 `NaN/Inf` | 1.2 |
| 字节序 | endianness | 多字节整数在内存中的顺序；x86 小端 | 1.2 |
| 缓存行 | cache line | 缓存与内存之间的传输单位，通常 64 B | 1.6 |
| 组相联 | set-associative | 缓存组内多路；地址拆为 tag/set/offset | 1.6 |
| TLB | translation lookaside buffer | 页表项缓存，加速虚拟地址翻译 | 1.9 |
| 链接 | linking | 把目标文件/库合并为可执行文件；含符号解析与重定位 | 1.7 |
| 重定位 | relocation | 把符号引用改成最终地址 | 1.7 |
| GOT | global offset table | 动态链接的全局偏移表 | 1.7 |
| PLT | procedure linkage table | 延迟绑定的过程链接表 | 1.7 |
| PIC | position-independent code | 位置无关代码；共享库常用 | 1.7 |
| 静态库 | static library | `.a`，代码复制进可执行文件 | 1.7 |
| 动态库 | shared library | `.so`，运行时由 `ld.so` 加载 | 1.7 |
| 虚拟地址 | virtual address | 进程看到的地址；由 MMU 翻译 | 1.9 |
| 物理地址 | physical address | 实际内存/设备地址 | 1.9 |
| 页表 | page table | 虚拟页到物理页的映射；多级结构 | 1.9 |
| 缺页 | page fault | 访问未映射/不在内存的页，触发内核处理 | 1.9 |
| 上下文切换 | context switch | 保存/恢复进程或线程的 CPU 状态 | 1.8 |
| IPC | inter-process communication | 进程间通信：管道、消息队列、共享内存、socket | 2.14 |
| Amdahl 定律 | Amdahl's law | 加速比受不可并行部分限制 | 1.1 |

## D. 内核

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| `task_struct` | process descriptor | 进程/线程描述符；含状态、mm、files、cred 等 | 3.4 |
| `mm_struct` | memory descriptor | 进程地址空间；含页表基址、VMA 链表 | 3.8 |
| VMA | virtual memory area | 一段连续虚拟地址区间；`vm_area_struct` | 3.8 |
| `struct page` | page descriptor | 物理页的元数据；引用计数、映射、LRU | 3.7 |
| slab | slab allocator | 内核对象缓存；slub 为默认实现 | 3.9 |
| 伙伴系统 | buddy allocator | 按 2 的幂管理物理页块，减少外部碎片 | 3.7 |
| zone | memory zone | 按 DMA 可达性划分的物理内存区域 | 3.7 |
| NUMA | non-uniform memory access | 多节点内存，访问本地/远端延迟不同 | 3.6 |
| RMAP | reverse mapping | 从物理页反查映射它的 VMA/页表项 | 3.10 |
| KSM | kernel samepage merging | 合并内容相同的匿名页，省内存 | 3.10 |
| OOM killer | out-of-memory killer | 内存耗尽时按 `oom_score` 杀进程 | 3.10 |
| CFS | completely fair scheduler | 用 `vruntime` 红黑树按权重分配 CPU | 3.5 |
| EEVDF | earliest eligible virtual deadline first | 6.6+ 的公平调度器；lag/vslice | 3.5 |
| 调度类 | scheduling class | fair/rt/deadline/idle，按优先级选择 | 3.5 |
| 软中断 | softirq | 下半部机制；网络收包用 `NET_RX_SOFTIRQ` | 3.3 |
| NAPI | New API | 网卡收包轮询机制；中断触发后 poll | 4.8 |
| ftrace | function tracer | 内核函数/函数图追踪 | 3.15 |
| kprobe | kernel probe | 动态插桩内核函数 | 3.15 |
| tracepoint | trace point | 内核预置的稳定追踪点 | 3.15 |
| eBPF | extended Berkeley Packet Filter | 内核内安全执行的小程序；观测/网络/安全 | 3.15 |
| cgroup v2 | control group v2 | 统一层级资源控制；cpu/memory/io/pids | 5.3 |
| namespace | namespace | 隔离进程可见的系统资源；pid/mnt/net/uts/ipc/user/cgroup/time | 5.2 |

## E. 网络

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| MTU | maximum transmission unit | 链路层最大帧负载；以太网常见 1500 B | 4.1 |
| MSS | maximum segment size | TCP 段最大数据量；通常 MTU 减首部 | 4.1 |
| 封装 | encapsulation | 上层数据加下层首部 | 4.1 |
| 分用 | demultiplexing | 按首部字段把数据交给上层 | 4.1 |
| ARP | address resolution protocol | IPv4 地址到 MAC 的解析 | 4.2 |
| CIDR | classless inter-domain routing | 用前缀长度表示网段，如 `/24` | 4.3 |
| NAT | network address translation | 改写地址/端口，让内网共享公网 IP | 4.3 |
| 三次握手 | three-way handshake | SYN / SYN-ACK / ACK 建立 TCP 连接 | 4.5 |
| 四次挥手 | four-way teardown | FIN/ACK/FIN/ACK 关闭连接 | 4.5 |
| `TIME_WAIT` | TIME_WAIT | 主动关闭方等 2MSL，处理迟到报文 | 4.5 |
| `CLOSE_WAIT` | CLOSE_WAIT | 被动关闭方收到 FIN，等应用 `close` | 4.5 |
| 拥塞窗口 | congestion window, cwnd | 发送方根据网络拥塞估计的窗口 | 4.6 |
| 接收窗口 | receive window, rwnd | 接收方可用缓冲；流量控制 | 4.6 |
| RTO | retransmission timeout | 重传超时；基于 RTT 估计 | 4.6 |
| SACK | selective acknowledgment | 选择性确认，减少重传 | 4.6 |
| 慢启动 | slow start | cwnd 指数增长阶段 | 4.6 |
| 拥塞避免 | congestion avoidance | cwnd 线性增长阶段 | 4.6 |
| `sk_buff` | socket buffer | 内核网络包结构；head/data/tail/end | 4.8 |
| NAPI poll | NAPI poll | 驱动轮询收包，有 budget | 4.8 |
| RPS/RFS | receive packet steering / flow steering | 把收包软中断分到多核 | 4.8 |
| GRO/GSO | generic receive/send offload | 合并/拆分大包，减少协议栈开销 | 4.8 |
| backlog | listen backlog | accept 队列上限 | 4.5 |
| `SO_REUSEADDR` | reuse address | 允许绑定 `TIME_WAIT`/冲突地址 | 2.16 |
| `SO_REUSEPORT` | reuse port | 多 socket 绑同一端口，内核负载均衡 | 2.16 |
| veth | virtual ethernet | 一对虚拟网卡，容器网络常用 | 5.6 |
| bridge | network bridge | 二层虚拟交换机 | 5.6 |
| VXLAN | virtual extensible LAN | 三层网络上的二层 overlay | 5.6 |
| CNI | container network interface | 容器网络插件规范 | 5.6 |

## F. 云原生

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 容器 | container | namespace + cgroups + rootfs 的隔离进程 | 5.1 |
| 镜像 | image | 只读层 + 配置；容器从镜像创建 | 5.4 |
| 镜像层 | layer | overlayfs 的 lowerdir；可复用 | 5.4 |
| overlayfs | overlay filesystem | 联合挂载 lower/upper，copy-up 写时复制 | 5.4 |
| OCI | Open Container Initiative | 运行时/镜像规范 | 5.5 |
| runc | runc | OCI 运行时参考实现；创建容器进程 | 5.5 |
| containerd | containerd | 容器运行时守护进程；管理镜像/容器 | 5.5 |
| Pod | Pod | Kubernetes 最小调度单元，共享网络命名空间 | 5.6 |
| Service | Service | Kubernetes 服务抽象；ClusterIP/NodePort/LB | 5.6 |

> 回 [R.5 易混对照](compare.md)；按主题找章节用 [A.4 覆盖矩阵](../appendix/coverage.md)。
