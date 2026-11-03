# 0.9 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · `ps` 五列与状态

`ps` 最该看哪五列？`R`、`S`、`D`、`T`、`Z` 各表示什么？

::: sol 解答

五列：PID、PPID、STAT、TTY、CMD。`R` 运行/可运行；`S` 可中断睡眠；`D` 不可中断睡眠（多在等 I/O）；`T` 停止；`Z` 僵尸（已退出、父进程未 `wait`）。`STAT` 后的 `s`/`+`/`l` 是附加标志（会话首进程/前台进程组/多线程）。

:::
:::

::: ex A2 · 进程组、会话与控制终端

进程组、会话、控制终端是什么关系？`Ctrl-C`/`Ctrl-Z`/`SIGHUP` 各发给谁？

::: sol 解答

进程组是一组相关进程（通常一个作业）；会话是一组进程组，最多有一个控制终端。`Ctrl-C` 发 `SIGINT` 给前台进程组；`Ctrl-Z` 发 `SIGTSTP` 给前台进程组；终端关闭时登录 Shell 向会话/作业发 `SIGHUP`。`setsid` 创建新会话、脱离控制终端。

:::
:::

::: ex A3 · 状态与 load average

load average 统计哪些状态？为什么 load 8.0 但 CPU 95% 空闲？`D` 状态为什么危险？

::: sol 解答

load 统计 R（运行/可运行）+ D（不可中断睡眠）的进程数（Linux 还包含部分 I/O 等待），不是 CPU 使用率。load 8.0 但 CPU 空闲，可能是 8 个进程卡在 D 等 I/O。D 状态不能被信号打断，`kill -9` 也要等 I/O 返回；大量 D 会拖垮负载。

:::
:::

::: ex A4 · TERM 与 KILL

`SIGTERM` 与 `SIGKILL` 差在哪？为什么先 TERM 再 KILL？哪些信号不可捕获？

::: sol 解答

`SIGTERM` 可捕获/忽略，给进程清理机会；`SIGKILL` 不可捕获/阻塞，内核直接终止，不给清理。先 TERM，等一段时间，再 KILL。不可捕获/阻塞：`SIGKILL`、`SIGSTOP`（`SIGCONT` 不能被阻塞）。`kill -0` 只检查进程是否存在/有权限，不发信号。

:::
:::

::: ex A5 · 僵尸与孤儿

僵尸进程是什么？孤儿是什么？谁负责回收？容器里为什么常看到僵尸？

::: sol 解答

子进程退出但父进程没 `wait`/`waitpid`，留下僵尸（Z），占 PID/进程表项；父进程先死，子进程成孤儿，由 PID 1（或 subreaper）收养并回收。容器里 PID 1 是应用本身，如果它不 `wait` 子进程，僵尸会堆积；用 `tini`/`--init` 或让应用正确回收。

:::
:::

::: ex A6 · nice、亲和性、rlimit、cgroup

`nice`/`renice`、`taskset`、`ulimit`/`prlimit`、cgroup 各管什么？`nice` 能替代 cgroup 吗？

::: sol 解答

`nice`/`renice` 调静态优先级（-20..19，越高越谦让）；`taskset` 绑 CPU 亲和性；`ulimit`/`prlimit` 管进程资源限制；cgroup v2 管一组进程的资源上限/权重（CPU/内存/IO/PIDs）。`nice` 只是调度权重，不能硬限制；硬上限/分组记账用 cgroup。`chrt` 管实时调度类。

:::
:::

::: ex A7 · 信号处置、阻塞与排队

信号处置有哪几种？阻塞与 pending 是什么？普通信号会排队吗？`sigprocmask`/`sigaction` 做什么？

::: sol 解答

处置：默认、忽略、捕获（`sigaction`）。阻塞用信号掩码（`sigprocmask`），被阻塞的信号进入 pending（`sigpending`），解除阻塞后递送。普通信号不排队，同类多个可能合并；实时信号排队。`/proc/PID/status` 的 `SigBlk`/`SigPnd`/`SigCgt` 看掩码/未决/捕获。`SIGKILL`/`SIGSTOP` 不能捕获/阻塞。

:::
:::

::: ex A8 · 进程树与 `/proc`

