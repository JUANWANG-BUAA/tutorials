<figure class="fig-plate fig-wide has-fig-scroll" id="fig-robot-system" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 368" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="robot-system-title robot-system-desc">
<title id="robot-system-title">一个机器人系统，一条闭环</title>
<desc id="robot-system-desc">机械本体把电变成运动，传感器把运动变成可观测的量，控制器再把误差闭合回目标。</desc>
<defs>
  <linearGradient id="robot-system-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="robot-system-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--accent)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--accent)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="robot-system-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="robot-system-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="368" fill="url(#robot-system-bg)"/>
<rect x="0" y="0" width="900" height="368" fill="url(#robot-system-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="368" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ROBOTICS · SYSTEM ANATOMY / 01</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-01</text>
<text x="32" y="73" class="pl-title">一个机器人系统，一条闭环</text>
<text x="32" y="96" class="pl-sub">机械本体把电变成运动，传感器把运动变成可观测的量，控制器再把误差闭合回目标。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<g><rect x="34" y="170" width="146" height="88" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-cyan)" stroke-opacity=".28"/><rect x="34" y="183" width="4" height="62" rx="2" fill="var(--atlas-cyan)" fill-opacity=".75"/><text x="52.0" y="195.0" class="pl-mono" style="fill:var(--atlas-cyan)" opacity="0.85">01</text><circle cx="158" cy="192" r="4" fill="var(--atlas-cyan)"/><circle cx="158" cy="192" r="9" fill="none" stroke="var(--atlas-cyan)" stroke-opacity=".25"/><text x="52.0" y="220.0" class="pl-node-title">感知</text><text x="52.0" y="240.0" class="pl-node-sub">编码器 · 力 / 视觉</text></g><path d="M182 214.0 L196 214.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="199" y="170" width="146" height="88" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--accent)" stroke-opacity=".28"/><rect x="199" y="183" width="4" height="62" rx="2" fill="var(--accent)" fill-opacity=".75"/><text x="217.0" y="195.0" class="pl-mono" style="fill:var(--accent)" opacity="0.85">02</text><circle cx="323" cy="192" r="4" fill="var(--accent)"/><circle cx="323" cy="192" r="9" fill="none" stroke="var(--accent)" stroke-opacity=".25"/><text x="217.0" y="220.0" class="pl-node-title">规划</text><text x="217.0" y="240.0" class="pl-node-sub">路径 · 轨迹 · 抓取</text></g><path d="M347 214.0 L361 214.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="364" y="170" width="146" height="88" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-plum)" stroke-opacity=".28"/><rect x="364" y="183" width="4" height="62" rx="2" fill="var(--atlas-plum)" fill-opacity=".75"/><text x="382.0" y="195.0" class="pl-mono" style="fill:var(--atlas-plum)" opacity="0.85">03</text><circle cx="488" cy="192" r="4" fill="var(--atlas-plum)"/><circle cx="488" cy="192" r="9" fill="none" stroke="var(--atlas-plum)" stroke-opacity=".25"/><text x="382.0" y="220.0" class="pl-node-title">控制</text><text x="382.0" y="240.0" class="pl-node-sub">PID · 计算力矩</text></g><path d="M512 214.0 L526 214.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="529" y="170" width="146" height="88" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--fig-green)" stroke-opacity=".28"/><rect x="529" y="183" width="4" height="62" rx="2" fill="var(--fig-green)" fill-opacity=".75"/><text x="547.0" y="195.0" class="pl-mono" style="fill:var(--fig-green)" opacity="0.85">04</text><circle cx="653" cy="192" r="4" fill="var(--fig-green)"/><circle cx="653" cy="192" r="9" fill="none" stroke="var(--fig-green)" stroke-opacity=".25"/><text x="547.0" y="220.0" class="pl-node-title">执行</text><text x="547.0" y="240.0" class="pl-node-sub">电机 · 减速器</text></g><path d="M677 214.0 L691 214.0" fill="none" stroke="var(--muted)" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arrow-m)"/><g><rect x="694" y="170" width="146" height="88" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="var(--atlas-gold)" stroke-opacity=".28"/><rect x="694" y="183" width="4" height="62" rx="2" fill="var(--atlas-gold)" fill-opacity=".75"/><text x="712.0" y="195.0" class="pl-mono" style="fill:var(--atlas-gold)" opacity="0.85">05</text><circle cx="818" cy="192" r="4" fill="var(--atlas-gold)"/><circle cx="818" cy="192" r="9" fill="none" stroke="var(--atlas-gold)" stroke-opacity=".25"/><text x="712.0" y="220.0" class="pl-node-title">机械本体</text><text x="712.0" y="240.0" class="pl-node-sub">连杆 · 关节 · 末端</text></g><g><rect x="360.0" y="132.0" width="124.0" height="24" rx="12.0" fill="var(--accent)" fill-opacity=".08" stroke="var(--accent)" stroke-opacity=".28"/><text x="422.0" y="147.8" class="pl-mono" style="fill:var(--accent)" text-anchor="middle">目标 → 指令</text></g><path d="M767.0 262 Q450 330 107.0 262" fill="none" stroke="var(--atlas-cyan)" stroke-width="1.8" stroke-linecap="round" marker-end="url(#arrow-c)"/><text x="450.0" y="326.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">传感器反馈：位置 · 速度 · 力</text><text x="450.0" y="350.0" class="pl-note" text-anchor="middle">控制比较目标与反馈，再发出命令。</text><text x="450.0" y="116.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" opacity="0.75">SENSE → THINK → ACT</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>上排是信息与能量的前进方向：<b>感知 → 规划 → 控制 → 执行 → 机械本体</b>；下方青色回路是反馈。规划回答「去哪里」，控制回答「怎么去」，执行回答「用什么去」，机械本体决定「能去到哪里」。<b>闭环</b>才是机器人区别于普通机械的关键。</figcaption>
</figure>
