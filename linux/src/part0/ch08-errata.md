# 0.8 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与工程化陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换 bash、换 GNU/BSD、换文件系统后要复核什么**。

**本章基线**：Ubuntu 24.04、bash 5.2、util-linux 2.39（`flock`/`mktemp`）、GNU coreutils 9.4、shellcheck 0.9。换环境时逐条复核。

## 1. 函数、数组与 trap

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | 函数 `echo` 的结果可以直接当返回值 | 命令替换会剥尾随换行；二进制/NUL 会丢 | `f(){ printf 'a\n\n'; }; x=$(f); printf '%q\n' "$x"` |
| 2 | `${arr[@]}` 不加引号也行 | 会分词/通配；元素含空格就散 | `a=('x y' z); printf '<%s>\n' ${a[@]}` 对比 `"${a[@]}"` |
| 3 | 数组长度是最大下标+1 | `${#arr[@]}` 是元素个数；稀疏数组下标不连续 | `a[10]=x; echo ${#a[@]} ${!a[@]}` |
| 4 | `trap cleanup EXIT` 只跑一次 | `INT`/`TERM` 里再 `exit` 会触发 `EXIT`，可能跑两次 | Ctrl-C 测试；清理函数里先 `trap -` |
| 5 | `trap` 能捕获 `kill -9` | `SIGKILL`/`SIGSTOP` 不可捕获 | `trap 'echo bye' EXIT; kill -9 $$` |
| 6 | `ERR` trap 在函数里一定触发 | 需要 `set -E`/`errtrace`；条件语境也有例外 | 函数里 `false`，对比 `set -E` 前后 |
| 7 | `local -n` 所有 bash 都支持 | bash 4.3+ 才有 nameref；macOS 3.2 不支持 | `bash --version`、`local -n` 测试 |

## 2. 临时文件、锁与并发

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 8 | `$$` 拼临时文件名很安全 | PID 可预测/复用，易被抢占/符号链接攻击 | 用 `mktemp`/`mktemp -d` |
| 9 | `flock -n` 拿不到锁会报错退出 | `flock` 只返回非零，脚本要继续检查并退出 | `flock -n 9 || exit 1` |
| 10 | 锁文件删了锁就释放 | 锁跟 inode/fd 绑定；删文件可能让新进程锁到新 inode | 不要删锁文件；用固定路径 |
| 11 | `flock` 在 NFS 上可靠 | NFS 的 `flock` 语义依实现/挂载选项，可能不可靠 | 查 `nfs(5)`/`mount` 选项；关键任务用本地锁/数据库锁 |
| 12 | `wait -n` 的退出码能区分每个任务 | 只代表“某一个”结束的任务 | 每个任务把状态写到文件/数组 |
| 13 | `wait` 能等到所有后台任务 | 能，但不会限流；一次 fork 太多会打满 | 用 `jobs -rp` + `wait -n` 或 `xargs -P` |

## 3. 参数、日志、shellcheck 与库

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 14 | `set -e` 会让所有失败退出 | `if`/`while`/`&&`/`||`/`!`/管道/函数等语境有例外 | 逐语境测试；用 `ERR` trap |
| 15 | 管道失败会返回非零 | 默认只看最后一段；要 `pipefail`/`PIPESTATUS` | `false \| true; echo $?` |
| 16 | `getopts` 能解析 `--long` | 只支持短选项；长选项用外部 `getopt`/手写 | `getopts 'a'` 后跟 `--long` |
| 17 | 外部 `getopt` 到处一样 | GNU getopt 支持 `--long`；BSD/macOS 行为不同 | `getopt --version`、在 macOS 测试 |
| 18 | `source` 两次没关系 | 会重复定义/执行副作用；可能递归 source | 用守卫变量/`BASH_SOURCE` |
| 19 | `shellcheck` 通过就没有 bug | 只做静态检查，不替代运行/边界/并发测试 | 造逻辑错误但语法正确的脚本 |
| 20 | bash 脚本在 `sh` 里能跑 | 数组/`[[`/`(( ))`/`local`/`<<<`/`<()` 是 bash 扩展 | `dash script.sh` 测试 |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的 bash/发行版上使用前先验证：

- `flock` 在 NFS/overlayfs/容器里的语义依实现与挂载选项；关键任务用数据库/etcd 锁或单实例服务。
- `wait -n` 在 bash 4.3+ 才有；macOS bash 3.2 不支持。
- `local -n`（nameref）在 bash 4.3+；macOS 3.2 不支持。
- `mktemp` 的模板/`--suffix` 选项在 GNU/BSD 上不同；`mktemp -d` 通用。
- `shellcheck` 规则编号随版本变化；以本机 `shellcheck --version` 与 Wiki 为准。

## 5. 发现新问题怎么记

如果你在别的 bash/文件系统上发现本章结论不成立，按「现象 → 命令/输出 → 版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
