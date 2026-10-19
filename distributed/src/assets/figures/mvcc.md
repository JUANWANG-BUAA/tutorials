<figure class="fig-plate fig-wide" id="fig-mvcc">
<svg class="figure-svg" viewBox="0 0 900 390" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="mvcc-title mvcc-desc">
<title id="mvcc-title">MVCC：读快照，写新版本</title>
<desc id="mvcc-desc">x 的版本链 0→1→2；事务 T1 的快照看到 1，T2 的快照看到 2，旧版本由 vacuum 回收。</desc>
<defs>
<marker id="mvcc-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="mvcc-ar-ink" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--ink)"/></marker>
<marker id="mvcc-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="mvcc-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="mvcc-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="390" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="390" fill="url(#mvcc-grid)"/>
<rect x="0" y="0" width="3" height="390" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">MVCC：读快照，写新版本</text>
<line x1="70" y1="190" x2="840" y2="190" stroke="var(--ink)" stroke-width="1.6"/>
<circle cx="140" cy="190" r="30" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.6"/>
<text x="140" y="194" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">v0</text>
<text x="140" y="240" fill="var(--ink)" font-size="12" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">x=0</text>
<text x="140" y="260" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">T0</text>
<circle cx="360" cy="190" r="30" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.6"/>
<text x="360" y="194" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">v1</text>
<text x="360" y="240" fill="var(--ink)" font-size="12" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">x=1</text>
<text x="360" y="260" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">T1 写</text>
<circle cx="600" cy="190" r="30" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.6"/>
<text x="600" y="194" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">v2</text>
<text x="600" y="240" fill="var(--ink)" font-size="12" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle">x=2</text>
<text x="600" y="260" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">T2 写</text>
<line x1="170" y1="190" x2="330" y2="190" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#mvcc-ar-muted)"/>
<line x1="390" y1="190" x2="570" y2="190" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#mvcc-ar-muted)"/>
<rect x="250" y="60" width="180" height="54" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="340.0" y="85.0" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">T1 快照</text>
<text x="340.0" y="102.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">可见 v1，不可见 v2</text>
<rect x="540" y="60" width="180" height="54" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="630.0" y="85.0" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">T2 快照</text>
<text x="630.0" y="102.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">可见 v2</text>
<line x1="340" y1="114" x2="360" y2="160" stroke="var(--accent)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#mvcc-ar-accent)"/>
<line x1="630" y1="114" x2="600" y2="160" stroke="var(--sage)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#mvcc-ar-sage)"/>
<text x="450" y="320" fill="var(--muted)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">旧版本保留到没有快照需要它；长事务 = vacuum 无法回收。</text>
<text x="450" y="345" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">写偏斜：两个事务各读一部分、各写另一部分，快照隔离下仍可能破坏不变量。</text>
</svg>
<figcaption><b>读图：</b>快照隔离下，读不阻塞写、写不阻塞读；代价是旧版本要保留，长事务会拖住回收。图中 T1 在 T2 提交后仍然读到 1，这不是 bug，而是快照的语义。</figcaption>
</figure>
