# 0.2 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 终端、Shell 与 pty

“终端”“Shell”“pty”各是什么？为什么说“终端卡死”时 Shell 可能还活着？

::: sol 解答

终端模拟器是用户态 GUI 程序（GNOME Terminal、iTerm2），负责渲染与按键；pty 是内核里的一对虚拟设备，master 端由模拟器持有，slave 端给 Shell 与程序；Shell 是跑在 pty slave 上的用户态进程。终端模拟器卡死时，Slave 与 Shell 可能仍在运行，只是没有程序在读写 master；所以“终端卡死”不等于“Shell 死了”。

:::
:::

::: ex A2 · 一条命令的六步

从回车到输出，交互式 bash 大致做哪六步？哪一步会 fork？内建命令为什么不 fork？

::: sol 解答

① 读取（行规程 → readline）；② 解析（`;`、管道、重定向、引号）；③ 展开（别名、变量、通配符、命令替换）；④ 查找（内建/函数/外部命令、`$PATH`）；⑤ 执行（外部命令 fork + `execve`，管道两端各 fork）；⑥ 等待（`wait4`，设置 `$?`）。内建命令（`cd`、`export`、`umask`、`read`）必须改变当前 Shell 的状态，所以由 Shell 自己执行，不 fork。

:::
:::

::: ex A3 · alias 与脚本

为什么 `alias ll='ls -alF'` 写在 `~/.bashrc` 里，脚本却用不了？脚本里应该怎么写？

::: sol 解答

非交互 Shell 默认不展开别名；`~/.bashrc` 通常只在交互 Shell 读取。脚本里用函数、完整命令或绝对路径；如果确实要别名，需 `shopt -s expand_aliases` 并确保别名已定义，但不建议在脚本里依赖交互配置。

:::
:::

::: ex A4 · 启动文件四象限

`ssh host`、`ssh host cmd`、打开终端窗口、cron 任务分别属于哪种 Shell？各读哪些启动文件？

::: sol 解答

`ssh host`：登录 + 交互，读 `/etc/profile` → `~/.bash_profile`/`~/.bash_login`/`~/.profile`；`ssh host cmd`：非登录 + 非交互，不读启动文件，只看 `BASH_ENV`；打开终端窗口：非登录 + 交互，读 `/etc/bash.bashrc` → `~/.bashrc`；cron：非登录 + 非交互，不读启动文件。所以 cron 里要显式设置 `PATH` 或 `source` 环境文件。

:::
:::

::: ex A5 · 作业控制与 SIGHUP

`Ctrl-Z`、`jobs`、`fg`、`bg`、`disown -h`、`nohup` 各做什么？关终端后后台任务会发生什么？

::: sol 解答

`Ctrl-Z` 发 `SIGTSTP` 挂起前台作业；`jobs -l` 列出作业；`fg %1` 放前台；`bg %1` 后台继续；`disown -h %1` 只标记“Shell 退出时不发 SIGHUP”，作业仍在作业表；`nohup cmd &` 让进程忽略 SIGHUP 并把输出写到 `nohup.out`。关终端时登录 Shell 默认向作业发 SIGHUP，所以不加保护的后台任务通常会死；tmux/systemd 里的进程不属于当前终端会话，能继续。

:::
:::

::: ex A6 · termios 标志

`stty -a` 里的 `icanon`、`isig`、`echo`、`ixon` 各控制什么？各举一个受影响的程序行为。

::: sol 解答

`icanon` 控制行缓冲：开着时 `read` 等整行，关掉后按 `min`/`time` 逐字节返回（vim/less 需要）；`isig` 控制 `intr`/`quit`/`susp` 是否变成信号（`Ctrl-C` 是否发 `SIGINT`）；`echo` 控制是否回显（读密码时关）；`ixon` 控制 `Ctrl-S`/`Ctrl-Q` 流控（关掉后 `Ctrl-S` 可用于前向搜索）。这些是行规程参数，不是 Shell 的魔法。

:::
:::

::: ex A7 · vim 文本对象

`ciw`、`ci"`、`dap`、`dit`、`:%norm A;` 各做什么？为什么文本对象比“按方向键选”稳？

::: sol 解答

`ciw` 改当前词；`ci"` 改双引号内字符串；`dap` 删整段；`dit` 删标签内文本；`:%norm A;` 对每一行执行普通模式 `A;`（行尾加分号）。文本对象以 `i`（inner）或 `a`（around）描述“范围”，不依赖光标当前位置；`di"` 在行内任何位置都能删引号内内容，按方向键选则要先数位置。

:::
:::

::: ex A8 · 查文档

