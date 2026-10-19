<figure class="fig-plate fig-wide" id="fig-replication-topologies">
<svg class="figure-svg" viewBox="0 0 900 440" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="replication-topologies-title replication-topologies-desc">
<title id="replication-topologies-title">三种复制拓扑：主从、多主、无主</title>
<desc id="replication-topologies-desc">左：单主写、多个从读；中：两个主都能写；右：任意副本读写，靠 quorum 相交。</desc>
<defs>
<marker id="replication-topologies-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="replication-topologies-ar-blue" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-blue,#2456a6)"/></marker>
<marker id="replication-topologies-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="replication-topologies-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="replication-topologies-ar-purple" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-purple,#4c3d99)"/></marker>
<marker id="replication-topologies-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="replication-topologies-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="440" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="440" fill="url(#replication-topologies-grid)"/>
<rect x="0" y="0" width="3" height="440" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">三种复制拓扑：主从、多主、无主</text>
<text x="150" y="58" fill="var(--accent)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">单主（single-leader）</text>
<rect x="90" y="80" width="120" height="48" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="150.0" y="102.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Leader</text>
<text x="150.0" y="119.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">读写</text>
<rect x="40" y="190" width="100" height="44" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="90.0" y="210.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower</text>
<text x="90.0" y="227.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">只读</text>
<rect x="160" y="190" width="100" height="44" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="210.0" y="210.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower</text>
<text x="210.0" y="227.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">只读</text>
<line x1="130" y1="128" x2="90" y2="190" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-accent)"/>
<text x="90" y="158" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">复制</text>
<line x1="170" y1="128" x2="210" y2="190" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-accent)"/>
<text x="220" y="158" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">复制</text>
<text x="150" y="270" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">写只有一条路；切换时选主</text>
<text x="450" y="58" fill="var(--fig-blue,#2456a6)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">多主（multi-leader）</text>
<rect x="340" y="80" width="110" height="48" rx="6" fill="var(--paper)" stroke="var(--fig-blue,#2456a6)" stroke-width="1.4"/>
<text x="395.0" y="102.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Leader A</text>
<text x="395.0" y="119.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">本地写</text>
<rect x="470" y="80" width="110" height="48" rx="6" fill="var(--paper)" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.4"/>
<text x="525.0" y="102.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Leader B</text>
<text x="525.0" y="119.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">本地写</text>
<line x1="450" y1="104" x2="470" y2="104" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-gold)" marker-start="url(#replication-topologies-ar-gold)"/>
<rect x="380" y="190" width="160" height="44" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="460.0" y="210.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower / 合并</text>
<text x="460.0" y="227.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">冲突解决</text>
<line x1="395" y1="128" x2="430" y2="190" stroke="var(--fig-blue,#2456a6)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-blue)"/>
<text x="390" y="160" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">复制</text>
<line x1="505" y1="128" x2="490" y2="190" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-purple)"/>
<text x="530" y="160" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">复制</text>
<text x="450" y="270" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">两个主都能写；冲突必须可解</text>
<text x="750" y="58" fill="var(--sage)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">无主（leaderless）</text>
<circle cx="700" cy="80" r="24" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.6"/>
<text x="700" y="84" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">N1</text>
<circle cx="820" cy="80" r="24" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.6"/>
<text x="820" y="84" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">N2</text>
<circle cx="760" cy="160" r="24" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.6"/>
<text x="760" y="164" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">N3</text>
<line x1="724" y1="80" x2="796" y2="80" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-sage)" marker-start="url(#replication-topologies-ar-sage)"/>
<text x="760" y="66" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">写/读</text>
<line x1="712" y1="102" x2="748" y2="140" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-sage)" marker-start="url(#replication-topologies-ar-sage)"/>
<line x1="808" y1="102" x2="772" y2="140" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#replication-topologies-ar-sage)" marker-start="url(#replication-topologies-ar-sage)"/>
<text x="750" y="230" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">R + W &gt; N；读修复/反熵</text>
<text x="450" y="330" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">选择依据：写延迟、RPO/RTO、冲突容忍度、运维复杂度。</text>
<line x1="290" y1="40" x2="290" y2="300" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="5 5"/>
<line x1="600" y1="40" x2="600" y2="300" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="5 5"/>
</svg>
<figcaption><b>读图：</b>拓扑不是「先进程度」排序，而是三种不同的取舍：单主简单但有切换窗口；多主写延迟低但冲突要解决；无主可用性高但读需要 quorum 与修复。</figcaption>
</figure>
