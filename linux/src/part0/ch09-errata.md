# 0.9 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与进程/信号陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换内核、换容器、换 `ps`/`top` 实现后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、procps-ng 4.0、systemd 255、cgroup v2。换环境时逐条复核。

## 1. 进程状态与进程组

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `ps aux` 的 `S` 列就是状态 | `STAT` 才是完整状态；`S` 只是 sleep | `ps -o pid,stat,cmd` |
| 2 | load average 是 CPU 使用率 | load 计 R+D（含 I/O 等待），不等于 CPU 忙 | `uptime`、`vmstat 1`、`ps -eo stat` |
| 3 | `D` 状态能 `kill -9` | D 是不可中断睡眠，信号要等 I/O 返回 | `ps -o stat,wchan`、`/proc/PID/stack`（root） |
| 4 | 进程组/会话是一回事 | 会话包含多个进程组；控制终端属于会话 | `ps -o pid,pgid,sid,tty,cmd` |
| 5 | `Ctrl-C` 只杀当前进程 | 发给前台进程组，组内都收到 | 启动同组两个 `sleep` 测试 |

## 2. 作业控制与信号

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 6 | `Ctrl-Z` 结束进程 | `SIGTSTP` 挂起，进程还在 `T` | `jobs`、`ps -o stat` |
| 7 | 关终端后台任务一定继续 | 登录 Shell 发 SIGHUP，默认杀作业 | 关终端测试；`nohup`/`disown -h`/`setsid` |
| 8 | `nohup` 能恢复现场 | 只忽略 SIGHUP/重定向输出，不能恢复终端 | 对比 tmux `attach` |
| 9 | `kill -9` 会清理 | KILL 不可捕获，没清理机会 | 用 `trap` 脚本对比 TERM/KILL |
| 10 | 所有信号都排队 | 普通信号可能合并；实时信号排队 | 连续发多个 `SIGUSR1` 计数 |
| 11 | `SIGKILL`/`SIGSTOP` 能捕获/阻塞 | 不能；内核强制 | `kill -STOP`/`-KILL` 测试 |
| 12 | PID 永远不变 | PID 会复用；`kill` 前确认身份/启动时间 | `ps -o pid,lstart,cmd` |

## 3. 僵尸、资源与容器

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 13 | 僵尸杀一下就没了 | 僵尸已死，等父进程 `wait`；杀它没用 | `ps -eo stat,ppid,pid` 找父进程 |
| 14 | 孤儿没人管 | PID 1/`subreaper` 收养并回收 | `ps -o ppid= -p PID` |
| 15 | 容器里 PID 1 会自动回收 | 应用当 PID 1 不 `wait` 就堆僵尸 | `docker run --init`/`tini` 对比 |
| 16 | `nice` 能硬限制 CPU | nice 是调度权重；硬上限用 cgroup `cpu.max` | `nice` vs `cpu.max` 实验 |
| 17 | `ulimit` 是全局设置 | 是进程/会话的资源限制；soft/hard 不同 | `ulimit -a`、`/proc/PID/limits` |
| 18 | cgroup v1 与 v2 一样 | v2 统一层级、`cpu.max`/`memory.max`/`pids.max`；v1 控制器分散 | `mount \| grep cgroup`、`cat /proc/self/cgroup` |
| 19 | `top` 的 `%CPU` 是累计 | 是上次刷新以来的占比；`ps` 的 `TIME` 是累计 CPU 时间 | 对比 `top`/`ps -o time` |
| 20 | 容器里看到的 PID 是主机 PID | PID namespace 里 PID 1 是容器内视角；主机 PID 不同 | `readlink /proc/1/ns/pid`、`ps` 对比 |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的内核/容器运行时上使用前先验证：

- cgroup v2 的控制器可用性依内核启动参数与容器 runtime；`cpu.max`/`memory.max` 路径可能不同。
- `ps`/`top` 的字段与排序选项在 procps-ng/BSD/macOS 上不同；`ps -eo` 在 macOS 支持有限。
- `SIGCHLD` 的 `SA_NOCLDWAIT`/`SA_NOCLDSTOP` 行为依内核/实现；不要假设所有子进程都会自动回收。
- 容器 PID 1 的信号处理依 runtime（Docker/containerd/K8s）；`--init`/`tini` 行为不同。
- `kill -9` 对 D 状态进程也要等 I/O；NFS/块设备挂起时可能长时间不可杀。

## 5. 发现新问题怎么记

如果你在别的内核/容器上发现本章结论不成立，按「现象 → 命令/输出 → 内核/运行时版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
