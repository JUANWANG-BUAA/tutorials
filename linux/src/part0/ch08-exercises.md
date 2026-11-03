# 0.8 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 函数返回

bash 函数有哪三种返回通道？各适合什么？为什么不要用 stdout 返回二进制？

::: sol 解答

① 退出码（`return n`/最后一条命令状态），适合成功/失败；② stdout（`$(func)`），适合文本/多行；③ `nameref`（`local -n ref=$1`）或全局变量，适合结构化结果。stdout 经过命令替换，尾随换行被剥、NUL/二进制会丢，不适合二进制；多值用 nameref/数组。

:::
:::

::: ex A2 · 数组与 mapfile

索引数组、关联数组、`mapfile -t` 各怎样用？`${arr[@]}` 不加引号会怎样？

::: sol 解答

索引数组 `arr=(a "b c")`，`"${arr[@]}"` 保留元素，`"${!arr[@]}"` 取下标，`${#arr[@]}` 个数；关联数组 `declare -A m; m[k]=v`，`"${!m[@]}"` 取键；`mapfile -t lines < file` 按行读入（`-t` 去换行）。`${arr[@]}` 不加引号会分词/通配，元素含空格就散。

:::
:::

::: ex A3 · trap

`trap cleanup EXIT INT TERM` 各在什么时候执行？为什么清理函数要先保存 `$?`、先 `trap -`？

::: sol 解答

`EXIT` 在脚本退出（正常/`exit`/捕获信号后）执行；`INT`/`TERM` 在 Ctrl-C/终止信号时执行。先保存 `$?` 才能把原退出码传出去；先 `trap -` 防止清理函数里的命令再次触发 trap，造成递归/重复清理。`kill -9` 不会触发任何 trap。

:::
:::

::: ex A4 · mktemp 与 flock

`mktemp` 与 `flock` 各解决什么问题？为什么不要用 `$$` 拼临时文件名？`flock -n` 是什么？

::: sol 解答

`mktemp` 原子地创建唯一临时文件/目录（`mktemp -d`），避免竞态/覆盖；`$$` 拼名可预测，容易被抢占/符号链接攻击。`flock` 对文件加建议锁，做单实例/互斥；`flock -n` 拿不到锁立即失败（非阻塞），适合 cron 防重入。锁跟着 fd 释放，进程退出自动释放。

:::
:::

::: ex A5 · 并发与 wait -n

怎样限制同时运行的后台任务数？`wait -n` 与 `wait` 差在哪？`jobs`/`wait` 在脚本里够用吗？

::: sol 解答

用 `wait -n` 等“任意一个”后台任务结束，再启动下一个，维持并发上限；`wait` 不带参数等全部。脚本里 `jobs -p`/`wait -n` 可以做简单限流；更复杂用 `xargs -P`/GNU parallel/任务队列。`wait -n` 的退出码是被等待任务的状态，要单独记录每个任务的结果。

:::
:::

::: ex A6 · 参数、日志与 set -e

`getopts` 与外部 `getopt` 各做什么？日志函数应记录什么？`set -e` 在哪些语境不生效？

::: sol 解答

`getopts` 解析短选项，外部 `getopt` 支持长选项。日志函数记录时间（`date -Is`）、级别、脚本名/PID、消息、退出码；日志要能追加、可轮转、不吞错误。`set -e` 在 `if`/`while`/`until`/`&&`/`||`/`!`、管道（除非 `pipefail`）、函数/子 Shell 等语境有例外。

:::
:::

::: ex A7 · getopt 长选项

外部 `getopt` 怎样解析 `--file=...`/`--verbose`？为什么 `getopts` 做不到？解析后怎样 `eval set --`？

::: sol 解答

GNU `getopt -o vo: --long verbose,file: -- "$@"` 输出规范化参数，再 `eval set -- "$parsed"`，用 `while true; case $1 in --file) ...; shift 2;; --) shift; break;; esac` 解析。`getopts` 只支持单字符短选项，不支持 `--long`；外部 `getopt` 是 GNU 工具，BSD/macOS 行为不同。

:::
:::

::: ex A8 · shellcheck、POSIX 与 source

`shellcheck` 能抓什么？`#!/bin/sh` 与 `#!/usr/bin/env bash` 差在哪？`source` 库怎样防重复？

::: sol 解答

