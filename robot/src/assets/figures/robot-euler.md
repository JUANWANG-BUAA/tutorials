<figure class="fig-plate fig-wide has-fig-scroll" id="fig-robot-euler" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 410" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="robot-euler-title robot-euler-desc">
<title id="robot-euler-title">欧拉角：三个环，三次旋转</title>
<desc id="robot-euler-desc">ZYZ 与 RPY 都是把姿态拆成三个可读的角，但读数依赖顺序，也会遇到万向节锁。</desc>
<defs>
  <linearGradient id="robot-euler-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="robot-euler-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--accent)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--accent)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="robot-euler-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="robot-euler-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="410" fill="url(#robot-euler-bg)"/>
<rect x="0" y="0" width="900" height="410" fill="url(#robot-euler-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="410" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ROBOTICS · EULER ANGLES / 11</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-11</text>
<text x="32" y="73" class="pl-title">欧拉角：三个环，三次旋转</text>
<text x="32" y="96" class="pl-sub">ZYZ 与 RPY 都是把姿态拆成三个可读的角，但读数依赖顺序，也会遇到万向节锁。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<ellipse cx="300" cy="270" rx="142" ry="59.64" fill="none" stroke="var(--accent)" stroke-width="2" stroke-opacity=".65" transform="rotate(-18 300 270)"/><circle cx="433.5" cy="244.4" r="4" fill="var(--accent)"/><ellipse cx="300" cy="270" rx="108" ry="45.36" fill="none" stroke="var(--atlas-cyan)" stroke-width="2" stroke-opacity=".65" transform="rotate(-9 300 270)"/><circle cx="401.5" cy="250.6" r="4" fill="var(--atlas-cyan)"/><ellipse cx="300" cy="270" rx="74" ry="31.08" fill="none" stroke="var(--atlas-gold)" stroke-width="2" stroke-opacity=".65" transform="rotate(0 300 270)"/><circle cx="369.6" cy="256.7" r="4" fill="var(--atlas-gold)"/><circle cx="300" cy="270" r="9" fill="var(--paper)" stroke="var(--accent)" stroke-width="2"/><path d="M300 270 L418 216" fill="none" stroke="var(--fig-red)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-r)"/><text x="359.0" y="235.0" class="pl-axis-label" style="fill:var(--fig-red)" text-anchor="middle">x</text><path d="M300 270 L212 332" fill="none" stroke="var(--fig-green)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-e)"/><text x="256.0" y="313.0" class="pl-axis-label" style="fill:var(--fig-green)" text-anchor="middle">y</text><path d="M300 270 L300 152" fill="none" stroke="var(--accent)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-a)"/><text x="300.0" y="203.0" class="pl-axis-label" style="fill:var(--accent)" text-anchor="middle">z</text><g><rect x="492.0" y="172.0" width="94.0" height="24" rx="12.0" fill="var(--accent)" fill-opacity=".08" stroke="var(--accent)" stroke-opacity=".28"/><text x="539.0" y="187.8" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">α  绕 z</text></g><g><rect x="492.0" y="216.0" width="94.0" height="24" rx="12.0" fill="var(--atlas-cyan)" fill-opacity=".08" stroke="var(--atlas-cyan)" stroke-opacity=".28"/><text x="539.0" y="231.8" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">β  绕 y′</text></g><g><rect x="492.0" y="260.0" width="94.0" height="24" rx="12.0" fill="var(--atlas-gold)" fill-opacity=".08" stroke="var(--atlas-gold)" stroke-opacity=".28"/><text x="539.0" y="275.8" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle">γ  绕 z″</text></g><text x="492.0" y="306.0" class="pl-small">ZYZ：内旋三次，顺序不能换。</text><rect x="492" y="326" width="344" height="54" rx="10" fill="var(--fig-red)" fill-opacity=".06" stroke="var(--fig-red)" stroke-opacity=".28"/><text x="510.0" y="348.0" class="pl-mono" style="fill:var(--fig-red)">万向节锁  β = 0 或 π</text><text x="510.0" y="367.0" class="pl-small">两个环轴重合，丢失一个自由度。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>ZYZ 是「先绕 z 转 α，再绕新 y 转 β，最后绕新 z 转 γ」的内旋序列。三个环分别代表三次旋转；当 β=0 或 π 时，第一、第三环的轴重合，两个角只剩一个独立效果——这就是<b>万向节锁</b>。</figcaption>
</figure>
