# 进度台账

> 完成状态（2026-10-18）。

## 正文

| 篇 | 完成/总章 |
|:--|--:|
| part0 | 14/14 |
| part1 | 13/13 |
| part2 | 19/19 |
| part3 | 15/15 |
| part4 | 12/12 |
| part5 | 6/6 |

## 项目

| 项目 | 行数 | 状态 |
|:--|--:|:--|
| A 云原生 | 2607 | done |
| B 存储 | ~2500 | done |
| C 网络 | 2539 | done |
| D 工具链 | 2102 | done |

## 验收

- `mdbook build linux`：exit 0，页面级 WARN 0（仅 search index 体积提示）
- `python3 tools/check_book.py`：107 页，问题页/断链/断锚点/重复锚点均为 0
- 仓库根 `./build.sh`：五本构建成功，linux 搜索索引与 138 条术语已生成
- A.4 覆盖矩阵：10 本母本 253 章逐章落点，`tools/build_coverage.py` 校验通过
- 所有正文页含「母本对应」与「下一站」；所有项目页含 Stage 代码/验证/验收

## 已知限制

- 需要 Linux 内核/root 的实验（epoll/io_uring/cgroups/namespace/LVM/RAID）未在真实 Linux 上逐条执行；正文已标注版本与「未实测」。
- 终端输出中的 inode/包版本/耗时是代表性示例，换发行版需复核。
- 共享 `tools/mathbook.py` 对行内代码里的 `$` 有跨 span 吞并问题；本书用局部 `tools/katex_wrapper.py` 与内容侧转义规避，后续修共享工具可根治。
