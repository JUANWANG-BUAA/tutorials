# 1.1 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与工具链陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换编译器、换 binutils、换架构后要复核什么**。

**本章基线**：Ubuntu 24.04、gcc 13.2、binutils 2.42、glibc 2.39、Linux 6.8。换环境时逐条复核。

## 1. 编译、ELF 与进程

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `hello.c` 就是程序 | 源文件是文本；程序是编译/链接后的 ELF | `file hello` |
| 2 | `gcc hello.c` 只有一步 | 预处理/编译/汇编/链接四阶段 | `gcc -E/-S/-c`、`-v` |
| 3 | ELF 的 section 就是 segment | section 给链接器/调试器，segment 给加载器 | `readelf -S/-l` |
| 4 | 入口就是 `main` | 入口是 `_start`，libc 再调 `main` | `readelf -h`、`nm`、gdb |
| 5 | `exec` 会返回 | 成功不返回；失败 -1 | `strace`、`perror` |
| 6 | `fork` 后 fd 完全独立 | fd 表复制，但共享打开文件描述/偏移 | `fork` + `read` 测试 |
| 7 | 虚拟地址就是物理地址 | 页表映射；进程各自地址空间 | `/proc/PID/pagemap`（root） |
| 8 | 栈从低地址往高长 | x86-64 栈通常向低地址增长 | `gdb`/`&local` |

## 2. 链接、加载与工具

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 9 | 静态链接一定更好 | 体积大、升级要重编、不共享；动态可共享/升级 | `size`、`ldd`、`readelf -d` |
| 10 | `ldd` 只是看依赖 | 它会执行 loader；来源不明用 `readelf -d` | `ldd` vs `readelf -d` |
| 11 | PLT 与 GOT 是一回事 | PLT 是跳转桩，GOT 存地址；lazy/now 不同 | `objdump -d`、`readelf -r`、`LD_DEBUG` |
| 12 | `LD_PRELOAD` 总能覆盖 | setuid/安全模式可能忽略；符号版本可能不匹配 | 对比普通/setuid |
| 13 | auxv 无关紧要 | 加载器/libc 靠 AT_PHDR/AT_ENTRY/AT_BASE | `gdb info auxv` |
| 14 | PIE/ASLR 不影响实验 | 地址随机化影响断点/缓存测量 | `setarch -R`、`gdb` |
| 15 | 同一 C 代码三架构 ELF 一样 | machine/entry/ABI/指令不同 | `file`、`readelf -h` |
| 16 | 交叉编译就能直接跑 | 需要目标架构/qemu/容器平台 | `qemu-aarch64`、`--platform` |

## 3. 性能、缓存与观测

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 17 | cache 测一次就准 | 冷启动/频率/中断/ASLR 影响；要预热/多次 | 重复测量、绑核 |
| 18 | `perf stat` 数字绝对可靠 | 计数器复用/多路/虚拟化有误差 | `perf stat -r`、对照 |
| 19 | 优化热点一定有大收益 | Amdahl 受未优化部分限制 | 算 `1/((1-p)+p/s)` |
| 20 | CPI 是固定值 | 依指令/缓存/流水线/频率 | `perf stat` 实测 |
| 21 | 指针追逐测带宽 | 串行依赖测延迟；MLP 影响 | 改并发/步长测试 |
| 22 | 编译器不会改逻辑 | 优化可能重排/内联/消除；`volatile`/`-O0` 对照 | `objdump`、`-S` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的编译器/架构上使用前先验证：

- gcc/binutils 的默认 PIE/RELRO/stack protector 依发行版；`gcc -v`/`readelf -h` 为准。
- 入口 `_start` 的栈布局/auxv 依内核/架构/加载器；`gdb info auxv` 为准。
- PLT/GOT/lazy binding 的实现依架构/编译选项；`LD_BIND_NOW`/`-z now` 会改变。
- 交叉编译/qemu 的系统调用/库路径依环境；`qemu-aarch64 -L` 指定 sysroot。
- `perf` 在容器/虚拟化/权限受限时可能不可用或数字有偏差。

## 5. 发现新问题怎么记

如果你在别的编译器/架构上发现本章结论不成立，按「现象 → 命令/输出 → 版本/架构 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
