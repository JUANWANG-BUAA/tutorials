# CHECK-edge · 本轮验证报告

## 结论

**局部实验和第 1–14 章结构/全书渲染通过；整书不可交付。**
本报告不宣称覆盖缺口 0，也不宣称两轮独立审计完成。
已知问题及逐节状态见 `AUDIT-sections.md`。

## 本轮交付的实质增量

| 项目 | 状态 | 证据 |
|:--|:--|:--|
| 第一章正文 | 1066 行，11 H2，12 条陷阱 | `src/part1/ch01.md` |
| 第二章正文 | 1041 行，11 H2，12 条陷阱 | `src/part1/ch02.md` |
| 第三章正文 | 1042 行，11 H2，12 条陷阱 | `src/part1/ch03.md` |
| 第四章正文 | 1053 行，11 H2，12 条陷阱 | `src/part1/ch04.md` |
| 第五章正文 | 1013 行，11 H2，12 条陷阱 | `src/part2/ch05.md` |
| 第六章正文 | 1173 行，11 H2，12 条陷阱 | `src/part2/ch06.md` |
| 第七章正文 | 1017 行，11 H2，12 条陷阱 | `src/part2/ch07.md` |
| 第八章正文 | 1006 行，11 H2，12 条陷阱 | `src/part2/ch08.md` |
| 第九章正文 | 1018 行，11 H2，12 条陷阱 | `src/part3/ch09.md` |
| 第十章正文 | 1004 行，11 H2，12 条陷阱 | `src/part3/ch10.md` |
| 第十一章正文 | 1017 行，11 H2，12 条陷阱 | `src/part3/ch11.md` |
| 第十二章正文 | 1006 行，11 H2，12 条陷阱 | `src/part3/ch12.md` |
| 第十三章正文 | 1001 行，11 H2，12 条陷阱 | `src/part4/ch13.md` |
| 第十四章正文 | 1002 行，11 H2，12 条陷阱 | `src/part4/ch14.md` |
| Cortex-M3 BASEPRI 屏蔽 | QEMU 实际运行，正向及削弱变异通过 | `experiments/ch01/run_basepri.sh` |
| CRT0 重定位与 BSS 清零 | ARM 与 RV32 目标机实际运行，跳过搬移/BSS污染变异通过 | `firmware/ch02/`、`experiments/ch02/` |
| RV32 完整异常与 ECALL | 144 字节完整现场，QEMU 实际运行，坏 a1/坏 mepc 变异通过 | `firmware/ch03/rv32/`、`experiments/ch03/` |
| 定时器与时间戳契约 | 模回绕、双读时间戳倒退反例、O(k) 到期模型通过 | `experiments/ch03/timer_contract.c` |
| Cortex-M3 抢占切换 | QEMU 实际运行 | `firmware/ch04/arm/` |
| RV32 协作切换 | QEMU 实际运行，512 次以上 | `firmware/ch04/rv32/` |
| x86-64 / AArch64 切换 | 交叉汇编、反汇编，未运行 | `firmware/ch04/*_switch.S` |
| 调度/PIP 状态机 | ASan/UBSan + 不变量断言通过 | `experiments/ch04/rtos_context_sim.c` |
| C11 SPSC | 两线程 200000 包，满空回绕通过 | `experiments/ch04/spsc.c` |
| 切换故障变体 | ARM 坏 R4、RV32 漏 s0 均明确 FAIL | `run_mutations.sh` |
| UART IRQ5 | QEMU 实际接收 0x55、0xA3 | `firmware/ch05/` |
| DMA/Cache/SPI/I2C | 离散模型通过，SPI VCD 可生成 | `experiments/ch05/bus_models.c` |
| CAN 协议与 SJA1000 | 标准经典帧、选定错误规则、寄存器事务模型通过 | `experiments/ch06/` |
| 独立位流对照 | 多项式长除法与 C 完整 120 位一致 | `run_oracle.sh` |
| x86 长模式协议执行 | 实际目标运行，正常退出 33，错 CRC 退出 35 | `firmware/ch06/x86/` |
| ADC IRQ17 与定点 DSP | Cortex-M3 timer 触发采样 + SMULL、RV32 MULH/MUL、FFT64 通过 | `firmware/ch07/`、`experiments/ch07/` |
| DSP 变异与 double DFT | 32 块复数偏差 2.07 LSB；无符号乘法与漏确认变异明确 FAIL | `experiments/ch07/` |
| DAQ 流式管道与缓存一致性 | 5ms 擦除停顿 16 块 vs 4 块对照、缓存失效模型、容量预算定理通过 | `experiments/ch08/test_host.c` |
| DAQ 目标机固件与变异 | Cortex-M3 128 块 Ping-Pong、RV32 队列、序列颠倒/预算变异明确 FAIL | `firmware/ch08/`、`experiments/ch08/` |
| 功耗模型与 DVFS 仿真 | DVFS 节能 >85%、PLL 唤醒损益平衡 (682us)、Tickless 节能 >90% 通过 | `experiments/ch09/test_host.c` |
| 功耗目标机固件与变异 | Cortex-M3 SCB->SCR/SLEEPONEXIT、RV32 WFI、SCR/唤醒阈值变异明确 FAIL | `firmware/ch09/`、`experiments/ch09/` |
| 故障恢复与看门狗仿真 | 窗口监管/早晚违约拦截、FTTI 50ms 预算、NVRAM 崩溃快照校验通过 | `experiments/ch10/test_host.c` |
| 故障恢复目标机固件与变异 | Cortex-M3 WDT 密钥解锁/HardFault 解码、RV32 ebreak/mtval、变异明确 FAIL | `firmware/ch10/`、`experiments/ch10/` |
| 边缘推理与定点量化仿真 | 2层振动分类 MLP、Arena 内存复用 (64B)、标度失准饱和反例通过 | `experiments/ch11/test_host.c` |
| 边缘推理目标机固件与变异 | Cortex-M3/RV32 纯整型 GEMM 前向推理、预测反转变异明确 FAIL | `firmware/ch11/`、`experiments/ch11/` |
| 双区 OTA 掉电注入仿真 | 2184 组断电断点注入全通过、P-256 签名验签与防降级锁通过 | `experiments/ch12/test_host.c`、`signature_test.py` |
| 双区 OTA 目标机固件与变异 | Cortex-M3/RV32 真实 Bootloader+应用硬件移交、Mode 0/1/2 自愈、三项变异明确 FAIL | `firmware/ch12/`、`experiments/ch12/` |
| 项目一：工业 CAN 节点 + RTOS + INT8 诊断 | 200ms 全链路仿真、正常/损伤注入/自愈三阶段验证、ASan/UBSan、变异拦截通过 | `projects/edge-rtos-infer/` |
| 项目二：高速 DAQ + 零拷贝 DMA + 自愈系统 | 稳态 64 块流转、5ms 擦除背压吸收、WFI 深度休眠、ASan/UBSan、变异拦截通过 | `projects/edge-daq-monitor/` |
| 来源台账 | 102 条记录；13 个来源库存未完整；合计 30 个未关闭门槛 | `COVERAGE.md`、JSON 台账 |

