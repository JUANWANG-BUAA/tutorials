# 视觉层

设计规范：**Academy / warm / standard density**，版式纪律参照 Rust Wiki，
表面语言参照 Physical Intelligence（pi.website）。风格由 serif-editorial-console
技能的 Academy 预设约束。

## 文件

| 文件 | 作用 |
|:--|:--|
| `css/na.css` | **唯一权威样式**。分段：设计令牌 → mdBook 变量映射 → 框架适配 → 语义盒子 → 表格/图/公式 → 首页 → 页内目录 → 侧栏（§6.5）→ 响应式 → 打印 |
| `css/katex.css` | KaTeX 布局规则 + 字体声明（仅 woff2，离线） |
| `js/na.js` | 本书配置 + 数值分析专属的「阅读分层」开关（`window.TUTORIALS = { slug, onReady }`）。附加操作都在 `js/framework.js` |
| `js/search-cjk.js` | 中文搜索分词（浏览器侧）。与 `tools/build_search_js.mjs` 里的索引分词**逐字对应**，改一处必须同步另一处 |

`src/404.md` 是 404 页的源文件（不在 `SUMMARY.md` 里，mdBook 单独渲染成
`404.html`）。GitHub Pages 会把它的内容返回给任意路径，所以页内链接在运行时
由一段内联脚本改写为站点根绝对地址（从样式表 URL 反推根，兼容 `/<repo>/` 子路径）。

字体文件在 `src/fonts/katex/`（mdBook 会整体复制 `src/`）。

## 规矩

1. **改样式只改 `na.css`**，不要新增覆盖层——旧版就是因为层层叠加而失去一致性。
2. **字体角色不越界**：display serif 用于章节标题；text serif 用于正文；sans 用于
   导航与控件；mono 用于编号、标签与证据。正文里不出现 mono，导航里不出现 serif。
3. **每个面板都有可见边框**，不用纯阴影做分隔；不用毛玻璃、发光、紫色渐变。
4. **动效只用于状态变化**，并遵守 `prefers-reduced-motion`。
5. **插图按 viewBox 宽度分档**：`figure svg` 默认铺满版心，缩放比 ≈1.1，适合
   viewBox 宽 ≥600 的宽图；窄图（宽 ≈360）铺满会被放大 2 倍以上，标注字号
   涨到正文的两倍、固定坐标的标注还会互相压叠——这类图在源文件里写
   `<figure class="fig-sm">`，图版限宽到 470px 居中，缩放比落到 ≈1.2。

## 两处容易踩的 mdBook 陷阱

写样式时必须知道 mdBook 的这两个行为，它们各引发过一个真实缺陷：

- **标题文字整段被包在 `<a class="header">` 里**。所以 `.header` 必须继承颜色
  （`color:inherit`），任何 `opacity:0` 都会让**整本书的标题消失**。锚点提示请用
  `::after` 悬停出现，而不是隐藏 `.header` 本身。
- **`--serif` 是 `var(--serif-display)` 的别名**，嵌套 `var()` 放在 `font` 简写里
  无法通过语法校验，整条声明会失效（回退到继承值）。因此对 `--serif` 一律用
  `font-family` 等长属性，不要用 `font:` 简写。

## 侧栏（§6.5）

侧栏**一比一交还原生**（连续目录、编号加粗、hover/当前项仅变色、本页大纲由
`toc.js` 折叠）。`na.css` §6.5 只保留与主题相关的滚动条与焦点环收尾；折叠钮、
吸顶分组标题、当前项底色/色条等自建样式均已移除，`na.js` 也不再处理侧栏。

## 框架界面文案

mdBook 的框架文案（菜单栏提示、搜索框占位符、搜索结果统计、主题名、复制按钮）
全部写死在模板与 `searcher.js` / `book.js` 里，**没有配置项**，只能由
`framework.js` 在运行时改写（`localizeChrome()` 与 `watchSearchResults()`）。
三条相关事实：

- **搜索结果统计行由 `formatSearchMetric()` 生成，每次搜索整体重建**，所以要用
  `MutationObserver` 盯住 `#mdbook-searchresults-header`，不能一次性改写。
- **搜索是 `keyup` 触发的**（`searchbarKeyUpHandler`），`input` 事件不生效——
  用脚本填值调试搜索时必须手动派发 `keyup`。
- **`#mdbook-search-wrapper` 在文档流里，没有定位也没有高度上限**：mdBook 原生
  会让 30 条结果把正文顶下去约 2600px。`framework.css` §3 给结果区加了高度上限与
  内滚，并补了一条 `MutationObserver` 让上下键移动高亮时把条目带进视野（mdBook
  自己不做）。

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
只有机器人控制技术收 H3；公式滚动提示只有矩阵论有）。现在全部收进 `js/framework.js`，
三本行为逐项相同：

- **页内目录**：H2 / H3 ≥ 3 个时在标题后插入，两列，窄屏单列；标题含公式时先剔掉
  KaTeX 给屏幕阅读器的 MathML 副本，避免一条目录读两遍。
- **解答工具条**：固定在页首（页内目录 / H1 之后），进入页面即可见；打印时整条隐藏。
- **宽公式滚动提示**：`can-scroll` / `scrolled-start` 左右缘渐隐，字体就绪、折叠展开、
  窗口缩放三处重测。
- **回到顶部**：`right:112px`，避开 mdBook 右缘 90px 宽的「下一页」悬停热区。
- **返回教程库**：地址由各书声明的 `slug` 推出，不写死域名；本地预览无 slug 时不插入。

书内专属部件用 `window.TUTORIALS.onReady` 注册：数值分析的「只看核心」图例靠它挂在
页内目录之后。

### 中文搜索：索引与查询同源（2026-10）

三本的分词实现此前并不相同（机器人控制技术多一套 ASCII ↔ 中文空格合并与混合词切分，
数值分析多一层权重补丁），现已统一为 `js/search-cjk.js` ⇄ `tools/build_search_js.mjs`
的同一套规则，并修两个真实缺陷：

- **深链竞态**：mdBook 0.5 把 elasticlunr 与本脚本同页加载（本脚本在后），但旧代码
  在 200ms 轮询里才改写分词器——`?search=线性空间` 这类深链在 DOMContentLoaded 就发
  查询，中文词组会误报「没有命中」。现在同步改写，轮询只作为老版本 mdBook 的兜底。
- **改错文件**：重建脚本原先用宽松匹配找 `searchindex-*.js`，macOS 拷贝冲突留下的
  「searchindex-xxx 2.js」会排在前面——索引重建成功但线上加载的那份没动。现在以
  `index.html` 实际引用的文件名为准。

CI 里中文搜索依赖 `node tools/build_search_js.mjs <book>/book`（**构建后**执行），
`.github/workflows/deploy.yml` 已含该步；`book.toml` 的 `use-boolean-and` 必须为
`false`——n-gram 索引下 AND 会把「线性空间」切出的伪二元组「性空」也当作必需项。
