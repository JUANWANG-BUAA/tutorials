# 第五章母本核读摘记（原创归纳）

## 页级抽样

- ARM64 PDF 311–312 §18.2.1：DMA 缓冲区准备和设备启动之间存在排序要求。正文 §5.2/5.3 将顺序、Cache 维护、所有权和设备完成拆开，不把一个屏障当成全部协议。
- ARM64 PDF 312–314 §18.2.2–18.2.4：DMB 的访问顺序与 DSB 的完成条件不同。正文 §5.3 不将 DMB 等价于“全部写缓冲已经刷入物理 SRAM”，也不把 DSB 当隐式全 Cache clean。
- ARM64 PDF 315 §18.2.5：内外共享域与方向参数应按观察者选择。正文 §5.3 说明 DMA 可能不位于 CPU 的 inner-shareable 域，不能盲用 ish。
- 嵌入式 C PDF 112–115 §2.8.1–2.8.3：物理地址、总线与统一/独立编址。正文 §5.1 补充现代 x86 同时广泛采用 MMIO，不将母本的简化分法误解为 x86 仅支持 port I/O。
- 嵌入式 C PDF 421–424 §6.7.1–6.7.2：aligned 与结构体填充。正文 §5.1、5.7 分开说明编译器对齐、最终链接地址与 DMA/Cache 边界。
- 嵌入式 C PDF 427–428 §6.7.4–6.7.5：packed 的紧凑布局。正文 §5.1 明确纠偏：MMIO 空洞可能是硬件保留区，不应压掉；字节或非对齐访问可能不合法。母本给出的某次 16B 对齐观察不能当作现代工具链普遍上限。

以上抽页文本只保存在本地忽略目录 `.qa/edge/sources/`。所有表格与代码为重新组织的原创内容。

## 仍待核录

Verilog 两本尚未逐章抽样，未捏造 UART/SPI/I2C 小节页码。
LM3S、STM32F407 参考手册尚未固定完整版本逐项复核；本轮只有 QEMU UART 指令执行与离散模型证据。
因此这些条目保持未完成，不把当前正文锚点当作完整来源覆盖。

## 运行

```bash
cd edge
bash experiments/ch05/run.sh
```

本轮输出：

```text
MODEL PASS DMA ownership: overwrite blocked, stale token rejected
MODEL PASS cache: barrier != clean; shared-line writeback destroys DMA byte
MODEL PASS UART: 3Mbaud 8N1, 400us masked, 120 arrived/16 stored/104 lost
MODEL PASS SPI: four CPOL/CPHA modes, 0x96 loopback, VCD generated
MODEL PASS I2C: 0x60 loses at bit6; stuck-SDA recovery exits after 9 clocks
UART READY
UART PASS: IRQ5 received 0x55 and 0xa3
```

MODEL 行不代表实体 DMA、非一致性 Cache 或引脚仿真。
UART 行对应实际的 QEMU Cortex-M3 IRQ5 收包，未声称波特率或引脚电压实测。
