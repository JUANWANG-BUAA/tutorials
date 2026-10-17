# 图鉴插图：生成器与排版语汇

`tools/build_atlas_figures.py` 生成四本书的教学插图。输出是 **Markdown 片段**（内联 SVG + 图注），
在各书页面里用 mdBook 的 include 插入；生成物已提交，CI 不运行生成器。

## 一眼看懂

```bash
python3 tools/build_atlas_figures.py                 # 全部重新生成
python3 tools/build_atlas_figures.py --only robot-pose,dl-mlp
```

输出：`<book>/src/assets/figures/<slug>.md`。

页面里这样插（路径相对当前页）：

```markdown
{{#include ../assets/figures/robot-pose.md}}
```

`lectures/lecNN/` 下的页面用 `../../assets/figures/...`。建议放在第一个 `##` 标题之前，
让读者先看到整节的结构图，再进入小节。

## 视觉语法

所有图共用 900 宽的「展示台」：

- 顶部：学科 · 主题 / 编号 + 大标题 + 一句话副题；右上角是 `ATLAS / R-01` 编号。
- 背景：纸面渐变 + 细网格 + 两个低饱和光斑；左侧 5px 主题色书脊。
- 文字角色：`pl-kicker`（等宽小标签）、`pl-title`（宋体大标题）、`pl-sub`（副题）、
  `pl-label` / `pl-small` / `pl-mono`（图内文字）；这些类定义在 `atlas.css`，
  因此图例在正文、图鉴画廊和放大灯箱里都能保持同一套排版。
- 颜色只引令牌：`var(--accent)`、`var(--atlas-cyan)`、`var(--atlas-gold)`、`var(--atlas-plum)`、
  `var(--fig-green)`、`var(--fig-red)`、`var(--ink)`、`var(--paper)`、`var(--line)`。
  明暗主题、读者强调色切换都会自动跟随。
- 箭头使用全局 `arrow-a / arrow-c / arrow-g / arrow-p / arrow-e / arrow-r / arrow-m` 标记；
  标记颜色固定为对应令牌，多图同页不会串色。
- 图注以 **`<b>读图：</b>`** 开头，说明「先看什么、再看什么、结论是什么」，可含 `$...$`。
  图注是教学的一部分，不要只写「示意图」。

## 常用原语

| 原语 | 用途 |
|:--|:--|
| `plate(uid, height, kicker, title, subtitle, body, tone, atlas_no, caption)` | 所有图的底座；生成 header、背景、`<figure>` 与图注 |
| `node(x, y, w, h, title, sub, color, index)` | 圆角节点卡（带左侧色条、编号、图标点） |
| `arrow(x1, y1, x2, y2, color, curve=…)` | 带箭头标记的连线，可弯曲、虚线、带标签 |
| `chip(x, y, label, color)` | 药丸形标签 |
| `matrix_block(...)` | 带方括号的矩阵块（相抵 / 满秩 / QR 等） |
| `flow_plate(...)` | 横向流程 + 可选反馈回路 |
| `plot_axes` / `poly_path` / `dot` | 曲线坐标、网格、折线、散点 |
| `network_plate(...)` | 层状网络 + 张量形状侧栏 |

`fig_*()` 逐个定义内容；在文件底部 `FIGURES` 字典登记 `(book, function)`，生成器据此写文件。

## 新增一张图的清单

1. 在 `FIGURES` 上方写 `fig_<slug>()`，返回 `plate(...)`。
2. `uid` 用英文短横线；同一页多图时保证唯一（它同时是 figure id）。
3. 图注写清「读图顺序 + 结论」，数学用 `$...$`；Markdown 的 `**粗体**` 会在 `plate()` 里
   自动转成 `<b>`（放在 HTML figcaption 里，Markdown 不会再解析）。
4. 运行 `--only <slug>`，检查 `src/assets/figures/<slug>.md`。
5. 在页面第一个 `##` 前插入 include，`./build.sh` 后检查：
   - 桌面 1440 / 1280 / 1180 无横向溢出；
   - 390 宽下整图进入「左右平移」模式（`720px` 内宽），图注仍整宽；
   - 点图打开灯箱时，底色/渐变/箭头仍在；
   - 图注里的公式由 KaTeX 渲染，没有字面 `$`。
6. 若改了共享样式，重跑 `./build.sh`。

## 图的数量与归属（2026-10）

| 书 | 生成图 | 代表图 |
|:--|:--|:--|
| robot | 7 | 系统闭环、位姿坐标架、欧拉角万向环、DH 四参数、轨迹 vs 路径、执行器链、雅可比 |
| matrix | 4 | 第一章六站、相抵分解、特征方向、核与像 |
| numerical | 4 | 数值分析工作流、四个基本子空间、SVD 圆→椭圆 + 低秩截断 |
| deeplearning | 5 | 九讲地图、神经元、MLP 前向、激活函数、Transformer |

四本书另有约 140 张已有的课堂原片/内联图，由 `atlas.js` 自动包上图鉴卡片与图注。

## 首页 feature 图

`site-index.html` 的 `FIG. R-02` 大图是 `robot-pose` 图版的 **2× 截图**：

- 文件：`robot/src/assets/portal/feature-pose.png`
- 来源：`http://127.0.0.1:8000/robot/ch02/sec2-1.html` 中 `figure.fig-plate svg`
- 修改 `robot-pose` 后需要重新截取，否则首页 feature 仍是旧图。
