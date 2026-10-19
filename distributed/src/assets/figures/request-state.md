<figure class="fig-plate fig-wide" id="fig-request-state">
<svg class="figure-svg" viewBox="0 0 900 390" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="request-state-title request-state-desc">
<title id="request-state-title">一次逻辑请求的状态机：unknown 不是失败</title>
<desc id="request-state-desc">pending、running、succeeded、failed 与 unknown 之间的迁移；超时进入 unknown，查询或同键重试才能离开。</desc>
<defs>
<marker id="request-state-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="request-state-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="request-state-ar-green" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-green,#1f6b3a)"/></marker>
<marker id="request-state-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="request-state-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<pattern id="request-state-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="390" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="390" fill="url(#request-state-grid)"/>
<rect x="0" y="0" width="3" height="390" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">一次逻辑请求的状态机：unknown 不是失败</text>
<rect x="40" y="140" width="150" height="64" rx="6" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.4"/>
<text x="115.0" y="170.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">pending</text>
<text x="115.0" y="187.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">已接收，未执行</text>
<rect x="250" y="140" width="150" height="64" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="325.0" y="170.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">running</text>
<text x="325.0" y="187.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">执行中（有租约）</text>
<rect x="470" y="50" width="160" height="60" rx="6" fill="var(--paper)" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.4"/>
<text x="550.0" y="78.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">succeeded</text>
<text x="550.0" y="95.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">副作用已提交</text>
<rect x="470" y="230" width="160" height="60" rx="6" fill="var(--paper)" stroke="var(--fig-red,#9c2b25)" stroke-width="1.4"/>
<text x="550.0" y="258.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">failed</text>
<text x="550.0" y="275.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">确定未提交</text>
<rect x="250" y="290" width="150" height="64" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4" stroke-dasharray="6 5"/>
<text x="325.0" y="320.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">unknown</text>
<text x="325.0" y="337.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">超时 / 响应丢失</text>
<line x1="190" y1="172" x2="250" y2="172" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#request-state-ar-accent)"/>
<text x="220" y="162" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">开始</text>
<line x1="400" y1="150" x2="470" y2="92" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.7" marker-end="url(#request-state-ar-green)"/>
<text x="450" y="112" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">提交 + 响应</text>
<line x1="400" y1="194" x2="470" y2="252" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" marker-end="url(#request-state-ar-red)"/>
<text x="452" y="235" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">明确失败</text>
<line x1="325" y1="204" x2="325" y2="290" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#request-state-ar-gold)"/>
<text x="380" y="250" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端超时</text>
<line x1="400" y1="322" x2="500" y2="290" stroke="var(--fig-green,#1f6b3a)" stroke-width="1.7" marker-end="url(#request-state-ar-green)"/>
<text x="472" y="318" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">查询到成功</text>
<line x1="300" y1="290" x2="300" y2="204" stroke="var(--muted)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#request-state-ar-muted)"/>
<text x="245" y="248" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">同键重试/查询</text>
<line x1="470" y1="292" x2="395" y2="320" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" marker-end="url(#request-state-ar-red)"/>
<text x="450" y="312" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">确定失败</text>
<text x="720" y="160" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">关键不变量</text>
<text x="720" y="184" fill="var(--fig-red,#9c2b25)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">unknown 不能当 failed</text>
<text x="720" y="204" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">只能查询或同键重试</text>
<text x="720" y="224" fill="var(--fig-red,#9c2b25)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">不能换新键重发</text>
</svg>
<figcaption><b>读图：</b>很多系统把 unknown 直接折成 failed，于是客户端重试、服务端再执行一次。把 unknown 画出来，是为了在代码里给它一个明确的分支，而不是靠异常类型猜。</figcaption>
</figure>
