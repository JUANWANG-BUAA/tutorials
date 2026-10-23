# 实验环境与工具链

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>复现全书所有实验需要哪些基础软件环境？macOS 与 Linux 在沙箱评测上有何差异？如何快速搭建最小可运行工具链？</p></div>
<div><span class="ci-label">读完你会</span><p>能独立配置包含 Python 3.11+、科学计算栈与 Linux 沙箱的完整测试环境；掌握一键运行全书实验的脚本命令；能诊断环境缺失引起的运行报错。</p></div>
</div>

## 0.1 基础软件栈清单

| 组件 | 推荐版本 | 用途 | 检查命令 |
|:--|:--|:--|:--|
| **Python** | 3.11 或更高 | 运行全书核心算法与实验脚本 | `python3 --version` |
| **NumPy** | 1.24+ | 高性能向量化、矩阵运算与随机模拟 | `python3 -c "import numpy; print(numpy.__version__)"` |
| **SciPy** | 1.10+ | 统计分布、假设检验、稀疏矩阵与优化器 | `python3 -c "import scipy; print(scipy.__version__)"` |
| **Scikit-Learn** | 1.3+ | 交叉验证、评估指标与机器学习基模型 | `python3 -c "import sklearn; print(sklearn.__version__)"` |
| **Statsmodels** | 0.14+ | 线性回归、2SLS 工具变量回归与方差分析 | `python3 -c "import statsmodels; print(statsmodels.__version__)"` |
| **Matplotlib** | 3.7+ | 绘制功效曲线、收敛轨迹与算法对比图 | `python3 -c "import matplotlib; print(matplotlib.__version__)"` |
| **GCC / Clang** | GCC 11+ / Clang 14+ | 编译第 13 章评测系统的 C/C++ 受测源码与沙箱包装器 | `cc --version` |
| **mdBook** | 0.4.30+ | 本地静态构建与渲染本书教程 | `mdbook --version` |

## 0.2 环境安装与依赖配置

### Python 科学计算依赖安装
建议在独立的虚拟环境中安装所需库：

```bash
# 创建并激活虚拟环境
python3 -m venv .venv
source .venv/bin/activate

# 安装核心计算库
pip install --upgrade pip
pip install numpy scipy scikit-learn statsmodels matplotlib
```

### 操作系统专属特性声明
- **全书算法与统计实验（第 1–12 章、第 14 章）**：完全基于纯 Python + 标准科学计算库开发，在 **macOS（Apple Silicon / Intel）、Linux（x86_64 / ARM64）与 Windows (WSL2)** 上均可 100% 独立无差异运行。
- **第 13 章项目一（评测系统安全沙箱）**：
  - 核心系统调用过滤 `seccomp-bpf` 与统一资源隔离树 `cgroup v2` 是 **Linux 内核原生特性**；
  - 在 macOS 本地测试时，评测引擎会自动降级为基于进程超时与退出码模拟的标准模式；若需验证完整的沙箱逃逸拦截，请在 Linux 宿主机或 Docker 容器中执行。

## 0.3 统一实验运行入口

本书所有章节实验均收敛在 `experiments/` 目录中，支持单章运行与全局自动化批处理：

```bash
# 运行指定章节实验（例如第 1 章复杂度分析）
python3 experiments/ch01/asymptotic_lab.py

# 运行所有章节实验并输出汇总通过率
bash experiments/run_all.sh
```
