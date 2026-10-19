<figure class="fig-plate fig-wide has-fig-scroll" id="fig-num-ode" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="num-ode-title num-ode-desc">
<title id="num-ode-title">单步、RK、多步：三条路线</title>
<desc id="num-ode-desc">精度看阶，稳定看测试方程；刚性方程优先隐式。</desc>
<defs>
  <linearGradient id="num-ode-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="num-ode-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-plum)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--atlas-plum)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="num-ode-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="num-ode-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="380" fill="url(#num-ode-bg)"/>
<rect x="0" y="0" width="900" height="380" fill="url(#num-ode-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="380" style="fill:var(--atlas-plum)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">NUMERICAL · ODE / 07</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / N-26</text>
<text x="32" y="73" class="pl-title">单步、RK、多步：三条路线</text>
<text x="32" y="96" class="pl-sub">精度看阶，稳定看测试方程；刚性方程优先隐式。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<g><rect x="32" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-gold)" stroke-opacity=".28"/><rect x="32" y="185" width="4" height="60" rx="2" fill="var(--atlas-gold)" fill-opacity=".75"/><text x="50.0" y="197.0" class="pl-mono" style="fill:var(--atlas-gold)" opacity="0.85">01</text><circle cx="162" cy="194" r="4" fill="var(--atlas-gold)"/><circle cx="162" cy="194" r="9" fill="none" stroke="var(--atlas-gold)" stroke-opacity=".25"/><text x="50.0" y="222.0" class="pl-node-title">初值问题</text><text x="50.0" y="242.0" class="pl-node-sub">y&#x27;=f(t,y), y(t0)=y0</text></g><path d="M186 215.0 L199 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="202" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--accent)" stroke-opacity=".28"/><rect x="202" y="185" width="4" height="60" rx="2" fill="var(--accent)" fill-opacity=".75"/><text x="220.0" y="197.0" class="pl-mono" style="fill:var(--accent)" opacity="0.85">02</text><circle cx="332" cy="194" r="4" fill="var(--accent)"/><circle cx="332" cy="194" r="9" fill="none" stroke="var(--accent)" stroke-opacity=".25"/><text x="220.0" y="222.0" class="pl-node-title">Euler</text><text x="220.0" y="242.0" class="pl-node-sub">沿切线走一步</text></g><path d="M356 215.0 L369 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="372" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-cyan)" stroke-opacity=".28"/><rect x="372" y="185" width="4" height="60" rx="2" fill="var(--atlas-cyan)" fill-opacity=".75"/><text x="390.0" y="197.0" class="pl-mono" style="fill:var(--atlas-cyan)" opacity="0.85">03</text><circle cx="502" cy="194" r="4" fill="var(--atlas-cyan)"/><circle cx="502" cy="194" r="9" fill="none" stroke="var(--atlas-cyan)" stroke-opacity=".25"/><text x="390.0" y="222.0" class="pl-node-title">RK</text><text x="390.0" y="242.0" class="pl-node-sub">多取几个斜率</text></g><path d="M526 215.0 L539 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="542" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-plum)" stroke-opacity=".28"/><rect x="542" y="185" width="4" height="60" rx="2" fill="var(--atlas-plum)" fill-opacity=".75"/><text x="560.0" y="197.0" class="pl-mono" style="fill:var(--atlas-plum)" opacity="0.85">04</text><circle cx="672" cy="194" r="4" fill="var(--atlas-plum)"/><circle cx="672" cy="194" r="9" fill="none" stroke="var(--atlas-plum)" stroke-opacity=".25"/><text x="560.0" y="222.0" class="pl-node-title">多步法</text><text x="560.0" y="242.0" class="pl-node-sub">用历史值</text></g><path d="M696 215.0 L709 215.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="712" y="172" width="152" height="86" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--fig-green)" stroke-opacity=".28"/><rect x="712" y="185" width="4" height="60" rx="2" fill="var(--fig-green)" fill-opacity=".75"/><text x="730.0" y="197.0" class="pl-mono" style="fill:var(--fig-green)" opacity="0.85">05</text><circle cx="842" cy="194" r="4" fill="var(--fig-green)"/><circle cx="842" cy="194" r="9" fill="none" stroke="var(--fig-green)" stroke-opacity=".25"/><text x="730.0" y="222.0" class="pl-node-title">刚性</text><text x="730.0" y="242.0" class="pl-node-sub">隐式 / A-稳定</text></g><text x="450.0" y="356.0" class="pl-note" text-anchor="middle">Euler O(h)；RK4 O(h⁴)；Adams 每步一次函数值但要启动。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>Euler 只用一个斜率，RK 用多个斜率加权，多步法用历史点；刚性方程的限制不在精度，而在绝对稳定区域——显式方法被迫用小步长，隐式方法才能走大步。</figcaption>
</figure>
