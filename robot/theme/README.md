# 视觉层

设计规范与版式纪律完全沿用《矩阵论》《数值分析》第一章教程（Academy / warm /
standard density，八段式单一权威样式表）。本目录为该设计语言的第三份实例化。

## 文件

| 文件 | 作用 |
|:--|:--|
| `css/robot.css` | **唯一权威样式**：设计令牌 → mdBook 变量映射 → 框架适配 → 语义盒子 → 表格/图/公式 → 首页 → 响应式 → 打印 |
| `css/katex.css` | KaTeX 布局规则 + 字体声明（仅 woff2，离线） |
| `js/robot.js` | 进度条、展开全部解答、打印前展开（渐进增强） |
| `js/search-cjk.js` | 中文搜索分词（见 docs/ARCHITECTURE.md §2.1） |

字体文件在 `src/fonts/katex/`（mdBook 会整体复制 `src/`）。

## 规矩

1. **改样式只改 `robot.css`**，不要新增覆盖层。
2. **字体角色不越界**：display serif 用于章节标题；text serif 用于正文；sans 用于
   导航与控件；mono 用于编号、标签与证据。
3. **每个面板都有可见边框**，不用纯阴影做分隔；不用毛玻璃、发光、紫色渐变。
4. **动效只用于状态变化**，并遵守 `prefers-reduced-motion`。

## 两处容易踩的 mdBook 陷阱

- **标题文字整段被包在 `<a class="header">` 里**：`.header` 必须 `color:inherit`，
  锚点提示用 `::after` 悬停出现，不要隐藏 `.header` 本身。
- **`--serif` 是 `var(--serif-display)` 的别名**：对 `--serif` 一律用 `font-family`
  等长属性，不要用 `font:` 简写（嵌套 `var()` 会让整条声明失效）。

颜色对比度按 WCAG AA 验算过（正文级文字 ≥4.5:1，大字与装饰线 ≥3:1），
改色后请重新验算。

## 三本书共用层（2026-10 起）

以下两份文件在 `robot` / `numerical` / `matrix` 三本书里**逐字相同**（改动请同步三处，
内容用 `shasum` 校验）：

| 文件 | 作用 |
|:--|:--|
| `css/prefs.css` | **阅读偏好层**：字体（衬线/黑体/系统）、字号（小/中/大）、行距间距（紧凑/标准/宽松）、版心宽度（窄/标准/宽）、配色主题（暖纸/冷灰/苔绿/高对比）。由 `<html>` 上的 `data-*` 属性驱动，属性由 `js/prefs.js` 写入、`head.hbs` 在首屏前预置。默认档（serif / m / standard / standard / warm）不写任何属性，外观与本层出现之前一致。 |
| `js/sidebar.js` | **侧栏**：折叠、编号分列、本页大纲、跟随当前小节。用**一个捕获阶段监听器**统一接管折叠，先于 mdBook 自带的处理器触发并 `stopPropagation`，避免「同一个 chevron 上有两个处理器改两个不同 `<li>`」；默认只展开通向当前页的那条路径。 |
| `head.hbs` | 首屏防闪：在 `<head>` 阶段把读者的偏好读成 `data-*` 属性，避免先按默认外观画一帧再跳。 |

`book.toml` 的加载顺序有约束：`prefs.css` 必须排在权威样式表**之后**（同特异性靠
后加载覆盖），`sidebar.js` 必须排在 `toc.js` 之后（`additional-js` 天然满足）。

配色主题只改「中性面 + 强调色」，语义盒子（定义/定理/例题…）的配色不动；四套主题的
`--muted` 与 `--accent-text` 都按 WCAG AA（≥4.5:1）在 `--page` 与 `--sidebar` 上验算过。

### 共用层补充（framework.css / framework.js）

| 文件 | 作用 |
|:--|:--|
| `css/framework.css` | mdBook 框架 UI 的修补：搜索面板限高与分隔、主题弹层、键帽 `<kbd>`、回到顶部、焦点环；以及列表 `ol/ul` 的行高（框架把它们钉在 1.45em，同 `.content p` 一并接管）。 |
| `js/framework.js` | 框架文案汉化（菜单栏、搜索框、主题名、帮助弹窗、复制按钮、翻页箭头）、搜索结果统计行汉化与键盘滚动、回到顶部、折叠状态记忆（解答/提示，按页存 localStorage）。 |

这两份与 `prefs.css` / `prefs.js` / `sidebar.js` / `head.hbs` 一样三本逐字相同。
CI 里中文搜索依赖 `node tools/build_search_js.mjs <book>/book`（**构建后**执行），
`.github/workflows/deploy.yml` 已含该步；`book.toml` 的 `use-boolean-and` 必须为
`false`——n-gram 索引下 AND 会把「线性空间」切出的伪二元组「性空」也当作必需项。
