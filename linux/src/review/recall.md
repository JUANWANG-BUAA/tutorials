# R.7 闭卷回忆卡

> **用法**：遮住答案，在空白纸上写；写完再展开对照。每张卡末尾标：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起。只重做 △ 与 ×。共 40 张，一轮约 40 分钟。

## A. 命令行与 Shell

**A1.** 写出硬链接与软链接的三条区别。
::: sol
① 硬链接与原文件共享同一 inode，软链接是独立 inode、内容是路径；② 硬链接不能跨文件系统，软链接可以；③ 删原文件后硬链接仍可访问（`nlink` 减 1），软链接悬空。（✓ / △ / ×）
:::

**A2.** `cmd > out 2>&1` 与 `cmd 2>&1 > out` 的区别？
::: sol
前者 stdout 与 stderr 都到 `out`；后者先把 stderr 复制到当前 stdout（终端），再把 stdout 指向 `out`，所以 stderr 仍在终端。重定向从左到右求值。（✓ / △ / ×）
:::

**A3.** `set -e` 在哪些语境下不生效？
::: sol
命令位于 `if`/`while`/`until` 的条件、`&&`/`||` 的非最后一项、`!` 之后、管道非最后一段（除非 `pipefail`）；子 shell/命令替换中的失败是否传播取决于语境。（✓ / △ / ×）
:::

**A4.** 为什么 `while read line; do ...; done < <(cmd)` 比 `cmd | while read` 好？
::: sol
管道右侧的 `while` 在子 shell 中执行，变量修改不会带回父 shell；进程替换 `< <(cmd)` 在当前 shell 执行循环，变量可见，且避免 `SIGPIPE`/退出码丢失。（✓ / △ / ×）
:::

**A5.** `umask 022` 下 `open(..., 0666)` 的最终权限是多少？如何让文件确定是 `0644`？
::: sol
`0666 & ~022 = 0644`。要确定权限：先 `umask(0)` 再 `open(..., 0644)`，或用 `fchmod(fd, 0644)`。（✓ / △ / ×）
:::

**A6.** `SIGPIPE` 什么时候产生？退出码是多少？
::: sol
向读端已关闭的管道/套接字写时，内核向写进程发 `SIGPIPE`，默认终止；shell 里退出码为 `128+13=141`。（✓ / △ / ×）
:::

## B. 系统编程

**B1.** 写出 `read()` 返回值的四种情况。
::: sol
`>0` 实际字节数（可短读）；`0` EOF；`-1` 错误（看 `errno`）；`-1 && EINTR` 被信号打断，通常重试。（✓ / △ / ×）
:::

**B2.** 为什么 `close()` 失败不能重试？
::: sol
Linux 上 `close()` 先释放 fd 再返回错误；重试可能关掉另一个线程刚打开的同号 fd。记录错误即可；要保证落盘先 `fsync`。（✓ / △ / ×）
:::

**B3.** `O_APPEND` 保证什么、不保证什么？
::: sol
保证每次 `write` 的「定位到末尾 + 写」原子；不保证多条 `write` 组成的记录不交错，也不保证 NFS 上原子。（✓ / △ / ×）
:::

**B4.** `fork()` 后哪些东西共享、哪些复制？
::: sol
共享：打开文件描述（偏移/flags）、代码段（COW）、部分内核对象；复制：fd 表、地址空间页表（COW）、信号处置、进程凭证副本。子进程返回 0，父进程返回子 pid。（✓ / △ / ×）
:::

**B5.** 僵尸进程与孤儿进程的区别？
::: sol
僵尸：子进程已退出，父进程未 `wait`，只剩 `task_struct`；孤儿：父进程先退出，子进程被 init/systemd 收养，继续运行。（✓ / △ / ×）
:::

**B6.** 条件变量为什么必须用 `while` 而不是 `if`？
::: sol
`pthread_cond_wait` 可能虚假唤醒，也可能被多个等待者中的其他线程先消费条件；醒来后必须重新检查谓词，`while (!ready) wait;`。（✓ / △ / ×）
:::

**B7.** `pthread_*` 函数如何报告错误？和 `errno` 有什么区别？
::: sol
直接返回错误码（0 成功），不设 `errno`；不要用 `== -1` 判断，也不要把返回值当 `errno` 传给 `strerror` 前不处理。（✓ / △ / ×）
:::

