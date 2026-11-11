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
<path d="M230 318 L330 210" stroke="var(--accent)" stroke-width="16" stroke-linecap="round" opacity=".22"/><path d="M330 210 L470 246" stroke="var(--atlas-cyan)" stroke-width="14" stroke-linecap="round" opacity=".24"/><path d="M230 318 L330 210" stroke="var(--accent)" stroke-width="5" stroke-linecap="round"/><path d="M330 210 L470 246" stroke="var(--atlas-cyan)" stroke-width="4" stroke-linecap="round"/><circle cx="230" cy="318" r="15" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><text x="209.0" y="316.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end">q₁</text><circle cx="330" cy="210" r="13" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><text x="311.0" y="208.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end">q₂</text><circle cx="470" cy="246" r="11" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><text x="453.0" y="244.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end">TCP</text><text x="196.0" y="352.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle">q̇₁ = 0（锁住）</text><path d="M321 185 A 26 26 0 0 0 304 210" fill="none" stroke="var(--atlas-plum)" stroke-width="2" marker-end="url(#arrow-p)"/><text x="286.0" y="168.0" class="pl-mono" style="fill:var(--atlas-plum)">q̇₂ = +1 rad/s</text><path d="M470 246 L443 141" fill="none" stroke="var(--fig-red)" stroke-width="2.6" stroke-linecap="round" marker-end="url(#arrow-r)"/><text x="456.5" y="183.5" class="pl-axis-label" style="fill:var(--fig-red)" text-anchor="middle">v</text><circle cx="510" cy="286" r="12" fill="none" stroke="var(--fig-green)" stroke-width="2"/><circle cx="510" cy="286" r="3" fill="var(--fig-green)"/><text x="510.0" y="318.0" class="pl-small" style="fill:var(--fig-green)" text-anchor="middle">ω：出纸面</text><rect x="606" y="146" width="256" height="222" rx="14" fill="var(--paper)" fill-opacity=".58" stroke="var(--line)" stroke-opacity=".8"/><text x="624.0" y="172.0" class="pl-kicker" style="fill:var(--atlas-gold)">平面位置块 Jₚ,xy（2×2）</text><text x="725.0" y="204.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle" font-size="10">关节 1</text><text x="795.0" y="204.0" class="pl-mono" style="fill:var(--atlas-plum)" text-anchor="middle" font-size="10">关节 2</text><rect x="694" y="214" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.1" stroke="var(--accent)" stroke-opacity=".26"/><text x="725.0" y="240.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂pₓ/∂q₁</text><rect x="764" y="214" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".26"/><text x="795.0" y="240.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂pₓ/∂q₂</text><rect x="694" y="266" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.1" stroke="var(--accent)" stroke-opacity=".26"/><text x="725.0" y="292.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂pᵧ/∂q₁</text><rect x="764" y="266" width="62" height="42" rx="6" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".26"/><text x="795.0" y="292.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="11.5">∂pᵧ/∂q₂</text><text x="682.0" y="240.0" class="pl-mono" style="fill:var(--muted)" text-anchor="end" font-size="10">pₓ 行</text><text x="682.0" y="292.0" class="pl-mono" style="fill:var(--muted)" text-anchor="end" font-size="10">pᵧ 行</text><text x="734.0" y="334.0" class="pl-small" text-anchor="middle">角速度行另计：ωz = q̇₁ + q̇₂</text><text x="734.0" y="356.0" class="pl-small" text-anchor="middle">完整几何雅可比为 6×2</text><text x="450.0" y="400.0" class="pl-note" text-anchor="middle">(vₓ, vᵧ)ᵀ = Jₚ,xy(q) q̇；ω 的正方向沿 +z 出纸面。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>右表只列<b>位置对关节角的偏导</b>，乘关节速度后得到平面线速度；完整几何雅可比还包括角速度行。左图锁住关节 1，关节 2 以 +1 rad/s 逆时针转动，v 垂直于第二杆、朝左上，ω 沿 +z 出纸面。速度箭头长度仅为示意，未给定杆长。</figcaption>
</figure>
