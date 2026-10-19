# R.3 内核速查

> 以 Linux 6.8 为基线；函数名随版本变化，读源码前先 `git grep`。

## 1. 关键数据结构

| 结构 | 代表什么 | 关键字段 |
|:--|:--|:--|
| `task_struct` | 进程/线程 | `__state`、`pid`、`mm`、`active_mm`、`files`、`signal`、`sighand`、`cred`、`nsproxy`、`cgroups`、`thread` |
| `thread_info` | 线程的低层信息 | x86-64 上在 `task_struct` 内；`flags`、`cpu` |
| `mm_struct` | 进程地址空间 | `pgd`、`mmap`（VMA 链表）、`mmap_lock`、`rss_stat`、`arg_start/end` |
| `vm_area_struct` | 一段连续 VMA | `vm_start/end`、`vm_flags`、`vm_file`、`vm_ops`、`vm_pgoff` |
| `struct page` | 物理页 | `flags`、`_refcount`、`_mapcount`、`mapping`、`index`、`lru` |
| `struct slab`/`kmem_cache` | slab 对象 | `objects`、`size`、`freelist`、`cpu_slab` |
| `super_block` | 挂载的文件系统 | `s_op`、`s_root`、`s_fs_info`、`s_flags` |
| `inode` | 文件元数据 | `i_ino`、`i_mode`、`i_size`、`i_op`、`i_fop`、`i_mapping`、`i_nlink` |
| `dentry` | 目录项缓存 | `d_name`、`d_parent`、`d_inode`、`d_op`、`d_lockref` |
| `struct file` | 一次打开 | `f_op`、`f_pos`、`f_flags`、`f_count`、`private_data` |
| `socket`/`sock` | 套接字 | `sk_state`、`sk_receive_queue`、`sk_write_queue`、`sk_wq`、`sk_prot` |
| `sk_buff` | 网络包 | `head/data/tail/end`、`len`、`data_len`、`cb`、`sk` |

关系：`task_struct.mm` → `mm_struct` → 一组 `vm_area_struct`；`task_struct.files` → `files_struct` → `fd` 表 → `struct file` → `dentry`/`inode`。

## 2. 系统调用路径

```text
用户: syscall 指令（%rax=号，%rdi/%rsi/%rdx/%r10/%r8/%r9=参数）
  → entry_SYSCALL_64（保存寄存器、切内核栈）
  → do_syscall_64（按号查 sys_call_table）
  → __x64_sys_xxx（SYSCALL_DEFINE 包装）
  → 子系统（ksys_read → vfs_read → f_op->read_iter）
  → 返回 %rax；负值表示 -errno
```

- 32 位入口 `int 0x80` / `sysenter`；x86-64 用 `syscall`。
- `ptrace` 可在 `syscall` 入口/出口停住；`strace` 基于它。
- `seccomp` 在入口过滤；`audit` 记录。

## 3. 中断与下半部

```text
硬件中断 → CPU 跳 IDT → 通用入口 → 中断控制器 ack
  → 驱动 handler（上半部，关中断/快速）
  → 触发软中断（NET_RX_SOFTIRQ、TASKLET_SOFTIRQ…）
  → do_softirq / ksoftirqd（下半部，可抢占）
  → 协议栈/驱动收尾
```

| 机制 | 上下文 | 能否睡眠 | 适用 |
|:--|:--|:--|:--|
| 硬中断 | 中断上下文 | 否 | 最快响应 |
| 软中断 | 中断/ksoftirqd | 否 | 网络收包、定时 |
| tasklet | 软中断 | 否 | 旧代码 |
| workqueue | 进程上下文 | 是 | 可睡眠的延迟工作 |
| threaded IRQ | 内核线程 | 是 | 大部分现代驱动 |

观测：`/proc/interrupts`、`/proc/softirqs`、`/proc/net/softnet_stat`、`perf top` 看 `ksoftirqd`。

## 4. 进程生命周期

```text
fork/clone → copy_process（复制 task_struct、fd、mm/COW、信号）
  → wake_up_new_task → 调度
execve → 替换 mm、打开 ELF、设置栈/寄存器
exit → do_exit（释放 mm/files、置 ZOMBIE、通知父进程）
wait → 父进程回收 task_struct
```

- `TASK_RUNNING`：可运行/运行；`S` 可中断睡眠；`D` 不可中断；`T` 停止；`Z` 僵尸。
- `current` 指向当前 `task_struct`；x86-64 通过 `gs` 基址取。
- 内核线程没有用户 `mm`，借用 `active_mm`。

## 5. 调度

| 类 | 策略 | 用途 |
|:--|:--|:--|
| `fair_sched_class` | CFS/EEVDF | 普通进程 |
| `rt_sched_class` | FIFO/RR | 实时 |
| `dl_sched_class` | DEADLINE | 截止时间 |
| `idle_sched_class` | idle | 空闲 |

