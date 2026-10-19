<figure class="fig-plate fig-wide" id="fig-retry-budget">
<svg class="figure-svg" viewBox="0 0 900 410" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="retry-budget-title retry-budget-desc">
<title id="retry-budget-title">重试预算：次数不是策略，放大倍数才是</title>
<desc id="retry-budget-desc">单层 3 次重试乘以两层就是 16 次尝试；带预算与抖动的重试把放大控制在可接受范围。</desc>
<defs>
<marker id="retry-budget-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="retry-budget-ar-blue" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-blue,#2456a6)"/></marker>
<marker id="retry-budget-ar-ink" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--ink)"/></marker>
<marker id="retry-budget-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="retry-budget-ar-purple" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-purple,#4c3d99)"/></marker>
<marker id="retry-budget-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<marker id="retry-budget-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="retry-budget-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="410" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="410" fill="url(#retry-budget-grid)"/>
<rect x="0" y="0" width="3" height="410" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">重试预算：次数不是策略，放大倍数才是</text>
<line x1="60" y1="330" x2="850" y2="330" stroke="var(--ink)" stroke-width="1.2"/>
<line x1="60" y1="326" x2="60" y2="336" stroke="var(--muted)" stroke-width="1.2"/>
<text x="60" y="352" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">0s</text>
<line x1="108" y1="326" x2="108" y2="336" stroke="var(--muted)" stroke-width="1.2"/>
<text x="108" y="352" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">1s</text>
<line x1="204" y1="326" x2="204" y2="336" stroke="var(--muted)" stroke-width="1.2"/>
<text x="204" y="352" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">3s</text>
<line x1="396" y1="326" x2="396" y2="336" stroke="var(--muted)" stroke-width="1.2"/>
<text x="396" y="352" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">7s</text>
<line x1="780" y1="326" x2="780" y2="336" stroke="var(--muted)" stroke-width="1.2"/>
<text x="780" y="352" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">15s</text>
<text x="60" y="372" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">时间轴（指数退避 + 抖动，单位 s）</text>
<line x1="60" y1="250" x2="60" y2="326" stroke="var(--accent)" stroke-width="1.4" stroke-dasharray="5 5"/>
<circle cx="60" cy="242" r="13" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.6"/>
<text x="60" y="246" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">1</text>
<text x="60" y="218" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">首次</text>
<line x1="108" y1="250" x2="108" y2="326" stroke="var(--sage)" stroke-width="1.4" stroke-dasharray="5 5"/>
<circle cx="108" cy="242" r="13" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.6"/>
<text x="108" y="246" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">2</text>
<text x="108" y="218" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重试1</text>
<line x1="204" y1="250" x2="204" y2="326" stroke="var(--fig-blue,#2456a6)" stroke-width="1.4" stroke-dasharray="5 5"/>
<circle cx="204" cy="242" r="13" fill="var(--paper)" stroke="var(--fig-blue,#2456a6)" stroke-width="1.6"/>
<text x="204" y="246" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">3</text>
<text x="204" y="218" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重试2</text>
<line x1="396" y1="250" x2="396" y2="326" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.4" stroke-dasharray="5 5"/>
<circle cx="396" cy="242" r="13" fill="var(--paper)" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.6"/>
<text x="396" y="246" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">4</text>
<text x="396" y="218" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重试3</text>
<rect x="560" y="70" width="280" height="100" rx="6" fill="var(--paper)" stroke="var(--fig-red,#9c2b25)" stroke-width="1.4"/>
<text x="700.0" y="118.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">最坏放大</text>
<text x="700.0" y="135.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">4 次尝试/层 × 2 层 = 16</text>
<text x="700" y="200" fill="var(--fig-red,#9c2b25)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">若每层都重试 3 次</text>
<text x="700" y="222" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">原始 1 个请求 → 最多 16 个</text>
<rect x="560" y="240" width="280" height="62" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="700.0" y="269.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">带预算</text>
<text x="700.0" y="286.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重试 ≤ 原始请求的 10%</text>
<text x="700" y="318" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">预算耗尽后返回 503 + Retry-After</text>
<text x="260" y="160" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">退避 + 抖动把重试摊开；预算限制总量。</text>
<text x="260" y="182" fill="var(--muted)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">没有预算，重试会把下游的慢变成雪崩。</text>
</svg>
<figcaption><b>读图：</b>指数退避只能减少同一时刻的并发，不能消除总放大。真正要限制的是「重试请求 / 原始请求」的比值；预算耗尽后应快速失败，而不是继续排队。</figcaption>
</figure>
