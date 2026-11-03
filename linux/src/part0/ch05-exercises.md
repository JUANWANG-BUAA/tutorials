# 0.5 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 三个 fd 与重定向

进程默认的 0/1/2 分别是什么？`>file` 在 fd 表上做了哪几步？`2>&1` 复制的是“数字 1”还是“fd 1 当前的目标”？

::: sol 解答

0 标准输入、1 标准输出、2 标准错误。`>file`：打开 file 得到一个临时 fd，把它复制到 1，再关闭临时 fd。`2>&1` 复制的是「当时」fd 1 指向的打开文件描述，不是数字 1；所以它必须放在 `>file` 之后，才能让 stderr 跟着 stdout 进文件。
:::
:::

::: ex A2 · 顺序题

分别写出 `cmd >out 2>&1` 与 `cmd 2>&1 >out` 执行后 fd 1、fd 2 的指向，并说明 stderr 去哪。

::: sol 解答

`cmd >out 2>&1`：先 fd1→out，再 fd2 复制 fd1 的目标，结果 fd1→out、fd2→out，stderr 进文件。`cmd 2>&1 >out`：先 fd2 复制 fd1 当前目标（终端），再 fd1→out，结果 fd1→out、fd2→终端，stderr 留在终端。关键是 `2>&1` 复制的是当时 fd 1 的指向。
:::
:::

::: ex A3 · here-doc 的引号

`<<'EOF'` 与 `<<EOF` 各会展开什么？写配置文件时为什么默认加引号？

::: sol 解答

