# 全书知识地图

## 第一编 · 引言：机器人学的骨架

第一章的任务是把「机器人」这件事的骨架立起来：**机器人是什么**（定义与四子系统，[1.1](ch01/sec1-1.md)）；**它的身体长什么样**——固定底座的机械手（[1.2](ch01/sec1-2.md)）与移动底座的移动机器人（[1.3](ch01/sec1-3.md)）；**它在哪里工作**——结构化环境的工业机器人学与弱结构环境的先进机器人学（[1.4](ch01/sec1-4.md)）；**研究它的什么**——建模、规划、控制三大主题与全书十二章的映射（[1.5](ch01/sec1-5.md)）。学习时建议按箭头顺序自检「前一环是否真正懂了」。

<figure>
<svg height="500" viewBox="0 0 920 500" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<!-- 第0行: 定义与系统构成 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="150" x="10" y="18"></rect><text fill="var(--fig-blue)" x="85" y="43">定义：感知↔行为</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="140" x="200" y="18"></rect><text fill="var(--fig-blue)" x="270" y="43">机械系统</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="140" x="380" y="18"></rect><text fill="var(--fig-blue)" x="450" y="43">执行系统</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="140" x="560" y="18"></rect><text fill="var(--fig-blue)" x="630" y="43">传感系统</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="140" x="740" y="18"></rect><text fill="var(--fig-blue)" x="810" y="43">控制系统</text>
<!-- 第1行: 两类结构 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="150" x="10" y="128"></rect><text fill="var(--fig-gold)" x="85" y="153">机械手（固定）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="160" x="200" y="128"></rect><text fill="var(--fig-gold)" x="280" y="153">五种构形对比</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="160" x="400" y="128"></rect><text fill="var(--fig-gold)" x="480" y="153">开链 / 闭链</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="160" x="600" y="128"></rect><text fill="var(--fig-gold)" x="680" y="153">球形腕解耦</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="150" x="10" y="188"></rect><text fill="var(--fig-green)" x="85" y="213">移动机器人</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="160" x="200" y="188"></rect><text fill="var(--fig-green)" x="280" y="213">三类车轮</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="160" x="400" y="188"></rect><text fill="var(--fig-green)" x="480" y="213">五种底盘布局</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="160" x="600" y="188"></rect><text fill="var(--fig-green)" x="680" y="213">全向与机动性</text>
<!-- 第2行: 应用域 -->
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="180" x="10" y="298"></rect><text fill="var(--fig-red, #c96a5a)" x="100" y="323">工业机器人学（结构化）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="190" x="230" y="298"></rect><text fill="var(--fig-red, #c96a5a)" x="325" y="323">三能力：搬运/操作/测量</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="220" x="460" y="298"></rect><text fill="var(--fig-red, #c96a5a)" x="570" y="323">先进机器人学（野外 / 服务）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="150" x="720" y="298"></rect><text fill="var(--fig-red, #c96a5a)" x="795" y="323">自治性谱系</text>
<!-- 第3行: 方法论路线图 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="170" x="10" y="408"></rect><text fill="var(--fig-blue)" x="95" y="433">建模（第2,3,7,11章）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="220" y="408"></rect><text fill="var(--fig-blue)" x="315" y="433">规划（第4,11,12章）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="450" y="408"></rect><text fill="var(--fig-blue)" x="545" y="433">控制（第6,8–11章）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="680" y="408"></rect><text fill="var(--fig-blue)" x="775" y="433">结构（第5章）</text>
</g>
<g stroke="var(--muted)" stroke-width="1.4" fill="none" marker-end="url(#arr)">
<path d="M160,38 L200,38"></path><path d="M340,38 L380,38"></path><path d="M520,38 L560,38"></path><path d="M700,38 L740,38"></path>
<path d="M85,58 L85,128"></path><path d="M450,58 L85,188" opacity="0"></path>
<path d="M160,148 L200,148"></path><path d="M360,148 L400,148"></path><path d="M560,148 L600,148"></path>
<path d="M85,168 L85,188"></path><path d="M160,208 L200,208"></path><path d="M360,208 L400,208"></path><path d="M560,208 L600,208"></path>
<path d="M85,228 L100,298"></path><path d="M680,228 L690,298"></path>
<path d="M190,338 L95,408"></path><path d="M420,338 L315,408"></path><path d="M600,338 L545,408"></path><path d="M820,338 L775,408"></path>
</g>
<g font-size="12" fill="var(--muted)" text-anchor="middle">
<text x="460" y="120">身体：两类机械结构</text>
<text x="460" y="285">用武之地：从结构化到开放环境</text>
<text x="460" y="395">方法论：全书十二章的骨架</text>
</g>
</svg>
</figure>

