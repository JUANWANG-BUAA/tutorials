# 4.6 潜空间扩散与整流流

[4.5](sec45.md)把扩散讲通了：训练稳、质量高、可控，唯一的短板是**采样要跑很多次网络前向**。这一个短板衍生出整整一代工程改进，本节讲其中四件事：

1. **换坐标系**：把扩散从像素空间搬到 **VAE 的潜空间**（LDM，latent diffusion model）。这不是近似，而是「用一次编解码换取 $6\sim64$ 倍的空间压缩」，代价是给重建误差设了一个天花板。
2. **换主干**：把 U-Net 换成 **Transformer**（DiT，diffusion transformer），并解决「Transformer 怎么吃时间步与条件」的设计问题（adaLN-Zero）。
3. **换训练目标**：从「预测噪声」转向 **整流流 / 流匹配**（rectified flow / flow matching）——直接学一条把噪声搬到数据的**速度场**，并把它拉直，从而能用极少步数积分。
4. **换解码方式**：**一致性模型**（consistency models）与 LCM 学「任意时刻的噪声图 → 原图」的一步映射，再用蒸馏把少步误差压下去。

一句话概括这一节的主线：**扩散的三条出路是「更小的空间、更强的骨干、更直的路」**。

::: note[skip] 本节定位
本节与 [4.7](sec47.md) 属于本讲的两节**拓展节**：它们建立在 [4.1](sec41.md)–[4.5](sec45.md) 打好的基础上（尤其是 [4.5](sec45.md) 的前向闭式、简化损失、CFG），面向 2023–2025 年的主流工程路线。**第一遍阅读可以只读每节的动机段、定义与结论表**，把论文与机制当作索引留在脑子里；二刷或做项目时再回来精读推导。
:::

## 4.6.1 潜空间扩散：把算力花在语义上

