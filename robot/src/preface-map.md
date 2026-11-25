# 全书知识地图

读这张地图时，可以沿着卷首的任务找问题：机械臂取出螺丝刀，移到螺栓前，对准、拧紧，再放回。第一章判断结构与系统是否合适；第二章描述目标位姿；第三章把关节速度换成工具速度，并建立静力传递关系；第四章安排路径与时间；第五章认识驱动能力和测量通道；第六章计算轨迹所需力矩，再与驱动能力核对；第七章根据实测偏差修正运动。

[两连杆练习](training/two-link.md)把其中的位置运动简化成可手算的平面 2R 任务，后续各关继续复用它。这个简化不能独立控制位置与任意朝向，也不代表已经解决工具抓取或接触拧紧。下面的详细图、公式和链接用于展开这些问题；涉及原书章号时，以各段说明为准。

## 第一编 · 引言：机器人学的骨架

第一章先看机器人的定义与四子系统（[1.1](ch01/sec1-1.md)），再看机械手（[1.2](ch01/sec1-2.md)）与移动底盘（[1.3](ch01/sec1-3.md)）的结构边界。部署要求分项分析（[1.4](ch01/sec1-4.md)）；建模、规划与控制把这些要求转成可计算的问题（[1.5](ch01/sec1-5.md)）。图底行按原书编号，本站七章与原书主题的对应入口见 §1.5.4。

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
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="150" x="720" y="298"></rect><text fill="var(--fig-red, #c96a5a)" x="795" y="323">四问分别分析</text>
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
<text x="460" y="285">部署：环境、变化、风险与决策分工</text>
<text x="460" y="395">方法论：以下使用原书章号，教程入口见 §1.5.4</text>
</g>
</svg>
</figure>

## 读图要领

- **蓝（顶行）**：「感知与行为之间的智能联系」+ 四子系统闭环——全章总纲。
- **金绿（两类身体）**：机械手（构形 / 拓扑 / 腕解耦）与轮系布局（机动性），在移动机械手处汇合。
- **红（部署问题）**：结构名称不能代替环境与任务分析，四问不合成为“先进程度”。
- **底行**：框内为原书章节；教程第六章对应原书第七章，第七章对应原书第八章。未收录的原书主题在 §1.5.4 标明。

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
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="220" x="250" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="360" y="373">闭解充分条件：三轴共点 / 平行</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="200" x="510" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="610" y="373">球腕：腕心分离臂与腕</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="150" x="750" y="348"></rect><text fill="var(--fig-red, #c96a5a)" x="825" y="373">数值逆解 → 第 3 章</text>
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
- **红（逆问题）**：连续三转轴共点或平行是六自由度闭解的充分条件，不是必要门槛。末三轴共点的球腕可用腕心拆成臂与腕，三轴平行的结构不能直接套这条腕心公式（[@thm-2.12.B]）。


## 第三编 · 微分运动学和静力学：速度与力的代数

第三章（[章总览](ch03/overview.md)）接上第二编末的红框「否则：数值法」——**对非线性的位姿运动学求导，一切重新线性化**：雅可比登场，奇点、冗余、伪逆、静力学全部由它派生。

<figure>
<svg height="470" viewBox="0 0 920 470" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr3" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<!-- 行1: 从位姿到速度 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="10" y="18"></rect><text fill="var(--fig-blue)" x="110" y="43">正运动学 p(q)、R(q)（第2编）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="210" x="245" y="18"></rect><text fill="var(--fig-blue)" x="350" y="43">求导：v_e = J(q) q′</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="490" y="18"></rect><text fill="var(--fig-blue)" x="590" y="43">旋转矩阵求导 R′ = S(ω)R</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="720" y="18"></rect><text fill="var(--fig-blue)" x="815" y="43">逐列构造 J（3.1）</text>
<!-- 行2: 结构的雅可比 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="10" y="128"></rect><text fill="var(--fig-gold)" x="95" y="153">三连杆平面臂</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="220" y="128"></rect><text fill="var(--fig-gold)" x="305" y="153">拟人臂</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="170" x="430" y="128"></rect><text fill="var(--fig-gold)" x="515" y="153">斯坦福机械手</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="250" x="640" y="128"></rect><text fill="var(--fig-gold)" x="765" y="153">全部从正运动学 T 读取</text>
<!-- 行3: 任务条件与零空间 -->
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="10" y="238"></rect><text fill="var(--fig-red, #c96a5a)" x="125" y="263">奇点：任务秩下降（3.3）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="280" y="238"></rect><text fill="var(--fig-red, #c96a5a)" x="395" y="263">冗余 n&gt;r（3.4）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="250" x="550" y="238"></rect><text fill="var(--fig-green)" x="675" y="263">解耦 / 零空间投影（正交基）</text>
<!-- 行4: 按条件和目标求逆速度；另列静力对偶 -->
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="10" y="348"></rect><text fill="var(--fig-green)" x="110" y="373">J<tspan class="sp">−1</tspan>（方阵满秩）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="240" y="348"></rect><text fill="var(--fig-green)" x="340" y="373">J† 最小范数/最小二乘</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="200" x="470" y="348"></rect><text fill="var(--fig-green)" x="570" y="373">J* 速度与残差权衡</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="190" x="700" y="348"></rect><text fill="var(--fig-blue)" x="795" y="373">静力对偶 τ=J<tspan class="sp">T</tspan>F</text>
</g>
<g stroke="var(--muted)" stroke-width="1.4" fill="none" marker-end="url(#arr3)">
<path d="M210,38 L245,38"></path><path d="M455,38 L490,38"></path><path d="M690,38 L720,38"></path>
<path d="M110,58 L95,128"></path><path d="M350,58 L305,128"></path><path d="M590,58 L515,128"></path>

