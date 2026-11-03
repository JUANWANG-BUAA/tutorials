# 《Linux 系统与内核 · 从命令行到云原生》

本目录是这本书的 mdBook 源。上游仓库的 `README.md` 介绍整个教程库；这里只说明本书怎么构建、内容怎么组织、改哪里。

## 1. 结构

```text
book.toml            构建配置（mdBook 0.5 + mathbook + KaTeX）
src/
  SUMMARY.md         目录：卷首 / 6 篇 85 章 / 项目 / 复习层 / 附录
  index.md           封面与导览
  preface.md         为什么写这本书
  scope.md           范围、取舍、淘汰政策
  objectives.md      能力矩阵
  roadmap.md         三条学习路线
  notation.md        符号与命令约定
  env.md             实验环境
  entry-test.md      入学诊断
  part0/ … part5/    正文 85 章
  projects/          项目总览、工程手册、A/B/C/D 四条主线
  review/            速查、易混对照、术语表、回忆卡、自测卷、面试
  appendix/          历史兼容、工具箱、排错、覆盖矩阵、参考文献、勘误
  assets/covers/     封面 SVG
  assets/figures/    内联 SVG 图版（tools/build_figures.py 生成）
theme/               共用主题符号链接 + 本书 linux.css / linux.js
tools/
  mathbook.py        语义盒 / 交叉引用 / 编号
  katex_wrapper.py   本书专用：保护代码里的 $，再调用 mdbook-katex
  build_figures.py   生成 10 张基础图版
  build_coverage.py  生成并校验 A.4 母本覆盖矩阵
  check_book.py      结构质检（围栏 / 盒子 / 锚点 / 链接 / 占位）
写作规范/            总则、各篇大纲、项目规范、进度台账、节级审计
写作规范/source-toc/ 10 本母本的章/节目录（覆盖矩阵与审计脚本的数据源）
requirements.txt     mathbook 依赖（markdown-it-py）
```

## 2. 构建

完整站点（八本一起）：

```bash
cd ..            # 仓库根
./build.sh
./build.sh serve # http://127.0.0.1:8000/
```

只构建本书（搜索索引与术语数据不会生成，仅供预览）：

```bash
mdbook build .
mdbook serve --open
```

依赖：

```bash
brew install mdbook
cargo install mdbook-katex --version 0.10.0
pip3 install -r requirements.txt
```

## 3. 图与覆盖矩阵

```bash
python3 tools/build_figures.py          # 重建全部图版
python3 tools/build_figures.py fd-table # 只重建一张
python3 tools/build_coverage.py         # 生成 A.4 并校验 10 本母本逐章落点
python3 tools/check_book.py             # 结构质检 + 自称数量同步门
python3 tools/check_loss.py             # 教材化改造体量守护（对比 git HEAD）
python3 tools/check_kits.py             # 章末件覆盖率清点（总览 + 五件套）
python3 tools/textbook_lint.py          # 行文体检（非阻塞，供三视角审读）
python3 tools/export_cards.py           # 回忆卡导出 Anki TSV（--stats 先清点）
```

图版输出到 `src/assets/figures/<name>.md`，页面用：

```markdown
{{#include ../assets/figures/fd-table.md}}
```

覆盖矩阵是「不遗漏」的验收依据：`build_coverage.py` 会在有母本章节没映射时报错退出。

## 4. 写作约定

- **教材化改造（2026-10-29 起）以 [`写作规范/70-教材化改造总纲.md`](写作规范/70-教材化改造总纲.md) 为准**：章总览 + 章末五件套、rustwiki 语言、Kerrisk/CSAPP 主干、非科班八条。每章改完按 [`写作规范/72-章节审读表.md`](写作规范/72-章节审读表.md) 做主线/文段/行文三视角审读。
- 每章：`chapter-index` 两栏 → 2–4 段导语 → 编号 H2 → 图/代码/errata/自测 → 本章小结 → 母本对应 → 下一站。
- 盒子：`::: def/thm/ex/intuition/preview/method/errata/think/note`，嵌套 `proof`/`sol`/`hint`；锚点全书唯一。交叉引用写 `[@def-2.2.1]`，引用不存在的锚点**构建失败**。
- 盒子标题可带**优先级标记**：`::: thm[skip]`（core / main / skip），渲染为 `p-core`/`p-skip` 阅读分层，配 `linux.js` 的「只看核心」开关。
- 折叠盒（`sol`/`hint`/`proof`）标题只写「解答」「提示」这类通用词时，构建器自动继承所属例题编号（「解答 · 例 2.2.1」）；有信息量的标题不动。
- **自称数量要与实际一致**：自检表导语「展开成 N 条」、回忆卡「N 张卡」、习题集「共 N 题」都被 `check_book.py` 的同步门对照实际计数，改完套件记得改自称。
- 代码：C17 + POSIX，`-Wall -Wextra -Werror`；错误处理不能省。
- 图：必须有 `<title>`、`<desc>`、`<figcaption>`，图注以「读图：」开头；构建器给图片加 `loading="lazy"`。
- 旧内容：主线只讲现代做法，历史与兼容集中在 `src/appendix/legacy.md`。

详见 `写作规范/00-写作总则.md`（底线）与 `写作规范/70-教材化改造总纲.md`（教材体与改造流程）。

## 5. 已知构建注意

- 本书的 `katex_wrapper.py` 与仓库根版本不同：它在调用 mdbook-katex 前把代码上下文里的 `$` 换成占位符，避免 `$PATH`/`$1` 被当成公式。不要换回根版本。
- `mdbook build` 会清空 `book/`；中文搜索索引与术语数据是构建后产物，必须用仓库根 `./build.sh`。
- 术语表由 `tools/build_glossary.py linux` 从 `src/review/glossary.md` 抽取，`book.toml` 不需要额外配置。
