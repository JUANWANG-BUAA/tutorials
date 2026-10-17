<figure class="fig-plate fig-wide has-fig-scroll" id="fig-numerical-subspaces" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 424" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="numerical-subspaces-title numerical-subspaces-desc">
<title id="numerical-subspaces-title">四个基本子空间与秩</title>
<desc id="numerical-subspaces-desc">A 把 ℝⁿ 劈成行空间与零空间，把 ℝᵐ 劈成列空间与左零空间。</desc>
<defs>
  <linearGradient id="numerical-subspaces-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="numerical-subspaces-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--accent)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--accent)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="numerical-subspaces-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="numerical-subspaces-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="424" fill="url(#numerical-subspaces-bg)"/>
<rect x="0" y="0" width="900" height="424" fill="url(#numerical-subspaces-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="424" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">NUMERICAL · LINEAR ALGEBRA / 10</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / N-10</text>
<text x="32" y="73" class="pl-title">四个基本子空间与秩</text>
<text x="32" y="96" class="pl-sub">A 把 ℝⁿ 劈成行空间与零空间，把 ℝᵐ 劈成列空间与左零空间。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="56" y="150" width="300" height="196" rx="14" fill="var(--paper)" fill-opacity=".72" stroke="var(--line)" stroke-opacity=".8"/><text x="76.0" y="176.0" class="pl-mono" style="fill:var(--accent)">出发端  ℝⁿ</text><rect x="76" y="192" width="260" height="54" rx="8" fill="var(--accent)" fill-opacity=".12" stroke="var(--accent)" stroke-opacity=".35"/><text x="96.0" y="215.0" class="pl-label" style="fill:var(--accent)">行空间  row(A)</text><text x="96.0" y="234.0" class="pl-mono" style="fill:var(--accent)">dim = r</text><rect x="76" y="270" width="260" height="54" rx="8" fill="var(--atlas-plum)" fill-opacity=".08" stroke="var(--atlas-plum)" stroke-opacity=".3"/><text x="96.0" y="293.0" class="pl-label" style="fill:var(--atlas-plum)">零空间  null(A)</text><text x="96.0" y="312.0" class="pl-mono" style="fill:var(--atlas-plum)">dim = n − r</text><rect x="544" y="150" width="300" height="196" rx="14" fill="var(--paper)" fill-opacity=".72" stroke="var(--line)" stroke-opacity=".8"/><text x="564.0" y="176.0" class="pl-mono" style="fill:var(--atlas-cyan)">到达端  ℝᵐ</text><rect x="564" y="192" width="260" height="54" rx="8" fill="var(--atlas-cyan)" fill-opacity=".1" stroke="var(--atlas-cyan)" stroke-opacity=".32"/><text x="584.0" y="215.0" class="pl-label" style="fill:var(--atlas-cyan)">列空间  col(A)</text><text x="584.0" y="234.0" class="pl-mono" style="fill:var(--atlas-cyan)">dim = r</text><rect x="564" y="270" width="260" height="54" rx="8" fill="var(--atlas-gold)" fill-opacity=".08" stroke="var(--atlas-gold)" stroke-opacity=".3"/><text x="584.0" y="293.0" class="pl-label" style="fill:var(--atlas-gold)">左零空间  null(Aᵀ)</text><text x="584.0" y="312.0" class="pl-mono" style="fill:var(--atlas-gold)">dim = m − r</text><path d="M340 219 L556 219" fill="none" stroke="var(--accent)" stroke-width="2.2" stroke-linecap="round" marker-end="url(#arrow-a)"/><text x="448.0" y="209.0" class="pl-axis-label" style="fill:var(--accent)" text-anchor="middle">A</text><text x="448.0" y="244.0" class="pl-axis-label" style="fill:var(--accent)" text-anchor="middle">同构</text><path d="M338 297 L404 297" fill="none" stroke="var(--atlas-plum)" stroke-width="1.8" stroke-linecap="round" stroke-dasharray="5 6" marker-end="url(#arrow-p)"/><circle cx="422" cy="297" r="14" fill="var(--atlas-plum)" fill-opacity=".08" stroke="var(--atlas-plum)" stroke-opacity=".45"/><text x="422.0" y="301.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle">0</text><text x="448.0" y="320.0" class="pl-small" style="fill:var(--atlas-plum)" text-anchor="middle">Ax = 0</text><text x="450.0" y="376.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle">row(A) ⊥ null(A)    ·    col(A) ⊥ null(Aᵀ)</text><text x="450.0" y="400.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle">维数账本：r + (n−r) = n    r + (m−r) = m</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>四个框两两配对：<b>行空间 ↔ 零空间</b>在出发端拼成整个 ℝⁿ，<b>列空间 ↔ 左零空间</b>在到达端拼成 ℝᵐ。A 在行空间上是<b>同构</b>，把零空间压成 0；秩 r 是这两本维数账本的同一个数。虚线标出「A 把零空间映成 0」，它不连接零空间与左零空间。</figcaption>
</figure>