## 读图要领

- **蓝（顶行）**：「感知与行为之间的智能联系」+ 四子系统闭环——全章总纲。
- **金绿（两类身体）**：机械手（构形 / 拓扑 / 腕解耦）与轮系布局（机动性），在移动机械手处汇合。
- **红（两个世界）**：结构化环境有限自治、开放环境强自治——同一身体，不同「智力预算」。
- **底行**：建模 → 规划 → 控制，每框标注对应章节，学完全书应能逐框复述。

## 第二编 · 运动学：描述与传递的代数

第二章（[章总览](ch02/overview.md)）接续底行的「建模（第 2 章）」格，回答两个问题：**怎么表示位姿**（表示论）与**怎么沿关节链传递位姿**（传递论）；最后用逆运动学的不对称性给第 3 章「微分运动学」留出门。

<figure>
<svg height="470" viewBox="0 0 920 470" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr2" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<!-- 行1: 表示 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="170" x="10" y="18"></rect><text fill="var(--fig-blue)" x="95" y="43">旋转矩阵（9 量，无奇点）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="180" x="220" y="18"></rect><text fill="var(--fig-blue)" x="310" y="43">欧拉角 ZYZ / RPY（3 参数）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="170" x="440" y="18"></rect><text fill="var(--fig-blue)" x="525" y="43">角和轴（4 参数）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="650" y="18"></rect><text fill="var(--fig-blue)" x="745" y="43">齐次变换（位置 + 指向）</text>
<!-- 行2: 传递 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="10" y="128"></rect><text fill="var(--fig-gold)" x="95" y="153">DH 建系（四规则）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="180" x="220" y="128"></rect><text fill="var(--fig-gold)" x="310" y="153">4n 参数表（3 常 1 变）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="440" y="128"></rect><text fill="var(--fig-gold)" x="525" y="153">A_i 连乘 = 正运动学</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="190" x="650" y="128"></rect><text fill="var(--fig-gold)" x="745" y="153">七种典型结构实例</text>
<!-- 行3: 空间与性能 -->
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="10" y="238"></rect><text fill="var(--fig-green)" x="110" y="263">关节空间 ↔ 操作空间</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="220" x="250" y="238"></rect><text fill="var(--fig-green)" x="360" y="263">工作空间 · 精度 · 冗余</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="510" y="238"></rect><text fill="var(--fig-green)" x="610" y="263">运动学标定（最小二乘）</text>
<!-- 行4: 逆问题 -->
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="200" x="10" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="110" y="373">逆运动学四难点</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="220" x="250" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="360" y="373">解耦条件（球腕交点 / 平行）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="200" x="510" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="610" y="373">闭式解（臂 + 腕）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="150" x="750" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="825" y="373">否则：数值法 → 第 3 章</text>
</g>
<g stroke="var(--muted)" stroke-width="1.4" fill="none" marker-end="url(#arr2)">
<path d="M180,38 L220,38"></path><path d="M400,38 L440,38"></path><path d="M610,38 L650,38"></path>
<path d="M745,58 L745,128" opacity="0"></path>
<path d="M180,148 L220,148"></path><path d="M400,148 L440,148"></path><path d="M610,148 L650,148"></path>
<path d="M310,58 L95,128"></path><path d="M525,58 L310,128" opacity="0"></path>
<path d="M110,168 L110,238"></path><path d="M525,168 L360,238"></path><path d="M745,168 L610,238"></path>
<path d="M210,258 L250,258"></path><path d="M470,258 L510,258"></path>
<path d="M110,278 L110,348"></path><path d="M610,278 L360,348"></path>
<path d="M210,368 L250,368"></path><path d="M470,368 L510,368"></path><path d="M710,368 L750,368"></path>
</g>
<g font-size="12" fill="var(--muted)" text-anchor="middle">
<text x="460" y="110">传递：从「会乘」到「会算」</text>
<text x="380" y="225">空间与性能：任务在哪里指定、边界在哪</text>
<text x="380" y="335">逆问题：表示可以反解吗</text>
<text x="460" y="440">四行自上而下：先会表示，再会传递，然后谈性能，最后谈反解</text>
</g>
</svg>
</figure>

