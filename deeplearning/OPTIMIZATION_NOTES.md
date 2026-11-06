# 深度学习导论 · 2026-11 对照记录

这次对照的是公开课页和实验仓库，不是把九讲改成另一门课。九讲加三个实验的骨架保留。第 1–5 讲的推导没有重写。

## 课表结论

核查日期：2026-11-06。页面：

- <https://introtodeeplearning.com/2026/index.html>
- <https://introtodeeplearning.com/2025/index.html>
- <https://introtodeeplearning.com/2024/index.html>
- 实验仓库 <https://github.com/MITDeepLearning/introtodeeplearning>（2025 年起课表所链；`aamini/introtodeeplearning` 是旧路径）

2026 年公开课表仍是九讲，标题与本书一致：导论、深度序列建模、深度计算机视觉、深度生成建模、深度强化学习、New Frontiers、The Three Laws of AI、AI for Science、Secrets to Massively Parallel Training。三个实验仍是音乐生成、Facial Detection Systems、Fine-Tune an LLM, You Must!。2026 年 FAQ 写明按 P/D/F、以项目提案完成为 3 学分的评分依据。

2025 年春季是十讲。第 1–6 讲同名；第 7–8 讲是 Large Language Models (I)/(II)；第 9 讲 AI in the Wild；第 10 讲 AI for Biology。这些没有另开讲次：语言模型在第 6 讲，生物与材料在第 8 讲，部署与公平在第 7 讲。

2026 年幻灯片（`/2026/slides/6S191_MIT_DeepLearning_L6.pdf` 至 `L9.pdf`）核对结果：

| 讲 | 幻灯片上能核实的内容 | 本书的处理 |
|:--|:--|:--|
| 6 | 标题 *Deep Learning Limitations and New Frontiers*（Ava Amini，2026-01-07）。抽查页含 Zhang 等 ICLR 2017 的随机标签图、输入梯度对抗样本、扩散正反向（脚注 Sohl-Dickstein ICML 2015、Ho NeurIPS 2020）、下一个 token 的交叉熵 | 6.2 之后仍是拓展，不是逐页翻译。见第 6 讲勘误 |
| 7 | Douglas Blank，*The Three Laws of AI*，2026-01-09。阿西莫夫定律写不成 `if`；操作版是停机、留痕、测试集、反复评测、公开结果 | 新增 [7.6.6](src/lectures/lec07/sec76.md)。不把客座编号替换成 7.2–7.4 的三条法则。工具沙箱仍归《Agent 系统工程》 |
| 8 | Chris Bishop，*AI for Science*。仿真器相对模拟器；化学精度 / 速度 / 通用性；Skala 标为 arXiv:2506.14665；并点名 Aurora、MatterGen、AI2BMD | 新增 [8.1.7](src/lectures/lec08/sec81.md)。作废「课程从未单列本讲」 |
| 9 | Mathias Lechner，*Massively Parallel Training*。议程是 ZeRO、FSDP、Megatron 与 LFM2。FSDP 页使用 `FULL_SHARD` / `SHARD_GRAD_OP` / `NO_SHARD`。激活重计算图上的 8 GB、2 GB、4 倍、约 30% 是示意图 | 损失下降不等于能力变强，能力仍在第 6 讲。示意图上的倍数不写入账本 |

幻灯片第 6、9 讲大量是图片，没有可抽取的全文。上表只覆盖读得见图注的页面，不把未读页说成「全片只有这些」。

## 改了什么

- **课表对照**写进范围声明、九讲导览、延伸阅读和封面题记（题记日期改为 2026-11）。
- **AlphaGeometry** 不再使用 arXiv:2401.04088。该编号的标题是 *Mixtral of Experts*（已向 arXiv 核对）。现引 Trinh 等，*Nature* 625:476–482，文章页 `s41586-023-06747-5`。期刊摘要中的 25/30 与 10/30 只作为论文自己的测试集结果。
- **PGD** 从 arXiv:1706.07334 改为 1706.06083。前者标题是 *Transfer results for Frobenius extensions*。
- **Skala**：预印本标题 *Accurate and scalable exchange-correlation with deep learning*（Luise 等，arXiv:2506.14665）。摘要报告 GMTKN55 误差 $2.8\ \mathrm{kcal/mol}$。不把它写成已经达到讲义上的 $1\ \mathrm{kcal/mol}$ 化学精度。
- **Lab 1**：标明官方仓库同时有 PyTorch 与 TensorFlow 2 / Keras 即时执行两套笔记本，任务是 ABC 字符 RNN。示例去掉 `Variable` 时代的写法，并写明 `zero_grad` 在 `backward` 之前。
- **Lab 2**：改成官方笔记本的实际任务（人脸 / 非人脸、`BCEWithLogitsLoss`、四档准确率、DB-VAE 重采样）。框和 mAP 留在第 3 讲 3.10，并标明不是 2026 年作业的必做。
- **Lab 3**：对齐 2026 年笔记本里能直接读到的接口：LFM2-1.2B 作为例子、LoRA 打在注意力和 SwiGLU 投影上、Lion、显式 `cross_entropy` 与 `ignore_index=-100`、`generate(..., do_sample=True)`。不把 Lion 的学习率说成 AdamW 的默认值。
- 第 7 讲不再写成「永远是 AI Bias 与 AI Safety 两次课」。

