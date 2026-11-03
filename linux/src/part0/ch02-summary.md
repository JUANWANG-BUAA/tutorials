# 0.2 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、先看清链路**（0.2.1–0.2.4） | 终端、Shell、命令是什么关系？ | 终端模拟器持有 pty master，Shell 跑在 pty slave 上；行规程负责回显、行缓冲、`Ctrl-C`→`SIGINT`、`Ctrl-D`→EOF。命令查找顺序是 alias → 函数 → 内建 → 哈希 → `$PATH`；启动文件由“登录/交互”两个维度决定。 | 把终端当 Shell；以为 alias 在脚本里生效；以为 `ssh host cmd` 会读 `.bashrc`；`Ctrl-Z` 当结束。 |
| **二、工作台**（0.2.5–0.2.8） | 怎样少打字、不丢现场？ | `$PS1` 控制提示符；历史展开与 `Ctrl-R` 是提效大头；作业控制用 `jobs`/`fg`/`bg`；vim 改文件、tmux 保现场。 | `\[ \]` 漏写导致换行错位；关终端后后台任务被 `SIGHUP`；vim 里不会退出；tmux 只会 `Ctrl-B d`。 |
| **三、再往下一层**（0.2.9–0.2.10） | 为什么同一程序在不同环境行为不同？ | 行规程由 termios 控制，`stty` 是它的命令行；`icanon`/`isig`/`echo` 决定行缓冲、信号键与回显。readline 负责光标、删除、历史、补全。 | 把 `Ctrl-C` 当永远发 `SIGINT`；`stty -echo` 没恢复；`Ctrl-S` 被流控吃掉；粘贴多行提前执行。 |
| **四、工具语法**（0.2.11–0.2.13） | 怎样把 vim/tmux/文档用成组合？ | vim 命令 = 操作符 + 动作/文本对象，宏是按键录制；tmux 可以脚本化布局、发送按键、抓取输出；查文档按 `help → --help → man → info → /usr/share/doc`。 | 把 vim 当快捷键表背；宏录进错误按键；`send-keys` 忘了 `C-m`；`man -w printf` 查到 `printf(1)` 就以为没有 `printf(3)`。 |
| **五、收口**（0.2.14–0.2.15） | 最容易踩的坑是什么？ | 终端坑集中在行规程、启动文件、作业控制、vim 恢复与 tmux 环境。 | 见 0.2.14 的八条；每条都有“现象 → 原因 → 修复”。 |

## 一条主线

这一章只做一件事：把“你面对的终端窗口”拆成可指认的层。**先分清终端模拟器、pty、行规程、Shell**，你就知道终端卡死、Shell 配置错、程序失败是三件事；**再看命令从回车到输出的六步**，你就知道 `alias` 为什么不进脚本、内建命令为什么不 fork；**然后用历史、readline、作业控制、vim、tmux 搭工作台**，把“敲命令”变成可持续的现场；**最后回到 termios 与编辑语法**，解释为什么同一个程序在 SSH、tmux、管道里行为不同。整章的落点不是背命令，而是出问题时能定位到“哪一层”。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| 终端像卡死，按键没反应 | 先按 `Ctrl-Q`；再 `stty sane` 或 `reset` | 可能是 `Ctrl-S` 流控或 `stty -echo` 没恢复；不一定是 Shell 死了。 |
| 脚本里 alias 不生效 | 改用函数或完整命令 | 非交互 Shell 默认不展开 alias。 |
| `ssh host cmd` 的 `PATH` 不对 | 在命令里显式 `source` 或写绝对路径 | 非交互非登录 Shell 不读 `.profile`/`.bashrc`。 |
| 关终端后后台任务没了 | 用 `nohup`、`disown -h`、tmux 或 systemd | 登录 Shell 退出会向作业发 `SIGHUP`。 |
| `Ctrl-C` 在 vim 里不退出 | 先 `Esc`，再 `:q!`/`ZZ` | vim 把终端切到 raw 模式，`Ctrl-C` 只是字节。 |
| vim 提示 swap file 已存在 | `vim -r file` 恢复，确认后再删 `.swp` | 另一个会话在编辑，或上次崩溃；直接删可能丢修改。 |
| tmux 里 vim 的 `Esc` 有延迟 | `set -g escape-time 10` | tmux 在等组合键，默认等待时间偏大。 |
| tmux 里颜色/按键错乱 | 检查 `TERM` 与 `default-terminal` | 远端 terminfo 与终端能力不匹配。 |
| `man xxx` 说没有条目 | `help`/`--help`/`apt install man-db`/`sudo mandb` | 可能是内建命令、包没装 man page，或索引过期。 |
| 粘贴多行命令提前执行 | 开启 bracketed paste，或 vim `:set paste` | readline 把换行当执行。 |

## 能否讲出这八句话

1. 终端模拟器不是 Shell；它持有 pty master，Shell 跑在 pty slave 上，中间隔着内核的行规程。
2. `Ctrl-C` 是行规程把字节 `0x03` 翻译成 `SIGINT`；raw 模式下它只是字节，由程序自己解释。
3. `Ctrl-D` 不是“关闭终端”，是行规程在缓冲区为空时让 `read` 返回 0。
4. bash 查找命令的顺序是 alias → 函数 → 内建 → 哈希 → `$PATH`；`alias` 默认只在交互 Shell 展开。
5. 启动文件由“登录/交互”两个维度决定；`ssh host cmd` 是非交互非登录 Shell，不读 `.bashrc`/`.profile`。
6. 作业控制只管当前 Shell 的作业；关终端默认发 `SIGHUP`，`nohup`/`disown -h`/tmux 解决的是不同层次的问题。
7. vim 的核心语法是“操作符 + 动作/文本对象”；宏是按键录制，`:g/pat/norm` 更适合规则明确的批量编辑。
8. 查文档的顺序是 `help → --help → man → info → /usr/share/doc`；系统调用要显式 `man 2`，C 库要 `man 3`。

## 学完之后

1. **[闭卷回忆卡](ch02-recall.md)**：先合上正文，把 pty 链路、查找顺序、启动文件、作业控制、termios 五组结论从空白纸上叫出来。
2. **[习题集](ch02-exercises.md)**：A 组检查概念，B 组诊断“为什么我的终端/别名/作业不工作”，C 组做 tty、strace、vim、tmux 实验。
3. **[学习目标自检表](ch02-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch02-errata.md)**：把 bash 版本、`stty` 标志、tmux `escape-time` 等版本敏感事实过一遍。
5. **下一站**：[0.3 文件系统导航与文件操作](ch03.md) 进入目录树与 inode；本章的 `cd`、`ls`、`find` 会在那里得到解释。
