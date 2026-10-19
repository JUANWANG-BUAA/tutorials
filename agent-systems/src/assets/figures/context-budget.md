<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-context-budget" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-context-title as-context-desc">
<title id="as-context-title">上下文预算的分配与压缩顺序</title>
<desc id="as-context-desc">顶部条是预算分配，不是实际占用；实际占用要靠 tokenizer 计数，不能按字符数估。右侧「输出预留」必须提前扣掉：很多 agent 的失败不是输入超限，而是输入刚好塞满、输出没有空间，导致回答被截断。下方四级是压缩顺序：先去重，再抽取，最后才摘要；摘要会不可逆地丢约束，放在最后。</desc>
<defs>
  <linearGradient id="as-context-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-context-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-context-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-context-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="400" fill="url(#as-context-bg)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#as-context-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="400" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">上下文预算：先分配，再填充，最后才压缩</text>
<rect x="36.0" y="80" width="99.4" height="58" fill="var(--accent)" fill-opacity=".10" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="85.68" y="105" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">系统与安全</text>
<text x="85.68" y="123" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">12%</text>
<rect x="135.4" y="80" width="82.8" height="58" fill="var(--atlas-gold)" fill-opacity=".10" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="176.76000000000002" y="105" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">任务与约束</text>
<text x="176.76000000000002" y="123" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">10%</text>
<rect x="218.2" y="80" width="115.9" height="58" fill="var(--atlas-cyan)" fill-opacity=".10" stroke="var(--atlas-cyan)" stroke-opacity=".55"/>
<text x="276.12" y="105" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">工具 schema</text>
<text x="276.12" y="123" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">14%</text>
<rect x="334.1" y="80" width="215.3" height="58" fill="var(--muted)" fill-opacity=".10" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="441.72" y="105" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">检索/记忆</text>
<text x="441.72" y="123" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">26%</text>
<rect x="549.4" y="80" width="182.2" height="58" fill="var(--muted)" fill-opacity=".10" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="640.44" y="105" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">对话历史</text>
<text x="640.44" y="123" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">22%</text>
<rect x="731.5" y="80" width="132.5" height="58" fill="var(--accent)" fill-opacity=".10" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="797.76" y="105" fill="var(--ink-2)" font-size="10.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">输出预留</text>
<text x="797.76" y="123" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">16%</text>
<text x="450" y="162" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">总预算 100%：任何一段超支，都必须从另一段扣除——不能靠「再塞一点」</text>
<rect x="36" y="196" width="192" height="66" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="132.0" y="225.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">① 去重</text>
<text x="132.0" y="242.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">同文多次出现只留一次</text>
<path d="M230 229 L242 229" stroke="var(--muted)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-context-arrow-dim)"/>
<rect x="246" y="196" width="192" height="66" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="342.0" y="225.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">② 抽取</text>
<text x="342.0" y="242.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">只留与当前子目标相关的 span</text>
<path d="M440 229 L452 229" stroke="var(--muted)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-context-arrow-dim)"/>
<rect x="456" y="196" width="192" height="66" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="552.0" y="225.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">③ 摘要</text>
<text x="552.0" y="242.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">保留约束、数字、失败原因</text>
<path d="M650 229 L662 229" stroke="var(--muted)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-context-arrow-dim)"/>
<rect x="666" y="196" width="192" height="66" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="762.0" y="225.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">④ 裁剪</text>
<text x="762.0" y="242.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">滑窗 / 引用替换 / 硬截断</text>
<rect x="36" y="292" width="828" height="66" rx="3" fill="var(--atlas-gold)" fill-opacity="0.06" stroke="var(--atlas-gold)" stroke-opacity=".5"/>
<text x="60" y="318" fill="var(--ink-2)" font-size="11.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">顺序不能反</text>
<text x="60" y="338" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">先压缩再分配 = 把预算浪费在低价值内容上；先分配再压缩 = 每段都知道自己为什么存在。</text>
</svg>
</div>
<figcaption><b>读图：</b>顶部条是预算分配，不是实际占用；实际占用要靠 tokenizer 计数，不能按字符数估。右侧「输出预留」必须提前扣掉：很多 agent 的失败不是输入超限，而是输入刚好塞满、输出没有空间，导致回答被截断。下方四级是压缩顺序：先去重，再抽取，最后才摘要；摘要会不可逆地丢约束，放在最后。</figcaption>
</figure>
