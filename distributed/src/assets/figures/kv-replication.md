<figure class="fig-plate fig-wide" id="fig-kv-replication">
<svg class="figure-svg" viewBox="0 0 900 440" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="kv-replication-title kv-replication-desc">
<title id="kv-replication-title">三节点复制：日志、matchIndex 与 commitIndex</title>
<desc id="kv-replication-desc">leader 把日志复制到两个 follower；多数派 matchIndex 达到 3 后 commitIndex 推进到 3，状态机应用。</desc>
<defs>
<marker id="kv-replication-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="kv-replication-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="kv-replication-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="kv-replication-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="440" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="440" fill="url(#kv-replication-grid)"/>
<rect x="0" y="0" width="3" height="440" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">三节点复制：日志、matchIndex 与 commitIndex</text>
<rect x="50" y="90" width="150" height="52" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="125.0" y="114.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端</text>
<text x="125.0" y="131.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">put k=v</text>
<rect x="300" y="80" width="180" height="70" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="390.0" y="113.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Leader A</text>
<text x="390.0" y="130.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">term=2, commit=2</text>
<rect x="620" y="60" width="170" height="56" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="705.0" y="86.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower B</text>
<text x="705.0" y="103.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">match=2</text>
<rect x="620" y="150" width="170" height="56" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="705.0" y="176.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Follower C</text>
<text x="705.0" y="193.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">match=3</text>
<line x1="200" y1="116" x2="300" y2="116" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#kv-replication-ar-accent)"/>
<text x="250" y="106" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">append</text>
<line x1="480" y1="100" x2="620" y2="88" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#kv-replication-ar-accent)"/>
<text x="550" y="80" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">AppendEntries</text>
<line x1="480" y1="130" x2="620" y2="178" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#kv-replication-ar-accent)"/>
<text x="550" y="168" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">AppendEntries</text>
<line x1="620" y1="116" x2="480" y2="116" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#kv-replication-ar-muted)"/>
<text x="550" y="132" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">ack 2</text>
<line x1="620" y1="206" x2="480" y2="140" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#kv-replication-ar-sage)"/>
<text x="550" y="200" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">ack 3</text>
<text x="300" y="240" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">日志索引</text>
<rect x="300" y="255" width="58" height="36" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="329.0" y="271.0" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">1</text>
<text x="329.0" y="288.0" fill="var(--ink-2)" font-size="8" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">已提交</text>
<rect x="370" y="255" width="58" height="36" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="399.0" y="271.0" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">2</text>
<text x="399.0" y="288.0" fill="var(--ink-2)" font-size="8" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">已提交</text>
<rect x="440" y="255" width="58" height="36" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="469.0" y="271.0" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">3</text>
<text x="469.0" y="288.0" fill="var(--ink-2)" font-size="8" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">已提交</text>
<rect x="510" y="255" width="58" height="36" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="539.0" y="271.0" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">4</text>
<text x="539.0" y="288.0" fill="var(--ink-2)" font-size="8" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">未提交</text>
<text x="300" y="320" fill="var(--fig-green,#1f6b3a)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">commitIndex = 3：多数派（A、C）match ≥ 3</text>
<text x="300" y="345" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">状态机 apply 到 3；读请求至少等待 applied ≥ readIndex</text>
<text x="300" y="380" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">若 leader 崩溃：新 leader 必须包含 index 3 的日志（选举限制）。</text>
</svg>
<figcaption><b>读图：</b>提交不是「leader 写了」而是「多数派持久化了」。图中 follower B 只到 2，但 A+C 已到 3，所以 3 可以提交；如果 leader 在提交前崩溃，新 leader 必须带上已提交的日志。</figcaption>
</figure>
