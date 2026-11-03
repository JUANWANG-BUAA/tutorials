# 0.7 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与 Bash 陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换 bash、换 `/bin/sh`、换 GNU/BSD 工具后要复核什么**。

**本章基线**：两台机器各跑一遍——写作机 macOS（Apple 芯片，bash 5.3.20，`/bin/bash` 是系统自带的 3.2.57，BSD 版 `date`/`df`/`mv`/`sed`）与 Ubuntu 24.04.5 LTS 虚拟机（bash 5.2.21、dash 0.5.12、GNU coreutils 9.4、GNU `sed` 4.9、mawk 1.3.4）。**`shellcheck` 两台都没装**（两边 `command -v shellcheck` 都返回空），本章不给它的输出，只用 0.7.15 那条 `bash -n` 加手工六步的路径；你自己的机器上装了更好，它的规则编号怎么读见 [0.8](ch08.md)。换环境时逐条复核。

## 1. 骨架、变量与引号

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `#!/bin/bash` 在所有机器上都一样 | macOS 自带 bash 3.2；`/bin/sh` 在 Debian/Ubuntu 是 dash | `bash --version`、`ls -l /bin/sh` |
| 2 | `set -e` 会让所有失败都退出 | `if`/`while`/`until`/`&&`/`||`/`!`/管道等语境有例外 | `set -e; false; echo still` vs `if false; then :; fi` |
| 3 | 变量不加引号也没事 | 会分词/通配；空变量让 `[` 报错 | `x='a b'; printf '<%s>\n' $x` 对比 `"$x"` |
| 4 | `"$@"` 与 `"$*"` 一样 | `"$@"` 保留每个参数；`"$*"` 用 `IFS` 合成一个 | 带空格参数测试 |
| 5 | `local` 可以写在函数外 | `local` 只在函数内有效；函数外报错或无效 | 在脚本顶层写 `local x=1` |
| 6 | `[` 与 `[[` 可以互换 | `[` 是命令，`[[` 是 bash 关键字；`[[` 支持 `&&`/`||`/`=~` | 空变量、`&&` 测试 |
| 7 | `${var:-x}` 与 `${var-x}` 一样 | `:` 形式把“空”也当未设；不带 `:` 只判断未设 | `var=''; echo "${var:-x}" "${var-x}"` |

## 2. 展开、条件与循环

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 8 | `${var#p}` 与 `${var##p}` 一样 | `#` 最短、`##` 最长；`%`/`%%` 同理 | 用多段前缀/后缀测试 |
| 9 | `read` 一定能读到最后一行 | 文件末尾无换行时 `read` 返回非零，循环会漏掉 | `printf 'a\nb' \| while read l; do echo "$l"; done` |
| 10 | 管道退出码看整条 | 默认只看最后一段；要 `pipefail`/`PIPESTATUS` | `false \| true; echo $?` |
| 11 | `set -o pipefail` 能告诉哪段失败 | 只让整条失败；具体段看 `PIPESTATUS` | `false \| true; echo "${PIPESTATUS[@]}"` |
| 12 | `getopts` 能解析长选项 | 只支持短选项；长选项要手写 `case`/`--` | `getopts 'a'` 后跟 `--long` |
| 13 | `((...))` 与 `$((...))` 一样 | `$((...))` 展开值；`((...))` 当命令，返回退出码 | `((1>0)); echo $?` vs `echo $((1>0))` |
| 14 | `case` 只匹配字符串 | 支持 glob 模式（`*`/`?`/`[...]`） | `case foo in f*) echo match;; esac` |

## 3. trap、可移植性与工具

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 15 | `trap cleanup EXIT` 一定会跑 | `kill -9` 不会触发；`exec` 替换进程也不触发 | `trap 'echo bye' EXIT; kill -9 $$` |
| 16 | `ERR` trap 等价于 `set -e` | `ERR` 也受 `set -e` 例外影响；函数/子 Shell 里传播复杂 | 在 `if`/`&&`/函数里触发失败 |
| 17 | 清理函数里可以直接 `exit` | 先保存 `$?`、先 `trap -`，否则退出码丢失/递归 | 故意让清理命令失败 |
| 18 | bash 脚本可以在 dash 里跑 | 数组、`[[`、`(( ))`、`local`、`<<<`、`<()` 等是 bash 扩展 | `dash script.sh` 测试 |
| 19 | `shellcheck` 通过就万事大吉 | 它只做静态检查，不替代运行测试/边界测试；本书两台机器都没装它，0.7.15 用 `bash -n` 加手工六步拿同一层证据 | 造一个逻辑错误但语法正确的脚本，先 `bash -n`、再按手工六步走一遍 |
| 20 | macOS 的 `sed -i` 与 GNU 一样 | BSD sed `-i` 需要参数（`-i ''`）；grep/sort 也有差异 | 在 macOS 跑 `sed -i 's/a/b/' f` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的 bash/发行版上使用前先验证：

- macOS 自带 bash 3.2 不支持 `${var,,}`/`${var^^}`、`mapfile`、`declare -A` 等；需要新版 bash 用 Homebrew。
- `set -e` 的传播规则在函数、子 Shell、命令替换、`trap ERR` 组合下依 bash 版本有差异；以本机测试为准。
- `shellcheck` 的规则随版本变化；SC2086/SC2181 等编号可能新增/调整。本书两台机器都没装它，本章涉及的 SC 编号一律按文档陈述，未做实测。
- `getopts` 的行为在 POSIX sh 与 bash 中基本一致，但 `OPTERR`/`POSIXLY_CORRECT` 会影响错误输出。
- `trap` 对 `SIGKILL`/`SIGSTOP` 无效；容器 PID 1 对信号的处理依 runtime 不同。

## 5. 发现新问题怎么记

如果你在别的 bash/发行版上发现本章结论不成立，按「现象 → 命令/输出 → bash 版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