## 故意没做的事

- 没有把第 6 讲收成 2026 年幻灯片的限度巡礼。幻灯片的语言模型一半只有下一个 token；缩放律、评测污染和测试时计算仍然是本教程的拓展，并已标明。
- 没有为 MatterGen、AI2BMD 补论文编号。幻灯片只点了名。
- 没有复述客座讲义里那则用药新闻的具体内容，只保留「长对话可以让单轮拒答失效」这一实验设计。
- 第 1–5 讲的公式没有因课表未改名而重写。部分旧页仍可能出现 `aamini/introtodeeplearning`，现行入口以范围声明为准。
- Shumailov 等模型塌缩一文的 arXiv 号、π0 的编号、激活字节系数 34/18/2，维持原文的「需核实」，没有补成确定数字。

## 第二遍：入口变缓，小规模推导写完

第 1–5 讲原来的定理和形状表留着。第一遍读不下去，是因为收敛定理、Lipschitz 下降、ELBO 和策略梯度都出现在手算之前。这一遍在原页前面加了「先跟几个数」的入口，没有新开讲，也没有把后半讲的前沿再加厚。

| 位置 | 给初学的入口 | 给细读的推导 |
|:--|:--|:--|
| [1.1 例 1.1.0](src/lectures/lec01/sec11.md) | 直线 $\hat y=wx+b$ 的一次更新；说明「一步拟合完」只对这一个点成立 | 感知机收敛定理仍在后面，第一遍可跳 |
| [1.4 例 1.4.0](src/lectures/lec01/sec14.md) | 两个类别上手算 softmax，再把 $1/\hat p$ 与 softmax 导数约掉 | 定理 1.4.2 仍是 $C$ 类的同一段代数 |
| [1.5 开场](src/lectures/lec01/sec15.md) | 两个标量、$w_1,w_2$、ReLU，链式法则走到一次更新，并核对损失下降 | 矩阵递推仍在 1.5.3；凸优化那一节标明可跳 |
| [2.4 例 2.4.0](src/lectures/lec02/sec24.md) | 三个值、三个分数，先做成和为 1 的加权平均 | $QK^{\mathsf T}/\sqrt{d_k}$ 是这行外面的写法 |
| [2.5 例 2.5.0](src/lectures/lec02/sec25.md) | 两个头 = 两次加权平均再拼接 | $W^O$ 与参数量不随头数变化的证明仍在定理 2.5.1 |
| [3.1 例 3.1.0](src/lectures/lec03/sec31.md) | 长度 4 的信号、长度 2 的核，两个权重服务三个输出 | 224² 图像的参数量对照留在原例 |
| [4.3 例 4.3.0](src/lectures/lec04/sec43.md) | 两个离散潜变量上的 $\log\mathbb E$ 与 $\mathbb E\log$ | 高斯 ELBO、重参数化、闭式 KL 没有改写成另一套模型 |
| [5.4 例 5.4.0](src/lectures/lec05/sec54.md) | 两个动作的赌博机，正回报抬高刚采样的 logit | 轨迹上的策略梯度定理仍从 5.4.3 开始 |

每讲习题 B 组加了一道闭卷手算（B7），数字与正文例题不同，答案写在折叠块里。第 1 讲导览加了先修 / 目标 / 学完标准，并写明第一遍必做哪两道手算。

仍旧薄、这一遍故意不加的部分：第 6–9 讲的系统清单（缩放律常数、并行字节账、科学模型名单）已经长过入门所需；再加产品名或未复核的论文编号会变成另一门课。第 1.6 的 Adam 偏差修正、第 2.2 的 BPTT 连乘、第 3.4 的残差梯度，正文里已有完整推导，没有再平行写一套。

## 仍开放

- 2026 年网上首播是否与 1 月现场幻灯片逐页相同，以当周放出的 PDF 为准。本书对照的是 2026-11 仍挂在 `/2026/slides/` 上的文件。
- FSDP2 的字段名继续以所用 PyTorch 版本文档为准。2026 年客座讲的是最初的 `FSDP` 策略枚举。
- DB-VAE 的损失分支以官方笔记本正文为准。本书只写重参数化、训练分布上的重采样，以及不能在测试集上估计重采样分布。
