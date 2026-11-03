# 0.8 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、函数、数组与 trap**（0.8.1–0.8.3） | 函数怎样返回？列表怎样存？清理放哪？ | 函数有三种返回通道：退出码、stdout、nameref/全局变量；索引用 `arr=(...)`，关联数组 `declare -A`，`mapfile -t` 读行；`trap cleanup EXIT` 保证清理。 | 用 stdout 返回二进制/多行；`${arr[@]}` 不加引号；`trap` 在 `EXIT` 与 `INT` 里重复执行。 |
| **二、临时文件、锁、并发与错误**（0.8.4–0.8.5） | 怎样不冲突、不并发踩踏、错误不吞？ | `mktemp` 建临时文件/目录，`trap` 清理；`flock` 做单实例锁；`wait -n` 限流；日志函数带时间戳/级别；`set -e` 有裂缝，要 `pipefail`/`ERR` trap 补。 | 用 `$$` 拼临时文件名；锁文件不释放；`set -e` 在 `if`/`&&`/管道里不生效。 |
| **三、完整 backup.sh**（0.8.6–0.8.7） | 一个生产脚本长什么样？ | 参数解析 → 锁 → 临时目录 → 复制/打包 → 校验 → 日志 → 清理 → 退出码；`shellcheck` + `set -x` 做静态/动态检查。 | 不锁导致并发跑；不校验；清理顺序错；日志没有退出码。 |
| **四、语义与全解**（0.8.8–0.8.15） | 函数/数组/trap/锁/并发/参数/库的边界？ | 函数返回码/`nameref`/动态作用域；数组稀疏与 `mapfile` 选项；`trap` 的 `EXIT/ERR/DEBUG/RETURN`；`mktemp`/`flock`；`wait -n`；`getopt` 长选项；`shellcheck` 规则；`source` 库要防重复。 | `local -n` 指向不存在的变量；稀疏数组 `for i in {0..n}`；`ERR` trap 在函数里不触发；`source` 循环。 |
| **五、复盘与脚本**（0.8.16–0.8.20） | 怎样把脚本变成可维护工具？ | 逐行复盘 `backup.sh`；用 `shellcheck`/`strace`/`flock` 实验验证；抄三个可复用脚本；过陷阱清单。 | 只读不跑；不 `shellcheck`；不做并发测试；不写复盘。 |

## 一条主线

这一章从“能跑”走到“可维护”。**先把重复逻辑封装成函数、用数组存列表、用 `trap` 保证清理**；**再处理临时文件、锁、并发、参数、日志与 `set -e` 裂缝**；**用一个完整 `backup.sh` 把参数、锁、临时目录、复制/打包、校验、日志、清理、退出码串起来**。第二遍回到语义与全解：函数返回码/`nameref`/动态作用域、数组稀疏与 `mapfile`、`trap` 的 `EXIT/ERR/DEBUG`、`mktemp`/`flock`、`wait -n`、`getopt` 长选项、`shellcheck` 规则、`source` 库。**最后逐行复盘、做实验、抄三个脚本、过陷阱清单。**

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| 函数返回多值很别扭 | 退出码 + stdout + `nameref` 三选一 | 退出码只适合状态；stdout 适合文本；`nameref` 适合结构化结果。 |
| 列表里有空格/换行 | 用数组/`mapfile -t`，不要用字符串 | 字符串会分词；数组保留元素边界。 |
| 脚本退出后临时文件残留 | `mktemp` + `trap cleanup EXIT` | 异常退出也能清理。 |
| 两个 cron 同时跑 | `flock -n 9` 或 `flock -n "$lock"` | 单实例锁；拿不到锁就退出/排队。 |
| 后台任务太多打满机器 | `wait -n` + 并发上限 | 控制同时运行的任务数。 |
| 长选项解析不了 | 外部 `getopt` 或手写 `case` | `getopts` 只支持短选项。 |
| `set -e` 没停 | 检查 `if`/`&&`/`||`/管道/函数上下文 | 这些语境有例外；用 `ERR` trap/`pipefail` 补。 |
| 日志里没有退出码/时间 | 写 `log()` 函数，记录 `date -Is`、级别、`$?` | 事后排障靠日志证据。 |
| 脚本在 macOS 上跑不了 | `shellcheck` + `#!/usr/bin/env bash` + 避免 GNU 专有 | macOS bash 3.2/BSD 工具不同。 |
| `source` 两次重复定义 | 用 `BASH_SOURCE`/守卫变量 | 库被多次 source 会重复执行。 |

## 能否讲出这八句话

1. 函数返回有三条通道：退出码（状态）、stdout（文本）、`nameref`/全局变量（结构化结果）。
2. 数组用 `"${arr[@]}"` 保留元素边界，`"${!arr[@]}"` 取下标，`mapfile -t` 按行读入。
3. `trap cleanup EXIT` 保证正常/异常退出都清理；`set -E` 让 `ERR` trap 在函数里也生效；`trap -` 防递归。
4. 临时文件用 `mktemp`，不要用 `$$` 拼名；单实例用 `flock`，锁要跟着 fd 释放。
5. 并发用 `wait -n` 限流；不要一次性 fork 几千个后台任务。
6. `set -e` 在 `if`/`while`/`&&`/`||`/`!`/管道等语境有例外；用 `pipefail`/`PIPESTATUS`/`ERR` trap 补。
7. `getopts` 解析短选项，外部 `getopt` 解析长选项；解析完 `shift $((OPTIND-1))`。
8. `shellcheck` 抓静态坑，`set -x`/`PS4` 看展开，POSIX 边界决定脚本能不能在 `sh` 里跑。

## 学完之后

1. **[闭卷回忆卡](ch08-recall.md)**：先合上正文，把函数返回、数组、`trap`、锁/并发、`set -e` 裂缝五组结论从空白纸上叫出来。
2. **[习题集](ch08-exercises.md)**：A 组检查概念，B 组诊断“为什么锁没生效/为什么 trap 跑两次/为什么函数返回值丢了”，C 组写 `backup.sh`、并发限流与 `flock` 实验。
3. **[学习目标自检表](ch08-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch08-errata.md)**：把 bash 3.2/5.2、GNU/BSD、`flock`/`mktemp` 的差异过一遍。
5. **下一站**：[0.9 进程、作业控制与信号](ch09.md) 会进入进程模型；本章的锁、并发与 `trap` 会在那里接到 `fork`/`exec`/信号。
