<figure class="fig-plate fig-wide" id="fig-fencing">
<svg class="figure-svg" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fencing-title fencing-desc">
<title id="fencing-title">租约过期与 fencing token</title>
<desc id="fencing-desc">客户端 A 在 GC 停顿时租约过期；B 获得 fence=2；A 恢复后带 fence=1 的写被资源拒绝。</desc>
<defs>
<marker id="fencing-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="fencing-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="fencing-ar-green" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-green,#1f6b3a)"/></marker>
<marker id="fencing-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="fencing-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<marker id="fencing-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="fencing-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="400" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#fencing-grid)"/>
<rect x="0" y="0" width="3" height="400" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">租约过期与 fencing token</text>
<line x1="150" y1="80" x2="150" y2="360" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="150" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端 A</text>
<line x1="450" y1="80" x2="450" y2="360" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="450" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">锁服务</text>
<line x1="750" y1="80" x2="750" y2="360" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="750" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">资源端</text>
<line x1="150" y1="110" x2="450" y2="110" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#fencing-ar-accent)"/>
<text x="300" y="100" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">acquire → lease=30s, fence=1</text>
<rect x="200" y="130" width="120" height="34" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="260.0" y="145.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">A 暂停（GC）</text>
<text x="260.0" y="162.0" fill="var(--ink-2)" font-size="9" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">租约继续走</text>
<line x1="450" y1="190" x2="150" y2="190" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" marker-end="url(#fencing-ar-red)"/>
<text x="300" y="180" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">租约到期</text>
<line x1="450" y1="220" x2="750" y2="220" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#fencing-ar-sage)"/>
<text x="600" y="210" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">B acquire → fence=2</text>
<line x1="750" y1="250" x2="750" y2="280" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.7" marker-end="url(#fencing-ar-green)"/>
<text x="810" y="268" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">接受 fence=2</text>
<line x1="150" y1="290" x2="750" y2="290" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" marker-end="url(#fencing-ar-red)"/>
<text x="450" y="280" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">A 恢复：write(fence=1)</text>
<text x="750" y="315" fill="var(--fig-red,#9c2b25)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">拒绝：1 &lt; 2</text>
<text x="450" y="380" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">锁的正确性不只在锁服务，还在被保护资源是否校验 token。</text>
</svg>
<figcaption><b>读图：</b>加长 TTL 不能解决停顿，只能降低概率；真正的解法是资源端记住见过的最大 token，拒绝所有更小的 token。锁服务只负责发号，资源端负责执行。</figcaption>
</figure>
