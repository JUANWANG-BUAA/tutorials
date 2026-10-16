# 5.7 训练循环示例与调试

前面六节给了零件：`MDP`、`贝尔曼方程`、`TD 误差`、`经验回放`、`目标网络`、`策略梯度`、`GAE`、`裁剪目标`、`KL 约束`、`偏好损失`。这一节把它们装成两台能跑的机器（**DQN 循环**与 **PPO 循环**），然后回答本讲最后一个、也是最容易被忽视的问题：**你怎么知道它真的在学？**

这件事在 RL 里比在监督学习里难得多，原因有三。第一，**指标会骗人**：回报上升可能来自奖励被利用（[5.6.8](sec56.md)），而不是能力提升。第二，**结果对种子极度敏感**：同一个算法、同一份代码，换个随机种子可能一个学会、一个完全学不动——单条曲线在统计上几乎不提供信息。第三，**失败看起来像正常波动**：监督学习里 loss 不降通常意味着代码错了，而 RL 里「回报卡住」既可能是超参数问题，也可能是环境、奖励、探索、评估协议里的任何一环。

因此本节把「训练」与「评估」并重：5.7.1–5.7.3 给一个**完全自包含**的最小环境与两个训练循环，逐行指出每一行在解决 [5.1](sec51.md) 提出的哪个困难；5.7.4 给出四类高频失败模式的诊断表（症状 → 根因 → 处方）；5.7.5 给出**多种子 + 多回合 + 回报分布**的评估协议与置信区间算法；5.7.6 给一份实验记录清单。本讲的学习目标 S5.2（「实现一个 PPO 训练循环，并以回报分布（多种子）验证改进」）就落在这里。

## 5.7.1 一个自包含的最小环境

为了让代码可以**直接运行、不依赖任何环境库**，本节统一用一个 4×4 网格世界：起点随机、目标是右上角、每步小惩罚、到达目标给 +1。它足够简单（可以手算最优回报），又包含了 RL 的三个难点：**延迟奖励**（只有到达目标才有正奖励）、**序贯决策**（动作影响下一状态）、**随机初始状态**（每局起点不同）。

```python
import random
import torch
import torch.nn as nn

class GridWorld:
    """4×4 网格：动作 0=上 1=右 2=下 3=左；撞墙原地不动。
    每步 −0.01；到达右上角 (0,3) 得 +1 并终止；超过 50 步截断。"""
    N, N_ACT = 4, 4
    GOAL = (0, 3)
    MOVE = [(-1, 0), (0, 1), (1, 0), (0, -1)]

    def reset(self, rng: random.Random):
        while True:                                  # 起点随机但避开目标
            s = (rng.randrange(self.N), rng.randrange(self.N))
            if s != self.GOAL:
                return s

    def step(self, s, a: int):
        di, dj = self.MOVE[a]
        s2 = (min(max(s[0] + di, 0), self.N - 1), min(max(s[1] + dj, 0), self.N - 1))
        done = (s2 == self.GOAL)
        return s2, (1.0 if done else -0.01), done

def obs(s, n: int = 4) -> torch.Tensor:
    """状态编码：16 维 one-hot。状态表示与算法无关，但直接决定学习速度。"""
    x = torch.zeros(n * n)
    x[s[0] * n + s[1]] = 1.0
    return x

# 手算参考：起点到目标的曼哈顿距离最大为 6，每步 −0.01，
# 故最优回报约 1 − 0.06·(步数) ≈ 0.94 上下（步数取决于起点）。
# 这个数字是评估时的“体检指标”：回报达到 0.9+ 才说明真的学会走最短路。
```

