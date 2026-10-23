# 实验环境与验证级别

<div class="chapter-index">
<div><span class="ci-label">本页回答</span><p>哪些工具被本轮实际使用？哪些实验是真正的 ISA 执行，哪些只是状态模型？如何运行第四至六章而不把未完成整书冒充已构建？</p></div>
</div>

## 本轮工具

| 工具 | 实际环境 | 用途 |
|:--|:--|:--|
| 主机 | Darwin arm64 | 主机 C11/pthread 与脚本 |
| LLVM Clang | 22.1.8 | ARM、RV32、AArch64、x86 交叉编译 |
| LLD | 22.1.8 | 裸机 ELF 链接 |
| llvm-objdump / llvm-objcopy | LLVM 22 系列 | 实际反汇编与裸二进制提取 |
| QEMU | 11.1.2 | Cortex-M3、RV32、x86 system 仿真 |
| Python 3 | 本机 Python | 子进程超时、台账与结构检查 |

工具具体版本由脚本写入 `.build/ch04/versions.txt` 和 `.build/ch06/versions.txt`。
未固定为本轮版本的环境应保留自己的版本输出。

## 可执行命令

在书根目录执行：

```bash
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
python3 tools/check_chapter.py part1/ch01.md
python3 tools/check_chapter.py part1/ch02.md
python3 tools/check_chapter.py part1/ch03.md
python3 tools/check_chapter.py part1/ch04.md
python3 tools/check_chapter.py part2/ch05.md
python3 tools/check_chapter.py part2/ch06.md
python3 tools/check_chapter.py part2/ch07.md
python3 tools/check_chapter.py part2/ch08.md
python3 tools/check_chapter.py part3/ch09.md
python3 tools/check_chapter.py part3/ch10.md
python3 tools/check_chapter.py part3/ch11.md
python3 tools/check_chapter.py part3/ch12.md
python3 tools/check_chapter.py part4/ch13.md
python3 tools/check_chapter.py part4/ch14.md
```

实验脚本有真实断言与退出码，不会在依赖缺失时输出成功。
QEMU 子进程有宿主超时，以免缺陷固件永久挂住测试。

## 编译器选择

Apple Clang 虽支持 ARM，并不一定含 RISC-V 后端。
macOS 脚本优先寻找 `/opt/homebrew/opt/llvm@22/bin/clang` 和对应 LLD。
其他平台从 PATH 查找，或通过以下环境变量指定：

```bash
export EDGE_CC=/path/to/clang
export EDGE_LD=/path/to/ld.lld
export EDGE_OBJDUMP=/path/to/llvm-objdump
export EDGE_OBJCOPY=/path/to/llvm-objcopy
```

这里是路径配置语法示例，应填入实际安装路径，不是可直接执行的默认安装方案。
Linux 可安装发行版的 clang、lld、llvm、qemu-system-arm、qemu-system-misc、qemu-system-x86。
版本差异导致的行为变化需要重新核验，不自动套用本轮输出。

## 验证级别

