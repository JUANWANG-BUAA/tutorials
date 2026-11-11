<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-barriers" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="armbr-title armbr-desc">
<title id="armbr-title">多核并发的三个正交问题与各自的手段</title>
<desc id="armbr-desc">互斥、一致性、存储序三个问题的现象与手段，右侧是屏障指令与独占访问的层次。</desc>
<defs>
<linearGradient id="armbr-bg" x1="0" y1="0" x2="1" y2="1">
<stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
<stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
</linearGradient>
<pattern id="armbr-grid" width="26" height="26" patternUnits="userSpaceOnUse">
<path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
</pattern>
</defs>
<rect x="0" y="0" width="900" height="420" fill="url(#armbr-bg)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#armbr-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="420" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM64 · MEMORY BARRIERS / 05</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-09</text>
<text x="32" y="73" class="pl-title">多核上的三个正交问题</text>
<text x="32" y="96" class="pl-sub">第四章 4.10 的三招（关中断/禁切换/信号量）只挡住本核——多核要三套手段各管一件事。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="136" width="270" height="104" rx="8" fill="var(--paper)" stroke="var(--fig-blue)"/>
<text x="48" y="162" class="pl-mono" style="fill:var(--fig-blue)">① 互斥</text>
<text x="48" y="186" class="pl-small">现象：两核同时改同一数据</text>
<text x="48" y="208" class="pl-small">手段：信号量 / 互斥量</text>
<text x="48" y="228" class="pl-note">多核主力：独占访问自旋锁</text>
<rect x="318" y="136" width="270" height="104" rx="8" fill="var(--paper)" stroke="var(--fig-green)"/>
<text x="334" y="162" class="pl-mono" style="fill:var(--fig-green)">② 一致性</text>
<text x="334" y="186" class="pl-small">现象：一核改了，另一核看旧值</text>
<text x="334" y="208" class="pl-small">手段：MESI（硬件自动）</text>
<text x="334" y="228" class="pl-note">软件：DMA 前 clean / 后 invalidate</text>
<rect x="604" y="136" width="264" height="104" rx="8" fill="var(--paper)" stroke="var(--fig-red)"/>
<text x="620" y="162" class="pl-mono" style="fill:var(--fig-red)">③ 存储序</text>
<text x="620" y="186" class="pl-small">现象：看到操作的中间状态</text>
<text x="620" y="208" class="pl-small">手段：内存屏障指令</text>
<text x="620" y="228" class="pl-note">缓存一致性管不了次序！</text>
<text x="32" y="272" class="pl-mono" style="fill:var(--accent)">下：手段的层次（由粗到细）</text>
<rect x="32" y="286" width="836" height="42" rx="6" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="48" y="312" class="pl-mono" style="fill:var(--fig-plum)">DMB</text>
<text x="110" y="312" class="pl-small">数据访存不能越过（保证次序）—— 最常用</text>
<rect x="32" y="336" width="836" height="42" rx="6" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="48" y="362" class="pl-mono" style="fill:var(--fig-gold)">DSB</text>
<text x="110" y="362" class="pl-small">次序 + 完成（等前面的访存真正落地）—— 设备寄存器必用</text>
<rect x="32" y="386" width="836" height="0" rx="0" fill="none"/>
<text x="32" y="404" class="pl-note">更优做法：LDAR/STLR 内建屏障原语；LDXR/STXR 独占访问实现 CAS 与自旋锁（详见 5.10）</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>三个问题互相独立——解决了互斥不等于解决了一致性，有一致性也不保证次序。判断多核 bug 时先问"这是哪个问题"：数据坏了是①，读到旧值是②，顺序不对是③，然后各用各的手段。</figcaption>
</figure>
