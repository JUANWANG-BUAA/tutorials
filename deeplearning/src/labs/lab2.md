# Lab 2 · 人脸分类与算法去偏

本实验对应第 3 讲和第 4 讲，并接到第 7 讲的分群评估。官方 2026 年笔记本是 `lab2/PT_Part2_Debiasing.ipynb`（另有 `TF_` 版），标题是 *Debiasing Facial Detection Systems*。这里的 “detection” 是**这张图是不是人脸**，不是画出框。框、IoU 和 mAP 在[第 3 讲 3.7](../lectures/lec03/sec37.md)；本实验要交的是**分群准确率**和一次去偏对照。

课程页面还链了一份 *Mitigating Algorithmic Bias* 的 PDF。仓库里的后半把所用模型称为 **DB-VAE**（debiasing variational autoencoder）：用变分自编码器学到的潜变量做自适应重采样，而不是先给每张脸标上人群标签。

## 1. 任务到底是什么

| 官方笔记本在做的 | 容易误当成的任务 |
|:--|:--|
| 正类：人脸；负类：非人脸。损失是二分类 | 一组框 $(x,y,w,h)$ 加类别，再算 mAP |
| 训练集来自 CelebA（人脸）和 ImageNet（非人脸） | 在一张大图上滑动窗口 |
| 测试集按人群切开，笔记本使用的四档是 Dark Male、Dark Female、Light Male、Light Female | 只报一个总准确率 |
| 后半用 DB-VAE 重采样，减轻「少见属性被学丢」 | 先人工标出每个子群再重采样 |

笔记本自己写明：CelebA 里多数人脸是浅肤色女性，因此只在 CelebA 上训练的分类器会偏向这些特征。这句话是**数据集说明**，不是对真实人口的统计。你的实验报告要写的是自己测到的四档准确率，不要照抄这句话当结果。

## 2. 基线：一个会报 logits 的 CNN

官方结构是若干带批归一化的卷积层，再接两个全连接层，输出一个 logit。训练用的是带 logits 的二元交叉熵，评估时再过 sigmoid。下面是同一接口的最小写法，层数按你的笔记本填。

```python
import torch
from torch import nn

class FaceCNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.net = nn.Sequential(
            nn.Conv2d(3, 32, 3, padding=1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Flatten(),
            nn.LazyLinear(1),   # 形状随输入分辨率变，第一次前向才实例化
        )

    def forward(self, x):
        return self.net(x).squeeze(-1)   # [B]，未过 sigmoid

loss_fn = nn.BCEWithLogitsLoss()
# loss = loss_fn(model(x), y.float())
```

`BCEWithLogitsLoss` 在内部用数值稳定的方式算 sigmoid 和交叉熵。不要先 `sigmoid` 再套 `BCELoss`，那会在概率贴近 0 或 1 时溢出。评估时用 `torch.inference_mode()`，并先 `model.eval()`，否则批归一化仍按训练批次更新统计量。

```python
model.eval()
with torch.inference_mode():
    logits = model(x)
    pred = (logits.sigmoid() >= 0.5).to(y.dtype)
    acc = (pred == y).float().mean()
```

`LazyLinear` 是现行 PyTorch 的写法。若你的版本没有它，就先用假输入跑一次，把 `Flatten` 之后的长度写死。不要使用已经不存在的 `Variable`。

## 3. 总准确率为什么会掩盖失败

