<section class="chapter-cover">
<div class="kicker">机器人控制技术 · 定制教程</div>
<h1>引言、运动学、微分运动学、轨迹规划 与 执行器传感器：从骨架到速度、力、运动与硬件</h1>
<div class="subtitle">第一章：机器人学定义、机械手构形、移动机器人、工业与先进机器人学、建模规划控制路线图 · 第二章：旋转矩阵、欧拉角、角和轴、齐次变换、DH 法与正逆运动学 · 第三章：几何雅可比、运动学奇点、冗余、逆微分运动学、分析雅可比与静力学 · 第四章：路径与轨迹、点对点运动（三次 / 五次 / 梯形速度曲线）、通过系列点的运动（样条与抛物线混合）、操作空间的位置与姿态规划 · 第五章：执行系统与传动装置、伺服发动机、电气与液压驱动建模、位置控制、本体传感器（位置与速度）、外部传感器（力 / 距离 / 视觉）—— 依据 Siciliano 等《机器人学：建模、规划与控制》与课程录播（智学北航）整理扩充</div>
<div class="cover-chips">
<span>五编 48 节 · 对应原书 §1.1–§1.5、§2.1–§2.12、§3.1–§3.8、§4.1–§4.3 与 §5.1–§5.4</span>
<span>第一章：5 节 · 10 条定义 · 5 条原理</span>
<span>第二章：12 节 · 与两周录播逐节对齐</span>
<span>插图 174 幅随文嵌入（课堂幻灯片 124 + 自制示意图 45 + 板书与教材图 5）</span>
<span>101 道习题 · 全部附解答 · 5 套作业详解（含第 5 章作业五）</span>
<span>五章勘误对照（原书 + 课件 + 板书）</span>
<span>复习层：公式速查卡 · 术语索引 · 易错点总表</span>
<span>6 张交互操作台：欧拉角正逆互检 · ZYZ↔RPY 对照 · 平面 3R 正运动学 · 两连杆逆解 · 奇点探针 · 三次/五次/LSPB 轨迹对比</span>
</div>
<div class="meta">
依据 <b>Siciliano / Sciavicco / Villani / Oriolo《机器人学：建模、规划与控制》</b>整理扩充：第 1 章全收录；第 2 章完整覆盖 2.1–2.12（课程未授的 2.6 等四处按原书补入并标注）<br>
第一章整理日期 2026-09-14 · 第二章整合第 2 周录播与课堂讲解，整理日期 2026-09-15 · 第三章整合第 3 周录播（2026-09-21）与教材原文，整理日期 2026-09-24 · 第四章整合第 4 周录播（2026-09-28）、课件与板书，整理日期 2026-10-01 · 第五章整合第 6 周录播（2026-10-12）、课件与板书，整理日期 2026-10-13 · 中文版 OCR 与课件问题分章收入勘误页
</div>
</section>

