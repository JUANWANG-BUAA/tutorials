# 0.2 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与终端陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换 bash、换终端、换 tmux、换发行版后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、bash 5.2、tmux 3.4、vim 9.1。换环境时逐条复核。

## 1. 终端与 Shell

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | 终端就是 Shell | 终端模拟器持有 pty master；Shell 跑在 pty slave 上 | `tty`、`ps -o tty,cmd -p $$`、`readlink -f /proc/$$/fd/0` |
| 2 | `Ctrl-C` 永远发 `SIGINT` | raw 模式下它只是字节 `0x03`；`isig` 关掉后由程序解释 | `stty -a`、在 vim 插入模式按 `Ctrl-C` |
| 3 | `Ctrl-D` 是关闭终端 | 行规程的 `eof` 字符；行首让 `read` 返回 0 | `stty -a` 的 `eof = ^D`；`read` 循环 |
| 4 | `Ctrl-Z` 是结束进程 | 发 `SIGTSTP` 挂起；进程仍在，占 PID 与内存 | `jobs`、`ps -o stat` |
| 5 | `Ctrl-S` 让终端卡死 | `ixon` 流控暂停输出；`Ctrl-Q` 恢复 | `stty -a` 的 `ixon`；`Ctrl-Q` |
| 6 | `stty -echo` 只影响当前命令 | 它改终端设备状态；异常退出不恢复，整个终端不回显 | 脚本里 `stty -echo` 后 `kill -9`，再敲字 |

## 2. Shell 与启动文件

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | alias 写进 `.bashrc`，脚本也能用 | 非交互 Shell 默认不展开 alias | 脚本里 `type ll`；`shopt -s expand_aliases` 后再试 |
| 8 | `ssh host cmd` 和登录后执行一样 | 非交互非登录 Shell，不读 `.bashrc`/`.profile` | `ssh host 'echo $PATH; type ll'` |
| 9 | cron 会读 `.bashrc` | cron 不启动交互 Shell；要显式设置 `PATH`/`source` | `crontab -e` 里加 `env > /tmp/cron.env` 对比 |
| 10 | `which` 是判断命令的标准工具 | `which` 是外部程序，不认别名/函数，行为因发行版而异 | `type -a ls`、`command -v ls`、`which ls` 对比 |
| 11 | `.` 放进 `PATH` 很方便 | 在不受控目录执行同名命令会中招；空路径分量也等于当前目录 | `echo "$PATH"`、`type -a ls` |

## 3. vim、tmux 与文档

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 12 | vim 提示 swap file，直接删 `.swp` 就行 | 可能另一个会话在编辑，或上次崩溃；先 `vim -r file` 恢复 | `vim -r file`、`:recover` |
| 13 | `:w !sudo tee %` 保存后就能继续 `:w` | vim 仍认为文件只读；要 `:e!` 重新加载 | 保存后 `:e!`，再 `:w` |
| 14 | tmux 会话能扛机器重启 | 只扛 SSH 断线与终端关闭；重启后会话全丢 | 重启后 `tmux ls` |
| 15 | `send-keys` 等于执行命令 | 只是把按键送进 pane；要加 `C-m` 才会回车执行 | `tmux send-keys -t s:0.0 'date'` 后看 pane |
| 16 | `capture-pane` 能抓全部历史 | 默认只有当前屏幕；历史深度受 `history-limit` 限制 | `tmux capture-pane -p -S -200` |
| 17 | tmux 里 Esc 延迟是 vim 的锅 | tmux 在等组合键；`set -g escape-time 10` | 改配置后对比 |
| 18 | `man xxx` 没有就是没文档 | 可能是内建命令、包没装 man page、`mandb` 索引过期 | `help xxx`、`apt install man-db`、`sudo mandb`、`man -w xxx` |
| 19 | `man -w printf` 就是 `printf(3)` | 默认区号顺序先命中 `printf(1)`；要显式 `man 3 printf` | `man -w printf`、`man -w 3 printf` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的终端/tmux/vim 版本上使用前先验证：

- `enable-bracketed-paste` 需要 bash 5.1+ 与终端支持；老终端或 `screen` 可能退化。
- `stty -a` 的具体字段名与默认值随 Unix 实现变化；macOS 与 Linux 不完全一样。
- tmux 的 `default-terminal`、`escape-time`、`history-limit` 默认值随版本变化；以 `tmux show-options -g` 为准。
- vim 的 `+clipboard`、`+terminal` 等编译特性因发行版而异；`vim --version` 查看。
- `ssh host cmd` 是否读 `BASH_ENV` 取决于 sshd 配置与远端 shell；不要假设一定读。

## 5. 发现新问题怎么记

如果你在别的终端/tmux/vim 版本上发现本章结论不成立，按「现象 → 命令/输出 → 终端与版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
