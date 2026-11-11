<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-scheduling" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="armsched-title armsched-desc">
<title id="armsched-title">抢占与非抢占：一次中断之后谁接着跑</title>
<desc id="armsched-desc">上下两条时间轴对比：非抢占内核中高优先级任务要等原任务主动让出，抢占内核中则立即接管 CPU。</desc>
<defs>
  <linearGradient id="armsched-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <pattern id="armsched-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
</defs>
<rect x="0" y="0" width="900" height="400" fill="url(#armsched-bg)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#armsched-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="400" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">RTOS · PREEMPTION / 04</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-06</text>
<text x="32" y="73" class="pl-title">中断之后，谁接着跑</text>
<text x="32" y="96" class="pl-sub">同一场景，两种内核：差别只在 ISR 结束那一刻。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<text x="32" y="142" class="pl-mono" style="fill:var(--fig-red)">非抢占（协作式）</text>
<rect x="32" y="156" width="300" height="34" rx="5" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="182" y="178" class="pl-small" text-anchor="middle">低优先级任务 L 继续跑</text>
<rect x="336" y="156" width="96" height="34" rx="5" fill="var(--paper)" stroke="var(--fig-red)"/>
<text x="384" y="178" class="pl-small" text-anchor="middle">ISR</text>
<rect x="436" y="156" width="300" height="34" rx="5" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="586" y="178" class="pl-small" text-anchor="middle">L 继续跑（高优先级任务在等）</text>
<rect x="740" y="156" width="128" height="34" rx="5" fill="var(--paper)" stroke="var(--fig-green)"/>
<text x="804" y="178" class="pl-small" text-anchor="middle">H 才跑</text>
<text x="32" y="206" class="pl-note">H 已在 ISR 里就绪，但要等 L 主动让出 —— 这段延迟不可预测</text>
<text x="32" y="246" class="pl-mono" style="fill:var(--fig-green)">抢占式</text>
<rect x="32" y="260" width="300" height="34" rx="5" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="182" y="282" class="pl-small" text-anchor="middle">低优先级任务 L</text>
<rect x="336" y="260" width="96" height="34" rx="5" fill="var(--paper)" stroke="var(--fig-red)"/>
<text x="384" y="282" class="pl-small" text-anchor="middle">ISR</text>
<rect x="436" y="260" width="432" height="34" rx="5" fill="var(--paper)" stroke="var(--fig-green)"/>
<text x="652" y="282" class="pl-small" text-anchor="middle">H 立刻接管 CPU，L 被挂起</text>
<text x="32" y="310" class="pl-note">响应时间由优先级与调度开销决定，有上界 —— 实时系统要的就是这个</text>
<rect x="32" y="330" width="836" height="52" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="48" y="352" class="pl-mono" style="fill:var(--accent)">切换的代价</text>
<text x="150" y="352" class="pl-small">保存当前任务全部 CPU 寄存器到它自己的栈，再从新任务的栈装载 → 与寄存器数量成正比</text>
<text x="48" y="372" class="pl-note">ARM 上 37 个寄存器（2.7.1）——每次切换都要搬一堆，这是嵌入式 RTOS 刻意精简任务上下文的原因</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>两条时间轴的唯一区别是 ISR 之后的第一个瞬间：非抢占内核把 CPU 还给 L，抢占内核直接交给 H。课件的结论很硬——实时系统中不宜采用非抢占式调度。底部那行说明代价：切换开销与 CPU 寄存器数量成正比。</figcaption>
</figure>
