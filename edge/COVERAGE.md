# 母本逐节覆盖台账

**状态：尚未达到缺口 0。** 目录锚点存在不等于正文已正确吸收。

页码统一为 PDF 文件物理页（1 起算），不推测纸书页码。

## 来源清单

| 来源 | 文件 | 页数 | SHA-256 | 逐节目录已完整核录 |
|:--|:--|--:|:--|:--|
| ARM64 | ARM64体系结构编程与实践 (奔跑吧linux社区) (z-library.sk, 1lib.sk, z-lib.sk).pdf | 454 | `a1ec3041d8f3992ec5f862731770fc84d5c43a4baee593be3257ed60024bc49b` | 否 |
| Verilog高级 | Verilog高级数字系统设计技术与实例分析 (Kishore Mishra) (Z-Library).pdf | 413 | `354bc989700302a994504a45d73ef828d16af6a5360ddf1dc4265658fa408758` | 否 |
| Verilog讲义 | Verilog语法讲义.pdf | 32 | `17a5d35e128cb7cf2a4a2405033704124898ca6da1e45ca711a64d08922d9656` | 否 |
| CAN笔记 | CAN总线学习笔记.pdf | 6 | `c4ad3a30c1329f201a6d270f869e4a262f831460ed556e636a49ddf41e45c8d3` | 否 |
| CAN实战 | 工程师经验手记 CAN总线嵌入式开发 从入门到实战 第2版 (Pdg2Pic, 牛跃听，周立功，方丹等编著) (Z-Library).pdf | 369 | `95b12f4f3d022f3852a95903ddcd3755dde3f567fe61a5fa2dc5411e124373e3` | 否 |
| 电路 | 电路 邱关源-第五版.pdf | 587 | `9a5adf94f71f202fc91f8ed0d7bde2521a036476520503d29290989942cbb55e` | 否 |
| 运放 | 基于运算放大器和模拟集成电路的电路设计（原书第4版·精编版） (Sergio Franco) (Z-Library).pdf | 354 | `f04fa492c0809500042c4ff5bfd93bbab58e466b6fde41ae654d6cc2f0fe6cb6` | 否 |
| 仪表 | 仪表放大器应用工程师指南.pdf | 125 | `bd0ba2ab864125c3b03b5d7b000d32005a03749db70eba62d0e6d9ab81a4e6bc` | 否 |
| DAQ | 数据采集基础知识.pdf | 100 | `6fd8450cb342d26b31e9c9eb6b9616b8f573083b37394ed8f66ab9cc24558e03` | 否 |
| PCB | 电路设计、仿真与PCB设计——从模拟电路、数字电路、射频电路、控制电路到信号完整性分析 (崔岩松) (Z-Library).pdf | 538 | `d7cdec3954ab61232f7d373e802e595d4df039f7c1c92ed4f5cbd6460879037e` | 否 |
| 嵌入式C | 嵌入式C语言自我修养：从芯片、编译器到操作系统 (王利涛 编著) (Z-Library).pdf | 752 | `d4d465fd4e8476dfe8a218435a61402a169850280d6ec89f25e43f45af264fcf` | 否 |
| SJA1000-2000 | Philips SJA1000 Product specification (2000-01-04), SJA1000.pdf | 68 | `65b642a7257e9e91c343426a6c63c96ec0c2f6c5a3c99fa4c3cef6422ab3c1ae` | 否 |
| LM3S6965-2014 | TI Stellaris LM3S6965 Microcontroller (2014-07-15), lm3s6965.pdf | 761 | `c3bfe9f1bcfb128f6a940aeb27805ce7ad7806ed412210b1f32367b24249f0a1` | 否 |

## 已录入节

