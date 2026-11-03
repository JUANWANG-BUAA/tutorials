# 0.7 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 脚本骨架

一个可靠脚本的开头通常有哪几行？`set -euo pipefail` 各是什么？`#!/usr/bin/env bash` 与 `#!/bin/bash` 差在哪？

::: sol 解答

开头：`#!/usr/bin/env bash`、`set -euo pipefail`、可选 `IFS=$'\n\t'`、`usage`/`main`、显式 `exit`。`-e` 命令失败退出，`-u` 未定义变量报错，`-o pipefail` 管道任一段失败即失败。`env bash` 从 `PATH` 找 bash，避免写死路径；`#!/bin/bash` 在 macOS 上可能落到 3.2，`env` 更容易用新版。

:::
:::

::: ex A2 · 变量与作用域

变量、环境变量、只读变量、局部变量各是什么？`export`、`readonly`、`local` 各做什么？

::: sol 解答

普通变量只在当前 Shell；`export` 后进入环境，子进程可见；`readonly` 禁改/删；`local` 只在函数内有效（bash 扩展）。变量默认全局，函数里改全局变量要小心；`declare -p var` 看类型/值，`env`/`printenv` 看环境。

:::
:::

::: ex A3 · 引号三态

无引号、单引号、双引号各怎样处理变量、分词与通配？`"$@"` 与 `"$*"` 差在哪？

::: sol 解答

无引号：变量展开后会分词/通配；单引号：全字面，不展开；双引号：展开变量/命令替换，但不分词/不通配。`"$@"` 保留每个位置参数为独立参数；`"$*"` 用 `IFS` 合成一个字符串。路径、变量、命令替换默认都加双引号。

:::
:::

::: ex A4 · 参数展开

`${var:-default}`、`${var:=default}`、`${var:?msg}`、`${var:+alt}`、`${#var}`、`${var#prefix}`、`${var%suffix}`、`${var/old/new}` 各做什么？

::: sol 解答

`:-` 为空/未设时用默认值（不赋值）；`:=` 同时赋值；`:?` 为空/未设时报错退出；`:+` 有值时用 alt；`${#var}` 长度；`#` 去最短前缀，`##` 去最长；`%` 去最短后缀，`%%` 去最长；`/old/new` 替换第一个，`//old/new` 替换全部。它们不调用外部命令，比 `sed`/`cut` 快。

:::
:::

::: ex A5 · 命令替换与算术

`$(...)` 与反引号差在哪？`$((...))` 与 `((...))` 各做什么？算术里变量要不要 `$`？

::: sol 解答

`$(...)` 可嵌套、可读性好，优先用；反引号旧式、嵌套要转义。`$((...))` 展开为算术结果；`((...))` 作为命令执行，返回退出码（非零为真）。算术里变量名通常不用 `$`；`((count++))` 可直接改变量。

:::
:::

::: ex A6 · 条件三套

`[`、`[[`、`(( ))` 各是什么？字符串/数字/文件测试各举一例。`[[ ]]` 比 `[` 强在哪？

::: sol 解答

`[` 是命令（`test`），`[[` 是 bash 关键字，`(( ))` 做算术。字符串 `[[ $a == b ]]`；数字 `(( a > b ))`；文件 `[[ -f $path ]]`。`[[ ]]` 支持 `&&`/`||`、模式/正则 `=~`、不做分词/通配，空变量更安全；`[` 需要小心引号和 `-a`/`-o`。

:::
:::

::: ex A7 · 退出码与 set -e

退出码 0/非 0 各表示什么？`set -e` 在哪些语境不生效？`pipefail`/`PIPESTATUS` 解决什么？

::: sol 解答

0 成功，非 0 失败（1 通用，2 用法，126/127 不可执行/找不到，130 Ctrl-C，141 SIGPIPE）。`set -e` 在 `if`/`while`/`until`/`&&`/`||`/`!`、管道（除非 `pipefail`）等语境有例外；函数/子 Shell 里也可能不按预期传播。`pipefail` 让管道任一段失败即失败；`PIPESTATUS` 保留每段状态，需立刻保存。

:::
:::

::: ex A8 · 展开顺序

一行命令执行前，bash 按什么顺序展开？为什么 `var='a b'; echo $var` 输出两个参数？

::: sol 解答

顺序：大括号 → 波浪号 → 参数/变量 → 命令替换 → 算术 → 分词 → 通配 → 去引号。`$var` 未加引号，参数展开后经过分词，`a b` 变成两个参数；`"$var"` 保留一个。顺序记反会写出“看起来对、跑起来错”的脚本。

:::
:::

## B 组 · 诊断推理

::: ex B1 · 空变量让 `[` 报错

`[ $x = ok ]` 在 `x` 为空时报 `unary operator expected`。为什么？给出两种修法。

::: sol 解答

`[` 是命令，`$x` 未加引号时为空，命令变成 `[ = ok ]`，参数数量不对。修法：① `[ "$x" = ok ]`（加引号，空串仍是一个参数）；② 用 `[[ $x == ok ]]`（bash 关键字，空变量安全）。脚本里优先 `[[ ]]`，或 `"${x:-}"`。