怎样看进程树与进程身份？`/proc/PID/` 下哪些文件最有用？

::: sol 解答

`pstree -p`、`ps -eo pid,ppid,cmd --forest` 看树；`/proc/PID/status` 看 Uid/Gid/State/SigBlk/SigPnd/SigCgt/Threads；`cmdline` 看命令行；`environ` 看环境；`fd/` 看打开的 fd；`cwd` 看当前目录；`limits` 看 rlimit；`cgroup` 看 cgroup。`ps -o ppid=` 找父进程。

:::
:::

## B 组 · 诊断推理

::: ex B1 · `kill -9` 后没清理

服务被 `kill -9` 后临时文件/锁/连接都没清理，为什么？怎样优雅停？

::: sol B1 核对

`SIGKILL` 不可捕获，进程没有机会执行清理；内核只回收资源，不做业务清理。优雅停：先 `kill -TERM`，等待进程自己清理/退出；设超时（如 10s），超时再 `KILL`；用 `trap`/`systemd` 的 `ExecStop`/`TimeoutStopSec` 管理。锁/临时文件用 `trap EXIT` + `flock`/`mktemp` 保证。

:::
:::

::: ex B2 · 容器里僵尸多

容器里 `ps` 看到很多 `Z`，应用本身还在跑。为什么？怎样修？

::: sol B2 核对

容器 PID 1 是应用本身，它不 `wait` 子进程，子进程退出后成僵尸；普通 init 会回收，容器里没有。修法：用 `tini`/`docker run --init`/`containerd` 的 init，或让应用 `waitpid`/`SIGCHLD` 处理；不要让 PID 1 是不回收子进程的 shell 脚本。

:::
:::

::: ex B3 · load 高但 CPU 空闲

`uptime` 显示 load 20，但 `top` 的 CPU 95% idle。列出至少三种原因与验证命令。

::: sol B3 核对

① 大量 D 状态进程等 I/O：`ps -eo stat,pid,cmd | awk '$1 ~ /D/'`、`vmstat 1`、`iostat -x 1`；② NFS/网络存储挂起；③ 内存压力导致频繁回收/swap：`free -h`、`vmstat`；④ cgroup CPU 限流导致任务排队：`cat /sys/fs/cgroup/.../cpu.stat`；⑤ 大量短命进程 fork/exit：`pidstat`。load 计 R+D，不等于 CPU 忙。

:::
:::

::: ex B4 · 关终端后台任务死

`sleep 300 &` 后关闭终端，进程没了；`nohup`/tmux 为什么能活？三者各解决什么？

::: sol B4 核对

关终端时登录 Shell 向作业发 SIGHUP，`sleep` 默认终止。`nohup` 让进程忽略 SIGHUP，输出到 `nohup.out`，但不可恢复现场；tmux 的 Shell 不属于当前终端会话，关终端不影响，`attach` 能恢复现场；`setsid` 让进程进新会话、脱离控制终端。生产长任务优先 systemd/tmux，不要只靠 `nohup`。

:::
:::

::: ex B5 · 进程杀不掉

`kill -9 PID` 没反应，进程还在。列出至少三种原因与验证。

::: sol B5 核对

① 进程在 D 状态等 I/O，信号要等 I/O 返回；`ps -o stat,wchan`、`cat /proc/PID/stack`（root）；② 僵尸 Z 已经死了，等父进程 `wait`，杀它没用；③ PID 被复用，你杀的是新进程；④ 权限不足/容器命名空间看不到；⑤ 内核线程不能杀。先 `ps -o stat`、`/proc/PID/status`、`dmesg`。

:::
:::

::: ex B6 · 信号没反应

给进程发 `TERM` 没反应。列出至少三种原因与验证。

::: sol B6 核对

① 信号被阻塞：`grep SigBlk /proc/PID/status`；② 被忽略/捕获但没处理：`SigCgt`/`SigIgn`；③ 进程在 D 状态，信号 pending 等 I/O；④ PID 不对/权限不足；⑤ 进程是僵尸。用 `kill -0` 检查存在，`/proc/PID/status` 看信号掩码，`strace -p` 看是否收到。

:::
:::

## C 组 · 动手实验

::: ex C1 · 读进程

