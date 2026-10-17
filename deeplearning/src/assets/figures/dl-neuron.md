<figure class="fig-plate fig-wide has-fig-scroll" id="fig-dl-neuron" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 442" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="dl-neuron-title dl-neuron-desc">
<title id="dl-neuron-title">一个神经元：加权、求和、再过一道门</title>
<desc id="dl-neuron-desc">y = φ(wᵀx + b)：线性组合负责「看什么」，激活函数负责「怎么响应」。</desc>
<defs>
  <linearGradient id="dl-neuron-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="dl-neuron-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".16"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="dl-neuron-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:var(--atlas-cyan)" stop-opacity=".10"/><stop offset="1" style="stop-color:var(--atlas-cyan)" stop-opacity="0"/>
  </radialGradient>
  <pattern id="dl-neuron-grid" width="26" height="26" patternUnits="userSpaceOnUse">
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
<rect x="0" y="0" width="900" height="442" fill="url(#dl-neuron-bg)"/>
<rect x="0" y="0" width="900" height="442" fill="url(#dl-neuron-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="442" style="fill:var(--atlas-cyan)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">DEEP LEARNING · NEURON / 18</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / D-18</text>
<text x="32" y="73" class="pl-title">一个神经元：加权、求和、再过一道门</text>
<text x="32" y="96" class="pl-sub">y = φ(wᵀx + b)：线性组合负责「看什么」，激活函数负责「怎么响应」。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<circle cx="120" cy="150" r="17" fill="var(--atlas-cyan)" fill-opacity=".08" stroke="var(--atlas-cyan)" stroke-opacity=".45"/><text x="120.0" y="154.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">x₁</text><circle cx="120" cy="200" r="17" fill="var(--atlas-cyan)" fill-opacity=".08" stroke="var(--atlas-cyan)" stroke-opacity=".45"/><text x="120.0" y="204.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">x₂</text><circle cx="120" cy="250" r="17" fill="var(--atlas-cyan)" fill-opacity=".08" stroke="var(--atlas-cyan)" stroke-opacity=".45"/><text x="120.0" y="254.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">x₃</text><circle cx="120" cy="300" r="17" fill="var(--atlas-cyan)" fill-opacity=".08" stroke="var(--atlas-cyan)" stroke-opacity=".45"/><text x="120.0" y="304.0" class="pl-mono" style="fill:var(--atlas-cyan)" text-anchor="middle">x₄</text><path d="M138 150 C 250 150, 300 224, 328 224" fill="none" stroke="var(--muted)" stroke-opacity=".2" stroke-width="1.2"/><text x="250.0" y="158.0" class="pl-mono" style="fill:var(--muted)" font-size="9.5">w1</text><path d="M138 200 C 250 200, 300 224, 328 224" fill="none" stroke="var(--muted)" stroke-opacity=".2" stroke-width="1.2"/><text x="250.0" y="208.0" class="pl-mono" style="fill:var(--muted)" font-size="9.5">w2</text><path d="M138 250 C 250 250, 300 224, 328 224" fill="none" stroke="var(--muted)" stroke-opacity=".2" stroke-width="1.2"/><text x="250.0" y="242.0" class="pl-mono" style="fill:var(--muted)" font-size="9.5">w3</text><path d="M138 300 C 250 300, 300 224, 328 224" fill="none" stroke="var(--muted)" stroke-opacity=".2" stroke-width="1.2"/><text x="250.0" y="292.0" class="pl-mono" style="fill:var(--muted)" font-size="9.5">w4</text><circle cx="384" cy="224" r="62" fill="var(--accent)" fill-opacity=".06" stroke="var(--accent)" stroke-opacity=".38" stroke-width="1.6"/><circle cx="384" cy="224" r="48" fill="var(--paper)" stroke="var(--accent)" stroke-opacity=".25" stroke-width="1.2"/><text x="384.0" y="226.0" class="pl-title" style="fill:var(--accent)" text-anchor="middle" font-size="36">Σ</text><text x="384.0" y="254.0" class="pl-small" text-anchor="middle">加权求和</text><text x="384.0" y="144.0" class="pl-mono" style="fill:var(--atlas-gold)" text-anchor="middle" font-size="10">b（偏置）</text><path d="M448 224 L516 224" fill="none" stroke="var(--accent)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-a)"/><rect x="520" y="182" width="108" height="84" rx="12" fill="var(--atlas-gold)" fill-opacity=".06" stroke="var(--atlas-gold)" stroke-opacity=".35"/><text x="574.0" y="220.0" class="pl-title" style="fill:var(--atlas-gold)" text-anchor="middle" font-size="24">φ(·)</text><text x="574.0" y="244.0" class="pl-small" text-anchor="middle">激活函数</text><path d="M630 224 L718 224" fill="none" stroke="var(--atlas-gold)" stroke-width="2" stroke-linecap="round" marker-end="url(#arrow-g)"/><circle cx="740" cy="224" r="24" fill="var(--fig-green)" fill-opacity=".07" stroke="var(--fig-green)" stroke-opacity=".4"/><text x="740.0" y="229.0" class="pl-title" style="fill:var(--fig-green)" text-anchor="middle" font-size="22">y</text><text x="740.0" y="272.0" class="pl-small" text-anchor="middle">输出</text><rect x="222" y="356" width="456" height="34" rx="10" fill="var(--accent)" fill-opacity=".06" stroke="var(--accent)" stroke-opacity=".22"/><text x="450.0" y="378.0" class="pl-mono" style="fill:var(--accent)" text-anchor="middle" font-size="12.5">y = φ( w₁x₁ + w₂x₂ + w₃x₃ + w₄x₄ + b )</text><text x="450.0" y="420.0" class="pl-note" text-anchor="middle">一个神经元 = 一次加权求和 + 一次非线性门控；堆起来就是网络。</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>左边是输入，中间是<b>加权求和</b>，右边是<b>激活</b>。没有 φ，堆多少层都等价于一次线性变换；有了 φ，网络才有能力逼近非线性函数。偏置 b 让超平面可以平移。</figcaption>
</figure>
