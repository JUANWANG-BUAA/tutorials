<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-control-native-title fig-control-native-desc">
<title id="fig-control-native-title">逆动力学控制：从参考运动和实际反馈得到关节力矩</title>
<desc id="fig-control-native-desc">参考轨迹进入误差反馈块，实际位置和速度由机器人返回。反馈块产生虚拟加速度，逆动力学块结合当前状态将它换成力矩，再作用于机器人。理想模型下虚拟加速度等于实际关节加速度。</desc>
<defs>
<marker id="fig-control-native-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10 Z" fill="var(--muted)"/></marker>
</defs>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.5">
<rect x="24" y="60" width="150" height="90" rx="8"/>
<rect x="218" y="60" width="195" height="90" rx="8"/>
<rect x="458" y="60" width="220" height="90" rx="8"/>
<rect x="724" y="60" width="170" height="90" rx="8"/>
<rect x="458" y="230" width="220" height="65" rx="8"/>
</g>
<g class="diagram-text" text-anchor="middle">
<text x="99" y="94">期望轨迹</text><text x="99" y="125">位置、速度、加速度</text>
<text x="315" y="94">参考加速度</text><text x="315" y="125">＋误差反馈</text>
<text x="568" y="94">当前状态的逆动力学</text><text x="568" y="125">惯性、耦合、重力补偿</text>
<text x="809" y="94">驱动与机械臂</text><text x="809" y="125">产生实际运动</text>
<text x="568" y="269">当前关节位置与速度</text>
</g>
<g fill="none" stroke="var(--muted)" stroke-width="1.7" marker-end="url(#fig-control-native-arrow)">
<path d="M174 105 H214"/><path d="M413 105 H454"/><path d="M678 105 H720"/>
<path d="M809 150 V262 H682"/><path d="M568 230 V156"/>
<path d="M458 262 H315 V156"/>
</g>
<g class="diagram-note" text-anchor="middle">
<text x="434" y="45" fill="var(--fig-blue)">虚拟加速度 y</text>
<text x="701" y="45" fill="var(--fig-gold)">关节力矩 u</text>
<text x="810" y="190">测量反馈</text>
<text x="315" y="219">计算位置与速度误差</text>
<text x="460" y="327">加速度与力矩是不同物理量；模型补偿负责两者之间的换算。</text>
</g>
</svg>
<figcaption>本教程绘。外层由参考与实际误差构造虚拟加速度，模型补偿将其换成关节力矩。理想抵消要求使用当前状态、模型准确并能实现所需输入；前馈则沿期望轨迹计算模型项。</figcaption>
</figure>