`shellcheck` 抓未加引号（SC2086）、`cd` 未检查（SC2164）、用 `$?` 而非 `if`（SC2181）、未使用变量（SC2034）、`set -e` 陷阱等；不替代运行测试。`#!/bin/sh` 在 Debian/Ubuntu 是 dash，不支持数组/`[[`/`(( ))`/`local`/`<<<`/`<()`；要 bash 写 `#!/usr/bin/env bash`。`source` 库用守卫变量或 `BASH_SOURCE` 判断是否已加载，避免重复定义/循环。

:::
:::

## B 组 · 诊断推理

::: ex B1 · trap 跑两次

`trap cleanup EXIT INT TERM` 在 Ctrl-C 时清理跑了两次。为什么？怎样修？

::: sol B1 核对

`INT` trap 先执行一次，随后脚本退出又触发 `EXIT` trap，所以两次。修法：清理函数里先 `trap - EXIT INT TERM` 再执行清理，或只在 `EXIT` 里清理、`INT`/`TERM` 只 `exit 130/143`。清理要幂等（删临时目录用 `rm -rf` 不报错）。

:::
:::

::: ex B2 · flock 没生效

脚本用了 `flock -n /tmp/backup.lock -c 'backup.sh'`，但两个 cron 还是同时跑。列出至少三种原因。

::: sol B2 核对

① 锁路径不同（不同用户/容器/命名空间）；② 用了 `-n` 但没检查退出码，拿不到锁也继续；③ 锁文件被删除/替换（inode 变了）；④ 两个任务在同一个锁内但某个子进程又 fork 出去；⑤ 锁在 NFS 上，`flock` 语义不可靠。用 `flock -n 9` + `exec 9>lock` 并检查 `$?`；锁文件放本地持久路径，不要删。

:::
:::

::: ex B3 · 函数返回值丢了

`result=$(myfunc)` 之后 `$?` 是 0，但函数里的失败没反映。为什么？怎样改？

::: sol B3 核对

`$?` 是命令替换/赋值的结果，不是函数最后一条命令的状态；`local`/赋值也会覆盖 `$?`。修法：函数用 `return n` 明确返回，或让 stdout 输出结果、状态写到全局/文件；调用后先保存 `rc=$?`，再解析 stdout。关键失败用 `set -e`/`ERR` trap 或显式检查。

:::
:::

::: ex B4 · backup.sh 并发跑

两个 `backup.sh` 同时跑，目标目录出现半成品/交错文件。怎样修？

::: sol B4 核对

加单实例锁：`exec 9>"$lock"; flock -n 9 || { echo busy; exit 1; }`；写临时目录（`mktemp -d`）再原子 `mv` 到最终路径；`trap cleanup EXIT` 清理半成品；日志写不同文件或加锁；校验（大小/哈希/`tar -t`）后再切换。不要用 `mkdir` 当锁（非原子/残留）。

:::
:::

::: ex B5 · wait -n 限流

用 `for f in *; do cmd "$f" & done; wait` 启动了 1000 个后台任务，机器被打满。怎样改成并发上限 8？

::: sol B5 核对

```bash
max=8
for f in *; do
    while (( $(jobs -rp | wc -l) >= max )); do wait -n; done
    cmd "$f" &
done
wait
```

用 `jobs -rp` 数运行中的任务，`wait -n` 等任意一个结束再启动下一个；记录每个任务的退出码到文件/数组，最后汇总。更稳用 `xargs -P8` 或任务队列。

:::
:::

::: ex B6 · source 两次

一个库被 `source` 两次，函数/变量重复定义，甚至递归 source。怎样防？

::: sol B6 核对

库顶部加守卫：

```bash
[[ -n ${MYLIB_LOADED:-} ]] && return 0
MYLIB_LOADED=1
```

或用 `BASH_SOURCE` 判断是否已加载；`source` 前检查文件存在/可读；避免在库顶层执行副作用（创建文件/启动服务），把初始化放到函数里。

:::
:::

## C 组 · 动手实验

::: ex C1 · 写 backup.sh

写一个 `backup.sh`：`-s SRC`、`-d DST`、`-n`（dry-run）、`-h`；用 `rsync`/`tar` 备份，带锁、临时目录、日志、校验、清理与退出码。

::: sol C1 核对

