# 0.9 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先看清进程

### D1 · `ps` 五列与状态

`ps` 最该看哪五列？`R`、`S`、`D`、`T`、`Z` 各表示什么？

::: sol D1 核对

五列：PID、PPID、STAT、TTY、CMD。`R` 运行/可运行；`S` 可中断睡眠（等事件）；`D` 不可中断睡眠（多在等 I/O）；`T` 停止（作业控制/`SIGSTOP`）；`Z` 僵尸（已退出、父进程未 `wait`）。`STAT` 后的 `s`/`+`/`l` 等是附加标志（会话首进程/前台进程组/多线程）。
:::

### D2 · 进程组、会话与控制终端

进程组、会话、控制终端是什么关系？`Ctrl-C`/`Ctrl-Z`/`SIGHUP` 各发给谁？

::: sol D2 核对

进程组是一组相关进程（通常一个作业）；会话是一组进程组，最多有一个控制终端；控制终端是登录/终端窗口。`Ctrl-C` 发 `SIGINT` 给**前台进程组**；`Ctrl-Z` 发 `SIGTSTP` 给前台进程组；终端关闭时登录 Shell 向会话/作业发 `SIGHUP`。`setsid` 创建新会话、脱离控制终端。
:::

### D3 · 状态与 load average

load average 统计哪些状态？为什么 load 8.0 但 CPU 95% 空闲？`D` 状态为什么危险？

::: sol D3 核对

load average 统计 R（运行/可运行）+ D（不可中断睡眠）的进程数（Linux 上还包含部分等待 I/O 的任务），不是 CPU 使用率。load 8.0 但 CPU 空闲，可能是 8 个进程卡在 D 等 I/O（磁盘/NFS）。D 状态不能被信号打断，`kill -9` 也要等 I/O 返回；大量 D 会拖垮负载。
:::

### D4 · 作业控制

`&`、`jobs`、`fg`、`bg`、`disown`、`nohup` 各做什么？`Ctrl-Z` 是结束进程吗？

::: sol D4 核对

`cmd &` 后台启动；`jobs -l` 列作业；`fg %1` 放前台；`bg %1` 后台继续；`disown -h %1` 标记 Shell 退出不发 SIGHUP（作业仍在表里）；`nohup cmd &` 忽略 SIGHUP、输出到 `nohup.out`。`Ctrl-Z` 是 `SIGTSTP` 挂起，不是结束；要结束用 `kill`。
:::

### D5 · TERM 与 KILL

`SIGTERM` 与 `SIGKILL` 差在哪？为什么先 TERM 再 KILL？哪些信号不可捕获？

::: sol D5 核对

`SIGTERM` 可捕获/忽略，给进程清理机会；`SIGKILL` 不可捕获/阻塞，内核直接终止，不给清理。先 TERM，等一段时间，再 KILL。不可捕获/阻塞：`SIGKILL`、`SIGSTOP`（以及 `SIGCONT` 不能被阻塞）。`kill -0` 只检查进程是否存在/有权限，不发信号。
:::

### D6 · 僵尸与孤儿

僵尸进程是什么？孤儿是什么？谁负责回收？容器里为什么常看到僵尸？

::: sol D6 核对

子进程退出但父进程没 `wait`/`waitpid`，留下僵尸（Z），占 PID/进程表项；父进程先死，子进程成孤儿，由 PID 1（或 subreaper）收养并回收。容器里 PID 1 是应用本身，如果它不 `wait` 子进程，僵尸会堆积；用 `tini`/`--init` 或让应用正确回收。
:::

## B. 第二遍：看信号与边界

### D7 · 进程树与 `/proc`

怎样看进程树与进程身份？`/proc/PID/` 下哪些文件最有用？

::: sol D7 核对