| 母本节 | 标题 | 页 | 状态 | 本书落点 | 证据 |
|:--|:--|:--|:--|:--|:--|
| ARM64 11.4 | 异常现场 | 170 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.1) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| ARM64 21.4.4 | 进程上下文切换 | 376–377 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.4) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| ARM64 21.4.5 | 新进程的第一次执行 | 378 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.2) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| ARM64 21.5.1 | 扩展进程控制块 | 379 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.5) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| ARM64 21.5.2 | 就绪队列 | 379 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.5) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| 嵌入式C 3.6.1 | ATPCS规则 | 148–149 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.1) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| 嵌入式C 3.6.2 | 在C中内嵌汇编 | 149–152 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.2) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| 嵌入式C 3.6.3 | 在汇编中调用C | 152–153 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.3) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| 嵌入式C 5.3.1 | 栈的初始化 | 276–277 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.5) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| 嵌入式C 5.3.2 | 函数调用 | 277–278 | 已抽页核读并落实 | [正文](src/part1/ch04.md#sec-edge.1.4.5) | [页级原创摘记与纠偏](evidence/ch04-source-notes.md) |
| ARM64 18.2.1 | 使用内存屏障的场景 | 311–312 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.3) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| ARM64 18.2.2 | ARM64 屏障指令 | 312 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.3) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| ARM64 18.2.3 | DMB 指令 | 312–314 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.3) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| ARM64 18.2.4 | DSB 指令 | 314 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.3) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| ARM64 18.2.5 | DMB/DSB 参数 | 315 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.3) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 2.8.1 | 地址的本质 | 112–114 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.1) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 2.8.2 | 总线的概念 | 114–115 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.1) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 2.8.3 | 总线编址方式 | 115 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.1) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 6.7.1 | 地址对齐 aligned | 421–423 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.7) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 6.7.2 | 结构体的对齐 | 423–424 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.1) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 6.7.4 | packed | 427–428 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.1) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| 嵌入式C 6.7.5 | aligned 与 packed | 428 | 已抽页核读并落实 | [正文](src/part2/ch05.md#sec-edge.2.5.1) | [页级原创摘记与实验边界](evidence/ch05-source-notes.md) |
| CAN笔记 I 1.4 | 位时间 | 1–2 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.4) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN笔记 I 2.1 | 数据帧 | 2–4 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.2) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN笔记 I 2.2 | 错误帧与故障界定 | 4–5 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN笔记 I 2.3 | 过载帧 | 5–6 | 已核读，过载帧尚未实现 | [正文](src/part2/ch06.md#sec-edge.2.6.2) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN笔记 I 2.4 | 帧间隔 | 6 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.2) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN笔记 II 1 | CAN FD 与 CAN 对比 | 6 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.3) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.8 | CAN总线通信过程 | 20 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.1) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.10.1 | 数据帧 | 22–23 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.2) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.10.3 | 错误帧 | 26 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.12 | 位定时要求 | 29–30 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.4) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.13 | 同步 | 30–31 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.4) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.14 | 位流编码及位填充 | 31–32 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.2) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.15.1 | 错误类型 | 32 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.15.2 | 错误标志 | 32–33 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.16.1 | 故障界定的方法 | 33 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 1.16.2 | 错误计数规则 | 33–34 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 2.1.2 | BasicCAN模式内部寄存器地址表 | 59–60 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 2.1.3 | PeliCAN模式内部寄存器地址表 | 60 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 2.1.7 | CAN总线通信波特率的计算 | 68–70 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.4) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| CAN实战 2.1.8 | SJA1000初始化流程 | 70 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.3 | Mode Register | 26–27 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.4 | Command Register | 28–29 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.5 | Status Register | 29–30 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.6 | Interrupt Register | 31 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.9 | Error Code Capture | 36–37 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.11 | RX Error Counter | 38 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.12 | TX Error Counter | 38 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.6) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.13 | Transmit buffer | 39–42 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.14 | Receive buffer | 42–44 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.4.15 | Acceptance filter | 44 | 部分抽页，整节待核读 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.5.1 | Bus Timing Register 0 | 50 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.4) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.5.2 | Bus Timing Register 1 | 50–51 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.4) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| SJA1000-2000 6.5.4 | Clock Divider Register | 55–56 | 已抽页核读并落实 | [正文](src/part2/ch06.md#sec-edge.2.6.5) | [页级原创核读与范围限制](evidence/ch06-source-notes.md) |
| 嵌入式C 7.1.2 | 有符号数和无符号数 | 477–480 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.3) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| 嵌入式C 7.1.3 | 数据溢出 | 480–483 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.8) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| 嵌入式C 7.1.4 | 数据类型转换 | 483–485 | 部分抽页，整节待核读 | [正文](src/part2/ch07.md#sec-edge.2.7.3) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| DAQ 采样-基带抗混叠 | 采样与基带抗混叠（抽页） | 46–50 | 部分抽页，整节待核读 | [正文](src/part2/ch07.md#sec-edge.2.7.1) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| DAQ FFT-交流性能指标 | FFT、SINAD/SNR/ENOB（抽页） | 55–59 | 部分抽页，整节待核读 | [正文](src/part2/ch07.md#sec-edge.2.7.6) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 11.3.1 | Sample Sequencers | 397 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 11.4 | Initialization and Configuration | 402 | 部分抽页，整节待核读 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg2 | ADC Raw Interrupt Status | 406 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg3 | ADC Interrupt Mask | 407 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg4 | ADC Interrupt Status and Clear | 408 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg5 | ADC Overflow Status | 409 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg13–16 | ADC Sample Sequence Result FIFOs | 424 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg17–20 | ADC Sample Sequence FIFO Status | 425 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| LM3S6965-2014 ADC-Reg26 | ADC Sample Sequence Control 3 | 430 | 已抽页核读并落实 | [正文](src/part2/ch07.md#sec-edge.2.7.2) | [页级原创核读、类型纠偏与模型边界](evidence/ch07-source-notes.md) |
| DAQ 采样与实时系统 | 采样率与实时处理约束（抽页） | 41–44 | 部分抽页，整节待核读 | [正文](src/part2/ch08.md#sec-edge.2.8.1) | [页级原创核读与流式管道落地](evidence/ch08-source-notes.md) |
| DAQ 孔径时间与抖动 | 孔径延迟与孔径抖动SNR模型（抽页） | 72–75 | 部分抽页，整节待核读 | [正文](src/part2/ch08.md#sec-edge.2.8.1) | [页级原创核读与流式管道落地](evidence/ch08-source-notes.md) |
| DAQ 比较器亚稳态与闪码 | 比较器亚稳态与闪码排查（抽页） | 92–96 | 部分抽页，整节待核读 | [正文](src/part2/ch08.md#sec-edge.2.8.6) | [页级原创核读与流式管道落地](evidence/ch08-source-notes.md) |
| ARM64 16.8 | DMA 和高速缓存的一致性 | 265–267 | 已抽页核读并落实 | [正文](src/part2/ch08.md#sec-edge.2.8.4) | [页级原创核读与流式管道落地](evidence/ch08-source-notes.md) |
| ARM64 18.3.7 | DMA 内存屏障案例 | 310 | 已抽页核读并落实 | [正文](src/part2/ch08.md#sec-edge.2.8.4) | [页级原创核读与流式管道落地](evidence/ch08-source-notes.md) |
| 嵌入式C 2.8.2-ch08 | 总线矩阵与多主设备并发 | 114–115 | 部分抽页，整节待核读 | [正文](src/part2/ch08.md#sec-edge.2.8.2) | [页级原创核读与流式管道落地](evidence/ch08-source-notes.md) |
| LM3S6965-2014 2.7 | 电源管理与休眠 (WFI/WFE) | 90–91 | 已抽页核读并落实 | [正文](src/part3/ch09.md#sec-edge.3.9.4) | [页级原创核读与低功耗状态机落地](evidence/ch09-source-notes.md) |
| LM3S6965-2014 5.2.4 | 系统时钟与 PLL 模式 | 183–186 | 已抽页核读并落实 | [正文](src/part3/ch09.md#sec-edge.3.9.4) | [页级原创核读与低功耗状态机落地](evidence/ch09-source-notes.md) |
| LM3S6965-2014 5.4-ch09 | 系统时钟门控寄存器组 (RCGC/SCGC/DCGC) | 214–233 | 部分抽页，整节待核读 | [正文](src/part3/ch09.md#sec-edge.3.9.4) | [页级原创核读与低功耗状态机落地](evidence/ch09-source-notes.md) |
| LM3S6965-2014 22.2.5 | 睡眠模式交流特性表 22-16 | 709 | 已抽页核读并落实 | [正文](src/part3/ch09.md#sec-edge.3.9.7) | [页级原创核读与低功耗状态机落地](evidence/ch09-source-notes.md) |
| ARM64 16.1 | 芯片功耗随频率电压变化规律 | 265–267 | 已抽页核读并落实 | [正文](src/part3/ch09.md#sec-edge.3.9.1) | [页级原创核读与低功耗状态机落地](evidence/ch09-source-notes.md) |
| LM3S6965-2014 10.1–10.4 | 看门狗定时器与密钥锁定 (WDTLOAD/CTL/LOCK) | 371–382 | 已抽页核读并落实 | [正文](src/part3/ch10.md#sec-edge.3.10.2) | [页级原创核读与功能安全容错落地](evidence/ch10-source-notes.md) |
| LM3S6965-2014 5.2.2.7-ch10 | 复位原因寄存器 (RESC) | 176、194 | 已抽页核读并落实 | [正文](src/part3/ch10.md#sec-edge.3.10.8) | [页级原创核读与功能安全容错落地](evidence/ch10-source-notes.md) |
| LM3S6965-2014 2.6.3-ch10 | 故障状态与地址寄存器 (CFSR/HFSR/BFAR) | 90 | 已抽页核读并落实 | [正文](src/part3/ch10.md#sec-edge.3.10.4) | [页级原创核读与功能安全容错落地](evidence/ch10-source-notes.md) |
| ARM64 11.4-ch10 | 异常现场保存与故障恢复 | 170 | 已抽页核读并落实 | [正文](src/part3/ch10.md#sec-edge.3.10.6) | [页级原创核读与功能安全容错落地](evidence/ch10-source-notes.md) |
| ARM64 22.3 | NEON 指令集与 SIMD 架构 | 378–385 | 已抽页核读并落实 | [正文](src/part3/ch11.md#sec-edge.3.11.1) | [页级原创核读与边缘张量推理落地](evidence/ch11-source-notes.md) |
| ARM64 22.4 | NEON 汇编与乘累加向量化 | 385–395 | 已抽页核读并落实 | [正文](src/part3/ch11.md#sec-edge.3.11.5) | [页级原创核读与边缘张量推理落地](evidence/ch11-source-notes.md) |
| 嵌入式C 2.5.6-ch11 | SIMD 与多媒体指令集 | 84–86 | 已抽页核读并落实 | [正文](src/part3/ch11.md#sec-edge.3.11.5) | [页级原创核读与边缘张量推理落地](evidence/ch11-source-notes.md) |
| 嵌入式C 2.7.6-ch11 | NPU 神经网络处理器与边缘智能 | 105–110 | 已抽页核读并落实 | [正文](src/part3/ch11.md#sec-edge.3.11.1) | [页级原创核读与边缘张量推理落地](evidence/ch11-source-notes.md) |
| LM3S6965-2014 7.0-ch12 | Internal Flash Memory 控制器与写保护 | 261–270 | 已抽页核读并落实 | [正文](src/part3/ch12.md#sec-edge.3.12.6) | [页级原创核读与双区OTA闪存时序落地](evidence/ch12-source-notes.md) |
| LM3S6965-2014 22.1.6-ch12 | Flash Memory Characteristics 擦写电气特性 | 703 | 已抽页核读并落实 | [正文](src/part3/ch12.md#sec-edge.3.12.2) | [页级原创核读与寿命倍率定理物理落地](evidence/ch12-source-notes.md) |
| 嵌入式C 4.12-ch12 | U-boot重定位分析与LMA/VMA解耦 | 256–261 | 已抽页核读并落实 | [正文](src/part3/ch12.md#sec-edge.3.12.2) | [页级原创核读与Direct-XIP架构落地](evidence/ch12-source-notes.md) |
| ARM64 16.9-ch12 | 自修改代码与指令缓存一致性屏障 | 288–289 | 已抽页核读并落实 | [正文](src/part3/ch12.md#sec-edge.3.12.5) | [页级原创核读与硬件移交合同落地](evidence/ch12-source-notes.md) |
| 嵌入式C 3.6.1-ch13 | ATPCS 规约与函数寄存器传参 | 148–153 | 已抽页核读并落实 | [正文](src/part4/ch13.md#sec-edge.4.13.4) | [页级原创核读与项目一ABI落地](evidence/ch13-source-notes.md) |
| CAN实战 2.1-ch13 | CAN 协议基础与报文线与仲裁 | 20–34 | 已抽页核读并落实 | [正文](src/part4/ch13.md#sec-edge.4.13.6) | [页级原创核读与项目一告警仲裁落地](evidence/ch13-source-notes.md) |
| DAQ 4.0-ch13 | 信号调理与低通抗混叠滤波 | 42–50 | 已抽页核读并落实 | [正文](src/part4/ch13.md#sec-edge.4.13.4) | [页级原创核读与项目一定点滤波落地](evidence/ch13-source-notes.md) |
| ARM64 22.3-ch13 | SIMD 架构与定点量化向量点积 | 378–395 | 已抽页核读并落实 | [正文](src/part4/ch13.md#sec-edge.4.13.5) | [页级原创核读与项目一张量推理落地](evidence/ch13-source-notes.md) |
| LM3S6965-2014 11.0-ch13 | Watchdog Timer 控制器与复位 | 464–475 | 已抽页核读并落实 | [正文](src/part4/ch13.md#sec-edge.4.13.7) | [页级原创核读与项目一看门狗监管落地](evidence/ch13-source-notes.md) |
| DAQ 4.0-ch14 | ADC 采样电容充电与阻抗匹配 | 42–50 | 已抽页核读并落实 | [正文](src/part4/ch14.md#sec-edge.4.14.1) | [页级原创核读与项目二采样阻抗落地](evidence/ch14-source-notes.md) |
| ARM64 16.9-ch14 | DMA 接收端数据缓存使失效 | 288–289 | 已抽页核读并落实 | [正文](src/part4/ch14.md#sec-edge.4.14.3) | [页级原创核读与项目二Cache失效落地](evidence/ch14-source-notes.md) |
| LM3S6965-2014 7.0-ch14 | Flash 块擦除停顿与总线冻结 | 261–270 | 已抽页核读并落实 | [正文](src/part4/ch14.md#sec-edge.4.14.4) | [页级原创核读与项目二背压容量落地](evidence/ch14-source-notes.md) |
| LM3S6965-2014 6.0-ch14 | 系统控制与低功耗待机模式 | 216–228 | 已抽页核读并落实 | [正文](src/part4/ch14.md#sec-edge.4.14.5) | [页级原创核读与项目二WFI休眠落地](evidence/ch14-source-notes.md) |
| LM3S6965-2014 11.0-ch14 | 窗口看门狗与晶振故障自愈 | 464–475 | 已抽页核读并落实 | [正文](src/part4/ch14.md#sec-edge.4.14.7) | [页级原创核读与项目二故障自愈落地](evidence/ch14-source-notes.md) |

## 未关闭门槛

- ARM64: 母本逐节目录尚未完整核录
- Verilog高级: 母本逐节目录尚未完整核录
- Verilog讲义: 母本逐节目录尚未完整核录
- CAN笔记: 母本逐节目录尚未完整核录
- CAN实战: 母本逐节目录尚未完整核录
- 电路: 母本逐节目录尚未完整核录
- 运放: 母本逐节目录尚未完整核录
- 仪表: 母本逐节目录尚未完整核录
- DAQ: 母本逐节目录尚未完整核录
- PCB: 母本逐节目录尚未完整核录
- 嵌入式C: 母本逐节目录尚未完整核录
- SJA1000-2000: 母本逐节目录尚未完整核录
- LM3S6965-2014: 母本逐节目录尚未完整核录
- unresolved: ('CAN笔记', 'I 2.3')
- unresolved: ('CAN实战', '1.8')
- unresolved: ('CAN实战', '1.10.1')
- unresolved: ('CAN实战', '1.10.3')
- unresolved: ('CAN实战', '2.1.2')
- unresolved: ('CAN实战', '2.1.3')
- unresolved: ('SJA1000-2000', '6.4.6')
- unresolved: ('SJA1000-2000', '6.4.15')
- unresolved: ('嵌入式C', '7.1.4')
- unresolved: ('DAQ', '采样-基带抗混叠')
- unresolved: ('DAQ', 'FFT-交流性能指标')
- unresolved: ('LM3S6965-2014', '11.4')
- unresolved: ('DAQ', '采样与实时系统')
- unresolved: ('DAQ', '孔径时间与抖动')
- unresolved: ('DAQ', '比较器亚稳态与闪码')
- unresolved: ('嵌入式C', '2.8.2-ch08')
- unresolved: ('LM3S6965-2014', '5.4-ch09')

当前仅追踪已录入单元；未录入来源节不计为已覆盖，更不能被自动排除以获得零缺口。
全书审计要求仍为完整目录录入、逐章抽页、落点审查、实验和连续两轮独立审计。
