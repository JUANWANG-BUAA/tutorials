<figure class="fig-plate fig-wide" id="fig-linearizability">
<svg class="figure-svg" viewBox="0 0 900 390" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="linearizability-title linearizability-desc">
<title id="linearizability-title">线性一致：读必须看到已返回的写</title>
<desc id="linearizability-desc">写 x=1 在 t1 返回；t2 之后开始的读若返回 0，则违反线性一致。</desc>
<defs>
<marker id="linearizability-ar-accent" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--accent)"/></marker>
<marker id="linearizability-ar-muted" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" fill="var(--muted)"/></marker>
<pattern id="linearizability-grid" width="24" height="24" patternUnits="userSpaceOnUse"><path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/></pattern>
</defs>
<rect x="0" y="0" width="900" height="390" fill="var(--paper)"/>
<rect x="0" y="0" width="900" height="390" fill="url(#linearizability-grid)"/>
<rect x="0" y="0" width="3" height="390" fill="var(--accent)" opacity=".55"/>
<text x="22" y="28" fill="var(--ink)" font-size="14" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif">线性一致：读必须看到已返回的写</text>
<line x1="150" y1="90" x2="150" y2="330" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="150" y="78" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端 A</text>
<line x1="620" y1="90" x2="620" y2="330" stroke="var(--muted)" stroke-width="1" stroke-dasharray="5 5"/>
<text x="620" y="78" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">客户端 B</text>
<rect x="150" y="120" width="230" height="22" fill="var(--accent)" fill-opacity=".18" stroke="var(--accent)"/>
<text x="265" y="136" fill="var(--accent)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">write x=1</text>
<line x1="380" y1="104" x2="380" y2="340" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="5 5"/>
<text x="380" y="98" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">t1 写返回</text>
<rect x="520" y="210" width="210" height="22" fill="var(--sage)" fill-opacity=".18" stroke="var(--sage)"/>
<text x="620" y="226" fill="var(--sage)" font-size="11" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">read x ?</text>
<line x1="520" y1="194" x2="520" y2="340" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="5 5"/>
<text x="520" y="188" fill="var(--ink-2)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">t2 读开始</text>
<text x="430" y="300" fill="var(--ink)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">t2 &gt; t1 ⇒ 读必须返回 1（或更新的值）</text>
<text x="430" y="330" fill="var(--fig-red,#9c2b25)" font-size="11.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">返回 0 = stale read = 违反线性一致</text>
<text x="430" y="360" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle">返回 timeout 只是 unknown，不构成反例</text>
</svg>
<figcaption><b>读图：</b>线性一致的判定不是看「有没有复制」，而是看能否找到一个全序，既尊重每个操作的实时区间，又让读返回该全序中最近一次写的值。图中下半部分给出反例。</figcaption>
</figure>