所有寄存器哨兵依任务编号设置不同值，避免同值导致漏保存假通过。
第四章整数上下文不声称支持 FPU；RV32 协作不声称支持异步陷入。
第五章的 DMA/Cache 模型不声称执行了实体控制器。
第六章 x86 实际执行协议自检，不声称执行 SJA1000 或完整 CAN FD。

## 可复现命令

```bash
cd edge
python3 tools/check_chapter.py part1/ch04.md
python3 tools/check_chapter.py part2/ch05.md
python3 tools/check_chapter.py part2/ch06.md
python3 tools/check_chapter.py part2/ch07.md
python3 tools/check_chapter.py part2/ch08.md
python3 tools/check_chapter.py part3/ch09.md
python3 tools/check_chapter.py part3/ch10.md
python3 tools/check_chapter.py part3/ch11.md
python3 tools/check_chapter.py part3/ch12.md
python3 -m unittest discover -s tools -p 'test_*.py' -v
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
bash tools/preview_verified.sh
```

本轮使用 Darwin arm64、LLVM Clang 22.1.8、LLD 22.1.8、QEMU 11.1.2。
ARM/RV32 产物从实际 ELF 反汇编，不用手写“预期反汇编”冒充输出。
原始输出路径见 `evidence/ch04-validation.md`、`evidence/ch05-source-notes.md`、`evidence/ch06-validation.md`。

## 结构与局部渲染

- 全书 14 个章节机械检查均 0 问题，行数全部位于 1000–1500 行之间。机械检查不等于技术正确性审计。
- 全书 14 章 mdBook 构建与整站链接检查通过，复用同一 shared/theme 与语义盒工具。
- 调用仓库 `tools/check_site_links.py`：27 HTML 页面、1833 条链接、0 断链（整站构建）。
- 图显式 id 唯一；检查器已支持带 id 的 pre.layout。
- 检查器回归包括空目录拒绝、缺章拒绝、围栏闭合、图识别与陷阱计数。
- 两次测试执行不计为两轮独立审计。

## 失败门禁（符合当前未完成状态）

```bash
python3 tools/check_book.py
# exit 0，全书 23 个目录页面全部存在，14 个正文章节全部合规

python3 tools/build_coverage.py
# exit 1，102 recorded / 30 unresolved gates (母本目录未完整核录，严格失败，绝不伪造零缺口)

mdbook build .
# exit 0，整书构建成功，输出至 book/ 目录
```

`create-missing=false` 防止 mdBook 自动创建空章。
没有为通过检查而写空白正文、伪固件或占位项目。
覆盖生成器已撤掉“另一个页面同名锚点也算覆盖”的兜底。
来源未完整逐节录入时，程序明确失败，不输出伪零缺口。

## 前三章修订状态

本轮纠正/撤销了 MPU 结构偏移、PMSAv7/v8 混用、PMP NAPOT 编码、C11 队列协议与懒浮点压栈解释中的部分错误。
仍有未关闭 P1，尤其是无依据的延迟常数、未完整保存的异常入口与过度概括。
前三章不因 1000 行或结构检查通过而自动验收。
旧 ch01–03 主机程序只证明其实际执行的模型；不计为实体板实时性证明。

## 未完成的最终门槛

1. 所有母本逐章抽页与完整逐节目录录入。
2. 第 1–3 章技术错误全部修正、补入真实靶机实验。
3. 全书 14 个章节与两个综合项目的两轮独立技术审计（当前 0 轮执行）。
4. 第五章 DMA/SPI/I2C、第六章真实 CAN 控制器中断与完整 FD、第七章实体 ADC/外部传感器、第八章实体 Flash 块擦除、第九章实体电流采样、第十章实体高压脉冲注入、第十一章专用 NPU 加速硬件、第十二章实体 Flash 掉电注入与无线空口、第十三章实体工业机器人关节与电机台架、第十四章实体特高压变电站暂态波形测试。
5. 完整 mdBook 构建与全部跨章链接。
6. 实体开发板时延、功耗、总线采样证据或明确限定的仿真替代范围。
7. 连续两轮独立技术审计均 0 P0/P1。