</g>
<g font-size="12" fill="var(--muted)" text-anchor="middle">
<text x="460" y="110">三种结构：同一台流水线</text>
<text x="460" y="225">检查任务条件：奇异与冗余可以同时出现</text>
<text x="340" y="322">逆速度求解：结合矩阵条件与求解目标选取（3.5）</text>
<text x="460" y="440">先求导、组装 J，再判断任务与求解目标，最后建立静力对偶</text>
</g>
</svg>
</figure>

### 读图要领（第三编）

- **蓝（求导链）**：位姿运动学 → 微分运动学是本章全部内容的根；$\dot R=S(\omega)R$ 是把「姿态随时间变」翻译成「角速度」的关键一步（[@thm-3.1.A]）。
- **金（结构）**：三种结构共用一台流水线，且所有中间量都来自第 2 编的 $T_i^0$——**第 2 编打得牢，第 3 编才算得顺**。
- **红（任务条件）**：奇点指当前任务秩低于最大可达秩；冗余比较关节数与任务维数。冗余机械手也可能处在奇点，两者并非互斥。
- **绿（逆速度求解）**：普通逆要求方阵满秩；一般伪逆给最小范数的最小二乘解，可行时精确满足任务；DLS以任务残差与关节速度代价作权衡。右伪逆闭式还要求行满秩，见[§3.5](ch03/sec3-5.md)。**静力对偶**（蓝框）则用转置将末端力映回关节。


## 第四编 · 轨迹规划：让机器人按你要的方式动

第四章（[章总览](ch04/overview.md)）接着第三编的速度映射，回答“沿哪条路、什么时候到达”。先生成位置、速度与加速度参考，再检查关节约束；驱动力矩是否足够还需第五、六章的信息。课堂板书、课件与教材的来源对照见该章导览。

<figure>
<svg height="430" viewBox="0 0 920 430" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr4" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="10" y="16"></rect><text fill="var(--fig-blue)" x="110" y="41">路径 = 纯几何</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="220" x="240" y="16"></rect><text fill="var(--fig-blue)" x="350" y="41">轨迹 = 路径 + 时间律</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="40" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="240" x="490" y="16"></rect><text fill="var(--fig-blue)" x="610" y="41">运动规划：按任务与约束找方案</text>
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

- **蓝（概念关系）**：路径不指定时间；轨迹加入时间律；运动规划按任务、环境和约束寻找可行方案，可包含避障和优化，三者不宜当成严格集合包含关系。
- **绿（点对点）**：固定端点位置/速度、常惯量且忽略其他力矩时，最小平方力矩给三次；一般指定六个端点条件需至少五次。梯形速度曲线便于直接设置加速度峰值，老师强调「重点介绍混合梯形」（0:48:11）。
- **金（系列点）**：指定或计算节点速度通常只保证速度连续；三次样条进一步约束加速度连续，抛物线混合则通常允许从经由点附近经过。是否精确插值与连续到几阶应分别核对。
- **红（操作空间）**：固定几何路径后，位置可用标量弧长 $s(t)$ 安排进度；固定相对旋转轴后，姿态可用转角 $\theta(t)$ 安排进度，两者仍须检查关节侧可行性。

## 第五编 · 执行器与传感器：把「算出来的」变成「做得到的」

第四编解决的是「怎么去」，但那条轨迹最终要靠**硬件**去执行、靠**传感器**去闭环。第五章（[章总览](ch05/overview.md)）从**算法世界回到物理世界**：先讲**执行器**（怎么把能量变成关节运动），再讲**传感器**（怎么把关节与环境的真实状态读回来）。这一编的落点在第七编：本章给出的驱动模型与反馈结构，正是运动控制器（原书第 8 章，本教程第七章）的被控对象。