`<<'EOF'` 引号包围定界符，正文不做参数展开、命令替换、算术展开；`<<EOF` 会展开 `$VAR`、`$(cmd)`、反引号和 `\`。写配置、传密码时默认加引号，避免 `$`、反引号被 Shell 解释；如果正文来自用户输入，不加引号还可能造成命令注入。
:::
:::

::: ex A4 · 管道退出码

`false | true | false` 的 `$?` 是多少？`PIPESTATUS` 是什么？开 `pipefail` 后 `$?` 是多少？

::: sol 解答

默认 `$?` 是最后一段 `false` 的状态 1；`PIPESTATUS` 是 `1 0 1`。开 `set -o pipefail` 后整条管道返回最右侧非零状态，仍是 1。`PIPESTATUS` 在下一条命令后会被覆盖，必须紧接着赋值：`st=("${PIPESTATUS[@]}")`。
:::
:::

::: ex A5 · 子 Shell

为什么 `printf 'a\nb\n' | while read -r line; do n=$((n+1)); done` 之后 `n` 仍是 0？给出两种修复。

::: sol 解答

管道的每一段在子 Shell 执行，`while` 里的 `n` 是副本，修改不回传父 Shell。修复：① `while ...; done < <(printf 'a\nb\n')`；② `shopt -s lastpipe` + `set +m`（非交互、job control 关闭时生效）；③ 让子 Shell 输出计数，父 Shell 用 `$(...)` 接收。
:::
:::

::: ex A6 · `tee`

`./deploy.sh | tee deploy.log` 的 `$?` 是谁的？怎样保留 `deploy.sh` 的退出码？

::: sol 解答

`$?` 是 `tee` 的，不是 `deploy.sh` 的。用 `st=("${PIPESTATUS[@]}")` 取 `st[0]`；或 `set -o pipefail` 让管道整体返回非零。注意 `set -e` + `pipefail` 下管道失败会提前退出，清理逻辑要显式处理。
:::
:::

::: ex A7 · 缓冲

stdio 的三种缓冲模式是什么？为什么 `tail -f` 有时看不到最新日志？

::: sol 解答

全缓冲 `_IOFBF`（stdout 非 tty 时默认）、行缓冲 `_IOLBF`（stdout 是 tty 时默认）、无缓冲 `_IONBF`（stderr 默认）。`tail -f` 看不到最新日志，是因为上游程序的 stdout 被重定向到文件/管道后进入全缓冲，没攒满不 `write`。用 `stdbuf -oL`、程序自己 `fflush`，Python 用 `-u` 或 `PYTHONUNBUFFERED=1`。
:::
:::

::: ex A8 · `dup2` 与 `O_CLOEXEC`

`dup2(oldfd, newfd)` 复制的是什么？`O_CLOEXEC` 防的是什么？

::: sol 解答

`dup2` 让 `newfd` 指向 `oldfd` 的 `struct file`，共享偏移、flags、`f_op`；它不复制文件内容，也不重置偏移。`O_CLOEXEC` 让 fd 在 `execve` 时自动关闭，防止 `fork + exec` 之间把不该传的 fd 泄漏给新程序；多线程程序里尤其重要，因为另一个线程可能在你 `open` 后立刻 `fork+exec`。
:::
:::

## B 组 · 诊断推理

::: ex B1 · 日志里少了错误行

你运行 `./app > run.log`，日志里只有正常输出，错误信息还在终端。为什么？给出两种修法。

::: sol 解答

`> run.log` 只重定向 stdout（fd 1），stderr（fd 2）仍指向终端。修法：① `./app > run.log 2>&1`（顺序不能反）；② `./app &> run.log`（bash 扩展，等价于 `>file 2>&1`）。不要写 `2>&1 > run.log`，那会让 stderr 留在终端。
:::
:::

::: ex B2 · 循环计数为 0

脚本里 `printf ... | while read ...; do n=$((n+1)); done` 之后 `n` 总是 0，但循环明明执行了。解释原因并给出三种修法。

::: sol 解答

管道每段在子 Shell，`while` 里的 `n` 是副本。修法：① 进程替换 `while ...; done < <(printf ...)`；② `shopt -s lastpipe` + `set +m`；③ 让子 Shell 把结果写到 stdout，父 Shell 用 `n=$(... | awk 'END{print NR}')` 接收。注意 `lastpipe` 在交互式 Shell 默认不生效。
:::
:::

::: ex B3 · 设计日志包装

写一个脚本 `logwrap.sh COMMAND [ARG...]`，把命令的 stdout/stderr 同时写到终端和日志，并返回命令的退出码。说明为什么不能直接用 `cmd | tee log`。

::: sol 解答

`cmd | tee log` 的 `$?` 是 `tee` 的，不是 `cmd` 的。正确做法：

```bash
#!/usr/bin/env bash
set -uo pipefail
log=${LOG_FILE:-./run.log}
{
    printf '== %s start cmd=%q ==\n' "$(date -Is)" "$*"
    "$@"
} 2>&1 | tee -a -- "$log"
st=("${PIPESTATUS[@]}")
printf '== %s end rc=%d ==\n' "$(date -Is)" "${st[0]}" | tee -a -- "$log"
exit "${st[0]}"
```

不要加 `set -e`：管道失败会在记录结束行之前退出。`PIPESTATUS[0]` 是花括号组的退出状态，也就是 `"$@"` 的状态。
:::
:::

::: ex B4 · 141 是不是 bug

脚本开了 `set -euo pipefail`，执行 `grep pattern huge.log | head -n 1` 时整个脚本退出，状态 141。解释原因，并给出两种处理方式。

::: sol 解答

`head` 读够一行就退出，`grep` 继续写时收到 `SIGPIPE`，退出码 141；`pipefail` 让整条管道返回 141，`set -e` 随即退出。处理：① 如果允许下游提前退出，临时 `set +o pipefail`，或 `if ! ...; then st=("${PIPESTATUS[@]}"); (( st[0] == 141 )) || exit ...; fi`；② 如果不想让上游收到 SIGPIPE，改成先读全量再处理，或让上游支持提前终止。不要把 141 一律当 bug 重试。
:::
:::

::: ex B5 · `/dev/stdout` 失败

容器里 `cmd 2>/dev/stdout` 报错，但 `cmd 2>&1` 正常。为什么？给出排查步骤。

::: sol 解答

`/dev/stdout` 在 Linux 上是指向 `/proc/self/fd/1` 的符号链接；容器里如果没挂 `/proc`，或 fd 1 已关闭/目标不可打开，就会失败。`2>&1` 是直接复制 fd，不依赖 `/proc`。排查：`ls -l /dev/stdout`、`ls -l /proc/self/fd/1`、`mount | grep proc`；在容器/chroot 里优先用 `2>&1`。
:::
:::

::: ex B6 · `stdbuf` 无效

你对一个程序用了 `stdbuf -oL ./app | grep ERROR`，但输出还是卡住。列出至少三种可能原因。

::: sol 解答

① 程序是静态链接，`LD_PRELOAD` 不生效；② 程序是 setuid，`LD_PRELOAD` 被安全执行模式忽略；③ 程序直接使用 `write(2)`，不经过 stdio；④ 程序自己调用了 `setvbuf`，覆盖了 `stdbuf` 的设置；⑤ `stdbuf` 只影响它启动的那个进程，不理解子进程/守护进程。更可靠的做法是让程序自己配合：`grep --line-buffered`、`awk fflush()`、Python `-u`、`perl $|=1`。
:::
:::

## C 组 · 动手实验

::: ex C1 · 用 `strace` 看重定向

运行下面的命令，解释 `openat`、`dup2`、`close` 的顺序；再交换重定向顺序，观察差异。

```bash
strace -f -e trace=openat,dup,dup2,dup3,close,pipe,pipe2 \
    -o /tmp/redir.trace \
    bash -c 'echo out; echo err >&2' > /tmp/out.txt 2>&1
