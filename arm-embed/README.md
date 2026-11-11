# 《嵌入式系统》定制教程（arm-embed）

依据课程课件（2026 年秋季）整理扩充的 mdBook 教程，覆盖：

- **第二章 · ARM 微处理器体系结构**（127 页课件）：ARM 公司与体系结构族谱、AMBA
  总线、Cortex-A9 微架构、数据类型、处理器状态与模式、37 个内部寄存器、CPSR/SPSR、
  异常、复位、存储器与存储器映射 I/O。
- **第三章 · ARM 指令集**（157 页课件）：条件域与指令格式、九种寻址方式、存储器
  访问指令、数据处理与桶形移位器、乘法、分支、杂项与伪指令、Thumb 互操作。
- **第四章 · 嵌入式操作系统**（196 页课件）：安全关键系统与 DO-178B/C、ARINC 653、
  主流 RTOS 全景、微内核与 seL4、RT-Thread、任务模型与调度（RMS/EDF/LLF）、
  进程间通信、中断与时钟、内存管理、实时 Linux。

第一章（绪论）课件待老师发布，SUMMARY 中预留占位。

## 日常操作

```bash
mdbook serve --open   # 本地预览（含全文搜索）
mdbook build          # 生成静态站点到 book/
make verify           # 结构质检（mathbook 预处理器测试 + check_book）
```

## 素材与来源

- 课件原件与逐页文本提取存放在仓库根 `_sources/embedded-ppt/`（gitignore，
  不入库）；每节标注对应的课件页码区间，勘误页记录课件与教程的差异。
- 视觉层沿用仓库共享设计语言（`shared/theme/`），本书自有样式在
  `theme/css/armembed.css`，交互脚本在 `theme/js/armembed.js`。

## 目录约定

- `src/chNN/overview.md` 章导览；`secN-M.md` 小节正文。
- 章末六件：`summary / errata / exercises / checklist / recall-cards / mock-exam`。
- `tools/mathbook.py` 是编号、交叉引用与语义盒子的预处理器（各书一份，
  与 robot 版同源）；`tools/check_book.py` 为本书结构与引用质检。