**B8.** `EINTR` 与 `EAGAIN` 的区别？
::: sol
`EINTR` 是阻塞调用被信号打断（事件），通常重试；`EAGAIN` 是非阻塞 fd 当前不可用（状态），应等 fd 就绪再试，不能忙等。（✓ / △ / ×）
:::

**B9.** `fork` 在多线程程序中为什么危险？
::: sol
子进程只复制调用线程；若其他线程持有 `malloc`/stdio 锁，子进程可能永久死锁。`fork` 后子进程只应调用 async-signal-safe 函数，随即 `exec` 或 `_exit`。（✓ / △ / ×）
:::

**B10.** 写文件并原子发布的四步是什么？
::: sol
写临时文件 → `fsync(tmpfd)` → `rename(tmp, dst)` → `fsync(dirfd)`。最后一步常被忘，目录项不落盘崩溃后可能看不到新名字。（✓ / △ / ×）
:::

## C. 计算机系统

**C1.** `-1` 的 32 位补码是什么？有符号溢出与无符号回绕在 C 里分别是什么行为？
::: sol
`0xFFFFFFFF`（32 个 1）。有符号溢出是未定义行为（UB）；无符号按模 2^32 回绕，有定义。（✓ / △ / ×）
:::

**C2.** IEEE 754 单精度的位域怎么分？为什么 `0.1+0.2 != 0.3`？
::: sol
1 位符号 + 8 位阶码（偏置 127）+ 23 位尾数（隐含 1）。0.1/0.2 不能精确表示，舍入后相加得到近似值，比较要用误差范围。（✓ / △ / ×）
:::

**C3.** 64 位虚拟地址、4 KiB 页、四级页表各 9 位，页内偏移多少位？一级页表项覆盖多大？
::: sol
偏移 12 位；一级覆盖 `2^(9+9+9+12)=2^39=512 GiB`。（✓ / △ / ×）
:::

**C4.** `call`、`leave`、`ret` 各做什么？
::: sol
`call` 把返回地址压栈并跳转；`leave` 等价 `mov %rbp,%rsp; pop %rbp`；`ret` 弹出返回地址并跳转。（✓ / △ / ×）
:::

**C5.** 静态链接与动态链接各有什么代价？
::: sol
静态：体积大、升级需重编，但部署简单、无运行时依赖；动态：体积小、可共享/热修，但有 `ld.so` 依赖、符号冲突、`LD_LIBRARY_PATH` 风险。（✓ / △ / ×）
:::

**C6.** 什么是 COW？`fork` 的成本主要在哪？
::: sol
写时复制：父子共享物理页，任一方写时复制新页。`fork` 主要复制页表与 `task_struct`，不复制全部内存；大地址空间的页表复制仍是成本。（✓ / △ / ×）
:::

## D. 内核

**D1.** `task_struct`、`thread_info`、内核栈在 x86-64 上是什么关系？
::: sol
`task_struct` 是进程描述符；x86-64 上 `thread_info` 嵌在 `task_struct` 内（不再放内核栈底）；内核栈是独立的 `THREAD_SIZE` 区域。（✓ / △ / ×）
:::

**D2.** 用户态 `read()` 到内核的入口路径是什么？
::: sol
`syscall` 指令 → `entry_SYSCALL_64`（保存寄存器、切内核栈）→ `do_syscall_64` → `sys_call_table[rax]` → `ksys_read` → `vfs_read` → `f_op->read_iter`。（✓ / △ / ×）
:::

**D3.** 硬中断、软中断、workqueue 的区别？
::: sol
硬中断：中断上下文，不能睡眠，最快；软中断：中断/ksoftirqd 上下文，不能睡眠，网络收包；workqueue：进程上下文，可睡眠，适合延迟工作。（✓ / △ / ×）
:::

**D4.** CFS 与 EEVDF 的核心区别？
::: sol
CFS 用 `vruntime` 红黑树按权重分配 CPU；EEVDF（6.6+）用 lag/vslice 按延迟需求分配，字段与调参变化。旧资料读 CFS 思想仍有效。（✓ / △ / ×）
:::

**D5.** 缺页异常的三种典型处理？
::: sol
匿名页：`do_anonymous_page` 分配零页/新页；文件页：`filemap_fault` 从 page cache/磁盘读；COW：`do_wp_page` 复制新页。另有 swap 换入。（✓ / △ / ×）
:::

