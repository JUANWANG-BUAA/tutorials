# shared —— 各书共用的一份实现

```
shared/theme/            浏览器侧资源（各书的 theme/ 里放符号链接指向这里）
  head.hbs               首帧防闪：把 localStorage 里的阅读偏好落到 <html data-*>
  css/base.css           共用样式：**§1 设计令牌层** + **§2 共用组件规则**
  css/atlas.css          图鉴视觉层：页首标题、插图卡片/图注、图鉴画廊、书封、窄屏宽图平移
  css/framework.css      mdBook 框架 UI 修补 + 附加操作外观 + 插图/阅读进度/微动效
  css/prefs.css          阅读偏好层（属性驱动；含可选皮肤）
  js/framework-core.js   共享工具 / 文案汉化 / 回到顶部 / 折叠状态记忆 / 启动注册表
  js/framework-nav.js    侧栏章节折叠 / 右栏大纲 / 已读标记 / 继续阅读
  js/framework-media.js  插图灯箱（含图注）/ 进场
  js/framework-text.js   公式复制 / 术语悬挂提示
  js/atlas.js            原生图片自动图注 / 页首阅读元信息 / 图鉴画廊 / 宽图平移
  js/prefs-config.js     唯一偏好 schema：首屏恢复 + 面板 + 导览页皮肤选择共用
  js/prefs.js            阅读偏好面板与持久化
  css/rhine.css          可选「莱茵档案」阅读皮肤：暖灰纸面与黄铜强调色
  css/rhine-portal.css   可选「莱茵档案」导览页：课程档案与三维阵列
  js/rhine.js            阅读页可恢复的封面替换；不改正文
  js/portal.js           导览页主题与皮肤选择 / 共用课程筛选 / 跨课程继续阅读
  js/rhine-portal.js     导览页组合层：从经典 DOM 读取课程，生成可 dispose 的档案终端
  js/rhine-scene.js      3D 场景构建产物（源：tools/theme-renderer/scene.js）
  assets/rhine-*.svg     目录封面（导览 catalogue / 3D fallback）
  vendor/three-LICENSE.txt Three.js MIT 许可
  RHINE.md               莱茵档案皮肤的结构、动效、构建与验收
  js/search-cjk.js       中文分词（浏览器侧）；与 tools/build_search_js.mjs 的分词逐字对应
  js/page-extras.js      **附加操作的一份实现**：阅读进度条 / 页内目录 / 解答工具条 /
                         返回教程库 / 宽公式滚动提示。各书的 <book>.js 只声明配置：
tools/                   构建脚本（八本一份）+ theme-renderer/
  katex_wrapper.py       mdbook-katex 包装器：中和会被 Markdown 误读的字符
  build_search_js.mjs    构建后重建中文搜索索引（探针表按书配置在脚本里）
  build_glossary.py      构建后从各书索引页抽术语数据，并给页面打 data-glossary 标记
  build_covers.py        生成四本平装书封 SVG
  build_atlas_figures.py 生成教学图鉴（SVG + 图注 Markdown 片段）
  theme-renderer/        莱茵档案 3D 场景（Three.js + esbuild）与目录封面生成
```

## 莱茵档案（可选皮肤）

可选视觉皮肤，默认不启用。导览页保留课程档案与三维阵列；阅读页采用暖灰纸面、简洁标题和黄铜强调色。

只影响 `html[data-skin="rhine"]`，仅在 screen 生效；默认 `classic` 不写属性。两种皮肤共用清晰教材的阅读结构。
完整契约、文件清单、动效与验收见 [theme/RHINE.md](theme/RHINE.md)。3D 重建：

```bash
pnpm --dir tools/theme-renderer install
pnpm --dir tools/theme-renderer build
python3 tools/theme-renderer/build_art.py
./build.sh
node --test tools/test_theme_config.mjs
```

## 阅读外观的边界

- 明暗主题负责纸面与正文颜色；主题色偏好只负责强调色，定义、定理等语义色独立。
- 背景默认 `plain`。显式保存的 `paper` 继续恢复；纹理只在 `.page-wrapper` 绘制，内部 `.page` 保持透明。
- 打印使用白底深字，不继承屏幕强调色与纹理；保留字体、字号和密度偏好。
- 页内目录使用原生 `details.page-toc-disclosure`，700px 以内默认收起。手动开关后保持选择，不随窗口大小变化重置。
- SVG 内部语义样式覆盖正文、灯箱与图鉴缩略图；容器仅负责布局。保留克隆 ID 去重和随主题更新的变量。
- 门户从 `.index-row` 读取课程与显式封面；新增课程应同步生成资源并运行 `tools/test_portal_assets.mjs`。

构建后运行 `node tools/check_browser.mjs`，包括真实控件切换、图形语义、打印、手机目录和门户封面的回归检查。

## 为什么是符号链接

这些文件原先在 `robot/`、`numerical/`、`matrix/` 里各存一份，靠「改完同步三处 + shasum
校验」维持一致——实际结果是**必然分叉**：本次改造时就发现中文分词器有三个版本
（`search-cjk.js` 88/76/60 行，`build_search_js.mjs` 也有三个版本，只有其中一本有
「ASCII↔中文空格合并」），索引侧与查询侧对不上，中文搜索时灵时不灵。

现在只有一份真文件，各书 `theme/` 里是指向它的相对符号链接，mdBook 会跟随链接把真实
内容拷进构建产物（已实测）。因此：