### 读图要领（第二编）

- **蓝（表示）**：同一姿态三种写法，参数越少代价越大（欧拉角奇点、角和轴不唯一）——按任务选型。
- **金（传递）**：DH 把相邻坐标系标准化成 4 参数，正运动学从此是流水线；七种结构是七次试跑。
- **绿（性能）**：任务在操作空间、能力在关节空间——差是冗余、边界是工作空间、误差靠标定。
- **红（逆问题）**：解耦条件（[@thm-2.12.B]）是闭合解门槛，解释「臂 + 球形腕」的统治性设计，也为第 3 章雅可比留出必要性。


## 第三编 · 微分运动学和静力学：速度与力的代数

第三章（[章总览](ch03/overview.md)）接上第二编末的红框「否则：数值法」——**对非线性的位姿运动学求导，一切重新线性化**：雅可比登场，奇点、冗余、伪逆、静力学全部由它派生。

<figure>
<svg height="470" viewBox="0 0 920 470" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr3" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<!-- 行1: 从位姿到速度 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="10" y="18"></rect><text fill="var(--fig-blue)" x="110" y="43">位姿运动学 x=k(q)（第2编）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="210" x="245" y="18"></rect><text fill="var(--fig-blue)" x="350" y="43">求导：v_e = J(q) q′</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="490" y="18"></rect><text fill="var(--fig-blue)" x="590" y="43">旋转矩阵求导 R′ = S(ω)R</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="720" y="18"></rect><text fill="var(--fig-blue)" x="815" y="43">逐列构造（绿框）</text>
<!-- 行2: 结构的雅可比 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="10" y="128"></rect><text fill="var(--fig-gold)" x="95" y="153">三连杆平面臂</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="220" y="128"></rect><text fill="var(--fig-gold)" x="305" y="153">拟人臂</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="430" y="128"></rect><text fill="var(--fig-gold)" x="515" y="153">斯坦福机械手</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="250" x="640" y="128"></rect><text fill="var(--fig-gold)" x="765" y="153">全部从正运动学 T 读取</text>
<!-- 行3: 两种病 -->
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="10" y="238"></rect><text fill="var(--fig-red, #c96a5a)" x="125" y="263">奇点 det J=0（3.3）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="280" y="238"></rect><text fill="var(--fig-red, #c96a5a)" x="395" y="263">冗余 n&gt;r（3.4）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="250" x="550" y="238"></rect><text fill="var(--fig-green)" x="675" y="263">解耦判据 / 零空间 P=NNT</text>
<!-- 行4: 三味药 + 对偶 -->
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="10" y="348"></rect><text fill="var(--fig-green)" x="110" y="373">J<tspan class="sp">−1</tspan>（方阵）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="240" y="348"></rect><text fill="var(--fig-green)" x="340" y="373">J† 伪逆（冗余）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="470" y="348"></rect><text fill="var(--fig-green)" x="570" y="373">J* 阻尼（奇点）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="700" y="348"></rect><text fill="var(--fig-blue)" x="795" y="373">静力对偶 τ=J<tspan class="sp">T</tspan>F</text>
</g>
<g stroke="var(--muted)" stroke-width="1.4" fill="none" marker-end="url(#arr3)">
<path d="M210,38 L245,38"></path><path d="M455,38 L490,38"></path><path d="M690,38 L720,38"></path>
<path d="M815,58 L815,128" opacity="0"></path>
<path d="M110,58 L95,128"></path><path d="M350,58 L305,128"></path><path d="M590,58 L515,128"></path>
<path d="M95,168 L125,238"></path><path d="M515,168 L395,238"></path>
<path d="M210,238 L395,238" opacity="0"></path>
<path d="M125,278 L110,348"></path><path d="M395,278 L340,348"></path><path d="M395,278 L570,348"></path>
<path d="M675,278 L795,348"></path>
</g>
<g font-size="12" fill="var(--muted)" text-anchor="middle">
<text x="460" y="110">三种结构：同一台流水线</text>
<text x="460" y="225">两种「不方阵」：退化与欠定</text>
<text x="460" y="440">自上而下：先求导得 J，再按结构组装，然后治两种病，最后接上力</text>
</g>
</svg>
</figure>

