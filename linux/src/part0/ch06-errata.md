# 0.6 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与文本工具陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换 GNU/BSD、换 locale、换 awk 实现后要复核什么**。

**本章基线**：Ubuntu 24.04、GNU grep 3.11、GNU sed 4.9、mawk 1.3.4（Ubuntu 默认）或 gawk 5.2、coreutils 9.4。换环境时逐条复核。

## 1. 正则与 grep

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `a+` 在 grep 里就是“一个或多个 a” | 默认 BRE，`+` 是普通字符；要 `grep -E 'a+'` 或 `grep 'a\+'` | `printf 'a\naa\n' \| grep 'a+'` 对比 `grep -E 'a+'` |
| 2 | grep 退出码 1 是错误 | 1 表示“没有匹配”；2 才是错误 | `grep x /dev/null; echo $?`、`grep x /no/such; echo $?` |
| 3 | `grep -P` 到处能用 | 只有 GNU grep 编了 PCRE 才支持；BSD/macOS 默认不支持 | `grep -P '\\d' /dev/null; echo $?` |
| 4 | `grep -F` 和 `grep` 一样 | `-F` 按固定字符串匹配，不做正则回溯，通常更快 | `grep -F 'a.b'` 与 `grep 'a.b'` 对比 |
| 5 | `[a-z]` 永远只匹配 26 个字母 | UTF-8 locale 下可能受 collation 影响 | `LC_ALL=C` 与 `LC_ALL=en_US.UTF-8` 对比 |
| 6 | 复杂正则最多慢一点 | 嵌套量词可能灾难性回溯，CPU 飙高 | 用长串 `a` 测试 `(a+)+b`，加 `timeout` |

## 2. sed

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | sed 默认不输出 | 默认输出模式空间；`-n` 才关闭 | `printf 'a\n' \| sed 'p'` 与 `sed -n 'p'` 对比 |
| 8 | `sed -i` 改的是同一个 inode | GNU sed 写临时文件 + rename，inode 变了，硬链接断开 | `ls -li`、`stat -c %i` 前后对比 |
| 9 | `sed -i` 会自动备份 | 不加后缀不备份；`-i.bak` 才留备份 | `ls file*` 对比 |
| 10 | 地址 `2,4` 与 `2;4` 一样 | `2,4` 是范围，`2;4` 是两个独立地址 | `sed -n '2,4p'` 与 `sed -n '2;4p'` 对比 |
| 11 | hold space 就是第二个文件 | 它是每行循环之间保留的缓冲区，初始为空 | `sed -n '1!G;h;$p'` 观察倒序 |
| 12 | `s///g` 会跨行替换 | 默认按行处理，`g` 只替换行内所有匹配；跨行要 `N`/`z` 等 | 多行输入测试 |

## 3. awk 与工具链

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 13 | awk 默认按空格切字段 | 默认 `FS` 是空白（空格/tab），连续空白算一个分隔符；`-F,` 才按逗号 | `awk '{print NF}'` 对比 `awk -F, '{print NF}'` |
| 14 | `%d` 会四舍五入 | `%d` 向零截断；`%.2f` 才按浮点舍入 | `awk 'BEGIN{printf "%d %.2f\n", 3.9, 3.9}'` |
| 15 | awk 数组按插入顺序遍历 | `for (k in a)` 的顺序未定义；要排序用 `asort`/`asorti`（gawk）或管道 `sort` | 多次运行观察顺序 |
| 16 | `uniq` 能去重任意重复 | `uniq` 只处理相邻重复行，必须先 `sort` | `printf 'b\na\nb\n' \| uniq` 对比 `sort \| uniq` |
| 17 | `sort` 在所有 locale 下结果一样 | locale 影响排序规则；`LC_ALL=C` 按字节序 | `LC_ALL=C sort` 与默认 `sort` 对比 |
| 18 | `diff -u` 与 `cmp` 一样 | `diff` 文本差异/补丁；`cmp` 字节级比较 | `diff -u a b`、`cmp -l a b` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的发行版/awk 实现上使用前先验证：

- Ubuntu 默认 `awk` 可能是 mawk，不是 gawk；`asort`/`asorti`/`gensub` 等 gawk 扩展不一定可用。`awk --version` 查看。
- `grep -P`、`sed -E`、`sed -i` 的具体行为随 GNU/BSD 版本变化；macOS 的 BSD sed `-i` 需要参数。
- `LC_ALL=C` 的性能优势取决于输入与 locale 实现；绝对秒数不要跨机器比较。
- `sed -i` 对 ACL/xattr 的保留程度依版本与文件系统；备份后再改。
- awk 浮点是 IEEE 754 双精度，具体舍入结果依实现；金额用整数分。

## 5. 发现新问题怎么记

如果你在别的 grep/sed/awk 实现上发现本章结论不成立，按「现象 → 命令/输出 → 工具版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