grep -E 'out\.txt|dup|close\(3\)' /tmp/redir.trace | tail -20
```

::: sol 解答

典型顺序（fd 号与是否用 `dup3` 因 bash 版本而异）：`openat("/tmp/out.txt", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC) = 3`；`dup2(3, 1) = 1`；`close(3) = 0`；`dup2(1, 2) = 2`。读法：先打开文件得到临时 fd 3，复制到 1，关闭 3，再让 2 复制 1 的目标。把顺序换成 `2>&1 > /tmp/out.txt`，会看到 `dup2(1,2)` 在前、`openat` 在后，stderr 仍指向终端。`-f` 跟随子进程，`-yy` 能把 fd 显示成路径。
:::
:::

::: ex C2 · 用 `strace` 看 `SIGPIPE`

运行 `strace -f -e trace=write,close,pipe,pipe2 -o /tmp/pipe.trace bash -c 'yes | head -n 1'`，在输出里找 `SIGPIPE`，解释它为什么不是 bug。

::: sol 解答

预期能看到 `write(1, "y\n", 2) = 2`，随后 `--- SIGPIPE {si_signo=SIGPIPE, ...} ---` 和 `+++ killed by SIGPIPE +++`。`head` 读一行后关闭读端，`yes` 下一次 `write` 触发 `SIGPIPE`；默认动作是终止进程，退出码 141。这是下游关闭的正常信号。若给 `yes` 加 `trap '' PIPE`，信号被忽略，`write` 返回 `EPIPE`，可以用来区分「正常关闭」与「真错误」。
:::
:::

::: ex C3 · 写一个日志包装

把 B3 的 `logwrap.sh` 真正跑起来：用一个会失败的命令测试退出码，再用一个输出很多的命令测试日志是否完整。

::: sol 解答

```bash
#!/usr/bin/env bash
set -uo pipefail
log=${LOG_FILE:-./run.log}
{
    printf '== %s start cmd=%q ==\n' "$(date -Is)" "$*"
    "$@"
} 2>&1 | tee -a -- "$log"
st=("${PIPESTATUS[@]}")
printf '== %s end rc=%d ==\n' "$(date -Is)" "${st[0]}" | tee -a -- "$log"
exit "${st[0]}"
```

测试：`./logwrap.sh sh -c 'echo out; echo err >&2; exit 7'; echo $?` 应输出 7；`./logwrap.sh seq 1 100000 >/dev/null` 后 `wc -l run.log` 应包含开始/结束行与全部输出。关键点：不加 `set -e`、取 `PIPESTATUS[0]`、用 `"$@"` 而不是 `"$*"` 执行。
:::
:::

::: ex C4 · 备份与恢复 fd

写一个脚本，把后续输出重定向到日志，并在 `EXIT`/`INT`/`TERM` 时恢复原来的 stdout/stderr；说明为什么先备份 3/4。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
log=${1:?usage: $0 LOG COMMAND [ARG...]}
shift
exec 3>&1 4>&2
cleanup() {
    local rc=$?
    trap - EXIT INT TERM
    exec 1>&3 2>&4
    exec 3>&- 4>&-
    printf 'restored rc=%d\n' "$rc" >&2
    exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
exec >>"$log" 2>&1
printf '== %s start\n' "$(date -Is)"
"$@"
printf '== %s done\n' "$(date -Is)"
```

`exec 3>&1 4>&2` 先把原 stdout/stderr 存到 3/4，再把 1/2 接到日志；`cleanup` 首行保存 `$?`、先 `trap -` 防止递归，再恢复并关闭 3/4。顺序不能反：先关 3 再 `1>&3` 会报 `Bad file descriptor`。
:::
:::

::: ex C5 · 修复变量丢失

用三种方法修复 A5 的计数问题，并比较它们的可移植性与副作用。

::: sol 解答

```bash
# 1. 进程替换：循环在当前 Shell，依赖 /dev/fd（bash/ksh）
n=0
while read -r line; do n=$((n + 1)); done < <(printf 'a\nb\n')
echo "$n"    # 2

# 2. lastpipe：只让最后一段在当前 Shell；非交互 + set +m 才生效
set +m
shopt -s lastpipe
n=0
printf 'a\nb\n' | while read -r line; do n=$((n + 1)); done
echo "$n"    # 2

# 3. 命令替换：最可移植；结果走 stdout，末尾换行被剥
n=$(printf 'a\nb\n' | awk 'END {print NR}')
echo "$n"    # 2
```

比较：进程替换需要 `/dev/fd`，`dash` 不支持；`lastpipe` 受交互模式与 job control 影响，最容易“时灵时不灵”；命令替换是 POSIX，适合只需要一个结果，但会把输出当数据、末尾换行被剥，不适合需要保留原始行内容的场景。
:::
:::