::: def 定义 4.6.1 · 潜空间扩散模型（latent diffusion model, LDM） {#def-4.6.1}
LDM 把扩散的前向与反向过程都搬到**感知压缩后的潜空间**中进行。整个系统分两个阶段训练：

**第一阶段（感知压缩）**：训练一个自编码器（通常是带感知损失与对抗损失的 VAE / VQ 型编码器，见 [4.3](sec43.md) 与 [4.7](sec47.md)）
$$\boldsymbol z=\mathcal E(\boldsymbol x)\in\mathbb R^{c\times h\times w},\qquad \hat{\boldsymbol x}=\mathcal D(\boldsymbol z),$$
把 $\boldsymbol x\in\mathbb R^{3\times H\times W}$ 压到 $\boldsymbol z$，典型压缩率是**空间 $8$ 倍**（$h=H/8$）且通道数较小（$c=4$ 或 $16$）。

**第二阶段（在 $\boldsymbol z$ 上做扩散）**：把 [4.5](sec45.md) 的全部公式里的 $\boldsymbol x$ 换成 $\boldsymbol z$：
$$\boldsymbol z_t=\sqrt{\bar\alpha_t}\,\boldsymbol z_0+\sqrt{1-\bar\alpha_t}\,\varepsilon,\qquad
\mathcal L=\mathbb E_{t,\boldsymbol z_0,\varepsilon}\bigl[\lVert\varepsilon-\varepsilon_\theta(\boldsymbol z_t,t,c)\rVert^2\bigr],$$
条件 $c$ 经过交叉注意力或 adaLN 注入网络。**采样时**先在潜空间跑反向链得到 $\hat{\boldsymbol z}_0$，再一次性解码 $\hat{\boldsymbol x}=\mathcal D(\hat{\boldsymbol z}_0)$。
:::

::: intuition 为什么压缩之后扩散仍然有效——「感知压缩」这个词
像素空间里有大量信息在**语义上与内容无关**：胶片噪声、压缩伪影、纹理的精确高频抖动。扩散在像素空间训练时，这些成分占据了模型容量与算力，却对「图像看起来表达什么」没有贡献。

一个训练良好的感知压缩编码器做的事是：**把语义信息留在潜码里，把不可感知高频细节用重建误差的名义"丢掉"**（这正是它的损失里要加感知损失与对抗损失的原因——纯 MSE 的编码器会把容量浪费在模糊的平均细节上）。于是第二阶段的扩散建模的是一个**信息密度更高的分布**：同样的网络容量与同样的步数，作用在潜空间上比作用在像素上「更值」。

**代价必须说清楚**：**潜空间编码器的重建误差是整条管线的上限**。潜码再完美，解码器也只能还原到 $\mathcal D(\mathcal E(\boldsymbol x))$ 的保真度。这个上限在细节密集的模态（小文字、细纹理、医学图像）上会直接可见，于是出现了「更小的压缩率 / 更高的通道数 / 更好的解码器」这一整条权衡——这不是实现细节，而是架构选择。
:::

::: prop 命题 4.6.1 · 潜空间扩散的算力账 {#prop-4.6.1}
设像素扩散的 U-Net 在第 $l$ 级的通道数为 $c_l$、特征图边长为 $H_l$；潜空间把空间尺寸降 $f$ 倍（$f=8$）、通道数从 $3$ 变为 $c$（$c=4$）。则**在同一组相对通道配置下**，注意力层的计算量与键值对的个数成正比：

$$\text{注意力 FLOPs}\ \propto\ (h\,w)^2\cdot c,\qquad h\,w=\frac{H}{f}\cdot\frac{W}{f}=\frac{HW}{f^2}\ \Longrightarrow\ \text{比值}\approx f^4\cdot\frac{c}{3}.$$
卷积类算子的比值约为 $f^2\cdot\frac{c}{3}$，下游若干级的比值更高（因为潜空间的低分辨率起点比像素扩散的深层还低）。
:::

::: proof 推导（逐项数一遍）
**注意力层**：$N=hw$ 个 token 的自注意力计算量 $\propto N^2\cdot c$。像素空间 $N_1=HW$、通道 $3$；潜空间 $N_2=HW/f^2$、通道 $c$。比值为
$$\frac{N_2^2 c}{N_1^2\cdot3}=\frac{(HW/f^2)^2c}{(HW)^2\cdot3}=\frac{c}{3f^4}\ \Longrightarrow\ \text{像素侧是潜空间侧的}\ \frac{3f^4}{c}\ \text{倍}.$$
**卷积层**：计算量 $\propto HW\cdot c^2\cdot k^2$（$k$ 为核大小），同一级上比值 $\approx (1/f^2)\cdot(c/3)^2\cdot$（通道比的不同配置），与注意力的 $f^4$ 相比要温和得多。

**代入 $f=8,\ c=4$ 的常见配置**：注意力项 $3\times8^4/4=3072$ 倍——这就是「在潜空间里做注意力便宜得多」的定量来源；卷积项的倍数则小得多（约 $f^2\cdot c/3\approx21$ 倍）。**结论**：压缩对**注意力**的收益远大于对卷积的收益，因此潜空间扩散与「在低分辨率上堆注意力」天然般配（也与 DiT 的出现相互促进）。
:::

::: ex 例 4.6.1 · 一次完整的算力与显存估算 {#ex-4.6.1}
目标：在 $512\times512\times3$ 上训练一个扩散模型。比较两种方案：(A) 像素空间扩散；(B) LDM（$f=8$、$c=4$）。只考虑**注意力层**与**单张图的一次前向**，给出两者的粗算比值；并说明显存的主要受益点。

::: proof 解
**(A) 像素空间**：把注意力放在最小一级 $16\times16$ 上（$HW=256$，$N=256$，通道 $c_{\text{att}}=512$ 量级）。
$$\text{注意力 FLOPs}\propto N^2c=256^2\times512\approx3.36\times10^{7}.$$

**(B) LDM**：潜空间尺寸 $64\times64$（$f=8$ 后）；若同样在「潜空间最小一级」放注意力，取 $N=16\times16=256$、通道 $c_{\text{att}}=512$ 量级，数值与 (A) 相同——**注意这里的关键差别在别处**：LDM 可以在**更大的潜空间分辨率**（如 $32\times32$、$64\times64$）上做注意力，而像素扩散要做同样的事就要在 $256\times256$、$512\times512$ 上做注意力。

若把注意力放在与像素方案**相同的语义尺度**上：像素 $256\times256$（$N=65536$）vs 潜空间 $32\times32$（$N=1024$），则
$$\frac{\text{像素}}{\text{潜}}\approx\frac{65536^2\times512}{1024^2\times512}=\Bigl(\frac{65536}{1024}\Bigr)^2=4096\ \text{倍}.$$

**显存**：注意力矩阵 $N\times N$、卷积激活 $\propto HW\cdot c\cdot B$，都随面积线性增长。$512^2\to64^2$ 使单张图的激活面积下降 $64$ 倍（同时通道 $3\to4$ 略增），于是同一个 GPU 上可以从「批大小 1 都紧张」变成「批大小十几」。

**但必须补上两项被省略的成本**：① **第一阶段的自编码器训练成本**（一次性，通常占整个项目算力的一个小比例）；② **解码器推理成本**（采样结束后一次解码，相对多步去噪可以忽略，但批量生成时不可忽略）。此外，**重建误差上限**是这套方案付出的质量代价。

**量级结论**：$f=8$ 的感知压缩通常带来「训练显存降一个数量级以上、注意力算力降两到三个数量级」的收益，换取「重建保真度的上限」。$\blacksquare$
:::

::: method LDM 的两阶段训练流程与常见工程坑 {#method-4.6.1}
```text
阶段 1：训练感知压缩自编码器
  · 损失 = 重建损失（L1/L2）+ 感知损失（LPIPS 类）+ 对抗损失（patch 判别器）
    —— 只有重建损失会得到过度平滑的编码器；对抗 + 感知才带来「可解码的细节」
  · 评估：重建 PSNR / LPIPS / rFID（在潜空间上的 FID）
阶段 2：在冻结的潜空间上训练扩散
  · 输入是 z = E(x)，**编码器与解码器全程冻结**
  · 网络输出与 z_t 同形状；条件 c 通过交叉注意力（LDM）或 adaLN（DiT）注入
  · 采样：z_T ~ N(0, I) → 反向链 → ẑ_0 → x̂ = D(ẑ_0)
```
**三个高频工程坑**：① 潜码的**尺度**要与先验匹配——若 $\boldsymbol z$ 的每维方差远离 1，$\mathcal N(0,I)$ 的先验就不合适（标准做法是在训练扩散前统计潜码的缩放因子 $s$，令 $\boldsymbol z\leftarrow s\boldsymbol z$ 后再做扩散，采样后除以 $s$）；② 编码器与扩散网络**不能一起端到端训**（否则 KL 会重新变成可优化对象，训练不稳定且丧失「潜空间固定」的工程优势）；③ 解码器**对潜码误差敏感**：潜空间上的小误差经解码器放大为可见伪影，因此潜空间扩散更依赖采样步数充足与数值裁剪（$\hat{\boldsymbol z}_0$ 的 clamp）。
:::
:::

## 4.6.2 DiT：用 Transformer 替换 U-Net

::: def 定义 4.6.2 · DiT 的 adaLN-Zero {#def-4.6.2}
**DiT**（diffusion transformer）把 U-Net 换成标准的 Transformer 编码器，并规定了三件事：

1. **分块化（patchify）**：把潜空间图像 $\boldsymbol z\in\mathbb R^{c\times h\times w}$ 切成 $p\times p$ 的块，展平后线性投影成 $N=(h/p)(w/p)$ 个 token（与 [第 3 讲](../lec03/sec35.md)的 ViT 完全同构）；
2. **条件注入（adaLN-Zero）**：时间步 $t$ 与类别 / 文本条件经嵌入相加后过一个 MLP，回归出**六组**逐通道的缩放与平移参数：
$$(\boldsymbol\gamma_1,\boldsymbol\beta_1,\boldsymbol\alpha_1,\boldsymbol\gamma_2,\boldsymbol\beta_2,\boldsymbol\alpha_2)=\mathrm{MLP}\bigl(\boldsymbol e_t+\boldsymbol e_c\bigr),$$
其中前两对用于注意力与前馈前的 LayerNorm，最后一对用于**残差分支的门控**：
$$\boldsymbol x\leftarrow\boldsymbol x+\boldsymbol\alpha\odot\mathrm{Attn}\bigl(\mathrm{LN}(\boldsymbol x)(1+\boldsymbol\gamma)\bigr),\qquad \boldsymbol x\leftarrow\boldsymbol x+\boldsymbol\alpha\odot\mathrm{FFN}\bigl(\mathrm{LN}(\boldsymbol x)(1+\boldsymbol\gamma)\bigr);$$
3. **零初始化**：把输出门的 MLP 最后一层**初始化为零**，于是训练开始时 $\boldsymbol\alpha=\boldsymbol 0$，每个残差块退化为恒等映射——**整个 DiT 块在初始化时是恒等的**，与 [第 3 讲](../lec03/sec34.md) 里残差连接的动机相同（让深层网络从「不破坏输入」开始学）。文本条件（较长、变长）则常保留交叉注意力层单独注入。
:::

::: intuition 为什么这个问题值得单独立一节
U-Net 是为**像素级图像**设计的：下采样—上采样金字塔 + 跳连，它的归纳偏置是「局部性 + 多尺度」。当扩散搬到潜空间之后，潜码已经没有像素级的局部结构语义，U-Net 的跳连价值下降；同时（[命题 4.6.1](#prop-4.6.1)）潜空间让**注意力变得便宜**——于是「用 Transformer 当主干」从「奢侈」变成「合理」。

**adaLN-Zero 解决的正是 Transformer 的接口问题**：时间步与条件不再是「看图像的网络如何对齐文本」，而是「**如何调制每一个残差块的行为**」。用「逐通道缩放 + 平移 + 门控」来注入，与 [第 3 讲](../lec03/sec33.md) 的归一化层家族（BN / LN / 组归一化）是同一套思路的延伸——归一化层本来就在控制信号的分布，让它**有条件地**控制，代价只是几个 MLP 参数。

**零初始化的意义常被低估**：它让「加条件」这个动作在训练初期**不引入任何扰动**。如果门控初值是 1，一个随机初始化的条件 MLP 会立刻给主干注入随机调制，深层网络的行为被破坏。零初始化把「先学会无条件生成，再逐步学会用条件」这件事变成优化的默认路径。
:::

::: method DiT 变体与规模（用于建立参数量级的直觉） {#method-4.6.2}
下表给出 DiT 论文中的四个标准配置（**参数列为其论文报告的公开数值**，路径数含 adaLN 引入的 MLP）：

| 变体 | 层数 $L$ | 隐维 $d$ | 注意力头数 | 参数量 | 备注 |
|:--|:--|:--|:--|:--|:--|
| DiT-S | $12$ | $384$ | $6$ | $\approx33$ M | 便于快速实验 |
| DiT-B | $12$ | $768$ | $12$ | $\approx130$ M | 常用基线 |
| DiT-L | $24$ | $1024$ | $16$ | $\approx458$ M | 质量明显提升 |
| DiT-XL | $28$ | $1152$ | $16$ | $\approx675$ M | 论文主结果（$256\times256$、$512\times512$） |

**patch 尺寸的影响**（$p$ 越大，token 越少、越便宜、细节越差）：

| 潜空间尺寸 $h\times w$ | $p=2$ | $p=4$ | $p=8$ |
|:--|:--|:--|:--|
| $32\times32$（即 $256$ px，$f=8$） | $256$ token | $64$ token | $16$ token |
| $64\times64$（即 $512$ px，$f=8$） | $1024$ token | $256$ token | $64$ token |

**读法**：token 数是注意力成本的一阶决定因素（$\propto N^2$）。$p=2$ 的 $512$ px 配置有 $1024$ 个 token，注意力矩阵是 $1024^2$——这已经接近「必须用 FlashAttention 家族（[第 2 讲](../lec02/sec26.md)）才现实」的量级。
:::

```python
import torch, torch.nn as nn

class AdaLNZero(nn.Module):
    """从 (t, c) 嵌入回归出 6 组调制参数；最后一层零初始化。"""
    def __init__(self, d_model, cond_dim):
        super().__init__()
        self.mlp = nn.Sequential(nn.SiLU(), nn.Linear(cond_dim, 6 * d_model))
        nn.init.zeros_(self.mlp[-1].weight)   # ← 关键：零初始化 → 训练初期块为恒等映射
        nn.init.zeros_(self.mlp[-1].bias)

    def forward(self, cond):
        g1, b1, a1, g2, b2, a2 = self.mlp(cond).chunk(6, dim=-1)
        return g1, b1, a1, g2, b2, a2

class DiTBlock(nn.Module):
    """一个 DiT 块：LN → 注意力/前馈 → 门控残差；条件只出现在调制参数里。"""
    def __init__(self, d_model, n_head, cond_dim):
        super().__init__()
        self.norm1 = nn.LayerNorm(d_model, elementwise_affine=False)   # 归一化不带自己参数
        self.attn = nn.MultiheadAttention(d_model, n_head, batch_first=True)
        self.norm2 = nn.LayerNorm(d_model, elementwise_affine=False)
        self.mlp = nn.Sequential(nn.Linear(d_model, 4 * d_model), nn.GELU(), nn.Linear(4 * d_model, d_model))
        self.ada = AdaLNZero(d_model, cond_dim)

    def forward(self, x, cond):
        g1, b1, a1, g2, b2, a2 = self.ada(cond)                        # 每个 (B, d_model)
        h = self.norm1(x) * (1 + g1.unsqueeze(1)) + b1.unsqueeze(1)    # 调制后的 LN
        h, _ = self.attn(h, h, h, need_weights=False)                  # 自注意力（可换成 FlashAttention）
        x = x + a1.unsqueeze(1) * h                                    # 门控残差：初始 α=0 → 恒等
        h = self.norm2(x) * (1 + g2.unsqueeze(1)) + b2.unsqueeze(1)
        x = x + a2.unsqueeze(1) * self.mlp(h)
        return x

class DiT(nn.Module):
    """最小可用 DiT：patchify → 位置编码 → N 个块 → 反分块预测噪声。"""
    def __init__(self, in_ch=4, patch=2, d_model=384, depth=4, n_head=6, cond_dim=256):
        super().__init__()
        self.patch = patch
        self.proj = nn.Conv2d(in_ch, d_model, kernel_size=patch, stride=patch)   # 等价于分块 + 线性投影
        self.blocks = nn.ModuleList([DiTBlock(d_model, n_head, cond_dim) for _ in range(depth)])
        self.norm_out = nn.LayerNorm(d_model, elementwise_affine=False)
        self.head = nn.Linear(d_model, patch * patch * in_ch)                    # 反分块：每个 token 还原一个块
        nn.init.zeros_(self.head.weight); nn.init.zeros_(self.head.bias)         # 零初始化输出头

    def forward(self, z, cond):
        # z: (B, in_ch, h, w) → token: (B, N, d_model)
        x = self.proj(z)
        B, D, h, w = x.shape
        x = x.flatten(2).transpose(1, 2)                       # (B, h*w, D)
        for blk in self.blocks:
            x = blk(x, cond)
        x = self.head(self.norm_out(x))                        # (B, N, p*p*in_ch)
        # 反分块还原成 (B, in_ch, h, w)
        x = x.view(B, h, w, self.patch, self.patch, -1).permute(0, 5, 1, 3, 2, 4).reshape(B, -1, h * self.patch, w * self.patch)
        return x
```

::: errata DiT 的三个常见误解
1. **「DiT 只是把 U-Net 换成 Transformer，等价于 ViT + 扩散」**：关键差别在**条件注入方式**。ViT 的条件（若需要）通常走交叉注意力；DiT 证明 adaLN-Zero 这种「用条件调制归一化 + 零初始化门控」的方式对扩散更有效（论文报告在同等条件下优于交叉注意力与上下文拼接）。**换主干的同时必须换条件通道**。
2. **「零初始化会让训练变慢」**：它让**初始**行为变慢（块恒等），但避免了随机调制破坏主干；实际效果是收敛更稳。这条经验与 [第 1 讲](../lec01/sec16.md) 的「输出层小初始化」、[第 3 讲](../lec03/sec34.md) 的残差零初始化同源。
3. **「patch 越小越好」**：$p=1$ 时 token 数等于潜空间的像素数，注意力成本平方增长且局部性归纳偏置被削弱。DiT 论文的实测结论是 **$p=2$ 在质量与成本之间最好**，$p=4$、$p=8$ 明显更便宜但在细节与 FID 上有代价（**具体数字需以论文表格为准**）。
:::

## 4.6.3 少步采样：一致性模型与 LCM

::: def 定义 4.6.3 · 一致性模型（consistency model） {#def-4.6.3}
**自一致性**：存在一个函数 $f$，使得**同一条前向轨迹上的任意两点都被映到同一个起点**：
$$f(x_t,t)=f(x_{t'},t')\quad\text{对所有}\ t,t'\ \text{落在同一条 PF-ODE 轨迹上},\qquad f(x_0,0)=x_0 .$$
因此它可以直接把「任意噪声水平的图」一步映射回原图：$\hat x_0=f_\theta(x_t,t)$。

**训练方式有两种**（都以「同一条轨迹上两点的输出必须相同」为约束）：

- **一致性蒸馏（CD）**：用已有的扩散模型（教师）生成的轨迹训练 $f_\theta$。损失为相邻两点输出的距离
  $$\mathcal L_{\text{CD}}=\mathbb E\Bigl[d\bigl(f_\theta(x_{t_{n+1}},t_{n+1}),\ f_{\theta^-}(\hat x_{t_n}^{\,\text{teacher}},t_n)\bigr)\Bigr],$$
  其中 $\theta^-$ 是**目标网络的 EMA**（防止自蒸发的坍塌），$\hat x_{t_n}^{\text{teacher}}$ 由教师的一步 ODE 采样得到。
- **一致性训练（CT）**：不用教师，直接用「同一条前向链的两个相邻时刻」构造目标（离散时刻情形下用 $\partial f/\partial t=0$ 的 PDE 形式）。

**少步生成**：从 $x_T\sim\mathcal N(0,I)$ 出发，交替「一步跳回 $\hat x_0$」与「重新加噪到下一个噪声水平」：
$$x_{t_{n+1}}\leftarrow \hat x_0+\sqrt{t_{n+1}^2-\epsilon^2}\,\varepsilon,\qquad \varepsilon\sim\mathcal N(0,I),$$
在 $2\sim4$ 个离散水平上做几轮即可出图。**LCM**（latent consistency model）是把上述做法搬到**潜空间**（[4.6.1](#def-4.6.1)）并用少量数据蒸馏的版本，其 LoRA 版本允许把已有潜空间扩散模型直接改造成少步模型。
:::

::: intuition 一致性模型在做什么：把「回归多步」换成「学不动点映射」
扩散的 DDIM 是**沿轨迹走很多小步**；一致性模型直接把「走到终点」这件事**学成一个函数**。它的合法性来自一个事实：前向加噪的 PF-ODE（概率流 ODE）是**确定性**的——给定轨迹上的点，起点唯一确定。因此「任意点 → 起点」是一个良定义的映射，可以学。

**两类误差的区别**（这是判断它会坏在哪里的关键）：

- **蒸馏路线**：上限受**教师**限制（学生无法超过教师的质量），且自蒸馏容易坍塌——用一个不停在变的自己对生成目标，会像 [4.4](sec44.md) 的博弈一样出现「目标漂移」。EMA 目标网络就是为这条设的稳定器。
- **训练路线**：不需要教师，但要构造「同一条链上的两点」，且在高噪声端（$\bar\alpha_t$ 很小）时链的曲率大，学起来更难。

**为什么 4 步近似值这么多工程投入？** 因为延迟是产品化的硬约束：一次 512 步的扩散采样在单卡上要秒级，而 4 步可以把同一件事压到百毫秒级——**这直接决定了「能不能做成实时交互产品」**。这也是 GAN 为什么在 2022 年之后仍没有完全消失：它天生是「1 步」的（[4.6.5](#sec-4.6.5) 会看到两者合流）。
:::

## 4.6.4 整流流 / 流匹配：学一条更直的路

::: def 定义 4.6.4 · 整流流（rectified flow）与流匹配 {#def-4.6.4}
**直路径与速度场**：在噪声 $\boldsymbol x_1\sim\mathcal N(0,I)$ 与数据 $\boldsymbol x_0\sim p_{\text{data}}$ 之间取直线插值
$$\boldsymbol x_t=(1-t)\,\boldsymbol x_1+t\,\boldsymbol x_0,\qquad t\in[0,1],$$
注意这条直线对应的速度与 $t$ 无关：
$$\boldsymbol v(\boldsymbol x_t,t)=\frac{d\boldsymbol x_t}{dt}=\boldsymbol x_0-\boldsymbol x_1 .$$

**训练目标（条件流匹配）**：让网络回归这个速度
$$\mathcal L_{\text{CFM}}=\mathbb E_{t\sim\mathcal U[0,1],\,\boldsymbol x_0,\boldsymbol x_1}\Bigl[\bigl\lVert\boldsymbol v_\theta(\boldsymbol x_t,t)-(\boldsymbol x_0-\boldsymbol x_1)\bigr\rVert^2\Bigr].$$

**采样**：解 ODE $\dfrac{d\boldsymbol x}{dt}=\boldsymbol v_\theta(\boldsymbol x,t)$，从 $\boldsymbol x_1\sim\mathcal N(0,I)$ 积分到 $t=0$，可用任意数值积分器（欧拉、Heun、中点法等）。

**重流化（reflow）**：用训练好的速度场把噪声—数据**配对**（$\boldsymbol x_1\to$ 采样出 $\boldsymbol x_0'=\mathrm{ODE}(\boldsymbol x_1)$），用这些新配对再训练一轮。反复若干次后，轨迹趋于直线，从而**少步积分即可复现**（论文报告 $1$–$2$ 次重流化后 1–2 步采样质量显著提升）。
:::

::: intuition 为什么「直」就等于「少步」——从积分误差看
用欧拉法积分一个 ODE 时，单步误差与**轨迹的曲率**成正比。把两个极端摆出来：

- **弯曲轨迹**（扩散的典型形态）：路径在中间区域剧烈拐弯，欧拉法用少量大步走会明显偏离真实路径，样本崩坏。
- **直线轨迹**（整流流的目标形态）：$d\boldsymbol x/dt$ 是常数，欧拉法用**一步**就精确到达终点（对直线而言，欧拉法与解析解完全相同）。

「重流化」做的事就是：**用现在的（可能弯曲的）速度场生成配对，把配对拉直之后重新回归**。它在数学上对应一个「对轨迹取期望使其变直」的迭代过程（论文把它描述为「降低轨迹的传输代价」）。

**一个必须说清的理论细节**：训练目标是 $\boldsymbol v_\theta\approx\boldsymbol x_0-\boldsymbol x_1$，但采样时起点 $\boldsymbol x_1$ 是随机的、且我们**不知道**它会配到哪个 $\boldsymbol x_0$。模型学的其实是**边缘速度场** $\mathbb E[\boldsymbol x_0-\boldsymbol x_1\mid\boldsymbol x_t]$——对同一个 $\boldsymbol x_t$，可能有多个 $\boldsymbol x_0$ 与之配对（多模态），边缘速度是它们的平均。这也解释了为什么**单条直线路径并不总能精确对应一个样本**，而重流化之所以有效，是因为它用**实际跟着 ODE 走出来的配对**替换了随机的初始配对，从而让边缘速度场更接近「一条直线」。
:::

::: ex 例 4.6.2 · 直线路径 vs 弯曲路径：为什么「直」省步数 {#ex-4.6.2}
一维玩具例子：数据 $\boldsymbol x_0$ 恒为 $+1$（单模），噪声 $\boldsymbol x_1\sim\mathcal N(0,1)$。

（a）写出整流流的**边缘速度场** $\boldsymbol v_\theta(\boldsymbol x_t,t)$ 的解析形式，验证它给出的轨迹确实是一条直线。
（b）写出扩散（噪声预测参数化）在这个例子里对应的**轨迹形状**，并计算它在两个端点处的速度方向，说明为什么这条路径是**弯**的。
（c）把数据改成双模 $\boldsymbol x_0\in\{+1,-1\}$ 各半，说明边缘速度场会发生什么、少步采样会坏成什么样。

::: proof 解
**(a) 整流流的边缘速度场。** 用直线参数化 $\boldsymbol x_t=(1-t)\boldsymbol x_1+t\boldsymbol x_0$，其中 $\boldsymbol x_1\sim\mathcal N(0,1)$、$\boldsymbol x_0\equiv1$。给定 $\boldsymbol x_t$ 可以反解出 $\boldsymbol x_1=\dfrac{\boldsymbol x_t-t}{1-t}$（$t\lt1$），于是条件速度 $\boldsymbol x_0-\boldsymbol x_1=1-\dfrac{\boldsymbol x_t-t}{1-t}$ 已经是确定值（单模，没有可平均的分支），故边缘速度场就是它：
$$\boldsymbol v_\theta(\boldsymbol x_t,t)=\mathbb E\bigl[\boldsymbol x_0-\boldsymbol x_1\mid\boldsymbol x_t\bigr]=\frac{1-\boldsymbol x_t}{1-t}.$$
**验证直线性**：把 $\dfrac{d\boldsymbol x}{dt}=\dfrac{1-\boldsymbol x}{1-t}$ 看作关于 $t$ 的常微分方程，解为 $\boldsymbol x_t=(1-t)C+t$（$C$ 为常数）——这正是直线族，且 $\boldsymbol x_0=1$、$\boldsymbol x_1=C$。所以**轨迹是直线** ✓。注意速度场本身仍随 $t$ 变化（$t\to1$ 时分母趋零、$|v|\to\infty$），因此**即便路径是直的，粗步长仍会有误差**——「直」减少的是**方向变化**造成的误差，不是所有误差。

**(b) 扩散路径的形状：一段圆弧。** 扩散的路径是 $\boldsymbol x_t=\sqrt{\bar\alpha_t}\,\boldsymbol x_0+\sqrt{1-\bar\alpha_t}\,\varepsilon$（[4.5](sec45.md)，$\varepsilon\sim\mathcal N(0,1)$ 固定）。取 $t=0$ 对应数据、$t=1$ 对应噪声，把 $\sqrt{\bar\alpha_t}$ 参数化成 $\cos\theta_t$，则 $\sqrt{1-\bar\alpha_t}=\sin\theta_t$，路径写成
$$\bigl(\sqrt{\bar\alpha_t},\ \sqrt{1-\bar\alpha_t}\bigr)=\bigl(\cos\theta_t,\ \sin\theta_t\bigr),\qquad \theta_t=\arccos\sqrt{\bar\alpha_t}\in[0,\tfrac{\pi}{2}],$$
即：**在「数据分量 × 噪声分量」张成的平面坐标系里，每一个数据—噪声对的成对坐标都沿着单位圆走四分之一圈**。

**两端点的速度方向**（沿该圆的切向）：
- $t=0$（$\theta=0$）：方向为 $(-\sin 0,\cos 0)=(0,1)$，即**纯噪声方向**；
- $t=1$（$\theta=\pi/2$）：方向为 $(-1,0)$，即**纯数据方向的负向**。

用玩具调度 $\beta_t\equiv0.1$ 检验一下角度：$t=0$ 时 $\theta_0=\arccos1=0$；$t=1$ 时 $\bar\alpha_1=0.9$，$\theta_1=\arccos\sqrt{0.9}\approx\arccos0.9487\approx18.4^\circ$。也就是说：**走完「从数据到第 1 步加噪」这一段，速度方向已经转了 $18.4^\circ$**——这就是「弯」的定量体现。（$T=1000$ 的完整调度下，$\theta_T\approx\arccos\sqrt{\bar\alpha_T}\approx\arccos 0.006\approx89.7^\circ$，整条路径几乎扫过完整的四分之一圆。）

**结论**：扩散的路径是**圆弧**，速度方向从「噪声方向」连续转到「数据方向」，扫过约 $90^\circ$；整流流的路径是**直线**，方向不转。用固定步数的欧拉法积分时，单步误差与方向的转过量成正比，因此**同步数下扩散误差更大**——这就是「整流流更省步数」的机制：**不是模型更强，而是路径更直、方向变化更小**。

**(c) 双模数据：边缘速度场会「抹平」模态。** 现在 $\boldsymbol x_0\in\{+1,-1\}$ 各半。同一个 $\boldsymbol x_t$ 可能由两条路径产生（一条来自 $\boldsymbol x_0=+1$、一条来自 $\boldsymbol x_0=-1$），于是
$$\boldsymbol v_\theta(\boldsymbol x_t,t)=\mathbb E\bigl[\boldsymbol x_0-\boldsymbol x_1\mid\boldsymbol x_t\bigr]$$
是两个分支的**加权平均**。特别地，在两条路径的交汇区（$\boldsymbol x_t$ 接近 $0$ 的中间地带、对应「不知道往哪边走」的样本），平均速度指向中间，积分结果会落到 $0$ 附近——**少步采样因此产出位于两个模态之间的「模糊中间态」**。

**(c) 双模数据：边缘速度场会「抹平」模态。** 当 $\boldsymbol x_0\in\{+1,-1\}$ 各半时，同一个 $\boldsymbol x_t$ 可能由两个不同的 $\boldsymbol x_0$ 生成（一个来自 $+1$ 的路径、一个来自 $-1$ 的路径）。于是
$$\boldsymbol v_\theta(\boldsymbol x_t,t)=\mathbb E[\boldsymbol x_0-\boldsymbol x_1\mid\boldsymbol x_t]$$
是两个分支的**加权平均**：在两条路径的交汇区（$\boldsymbol x_t\approx0$ 附近），平均速度指向「中间」，积分结果会落到 $0$ 附近——**这正是少步采样在边缘速度场下产生「模糊中间态」的机制**。重流化之所以重要：它用实际 ODE 配对（每次只跟定一个模态）重新训练，让一个新的噪声点**只对应一条**路径，边缘速度场重新变得「有一致方向」。$\blacksquare$
:::
:::

::: method SD3 / FLUX 这一代模型的配方要素 {#method-4.6.3}
把 [4.6.1](#def-4.6.1)–[4.6.4](#sec-4.6.4) 的零件拼起来，就是 2024 年以来文本到图像主流路线的结构（**下列为公开论文与官方材料所述要点的归纳**）：

| 部件 | 选择 | 对应本节小节 |
|:--|:--|:--|
| 第一阶段压缩 | 感知压缩自编码器（$f=8$，通道 $16$ 量级） | [4.6.1](#def-4.6.1)、[4.7](sec47.md) |
| 主干 | Transformer（patchify + adaLN 系列条件注入），规模到数十亿参数 | [4.6.2](#def-4.6.2) |
| 训练目标 | 流匹配 / 整流流（回归速度场），常与 logit-normal 时间步采样、分辨率相关的位移（shift）配合 | [4.6.4](#sec-4.6.4) |
| 文本条件 | 多编码器特征拼接 + 池化向量（分别走交叉注意力与 adaLN） | [4.6.2](#def-4.6.2) |
| 采样 | 少步 ODE 求解器 + CFG 引导 | [4.5.5](sec45.md)、[4.6.4](#sec-4.6.4) |

**读表方式**：这张表里没有任何一项是本节新发明的数学，它们全是已知工具的**重新组合**。理解生成模型的前沿，多半是在理解「哪些组合在什么规模上成立」——这也是本教程反复强调「给条件与量级」的原因。
:::

::: method 采样步数—质量—成本对照（承 [4.5.5](sec45.md)） {#method-4.6.4}
把 [4.5](sec45.md) 与本节的方法放在同一张表里，便于做工程选型（**趋势性描述，具体数字必须实测**）：

| 方法 | 典型步数 | 每步成本（相对） | 需要额外训练 | 主要风险 |
|:--|:--|:--|:--|:--|
| DDPM | $1000$ | $1\times$ | 无 | 太慢 |
| DDIM | $20\sim100$ | $1\times$ | 无 | 步数过少时细节退化 |
| 潜空间扩散 + DDIM | $20\sim50$ | $0.02\sim0.05\times$ | 需第一阶段编码器 | 重建误差上限；潜码尺度要匹配 |
| 潜空间扩散 + DiT | $20\sim50$ | 同上（主干更强） | 同上 + 主干规模 | 训练成本高 |
| 一致性模型 / LCM | $1\sim4$ | $1\times$（但步数极端少） | **需蒸馏**（或 CT 联合训练） | 上限受教师；自蒸馏易坍塌 |
| 整流流（未重流化） | $8\sim50$ | $1\times$ | 无（换目标） | $t\to1$ 处速度场病态，需小步 |
| 整流流（重流化） | $1\sim8$ | $1\times$ | 需重流化轮次 | 多模态分布上的「路径合并」 |
| GAN / 对抗蒸馏 | $1$ | $1\times$ | 需对抗训练 | 训练不稳、模式坍塌（[4.4](sec44.md)） |

**选型顺序建议**：① 先定**延迟预算**（每张图的毫秒数）→ 决定是否需要少步；② 再定**质量预算**（可接受的重建上限 / FID 区间）→ 决定是否用感知压缩与压缩率；③ 最后定**训练预算**（能否承担蒸馏 / 重流化 / 数十亿参数主干）。
:::

## 4.6.5 GAN 的复辟：对抗蒸馏 {#sec-4.6.5}

[4.4](sec44.md)讲 GAN 退出了生成主干，但它以另一种身份回来了：**少步加速器**。核心想法是**把「预训练扩散模型的分数信息」与「判别器的真假信息」拼起来训一个一步学生**：

::: method 对抗蒸馏的两种典型形式（要旨，细节以原论文为准） {#method-4.6.5}
- **分数蒸馏（score distillation）**：让学生的一步输出与教师扩散模型在多个噪声水平上的「去噪目标」对齐。它本质是把教师的**多步知识**压进学生的一步映射，用**教师模型自身的分数**当监督信号。
- **对抗损失**：再加一个判别器，直接监督「学生的一步输出看起来像不像真实数据」。**扩散的信息提供「往哪走」，判别器提供「够不够真」**——两者互补：纯蒸馏容易糊（均值化），纯对抗容易坍塌（模式丢失）。

两类损失联合训练出的模型可以在 **$1\sim4$ 步**内出图，同时保留相当程度的多样性与结构，这也是「SDXL-Turbo」一类实时模型的技术基础（**具体实现的损失权重与细节以各官方材料为准**）。
:::

::: intuition 为什么必须有判别器
在 [例 4.6.2(c)](#ex-4.6.2) 里我们看到：**边缘速度场会把多个模态平均掉**，少步采样因此趋向「模糊的中间态」。纯回归式的蒸馏（无论蒸馏扩散还是重流化）都有同一个倾向——损失是平方误差，多个可能目标的平均值就是最优解，而平均值在感知上往往「糊」。**判别器的作用是把「糊」单独挑出来惩罚**：它不需要对每个输入给出正确答案，只需要说「这个不像真的」。这正是 [4.4](sec44.md) 里 GAN 的能力所在，只是现在的角色从「主生成器」变成了「质量裁判」。
:::

::: errata 本节四条高频误解
1. **「潜在空间扩散只是把分辨率调小，等价于降采样」**：它是一次**感知压缩**——编码器用感知/对抗损失训练，目标不是「像素最接近」而是「语义保得住、解码器能补回细节」。这与简单地 resize 图像有本质区别（[命题 4.6.1](#prop-4.6.1) 的算力账与 [4.6.1](#def-4.6.1) 的质量上限是它的两面）。
2. **「流匹配就是扩散换了名字」**：训练目标（回归速度场 vs 预测噪声）与**路径形状**（直线 vs 扩散的弯曲路径）都不同。在近 $t=1$ 处两者差别最大；对同步数采样的误差影响也因此不同（[例 4.6.2](#ex-4.6.2)）。
3. **「重流化越多越好」**：重流化在**多模态分布**上可能让不同路径合并，从而损失多样性（[例 4.6.2(c)](#ex-4.6.2) 描述的机制）。实践中通常做 $1\sim2$ 轮，并监控样本多样性而非只看 FID。
4. **「一致性模型一定能到 1 步」**：论文验证了 $1\sim4$ 步的可用性，但在复杂条件（长文本、多物体）下少步质量下降明显；LCM-LoRA 这类方案的意义在于**用少量蒸馏成本**在已有模型上获得少步能力，而不是宣称「一步即达最优」。
:::

::: method 即时自测 · 4.6
**Q1** 用一句话说明 LDM 两阶段训练里「第一阶段」为什么必须用感知损失与对抗损失，而不能只用 MSE。

**Q2** 潜空间压缩率 $f=8$、通道 $3\to4$ 时，注意力层计算量的像素/潜空间比大约是多少？为什么这个比值对 DiT 特别重要？

**Q3** adaLN-Zero 里的输出门为什么初始化成零？如果不这样做会发生什么？

**Q4** 整流流的训练目标为什么可以写成与 $t$ 无关的 $\boldsymbol x_0-\boldsymbol x_1$？重流化要解决什么问题？

**Q5** 一个团队想在 200 ms 内出 $1024\times1024$ 的图，候选方案有「潜空间扩散 + DDIM 50 步」「LCM 4 步」「整流流重流化后 2 步 + 对抗蒸馏」。请给出你的选型顺序与各自的失败判据。

::: sol 参考要点
**Q1** 因为纯 MSE 的最优解是条件均值，编码器会把容量花在「让每个像素的平均误差最小」上——结果是把高频细节（纹理、边缘、文字）当作噪声抹平，解码出来是模糊图。加感知损失（在特征空间比较）与对抗损失（判别真假）后，「模糊」会被明确惩罚，编码器才愿意把可解码的细节保留在潜码里。

**Q2** 注意力计算量 $\propto N^2c$，$N\propto 1/f^2$，故比值为 $\frac{3f^4}{c}=\frac{3\times4096}{4}=3072$ 倍。因为 DiT 的**主干就是注意力**（token 数 $N$ 决定 $\propto N^2$ 的成本），所以在潜空间里几乎可以不心疼地堆分辨率与层数，而在像素空间里做不到——这就是「潜空间压缩」与「Transformer 主干」互相成就的原因。

**Q3** 输出门 $\boldsymbol\alpha$ 初始化为零 → 训练开始时两个残差分支的贡献为零 → **每个 DiT 块在初始化时退化为恒等映射**。若不做零初始化（例如门初始为 1），一个随机初始化的条件 MLP 会立即给主干注入随机的逐通道调制，等于在深层网络输入上叠加噪声，破坏「先学无条件生成、再学用条件」的优化路径（与本讲 [第 1 讲](../lec01/sec16.md) 输出层小初始化、[第 3 讲](../lec03/sec34.md) 残差零初始化的思想同源）。

**Q4** 因为在直线参数化 $\boldsymbol x_t=(1-t)\boldsymbol x_1+t\boldsymbol x_0$ 下，$d\boldsymbol x_t/dt=\boldsymbol x_0-\boldsymbol x_1$ 是常数（不依赖 $t$）；训练目标是回归**边缘速度场** $\mathbb E[\boldsymbol x_0-\boldsymbol x_1\mid\boldsymbol x_t]$。重流化要解决的是：初始配对是随机的（同一个 $\boldsymbol x_1$ 不唯一对应 $\boldsymbol x_0$），因此边缘速度场是多个分支的平均，轨迹实际上仍会弯；重流化用「跟着 ODE 实际生成出的配对」替换随机配对，把轨迹拉直，从而让少步积分可行。

**Q5** 建议顺序：**先估算延迟**——50 步潜空间扩散在 $1024^2$ 上通常远超 200 ms（即便每步几十毫秒量级，也需数百毫秒到数秒），因此先排除「不作加速的 50 步 DDIM」；在「LCM 4 步」与「整流流 2 步 + 对抗蒸馏」之间，取决于**是否有现成的基座模型**：有基座 → LCM/LCM-LoRA 蒸馏成本最低（少量数据 + 短训练）；从头训 → 整流流 + 重流化 + 对抗蒸馏的组合拳更可控（不依赖特定教师）。失败判据：① 少步模型的**多样性指标**（同提示下多样本的两两距离）显著低于基线 → 蒸馏坍塌或重流化过度；② 提示—图像对齐度（独立模型打分）明显下降 → 步数过少导致条件方向丢失；③ 高细节区域（文字、手部）系统性崩坏 → 蒸馏教师本身的上限或压缩率过高。无论选哪条，都要在**目标分辨率与目标延迟**下实测，而不是照搬论文设置。
:::

::: note[skip] 延伸阅读
- Rombach et al., *High-Resolution Image Synthesis with Latent Diffusion Models*（2022，arXiv:2112.10752）——LDM 原始论文；第 3 节的感知压缩与「两阶段训练」设计、以及交叉注意力条件注入。
- Peebles & Xie, *Scalable Diffusion Models with Transformers*（2022，arXiv:2212.09748）——DiT 原始论文；adaLN-Zero 与四个变体配置（[4.6.2](#sec-4.6.2) 表格的来源）。
- Song et al., *Consistency Models*（2023，arXiv:2303.01469）——一致性模型；自一致性与两种训练方式（CD / CT）都在其中。
- Luo et al., *Latent Consistency Models: Synthesizing High-Resolution Images with Few-Step Inference*（2023，arXiv:2310.04378）——LCM 与 LCM-LoRA：把少步扩散带到潜空间与 LoRA 生态。
- Liu et al., *Flow Straight and Fast: Learning to Generate and Transfer Data with Rectified Flow*（2022，arXiv:2209.14577）——整流流与重流化（本节 [4.6.4](#sec-4.6.4) 的原始论文）。
- Lipman et al., *Flow Matching for Generative Modeling*（2022，arXiv:2210.02747）——流匹配的另一种表述（条件概率路径与向量场回归），与整流流互为镜像。
- Esser et al., *Scaling Rectified Flow Transformers for High-Resolution Image Synthesis*（2024，arXiv:2403.03206）——SD3 论文：整流流 Transformer 在文本到图像上的规模化实验。
- Sauer et al., *Adversarial Diffusion Distillation*（2023，arXiv:2311.17042）——对抗蒸馏：分数蒸馏 + 对抗损失联合训练一步学生（[4.6.5](#sec-4.6.5) 的依据）。
- Black Forest Labs, *FLUX.1*（2024，官方模型卡与仓库 `black-forest-labs/flux`）——开源权重的整流流模型（**无正式论文与 arXiv 编号，引用时请指向官方页面**）。
:::
:::

**本节小结**：这一节的四件改进各解决一个具体瓶颈。**LDM** 把扩散搬到感知压缩后的潜空间（$f=8$、通道 $4\sim16$），换来算力与显存的量级收益，代价是编码器重建误差成为整条管线的上限。**DiT** 用 Transformer + adaLN-Zero 替换 U-Net：patchify 重用 [第 3 讲](../lec03/sec35.md) 的 ViT 思路，条件通过「调制归一化 + 零初始化门控」注入，零初始化让每个块从恒等映射开始。**一致性模型**学「任意时刻 → 原图」的一步映射（自一致性），用蒸馏或 CT 训练，把采样压到 $1\sim4$ 步。**整流流 / 流匹配**直接回归直线速度场并靠重流化把轨迹拉直，使少步积分可行——代价是多模态分布上的路径合并风险（[例 4.6.2](#ex-4.6.2)）。最后，GAN 以对抗蒸馏的形式回归：**教师提供方向、判别器惩罚模糊**。

下一节换一个维度：不再讨论「用什么坐标系与路径」，而是问「**用什么表示**」——把连续潜空间换成**离散 token**，并让自回归模型接管生成。
