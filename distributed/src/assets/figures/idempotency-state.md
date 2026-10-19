<figure class="fig-plate fig-wide" id="fig-idempotency-state">
<svg class="figure-svg" viewBox="0 0 900 410" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="idempotency-state-title idempotency-state-desc">
<title id="idempotency-state-title">幂等记录：同一把钥匙只能产生一次副作用</title>
<desc id="idempotency-state-desc">新键创建记录；执行中持有租约；成功后同键请求直接返回结果；失败可重试；租约过期可被接管。</desc>
<defs>
<marker id="idempotency-state-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="idempotency-state-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="idempotency-state-ar-green" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-green,#1f6b3a)"/></marker>
<marker id="idempotency-state-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="idempotency-state-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<marker id="idempotency-state-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="idempotency-state-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="410" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="410" fill="url(#idempotency-state-grid)"/>
<rect x="0" y="0" width="3" height="410" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">幂等记录：同一把钥匙只能产生一次副作用</text>
<rect x="40" y="160" width="150" height="64" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="115.0" y="190.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">new</text>
<text x="115.0" y="207.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">键不存在</text>
<rect x="250" y="160" width="160" height="64" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="330.0" y="190.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">in_progress</text>
<text x="330.0" y="207.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">lease_until 未到</text>
<rect x="480" y="60" width="160" height="60" rx="6" fill="var(--paper)" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.4"/>
<text x="560.0" y="88.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">succeeded</text>
<text x="560.0" y="105.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">结果 + effect_id</text>
<rect x="480" y="260" width="160" height="60" rx="6" fill="var(--paper)" stroke="var(--fig-red,#9c2b25)" stroke-width="1.4"/>
<text x="560.0" y="288.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">failed</text>
<text x="560.0" y="305.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">可重试/不可重试</text>
<rect x="250" y="320" width="160" height="56" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4" stroke-dasharray="6 5"/>
<text x="330.0" y="346.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">expired</text>
<text x="330.0" y="363.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">租约到期，可接管</text>
<line x1="190" y1="192" x2="250" y2="192" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#idempotency-state-ar-accent)"/>
<text x="220" y="182" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">begin</text>
<line x1="410" y1="176" x2="480" y2="100" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.7" marker-end="url(#idempotency-state-ar-green)"/>
<text x="455" y="120" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">commit</text>
<line x1="410" y1="208" x2="480" y2="270" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" marker-end="url(#idempotency-state-ar-red)"/>
<text x="455" y="250" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">error</text>
<line x1="330" y1="224" x2="330" y2="320" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#idempotency-state-ar-gold)"/>
<text x="380" y="280" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">lease 超时</text>
<line x1="330" y1="320" x2="330" y2="224" stroke="var(--muted)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#idempotency-state-ar-muted)"/>
<text x="270" y="280" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">同键重试接管</text>
<line x1="480" y1="90" x2="620" y2="150" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#idempotency-state-ar-sage)"/>
<text x="560" y="110" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">同键请求</text>
<line x1="620" y1="150" x2="620" y2="250" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#idempotency-state-ar-sage)"/>
<text x="650" y="160" fill="var(--sage)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">返回原结果</text>
<text x="650" y="182" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">attempts 不增加</text>
<text x="650" y="280" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">参数不同 → 409</text>
<text x="450" y="392" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">键相同 + 指纹不同 = 客户端 bug，必须拒绝，不能覆盖。</text>
</svg>
<figcaption><b>读图：</b>幂等表不是「缓存响应」，而是一台状态机：键、指纹、状态、租约、结果、副作用 ID 缺一不可。只有状态机才能同时处理并发重复、崩溃恢复和参数冲突。</figcaption>
</figure>
