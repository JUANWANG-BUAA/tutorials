<figure class="fig-plate fig-wide has-fig-scroll" id="fig-robot-dh" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="robot-dh-title robot-dh-desc">
<title id="robot-dh-title">DH 四参数：四个数写清一根连杆</title>
<desc id="robot-dh-desc">相邻关节轴之间的相对位姿，只需要 a、α、d、θ 四个数。</desc>
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
<text x="32" y="73" class="pl-title">DH 四参数：四个数写清一根连杆</text>
<text x="32" y="96" class="pl-sub">相邻关节轴之间的相对位姿，只需要 a、α、d、θ 四个数。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<path d="M250 310 L390 220" stroke="var(--accent)" stroke-width="18" stroke-linecap="round" opacity=".28"/><path d="M390 220 L570 250" stroke="var(--atlas-cyan)" stroke-width="14" stroke-linecap="round" opacity=".3"/><path d="M250 310 L390 220" stroke="var(--accent)" stroke-width="6" stroke-linecap="round"/><path d="M390 220 L570 250" stroke="var(--atlas-cyan)" stroke-width="5" stroke-linecap="round"/><circle cx="250" cy="310" r="18" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><circle cx="250" cy="310" r="13" fill="var(--atlas-gold)" fill-opacity=".15"/><text x="250.0" y="285.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle">J₁</text><circle cx="390" cy="220" r="16" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><circle cx="390" cy="220" r="11" fill="var(--atlas-gold)" fill-opacity=".15"/><text x="390.0" y="197.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle">J₂</text><circle cx="570" cy="250" r="13" fill="var(--paper)" stroke="var(--atlas-gold)" stroke-width="2"/><circle cx="570" cy="250" r="8" fill="var(--atlas-gold)" fill-opacity=".15"/><text x="570.0" y="230.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle">TCP</text><path d="M356 230 L424 210" stroke="var(--atlas-plum)" stroke-width="2" stroke-dasharray="4 4"/><text x="428.0" y="212.0" class="pl-mono" style="fill:var(--atlas-plum)">z₁</text><path d="M250 288 L390 198" stroke="var(--accent)" stroke-opacity=".55" stroke-dasharray="3 5"/><text x="320.0" y="280.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">a₁</text><text x="320.0" y="346.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">α₁</text><text x="418.0" y="245.0" class="pl-mono" style="fill:var(--atlas-gold)">d₂</text><text x="418.0" y="263.0" class="pl-mono" style="fill:var(--atlas-plum)">θ₂</text><rect x="640" y="140" width="224" height="220" rx="14" fill="var(--paper)" fill-opacity=".74" stroke="var(--line)" stroke-opacity=".8"/><text x="658.0" y="168.0" class="pl-kicker" style="fill:var(--atlas-gold)">DH 四参数</text><text x="658.0" y="194.0" class="pl-small">aᵢ₋₁  沿 x 的连杆长度</text><text x="658.0" y="216.0" class="pl-small">αᵢ₋₁  绕 x 的扭转角</text><text x="658.0" y="238.0" class="pl-small">dᵢ     沿 z 的偏置</text><text x="658.0" y="260.0" class="pl-small">θᵢ     绕 z 的关节角</text><path d="M658 278H846" stroke="var(--line)" stroke-opacity=".7"/><text x="658.0" y="300.0" class="pl-mono" style="fill:var(--accent)" font-size="10.5">Tᵢ  =  Rot_z(θᵢ) Trans_z(dᵢ)</text><text x="658.0" y="318.0" class="pl-mono" style="fill:var(--accent)" font-size="10.5">      Trans_x(aᵢ₋₁) Rot_x(αᵢ₋₁)</text><text x="658.0" y="342.0" class="pl-note">四个数确定一个连杆坐标系。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>DH 把「两根相邻关节轴之间的相对位姿」压缩成四个数：沿 x 平移 <b>a</b>、绕 x 转 <b>α</b>、沿 z 平移 <b>d</b>、绕 z 转 <b>θ</b>。转动关节只有 θ 是变量；四个参数排成一张表，整条机械臂的几何就写完了。</figcaption>
</figure>
