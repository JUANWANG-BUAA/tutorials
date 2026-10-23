# 《边缘嵌入式与实时系统》工作状态

slug：`edge`。主线已调整为 **x86 / ARM / RISC-V 架构、汇编、ABI、启动、异常、实时调度与 MMIO/DMA**。
数电、模电、IC 设计不作为独立主线；传感器电气条件仅作为外设接口的边界。

**状态：编写与修订中，未达到整书交付门槛。**

## 已能执行的第 1–14 章全书路径

```bash
cd edge
bash experiments/ch01/run.sh
bash experiments/ch02/run.sh
bash experiments/ch03/run.sh
bash experiments/ch04/run.sh
bash experiments/ch04/run_mutations.sh
bash experiments/ch05/run.sh
bash experiments/ch06/run.sh
bash experiments/ch06/run_oracle.sh
bash experiments/ch06/run_mutations.sh
bash experiments/ch07/run.sh
bash experiments/ch07/run_mutations.sh
bash experiments/ch08/run.sh
bash experiments/ch08/run_mutations.sh
bash experiments/ch09/run.sh
bash experiments/ch09/run_mutations.sh
bash experiments/ch10/run.sh
bash experiments/ch10/run_mutations.sh
bash experiments/ch11/run.sh
bash experiments/ch11/run_mutations.sh
bash experiments/ch12/run.sh
bash experiments/ch12/run_mutations.sh
bash projects/edge-rtos-infer/run_tests.sh
bash projects/edge-daq-monitor/run_tests.sh
mdbook build .
python3 ../tools/check_site_links.py book --site-url https://juanwang-buaa.github.io/tutorials/edge/
```

- 第一章：QEMU Cortex-M3 执行 BASEPRI 原始优先级分级屏蔽、嵌套保护与削弱变异检测。
- 第二章：QEMU Cortex-M3 与 RV32 执行真实 CRT0 重定位固件，包含奇数 27 字节 .data 搬移与 31 字节 .bss 清零，跳过搬移与 BSS 污染变异明确 FAIL。
- 第三章：QEMU virt 执行 144 字节完整现场 RV32 异常框架，验证 M-mode ECALL、异步 MTIP、mepc 不加四及坏 a1/坏 mepc 变异检测；timer 契约测试验证模回绕、时间戳倒退反例与 O(k) 到期。
- 第四章：Cortex-M3 SysTick 抢占、PendSV 切换、PSP 上下文恢复；RV32 512 次协作切换；两项变异测试。
- 第五章：UART IRQ5 字符注入接收；DMA、Cache、SPI、I2C 离散模型。
- 第六章：经典 CAN 标准帧编解码、SJA1000 模型、独立 GF(2) 位流对照、x86 长模式自检执行及错误 CRC 变异。
- 第七章：QEMU Cortex-M3 ADC IRQ17 定时器触发采样 + SMULL 宽乘法；RV32 MULH/MUL 执行；Q15、FIR/IIR、FFT64 与 32 块复数 double DFT 参照；无符号乘法与漏确认变异明确 FAIL。
- 第八章：多级 DAQ 存储管道模型（5 ms Flash 擦除停顿 16 块 vs 4 块丢弃对照、缓存失效模型、容量预算定理）；QEMU Cortex-M3 128 块 Ping-Pong 固件、RV32 SPSC 队列固件；序列颠倒与预算算法变异明确 FAIL。
- 第九章：动态 CMOS 翻转与漏电能耗模型、DVFS 二次方能耗定理与单纯降频能耗增加反例；PLL 唤醒损益平衡时间（682 µs）与 Tickless 空转节能（>90%）；QEMU Cortex-M3 SCB->SCR/SLEEPONEXIT 与时钟门控固件、RV32 机器模式 WFI 定时唤醒固件；非法 SCR 配置与唤醒计数变异明确 FAIL。
- 第十章：功能安全 FTTI 预算模型与多任务窗口看门狗代际监管；非易失 RAM 崩溃快照与 RESC 复位原因自愈分流；QEMU Cortex-M3 硬件看门狗密钥解锁（0x1ACCE551）与 HardFault 栈帧解码（MSP/PSP 识别与 CFSR 诊断）、RV32 ebreak/mtval 故障捕获固件；WDT 写保护与 mcause 颠倒变异明确 FAIL。
- 第十一章：INT8 仿射定点量化数学模型、Q31 重量化乘法与对称舍入、零点偏置离线融合；Tensor Arena 静态内存池与双激活缓冲复用（64B 峰值）；标度因子失准引发隐藏层全饱和分类反转反例；QEMU Cortex-M3 与 RV32 纯整型 2 层振动分类 MLP 前向推理固件；预测颠倒变异明确 FAIL。
- 第十二章：双区 Direct-XIP 物理分区拓扑、NOR Flash 1变0 与扇区擦除特性、寿命倍率定理；代际双页轮换、二阶段原子提交与 2184 组断电注入自愈仿真；OpenSSL P-256 签名验签与单调 Version Floor 防降级测试；QEMU Cortex-M3 与 RV32IM 真实 Bootloader 到应用程序标准六步硬件移交（关中断、清 SysTick、清 NVIC、切换 MSP、重设 VTOR/mtvec）、Mode 0/1/2 自检与看门狗自动回滚固件；缺少提交标记、未落盘试运行与 VTOR 遗漏变异明确 FAIL。
- 第十三章（项目一）：工业级 CAN 节点 + RTOS 实时调度 + 边缘 INT8 故障诊断系统；RMS 调度定理与 RTA 迭代收敛（总负载 29.50%）；8 阶 Q15 FIR 滤波无溢出证明、SPSC 无锁环形队列零拷贝解耦；CAN 0x050 突发最高仲裁特权告警帧与 0x200 周期状态帧；多任务代际 Token 监视器联合打卡；200ms 全链路仿真、正常工况/轴承损伤注入/自愈三阶段验证与分类反转变异明确 FAIL。
- 第十四章（项目二）：多通道高速数据采集、DMA 流式管道与低功耗故障自愈小系统；1 MSPS 高速采样孔径抖动 SNR 退化推导、AFE 运放阻抗匹配；循环双缓冲 DMA 引擎与按地址精准失效（Invalidate by Address）Cache 维护规约；定理 14.4.1 存储队列容量预算定理与 5ms Flash 擦除停顿背压吸收（16 槽位吸收 8 块突发，0 丢块）；WFI 动态待机与 Tickless 钩子（节能 >85%）；窗口看门狗刷新率上下限双向审查与 NOLOAD 崩溃黑匣子自愈流水线；数据块校验和破坏变异明确 FAIL。

