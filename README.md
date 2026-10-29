# 教程库 · Tutorials

研究生课程定制教程合集（mdBook 构建），通过 GitHub Pages 在线阅读：

| 教程 | 在线阅读 | 当前范围 |
|---|---|---|
| 🤖 机器人控制技术 | [开始阅读](https://juanwang-buaa.github.io/tutorials/robot/) | 第 1–7 章：引言、运动学、微分运动学与静力学、轨迹规划、执行器与传感器、动力学（对应原书第 7 章）、运动控制（对应原书第 8 章） |
| 📐 矩阵论 | [开始阅读](https://juanwang-buaa.github.io/tutorials/matrix/) | 第 1 章完整；第 2 章 2.1–2.5；第 3 章 3.1–3.2、3.4–3.8（相抵 / 满秩 / QR / Schur / 对角化 / 谱分解与幂等阵 / Jordan 分解）；第 4 章 4.1–4.3（向量范数 / 矩阵范数 / 相容范数，含范数闭环交互件）。其余小节待素材补齐 |
| 📊 数值分析 | [开始阅读](https://juanwang-buaa.github.io/tutorials/numerical/) | 以课堂实录为主线（第 1–12 讲全程，含板书、老师强调考点与错词对照；第 10–11 讲含稳定计算、Runge 现象、数值实验与分层练习，第 12 讲含正交多项式族与数值积分分层练习）+ 教材正文七章 + 补充篇；复习层（公式卡 / 易混对照 / 术语索引 / 必读路径）+ 特训层（竞技场 / 考场模拟卷） |
| 🧠 深度学习导论 | [开始阅读](https://juanwang-buaa.github.io/tutorials/deeplearning/) | 九讲正文按「讲导览 + 66 节 + 讲末材料」组织；每讲含总结 / 勘误 / 习题 / 自检表 / 回忆卡 / 自测卷；另有工程工具箱、复习层（公式卡 / 易混对照卡 / 术语表 / 速查背记卡）、特训层（面试竞技场 / 综合自测卷）、延伸阅读地图与三个 Lab；依据 MIT 6.S191 整理扩充 |
| 🐧 Linux 系统与内核 | [开始阅读](https://juanwang-buaa.github.io/tutorials/linux/) | 六篇 85 章 + 项目篇：命令行与 Shell、计算机系统（CSAPP/OSTEP）、系统编程（Kerrisk）、Linux 内核、网络协议栈、云原生；附 11 个真实项目的从零复现；逐章覆盖 10 部母本 |
| 🧭 Agent 系统工程 | [开始阅读](https://juanwang-buaa.github.io/tutorials/agent-systems/) | 4 篇 14 章 + 2 个项目：循环与状态、工具协议（JSON Schema/function calling/MCP）、沙箱与权限、上下文与记忆、规划与多智能体、评估/观测/安全/治理；与 Linux 卷、DL 卷交叉引用 |
| 🌐 分布式系统与数据面 | [开始阅读](https://juanwang-buaa.github.io/tutorials/distributed/) | 5 篇 13 章 + 2 个项目：请求与失败、复制与共识、事务与消息、缓存与观测、容量与演练；从一次工具调用走到可验证的一致性 |
| 🧱 编译器与程序分析 | [开始阅读](https://juanwang-buaa.github.io/tutorials/compilers/) | 4 篇 14 章 + 2 个项目：词法/AST、类型/作用域、IR/SSA、数据流与优化、寄存器分配、ABI 代码生成、UB/sanitizer、fuzzing、形式化验证、JIT 沙箱；附迷你 C 编译器和 agent 代码验证器 |
| ⚡ 算法、评估与因果推断 | [开始阅读](https://juanwang-buaa.github.io/tutorials/algorithms/) | 4 篇 14 章 + 2 个项目：渐进分析、分治、图算法、平摊分析、贪心与反例、动态规划、NP难与近似、在线算法、评估指标、假设检验、模型评估与选择、准实验因果推断；附算法评测系统与 A/B 测试分析流水线 |
| 🦀 Rust 底层性能工程 | [开始阅读](https://juanwang-buaa.github.io/tutorials/cpp-rust/) | 4 篇 16 章 + 2 个项目：rustc 编译流水线、内存布局与 niche、所有权与 unsafe 证明、原子与 128B 伪共享消除、Tokio 调度器与管道背压、无锁队列与 EBR 代际回收、ARM NEON 向量化与零拷贝、系统采样与 CI 门禁；附 Agent 工具执行器与跨语言 C ABI 组件 |
| 🔌 边缘嵌入式与实时系统 | [开始阅读](https://juanwang-buaa.github.io/tutorials/edge/) | 4 篇 14 章 + 2 个项目：x86/ARM/RISC-V 架构、汇编、ABI、启动、中断、抢占式 RTOS、总线 MMIO/DMA、CAN 协议栈、定点滤波、流式 DAQ、芯片低功耗、看门狗容错、INT8 张量推理与双区 OTA；附工业 CAN 诊断节点与高速 DAQ 自愈两个可运行项目 |
| 📕 马克思主义原理 | [开始阅读](https://juanwang-buaa.github.io/tutorials/mlm/) | 6 篇 45 章 + 4 附录：唯物史观与辩证法（7 章）、政治经济学批判（12 章，商品到地租，含列宁帝国主义论）、国家与革命（7 章，含卢森堡《社会改良还是革命？》全篇论证与阿尔都塞《论再生产》六节）、第一国际到共产国际（6 章）、中国革命与毛泽东的理论（9 章，含文革与《论我国革命》）、当代问题与方法训练（4 章）；每章按问题—概念—机制—证据—反驳组织，引文标印刷页码并分级；附年表、59 条概念表、文献版本分级与 45 道习题 |

## 仓库结构

```
robot/         机器人控制技术 · mdBook 源（src/ 为 Markdown 本体，theme/ 为本书样式与脚本）
matrix/        矩阵论 · mdBook 源
numerical/     数值分析 · mdBook 源
deeplearning/  深度学习导论 · mdBook 源
linux/         Linux 系统与内核 · mdBook 源（六篇 + 项目篇；独立图版脚本）
agent-systems/ Agent 系统工程 · mdBook 源（4 篇 14 章 + 2 个项目；复用 shared/theme）
distributed/   分布式系统与数据面 · mdBook 源（5 篇 13 章 + 2 个项目）
compilers/     编译器与程序分析 · mdBook 源（4 篇 14 章 + 2 个项目；复用 shared/theme 与 tools）
algorithms/    算法、评估与因果推断 · mdBook 源（4 篇 14 章 + 2 个项目；复用 shared/theme 与 tools）
embodied/      具身感知：SLAM、状态估计与传感器融合 · mdBook 源（4 篇 14 章 + 2 个项目；机器人卷 II）
cpp-rust/      Rust 底层性能工程 · mdBook 源（4 篇 16 章 + 2 个项目；复用 shared/theme 与 tools）
edge/          边缘嵌入式与实时系统 · mdBook 源（4 篇 14 章 + 2 个项目；复用 shared/theme 与 tools）
mlm/           马克思主义原理 · mdBook 源（6 篇 45 章 + 4 附录；三类本书专属语义盒 arg/src/debate，
               见 mlm/theme/css/mlm.css；复用 shared/theme 与 tools）
shared/        十三本书**共用一份**的浏览器侧资源与构建工具（各书 theme/ 里是符号链接）；
               RHINE.md 记录可选的「莱茵档案」皮肤
  theme/       head.hbs、atlas 视觉层、framework/prefs 的 css+js、search-cjk.js
  README.md    共用层说明与本地构建方式
<book>/src/assets/
  covers/      十一张平装书封（首页与导览页共用；其中四张由 tools/build_covers.py 生成）
  figures/     内联 SVG 图鉴片段（tools/build_atlas_figures.py 生成，页面里 include）
tools/         仓库级构建脚本（十本一份）+ theme-renderer/（莱茵档案 3D 场景与封面源）：
  build_search_js.mjs     构建后重建中文搜索索引（分词与查询同源）
  build_glossary.py       构建后抽术语数据 + 给页面打标记
  katex_wrapper.py        包装 mdbook-katex，中和会被 Markdown 误读的字符
  build_covers.py         生成四本平装书封 SVG
  build_atlas_figures.py  生成教学图鉴（SVG + 图注 Markdown 片段）
build.sh       一键构建十本 + 后置步骤 → _site/（与 CI 步骤一致）
site-index.html 教程库首页（课程目录，构建时拷为 _site/index.html）
.github/       Pages 自动部署工作流
```

书与书的边界很清楚：**共用行为**在 `shared/`（一份），**本书样式**在各书 `theme/css/<书>.css`
（权威样式表），**本书预处理规则**在各书 `tools/mathbook.py`。

仓库只包含教程本体（`book.toml` + `src/` + `theme/`）。课程录播、转录稿、PPT 原料等中间产物不纳入版本管理。

## 视觉层与图鉴（2026-10）

这一轮把正文升级为图文并重的教程：保留文档的克制排版，用结构图和读图提示承担教学。各本书共用同一套样式，但每本书保留自己的封面。

| 层 | 文件 | 作用 |
|:--|:--|:--|
| 设计底座 | `shared/theme/css/base.css` | 五套主题、语义盒、尺寸/字号令牌（原有） |
| 图鉴视觉层 | `shared/theme/css/atlas.css` | 页首标题与章节描边编号、书首页事实章节索引、插图卡片、图注、平装书封、图表排版语汇、图鉴画廊、窄屏宽图平移 |
| 图鉴交互层 | `shared/theme/js/atlas.js` | 原生图片自动图注、页首阅读元信息、菜单栏「图鉴」总览、宽图平移包装 |
| 插图生成 | `tools/build_atlas_figures.py` | 输出 `<book>/src/assets/figures/*.md`：统一 900 宽的 SVG 展示台 + KaTeX 图注 |
| 书封生成 | `tools/build_covers.py` | 输出 `<book>/src/assets/covers/*.svg`：机械臂 / 线性映射 / 三维曲面 / 神经网络四张封面 |
| 导览页 | `site-index.html` | 主视觉书封条 + 教学图鉴 feature + 书目（带封面）+ 学习路线；竖排标签、平装封面、hover 反相书目行、浅/深色切换 |

**加载顺序**：`base → <book> → katex → framework → atlas → prefs`。atlas 只用令牌与组件级
特异性，不覆盖读者在 prefs 里的字体 / 字号 / 行距 / 版心选择。

**新增一张图鉴图**：

1. 在 `tools/build_atlas_figures.py` 里加一个 `fig_xxx()`，用 `plate()` / `flow_plate()` /
   `plot_plate()` / `network_plate()` 等原语；图注用 `<b>读图：</b>` 开头，可含 `$...$`。
2. 运行 `python3 tools/build_atlas_figures.py --only xxx`，生成 `<book>/src/assets/figures/xxx.md`。
3. 在目标页面的第一个 `##` 标题前加一行 `{{#include ../assets/figures/xxx.md}}`
   （`lectures/lecNN/` 下用 `../../assets/figures/...`），然后 `./build.sh`。

生成物本身已提交，CI 不需要运行生成脚本；修改生成脚本后记得重跑并提交对应片段。
插图全部是内联 SVG，颜色走 `--accent` / `--atlas-cyan` / `--fig-*` 等令牌，明暗主题与强调色自动跟随；
窄屏下 900 宽的图会进入「可左右平移的图版」，不会把 15px 图内文字压成 5px。

完整排版语汇、原语清单与验收清单见 [tools/ATLAS_FIGURES.md](tools/ATLAS_FIGURES.md)。


## 莱茵档案：可选的明日方舟式皮肤（2026-10）

默认仍是经典图鉴。偏好面板的「界面外观」或导览页右上角可切到 **莱茵档案**；它只加
`html[data-skin="rhine"]`，不改变正文、章节、搜索与导航。参考了
[明日方舟官网](https://ak.hypergryph.com/)的黑—青终端结构、
[终末地官网](https://endfield.hypergryph.com/)的黑底稀疏状态语汇，以及
[莱茵生命站点](https://rhine.reverieach.com/)、
[RhineLabUI](https://github.com/LBEILC/RhineLabUI)/
[Rhine-Music-Demo](https://github.com/RonaldDeng/Rhine-Music-Demo) 的厚玻璃档案匣与暖纸阅读室。

| 层 | 文件 | 作用 |
|:--|:--|:--|
| 终端导览 | `shared/theme/css/rhine-portal.css` + `js/rhine-portal.js` | 全幅首屏：黑功能条、超大 `ATLAS`、青色档案区、黑色档案块、01–08 索引；从经典 `<main>` 读取课程，经典 DOM 保留可随时还原 |
| 3D 场景 | `tools/theme-renderer/scene.js` → `shared/theme/js/rhine-scene.js` | 左侧八格档案架（八件完整档案，书脊朝外，侧面编号）+ 单件厚玻璃档案匣：同一组物转向/抽出/展开，文档全程留在匣内；内部文件/实体双环/纸标签/螺钉；涟漪、指针视差；2× 超采样；可点选架上书脊 |
| 终端启动 | `rhine-portal.js` + `rhine-portal.css` | 每个标签页首次进入的黑场装载：ATLAS、青色进度、状态码；可跳过、`sessionStorage` 去重、减少动态效果直接跳过 |
| 阅读皮肤 | `shared/theme/css/rhine.css` + `js/rhine.js` | 暖纸正文 + 黑色终端菜单栏/青色进度线；`COURSE ARCHIVE` 装饰条；全部 screen-only |
| 偏好解耦 | `shared/theme/js/prefs-config.js` | 首屏恢复、mdBook 面板、导览页皮肤选择共用一份 schema；默认 `classic` 不落属性 |
| 资源 | `shared/theme/assets/rhine-*.svg`、`shared/theme/vendor/three-LICENSE.txt` | 八张目录封面（构建产物）；Three.js MIT |
| 说明 | `shared/theme/RHINE.md` | 结构、令牌、动效、构建、验收与已知限制 |

```bash
# 修改 3D 源后
pnpm --dir tools/theme-renderer install
pnpm --dir tools/theme-renderer build
python3 tools/theme-renderer/build_art.py

# 全部书 + 搜索 + 术语 + 导览页
./build.sh
node --test tools/test_theme_config.mjs
```

**验证口径**：经典模式与 HEAD 基线逐元素计算样式比对（三本原书正文 14 项属性、菜单栏/侧栏/正文
边框与宽度、导览页 `<main>` 208 个元素全部一致）；莱茵→经典→莱茵往返后正文 DOM 与计算样式
完全一致。3D 桌面 60fps；浅/深色、390px 窄屏、`prefers-reduced-motion` 均有实拍。


## 本地开发

```bash
brew install mdbook        # 如未安装
./build.sh serve           # 构建十本（含搜索索引与术语数据）并起预览 http://127.0.0.1:8000/
```

⚠️ 不要只跑 `mdbook serve`：搜索索引与术语数据都是**构建后产物**，而 mdBook 每次构建会先清空
`book/`，只跑 mdbook 会得到一个没有索引、没有术语气泡的站点。`./build.sh` 与 CI 的步骤一致。

本地与 CI 使用同一质量检查入口：

```bash
bash check.sh                 # 单元测试、章节检查、项目测试、构建、产物与浏览器检查
bash check.sh --no-browser    # 不运行浏览器，其余检查照常执行
```

依赖、浏览器安装、检查范围及内容审校方法见 [质量检查与内容审校](docs/quality-gates.md)。检查通过代表已列出的门禁通过；全书知识结论仍需内容审校。

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
| 7 | `framework.js` 拆分 | ✅ | 原为单文件 1050 行、职责十项；现按内聚拆成四份，四本书的 `additional-js` 全部改接新模块：`framework-core.js`（共享工具 / 界面文案汉化 / 回到顶部 / 折叠状态记忆 / 启动注册表）+ `framework-nav.js`（侧栏章节折叠 / 右栏大纲 / 已读标记 / 继续阅读）+ `framework-media.js`（插图灯箱 / 进场）+ `framework-text.js`（公式复制 / 术语悬挂提示）。模块之间只依赖 `TUTORIALS_CORE` 小接口，不互相依赖；三本书里残留的 `theme/js/framework.js` 死符号链接已清理 |
| 8 | 尺寸令牌化 | ✅ | §1.4 补**字号刻度**（`--fs-2xs…--fs-display`，11 档，按角色命名）；随后把组件里**正好等于刻度值**的字面量机械换成令牌（间距 111 处 + 字号 69 处 = **180 处**）。规则：只做「同值换名」，不做取整——不在刻度上的值（如 `18px 22px 14px`、`13.5px`）保留原样，因此**可证明零视觉变化**（A/B 计算样式比对 9 页逐元素零差异）。审计脚本确认「仍在用字面量但正好等于刻度」为 0 处 |
| 9 | 深度学习教程结构化重构 | ✅ | 九讲从「一讲一页」升为「讲导览 + 节页 + 讲末六页」（`lectures/lecNN/{overview,secNN,summary,errata,exercises,checklist,recall-cards,mock-exam}.md`），对齐其余三本的组织方式；新增工程工具箱、复习层（公式卡/易混对照卡/术语表/速查背记卡）、特训层（面试竞技场/综合自测卷）、延伸阅读地图、附录（选题路线/工具地图/补充推导）；写作规范与页面模板落在 `deeplearning/写作规范/`（5 份），并统一为「讲号.节号」编号与 `{#type-N.M.K}` 锚点体系。规模：`src` 由约 3.5k 行 → 36.4k 行（157 页 / 66 节 / 54 个讲末页 / 662 个锚点）；9 个旧 `lecNN.md` 单文件已删除（内容并入节页） |
| 10 | 盒子配平工具 | ✅ | 新增 `tools/boxfix.py`（`--check` 只查、默认修复）：盒子漏写外层闭合会让 `mathbook.py` 中止构建，本工具按同一判据补齐并复验。配套约定写入 `deeplearning/写作规范/05-讲末六页规范.md`：**平铺闭合**（先关内层 `proof`/`sol`，再关外层 `ex`/`method`），「即时自测」的锚点取节内最大序号 +1 以避免撞号 |
| 11 | 图鉴视觉层 | ✅ | 新增 `shared/theme/css/atlas.css` + `shared/theme/js/atlas.js`：页首标题与阅读元信息、插图卡片与图注、页内「图鉴」画廊、原生图片自动图注、平装书封。菜单栏新增「图鉴」入口；窄屏宽图改为横向平移版，不压缩图内文字 |
| 12 | 书封与导览页 | ✅ | `tools/build_covers.py` 生成四张平装书封（机械臂 / 线性映射 / 三维曲面 / 神经网络）；四本书首页改为「文字 + 平装书封」双栏封面；`site-index.html` 重做为编辑式课程索引（大字号宋体、竖排标签、封面网格、课程行、深浅色切换） |
| 13 | 定制教学插图 | ✅ | `tools/build_atlas_figures.py` 生成 20 张内联 SVG 图鉴（流程 / 对比 / 矩阵分解 / 网络 / 关系图五类原语），覆盖机器人、矩阵、数值、深度学习四本书；图注以「读图」提示收束，数学公式由 KaTeX 构建期渲染 |

## 课程查找与阅读体验（2026-10）

首页可按课程名、简介关键词和方向筛选；支持中文输入法、全角英文及多个关键词。筛选覆盖经典图鉴与莱茵档案两套外观，切换时保留筛选条件。手机端保留课程目录与学习路线入口。

首页展示最近浏览的三门课程，链接恢复到上次可见的小节；记录仅保存在当前浏览器。阅读页增加跳到正文入口，页底翻页显示目标章节标题；浏览记录统一称为「已浏览」，不将打开页面视为完成学习。搜索空结果提供换词建议并说明仅检索当前课程。

复现：`bash check.sh`。新增 `tools/browser-portal.js` 覆盖课程发现、皮肤切换、阅读恢复、窄屏、存储拒绝与禁用 JavaScript 等流程。

## 部署

推送到 `main` 分支后，GitHub Actions 执行质量检查、构建十本书，全部成功后发布到 Pages。面向 `main` 的 PR 执行同一检查但不发布。各书首页会说明正文范围与待补内容。

数学内容核验优先覆盖矩阵论与数值分析，采用可重复运行的 SMT-LIB 2/Z3 义务和数值复算。范围、已修正问题与未证明部分见[形式化核验记录](docs/formal-verification.md)。
