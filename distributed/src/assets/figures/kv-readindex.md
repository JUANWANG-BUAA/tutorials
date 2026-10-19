<figure class="fig-plate fig-wide" id="fig-kv-readindex">
<svg class="figure-svg" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="kv-readindex-title kv-readindex-desc">
<title id="kv-readindex-title">ReadIndex：线性一致读为什么要一次心跳</title>
<desc id="kv-readindex-desc">leader 记录当前 commitIndex 作为 readIndex，向多数派确认自己仍是 leader，再等 applied ≥ readIndex。</desc>
<defs>
<marker id="kv-readindex-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="kv-readindex-ar-blue" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-blue,#2456a6)"/></marker>
<marker id="kv-readindex-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="kv-readindex-ar-green" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-green,#1f6b3a)"/></marker>
<marker id="kv-readindex-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="kv-readindex-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="kv-readindex-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="400" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#kv-readindex-grid)"/>
<rect x="0" y="0" width="3" height="400" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">ReadIndex：线性一致读为什么要一次心跳</text>
<line x1="120" y1="80" x2="120" y2="350" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="120" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端</text>
<line x1="400" y1="80" x2="400" y2="350" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="400" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Leader</text>
<line x1="700" y1="80" x2="700" y2="350" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="700" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower 多数派</text>
<line x1="120" y1="110" x2="400" y2="110" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#kv-readindex-ar-accent)"/>
<text x="260" y="100" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">GET k (linearizable)</text>
<line x1="400" y1="140" x2="700" y2="140" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#kv-readindex-ar-gold)"/>
<text x="550" y="130" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">heartbeat（确认 leadership）</text>
<line x1="700" y1="170" x2="400" y2="170" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#kv-readindex-ar-sage)"/>
<text x="550" y="160" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">ack（多数派）</text>
<rect x="330" y="190" width="140" height="44" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="400.0" y="210.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">readIndex = commit</text>
<text x="400.0" y="227.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">记录当前提交位置</text>
<line x1="400" y1="240" x2="400" y2="280" stroke="var(--fig-blue,#2456a6)" stroke-width="1.7" marker-end="url(#kv-readindex-ar-blue)"/>
<text x="520" y="260" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">等待 applied ≥ readIndex</text>
<line x1="400" y1="300" x2="120" y2="320" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.7" marker-end="url(#kv-readindex-ar-green)"/>
<text x="260" y="310" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">返回 200 + value</text>
<text x="700" y="230" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">若心跳拿不到多数派</text>
<text x="700" y="250" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">→ 拒绝读，不返回旧值</text>
<text x="450" y="385" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">lease read 省掉心跳，但依赖时钟；ReadIndex 不依赖时钟，代价是多一次 RTT。</text>
</svg>
<figcaption><b>读图：</b>如果 leader 已经被分区隔离，它本地仍有数据，直接读会返回旧值。ReadIndex 的心跳确认「多数派还认我」，然后再等状态机追上；两步缺一不可。</figcaption>
</figure>
