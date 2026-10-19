<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-protocol" data-fig-kind="plate">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 900 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="as-protocol-title as-protocol-desc">
<title id="as-protocol-title">工具协议的三方与四层边界</title>
<desc id="as-protocol-desc">从左到右是控制流，不是信任流。模型产出的只是 tool_calls；宿主做校验、授权、路由；MCP 只负责把调用送到 server。读到中间的请求帧要意识到：参数可以来自网页、文件或另一个工具的输出，所以「schema 合法」不等于「可以执行」。底部两行是版本坐标：新版把 initialize 与协议级会话去掉了，新实现不应再把握手当默认前提。</desc>
<defs>
  <linearGradient id="as-protocol-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="as-protocol-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="as-protocol-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="as-protocol-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="420" fill="url(#as-protocol-bg)"/>
<rect x="0" y="0" width="900" height="420" fill="url(#as-protocol-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="420" style="fill:var(--accent)" fill-opacity=".5"/>
<text x="450" y="40" fill="var(--ink-2)" font-size="13" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">同一份工具契约，穿过四处边界</text>
<rect x="36" y="80" width="168" height="76" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="120.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">模型 provider</text>
<text x="120.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">tool_calls / JSON 参数</text>
<rect x="246" y="80" width="168" height="76" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="330.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">宿主 runtime</text>
<text x="330.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">校验、授权、调度</text>
<rect x="456" y="80" width="168" height="76" rx="3" fill="var(--atlas-cyan)" fill-opacity="0.05" stroke="var(--atlas-cyan)" stroke-opacity=".55"/>
<text x="540.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">MCP client</text>
<text x="540.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">JSON-RPC 2.0 请求</text>
<rect x="666" y="80" width="168" height="76" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="750.0" y="114.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">MCP server / 工具</text>
<text x="750.0" y="131.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">进程、文件、网络副作用</text>
<path d="M206 118 L244 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-protocol-arrow)"/>
<path d="M416 118 L454 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-protocol-arrow)"/>
<path d="M626 118 L664 118" stroke="var(--accent)" stroke-width="1.3" stroke-opacity=".75" fill="none" marker-end="url(#as-protocol-arrow)"/>
<text x="450" y="190" fill="var(--accent-strong)" font-size="11.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">线上传输的是「意图 + 参数」，不是权限</text>
<rect x="36" y="208" width="828" height="96" rx="3" fill="var(--paper)" stroke="var(--line-strong)"/>
<text x="60" y="232" fill="var(--ink-2)" font-size="11" font-weight="700" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">tools/call 请求</text>
<text x="60" y="252" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0">{&quot;jsonrpc&quot;:&quot;2.0&quot;,&quot;id&quot;:7,&quot;method&quot;:&quot;tools/call&quot;,</text>
<text x="60" y="270" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0"> &quot;params&quot;:{&quot;name&quot;:&quot;fs.read&quot;,&quot;arguments&quot;:{&quot;path&quot;:&quot;/work/a.txt&quot;},</text>
<text x="60" y="288" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="start" opacity="1.0"> &quot;_meta&quot;:{&quot;traceparent&quot;:&quot;00-...&quot;}}}</text>
<text x="500" y="232" fill="var(--ink-2)" font-size="11" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">宿主必须自己回答四问</text>
<text x="500" y="252" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">① schema 合法？ ② 这个调用者有权？</text>
<text x="500" y="270" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">③ 参数是否来自不可信数据？ ④ 失败如何回传？</text>
<text x="500" y="288" fill="var(--muted)" font-size="10.5" font-weight="400" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="start" opacity="1.0">协议只规定格式，授权与副作用由宿主与 server 负责。</text>
<rect x="36" y="330" width="250" height="56" rx="3" fill="var(--muted)" fill-opacity="0.05" stroke="var(--muted)" stroke-opacity=".55"/>
<text x="161.0" y="354.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">2025-11-25</text>
<text x="161.0" y="371.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">initialize 握手 + 会话</text>
<rect x="325" y="330" width="250" height="56" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".55"/>
<text x="450.0" y="354.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">2026-07-28</text>
<text x="450.0" y="371.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">无状态 + server/discover + MRTR</text>
<rect x="614" y="330" width="250" height="56" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".55"/>
<text x="739.0" y="354.0" fill="var(--ink-2)" font-size="12.5" font-weight="700" font-family="'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif" text-anchor="middle" opacity="1.0">弃用窗口</text>
<text x="739.0" y="371.0" fill="var(--muted)" font-size="10" font-weight="400" font-family="'SFMono-Regular','Roboto Mono',Consolas,monospace" text-anchor="middle" opacity="1.0">Roots / Sampling / Logging</text>
</svg>
</div>
<figcaption><b>读图：</b>从左到右是控制流，不是信任流。模型产出的只是 tool_calls；宿主做校验、授权、路由；MCP 只负责把调用送到 server。读到中间的请求帧要意识到：参数可以来自网页、文件或另一个工具的输出，所以「schema 合法」不等于「可以执行」。底部两行是版本坐标：新版把 initialize 与协议级会话去掉了，新实现不应再把握手当默认前提。</figcaption>
</figure>
