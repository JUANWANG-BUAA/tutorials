<section class="chapter-cover">
<div class="kicker">机器人控制技术 · 定制教程</div>
<h1>机器人控制技术</h1>
<div class="subtitle">从一台两连杆机械臂开始，学习怎样计算姿势、安排运动，并纠正实际运动中的偏差。</div>
<div class="cover-chips">
<span>7 章 · 65 节正文</span>
<span>分层习题 · 附解答</span>
<span>6 组交互演示</span>
<span>教材、课件与录播对照</span>
</div>
<details class="cover-details">
<summary>查看章节范围与资料说明</summary>
<div class="meta">
覆盖原书 §1.1–§1.5、§2.1–§2.12、§3.1–§3.8、§4.1–§4.3、§5.1–§5.4、§7.1–§7.8（本书第六章）与 §8.1–§8.7（本书第七章）。<br>
依据 <b>Siciliano / Sciavicco / Villani / Oriolo《机器人学：建模、规划与控制》</b>整理扩充：第 1 章全收录；第 2 章完整覆盖 2.1–2.12（课程未授的 2.6 等四处按原书补入并标注）<br>
第一章整理日期 2026-09-14 · 第二章整合第 2 周录播与课堂讲解 · 第三章整合第 3 周录播与教材 · 第四章整合第 4 周录播、课件与板书 · 第五章整合第 6 周录播、课件与板书 · 第六章（原书第 7 章）整合第 7、8 周录播与课件；第七章（原书第 8 章）整合第 8、9 周录播与课件。中文版 OCR 与课件问题分章收入勘误页。
</div>
</details>

<div class="cover-object" aria-hidden="true">
  <div class="book-3d"><div class="book"><div class="face face-front">{{#include assets/covers/robot.svg}}</div></div></div>
</div>
</section>

## 同一个点，两种姿势

两根杆长都是 1 米。机械臂可以用两种姿势碰到同一个点，一种“肘朝上”，另一种“肘朝下”。让关节平滑地从一种姿势转到另一种，末端会一直留在原地吗？

先在纸上画出中途的姿势，再看[两连杆练习](training/two-link.md)。这道题会用到正逆运动学、奇点和轨迹规划。随后给杆加上重量、给电机加上限制，就需要继续学习动力学与控制。

## 从哪里开始

- **系统入门**：先看[阅读方法与七章安排](preface.md)；先修不确定时做[入学诊断](entry-test.md)，读完一章后完成相应的两连杆练习。
- **跟课与作业**：在下方进入对应章节，按章导览中的录播时间学习，再做左侧目录里的作业详解与习题。
- **期末复习**：先闭卷做[综合训练](training/arena.md)，按错题链接回读；再用各章回忆卡检验，而不只是重看公式。

**复习节奏建议**：学完当天先闭卷回忆，约 1 天、3 天、1 周后再抽查；不会的题回读后重新做，会的题也在下次混合抽查。间隔可按个人情况调整，纸笔记录即可。

<section class="book-contents" aria-label="目录">
<div class="bc-head"><span class="bc-kicker">CONTENTS / 目录</span><span class="bc-meta">7 章 · 65 节</span></div>
<div class="bc-list">
<a class="bc-row" href="ch01/overview.md"><span class="bc-no">01</span><span class="bc-title">第一章 · 引言</span><span class="bc-count">5 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch02/overview.md"><span class="bc-no">02</span><span class="bc-title">第二章 · 运动学</span><span class="bc-count">12 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch03/overview.md"><span class="bc-no">03</span><span class="bc-title">第三章 · 微分运动学和静力学</span><span class="bc-count">8 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch04/overview.md"><span class="bc-no">04</span><span class="bc-title">第四章 · 轨迹规划</span><span class="bc-count">6 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch05/overview.md"><span class="bc-no">05</span><span class="bc-title">第五章 · 执行器与传感器</span><span class="bc-count">17 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch06/overview.md"><span class="bc-no">06</span><span class="bc-title">第六章 · 动力学</span><span class="bc-count">12 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch07/overview.md"><span class="bc-no">07</span><span class="bc-title">第七章 · 运动控制</span><span class="bc-count">5 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
</div>
<p class="bc-note">左侧目录是完整导航；页首搜索支持全文检索。</p>
</section>

<footer class="book-colophon">
  <span class="colophon-kicker">COLOPHON / 题记</span>
  <span class="colophon-main">依据 Siciliano 等《机器人学：建模、规划与控制》整理扩充；图版与公式由 SVG / KaTeX 生成。</span>
  <span class="colophon-meta">MDBOOK · 2026-10</span>
</footer>
