<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-eval" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-eval-title as-eval-desc">
<title id="as-eval-title">评估流水线与回归门禁</title>
<desc id="as-eval-desc">从左到右是流水线，从右往左是回滚路径。门禁读的不是一个分数，而是一组带不确定性的差值：质量差值的置信区间下界、安全回归数、成本与 P95 延迟。图中「门禁」是唯一有写权限的环节，runner 与统计只产出证据；没有证据链的放行，等于把发布交给运气。</desc>
<defs>
  <linearGradient id="as-eval-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-eval-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-eval-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-eval-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="400" fill="url(#as-eval-bg)"/>
<rect x="0" y="0" width="900" height="400" fill="url(#as-eval-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="400" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">评估流水线：从版本化数据集到可回滚的门禁</text>
<rect x="36" y="84" width="158" height="68" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="115.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">数据集 v3</text>
<text x="115.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">分层 + 污染检查</text>
<path d="M196 118 L204 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-eval-arrow)"/>
<rect x="208" y="84" width="158" height="68" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="287.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">runner</text>
<text x="287.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">N 次采样 + 成本</text>
<path d="M368 118 L376 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-eval-arrow)"/>
<rect x="380" y="84" width="158" height="68" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="459.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">指标</text>
<text x="459.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">准确率 / 工具 / 引用</text>
<path d="M540 118 L548 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-eval-arrow)"/>
<rect x="552" y="84" width="158" height="68" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="631.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">统计</text>
<text x="631.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">CI + 配对检验</text>
<path d="M712 118 L720 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-eval-arrow)"/>
<rect x="724" y="84" width="158" height="68" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="803.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">门禁</text>
<text x="803.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">阈值 + 灰度</text>
<rect x="36" y="184" width="400" height="128" rx="3" fill="var(--accent)" fill-opacity="0.04" stroke="var(--accent)" stroke-opacity=".45"/>
<text x="56" y="210" fill="var(--accent-strong)" font-size="11.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">一次比较要同时报告</text>
<text x="56" y="234" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">Δ质量 = +4.2pp  [95% CI +1.1, +7.3]</text>
<text x="56" y="254" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">Δ成本 = +18%    ΔP95 = +240ms</text>
<text x="56" y="274" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">n = 400 配对样本；同一 seed 集</text>
<text x="56" y="294" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">失败样本：12 个新增，3 个修复</text>
<rect x="464" y="184" width="400" height="128" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".45"/>
<text x="484" y="210" fill="var(--ink-2)" font-size="11.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">门禁不是单指标</text>
<text x="484" y="234" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">① 质量下界 &gt; baseline（配对）</text>
<text x="484" y="254" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">② 安全用例 0 回归</text>
<text x="484" y="274" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">③ 成本/延迟在预算内</text>
<text x="484" y="294" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">④ 任一失败 → 可回滚到上一版本</text>
<text x="450" y="350" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">没有「平均分涨了」就放行；平均分可以掩盖尾部、失败类型与成本漂移。</text>
<text x="450" y="374" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">观测：每次评估写 dataset_version / model / prompt_hash / seed / git_sha，否则结果不可复现。</text>
</svg>
</div>
<figcaption><b>读图：</b>从左到右是流水线，从右往左是回滚路径。门禁读的不是一个分数，而是一组带不确定性的差值：质量差值的置信区间下界、安全回归数、成本与 P95 延迟。图中「门禁」是唯一有写权限的环节，runner 与统计只产出证据；没有证据链的放行，等于把发布交给运气。</figcaption>
</figure>
