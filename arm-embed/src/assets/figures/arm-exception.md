<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-exception" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="armexc-title armexc-desc">
<title id="armexc-title">异常响应：硬件四步进入，软件两步退出</title>
<desc id="armexc-desc">异常发生到硬件四步动作、进入中断向量、执行处理程序、最后软件恢复返回的完整流程。</desc>
<defs>
  <linearGradient id="armexc-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <pattern id="armexc-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
  <marker id="armexc-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="armexc-arrow-r" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--fig-red)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="430" fill="url(#armexc-bg)"/>
<rect x="0" y="0" width="900" height="430" fill="url(#armexc-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="430" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM · EXCEPTION FLOW / 02</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-04</text>
<text x="32" y="73" class="pl-title">一次 IRQ 的完整往返</text>
<text x="32" y="96" class="pl-sub">硬件四步进入、软件两步退出，偏移 4 还是 8 取决于"继续"还是"重试"。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="140" width="150" height="72" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="107" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">① 用户程序</text>
<text x="107" y="188" class="pl-small" text-anchor="middle">sys 模式 · 允许 IRQ</text>
<text x="107" y="204" class="pl-note" text-anchor="middle">PC → 下一条指令</text>
<path d="M190 176H236" style="stroke:var(--fig-red)" stroke-width="1.6" marker-end="url(#armexc-arrow-r)"/>
<text x="213" y="166" class="pl-note" text-anchor="middle" style="fill:var(--fig-red)">nIRQ</text>
<rect x="244" y="140" width="212" height="86" rx="8" fill="var(--paper)" stroke="var(--fig-red)"/>
<text x="350" y="162" class="pl-mono" text-anchor="middle" style="fill:var(--fig-red)">② 硬件四步</text>
<text x="350" y="182" class="pl-small" text-anchor="middle">LR_irq ← 返回地址(+4)</text>
<text x="350" y="200" class="pl-small" text-anchor="middle">CPSR → SPSR_irq</text>
<text x="350" y="218" class="pl-note" text-anchor="middle">M←irq · I←1 · T←0 · PC←0x18</text>
<path d="M464 176H510" style="stroke:var(--fig-red)" stroke-width="1.6" marker-end="url(#armexc-arrow-r)"/>
<rect x="518" y="140" width="166" height="72" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="601" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">③ 向量 0x18</text>
<text x="601" y="188" class="pl-small" text-anchor="middle">ISR 开始</text>
<text x="601" y="204" class="pl-note" text-anchor="middle">（IRQ 模式）</text>
<path d="M692 176H738" style="stroke:var(--accent)" stroke-width="1.6" marker-end="url(#armexc-arrow)"/>
<rect x="746" y="140" width="122" height="72" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="807" y="166" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">④ 处理</text>
<text x="807" y="188" class="pl-small" text-anchor="middle">干活</text>
<text x="807" y="204" class="pl-note" text-anchor="middle">可能被抢占</text>
<rect x="32" y="238" width="836" height="74" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="48" y="262" class="pl-mono" style="fill:var(--accent)">标准 ISR 骨架</text>
<text x="48" y="286" class="pl-mono">SUB  LR, LR, #4</text>
<text x="330" y="286" class="pl-mono">STMFD SP!, {R0-R3, LR}</text>
<text x="660" y="286" class="pl-mono">… 处理 …</text>
<text x="48" y="304" class="pl-mono" style="fill:var(--fig-plum)">LDMFD SP!, {R0-R3, PC}^</text>
<text x="330" y="304" class="pl-note">^ = 同时把 SPSR 抄回 CPSR：模式、I/F、T 一并复原</text>
<rect x="32" y="328" width="404" height="82" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="48" y="352" class="pl-mono" style="fill:var(--fig-green)">偏移 +4：继续</text>
<text x="48" y="374" class="pl-small">IRQ / FIQ / SWI / 未定义指令</text>
<text x="48" y="394" class="pl-note">返回到被中断处的下一条指令</text>
<rect x="464" y="328" width="404" height="82" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="480" y="352" class="pl-mono" style="fill:var(--fig-red)">偏移 +8：重试</text>
<text x="480" y="374" class="pl-small">预取中止 / 数据中止</text>
<text x="480" y="394" class="pl-note">回到出错的指令本身，重新执行一次</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>进入的四步全是硬件动作，程序员不用管；退出的两步必须软件做。偏移取 4 还是 8，只看一件事——是"接着往下走"（4）还是"把出错的那条再做一遍"（8）。</figcaption>
</figure>