- 改共用行为 = 改 `shared/theme/` 下的那一个文件，八本同时生效；
- 不存在「忘记同步」的失败模式，也就不需要 shasum 校验；
- 产物里仍然只有该文件的内容（构建产物不依赖链接）。

书的**专属**文件仍在各书自己的 `theme/` 里（真实文件，不是链接）：

| 文件 | 归属 |
|:--|:--|
| `theme/css/<robot\|na\|matrix>.css` | 各书的权威样式表**组件与版式部分**；开头有一小段「§1 本书对 base.css 令牌层的覆盖」（只写与共用层不同的块，如数值分析/机器人的公式直觉盒与竞技场段位色） |
| `theme/js/<robot\|na\|matrix>.js` | 各书页面的**配置**：`TUTORIALS_EXTRAS.boot({ slug, pageTocLevels, toolbarPlacement, formulaHint })`，外加本书专属增强（数值分析的「阅读分层」图例） |
| `theme/js/robot-labs.js` / `arena.js` / `matrix-interactive.js` | 各书的专属交互组件 |
| `tools/mathbook.py` | 各书的编号 / 交叉引用 / 语义盒子预处理器（按书规则确有差异，保持独立） |

## 本地构建

```bash
./build.sh          # 八本 mdbook build → 搜索索引 → 术语数据 → 组装 _site/
./build.sh serve    # 构建后直接起 http://127.0.0.1:8000/ 预览
```

`mdbook build` 与 `mdbook serve` 都**不含**「搜索索引」与「术语数据」这两步（它们是构建后
产物，且 mdBook 会先清空 `book/`），只跑 mdbook 会得到一个没有索引、没有术语气泡的站点。

## 一句话说明「谁决定什么」

| 谁 | 决定 |
|:--|:--|
| `shared/theme/js/page-extras.js` | 附加操作**怎么做**（一份实现） |
| 各书 `<book>.js` | 本书**要哪些、什么形态**（配置）+ 本书专属增强 |
| `shared/theme/js/framework-*.js` | 框架层行为（汉化、侧栏折叠、灯箱、术语、右栏大纲、公式复制、已读进度） |
| `shared/theme/js/atlas.js` | 图鉴层行为（图片图注、页首元信息、章节描边编号、书首页目录、图鉴画廊、宽图平移） |
| `shared/theme/css/atlas.css` | 图鉴层的视觉语汇（排在 framework 之后、prefs 之前） |
| 各书 `theme/css/<book>.css` | 本书**长什么样**（设计令牌、组件、打印、响应式） |

共用设计令牌与重复组件已集中到 `theme/css/base.css`；各书样式只保留本书差异。`mathbook.py` 因编号、盒类型和校验需求不同继续按书维护。新增共用行为时优先改共享层；具体演进记录见仓库根 README。

## 样式层怎么改、怎么验

| 想改什么 | 改哪里 |
|:--|:--|
| 五套主题配色、语义盒、派生量（底纹/选区/悬停/斑马线）、尺寸令牌 | `shared/theme/css/base.css`（一份，八本同时生效） |
| 本书特有的令牌（公式直觉盒、竞技场段位色…） | `<book>/theme/css/<book>.css` 开头的「§1 本书覆盖」段 |
| 组件与版式（盒、表、图、打印、响应式） | `<book>/theme/css/<book>.css` |
| 框架 UI 与附加操作外观、插图与阅读进度 | `shared/theme/css/framework.css` |
| 读者可调的字体/字号/间距/版心/纸张配色/背景纹理 | `shared/theme/css/prefs.css` |

**验证方法（样式层改动必做）**：把改动前的版本用 `git worktree add /tmp/old HEAD` 检出并
`./build.sh`，起在另一个端口（如 8010），再用「归一状态后的 A/B 计算样式比对」逐页比：
同主题、侧栏隐藏、清空 `tutorials-*` 偏好与进度、等术语数据加载完，然后对整页每个元素比
18 项关键计算属性——要求**逐页逐元素零差异**。本次 §1 抽取就是这样验证的（9 页、含
36k 元素的公式长页，全部一致）。只比肉眼与截图是不够的：状态不同（侧栏是否展开、
术语数据是否加载）会伪装成大量差异。

## 部署资源与缓存

完整构建在图片、中文索引和术语数据生成后运行 `tools/optimize_assets.py`，按最终内容生成资源指纹并统一到 `_site/shared/cache/`，使跨书阅读复用脚本、样式和字体。请通过 `./build.sh` 预览完整部署产物；`mdbook serve` 不执行此步骤。

`shared/theme/js/cache-client.js` 在页面加载后注册根目录的 `cache-worker.js`。Worker 只按需缓存带指纹的资源，上限 64 MiB / 180 条，不缓存正文，不预下载整书。更新资源会生成新 URL。构建末尾 `tools/audit_site_assets.py` 检查资源路径、CSS 字体依赖与重复 ID，缺失时构建失败。构建机制、测量口径及验证见 [交互与加载优化记录](../docs/interaction-optimization.md)。

高亮包已提交，可用 `npm ci --prefix tools/syntax-highlighter` 和 `npm --prefix tools/syntax-highlighter run build` 重新生成；普通构建不安装 npm 依赖。

本地与 CI 的统一质量检查入口为根目录 `bash check.sh`，依赖、检查边界和内容审校方法见 [质量检查与内容审校](../docs/quality-gates.md)。
