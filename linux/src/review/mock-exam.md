# R.8 综合自测卷

> **规则**：闭卷，90 分钟，满分 100。先做题，再对答案；错题回到对应章。建议每 10 题休息 5 分钟。

## 一、单选（每题 3 分，共 30 分）

**1.** `write(fd, buf, 4096)` 返回 `1024`，最准确的解释是：
A. 写失败，只剩 1024 字节空间
B. 短写，实际写入 1024 字节，应继续写剩余部分
C. 内核缓冲区只有 1024 字节，必须 `fsync`
D. 返回的是错误码

**2.** 两个进程各自 `open("log", O_WRONLY|O_APPEND)`，各用一次 `write` 写 100 字节。结果是：
A. 一定互相覆盖
B. 不会互相覆盖，且两条 100 字节记录不会交错
C. 不会互相覆盖，但若一条记录由多次 `write` 完成仍可能交错
D. 取决于 `umask`

**3.** `fork()` 后，父子进程共享的是：
A. fd 表
B. 打开文件描述（偏移与 flags）
C. 地址空间物理页（无 COW）
D. 信号处理器栈

**4.** `listen(fd, 128)` 的 `128` 主要限制：
A. SYN 队列
B. accept 队列
C. 同时建立的连接总数
D. 每个连接的接收缓冲区

**5.** epoll ET 模式下，正确的读法是：
A. 读一次即可
B. 循环读到 `EAGAIN`，且 fd 非阻塞
C. 每次先 `lseek`
D. 必须用 `select`

**6.** 服务端出现大量 `CLOSE_WAIT`，最可能的原因是：
A. 内核参数 `tcp_tw_reuse` 没开
B. 应用收到 FIN 后没有 `close`
C. 客户端主动关闭
D. 防火墙拦截

**7.** 32 位补码中 `-1` 的十六进制是：
A. `0x80000000`
B. `0xFFFFFFFF`
C. `0x00000001`
D. `0x7FFFFFFF`

**8.** 64 位虚拟地址、4 KiB 页、四级页表各 9 位，一级页表项覆盖：
A. 2 MiB
B. 1 GiB
C. 512 GiB
D. 256 TiB

**9.** cgroups v2 中限制 CPU 带宽的接口是：
A. `cpu.shares`
B. `cpu.cfs_quota_us`
C. `cpu.max`
D. `cpu.weight`

**10.** overlayfs 的 copy-up 发生在：
A. 读 lower 文件时
B. 写 lower 文件时
C. 删除 upper 文件时
D. 挂载时

## 二、简答（每题 5 分，共 30 分）

**11.** 解释 `fork()` 的 COW，并说明为什么大内存进程 `fork` 仍然可能慢。

**12.** 写出处理短读、短写与 `EINTR` 的 `read_full`/`write_full` 的关键循环。

**13.** 信号处理器里为什么不能调用 `printf`/`malloc`？给出两种把信号转成 fd 事件的方法。

**14.** 条件变量为什么必须用 `while`？`pthread_cond_wait` 内部做了什么？

**15.** 画出 Linux 收包从网卡到 socket 的关键路径（至少 8 个节点）。

**16.** `write()` 返回、`fsync()` 返回、`O_SYNC` 三者对持久化的保证分别是什么？

## 三、分析（每题 10 分，共 20 分）

**17.** 线上服务 `ss -s` 显示 `TIME_WAIT` 3 万、`CLOSE_WAIT` 200。请判断哪个是问题、为什么，并给出三步排查/修复。

**18.** 一台 8 核机器 `load average` 12，但 `top` 显示 CPU 空闲 70%。请给出至少三条假设、对应证据命令与判据。

## 四、设计（每题 10 分，共 20 分）

**19.** 设计一个单机 100 万空闲 TCP 连接的服务器：列出架构、fd/内存/端口/backlog 的估算与关键代码结构（不必写完整代码）。

**20.** 设计一个最小容器运行时：列出 namespace、cgroups、rootfs、生命周期与安全五部分的关键点，并说明容器与虚拟机的本质区别。

---

## 答案与评分

### 单选

| 题 | 答案 | 解释 |
|:--|:--|:--|
| 1 | B | 短写合法；循环写剩余，处理 `EINTR` |
| 2 | C | `O_APPEND` 保证单次 `write` 原子追加；多次写仍可能交错 |
| 3 | B | `fork` 复制 fd 表，表项指向同一 `struct file`，偏移共享 |
| 4 | B | backlog 主要限制 accept 队列；SYN 队列由 `tcp_max_syn_backlog` |
| 5 | B | ET 必须非阻塞并读到 `EAGAIN`，否则丢事件 |
| 6 | B | `CLOSE_WAIT` 是被动关闭方等应用 `close`，多则为应用 bug |
| 7 | B | 32 位全 1 |
| 8 | C | `2^(9+9+9+12)=2^39=512 GiB` |
| 9 | C | v2 用 `cpu.max`（`$MAX $PERIOD`） |
| 10 | B | 写 lower 文件触发 copy-up 到 upper |