对当前 Shell 运行 `ps -o pid,ppid,stat,tty,cmd -p $$`、`pstree -p $$`、`cat /proc/$$/status`，解释每列/字段。

::: sol C1 核对

```bash
ps -o pid,ppid,stat,tty,cmd -p $$
pstree -p $$
grep -E '^(Name|State|Uid|Gid|Threads|SigBlk|SigCgt):' /proc/$$/status
```

`ps` 五列看 PID/父进程/状态/终端/命令；`pstree -p` 看父子链；`/proc/$$/status` 看 Name/State/Uid/Gid/Threads/SigBlk/SigCgt。`State` 的 `S` 表示可中断睡眠；`SigCgt` 是捕获的信号位图。

:::
:::

::: ex C2 · 进程组实验

在脚本里启动两个 `sleep`，用 `ps -o pid,pgid,sid,tty,cmd` 看进程组/会话；用 `kill -- -PGID` 杀整个组。

::: sol C2 核对

```bash
bash -c 'sleep 300 & sleep 300 & ps -o pid,pgid,sid,tty,cmd; wait' &
ps -o pid,pgid,sid,tty,cmd -p $!
kill -- -$PGID   # 负号表示进程组
```

`PGID` 相同说明同组；`SID` 是会话；`kill -- -PGID` 给整组发信号。`Ctrl-C` 发前台进程组，正是这个机制。注意负号与权限。

:::
:::

::: ex C3 · 信号掩码实验

用 `bash`/Python 阻塞 `SIGINT`，发 `Ctrl-C` 或 `kill -INT`，观察 pending；解除阻塞后递送。

::: sol C3 核对

Python 示例：

```python
import signal, time
signal.pthread_sigmask(signal.SIG_BLOCK, {signal.SIGINT})
print('blocked; send SIGINT now')
time.sleep(5)
print('pending:', signal.sigpending())
signal.pthread_sigmask(signal.SIG_UNBLOCK, {signal.SIGINT})
```

阻塞期间 `SIGINT` 进 pending，进程不退出；解除后递送，触发默认动作（KeyboardInterrupt/终止）。`/proc/PID/status` 的 `SigBlk`/`SigPnd` 可对照。

:::
:::

::: ex C4 · nice 与 cgroup

用 `nice -n 10` 启动 CPU 密集任务，与普通任务对比；再用 cgroup v2 的 `cpu.max` 限制，观察差异。

::: sol C4 核对

```bash
nice -n 10 sh -c 'while :; do :; done' &
sh -c 'while :; do :; done' &
top   # 观察两个任务的 %CPU
```

`nice` 只改调度权重，空闲 CPU 上高 nice 任务仍可能跑满；有竞争时才让出。cgroup v2：

```bash
mkdir -p /sys/fs/cgroup/demo
echo '20000 100000' > /sys/fs/cgroup/demo/cpu.max   # 20% CPU
echo $$ > /sys/fs/cgroup/demo/cgroup.procs
```

`cpu.max` 是硬上限（配额/周期），与 nice 的“权重”不同层。实验后清理 cgroup。

:::
:::

::: ex C5 · 进程巡检/超时脚本

写一个脚本：找高 CPU、僵尸、D 状态进程；再写一个 `timeout` 包装：先 TERM，超时 KILL，回收退出码。

::: sol C5 核对

巡检：

```bash
echo "== top cpu"; ps -eo pid,stat,pcpu,pmem,cmd --sort=-pcpu | head -6
echo "== zombies"; ps -eo stat,ppid,pid,cmd | awk '$1 ~ /Z/'
echo "== D state"; ps -eo stat,pid,cmd | awk '$1 ~ /D/'
```

超时包装：

```bash
#!/usr/bin/env bash
set -euo pipefail
timeout=${1:?timeout}; shift
"$@" & pid=$!
( sleep "$timeout"; kill -TERM "$pid" 2>/dev/null; sleep 3; kill -KILL "$pid" 2>/dev/null ) & watcher=$!
wait "$pid"; rc=$?
kill "$watcher" 2>/dev/null || true
exit "$rc"
```

先 TERM 给清理机会，超时再 KILL；`wait` 回收僵尸；记录退出码。生产可用 `timeout(1)`，但自己写一遍能理解信号与回收。

:::
:::
