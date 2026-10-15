# 视觉层

设计规范：**Academy / warm / standard density**，版式纪律参照 Rust Wiki，
表面语言参照 Physical Intelligence（pi.website）。风格由 serif-editorial-console
技能的 Academy 预设约束。

## 文件

| 文件 | 作用 |
|:--|:--|
| `css/matrix.css` | **唯一权威样式**。分八段：设计令牌 → mdBook 变量映射 → 框架适配 → 语义盒子 → 表格/图/公式 → 首页 → 响应式 → 打印 |
| `css/katex.css` | KaTeX 布局规则 + 字体声明（仅 woff2，离线） |
| `js/matrix.js` | 进度条、本页目录、展开全部解答、打印前展开、宽公式滚动提示、返回教程库（渐进增强） |
| `js/search-cjk.js` | 中文搜索分词（见 docs/ARCHITECTURE.md §2.1） |

字体文件在 `src/fonts/katex/`（mdBook 会整体复制 `src/`）。

## 规矩

1. **改样式只改 `matrix.css`**，不要新增覆盖层——旧版就是因为层层叠加而失去一致性。
2. **字体角色不越界**：display serif 用于章节标题；text serif 用于正文；sans 用于
   导航与控件；mono 用于编号、标签与证据。正文里不出现 mono，导航里不出现 serif。
3. **每个面板都有可见边框**，不用纯阴影做分隔；不用毛玻璃、发光、紫色渐变。
4. **动效只用于状态变化**，并遵守 `prefers-reduced-motion`。

## 两处容易踩的 mdBook 陷阱

写样式时必须知道 mdBook 的这两个行为，它们各引发过一个真实缺陷：

- **标题文字整段被包在 `<a class="header">` 里**。所以 `.header` 必须继承颜色
  （`color:inherit`），任何 `opacity:0` 都会让**整本书的标题消失**。锚点提示请用
  `::after` 悬停出现，而不是隐藏 `.header` 本身。
- **`--serif` 是 `var(--serif-display)` 的别名**，嵌套 `var()` 放在 `font` 简写里
  无法通过语法校验，整条声明会失效（回退到继承值）。因此对 `--serif` 一律用
  `font-family` 等长属性，不要用 `font:` 简写。

## 颜色与对比度

正文次级灰 `--muted` 与彩色文字 `--accent-text` 的取值，都按 **WCAG AA（≥4.5:1）**
在 `--page` 与 `--sidebar` 两种底色上验算过：

| 令牌 | 亮色取值 | 用途 |
|:--|:--|:--|
| `--muted` | `#6f675b` | 正文次级文字（sidebar 4.6:1 / page 5.1:1） |
| `--accent` | `#b96543` / `#8aa79d` | **仅装饰**：线条、底色、进度条、水印 |
| `--accent-text` | `#9f5033` / `#8aa79d` | 小字号彩色**文字**（侧栏高亮、交叉引用悬停） |

改色后请重新验算：正文级文字需 ≥4.5:1，大字与装饰线需 ≥3:1。暗色令牌与亮色
同名同结构，只换值。

## 三本书共用层（2026-10 起）

以下文件在 `robot` / `numerical` / `matrix` 三本书里**逐字相同**（改动请同步三处）：

| 文件 | 作用 |
|:--|:--|
| 侧栏 | **一比一交还原生**（连续目录、编号加粗、hover/当前项仅变色、本页大纲折叠）。无自建脚本与自加样式。 |
| `css/framework.css` | mdBook 框架 UI 的修补：搜索面板限高与分隔、键帽 `<kbd>`、回到顶部、焦点环；以及 `.content` 里 p / li / ol / ul 的行高（框架把它们钉在 1.45em，中文正文发挤）。主题弹层不做皮肤，走 mdBook 原生。 |
| `js/framework.js` | 框架文案汉化（菜单栏、搜索框、主题名、帮助弹窗、复制按钮、翻页箭头）、搜索结果统计行汉化与键盘滚动、回到顶部、折叠状态记忆（解答/提示，按页存 localStorage）。 |

侧栏逻辑已从各书的 `matrix.js` / `na.js` / `robot.js` 移出，那几个文件不再处理侧栏。

### 外观设置：一比一还原 rustwiki（2026-10）

外观设置**只保留菜单栏的原生入口**：主题切换 = 画笔图标弹层（跟随系统 / 浅色 /
浅色 · Rust / 深色 · Coal / 深色 · Navy / 深色 · Ayu），操作与 rustwiki、mdBook 官方
手册一致。此前的自建「阅读偏好」面板（`prefs.css` + `prefs.js` + `head.hbs`：字体 /
字号 / 间距 / 版心 / 配色主题）已整体移除——它与原生主题弹层各自都能改明暗与配色，
是两个入口、两套状态，读者看到的设置不统一。主题弹层的样式也一并还原 mdBook 原生
（4px 圆角、1px 边框、0.7em 字号、2px 20px 内边距、条目内「✓」选中标记），不再自加皮肤。

CI 里中文搜索依赖 `node tools/build_search_js.mjs <book>/book`（**构建后**执行），
`.github/workflows/deploy.yml` 已含该步；`book.toml` 的 `use-boolean-and` 必须为
`false`——n-gram 索引下 AND 会把「线性空间」切出的伪二元组「性空」也当作必需项。