### 简答评分点

**11.** COW：父子共享物理页，写时复制；`fork` 复制页表/`task_struct`，页表随地址空间增大而增大；大页表复制 + TLB 失效仍可能慢；`vfork`/`posix_spawn` 可避免。（5 分：COW 2、成本 2、替代 1）

**12.** 循环：`done` 游标、`read/write` 返回 `>0` 累加、`0` EOF/错误、`-1 && EINTR` 重试、`-1` 其他返回错误；`write` 返回 0 视为 `EIO` 防死循环。（5 分：短读/短写 2、EINTR 2、0 处理 1）

**13.** 处理器可能在任意指令处打断，`printf`/`malloc` 非 async-signal-safe，可能死锁/重入；方法：self-pipe（处理器 `write` 一字节，主循环 `poll/epoll` 读）、`signalfd`（阻塞信号，读 fd）。（5 分：原因 2、两种方法 3）

**14.** 虚假唤醒 + 多个等待者竞争；`wait` 原子释放锁并睡眠，被唤醒后重新加锁；醒来必须重新检查谓词，故 `while`。（5 分：虚假唤醒 2、原子释放 2、循环 1）

**15.** NIC DMA → RX ring → 硬中断 → `napi_schedule` → `NET_RX_SOFTIRQ` → `napi_poll` → `netif_receive_skb` → `ip_rcv` → `tcp_v4_rcv` → `sk_receive_queue` → 唤醒。少一个节点扣 0.5，最多扣 3。（5 分）

**16.** `write` 只到 page cache；`fsync` 数据+元数据到持久介质；`O_SYNC` 每次 `write` 同步完成；`fdatasync` 只数据+必要元数据。（5 分：三点各 1.5，补充 0.5）

### 分析评分点

**17.** `CLOSE_WAIT` 200 是问题（应用没 close），`TIME_WAIT` 3 万是主动关闭方的正常状态，除非端口耗尽。步骤：① `ss -tan state close-wait` 找进程/fd；② `lsof -p`/代码检查所有分支是否 `close`；③ 修复后观察 `CLOSE_WAIT` 降为 0；`TIME_WAIT` 只在端口耗尽时考虑 `tcp_tw_reuse`。（10 分：判断 3、证据 4、修复 3）

**18.** 假设：D 状态 I/O 等待、NFS/块层卡住、内存回收/直接回收、锁竞争、CPU 被 cgroup 限流。证据：`ps -eo state,wchan`、`iostat -xz`、`/proc/pressure/io`、`vmstat`、`perf sched`、`cat /sys/fs/cgroup/.../cpu.stat`。判据：D 多 + `%wa` 高 → I/O；D 多 + `wchan=nfs` → NFS；PSI `io some` 高 → I/O 压力。（10 分：每条假设+证据+判据约 2 分，答满 5 条满分）

### 设计评分点

**19.** 架构：多 reactor + 多 acceptor（`SO_REUSEPORT`）、epoll ET、非阻塞、内存池、定时器轮、连接对象池；估算：fd 100 万（`ulimit -n`/`fs.file-max`）、内存每连接 ~几 KB（`tcp_mem`/`sk_buff`）、端口仅客户端受限、`somaxconn`/backlog；代码结构：`event_loop`、` acceptor`、`conn`、`timer`、`buffer`。容器/虚拟机：共享内核 vs 独立内核。（10 分：架构 4、估算 3、结构 2、区别 1）

**20.** namespace：pid/mnt/net/uts/ipc/user；cgroups：`cpu.max`/`memory.max`/`pids.max`；rootfs：overlayfs + `pivot_root`；生命周期：create/start/kill/delete、PID 1 信号；安全：capabilities/seccomp/no_new_privs/user ns；本质区别：共享内核，隔离靠内核机制，不是虚拟化。（10 分：每部分 1.5，区别 2.5）

## 分数对照

| 分数 | 判断 | 下一步 |
|:--|:--|:--|
| 90–100 | 系统知识扎实 | 做项目 A1/C1，读内核源码 |
| 75–89 | 主干清楚，细节有洞 | 回看错题章节 + R.7 回忆卡 |
| 60–74 | 会用但机制不牢 | 重读第 1/2 篇，做 2.18 实验 |
| <60 | 需要系统重建 | 按路线 B 从 1.2 开始，别跳 |

> 回 [R.7 回忆卡](recall.md)；面试追问去 [R.9 面试竞技场](interview.md)。
