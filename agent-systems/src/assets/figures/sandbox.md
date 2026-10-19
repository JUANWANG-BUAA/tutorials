<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-sandbox" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 410" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-sandbox-title as-sandbox-desc">
<title id="as-sandbox-title">代码 agent 的四层沙箱边界</title>
<desc id="as-sandbox-desc">四层不是四个可选项，而是四种失败模式的一一对应。只做进程超时、不做进程组，超时后子进程仍在写文件；只做文件只读、不做网络隔离，agent 仍可把读到的内容发出去。共同前提那一行是第 4 章的主题：边界要靠「丢权」而不是「加限制」来实现。</desc>
<defs>
  <linearGradient id="as-sandbox-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-sandbox-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-sandbox-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-sandbox-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="410" fill="url(#as-sandbox-bg)"/>
<rect x="0" y="0" width="900" height="410" fill="url(#as-sandbox-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="410" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">代码 agent 的四层边界：每层挡不同的逃逸</text>
<rect x="70" y="84" width="170" height="74" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="155.0" y="117.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">进程</text>
<text x="155.0" y="134.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">fork/exec · 进程组 · 超时 · 收尸</text>
<text x="255" y="126" fill="var(--muted)" font-size="18" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">+</text>
<rect x="270" y="84" width="170" height="74" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="355.0" y="117.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">文件</text>
<text x="355.0" y="134.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">rootfs · pivot_root · openat2 · 临时目录</text>
<text x="455" y="126" fill="var(--muted)" font-size="18" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">+</text>
<rect x="470" y="84" width="170" height="74" rx="3" fill="var(--atlas-cyan)" fill-opacity="0.05" stroke="var(--atlas-cyan)" stroke-opacity=".55"/>
<text x="555.0" y="117.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">网络</text>
<text x="555.0" y="134.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">netns · egress allowlist · DNS 固定</text>
<text x="655" y="126" fill="var(--muted)" font-size="18" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">+</text>
<rect x="670" y="84" width="170" height="74" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="755.0" y="117.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">资源</text>
<text x="755.0" y="134.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">rlimit · cgroup v2 · pids.max · 墙钟</text>
<rect x="70" y="196" width="770" height="76" rx="3" fill="var(--paper)" stroke="var(--line-strong)"/>
<text x="90" y="222" fill="var(--ink-2)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">共同前提</text>
<text x="90" y="244" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">低权限 UID + no_new_privs + 最小 capability + seccomp 白名单 + landlock 路径规则</text>
<text x="90" y="262" fill="var(--muted)" font-size="10" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">顺序：userns → mount/rootfs → drop caps → no_new_privs → seccomp → landlock（细节见第 4 章）</text>
<rect x="70" y="290" width="770" height="92" rx="3" fill="var(--accent)" fill-opacity="0.04" stroke="var(--accent)" stroke-opacity=".45"/>
<text x="90" y="316" fill="var(--accent-strong)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">四条事故路径（每层一条）</text>
<text x="90" y="338" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">① 不设进程组 → 超时只杀父进程，子进程继续跑    ② 不换根 → 读到宿主 ~/.ssh</text>
<text x="90" y="358" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">③ 不隔离网络 → 把数据 POST 出去    ④ 不设 pids.max → fork 炸弹拖垮宿主</text>
</svg>
</div>
<figcaption><b>读图：</b>四层不是四个可选项，而是四种失败模式的一一对应。只做进程超时、不做进程组，超时后子进程仍在写文件；只做文件只读、不做网络隔离，agent 仍可把读到的内容发出去。共同前提那一行是第 4 章的主题：边界要靠「丢权」而不是「加限制」来实现。</figcaption>
</figure>