**D6.** 伙伴系统与 slab 各解决什么问题？
::: sol
伙伴系统按 2 的幂管理物理页块，解决外部碎片；slab/slub 在内核对象粒度缓存，解决频繁分配/初始化的开销与内部碎片。（✓ / △ / ×）
:::

**D7.** RCU 的读侧为什么不能睡眠？宽限期是什么？
::: sol
读侧在 `rcu_read_lock` 期间访问旧数据，不能睡眠/切走，否则宽限期无法结束；宽限期是所有已存在读侧临界区都结束的等待期，之后才能释放旧对象。（✓ / △ / ×）
:::

**D8.** `fsync` 在内核里大致经过什么？
::: sol
`vfs_fsync` → 文件系统 `fsync` → 回写脏页（`writeback`）→ 块层 `bio/request` → 设备缓存 flush；目录项还需单独 `fsync` 目录。（✓ / △ / ×）
:::

## E. 网络

**E1.** 写出 TCP 三次握手的报文与 seq/ack 变化。
::: sol
`SYN(seq=x)` → `SYN-ACK(seq=y, ack=x+1)` → `ACK(seq=x+1, ack=y+1)`。（✓ / △ / ×）
:::

**E2.** `listen(fd, 128)` 的 backlog 限制哪个队列？队列满了默认怎么处理？
::: sol
主要限制 accept 队列（已完成握手、等 `accept`）；SYN 队列由 `tcp_max_syn_backlog` 控制。accept 队列满时默认忽略/丢弃新 ACK（`tcp_abort_on_overflow=0`）。（✓ / △ / ×）
:::

**E3.** epoll LT 与 ET 的区别？ET 的两条纪律？
::: sol
LT 只要就绪就持续通知；ET 只在状态变化时通知一次。ET 必须 fd 非阻塞，并循环 `read` 到 `EAGAIN`；还要处理 `EPOLLERR/EPOLLHUP`。（✓ / △ / ×）
:::

**E4.** `TIME_WAIT` 与 `CLOSE_WAIT` 分别是谁、为什么？
::: sol
`TIME_WAIT` 是主动关闭方等 2MSL，处理迟到报文；`CLOSE_WAIT` 是被动关闭方收到 FIN 后等应用 `close`——多说明应用没关 fd，是 bug。（✓ / △ / ×）
:::

**E5.** 收包从网卡到 socket 的关键路径？
::: sol
NIC DMA → RX ring → 硬中断 → `napi_schedule` → `NET_RX_SOFTIRQ` → `napi_poll` → `netif_receive_skb` → `ip_rcv` → `tcp_v4_rcv` → `sk_receive_queue` → 唤醒等待者。（✓ / △ / ×）
:::

**E6.** 一百万连接最先撞到什么？列出四项。
::: sol
fd 上限（`ulimit -n`/`fs.file-max`）、临时端口范围（客户端）、内存（`tcp_mem`/`sk_buff`）、conntrack 表、`somaxconn`/backlog、epoll 对象开销。（✓ / △ / ×）
:::

## F. 云原生

**F1.** 容器的三件套是什么？各解决什么？
::: sol
namespace 决定「看见什么」；cgroups 决定「能用多少」；rootfs/镜像决定「文件系统长什么样」。共享内核，不是轻量虚拟机。（✓ / △ / ×）
:::

**F2.** overlayfs 的四个目录与 copy-up 是什么？
::: sol
`lowerdir`（只读层）、`upperdir`（可写层）、`workdir`（内部）、`merged`（合并视图）。写 lower 文件时先复制到 upper（copy-up），再修改。（✓ / △ / ×）
:::

**F3.** OCI 运行时（runc）的生命周期？
::: sol
`create`（准备 namespaces/cgroups/rootfs，创建进程但暂停）→ `start`（执行用户进程）→ `kill`/`delete`。`config.json` 描述根文件系统、进程、挂载、namespace、资源。（✓ / △ / ×）
:::

**F4.** 容器网络从 veth 到外网的路径？
::: sol
容器 netns 内 `eth0` ↔ veth pair ↔ 宿主 bridge（docker0/cni0）→ 宿主路由 → NAT（nftables/iptables）→ 外网；跨主机用 VXLAN/CNI overlay。（✓ / △ / ×）
:::

> 回 [R.6 术语表](glossary.md)；做整套题去 [R.8 综合自测卷](mock-exam.md)。
