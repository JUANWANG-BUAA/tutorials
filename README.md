# 教程库 · Tutorials

研究生课程定制教程合集（mdBook 构建），通过 GitHub Pages 在线阅读：

| 教程 | 在线阅读 | 内容 |
|---|---|---|
| 🤖 机器人控制技术 | [tutorials/robot](https://juanwang-buaa.github.io/tutorials/robot/) | 引言 · 运动学 · 微分运动学和静力学 · 轨迹规划 |
| 📐 矩阵论 | [tutorials/matrix](https://juanwang-buaa.github.io/tutorials/matrix/) | 线性空间引论 · 线性映射与矩阵 · 矩阵分解 |
| 📊 数值分析 | [tutorials/numerical](https://juanwang-buaa.github.io/tutorials/numerical/) | 绪论：误差、算法与范数 · 数值线性代数基础 |

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

推送到 `main` 分支后，GitHub Actions 自动构建三本书并发布到 Pages，无需手工操作。
