# 视觉层

设计规范与版式纪律完全沿用《矩阵论》《数值分析》第一章教程（Academy / warm /
standard density，八段式单一权威样式表）。本目录为该设计语言的第三份实例化。

## 文件

| 文件 | 作用 |
|:--|:--|
| `css/robot.css` | **唯一权威样式**：设计令牌 → mdBook 变量映射 → 框架适配 → 语义盒子 → 表格/图/公式 → 首页 → 响应式 → 打印 |
| `css/katex.css` | KaTeX 布局规则 + 字体声明（仅 woff2，离线） |
| `js/robot.js` | 本书配置：`window.TUTORIALS = { slug: "robot" }`。附加操作都在 `js/framework.js`；本书专属交互实验在 `js/robot-labs.js` |
| `js/search-cjk.js` | 中文搜索分词（浏览器侧）。与 `tools/build_search_js.mjs` 里的索引分词**逐字对应**，改一处必须同步另一处 |

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

以下文件在 `robot` / `numerical` / `matrix` 三本书里**逐字相同**（改动请同步三处，
内容用 `shasum` 校验）：

| 文件 | 作用 |
|:--|:--|
| 侧栏 | **一比一交还原生**（连续目录、编号加粗、hover/当前项仅变色、本页大纲折叠）。无自建脚本与自加样式。 |
| `css/framework.css` | mdBook 框架 UI 的修补：搜索面板限高与分隔、键帽 `<kbd>`、回到顶部、焦点环；附加操作（进度条 / 页内目录 / 解答工具条 / 宽公式滚动提示 / 返回教程库）的外观；以及 `.content` 里 p / li / ol / ul 的行高（框架把它们钉在 1.45em，中文正文发挤）。主题弹层不做皮肤，走 mdBook 原生 |
| `js/framework.js` | 框架文案汉化（菜单栏、搜索框、主题名、帮助弹窗、复制按钮、翻页箭头）、搜索结果统计行汉化与键盘滚动、回到顶部、折叠状态记忆（解答/提示，按页存 localStorage）；附加操作**一份实现**（进度条 / 页内目录 / 解答工具条 / 宽公式滚动提示 / 返回教程库），每本书只声明 `window.TUTORIALS = { slug, onReady }` |
| `js/search-cjk.js` | 中文分词（浏览器侧）；与 `tools/build_search_js.mjs` 的索引分词逐字对应 |

侧栏逻辑已从各书的 `matrix.js` / `na.js` / `robot.js` 移出，那几个文件不再处理侧栏。

### 外观设置：一比一还原 rustwiki（2026-10）

外观设置**只保留菜单栏的原生入口**：主题切换 = 画笔图标弹层（跟随系统 / 浅色 /
浅色 · Rust / 深色 · Coal / 深色 · Navy / 深色 · Ayu），操作与 rustwiki、mdBook 官方
手册一致。此前的自建「阅读偏好」面板（`prefs.css` + `prefs.js` + `head.hbs`：字体 /
字号 / 间距 / 版心 / 配色主题）已整体移除——它与原生主题弹层各自都能改明暗与配色，
是两个入口、两套状态，读者看到的设置不统一。主题弹层的样式也一并还原 mdBook 原生
（4px 圆角、1px 边框、0.7em 字号、2px 20px 内边距、条目内「✓」选中标记），不再自加皮肤。

### 附加操作：一份实现（2026-10）

进度条、页内目录、解答工具条、宽公式滚动提示、返回教程库这五项此前在三个书名脚本里
各写各的，行为并不一致（工具条在矩阵论置于页首、在另两本埋在第一个解答框旁；页内目录
只有本书收 H3；公式滚动提示只有矩阵论有）。现在全部收进 `js/framework.js`，三本行为
逐项相同：

- **页内目录**：H2 / H3 ≥ 3 个时在标题后插入，两列，窄屏单列；标题含公式时先剔掉
  KaTeX 给屏幕阅读器的 MathML 副本，避免一条目录读两遍。
- **解答工具条**：固定在页首（页内目录 / H1 之后），进入页面即可见；打印时整条隐藏。
- **宽公式滚动提示**：`can-scroll` / `scrolled-start` 左右缘渐隐，字体就绪、折叠展开、
  窗口缩放三处重测。
- **回到顶部**：`right:112px`，避开 mdBook 右缘 90px 宽的「下一页」悬停热区。
- **返回教程库**：地址由各书声明的 `slug` 推出，不写死域名；本地预览无 slug 时不插入。

书内专属部件用 `window.TUTORIALS.onReady` 注册，本书记在 `js/robot.js`；
本书专属的交互实验在 `js/robot-labs.js`。

### 中文搜索：索引与查询同源（2026-10）

三本的分词实现此前并不相同，现已统一为 `js/search-cjk.js` ⇄ `tools/build_search_js.mjs`
的同一套规则（本书原本就是最全的一版：ASCII ↔ 中文空格合并 + 混合词切分），并修两个
真实缺陷：

- **深链竞态**：mdBook 0.5 把 elasticlunr 与本脚本同页加载（本脚本在后），但旧代码
  在 200ms 轮询里才改写分词器——`?search=机械手` 这类深链在 DOMContentLoaded 就发
  查询，中文词组会误报「没有命中」。现在同步改写，轮询只作为老版本 mdBook 的兜底。
- **改错文件**：重建脚本原先用宽松匹配找 `searchindex-*.js`，macOS 拷贝冲突留下的
  「searchindex-xxx 2.js」会排在前面——索引重建成功但线上加载的那份没动。现在以
  `index.html` 实际引用的文件名为准。

CI 里中文搜索依赖 `node tools/build_search_js.mjs <book>/book`（**构建后**执行），
`.github/workflows/deploy.yml` 已含该步；`book.toml` 的 `use-boolean-and` 必须为
`false`——n-gram 索引下 AND 会把「线性空间」切出的伪二元组「性空」也当作必需项。
