<figure class="fig-plate fig-wide has-fig-scroll" id="fig-robot-pose" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 440" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="robot-pose-title robot-pose-desc">
<title id="robot-pose-title">位姿 = 位置 + 姿态</title>
<desc id="robot-pose-desc">同一个参考点位置，可以对应不同的三轴朝向；位置和姿态须分别说明。</desc>
<defs>
  <linearGradient id="robot-pose-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="robot-pose-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--accent)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--accent)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="robot-pose-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="robot-pose-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="440" fill="url(#robot-pose-bg)"/>
<rect x="0" y="0" width="900" height="440" fill="url(#robot-pose-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="440" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ROBOTICS · POSE / 02</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-02</text>
<text x="32" y="73" class="pl-title">位姿 = 位置 + 姿态</text>
<text x="32" y="96" class="pl-sub">同一个参考点位置，可以对应不同的三轴朝向；位置和姿态须分别说明。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<ellipse cx="440" cy="268" rx="105" ry="52" fill="var(--accent)" fill-opacity=".06" stroke="var(--accent)" stroke-opacity=".28"/><path d="M170 330 L430 255" fill="none" stroke="var(--atlas-cyan)" stroke-width="2.6" stroke-linecap="round" marker-end="url(#arrow-c)"/><text x="292.0" y="279.0" class="pl-small" style="fill:var(--atlas-cyan)" text-anchor="middle">o′：从 O 指向 O′</text><path d="M170 330 L270 360" fill="none" stroke="var(--fig-red)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-r)"/><text x="282.0" y="352.0" class="pl-mono" style="fill:var(--fig-red)" text-anchor="start">x</text><path d="M170 330 L100 365" fill="none" stroke="var(--fig-green)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-e)"/><text x="88.0" y="357.0" class="pl-mono" style="fill:var(--fig-green)" text-anchor="end">y</text><path d="M170 330 L170 230" fill="none" stroke="var(--accent)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-a)"/><text x="182.0" y="222.0" class="pl-mono" style="fill:var(--accent)" text-anchor="start">z</text><circle cx="170" cy="330" r="4" fill="var(--ink)"/><path d="M430 255 L360 290" fill="none" stroke="var(--fig-red)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-r)"/><text x="348.0" y="314.0" class="pl-mono" style="fill:var(--fig-red)" text-anchor="end">x′ = y</text><path d="M430 255 L330 225" fill="none" stroke="var(--fig-green)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-e)"/><text x="318.0" y="217.0" class="pl-mono" style="fill:var(--fig-green)" text-anchor="end">y′ = −x</text><path d="M430 255 L430 155" fill="none" stroke="var(--accent)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-a)"/><text x="442.0" y="147.0" class="pl-mono" style="fill:var(--accent)" text-anchor="start">z′ = z</text><circle cx="430" cy="255" r="4" fill="var(--ink)"/><text x="154.0" y="352.0" class="pl-mono">O</text><text x="442.0" y="274.0" class="pl-mono">O′</text><rect x="635" y="144" width="230" height="218" rx="12" fill="var(--paper)" stroke="var(--line)"/><text x="650.0" y="171.0" class="pl-small">姿态：绕参考 z 正转 90°</text><text x="650.0" y="196.0" class="pl-small">列依次为 x′、y′、z′</text><text x="686.0" y="229.0" class="pl-mono" text-anchor="middle">0</text><text x="742.0" y="229.0" class="pl-mono" text-anchor="middle">-1</text><text x="798.0" y="229.0" class="pl-mono" text-anchor="middle">0</text><text x="686.0" y="263.0" class="pl-mono" text-anchor="middle">1</text><text x="742.0" y="263.0" class="pl-mono" text-anchor="middle">0</text><text x="798.0" y="263.0" class="pl-mono" text-anchor="middle">0</text><text x="686.0" y="297.0" class="pl-mono" text-anchor="middle">0</text><text x="742.0" y="297.0" class="pl-mono" text-anchor="middle">0</text><text x="798.0" y="297.0" class="pl-mono" text-anchor="middle">1</text><text x="650.0" y="338.0" class="pl-small">方向余弦无量纲</text><text x="55.0" y="400.0" class="pl-small">先确定 O′ 在哪里，再确定三根本体轴的方向。</text><text x="55.0" y="424.0" class="pl-small">空间投影示意；屏幕上的夹角不等于实际三维夹角。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>蓝色箭头是位置向量 O→O′；两组三轴使用同一线性投影。此例本体 x′ 与参考 y 同向，y′ 与参考 x 反向，z′ 与参考 z 同向，右侧按列列出方向余弦。位置以长度计，方向余弦无量纲。自由刚体的位置与姿态各有三个局部独立变量；图的投影不用于量角。</figcaption>
</figure>
