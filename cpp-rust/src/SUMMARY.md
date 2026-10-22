# 目录

- [写作状态与Rust主线](index.md)

## 第一篇：数据与编译器

- [1 测量：让编译器、时钟与回归预算说同一种话](part1/ch01.md)
- [2 对象：布局、热字段与可证明的存储复用](part1/ch02.md)
- [3 所有权：借用、初始化、销毁与unsafe证明边界](part1/ch03.md)
- [4 从所有权事实到机器码：rustc 的分层证据](part1/ch04.md)

## 第二篇：优化与并发

- [5 泛型、trait 对象与优化可见性](part2/ch05.md)
- [6 LLVM、CTFE 与可验证的优化边界](part2/ch06.md)
- [7 并发、原子与内存序](part2/ch07.md)
- [8 异步的编译器底座](part2/ch08.md)

## 第三篇：高性能运行系统

- [9 多任务执行器、Tokio、背压与公平性](part3/ch09.md)
- [10 多进程、IPC、输出背压与异常回收](part3/ch10.md)
- [11 无锁数据结构、ABA问题与内存回收机制](part3/ch11.md)
- [12 向量化、零拷贝数据流与异步I/O边界](part3/ch12.md)

## 第四篇：证据与项目

- [13 Profiling：从热栈到可以反驳的归因](part4/ch13.md)
- [14 Cargo、构建身份与性能发布门禁](part4/ch14.md)
- [15 项目一：有界agent工具runtime的资源与取消协议](part4/ch15.md)
- [16 项目二：Rust 高性能组件与最小 C ABI](part4/ch16.md)

## 附录

- [母本逐节台账与全书覆盖](appendix/coverage.md)
