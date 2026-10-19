<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-planning" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-planning-title as-planning-desc">
<title id="as-planning-title">ReAct、Plan-Execute 与树搜索的结构对比</title>
<desc id="as-planning-desc">三块不是难度阶梯，而是三种搜索结构。ReAct 每一步只看局部，适合反馈快、步数少的任务；Plan-Execute 先付一笔规划成本换全局一致性，适合步骤可预判、可并行的任务；树搜索把预算花在展开候选上，只有在价值函数能区分好坏时才划算。没有验证器时，树搜索往往只是把同一个错误复制成四份。</desc>
<defs>
  <linearGradient id="as-planning-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-planning-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-planning-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-planning-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="430" fill="url(#as-planning-bg)"/>
<rect x="0" y="0" width="900" height="430" fill="url(#as-planning-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="430" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">三种规划：交错、先计划后执行、搜索</text>
<text x="150" y="78" fill="var(--accent-strong)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">ReAct</text>
<rect x="48" y="96" width="204" height="52" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="150.0" y="118.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Thought</text>
<text x="150.0" y="135.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">下一步做什么</text>
<rect x="48" y="168" width="204" height="52" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="150.0" y="190.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Action</text>
<text x="150.0" y="207.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">一次工具调用</text>
<rect x="48" y="240" width="204" height="52" rx="3" fill="var(--atlas-cyan)" fill-opacity="0.05" stroke="var(--atlas-cyan)" stroke-opacity=".55"/>
<text x="150.0" y="262.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Observation</text>
<text x="150.0" y="279.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">结果 / 错误</text>
<path d="M150 148 L150 166" stroke="var(--accent)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow)"/>
<path d="M150 220 L150 238" stroke="var(--accent)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow)"/>
<path d="M48 266 C18 266, 18 122, 48 122" stroke="var(--muted)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow-dim)" stroke-dasharray="5 4"/>
<text x="150" y="330" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">局部 reactive；无全局计划</text>
<text x="450" y="78" fill="var(--accent-strong)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Plan-Execute</text>
<rect x="330" y="96" width="240" height="52" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="450.0" y="118.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Planner</text>
<text x="450.0" y="135.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">输出步骤 DAG</text>
<rect x="330" y="178" width="90" height="48" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="375.0" y="198.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">S1</text>
<text x="375.0" y="215.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">可重试</text>
<rect x="448" y="178" width="90" height="48" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="493.0" y="198.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">S2</text>
<text x="493.0" y="215.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">可重试</text>
<rect x="566" y="178" width="90" height="48" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="611.0" y="198.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">S3</text>
<text x="611.0" y="215.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">可重试</text>
<path d="M450 148 L450 160 L375 160 L375 176" stroke="var(--accent)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow)"/>
<path d="M450 148 L450 176" stroke="var(--accent)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow)"/>
<path d="M450 148 L450 160 L611 160 L611 176" stroke="var(--accent)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow)"/>
<path d="M422 202 L446 202" stroke="var(--muted)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-planning-arrow-dim)"/>
<path d="M540 202 L564 202" stroke="var(--muted)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-planning-arrow-dim)"/>
<rect x="330" y="250" width="240" height="48" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="450.0" y="270.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Replan</text>
<text x="450.0" y="287.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">失败/新信息触发</text>
<path d="M450 226 L450 248" stroke="var(--accent)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-planning-arrow)"/>
<text x="450" y="330" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">全局计划；重规划成本高</text>
<text x="760" y="78" fill="var(--accent-strong)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">Tree search</text>
<path d="M760 112 L700 148" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>
<path d="M760 112 L820 148" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>
<path d="M700 172 L670 208" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>
<path d="M700 172 L730 208" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>
<path d="M820 172 L790 208" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>
<path d="M820 172 L850 208" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>
<circle cx="760" cy="100" r="12" fill="var(--paper)" fill-opacity="1" stroke="var(--muted)" stroke-width="1.2"/>
<text x="760" y="103.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0"></text>
<circle cx="700" cy="160" r="12" fill="var(--paper)" fill-opacity="1" stroke="var(--muted)" stroke-width="1.2"/>
<text x="700" y="163.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0"></text>
<circle cx="820" cy="160" r="12" fill="var(--paper)" fill-opacity="1" stroke="var(--muted)" stroke-width="1.2"/>
<text x="820" y="163.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0"></text>
<circle cx="670" cy="220" r="12" fill="var(--paper)" fill-opacity="1" stroke="var(--muted)" stroke-width="1.2"/>
<text x="670" y="223.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0"></text>
<circle cx="730" cy="220" r="12" fill="var(--accent)" fill-opacity="0.18" stroke="var(--accent)" stroke-width="1.2"/>
<text x="730" y="223.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">✓</text>
<circle cx="790" cy="220" r="12" fill="var(--accent)" fill-opacity="0.18" stroke="var(--accent)" stroke-width="1.2"/>
<text x="790" y="223.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">✓</text>
<circle cx="850" cy="220" r="12" fill="var(--paper)" fill-opacity="1" stroke="var(--muted)" stroke-width="1.2"/>
<text x="850" y="223.5" fill="var(--accent-strong)" font-size="10" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0"></text>
<text x="760" y="262" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">展开 + 评估 + 回传价值</text>
<text x="760" y="330" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">预算换质量；需要价值函数</text>
<rect x="36" y="356" width="828" height="46" rx="3" fill="var(--muted)" fill-opacity="0.04" stroke="var(--line)"/>
<text x="450" y="383" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">选择依据：任务可分解性、验证器强度、单步成本、失败可逆性——不是「哪个更高级」</text>
</svg>
</div>
<figcaption><b>读图：</b>三块不是难度阶梯，而是三种搜索结构。ReAct 每一步只看局部，适合反馈快、步数少的任务；Plan-Execute 先付一笔规划成本换全局一致性，适合步骤可预判、可并行的任务；树搜索把预算花在展开候选上，只有在价值函数能区分好坏时才划算。没有验证器时，树搜索往往只是把同一个错误复制成四份。</figcaption>
</figure>
