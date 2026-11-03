# 0.9 章末总结

## 四单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、看清进程**（0.9.1–0.9.3、0.9.7） | `ps` 五列是什么？进程怎样组织？ | PID/PPID/STAT/TTY/CMD 是五列；进程组、会话、控制终端决定 `Ctrl-C`/`Ctrl-Z`/`SIGHUP` 发给谁；`R/S/D/T/Z` 是状态，load average 只算 R+D。 | 把 `Z` 当运行；把 load 当 CPU 使用率；把 PID 当永久身份。 |
| **二、会管进程**（0.9.4–0.9.9） | 作业控制、信号、僵尸、资源怎样管？ | `jobs/fg/bg/disown` 管作业；`TERM` 先礼后兵，`KILL` 不可捕获；`wait` 回收僵尸，PID 1 收孤儿；`nice`/`taskset`/`ulimit`/cgroup 管资源；`ps/top` 排序看热点。 | 关终端后台被杀；`KILL` 当第一选择；僵尸不回收；`nice` 当 cgroup。 |
| **三、信号与边界**（0.9.10、0.9.13） | 信号怎样处置/阻塞/排队？哪些边界最容易错？ | 处置有默认/忽略/捕获；阻塞用 mask，pending 记录未决；实时信号排队，普通信号可能合并。14 个边界集中在 TERM/KILL、PID 复用、D 状态、SIGHUP、容器 PID 1。 | 以为信号一定立即到；以为 `kill -9` 能清理；忽略 `SIGCHLD`；容器里 PID 1 不回收。 |
| **四、实验与脚本**（0.9.11–0.9.12、0.9.14–0.9.15） | 怎样证明？ | 进程巡检、信号转发、超时回收脚本；进程组/信号掩码/nice/cgroup 实验。 | 只读不跑；不做进程组实验；不检查 `/proc/PID/status`。 |

## 一条主线

这一章先让你**看清进程**：`ps` 五列、进程组/会话/控制终端、状态字母、`/proc` 与进程树。再让你**会管进程**：作业控制、`TERM`/`KILL`、僵尸/孤儿/`wait`、`nice`/亲和性/资源限制、`ps`/`top`。然后**看信号与边界**：处置、阻塞、排队与 14 个容易踩错的边界。最后用**三个脚本和四组实验**收口：进程巡检、信号转发、超时回收；进程组、信号掩码、nice 权重、cgroup 记账。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| 进程在不在、什么状态 | `ps -o pid,ppid,stat,tty,cmd -p PID` | `STAT` 比 `ps aux` 的 `S` 列更直接。 |
| 进程树/父子关系 | `pstree -p`、`ps -o ppid=` | 孤儿/僵尸/容器 PID 1 都靠父子链解释。 |
| 僵尸很多 | `ps -eo stat,ppid,pid,cmd \| awk '$1 ~ /Z/'` | 找父进程，让它 `wait`；PID 1 要负责回收。 |
| load 很高但 CPU 空闲 | 看 `D` 状态与 `vmstat`/`iostat` | load 计 R+D；D 多在等 I/O。 |
| 要优雅停服务 | 先 `kill -TERM`，等，再 `kill -KILL` | TERM 可捕获做清理；KILL 不可捕获。 |
| 关终端后台任务死了 | `nohup`/`disown -h`/`setsid`/tmux/systemd | 登录 Shell 退出发 SIGHUP。 |
| 进程 CPU 抢不过别人 | `nice`/`renice`、`taskset`、`chrt`、cgroup | 优先级/亲和性/调度类/资源限制是不同层。 |
| fd 泄漏 | `ls -l /proc/PID/fd`、`lsof -p PID` | fd 表是进程内资源；泄漏会 `EMFILE`。 |
| 信号被阻塞/未决 | `grep Sig /proc/PID/status` | `SigBlk`/`SigPnd`/`SigCgt` 看阻塞/未决/捕获。 |
| 容器里 PID 1 不回收 | 用 `tini`/`--init` 或让应用 `wait` | 容器 PID 1 是孤儿回收者，不回收就僵尸。 |

## 能否讲出这八句话

1. `ps` 五列是 PID、PPID、STAT、TTY、CMD；`S`/`R`/`D`/`Z`/`T` 各表示睡眠/运行/不可中断/僵尸/停止。
2. 进程组、会话、控制终端决定 `Ctrl-C`/`Ctrl-Z`/`SIGHUP` 发给谁；`Ctrl-C` 发给前台进程组。
3. load average 只算 R（运行/可运行）与 D（不可中断睡眠），不等于 CPU 使用率。
4. 停进程先 `TERM`，等它清理；不行再 `KILL`；`KILL` 不可捕获、不给清理机会。
5. 子进程退出父进程没 `wait` 就是僵尸；父进程先死子进程成孤儿，由 PID 1 收养并回收。
6. `nice` 范围 -20..19，越高越“谦让”；`taskset` 管亲和性，`chrt` 管调度类，cgroup 管资源上限。
7. 信号处置有默认/忽略/捕获；阻塞用 mask，pending 记录未决；普通信号可能合并，实时信号排队。
8. 关终端默认发 SIGHUP；`nohup`/`disown -h`/`setsid`/tmux/systemd 解决的是不同层的问题。

## 学完之后

1. **[闭卷回忆卡](ch09-recall.md)**：先合上正文，把 `ps` 五列、进程组/会话、状态、TERM/KILL、僵尸/孤儿五组结论从空白纸上叫出来。
2. **[习题集](ch09-exercises.md)**：A 组检查概念，B 组诊断“为什么杀不掉/为什么有僵尸/为什么 load 高”，C 组做进程组、信号掩码、nice/cgroup 实验。
3. **[学习目标自检表](ch09-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch09-errata.md)**：把 cgroup v2、`ps`/`top` 选项、信号语义的版本差异过一遍。
5. **下一站**：[0.10 磁盘、文件系统、挂载与 LVM/RAID](ch10.md) 会从进程转到存储；本章的 `D` 状态与 I/O 等待会在那里得到解释。
