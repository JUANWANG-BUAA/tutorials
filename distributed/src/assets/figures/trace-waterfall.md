<figure class="fig-plate fig-wide" id="fig-trace-waterfall">
<svg class="figure-svg" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="trace-waterfall-title trace-waterfall-desc">
<title id="trace-waterfall-title">Trace 瀑布：一次请求的 span 与重复 span</title>
<desc id="trace-waterfall-desc">根 span 1 s；下游 A 240 ms，B 380 ms；一次重试产生第二个 B span，总耗时被拉长。</desc>
<defs>
<marker id="trace-waterfall-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="trace-waterfall-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<pattern id="trace-waterfall-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="420" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#trace-waterfall-grid)"/>
<rect x="0" y="0" width="3" height="420" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">Trace 瀑布：一次请求的 span 与重复 span</text>
<line x1="180" y1="80" x2="180" y2="380" stroke="var(--muted)" stroke-width="1"/>
<line x1="860" y1="80" x2="860" y2="380" stroke="var(--muted)" stroke-width="1"/>
<text x="180" y="66" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">0 ms</text>
<text x="860" y="66" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">1000 ms</text>
<text x="170" y="114" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="end">root  POST /tool</text>
<rect x="180.0" y="100" width="680.0" height="20" fill="var(--accent)" fill-opacity=".22" stroke="var(--accent)"/>
<text x="170" y="156" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="end">edge  auth/limit</text>
<rect x="200.4" y="142" width="61.2" height="20" fill="var(--sage)" fill-opacity=".22" stroke="var(--sage)"/>
<text x="170" y="198" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="end">A     rpc</text>
<rect x="282.0" y="184" width="163.2" height="20" fill="var(--fig-blue,#2456a6)" fill-opacity=".22" stroke="var(--fig-blue,#2456a6)"/>
<text x="170" y="240" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="end">B     rpc (attempt=1)</text>
<rect x="329.6" y="226" width="258.4" height="20" fill="var(--fig-purple,#4c3d99)" fill-opacity=".22" stroke="var(--fig-purple,#4c3d99)"/>
<text x="170" y="282" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="end">B     rpc (attempt=2)</text>
<rect x="622.0" y="268" width="170.0" height="20" fill="var(--fig-red,#9c2b25)" fill-opacity=".22" stroke="var(--fig-red,#9c2b25)"/>
<text x="170" y="324" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="end">DB    commit</text>
<rect x="656.0" y="310" width="81.6" height="20" fill="var(--fig-gold,#8a5a00)" fill-opacity=".22" stroke="var(--fig-gold,#8a5a00)"/>
<text x="450" y="390" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重复 span 必须带 attempt/retry 标记，否则会被当成两次独立调用。</text>
</svg>
<figcaption><b>读图：</b>trace 的价值是显示「时间花在哪」，不是「有没有报错」。重复 span 如果不标 attempt，会被误读成两个独立下游调用；指标也会把重试算成额外流量。</figcaption>
</figure>