::: ex 思考题 · 四档里有一档崩了 {#lab2-q1}
测试集四档人数相等。三档准确率是 $0.96$，一档是 $0.60$。总准确率是多少？只报总准确率时，你会做出什么错误的上线决定？

::: proof 参考结论
总准确率是 $(3\times0.96+0.60)/4=0.87$。它看起来「还能用」，但有一档只有六成。人脸是否被系统承认，在这一档上已经和抛硬币差不多。第 7 讲要求的是**最差子群**，不是平均。笔记本的提交也是按四档分开报，而不是一个数。
:::
:::

发现差距之后，笔记本讨论的朴素修法是：把训练集按子群标全，再把少的那档补齐。它贵，而且你往往**不知道该标哪一个潜在因素**（肤色、配饰、光照、年龄会缠在一起）。DB-VAE 的想法是让模型自己学这些因素，再按潜变量的稀有程度重采样。

## 4. DB-VAE 在算什么

这一节接[第 4 讲的变分自编码器](../lectures/lec04/sec43.md)。编码器给出 $\mu$ 和 $\log\sigma$，采样必须走重参数化，否则梯度断掉：

$$z=\mu+\sigma\odot\epsilon,\qquad \epsilon\sim\mathcal N(0,I).$$

损失仍是两项：重建项，加上把 $q(z\mid x)$ 拉向标准正态的 KL 项。官方函数签名里给了一个示例默认值 `kl_weight=0.0005`，损失本体仍是待填的空。这个默认值不是普遍最优的超参。人脸和非人脸的损失形式不一样：非人脸没有「要重建出一张脸」这件要事，具体分支以笔记本正文为准，不要把两类样本塞进同一个重建项就算完。

去偏的动作在采样，不在把分类损失写得更复杂。编码器把一张脸映射到潜变量之后，估计这些潜变量在训练集上的直方图；落在稀有格子里的脸，下一批被抽到的概率更高。分类器因此更常看见原先很少的属性组合。潜变量是模型自己学的，**不是**你标好的「肤色」轴。它可能学到光照或背景。所以重采样之后必须回到第 3 节的四档测试集上重新报准确率：总准确率上升、最差一档不动，就不算去偏成功。

::: errata 三件不要做的事
1. 不要在测试集上估计该重采样哪些格子。重采样分布只能来自训练批次，否则你是在用考题改复习范围。
2. 不要把 DB-VAE 读成「公平已经解决」。它缓解的是**训练分布里少见的潜在因素**，不保证换一个数据集、换一种摄像条件仍然成立。第 7 讲的公平度量彼此还可能不相容。
3. 不要为了做这个实验去收集或公开可识别的人脸。用课程提供的缓存数据；报告里放曲线和四档数字，不放能认出某人的图片。
:::

## 5. 排错清单

1. **logits 和概率用混**：`BCEWithLogitsLoss` 吃 logits；阈值 $0.5$ 要打在 sigmoid 之后。
2. **忘了 `eval()`**：批归一化在小批量评估时会把准确率打乱，四档差距可能是统计噪声。
3. **标签类型**：`y` 必须是浮点 0/1。整型标签进 `BCEWithLogitsLoss` 会直接报错或悄悄算错。
4. **KL 权重过大**：潜变量塌成标准正态，重建和分类都没有属性信息，重采样失去对象。
5. **只看训练准确率**：CelebA 上很高，不代表四档测试集上均衡。两个数都要报。

## 6. 提交与自检

- 一张训练损失曲线；
- 基线 CNN 在四档测试集上的准确率表，外加总准确率；
- DB-VAE（或你实现的重采样）之后的同一张表，并写明最差一档变了多少；
- 一句限制：你的潜变量可能在代表什么、你没有检验什么。

**自检**：能解释为什么总准确率可以很高而某一档失败；能写出重参数化，并说明它为什么让 KL 和重建可以一起反传；能指出重采样分布不能在测试集上估计。

## 7. 代码 ↔ 讲次对照表

| 代码 / 步骤 | 对应结论 |
|:--|:--|
| `Conv2d` + `BatchNorm2d` + `MaxPool2d` | [3.2](../lectures/lec03/sec32.md)、[3.3](../lectures/lec03/sec33.md)：局部性、归一化、下采样 |
| `BCEWithLogitsLoss` | [1.4](../lectures/lec01/sec14.md)：二分类用对数概率，不要先 sigmoid 再 BCE |
| `model.eval()` 与 `inference_mode()` | [3.3](../lectures/lec03/sec33.md)：评估时冻结批统计 |
| 四档准确率 | [7.4](../lectures/lec07/sec74.md)：平均值掩盖子群 |
| $z=\mu+\sigma\odot\epsilon$ | [4.3](../lectures/lec04/sec43.md)：重参数化 |
| 按潜变量直方图重采样 | 官方笔记本的 DB-VAE；潜变量不是人工子群标签 |

## 8. 扩展（选做，不属于官方笔记本的必做）

框检测（IoU、NMS、mAP）和 FGSM 留在第 3 讲的习题里做。若你仍想把本实验的分类器滑成检测器，步幅和感受野见 [3.2](../lectures/lec03/sec32.md)，并且**增强图像时必须同步改框**。那是另一份实验，不要和四档准确率混在同一张表里。
