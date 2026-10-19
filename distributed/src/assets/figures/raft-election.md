<figure class="fig-plate fig-wide" id="fig-raft-election">
<svg class="figure-svg" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="raft-election-title raft-election-desc">
<title id="raft-election-title">一次 Raft 选举：term 1 平票，term 2 选出 leader</title>
<desc id="raft-election-desc">三个节点在 term 1 各自拉票导致平票；随机超时后节点 B 在 term 2 先发起并赢得多数。</desc>
<defs>
<marker id="raft-election-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="raft-election-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="raft-election-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="raft-election-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="raft-election-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="430" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="430" fill="url(#raft-election-grid)"/>
<rect x="0" y="0" width="3" height="430" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">一次 Raft 选举：term 1 平票，term 2 选出 leader</text>
<line x1="150" y1="80" x2="150" y2="380" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="150" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">节点 A</text>
<line x1="450" y1="80" x2="450" y2="380" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="450" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">节点 B</text>
<line x1="750" y1="80" x2="750" y2="380" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="750" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">节点 C</text>
<text x="450" y="60" fill="var(--fig-gold,#8a5a00)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">term 1：三方同时超时</text>
<line x1="150" y1="105" x2="450" y2="125" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#raft-election-ar-gold)"/>
<text x="300.0" y="112" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">RequestVote</text>
<line x1="450" y1="105" x2="150" y2="125" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#raft-election-ar-gold)"/>
<text x="450.0" y="112" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">RequestVote</text>
<line x1="750" y1="105" x2="450" y2="125" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#raft-election-ar-gold)"/>
<text x="600.0" y="112" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">RequestVote</text>
<text x="450" y="160" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">都没有拿到多数票 → 超时，term+1</text>
<text x="450" y="205" fill="var(--accent)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">term 2：B 先超时（随机 150–300 ms）</text>
<line x1="450" y1="225" x2="150" y2="245" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#raft-election-ar-accent)"/>
<text x="300" y="228" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">RequestVote(term=2)</text>
<line x1="450" y1="225" x2="750" y2="245" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#raft-election-ar-accent)"/>
<text x="600" y="228" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">RequestVote(term=2)</text>
<line x1="150" y1="265" x2="450" y2="285" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#raft-election-ar-sage)"/>
<text x="300" y="270" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">投票</text>
<line x1="750" y1="265" x2="450" y2="285" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#raft-election-ar-sage)"/>
<text x="600" y="270" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">投票</text>
<text x="450" y="315" fill="var(--fig-green,#1f6b3a)" font-size="11.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">B 获得 2/3 票 → Leader</text>
<line x1="450" y1="330" x2="150" y2="350" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#raft-election-ar-muted)"/>
<text x="300" y="335" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">AppendEntries(term=2)</text>
<line x1="450" y1="330" x2="750" y2="350" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#raft-election-ar-muted)"/>
<text x="600" y="335" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">AppendEntries(term=2)</text>
<text x="450" y="405" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">关键：每个节点在 term 2 只投一票；B 的日志必须不旧于投票者。</text>
</svg>
<figcaption><b>读图：</b>随机化选举超时是打破平票的关键；没有它，三个节点可能在同一时刻反复拉票，形成活锁。图中 term 2 的 B 先超时，所以它拿到了 A 和 C 的票。</figcaption>
</figure>
