<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-cpsr" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="arm-cpsr-title arm-cpsr-desc">
<title id="arm-cpsr-title">CPSR 位布局：NZCV 标志位与 I/F/T/M 控制位</title>
<desc id="arm-cpsr-desc">32 位 CPSR 分成条件代码标志、保留位与控制位三段，控制位含中断禁止位、状态位与模式位。</desc>
<defs>
  <linearGradient id="armcpsr-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <pattern id="armcpsr-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
</defs>
<rect x="0" y="0" width="900" height="420" fill="url(#armcpsr-bg)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#armcpsr-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="420" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM · CPSR LAYOUT / 02</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-03</text>
<text x="32" y="73" class="pl-title">CPSR：上半是结果，下半是控制</text>
<text x="32" y="96" class="pl-sub">标志位由运算写，控制位由异常与特权软件写。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="140" width="180" height="62" rx="8" fill="var(--paper)" stroke="var(--fig-blue)"/>
<text x="122" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--fig-blue)">31 30 29 28</text>
<text x="122" y="190" class="pl-mono" text-anchor="middle" style="fill:var(--fig-blue)">N  Z  C  V</text>
<rect x="222" y="140" width="396" height="62" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="420" y="166" class="pl-mono" text-anchor="middle">27 … 8</text>
<text x="420" y="190" class="pl-note" text-anchor="middle">保留 · 不要改写（改时读—改—写）</text>
<rect x="628" y="140" width="64" height="62" rx="8" fill="var(--paper)" stroke="var(--fig-red)"/>
<text x="660" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--fig-red)">7</text>
<text x="660" y="190" class="pl-mono" text-anchor="middle" style="fill:var(--fig-red)">I</text>
<rect x="700" y="140" width="52" height="62" rx="8" fill="var(--paper)" stroke="var(--fig-gold)"/>
<text x="726" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--fig-gold)">6</text>
<text x="726" y="190" class="pl-mono" text-anchor="middle" style="fill:var(--fig-gold)">F</text>
<rect x="760" y="140" width="48" height="62" rx="8" fill="var(--paper)" stroke="var(--fig-plum)"/>
<text x="784" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--fig-plum)">5</text>
<text x="784" y="190" class="pl-mono" text-anchor="middle" style="fill:var(--fig-plum)">T</text>
<rect x="816" y="140" width="52" height="62" rx="8" fill="var(--paper)" stroke="var(--atlas-cyan, var(--fig-blue))"/>
<text x="842" y="166" class="pl-mono" text-anchor="middle">4:0</text>
<text x="842" y="190" class="pl-mono" text-anchor="middle">M</text>
<text x="32" y="236" class="pl-mono" style="fill:var(--fig-blue)">标志位 NZCV — 运算的结果</text>
<text x="32" y="258" class="pl-small">N 结果为负（补码最高位 1）</text>
<text x="32" y="278" class="pl-small">Z 结果为 0</text>
<text x="32" y="298" class="pl-small">C 加法进位 / 减法无借位 / 移出位</text>
<text x="32" y="318" class="pl-small">V 有符号溢出</text>
<text x="420" y="236" class="pl-mono" style="fill:var(--fig-red)">控制位 — 异常时硬件改，平时仅特权软件可改</text>
<text x="420" y="258" class="pl-small">I = 1 禁止 IRQ　　F = 1 禁止 FIQ</text>
<text x="420" y="278" class="pl-small">T = 1 Thumb / 0 ARM（禁止用 MSR 直接改）</text>
<text x="420" y="298" class="pl-small">M[4:0] 模式编码：usr fiq irq svc abt und sys</text>
<rect x="32" y="336" width="836" height="62" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="48" y="360" class="pl-mono" style="fill:var(--accent)">异常进入时：</text>
<text x="160" y="360" class="pl-small">CPSR → SPSR_xxx（备份） · 模式位改写 · 按类型置 I/F · 清 T（异常总在 ARM 状态处理）</text>
<text x="48" y="384" class="pl-mono" style="fill:var(--accent)">异常退出时：</text>
<text x="160" y="384" class="pl-small">SPSR → CPSR（恢复） · 模式、I/F、T 一并复原</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>31–28 是运算留下的 NZCV（第三章条件执行就读它），27–8 是保留区（写时务必读—改—写），7–0 是控制区——异常时由硬件改写，平时只有特权模式能碰。三段各有各的写入者，是本章最常考的分界。</figcaption>
</figure>
