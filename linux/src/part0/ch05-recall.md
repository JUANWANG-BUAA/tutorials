# 0.5 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · 三个 fd

进程启动时默认有哪三个 fd？重定向的本质是什么？用一句话解释 `>file`。

::: sol D1 核对

0 标准输入、1 标准输出、2 标准错误。重定向的本质是**让某个 fd 下标指向另一个打开文件描述**。`>file` = 打开 file 得到新 fd，把它复制到 1，关闭旧 1。`2>&1` 复制的是「当时」fd 1 的目标，不是数字 1。
:::

### D2 · 重定向顺序

`cmd >out 2>&1` 与 `cmd 2>&1 >out` 的 stderr 分别去哪？为什么？

::: sol D2 核对

`>out 2>&1`：先把 fd 1 指向 out，再让 fd 2 复制 fd 1，stderr 进 out。`2>&1 >out`：先把 fd 2 复制到 fd 1 当前目标（终端），再把 fd 1 改成 out，stderr 留在终端。关键是 `2>&1` 复制的是当时 fd 1 的指向。
:::

### D3 · here-doc 的安全默认

`<<'EOF'` 与 `<<EOF` 差在哪？写配置、传密码时应该用哪种？为什么？

::: sol D3 核对

`<<'EOF'` 引号包围定界符，正文不做参数展开、命令替换、算术展开；`<<EOF` 会展开 `$VAR`、`$(cmd)`、反引号和 `\`。写配置、传密码时**默认加引号**；不加引号时，正文里的 `$()` 会执行任意命令，正文来自用户输入就是命令注入。
:::

### D4 · 管道与退出码

`false | true` 的 `$?` 是多少？`PIPESTATUS` 里是什么？开了 `pipefail` 后呢？

::: sol D4 核对

`$?` 是 0，默认只取最后一段 `true`。`PIPESTATUS` 是 `1 0`。`set -o pipefail` 后整条管道返回最右侧非零状态，即 1。`PIPESTATUS` 在下一条命令后就被覆盖，必须立刻 `st=("${PIPESTATUS[@]}")`。
:::

### D5 · 子 Shell 丢变量

为什么下面输出 0？给出两种修复。

```bash
n=0
printf 'a\nb\n' | while read -r line; do n=$((n + 1)); done
echo "$n"
```

::: sol D5 核对

管道的每一段在子 Shell 执行，`while` 里的 `n` 是副本，修改不回传父 Shell。修复：① `while ...; done < <(printf ...)`；② `shopt -s lastpipe` + `set +m`（非交互、job control 关闭时生效）；③ 让子 Shell 输出计数，父 Shell 用 `$(...)` 接收。
:::

### D6 · `tee` 的退出码

`./app | tee app.log` 之后 `$?` 是 0，但 `./app` 失败了。为什么？怎么修？

::: sol D6 核对

`$?` 是 `tee` 的退出码，不是 `./app` 的。修复：用 `st=("${PIPESTATUS[@]}")` 取 `st[0]`，或 `set -o pipefail` 让管道整体返回非零。注意 `set -e` + `pipefail` 下管道失败会提前退出，清理逻辑要显式处理。
:::

### D7 · 缓冲三模式

stdio 的三种缓冲模式是什么？各自什么时候默认？为什么程序输出到管道后会“卡住”？

::: sol D7 核对

全缓冲 `_IOFBF`：stdout 不是 tty（管道、文件）时默认，攒满缓冲区（glibc 通常 4–8 KiB）才 `write`；行缓冲 `_IOLBF`：stdout 是 tty 时默认，遇换行就 `write`；无缓冲 `_IONBF`：stderr 默认，每次写入都 `write`。输出到管道后“卡住”是因为全缓冲没攒满；用 `stdbuf -oL`、`grep --line-buffered` 或程序自己 `fflush`。
:::

## B. 第二遍：看内核与边界

### D8 · `dup2` 复制什么

`dup2(oldfd, newfd)` 做哪三件事？两个 fd 共享什么、不共享什么？

::: sol D8 核对

① 关闭 `newfd`（如果已打开）；② 让 `newfd` 指向 `oldfd` 的 `struct file`；③ `f_count` 加一。两个 fd 共享 `f_pos`、`f_flags`、`f_mode`、`f_op`，但 fd 下标本身独立；关闭一个不影响另一个。独立 `open` 同一路径会得到两个 `struct file`，偏移不共享。
:::

### D9 · `O_CLOEXEC`

`O_CLOEXEC` 防的是什么？为什么多线程程序里特别重要？

::: sol D9 核对

防的是 `fork + exec` 之间的 fd 泄漏：`fork` 后子进程继承所有 fd，`execve` 只关闭带 `FD_CLOEXEC` 的 fd。多线程程序里，一个线程 `open` 后另一个线程可能 `fork+exec`，把不该传的 fd 带进新程序。`O_CLOEXEC` 让「打开 + 设置 close-on-exec」成为一个原子操作；`dup3` 也能原子设置。
:::

### D10 · `PIPE_BUF` 与 `SIGPIPE`

管道默认多大？`PIPE_BUF` 保证什么？`yes | head -n 1` 里 `yes` 为什么收到 141？

::: sol D10 核对

Linux 管道默认 64 KiB（16 页），可由 `F_SETPIPE_SZ` 调整，上限看 `/proc/sys/fs/pipe-max-size`。单次 `write ≤ PIPE_BUF`（Linux 4096）时不会与其他写者交错；超过则可能拆分交错。`head` 读一行就退出，`yes` 继续写时内核发 `SIGPIPE`，默认终止，退出码 141（128+13）；这是下游关闭的正常信号。
:::

### D11 · `lastpipe` 的生效条件

`shopt -s lastpipe` 为什么有时不生效？需要什么条件？

::: sol D11 核对

`lastpipe` 只让管道最后一段在当前 Shell 执行，但仅在**非交互 Shell**且 **job control 关闭（`set +m`）**时生效。交互式 Shell 默认 `set -m`，开了也不生效。脚本默认非交互且 job control 关，才生效；可以用 `shopt -q lastpipe` 查选项，但 job control 的影响要显式 `set +m`。
:::

### D12 · `/dev/stdout` vs `2>&1`

`2>/dev/stdout` 与 `2>&1` 差在哪？容器里为什么前者可能失败？

::: sol D12 核对

`2>&1` 复制 fd 1 的 `struct file`，共享偏移与 flags，不依赖 `/proc`。`2>/dev/stdout` 是重新 `open` `/proc/self/fd/1` 指向的目标，得到新的 `struct file`（偏移可能独立）；fd 1 已关闭、目标不可打开、`/proc` 未挂载时都会失败。容器/chroot 里优先 `2>&1`。
:::

### D13 · `stdbuf` 的边界

`stdbuf -oL` 的原理是什么？对哪些程序无效？

::: sol D13 核对

原理是 `LD_PRELOAD=libstdbuf.so`，在程序启动时替换 stdio 的缓冲设置。对静态链接、setuid、直接使用 `write(2)` 的程序无效；`LD_PRELOAD` 在安全执行模式下被忽略；程序自己 `setvbuf` 也可能覆盖它。更可靠的做法是让程序自己配合：`grep --line-buffered`、`awk fflush()`、Python `-u`、`perl $|=1`。
:::

### D14 · 141 是不是 bug

`set -o pipefail` 后 `grep pattern huge.log | head -n 1` 返回 141，是 bug 吗？脚本里应该怎么处理？

::: sol D14 核对

不一定是 bug。`head` 读够一行就退出，`grep` 继续写时收到 `SIGPIPE`，退出码 141。如果允许下游提前退出，临时 `set +o pipefail`，或检查 `PIPESTATUS` 并接受 141；如果不允许，说明管道设计有问题，应让上游支持提前终止。不要在 `set -e` 下让 141 直接终止脚本而不清理。
:::
