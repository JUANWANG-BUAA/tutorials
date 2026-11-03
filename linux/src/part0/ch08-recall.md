# 0.8 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · 函数返回

bash 函数有哪三种返回通道？各适合什么？为什么不要用 stdout 返回二进制？

::: sol D1 核对

① 退出码（`return n`/最后一条命令状态），适合成功/失败；② stdout（`$(func)`），适合文本/多行；③ `nameref`（`local -n ref=$1`）或全局变量，适合结构化结果。stdout 会经过命令替换，尾随换行被剥、二进制/NUL 会丢，不适合二进制；多值用 nameref/数组。
:::

### D2 · 数组与 mapfile

索引数组、关联数组、`mapfile -t` 各怎样用？`${arr[@]}` 不加引号会怎样？

::: sol D2 核对

索引数组 `arr=(a "b c")`，`"${arr[@]}"` 保留元素，`"${!arr[@]}"` 取下标，`${#arr[@]}` 个数；关联数组 `declare -A m; m[k]=v`，`"${!m[@]}"` 取键；`mapfile -t lines < file` 按行读入（`-t` 去换行）。`${arr[@]}` 不加引号会分词/通配，元素含空格就散。
:::

### D3 · trap

`trap cleanup EXIT INT TERM` 各在什么时候执行？为什么清理函数要先保存 `$?`、先 `trap -`？

::: sol D3 核对

`EXIT` 在脚本退出（正常/`exit`/捕获信号后）执行；`INT`/`TERM` 在 Ctrl-C/终止信号时执行。先保存 `$?` 才能把原退出码传出去；先 `trap -` 防止清理函数里的命令再次触发 trap，造成递归/重复清理。`kill -9` 不会触发任何 trap。
:::

### D4 · mktemp 与 flock

`mktemp` 与 `flock` 各解决什么问题？为什么不要用 `$$` 拼临时文件名？`flock -n` 是什么？

::: sol D4 核对

`mktemp` 原子地创建唯一临时文件/目录（`mktemp -d`），避免竞态/覆盖；用 `$$` 拼名可预测，容易被抢占/符号链接攻击。`flock` 对文件加建议锁，做单实例/互斥；`flock -n` 拿不到锁立即失败（非阻塞），适合 cron 防重入。锁要跟着 fd 释放，进程退出自动释放。
:::

### D5 · 并发与 wait -n

怎样限制同时运行的后台任务数？`wait -n` 与 `wait` 差在哪？`jobs`/`wait` 在脚本里够用吗？

::: sol D5 核对

用 `wait -n` 等“任意一个”后台任务结束，再启动下一个，维持并发上限；`wait` 不带参数等全部。脚本里 `jobs -p`/`wait -n` 可以做简单限流；更复杂用 `xargs -P`/GNU parallel/任务队列。注意 `wait -n` 的退出码是“被等待任务”的状态，要单独记录每个任务的结果。
:::

### D6 · 参数、日志与 set -e

`getopts` 与外部 `getopt` 各做什么？日志函数应记录什么？`set -e` 在哪些语境不生效？

::: sol D6 核对

`getopts` 解析短选项（`-a`/`-b value`），外部 `getopt` 支持长选项（`--file=...`）。日志函数记录时间（`date -Is`）、级别、脚本名/PID、消息、退出码；日志要能追加、可轮转、不吞错误。`set -e` 在 `if`/`while`/`until`/`&&`/`||`/`!`、管道（除非 `pipefail`）、函数/子 Shell 等语境有例外。
:::

## B. 第二遍：看语义与边界

### D7 · backup.sh 结构

一个可靠的 `backup.sh` 应有哪些步骤？锁、临时目录、校验、清理、退出码各放哪？

::: sol D7 核对

参数解析/usage → 获取锁（`flock -n`）→ 建临时目录（`mktemp -d`）+ `trap cleanup EXIT` → 复制/打包（`rsync`/`tar`）→ 校验（大小/哈希/`tar -t`）→ 写日志（开始/结束/退出码）→ 清理临时文件 → 释放锁/退出。锁防并发，临时目录防半成品，校验防“成功但坏包”，trap 保证异常也清理。
:::

### D8 · nameref 与动态作用域

`local -n ref=$1` 是什么？bash 的函数作用域是动态还是词法？为什么 `local` 不能写在函数外？

::: sol D8 核对

`local -n ref=$1` 创建 nameref，让 `ref` 指向参数名对应的变量，可在函数内改调用者的变量（bash 4.3+）。bash 默认动态作用域：函数里看到的变量取决于调用链，不是定义位置；`local` 只在函数内有效，函数外使用报错/无效。nameref 指向不存在的变量会报错，先检查。
:::

### D9 · 稀疏数组与 mapfile 选项

稀疏数组是什么？`for i in {0..n}` 遍历稀疏数组有什么问题？`mapfile` 的 `-t`/`-n`/`-s` 各做什么？

::: sol D9 核对

稀疏数组是下标不连续的数组（`arr[10]=x`），`${#arr[@]}` 是元素个数，不是最大下标+1；`for i in {0..n}` 会遍历不存在的下标。遍历用 `"${!arr[@]}"`。`mapfile -t` 去每行换行，`-n N` 最多读 N 行，`-s N` 跳过前 N 行；`readarray` 同义。
:::

### D10 · trap 全解

`EXIT`/`ERR`/`DEBUG`/`RETURN` trap 各在什么时候触发？`set -E`/`errtrace` 解决什么？为什么 `ERR` 在函数里可能不触发？

::: sol D10 核对

`EXIT` 脚本/Shell 退出；`ERR` 命令失败（受 `set -e` 例外影响）；`DEBUG` 每条命令前；`RETURN` 函数/`source` 返回时。`set -E`/`errtrace` 让 `ERR` trap 继承到函数/子 Shell。`ERR` 在 `if`/`&&`/`||`/`!` 等条件语境、或函数未开启 `-E` 时可能不触发；关键清理放 `EXIT`。
:::

### D11 · getopt 长选项

外部 `getopt` 怎样解析 `--file=...`/`--verbose`？为什么 `getopts` 做不到？解析后怎样 `eval set --`？

::: sol D11 核对

GNU `getopt -o vo: --long verbose,file: -- "$@"` 输出规范化参数，再 `eval set -- "$parsed"`，用 `while true; case $1 in --file) ...; shift 2;; --) shift; break;; esac` 解析。`getopts` 只支持单字符短选项，不支持 `--long`；外部 `getopt` 是 GNU 工具，BSD/macOS 行为不同。解析后 `shift` 处理剩余位置参数。
:::

### D12 · shellcheck、POSIX 与 source

`shellcheck` 能抓什么？`#!/bin/sh` 与 `#!/usr/bin/env bash` 差在哪？`source` 库怎样防重复？

::: sol D12 核对

`shellcheck` 抓未加引号（SC2086）、`cd` 未检查（SC2164）、用 `$?` 而非 `if`（SC2181）、未使用变量（SC2034）、`set -e` 陷阱等；不替代运行测试。`#!/bin/sh` 在 Debian/Ubuntu 是 dash，不支持数组/`[[`/`(( ))`/`local`/`<<<`/`<()`；要 bash 写 `#!/usr/bin/env bash`。`source` 库用守卫变量或 `BASH_SOURCE` 判断是否已加载，避免重复定义/循环。
:::
