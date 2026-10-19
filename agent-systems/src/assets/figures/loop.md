<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-loop" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-loop-title as-loop-desc">
<title id="as-loop-title">Agent 循环：观察、决策、行动、更新、终止</title>
<desc id="as-loop-desc">横向读是「一步」，弧线读是「多步」。真正把 agent 与单次调用区分开的是弧线与中间那层 STATE/BUDGET：没有状态，下一步不知道上一步做了什么；没有预算，循环不知道何时停。图中「终止？」是判定节点，不是又一个模型调用——终止必须由宿主用可检查的条件执行。</desc>
<defs>
  <linearGradient id="as-loop-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-loop-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-loop-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-loop-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="380" fill="url(#as-loop-bg)"/>
<rect x="0" y="0" width="900" height="380" fill="url(#as-loop-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="380" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">一次 step 是五件事，不是一次模型调用</text>
<rect x="40" y="86" width="124" height="64" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="102.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">输入 / 目标</text>
<text x="102.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">task + tools</text>
<rect x="186" y="86" width="124" height="64" rx="3" fill="var(--atlas-cyan)" fill-opacity="0.05" stroke="var(--atlas-cyan)" stroke-opacity=".55"/>
<text x="248.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">观察</text>
<text x="248.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">tool result</text>
<rect x="332" y="86" width="124" height="64" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="394.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">决策</text>
<text x="394.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">policy / LLM</text>
<rect x="478" y="86" width="124" height="64" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="540.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">行动</text>
<text x="540.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">tool call</text>
<rect x="624" y="86" width="124" height="64" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="686.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">更新</text>
<text x="686.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">state + budget</text>
<rect x="770" y="86" width="124" height="64" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="832.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">终止？</text>
<text x="832.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">answer / abort</text>
<path d="M162.0 118 L188.0 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-loop-arrow)"/>
<path d="M308.0 118 L334.0 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-loop-arrow)"/>
<path d="M454.0 118 L480.0 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-loop-arrow)"/>
<path d="M600.0 118 L626.0 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-loop-arrow)"/>
<path d="M746.0 118 L772.0 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-loop-arrow)"/>
<path d="M832.0 152 C832.0 220, 102.0 220, 102.0 154" stroke="var(--muted)" stroke-width="1.4" stroke-opacity=".8" fill="none" marker-end="url(#as-loop-arrow-dim)" stroke-dasharray="5 4"/>
<text x="450" y="214" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">未终止：带着新观察回到循环；预算与步数每轮递减</text>
<rect x="150" y="252" width="600" height="82" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".5"/>
<text x="450" y="278" fill="var(--ink-2)" font-size="12" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">STATE：世界状态 / 任务状态 / 会话状态 / 控制状态</text>
<text x="450" y="300" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">BUDGET：steps · wall-clock · tokens · tool calls · money</text>
<text x="450" y="320" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">终止条件必须三者同时成立：目标满足 ∧ 预算未耗尽 ∧ 无待处理工具结果</text>
<text x="450" y="360" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">观测：每一步写一条 step 记录（决策、调用、结果、耗时、余额）；没有记录就不算可复现</text>
</svg>
</div>
<figcaption><b>读图：</b>横向读是「一步」，弧线读是「多步」。真正把 agent 与单次调用区分开的是弧线与中间那层 STATE/BUDGET：没有状态，下一步不知道上一步做了什么；没有预算，循环不知道何时停。图中「终止？」是判定节点，不是又一个模型调用——终止必须由宿主用可检查的条件执行。</figcaption>
</figure>
