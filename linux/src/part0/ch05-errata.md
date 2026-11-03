# 0.5 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与跨层误判。正文里的 `errata` 盒讲理解陷阱；这一页讲**换 shell、换内核、换文件系统后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、glibc 2.39、bash 5.2。换环境时逐条复核。

## 1. 重定向与 fd

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `2>&1 >file` 与 `>file 2>&1` 一样 | 顺序不同，`dup2` 目标不同；前者 stderr 留终端 | `strace -e openat,dup2 bash -c '...'` |
| 2 | 命令失败，输出文件不会动 | `>file` 在命令执行前就截断；失败也留下空文件 | `ls /nonexistent > out; ls -l out` |
| 3 | `> list 2> list` 是合并 | 两次独立 `open` 各自截断、各自偏移，输出会交错/覆盖 | 用 `> list 2>&1` 或 `&>` |
| 4 | `2>/dev/null` 与 `2>&-` 一样 | 前者写成功但丢弃；后者关闭 fd，后续写返回 `EBADF` | 对同一命令分别重定向，看程序是否报错 |
| 5 | `/dev/stdout` 就是 fd 1 的别名 | 它重新 `open` `/proc/self/fd/1`；`2>&1` 才是复制 fd | `ls -l /dev/stdout`、`readlink -f /dev/stdout` |
| 6 | `exec` 会启动新 Shell | `exec` 替换当前 Shell 的命令或只改 fd 表；`exec 3>file` 一直有效 | `exec 3>f; echo x >&3; exec 3>&-` |

## 2. 管道、子 Shell 与 `tee`

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | 管道会把 stderr 也传给下游 | 管道只连 stdout；要合并必须在上游写 `2>&1`，或用 bash 的管道简写 | `find / -name x 2>/dev/null` 后接管道 `grep x` |
| 8 | 管道每段在当前 Shell | 每段在子 Shell，变量修改不回传 | `n=0; printf 'a\n'` 后接管道 `while read l; do n=1; done`，再 `echo $n` |
| 9 | `cmd` 后接 `tee log` 时 `$?` 是 `cmd` 的 | 是 `tee` 的；用 `PIPESTATUS[0]` 或 `pipefail` | `false` 后接 `tee /dev/null`，再 `echo $?` |
| 10 | `PIPESTATUS` 可以稍后再看 | 下一条命令后就覆盖；必须立刻赋值 | `false` 后接 `true`，再 `echo "${PIPESTATUS[@]}"` |
| 11 | `SIGPIPE`/141 是 bug | 下游正常关闭的信号；`yes` 接 `head` 的正常结束就是 141 | 看 `PIPESTATUS[0]` 是否为 141 |
| 12 | `lastpipe` 在任何 Shell 都生效 | 只在非交互 + job control 关闭（`set +m`）时生效 | `shopt -s lastpipe; set +m; ...` vs 交互式 |

## 3. 内核语义与缓冲

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 13 | 管道缓冲区是无限的 | Linux 默认 64 KiB（16 页），写满会阻塞 | `cat /proc/sys/fs/pipe-max-size`；C/Python `F_GETPIPE_SZ` |
| 14 | 只要写管道就是原子的 | 只有单次 `write ≤ PIPE_BUF`（Linux 4096）才保证不交错 | `getconf PIPE_BUF /` 或 `fpathconf` |
| 15 | `dup2` 会复制文件内容 | 只复制指向关系；两个 fd 共享 `struct file` 与偏移 | `exec 3<file; cat <&3; cat <&3` 看第二次是否还有内容 |
| 16 | `O_CLOEXEC` 只是可选优化 | 它防 `fork+exec` 之间的 fd 泄漏；多线程程序里是正确性问题 | `open(..., O_CLOEXEC)` 后 `exec`，子进程 `/proc/self/fd` 看不到 |
| 17 | `stdbuf` 对所有程序有效 | 只对动态链接、使用 stdio 的程序；静态/setuid/直接 `write` 无效 | 对静态程序跑 `stdbuf -oL`，观察输出是否仍全缓冲 |
| 18 | stderr 永远无缓冲 | C stdio 默认无缓冲，但程序可 `setvbuf` 改；Shell 的 `echo >&2` 走 `write` | 程序里 `setvbuf(stderr, ...)` 后观察 |

## 4. 本章未实测项

以下结论来自文档与源码，但未在本书写作环境逐条复跑；在别的发行版/内核上使用前先验证：

- `PIPE_BUF` 在 Linux 上是 4096，但 POSIX 只要求至少 512；其他 Unix 可能不同。
- 管道默认容量 64 KiB 是 Linux 常见值；内核版本、`pipe-max-size`、容器运行时可能改变它。
- `lastpipe` 的行为依赖 bash 版本与 job control 状态；`dash`/`zsh` 没有同名选项。
- `stdbuf` 依赖 `libstdbuf.so` 与 `LD_PRELOAD`；在 setuid/静态/容器安全配置下可能失效。
- `script`、`unbuffer`、`stdbuf` 的具体输出随发行版和工具版本变化，正文只保证语义方向。

## 5. 发现新问题怎么记

如果你在别的 shell/内核上发现本章结论不成立，按「现象 → 命令/输出 → shell 与内核版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
