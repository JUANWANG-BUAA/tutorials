# 7.3 计算力矩（逆动力学）控制

> **教材补写**（课件 §8.5「集中控制：重力补偿 PD、逆动力学、鲁棒、自适应」中的逆动力学一项）。
> 本讲只在两处提到它：归入「集中控制」名下（01:59:48–02:00:00）、解释「为什么分散控制不够用」
> （02:16:00–02:16:23）；具体控制律是下一讲内容，本节按教材（Siciliano 第 8 章「计算力矩控制」
> 一节）与第六章的记法预写，公式 (7.15)–(7.17) 与稳定性论证全部为教材补，第 9 周录播后校订。

<a id="sec-7.3.1"></a>

## 7.3.1 为什么会想到「用模型抵消非线性」

第六章的方程是非线性的：

$$B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau .$$

它难控，难在**三项都随状态变**：$B$ 随位形、$C\dot{\boldsymbol q}$ 随速度、$\boldsymbol g$ 随位形。
如果有一个「上帝视角」的执行器能直接指定 $\ddot{\boldsymbol q}$，控制就退化成三个独立的线性二阶
问题——这不可能，但**可以伪装**：既然 $\boldsymbol\tau$ 与 $\ddot{\boldsymbol q}$ 之间隔着一段
「已知的」非线性变换，那就先把它反解掉。

$$\boldsymbol\tau
=\underbrace{B(\boldsymbol q)\boldsymbol u+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+\boldsymbol g(\boldsymbol q)}_{\text{用模型把非线性「抵消」掉}}
\ \Longrightarrow\
B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}-\boldsymbol u\bigr)=0
\ \Longrightarrow\
\ddot{\boldsymbol q}=\boldsymbol u .$$

最后一步用到的正是第六章的**性质一**：$B(\boldsymbol q)$ 对称正定 ⇒ **可逆**。于是「原来的非线性
被控对象」在输入端被改造成了 $n$ 个**双积分器** $\ddot q_i=u_i$。

::: intuition 这就是「反馈线性化」这个名字的来历
上面这一步**不是近似**（只要模型准确）：$\boldsymbol\tau$ 的表达式里显式含有 $\boldsymbol q,
\dot{\boldsymbol q}$，它们是**实测反馈**，所以消掉非线性靠的是反馈，不是在工作点附近做 Taylor 展开。
这与「小偏差线性化」有本质区别：**前者大范围有效，后者只在工作点附近有效**。
:::

<a id="sec-7.3.2"></a>

## 7.3.2 计算力矩律与误差方程

把「双积分器」用标准 PD 闭环：取 $\boldsymbol u=\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}
+K_P\boldsymbol e$，代回去就是**计算力矩律**（computed torque，也叫逆动力学控制 inverse
dynamics control）：

$$\boxed{\ \boldsymbol\tau
=B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}+K_P\boldsymbol e\bigr)
+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)\ }\tag{7.15}$$

$$K_P=\operatorname{diag}\{K_{P_1},\dots,K_{P_n}\},\qquad
K_D=\operatorname{diag}\{K_{D_1},\dots,K_{D_n}\}.$$

代进被控对象（假设模型精确），$B$ 可逆，两边左乘 $B^{-1}$：

$$\ddot{\boldsymbol q}=\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}+K_P\boldsymbol e
\quad\Longrightarrow\quad
\boxed{\ \ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e=\boldsymbol 0\ }\tag{7.16}$$

**这是本章最漂亮的一行**：一个 $n$ 自由度、强耦合、非线性的机械手，在 (7.15) 的作用下，误差方程
变成了 **$n$ 个互不耦合的线性二阶系统**

$$\ddot e_i+K_{D_i}\dot e_i+K_{P_i}e_i=0,\qquad i=1,\dots,n,$$

只要 $K_{P_i},K_{D_i}>0$，每个 $e_i(t)$ 都按指数衰减到零。**全局、解耦、线性**，三个词同时成立。

**与 7.2 的分散控制差在哪**：两者的「反馈壳」长得一样（都是 PD），差别全在**前馈项**。

| | 分散控制（7.2） | 计算力矩（本节） |
|:--|:--|:--|
| 前馈 | 无（或只用重力 $\boldsymbol g$、或前馈 (7.13)） | $B\ddot{\boldsymbol q}_d+C\dot{\boldsymbol q}+\boldsymbol g$ 全补 |
| 误差方程 | $J_i\ddot e_i+K_{D_i}\dot e_i+K_{P_i}e_i=d_i'$（**带扰动**） | $\ddot e_i+K_{D_i}\dot e_i+K_{P_i}e_i=0$（**无扰动**，模型精确时） |
| 稳定性 | 依赖耦合小、增益压得住 | 依赖模型准；模型不准时退化为「带扰动的分散系统」 |
| 「集中」在哪 | —— | 在 $\boldsymbol\tau$ 的**计算**：必须用整机 $B,C,\boldsymbol g$ 与全部状态 |

