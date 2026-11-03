# 0.2 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 链路与查找

### D1 · 终端、tty、pty、Shell

不看书写出：终端模拟器、pty master、pty slave、行规程、Shell 各在哪一层？它们之间谁连谁？

::: sol D1 核对

终端模拟器在用户态，持有 pty master；pty slave 是内核里的一对虚拟设备的一端，表现得像真实终端；行规程在 pty slave 上，负责回显、行缓冲、把 `Ctrl-C` 翻译成 `SIGINT`、把 `Ctrl-D` 翻译成 EOF；Shell 是跑在 pty slave 上的用户态进程，stdin/stdout 就是 slave。链路：键盘 → 终端模拟器 → pty master → 行规程 → pty slave → Shell → 子进程。
:::

### D2 · 一条命令的六步

从回车到输出，交互式 bash 大致做哪六步？哪一步会 fork？

::: sol D2 核对

① 读取：行规程把整行交给 readline；② 解析：按 `;`、`|`、`&&` 切命令，识别重定向与引号；③ 展开：别名、大括号、波浪号、变量、命令替换、算术、通配符；④ 查找：内建/函数/外部命令，`$PATH` 找文件；⑤ 执行：外部命令 fork 子进程，管道两端各 fork，`dup2` 接 fd，`execve`；⑥ 等待：父 Shell `wait4`，设置 `$?`。内建命令不 fork。
:::

### D3 · 查找顺序

bash 查找一个名字的顺序是什么？为什么 `alias` 在脚本里不生效？`command -v` 与 `which` 差在哪？

::: sol D3 核对

顺序：alias → 函数 → 内建 → 哈希表 → `$PATH`。非交互 Shell 默认不展开 alias；脚本里除非 `shopt -s expand_aliases`，否则不生效。`command -v` 是 Shell 内建，认别名/函数/内建，适合脚本判断；`which` 是外部程序，通常只查 `$PATH`，不认别名与函数，不同实现行为不一致。
:::

### D4 · 启动文件四象限

bash 的启动文件由哪两个维度决定？`ssh host cmd` 与 `ssh host` 分别读哪些文件？

::: sol D4 核对

两个维度：是不是登录 Shell、是不是交互式。`ssh host` 是登录 + 交互，读 `/etc/profile` → `~/.bash_profile`/`~/.bash_login`/`~/.profile`；`ssh host cmd` 是非登录 + 非交互，不读启动文件，只看 `BASH_ENV`。打开终端窗口是非登录 + 交互，读 `/etc/bash.bashrc` → `~/.bashrc`。
:::

### D5 · 历史与 readline

`!!`、`!$`、`Ctrl-R`、`Alt-.` 各做什么？为什么 `Ctrl-S` 有时像卡住？

::: sol D5 核对

`!!` 展开上一条命令；`!$` 取上一条命令最后一个参数；`Ctrl-R` 反向增量搜索历史；`Alt-.` 插入上一条命令的最后一个参数。`Ctrl-S` 默认被终端流控 `ixon` 吃掉，看起来像卡住；按 `Ctrl-Q` 恢复，或 `stty -ixon` 关掉流控。
:::

## B. 工作台与终端行为

### D6 · 作业控制与 SIGHUP

`Ctrl-Z`、`jobs`、`fg`、`bg`、`disown -h`、`nohup` 各做什么？关终端后后台任务一定会死吗？

::: sol D6 核对

`Ctrl-Z` 发 `SIGTSTP` 挂起前台作业；`jobs -l` 列出作业；`fg %1` 放前台；`bg %1` 后台继续；`disown -h %1` 只标记“Shell 退出时不发 SIGHUP”，作业仍在作业表；`nohup cmd &` 让进程忽略 SIGHUP 并把输出写到 `nohup.out`。关终端时登录 Shell 默认向作业发 SIGHUP，所以不加保护通常会死；tmux/systemd 里的进程不属于当前终端会话，能继续。
:::

### D7 · vim 生存集

