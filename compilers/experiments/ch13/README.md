# 第 13 章实验

`run.sh` 在仓库的 `compilers/` 目录下执行一条完整流水线：

1. `loop.mc` 的 SSA（循环头部的 phi）；
2. `--opt` 后的 SSA（常量折叠与 DCE）；
3. 解释器与生成代码的四种组合对拍；
4. 生成的 x86-64 汇编栈帧；
5. `llvm-objdump` 中的 `subq` 对齐证据。

```bash
cd compilers
bash experiments/ch13/run.sh
```

需要 x86-64 执行环境（macOS 上是 Rosetta 2）才能跑第 3 步；没有时
`--run-compiled` 会报错，但 `--run` 与汇编检查仍可运行。