`pstree -p`、`ps -eo pid,ppid,cmd --forest` 看树；`/proc/PID/status` 看 Uid/Gid/State/SigBlk/SigPnd/SigCgt/Threads；`cmdline` 看命令行（NUL 分隔）；`environ` 看环境；`fd/` 看打开的 fd；`cwd` 看当前目录；`limits` 看 rlimit；`cgroup` 看 cgroup。`ps -o ppid=` 找父进程。
:::

### D8 · nice、亲和性、rlimit、cgroup

`nice`/`renice`、`taskset`、`ulimit`/`prlimit`、cgroup 各管什么？`nice` 能替代 cgroup 吗？

::: sol D8 核对

`nice`/`renice` 调静态优先级（-20..19，越高越谦让）；`taskset` 绑 CPU 亲和性；`ulimit`/`prlimit` 管进程资源限制（fd/内存/CPU 时间）；cgroup v2 管一组进程的资源上限/权重（CPU/内存/IO/PIDs）。`nice` 只是调度权重，不能硬限制；要硬上限/分组记账用 cgroup。`chrt` 管实时调度类。
:::

### D9 · `ps`/`top` 字段

`ps aux` 与 `ps -eo` 差在哪？`top` 的 `%CPU`/`RES`/`S` 列是什么？怎样按内存排序？

::: sol D9 核对

`ps aux` 是 BSD 风格（USER/PID/%CPU/%MEM/VSZ/RSS/TTY/STAT/START/TIME/COMMAND）；`ps -eo` 自定义列（`pid,ppid,stat,pcpu,pmem,rss,cmd --sort=-rss`）。`top` 的 `%CPU` 是上次刷新以来的 CPU 占比，`RES` 是常驻内存，`S` 是状态；`top -o %MEM` 或 `ps --sort=-rss` 按内存排序。`top` 的 `load average` 与 `ps` 的 `STAT` 要一起看。
:::

### D10 · 信号处置、阻塞与排队

信号处置有哪几种？阻塞与 pending 是什么？普通信号会排队吗？`sigprocmask`/`sigaction` 做什么？

::: sol D10 核对

处置：默认、忽略、捕获（`sigaction`）。阻塞用信号掩码（`sigprocmask`），被阻塞的信号进入 pending（`sigpending`），解除阻塞后递送。普通（非实时）信号不排队，同类多个可能合并；实时信号排队。`/proc/PID/status` 的 `SigBlk`/`SigPnd`/`SigCgt` 看掩码/未决/捕获。`SIGKILL`/`SIGSTOP` 不能捕获/阻塞。
:::

### D11 · 脚本与实验

进程巡检/信号转发/超时回收脚本各解决什么？进程组/信号掩码/nice/cgroup 实验各验证什么？

::: sol D11 核对

巡检脚本：列出高 CPU/内存/僵尸/D 状态进程；信号转发：把 TERM/INT 转发给子进程并等待；超时回收：启动子进程，超时先 TERM 再 KILL，回收退出码。实验：进程组验证 `Ctrl-C` 发给前台组；信号掩码验证阻塞/ pending；nice 验证权重对 CPU 分配的影响；cgroup 验证 `cpu.max`/`memory.max` 的硬限制。
:::

### D12 · 十四个边界

任选四个进程/信号边界，说出“现象 → 原因 → 修复”。

::: sol D12 核对

示例：① `kill -9` 后服务没清理——KILL 不可捕获，用 TERM + 超时；② 容器里僵尸多——PID 1 不 `wait`，用 `tini`/`--init` 或应用回收；③ load 高 CPU 空闲——进程卡 D 等 I/O，查 `vmstat`/`iostat`；④ 关终端后台任务死——SIGHUP，用 `nohup`/`disown -h`/`setsid`/tmux/systemd；⑤ 进程杀不掉——D 状态等 I/O 或僵尸等父进程 `wait`；⑥ 信号没反应——被阻塞/忽略，查 `/proc/PID/status` 的 `SigBlk`/`SigCgt`。
:::
