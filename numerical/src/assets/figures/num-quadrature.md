<figure class="fig-plate fig-wide has-fig-scroll" id="fig-num-quadrature" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="num-quadrature-title num-quadrature-desc">
<title id="num-quadrature-title">从梯形到 Gauss：精度是怎么抬上去的</title>
<desc id="num-quadrature-desc">同一张图上看清复化、外推、Gauss 三条加速路线。</desc>
<defs>
  <linearGradient id="num-quadrature-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="num-quadrature-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="num-quadrature-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="num-quadrature-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="380" fill="url(#num-quadrature-bg)"/>
<rect x="0" y="0" width="900" height="380" fill="url(#num-quadrature-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="380" style="fill:var(--atlas-cyan)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">NUMERICAL · QUADRATURE / 06</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / N-25</text>
<text x="32" y="73" class="pl-title">从梯形到 Gauss：精度是怎么抬上去的</text>
<text x="32" y="96" class="pl-sub">同一张图上看清复化、外推、Gauss 三条加速路线。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<g><rect x="32" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-gold)" stroke-opacity=".28"/><rect x="32" y="185" width="4" height="60" rx="2" fill="var(--atlas-gold)" fill-opacity=".75"/><text x="50.0" y="197.0" class="pl-mono" style="fill:var(--atlas-gold)" opacity="0.85">01</text><circle cx="162" cy="194" r="4" fill="var(--atlas-gold)"/><circle cx="162" cy="194" r="9" fill="none" stroke="var(--atlas-gold)" stroke-opacity=".25"/><text x="50.0" y="222.0" class="pl-node-title">分割</text><text x="50.0" y="242.0" class="pl-node-sub">把 [a,b] 切成小段</text></g><path d="M186 215.0 L199 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="202" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--accent)" stroke-opacity=".28"/><rect x="202" y="185" width="4" height="60" rx="2" fill="var(--accent)" fill-opacity=".75"/><text x="220.0" y="197.0" class="pl-mono" style="fill:var(--accent)" opacity="0.85">02</text><circle cx="332" cy="194" r="4" fill="var(--accent)"/><circle cx="332" cy="194" r="9" fill="none" stroke="var(--accent)" stroke-opacity=".25"/><text x="220.0" y="222.0" class="pl-node-title">低阶公式</text><text x="220.0" y="242.0" class="pl-node-sub">梯形 / Simpson</text></g><path d="M356 215.0 L369 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="372" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-cyan)" stroke-opacity=".28"/><rect x="372" y="185" width="4" height="60" rx="2" fill="var(--atlas-cyan)" fill-opacity=".75"/><text x="390.0" y="197.0" class="pl-mono" style="fill:var(--atlas-cyan)" opacity="0.85">03</text><circle cx="502" cy="194" r="4" fill="var(--atlas-cyan)"/><circle cx="502" cy="194" r="9" fill="none" stroke="var(--atlas-cyan)" stroke-opacity=".25"/><text x="390.0" y="222.0" class="pl-node-title">复化累加</text><text x="390.0" y="242.0" class="pl-node-sub">T_n / S_n</text></g><path d="M526 215.0 L539 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="542" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-plum)" stroke-opacity=".28"/><rect x="542" y="185" width="4" height="60" rx="2" fill="var(--atlas-plum)" fill-opacity=".75"/><text x="560.0" y="197.0" class="pl-mono" style="fill:var(--atlas-plum)" opacity="0.85">04</text><circle cx="672" cy="194" r="4" fill="var(--atlas-plum)"/><circle cx="672" cy="194" r="9" fill="none" stroke="var(--atlas-plum)" stroke-opacity=".25"/><text x="560.0" y="222.0" class="pl-node-title">外推</text><text x="560.0" y="242.0" class="pl-node-sub">Romberg · Richardson</text></g><path d="M696 215.0 L709 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="712" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--fig-green)" stroke-opacity=".28"/><rect x="712" y="185" width="4" height="60" rx="2" fill="var(--fig-green)" fill-opacity=".75"/><text x="730.0" y="197.0" class="pl-mono" style="fill:var(--fig-green)" opacity="0.85">05</text><circle cx="842" cy="194" r="4" fill="var(--fig-green)"/><circle cx="842" cy="194" r="9" fill="none" stroke="var(--fig-green)" stroke-opacity=".25"/><text x="730.0" y="222.0" class="pl-node-title">Gauss</text><text x="730.0" y="242.0" class="pl-node-sub">节点也自由</text></g><text x="450.0" y="356.0" class="pl-note" text-anchor="middle">复化 Simpson O(h⁴)；Romberg 每列再抬 2 阶；n 点 Gauss 精确到 2n-1 次。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>先分割，再用低阶公式；复化把误差降到 O(h²)/O(h⁴)，Romberg 用外推再抬阶，Gauss 让节点也参与优化。精度不是免费的：Gauss 节点不固定、权重需预计算，适合光滑函数。</figcaption>
</figure>