```bash
#!/usr/bin/env bash
set -euo pipefail
usage() { printf 'usage: %s -s SRC -d DST [-n]\n' "${0##*/}" >&2; }
src='' dst='' dry=0
while getopts ':s:d:nh' opt; do
    case $opt in
        s) src=$OPTARG ;; d) dst=$OPTARG ;;
        n) dry=1 ;; h) usage; exit 0 ;;
        *) usage; exit 2 ;;
    esac
done
[[ -n $src && -n $dst ]] || { usage; exit 2; }
[[ -d $src ]] || { echo "not a dir: $src" >&2; exit 2; }
mkdir -p -- "$dst"
lock=$dst/.backup.lock
exec 9>"$lock"
flock -n 9 || { echo "another backup is running" >&2; exit 1; }
tmp=$(mktemp -d "$dst/.backup.XXXXXX")
cleanup() { local rc=$?; trap - EXIT INT TERM; rm -rf -- "$tmp"; exit "$rc"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
log() { printf '%s %s\n' "$(date -Is)" "$*" | tee -a "$dst/backup.log"; }
log "start src=$src dst=$dst dry=$dry"
if (( dry )); then
    rsync -a --dry-run --delete -- "$src/" "$tmp/"
else
    rsync -a --delete -- "$src/" "$tmp/"
    tar -C "$tmp" -czf "$dst/backup-$(date +%Y%m%d-%H%M%S).tar.gz" .
fi
log "done rc=$?"
```

关键点：`getopts`、参数校验、`flock -n`、`mktemp -d`、`trap` 清理、`rsync --dry-run`、日志、显式退出码。生产版还要校验 tar、保留策略、通知。

:::
:::

::: ex C2 · flock 单实例

用 `flock` 写一个单实例脚本：拿不到锁就退出 1；拿到锁后 sleep 5；用两个终端验证。

::: sol C2 核对

```bash
#!/usr/bin/env bash
set -euo pipefail
lock=/tmp/demo.lock
exec 9>"$lock"
if ! flock -n 9; then
    echo "already running" >&2
    exit 1
fi
echo "got lock pid=$$"
sleep 5
```

终端 A 运行后，终端 B 再运行应输出 `already running` 并退出 1；A 结束后 B 才能拿到锁。`flock` 跟 fd 9 绑定，进程退出自动释放；不要手动删锁文件。

:::
:::

::: ex C3 · wait -n 限流

启动 20 个 `sleep 1` 任务，并发上限 4，统计总耗时与失败数。

::: sol C3 核对

```bash
#!/usr/bin/env bash
set -uo pipefail
max=4 fails=0
for i in $(seq 1 20); do
    while (( $(jobs -rp | wc -l) >= max )); do
        wait -n || fails=$((fails + 1))
    done
    ( sleep 1; exit $((i % 7 == 0)) ) &
done
while (( $(jobs -rp | wc -l) > 0 )); do
    wait -n || fails=$((fails + 1))
done
printf 'fails=%d\n' "$fails"
```

并发上限 4，总耗时约 5 秒（20/4）；失败数按每个任务的退出码统计。注意 `wait -n` 的退出码只代表“某个任务”，要配合任务自己的状态记录。

:::
:::

::: ex C4 · trap 清理

写一个脚本创建临时目录，正常退出、Ctrl-C、`kill -TERM` 三种情况都能清理；验证没有残留。

::: sol C4 核对

```bash
#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp -d)
cleanup() { local rc=$?; trap - EXIT INT TERM; rm -rf -- "$tmp"; exit "$rc"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
echo "tmp=$tmp"
sleep 30
```

正常结束、Ctrl-C、`kill -TERM` 后 `ls "$tmp"` 都应不存在；`kill -9` 不会触发 trap，这是预期。清理函数先保存 `$?`、先 `trap -`，避免重复/递归。

:::
:::

::: ex C5 · shellcheck 与 trace

对 C1 的 `backup.sh` 跑 `shellcheck`，修掉至少三个警告；再用 `bash -x`/`PS4` 看一次 dry-run 的展开。

::: sol C5 核对

```bash
shellcheck backup.sh
PS4='+ $LINENO: ' bash -x backup.sh -s /tmp/src -d /tmp/dst -n
```

常见警告：SC2086（未加引号）、SC2164（`cd` 未检查）、SC2181（用 `$?` 而不是 `if`）、SC2034（变量未使用）。修法：变量加双引号、`cd ... || exit`、用 `if cmd; then`。`PS4` 带行号，能对上脚本位置；shellcheck 不替代运行测试。

:::
:::