<figure>
<svg height="470" viewBox="0 0 920 470" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr5" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
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
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="290" x="10" y="234"></rect><text fill="var(--fig-red, #c96a5a)" x="155" y="260">减速比折算：1/k_r² 管惯量、1/k_r 管力矩</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="330" x="330" y="234"></rect><text fill="var(--fig-red, #c96a5a)" x="495" y="260">多轴强耦合 → 单轴 + 干扰（5.2.3）</text>
<rect fill="color-mix(in srgb, var(--fig-red, #c96a5a) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red, #c96a5a) 45%, transparent)" width="230" x="690" y="234"></rect><text fill="var(--fig-red, #c96a5a)" x="805" y="260">独立关节控制</text>
<!-- 第四行：传感器 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="240" x="10" y="343"></rect><text fill="var(--fig-gold)" x="130" y="369">本体传感器：位置 / 速度（5.3）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="240" x="280" y="343"></rect><text fill="var(--fig-gold)" x="400" y="369">外部传感器：力 / 距离 / 视觉（5.4）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="380" x="550" y="343"></rect><text fill="var(--fig-blue)" x="740" y="369">→ 第七编运动控制的反馈通道</text>
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
- **红（传动的影响）**：理想折算中，负载惯量与黏性摩擦按 $1/k_r^2$、负载力矩按 $1/k_r$ 折到电机侧；大减速比可削弱负载动态的相对影响，但是否支持独立关节近似仍须核查转速、耦合扰动和误差要求。
- **金（传感器）**：本体传感器（位置、速度）是伺服的反馈源；外部传感器（力、距离、视觉）让机器人认识环境——两者的判据是「**量的是自己还是环境**」。
- **向右的箭头**：本章的驱动模型与反馈结构，正是第七编运动控制器（原书第 8 章）的**被控对象**；位置环 PI 与测速反馈在那里被正式设计。

## 第六编 · 动力学：从「怎么动」到「用多大力」

第五编给出了驱动与测量模型，但还没算出“要沿指定轨迹运动，关节需要多大的力矩”。第六章（[章总览](ch06/overview.md)，对应原书第 7 章）先用能量法建立方程，再学习递推计算、辨识与操作空间模型。下图先省略摩擦；其中 $h_e$ 是末端向环境施加的力，$C$ 采用 Christoffel 选法。

```text
广义坐标 q ──→ 动能 T = ½ q̇ᵀB(q)q̇ ──┐
                                   ├──→ L = T − U ──→ 拉格朗日方程
              势能 U = U(q) ────────┘
                                   │
                                   ├──→ B(q)q̈ + C(q,q̇)q̇ + g(q) = τ − Jᵀhₑ
                                   │
                                   ├──→ 性质一：Ḃ − 2C 反对称（能量/无源性）
                                   └──→ 性质二：τ = Y(q,q̇,q̈)π（参数线性）
```

**三个阶段**：

1. **能量**（6.1）：把 $n$ 个连杆 + $n$ 个转子的动能写成二次型，把重力势能写成 $q$ 的函数；
2. **方程**（6.1.3）：代拉格朗日方程，得到 $B\ddot q+C\dot q+g=\tau-J^{\mathrm T}h_e$，并认领每一项的物理意义；
3. **结构**（6.2）：Christoffel 选法下 $\dot B-2C$ 反对称；任一满足同一物理速度项的 $C$ 都有沿速度的能量恒等式。参数线性式 $\tau=Y\pi$ 则用于辨识与自适应，须排除或另计已知接触力。

**两个算例**：笛卡儿臂（$B$ 常数、$C=0$、解耦）与平面臂（$B(q)$、离心/科氏、重力耦合）。前者告诉你「什么情况下最简单」，后者告诉你「一般情况下复杂在哪」。

**与第七编的接口**：第七编（原书第 8 章）的计算力矩控制写成

$$\tau=B(q)\bigl(\ddot q_d+K_D\dot e+K_P e\bigr)+C(q,\dot q)\dot q+g(q),$$

其中 $B,C,g$ 全部来自本章。**没有这一章，控制律只是三个矩阵符号；有了这一章，才知道它们各自补偿的是什么物理效应。**


## 第七编 · 运动控制：从模型到闭环

第六编交出的是 $B\ddot q+C\dot q+g=\tau$——**一个模型**；第七编回答的是「给定 $q_d(t)$ 或 $x_d(t)$，怎样设计 $\tau(t)$，使实际运动跟上，并扛住摩擦、噪声与模型偏差」。

```text
控制问题（7.1）
   │  任务在操作空间提出、控制动作在关节空间实现
   ├─ 两套方案：关节空间（x 开环） / 操作空间（x 闭环）
   ├─ 两类架构：分散（各关节独立） / 集中（整机模型统一设计）
   │      └─ 判别依据在驱动：大减速比 + 小电枢电阻 + 小转矩 ⇒ q̇ ∝ v_c（速度源）
   ├─ 具体控制律：PD/PID → 重力补偿 → 计算力矩（逆动力学）
   └─ 操作空间控制与三方案比较
```

