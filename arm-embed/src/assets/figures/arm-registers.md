<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-registers" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 460" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="arm-registers-title arm-registers-desc">
<title id="arm-registers-title">37 个寄存器的分组：R0–R7 共享，R8–R12 两份，R13/R14 每模式一份</title>
<desc id="arm-registers-desc">左侧列出未分组与分组的寄存器，右侧按七种处理器模式列出各自可见的寄存器集合。</desc>
<defs>
  <linearGradient id="armreg-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <pattern id="armreg-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
  <marker id="armreg-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="460" fill="url(#armreg-bg)"/>
<rect x="0" y="0" width="900" height="460" fill="url(#armreg-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="460" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM · REGISTER BANKS / 02</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-02</text>
<text x="32" y="73" class="pl-title">37 个寄存器：一份、两份、七份</text>
<text x="32" y="96" class="pl-sub">模式决定你看到哪一组物理寄存器；同一编号在不同模式下可能是不同硬件。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<text x="32" y="142" class="pl-mono" style="fill:var(--accent)">左：按分组规则</text>
<rect x="32" y="156" width="250" height="66" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="48" y="180" class="pl-mono" style="fill:var(--accent)">R0 – R7</text>
<text x="48" y="202" class="pl-small">未分组 · 任何模式同一份</text>
<text x="48" y="216" class="pl-note">8 个</text>
<rect x="32" y="234" width="250" height="66" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="48" y="258" class="pl-mono" style="fill:var(--fig-blue)">R8 – R12</text>
<text x="48" y="280" class="pl-small">两份 · FIQ 独享 R8_fiq…R12_fiq</text>
<text x="48" y="294" class="pl-note">10 个</text>
<rect x="32" y="312" width="250" height="66" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="48" y="336" class="pl-mono" style="fill:var(--fig-plum)">R13 / R14</text>
<text x="48" y="358" class="pl-small">七份 · 每模式各一份</text>
<text x="48" y="372" class="pl-note">14 个</text>
<rect x="32" y="390" width="250" height="46" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="48" y="412" class="pl-mono" style="fill:var(--fig-gold)">R15 / CPSR / SPSR×5</text>
<text x="48" y="428" class="pl-note">全局各一份 · 7 个</text>
<text x="330" y="142" class="pl-mono" style="fill:var(--accent)">右：按模式可见</text>
<text x="330" y="164" class="pl-small">usr / sys</text>
<rect x="330" y="172" width="300" height="40" rx="6" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="344" y="197" class="pl-mono">R0–R14 · PC · CPSR</text>
<text x="614" y="197" class="pl-note" text-anchor="end">无 SPSR</text>
<text x="330" y="234" class="pl-small">fiq</text>
<rect x="330" y="242" width="300" height="40" rx="6" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="344" y="267" class="pl-mono">R0–R7 · R8_fiq–R14_fiq</text>
<text x="614" y="267" class="pl-note" text-anchor="end">SPSR_fiq</text>
<text x="330" y="304" class="pl-small">svc / abt / und / irq</text>
<rect x="330" y="312" width="300" height="40" rx="6" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="344" y="337" class="pl-mono">R0–R12 · R13_m · R14_m</text>
<text x="614" y="337" class="pl-note" text-anchor="end">SPSR_m</text>
<rect x="648" y="172" width="220" height="180" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="664" y="196" class="pl-mono" style="fill:var(--fig-red)">m ∈ {svc, abt, und, irq}</text>
<text x="664" y="222" class="pl-small">R13_m = 该模式的栈指针</text>
<text x="664" y="242" class="pl-small">R14_m = 该模式的返回地址</text>
<text x="664" y="262" class="pl-small">SPSR_m = 异常前的 CPSR</text>
<path d="M664 282H852" style="stroke:var(--line)" stroke-opacity=".9"/>
<text x="664" y="306" class="pl-note">切模式 → 换寄存器组</text>
<text x="664" y="326" class="pl-note">切状态 → 不换寄存器</text>
<text x="664" y="344" class="pl-note">（ARM/Thumb 是另一维）</text>
<text x="330" y="386" class="pl-note">账目：8 + 10 + 14 + 1(PC) = 31 通用 · +1 CPSR +5 SPSR = 37</text>
<text x="330" y="410" class="pl-note">FIQ 独享 R8–R12：中断处理不必保存现场，直接用自己的副本</text>
<text x="330" y="432" class="pl-note">R13/R14 每模式一份：每种异常有自己的栈与返回地址，互不踩踏</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>左侧按"分组规则"数个数（8 + 10 + 14 + 7 = 37），右侧按"当前模式"决定你能访问哪一组。同一编号在不同模式下指向不同物理寄存器——这是异常嵌套时 LR 会被覆盖的根源（见 2.7.4）。</figcaption>
</figure>
