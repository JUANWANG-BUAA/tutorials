# 节级覆盖审计（机械筛子）

> 由 `tools/audit_sections.py` 生成。`zero` 表示标题里的高信息量词在限定篇目正文中一个都没找到；`weak` 表示只命中一个词或命中率 < 34%。这两类必须人工复核：可能真的漏了，也可能只是换了说法。

共 1723 个节级条目，`zero` 5、`weak` 572、`ok` 1146。

## 需要复核的条目

| 状态 | 母本 | 章 | 节 | 标题 | 最佳落点 | 命中词 |
|:--|:--|:--|:--|:--|:--|:--|
| zero | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.8.4 | 使用库 | None | — |
| zero | C · CSAPP 3e | 3 | 3.1 | 历史观点 | None | — |
| zero | G · 鸟哥的 Linux 私房菜 | 9 | 9.2 | vi 的使用 | None | — |
| zero | K · Kerrisk 系统编程手册 | 1 | 1.2 | Linux 简史 | None | — |
| zero | O · OSTEP | 17 | 17.4 | 其他方式 | None | — |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 1 | 1.1 | Linux初探 | part0/ch09-overview.md | 初探 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 1 | 1.1.1 | 深入探究Linux内核 | part0/ch01-overview.md | 深入、内核 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.1.2 | 图形化终端 | part0/ch01.md | 图形、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.3 | 通过图形化终端仿真器访问CLI | part0/ch02.md | cli、通过、图形、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.4 | 使用GNOME Terminal终端仿真器 | part0/ch02-exercises.md | gnome、terminal、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.4.2 | 菜单栏 | part0/ch01.md | 菜单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.5 | 使用Konsole终端仿真器 | part0/ch01-checklist.md | 终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.5.1 | 访问Konsole终端仿真器 | part0/ch01.md | 访问、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.5.2 | 菜单栏 | part0/ch01.md | 菜单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.6 | 使用xterm终端仿真器 | part0/ch01-checklist.md | 终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.6.1 | 访问xterm | part0/ch01-recall.md | 访问 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.6.2 | 命令行选项 | part0/ch01-summary.md | 命令行、命令、令行、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.3 | 与bash手册交互 | part0/ch02.md | bash、手册、交互 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5.1 | 显示基本列表 | part0/ch01.md | 显示、基本、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5.2 | 显示长列表 | part0/ch01.md | 显示、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5.3 | 过滤输出列表 | part0/ch06.md | 输出列、过滤、输出、出列、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.6.3 | 使用命令行补全 | part0/ch02.md | 用命令、命令行、用命、命令、令行、补全 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.6.5 | 文件重命名 | part0/ch02.md | 重命名、文件、重命、命名 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.1 | 监测程序 | part0/ch10.md | 监测、程序 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.1.2 | 实时监测进程 | part0/ch08.md | 实时、测进、进程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.2.1 | 挂载存储设备 | part0/ch01.md | 挂载、存储、设备 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.2.2 | 使用df命令 | part0/ch01-checklist.md | 命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.2.3 | 使用du命令 | part0/ch01-checklist.md | 命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.1 | 数据排序 | part0/ch01.md | 数据、排序 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.2 | 数据搜索 | part0/ch01.md | 数据、搜索 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.3 | 数据压缩 | part0/ch01.md | 数据、压缩 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.4 | 数据归档 | part0/ch01.md | 数据、归档 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 5 | 5.2.1 | 查看进程列表 | part0/ch09.md | 看进程、查看、看进、进程、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 5 | 5.2.2 | 别出心裁的子shell用法 | part0/ch02.md | shell、的子、用法 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 6 | 6.2.2 | 设置全局环境变量 | part0/ch04.md | 环境变量、环境变、境变量、设置、全局、环境 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 6 | 6.6 | 定位系统环境变量 | part0/ch01-exercises.md | 环境变量、环境变、境变量、定位、系统、环境 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 6 | 6.7 | 数组变量 | part0/ch03.md | 数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.1.3 | 添加新用户 | part0/ch01-errata.md | 新用户、新用、用户 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.4 | 更改安全设置 | part0/ch01-recall.md | 安全、设置 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.4.2 | 改变所属关系 | part0/ch03.md | 改变、所属、关系 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 8 | 8.3 | 逻辑卷管理 | part0/ch10-exercises.md | 逻辑卷、逻辑、辑卷 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 8 | 8.3.3 | 使用Linux LVM | part0/ch01.md | lvm |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.2.1 | 使用apt管理软件包 | part0/ch10.md | apt、软件包、软件、件包 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.2.3 | 使用apt升级软件 | part0/ch01.md | apt、升级、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.3.3 | 使用dnf升级软件 | part0/ch01.md | dnf、升级、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.3.4 | 使用dnf卸载软件 | part0/ch01.md | dnf、卸载、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.4 | 使用容器管理软件 | part0/ch01.md | 用容器、用容、容器、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.2 | vim基础 | part0/ch01.md | vim |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.3 | 编辑数据 | part0/ch01.md | 编辑、数据 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.4 | 复制和粘贴 | part0/ch02.md | 和粘贴、复制、和粘、粘贴 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.5 | 查找和替换 | part0/ch06.md | 和替换、查找、和替、替换 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.3.2 | 在控制台中使用Emacs | part0/ch02.md | 控制台、控制、制台 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.3.3 | 在GUI中使用Emacs | part0/ch02-exercises.md | gui |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.4 | KDE系编辑器 | part0/ch02-overview.md | 编辑器、编辑、辑器 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.5.1 | 启动gedit | part0/ch01-checklist.md | 启动 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.5.2 | gedit的基本功能 | part0/ch01.md | 的基本、的基、基本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.5.3 | 管理插件 | part0/ch01-recall.md | 插件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.3 | 显示消息 | part0/ch05.md | 显示、消息 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.6 | 管道 | part0/ch01-exercises.md | 管道 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.7 | 执行数学运算 | part0/ch06.md | 执行、行数、数学、运算 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.7.2 | 使用方括号 | part0/ch07.md | 方括号、用方、方括、括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.7.3 | 浮点数解决方案 | part0/ch01.md | 浮点数、浮点、点数、解决 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.9 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.1 | 使用if-then语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.2 | if-then-else语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.4.3 | 文件比较 | part0/ch01.md | 文件、比较 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.6.1 | 使用单括号 | part0/ch06.md | 用单、括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.6.2 | 使用双括号 | part0/ch07.md | 双括号、双括、括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.8 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1 | for命令 | part0/ch01-checklist.md | 命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.1 | 读取列表中的值 | part0/ch10.md | 表中的、读取、表中、中的 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.2 | 读取列表中的复杂值 | part0/ch03.md | 读取、列表、表中、中的、复杂 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.3 | 从变量中读取值列表 | part0/ch07.md | 从变量、从变、变量、读取、取值、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.4 | 从命令中读取值列表 | part0/ch07.md | 从命令、从命、命令、读取、取值、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.6 | 使用通配符读取目录 | part0/ch07.md | 用通配符、用通配、通配符、用通、通配、配符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.3.2 | 使用多个测试命令 | part0/ch06.md | 用多个、用多、多个、测试、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.5 | 嵌套循环 | part0/ch03.md | 嵌套、循环 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.6 | 循环处理文件数据 | part0/ch03.md | 文件数据、文件数、件数据、循环、处理、文件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.8 | 处理循环的输出 | part0/ch06.md | 循环的、的输出、处理、循环、环的、的输 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.9 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.9.2 | 创建多个用户账户 | part0/ch01.md | 个用户、创建、多个、个用、用户 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.1 | 传递参数 | part0/ch03.md | 传递、参数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.1.2 | 读取脚本名 | part0/ch07.md | 脚本名、读取、脚本、本名 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.2 | 特殊参数变量 | part0/ch07.md | 数变量、特殊、参数、数变、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.2.2 | 获取所有的数据 | part0/ch03.md | 的数据、所有、有的、的数、数据 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.4 | 处理选项 | part0/ch01.md | 处理、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.4.1 | 查找选项 | part0/ch02.md | 查找、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.2 | 超时 | part0/ch01-exercises.md | 超时 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.3 | 无显示读取 | part0/ch01.md | 显示、读取 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.4 | 从文件中读取 | part0/ch03.md | 从文件、从文、文件、件中、读取 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.7 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.1 | 理解输入和输出 | part0/ch14.md | 和输出、输入、和输、输出 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.2.2 | 永久重定向 | part0/ch02.md | 重定向、永久、重定、定向 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.7.1 | 创建本地临时文件 | part0/ch01.md | 临时文件、临时文、时文件、创建、本地、临时 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.8 | 记录消息 | part0/ch05.md | 记录、消息 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.9 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.1.1 | 重温Linux信号 | part0/ch01.md | 信号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.1.2 | 产生信号 | part0/ch01.md | 产生、信号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.1.5 | 修改或移除信号捕获 | part0/ch07-recall.md | 信号捕获、信号捕、号捕获、修改、信号、号捕 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.3 | 在非控制台下运行脚本 | part0/ch07.md | 运行脚本、运行脚、行脚本、在非、控制、运行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.5 | 调整谦让度 | part0/ch02.md | 调整 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.6 | 定时运行作业 | part0/ch02.md | 时运行、定时、时运、运行、作业 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.6.1 | 使用at命令调度作业 | part0/ch01.md | 命令、调度、作业 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.7 | 使用新shell启动脚本 | part0/ch02.md | shell、用新、启动、脚本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.8 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.1 | 脚本函数基础 | part0/ch01.md | 脚本、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.2.3 | 使用函数输出 | part0/ch01.md | 用函数、用函、函数、输出 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.3.1 | 向函数传递参数 | part0/ch07.md | 函数传、数传递、函数、数传、传递、参数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.4 | 数组变量和函数 | part0/ch07.md | 变量和、和函数、数组、变量、量和、和函 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.4.1 | 向函数传递数组 | part0/ch07.md | 函数传、数传递、函数、数传、传递、数组 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.5 | 函数递归 | part0/ch02.md | 函数、递归 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.7.2 | 在.bashrc文件中定义函数 | part0/ch06-overview.md | 定义函数、定义函、义函数、文件、定义、义函 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.8 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.8.1 | 下载及安装 | part0/ch01.md | 下载、安装 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1 | 创建文本菜单 | part0/ch04.md | 创建文、创建、建文、文本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.1 | 创建菜单布局 | part0/ch01.md | 创建、菜单、布局 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.2 | 创建菜单函数 | part0/ch01.md | 创建、菜单、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.3 | 添加菜单逻辑 | part0/ch01.md | 菜单、逻辑 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.4 | 整合shell脚本菜单 | part0/ch01.md | shell、脚本、菜单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.2 | 创建文本窗口部件 | part0/ch04.md | 创建文、创建、建文、文本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.2.2 | dialog选项 | part0/ch01-summary.md | 选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.3 | 图形化窗口部件 | part0/ch12.md | 化窗口、图形、化窗、窗口 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.4 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2 | sed编辑器基础命令 | part0/ch03.md | sed、基础命令、基础命、础命令、础命、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.1 | 更多的替换选项 | part0/ch06.md | 的替换、多的、的替、替换、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.2 | 使用地址 | part0/ch14.md | 用地、地址 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.4 | 插入和附加文本 | part0/ch04.md | 插入、附加、文本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.5 | 修改行 | part0/ch01-exercises.md | 修改 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.7 | 再探打印 | part0/ch01-exercises.md | 打印 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.3 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.1.1 | 定义 | part0/ch01-exercises.md | 定义 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.3 | 锚点字符 | part0/ch06-checklist.md | 锚点、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.4 | 点号字符 | part0/ch06.md | 点号、号字、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.6 | 排除型字符组 | part0/ch03.md | 型字符、排除、型字、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.7 | 区间 | part0/ch01.md | 区间 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.8 | 特殊的字符组 | part0/ch07.md | 的字符、字符组、特殊、的字、字符、符组 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.9 | 星号 | part0/ch07.md | 星号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.3.1 | 问号 | part0/ch04.md | 问号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.3.2 | 加号 | part0/ch04.md | 加号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.3.4 | 竖线符号 | part0/ch06.md | 竖线、符号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.4 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.4.2 | 验证电话号码 | part0/ch09.md | 验证、话号、号码 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.1.2 | 多行删除命令 | part0/ch06.md | 除命令、多行、删除、除命、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.4 | 改变执行流程 | part0/ch07.md | 改变、执行、行流、流程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.4.1 | 分支 | part0/ch01-errata.md | 分支 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.4.2 | 测试 | part0/ch01-recall.md | 测试 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.5.1 | &符号 | part0/ch01-errata.md | 符号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.5.2 | 替换单独的单词 | part0/ch03.md | 单独的、替换、单独、独的、的单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.6.1 | 使用包装器 | part0/ch01.md | 用包装、用包、包装、装器 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.1 | 加倍行间距 | part0/ch06.md | 行间 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.2 | 对可能含有空行的文件加倍行间距 | part0/ch06.md | 行的文件、有空行、空行的、行的文、的文件、可能 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.3 | 给文件中的行编号 | part0/ch06.md | 中的行、行编号、文件、中的、的行、行编 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.4 | 打印末尾行 | part0/ch01.md | 打印、末尾 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.8 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.2.1 | 定义数组变量 | part0/ch03.md | 定义、数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.2.3 | 删除数组变量 | part0/ch03.md | 删除数、删除、除数、数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.3.2 | 匹配操作符 | part0/ch02-summary.md | 操作符、匹配、作符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.3.3 | 数学表达式 | part0/ch06.md | 表达式、数学、表达、达式 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.4.1 | if语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.4.3 | do-while语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.4.4 | for语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.5 | 格式化打印 | part0/ch01-exercises.md | 格式化、格式、式化、打印 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.6.1 | 数学函数 | part0/ch06.md | 数学、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.6.2 | 字符串函数 | part0/ch01.md | 字符串、字符、符串、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.8 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.3 | dash脚本编程 | part0/ch01.md | dash、脚本、编程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.3.2 | 不能使用的特性 | part0/ch10.md | 使用的、不能、用的、的特、特性 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.6 | zsh脚本编程 | part0/ch06.md | zsh、脚本、编程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.6.1 | 数学运算 | part0/ch06.md | 数学、运算 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.6.3 | 函数 | part0/ch01-overview.md | 函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.7 | 实战演练 | part0/ch06-checklist.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.1 | 备份 | part0/ch01-exercises.md | 备份 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.1.2 | 创建按小时归档的脚本 | part0/ch03.md | 归档的、的脚本、创建、小时、归档、档的 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.2 | 删除账户 | part0/ch01.md | 删除 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.2.1 | 功能需求 | part0/ch01.md | 能需、需求 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.3 | 系统监控 | part0/ch01.md | 系统、监控 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.3.1 | 获得默认的shell审计功能 | part0/ch11.md | shell、默认的、默认、认的、审计 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.2 | 暂存区 | part0/ch06.md | 暂存 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.3 | 本地仓库 | part0/ch02.md | 本地、仓库 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.4 | 远程仓库 | part0/ch02.md | 远程、仓库 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.5 | 分支 | part0/ch01-errata.md | 分支 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.6 | 克隆 | part0/ch01.md | 克隆 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.3 | 使用Git提交文件 | part0/ch05.md | git、提交、文件 |
| weak | C · CSAPP 3e | 1 | 1.3 | 了解编译系统如何工作是大有益处的 | part1/ch01.md | 了解编译、解编译系、编译系统、了解编、解编译、编译系 |
| weak | C · CSAPP 3e | 2 | 2.1 | 信息存储 | part1/ch01-checklist.md | 信息、存储 |
| weak | C · CSAPP 3e | 3 | 3.10 | 在机器级程序中将控制与数据结合起来 | part1/ch02.md | 机器级程、器级程序、机器级、器级程、级程序、与数据 |
| weak | C · CSAPP 3e | 3 | 3.5 | 算数和逻辑操作 | part1/ch02.md | 数和、逻辑 |
| weak | C · CSAPP 3e | 3 | 3.6 | 控制 | part1/ch01-exercises.md | 控制 |
| weak | C · CSAPP 3e | 3 | 3.7 | 过程 | part1/ch01.md | 过程 |
| weak | C · CSAPP 3e | 3 | 3.8 | 数组分配和访问 | part1/ch06.md | 和访问、数组、分配、和访、访问 |
| weak | C · CSAPP 3e | 4 | 4.3 | Y86-64的顺序现实 | part1/ch03.md | y86-64、的顺序、的顺、顺序 |
| weak | C · CSAPP 3e | 8 | 8.1 | 异常 | part1/ch01.md | 异常 |
| weak | C · CSAPP 3e | 8 | 8.2 | 进程 | part1/ch01-checklist.md | 进程 |
| weak | C · CSAPP 3e | 8 | 8.5 | 信号 | part1/ch01.md | 信号 |
| weak | C · CSAPP 3e | 10 | 10.1 | Unix I/O | part1/ch01-checklist.md | i/o |
| weak | C · CSAPP 3e | 10 | 10.2 | 文件 | part1/ch01-checklist.md | 文件 |
| weak | C · CSAPP 3e | 10 | 10.7 | 读取目录和内容 | part1/ch10.md | 读取目录、读取目、取目录、读取、取目、目录 |
| weak | C · CSAPP 3e | 11 | 11.2 | 网络 | part1/ch01-checklist.md | 网络 |
| weak | G · 鸟哥的 Linux 私房菜 | 0 | 0.1 | 电脑：辅助人脑的好工具 | part0/ch12.md | 辅助、的好、工具 |
| weak | G · 鸟哥的 Linux 私房菜 | 0 | 0.2 | 个人电脑架构与相关设备元件 | part0/ch01.md | 架构与、架构、构与、设备 |
| weak | G · 鸟哥的 Linux 私房菜 | 1 | 1.2 | Torvalds的Linux发展 | part0/ch01.md | torvalds |
| weak | G · 鸟哥的 Linux 私房菜 | 1 | 1.3 | Linux当前应用的角色 | part0/ch07.md | 的角色、当前、应用、用的、的角、角色 |
| weak | G · 鸟哥的 Linux 私房菜 | 1 | 1.4 | Linux 该如何学习 | part0/ch01-checklist.md | 学习 |
| weak | G · 鸟哥的 Linux 私房菜 | 2 | 2.1 | Linux与硬件的搭配 | part0/ch01.md | 与硬件、与硬、硬件、件的 |
| weak | G · 鸟哥的 Linux 私房菜 | 2 | 3.2 | 开始安装CentOS 7 | part0/ch01-exercises.md | 开始、安装 |
| weak | G · 鸟哥的 Linux 私房菜 | 2 | 3.3 | 多重开机安装流程与管理（Option｜ | part0/ch01.md | option、开机、安装、流程、程与 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.1 | 首次登陆系统 | part0/ch02-overview.md | 首次登、首次、次登、系统 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.2 | 文字模式下指令的下达 | part0/ch10.md | 下指令的、模式下、下指令、指令的、模式、式下 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.3 | Linux系统的线上求助man page与info page | part0/ch01.md | man、page、info、系统的、系统、统的 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.4 | 超简单文书编辑器： nano | part0/ch04.md | nano、编辑器、简单、编辑、辑器 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.5 | 正确的关机方法 | part0/ch03.md | 正确的、正确、确的、的关、关机 |
| weak | G · 鸟哥的 Linux 私房菜 | 5 | 5.1 | 使用者与群组 | part0/ch01.md | 使用者、用者 |
| weak | G · 鸟哥的 Linux 私房菜 | 6 | 6.5 | 指令与文件的搜寻 | part0/ch02.md | 令与文件、令与文、与文件、文件的、令与、与文 |
| weak | G · 鸟哥的 Linux 私房菜 | 6 | 6.6 | 极重要的复习！权限与指令间的关系 | part0/ch03.md | 重要、要的、权限与、的关系、权限、限与 |
| weak | G · 鸟哥的 Linux 私房菜 | 7 | 7.4 | 设置开机挂载 | part0/ch10.md | 设置、开机、机挂、挂载 |
| weak | G · 鸟哥的 Linux 私房菜 | 7 | 7.5 | 内存交换空间（swap｜ॎ䭒᭞ | part0/ch02.md | swap、内存、交换、空间 |
| weak | G · 鸟哥的 Linux 私房菜 | 8 | 8.3 | 打包指令： tar | part0/ch01.md | tar、打包、指令 |
| weak | G · 鸟哥的 Linux 私房菜 | 8 | 8.5 | 光盘写入工具 | part0/ch10.md | 光盘、写入、工具 |
| weak | G · 鸟哥的 Linux 私房菜 | 9 | 9.1 | vi 与 vim | part0/ch01.md | vim |
| weak | G · 鸟哥的 Linux 私房菜 | 9 | 9.3 | vim 的额外功能 | part0/ch04.md | vim、的额、额外 |
| weak | G · 鸟哥的 Linux 私房菜 | 9 | 9.4 | 其他 vim 使用注意事项 | part0/ch01.md | vim、注意 |
| weak | G · 鸟哥的 Linux 私房菜 | 10 | 10.2 | Shell 的变量功能 | part0/ch01-overview.md | shell、的变量、的变、变量 |
| weak | G · 鸟哥的 Linux 私房菜 | 10 | 10.3 | 命令别名与历史命令 | part0/ch02.md | 别名与、与历史、命令、别名、名与、与历 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 12.3 | 善用判断式 | part0/ch07.md | 判断式、判断、断式 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.1 | Linux 的帐号与群组 | part0/ch01-overview.md | 号与 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.2 | 帐号管理 | part0/ch04-overview.md | 号管理、号管 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.3 | 主机的细部权限规划：ACL 的使用 | part0/ch08.md | acl、主机的、主机、机的、的细、权限 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.6 | Linux 主机上的使用者讯息传递 | part0/ch01.md | 主机上的、主机上、机上的、使用者、主机、机上 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.7 | CentOS 7 环境下大量创建帐号的方法 | part0/ch14.md | 的方法、环境、大量、创建、号的、的方 |
| weak | G · 鸟哥的 Linux 私房菜 | 14 | 14.2 | 软件磁盘阵列 （Software RAID｜ | part0/ch10.md | raid、软件、磁盘、阵列 |
| weak | G · 鸟哥的 Linux 私房菜 | 14 | 14.3 | 逻辑卷轴管理员 （Logical Volume Manager｜ | part0/ch10.md | logical、volume、逻辑卷、管理员、逻辑、辑卷 |
| weak | G · 鸟哥的 Linux 私房菜 | 15 | 15.4 | 可唤醒停机期间的工作任务 | part0/ch12.md | 停机期间、停机期、机期间、唤醒、停机、机期 |
| weak | G · 鸟哥的 Linux 私房菜 | 18 | 18.4 | systemd-journald.service 简介 | part0/ch12.md | systemd-journald.service |
| weak | G · 鸟哥的 Linux 私房菜 | 19 | 19.2 | 核心与核心模块 | part0/ch01-summary.md | 核心、模块 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.1 | 系统基本设置 | part0/ch04.md | 系统、基本、本设、设置 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.4 | 备份的种类、频率与工具的遜ॢ | part0/ch08.md | 备份的、备份、份的、种类、工具的、与工 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.5 | 鸟哥的备份策略 | part0/ch03.md | 的备份、鸟哥、的备、备份、策略 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.6 | 灾难复原的考虑 | part0/ch06.md | 灾难、考虑 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 20.1 | 开放源码的软件安装与升级简介 | part0/ch03.md | 软件安装、软件安、件安装、源码、软件、件安 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.2 | 使用传统程序语言进行编译的简单范例 | part0/ch01.md | 统程序、编译的、传统、统程、程序、语言 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.3 | 用 make 进行宏编译 | part0/ch01.md | make、编译 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.4 | Tarball 的管理与建议 | part0/ch11.md | tarball、管理与、理与、建议 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.5 | 函数库管理 | part0/ch08.md | 函数库、函数、数库 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.6 | 检验软件正确性 | part0/ch06.md | 正确性、检验、软件、正确、确性 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.1 | 软件管理员简介 | part0/ch03.md | 件管理、管理员、软件、件管、理员 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.2 | RPM 软件管理程序： rpm | part0/ch03.md | 件管理、软件、件管、程序 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.3 | YUM 线上升级机制 | part0/ch10.md | 线上、上升、升级、机制 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.4 | SRPM 的使用 ： rpmbuild （Optional｜ | part0/ch11.md | srpm |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 23.3 | 显卡驱动程序安装范例 | part0/ch01.md | 显卡驱动、显卡驱、卡驱动、显卡、卡驱、驱动 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.1 | 编译前的任务：认识核心与取得核心源代码 | part0/ch07.md | 编译、前的、任务、源代码、认识、核心 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.2 | 核心编译的前处理与核心功能遜ॢ | part0/ch14.md | 编译的、核心、编译、译的、的前、处理 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.3 | 核心的编译与安装 | part0/ch11.md | 的编译、编译与、与安装、核心、的编、编译 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.5 | 以最新核心版本编译 CentOS 7.x 的核心 | part0/ch02.md | 最新、核心、版本、本编、编译、的核心 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.1 | UNIX 和C 语言简史 | part0/ch01.md | 语言 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.2.2 | Linux 内核 | part0/ch01-checklist.md | 内核 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.3.3 | X/Open 公司和The Open Group | part0/ch01-exercises.md | open、group |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.3.4 | SUSv3 和POSIX.1-2001 | part0/ch09.md | susv3 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.3.7 | 实现标准 | part0/ch01-checklist.md | 标准 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.11 | 信号 | part0/ch01.md | 信号 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.12 | 线程 | part0/ch01-exercises.md | 线程 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.16 | 日期和时间 | part0/ch03.md | 日期、时间 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.2 | shell | part0/ch01-checklist.md | shell |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.6 | 程序 | part0/ch01-exercises.md | 程序 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.7 | 进程 | part0/ch01-exercises.md | 进程 |
| weak | K · Kerrisk 系统编程手册 | 3 | 3.5 | 关于本书示例程序的注意事项 | part1/ch13.md | 关于本书、关于本、于本书、关于、于本、本书 |
| weak | K · Kerrisk 系统编程手册 | 3 | 3.5.1 | 命令行选项及参数 | part0/ch01.md | 命令行、命令、令行、选项、参数 |
| weak | K · Kerrisk 系统编程手册 | 4 | 4.8 | 通用I/O 模型以外的操作：ioctl() | part0/ch01.md | i/o、ioctl、通用、的操作、模型、外的 |
| weak | K · Kerrisk 系统编程手册 | 5 | 5.1 | 原子操作和竞争条件 | part0/ch08.md | 原子操作、原子操、子操作、原子、子操、竞争 |
| weak | K · Kerrisk 系统编程手册 | 5 | 5.6 | 在文件特定偏移量处的I/O：pread()和pwrite() | part2/ch02.md | i/o、pread、pwrite、在文件、定偏移、在文 |
| weak | K · Kerrisk 系统编程手册 | 5 | 5.7 | 分散输入和集中输出（Scatter-Gather I/O）：readv()和writev() | part1/ch01.md | i/o、writev、分散、输入、集中、输出 |
| weak | K · Kerrisk 系统编程手册 | 7 | 7.1.4 | 在堆上分配内存的其他方法 | part3/ch06.md | 分配内存、上分配、分配内、配内存、内存的、上分 |
| weak | K · Kerrisk 系统编程手册 | 8 | 8.1 | 密码文件：/etc/passwd | part0/ch02-exercises.md | etc/passwd、密码、文件 |
| weak | K · Kerrisk 系统编程手册 | 8 | 8.5 | 密码加密和用户认证 | part0/ch13.md | 用户认证、用户认、户认证、密码、加密、用户 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.7 | 获取和修改进程凭证 | part0/ch04.md | 进程凭证、进程凭、程凭证、修改、进程、程凭 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.7.1 | 获取和修改实际、有效和保存设置标识 | part2/ch10.md | 修改、实际、设置标、有效、保存、设置 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.7.3 | 获取和修改辅助组ID | part2/ch05.md | 辅助组、修改、辅助、助组 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.2.1 | 将time_t 转换为可打印格式 | part1/ch01.md | 可打印、转换、为可、可打、打印、格式 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.3 | 时区 | part0/ch01.md | 时区 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.6 | 软件时钟（jiffies） | part3/ch13.md | jiffies、软件、件时 |
| weak | K · Kerrisk 系统编程手册 | 12 | 12.2 | 系统标识：uname() | part0/ch10.md | uname、系统、标识 |
| weak | K · Kerrisk 系统编程手册 | 13 | 13.4 | I/O 缓冲小结 | part0/ch01.md | i/o、缓冲 |
| weak | K · Kerrisk 系统编程手册 | 13 | 13.5 | 就I/O 模式向内核提出建议 | part0/ch01.md | i/o、向内核、内核提、模式、向内、内核 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.4 | i 节点 | part0/ch01.md | 节点 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.9.2 | 多次挂载同一挂载点 | part0/ch03-errata.md | 同一挂载、同一挂、一挂载、挂载、同一、一挂 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.9.3 | 基于每次挂载的挂载标志 | part0/ch03.md | 次挂载、挂载的、的挂载、每次、次挂、挂载 |
| weak | K · Kerrisk 系统编程手册 | 17 | 17.3 | ACL 的长、短文本格式 | part0/ch03.md | acl、的长、文本、格式 |
| weak | K · Kerrisk 系统编程手册 | 17 | 17.7 | ACL 在实现方面的限制 | part0/ch09.md | acl、的限制、在实、面的、的限、限制 |
| weak | K · Kerrisk 系统编程手册 | 18 | 18.3 | 创建和移除（硬）链接：link()和 unlink() | part0/ch04.md | link、unlink、创建、移除、链接 |
| weak | K · Kerrisk 系统编程手册 | 18 | 18.6 | 创建和移除目录：mkdir()和rmdir() | part2/ch06.md | mkdir、rmdir、除目录、创建、移除、除目 |
| weak | K · Kerrisk 系统编程手册 | 19 | 19.6 | 监控文件的旧有系统：dnotify | part1/ch09.md | 文件的、有系统、监控、文件、件的、的旧 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.1 | 概念和概述 | part0/ch01-exercises.md | 概念 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.12 | 不对信号进行排队处理 | part2/ch10.md | 对信号、信号进、对信、信号、号进、进行 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.14 | 等待信号：pause() | part1/ch08-overview.md | pause、等待、信号 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.8 | 显示信号描述 | part1/ch01.md | 号描述、显示、信号、号描、描述 |
| weak | K · Kerrisk 系统编程手册 | 21 | 21.1.1 | 再论信号的非队列化处理 | part1/ch08.md | 信号的、信号、号的、的非、队列、处理 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.1 | 核心转储文件 | part1/ch02.md | 核心、转储、文件 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.10 | 以同步方式等待信号 | part2/ch12.md | 同步方式、同步方、步方式、同步、步方、等待 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.2 | 传递、处置及处理的特殊情况 | part0/ch04.md | 传递、处理的、的特殊、处理、理的、的特 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.5 | 信号的同步生成和异步生成 | part2/ch14.md | 的同步、和异步、信号、号的、的同、同步 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.9 | 使用掩码来等待信号：sigsuspend() | part1/ch08-checklist.md | sigsuspend、掩码、等待、信号 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.2 | 定时器的调度及精度 | part2/ch11.md | 定时器的、定时器、时器的、定时、时器、器的 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.3 | 为阻塞操作设置超时 | part1/ch11.md | 阻塞操作、阻塞操、塞操作、阻塞、塞操、设置 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.4.1 | 低分辨率休眠：sleep() | part2/ch11.md | sleep、分辨率、分辨、辨率、休眠 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.4.2 | 高分辨率休眠：nanosleep() | part2/ch11.md | nanosleep、分辨率、分辨、辨率、休眠 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.5.3 | 获取特定进程或线程的时钟ID | part2/ch07.md | 程或线程、定进程、程或线、或线程、定进、进程 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6 | POSIX 间隔式定时器 | part0/ch01.md | posix、定时器、间隔、定时、时器 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6.5 | 通过信号发出通知 | part0/ch09.md | 信号发、出通知、通过、信号、号发、发出 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6.7 | 通过线程来通知 | part0/ch09.md | 通过、线程、程来、通知 |
| weak | K · Kerrisk 系统编程手册 | 24 | 24.5 | 同步信号以规避竞争条件 | part1/ch19.md | 竞争条件、竞争条、争条件、同步、信号、以规 |
| weak | K · Kerrisk 系统编程手册 | 26 | 26.1 | 等待子进程 | part0/ch02-exercises.md | 子进程、等待、子进、进程 |
| weak | K · Kerrisk 系统编程手册 | 27 | 27.2.2 | 将程序参数指定为列表 | part0/ch12.md | 参数指定、参数指、数指定、程序、参数、数指 |
| weak | K · Kerrisk 系统编程手册 | 28 | 28.2.2 | 因克隆生成的子进程而对waitpid()进行的扩展 | part0/ch08.md | 的子进程、的子进、子进程、进程而、生成、成的 |
| weak | K · Kerrisk 系统编程手册 | 29 | 29.2 | Pthreads API 的详细背景 | part3/ch08.md | api、的详细、的详、详细 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.1.2 | 加锁和解锁互斥量 | part2/ch13.md | 互斥量、加锁、锁和、解锁、互斥、斥量 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.1.3 | 互斥量的性能 | part2/ch13.md | 互斥量、互斥、斥量、量的、性能 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.1.7 | 互斥量类型 | part2/ch13.md | 互斥量、互斥、斥量、类型 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.2.4 | 示例程序：连接任意已终止线程 | part2/ch12.md | 程序、终止线程、终止线、止线程、连接、任意 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3 | 线程特有数据 | part2/ch17.md | 有数据、线程、特有、有数、数据 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.2 | 线程特有数据API 概述 | part2/ch17.md | api、有数据、线程、特有、有数、数据 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.3 | 线程特有数据API 详述 | part2/ch12.md | api、有数据、线程、有数、数据、详述 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.5 | 线程特有数据的实现限制 | part1/ch12.md | 有数据、数据的、的实现、线程、有数、数据 |
| weak | K · Kerrisk 系统编程手册 | 32 | 32.4 | 线程可取消性的检测 | part2/ch13.md | 线程可、的检测、线程、程可、取消、的检 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.2.1 | UNIX 信号模型如何映射到线程中 | part1/ch09.md | 何映射、映射到、信号、何映、映射、射到 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.4 | 线程实现模型 | part3/ch05.md | 程实现、线程、程实、模型 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.5.1 | LinuxThreads | part2/ch15.md | linuxthreads |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.5.2 | NPTL | part1/ch08-errata.md | nptl |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.5.3 | 哪一种线程实现 | part0/ch04.md | 哪一种、哪一、一种、线程、程实 |
| weak | K · Kerrisk 系统编程手册 | 34 | 34.3 | 会话 | part0/ch02-checklist.md | 会话 |
| weak | K · Kerrisk 系统编程手册 | 35 | 35.3.2 | 修改和获取策略和优先级 | part0/ch01.md | 策略和、优先级、修改、策略、略和、优先 |
| weak | K · Kerrisk 系统编程手册 | 36 | 36.3 | 特定资源限制细节 | part0/ch01.md | 资源限制、资源限、源限制、特定、资源、源限 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.3 | 编写daemon 指南 | part0/ch02.md | 指南 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.4 | 使用SIGHUP 重新初始化一个daemon | part0/ch08.md | sighup、daemon、初始化、重新、初始、始化 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.5 | 使用syslog 记录消息和错误 | part2/ch01.md | 和错误、记录、消息、和错、错误 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.5.3 | /etc/syslog.conf 文件 | part0/ch01-errata.md | 文件 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.10 | 小心拒绝服务攻击 | part0/ch06.md | 拒绝服务、拒绝服、绝服务、小心、拒绝、绝服 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.2 | 以最小权限操作 | part0/ch04-exercises.md | 最小权限、最小权、小权限、最小、小权、权限 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.4 | 避免暴露敏感信息 | part0/ch04.md | 避免、暴露、敏感、信息 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.8 | 不要完全相信输入和环境 | part0/ch07.md | 完全相、和环境、不要、要完、完全、全相 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.1 | 能力基本原理 | part1/ch13.md | 能力、基本、本原 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.10 | 不具备文件能力的老式内核和系统 | part0/ch04.md | 文件能力、件能力的、文件能、件能力、能力的、文件 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.2 | Linux 能力 | part0/ch01-exercises.md | 能力 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.3 | 进程许可和有效能力集的目的 | part0/ch04.md | 有效能力、和有效、有效能、效能力、能力集、进程 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.4 | 文件许可和有效能力集的目的 | part0/ch04.md | 有效能力、和有效、有效能、效能力、能力集、文件 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.6 | 在shell 中给文件赋予能力和查看文件能力 | part0/ch04.md | shell、文件能力、给文件、看文件、文件能、件能力 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.4 | 现代能力实现 | part0/ch01.md | 现代、能力 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.5 | 在exec()中转变进程能力 | part2/ch09.md | exec、变进程、进程能、变进、进程、程能 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.6 | 改变用户ID 对进程能力的影响 | part2/ch09.md | 改变、用户、进程能、能力的、进程、程能 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.7 | 用编程的方式改变进程能力 | part2/ch09.md | 改变进程、改变进、变进程、进程能、用编、编程 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.8 | 创建仅包含能力的环境 | part0/ch04.md | 能力的、的环境、创建、包含、能力、力的 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.9 | 发现程序所需的能力 | part1/ch01.md | 所需的、的能力、发现、程序、所需、需的 |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.2 | utmpx API | part0/ch02.md | api |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.3 | utmpx 结构 | part0/ch12.md | utmpx |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.4 | 从utmp 和wtmp 文件中检索信息 | part0/ch12.md | utmp、wtmp、文件、信息 |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.5 | 获取登录名称：getlogin() | part0/ch04.md | 登录名、登录、录名、名称 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.3 | 共享库概述 | part0/ch01.md | 共享库、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.4 | 创建和使用共享库——首回合 | part1/ch13.md | 用共享、共享库、创建、用共、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.4.2 | 位置独立的代码 | part0/ch01.md | 独立的、的代码、位置、独立、立的、的代 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.5 | 使用共享库的有用工具 | part1/ch07.md | 共享库的、共享库、享库的、用工具、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.6 | 共享库版本和命名规则 | part1/ch01.md | 共享库、库版本、共享、享库、库版、版本 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.7 | 安装共享库 | part0/ch01.md | 共享库、安装、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.8 | 兼容与不兼容库比较 | part0/ch11-exercises.md | 不兼容、兼容库、兼容、不兼、容库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.9 | 升级共享库 | part0/ch01.md | 共享库、升级、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.1.2 | 错误诊断：dlerror() | part0/ch01-checklist.md | 错误、诊断 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.1.4 | 关闭共享库：dlclose() | part1/ch07-recall.md | dlclose、共享库、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.1.5 | 获取与加载的符号相关的信息：dladdr() | part1/ch01.md | 与加载、加载的、的符号、的信息、取与、与加 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.5 | 预加载共享库 | part1/ch01-exercises.md | 预加载、共享库、预加、加载、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 43 | 43.2 | 通信工具 | part0/ch03.md | 通信、工具 |
| weak | K · Kerrisk 系统编程手册 | 43 | 43.4 | IPC 工具比较 | part0/ch10.md | ipc、工具、比较 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.2 | 创建和使用管道 | part0/ch05.md | 用管道、创建、用管、管道 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.3 | 将管道作为一种进程同步的方法 | part2/ch13.md | 进程同步、进程同、程同步、同步的、管道、作为 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.5 | 通过管道与shell 命令进行通信：popen() | part2/ch08.md | shell、popen、通过管道、通过管、过管道、通过 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.7 | FIFO | part0/ch03-checklist.md | fifo |
| weak | K · Kerrisk 系统编程手册 | 45 | 45.4 | IPC 标识符和客户端/服务器应用程序 | part2/ch17.md | ipc、客户端、标识、客户、户端、服务器 |
| weak | K · Kerrisk 系统编程手册 | 45 | 45.7 | 获取所有IPC 对象列表 | part0/ch14.md | ipc、所有、对象、列表 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.2.1 | 发送消息 | part0/ch09.md | 发送、消息 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.2.2 | 接收消息 | part0/ch09.md | 接收、消息 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.3 | 消息队列控制操作 | part0/ch09.md | 消息队列、消息队、息队列、消息、息队、队列 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.7 | 使用消息队列实现客户端-服务器应用程序 | part1/ch11.md | 消息队列、消息队、息队列、客户端、消息、息队 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.10 | 信号量限制 | part1/ch12-summary.md | 信号量、信号、号量、限制 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.5 | 信号量初始化 | part1/ch12-exercises.md | 信号量、初始化、信号、号量、初始、始化 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.6 | 信号量操作 | part0/ch02.md | 量操作、信号、量操 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.8 | 信号量撤销值 | part1/ch19.md | 信号量、信号、号量、撤销 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.4.3 | 边界情况 | part0/ch01-checklist.md | 边界 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.4.4 | 内存保护和文件访问模式交互 | part0/ch03.md | 访问模式、和文件、访问模、问模式、内存、保护 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.5 | 同步映射区域：msync() | part1/ch09.md | msync、映射区、同步、映射、射区、区域 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.9 | MAP_NORESERVE 和过度利用交换空间 | part2/ch03.md | map_noreserve、交换空间、交换空、换空间、交换、换空 |
| weak | K · Kerrisk 系统编程手册 | 50 | 50.3 | 确定内存驻留性：mincore() | part1/ch09-checklist.md | mincore、确定、内存、驻留 |
| weak | K · Kerrisk 系统编程手册 | 50 | 50.4 | 建议后续的内存使用模式：madvise() | part0/ch02.md | 后续的、的内存、用模式、后续、续的、的内 |
| weak | K · Kerrisk 系统编程手册 | 51 | 51.1 | API 概述 | part0/ch02.md | api |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.2 | 打开、关闭和断开链接消息队列 | part2/ch13.md | 打开、消息队列、消息队、息队列、关闭、链接 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.5.1 | 发送消息 | part0/ch09.md | 发送、消息 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.5.2 | 接收消息 | part0/ch09.md | 接收、消息 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.5.3 | 在发送和接收消息时设置超时时间 | part2/ch14.md | 超时时间、超时时、时时间、发送、接收、消息 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.6 | 消息通知 | part0/ch08.md | 消息、通知 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.6.1 | 通过信号接收通知 | part0/ch09.md | 信号接收、信号接、号接收、通过、信号、号接 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.6.2 | 通过线程接收通知 | part1/ch08.md | 通过、线程、程接、接收、通知 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.7 | Linux 特有的特性 | part1/ch01.md | 特有的、特有、有的、的特 |
| weak | K · Kerrisk 系统编程手册 | 53 | 53.3 | 信号量操作 | part0/ch02.md | 量操作、信号、量操 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3 | 使用fcntl()给记录加锁 | part0/ch08.md | fcntl、记录、加锁 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.1 | 死锁 | part0/ch05.md | 死锁 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.3 | 示例：一个加锁函数库 | part1/ch12-recall.md | 一个加锁、一个加、个加锁、个加、加锁、函数 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.4 | 锁的限制和性能 | part1/ch12.md | 的限制、锁的、的限、限制、制和、性能 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.5 | 锁继承和释放的语义 | part0/ch03.md | 释放的、的语义、继承、释放、放的、的语 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.6 | 锁定饿死和排队加锁请求的优先级 | part3/ch10.md | 的优先级、请求的、的优先、优先级、锁定、排队 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.4 | 强制加锁 | part0/ch03.md | 强制、制加 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.7 | 老式加锁技术 | part0/ch08.md | 式加、加锁 |
| weak | K · Kerrisk 系统编程手册 | 56 | 56.5 | 流socket | part0/ch01.md | socket |
| weak | K · Kerrisk 系统编程手册 | 56 | 56.5.1 | 监听接入连接：listen() | part0/ch13.md | listen、监听、接入、连接 |
| weak | K · Kerrisk 系统编程手册 | 56 | 56.5.3 | 连接到对等socket：connect() | part0/ch03.md | socket、connect、连接、接到 |
| weak | K · Kerrisk 系统编程手册 | 57 | 57.5 | 创建互联socket 对：socketpair() | part1/ch17.md | socket、socketpair、创建 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.1 | 互联网 | part0/ch13.md | 联网 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.2 | 联网协议和层 | part1/ch02.md | 协议和、协议、议和 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.5 | IP 地址 | part0/ch01-exercises.md | 地址 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.6.3 | 传输控制协议（TCP） | part1/ch11.md | tcp、制协议、传输、控制、制协、协议 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.7 | 请求注解（RFC） | part1/ch11.md | rfc、请求 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.10 | 独立于协议的主机和服务转换 | part1/ch11.md | 协议的、和服务、独立、协议、议的、的主 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.10.3 | 错误诊断：gai_strerror() | part1/ch11.md | gai_strerror、错误 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.13 | 过时的主机和服务转换API | part0/ch04.md | api、和服务、过时、时的、的主、主机 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.13.2 | gethostbyname()和gethostbyaddr()函数 | part0/ch01-overview.md | 函数 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.13.3 | getserverbyname()和getserverbyport()函数 | part0/ch01-overview.md | 函数 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.5 | 主机和服务转换函数概述 | part1/ch11.md | 和服务、主机、和服、服务、转换、函数 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.8 | 域名系统（DNS） | part0/ch13.md | dns、域名、系统 |
| weak | K · Kerrisk 系统编程手册 | 60 | 60.1 | 迭代型和并发型服务器 | part1/ch17.md | 和并发、服务器、型和、和并、并发、服务 |
| weak | K · Kerrisk 系统编程手册 | 60 | 60.4 | 并发型服务器的其他设计方案 | part1/ch11.md | 服务器的、服务器、务器的、并发、服务、务器 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.1 | 流式套接字上的部分读和部分写 | part2/ch16.md | 套接字、的部分、部分读、套接、接字、上的 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.11 | 在accept()中继承标记和选项 | part0/ch10.md | 继承标、继承、承标、标记、选项 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.12 | TCP vs.UDP | part0/ch01-exercises.md | tcp |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13 | 高级功能 | part0/ch02-overview.md | 高级 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13.4 | 接收发送端的凭据 | part1/ch01.md | 发送端、接收、收发、发送、送端、端的 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13.5 | 顺序数据包套接字 | part0/ch04.md | 套接字、顺序、数据、套接、接字 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.5 | 获取套接字地址 | part1/ch11.md | 套接字、字地址、套接、接字、字地、地址 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.2 | TCP 序列号和确认机制 | part3/ch12.md | tcp、序列号、序列、列号、确认、机制 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.3 | TCP 协议状态机以及状态迁移图 | part1/ch11.md | tcp、状态迁移、状态机、状态迁、态迁移、协议 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.6 | 在TCP 套接字上调用shutdown() | part0/ch12.md | tcp、shutdown、套接字、套接、接字、调用 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.7 | 监视套接字：netstat | part0/ch04-exercises.md | 套接字、套接、接字 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.1 | 整体概览 | part0/ch01.md | 整体、概览 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.2 | 获取和修改终端属性 | part0/ch02.md | 终端属性、终端属、端属性、修改、终端、端属 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.7 | 终端线速（比特率） | part2/ch19.md | 终端、线速、特率 |
| weak | K · Kerrisk 系统编程手册 | 63 | 63.1 | 整体概览 | part0/ch01.md | 整体、概览 |
| weak | K · Kerrisk 系统编程手册 | 63 | 63.1.2 | 在备选的I/O 模型中采用非阻塞I/O | part2/ch18.md | i/o、备选的、备选、选的、用非阻塞、用非阻 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.1 | 整体概览 | part0/ch01.md | 整体、概览 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.2 | 修改从设备属主和权限：grantpt() | part0/ch03.md | 属主和、修改、设备、属主、主和、权限 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.3 | 解锁从设备：unlockpt() | part0/ch02.md | 从设备、从设、设备 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.4 | 获取从设备名称：ptsname() | part0/ch02.md | 从设备、设备名、从设、设备、备名 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.3 | 打开主设备：ptyMasterOpen() | part0/ch03.md | 主设备、打开、主设、设备 |
| weak | L · 操作系统原理、实现与实践 | 1 | 1 | 系统启动——打开电源以后发生的故事 | part1/ch01.md | 系统启动、系统启、统启动、系统、统启、启动 |
| weak | L · 操作系统原理、实现与实践 | 7 | 7 | 换入/换出——用磁盘和时间换取一个规整虚拟内存 | part1/ch09.md | 换入、换出、虚拟内存、用磁盘、磁盘和、虚拟内 |
| weak | N · 深入理解 Linux 网络 | 1 | 1.4 | ⼀些术语 | part2/ch10.md | 术语 |
| weak | N · 深入理解 Linux 网络 | 4 | 4.2 | ⽹络包发送过程总览 | part4/ch02.md | 发送过程、发送过、送过程、包发、发送、送过 |
| weak | N · 深入理解 Linux 网络 | 4 | 4.3 | ⽹卡启动准备 | part4/ch09.md | 卡启动、卡启、启动、准备 |
| weak | N · 深入理解 Linux 网络 | 8 | 8.3.1 | ⼀次关于服务端并发的聊天 | part4/ch10.md | 服务端、端并发、并发的、服务、务端、端并 |
| weak | N · 深入理解 Linux 网络 | 8 | 8.5 | 单机百万并发连接的动⼿实验 | part2/ch16.md | 并发连接、并发连、发连接、连接的、并发、发连 |
| weak | N · 深入理解 Linux 网络 | 9 | 9.5 | 握⼿挥⼿过程优化 | part2/ch01.md | 过程、优化 |
| weak | O · OSTEP | 2 | 2.3 | 并发 | part1/ch01-errata.md | 并发 |
| weak | O · OSTEP | 5 | 5.5 | 其他 API | part1/ch01.md | api |
| weak | O · OSTEP | 6 | 6.2 | 问题 1：受限制的操作 | part3/ch13.md | 限制的、的操作、限制、制的、的操 |
| weak | O · OSTEP | 6 | 6.4 | 担心并发吗 | part1/ch01-errata.md | 并发 |
| weak | O · OSTEP | 7 | 7.7 | 轮转 | part1/ch09.md | 轮转 |
| weak | O · OSTEP | 8 | 8.1 | MLFQ：基本规则 | part1/ch13.md | mlfq、基本、规则 |
| weak | O · OSTEP | 8 | 8.2 | 尝试 1：如何改变优先级 | part1/ch16.md | 如何改变、如何改、何改变、何改、改变、优先 |
| weak | O · OSTEP | 8 | 8.4 | 尝试 3：更好的计时方式 | part1/ch04.md | 更好的、的计时、更好、好的、的计、计时 |
| weak | O · OSTEP | 8 | 8.5 | MLFQ 调优及其他问题 | part3/ch05.md | mlfq、调优 |
| weak | O · OSTEP | 8 | 8.6 | MLFQ：小结 | part1/ch13-checklist.md | mlfq |
| weak | O · OSTEP | 9 | 9.1 | 基本概念：彩票数表示份额 | part1/ch01.md | 基本概念、基本概、本概念、基本、本概、概念 |
| weak | O · OSTEP | 9 | 9.2 | 彩票机制 | part1/ch13-checklist.md | 彩票、机制 |
| weak | O · OSTEP | 9 | 9.5 | 如何分配彩票 | part1/ch13-checklist.md | 分配、彩票 |
| weak | O · OSTEP | 10 | 10.2 | 别忘了同步 | part1/ch10.md | 忘了、了同、同步 |
| weak | O · OSTEP | 13 | 13.1 | 早期系统 | part1/ch02.md | 早期、系统 |
| weak | O · OSTEP | 13 | 13.2 | 多道程序和时分共享 | part1/ch19.md | 多道程序、多道程、道程序、多道、道程、程序 |
| weak | O · OSTEP | 13 | 13.4 | 目标 | part1/ch01-checklist.md | 目标 |
| weak | O · OSTEP | 14 | 14.5 | 底层操作系统支持 | part1/ch13.md | 操作系统、操作系、作系统、底层、作系、系统 |
| weak | O · OSTEP | 14 | 14.6 | 其他调用 | part1/ch01-checklist.md | 调用 |
| weak | O · OSTEP | 15 | 15.1 | 假设 | part1/ch01-exercises.md | 假设 |
| weak | O · OSTEP | 16 | 16.2 | 我们引用哪个段 | part1/ch01.md | 用哪个、我们、引用、用哪、哪个、个段 |
| weak | O · OSTEP | 16 | 16.4 | 支持共享 | part1/ch01.md | 支持、共享 |
| weak | O · OSTEP | 16 | 16.5 | 细粒度与粗粒度的分段 | part1/ch09.md | 细粒度、粒度与、细粒、粒度、度与、度的 |
| weak | O · OSTEP | 17 | 17.1 | 假设 | part1/ch01-exercises.md | 假设 |
| weak | O · OSTEP | 18 | 18.3 | 列表中究竟有什么 | part1/ch01.md | 有什么、列表、究竟、有什 |
| weak | O · OSTEP | 18 | 18.5 | 内存追踪 | part1/ch01.md | 内存、追踪 |
| weak | O · OSTEP | 20 | 20.1 | 简单的解决方案：更大的页 | part1/ch09.md | 简单的、简单、单的、的解、解决、更大的 |
| weak | O · OSTEP | 20 | 20.2 | 混合方法：分页和分段 | part1/ch09.md | 混合、分页、页和、和分、分段 |
| weak | O · OSTEP | 20 | 20.4 | 反向页表 | part1/ch01.md | 反向、页表 |
| weak | O · OSTEP | 20 | 20.5 | 将页表交换到磁盘 | part1/ch19.md | 页表交、到磁盘、页表、表交、交换、换到 |
| weak | O · OSTEP | 21 | 21.1 | 交换空间 | part1/ch01.md | 交换、空间 |
| weak | O · OSTEP | 21 | 21.6 | 交换何时真正发生 | part1/ch10-recall.md | 真正发生、真正发、正发生、真正、正发、发生 |
| weak | O · OSTEP | 22 | 22.11 | 抖动 | part1/ch01.md | 抖动 |
| weak | O · OSTEP | 22 | 22.3 | 简单策略：FIFO | part1/ch06-recall.md | fifo、简单、策略 |
| weak | O · OSTEP | 22 | 22.4 | 另一简单策略：随机 | part1/ch06.md | 另一、简单、策略、随机 |
| weak | O · OSTEP | 22 | 22.5 | 利用历史数据：LRU | part1/ch13.md | lru、用历史、利用、用历、数据 |
| weak | O · OSTEP | 22 | 22.7 | 实现基于历史信息的算法 | part1/ch01.md | 信息的、的算法、基于、信息、息的、的算 |
| weak | O · OSTEP | 22 | 22.9 | 考虑脏页 | part1/ch10.md | 考虑、脏页 |
| weak | O · OSTEP | 23 | 23.1 | 背景 | part1/ch01-overview.md | 背景 |
| weak | O · OSTEP | 27 | 27.2 | 线程完成 | part1/ch01-recall.md | 线程、完成 |
| weak | O · OSTEP | 28 | 28.1 | 锁的基本思想 | part1/ch08.md | 的基本、的基、基本 |
| weak | O · OSTEP | 28 | 28.10 | 链接的加载和条件式存储指令 | part1/ch01.md | 链接的、的加载、链接、接的、的加、加载 |
| weak | O · OSTEP | 28 | 28.11 | 获取并增加 | part3/ch13.md | 并增加、获取、并增、增加 |
| weak | O · OSTEP | 28 | 28.13 | 简单方法：让出来吧，宝贝 | part1/ch07.md | 简单、单方、出来 |
| weak | O · OSTEP | 28 | 28.14 | 使用队列：休眠替代自旋 | part1/ch08.md | 用队列、用队、队列、替代 |
| weak | O · OSTEP | 28 | 28.15 | 不同操作系统，不同实现 | part3/ch14.md | 不同、系统、不同实现、不同实、同实现、同实 |
| weak | O · OSTEP | 28 | 28.2 | Pthread 锁 | part1/ch01.md | pthread |
| weak | O · OSTEP | 28 | 28.4 | 评价锁 | part1/ch13.md | 评价 |
| weak | O · OSTEP | 28 | 28.5 | 控制中断 | part1/ch01-exercises.md | 控制、中断 |
| weak | O · OSTEP | 28 | 28.8 | 评价自旋锁 | part1/ch13.md | 自旋锁、评价、自旋、旋锁 |
| weak | O · OSTEP | 29 | 29.2 | 并发链表 | part1/ch01.md | 并发、链表 |
| weak | O · OSTEP | 29 | 29.3 | 并发队列 | part1/ch01.md | 并发、队列 |
| weak | O · OSTEP | 29 | 29.4 | 并发散列表 | part1/ch01.md | 并发、列表 |
| weak | O · OSTEP | 30 | 30.1 | 定义和程序 | part1/ch01.md | 和程序、定义、和程、程序 |
| weak | O · OSTEP | 31 | 31.7 | 如何实现信号量 | part1/ch12-checklist.md | 信号量、信号、号量 |
| weak | O · OSTEP | 32 | 32.1 | 有哪些类型的缺陷 | part1/ch07-errata.md | 哪些类型、哪些类、些类型、哪些、些类、类型 |
| weak | O · OSTEP | 32 | 32.2 | 非死锁缺陷 | part3/ch11.md | 死锁、缺陷 |
| weak | O · OSTEP | 32 | 32.3 | 死锁缺陷 | part3/ch11.md | 死锁、缺陷 |
| weak | O · OSTEP | 33 | 33.3 | 使用 select() | part1/ch08-exercises.md | select |
| weak | O · OSTEP | 33 | 33.4 | 为何更简单？无须锁 | part1/ch02.md | 更简单、更简、简单 |
| weak | O · OSTEP | 33 | 33.8 | 什么事情仍然很难 | part3/ch04.md | 仍然很、仍然、然很 |
| weak | O · OSTEP | 36 | 36.1 | 系统架构 | part1/ch01-checklist.md | 系统、架构 |
| weak | O · OSTEP | 36 | 36.3 | 标准协议 | part1/ch01.md | 标准、协议 |
| weak | O · OSTEP | 36 | 36.4 | 利用中断减少 CPU 开销 | part1/ch01-exercises.md | cpu、利用、中断、减少、开销 |
| weak | O · OSTEP | 36 | 36.5 | 利用 DMA 进行更高效的数据 | part1/ch01.md | dma、利用、的数据、进行、更高、的数 |
| weak | O · OSTEP | 36 | 36.6 | 设备交互的方法 | part1/ch13.md | 的方法、设备、交互、的方 |
| weak | O · OSTEP | 36 | 36.9 | 历史记录 | part1/ch01.md | 记录 |
| weak | O · OSTEP | 37 | 37.1 | 接口 | part1/ch01.md | 接口 |
| weak | O · OSTEP | 37 | 37.2 | 基本几何形状 | part1/ch06-exercises.md | 基本、几何、形状 |
| weak | O · OSTEP | 37 | 37.5 | 磁盘调度 | part1/ch01.md | 磁盘、调度 |
| weak | O · OSTEP | 38 | 38.3 | 如何评估 RAID | part1/ch13.md | raid、评估 |
| weak | O · OSTEP | 38 | 38.6 | RAID 4 级：用校验节省空间 | part1/ch13-recall.md | raid、用校验、用校、校验、空间 |
| weak | O · OSTEP | 38 | 38.7 | RAID 5 级：旋转奇偶校验 | part1/ch13-exercises.md | raid、旋转、校验 |
| weak | O · OSTEP | 38 | 38.9 | 其他有趣的 RAID 问题 | part1/ch13-checklist.md | raid |
| weak | O · OSTEP | 39 | 39.5 | 读取和写入，但不按顺序 | part1/ch08.md | 读取、不按顺序、不按顺、按顺序、但不、不按 |
| weak | O · OSTEP | 39 | 39.6 | 用 fsync()立即写入 | part1/ch01.md | fsync、立即、写入 |
| weak | O · OSTEP | 39 | 39.7 | 文件重命名 | part1/ch03.md | 重命名、文件、重命、命名 |
| weak | O · OSTEP | 40 | 40.1 | 思考方式 | part1/ch01.md | 思考 |
| weak | O · OSTEP | 40 | 40.2 | 整体组织 | part1/ch01.md | 整体、组织 |
| weak | O · OSTEP | 40 | 40.3 | 文件组织：inode | part1/ch01.md | inode、文件、组织 |
| weak | O · OSTEP | 40 | 40.4 | 目录组织 | part1/ch01.md | 目录、组织 |
| weak | O · OSTEP | 40 | 40.6 | 访问路径：读取和写入 | part1/ch06.md | 访问、路径、和写入、和写、写入 |
| weak | O · OSTEP | 41 | 41.2 | FFS：磁盘意识是解决方案 | part1/ch01.md | ffs、磁盘、是解、解决、方案 |
| weak | O · OSTEP | 41 | 41.5 | 测量文件的局部性 | part1/ch01.md | 文件的、局部性、测量、文件、件的、局部 |
| weak | O · OSTEP | 42 | 42.1 | 一个详细的例子 | part1/ch01.md | 的例子、细的、的例 |
| weak | O · OSTEP | 42 | 42.4 | 解决方案 3：其他方法 | part1/ch01.md | 解决、方案 |
| weak | O · OSTEP | 43 | 43.10 | 确定块的死活 | part1/ch06-recall.md | 确定块、确定、定块、块的 |
| weak | O · OSTEP | 43 | 43.11 | 策略问题：要清理哪些块， | part1/ch12.md | 策略问题、策略问、略问题、策略、略问、哪些 |
| weak | O · OSTEP | 43 | 43.2 | 顺序而高效地写入 | part1/ch19.md | 顺序而、顺序、序而、写入 |
| weak | O · OSTEP | 43 | 43.3 | 要缓冲多少 | part1/ch11-recall.md | 要缓冲、要缓、缓冲、多少 |
| weak | O · OSTEP | 43 | 43.5 | 通过间接解决方案：inode 映射 | part1/ch13.md | inode、通过、间接、接解、解决、方案 |
| weak | O · OSTEP | 43 | 43.6 | 检查点区域 | part1/ch09.md | 检查点、检查、查点、区域 |
| weak | O · OSTEP | 43 | 43.8 | 目录如何 | part1/ch18.md | 目录、录如 |
| weak | O · OSTEP | 44 | 44.5 | 一个新问题：错误的写入 | part1/ch01.md | 一个新、个新、错误的、错误、误的、的写 |
| weak | O · OSTEP | 44 | 44.7 | 擦净 | part3/ch12.md | 擦净 |
| weak | O · OSTEP | 47 | 47.1 | 通信基础 | part1/ch01.md | 通信 |
| weak | O · OSTEP | 47 | 47.2 | 不可靠的通信层 | part1/ch01.md | 可靠的、不可、可靠、靠的、的通、通信 |
| weak | O · OSTEP | 47 | 47.3 | 可靠的通信层 | part1/ch01.md | 可靠的、可靠、靠的、的通、通信 |
| weak | O · OSTEP | 47 | 47.4 | 通信抽象 | part1/ch01.md | 通信、抽象 |
| weak | O · OSTEP | 48 | 48.11 | 服务器端写缓冲的隐含意义 | part1/ch11.md | 服务器端、服务器、务器端、写缓冲、服务、务器 |
| weak | O · OSTEP | 48 | 48.3 | 关注点：简单快速的服务器崩溃 | part1/ch12.md | 的服务器、的服务、服务器、简单、快速、的服 |
| weak | O · OSTEP | 48 | 48.5 | NFSv2 协议 | part1/ch01.md | 协议 |
| weak | O · OSTEP | 48 | 48.7 | 利用幂等操作处理服务器故障 | part1/ch12.md | 处理服务、处理服、理服务、服务器、利用、处理 |
| weak | O · OSTEP | 49 | 49.3 | 改进协议 | part1/ch01.md | 协议 |
| weak | O · OSTEP | 49 | 49.8 | AFS：其他改进 | part1/ch13.md | afs |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.17 | KSM | part1/ch09-errata.md | ksm |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.6 | vmalloc | part1/ch09.md | vmalloc |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.7 | VMA操作 | part1/ch08-recall.md | vma |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.8 | malloc | part1/ch01.md | malloc |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.9 | mmap | part1/ch01-recall.md | mmap |
| weak | R · 奔跑吧 Linux 内核 | 4 | 4.2 | spinlock | part1/ch13.md | spinlock |
| weak | R · 奔跑吧 Linux 内核 | 4 | 4.6 | RCU | part1/ch06-overview.md | rcu |
| weak | R · 奔跑吧 Linux 内核 | 6 | 6.2 | ftrace | part3/ch01.md | ftrace |
| weak | R · 奔跑吧 Linux 内核 | 6 | 6.3 | SystemTap | part3/ch01.md | systemtap |
| weak | S · Linux 命令行大全 | 2 | 2 | 导航 | part0/ch01-overview.md | 导航 |
| weak | S · Linux 命令行大全 | 5 | 5 | 和命令打交道 | part0/ch02.md | 和命令、打交道、和命、命令、打交、交道 |
| weak | S · Linux 命令行大全 | 9 | 9 | 权限 | part0/ch01-errata.md | 权限 |
| weak | S · Linux 命令行大全 | 10 | 10 | 进程 | part0/ch01-exercises.md | 进程 |
| weak | S · Linux 命令行大全 | 11 | 11 | 环境 | part0/ch01-errata.md | 环境 |
| weak | S · Linux 命令行大全 | 16 | 16 | 联网 | part0/ch13.md | 联网 |
| weak | S · Linux 命令行大全 | 22 | 22 | 打印 | part0/ch01-exercises.md | 打印 |
| weak | S · Linux 命令行大全 | 26 | 26 | 自顶向下设计 | part0/ch03.md | 向下、设计 |
| weak | S · Linux 命令行大全 | 28 | 28 | 读取键盘输入 | part0/ch07.md | 读取、取键、键盘、输入 |
| weak | S · Linux 命令行大全 | 35 | 35 | 数组 | part0/ch03.md | 数组 |
