<figure class="fig-plate fig-wide has-fig-scroll" id="fig-arm-endian" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="armend-title armend-desc">
<title id="armend-title">大小端：0x12345678 在四个字节单元里的两种排法</title>
<desc id="armend-desc">同一个 32 位字按小端与大端存入连续四个字节时的地址与内容对照。</desc>
<defs>
  <linearGradient id="armend-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <pattern id="armend-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
</defs>
<rect x="0" y="0" width="900" height="400" fill="url(#armend-bg)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#armend-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="400" style="fill:var(--accent)" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">ARM · ENDIANNESS / 02</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / R-05</text>
<text x="32" y="73" class="pl-title">同一个字，两种摆法</text>
<text x="32" y="96" class="pl-sub">0x12345678 存进 0x100 起的四个字节单元。</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
<text x="32" y="146" class="pl-mono" style="fill:var(--fig-blue)">小端 Little-endian</text>
<text x="32" y="166" class="pl-small">低字节放低地址 · 字节 0 接数据线 7–0</text>
<text x="700" y="146" class="pl-mono" style="fill:var(--fig-blue)" text-anchor="end">地址</text>
<rect x="32" y="178" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="120" y="204" class="pl-mono" text-anchor="middle">0x100</text>
<text x="120" y="228" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">0x78</text>
<rect x="216" y="178" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="304" y="204" class="pl-mono" text-anchor="middle">0x101</text>
<text x="304" y="228" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">0x56</text>
<rect x="400" y="178" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="488" y="204" class="pl-mono" text-anchor="middle">0x102</text>
<text x="488" y="228" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">0x34</text>
<rect x="584" y="178" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="672" y="204" class="pl-mono" text-anchor="middle">0x103</text>
<text x="672" y="228" class="pl-mono" text-anchor="middle" style="fill:var(--accent)">0x12</text>
<rect x="776" y="178" width="92" height="62" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="822" y="204" class="pl-note" text-anchor="middle">低位</text>
<text x="822" y="228" class="pl-note" text-anchor="middle">地址 ↑</text>
<text x="32" y="286" class="pl-mono" style="fill:var(--fig-plum)">大端 Big-endian</text>
<text x="32" y="306" class="pl-small">高字节放低地址 · 字节 0 接数据线 31–24</text>
<rect x="32" y="318" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="120" y="344" class="pl-mono" text-anchor="middle">0x100</text>
<text x="120" y="368" class="pl-mono" text-anchor="middle" style="fill:var(--fig-plum)">0x12</text>
<rect x="216" y="318" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="304" y="344" class="pl-mono" text-anchor="middle">0x101</text>
<text x="304" y="368" class="pl-mono" text-anchor="middle" style="fill:var(--fig-plum)">0x34</text>
<rect x="400" y="318" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="488" y="344" class="pl-mono" text-anchor="middle">0x102</text>
<text x="488" y="368" class="pl-mono" text-anchor="middle" style="fill:var(--fig-plum)">0x56</text>
<rect x="584" y="318" width="176" height="62" rx="8" fill="var(--paper)" stroke="var(--line)"/>
<text x="672" y="344" class="pl-mono" text-anchor="middle">0x103</text>
<text x="672" y="368" class="pl-mono" text-anchor="middle" style="fill:var(--fig-plum)">0x78</text>
<rect x="776" y="318" width="92" height="62" rx="8" fill="var(--paper-soft)" stroke="var(--line)"/>
<text x="822" y="344" class="pl-note" text-anchor="middle">低位</text>
<text x="822" y="368" class="pl-note" text-anchor="middle">地址 ↑</text>
</svg>
</div>
<figcaption><span class="fig-index">图解</span><b>读图：</b>小端是"低对低"——最低位字节放在最低地址，读出来像一串反着写的十六进制；大端是"高对高"，人眼友好。两端字节序不一致时，同一份数据会被读成完全不同的数（0x00000001 在对端变成 0x01000000），所以跨机传输要么统一约定、要么逐字节拼装。</figcaption>
</figure>
