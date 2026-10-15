# 教程库 · Tutorials

研究生课程定制教程合集（mdBook 构建），通过 GitHub Pages 在线阅读：

| 教程 | 在线阅读 | 当前范围 |
|---|---|---|
| 🤖 机器人控制技术 | [开始阅读](https://juanwang-buaa.github.io/tutorials/robot/) | 第 1–5 章：引言、运动学、微分运动学与静力学、轨迹规划、执行器与传感器 |
| 📐 矩阵论 | [开始阅读](https://juanwang-buaa.github.io/tutorials/matrix/) | 第 1 章完整；第 2 章 2.1–2.5；第 3 章 3.1–3.2、3.4–3.5。其余小节待素材补齐 |
| 📊 数值分析 | [开始阅读](https://juanwang-buaa.github.io/tutorials/numerical/) | 第 1–2 章及课堂精编；第 8 讲页面待补，后续章节逐步整理 |

## 仓库结构

```
robot/       机器人控制技术 · mdBook 源（src/ 为 Markdown 本体，theme/ 为定制样式）
matrix/      矩阵论 · mdBook 源
numerical/   数值分析 · mdBook 源
.github/     Pages 自动部署工作流
```

仓库只包含教程本体（`book.toml` + `src/` + `theme/`）。课程录播、转录稿、PPT 原料等中间产物不纳入版本管理。

## 本地开发

```bash
brew install mdbook        # 如未安装
cd robot && mdbook serve --open   # 本地预览 http://localhost:3000
```

## 部署

推送到 `main` 分支后，GitHub Actions 自动构建三本书并发布到 Pages，无需手工操作。各书首页会说明正文范围与待补内容。
