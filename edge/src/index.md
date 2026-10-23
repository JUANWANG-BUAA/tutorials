# 边缘嵌入式与实时系统

<div class="chapter-index">
<div><span class="ci-label">主线</span><p>x86-64、ARM Cortex-M/AArch64、RISC-V 的架构、汇编、ABI、启动、异常和实时调度。通过 MMIO、DMA 与总线把处理器的指令合同连接到设备。</p></div>
<div><span class="ci-label">状态</span><p>编写与修订中。当前全书全部十四章（前三篇理论章节与第四篇两大实战项目）正文与实验套件已全部就绪；前三章技术漏洞已修复并补齐靶机固件与变异；整书 mdBook 构建通过。全书正待开展两轮独立技术审计，不能将构建通过等同于审计闭环。</p></div>
</div>

## 阅读路线

| 篇 | 主题 | 当前范围 |
|:--|:--|:--|
| 1 | 架构、内存映射、启动、中断、RTOS | 1–4 章正文与 QEMU/变异测试就绪，无实体时延数据 |
| 2 | DMA、总线、CAN、ADC 与流式管道 | 5–8 章正文与实验就绪；第 2 篇核心章节全部闭合 |
| 3 | 功耗管理、安全容错、量化推理、OTA | 9–12 章功耗、安全容错、边缘量化推理与双区 OTA 全部就绪；第 3 篇闭合 |
| 4 | CAN/传感器实时节点、采集与故障自愈系统 | 第 13 章项目一与第 14 章项目二全部就绪；全书正文闭合 |

## 已有的可执行路径

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
```

- Cortex-M3：BASEPRI 屏蔽、奇数 CRT0 重定位与清零、SysTick 抢占、PendSV 切换、UART IRQ5 接收、ADC IRQ17 触发与 SMULL 宽乘法。
- RV32：CRT0 重定位与 BSS 清零、144 字节完整现场异常/ECALL/MTIP、512 次协作切换、MULH/MUL 宽乘法。
- x86-64：保护模式到长模式切换、协议核心执行；SysV 切换与宽乘法交叉汇编反汇编。
- AArch64：协作切换与 SMULL 宽乘法交叉汇编反汇编，目前未动态运行。
- DMA/Cache/SPI/I2C/CAN：所有权代际、共享行破坏、SPI 四模式、I2C 仲裁、CAN 标准帧/错误状态机/独立位流对照。
- 定点信号处理：Q15 标度、不对称 FIR、一阶 IIR、FFT64 逐级除二与 32 块复数 double DFT 参照。
- 高速 DAQ 管道：Ping-Pong 缓冲区、SPSC 无锁块队列、5 ms Flash 擦除停顿丢块分析、非一致性缓存模型、容量预算定理。
- 芯片功耗管理：CMOS 动态/漏电模型、DVFS 二次方能耗、PLL 唤醒损益平衡、Tickless 节电、Cortex-M3 SLEEPONEXIT 与 RV32 WFI。
- 功能安全与容错自愈：FTTI 50ms 预算定理、多任务窗口看门狗代际监管、ARM Cortex-M HardFault 栈帧解码（MSP/PSP）、RV32 mcause/mtval、非易失 RAM 崩溃转储与 RESC 复位自愈。
- 边缘张量推理：INT8 对称/非对称量化、零点偏置离线折叠、Q31 定点重量化对称舍入位移、Tensor Arena 双激活缓冲复用、Cortex-M3/RV32 振动异常分类 MLP 推理固件。
- 固件空中升级 (OTA)：双区 Direct-XIP 物理拓扑、NOR Flash 1变0 与扇区擦除寿命定理、代际双页轮换二阶段提交、2184 组断电自愈测试、P-256 签名与防降级锁、Cortex-M3/RV32 六步硬件移交合同与看门狗自动回滚固件。
- 综合项目一（工业 CAN 节点 + RTOS + 边缘 INT8 故障诊断）：RMS 调度与 RTA 迭代收敛（负载 29.50%）、8 阶 Q15 FIR 滤波、SPSC 无锁环形队列零拷贝解耦、CAN 0x050 突发最高仲裁特权告警帧、多任务 Token 监视器联合打卡、200ms 全链路仿真与分类反转变异拦截。
- 综合项目二（多通道高速采集 + DMA 流式管道 + 低功耗自愈）：1 MSPS 采样抖动 SNR 退化推导、双缓冲 DMA 循环引擎、按地址强制失效（Invalidate by Address）Cache 规约、5ms Flash 擦除背压容量预算（16 槽位吸收 8 块突发，0 丢块）、WFI 动态待机（节能 >85%）、窗口看门狗刷新率审查与 NOLOAD 崩溃黑匣子自愈流水线。

## 不走偏的边界

本书不把嵌入式限制为调用单片机 SDK。
也不把课程扩展为数电、模电、IC 制造或版图设计。
传感器电气与 PCB 仅保留影响固件时序、供电、数据完整性的接口边界。
Linux 内核与驱动模型、机器人运动学不重写。

## 证据规则

模型推导、模拟器运行和实体测量分别标记。
没有连接实体开发板时，不提供虚构的示波器延迟、功耗曲线或零抖动结论。
母本逐节台账尚未闭合，不声称缺口 0 或两轮独立审计通过。
完整进度见仓库本书根目录 README、COVERAGE、AUDIT-sections 与 CHECK-edge。
