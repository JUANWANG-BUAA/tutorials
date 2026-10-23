#!/usr/bin/env python3
"""
第 12 章实验：工具变量、断点回归与双重差分
实现 IV/2SLS、RD、DID 估计器，验证识别假设。

Requires: numpy, scipy, matplotlib, statsmodels
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from typing import Tuple, Dict
import warnings

warnings.filterwarnings('ignore')
np.random.seed(42)

# ========== [CONTINUED IN NEXT CHUNK] ==========