源文件在 `firmware/`、`experiments/` 与 `projects/`。
输出在 `.build/` 与 `book/`，证据见 `evidence/` 与 `src/appendix/` 目录。
整书 HTML 已由 `mdbook build .` 完整构建通过，全站 27 个页面、1833 条链接 0 断链。

## 必需工具

- 支持 ARM/RISC-V/x86/AArch64 后端的 LLVM Clang；本轮使用 22.1.8。
- LLD、llvm-objdump、llvm-objcopy。
- QEMU system-arm、system-riscv32、system-x86_64；本轮使用 11.1.2。
- 主机 C11 编译器、pthread、ASan/UBSan。
- Python 3（测试超时与源证据校验工具）。

脚本自动优先使用 Homebrew 的 `llvm@22` / `lld@22` 路径；Linux 使用 PATH。
可用 `EDGE_CC`、`EDGE_LD`、`EDGE_OBJDUMP`、`EDGE_OBJCOPY` 显式覆盖。
macOS 自带 Apple Clang 未必包含 RISC-V 后端，不应据名称猜测支持情况。

## 未完成门槛

- 全书 14 个正文章节与两个综合项目均已建立完整代码实现与限定范围测试，仍未经过两轮独立技术审计。前三章补入了靶机与契约实验，但无实体示波器/板卡数据；第五章真实 DMA/SPI/I2C 驱动路径未完成；第六章完整 FD、控制器中断及实体总线未完成；第七章使用合成 ADC 数据；第八章使用离散 Flash 擦除模型；第九章使用模拟器时钟门控；第十章使用模拟器 WDT 与未定义指令注入；第十一章使用模拟器整型 GEMM 前向推理；第十二章使用模型 Flash 擦写与虚拟移交；第十三与第十四章使用虚拟总线与仿真输入。
- 来源清单库继续保持未全部逐节录入的真实状态，`build_coverage.py` 严格退出 1，不宣称“缺口 0”。
- 母本尚未逐节全覆盖，覆盖台账不得声称缺口 0。
- SUMMARY 表示最终目录；所列后续页面尚未全部存在，因此整书 mdBook 构建当前应失败。

复用仓库 `shared/theme` 与语义盒预处理器，不修改其他书的内容。
不复制母本原图、原代码；页级抽取只在仓库忽略的本地 `.qa/edge/sources/` 保存。
