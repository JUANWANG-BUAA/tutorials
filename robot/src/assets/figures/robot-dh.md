<figure class="fig-plate fig-wide has-fig-scroll" id="fig-robot-dh" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="robot-dh-title robot-dh-desc">
<title id="robot-dh-title">标准 DH：一行参数，四步建系</title>
<desc id="robot-dh-desc">先定轴向、原点与零位，再沿同一套约定连乘。</desc>
<defs>
  <linearGradient id="robot-dh-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="robot-dh-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--accent)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--accent)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="robot-dh-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="robot-dh-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="420" fill="url(#robot-dh-bg)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#robot-dh-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="420" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ROBOTICS · DH PARAMETERS / 13</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-13</text>
<text x="32" y="73" class="pl-title">标准 DH：一行参数，四步建系</text>
<text x="32" y="96" class="pl-sub">先定轴向、原点与零位，再沿同一套约定连乘。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="145" width="195" height="120" rx="8" fill="var(--paper)" stroke="var(--line)"/><text x="129.0" y="175.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">① Rot_z(θᵢ)</text><text x="129.0" y="208.0" class="pl-small" text-anchor="middle">绕当前 z 转</text><text x="129.0" y="242.0" class="pl-note" text-anchor="middle">关节 i 的正轴为 zᵢ₋₁</text><text x="236.0" y="209.0" class="pl-mono" text-anchor="middle">→</text><rect x="245" y="145" width="195" height="120" rx="8" fill="var(--paper)" stroke="var(--line)"/><text x="342.0" y="175.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">② Trans_z(dᵢ)</text><text x="342.0" y="208.0" class="pl-small" text-anchor="middle">沿当前 z 移</text><text x="342.0" y="242.0" class="pl-note" text-anchor="middle">到公垂线的垂足</text><text x="449.0" y="209.0" class="pl-mono" text-anchor="middle">→</text><rect x="458" y="145" width="195" height="120" rx="8" fill="var(--paper)" stroke="var(--line)"/><text x="555.0" y="175.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">③ Trans_x(aᵢ)</text><text x="555.0" y="208.0" class="pl-small" text-anchor="middle">沿当前 x 移</text><text x="555.0" y="242.0" class="pl-note" text-anchor="middle">沿公垂线到新原点</text><text x="662.0" y="209.0" class="pl-mono" text-anchor="middle">→</text><rect x="671" y="145" width="195" height="120" rx="8" fill="var(--paper)" stroke="var(--line)"/><text x="768.0" y="175.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">④ Rot_x(αᵢ)</text><text x="768.0" y="208.0" class="pl-small" text-anchor="middle">绕当前 x 转</text><text x="768.0" y="242.0" class="pl-note" text-anchor="middle">把 z 转到 zᵢ</text><text x="450.0" y="303.0" class="pl-small" text-anchor="middle">从系 i−1 起步，按当前轴逐步右乘，最后得到系 i 的位姿</text><text x="450.0" y="335.0" class="pl-note" text-anchor="middle">四因子作用到一个列向量时，仍从最右侧先算</text><text x="450.0" y="375.0" class="pl-small" text-anchor="middle">固定几何的 R 行：θᵢ 变化；P 行：dᵢ 变化。aᵢ、αᵢ 恒定。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>本书标准 DH 的每一行都用 aᵢ、αᵢ、dᵢ、θᵢ。箭头是构造坐标系的时序，各步绕或沿当前轴，故在乘积中依次右乘；用矩阵换算点坐标时则从右向左作用。四参数依赖选系，并不把一般刚体位姿的六维自由度改成四维。</figcaption>
</figure>