vim 有哪三种模式？打开、保存、退出、放弃修改、查找替换、撤销各用什么？

::: sol D7 核对

普通模式（`Esc`）、插入模式（`i`/`a`/`o`）、命令行模式（`:`）。打开 `vim file`；保存 `:w`；退出 `:q`；保存退出 `:wq`/`:x`/`ZZ`；放弃 `:q!`；查找 `/pattern`、`n`/`N`；替换 `:%s/old/new/g`、`:%s/old/new/gc`；撤销 `u`、重做 `Ctrl-R`。权限不够用 `:w !sudo tee %`。
:::

### D8 · vim 语法

vim 的“操作符 + 动作/文本对象”是什么意思？`ciw`、`ci"`、`dap`、`:%norm A;` 各做什么？

::: sol D8 核对

操作符（`d` 删除、`c` 修改、`y` 复制）可以接动作（`w`、`$`、`j`）或文本对象（`iw`、`a"`、`it`、`ap`）。`ciw` 改当前词；`ci"` 改双引号内字符串；`dap` 删整段；`:%norm A;` 对每一行执行普通模式 `A;`（行尾加分号）。文本对象让“选到哪里”不依赖光标位置。
:::

### D9 · tmux

tmux 的 session/window/pane 是什么关系？`new -d`、`send-keys`、`capture-pane`、`pipe-pane` 各做什么？

::: sol D9 核对

一个 session 包含多个 window，一个 window 可切分多个 pane；Shell 跑在 pane 里，与终端窗口解耦。`tmux new -d -s work -c "$PWD"` 创建分离会话；`send-keys -t work:1.0 'cmd' C-m` 向指定 pane 发送按键并回车；`capture-pane -p -S -200` 抓当前屏幕往前 200 行；`pipe-pane -o 'cat >> log'` 把后续输出持续写到文件。tmux 扛 SSH 断线，不扛机器重启。
:::

### D10 · termios 与 stty

`stty -a` 里的 `icanon`、`isig`、`echo`、`ixon` 各控制什么？vim/less 为什么要改这些标志？

::: sol D10 核对

`icanon` 控制行缓冲：开着时 `read` 等整行，关掉后按 `min`/`time` 逐字节返回；`isig` 控制 `intr`/`quit`/`susp` 是否变成信号；`echo` 控制是否回显；`ixon` 控制 `Ctrl-S`/`Ctrl-Q` 流控。vim、less、top 需要逐键响应，所以切到 raw 模式，关闭 `icanon`、`echo`、`isig`、`opost` 等；退出时用 `stty -g` 保存的现场恢复。
:::

### D11 · 查文档

面对一个陌生命令，按什么顺序查？`man -w`、`man -a`、`man 2`、`man 3` 各做什么？

::: sol D11 核对

顺序：Shell 内建 `help` → `cmd --help` → `man` → `info` → `/usr/share/doc/<pkg>/` → 源码/上游。`man -w name` 只打印路径，确认查到哪一页；`man -a name` 依次显示所有同名页；`man 2` 看系统调用，`man 3` 看 C 库；`man 5` 看文件格式。`man -w printf` 可能命中 `printf(1)`，要看 C 库就显式 `man 3 printf`。
:::

### D12 · 终端陷阱

任选三个终端陷阱，说出“现象 → 原因 → 修复”。

::: sol D12 核对

示例：① 终端像卡死——`Ctrl-S` 被 `ixon` 流控，按 `Ctrl-Q` 或 `stty -ixon`；② 脚本崩后不回显——`stty -echo` 没恢复，盲打 `stty sane` 或 `reset`，脚本里先 `trap 'stty "$saved"' EXIT`；③ 粘贴多行提前执行——没有 bracketed paste，readline 把换行当执行，升级 bash 5.1+ 并开启 `enable-bracketed-paste on`，vim 里用 `:set paste`；④ vim 提示 swap file——用 `vim -r file` 恢复，不要直接删 `.swp`；⑤ tmux 里 Esc 延迟——`set -g escape-time 10`。
:::
