# 一页速览 · 公式与结论卡

九讲的必记公式压成一页。**复习时只读这一页**，逐条自问能否默写并解释符号含义。

## 第 1 讲 · 基础

| 项 | 公式 |
|:--|:--|
| 神经元 | $z=\boldsymbol w^{\mathrm T}\boldsymbol x+b,\quad a=\phi(z)$ |
| MLP 前向 | $\boldsymbol z^{(l)}=\boldsymbol a^{(l-1)}W^{(l)}+\boldsymbol b^{(l)},\quad \boldsymbol a^{(l)}=\phi(\boldsymbol z^{(l)})$ |
| Softmax | $\hat y_c=\dfrac{e^{z_c}}{\sum_{c'}e^{z_{c'}}}$ |
| 交叉熵 | $\mathcal L_{\mathrm{CE}}=-\sum_c y_c\log\hat y_c$，**softmax + CE 对 logits 的梯度 = $\hat{\boldsymbol y}-\boldsymbol y$** |
| MSE | $\mathcal L_{\mathrm{MSE}}=\dfrac1N\sum_i(\hat y_i-y_i)^2$ |
| 梯度下降 | $\theta\leftarrow\theta-\eta\nabla_\theta\mathcal L$ |
| 反向传播 | $\boldsymbol\delta^{(l)}=\bigl(\boldsymbol\delta^{(l+1)}W^{(l+1)\mathrm T}\bigr)\odot\phi'(\boldsymbol z^{(l)})$，$\nabla_{W^{(l)}}=\boldsymbol a^{(l-1)\mathrm T}\boldsymbol\delta^{(l)}$ |

## 第 2 讲 · 序列

| 项 | 公式 |
|:--|:--|
| RNN | $\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b)$ |
| 注意力 | $\mathrm{Attention}(Q,K,V)=\mathrm{softmax}\!\left(\dfrac{QK^{\mathrm T}}{\sqrt{d_k}}\right)V$ |
| 多头 | $\mathrm{head}_i=\mathrm{Attention}(QW_i^Q,KW_i^K,VW_i^V)$，拼接后线性变换 |
| 位置编码 | 给每个位置注入与内容无关的位置信息（否则注意力置换等变） |

## 第 3 讲 · 视觉

| 项 | 公式 |
|:--|:--|
| 卷积输出尺寸 | $W_{\text{out}}=\left\lfloor\dfrac{W_{\text{in}}-k+2p}{s}\right\rfloor+1$ |
| 参数量（一层） | $k\times k\times C_{\text{in}}\times C_{\text{out}}+C_{\text{out}}$ |
| 残差块 | $\boldsymbol y=\mathcal F(\boldsymbol x)+\boldsymbol x$（梯度直通，缓解退化） |
| 卷积计算量 | $\approx W_{\text{out}}H_{\text{out}}\times C_{\text{out}}\times k^2C_{\text{in}}$ |

## 第 4 讲 · 生成

| 项 | 公式 |
|:--|:--|
| VAE 重参数化 | $\boldsymbol z=\boldsymbol\mu+\boldsymbol\sigma\odot\boldsymbol\varepsilon,\quad \boldsymbol\varepsilon\sim\mathcal N(\boldsymbol0,I)$ |
| ELBO | $\log p(\boldsymbol x)\ge\mathbb E_{q}[\log p_\theta(\boldsymbol x\mid\boldsymbol z)]-\mathrm{KL}(q_\phi(\boldsymbol z\mid\boldsymbol x)\,\Vert\,p(\boldsymbol z))$ |
| GAN 目标 | $\min_G\max_D\ \mathbb E_{\boldsymbol x}[\log D(\boldsymbol x)]+\mathbb E_{\boldsymbol z}[\log(1-D(G(\boldsymbol z)))]$ |
| 扩散前向 | $\boldsymbol x_t=\sqrt{\bar\alpha_t}\,\boldsymbol x_0+\sqrt{1-\bar\alpha_t}\,\boldsymbol\varepsilon$ |
| 扩散损失 | $\mathcal L=\mathbb E_{t,\boldsymbol x_0,\boldsymbol\varepsilon}\bigl[\lVert\boldsymbol\varepsilon-\boldsymbol\varepsilon_\theta(\boldsymbol x_t,t)\rVert^2\bigr]$ |

## 第 5 讲 · 强化学习

| 项 | 公式 |
|:--|:--|
| 回报 | $G_t=\sum_{k\ge0}\gamma^k r_{t+k}$ |
| 动作值 | $Q^\pi(s,a)=\mathbb E_\pi[G_t\mid s_t=s,a_t=a]$ |
| 贝尔曼 | $Q^\pi(s,a)=\mathbb E_{s'}\bigl[r+\gamma\,\mathbb E_{a'\sim\pi}Q^\pi(s',a')\bigr]$ |
| 策略梯度 | $\nabla_\theta J=\mathbb E\bigl[\nabla_\theta\log\pi_\theta(a\mid s)\,A(s,a)\bigr]$ |
| PPO 裁剪 | $\mathcal L^{\mathrm{clip}}=\mathbb E\bigl[\min\bigl(\rho A,\ \mathrm{clip}(\rho,1-\epsilon,1+\epsilon)A\bigr)\bigr]$ |

## 第 7 讲 · 安全（量化的两个）

| 项 | 公式 |
|:--|:--|
| 期望校准误差 | $\mathrm{ECE}=\sum_m\dfrac{\lvert B_m\rvert}{n}\,\bigl\lvert\mathrm{acc}(B_m)-\mathrm{conf}(B_m)\bigr\rvert$ |
| 差分隐私（$\varepsilon$-DP 的直观） | 相邻数据集上输出分布之比受 $e^{\varepsilon}$ 约束 |

## 第 9 讲 · 并行与显存

| 项 | 结论 |
|:--|:--|
| 显存构成（Adam，混合精度） | 参数 $2N$ + 梯度 $2N$ + 优化器状态 $12N$ ≈ **$16N$ 字节** |
| 数据并行 | 每卡一份模型、切分数据、All-Reduce 同步梯度；批大小 $\propto$ 卡数 |
| 气泡占比（流水线，$P$ 段、$M$ 个 micro-batch） | $\dfrac{P-1}{M+P-1}$ |
| LoRA 前向 | $h=Wx+BAx$，只训 $A,B$，可训参数 $r(d+k)$ |
| 梯度累积 | 累积 $k$ 步再更新 ≈ 批大小放大 $k$ 倍 |

::: method[core] 三句话带走（全书）
1. **一个范式**：结构 + 损失 + 梯度下降；反向传播是链式法则的线性时间实现。
2. **四条支线**：序列用注意力、视觉用卷积、生成学分布、决策学策略——都是同一个范式换结构。
3. **规模与责任**：训练大模型的核心是显存与通信（第 9 讲）；能力强了以后，可控、可信、公平就成了设计约束（第 7 讲）。
:::
