<figure class="fig-plate fig-wide" id="fig-cache-path">
<svg class="figure-svg" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="cache-path-title cache-path-desc">
<title id="cache-path-title">缓存与 CDN：命中、回源与失效</title>
<desc id="cache-path-desc">客户端先到边缘 CDN，再到本地缓存；未命中才回源到对象存储/数据库，失效要同时覆盖边缘与本地。</desc>
<defs>
<marker id="cache-path-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="cache-path-ar-blue" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-blue,#2456a6)"/></marker>
<marker id="cache-path-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="cache-path-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="cache-path-ar-purple" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-purple,#4c3d99)"/></marker>
<marker id="cache-path-ar-red" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-red,#9c2b25)"/></marker>
<marker id="cache-path-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="cache-path-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="420" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#cache-path-grid)"/>
<rect x="0" y="0" width="3" height="420" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">缓存与 CDN：命中、回源与失效</text>
<rect x="30" y="100" width="120" height="62" rx="6" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.4"/>
<text x="90.0" y="129.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端</text>
<text x="90.0" y="146.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">浏览器/APP</text>
<rect x="200" y="90" width="150" height="82" rx="6" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.4"/>
<text x="275.0" y="129.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">CDN 边缘</text>
<text x="275.0" y="146.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">cache key / TTL</text>
<rect x="400" y="90" width="145" height="82" rx="6" fill="var(--paper)" stroke="var(--fig-blue,#2456a6)" stroke-width="1.4"/>
<text x="472.5" y="129.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">服务缓存</text>
<text x="472.5" y="146.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">Redis/本地</text>
<rect x="600" y="90" width="150" height="82" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="675.0" y="129.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">源站</text>
<text x="675.0" y="146.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">DB/对象存储</text>
<rect x="600" y="250" width="150" height="62" rx="6" fill="var(--paper)" stroke="var(--fig-purple,#4c3d99)" stroke-width="1.4"/>
<text x="675.0" y="279.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">对象存储</text>
<text x="675.0" y="296.0" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">S3 兼容</text>
<line x1="150" y1="131" x2="200" y2="131" stroke="var(--accent)" stroke-width="1.7" marker-end="url(#cache-path-ar-accent)"/>
<text x="175" y="121" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">1</text>
<line x1="350" y1="131" x2="400" y2="131" stroke="var(--sage)" stroke-width="1.7" marker-end="url(#cache-path-ar-sage)"/>
<text x="375" y="121" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">2</text>
<line x1="545" y1="131" x2="600" y2="131" stroke="var(--fig-blue,#2456a6)" stroke-width="1.7" marker-end="url(#cache-path-ar-blue)"/>
<text x="572" y="121" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">3 回源</text>
<line x1="675" y1="172" x2="675" y2="250" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.7" marker-end="url(#cache-path-ar-gold)"/>
<text x="720" y="212" fill="var(--ink-2)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">读对象</text>
<text x="200" y="210" fill="var(--sage)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">HIT：直接返回</text>
<text x="400" y="230" fill="var(--fig-blue,#2456a6)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">MISS：回源 + 回填</text>
<text x="600" y="340" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start">失效：purge 边缘 + 删本地 + 版本号</text>
<line x1="275" y1="172" x2="275" y2="220" stroke="var(--fig-red,#9c2b25)" stroke-width="1.7" stroke-dasharray="6 5" marker-end="url(#cache-path-ar-red)"/>
<text x="275" y="240" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">stale-while-revalidate</text>
<text x="450" y="380" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">命中最怕陈旧；回源最怕击穿；失效最怕只清一半。</text>
</svg>
<figcaption><b>读图：</b>缓存层数越多，命中率越高，失效路径也越长。一次 purge 只清边缘，本地缓存仍可能返回旧值；TTL 是兜底，不是一致性方案。</figcaption>
</figure>
