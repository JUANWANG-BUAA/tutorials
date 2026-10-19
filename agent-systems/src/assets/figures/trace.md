<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-trace" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-trace-title as-trace-desc">
<title id="as-trace-title">Agent trace 的瀑布视图与关键路径</title>
<desc id="as-trace-desc">横轴是时间，纵轴是调用栈。看三件事：哪一段最长（llm #2 与 tool #2）、哪一段是并行/串行、哪个 span 失败了（guard 拒绝出口）。trace 的价值不是「有记录」，而是能把一次失败定位到具体 span 的输入、输出与属性；如果 span 断链，回放就只能靠猜。</desc>
<defs>
  <linearGradient id="as-trace-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-trace-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-trace-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-trace-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="430" fill="url(#as-trace-bg)"/>
<rect x="0" y="0" width="900" height="430" fill="url(#as-trace-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="430" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">一条 agent trace：span 的父子、耗时与关键属性</text>
<line x1="230" y1="72" x2="860" y2="72" stroke="var(--line-strong)"/>
<line x1="230.0" y1="68" x2="230.0" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>
<text x="230.0" y="62" fill="var(--muted)" font-size="9" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">0ms</text>
<line x1="356.0" y1="68" x2="356.0" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>
<text x="356.0" y="62" fill="var(--muted)" font-size="9" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">500ms</text>
<line x1="482.0" y1="68" x2="482.0" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>
<text x="482.0" y="62" fill="var(--muted)" font-size="9" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">1000ms</text>
<line x1="608.0" y1="68" x2="608.0" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>
<text x="608.0" y="62" fill="var(--muted)" font-size="9" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">1500ms</text>
<line x1="734.0" y1="68" x2="734.0" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>
<text x="734.0" y="62" fill="var(--muted)" font-size="9" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">2000ms</text>
<line x1="860.0" y1="68" x2="860.0" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>
<text x="860.0" y="62" fill="var(--muted)" font-size="9" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">2500ms</text>
<text x="40" y="112" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">run</text>
<rect x="230.0" y="100" width="630.0" height="18" rx="2" fill="var(--accent)" fill-opacity=".16" stroke="var(--accent)" stroke-opacity=".6"/>
<text x="238.0" y="113" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">acme.support · 9 steps</text>
<text x="40" y="152" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">  llm #1</text>
<rect x="235.0" y="140" width="105.8" height="18" rx="2" fill="var(--muted)" fill-opacity=".16" stroke="var(--muted)" stroke-opacity=".6"/>
<text x="243.04" y="153" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">gpt · 1.2k in / 180 out</text>
<text x="40" y="192" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">  tool #1</text>
<rect x="343.4" y="180" width="65.5" height="18" rx="2" fill="var(--atlas-gold)" fill-opacity=".16" stroke="var(--atlas-gold)" stroke-opacity=".6"/>
<text x="351.4" y="193" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">search_orders · ok</text>
<text x="40" y="232" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">  llm #2</text>
<rect x="414.0" y="220" width="131.0" height="18" rx="2" fill="var(--muted)" fill-opacity=".16" stroke="var(--muted)" stroke-opacity=".6"/>
<text x="421.96000000000004" y="233" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">gpt · 2.9k in / 240 out</text>
<text x="40" y="272" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">  tool #2</text>
<rect x="550.0" y="260" width="153.7" height="18" rx="2" fill="var(--atlas-gold)" fill-opacity=".16" stroke="var(--atlas-gold)" stroke-opacity=".6"/>
<text x="558.04" y="273" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">refund · 1.8s · retry=0</text>
<text x="40" y="312" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">  guard</text>
<rect x="708.8" y="300" width="22.7" height="18" rx="2" fill="var(--atlas-cyan)" fill-opacity=".16" stroke="var(--atlas-cyan)" stroke-opacity=".6"/>
<text x="716.8" y="313" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">egress deny</text>
<text x="40" y="352" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">  llm #3</text>
<rect x="736.5" y="340" width="118.4" height="18" rx="2" fill="var(--muted)" fill-opacity=".16" stroke="var(--muted)" stroke-opacity=".6"/>
<text x="744.52" y="353" fill="var(--ink-2)" font-size="9.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">final answer</text>
<text x="40" y="398" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">关键路径：run 2.5s = llm 1.41s + tool 0.87s + guard 0.09s + 调度 0.13s</text>
<text x="40" y="418" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">每个 span 至少带：trace_id / span_id / parent_span_id / gen_ai.operation.name / status</text>
</svg>
</div>
<figcaption><b>读图：</b>横轴是时间，纵轴是调用栈。看三件事：哪一段最长（llm #2 与 tool #2）、哪一段是并行/串行、哪个 span 失败了（guard 拒绝出口）。trace 的价值不是「有记录」，而是能把一次失败定位到具体 span 的输入、输出与属性；如果 span 断链，回放就只能靠猜。</figcaption>
</figure>
