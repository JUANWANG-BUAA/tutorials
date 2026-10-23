# 第六章执行证据与限制

## 本轮实际环境

Darwin arm64；目标编译器 LLVM Clang 22.1.8、LLD 22.1.8；QEMU 11.1.2。
宿主编译器为本机 `cc`，正向模型启用 ASan/UBSan。
版本保存在 `.build/ch06/versions.txt`；本轮合并日志在本地忽略目录 `.qa/edge/ch06-validation.txt`。

```bash
cd edge
bash experiments/ch06/run.sh
bash experiments/ch06/run_oracle.sh
bash experiments/ch06/run_mutations.sh
python3 tools/check_chapter.py part2/ch06.md
bash tools/preview_verified.sh
```

## 正向模型

- CRC-15/CAN 检查串：`123456789 -> 0x059e`。
- 一千条固定种子的经典标准帧（包含远程帧）编码/解码通过。
- 固定帧动态区域每个线上位逐一翻转后均被拒绝；CRC delimiter 破坏产生 FORM；无 ACK 仍能作为接收侧字段解码并返回 ack=false。
- 同标准 ID 的 data/RTR 和同前缀标准 remote/extended 仲裁分支通过。
- PeliCAN 标准及扩展字节记录打包/解包通过；未实现扩展线上帧编码，不冒充完整支持。
- FD 只测试十六项 DLC 表以及非法索引；无 FD 编解码器。
- 选定计数规则测试 127/128/255/256、REC-only 不关闭、被动 ACK 例外、恢复请求与 128×11 位条件。
- SJA1000 寄存器模型测试配置态、进入与退出复位超时、运行态 BTR 写拒绝、TX busy、Bus-Off 同时带 RM、RX 先复制后释放、坏 DLC 排空、远程帧不读数据，以及 IR 一次快照。
- 初始化 IER 保持 0，由测试夹具在配置完成后显式开放建模事件；不暗示已有真实 ISR。

模型输出的时序数字：

```text
MODEL timing: SJA 16MHz BTR0=0x00 BTR1=0x1c -> 500000 bit/s, sample=87.5%
MODEL frame: 120 bits including stuffing/intermission, at 500k -> 240 us
MODEL deadline: nonpreemptive wait=810us + frame=270us -> 1080us, misses 1000us
```

最后一行是固定占用的抽象调度模型。对实体系统，超过截止期的保守响应上界本身不能证明实际报文必然违约。
VCD 是编码出的逻辑总线，2000 ns/bit，不含物理传播、采样或波形测量。

## 独立算法对照

`run_oracle.sh` 以 GF(2) 多项式长除法计算 CRC，再独立排列字段和位填充。
与 C 反馈移位实现的固定完整位串比较，120 位逐位相同。
结果写入 `.build/ch06/reference-wire.txt`。
“独立算法”不是独立审计员；该脚本仍是作者工作成果。

## 实际 x86 指令执行

- QEMU Multiboot 加载 ELF32，不是 BIOS 复位启动。
- 启动代码执行 PML4/PDPT/2MiB 页表设置、CR4.PAE、EFER.LME、CR0.PG 与远跳转。
- 进入长模式后清 BSS，调用 freestanding x86-64 C 核心。
- C 检查 PG、PAE、LMA，并调用与宿主同源的 `can_core_selftest`。
- 调试输出：`X86 CAN CORE PASS: long mode, CRC/stuff/arbitration/confinement tests`。
- isa-debug-exit 的成功宿主退出值必须为 33；日志另存 `.build/ch06/x86-run.txt`。
- 不把进程退出、超时或无输出当成功；目标运行超时直接失败。

主镜像为 `.build/ch06/can64.elf`，加载器为 `.build/ch06/boot32.elf`。
实际反汇编在 `.build/ch06/x86-disassembly.txt`。
本章实际 x86 运行不补足第四章 x86 协作切换的动态验证缺口。

## 故障变异

在忽略构建目录副本中把多项式 `0x4599` 改成 `0x4598`：

1. 宿主核心检查串失败，退出 1，并包含 `CAN CORE FAIL`。
2. 错误核心重新链接到 x86 镜像，实际输出 `X86 CAN CORE FAIL`，退出 35。

失败日志在 `.build/ch06/mutations/`。
负向镜像不覆盖正常镜像；超时不计为成功检测到错误。

另有一次本轮真实缺陷记录：初版扩展仲裁投影把数值 1 按两位写出，得到 SRR/IDE=01。
标准远程与扩展的边界自检失败。修为数值 3 后回归通过。
这条错误及定位过程写入正文，不把没有发生的事故伪装成测量案例。

## 未覆盖

- Cortex-M3、RV32、AArch64 的核心及驱动仅编译对象文件，未链接运行。
- 未在任何目标上实际访问 SJA1000 MMIO、处理 CAN IRQ 或验证外部总线时序。
- 模型没有多帧 FIFO 字节容量、捕获寄存器完整锁存、全部错误界定例外和命令最小间隔。
- 未实现完整 ISO CAN FD 线上格式、M_CAN 驱动、双速率和延迟补偿执行。
- 无实体总线、错误帧、Bus-Off 恢复、能耗或 WCET 证据。
- 未进行两轮独立逐节审计。

## 结构与预览

本章 1173 行、11 H2、12 条陷阱，章节机械检查 0 问题。
第 4–6 章局部预览构建通过：7 个 HTML 页面、412 条链接、0 断链。
整书仍因 `part2/ch07.md` 不存在而构建失败；不生成空章掩盖缺失。
来源台账当前 55 条记录、20 个未关闭门槛，不声称缺口为零。
