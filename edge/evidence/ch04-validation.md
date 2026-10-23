# 第四章执行证据

## 环境与命令

主机 `Darwin arm64`；LLVM Clang 22.1.8；LLD 22.1.8；QEMU 11.1.2。

```bash
cd edge
bash experiments/ch04/run.sh
bash experiments/ch04/run_mutations.sh
```

## 本轮实际输出

```text
PASS same-priority FIFO: removing one task retains its peer
PASS priority inheritance: blocked waiter, owner boost, direct handover
PASS transitive donation, cycle rejection, remaining-lock donation
MODEL deadline: no-PIP finish=13ms MISS; PIP finish=5ms MEET (not hardware timing)
PASS scheduler invariants (single-core serialized teaching model)
PASS C11 SPSC: 200000 ordered packets, full/empty/wrap tests
ARM PASS: integer registers, PSP, SysTick preemption
RV32 PASS: cooperative ABI, 12 saved registers, 512 switches
PASS mutation detected: arm, explicit FAIL exit=1
PASS mutation detected: rv32, explicit FAIL exit=1
```

## 可复核产物

`.build/ch04/arm.elf` / `rv32.elf`：实际启动的固件。
`arm-disassembly.txt` / `rv32-disassembly.txt`：从 ELF 反汇编。
`x86-disassembly.txt` / `a64-disassembly.txt`：交叉汇编产物，仅静态检查。
`arm-run.txt` / `rv32-run.txt`：模拟器原始输出。
`mutations/*-run.txt`：故障变体明确 FAIL。
`versions.txt`：工具版本。

## 证据边界

没有连接实体开发板或示波器。没有测定硬件中断延迟、总线波形、电流或 WCET。
主机测试中的 13ms 与 5ms 是人工设定调度模型的算术结果。
寄存器哨兵测试能检测已覆盖的保存/恢复错误，但不是处理器全部状态的全称证明。
ARM 固件无 FPU；RV32 固件不开放中断；x86/AArch64 尚未运行。