<section class="study-paths" aria-label="建议学习路径">
<article class="study-path">
<span class="path-kicker">30 MIN · QUICK START</span>
<strong>先看懂主线</strong>
<p>读知识地图与五章「全章总结」，建立「机器人是什么 → 怎么用代数描述它的运动 → 它在哪里会失灵 → 怎么让它按你要的方式动 → 靠什么硬件真的动起来」的全局图。</p>
<a href="preface-map.md">开始快速预习 →</a>
</article>
<article class="study-path">
<span class="path-kicker">5–6 H · CHAPTER 1</span>
<strong>按概念链通读第一章</strong>
<p>每节先看学习简报，顺着蓝色「直觉」框读懂判据；读前先看该章的「阅读优先级」表，知道哪几节必须现在读懂。</p>
<a href="ch01/overview.md">从第一章总览开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">10–12 H · CHAPTER 2</span>
<strong>跟随录播通读第二章</strong>
<p>每节标注录播区间、图注给时间点；重点是**亲手重推 9 张 DH 参数表**与平面臂逆解——「参数表写对，剩下就是机械代入」。</p>
<a href="ch02/sec2-1.md">从 2.1 开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">7–8 H · CHAPTER 3</span>
<strong>攻下微分运动学与静力学</strong>
<p>逐列构造绿框与 $\tau=J^{\mathrm T}F_e$ 是老师点明的考试核心；配合中心差分校验亲手算过的雅可比。</p>
<a href="ch03/sec3-1.md">从 3.1 开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">6–7 H · CHAPTER 4</span>
<strong>学会设计轨迹</strong>
<p>老师点明的重点是**梯形速度曲线**；把「约束数 → 阶次」「要求的连续性 → 路线」两条选型链练熟，再用数值自查验一遍样条与混合。</p>
<a href="ch04/sec4-1.md">从 4.1 开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">5–6 H · CHAPTER 5</span>
<strong>从算法回到硬件</strong>
<p>重点是**传动装置的三重作用**与**两个折算因子**（$1/k_r^2$ 管惯量、$1/k_r$ 管力矩）；把电气驱动的四个方程与两种发电机特性推一遍，再到编码器 / 测速 / 力 / 距离 / 视觉的定量题。</p>
<a href="ch05/sec5-1.md">从 5.1 开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">1 H · REVIEW</span>
<strong>用复习层把知识固定住</strong>
<p>公式速查卡一页看完全部公式，术语索引定位概念，易错点总表的 30 道判断题做主动回忆。</p>
<a href="preface-formulas.md">进入公式速查卡 →</a>
</article>
<article class="study-path">
<span class="path-kicker">MASTERY · PRACTICE</span>
<strong>用题目检验掌握</strong>
<p>五编共 101 题全部附解；先独立作答再展开，A / B 组按自评标准判分，自检表逐行对照。</p>
<a href="ch01/exercises.md">进入第一章习题集 →</a>
</article>
</section>

## 本教材怎么读

全书按「卷首 → 五编正文 → 章末」组织。左侧目录是唯一的导航入口，页面顶部有全文搜索（或按 <kbd>/</kbd>），页脚与键盘 <kbd>←</kbd> <kbd>→</kbd> 可翻页。下面按阅读顺序列出各页：

<div class="index-cards">
<a href="preface.md">
  <span class="no">0</span>
  <span class="t">卷首 · 范围与目标</span>
  <span class="d">范围与使用方法 · 学习目标（K/S/A） · 符号表 · 知识地图</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec1-1.md">
  <span class="no">1.1</span>
  <span class="t">机器人学：定义、历史与系统构成</span>
  <span class="d">词源与三定律 · 「感知与行为的智能联系」 · 四子系统 · 交叉学科</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec1-2.md">
  <span class="no">1.2</span>
  <span class="t">机器人机械手：构形与自由度</span>
  <span class="d">连杆与关节 · 开链 / 闭链 · 6 自由度判据 · 五构形对比 · 球形腕解耦</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec1-3.md">
  <span class="no">1.3</span>
  <span class="t">移动机器人：轮系与机动性</span>
  <span class="d">三类车轮 · 五种底盘布局 · 麦轮全向 · 支撑三角形 · 机动性 ≠ 位形</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec1-4.md">
  <span class="no">1.4</span>
  <span class="t">工业机器人学与先进机器人学</span>
  <span class="d">自动化三层次 · 三能力 · 7 款实例速览 · 野外与服务机器人</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/sec1-5.md">
  <span class="no">1.5</span>
  <span class="t">建模、规划与控制：全书路线图</span>
  <span class="d">建模 / 规划 / 控制 · 反馈不可替代 · 十二章映射表</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/summary.md">
  <span class="no">一末</span>
  <span class="t">第一章总结 · 勘误与补注</span>
  <span class="d">一览与主线 · 三句话带走 · OCR 勘误 15 处 · 数据时效</span>
  <span class="go">进入 →</span>
