# 《矩阵论》讲义整理版 · 第一章 线性空间引论（附第二、三章，续写中）

线性空间 · 线性子空间 · 基与坐标 · 内积空间 · 长度与夹角 · 直和与投影 —— 依据本课程六次课课件整理扩充的教程。

**第二章（2.1–2.5）**：映射与多项式、线性映射、矩阵与同构、特征值与特征向量、正交 / 酉变换（含 Givens 与 Householder）—— 2.1–2.2 依据第二章课件与第 3 周录播（2026-09-22，王振乾）整理；**2.3 依据官方课件整理**（`raw/decks/2.3-矩阵与同构.pdf`，无录播，课件省略的证明已补全）；**2.4–2.5 依第 5 周录播转录整理**（2026-10-08，`raw/lec2_transcript.txt`，该讲把第二章讲完；课件入库后再行编号对照）；2.6–2.7 随素材续写。

**第三章（3.1–3.2）**：相抵分解、满秩分解 —— 依据官方课件 `3.1-相抵分解.pdf`（15 页）、`3.2-满秩分解.pdf`（9 页）整理；两节**均无录播**，课件省略的证明（引理 3.1.1、定理 3.2.2 等）由本编补全并标注，四条课件勘误见[第三章勘误](src/ch03/errata.md)；3.3 及以后随素材续写。

**官方课件已入库**：`raw/decks/` 存放学院发出的 2.1 / 2.2 / 2.3 / 3.1 / 3.2 五份 PowerPoint 版课件（PDF），`raw/decks/extract_figs.py` 由它们渲染正文插图（此前用的是录播截屏，字小且有黑边；按 `--chapter ch02|ch03` 选择章）。

**面向学习而不只是阅读**：带入学诊断、先修复习、节末即时自测、分级习题（含提示层）、100 分制综合自测卷，全部内容附解。

**动手层**：正文嵌入可拖动的交互图解（投影分解、Cauchy–Schwarz、Gram–Schmidt 分步、换基、线性映射、特征方向）——零依赖、离线可用、配色随明暗主题、控件是原生元素因此键盘与读屏都可用。