| 路径 | 级别 | 不覆盖 |
|:--|:--|:--|
| ch01 ARM | 实际 Thumb 指令、BASEPRI 优先级屏蔽与嵌套测试 | 实体 Flash 等待与外部中断时延 |
| ch02 ARM/RV32 | 实际 CRT0 LMA->VMA 重定位、奇数尾部拷贝、BSS 清零 | 外部 XIP Flash 物理时序 |
| ch03 RV32 | 实际 144 字节完整现场异常、ECALL 与异步 MTIP 测试 | F/V 扩展、不可信 U-mode 用户栈 |
| ch04 ARM | 实际 Thumb 指令、SysTick/NVIC/PendSV 模型 | 实体 Flash/总线时序、FPU |
| ch04 RV32 | 实际 RV32 指令、独立任务栈 | 中断、PMP、多核 |
| ch04 x86/A64 | 汇编目标文件与反汇编 | 动态运行 |
| ch05 UART | 实际 Cortex-M3 MMIO、IRQ5、字符注入 | 物理引脚采样、DMA |
| ch05 其他接口 | 离散状态模型与 VCD 生成 | 芯片总线仲裁、线路噪声 |
| ch06 CAN | 经典协议与 SJA1000 寄存器模型、独立位流对照 | 实体控制器、完整 ISO FD |
| ch06 x86 | 实际保护模式到长模式、协议核心指令执行 | CAN MMIO/IRQ、第四章协作切换 |
| ch06 ARM/RV32/A64 | 核心与驱动对象交叉编译 | 这些对象的动态执行 |
| ch07 ARM/RV32 | 实际 SMULL、MULH/MUL 目标执行；ARM 定时器触发 ADC IRQ17 | 实体模拟电压输入、外部传感器 |
| ch07 x86/A64 | 宽乘法汇编编译与反汇编 | 动态运行 |
| ch07 信号处理 | Q15、FIR/IIR、FFT64 与 32 块复数 double DFT 参照 | 任意点数 FFT、硬件浮点性能 |
| ch08 DAQ 管道 | 5ms 擦除停顿 16 块 vs 4 块对照、非一致性缓存模型、容量预算定理 | 物理 Flash 坏块与磨损寿命 |
| ch08 ARM/RV32 | 实际 Ping-Pong DMA 缓冲区、SPSC 块队列、FENCE 内存序 | 外部总线仲裁物理波形 |
| ch08 x86/A64 | 非时间性流式存储 (movnti/sfence 与 stp/dsb st) 编译与反汇编 | 动态运行 |
| ch09 功耗模型 | 动态/漏电模型、DVFS 二次方能耗、PLL 唤醒损益平衡、Tickless 仿真 | 真实安捷伦直流电流分析仪实测 |
| ch09 ARM/RV32 | 实际 SCB->SCR/SLEEPONEXIT、时钟门控、RV32 WFI 定时器唤醒固件 | 物理芯片引脚漏电流 |
| ch09 x86/A64 | C-state hlt/sti 与 WFI/WFE 汇编编译与反汇编 | 动态运行 |
| ch10 故障恢复 | 窗口看门狗代际监管、FTTI 50ms 预算、NVRAM 崩溃快照校验 | 物理高压脉冲注入 |
| ch10 ARM/RV32 | 实际 WDT 密钥解锁、HardFault 栈帧解码（MSP/PSP）、RV32 ebreak/mtval | 物理主晶振断路停振 |
| ch10 x86/A64 | #PF CR2 锁存与 ESR_EL1/FAR_EL1 故障诊断汇编编译反汇编 | 动态运行 |
| ch11 定点量化 | INT8 仿射量化、Q31 重量化缩放、Arena 双缓冲复用、标度失准反例 | 专用硬件 NPU 硅片面积与功耗 |
| ch11 ARM/RV32 | 实际 2层振动分类 MLP 前向推理、预测反转变异拦截 | 物理机械振动试验台 |
| ch11 x86/A64 | 4字节打包标量点积与 AArch64 NEON 成对点积汇编编译反汇编 | 动态运行 |
| ch12 双区 OTA | Direct-XIP、二阶段原子提交、2184 组断电注入自愈、P-256 签名与防降级锁 | 物理高压断电器与产线烧录 |
| ch12 ARM/RV32 | 实际 Bootloader 到 App 硬件移交、Mode 0/1/2 自愈、三项变异拦截 | 物理无线空口射频传输 |
| ch13 项目一 | 200ms 全链路仿真、正常/损伤注入/自愈三阶段测试、ASan/UBSan、变异拦截 | 物理机械臂协作关节与伺服电机 |
| ch14 项目二 | 稳态 64 块流转、5ms 擦除背压吸收、WFI 深度休眠、ASan/UBSan、变异拦截 | 物理特高压变电站与超高频传感器 |

SocketCAN vcan 可以测试软件报文通路，但不会复现物理位仲裁、终端电阻或错误帧电气波形。
本书 CAN 章不把 vcan 或协议模型当作硬件保真测量替身。

## 整书门禁

```bash
python3 tools/check_book.py --verbose
python3 tools/build_coverage.py
mdbook build .
python3 ../tools/check_site_links.py book --site-url https://juanwang-buaa.github.io/tutorials/edge/
```

当前全书正文、代码实验与附录已全部编写就绪。
`check_book.py` 报告 0 错误（23 页面全部存在，14 正文章节全部合规）；`mdbook build .` 完整构建通过；`check_site_links.py` 验证全站 1833 条链接 0 断链。
`build_coverage.py` 因母本逐节目录尚未完整核录而严格返回 exit 1，拒绝伪造“零缺口”。
连续两轮独立技术审计未完成前，不输出“整书可交付”。
