<figure class="fig-plate fig-wide" id="fig-log-offsets">
<svg class="figure-svg" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="log-offsets-title log-offsets-desc">
<title id="log-offsets-title">日志、消费者 offset 与重复投递</title>
<desc id="log-offsets-desc">消息 0–7 按顺序写入；消费者处理到 5，但 offset 只提交到 4，崩溃后 5 被重投。</desc>
<defs>
<marker id="log-offsets-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="log-offsets-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="log-offsets-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="log-offsets-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<marker id="log-offsets-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="log-offsets-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="400" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#log-offsets-grid)"/>
<rect x="0" y="0" width="3" height="400" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">日志、消费者 offset 与重复投递</text>
<text x="60" y="70" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">分区日志（append-only）</text>
<rect x="80" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="121.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 0</text>
<text x="121.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 0</text>
<rect x="175" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="216.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 1</text>
<text x="216.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 1</text>
<rect x="270" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="311.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 2</text>
<text x="311.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 2</text>
<rect x="365" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="406.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 3</text>
<text x="406.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 3</text>
<rect x="460" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="501.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 4</text>
<text x="501.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 4</text>
<rect x="555" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="596.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 5</text>
<text x="596.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 5</text>
<rect x="650" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="691.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 6</text>
<text x="691.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 6</text>
<rect x="745" y="90" width="82" height="46" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="786.0" y="111.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 7</text>
<text x="786.0" y="128.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">offset 7</text>
<line x1="80" y1="160" x2="840" y2="160" stroke="var(--muted)" stroke-width="1.2"/>
<text x="80" y="182" fill="var(--sage)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">已提交 offset = 4</text>
<text x="560" y="182" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">已处理到 5，但提交前崩溃</text>
<line x1="560" y1="210" x2="560" y2="250" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#log-offsets-ar-gold)"/>
<text x="650" y="232" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">重启后从 5 重投</text>
<rect x="500" y="255" width="130" height="40" rx="6" fill="var(--paper)" stroke="var(--fig-red,#9c2b25)" stroke-width="1.4"/>
<text x="565.0" y="273.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">msg 5 再来一次</text>
<text x="565.0" y="290.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">副作用可能翻倍</text>
<text x="450" y="335" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">至少一次 = 允许重复；有效一次 = 业务去重 + 原子提交。</text>
</svg>
<figcaption><b>读图：</b>「处理成功」和「offset 提交成功」是两个动作；两者之间崩溃，就会重复。把业务写与 offset 放在同一个事务里，或者让消费幂等，才能把重复变成无害。</figcaption>
</figure>