面对一个陌生命令，按什么顺序查？`man -w`、`man -a`、`man 2`、`man 3` 各做什么？`man -w printf` 命中 `printf(1)` 怎么办？

::: sol 解答

顺序：`help`（内建）→ `cmd --help` → `man` → `info` → `/usr/share/doc/包名/` → 源码/上游。`man -w` 只打印路径；`man -a` 依次显示所有同名页；`man 2` 看系统调用；`man 3` 看 C 库。`man -w printf` 可能命中 `printf(1)`；要看 C 库就显式 `man 3 printf`，不要依赖默认区号顺序。

:::
:::

## B 组 · 诊断推理

::: ex B1 · `ssh host 'll'` 找不到命令

你在 `~/.bashrc` 里定义了 `alias ll='ls -alF'`，本地能用；`ssh host 'll'` 报 `ll: command not found`。解释原因，给出两种修复，并说明哪种适合生产脚本。

::: sol 解答

`ssh host 'll'` 启动非登录 + 非交互 Shell，不读 `~/.bashrc`，也不展开别名。修复：① 命令里写完整命令 `ls -alF`；② 把逻辑写成脚本或函数，用绝对路径调用；③ 临时 `ssh host 'source ~/.bashrc; ll'` 只适合交互调试，不适合生产。生产脚本应显式设置环境、用完整命令或包装脚本，不依赖交互配置。

:::
:::

::: ex B2 · 关终端后任务还在吗

`sleep 300 &` 后关闭终端，进程还会在吗？换成 `nohup sleep 300 &` 呢？放进 tmux 呢？三种方式各解决什么问题？

::: sol 解答

直接 `sleep 300 &`：登录 Shell 退出时向作业发 SIGHUP，进程通常被终止。`nohup`：让进程忽略 SIGHUP，stdout 重定向到 `nohup.out`，进程继续，但不可恢复现场、不会自动重启。tmux：Shell 跑在 tmux 会话里，与当前终端解耦，关终端不影响，重新 `attach` 能看到现场；机器重启仍会丢，需要 systemd 或持久化任务队列。

:::
:::

::: ex B3 · `Ctrl-C` 在 vim 里不退出

为什么 `Ctrl-C` 能终止前台 `sleep`，却常常不能退出 vim 的插入模式？这与 pty 的哪一层有关？

::: sol 解答

`Ctrl-C` 由行规程识别为 `intr` 字符，向前台进程组发 `SIGINT`。vim 进入全屏/插入时要逐键响应，把终端切到 raw 模式，关闭 `isig` 等行规程处理；此时 `Ctrl-C` 只是字节 `0x03`，由 vim 自己解释。要退出先按 `Esc` 回普通模式，再 `:q!` 或 `ZZ`。

:::
:::

::: ex B4 · 脚本崩了，终端不回显

一个脚本执行 `stty -echo` 读密码，被 `Ctrl-C` 打断后终端一直不回显。解释原因，给出应急恢复与脚本修复。

::: sol 解答

`stty -echo` 改的是终端设备状态，不是当前命令的局部状态；脚本异常退出没恢复，整个终端都不回显。应急：盲打 `stty sane` 回车，或 `reset`。脚本修复：在 `stty -echo` **之前**保存现场并安装 trap：

```bash
saved=$(stty -g)
trap 'stty "$saved"' EXIT INT TERM
stty -echo
IFS= read -r token
stty "$saved"
trap - EXIT INT TERM
```

trap 必须在关闭回显之前安装，否则 Ctrl-C 时来不及恢复。

:::
:::

::: ex B5 · tmux 里 Esc 延迟、颜色错乱

tmux 里 vim 按 `Esc` 有明显延迟；SSH 进 tmux 后颜色/按键也错乱。各是什么原因？怎么修？

::: sol 解答

`Esc` 延迟：tmux 要等待一段时间判断你按的是 `Esc` 还是以 `Esc` 开头的组合键；在 `~/.tmux.conf` 设 `set -g escape-time 10`（毫秒）。颜色/按键错乱：`TERM` 与远端 terminfo 不匹配；设 `set -g default-terminal "screen-256color"` 或 `tmux-256color`，确认远端有对应 terminfo 条目，必要时 `infocmp`/`toe` 检查。

:::
:::

::: ex B6 · `man -w printf` 查到错页

`man -w printf` 返回 `/usr/share/man/man1/printf.1.gz`，但你想看 C 库的 `printf(3)`。为什么？给出三种查法。

::: sol 解答

`man -w` 只报告默认搜索顺序里的第一个命中；`MANSECT` 决定区号顺序，`printf` 先命中命令页 `printf(1)`。查法：① `man 3 printf` 显式区号；② `man -a printf` 依次看所有同名页；③ `man -w 3 printf` 确认目标路径。脚本里最可靠的是显式区号，不依赖 `MANSECT`。

