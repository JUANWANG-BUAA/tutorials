# 覆盖验证报告（2026-10-18）

> 目的：证明 10 本母本「除已淘汰内容外没有整章/整节被漏掉」，并记录验证方法与证据。
> 本报告是**审计记录**，不是教程正文。

## 1. 范围

| 母本 | 正文章节 | 节级条目（可抽取） | 本书落点 |
|:--|--:|--:|:--|
| Kerrisk 系统编程手册 | 64 | 669 | 第 2 篇 + 0.12/1.x/3.x |
| CSAPP 3e | 12 | 102 | 第 1 篇 |
| OSTEP | 50 | 259 | 1.9/1.12/1.13 + 第 3 篇 |
| 操作系统原理、实现与实践 | 8（+8 实践） | 8（章级） | 第 3 篇「实现侧写」 |
| 奔跑吧 Linux 内核 | 6 | 46 | 第 3 篇 |
| 深入理解 Linux 网络 | 10 | 51 | 第 4 篇 |
| 鸟哥的 Linux 私房菜 | 25 | 115 | 第 0 篇 |
| Linux 命令行大全 | 36 | 34（章级） | 第 0 篇 |
| Linux 命令行与 shell 脚本编程大全 | 25 | 420 | 第 0 篇 |
| 计算机网络 8e | 9 | 8（章级） | 1.11 + 第 4 篇 |

合计 **245 章**；可抽取的节级条目 **1,712**（部分书只有章级目录：Shotts、李治军、计算机网络）。

## 2. 方法

1. **章级矩阵**：`tools/build_coverage.py` 把每章映射到本书落点，缺任何一章直接报错；输出 `src/appendix/coverage.md`。
2. **节级机械扫描**：`tools/audit_sections.py` 从母本目录抽标题关键词，在限定篇目正文（去掉代码/HTML）中找落点；输出 `写作规范/AUDIT-sections.md` 与 `AUDIT-chapters.md`。
3. **语义复核**：按不重叠页面范围分给 4 个审计代理（CLI / Kerrisk / CSAPP+OSTEP / 内核+网络+OS 实现），逐章判断「覆盖 / 合并 / 背景 / 淘汰 / 真缺口」，只对真缺口补写。
4. **结构验证**：`python3 tools/check_book.py` 检查占位、围栏、盒子、断链、断锚点、重复锚点；`mdbook build` 检查页面级 HTML/KaTeX 告警。
5. **全站验证**：仓库根 `./build.sh` 构建五本，生成 `_site/linux`、搜索索引、`glossary.json`。

## 3. 当前证据（审计中）

- 章级矩阵：**245 章，缺口 0**；完整/精选/背景/淘汰见 `coverage.md`。
- 节级机械扫描（排除教辅后）：1,722 条中 `zero` 15、`weak` 878、`ok` 829。`zero` 已收敛到 15 条，逐条复核中；多数是历史/背景或换了说法（如 `vi`/`数据流重导向`/`全球 IP` 已在其他节展开）。
- `check_book`：107 页，问题页/断链/断锚点/重复锚点 0。
- `mdbook build linux`：exit 0，页面级 WARN 0，仅 search index 体积提示。
- 根 `./build.sh`：exit 0，五本 + 导览页。

## 4. 语义复核结果

（待 4 个审计代理返回后填写：已补真缺口、合并/背景、淘汰、仍存疑。）

## 5. 结论口径

- 「无遗漏」指：每章有落点；每节至少被判定为覆盖/合并/背景/淘汰之一，且真缺口已补或有明确理由。
- 「淘汰」不等于遗漏：旧工具、桌面/GUI、安装器逐屏、打印等集中到 `appendix/legacy.md` 或明确标注背景。
- 不承诺逐字复述母本；承诺读者遇到该主题时，能在本书找到定义、边界与下一步。

## 6. 复现命令

```bash
cd linux
python3 tools/build_coverage.py     # 245 章矩阵，缺口非 0 会失败
python3 tools/audit_sections.py     # 节级机械扫描
python3 tools/check_book.py         # 结构质检
mdbook build                        # 页面级构建
cd .. && ./build.sh                 # 五本全站构建
```

## 7. 逐章深度增补（完成）

最终：**126,919 行、113 页、85 章；85/85 章 ≥1000 行**。最少 `part5/ch06` 1006 行，最多 `part2/ch16` 2000 行；81 章在 1000–1800，4 章略高于 1800。

| 块 | 页面 | 行数（约） | 状态 |
|:--|:--|:--|:--|
| Kerrisk 文件 I/O | 2.1–2.6 | 1545–1600 | 完成 |
| Kerrisk 进程/信号 | 2.7–2.11 | 1267–1482 | 完成 |
| Kerrisk 线程/同步 | 2.12–2.13 | 1900/1812 | 完成 |
| Kerrisk socket | 2.16 | 2000 | 完成 |
| CLI 文件/Shell | 0.3–0.8、0.9–0.14 | 1000–1442 | 完成 |
| 内核 | 3.1–3.15 | 1300–1850 | 完成 |
| CSAPP | 1.1–1.13 | 1000–1200 | 完成 |
| 网络 | 4.1–4.12 | 900–1320 | 完成 |
| 云原生 | 5.1–5.6 | 1000–1100 | 完成 |
| 多架构/Rust/RISC-V | 1.14–1.19 | 1000–1270 | 完成 |

增补方式：每章先读原书对应页（`pdftotext -layout`，记录 PDF 页码），再补 API/flags/struct/errno 表、内核路径、完整程序、strace/perf 实验与 8–15 条陷阱；不写「综上所述」凑行数。

## 8. 独立审计（2026-10-18）

- `AUDIT-KERRISK-SECTIONS.md`：584 个 `x.y` 节，明确落点 275、合并 95、背景 57、淘汰 138、可疑缺失 19；19 项已按报告补到 `ioctl/mount/mkstemp/statvfs/semop/TZ/times/dirname/lockf/fadvise/strsignal/服务器模型` 等节，记录见 `THREE-BOOK-GAP-FIXES.md`。
- `AUDIT-CSAPP-SECTIONS.md`：116 个编号节 + OSTEP 50 章，CSAPP 可疑缺失 3、OSTEP 1；已补 1.3.12.1（缓冲区溢出/ROP）、1.3.11.1（浮点）、1.12.13.1（强/弱扩展）、1.12.13.2（锁式数据结构）、1.9.10.1（GC）、1.11.5.1（MIME/CGI）。
- `AUDIT-KERNEL-SECTIONS.md`：奔跑吧 46 节 38/7/1/0 缺失；OSTEP 持久化 85 节 29/35/9/1/11 缺失，11 项已补（LFS、写错位置/丢失写、FFS、soft updates/CoW、cmwq、bitmap、mm 锁矩阵、API 表、polling/DMA）。

## 9. 多架构 × 多语言

- `theme/js/variants.js` + `theme/css/linux.css`：x86-64/ARM64/RISC-V × C/Rust/汇编，持久化、复制按钮。
- 1.14–1.19 已写：组成/ISA、汇编/ABI、编译/链接、Rust 系统编程、RISC-V 裸机、rCore 主线；共 1000–1200 行/章。
- 1.14–1.19 的 variant 渲染与切换已在 `_site` 用 Chrome 实测。