:::
:::

::: ex B2 · `set -e` 没停

脚本开了 `set -e`，但某条失败命令没让脚本退出。列出至少三种原因。

::: sol 解答

① 命令在 `if`/`while`/`until` 条件里；② 命令在 `&&`/`||`/`!` 列表里；③ 命令在管道里且没开 `pipefail`（只看最后一段）；④ 命令在子 Shell/命令替换里，退出码没传出来；⑤ 函数调用在条件上下文；⑥ `set -e` 被 `set +e` 临时关闭。用 `set -x`/`trap ERR` 定位。

:::
:::

::: ex B3 · while read 丢最后一行

`while IFS= read -r line; do echo "$line"; done < file` 有时漏掉最后一行。为什么？怎样修？

::: sol 解答

`read` 在文件末尾没有换行时返回非零，循环条件为假，最后一行没进循环体。修法：`while IFS= read -r line || [[ -n $line ]]; do ...; done < file`。`IFS= read -r` 保留前导/尾随空白与反斜杠；不要用 `for line in $(cat file)`。

:::
:::

::: ex B4 · `"$@"` 与 `"$*"`

写一个脚本打印参数个数与每个参数；分别用 `"$@"` 与 `"$*"`，说明差异。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
printf 'count=%d\n' "$#"
for a in "$@"; do printf '<%s>\n' "$a"; done
printf 'star=<%s>\n' "$*"
```

`"$@"` 保留每个参数为独立参数，循环逐个输出；`"$*"` 用 `IFS`（默认空格）合成一个字符串。参数含空格时差异最明显；传参给子命令用 `"$@"`。

:::
:::

::: ex B5 · getopts 解析

用 `getopts` 解析 `-v`（verbose）与 `-f FILE`（file），并说明 `OPTARG`/`OPTIND`。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
verbose=0 file=''
while getopts ':vf:' opt; do
    case $opt in
        v) verbose=1 ;;
        f) file=$OPTARG ;;
        :) echo "option -$OPTARG requires an argument" >&2; exit 2 ;;
        \?) echo "unknown option -$OPTARG" >&2; exit 2 ;;
    esac
done
shift $((OPTIND - 1))
printf 'verbose=%d file=%s rest=%s\n' "$verbose" "$file" "$*"
```

`OPTARG` 是当前选项的参数，`OPTIND` 是下一个要处理的参数下标；循环后 `shift $((OPTIND-1))` 去掉已解析的选项。`getopts` 只处理短选项，长选项要手写。

:::
:::

::: ex B6 · trap 清理

写一个脚本，创建临时目录并在 `EXIT`/`INT`/`TERM` 时清理；说明为什么先保存 `$?`、先 `trap -`。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp -d)
cleanup() {
    local rc=$?
    trap - EXIT INT TERM
    rm -rf -- "$tmp"
    exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
printf 'work in %s\n' "$tmp"
```

先保存 `$?` 才能把原退出码传出去；先 `trap -` 防止清理里再次触发 trap 递归。`rm -rf -- "$tmp"` 的 `--` 防止路径以 `-` 开头。

:::
:::

## C 组 · 动手实验

::: ex C1 · 脚本骨架

写一个脚本：接受 `-n`（dry-run）与 `-d DIR`，默认 dry-run，检查目录存在，打印将要做什么，最后显式退出码。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
usage() { printf 'usage: %s [-n] -d DIR\n' "${0##*/}" >&2; }
dry=1 dir=''
while getopts ':nd:' opt; do
    case $opt in
        n) dry=1 ;;
        d) dir=$OPTARG ;;
        *) usage; exit 2 ;;
    esac
done
[[ -n $dir ]] || { usage; exit 2; }
[[ -d $dir ]] || { printf 'not a directory: %s\n' "$dir" >&2; exit 2; }
if (( dry )); then
    printf 'would process %s\n' "$dir"
else
    printf 'processing %s\n' "$dir"
fi
```

关键点：`set -euo pipefail`、`usage`、`getopts`、参数检查、显式退出码。真操作前先 dry-run。

:::
:::

::: ex C2 · 参数展开

不用 `sed`/`basename`，用参数展开从 `/var/log/app.log` 取出目录 `/var/log`、文件名 `app.log`、去扩展名 `app`。

::: sol 解答

```bash
path=/var/log/app.log
dir=${path%/*}
file=${path##*/}
stem=${file%.*}
printf 'dir=%s file=%s stem=%s\n' "$dir" "$file" "$stem"
```

`${path%/*}` 去最短后缀 `/*` 得 `/var/log`；`${path##*/}` 去最长前缀 `*/` 得 `app.log`；`${file%.*}` 去最短后缀 `.*` 得 `app`。边界：路径没有 `/` 时 `dir` 会等于原路径；先判断。

:::
:::

::: ex C3 · 循环读文件

用 `while IFS= read -r` 读一个可能没有末尾换行的文件，统计行数并打印每行；不要用 `for line in $(cat file)`。

::: sol 解答

```bash
n=0
while IFS= read -r line || [[ -n $line ]]; do
    n=$((n + 1))
    printf '%d: %s\n' "$n" "$line"
done < file
printf 'total=%d\n' "$n"
```

`IFS= read -r` 保留空白/反斜杠；`|| [[ -n $line ]]` 处理末尾无换行；`n` 在当前 Shell（重定向输入，不用管道）。`for line in $(cat file)` 会分词、丢空行、把 `*` 展开。

:::
:::

::: ex C4 · getopts 实战

写一个脚本，支持 `-v`、`-o FILE`、`-h`，未知选项报错；解析后打印剩余位置参数。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
verbose=0 out=''
while getopts ':vo:h' opt; do
    case $opt in
        v) verbose=1 ;;
        o) out=$OPTARG ;;
        h) printf 'usage: %s [-v] [-o FILE] [args...]\n' "${0##*/}"; exit 0 ;;
        :) printf 'option -%s requires an argument\n' "$OPTARG" >&2; exit 2 ;;
        \?) printf 'unknown option -%s\n' "$OPTARG" >&2; exit 2 ;;
    esac
