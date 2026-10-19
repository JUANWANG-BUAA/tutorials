<figure class="fig-plate fig-wide" id="fig-quorum">
<svg class="figure-svg" viewBox="0 0 900 370" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="quorum-title quorum-desc">
<title id="quorum-title">Quorum 相交：R + W &gt; N 只保证集合相交</title>
<desc id="quorum-desc">N=3、W=2、R=2 时，读集合与写集合至少共享一个副本；但共享副本不一定有最新值。</desc>
<defs>
<marker id="quorum-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="quorum-ar-gold" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--fig-gold,#8a5a00)"/></marker>
<marker id="quorum-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<marker id="quorum-ar-sage" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--sage)"/></marker>
<pattern id="quorum-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="370" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="370" fill="url(#quorum-grid)"/>
<rect x="0" y="0" width="3" height="370" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">Quorum 相交：R + W &gt; N 只保证集合相交</text>
<circle cx="300" cy="180" r="120" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.6"/>
<text x="300" y="184" fill="var(--ink)" font-size="1" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle"></text>
<circle cx="500" cy="180" r="120" fill="var(--paper)" stroke="var(--muted)" stroke-width="1.6"/>
<text x="500" y="184" fill="var(--ink)" font-size="1" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle"></text>
<text x="300" y="175" fill="var(--accent)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">W = {A, B}</text>
<text x="500" y="175" fill="var(--sage)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">R = {B, C}</text>
<circle cx="400" cy="180" r="42" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.6"/>
<text x="400" y="184" fill="var(--ink)" font-size="16" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">B</text>
<circle cx="190" cy="180" r="28" fill="var(--paper)" stroke="var(--accent)" stroke-width="1.6"/>
<text x="190" y="184" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">A</text>
<circle cx="610" cy="180" r="28" fill="var(--paper)" stroke="var(--sage)" stroke-width="1.6"/>
<text x="610" y="184" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">C</text>
<text x="400" y="260" fill="var(--ink-2)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">交集 B 是读能看到最新写的必要条件</text>
<rect x="90" y="300" width="720" height="44" rx="6" fill="var(--paper)" stroke="var(--fig-gold,#8a5a00)" stroke-width="1.4"/>
<text x="450.0" y="326.0" fill="var(--ink)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">R + W &gt; N  ⇒  读集合 ∩ 写集合 ≠ ∅</text>
<text x="820" y="120" fill="var(--fig-red,#9c2b25)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">常见误读</text>
<text x="820" y="142" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">× 相交 = 线性一致</text>
<text x="820" y="162" fill="var(--fig-red,#9c2b25)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">× W=all 才安全</text>
</svg>
<figcaption><b>读图：</b>相交只解决「至少一个副本知道这次写」，不解决「读是否等到修复完成」。要线性一致，还需要写确认、读修复/提交等待与顺序规则。</figcaption>
</figure>
