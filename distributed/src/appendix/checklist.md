# A.4 交付自检与回归清单

> 这份清单给两类人用：写完一章的作者，和准备把书交付出去的维护者。它只列**可机械检查或可复现**的项，不列「文笔是否优美」。

## 1 单章交付

| # | 检查项 | 命令/证据 | 通过标准 |
|--:|:--|:--|:--|
| 1 | 行数 | `wc -l src/partN/chXX.md` | 1000–1400 |
| 2 | 章首两栏 | 搜索 `chapter-index` 与 `本章回答` | 两项都在 |
| 3 | 编号连续 | 检查 H2 编号 `X.Y.Z` | 无跳号、无重复 |
| 4 | 锚点唯一 | `python3 tools/check_book.py` | 0 重复 |
| 5 | 盒子配平 | 同上 | 0 未闭合 |
| 6 | 只用允许盒子 | 同上 | 仅 def/thm/ex/intuition/method/errata/note/proof/sol |
| 7 | 代码围栏有语言 | 同上 | 0 个无语言围栏 |
| 8 | 失败模式 | 搜索 `失败模式` | 至少 1 个，且属于分区/超时/重复/乱序 |
| 9 | 观测命令 | 搜索 `观测` | 至少 1 个可复制命令 |
| 10 | 真实案例 | 搜索 `真实案例` | 至少 1 个，含可核对链接或时间线 |
| 11 | 重试重复副作用 | 搜索 `重复副作用` | 至少 1 个案例 |
| 12 | 陷阱清单 | 末尾 `::: errata` | 8–15 条 |
| 13 | 出口检查 | 末尾表格 | 8–12 行，含「没达标去哪」 |
| 14 | 母本对应 | `## 母本对应` | 至少 3 行，含「不重复」说明 |
| 15 | 下一站 | 最后一段 | 有链接且目标存在 |
| 16 | 图 | `figure`/`pre.layout` | 至少 1 张，SVG id 唯一，有读图结论 |

## 2 全书交付

| # | 检查项 | 命令 | 通过标准 |
|--:|:--|:--|:--|
| 1 | 构建 | `mdbook build .` | 退出码 0，无 warning 级别的断链 |
| 2 | 结构质检 | `python3 tools/check_book.py` | 0 问题、0 断链、0 重复锚点 |
| 3 | 覆盖矩阵 | `python3 tools/check_coverage.py` | 0 缺口 |
| 4 | 脚本语法 | `python3 tools/check_projects.py` | 所有 `.sh` 过 `bash -n`，所有 `.py` 过 `py_compile` |
| 5 | 项目一测试 | `python3 -m unittest -v projects/idempotent-tool/test_server.py` | 全通过 |
| 6 | 项目二测试 | `python3 -m unittest -v projects/replicated-kv/test_kv.py` | 全通过 |
| 7 | 故障注入 | `bash projects/*/fault_inject.sh --dry-run` | 退出码 0 |
| 8 | 重试案例覆盖 | `grep -c 重复副作用 src/part*/ch*.md` | 每章 ≥ 1 |
| 9 | 跨书链接 | 抽查 `../linux/...` 等相对链接 | 目标页面存在 |
| 10 | 禁止项 | 搜索占位标记、未完成提示句 | 0 处 |
| 11 | 图 id | `grep -o 'id="[^"]*"' src/assets/figures/*.md` | 跨文件唯一 |
| 12 | 覆盖矩阵与正文一致 | 抽查 10 个锚点 | 全部能跳转 |

## 3 回归清单（每次改正文后）

1. 改了某章的节号 → 同步改该章锚点、目录、覆盖矩阵、其他章的链接；
2. 改了代码 → 重跑项目测试与 `fault_inject.sh --dry-run`，更新正文里的行号/输出；
3. 改了图 → 重跑 `python3 tools/build_figures.py`，检查 SVG id 是否仍唯一；
4. 改了 SUMMARY → 重跑 `check_book.py`，确认新增页面存在且非空；
5. 改了协议事实 → 在 `CHECK-distributed.md` 里记一条，写清依据（论文/规范/版本）。

## 4 常见「假通过」

| 现象 | 为什么是假通过 | 正确做法 |
|:--|:--|:--|
| `check_book.py` 过了，但章只有 600 行 | 脚本只查 ≥150 行 | 用单章清单第 1 项单独卡 1000–1400 |
| 所有代码块都标了 `text` | 规避了语言检查 | 可运行代码必须标真实语言；伪代码才用 `text` |
| 链接指向 `#` 或空页面 | 没触发断链 | 链接必须有真实目标；跨书用绝对站点路径 |
| 覆盖矩阵每行都写「第 X 章」 | 没有锚点，无法核对 | 每行必须有可跳转的 `sec-...` 锚点 |
| 测试只跑 happy path | 重复/超时/崩溃没覆盖 | 项目测试至少包含丢响应、并发重复、崩溃恢复 |
| 故障脚本只 `echo` | 没注入任何故障 | `--dry-run` 可只打印；真实模式必须改变系统状态 |

::: method 交付前的 10 分钟
```bash
cd distributed
mdbook build . >/tmp/build.log 2>&1; echo "build=$?"
python3 tools/check_book.py; echo "check=$?"
python3 tools/check_coverage.py; echo "coverage=$?"
python3 tools/check_projects.py; echo "projects=$?"
python3 -m unittest discover -s projects/idempotent-tool -p 'test_*.py' >/dev/null; echo "p1=$?"
python3 -m unittest discover -s projects/replicated-kv -p 'test_*.py' >/dev/null; echo "p2=$?"
```
六个 0 才算交付；任何一个非 0，先修再谈内容。
:::
