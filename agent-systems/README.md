# Agent 系统工程 · 循环、协议、沙箱与评估

一本关于 **agent 新增层** 的 mdBook 教程：不重写操作系统、TCP/IP 与深度学习基础，只写把一个 agent 做成可运行、可观测、可评估、可审计系统所需要的那一层。

- 在线阅读（构建后）：`/tutorials/agent-systems/`
- 4 篇 · 14 章 · 2 个项目
- 每章 1000–1400 行，含机制图、可运行实验、失败案例、观测命令、母本对应、8–15 条陷阱、出口检查
- 14 个章实验 + 2 个完整项目；Python 实验只用标准库，离线可跑
- 163 个母本/规范/论文单元逐节映射，缺口 0

## 结构

```text
agent-systems/
  book.toml                 mdBook 配置（含 mathbook 与 katex 预处理器）
  src/
    SUMMARY.md              唯一导航
    index.md                封面与导览
    preface.md scope.md roadmap.md notation.md env.md
    part1/ch01.md … ch04.md 循环、协议、沙箱、权限
    part2/ch05.md … ch08.md 上下文、记忆、规划、多智能体
    part3/ch09.md … ch12.md 评估、可观测性、安全、治理
    part4/ch13.md ch14.md   两个项目
    projects/overview.md    项目总览与验收
    appendix/coverage.md    母本覆盖矩阵（生成物）
    appendix/errata.md      跨书勘误与共享系统调用
    appendix/references.md  规范、论文、术语
    assets/figures/         SVG 机制图（tools/build_figures.py 生成）
    assets/covers/          书封
  experiments/              每章实验 + errata 验证 + run_all.sh
  projects/                 两个项目的完整实现
  tools/                    mathbook、check_book、check_chapter、build_coverage、build_figures
  theme/                    本书样式；共用层是 shared/ 的符号链接
  写作规范/                 写作契约、章节大纲、母本目录
  coverage.md               覆盖矩阵副本（评审用）
  CHECK-agent-systems.md    独立事实核查与质量门禁报告
```

## 构建

```bash
# 只构建本书
mdbook build .

# 本地预览
mdbook serve --open  # 仅正文预览，不生成中文搜索索引和术语数据

# 在仓库根构建全部八本（含搜索索引与术语数据）
cd .. && ./build.sh
```

依赖：

```bash
pip3 install -r requirements.txt     # markdown-it-py
cargo install mdbook-katex           # 若未安装
```

## 自检

```bash
# 结构、行数、锚点、盒子、代码围栏、链接、SVG id
python3 tools/check_book.py --verbose

# 单章（写章时用）
python3 tools/check_chapter.py part1/ch02.md

# 覆盖矩阵：缺口非零会拒绝写出页面
python3 tools/build_coverage.py

# 实验：本机可跑的全绿
bash experiments/run_all.sh
```

## 与另外两本书的边界

| 主题 | 去哪读 | 本书只做什么 |
|:--|:--|:--|
| 进程、信号、IPC、socket、epoll | 《Linux 系统与内核》第 2 篇 | 沙箱边界、wait status、进程组、超时 |
| namespace、cgroup、seccomp、容器 | 同书第 3/5 篇 | 组合次序、capability/landlock、OCI 字段映射 |
| TCP/IP、DNS、HTTP | 同书第 4 篇 | egress 策略、DNS 重绑定、SSRF |
| 神经网络、注意力、训练 | 《深度学习导论》 | token、上下文、成本等工程含义 |

覆盖矩阵见 [src/appendix/coverage.md](src/appendix/coverage.md)。

## 版本基线

MCP `2026-07-28`（对照 `2025-11-25`）、OCI Runtime Spec `v1.3.0`、OpenTelemetry semconv `1.44.0`、Linux 6.8 / Ubuntu 24.04、Python 3.11+、bash 5.2+。

版本会变。正文把版本写在句子里；读到时先确认它是否仍适用于你的环境。

## 勘误与贡献

- 五条历史错误（wait status、mq/sem variadic、clone 参数顺序、TZ 空值、shell 语义）集中在 [附录 B](src/appendix/errata.md)，附可运行证据。
- 发现错误请附：环境、命令、真实输出、期望行为。没有这四项，很难判断是书错还是环境差异。
- 不要修改 `shared/` 与其他书的 `SUMMARY.md`/`book.toml`；本书的共享层通过符号链接复用。

## 许可

教程正文与图由本仓库维护；引用的规范、论文与工具归各自权利人所有。正文为重新组织的讲解与示例，不是原文摘录。