**与第六编的接口**：计算力矩控制写成

$$\tau=B(q)\bigl(\ddot q_d+K_D\dot e+K_Pe\bigr)+C(q,\dot q)\dot q+g(q),$$

其中 $B,C,g$ 来自第六编。上式假设无接触、无摩擦（或已精确补偿）、模型精确、连续状态反馈且力矩未限幅；代回动力学可得线性误差方程。重力补偿 PD 的能量证明则使用 $\dot B-2C$ 的二次型消项，两条证明路线不要混在一起。

**与后续的接口（以下为原书章号，未在本教程中单独成章）**：第 9 章力控制处理环境接触；第 10 章视觉控制讨论由图像形成反馈；第 12 章运动规划重点处理避碰。

> 记号约定：本教程第七章的 PD 增益写作 $K_P,K_D$（位置、速度/微分增益）；旧稿或教材偶用 $K_p,K_v$，二者同义。

## 第八编 · 力控制：接触任务的闭环

第七编解决的是自由空间里的跟踪；第八编（[章总览](ch08/overview.md)，对应原书第 9 章）让末端真正碰到环境。顺序是一条工程链：先立力的符号约定与含接触动力学（[8.1](ch08/sec8-1.md)），再看两个刚度如何决定平衡（[8.2](ch08/sec8-2.md) 柔顺）；把平衡升级为二阶动态关系是阻抗与导纳（[8.3](ch08/sec8-3.md)），直接闭环力误差是直接力控制（[8.4](ch08/sec8-4.md)）；理想互易接触给出一对互补子空间（[8.5](ch08/sec8-5.md)），逐方向判定自然/人工约束（[8.6](ch08/sec8-6.md)）后，混合力／运动控制（[8.7](ch08/sec8-7.md)）把两个子空间的控制器接起来；[8.8](ch08/sec8-8.md) 用平面打磨算例把整条链走完。与第七编的接口：本章的被控对象仍是 $B\ddot q+C\dot q+\boldsymbol g=\tau-J^{\mathrm T}h_e$——左端来自第六编，右端的 $J^{\mathrm T}$ 来自第三编的静力对偶。

## 第九编 · 视觉伺服：用眼睛闭环

第八编的力需要接触才有；第九编（[章总览](ch09/overview.md)，对应原书第 10 章）给末端装上「眼睛」，用图像形成反馈。三段式：**看**——图像处理与图像矩（[9.2](ch09/sec9-2.md)）；**算**——PnP 位姿估计的解析解（[9.3](ch09/sec9-3.md)）、相互作用矩阵（[9.4](ch09/sec9-4.md)）与数值算法（[9.5](ch09/sec9-5.md)），相机标定（[9.6](ch09/sec9-6.md)）决定内参在哪条路上出现；**动**——位置式与图像式伺服的取舍（[9.7](ch09/sec9-7.md)）、两类控制律（[9.8](ch09/sec9-8.md)、[9.9](ch09/sec9-9.md)）及其仿真比较（[9.10](ch09/sec9-10.md)）。与第七编的接口：两类控制律分别复用 7.4 的操作空间控制与 7.3 的 PD + 重力补偿；与第八编的接口：视觉测量让「优点只是潜在的」操作空间方案有了**独立的**末端信息来源（[7.1.4.2](ch07/sec7-1.md#sec-7.1.4.2)）。

## 第十编 · 移动机器人建模：无侧滑、李括号与链式形式

前九章机械臂固定在底座上，几何约束可积、位形空间由关节角直接给定；第十编（[章总览](ch10/overview.md)，对应原书第 11 章前半）把机器人放回地面，引入由轮子无侧滑滚动引起的**非完整约束**。六节推进一条闭合链条：**闭环定位与世界/载体系**（[10.1](ch10/sec10-1.md)、[10.2](ch10/sec10-2.md)）写出平面刚体速度与内/外参关系；**Pfaffian 约束与可积性**（[10.3](ch10/sec10-3.md)）区分减少自由度的完整约束与只限制瞬时速度、不减小可达位形的非完整约束；**李括号与对合闭包**（[10.4](ch10/sec10-4.md)）借助 Frobenius 定理与 Chow 定理把「前进与转向组合能否产生侧移」写成向量场满秩条件；**独轮车、差速等效与前/后轮驱动两轮车**（[10.5](ch10/sec10-5.md)）把抽象理论落到三类常见车体参数；**链式系统标准形与二阶／Euler-Lagrange 动力学扩展**（[10.6](ch10/sec10-6.md)）为轨迹构造与后续移动控制搭起接口。

