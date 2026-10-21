# 附录 A · 母本覆盖矩阵

本矩阵由 tools/build_coverage.py 生成并校验；每个单元必须映射到一个存在的节锚点。「缺口 0」指没有未映射单元，不指逐字覆盖母本全文。

## A.1 总览

| 母本 | 单元 | 完整 | 精选 | 背景 | 交叉引用 | 淘汰 |
|:--|--:|--:|--:|--:|--:|--:|
| 自制编译器 | 15 | 13 | 1 | 0 | 1 | 0 |
| Rust Reference | 16 | 3 | 7 | 5 | 1 | 0 |
| Rustc Dev Guide | 17 | 7 | 5 | 4 | 1 | 0 |
| C 语言现代方法 | 15 | 3 | 7 | 4 | 1 | 0 |
| C++ 程序设计语言 | 12 | 1 | 6 | 5 | 0 | 0 |
| Effective Modern C++ | 9 | 0 | 3 | 6 | 0 | 0 |
| **合计** | **84** | **27** | **29** | **24** | **4** | **0** |

## A.2 逐单元映射

| # | 母本 | 单元 | 本书落点 | 深度 | 说明 |
|--:|:--|:--|:--|:--|:--|
| 1 | 自制编译器 | 编译器整体结构 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.3) | 完整 | 阶段划分与驱动 |
| 2 | 自制编译器 | 编译理论与实际实现 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.4) | 精选 | pass 与工程边界 |
| 3 | 自制编译器 | 词法分析 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.1) | 完整 | 正则/DFA/最大匹配 |
| 4 | 自制编译器 | 语法分析 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.3) | 完整 | 递归下降/Pratt |
| 5 | 自制编译器 | 抽象语法树 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.4) | 完整 | 节点/span/访问者 |
| 6 | 自制编译器 | 语义分析 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 完整 | 类型检查 |
| 7 | 自制编译器 | 变量与作用域 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.2) | 完整 | 符号表与遮蔽 |
| 8 | 自制编译器 | 类型与类型检查 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 完整 | 判断与推导 |
| 9 | 自制编译器 | 中间代码 | [part1/ch04.md](src/part1/ch04.md#sec-compilers.1.4.2) | 完整 | TAC/CFG |
| 10 | 自制编译器 | 表达式与语句翻译 | [part1/ch04.md](src/part1/ch04.md#sec-compilers.1.4.2) | 完整 | 控制流降级 |
| 11 | 自制编译器 | 函数调用与栈帧 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.3) | 完整 | 参数/返回/对齐 |
| 12 | 自制编译器 | 寄存器分配 | [part2/ch07.md](src/part2/ch07.md#sec-compilers.2.7.3) | 完整 | 图着色与溢出 |
| 13 | 自制编译器 | 代码生成 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.5) | 完整 | prologue/epilogue |
| 14 | 自制编译器 | 优化 | [part2/ch05.md](src/part2/ch05.md#sec-compilers.2.5.6) | 完整 | 保守性 |
| 15 | 自制编译器 | 链接与加载 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.1) | 交叉引用 | 指向 Linux 1.7 |
| 16 | Rust Reference | 类型与类型参数 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.1) | 精选 | 静态类型检查 |
| 17 | Rust Reference | 名字、作用域与遮蔽 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.2) | 完整 | 绑定与解析 |
| 18 | Rust Reference | 生命周期与借用 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 精选 | 检查器接口 |
| 19 | Rust Reference | 未定义行为 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.1) | 完整 | 抽象机器 |
| 20 | Rust Reference | ABI 与链接属性 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.1) | 交叉引用 | ABI 合同 |
| 21 | Rust Reference | 常量求值 | [part2/ch06.md](src/part2/ch06.md#sec-compilers.2.6.4) | 精选 | 编译期折叠 |
| 22 | Rust Reference | 析构与 drop | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.6) | 背景 | 清理语义 |
| 23 | Rust Reference | 模式匹配 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.4) | 背景 | AST 形态 |
| 24 | Rust Reference | 条件编译与属性 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.6) | 背景 | 构建配置 |
| 25 | Rust Reference | 运算符与重载 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 精选 | 类型约束 |
| 26 | Rust Reference | trait 与实现 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 精选 | 实例化边界 |
| 27 | Rust Reference | 泛型 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 完整 | 单态化 |
| 28 | Rust Reference | unsafe 与内存模型 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.3) | 精选 | UB 分类 |
| 29 | Rust Reference | FFI 与 repr | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.3) | 精选 | 布局与调用 |
| 30 | Rust Reference | 类型布局 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.3) | 背景 | 聚合参数 |
| 31 | Rust Reference | 内联与 codegen 属性 | [part2/ch06.md](src/part2/ch06.md#sec-compilers.2.6.3) | 背景 | 内联提示 |
| 32 | Rustc Dev Guide | 编译器高层结构 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.4) | 完整 | driver/pass |
| 33 | Rustc Dev Guide | 查询系统 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.7) | 精选 | 增量与缓存 |
| 34 | Rustc Dev Guide | HIR 与 MIR | [part1/ch04.md](src/part1/ch04.md#sec-compilers.1.4.7) | 精选 | IR 谱系 |
| 35 | Rustc Dev Guide | THIR 与类型检查 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 背景 | 检查顺序 |
| 36 | Rustc Dev Guide | 类型推导 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 完整 | 约束求解 |
| 37 | Rustc Dev Guide | trait 求解 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 背景 | 实例化 |
| 38 | Rustc Dev Guide | 借用检查 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 精选 | 生命周期 |
| 39 | Rustc Dev Guide | 单态化 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 完整 | 代码膨胀 |
| 40 | Rustc Dev Guide | 代码生成 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.5) | 完整 | 后端 |
| 41 | Rustc Dev Guide | LLVM 后端 | [part2/ch07.md](src/part2/ch07.md#sec-compilers.2.7.6) | 交叉引用 | 目标描述 |
| 42 | Rustc Dev Guide | 调试信息 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.6) | 精选 | 可复现构建 |
| 43 | Rustc Dev Guide | 增量编译 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.7) | 完整 | 查询缓存 |
| 44 | Rustc Dev Guide | 测试与编译测试 | [part3/ch10.md](src/part3/ch10.md#sec-compilers.3.10.4) | 精选 | 属性测试 |
| 45 | Rustc Dev Guide | sanitizer | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.4) | 完整 | 插桩 |
| 46 | Rustc Dev Guide | fuzz 与回归 | [part3/ch10.md](src/part3/ch10.md#sec-compilers.3.10.2) | 完整 | 覆盖率 |
| 47 | Rustc Dev Guide | 性能剖析 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.7) | 背景 | 预算 |
| 48 | Rustc Dev Guide | 交叉编译与目标 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.1) | 背景 | 目标三元组 |
| 49 | C 语言现代方法 | 词法元素 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.1) | 精选 | token 边界 |
| 50 | C 语言现代方法 | 声明与作用域 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.2) | 精选 | 符号表 |
| 51 | C 语言现代方法 | 表达式 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.3) | 背景 | 优先级 |
| 52 | C 语言现代方法 | 选择与循环 | [part1/ch04.md](src/part1/ch04.md#sec-compilers.1.4.2) | 精选 | CFG 降级 |
| 53 | C 语言现代方法 | 函数 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.3) | 精选 | 调用 |
| 54 | C 语言现代方法 | 指针与数组 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.3) | 精选 | 越界 UB |
| 55 | C 语言现代方法 | 字符串 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.3) | 背景 | 缓冲区 |
| 56 | C 语言现代方法 | 预处理器 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.6) | 背景 | 构建阶段 |
| 57 | C 语言现代方法 | 程序组织 | [part1/ch01.md](src/part1/ch01.md#sec-compilers.1.1.3) | 精选 | 编译单元 |
| 58 | C 语言现代方法 | 整数类型与转换 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.6) | 完整 | 提升与截断 |
| 59 | C 语言现代方法 | 浮点类型 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.3) | 背景 | 调用约定 |
| 60 | C 语言现代方法 | 指针算术 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.3) | 精选 | 边界 UB |
| 61 | C 语言现代方法 | 未定义行为 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.1) | 完整 | 可观察行为 |
| 62 | C 语言现代方法 | UB 的例子 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.2) | 完整 | 分类 |
| 63 | C 语言现代方法 | 链接 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.1) | 交叉引用 | 指向 Linux 1.7 |
| 64 | C++ 程序设计语言 | 类型与对象 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.1) | 精选 | 表示 |
| 65 | C++ 程序设计语言 | 声明与作用域 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.2) | 精选 | 名字查找 |
| 66 | C++ 程序设计语言 | 表达式 | [part1/ch02.md](src/part1/ch02.md#sec-compilers.1.2.3) | 背景 | 求值顺序 |
| 67 | C++ 程序设计语言 | 语句 | [part1/ch04.md](src/part1/ch04.md#sec-compilers.1.4.2) | 背景 | 控制流 |
| 68 | C++ 程序设计语言 | 函数 | [part2/ch08.md](src/part2/ch08.md#sec-compilers.2.8.3) | 精选 | 调用/返回 |
| 69 | C++ 程序设计语言 | 命名空间 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.2) | 背景 | 限定名 |
| 70 | C++ 程序设计语言 | 重载 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 精选 | 重载决议 |
| 71 | C++ 程序设计语言 | 模板 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 完整 | 实例化 |
| 72 | C++ 程序设计语言 | 类与布局 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.3) | 背景 | 成员偏移 |
| 73 | C++ 程序设计语言 | 优化 | [part2/ch06.md](src/part2/ch06.md#sec-compilers.2.6.6) | 精选 | pass 顺序 |
| 74 | C++ 程序设计语言 | 异常与栈展开 | [part3/ch12.md](src/part3/ch12.md#sec-compilers.3.12.1) | 背景 | 执行模型 |
| 75 | C++ 程序设计语言 | 内联 | [part2/ch06.md](src/part2/ch06.md#sec-compilers.2.6.3) | 精选 | 成本模型 |
| 76 | Effective Modern C++ | auto 与类型推导 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.4) | 精选 | 推导规则 |
| 77 | Effective Modern C++ | 移动语义 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.6) | 背景 | 值类别 |
| 78 | Effective Modern C++ | 完美转发 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 背景 | 实例化 |
| 79 | Effective Modern C++ | 智能指针与所有权 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.6) | 背景 | 清理 |
| 80 | Effective Modern C++ | lambda 与闭包 | [part1/ch03.md](src/part1/ch03.md#sec-compilers.1.3.5) | 背景 | 捕获 |
| 81 | Effective Modern C++ | 并发与数据竞争 | [part3/ch09.md](src/part3/ch09.md#sec-compilers.3.9.4) | 背景 | TSan |
| 82 | Effective Modern C++ | constexpr 与编译期计算 | [part2/ch06.md](src/part2/ch06.md#sec-compilers.2.6.4) | 精选 | 常量传播 |
| 83 | Effective Modern C++ | 零开销抽象 | [part2/ch07.md](src/part2/ch07.md#sec-compilers.2.7.1) | 精选 | 指令选择 |
| 84 | Effective Modern C++ | 内联与可见性 | [part2/ch06.md](src/part2/ch06.md#sec-compilers.2.6.3) | 背景 | LTO |

## A.3 缺口

缺口：**0**。构建脚本在映射缺失、页面不存在、锚点不存在、深度非法或单元重复时拒绝写出。

