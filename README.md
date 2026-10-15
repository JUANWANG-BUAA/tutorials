# 教程库 · Tutorials

研究生课程定制教程合集（mdBook 构建），通过 GitHub Pages 在线阅读：

| 教程 | 在线阅读 | 当前范围 |
|---|---|---|
| 🤖 机器人控制技术 | [开始阅读](https://juanwang-buaa.github.io/tutorials/robot/) | 第 1–5 章：引言、运动学、微分运动学与静力学、轨迹规划、执行器与传感器 |
| 📐 矩阵论 | [开始阅读](https://juanwang-buaa.github.io/tutorials/matrix/) | 第 1 章完整；第 2 章 2.1–2.5；第 3 章 3.1–3.2、3.4–3.5。其余小节待素材补齐 |
| 📊 数值分析 | [开始阅读](https://juanwang-buaa.github.io/tutorials/numerical/) | 第 1–2 章及课堂精编；第 8 讲页面待补，后续章节逐步整理 |

## 仓库结构

```
robot/       机器人控制技术 · mdBook 源（src/ 为 Markdown 本体，theme/ 为本书样式与脚本）
matrix/      矩阵论 · mdBook 源
numerical/   数值分析 · mdBook 源
shared/      三本书**共用一份**的浏览器侧资源与构建工具（各书 theme/ 里是符号链接）
  theme/       head.hbs、framework/prefs 的 css+js、search-cjk.js
  README.md   共用层说明与本地构建方式
tools/       仓库级构建脚本（三本一份）：
  build_search_js.mjs  构建后重建中文搜索索引（分词与查询同源）
  build_glossary.py    构建后抽术语数据 + 给页面打标记
  katex_wrapper.py     包装 mdbook-katex，中和会被 Markdown 误读的字符
build.sh     一键构建三本 + 后置步骤 → _site/（与 CI 步骤一致）
.github/     Pages 自动部署工作流
```

书与书的边界很清楚：**共用行为**在 `shared/`（一份），**本书样式**在各书 `theme/css/<书>.css`
（权威样式表），**本书预处理规则**在各书 `tools/mathbook.py`。

仓库只包含教程本体（`book.toml` + `src/` + `theme/`）。课程录播、转录稿、PPT 原料等中间产物不纳入版本管理。

## 本地开发

```bash
brew install mdbook        # 如未安装
./build.sh serve           # 构建三本（含搜索索引与术语数据）并起预览 http://127.0.0.1:8000/
```

⚠️ 不要只跑 `mdbook serve`：搜索索引与术语数据都是**构建后产物**，而 mdBook 每次构建会先清空
`book/`，只跑 mdbook 会得到一个没有索引、没有术语气泡的站点。`./build.sh` 与 CI 的步骤一致。

## 工程改造清单（2026-10 起）

目标：**高内聚、低耦合、样式令牌化**。已完成与待办都写在这里，避免「改一处、忘一处」。

| # | 项 | 状态 | 说明 |
|:--|:--|:--|:--|
| 1 | 共用浏览器资源收成一份 | ✅ | `shared/theme/`，各书 `theme/` 里放符号链接，mdBook 跟随链接构建 |
| 2 | 构建脚本收成一份 | ✅ | `tools/`（katex_wrapper / build_search_js / build_glossary），每本差异改成脚本内配置表 |
| 3 | 中文搜索「索引分词 = 查询分词」 | ✅ | 三本共用 `shared/theme/js/search-cjk.js`，与 `tools/build_search_js.mjs` 逐字对应；顺带修掉深链 `?search=` 因轮询打补丁而误报无命中的缺陷 |
| 4 | 页面附加操作收成一份实现 | ✅ | `shared/theme/js/page-extras.js`；各书 `theme/js/<书>.js` 只剩配置（robot 14 行、matrix 22 行、na 121 行含本书图例） |
| 5 | 权威样式表去重 | ⏳ | 各书 `theme/css/<书>.css` 约 880 行，两两差异约 400 行。计划：抽出共用骨架 `shared/theme/css/base.css`（令牌 §1、框架适配 §2、通用组件、打印、响应式），各书只留本书组件与覆盖；**改完用像素比对证明零视觉变化**再提交 |
| 6 | `mathbook.py` 去重 | ⏳ | 每本 632 行、两两差异 275–368 行。先做「共用库 + 本书配置」的边界划分（编号规则、交叉引用、盒类型的差异要先量化） |
| 7 | `framework.js` 拆分 | ⏳ | 现为单文件 1050 行、职责十项。计划按内聚拆成 core（文案/回到顶部/折叠记忆）+ reading（右栏大纲/术语/已读）+ media（灯箱/进场/公式复制）三个模块，用一个小命名空间共享辅助函数 |
| 8 | 尺寸令牌化 | ⏳ | 颜色已全部令牌化并解耦（§1 四层）；间距/字号仍散落在组件里，计划收进 `§1.4 尺寸令牌` 的刻度（--space-*）并在组件中改用 |

## 部署

推送到 `main` 分支后，GitHub Actions 自动构建三本书并发布到 Pages，无需手工操作。各书首页会说明正文范围与待补内容。
