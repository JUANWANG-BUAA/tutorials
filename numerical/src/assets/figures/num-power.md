<figure class="fig-plate fig-wide has-fig-scroll" id="fig-num-power" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 436" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="num-power-title num-power-desc">
<title id="num-power-title">幂法：误差按 q^k 缩</title>
<desc id="num-power-desc">q = |λ₂| / |λ₁|；谱间隙越小，收敛越慢。</desc>
<defs>
  <linearGradient id="num-power-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="num-power-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-plum)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--atlas-plum)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="num-power-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="num-power-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="436" fill="url(#num-power-bg)"/>
<rect x="0" y="0" width="900" height="436" fill="url(#num-power-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="436" style="fill:var(--atlas-plum)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">NUMERICAL · POWER METHOD / 03</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / N-22</text>
<text x="32" y="73" class="pl-title">幂法：误差按 q^k 缩</text>
<text x="32" y="96" class="pl-sub">q = |λ₂| / |λ₁|；谱间隙越小，收敛越慢。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<rect x="32" y="138" width="566" height="250" rx="8" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".7"/><path d="M145.2 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 188.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M258.4 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 238.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M371.6 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 288.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M484.8 138 V388" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 338.0 H598" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/><path d="M32 388 H598" stroke="var(--ink-2)" stroke-opacity=".65" stroke-width="1.2"/><path d="M32 388 V138" stroke="var(--ink-2)" stroke-opacity=".65" stroke-width="1.2"/><text x="20" y="150" class="pl-axis-label" text-anchor="middle" transform="rotate(-90 20 150)">log10 误差</text><text x="32.0" y="404.0" class="pl-axis-label" text-anchor="middle">0</text><text x="173.5" y="404.0" class="pl-axis-label" text-anchor="middle">5</text><text x="315.0" y="404.0" class="pl-axis-label" text-anchor="middle">10</text><text x="456.5" y="404.0" class="pl-axis-label" text-anchor="middle">15</text><text x="598.0" y="404.0" class="pl-axis-label" text-anchor="middle">20</text><text x="26.0" y="142.0" class="pl-axis-label" text-anchor="end">0</text><text x="26.0" y="225.3" class="pl-axis-label" text-anchor="end">-2</text><text x="26.0" y="308.7" class="pl-axis-label" text-anchor="end">-4</text><text x="26.0" y="392.0" class="pl-axis-label" text-anchor="end">-6</text><text x="315.0" y="424.0" class="pl-axis-label" text-anchor="middle">迭代步 k</text><path d="M32.0 138.0 L60.3 139.9 L88.6 141.8 L116.9 143.7 L145.2 145.6 L173.5 147.5 L201.8 149.4 L230.1 151.3 L258.4 153.3 L286.7 155.2 L315.0 157.1 L343.3 159.0 L371.6 160.9 L399.9 162.8 L428.2 164.7 L456.5 166.6 L484.8 168.5 L513.1 170.4 L541.4 172.3 L569.7 174.2 L598.0 176.1" stroke="var(--fig-red)" stroke-width="2.2" stroke-linejoin="round" stroke-linecap="round" fill="none"/><text x="569.7" y="166.2" class="pl-mono" style="fill:var(--fig-red)" text-anchor="end" font-size="10.5">q=0.9</text><path d="M32.0 138.0 L60.3 147.2 L88.6 156.5 L116.9 165.7 L145.2 175.0 L173.5 184.2 L201.8 193.5 L230.1 202.7 L258.4 211.9 L286.7 221.2 L315.0 230.4 L343.3 239.7 L371.6 248.9 L399.9 258.2 L428.2 267.4 L456.5 276.7 L484.8 285.9 L513.1 295.1 L541.4 304.4 L569.7 313.6 L598.0 322.9" stroke="var(--atlas-gold)" stroke-width="2.2" stroke-linejoin="round" stroke-linecap="round" fill="none"/><text x="569.7" y="305.6" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="end" font-size="10.5">q=0.6</text><path d="M32.0 138.0 L60.3 159.8 L88.6 181.6 L116.9 203.4 L145.2 225.1 L173.5 246.9 L201.8 268.7 L230.1 290.5 L258.4 312.3 L286.7 334.1 L315.0 355.9 L343.3 377.7 L371.6 388.0 L399.9 388.0 L428.2 388.0 L456.5 388.0 L484.8 388.0 L513.1 388.0 L541.4 388.0 L569.7 388.0 L598.0 388.0" stroke="var(--atlas-cyan)" stroke-width="2.2" stroke-linejoin="round" stroke-linecap="round" fill="none"/><text x="569.7" y="380.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="end" font-size="10.5">q=0.3</text><text x="315.0" y="360.9" class="pl-small" style="fill:var(--muted)" text-anchor="middle">半对数坐标：斜率 = log10 q</text><rect x="626" y="138" width="242" height="250" rx="14" fill="var(--paper)" fill-opacity=".7" stroke="var(--line)" stroke-opacity=".8"/><text x="644.0" y="166.0" class="pl-kicker" style="fill:var(--atlas-plum)">读 法</text><text x="644.0" y="196.0" class="pl-small">q=0.9：20 步只降约 1 个量级</text><text x="644.0" y="226.0" class="pl-small">q=0.6：20 步降约 4 个量级</text><text x="644.0" y="256.0" class="pl-small">q 由谱间隙决定</text><text x="644.0" y="286.0" class="pl-small">q 越接近 1 越慢</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>幂法误差按 <b>q^k</b> 几何下降，q = |λ₂|/|λ₁|。三条线在半对数坐标下都是直线，斜率就是 log10 q：q 越接近 1，谱间隙越小，收敛越慢；q=0.3 时十几步就到机器精度，q=0.9 时二十步才降一个量级。</figcaption>
</figure>
