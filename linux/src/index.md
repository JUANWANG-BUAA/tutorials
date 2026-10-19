<section class="chapter-cover">
<div class="kicker">Linux 系统与内核 · 定制教程</div>
<h1>Linux 系统与内核</h1>
<div class="subtitle">从命令行到云原生：把「会用 Linux」「会写系统程序」「看得懂内核」「调得动网络」连成一条线，最后用四个真实项目把知识压成工程能力。</div>
<div class="cover-chips">
<span>六篇 · 85 章</span>
<span>11 个真实项目</span>
<span>10 部母本逐章覆盖</span>
<span>图版 / 速查 / 回忆卡 / 自测卷</span>
</div>
<details class="cover-details">
<summary>查看母本与取舍</summary>
<div class="meta">
依据 <b>《Linux/UNIX 系统编程手册》</b>（Kerrisk）、<b>《深入理解计算机系统》</b>（CSAPP, 3e）、<b>《操作系统导论》</b>（OSTEP）、<b>《操作系统原理、实现与实践》</b>（李治军）、<b>《奔跑吧 Linux 内核》</b>、<b>《深入理解 Linux 网络》</b>、<b>《鸟哥的 Linux 私房菜 · 基础学习篇》</b>、<b>《Linux 命令行大全》</b>、<b>《Linux 命令行与 shell 脚本编程大全》</b>、<b>《计算机网络》</b>（谢希仁, 8e）整理。全部正文为重新组织的讲解与示例，不是原书摘录；过时内容集中到附录 A.1。
</div>
</details>

<div class="cover-object" aria-hidden="true">
  <div class="book-3d"><div class="book"><div class="face face-front">{{#include assets/covers/linux.svg}}</div></div></div>
</div>
</section>

<section class="book-contents" aria-label="目录">
<div class="bc-head"><span class="bc-kicker">CONTENTS / 目录</span><span class="bc-meta">6 篇 · 85 章 · 11 项目</span></div>
<div class="bc-list">
<a class="bc-row" href="part0/ch01.md"><span class="bc-no">00</span><span class="bc-title">命令行与 Shell 工程</span><span class="bc-count">14 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part1/ch01.md"><span class="bc-no">01</span><span class="bc-title">计算机系统 · 多架构与 Rust</span><span class="bc-count">19 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part2/ch01.md"><span class="bc-no">02</span><span class="bc-title">Unix/Linux 系统编程</span><span class="bc-count">19 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part3/ch01.md"><span class="bc-no">03</span><span class="bc-title">Linux 内核</span><span class="bc-count">15 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part4/ch01.md"><span class="bc-no">04</span><span class="bc-title">网络</span><span class="bc-count">12 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part5/ch01.md"><span class="bc-no">05</span><span class="bc-title">云原生</span><span class="bc-count">6 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="projects/overview.md"><span class="bc-no">06</span><span class="bc-title">项目复现</span><span class="bc-count">4 条主线 / 11 项目</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
</div>
<p class="bc-note">左侧目录是完整导航；页首搜索支持全文检索。第一次来，先读 <a href="roadmap.md">三条学习路线</a>。</p>
</section>

<section class="study-paths" aria-label="学习路线">
<div class="path-card">
<span class="path-no">ROUTE 01</span>
<h3>应用与运维路线</h3>
<p>第 0 篇 → 第 4 篇 4.1–4.7 → 第 5 篇 → 项目 D。目标：能把 Linux 当生产环境用，能写可靠的自动化脚本，能定位服务与网络问题。</p>
</div>
<div class="path-card">
<span class="path-no">ROUTE 02</span>
<h3>系统编程路线</h3>
<p>第 0 篇 0.1–0.9 → 第 1 篇 → 第 2 篇 → 项目 A2 / B / C。目标：写出正确、可移植、可观测的系统程序。</p>
</div>
<div class="path-card">
<span class="path-no">ROUTE 03</span>
<h3>内核与性能路线</h3>
<p>第 1 篇 1.2–1.9 → 第 2 篇 → 第 3 篇 → 第 4 篇 4.8–4.12 → 项目 A1 / A3。目标：读懂内核路径，能用证据定位性能瓶颈。</p>
</div>
</section>

<section class="book-contents" aria-label="如何使用">
<div class="bc-head"><span class="bc-kicker">HOW TO USE / 怎么用</span><span class="bc-meta">学 · 练 · 测 · 查</span></div>
<div class="bc-list">
<a class="bc-row" href="objectives.md"><span class="bc-no">K</span><span class="bc-title">知识：每章「本章回答」+ 知识地图</span><span class="bc-count">建立骨架</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="projects/overview.md"><span class="bc-no">S</span><span class="bc-title">技能：11 个项目按 Stage 递进，每阶段有验收</span><span class="bc-count">压成能力</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="review/mock-exam.md"><span class="bc-no">A</span><span class="bc-title">态度：故障复盘、证据链与工程纪律</span><span class="bc-count">形成习惯</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="review/recall.md"><span class="bc-no">R</span><span class="bc-title">复习：速查表 / 易混对照 / 回忆卡 / 自测卷</span><span class="bc-count">对抗遗忘</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
</div>
</section>

<footer class="book-colophon">
  <span class="colophon-kicker">COLOPHON / 题记</span>
  <span class="colophon-main">系统知识不是名词表，而是一条条「从用户请求到硬件动作」的路径。本书的写法是：先给路径，再给岔路，最后给证据。</span>
  <span class="colophon-meta">MDBOOK · 2026-10</span>
</footer>
