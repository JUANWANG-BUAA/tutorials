<section class="chapter-cover">
<div class="kicker">嵌入式系统 · 定制教程</div>
<h1>嵌入式系统</h1>
<div class="subtitle">从按下复位键那一步开始：先弄清 ARM 处理器由哪些部件组成、一条指令怎样寻址执行，再看多个任务怎样在同一个核上共存。</div>
<div class="cover-chips">
<span>3 章 · 35 节正文</span>
<span>章末六件 · 附解答</span>
<span>课件逐页对照</span>
<span>寄存器 / 异常 / 调度全表</span>
</div>
<details class="cover-details">
<summary>查看章节范围与资料说明</summary>
<div class="meta">
现覆盖课件第二章（ARM 微处理器体系结构，127 页）、第三章（ARM 指令集，157 页）、第四章（嵌入式操作系统，196 页）。<br>
第一章（绪论）课件待发布，目录中预留占位。<br>
依据课程课件（2026 年秋季）整理扩充：课件只列要点的（如异常响应流程、调度算法推导），按教材口径补全推导并标注；课件与通用口径不一致处收入各章勘误页。原始课件存于仓库 <b>_sources/embedded-ppt/</b>（不入库），每节首段注明对应课件页码区间。
</div>
</details>
</section>

## 上电之后，第一件发生的事是什么？

电源稳定、时钟起振，ARM 核从地址 0x00000000 取第一条指令。它落在哪种处理器模式？哪些寄存器可用？下一条指令怎样从存储器到达 ALU？中断来了插进哪一步？三个任务都想用这个核时，谁说了算？

这三个问题分别对应本书三章：体系结构回答"舞台长什么样"，指令集回答"戏怎么唱"，操作系统回答"多个节目怎么排"。读完第二章你能跟踪一次复位的完整过程；读完第三章你能手工推演一小段程序对寄存器和存储器的影响；读完第四章你能判断一组实时任务可否调度，并说清信号量、消息队列各自解决什么问题。

## 从哪里开始

- **系统入门**：先看[阅读方法与三章安排](preface.md)；数制、汇编、进程概念不确定时，做[入学诊断](entry-test.md)定位。
- **跟课与作业**：按当前进度进入对应章节，先回答章导览开头的问题，再读本周小节；课件对照与勘误见各章章末。
- **期末复习**：先用[指令与要点速查卡](preface-formulas.md)过一遍骨架，按错题回读小节，再用各章[闭卷回忆卡](ch02/recall-cards.md)检验，而不只是重看课件。

**复习节奏建议**：学完当天先闭卷回忆（寄存器表、异常向量表适合默写），约 1 天、3 天、1 周后再抽查；汇编读程序题改一个条件重做，调度题换一组参数重算。间隔可按个人情况调整，纸笔记录即可。

<section class="book-contents" aria-label="目录">
<div class="bc-head"><span class="bc-kicker">CONTENTS / 目录</span><span class="bc-meta">3 章 · 35 节</span></div>
<div class="bc-list">
<a class="bc-row" href="ch02/overview.md"><span class="bc-no">02</span><span class="bc-title">第二章 · ARM 微处理器体系结构</span><span class="bc-count">11 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch03/overview.md"><span class="bc-no">03</span><span class="bc-title">第三章 · ARM 指令集</span><span class="bc-count">10 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="ch04/overview.md"><span class="bc-no">04</span><span class="bc-title">第四章 · 嵌入式操作系统</span><span class="bc-count">12 节</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
</div>
<p class="bc-note">左侧目录是完整导航；页首搜索支持全文检索。第一章绪论课件发布后接入此处。</p>
</section>
