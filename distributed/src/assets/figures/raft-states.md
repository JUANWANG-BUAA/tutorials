<figure class="fig-plate fig-wide" id="fig-raft-states">
<svg class="figure-svg" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="raft-states-title raft-states-desc">
<title id="raft-states-title">Raft 的三个角色与迁移条件</title>
<desc id="raft-states-desc">Follower 在选举超时后成为 Candidate；获得多数票成为 Leader；发现更高 term 退回 Follower。</desc>
<defs>
<marker id="raft-states-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="raft-states-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="raft-states-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="raft-states-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<pattern id="raft-states-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="400" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#raft-states-grid)"/>
<rect x="0" y="0" width="3" height="400" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">Raft 的三个角色与迁移条件</text>
<rect x="90" y="150" width="170" height="72" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="175.0" y="184.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower</text>
<text x="175.0" y="201.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">被动接收 AppendEntries</text>
<rect x="370" y="60" width="170" height="72" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="455.0" y="94.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Candidate</text>
<text x="455.0" y="111.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">term+1，拉票</text>
<rect x="370" y="250" width="170" height="72" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="455.0" y="284.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Leader</text>
<text x="455.0" y="301.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">心跳 + 复制</text>
<line x1="260" y1="170" x2="370" y2="110" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#raft-states-ar-gold)"/>
<text x="300" y="120" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">选举超时</text>
<line x1="455" y1="132" x2="455" y2="250" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#raft-states-ar-accent)"/>
<text x="505" y="195" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">获得多数票</text>
<line x1="370" y1="286" x2="260" y2="210" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#raft-states-ar-muted)"/>
<text x="300" y="270" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">发现更高 term</text>
<line x1="455" y1="250" x2="455" y2="132" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#raft-states-ar-gold)"/>
<text x="505" y="200" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">选举超时/平票</text>
<line x1="455" y1="60" x2="455" y2="36" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#raft-states-ar-muted)"/>
<text x="455" y="24" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">term 增大</text>
<line x1="370" y1="96" x2="260" y2="150" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#raft-states-ar-red)"/>
<text x="300" y="86" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">收到更高 term</text>
<text x="90" y="300" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">安全规则</text>
<text x="90" y="324" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">· 每个 term 最多投一票</text>
<text x="90" y="344" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">· 只给日志不旧于自己的候选人投票</text>
<text x="90" y="364" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">· 只提交当前 term 的日志项（旧 term 间接提交）</text>
</svg>
<figcaption><b>读图：</b>Raft 把「什么时候可以投票」「什么时候可以提交」绑定到 term 和日志新旧。图中每条边都对应一个必须检查的条件，少一个就会出现双主或丢日志。</figcaption>
</figure>
