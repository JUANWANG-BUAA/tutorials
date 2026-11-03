# 视觉层

设计规范：**Academy / Cool / standard density**，版式纪律参照 Rust Wiki，
表面语言参照 Physical Intelligence（pi.website）。与《矩阵论》同一套设计语言，
差异只在本书专属样式（linux.css）与专属交互（linux.js / variants.js / linux-viz.js）。

## 文件

| 文件 | 作用 |
|:--|:--|
| `css/linux.css` | **本书唯一权威样式**。含架构切换、代码复制按钮、阅读分层（§阅读分层） |
| `css/katex.css` | KaTeX 布局规则 + 字体声明（仅 woff2，离线） |
| `css/{base,framework,atlas,rhine,prefs}.css` | 共享层（`../shared/theme/css/` 同版拷贝）：语义盒子、术语悬挂提示、阅读偏好 |
| `js/linux.js` | 本书配置：页内目录层级、解答工具条位置；「只看核心」阅读分层开关 |
| `js/variants.js` | 架构 × 语言切换器（x86-64 / arm64 / RISC-V × C / Rust / 汇编） |
| `js/linux-viz.js` | 轻量 canvas 教学动画（process / pagewalk / tcp / epoll） |
| `js/{prefs-config,prefs,page-extras,framework-*,rhine,atlas,search-cjk}.js` | 共享交互层：偏好、进度条、目录、术语气泡、中文搜索 |
| `head.hbs` | 符号链接 → `../shared/theme/head.hbs`：首帧前恢复阅读偏好 |

字体文件在 `src/fonts/`（mdBook 会整体复制 `src/`）。

## 规矩

1. **改样式只改 `linux.css`**，不要新增覆盖层——旧版就是因为层层叠加而失去一致性。
   共享层的缺陷回 `../shared/theme/` 修，不在本书打补丁。
2. **字体角色不越界**：display serif 用于章节标题；text serif 用于正文；sans 用于
   导航与控件；mono 用于编号、标签与证据。正文里不出现 mono，导航里不出现 serif。
3. **每个面板都有可见边框**，不用纯阴影做分隔；不用毛玻璃、发光、紫色渐变。
4. **动效只用于状态变化**，并遵守 `prefers-reduced-motion`。

## 阅读分层（本书专属）

`tools/mathbook.py` 给每个盒子打 `p-core` / `p-main` / `p-skip` 类名
（类型默认值 + `::: thm[skip]` 显式覆盖），`linux.css §阅读分层` 画三层视觉权重，
`linux.js` 注入「只看核心」开关（折叠全部 `p-skip`，状态记 `localStorage`）。
skip 只降权重不隐藏；打印时一律展开。改优先级默认值去改 mathbook.py 的
`PRIORITY_DEFAULT`，不要在 CSS 里重判类型。

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
在 `--page` 与 `--sidebar` 两种底色上验算过。改色后请重新验算：
正文级文字需 ≥4.5:1，大字与装饰线需 ≥3:1。暗色令牌与亮色同名同结构，只换值。
