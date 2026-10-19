<figure class="fig-plate fig-wide" id="fig-timeout-truth">
<svg class="figure-svg" viewBox="0 0 900 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="timeout-truth-title timeout-truth-desc">
<title id="timeout-truth-title">超时后的三种真相</title>
<desc id="timeout-truth-desc">客户端在 T 时刻返回 timeout；请求可能没到、执行了但响应丢失、或执行并提交但响应丢失。</desc>
<defs>
<marker id="timeout-truth-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="timeout-truth-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="timeout-truth-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="timeout-truth-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<pattern id="timeout-truth-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="380" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="380" fill="url(#timeout-truth-grid)"/>
<rect x="0" y="0" width="3" height="380" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">超时后的三种真相</text>
<line x1="100" y1="80" x2="100" y2="350" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="100" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端</text>
<line x1="760" y1="80" x2="760" y2="350" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="760" y="68" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">服务端</text>
<line x1="610" y1="70" x2="610" y2="360" stroke="var(--fig-red,#9c2b25)" stroke-width="1.6" stroke-dasharray="5 5"/>
<text x="610" y="62" fill="var(--fig-red,#9c2b25)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">T = 1 s（客户端超时）</text>
<text x="30" y="92" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">① 请求没到</text>
<line x1="100" y1="110" x2="360" y2="110" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#timeout-truth-ar-accent)"/>
<text x="30" y="114" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">报文丢失/连接未建立</text>
<text x="790" y="104" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="end">server 无记录</text>
<text x="30" y="182" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">② 执行了，响应丢了</text>
<line x1="100" y1="200" x2="760" y2="200" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#timeout-truth-ar-accent)"/>
<text x="30" y="204" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">副作用已发生，客户端不知道</text>
<text x="790" y="194" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="end">server 有记录，状态成功</text>
<rect x="700" y="208" width="120" height="26" rx="3" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="760.0" y="225.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">已执行</text>
<text x="30" y="272" fill="var(--ink)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">③ 执行并提交，响应丢了</text>
<line x1="100" y1="290" x2="760" y2="290" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#timeout-truth-ar-accent)"/>
<text x="30" y="294" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">数据库已提交，最危险</text>
<text x="790" y="284" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="end">server 可查到结果</text>
<rect x="700" y="298" width="120" height="26" rx="3" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="760.0" y="315.0" fill="var(--ink)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">已执行</text>
<text x="450" y="372" fill="var(--muted)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端看到的都是 timeout；服务端状态分别是「无」「成功」「成功」。</text>
</svg>
<figcaption><b>读图：</b>同一条 timeout 日志背后可能是三种完全不同的服务端状态。只看客户端错误码，无法判断该不该重试；这就是为什么需要幂等键和服务端查询接口。</figcaption>
</figure>