- CFS：`vruntime` 红黑树，按权重分配；`nice` 影响权重。
- EEVDF（6.6+）：lag/vslice，按延迟需求分配；字段与调参变化。
- 调度域/负载均衡：`/proc/schedstat`、`/proc/sched_debug`。
- 绑核：`taskset`、`sched_setaffinity`；隔离：`isolcpus`。

## 6. 内存

```text
NUMA node → zone（DMA/DMA32/NORMAL/HIGHMEM）→ page
buddy：2^order 页块，/proc/buddyinfo
slab/slub：kmalloc/kmem_cache，/proc/slabinfo
vmalloc：非连续虚拟地址，适合大块
```

缺页路径：

```text
page fault → do_page_fault → handle_mm_fault
  → 匿名页：do_anonymous_page（零页/新页）
  → 文件页：do_fault → filemap_fault（page cache）
  → COW：do_wp_page
  → 交换：do_swap_page
```

回收：

- LRU active/inactive；`kswapd` 后台回收；直接回收（`__alloc_pages` 慢路径）。
- `memory.max`/`memory.high`（cgroup v2）；OOM killer 看 `oom_score`。
- `mmap_lock`（5.8+ 取代 `mmap_sem`）；RMAP 反向映射；KSM 合并相同匿名页。

观测：`/proc/meminfo`、`/proc/vmstat`、`/proc/PID/smaps`、`slabtop`、`/sys/kernel/debug/tracing`。

## 7. VFS 与文件系统

```text
open → path_openat → 逐级 lookup（dcache/inode）
  → may_open（权限）→ do_dentry_open → file->f_op
read/write → vfs_read/vfs_write → filemap/直接 I/O
  → page cache → writeback → block layer → driver
```

- `dentry` 缓存路径；`inode` 缓存元数据；`page cache` 以 `address_space` 管理。
- `ext4`：extent、日志（journal）、delayed allocation；`XFS`：B+ 树、分配组；`Btrfs`：COW、校验、快照。
- `fsync` 刷数据+元数据；`fdatasync` 只刷数据；`O_SYNC` 每次写同步。
- 块层：`bio` → `request` → `blk-mq` → 调度器（`mq-deadline`/`kyber`/`bfq`/`none`）。

## 8. 锁与同步

| 原语 | 睡眠 | 适用 |
|:--|:--|:--|
| `spinlock_t` | 否 | 极短临界区、中断上下文 |
| `mutex` | 是 | 进程上下文、可能阻塞 |
| `rwlock`/`rwsem` | 是/否 | 读多写少 |
| `seqlock` | 否 | 读多写少、读侧重试 |
| `RCU` | 读侧否 | 读多写极少、可容忍旧值 |
| `atomic_t` | 否 | 计数/标志 |
| `completion` | 是 | 等待事件 |

- 内存屏障：`smp_mb()`、`smp_rmb()`、`smp_wmb()`、`barrier()`；RCU 的 `rcu_read_lock()` 不是锁。
- 锁顺序：同一路径固定顺序；`lockdep` 检测环。
- 中断上下文不能睡眠；持 spinlock 不能睡眠。

## 9. 调试与观测

| 目的 | 命令 |
|:--|:--|
| 内核日志 | `dmesg -T -w` |
| 动态调试 | `echo 'file mm/* +p' > /sys/kernel/debug/dynamic_debug/control` |
| 函数追踪 | `trace-cmd record -p function_graph -g vfs_read` |
| kprobe | `bpftrace -e 'kprobe:vfs_read { @[comm]=count(); }'` |
| 采样 | `perf record -F 999 -g -- PID` |
| 调度 | `perf sched latency`、`/proc/sched_debug` |
| 内存 | `slabtop`、`/proc/buddyinfo`、`kmemleak` |
| 死锁 | `lockdep`、`sysrq-w` |
| 崩溃 | `crash vmlinux vmcore`、`drgn` |
| 网络 | `/proc/net/softnet_stat`、`ss -tin` |

## 10. 版本差异（读旧资料必看）

| 旧 | 新 |
|:--|:--|
| `do_fork()` | `kernel_clone()`（5.x） |
| `mmap_sem` | `mmap_lock`（5.8+） |
| CFS 默认 | EEVDF（6.6+） |
| `struct page` 旧布局 | 6.x 有 `folio`、`memcg_data` 等变化 |
| `int 0x80` | `syscall`（x86-64） |
| `tcp_tw_recycle` | 4.12 移除 |
| `epoll` 无 `EPOLLEXCLUSIVE` | 4.5+ |
| 无 `io_uring` | 5.1+ |
| 无 `clone3` | 5.3+ |
| 无 `pidfd` | 5.1+ |
| 无 `openat2` | 5.6+ |

> 回 [R.4 网络速查](cheatsheet-net.md)；内核章节从 [3.1](../part3/ch01.md) 开始。
