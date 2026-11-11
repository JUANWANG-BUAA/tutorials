<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-instruction" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="armins-title armins-desc">
<title id="armins-title">ARM 32 位指令的字段切分与四种地址形态</title>
<desc id="armins-desc">上半是条件域、寄存器编号、第二操作数的位段划分，下半是零偏移、前索引、后索引、PC 相对四种地址写法的对照。</desc>
<defs>
  <linearGradient id="armins-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <pattern id="armins-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
  <marker id="armins-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="380" fill="url(#armins-bg)"/>
<rect x="0" y="0" width="900" height="380" fill="url(#armins-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="380" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM · INSTRUCTION FORMAT / 03</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-07</text>
<text x="32" y="73" class="pl-title">32 位怎么切：条件、寄存器、第二操作数</text>
<text x="32" y="96" class="pl-sub">同一个骨架，填不同的操作码与寻址方式，就成了不同指令。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="134" width="90" height="52" rx="6" fill="var(--paper)" stroke="var(--fig-blue)"/>
<text x="77" y="156" class="pl-note" text-anchor="middle">31–28</text>
<text x="77" y="176" class="pl-mono" text-anchor="middle" style="fill:var(--fig-blue)">cond</text>
<rect x="128" y="134" width="112" height="52" rx="6" fill="var(--paper)" stroke="var(--line)"/>
<text x="184" y="156" class="pl-note" text-anchor="middle">27–25</text>
<text x="184" y="176" class="pl-mono" text-anchor="middle">opcode</text>
<rect x="246" y="134" width="112" height="52" rx="6" fill="var(--paper)" stroke="var(--line)"/>
<text x="302" y="156" class="pl-note" text-anchor="middle">24–21</text>
<text x="302" y="176" class="pl-mono" text-anchor="middle">S · I</text>
<rect x="364" y="134" width="112" height="52" rx="6" fill="var(--paper)" stroke="var(--line)"/>
<text x="420" y="156" class="pl-note" text-anchor="middle">20–16</text>
<text x="420" y="176" class="pl-mono" text-anchor="middle">Rn</text>
<rect x="482" y="134" width="112" height="52" rx="6" fill="var(--paper)" stroke="var(--line)"/>
<text x="538" y="156" class="pl-note" text-anchor="middle">15–12</text>
<text x="538" y="176" class="pl-mono" text-anchor="middle">Rd</text>
<rect x="600" y="134" width="120" height="52" rx="6" fill="var(--paper)" stroke="var(--fig-plum)"/>
<text x="660" y="156" class="pl-note" text-anchor="middle">11–8 / 7–4</text>
<text x="660" y="176" class="pl-mono" text-anchor="middle">Rm / Rs</text>
<rect x="726" y="134" width="142" height="52" rx="6" fill="var(--paper)" stroke="var(--fig-gold)"/>
<text x="797" y="156" class="pl-note" text-anchor="middle">3–0</text>
<text x="797" y="176" class="pl-mono" text-anchor="middle">移位 / 立即数</text>
<text x="32" y="216" class="pl-note">cond 占 4 位 → 每条指令自带 if；operand2 三形态：立即数（8 位循环右移偶数位）、寄存器、寄存器移位</text>
<text x="32" y="248" class="pl-mono" style="fill:var(--accent)">四种地址形态：什么时候算地址，什么时候回写基址</text>
<rect x="32" y="262" width="204" height="88" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="48" y="284" class="pl-mono" style="fill:var(--fig-blue)">LDR Rd,[Rn]</text>
<text x="48" y="306" class="pl-small">零偏移 · 地址 = Rn</text>
<text x="48" y="328" class="pl-note">基址不变</text>
<rect x="244" y="262" width="204" height="88" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="260" y="284" class="pl-mono" style="fill:var(--fig-plum)">LDR Rd,[Rn,#off]!</text>
<text x="260" y="306" class="pl-small">前索引 · 地址 = Rn+off</text>
<text x="260" y="328" class="pl-note">先算地址，访存后回写 Rn</text>
<rect x="456" y="262" width="204" height="88" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="472" y="284" class="pl-mono" style="fill:var(--fig-green)">LDR Rd,[Rn],#off</text>
<text x="472" y="306" class="pl-small">后索引 · 地址 = Rn</text>
<text x="472" y="328" class="pl-note">先访存，再回写 Rn</text>
<rect x="668" y="262" width="200" height="88" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="684" y="284" class="pl-mono" style="fill:var(--fig-gold)">LDR Rd,label</text>
<text x="684" y="306" class="pl-small">程序相对 · PC ± 偏移</text>
<text x="684" y="328" class="pl-note">位置无关的基础</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>上半的位段划分是所有 ARM 指令共用的骨架——cond 决定"执行不执行"，S 决定"要不要更新标志"，最后一段决定第二操作数怎么解释。下半四种地址形态只差两件事：<code>!</code> 在不在（要不要回写）、逗号在括号内还是外（先算地址还是先访存）。</figcaption>
</figure>
