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
