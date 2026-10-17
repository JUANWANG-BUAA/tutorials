<figure class="fig-plate fig-wide has-fig-scroll" id="fig-robot-jacobian" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="robot-jacobian-title robot-jacobian-desc">
<title id="robot-jacobian-title">雅可比：把关节速度翻译成末端速度</title>
<desc id="robot-jacobian-desc">v = J(q)q̇；J 的每一列，都是一个关节对末端的「贡献方向」。</desc>
<defs>
  <linearGradient id="robot-jacobian-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="robot-jacobian-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--fig-red)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--fig-red)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="robot-jacobian-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="robot-jacobian-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="420" fill="url(#robot-jacobian-bg)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#robot-jacobian-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="420" style="fill:var(--fig-red)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ROBOTICS · JACOBIAN / 19</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-19</text>
<text x="32" y="73" class="pl-title">雅可比：把关节速度翻译成末端速度</text>
<text x="32" y="96" class="pl-sub">v = J(q)q̇；J 的每一列，都是一个关节对末端的「贡献方向」。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<path d="M230 318 L330 210" stroke="var(--accent)" stroke-width="16" stroke-linecap="round" opacity=".22"/><path d="M330 210 L470 246" stroke="var(--atlas-cyan)" stroke-width="14" stroke-linecap="round" opacity=".24"/><path d="M230 318 L330 210" stroke="var(--accent)" stroke-width="5" stroke-linecap="round"/><path d="M330 210 L470 246" stroke="var(--atlas-cyan)" stroke-width="4" stroke-linecap="round"/><circle cx="230" cy="318" r="15" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><text x="209.0" y="316.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end">q₁</text><circle cx="330" cy="210" r="13" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><text x="311.0" y="208.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end">q₂</text><circle cx="470" cy="246" r="11" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><text x="453.0" y="244.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end">TCP</text><path d="M196 318 A 34 34 0 0 1 221 285" fill="none" stroke="var(--atlas-plum)" stroke-width="2" marker-end="url(#arrow-p)"/><text x="178.0" y="332.0" class="pl-mono" style="fill:var(--atlas-plum)">q̇₁</text><path d="M304 210 A 26 26 0 0 1 321 185" fill="none" stroke="var(--atlas-plum)" stroke-width="2" marker-end="url(#arrow-p)"/><text x="286.0" y="224.0" class="pl-mono" style="fill:var(--atlas-plum)">q̇₂</text><path d="M470 246 L582 188" fill="none" stroke="var(--fig-red)" stroke-width="2.6" stroke-linecap="round" marker-end="url(#arrow-r)"/><text x="526.0" y="207.0" class="pl-axis-label" style="fill:var(--fig-red)" text-anchor="middle">v</text><path d="M470 246 L504 150" fill="none" stroke="var(--fig-green)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-e)"/><text x="487.0" y="190.0" class="pl-axis-label" style="fill:var(--fig-green)" text-anchor="middle">ω</text><rect x="606" y="146" width="256" height="222" rx="14" fill="var(--paper)" fill-opacity=".58" stroke="var(--line)" stroke-opacity=".8"/><text x="624.0" y="172.0" class="pl-kicker" style="fill:var(--atlas-gold)">几何雅可比</text><text x="624.0" y="232.0" class="pl-mono" style="fill:var(--accent)" font-size="14">J(q) =</text><text x="690.0" y="204.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle" font-size="9.5">q̇₁</text><text x="762.0" y="204.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle" font-size="9.5">q̇₂</text><rect x="694" y="214" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.1" stroke="var(--accent)" stroke-opacity=".26"/><text x="725.0" y="240.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂vₓ/∂q₁</text><rect x="764" y="214" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".26"/><text x="795.0" y="240.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂vₓ/∂q₂</text><rect x="694" y="266" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.1" stroke="var(--accent)" stroke-opacity=".26"/><text x="725.0" y="292.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂vᵧ/∂q₁</text><rect x="764" y="266" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".26"/><text x="795.0" y="292.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂vᵧ/∂q₂</text><text x="682.0" y="238.0" class="pl-mono" style="fill:var(--muted)" text-anchor="end" font-size="9.5">vₓ</text><text x="682.0" y="290.0" class="pl-mono" style="fill:var(--muted)" text-anchor="end" font-size="9.5">vᵧ</text><text x="734.0" y="346.0" class="pl-small" text-anchor="middle">每一列 = 一个关节的贡献方向</text><text x="450.0" y="400.0" class="pl-note" text-anchor="middle">v = J(q) · q̇：关节速度经雅可比映射成末端速度。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>雅可比是「每个关节单独动一点，末端往哪走」的偏导表。第 i 列是第 i 个关节速度对末端线速度 / 角速度的贡献；末端速度箭头是各列贡献的线性叠加。</figcaption>
</figure>