<a id="sec-7.3.3"></a>

## 7.3.3 模型不准确时会怎样

(7.16) 的干净形式依赖「模型精确」这个前提，而工程上永远做不到。设实际模型为
$B=\hat B+\Delta B$、$C=\hat C+\Delta C$、$\boldsymbol g=\hat{\boldsymbol g}+\Delta\boldsymbol g$
（带帽的是控制器里用的标称模型），控制器仍用 (7.15) 的标称版：

$$\boldsymbol\tau=\hat B\bigl(\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}+K_P\boldsymbol e\bigr)
+\hat C\dot{\boldsymbol q}+\hat{\boldsymbol g}.$$

代入真对象、整理后误差方程多出一项**不确定性**：

$$\boxed{\ \ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e
=\underbrace{B^{-1}\bigl[\Delta B\,\boldsymbol u+\Delta C\,\dot{\boldsymbol q}
+\Delta\boldsymbol g\bigr]}_{\text{模型误差「漏」进来的项}}\ }\tag{7.17}$$

**这一项正是鲁棒/自适应控制的入口**：(7.17) 说明计算力矩把「非线性」换成了「不确定性」。$\Delta$
有界且小时，PD 增益留足裕度就能压住（鲁棒性）；$\Delta$ 是**参数误差**时，可用第六章的**性质二**
把它参数化：

$$\Delta B\boldsymbol u+\Delta C\dot{\boldsymbol q}+\Delta\boldsymbol g
=Y(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol u)\,\Delta\boldsymbol\pi ,$$

于是可以设计自适应律在线估 $\Delta\boldsymbol\pi$，或用 $\boldsymbol\tau=Y\hat{\boldsymbol\pi}$
在线辨识（[6.2.2](../ch06/sec6-2-2.md)）。课件 §8.5 把「鲁棒控制」「自适应控制」与逆动力学控制
并列，原因就在这里：**它们都是给 (7.17) 的右边擦屁股**。本课程不展开；老师在第 8 周收尾时说
「到后面尤其鲁棒控制、自适应控制，那理论性还是很强」（02:03:05），可作选修方向。

<a id="sec-7.3.4"></a>

## 7.3.4 实现要点（工程上真正决定成败的地方）

1. **要在线算整机模型**。(7.15) 每个控制周期都要算 $B,C,\boldsymbol g$ 与 $\boldsymbol u$。直接按
   公式算是 $O(n^2)$ 量级；用**牛顿–欧拉递推**（[6.4](../ch06/sec6-4.md)，本讲前半段刚讲完）
   可以做到 $O(n)$，这是它在实时控制里不可替代的原因。
2. **$B$ 可逆是白给的**：$B$ 对称正定（[6.1.1.5](../ch06/sec6-1-1.md)），永远可逆——**但数值条件数
   可能很差**（接近奇异位形、惯量比悬殊时），需要留数值裕度。
3. **必须有力矩限幅**：(7.15) 无上界，误差大时算出的 $\boldsymbol\tau$ 会超过电机能力。限幅后
   「精确对消」不再成立，(7.17) 的不确定性变大——**限幅是计算力矩最常见的失效原因**。
4. **采样周期要够短**：$C\dot{\boldsymbol q}$ 与 $B$ 的时变由 $\boldsymbol q,\dot{\boldsymbol q}$
   描述，采样太慢时「用旧状态算新力矩」会让对消失效，等效为时滞。
5. **参数要先辨识**：$\Delta\boldsymbol\pi$ 越小，(7.17) 的右边越小。第六章的
   $\boldsymbol\tau=Y\boldsymbol\pi$ 就是为辨识准备的（最小二乘即可）。

::: think 常见错误清单
1. **把 (7.15) 里的 $\boldsymbol q$ 写成 $\boldsymbol q_d$**：一写就退回 7.2.6 的前馈，不再是反馈线性化。
2. **以为误差方程 (7.16) 与机械手参数无关**：无关的前提是**模型精确**且**未限幅**；
   两个前提破一个，(7.17) 就回来了。
3. **只补重力就叫「计算力矩」**：那是 7.2.4 的重力补偿 PD，误差方程里仍有 $B,C$ 项。
4. **增益按标量给**：$K_P,K_D$ 常取对角，但要与各轴惯量匹配（$\omega_n$ 相近），
   否则快轴抖、慢轴拖。
5. **忘记 $B$ 的条件数**：近奇异位形处 $B$ 虽可逆但病态，$\boldsymbol\tau$ 会爆——要限幅并报警。
:::

::: think 默写点 · 合上书再写
1. 写出计算力矩律 (7.15)，并推出误差方程 (7.16)，指出哪一步用了 $B$ 的正定性。
2. 说明「反馈线性化」与「小偏差线性化」的区别。
3. 写出模型不准确时的误差方程 (7.17)，并说明它通向哪两类高级方法。
4. 列出计算力矩的至少三条实现约束。
:::
