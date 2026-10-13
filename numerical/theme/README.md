# 视觉层

设计规范：**Academy / warm / standard density**，版式纪律参照 Rust Wiki，
表面语言参照 Physical Intelligence（pi.website）。风格由 serif-editorial-console
技能的 Academy 预设约束。

## 文件

| 文件 | 作用 |
|:--|:--|
| `css/na.css` | **唯一权威样式**。分段：设计令牌 → mdBook 变量映射 → 框架适配 → 语义盒子 → 表格/图/公式 → 首页 → 页内目录 → 侧栏（§6.5）→ 搜索面板与主题弹层（§6.6）→ 响应式 → 打印 |
| `css/katex.css` | KaTeX 布局规则 + 字体声明（仅 woff2，离线） |
| `js/na.js` | 进度条、展开全部解答、打印前展开、侧栏增强、框架界面文案汉化（渐进增强） |
| `js/search-cjk.js` | 中文搜索分词（见 docs/ARCHITECTURE.md §2.1） |

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

侧栏的**权威规则在 `na.css` §6.5**，§2 只留骨架；改侧栏改 §6.5。三条与
mdBook 0.5 实现细节耦合、光看渲染看不出来的事实：

- **链接是 `li > span.chapter-link-wrapper > a`，不是 `li > a`**。写成 `li>a`
  的选择器会静默落空（「本页大纲」就因此比页面导航还大一号，且 `.current-header`
  的高亮只能靠 mdBook 自己的 chrome 规则兜住）。
- **`ol.section` 不能用 `flex:0 0 100%` + `padding-left`**：默认 `content-box`
  下每嵌套一层就多出 `padding-left` 的宽度，深层标题被推出侧栏右缘裁字。
  页面导航那层用 `width:auto` 绕开，`header-item` 这层是 flex 行、只能给
  `box-sizing:border-box`。
- **「本页大纲」由 `toc.js` 在 `DOMContentLoaded` 里插入**，晚于 `na.js` 的
  `boot()`。所以 `na.js` 的编号分列、箭头注入要挂在 `na.js` 自己的
  `DOMContentLoaded` 回调里（`toc.js` 的监听器注册在前，顺序有保证）。

## 框架界面文案

mdBook 的框架文案（菜单栏提示、搜索框占位符、搜索结果统计、主题名、复制按钮）
全部写死在模板与 `searcher.js` / `book.js` 里，**没有配置项**，只能由 `na.js`
在运行时改写（`localizeChrome()` 与 `watchSearchResults()`）。三条相关事实：

- **搜索结果统计行由 `formatSearchMetric()` 生成，每次搜索整体重建**，所以要用
  `MutationObserver` 盯住 `#mdbook-searchresults-header`，不能一次性改写。
- **搜索是 `keyup` 触发的**（`searchbarKeyUpHandler`），`input` 事件不生效——
  用脚本填值调试搜索时必须手动派发 `keyup`。
- **`#mdbook-search-wrapper` 在文档流里，没有定位也没有高度上限**：mdBook 原生
  会让 30 条结果把正文顶下去约 2600px。§6.6 给结果区加了高度上限与内滚，并补了
  一条 `MutationObserver` 让上下键移动高亮时把条目带进视野（mdBook 自己不做）。

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
