<figure class="fig-plate fig-wide has-fig-scroll" id="fig-num-vandermonde" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 436" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="num-vandermonde-title num-vandermonde-desc">
<title id="num-vandermonde-title">范德蒙德：存在唯一，但病态</title>
<desc id="num-vandermonde-desc">节点越多，系数方程越难解；换基（拉格朗日）才是出路。</desc>
<defs>
  <linearGradient id="num-vandermonde-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="num-vandermonde-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-gold)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--atlas-gold)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="num-vandermonde-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="num-vandermonde-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="436" fill="url(#num-vandermonde-bg)"/>
<rect x="0" y="0" width="900" height="436" fill="url(#num-vandermonde-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="436" style="fill:var(--atlas-gold)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">NUMERICAL · INTERPOLATION / 05</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / N-24</text>
<text x="32" y="73" class="pl-title">范德蒙德：存在唯一，但病态</text>
<text x="32" y="96" class="pl-sub">节点越多，系数方程越难解；换基（拉格朗日）才是出路。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="138" width="566" height="250" rx="8" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".7"/><path d="M145.2 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 188.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M258.4 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 238.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M371.6 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 288.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M484.8 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 338.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 388 H598" stroke="var(--ink-2)" stroke-opacity=".65" stroke-width="1.2"/><path d="M32 388 V138" stroke="var(--ink-2)" stroke-opacity=".65" stroke-width="1.2"/><text x="20" y="150" class="pl-axis-label" text-anchor="middle" transform="rotate(-90 20 150)">log10 cond(V)</text><text x="32.0" y="404.0" class="pl-axis-label" text-anchor="middle">2</text><text x="145.2" y="404.0" class="pl-axis-label" text-anchor="middle">4</text><text x="258.4" y="404.0" class="pl-axis-label" text-anchor="middle">6</text><text x="371.6" y="404.0" class="pl-axis-label" text-anchor="middle">8</text><text x="484.8" y="404.0" class="pl-axis-label" text-anchor="middle">10</text><text x="598.0" y="404.0" class="pl-axis-label" text-anchor="middle">12</text><text x="26.0" y="392.0" class="pl-axis-label" text-anchor="end">0</text><text x="26.0" y="308.7" class="pl-axis-label" text-anchor="end">3</text><text x="26.0" y="225.3" class="pl-axis-label" text-anchor="end">6</text><text x="26.0" y="142.0" class="pl-axis-label" text-anchor="end">9</text><text x="315.0" y="424.0" class="pl-axis-label" text-anchor="middle">节点数 n</text><path d="M32.0 376.3 L88.6 355.2 L145.2 332.4 L201.8 309.1 L258.4 285.5 L315.0 261.3 L371.6 237.2 L428.2 213.0 L484.8 188.6 L541.4 164.1 L598.0 139.4" stroke="var(--fig-red)" stroke-width="2.4" stroke-linejoin="round" stroke-linecap="round" fill="none"/><circle cx="32.0" cy="376.3" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="88.6" cy="355.2" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="145.2" cy="332.4" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="201.8" cy="309.1" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="258.4" cy="285.5" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="315.0" cy="261.3" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="371.6" cy="237.2" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="428.2" cy="213.0" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="484.8" cy="188.6" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="541.4" cy="164.1" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><circle cx="598.0" cy="139.4" r="3.2" fill="var(--paper)" stroke="var(--fig-red)" stroke-width="2"/><text x="269.7" y="332.4" class="pl-small" style="fill:var(--muted)" font-size="10">等距节点：每加几个点，条件数涨一个量级</text><text x="598.0" y="129.4" class="pl-mono" style="fill:var(--fig-red)" text-anchor="end" font-size="10.5">n=12：κ≈8.8×10⁸</text><rect x="626" y="138" width="242" height="250" rx="14" fill="var(--paper)" fill-opacity=".7" stroke="var(--line)" stroke-opacity=".8"/><text x="644.0" y="166.0" class="pl-kicker" style="fill:var(--atlas-gold)">读 法</text><text x="644.0" y="196.0" class="pl-small">n=2：κ≈2.6</text><text x="644.0" y="226.0" class="pl-small">n=8：κ≈2.7×10⁵</text><text x="644.0" y="256.0" class="pl-small">n=12：κ≈8.8×10⁸</text><text x="644.0" y="286.0" class="pl-small">每加几个点涨一个量级</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>等距节点上，范德蒙德矩阵的条件数随 n 近似指数增长：n=8 时约 10⁵，n=12 时约 10⁹。这意味着用 1,x,…,xⁿ 这组基直接解系数，会丢掉约 9 位有效数字——“存在唯一”不等于“能算出来”。</figcaption>
</figure>