</a>
<a href="ch01/exercises.md">
  <span class="no">一练</span>
  <span class="t">第一章习题集 · 自检表</span>
  <span class="d">A/B/C/D 四组 21 题 · 全部附解 · 自检表</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-1.md">
  <span class="no">2.1</span>
  <span class="t">刚体的姿态</span>
  <span class="d">位姿 = 位置 + 姿态 · 9 个方向余弦 · 第 1 周录播</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-2.md">
  <span class="no">2.2</span>
  <span class="t">旋转矩阵</span>
  <span class="d">$R^TR=I$ · $R^{-1}=R^T$ · 基本旋转 · 三重身份 · 第 1 周录播</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-3.md">
  <span class="no">2.3</span>
  <span class="t">旋转矩阵的合成（含姿态表示回顾）</span>
  <span class="d">三重身份 · 右乘 / 左乘 · 不可交换 · 录播 0:03–0:09、0:30</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-4.md">
  <span class="no">2.4</span>
  <span class="t">欧拉角：ZYZ 与 RPY</span>
  <span class="d">27→12 · ZYZ / RPY 正逆解 · Atan2 误差分析 · 奇点 · 录播 0:06–0:22</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-5.md">
  <span class="no">2.5</span>
  <span class="t">角和轴</span>
  <span class="d">五步左乘 → Rodrigues 矩阵 · 迹求角、反对称求轴 · 录播 0:22–0:30</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-6.md">
  <span class="no">2.6</span>
  <span class="t">单位四元数（教材补充）</span>
  <span class="d">半角打包 · 修掉不唯一与逆解奇点 · 卫星 / 图形学首选 · 课程未授</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-7.md">
  <span class="no">2.7</span>
  <span class="t">齐次变换</span>
  <span class="d">$[\boldsymbol p;1]$ 打包平移与旋转 · $A\in SE(3)$ · 逆不再正交 · 录播 0:31–0:40</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-8.md">
  <span class="no">2.8</span>
  <span class="t">正运动学与 DH 法</span>
  <span class="d">四规则 + 4n 参数（3 常 1 变）· $A_i$ 两步分解 · 十步流程 · 录播 0:40–1:13</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-9.md">
  <span class="no">2.9</span>
  <span class="t">典型机械手结构运动学</span>
  <span class="d">九种结构逐一建表连乘 · 参数表的 0 从哪来 · 录播 1:13–1:35</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-10.md">
  <span class="no">2.10</span>
  <span class="t">关节空间与操作空间</span>
  <span class="d">$\boldsymbol x_e=k(\boldsymbol q)$ · 可达 ⊇ 灵活 · 冗余 $(n,m,r)$ · 录播 1:35–1:49</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-11.md">
  <span class="no">2.11</span>
  <span class="t">运动学标定</span>
  <span class="d">量测反推参数 · 线性化 + 最小二乘 + 迭代 · 录播 1:49–1:55</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/sec2-12.md">
  <span class="no">2.12</span>
  <span class="t">逆运动学问题</span>
  <span class="d">四难点 · 球腕解耦 · 拟人臂 4 解 · 腕 = ZYZ 反解 · 录播 1:55–2:13</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/summary.md">
  <span class="no">二末</span>
  <span class="t">第二章总结 · 勘误与补注</span>
  <span class="d">十二节详表 · 主线 · 课件勘误 · 转写校正对照</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/exercises.md">
  <span class="no">二练</span>
  <span class="t">第二章习题集 · 自检表</span>
  <span class="d">覆盖原书 14 个题号 + 自编 10 题 · 全部附解 · 自检表</span>
  <span class="go">进入 →</span>
</a>
<a href="ch02/homework02.md">
  <span class="no">作业</span>
  <span class="t">第 2 周作业 · 教材化解答</span>
  <span class="d">三题全解 · 与官方解答手册和数值实验三方自洽（verify_homework02.py）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-1.md">
  <span class="no">3.1</span>
  <span class="t">几何雅可比矩阵</span>
  <span class="d">$\dot R=SR$ · 速度合成与两条递推 · 逐列构造（绿框）· 录播 0:27–1:12</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-2.md">
  <span class="no">3.2</span>
  <span class="t">典型机械手结构的雅可比</span>
  <span class="d">三连杆平面臂 · 拟人臂 · 斯坦福 · 五步流水线 · 录播 1:12–1:23</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-3.md">
  <span class="no">3.3</span>
  <span class="t">运动学奇点</span>
  <span class="d">$\det J=0$ · 边界 / 内部 · 例 3.2 · 解耦 · 腕 $s_5$ / 肘 / 肩 · 录播 1:23–1:48</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-4.md">
  <span class="no">3.4</span>
  <span class="t">冗余分析</span>
  <span class="d">任务相关冗余 · 零空间与内部运动 · 解族定理 · 录播 1:47–1:56</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-5.md">
  <span class="no">3.5</span>
  <span class="t">逆微分运动学</span>
  <span class="d">数值积分 · 伪逆与 $\dot q_0$ · DLS 与 $J^*$ · 录播 1:56–2:19</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-6.md">
  <span class="no">3.6</span>
  <span class="t">分析雅可比矩阵</span>
  <span class="d">$\omega$ vs $\dot\varphi$ · $T_A$ 分块 · $J_A=T_A^{-1}J$ · 录播 2:17–2:24</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-7.md">
  <span class="no">3.7</span>
  <span class="t">逆运动学算法</span>
  <span class="d">逆方案 / 转置方案 / 二阶算法 · 方向误差 · 录播 2:24–2:27</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/sec3-8.md">
  <span class="no">3.8</span>
  <span class="t">静力学</span>
  <span class="d">$\tau=J^{\mathrm T}F_e$ · 虚功原理 · 速度 / 力变换对偶 · 录播 0:03 与 2:27</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/homework03.md">
  <span class="no">作业</span>
  <span class="t">第 3 周作业 · 教材习题 3-3 / 3-7</span>
  <span class="d">SCARA 雅可比与奇点全解 · 与教材原文和数值实验三方自洽（verify_ch03_jac.py）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/summary.md">
  <span class="no">三末</span>
  <span class="t">第三章总结 · 勘误与补注</span>
  <span class="d">八节详表 · 主线 · 三句话 · 勘误 E3.1–E3.6 · 转写校正对照</span>
  <span class="go">进入 →</span>
