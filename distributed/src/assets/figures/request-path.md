<figure class="fig-plate fig-wide" id="fig-request-path">
<svg class="figure-svg" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="request-path-title request-path-desc">
<title id="request-path-title">一次工具调用的路径与延迟预算</title>
<desc id="request-path-desc">客户端经过接入层到服务 A、服务 B，再访问存储；下方是各段延迟占总预算的比例。</desc>
<defs>
<marker id="request-path-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="request-path-ar-blue" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-blue,#2456a6)"/></marker>
<marker id="request-path-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="request-path-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="request-path-ar-purple" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-purple,#4c3d99)"/></marker>
<marker id="request-path-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="request-path-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="430" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="430" fill="url(#request-path-grid)"/>
<rect x="0" y="0" width="3" height="430" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">一次工具调用的路径与延迟预算</text>
<rect x="30" y="92" width="145" height="62" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="102.5" y="121.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端</text>
<text x="102.5" y="138.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重试 / 超时 / 幂等键</text>
<rect x="225" y="82" width="155" height="82" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="302.5" y="121.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">接入层</text>
<text x="302.5" y="138.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">鉴权 / 限流 / 路由</text>
<rect x="430" y="82" width="150" height="82" rx="6" fill="var(--paper)" stroke="var(--fig-blue,#2456a6)" stroke-width="1.4"/>
<text x="505.0" y="121.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">服务 A</text>
<text x="505.0" y="138.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">RPC / 事务边界</text>
<rect x="630" y="82" width="150" height="82" rx="6" fill="var(--paper)" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.4"/>
<text x="705.0" y="121.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">服务 B</text>
<text x="705.0" y="138.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">幂等 / 背压</text>
<rect x="630" y="240" width="150" height="66" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="705.0" y="271.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">存储</text>
<text x="705.0" y="288.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">日志 / MVCC</text>
<line x1="175" y1="123" x2="225" y2="123" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#request-path-ar-accent)"/>
<text x="200" y="113" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">1–3 ms</text>
<line x1="380" y1="123" x2="430" y2="123" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#request-path-ar-sage)"/>
<text x="405" y="113" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">2–8 ms</text>
<line x1="580" y1="123" x2="630" y2="123" stroke="var(--fig-blue,#2456a6)" stroke-width="1.7" marker-end="url(#request-path-ar-blue)"/>
<text x="605" y="113" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">5–50 ms</text>
<line x1="705" y1="164" x2="705" y2="240" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#request-path-ar-gold)"/>
<text x="748" y="205" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">1–10 ms</text>
<text x="430" y="205" fill="var(--muted)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">每一跳都可能排队；超时预算按跳分配，不按「服务」平均分。</text>
<text x="30" y="292" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">1 s 预算怎么花（示例）</text>
<rect x="30" y="320" width="48.0" height="26" fill="var(--accent)" fill-opacity=".16" stroke="var(--accent)"/>
<line x1="30" y1="346" x2="78.0" y2="346" stroke="var(--accent)" stroke-width="1.5"/>
<rect x="78.0" y="320" width="36.0" height="26" fill="var(--sage)" fill-opacity=".16" stroke="var(--sage)"/>
<line x1="78.0" y1="346" x2="114.0" y2="346" stroke="var(--sage)" stroke-width="1.5"/>
<rect x="114.0" y="320" width="144.0" height="26" fill="var(--fig-blue,#2456a6)" fill-opacity=".16" stroke="var(--fig-blue,#2456a6)"/>
<text x="186.0" y="337" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">240</text>
<line x1="114.0" y1="346" x2="258.0" y2="346" stroke="var(--fig-blue,#2456a6)" stroke-width="1.5"/>
<rect x="258.0" y="320" width="228.0" height="26" fill="var(--fig-purple,#4c3d99)" fill-opacity=".16" stroke="var(--fig-purple,#4c3d99)"/>
<text x="372.0" y="337" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">380</text>
<line x1="258.0" y1="346" x2="486.0" y2="346" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.5"/>
<rect x="486.0" y="320" width="96.0" height="26" fill="var(--fig-gold,#8a5a00)" fill-opacity=".16" stroke="var(--fig-gold,#8a5a00)"/>
<text x="534.0" y="337" fill="var(--ink-2)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">160</text>
<line x1="486.0" y1="346" x2="582.0" y2="346" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.5"/>
<rect x="582.0" y="320" width="48.0" height="26" fill="var(--muted)" fill-opacity=".16" stroke="var(--muted)"/>
<line x1="582.0" y1="346" x2="630.0" y2="346" stroke="var(--muted)" stroke-width="1.5"/>
<text x="30" y="370" fill="var(--muted)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">每条都按 1 s 总预算切；任何一段超时，整条链路应尽快失败，而不是等满 1 s。</text>
</svg>
<figcaption><b>读图：</b>一次调用不是一个「服务」，而是一串 hop。真正的 p99 往往由最慢的那一跳决定；把预算按 hop 切开，才能知道该给谁设更短的 deadline。</figcaption>
</figure>
