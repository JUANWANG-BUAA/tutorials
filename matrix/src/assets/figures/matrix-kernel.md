<figure class="fig-plate fig-wide has-fig-scroll" id="fig-matrix-kernel" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 440" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="matrix-kernel-title matrix-kernel-desc">
<title id="matrix-kernel-title">核与像：A 到底丢掉了什么</title>
<desc id="matrix-kernel-desc">x 被拆成行空间分量与核分量；前者决定像，后者被压成 0。</desc>
<defs>
  <linearGradient id="matrix-kernel-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="matrix-kernel-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-plum)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--atlas-plum)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="matrix-kernel-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="matrix-kernel-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
  <marker id="arrow-a" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="arrow-c" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--atlas-cyan)"/></marker>
  <marker id="arrow-g" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--atlas-gold)"/></marker>
  <marker id="arrow-p" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--atlas-plum)"/></marker>
  <marker id="arrow-e" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--fig-green)"/></marker>
  <marker id="arrow-r" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--fig-red)"/></marker>
  <marker id="arrow-m" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="440" fill="url(#matrix-kernel-bg)"/>
<rect x="0" y="0" width="900" height="440" fill="url(#matrix-kernel-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="440" style="fill:var(--atlas-plum)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">MATRIX · KERNEL / 17</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / M-17</text>
<text x="32" y="73" class="pl-title">核与像：A 到底丢掉了什么</text>
<text x="32" y="96" class="pl-sub">x 被拆成行空间分量与核分量；前者决定像，后者被压成 0。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="42" y="140" width="370" height="236" rx="14" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/><text x="64.0" y="166.0" class="pl-mono" style="fill:var(--accent)">出发端  ℝⁿ</text><path d="M86 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M86 424 H334" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M148 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M86 362 H334" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M210 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M86 300 H334" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M272 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M86 238 H334" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M334 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M86 176 H334" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M210 300 L360 338" fill="none" stroke="var(--accent)" stroke-width="3" stroke-linecap="round" marker-end="url(#arrow-a)"/><text x="285.0" y="309.0" class="pl-axis-label" style="fill:var(--accent)" text-anchor="middle">x_row</text><path d="M210 300 L132 354" fill="none" stroke="var(--atlas-plum)" stroke-width="2.2" stroke-linecap="round" stroke-dasharray="5 6" marker-end="url(#arrow-p)"/><text x="171.0" y="343.0" class="pl-axis-label" style="fill:var(--atlas-plum)" text-anchor="middle">x_null</text><path d="M114 364 L282 392" stroke="var(--atlas-plum)" stroke-width="4" stroke-opacity=".5"/><text x="296.0" y="410.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle">ker A</text><rect x="488" y="140" width="370" height="236" rx="14" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/><text x="510.0" y="166.0" class="pl-mono" style="fill:var(--atlas-cyan)">到达端  ℝᵐ</text><path d="M531 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M531 424 H779" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M593 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M531 362 H779" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M655 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M531 300 H779" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M717 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M531 238 H779" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M779 176 V424" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M531 176 H779" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/><path d="M655 300 L805 338" fill="none" stroke="var(--atlas-cyan)" stroke-width="3" stroke-linecap="round" marker-end="url(#arrow-c)"/><text x="730.0" y="309.0" class="pl-axis-label" style="fill:var(--atlas-cyan)" text-anchor="middle">Ax = A x_row</text><circle cx="655" cy="300" r="5" fill="var(--ink)"/><text x="647.0" y="322.0" class="pl-mono" text-anchor="end">0</text><g><rect x="510.0" y="342.0" width="132.0" height="24" rx="12.0" fill="var(--atlas-plum)" fill-opacity=".08" stroke="var(--atlas-plum)" stroke-opacity=".28"/><text x="576.0" y="357.8" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle">A x_null = 0</text></g><path d="M416 256 L480 256" fill="none" stroke="var(--accent)" stroke-width="2.6" stroke-linecap="round" marker-end="url(#arrow-a)"/><text x="448.0" y="246.0" class="pl-axis-label" style="fill:var(--accent)" text-anchor="middle">A</text><text x="448.0" y="282.0" class="pl-axis-label" style="fill:var(--accent)" text-anchor="middle">同构</text><text x="450.0" y="400.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle" font-size="13">rank(A) + dim ker(A) = n</text><text x="450.0" y="424.0" class="pl-note" text-anchor="middle">A 只看 x_row；x_null 被压成 0。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>把 x 拆成两半：<b>x_row</b> 落在行空间里，被 A 同构地送到列空间；<b>x_null</b> 落在核里，被 A 直接压成 0。于是「A 的像」只由 x_row 决定，秩与零空间维数的账本也就自然成立。</figcaption>
</figure>
