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

## 全书优化轮（2026-10-24/25）

两阶段全书优化，明细见各 CHECK 报告末尾的「修复记录（2026-10-24）」小节：

1. **事实修复**：五份母本核查报告（CLI/CSAPP/KERRISK/KERNEL-NET/NETWORK）的 A 表条目全部处置完毕——本轮修复 54 条、核实此前已修复 78 条、未找到 0。另对从未核查过的 part5/复习层/附录/卷首新做一轮核查（报告 `CHECK-CLOUD-REVIEW-ERRORS.md`，修复 8 条、存疑 3 条），并在报告未覆盖的 1.14–1.19 扫出 3 处硬错误。
2. **文稿优化**：errata 盒全书拆组 41 处（原 8–15 条「清单墙」按主题拆为每组 3–6 条）；补齐 1.14/1.18/1.19 缺失的「即时自测」盒（各 4 问 4 答）；行文修正 30 余处（指代、断句、交叉引用错序、标题与条数不符、绝对化断言条件化）；术语统一（part4「头部→首部」等）。

验收：`check_book.py` 113 页 0 问题；`verify_teaching_examples.py` 4/4；`mdbook build` exit 0 无页面级告警。

遗留：五份报告 B 表的实质漏节共约 73 条未补写（各报告内已逐条列明，可作下一轮增补的输入）；`CHECK-CLOUD-REVIEW-ERRORS.md` 存疑 3 条。

## 已知限制

- 需要 Linux 内核/root 的实验（epoll/io_uring/cgroups/namespace/LVM/RAID）未在真实 Linux 上逐条执行；正文已标注版本与「未实测」。
- 终端输出中的 inode/包版本/耗时是代表性示例，换发行版需复核。
- 共享 `tools/mathbook.py` 对行内代码里的 `$` 有跨 span 吞并问题；本书用局部 `tools/katex_wrapper.py` 与内容侧转义规避，后续修共享工具可根治。