</a>
<a href="ch03/exercises.md">
  <span class="no">三练</span>
  <span class="t">第三章习题集 · 自检表</span>
  <span class="d">A/B/C/D 四组 20 题 · 全部附解 · 自检表</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/sec4-1.md">
  <span class="no">4.1</span>
  <span class="t">路径和轨迹</span>
  <span class="d">路径 ⊂ 轨迹 ⊂ 运动规划 · 运动律的两条硬约束 · 规划器接口 · 两个空间的取舍 · 录播 0:08</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/sec4-2-1.md">
  <span class="no">4.2.1</span>
  <span class="t">点对点运动</span>
  <span class="d">最小能量 ⇒ 三次 · 五次多项式 · **梯形速度曲线（重点）** · 录播 0:39</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/sec4-2-2.md">
  <span class="no">4.2.2</span>
  <span class="t">通过系列点的运动</span>
  <span class="d">四条修正路线 · 三次样条与虚拟点 · 三对角降维 · 抛物线混合与经由点 · 录播 1:10</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/sec4-3-1.md">
  <span class="no">4.3.1</span>
  <span class="t">路径基元</span>
  <span class="d">参数化与弧长 · Frenet 标架 · 直线 / 圆弧的解析表达与圆心公式 · 录播 1:57</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/sec4-3-2.md">
  <span class="no">4.3.2</span>
  <span class="t">位置</span>
  <span class="d">$p_e=f(s)$ + $s(t)$ · 向心 / 切向加速度 · 多段路径与时间超前 · 录播 2:14</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/sec4-3-3.md">
  <span class="no">4.3.3</span>
  <span class="t">指向</span>
  <span class="d">旋转矩阵不能直接插值 · 欧拉角法 · 角和轴法（降为一维 $\theta$） · 录播 2:22</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/homework04.md">
  <span class="no">作业</span>
  <span class="t">第 4 周作业 · 教材习题 4.1 / 4.5 / 4.6</span>
  <span class="d">五次多项式 · 三次样条（虚拟点 + 三对角）· 抛物线混合全解 · 与官方解答逐项核对</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/summary.md">
  <span class="no">四末</span>
  <span class="t">第四章总结 · 勘误与补注</span>
  <span class="d">六节详表 · 主线 · 三句话 · 考试边界 · 勘误 E4.1–E4.6（含帧时间轴校正）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch04/exercises.md">
  <span class="no">四练</span>
  <span class="t">第四章习题集 · 自检表</span>
  <span class="d">A/B/C/D 四组 20 题 · 全部附解 · 自检表 19 条</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-1.md">
  <span class="no">5.1</span>
  <span class="t">关节执行系统</span>
  <span class="d">四组成部分 · 功率链与六个功率符号 · 「功率 = 力 × 速度」 · 录播 23:44</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-1-1.md">
  <span class="no">5.1.1</span>
  <span class="t">传动装置</span>
  <span class="d">三重作用（定量 / 定性 / 减重解耦）· 三种装置选型 · 直接驱动的代价 · 录播 30:54</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-1-2.md">
  <span class="no">5.1.2</span>
  <span class="t">伺服发动机</span>
  <span class="d">三类发动机 · 六条性能要求 · 有刷与无刷的组成与换相 · 步进 · 液压 · 电动/液压对照表 · 录播 38:41</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-1-3.md">
  <span class="no">5.1.3</span>
  <span class="t">功率放大器</span>
  <span class="d">调节任务 · 斩波器 / 逆变器 · PWM 两个指标 · 电液伺服与分布器 · 录播 59:59</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-1-4.md">
  <span class="no">5.1.4</span>
  <span class="t">能源</span>
  <span class="d">电源 = 变压器 + 整流 · 液压源 = 泵 + 储液器 + 阀组 · 「储液器 = 滤波电容」 · 录播 1:02:18</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-2-1.md">
  <span class="no">5.2.1</span>
  <span class="t">电气驱动</span>
  <span class="d">四个基本方程 · 电流反馈双重目的 · 两种发电机与统一传递函数 · 录播 1:05:27</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-2-2.md">
  <span class="no">5.2.2</span>
  <span class="t">液压驱动</span>
  <span class="d">六条基础方程 · 渗漏与可压缩性 · 与电气驱动逐条对照 · 录播 1:22:09</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-2-3.md">
  <span class="no">5.2.3</span>
  <span class="t">传动装置影响</span>
  <span class="d">减速比定义 · $I_{eq},F_{eq}$ 与 $C_l/k_r$ · 大减速比使非线性线性化 · 录播 1:24:51</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-2-4.md">
  <span class="no">5.2.4</span>
  <span class="t">位置控制</span>
  <span class="d">独立关节近似 · 位置环 PI 的理由（两个原点极点）· 测速反馈 · 录播 1:32:31</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-3-1.md">
  <span class="no">5.3.1</span>
  <span class="t">位置传感器</span>
  <span class="d">电位计 · 绝对式 / 增量式编码器 · 格雷码 · 旋转变压器 · 录播 1:48:03</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-3-2.md">
  <span class="no">5.3.2</span>
  <span class="t">速度传感器</span>
  <span class="d">测速发电机 · 由位置差分重建速度的三条途径 · 录播 1:57:55</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-4-1.md">
  <span class="no">5.4.1</span>
  <span class="t">力传感器</span>
  <span class="d">应变片与电桥 · 轴转矩传感器 · 六维腕力与校准矩阵 · 传感器系→接触系变换 · 录播 2:01:51</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-4-2.md">
  <span class="no">5.4.2</span>
  <span class="t">距离传感器</span>
  <span class="d">接近与敏感距离 · 声纳与温度修正 · 两种激光测距 · 厂商演示 · 录播 2:14:15</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/sec5-4-3.md">
  <span class="no">5.4.3</span>
  <span class="t">视觉传感器</span>
  <span class="d">像素与 CCD / CMOS · 投影与相机校准矩阵 · 低水平 / 高水平视觉 · 录播 2:22:15</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/homework05.md">
  <span class="no">作业</span>
  <span class="t">第 6 周作业 · 教材习题 5.1 / 5.6 / 5.7</span>
  <span class="d">稳态两种发电机 · 接触系等价力/力矩 · SCARA + CCD 像素坐标 · 与官方解答逐项核对</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/summary.md">
  <span class="no">五末</span>
  <span class="t">第五章总结 · 勘误与补注</span>
  <span class="d">十二节详表 · 主线 · 三句话 · 考试边界 · 勘误 E5.1–E5.6（含 guid 陷阱与帧时间轴）</span>
  <span class="go">进入 →</span>
</a>
<a href="ch05/exercises.md">
  <span class="no">五练</span>
  <span class="t">第五章习题集 · 自检表</span>
  <span class="d">A/B/C/D 四组 20 题 · 全部附解 · 自检表 32 条</span>
  <span class="go">进入 →</span>
</a>
</div>

<p class="kbd-hint">提示：解答默认折叠，点击「解答」展开；习题页有「展开全部解答」按钮；打印时会自动展开全部解答。第二至五章各节标题下标注录播区间，图注给时间点，可对照原片学习；第四、五章另有老师板书原貌（开课前预写的全章路线图 / 执行系统框图）。</p>