:::
:::

## C 组 · 动手实验

::: ex C1 · 验证 tty 链路

用 `tty`、`ps`、`/proc/$$/fd/0` 证明当前 Shell 的 stdin 是 pty slave；再用 `script` 或 `ssh` 观察一层 pty。

::: sol 解答

```bash
tty
ps -o pid,ppid,tty,stat,cmd -p $$
readlink -f /proc/$$/fd/0
```

典型输出：`/dev/pts/0`；`TTY=pts/0`；`/proc/PID/fd/0 -> /dev/pts/0`。`tty` 显示 slave 路径，`ps` 的 `TTY` 列显示缩写，`/proc` 的 fd 链接证明 stdin 指向同一个 slave。`script -qec 'tty' /dev/null` 会再分配一层 pty；SSH 登录则在远端分配 pty，本地终端与远端 pty 之间由 sshd 转发。

:::
:::

::: ex C2 · 用 `strace` 看命令六步

运行 `strace -f -e trace=clone,execve,wait4 bash -c 'grep -n root /etc/passwd | head -3'`，指出 `clone`、`execve`、`wait4` 各对应哪一步。

::: sol 解答

管道两端各有一个 `clone`（创建子进程），随后各有 `execve`（`grep` 与 `head`），父 Shell 用 `wait4` 等待。`clone` 对应“执行”阶段的 fork，`execve` 对应装入程序，`wait4` 对应“等待”阶段。输出里通常能看到两次 `clone`、两次 `execve`、一次或多次 `wait4`；这证明“管道不是一个命令，而是两个进程加一个内核缓冲区”。

:::
:::

::: ex C3 · readline 键位练习

在新终端里完成：把 `echo /etc/nginx /var/log/nginx /usr/share/nginx` 改成只保留 `/var/log/nginx`；用 `Ctrl-Y` 粘回删除内容；用 `Alt-.` 复用上一条命令的最后一个参数。

::: sol 解答

操作序列示例：输入整行后，`Alt-B` 跳到 `/usr/share/nginx` 前，`Ctrl-K` 删到行尾；再 `Alt-B` 到 `/etc/nginx` 前，`Ctrl-W` 删词；剩下 `/var/log/nginx`。删除的内容进入 kill ring，`Ctrl-Y` 粘回最近一次删除，连续 `Alt-Y` 轮换更早内容。`ls -lh /var/log/syslog` 后按 `Alt-.` 插入 `/var/log/syslog`。验收：全程不碰方向键，能解释 `Ctrl-W` 与 `Alt-Backspace` 分词规则不同。

:::
:::

::: ex C4 · vim 宏与批量编辑

生成 20 行 `item1`…`item20`，用宏给每行加 `;`；再撤销，改用 `:%norm A;` 一次完成。比较两种做法。

::: sol 解答

```bash
seq 1 20 | sed 's/^/item/' > /tmp/items.txt
vim /tmp/items.txt
```

宏：`qa` 开始录制，`A;`、`Esc`、`j`，`q` 结束；`19@a` 处理剩余行；`:wq`。验收 `grep -c ';$' /tmp/items.txt` 输出 20。撤销后用 `:%norm A;` 一次完成。宏适合“按键序列包含判断/移动”的场景；`:g/pat/norm` 或 `:%norm` 适合规则明确的批量编辑，更稳、更易读。

:::
:::

::: ex C5 · tmux 脚本化布局

写一个脚本，创建一个 1 窗口 3 pane 的 tmux 会话：左边 vim，右上循环打印时间，右下 `tail -f /var/log/syslog`；再用 `capture-pane` 抓取右上最近 20 行。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
s=${1:-dev}
tmux new-session -d -s "$s" -n edit
tmux split-window -h -t "$s:edit"
tmux split-window -v -t "$s:edit.1"
tmux select-layout -t "$s:edit" main-vertical
tmux send-keys -t "$s:edit.0" 'vim .' C-m
tmux send-keys -t "$s:edit.1" 'while :; do clear; date; sleep 2; done' C-m
tmux send-keys -t "$s:edit.2" 'tail -f /var/log/syslog' C-m
tmux capture-pane -p -t "$s:edit.1" -S -20 > /tmp/clock.txt
```

关键点：`-d` 不抢占当前终端；`send-keys` 要加 `C-m` 才会执行；`capture-pane` 抓当前屏幕缓冲区，`-S -20` 往前 20 行；`pipe-pane` 可把后续输出持续写到文件。tmux 扛 SSH 断线，不扛机器重启。

:::
:::