done
shift $((OPTIND - 1))
printf 'verbose=%d out=%s rest=' "$verbose" "$out"
printf '<%s> ' "$@"; printf '\n'
```

`-o:` 的冒号表示要参数；`OPTARG` 取值；`shift $((OPTIND-1))` 处理剩余参数。`-h` 直接退出 0，未知选项退出 2。

:::
:::

::: ex C5 · 手工体检：没有 `shellcheck` 也要能把 C1 过一遍

本书的两台机器都没装 `shellcheck`（两边 `command -v shellcheck` 都返回空），这道题不用它。按 0.7.15 的六步给 C1 的 `c1.sh` 做一次体检：语法层 `bash -n`、展开层 `PS4=… bash -x`、数据层 `declare -p` 与 `printf '%q'`/`printf '[%s]'` 探针、空值层临时加 `set -u`、破坏性动作层把要执行的 `rm` 换成 `printf` 试运行，最后一步才是可选的自动检查器。逐步写下你看到了什么、那说明脚本在哪一层是干净的。

::: sol 解答

前四步在你的脚本上各给出一次「干净」的证据。语法层：`bash -n c1.sh` 退出码 0，`if`/`fi` 与引号配对没问题——注意它同时也放行未加引号的变量，所以这一步过了不代表安全。展开层与数据层（本机 bash 5.3.20 与 VM 的 bash 5.2.21 逐字一致，只有行号随文件不同）：

```bash
$ PS4='+${BASH_SOURCE##*/}:${LINENO}> ' bash -x c1.sh -d /tmp
+c1.sh:5> getopts :nd: opt
+c1.sh:8> dir=/tmp
+c1.sh:12> [[ -n /tmp ]]
+c1.sh:13> [[ -d /tmp ]]
+c1.sh:14> ((  dry  ))
+c1.sh:15> printf 'would process %s\n' /tmp
would process /tmp
```

`dir=/tmp` 是一个词、`printf` 收到的 argv 是 `/tmp` 一个参数，说明第 6、7 站没被踩。换成 `-d 'my dir'` 再跑一次，trace 里是 `[[ -d my dir ]]` 和 `printf 'would process %s\n' 'my dir'`：`[[` 那一行看着像两个词，但 `[[` 根本不分词（0.7.11），真正数词要看 `printf` 那行——带引号的 `'my dir'` 是一个参数。如果你的脚本里出现的是 `rm -rf my dir` 这种两个词的形态，那就是漏了引号。空值层：这份 C1 自带 `set -u`，所以带 `-d` 跑它一声不响（退出码 0），这正说明 `set -u` 只挡未设置、不挡空串（0.7.4）；把 `dry=1 dir=''` 那行改成只剩 `dry=1`，再不带 `-d` 跑，第 12 行的 `[[ -n $dir ]]` 就报 `dir: unbound variable`、退出码 1（VM 实测；本机同一处是中文文案「dir: 未绑定的变量」）。破坏性动作层：C1 默认 `dry=1` 只打印，把 `printf 'processing %s\n'` 那一支换成真删除之前，先加一句 `printf 'would rm -rf %q\n' "$dir"` 看原样形式，路径里有空格或名字以 `-` 开头都会在这里现形。

如果你的机器上装了 `shellcheck`，可以再跑一次做对照；本章的判据不依赖它。社区用 SC 编号交流这类问题：SC2086（变量未加引号会被分词与通配）、SC2164（`cd` 失败后继续）、SC2181（用 `$?` 判断而不是直接 `if cmd`）、SC2034（变量赋值后没用过）——0.8.14 有整张编号表。静态检查器替代不了运行测试：上面那五步每步都在真的跑，编号表只是给同样的问题起了名字。

:::
:::
