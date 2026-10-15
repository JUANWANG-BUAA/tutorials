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
| 5 | 权威样式表去重 | ✅ | 两步完成：① **§1 设计令牌层** → `shared/theme/css/base.css`；② **177 个三本逐字相同的组件规则**（盒/证明/表格/插图/封面/菜单栏按钮…，18k 字符）一并收进同一文件。各书只留本书令牌覆盖（数值分析/机器人各 2 块）与**值不同**的规则。行数：matrix 1030→445、na 1087→576、robot 881→283。验证：归一状态的 A/B 计算样式比对 **9 页逐元素零差异**（含 3.6 万元素长页；唯一一次报警经复测为加载时机抖动，同一版本重复加载 4/4 一致） |
| 6 | `mathbook.py` 去重 | ❌ 不做 | 实测三本同名函数 19 个、**逐字相同的只有 7 个（≈10%）**；编号规则、盒类型、校验逻辑各书不同是真实需求（矩阵论有 `lazy_images`/`label_folds`，数值分析有 `box_priority`，机器人有 `_check_number`/`label_number`）。抽共用的收益低于抽象成本与内容回归风险，**保持各书独立** |
| 7 | `framework.js` 拆分 | ⏳ | 现为单文件 1050 行、职责十项。计划按内聚拆成 core（文案/回到顶部/折叠记忆）+ reading（右栏大纲/术语/已读）+ media（灯箱/进场/公式复制）三个模块，用一个小命名空间共享辅助函数 |
| 8 | 尺寸令牌化 | ✅ | §1.4 补**字号刻度**（`--fs-2xs…--fs-display`，11 档，按角色命名）；随后把组件里**正好等于刻度值**的字面量机械换成令牌（间距 111 处 + 字号 69 处 = **180 处**）。规则：只做「同值换名」，不做取整——不在刻度上的值（如 `18px 22px 14px`、`13.5px`）保留原样，因此**可证明零视觉变化**（A/B 计算样式比对 9 页逐元素零差异）。审计脚本确认「仍在用字面量但正好等于刻度」为 0 处 |

## 部署

推送到 `main` 分支后，GitHub Actions 自动构建三本书并发布到 Pages，无需手工操作。各书首页会说明正文范围与待补内容。