用 [mdBook](https://rust-lang.github.io/mdBook/) 构建（与 rustwiki 系列同一套工具链），带**中文全文搜索、明暗主题、页内锚点、键盘翻页、离线公式**，公式在构建期渲染，站点不依赖任何 CDN。

## 快速开始

```bash
brew install mdbook            # 构建器
cargo install mdbook-katex     # 公式预处理器
pip3 install -r requirements.txt

make serve                     # 本地预览 http://localhost:3000
make build                     # 生成静态站点到 book/
make check                     # 测试 + 一致性 + 构建 + 渲染 + 死链 + 搜索自检
make check-ui                  # 浏览器层验收：交互部件绘制 + 键盘导航（需 Playwright）
```

> **构建分两步**：`mdbook build` 之后还需 `node tools/build_search_js.mjs book` 重建
> 中文搜索索引（mdBook 自带分词器不处理中文）。`make` 已封装，手工操作时别漏第二步。

## 学习支持结构

正文之外，教程提供一条完整的学习闭环。**三章都有各自的章末套件**：

| 环节 | 页面 | 作用 |
|:--|:--|:--|
| **定位起点** | [入学诊断自测](src/entry-test.md) | 14 道小题测先修 + 本章预诊，给出三条阅读路径 |
| **补先修** | [先修工具箱](src/prerequisite.md) | 矩阵乘法列观点、可逆等价、秩与自由未知量、特征值与特征多项式等，正文引用的先修事实集中于此 |
| **读完就回忆** | 每节末的「即时自测」 | 每节 4–6 道回忆题，先合上页面作答再展开核对 |
| **先压缩再背** | [速查背记卡](src/memory-sheet.md) | 每个定义/定理一句「最小可背诵单元」+ 口诀索引 + 对比表 + 反例表；可导出 Anki |
| **练** | 第一[习题集](src/ch01/exercises.md) · 第二[习题集](src/ch02/exercises.md) · 第三[习题集](src/ch03/exercises.md) | 各为 A/B/C 三组（47 题 / 51 题 / 38 题）全附解；B 组与难题另有折叠「提示」层 |
| **验收** | 第一[自测卷](src/ch01/mock-exam.md) · 第二[自测卷](src/ch02/mock-exam.md) · 第三[自测卷](src/ch03/mock-exam.md) | 闭卷计时、100 分制，含评分标准与复盘方法 |
| **反查** | 第一[自检表](src/ch01/checklist.md) · 第二[自检表](src/ch02/checklist.md) · 第三[自检表](src/ch03/checklist.md) | 逐条目标对到正文小节与具体题目（25 条 / 40 条 / 26 条） |
| **主动提取** | [闭卷回忆卡](src/ch01/recall-cards.md) | 只有问题、先合上页面作答再展开核对；`make test` 会校验卡数没有掉 |
| **动手** | 正文中的「动手」交互图解 | 拖一下就看见投影、正交化、换基、特征方向怎么变（零依赖、离线可用） |
| **接着做** | 折叠块会记住你展开过哪些 | 解答标题带题号（「解答 · 例 1.5.B」），翻页回来仍在原处；图片按需加载，长页首屏快 |

## 仓库结构

```
src/       内容源（Markdown），SUMMARY.md 是唯一的目录树；页面粒度 = 分节，
           小节是分节页内的 H2（带 sec-1.x.y 稳定锚点）
theme/     视觉层：css/matrix.css（唯一权威样式）、katex.css、js/matrix.js
           （进度条、本页内容目录、解答与提示折叠）、js/search-cjk.js、
           js/matrix-interactive.js（交互图解部件）
tools/     mathbook.py（预处理器）、build_search_js.mjs（中文搜索索引）、
           check_links.py（死链与死锚点检查）、check_consistency.py（内容一致性：
           记号/术语/盒类型/自称数字）、export_cards.py（回忆卡导出 Anki）、
           serve_book.py + check_widgets.mjs + check_navigation.mjs（浏览器层验收）、
           merge_sections.py（结构重组，一次性）、legacy_migrate.py（旧版内容迁移，一次性）
raw/       素材：decks/（官方 2.1–2.3、3.1–3.2 课件 PDF + extract_figs.py 插图抽取）、
           录播转录、录屏抽帧（详见 raw/README.md）
docs/      架构与写作约定（先读这个）
_build/    旧版自研生成器与页面（已冻结，仅用于回滚比对）
```

## 写作要点

内容用语义盒子书写，编号与引用交给构建器：

```markdown
::: def 定义 1.1.3 · 数域 field {#def-1.1.3}
设 $F$ 是非空数集……则称 $F$ 为一个**数域**。
:::

……即为 [@def-1.1.3] 中定义的数域。
```

`[@def-1.1.3]` 会自动渲染成「定义 1.1.3」并链到该处；**引用了不存在的锚点会让构建失败**，避免编号在增删章节后静默失效。

交互图解写在顶层（**不能放进盒子**——盒子会抹掉空行，而 CommonMark 的 HTML 块遇空行
即终止），只声明 `data-widget` 名字，控件由 JS 生成原生元素以保证键盘与读屏可用：

```html
<div class="widget" data-widget="gram-schmidt">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">…</strong></p>
<p class="widget-hint">拖动金色端点可以换一个 $\boldsymbol{x}_2$……</p>
</div>
```

完整约定（盒子类型表、编号策略、新增一节与新增一个交互部件的步骤、发布流程）见
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。

## 设计原则

1. **保留原编号**：全部定义、定理、例题沿用课件编号（如「定义 1.1.3」），可与课件逐条对照。
2. **敢于勘误**：原课件的问题（数学错误、缺失证明、编号重复、证明跳跃、记号循环与概念边界混淆）已修正：第一章十五处（[勘误表](src/ch01/errata.md)）、第二章课件与口述问题（[勘误与补注](src/ch02/errata.md)）、第三章四条课件勘误与七处补全（[勘误与补注](src/ch03/errata.md)）均可回链。
3. **从识别到提取**：[证明骨架](src/proof-workshop.md)训练第一行，[闭卷回忆卡](src/ch01/recall-cards.md)训练定义、定理与证明入口的主动提取。
4. **单一事实来源**：内容只在 `src/`，样式只在 `theme/css/matrix.css`；其余皆为构建产物。
5. **构建即校验，三层**：**结构**层（悬空引用、重复锚点、未闭合盒子、死链）、
   **内容**层（记号、术语、盒类型、文档自称的数字）、**交互**层（部件是否真的画出来、
   交互之后 ←/→ 是否还能翻页）都会让 CI 失败——「自己声明的约定」必须由机器检查，
   否则必然漂移。第三层单独存在是因为它的失败**静默**：JS 抛错时页面照样返回 200，
   只是少了一块图（详见 [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) §2.2 与 §4.2）。