### 读图要领（第三编）

- **蓝（求导链）**：位姿运动学 → 微分运动学是本章全部内容的根；$\dot R=S(\omega)R$ 是把「姿态随时间变」翻译成「角速度」的关键一步（[@thm-3.1.A]）。
- **金（结构）**：三种结构共用一台流水线，且所有中间量都来自第 2 编的 $T_i^0$——**第 2 编打得牢，第 3 编才算得顺**。
- **红（两种病）**：奇点是「秩亏」（列不够用）、冗余是「欠定」（列太多）——一左一右两个方向的病。
- **绿（三味药）**：$J^{-1}$ / $J^\dagger$ / $J^*$ 按方阵满秩 / 长方形 / 退化对号；**静力对偶**（蓝框）是收束：$J$ 转置后把力接回关节。


## 第四编 · 轨迹规划：让机器人按你要的方式动

第四章（[章总览](ch04/overview.md)）接着第三编的「力与速度」往下走：**前三章回答「到哪去」，这一章回答「怎么去」**——把起点和终点连成一条底层伺服跟得住、又不超出物理极限的曲线。板书（老师开课前预写、全程未擦）与课件、教材的结构完全一致。

<figure>
<svg height="430" viewBox="0 0 920 430" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr4" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="10" y="16"></rect><text fill="var(--fig-blue)" x="110" y="41">路径 = 纯几何</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="220" x="240" y="16"></rect><text fill="var(--fig-blue)" x="350" y="41">轨迹 = 路径 + 时间律</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="240" x="490" y="16"></rect><text fill="var(--fig-blue)" x="610" y="41">运动规划 = 轨迹 + 避障/优化</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="140" x="760" y="16"></rect><text fill="var(--fig-gold)" x="830" y="41">伺服参考输入</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="150" x="10" y="120"></rect><text fill="var(--fig-green)" x="85" y="145">点对点（4.2.1）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="120" x="180" y="120"></rect><text fill="var(--fig-green)" x="240" y="145">三次</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="120" x="320" y="120"></rect><text fill="var(--fig-green)" x="380" y="145">五次</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="460" y="120"></rect><text fill="var(--fig-green)" x="560" y="145">混合 = 梯形速度（重点）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="220" x="680" y="120"></rect><text fill="var(--fig-green)" x="790" y="145">指定加速度 / 指定巡航速度</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="150" x="10" y="222"></rect><text fill="var(--fig-gold)" x="85" y="247">系列点（4.2.2）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="150" x="180" y="222"></rect><text fill="var(--fig-gold)" x="255" y="247">指定任意速度</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="150" x="350" y="222"></rect><text fill="var(--fig-gold)" x="425" y="247">按规则计算速度</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="190" x="520" y="222"></rect><text fill="var(--fig-gold)" x="615" y="247">连续加速度（样条）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="180" x="730" y="222"></rect><text fill="var(--fig-gold)" x="820" y="247">抛物线 + 线性混合</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="180" x="10" y="324"></rect><text fill="var(--fig-red, #c96a5a)" x="100" y="349">操作空间（4.3）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="220" x="210" y="324"></rect><text fill="var(--fig-red, #c96a5a)" x="320" y="349">路径基元：直线 / 圆弧</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="450" y="324"></rect><text fill="var(--fig-red, #c96a5a)" x="565" y="349">位置：p=f(s) + s(t)</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="220" x="700" y="324"></rect><text fill="var(--fig-red, #c96a5a)" x="810" y="349">指向：欧拉角 / 角和轴</text>
</g>
<g stroke="var(--muted)" stroke-width="1.4" fill="none" marker-end="url(#arr4)">
<path d="M350,56 L350,120"></path><path d="M610,56 L560,120"></path>
<path d="M85,160 L85,222"></path>
<path d="M790,160 L820,222"></path>
<path d="M85,262 L100,324"></path><path d="M615,262 L565,324"></path>
<path d="M830,262 L810,324"></path>
</g>
<g font-size="12" fill="var(--muted)" text-anchor="middle">
<text x="460" y="100">关节空间是基础：先点对点，再系列点</text>
<text x="460" y="204">点对点：约束少 ⇒ 用指标锁死；工业选梯形</text>
<text x="460" y="306">系列点：每段差 2 个条件 ⇒ 四条补法</text>
<text x="460" y="404">操作空间：几何归路径、时间归标量 s(t) / θ(t) ⇒ 复用关节空间的方法</text>
</g>
</svg>
</figure>

### 读图要领（第四编）

- **蓝（概念分层）**：路径 ⊂ 轨迹 ⊂ 运动规划，各加一层（时间律、避障与优化）；轨迹规划的产出是**底层伺服的参考输入**（位置 + 速度 + 加速度）。
- **绿（点对点）**：三次是「最小能量」的答案、五次是「要管初终加速度」的答案，**工业的答案是梯形速度曲线**——老师明说这是重点（0:48:11）。
- **金（系列点）**：每段差 2 个条件，补法不同就是四条路线；只有样条保证**加速度连续**，工业最常用的是**抛物线 + 线性混合**。
- **红（操作空间）**：几何路径先解析化（参数、弧长、Frenet 标架），再用标量 $s(t)$（位置）与 $\theta(t)$（姿态）把关节空间的全部武器搬过来——**两次降维**是本章最漂亮的一步。

## 第五编 · 执行器与传感器：把「算出来的」变成「做得到的」

第四编解决的是「怎么去」，但那条轨迹最终要靠**硬件**去执行、靠**传感器**去闭环。第五章（[章总览](ch05/overview.md)）从**算法世界回到物理世界**：先讲**执行器**（怎么把能量变成关节运动），再讲**传感器**（怎么把关节与环境的真实状态读回来）。这一编的落点在第 8 章：本章给出的驱动模型与反馈结构，正是第 8 章控制器的被控对象。

<figure>
<svg height="470" viewBox="0 0 920 470" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr5" markerHeight="9" markerWidth="9" orient="arrow" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<!-- 顶行：功率链 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="150" x="10" y="16"></rect><text fill="var(--fig-blue)" x="85" y="42">能源（5.1.4）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="170" x="190" y="16"></rect><text fill="var(--fig-blue)" x="275" y="42">功率放大器（5.1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="390" y="16"></rect><text fill="var(--fig-blue)" x="485" y="42">伺服发动机（5.1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="180" x="610" y="16"></rect><text fill="var(--fig-blue)" x="700" y="42">传动装置（5.1.1）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="100" x="820" y="16"></rect><text fill="var(--fig-gold)" x="870" y="42">关节</text>
<!-- 第二行：驱动建模 -->
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="10" y="125"></rect><text fill="var(--fig-green)" x="110" y="151">电气驱动：四方程（5.2.1）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="240" y="125"></rect><text fill="var(--fig-green)" x="340" y="151">液压驱动：六方程（5.2.2）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="230" x="470" y="125"></rect><text fill="var(--fig-green)" x="585" y="151">两种发电机特性（5.2.1）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="720" y="125"></rect><text fill="var(--fig-green)" x="820" y="151">位置控制 PI（5.2.4）</text>
<!-- 第三行：传动影响与解耦 -->
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="290" x="10" y="234"></rect><text fill="var(--fig-red, #c96a5a)" x="155" y="260">减速比折算：$1/k_r^2$ 管惯量、$1/k_r$ 管力矩</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="330" x="330" y="234"></rect><text fill="var(--fig-red, #c96a5a)" x="495" y="260">多轴强耦合 → 单轴 + 干扰（5.2.3）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="690" y="234"></rect><text fill="var(--fig-red, #c96a5a)" x="805" y="260">独立关节控制</text>
<!-- 第四行：传感器 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="240" x="10" y="343"></rect><text fill="var(--fig-gold)" x="130" y="369">本体传感器：位置 / 速度（5.3）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="240" x="280" y="343"></rect><text fill="var(--fig-gold)" x="400" y="369">外部传感器：力 / 距离 / 视觉（5.4）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="380" x="550" y="343"></rect><text fill="var(--fig-blue)" x="740" y="369">→ 第 8 章运动控制的反馈通道</text>
</g>
<g stroke="var(--muted)" stroke-width="1.4" fill="none" marker-end="url(#arr5)">
<path d="M160,37 L190,37"></path><path d="M360,37 L390,37"></path><path d="M580,37 L610,37"></path><path d="M790,37 L820,37"></path>
<path d="M870,58 L870,125"></path>
<path d="M110,167 L155,234"></path><path d="M340,167 L340,234" opacity="0"></path>
<path d="M585,167 L495,234"></path>
<path d="M130,385 L130,385" opacity="0"></path>
<path d="M400,385 L400,385" opacity="0"></path>
<path d="M130,276 L130,343"></path><path d="M130,276 L400,343" opacity="0"></path>
<path d="M805,276 L805,343"></path>
<path d="M250,364 L280,364"></path>
</g>
<g font-size="12" fill="var(--muted)" text-anchor="middle">
<text x="460" y="105">功率链：能源 → 功放 → 发动机 → 传动 → 关节</text>
<text x="460" y="214">建模：把每一段写成方程、拼成框图</text>
<text x="460" y="322">关键推论：大减速比把多轴耦合削弱成「单轴 + 干扰」</text>
<text x="460" y="430">传感器分内外：本体量闭环伺服、外部量认识环境</text>
</g>
</svg>
</figure>

### 读图要领（第五编）

- **蓝（功率链）**：能源 / 功放 / 发动机 / 传动四部分，是 §5.1 的骨架；标准国际单位下 $k_t=k_v$ 是电与机之间的桥。
- **绿（建模）**：电气驱动四个方程给出两种「发电机」特性——**速度控制**（不加电流反馈，抗扰好）与**力矩控制**（加电流反馈，力矩独立于转速）；液压驱动是同一套结构的平行版本，多出**渗漏**与**可压缩性**两项。
- **红（传动的影响）**：**$1/k_r^2$ 管惯量与摩擦、$1/k_r$ 管负载力矩与非线性**。这一框是本章与第 7 章的分界线：多轴强耦合被削弱成「可独立设计的单轴 + 干扰」，独立关节控制因此成立。
- **金（传感器）**：本体传感器（位置、速度）是伺服的反馈源；外部传感器（力、距离、视觉）让机器人认识环境——两者的判据是「**量的是自己还是环境**」。
- **向右的箭头**：本章的驱动模型与反馈结构，正是第 8 章运动控制器的**被控对象**；位置环 PI 与测速反馈在那里被正式设计。