::: method 环境写的三件事必须明确 {#method-5.7.1}
1. **终止与截断要分开**（`done` vs `steps >= 50`）：终止是「任务结束，值函数应归零自举」，截断是「时间到，值函数仍然要自举」——两者在代码里都写进 `done` 会系统性低估靠近时间上限的状态值。自包含环境里为了简单可以合并，但换成 Gymnasium 时必须区分 `terminated` 与 `truncated`。
2. **奖励尺度要与学习率一起定**：本节用 $+1/-0.01$，量级 $O(1)$，配合 Adam $10^{-3}$ 合适。若把奖励改成 $+100$，等价于把有效学习率放大 100 倍，训练必然发散（[5.5](sec55.md) 的优势归一化就是为这类问题准备的解毒剂）。
3. **状态编码要用「算法看得懂」的形式**：one-hot 让 16 个状态彼此正交，是最容易学的表示；换成 $(i,j)$ 两个整数（0–3）也能学，但需要网络自行发现「位置」的语义，收敛更慢。**状态表示是实现细节，但它是 RL 项目里收益最高的调优点之一。**
:::

## 5.7.2 DQN 训练循环：逐行讲解

下面这个循环把 [5.3](sec53.md) 的全部零件接起来，并顺手把 [5.1](sec51.md) 的三个困难逐条对付掉。

```python
class QNet(nn.Module):
    def __init__(self, n_in: int = 16, n_act: int = 4, h: int = 64):
        super().__init__()
        self.net = nn.Sequential(nn.Linear(n_in, h), nn.ReLU(),
                                 nn.Linear(h, h), nn.ReLU(),
                                 nn.Linear(h, n_act))

    def forward(self, x):
        return self.net(x)

def train_dqn(seed: int, episodes: int = 400, batch: int = 64, gamma: float = 0.99,
              lr: float = 1e-3, capacity: int = 20000, target_every: int = 200):
    """返回每局回报列表（训练曲线）与训练好的网络。"""
    torch.manual_seed(seed)
    rng = random.Random(seed)                                    # ③ 环境随机性也用同一个种子固定
    env = GridWorld()
    online, target = QNet(), QNet()
    target.load_state_dict(online.state_dict())                  # ⑤ 目标网络初始同步一次
    opt = torch.optim.Adam(online.parameters(), lr=lr)
    buffer, history, steps_done = [], [], 0
    eps_start, eps_end, decay = 1.0, 0.05, episodes // 3

    for ep in range(episodes):
        eps = eps_start + (eps_end - eps_start) * min(1.0, ep / decay)   # ④ 探索率线性衰减
        s, done, ep_ret, t = env.reset(rng), False, 0.0, 0
        while not done and t < 50:
            if rng.random() < eps:                               # ④ ε-greedy：随机探索
                a = rng.randrange(env.N_ACT)
            else:
                with torch.no_grad():
                    a = int(online(obs(s)).argmax().item())
            s2, r, done = env.step(s, a)
            buffer.append((obs(s), a, r, obs(s2), float(done)))  # ② 回放池：存下 (s, a, r, s′, done)
            if len(buffer) > capacity:
                buffer.pop(0)                                    # 简单 FIFO：防止内存无限增长
            if len(buffer) >= 500:                               # 先攒够数据再开始学习（避免早期过拟合少量样本）
                idx = [rng.randrange(len(buffer)) for _ in range(batch)]   # ② 随机采样打破时序相关
                b = [buffer[i] for i in idx]
                s_b, a_b = torch.stack([x[0] for x in b]), torch.tensor([x[1] for x in b])
                r_b, s2_b = torch.tensor([x[2] for x in b]), torch.stack([x[3] for x in b])
                d_b = torch.tensor([x[4] for x in b])
                with torch.no_grad():                            # ⑤ 目标网络侧不反传
                    y = r_b + gamma * (1.0 - d_b) * target(s2_b).max(dim=1).values
                q_sa = online(s_b).gather(1, a_b[:, None]).squeeze(1)      # 只取被选动作的 Q 值
                loss = nn.functional.smooth_l1_loss(q_sa, y)
                opt.zero_grad(); loss.backward()
                nn.utils.clip_grad_norm_(online.parameters(), 10.0)
                opt.step()
                steps_done += 1
                if steps_done % target_every == 0:               # ⑤ 周期性同步目标网络
                    target.load_state_dict(online.state_dict())
            s, ep_ret, t = s2, ep_ret + r, t + 1
        history.append(ep_ret)
    return history, online
```

::: method 每一行在对付哪个困难 {#method-5.7.2}
| 困难（[5.1](sec51.md)） | 代码里的对应行 | 如果去掉会怎样 |
|:--|:--|:--|
| **延迟奖励 / 信用分配** | `y = r_b + gamma * (1-d_b) * target(s2_b).max(...)`：用 TD 目标把「到目标的奖励」沿路径往回传播 | 只学「到达那一步」的值，路径中间的状态永远学不到（稀疏奖励卡死） |
| **非平稳数据** | `buffer.append(...)` + `rng.randrange(len(buffer))` 随机采样 | 用连续轨迹更新 ⇒ 梯度被局部经验主导、灾难性遗忘 |
| **探索—利用张力** | `if rng.random() < eps` + `eps` 线性衰减 | 常数 ε 有探索税上限；ε 过快衰减 ⇒ 会早早锁定次优策略 |
| **移动目标** | `target.load_state_dict(...)` + `with torch.no_grad()` | 目标随参数移动 ⇒ loss 抖动、Q 值发散 |
| **过高估计** | （本例是普通 DQN；把 `max` 换成「在线选动作、目标网评估」即 Double DQN） | Q 值系统性虚高（[定理 5.3.2](sec53.md#thm-5.3.2)） |
| **可复现** | `torch.manual_seed` + `random.Random(seed)` | 结果无法比较、无法定位回归 |
:::

**读这个循环时的三个检查点**（它们对应最常见的三类隐性 bug）：

1. **`(1.0 - d_b)` 乘在自举项上**，而不是乘在 $r$ 上（[5.3](sec53.md) 的 `done` 掩码）。
2. **`gather(1, a_b[:, None])`** 精确取出 $Q(s,a)$，否则广播会把损失变成「全部动作的均方误差」——loss 仍然下降，但学的不是 Q-learning。
3. **`target` 与 `online` 是两个对象**（`load_state_dict` 只拷参数，不共享引用）。若写成 `target = online`，目标网络就名存实亡。

## 5.7.3 PPO 训练循环：逐行讲解

PPO 的循环结构与 DQN 有一处根本差别：**它是「采样一批数据 → 在这批数据上做多个 epoch → 丢弃数据」**，因为 $\rho$ 的重要性修正只在「新旧策略差别不大」时有效（[5.5](sec55.md)）。

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

class PolicyNet(nn.Module):
    def __init__(self, n_in: int = 16, n_act: int = 4, h: int = 64):
        super().__init__()
        self.body = nn.Sequential(nn.Linear(n_in, h), nn.Tanh())
        self.pi = nn.Linear(h, n_act)        # Actor：动作 logits
        self.vf = nn.Linear(h, 1)            # Critic：状态值（共享躯干）

    def forward(self, x):
        h = self.body(x)
        return self.pi(h), self.vf(h).squeeze(-1)

def collect_rollout(policy, env: GridWorld, rng, steps: int = 1024, gamma: float = 0.99):
    """收集一批交互数据。注意：每个 episode 结束时要把“未完成”标记出来（done 掩码）。"""
    S, A, R, LP, D, V = [], [], [], [], [], []
    s, done = env.reset(rng), False
    for _ in range(steps):
        x = obs(s)
        with torch.no_grad():
            logits, v = policy(x)
            dist = torch.distributions.Categorical(logits=logits)
            a = dist.sample()
        s2, r, done = env.step(s, int(a))
        S.append(x); A.append(int(a)); R.append(r); LP.append(dist.log_prob(a).item())
        D.append(float(done)); V.append(float(v))
        if done:                                            # 一局结束 ⇒ 重置环境（自动课程：起点随机）
            s, done = env.reset(rng), False
        else:
            s = s2
    return (torch.stack(S), torch.tensor(A), torch.tensor(R), torch.tensor(LP),
            torch.tensor(D), torch.tensor(V))

def compute_gae(rewards, values, dones, gamma=0.99, lam=0.95):
    """GAE：Â_t = δ_t + γλ Â_{t+1}，从后往前算（推导见 5.5.2）。"""
    T = len(rewards)
    adv = torch.zeros(T + 1)                                 # 末端的后继优势为 0
    for t in reversed(range(T)):
        next_val = values[t + 1] if t + 1 < T else 0.0       # 批末用 0（简化：不跨批自举）
        nonterm = 1.0 - dones[t]
        delta = rewards[t] + gamma * next_val * nonterm - values[t]
        adv[t] = delta + gamma * lam * nonterm * adv[t + 1]
    return adv[:T].detach(), (adv[:T] + values).detach()

def train_ppo(seed: int, updates: int = 60, rollout: int = 1024, epochs: int = 4,
              mini: int = 256, eps_clip: float = 0.2, lr: float = 3e-4):
    torch.manual_seed(seed); rng = random.Random(seed)
    env = GridWorld()
    policy = PolicyNet()
    opt = torch.optim.Adam(policy.parameters(), lr=lr)
    hist = []
    for it in range(updates):
        S, A, R, LP, D, V = collect_rollout(policy, env, rng, rollout)   # ① 采样一批数据
        adv, ret = compute_gae(R, V, D)                                  # ② 用 GAE 估优势
        adv = (adv - adv.mean()) / (adv.std() + 1e-8)                    # ③ 优势归一化
        ep_stats = []
        for _ in range(epochs):                                          # ④ 同一批数据跑多个 epoch
            perm = torch.randperm(len(S))
            for k in range(0, len(S), mini):
                idx = perm[k:k + mini]
                logits, v = policy(S[idx])
                dist = torch.distributions.Categorical(logits=logits)
                logp = dist.log_prob(A[idx])
                ratio = torch.exp(logp - LP[idx])                        # ρ = π_θ / π_θold
                clip_ratio = torch.clamp(ratio, 1 - eps_clip, 1 + eps_clip)
                policy_loss = -torch.min(ratio * adv[idx], clip_ratio * adv[idx]).mean()
                value_loss = F.mse_loss(v, ret[idx])
                entropy = dist.entropy().mean()
                loss = policy_loss + 0.5 * value_loss - 0.01 * entropy   # 三项合成（5.5.4）
                opt.zero_grad(); loss.backward()
                nn.utils.clip_grad_norm_(policy.parameters(), 0.5)
                opt.step()
                with torch.no_grad():                                    # ⑤ 诊断量
                    kl = ((ratio - 1) - (logp - LP[idx])).mean().item()
                    clipf = ((ratio - 1).abs() > eps_clip).float().mean().item()
                ep_stats.append((kl, clipf))
        hist.append((R.sum().item(),  # 本批总奖励（粗略的进展信号）
                     sum(k for k, _ in ep_stats) / len(ep_stats),        # 平均近似 KL
                     sum(f for _, f in ep_stats) / len(ep_stats)))       # 平均裁剪比例
    return hist, policy
```

::: method PPO 循环与 DQN 循环的四处结构差异 {#method-5.7.3}
| 差异 | DQN | PPO | 原因 |
|:--|:--|:--|:--|
| 数据的生命周期 | 回放池长期保存、反复使用 | **一批用完就丢** | PPO 的重要性修正只在策略未走远时有效（[5.5](sec55.md)） |
| 每次参数更新用多少数据 | 随机 mini-batch（可来自很久以前） | 固定的 rollout + 多个 epoch 内切 mini-batch | 前者 off-policy 合法，后者要求近似 on-policy |
| 需要几个网络 | 在线 + 目标（同结构） | Actor + Critic（常共享躯干） | 前者要「冻结的靶子」，后者要「优势估计」 |
| 最该盯的诊断量 | Q 值尺度、loss 抖动、回报 | **近似 KL、裁剪比例、熵** | 三者的失效模式不同 |
:::

::: think 为什么 `train_ppo` 的回报统计是「本批总奖励」
`R.sum()` 是这一批 1024 步里累计的奖励，它不是「平均每局回报」，但它是**单调可比**的进展指标：同一个任务、同一批长度下，总奖励上升意味着「更快到达目标」或「到得更多」。真正的评估必须另跑（5.7.5），用**独立的评估回合**统计回报分布——**把训练指标当验收指标，是 RL 项目里最常见的自欺**。
:::

## 5.7.4 四类高频失败模式：症状、根因、处方

::: method 失败模式诊断表 {#method-5.7.4}
| 失败模式 | 可测量的症状 | 根因 | 处方 |
|:--|:--|:--|:--|
| **① 奖励设计错误 / 被 hack** | 训练回报上升但**独立评估**不变或变差；行为出现明显套路（原地刷分、堆长度、格式模板） | 奖励是**代理**，在训练分布外不可靠（[5.6.8](sec56.md)） | 独立验收指标；行为审计；加 KL / 早停；迭代补数据；慎用人为塑形奖励 |
| **② 探索不足** | 多个种子收敛到**不同但都次优**的解；回报曲线早早变平；策略熵快速塌到 ~0 | $\varepsilon$ 衰减过快 / 熵系数太小 / 初始估计过于自信 | 放慢 $\varepsilon$ 衰减（衰减周期 ≈ 总步数 1/5）；上调熵系数；乐观初始化；加噪声策略 |
| **③ 目标网络更新过快** | Q 值单调膨胀或剧烈振荡；loss 尖峰；成功率在不同种子间差异巨大 | 每步同步（等价于没有目标网络）或 $C$ 太小 | 同步周期 $C=10^3$–$10^4$ 或 Polyak $\tau\approx0.005$；降学习率 |
| **④ 方差爆炸** | 梯度范数尖峰；单次更新后回报**骤降且不恢复**；同一配置不同种子表现天差地别 | 回报尺度大 / 优势未归一化 / batch 太小 / $\gamma$ 太大 | 优势归一化；奖励缩放；梯度裁剪；加大 batch；加并行环境（A2C 思路）；降 $\gamma$ |
:::

::: intuition 为什么这四类要放在「诊断表」而不是「技巧表」里
因为它们都**不会报错**。代码能跑、loss 有数字、回报曲线在动——问题只会在几天后以「怎么调都不涨」或「人评变差」的形式暴露。诊断表的价值在于：**给每个症状配一个可测量的信号**，让排查从「猜」变成「看数字」。

排查顺序建议固定为：**先奖励、再评估协议、再探索、最后算法超参数**。理由：前三项的错误会让任何算法都失效，而算法超参数的错误通常只是变慢。**把顺序搞反（一上来就调学习率）是 RL 项目最常见的浪费。**
:::

## 5.7.5 评估协议：多种子、多回合、回报分布

::: method 一份可执行的最小评估协议 {#method-5.7.5}
1. **固定一组评估种子**（例如 `seed ∈ {1000..1049}`），与训练种子**不同**；评估时用**确定性策略**（DQN 取 `argmax`；PPO 可用策略均值或多次采样的平均，并注明用的是哪一种）。
2. **每个种子跑 $N$ 局**（本讲示例用 50–100 局），记录**每局的回报**，而不是只看平均。
3. **报分布**：均值 ± 标准差、中位数与四分位距、最好/最差；RL 的回报分布常常左偏或双峰（学会/没学会），只看均值会掩盖双峰现象。
4. **跨训练种子重复**（≥5 个，最好 10 个），对每个种子的（回合平均）回报再算**均值与 95% 置信区间**。
5. **报告训练曲线时画所有种子**（淡线）+ 中位数（粗线），而不是只画「最优种子」或「各种子平均」——
   多臂老虎机式的「取最好种子」是 RL 论文里最顽固的统计错误之一。
6. **改变任何一处配置都必须重新评估**，并把配置（种子、超参、环境版本、依赖版本）写进日志。
:::

```python
def evaluate(policy_or_q, env: GridWorld, runs: int = 50, seed: int = 1000):
    """独立的评估回合：不探索、不训练、不写入回放池。"""
    rng, rets = random.Random(seed), []
    for _ in range(runs):
        s, done, t, ep_r = env.reset(rng), False, 0, 0.0
        while not done and t < 50:
            x = obs(s)
            with torch.no_grad():
                logits, _ = policy_or_q(x) if isinstance(policy_or_q, PolicyNet) else (policy_or_q(x), None)
                a = int(logits.argmax().item())          # 确定性动作：排除策略随机性带来的噪声
            s, r, done = env.step(s, a)
            ep_r, t = ep_r + r, t + 1
        rets.append(ep_r)
    return torch.tensor(rets)

# 多种子：训练 5 个种子，每个种子评估 50 局，得到 5 个（近似）独立的性能估计
def multi_seed(train_fn, seeds=range(5), eval_runs=50):
    per_seed = []
    for sd in seeds:
        _, model = train_fn(sd)
        rets = evaluate(model, GridWorld(), runs=eval_runs, seed=1000 + sd)
        per_seed.append(rets.mean().item())              # 每个种子一个“性能估计”
    return torch.tensor(per_seed)
```

::: ex 例 5.7.1 · 五种子的置信区间：为什么「涨了 5 分」还不能下结论 {#ex-5.7.1}
假设某环境上两个算法各跑 5 个种子，每种子的评估回报（同一评估协议）如下：

| 算法 | 5 个种子的评估回报 | 均值 | 样本标准差 | 95% 置信区间 |
|:--|:--|:--|:--|:--|
| A（示例数据） | 128, 142, 96, 155, 119 | 128.0 | 22.5 | $[100.1,\ 155.9]$ |
| B（示例数据） | 131, 150, 101, 160, 125 | 133.4 | 23.0 | $[104.9,\ 161.9]$ |

B 的均值比 A 高 5.4 分。这个差值可信吗？

::: proof 解
**A 的统计量**：$\bar x=128.0$；离差 $0,14,-32,27,-9$；平方和 $0+196+1024+729+81=2030$；
$$s=\sqrt{\frac{2030}{5-1}}=\sqrt{507.5}\approx22.5,\qquad \mathrm{SE}=\frac{s}{\sqrt 5}\approx10.1 .$$
5 个样本的自由度 $df=4$，双侧 95% 的 $t$ 临界值 $t_{0.975,4}=2.776$，故
$$\text{CI}=128.0\pm2.776\times10.1=128.0\pm28.1=[99.9,\ 156.1]\ (\text{量级：约}\pm28).$$

**B 的统计量**：$\bar x=133.4$；离差 $-2.4,16.6,-32.4,26.6,-8.4$；平方和 $5.8+275.6+1049.8+707.6+70.6=2109.2$；
$$s\approx23.0,\qquad \mathrm{SE}\approx10.3,\qquad \text{CI}\approx133.4\pm28.5=[104.9,\ 161.9] .$$

**结论**：两个区间**大幅重叠**，5.4 分的差距被约 28 分的区间宽度完全淹没——**不能下「B 更好」的结论**。要检出这个量级的差异（以 $s\approx23$ 为参照），每个算法大约需要 $n\approx\left(\frac{2.8\times23}{5.4}\right)^2\approx142$ 个种子（用「两倍标准误」的粗估），这在算力上通常不现实。

**三个可操作的推论**：① **先降方差再比大小**：固定评估种子集合、增加评估回合数（降低「评估噪声」）、把环境随机性固定，往往比增加训练种子更便宜；② 报**效应量 + 区间**而不是「A 比 B 高 5 分」；③ 若差异确实很小，那就说明**这个改动不值得**——把精力花在奖励设计或数据上（[5.6](sec56.md)），而不是调参。
$\blacksquare$
:::
:::

::: method 三个比「均值 ± 标准差」更稳的做法 {#method-5.7.6}
| 做法 | 用在什么情况 | 代价 |
|:--|:--|:--|
| **分层自助法**（stratified bootstrap）按任务/种子分层重采样 | 多任务、多种子的一组实验；对非正态与异方差更稳 | 需要实现重采样（几十行代码）；结果依赖分层方式 |
| **分位数汇报**（中位数 + 四分位距 + 最差种子） | 回报分布明显左偏或双峰（学会/没学会） | 不给出「显著性」这类单一数字 |
| **固定评估种子集合 + 增加回合数** | 评估噪声大于训练种子噪声时（常见！） | 需要保证评估协议在所有对比中一致 |
:::

## 5.7.6 实验记录清单：让下次能复现

::: note[skip] 一份 RL 实验日志最少要写什么
| 分组 | 必须记录 |
|:--|:--|
| **环境** | 环境名与版本、终止/截断规则、奖励函数原文、最大步数、观测与动作空间 |
| **算法** | 算法名与实现来源（自写 / CleanRL / Stable-Baselines3 + 版本）、网络结构、参数总量 |
| **超参数** | 学习率、$\gamma$、$\lambda$、$\varepsilon$ 或熵系数、batch/minibatch、rollout 长度、目标网络同步周期、裁剪系数 $\beta$；**以及这些值是不是社区默认值** |
| **随机性** | 训练种子、环境种子、评估种子集合、`torch.use_deterministic_algorithms` 是否开启 |
| **数据** | 回放池容量、训练步数 / episodes / updates、是否早停、早停判据 |
| **评估** | 评估回合数、确定性还是随机策略、回报定义（折扣前还是折扣后、是否含塑形奖励） |
| **结果** | 每个种子的曲线与最终评估分布（不是最优值）、失败种子的现象描述 |
| **环境** | 库版本（`torch`、`numpy`、环境库）、硬件、单次实验的墙钟时间与显存 |
:::

::: errata 本节的六个常见误解（含本讲其余陷阱清单）
1. **「on-policy 与 off-policy 可以混用」**：Q-learning / DQN 是 off-policy，可以随便用回放池旧数据；REINFORCE 是 on-policy，用它跑旧数据必须做重要性修正；PPO 是「近似 on-policy」——靠 $\rho$ 在同一批数据上多跑几个 epoch，跑完必须重新采样（[5.5](sec55.md)）。
2. **「把 RL 当监督学习喂连续数据」**：轨迹样本强相关且分布随策略漂移，直接拿一小段连续轨迹反复更新会让网络灾难性遗忘其他状态。回放、打乱、基线、GAE 都是在替你**制造 i.i.d. 的假象**。
3. **「把 DQN 直接搬到连续动作空间」**：$y=r+\gamma\max_{a'}Q(s',a')$ 中的 $\max$ 在连续动作上是**内层优化**，逐点枚举不可行。连续控制应改用策略方法（PPO 直接参数化高斯策略）或专门的 Actor–Critic 变体（DDPG / TD3 / SAC）。
4. **「折扣因子随便设，或忘了打折」**：无限时域下 $\gamma=1$ 会让回报发散、值函数无定义；$\gamma\to1$ 又把有效视野拉长、方差暴涨。$\gamma$ 要与任务的**时间尺度**匹配（[5.2](sec52.md)）。
5. **「只看平均回报、不看种子与方差」**：RL 对随机种子极度敏感，同一算法换个种子可能一个学会、一个不学。报告必须给**多种子的均值与波动**（[例 5.7.1](sec57.md#ex-5.7.1)），必要时画出各条曲线。
6. **「忽视样本效率与稳定性的取舍」**：off-policy 方法（DQN）样本效率高但难调；on-policy（PPO）稳定但吃样本。先问清算力与在线交互预算，再选算法——不要拿一种方法硬套所有场景。
:::

::: method 即时自测 · 5.7
**Q1** DQN 循环里 `(1.0 - d_b)` 为什么乘在自举项上而不是乘在奖励上？写错会造成什么现象？

**Q2** 为什么 PPO 的一批数据只能跑有限个 epoch，而 DQN 的回放池可以长期复用？

**Q3** 训练日志显示：batch 总奖励从 30 涨到 90，但独立评估（50 局、确定性策略）的均值从 0.6 掉到 0.4。最可能的原因是什么？下一步查什么？

**Q4** 5 个种子的评估回报为 `[10, 12, 9, 11, 8]`，求均值、样本标准差与 95% 置信区间（$t_{0.975,4}=2.776$），并说明若另一个算法均值高 1.0，能否得出「更好」的结论。

::: sol 参考要点
**Q1** 因为 `(1-d)` 的作用是**关掉终止状态之后的自举**：终止意味着「后面没有未来了」，$V(s')$ 必须视为 0；而即时奖励 $r$ 是**已经真实拿到**的，与是否终止无关。写反了会把终止前最后一步的奖励一起抹掉（回报被系统性低估），典型现象是「智能体学会了绕圈不结束」或「靠近目标的动作被低估、到达率下降」。

**Q2** 因为两者的偏差来源不同。PPO 用 $\rho=\pi_\theta/\pi_{\theta_{\text{old}}}$ 做重要性修正，而这个修正在策略偏离太远时方差爆炸、估计失效（表现为 `approx_kl` 变大、`clip_frac` 升高）；DQN 的 TD 目标用 $\max$ 且与行为策略无关，因此**旧数据仍然是对 $Q^\ast$ 的无偏（近似）样本**，可以长期复用——代价是数据陈旧带来的分布偏差（这正是离线 RL 要专门处理的问题，[5.6](sec56.md)）。

**Q3** 最可能是**奖励被利用（reward hacking）或指标口径不一致**：训练奖励（本批总奖励）与评估回报不是同一个量——训练奖励里可能混入了「训练时的探索收益/塑形奖励」，而评估用确定性策略、且可能环境参数不同。**下一步查三件事**：① 奖励函数在训练与评估中是否完全一致（含任何塑形项）；② 评估是否真的用了独立回合与确定性策略（而不是仍在采样）；③ 直接看策略的行为录像/轨迹，检查是否有套路化行为。若确认是 hacking，回滚 checkpoint 并按 [5.6.8](sec56.md) 的对策处理。

**Q4** 均值 $\bar x=(10+12+9+11+8)/5=10.0$；离差 $0,2,-1,1,-2$，平方和 $0+4+1+1+4=10$；$s=\sqrt{10/4}=\sqrt{2.5}\approx1.58$；$\mathrm{SE}=1.58/\sqrt5\approx0.71$；CI $=10.0\pm2.776\times0.71=10.0\pm1.96=[8.0,\ 12.0]$。**若另一算法均值高 1.0**（即 11.0），其 CI（在方差相近时）约 $[9.0,\ 13.0]$，与上图区间**重度重叠**——**不能**得出「更好」的结论。**正确做法**：先增加评估回合/种子以缩小区间，或直接对**配对差值**（同一评估种子下的差值）做检验——配对能显著降低方差，通常比「比两个独立均值」灵敏得多。
:::
:::

::: note[skip] 延伸阅读
- Henderson et al., *Deep Reinforcement Learning That Matters*（AAAI 2018, arXiv:1709.06560）——种子敏感性与评估协议的经典批判性论文；5.7.5 的全部要求几乎都能在这篇里找到出处。
- Agarwal, Schwarzer, Castro, Courville & Bellemare, *Deep Reinforcement Learning at the Edge of the Statistical Precipice*（NeurIPS 2021, arXiv:2108.13264）——分层自助法、四分位均值与性能剖面（performance profile），把「多种子汇报」做了严格的统计处理。
- OpenAI Spinning Up 的 *Running Experiments* 与 *Experiment Setup* 章节——工程化的记录清单与常见坑。
- CleanRL（`github.com/vwxyzjn/cleanrl`）——单文件实现的 RL 算法集合（含 PPO / DQN / SAC 等），适合对照本节的循环结构逐行比较。
- Stable-Baselines3（`github.com/DLR-RM/stable-baselines3`）与 Gymnasium（`github.com/Farama-Foundation/Gymnasium`）——成熟实现与标准环境接口；注意 `reset()` / `step()` 的签名随版本变化（[5.4](sec54.md) 的版本提示）。
- Pardo et al., *A Closer Look at Deep Policy Gradients*（ICLR 2020, arXiv:1811.02553）——从梯度、更新步长与信噪比角度诊断策略梯度类算法的失败原因。
:::

**本节小结**：训练循环本身不长，难的是把它接对并且判断它真的在学。DQN 循环的核心是「回放池 + 目标网络 + `done` 掩码 + $\varepsilon$ 衰减」，PPO 循环的核心是「rollout → GAE → 优势归一化 → 多 epoch 裁剪更新 → 诊断量」。四类高频失败模式（奖励设计、探索不足、目标更新过快、方差爆炸）都**不会报错**，只能靠可测量的症状定位；而评估必须做到**多种子、多回合、报分布**——单条曲线与单点数字在 RL 里不构成证据。

> **本讲三句话带走**：
> 1. RL 把「有标签的监督」换成「**与环境交互、从奖励信号里试错**」；它独有的两个难题是**延迟的信用分配**与**探索—利用的张力**，MDP 与贝尔曼方程是描述它们的通用语言。
> 2. 两条主干殊途同归：**值方法**（Q-learning → DQN）先学 $Q$ 再取贪心动作，靠**经验回放 + 目标网络**稳住训练；**策略方法**（策略梯度 → Actor–Critic → PPO）直接对 $\pi_\theta$ 求梯度，靠**基线/优势**降方差、靠**裁剪**限制步幅。Actor–Critic 把两者合流，PPO 则是今天最稳、最通用的默认算法。
> 3. 前沿把 RL 推向两个极端：**离线 RL** 应对「不能交互，只有固定数据」，**RLHF / DPO / GRPO** 应对「奖励写不出来，用人类偏好或可验证信号代替」——后者正是大模型对齐的默认手段。
>
> **与后续的连接**：本讲把「结构 + 损失 + 梯度下降」的范式换成了「**策略 + 回报 + 试错**」，但底层仍是 [1.5](../lec01/sec15.md) 的反向传播在驱动。RLHF 与偏好优化直接接到第 6 讲（规模、对齐与推理模型）与第 7 讲（对齐、可控与安全）；用 RL 做科学发现与控制会出现在第 8 讲的案例里；而大规模策略/价值网络的并行训练，则落到第 9 讲的切分与通信。[Lab 3](../../labs/lab3.md) 微调大语言模型的流程里，SFT 之后的偏好优化环节就是本讲 5.6 的工程化身。
