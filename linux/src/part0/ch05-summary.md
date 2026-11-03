# 0.5 章末总结

## 六单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、重定向与 fd 表**（0.5.1–0.5.3） | `>`、`2>&1` 改的是哪一格？ | 重定向是让某个 fd 下标指向另一个“打开文件描述”；求值从左到右，`2>&1` 复制的是当时 fd 1 的目标。 | `2>&1 >file` 与 `>file 2>&1` 混用；`>file` 在命令执行前就截断；`ls > less` 覆盖可执行文件。 |
| **二、管道、子 Shell、日志与缓冲**（0.5.4–0.5.7） | 管道连的是什么？变量为什么丢？ | 管道只连 stdout；每段在子 Shell；`tee` 返回自己的状态；stdio 在非 tty 下全缓冲。 | 以为 stderr 会进管道；`while read` 改不了外面变量；`cmd` 后接 `tee log` 时 `$?` 是 `tee` 的；输出“卡住”。 |
| **三、fd 与重定向的全貌**（0.5.8–0.5.10） | `dup2` 复制什么？`O_CLOEXEC` 防什么？ | `dup2` 让新 fd 指向同一个 `struct file`，共享偏移；`O_CLOEXEC` 防止 `fork+exec` 之间泄漏 fd；here-doc/进程替换底层是临时文件或 `/dev/fd`。 | 以为 `dup2` 复制文件内容；以为 `exec` 启动新 Shell；进程替换拿不到子命令退出码。 |
| **四、管道、子 Shell、`tee` 的边界**（0.5.11–0.5.13） | 管道多大？`SIGPIPE` 是 bug 吗？ | 管道默认 64 KiB；单次 `write ≤ PIPE_BUF`（4096）才保证不交错；下游关闭时 `SIGPIPE` 是正常结束，退出码 141；`lastpipe` 只在非交互 + `set +m` 时生效。 | 把 141 当 bug；以为 `pipefail` 能告诉哪段失败；在交互 Shell 里用 `lastpipe`。 |
| **五、特殊 fd 与缓冲**（0.5.14–0.5.15） | `/dev/stdout` 和 `2>&1` 差在哪？ | `/dev/stdout` 是重新 `open` 路径，`2>&1` 是复制 fd；`stdbuf` 只对动态链接、用 stdio 的程序有效；颜色由 `isatty` 决定。 | 用 `/dev/stdout` 替代 `2>&1`；以为 `stdbuf` 万能；把颜色丢失当程序 bug。 |
| **六、实验、脚本与陷阱**（0.5.16–0.5.18） | 怎样把知识变成证据？ | `strace` 能看到 `openat`/`dup2`/`SIGPIPE`；日志包装要取 `PIPESTATUS[0]`；fd 备份要按“先备份、再重定向、最后恢复”的顺序。 | 不检查 `exec` 重定向失败；恢复 fd 时先关备份；脚本里 `set -e` + `pipefail` 让清理逻辑来不及跑。 |

## 一条主线

这一章分两遍。**第一遍先会用**：把 fd 表画出来，用“下标 → 打开文件描述”解释 `2>&1` 的顺序；然后学会用管道、子 Shell、`tee` 和缓冲。**第二遍看内核与边界**：`dup2` 复制的是指向关系，`O_CLOEXEC` 防 fd 泄漏，管道是 64 KiB 的内核缓冲区，`PIPE_BUF` 决定原子写，`SIGPIPE` 是下游关闭的正常信号，`lastpipe` 的生效条件取决于交互模式与 job control。**最后压成能力**：三个 `strace` 实验把结论变成证据，三个脚本把模式变成可复用代码，陷阱清单把事故变成检查项。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| 日志里少了错误行 | 检查 `2>&1` 的位置，或改用 `&>` | stderr 默认不进管道/文件；顺序决定 `dup2` 目标。 |
| 管道退出码总是 0 | `st=("${PIPESTATUS[@]}")`，或 `set -o pipefail` | `$?` 默认只取最后一段；`PIPESTATUS` 才保留每段。 |
| `while read` 后变量是 0 | 改用 `< <(...)` 或 `shopt -s lastpipe` + `set +m` | 管道每段在子 Shell，变量修改不回传。 |
| 日志有内容但退出码是 0 | 取 `PIPESTATUS[0]`，不要看 `tee` 的 `$?` | `tee` 返回自己的状态，不是上游的。 |
| 程序输出到管道后“卡住” | `stdbuf -oL`、`grep --line-buffered`、Python `-u` | stdio 在非 tty 下全缓冲，没攒满不 `write`。 |
| 保存的日志没有颜色 | `--color=always` + `less -R`，或 `FORCE_COLOR` | 程序按 `isatty` 关闭颜色。 |
| 脚本偶尔报 `Bad file descriptor` | 检查 `exec 3>&1` 的备份与恢复顺序 | 先关备份 fd，后面 `1>&3` 就失败。 |
| `2>/dev/stdout` 在容器里失败 | 改用 `2>&1` | `/dev/stdout` 依赖 `/proc`，且是重新 `open`，不是复制 fd。 |
| 管道里 `grep` 收到 141 | 判断是否允许下游提前退出；允许就接受 141 | `SIGPIPE` 是下游关闭的正常信号，不一定是 bug。 |
| fd 越用越少 / `EMFILE` | `ls -l /proc/PID/fd`、`lsof -p PID` | fd 泄漏；检查 `open`/`pipe`/`socket` 的关闭路径。 |

## 能否讲出这八句话

1. 重定向的本质是**让某个 fd 下标指向另一个打开文件描述**；`2>&1` 复制的是“当时”fd 1 的目标，所以顺序敏感。
2. `>file` 在命令执行前就截断；命令失败也会留下空文件；不要用“失败所以没动”做假设。
3. 管道只连 **stdout**；stderr 要进管道必须在上游写 `2>&1` 或 `|&`。
4. 管道每段在**子 Shell**；`while read` 里的变量修改不回传，用 `< <(...)`、`lastpipe` 或命令替换。
5. `tee` 返回自己的状态；要保留上游退出码，取 `PIPESTATUS[0]` 或开 `pipefail`。
6. `SIGPIPE`/141 不一定是 bug；`yes | head` 的正常结束就是 141，`pipefail` 下要显式接受或改设计。
7. `dup2` 让两个 fd 指向同一个 `struct file`，共享偏移；`O_CLOEXEC` 防止 `fork+exec` 之间把 fd 泄漏给新程序。
8. `/dev/stdout` 是重新 `open` 路径，`2>&1` 是复制 fd；容器里 `/proc` 没挂时，前者会失败。

## 学完之后

1. **[闭卷回忆卡](ch05-recall.md)**：先合上正文，把 fd 表、顺序、退出码、缓冲四组结论从空白纸上叫出来。
2. **[习题集](ch05-exercises.md)**：A 组检查概念，B 组诊断脚本 bug，C 组用 `strace` 做实验；错题记记号，三天后只重做记号题。
3. **[学习目标自检表](ch05-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch05-errata.md)**：把版本敏感的事实过一遍，尤其是 `PIPE_BUF`、`lastpipe`、`stdbuf` 的边界。
5. **下一站**：[0.6 正则表达式与 grep/sed/awk](ch06.md) 开始处理管道里的文本；先学会筛选，再谈统计与改写。
