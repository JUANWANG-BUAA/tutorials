# shared —— 三本书共用的一份实现

```
shared/theme/            浏览器侧资源（各书的 theme/ 里放符号链接指向这里）
  head.hbs               首帧防闪：把 localStorage 里的阅读偏好落到 <html data-*>
  css/framework.css      mdBook 框架 UI 修补 + 附加操作外观 + 插图/阅读进度/微动效
  css/prefs.css          阅读偏好层（六个轴，属性驱动）
  js/framework.js        框架文案汉化、回到顶部、侧栏折叠、灯箱、术语、右栏大纲、
                         公式复制、已读进度…
  js/prefs.js            阅读偏好面板与持久化
  js/search-cjk.js       中文分词（浏览器侧）；与 tools/build_search_js.mjs 的分词逐字对应
  js/page-extras.js      **附加操作的一份实现**：阅读进度条 / 页内目录 / 解答工具条 /
                         返回教程库 / 宽公式滚动提示。各书的 <book>.js 只声明配置：
tools/                   构建脚本（三本一份）
  katex_wrapper.py       mdbook-katex 包装器：中和会被 Markdown 误读的字符
  build_search_js.mjs    构建后重建中文搜索索引（探针表按书配置在脚本里）
  build_glossary.py      构建后从各书索引页抽术语数据，并给页面打 data-glossary 标记
```

## 为什么是符号链接

这些文件原先在 `robot/`、`numerical/`、`matrix/` 里各存一份，靠「改完同步三处 + shasum
校验」维持一致——实际结果是**必然分叉**：本次改造时就发现中文分词器有三个版本
（`search-cjk.js` 88/76/60 行，`build_search_js.mjs` 也有三个版本，只有其中一本有
「ASCII↔中文空格合并」），索引侧与查询侧对不上，中文搜索时灵时不灵。

现在只有一份真文件，各书 `theme/` 里是指向它的相对符号链接，mdBook 会跟随链接把真实
内容拷进构建产物（已实测）。因此：

- 改共用行为 = 改 `shared/theme/` 下的那一个文件，三本同时生效；
- 不存在「忘记同步」的失败模式，也就不需要 shasum 校验；
- 产物里仍然只有该文件的内容（构建产物不依赖链接）。

书的**专属**文件仍在各书自己的 `theme/` 里（真实文件，不是链接）：

| 文件 | 归属 |
|:--|:--|
| `theme/css/<robot\|na\|matrix>.css` | 各书的权威样式表（设计令牌、组件、打印、响应式） |
| `theme/js/<robot\|na\|matrix>.js` | 各书页面的**配置**：`TUTORIALS_EXTRAS.boot({ slug, pageTocLevels, toolbarPlacement, formulaHint })`，外加本书专属增强（数值分析的「阅读分层」图例） |
| `theme/js/robot-labs.js` / `arena.js` / `matrix-interactive.js` | 各书的专属交互组件 |
| `tools/mathbook.py` | 各书的编号 / 交叉引用 / 语义盒子预处理器（三本规则确有差异，暂未合并） |

## 本地构建

```bash
./build.sh          # 三本 mdbook build → 搜索索引 → 术语数据 → 组装 _site/
./build.sh serve    # 构建后直接起 http://127.0.0.1:8000/ 预览
```

`mdbook build` 与 `mdbook serve` 都**不含**「搜索索引」与「术语数据」这两步（它们是构建后
产物，且 mdBook 会先清空 `book/`），只跑 mdbook 会得到一个没有索引、没有术语气泡的站点。

## 一句话说明「谁决定什么」

| 谁 | 决定 |
|:--|:--|
| `shared/theme/js/page-extras.js` | 附加操作**怎么做**（一份实现） |
| 各书 `<book>.js` | 本书**要哪些、什么形态**（配置）+ 本书专属增强 |
| `shared/theme/js/framework.js` | 框架层行为（汉化、侧栏折叠、灯箱、术语、右栏大纲、公式复制、已读进度） |
| 各书 `theme/css/<book>.css` | 本书**长什么样**（设计令牌、组件、打印、响应式） |

> 2026-10 的状态：附加操作已收成一份；**权威样式表（各书 ~880 行，两两差异约 400 行）
> 与 `tools/mathbook.py`（632 行，两两差异 275–368 行）尚未合并**——两者都属于「按书
> 定制」的部分，合并前需要先把「共用骨架」与「本书覆盖」分干净，改完要用像素比对
> 证明零视觉变化。见仓库根 README 的改造清单。
