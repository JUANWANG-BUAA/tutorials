<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-exlevels" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="armel-title armel-desc">
<title id="armel-title">AArch64 的四个异常级与 16 项向量表</title>
<desc id="armel-desc">左侧是 EL0 到 EL3 的特权阶梯，右侧是一张 16 项乘 128 字节的向量表布局。</desc>
<defs>
<linearGradient id="armel-bg" x1="0" y1="0" x2="1" y2="1">
<stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
<stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
</linearGradient>
<pattern id="armel-grid" width="26" height="26" patternUnits="userSpaceOnUse">
<path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
</pattern>
<marker id="armel-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--fig-red)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="430" fill="url(#armel-bg)"/>
<rect x="0" y="0" width="900" height="430" fill="url(#armel-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="430" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM64 · EXCEPTION LEVELS / 05</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-08</text>
<text x="32" y="73" class="pl-title">特权阶梯与向量表：ARMv8 的异常体系</text>
<text x="32" y="96" class="pl-sub">每级一张向量表，每项 128 字节，基址由 VBAR_ELx 设定、2 KB 对齐。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<text x="32" y="142" class="pl-mono" style="fill:var(--accent)">左：异常级（特权递增 ↑）</text>
<rect x="32" y="156" width="200" height="52" rx="8" fill="var(--paper)" stroke="var(--fig-blue)"/>
<text x="48" y="178" class="pl-mono" style="fill:var(--fig-blue)">EL0 · 用户态</text>
<text x="48" y="198" class="pl-small">用户程序 · 无特权</text>
<rect x="32" y="218" width="200" height="52" rx="8" fill="var(--paper)" stroke="var(--fig-green)"/>
<text x="48" y="240" class="pl-mono" style="fill:var(--fig-green)">EL1 · 内核态</text>
<text x="48" y="260" class="pl-small">操作系统内核</text>
<rect x="32" y="280" width="200" height="52" rx="8" fill="var(--paper)" stroke="var(--fig-gold)"/>
<text x="48" y="302" class="pl-mono" style="fill:var(--fig-gold)">EL2 · 虚拟化</text>
<text x="48" y="322" class="pl-small">Hypervisor</text>
<rect x="32" y="342" width="200" height="52" rx="8" fill="var(--paper)" stroke="var(--fig-plum)"/>
<text x="48" y="364" class="pl-mono" style="fill:var(--fig-plum)">EL3 · 安全态</text>
<text x="48" y="384" class="pl-small">可信固件 · 最高特权</text>
<text x="268" y="142" class="pl-mono" style="fill:var(--accent)">右：VBAR_ELx 指向的 16 项向量表（每项 0x80）</text>
<rect x="268" y="156" width="604" height="34" rx="5" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="282" y="178" class="pl-mono">+0x000 ~ +0x180</text>
<text x="560" y="178" class="pl-small">当前 EL · 用 SP_EL0（4 项：同步/IRQ/FIQ/SError）</text>
<rect x="268" y="198" width="604" height="34" rx="5" fill="var(--paper)" stroke="var(--line)"/>
<text x="282" y="220" class="pl-mono">+0x200 ~ +0x380</text>
<text x="560" y="220" class="pl-small">当前 EL · 用 SP_ELx（4 项）</text>
<rect x="268" y="240" width="604" height="34" rx="5" fill="var(--paper-soft)" stroke="var(--fig-blue)"/>
<text x="282" y="262" class="pl-mono">+0x400 ~ +0x580</text>
<text x="560" y="262" class="pl-small">来自低 EL · AArch64 执行状态（4 项）</text>
<rect x="268" y="282" width="604" height="34" rx="5" fill="var(--paper)" stroke="var(--fig-gold)"/>
<text x="282" y="304" class="pl-mono">+0x600 ~ +0x780</text>
<text x="560" y="304" class="pl-small">来自低 EL · AArch32 执行状态（4 项）</text>
<rect x="268" y="332" width="604" height="62" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="282" y="356" class="pl-mono" style="fill:var(--fig-red)">对照 AArch32（2.9.2）</text>
<text x="282" y="378" class="pl-small">8 项 × 4 字节 · 固定 0x0 / 0xFFFF0000 → 16 项 × 128 字节 · 每级一张 · 处理程序直接写在向量项里</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>左边的特权阶梯决定"谁能动谁"——异常只能往同级或更高级陷；右边的向量表按"来源 × 栈 × 执行状态"切成 16 格，每格 128 字字节容得下 32 条指令，免掉 AArch32 每项一条跳转的二次跳转。</figcaption>
</figure>
