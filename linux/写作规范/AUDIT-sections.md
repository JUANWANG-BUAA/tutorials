# 节级覆盖审计（机械筛子）

> 由 `tools/audit_sections.py` 生成。`zero` 表示标题里的高信息量词在限定篇目正文中一个都没找到；`weak` 表示只命中一个词或命中率 < 34%。这两类必须人工复核：可能真的漏了，也可能只是换了说法。

共 1723 个节级条目，`zero` 7、`weak` 716、`ok` 1000。

## 需要复核的条目

| 状态 | 母本 | 章 | 节 | 标题 | 最佳落点 | 命中词 |
|:--|:--|:--|:--|:--|:--|:--|
| zero | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.8.4 | 使用库 | None | — |
| zero | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.1 | 加倍行间距 | None | — |
| zero | C · CSAPP 3e | 3 | 3.1 | 历史观点 | None | — |
| zero | G · 鸟哥的 Linux 私房菜 | 9 | 9.2 | vi 的使用 | None | — |
| zero | G · 鸟哥的 Linux 私房菜 | 12 | 13.2 | 帐号管理 | None | — |
| zero | K · Kerrisk 系统编程手册 | 1 | 1.2 | Linux 简史 | None | — |
| zero | O · OSTEP | 17 | 17.4 | 其他方式 | None | — |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 1 | 1.1 | Linux初探 | part0/ch14.md | 初探 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 1 | 1.1.1 | 深入探究Linux内核 | part0/ch01.md | 内核 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 1 | 1.2.2 | 特定用途的Linux发行版 | part0/ch01.md | 用途、发行版、发行、行版 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.1.1 | 控制台终端 | part0/ch02.md | 控制台、控制、制台、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.1.2 | 图形化终端 | part0/ch01.md | 图形、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.2 | 通过Linux控制台终端访问CLI | part0/ch10.md | cli、通过、控制台、控制、制台、访问 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.3 | 通过图形化终端仿真器访问CLI | part0/ch03.md | cli、通过、终端、访问 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.4 | 使用GNOME Terminal终端仿真器 | part0/ch02.md | gnome、terminal、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.4.2 | 菜单栏 | part0/ch01.md | 菜单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.5 | 使用Konsole终端仿真器 | part0/ch01.md | 终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.5.1 | 访问Konsole终端仿真器 | part0/ch01.md | 访问、终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.5.2 | 菜单栏 | part0/ch01.md | 菜单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.6 | 使用xterm终端仿真器 | part0/ch01.md | 终端 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.6.1 | 访问xterm | part0/ch01.md | 访问 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 2 | 2.6.2 | 命令行选项 | part0/ch01.md | 命令行、命令、令行、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.3 | 与bash手册交互 | part0/ch02.md | bash、交互 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5 | 列出文件和目录 | part0/ch12.md | 和目录、列出、文件、件和、和目、目录 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5.1 | 显示基本列表 | part0/ch01.md | 显示、基本、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5.2 | 显示长列表 | part0/ch01.md | 显示、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.5.3 | 过滤输出列表 | part0/ch06.md | 输出列、过滤、输出、出列 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.6.3 | 使用命令行补全 | part0/ch01.md | 用命令、命令行、用命、命令、令行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.6.4 | 链接文件 | part0/ch02.md | 链接、接文、文件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.6.5 | 文件重命名 | part0/ch02.md | 重命名、文件、重命、命名 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.7 | 管理目录 | part0/ch01.md | 目录 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 3 | 3.8.3 | 查看部分文件 | part0/ch02.md | 查看、文件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.1 | 监测程序 | part0/ch10.md | 监测、程序 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.1.1 | 探查进程 | part0/ch01.md | 进程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.1.2 | 实时监测进程 | part0/ch09.md | 实时、进程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.2.1 | 挂载存储设备 | part0/ch01.md | 挂载、存储、设备 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.2.2 | 使用df命令 | part0/ch01.md | 命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.2.3 | 使用du命令 | part0/ch01.md | 命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3 | 处理数据文件 | part0/ch01.md | 处理、数据、文件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.1 | 数据排序 | part0/ch02.md | 数据、排序 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.2 | 数据搜索 | part0/ch01.md | 数据、搜索 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.3 | 数据压缩 | part0/ch01.md | 数据、压缩 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 4 | 4.3.4 | 数据归档 | part0/ch01.md | 数据、归档 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 5 | 5.2.1 | 查看进程列表 | part0/ch09.md | 看进程、看进、进程、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 5 | 5.2.2 | 别出心裁的子shell用法 | part0/ch03.md | shell、的子、用法 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 6 | 6.2.2 | 设置全局环境变量 | part0/ch04.md | 环境变量、环境变、境变量、设置、全局、环境 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 6 | 6.6 | 定位系统环境变量 | part0/ch02.md | 环境变量、环境变、境变量、定位、系统、环境 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 6 | 6.7 | 数组变量 | part0/ch03.md | 数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.1.3 | 添加新用户 | part0/ch01.md | 新用户、新用、用户 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.1.4 | 删除用户 | part0/ch11.md | 删除、除用、用户 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.2.3 | 修改组 | part0/ch01.md | 修改 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.3.1 | 使用文件权限符号 | part0/ch04.md | 文件权限、文件权、件权限、文件、件权、权限 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.4 | 更改安全设置 | part0/ch01.md | 安全、设置 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.4.2 | 改变所属关系 | part0/ch03.md | 改变、所属、关系 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.5 | 共享文件 | part0/ch01.md | 共享、文件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 7 | 7.6 | 访问控制列表 | part0/ch01.md | 访问、控制、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 8 | 8.3 | 逻辑卷管理 | part0/ch10.md | 逻辑卷、逻辑、辑卷 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 8 | 8.3.3 | 使用Linux LVM | part0/ch01.md | lvm |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.2.1 | 使用apt管理软件包 | part0/ch10.md | apt、软件包、软件、件包 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.2.3 | 使用apt升级软件 | part0/ch01.md | apt、升级、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.3.3 | 使用dnf升级软件 | part0/ch01.md | dnf、升级、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.3.4 | 使用dnf卸载软件 | part0/ch01.md | dnf、卸载、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 9 | 9.4 | 使用容器管理软件 | part0/ch01.md | 用容器、用容、容器、软件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.2 | vim基础 | part0/ch01.md | vim |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.3 | 编辑数据 | part0/ch01.md | 编辑、数据 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.4 | 复制和粘贴 | part0/ch12.md | 复制和、复制、制和 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.1.5 | 查找和替换 | part0/ch02.md | 查找、替换 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.3.2 | 在控制台中使用Emacs | part0/ch02.md | 控制台、控制、制台 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.3.3 | 在GUI中使用Emacs | part0/ch02.md | gui |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.4 | KDE系编辑器 | part0/ch02.md | 编辑器、编辑、辑器 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.5.1 | 启动gedit | part0/ch01.md | 启动 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.5.2 | gedit的基本功能 | part0/ch01.md | 的基本、的基、基本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 10 | 10.5.3 | 管理插件 | part0/ch01.md | 插件 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.3 | 显示消息 | part0/ch06.md | 显示、消息 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.5 | 重定向输入和输出 | part0/ch14.md | 重定向、和输出、重定、定向、和输、输出 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.6 | 管道 | part0/ch01.md | 管道 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.7 | 执行数学运算 | part0/ch03.md | 执行、行数、运算 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.7.2 | 使用方括号 | part0/ch09.md | 方括号、用方、方括、括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.7.3 | 浮点数解决方案 | part0/ch01.md | 浮点数、浮点、点数、解决 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.8 | 退出脚本 | part0/ch01.md | 退出、脚本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.8.1 | 查看退出状态码 | part0/ch08.md | 退出状态、退出状、出状态、退出、出状、状态 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 11 | 11.9 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.1 | 使用if-then语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.2 | if-then-else语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.4.1 | 数值比较 | part0/ch06.md | 数值、比较 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.4.3 | 文件比较 | part0/ch01.md | 文件、比较 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.5 | 复合条件测试 | part0/ch07.md | 件测试、条件、件测、测试 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.6.1 | 使用单括号 | part0/ch06.md | 用单、括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.6.2 | 使用双括号 | part0/ch02.md | 括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.6.3 | 使用双方括号 | part0/ch09.md | 方括号、方括、括号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 12 | 12.8 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1 | for命令 | part0/ch01.md | 命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.1 | 读取列表中的值 | part0/ch02.md | 读取、列表、中的 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.2 | 读取列表中的复杂值 | part0/ch07.md | 的复杂、读取、的复、复杂 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.3 | 从变量中读取值列表 | part0/ch08.md | 变量、读取、取值、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.4 | 从命令中读取值列表 | part0/ch02.md | 命令中、命令、令中、读取、列表 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.1.6 | 使用通配符读取目录 | part0/ch01.md | 通配符、通配、配符、读取、目录 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.2.2 | 使用多个变量 | part0/ch06.md | 用多个、用多、多个、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.3.2 | 使用多个测试命令 | part0/ch06.md | 用多个、用多、多个、测试、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.5 | 嵌套循环 | part0/ch06.md | 嵌套、循环 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.6 | 循环处理文件数据 | part0/ch08.md | 处理文件、处理文、理文件、循环、处理、理文 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.7 | 循环控制 | part0/ch02.md | 循环、控制 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.8 | 处理循环的输出 | part0/ch02.md | 的输出、处理、循环、的输、输出 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.9 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 13 | 13.9.2 | 创建多个用户账户 | part0/ch01.md | 个用户、创建、多个、个用、用户 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.1 | 传递参数 | part0/ch03.md | 传递、参数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.1.1 | 读取参数 | part0/ch01.md | 读取、参数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.1.2 | 读取脚本名 | part0/ch07.md | 脚本名、读取、脚本、本名 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.1.3 | 参数测试 | part0/ch01.md | 参数、测试 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.2 | 特殊参数变量 | part0/ch01.md | 特殊、参数、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.2.1 | 参数统计 | part0/ch03.md | 参数、统计 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.2.2 | 获取所有的数据 | part0/ch03.md | 的数据、所有、有的、的数、数据 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.4 | 处理选项 | part0/ch01.md | 处理、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.4.1 | 查找选项 | part0/ch02.md | 查找、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.5 | 选项标准化 | part0/ch07.md | 选项标、选项、项标、标准 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.1 | 基本的读取 | part0/ch01.md | 基本、本的、的读、读取 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.2 | 超时 | part0/ch01.md | 超时 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.3 | 无显示读取 | part0/ch01.md | 显示、读取 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.6.4 | 从文件中读取 | part0/ch03.md | 从文件、从文、文件、读取 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 14 | 14.7 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.1 | 理解输入和输出 | part0/ch14.md | 和输出、和输、输出 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.2 | 在脚本中重定向输出 | part0/ch11.md | 定向输出、定向输、向输出、脚本、重定、定向 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.2.2 | 永久重定向 | part0/ch02.md | 重定向、永久、重定、定向 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.3 | 在脚本中重定向输入 | part0/ch02.md | 在脚本、重定向、在脚、脚本、重定、定向 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.7.1 | 创建本地临时文件 | part0/ch01.md | 临时文件、临时文、时文件、创建、本地、临时 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.8 | 记录消息 | part0/ch06.md | 记录、消息 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 15 | 15.9 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.1.1 | 重温Linux信号 | part0/ch01.md | 信号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.1.2 | 产生信号 | part0/ch02.md | 产生、信号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.1.5 | 修改或移除信号捕获 | part0/ch08.md | 修改、移除、信号、捕获 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.2 | 以后台模式运行脚本 | part0/ch07.md | 运行脚本、运行脚、行脚本、后台、模式、运行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.3 | 在非控制台下运行脚本 | part0/ch06.md | 运行脚本、运行脚、行脚本、在非、控制、运行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.5 | 调整谦让度 | part0/ch02.md | 调整 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.6 | 定时运行作业 | part0/ch09.md | 时运行、时运、运行、作业 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.6.1 | 使用at命令调度作业 | part0/ch01.md | 命令、调度、作业 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.7 | 使用新shell启动脚本 | part0/ch01.md | shell、启动、脚本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 16 | 16.8 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.1 | 脚本函数基础 | part0/ch01.md | 脚本、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.1.1 | 创建函数 | part0/ch01.md | 创建、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.2.3 | 使用函数输出 | part0/ch02.md | 用函数、用函、函数、输出 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.3 | 在函数中使用变量 | part0/ch07.md | 在函数、用变量、在函、函数、用变、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.3.1 | 向函数传递参数 | part0/ch07.md | 函数传、函数、数传、参数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.3.2 | 在函数中处理变量 | part0/ch07.md | 在函数、在函、函数、处理、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.4 | 数组变量和函数 | part0/ch08.md | 和函数、数组、变量、和函、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.4.1 | 向函数传递数组 | part0/ch07.md | 函数传、函数、数传、数组 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.5 | 函数递归 | part0/ch02.md | 函数、递归 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.7 | 在命令行中使用函数 | part0/ch02.md | 在命令、命令行、用函数、在命、命令、令行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.7.1 | 在命令行中创建函数 | part0/ch01.md | 在命令行、在命令、命令行、在命、命令、令行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.7.2 | 在.bashrc文件中定义函数 | part0/ch06.md | 定义函数、定义函、义函数、文件、定义、义函 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.8 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 17 | 17.8.1 | 下载及安装 | part0/ch01.md | 下载、安装 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1 | 创建文本菜单 | part0/ch04.md | 创建文、创建、建文、文本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.1 | 创建菜单布局 | part0/ch01.md | 创建、菜单、布局 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.2 | 创建菜单函数 | part0/ch01.md | 创建、菜单、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.3 | 添加菜单逻辑 | part0/ch07.md | 菜单、逻辑 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.1.4 | 整合shell脚本菜单 | part0/ch01.md | shell、脚本、菜单 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.2 | 创建文本窗口部件 | part0/ch04.md | 创建文、创建、建文、文本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.2.2 | dialog选项 | part0/ch01.md | 选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.2.3 | 在脚本中使用dialog命令 | part0/ch02.md | 在脚本、在脚、脚本、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.3 | 图形化窗口部件 | part0/ch12.md | 化窗口、图形、化窗、窗口 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 18 | 18.4 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2 | sed编辑器基础命令 | part0/ch02.md | sed、编辑器、编辑、辑器、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.1 | 更多的替换选项 | part0/ch06.md | 的替换、的替、替换、选项 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.2 | 使用地址 | part0/ch01.md | 地址 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.4 | 插入和附加文本 | part0/ch02.md | 插入、文本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.5 | 修改行 | part0/ch01.md | 修改 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.2.7 | 再探打印 | part0/ch01.md | 打印 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 19 | 19.3 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.1.1 | 定义 | part0/ch01.md | 定义 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.3 | 锚点字符 | part0/ch06.md | 锚点、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.4 | 点号字符 | part0/ch06.md | 号字、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.5 | 字符组 | part0/ch01.md | 字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.6 | 排除型字符组 | part0/ch03.md | 型字符、排除、型字、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.7 | 区间 | part0/ch09.md | 区间 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.8 | 特殊的字符组 | part0/ch01.md | 的字符、特殊、的字、字符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.2.9 | 星号 | part0/ch07.md | 星号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.3.1 | 问号 | part0/ch06.md | 问号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.3.2 | 加号 | part0/ch06.md | 加号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.3.4 | 竖线符号 | part0/ch06.md | 竖线、符号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.4 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.4.1 | 目录文件计数 | part0/ch12.md | 录文件、目录、录文、文件、计数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 20 | 20.4.2 | 验证电话号码 | part0/ch04.md | 验证、电话 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.1.2 | 多行删除命令 | part0/ch02.md | 多行、删除、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.3 | 排除命令 | part0/ch03.md | 排除、命令 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.4 | 改变执行流程 | part0/ch01.md | 改变、执行、流程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.4.1 | 分支 | part0/ch01.md | 分支 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.4.2 | 测试 | part0/ch01.md | 测试 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.5.1 | &符号 | part0/ch01.md | 符号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.5.2 | 替换单独的单词 | part0/ch04.md | 单独的、替换、单独、独的 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.6 | 在脚本中使用sed | part0/ch02.md | sed、在脚本、在脚、脚本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.6.1 | 使用包装器 | part0/ch01.md | 用包装、用包、包装、装器 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.2 | 对可能含有空行的文件加倍行间距 | part0/ch02.md | 有空行、的文件、文件加、可能、有空、空行 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.3 | 给文件中的行编号 | part0/ch02.md | 的行编、文件、中的、的行、行编、编号 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.7.4 | 打印末尾行 | part0/ch01.md | 打印、末尾 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 21 | 21.8 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.1.1 | 内建变量 | part0/ch01.md | 内建、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.2 | 处理数组 | part0/ch03.md | 处理、数组 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.2.1 | 定义数组变量 | part0/ch03.md | 定义、数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.2.2 | 遍历数组变量 | part0/ch03.md | 遍历、数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.2.3 | 删除数组变量 | part0/ch06.md | 删除数、删除、除数、数组、变量 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.3 | 使用模式 | part0/ch01.md | 模式 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.3.2 | 匹配操作符 | part0/ch02.md | 操作符、匹配、作符 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.3.3 | 数学表达式 | part0/ch02.md | 表达式、表达、达式 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.4.1 | if语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.4.3 | do-while语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.4.4 | for语句 | part0/ch07.md | 语句 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.5 | 格式化打印 | part0/ch01.md | 格式化、格式、式化、打印 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.6 | 内建函数 | part0/ch01.md | 内建、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.6.1 | 数学函数 | part0/ch01.md | 函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.6.2 | 字符串函数 | part0/ch01.md | 字符串、字符、符串、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.6.3 | 时间函数 | part0/ch01.md | 时间、函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.7.3 | 创建函数库 | part0/ch08.md | 函数库、创建、函数、数库 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 22 | 22.8 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.3 | dash脚本编程 | part0/ch07.md | dash、脚本、编程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.3.2 | 不能使用的特性 | part0/ch04.md | 使用的、用的特、不能、用的、的特 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.4 | zsh shell | part0/ch01.md | shell |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.6 | zsh脚本编程 | part0/ch01.md | 脚本、编程 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.6.1 | 数学运算 | part0/ch03.md | 运算 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.6.3 | 函数 | part0/ch01.md | 函数 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 23 | 23.7 | 实战演练 | part0/ch06.md | 实战 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.1 | 备份 | part0/ch01.md | 备份 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.1.1 | 日常备份 | part0/ch01.md | 日常、备份 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.1.2 | 创建按小时归档的脚本 | part0/ch08.md | 的脚本、创建、小时、归档、的脚、脚本 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.2 | 删除账户 | part0/ch02.md | 删除 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.2.1 | 功能需求 | part0/ch01.md | 能需、需求 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.3 | 系统监控 | part0/ch01.md | 系统、监控 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 24 | 24.3.1 | 获得默认的shell审计功能 | part0/ch09.md | shell、默认的、获得、默认、认的 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.2 | 暂存区 | part0/ch11.md | 暂存 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.3 | 本地仓库 | part0/ch02.md | 本地、仓库 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.4 | 远程仓库 | part0/ch02.md | 远程、仓库 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.5 | 分支 | part0/ch01.md | 分支 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.1.6 | 克隆 | part0/ch01.md | 克隆 |
| weak | B · Linux 命令行与 shell 脚本编程大全 | 25 | 25.3 | 使用Git提交文件 | part0/ch10.md | git、提交、文件 |
| weak | C · CSAPP 3e | 1 | 1.1 | 信息就是位+上下文 | part1/ch01.md | 信息、就是、上下文、上下、下文 |
| weak | C · CSAPP 3e | 1 | 1.2 | 程序被其他程序翻译成不同的格式 | part2/ch01.md | 成不同的、被其他、翻译成、成不同、不同的、程序 |
| weak | C · CSAPP 3e | 1 | 1.3 | 了解编译系统如何工作是大有益处的 | part1/ch01.md | 编译系统、编译系、译系统、编译、译系、系统 |
| weak | C · CSAPP 3e | 1 | 1.5 | 高速缓存至关重要 | part1/ch06.md | 高速缓存、高速缓、速缓存、高速、速缓、缓存 |
| weak | C · CSAPP 3e | 1 | 1.6 | 储存设备形成层次结构 | part1/ch06.md | 层次结构、层次结、次结构、层次、次结 |
| weak | C · CSAPP 3e | 1 | 1.7 | 操作系统管理硬件 | part1/ch01.md | 操作系统、操作系、作系统、作系、系统、硬件 |
| weak | C · CSAPP 3e | 1 | 1.8 | 系统之间利用网络通信 | part1/ch13.md | 系统之、系统、统之、之间、利用、网络 |
| weak | C · CSAPP 3e | 1 | 1.9 | 重要主题 | part1/ch08.md | 要主、主题 |
| weak | C · CSAPP 3e | 2 | 2.1 | 信息存储 | part1/ch01.md | 信息、存储 |
| weak | C · CSAPP 3e | 3 | 3.10 | 在机器级程序中将控制与数据结合起来 | part1/ch02.md | 机器级程、器级程序、机器级、器级程、级程序、与数据 |
| weak | C · CSAPP 3e | 3 | 3.11 | 浮点代码 | part1/ch02.md | 浮点、代码 |
| weak | C · CSAPP 3e | 3 | 3.2 | 程序编码 | part1/ch01.md | 程序、编码 |
| weak | C · CSAPP 3e | 3 | 3.5 | 算数和逻辑操作 | part1/ch08.md | 数和、逻辑 |
| weak | C · CSAPP 3e | 3 | 3.6 | 控制 | part1/ch01.md | 控制 |
| weak | C · CSAPP 3e | 3 | 3.7 | 过程 | part1/ch07.md | 过程 |
| weak | C · CSAPP 3e | 3 | 3.8 | 数组分配和访问 | part1/ch13.md | 分配和、数组、分配、配和、访问 |
| weak | C · CSAPP 3e | 4 | 4.3 | Y86-64的顺序现实 | part1/ch03.md | y86-64、的顺序、的顺、顺序 |
| weak | C · CSAPP 3e | 5 | 5.1 | 优化编译器的能力和局限性 | part1/ch04.md | 优化编译、化编译器、优化编、化编译、编译器、优化 |
| weak | C · CSAPP 3e | 5 | 5.10 | 优化合并代码的结果小结 | part1/ch04.md | 代码的、的结果、优化、合并、代码、码的 |
| weak | C · CSAPP 3e | 5 | 5.11 | 一些限制因素 | part1/ch03.md | 一些、限制 |
| weak | C · CSAPP 3e | 5 | 5.12 | 理解内存性能 | part1/ch03.md | 理解、内存、性能 |
| weak | C · CSAPP 3e | 5 | 5.13 | 应用：性能提高技术 | part1/ch04.md | 性能提、性能、能提、提高、技术 |
| weak | C · CSAPP 3e | 5 | 5.14 | 确认和消除性能瓶颈 | part2/ch13.md | 性能瓶颈、性能瓶、能瓶颈、确认、性能、能瓶 |
| weak | C · CSAPP 3e | 5 | 5.3 | 程序示例 | part1/ch01.md | 程序 |
| weak | C · CSAPP 3e | 5 | 5.4 | 消除循环的低效率 | part1/ch03.md | 循环的、循环、环的、的低 |
| weak | C · CSAPP 3e | 8 | 8.1 | 异常 | part1/ch01.md | 异常 |
| weak | C · CSAPP 3e | 8 | 8.2 | 进程 | part1/ch01.md | 进程 |
| weak | C · CSAPP 3e | 8 | 8.5 | 信号 | part1/ch03.md | 信号 |
| weak | C · CSAPP 3e | 10 | 10.1 | Unix I/O | part1/ch01.md | i/o |
| weak | C · CSAPP 3e | 10 | 10.2 | 文件 | part1/ch01.md | 文件 |
| weak | C · CSAPP 3e | 10 | 10.7 | 读取目录和内容 | part1/ch10.md | 读取目录、读取目、取目录、读取、取目、目录 |
| weak | C · CSAPP 3e | 11 | 11.2 | 网络 | part1/ch01.md | 网络 |
| weak | G · 鸟哥的 Linux 私房菜 | 0 | 0.1 | 电脑：辅助人脑的好工具 | part0/ch12.md | 辅助、的好、工具 |
| weak | G · 鸟哥的 Linux 私房菜 | 0 | 0.2 | 个人电脑架构与相关设备元件 | part0/ch01.md | 架构与、架构、构与、设备 |
| weak | G · 鸟哥的 Linux 私房菜 | 0 | 0.3 | 数据表示方式 | part0/ch01.md | 数据、表示 |
| weak | G · 鸟哥的 Linux 私房菜 | 1 | 1.2 | Torvalds的Linux发展 | part0/ch01.md | torvalds |
| weak | G · 鸟哥的 Linux 私房菜 | 1 | 1.3 | Linux当前应用的角色 | part0/ch10.md | 的角色、当前、应用、用的、的角、角色 |
| weak | G · 鸟哥的 Linux 私房菜 | 1 | 1.4 | Linux 该如何学习 | part0/ch01.md | 学习 |
| weak | G · 鸟哥的 Linux 私房菜 | 2 | 2.1 | Linux与硬件的搭配 | part0/ch01.md | 硬件的、硬件、件的 |
| weak | G · 鸟哥的 Linux 私房菜 | 2 | 3.2 | 开始安装CentOS 7 | part0/ch01.md | 开始、安装 |
| weak | G · 鸟哥的 Linux 私房菜 | 2 | 3.3 | 多重开机安装流程与管理（Option｜ | part0/ch01.md | option、开机、安装、流程、程与 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.1 | 首次登陆系统 | part0/ch02.md | 首次登、首次、次登、系统 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.2 | 文字模式下指令的下达 | part0/ch02.md | 模式下、文字、模式、式下、令的 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.3 | Linux系统的线上求助man page与info page | part0/ch01.md | man、page、info、系统的、系统、统的 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.4 | 超简单文书编辑器： nano | part0/ch06.md | 编辑器、简单、编辑、辑器 |
| weak | G · 鸟哥的 Linux 私房菜 | 4 | 4.5 | 正确的关机方法 | part0/ch03.md | 正确的、正确、确的、的关 |
| weak | G · 鸟哥的 Linux 私房菜 | 5 | 5.1 | 使用者与群组 | part0/ch01.md | 使用者、用者 |
| weak | G · 鸟哥的 Linux 私房菜 | 6 | 6.1 | 目录与路径 | part0/ch04.md | 目录与、目录、录与、路径 |
| weak | G · 鸟哥的 Linux 私房菜 | 6 | 6.5 | 指令与文件的搜寻 | part0/ch02.md | 令与文件、令与文、与文件、文件的、令与、与文 |
| weak | G · 鸟哥的 Linux 私房菜 | 6 | 6.6 | 极重要的复习！权限与指令间的关系 | part0/ch04.md | 重要、要的、权限与、权限、限与、的关 |
| weak | G · 鸟哥的 Linux 私房菜 | 7 | 7.4 | 设置开机挂载 | part0/ch01.md | 设置、开机、挂载 |
| weak | G · 鸟哥的 Linux 私房菜 | 7 | 7.5 | 内存交换空间（swap｜ॎ䭒᭞ | part0/ch10.md | swap、内存、交换、空间 |
| weak | G · 鸟哥的 Linux 私房菜 | 8 | 8.2 | Linux 系统常见的压缩指令 | part0/ch01.md | 常见的、系统、常见、见的、压缩、指令 |
| weak | G · 鸟哥的 Linux 私房菜 | 8 | 8.3 | 打包指令： tar | part0/ch01.md | tar、打包、指令 |
| weak | G · 鸟哥的 Linux 私房菜 | 8 | 8.5 | 光盘写入工具 | part0/ch13.md | 盘写、写入、工具 |
| weak | G · 鸟哥的 Linux 私房菜 | 8 | 8.6 | 其他常见的压缩与备份工具 | part0/ch03.md | 备份工具、常见的、备份工、份工具、常见、见的 |
| weak | G · 鸟哥的 Linux 私房菜 | 9 | 9.1 | vi 与 vim | part0/ch01.md | vim |
| weak | G · 鸟哥的 Linux 私房菜 | 9 | 9.3 | vim 的额外功能 | part0/ch04.md | vim、额外 |
| weak | G · 鸟哥的 Linux 私房菜 | 9 | 9.4 | 其他 vim 使用注意事项 | part0/ch01.md | vim、注意 |
| weak | G · 鸟哥的 Linux 私房菜 | 10 | 10.2 | Shell 的变量功能 | part0/ch05.md | shell、的变量、的变、变量 |
| weak | G · 鸟哥的 Linux 私房菜 | 10 | 10.3 | 命令别名与历史命令 | part0/ch02.md | 别名与、与历史、命令、别名、名与、与历 |
| weak | G · 鸟哥的 Linux 私房菜 | 10 | 10.5 | 数据流重导向 | part0/ch01.md | 数据 |
| weak | G · 鸟哥的 Linux 私房菜 | 10 | 10.6 | 管线命令 （pipe｜ | part0/ch05.md | pipe、管线、命令 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 12.3 | 善用判断式 | part0/ch07.md | 判断式、判断、断式 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.1 | Linux 的帐号与群组 | part0/ch02.md | 号与 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.3 | 主机的细部权限规划：ACL 的使用 | part0/ch04.md | acl、部权限、主机、的细、部权、权限 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.6 | Linux 主机上的使用者讯息传递 | part0/ch01.md | 使用者、主机、机上、上的、用者 |
| weak | G · 鸟哥的 Linux 私房菜 | 12 | 13.7 | CentOS 7 环境下大量创建帐号的方法 | part0/ch08.md | 环境下、环境、境下、创建、号的、的方 |
| weak | G · 鸟哥的 Linux 私房菜 | 14 | 14.2 | 软件磁盘阵列 （Software RAID｜ | part0/ch10.md | raid、软件、磁盘、阵列 |
| weak | G · 鸟哥的 Linux 私房菜 | 14 | 14.3 | 逻辑卷轴管理员 （Logical Volume Manager｜ | part0/ch13.md | manager、管理员、理员 |
| weak | G · 鸟哥的 Linux 私房菜 | 15 | 15.2 | 仅执行一次的工作调度 | part0/ch03.md | 执行一次、执行一、行一次、的工作、执行、行一 |
| weak | G · 鸟哥的 Linux 私房菜 | 15 | 15.4 | 可唤醒停机期间的工作任务 | part0/ch12.md | 停机期间、停机期、机期间、唤醒、停机、机期 |
| weak | G · 鸟哥的 Linux 私房菜 | 16 | 16.1 | 什么是程序 （process｜ | part0/ch02.md | process、什么是、么是、程序 |
| weak | G · 鸟哥的 Linux 私房菜 | 17 | 17.5 | CentOS 7.x 默认启动的服务简易说明 | part0/ch04.md | 默认启、启动的、的服务、默认、认启、启动 |
| weak | G · 鸟哥的 Linux 私房菜 | 18 | 18.4 | systemd-journald.service 简介 | part0/ch12.md | systemd-journald.service |
| weak | G · 鸟哥的 Linux 私房菜 | 19 | 19.1 | Linux 的开机流程分析 | part0/ch01.md | 开机流程、开机流、机流程、开机、机流、流程 |
| weak | G · 鸟哥的 Linux 私房菜 | 19 | 19.2 | 核心与核心模块 | part0/ch01.md | 核心、模块 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.1 | 系统基本设置 | part0/ch01.md | 系统、基本、设置 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.2 | 服务器硬件数据的收集 | part0/ch14.md | 硬件数据、硬件数、件数据、服务、硬件、件数 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.3 | 备份要点 | part0/ch10.md | 备份、要点 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.4 | 备份的种类、频率与工具的遜ॢ | part0/ch14.md | 与工具的、与工具、工具的、频率、与工、工具 |
| weak | G · 鸟哥的 Linux 私房菜 | 20 | 20.6 | 灾难复原的考虑 | part0/ch06.md | 灾难、考虑 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 20.1 | 开放源码的软件安装与升级简介 | part0/ch11.md | 软件安装、软件安、件安装、源码、软件、件安 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.2 | 使用传统程序语言进行编译的简单范例 | part0/ch01.md | 统程序、编译的、传统、统程、程序、语言 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.3 | 用 make 进行宏编译 | part0/ch01.md | make、编译 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.4 | Tarball 的管理与建议 | part0/ch11.md | tarball、管理与、理与、建议 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.5 | 函数库管理 | part0/ch07.md | 函数库、函数、数库 |
| weak | G · 鸟哥的 Linux 私房菜 | 21 | 21.6 | 检验软件正确性 | part0/ch03.md | 正确性、软件、正确、确性 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.1 | 软件管理员简介 | part0/ch01.md | 管理员、软件、理员 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.2 | RPM 软件管理程序： rpm | part0/ch01.md | rpm、软件、程序 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.3 | YUM 线上升级机制 | part0/ch11.md | yum、线上、升级 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 22.4 | SRPM 的使用 ： rpmbuild （Optional｜ | part0/ch11.md | srpm |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 23.2 | X Server 配置文件解析与设置 | part0/ch13.md | server、配置文件、配置文、置文件、配置、置文 |
| weak | G · 鸟哥的 Linux 私房菜 | 22 | 23.3 | 显卡驱动程序安装范例 | part0/ch01.md | 显卡驱动、显卡驱、卡驱动、显卡、卡驱、驱动 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.1 | 编译前的任务：认识核心与取得核心源代码 | part0/ch02.md | 编译、前的、任务、认识、核心、与取 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.2 | 核心编译的前处理与核心功能遜ॢ | part0/ch01.md | 编译的、核心、编译、译的、的前、处理 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.3 | 核心的编译与安装 | part0/ch01.md | 编译与、核心、编译、译与、安装 |
| weak | G · 鸟哥的 Linux 私房菜 | 24 | 24.5 | 以最新核心版本编译 CentOS 7.x 的核心 | part0/ch02.md | 最新、核心、版本、本编、编译、的核心 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.1 | UNIX 和C 语言简史 | part0/ch01.md | 语言 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.2.2 | Linux 内核 | part0/ch01.md | 内核 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.3.4 | SUSv3 和POSIX.1-2001 | part2/ch03.md | susv3 |
| weak | K · Kerrisk 系统编程手册 | 1 | 1.3.7 | 实现标准 | part0/ch01.md | 标准 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.10 | 进程间通信及同步 | part2/ch15.md | 进程间、进程、程间、通信、同步 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.11 | 信号 | part0/ch01.md | 信号 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.12 | 线程 | part0/ch01.md | 线程 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.16 | 日期和时间 | part0/ch03.md | 日期、时间 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.2 | shell | part0/ch01.md | shell |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.4 | 单根目录层级、目录、链接及文件 | part0/ch01.md | 目录层级、目录层、录层级、目录、录层、层级 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.6 | 程序 | part0/ch01.md | 程序 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.7 | 进程 | part0/ch01.md | 进程 |
| weak | K · Kerrisk 系统编程手册 | 2 | 2.9 | 静态库和共享库 | part1/ch09.md | 和共享、共享库、静态、库和、和共、共享 |
| weak | K · Kerrisk 系统编程手册 | 3 | 3.5 | 关于本书示例程序的注意事项 | part2/ch03.md | 注意事项、注意事、意事项、本书、程序、注意 |
| weak | K · Kerrisk 系统编程手册 | 3 | 3.5.1 | 命令行选项及参数 | part0/ch01.md | 命令行、命令、令行、选项、参数 |
| weak | K · Kerrisk 系统编程手册 | 3 | 3.6.2 | 系统数据类型 | part0/ch02.md | 系统、数据、类型 |
| weak | K · Kerrisk 系统编程手册 | 4 | 4.8 | 通用I/O 模型以外的操作：ioctl() | part0/ch01.md | i/o、ioctl、通用、的操作、模型、外的 |
| weak | K · Kerrisk 系统编程手册 | 5 | 5.6 | 在文件特定偏移量处的I/O：pread()和pwrite() | part2/ch02.md | i/o、pread、pwrite、在文件、定偏移、在文 |
| weak | K · Kerrisk 系统编程手册 | 5 | 5.7 | 分散输入和集中输出（Scatter-Gather I/O）：readv()和writev() | part2/ch01.md | i/o、readv、分散、输入、集中、输出 |
| weak | K · Kerrisk 系统编程手册 | 6 | 6.2 | 进程号和父进程号 | part3/ch04.md | 和父进程、和父进、父进程、进程、和父、父进 |
| weak | K · Kerrisk 系统编程手册 | 6 | 6.7 | 环境列表 | part0/ch01.md | 环境、列表 |
| weak | K · Kerrisk 系统编程手册 | 7 | 7.1.4 | 在堆上分配内存的其他方法 | part3/ch06.md | 分配内存、上分配、分配内、配内存、内存的、上分 |
| weak | K · Kerrisk 系统编程手册 | 8 | 8.1 | 密码文件：/etc/passwd | part0/ch02.md | etc/passwd、密码、文件 |
| weak | K · Kerrisk 系统编程手册 | 8 | 8.5 | 密码加密和用户认证 | part0/ch13.md | 用户认证、用户认、户认证、密码、加密、用户 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.1 | 实际用户ID 和实际组ID | part0/ch14.md | 实际用、实际、际用、用户 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.7 | 获取和修改进程凭证 | part0/ch04.md | 进程凭证、进程凭、程凭证、修改、进程、程凭 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.7.1 | 获取和修改实际、有效和保存设置标识 | part1/ch12.md | 获取、修改、实际、有效、保存、设置 |
| weak | K · Kerrisk 系统编程手册 | 9 | 9.7.3 | 获取和修改辅助组ID | part2/ch05.md | 辅助组、修改、辅助、助组 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.2.1 | 将time_t 转换为可打印格式 | part0/ch13.md | time_t、转换、打印、格式 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.2.2 | time_t 和分解时间之间的转换 | part2/ch11.md | time_t、之间的、分解、时间、之间、间的 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.3 | 时区 | part0/ch12.md | 时区 |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.4 | 地区（Locale） | part0/ch01.md | locale |
| weak | K · Kerrisk 系统编程手册 | 10 | 10.6 | 软件时钟（jiffies） | part3/ch13.md | jiffies、软件、件时 |
| weak | K · Kerrisk 系统编程手册 | 11 | 11.1 | 系统限制 | part0/ch01.md | 系统、限制 |
| weak | K · Kerrisk 系统编程手册 | 11 | 11.3 | 运行时获取与文件相关的限制（和选项） | part2/ch01.md | 运行时、与文件、相关的、的限制、运行、行时 |
| weak | K · Kerrisk 系统编程手册 | 12 | 12.1.1 | 获取与进程有关的信息：/proc/PID | part2/ch09.md | proc/pid、与进程、进程有、的信息、与进、进程 |
| weak | K · Kerrisk 系统编程手册 | 12 | 12.2 | 系统标识：uname() | part2/ch11.md | uname、系统、标识 |
| weak | K · Kerrisk 系统编程手册 | 13 | 13.4 | I/O 缓冲小结 | part0/ch01.md | i/o、缓冲 |
| weak | K · Kerrisk 系统编程手册 | 13 | 13.5 | 就I/O 模式向内核提出建议 | part0/ch01.md | i/o、向内核、内核提、模式、向内、内核 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.2 | 磁盘和分区 | part3/ch02.md | 磁盘、盘和、分区 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.4 | i 节点 | part0/ch01.md | 节点 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.7 | 单根目录层级和挂载点 | part0/ch01.md | 目录层级、目录层、录层级、挂载点、目录、录层 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.9 | 高级挂载特性 | part0/ch10.md | 高级、挂载、特性 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.9.2 | 多次挂载同一挂载点 | part2/ch05.md | 次挂载、挂载点、次挂、挂载、同一、载点 |
| weak | K · Kerrisk 系统编程手册 | 14 | 14.9.3 | 基于每次挂载的挂载标志 | part3/ch12.md | 次挂载、挂载的、的挂载、每次、次挂、挂载 |
| weak | K · Kerrisk 系统编程手册 | 15 | 15.1 | 获取文件信息：stat() | part0/ch03.md | stat、取文件、取文、文件、信息 |
| weak | K · Kerrisk 系统编程手册 | 15 | 15.2.1 | 使用utime()和utimes()来改变文件时间戳 | part0/ch03.md | 文件时间、文件时、件时间、时间戳、改变、文件 |
| weak | K · Kerrisk 系统编程手册 | 15 | 15.4.6 | 进程的文件模式创建掩码：umask() | part1/ch12.md | umask、进程的、的文件、进程、程的、的文 |
| weak | K · Kerrisk 系统编程手册 | 17 | 17.3 | ACL 的长、短文本格式 | part2/ch04.md | acl、的长、文本、格式 |
| weak | K · Kerrisk 系统编程手册 | 17 | 17.7 | ACL 在实现方面的限制 | part0/ch12.md | acl、的限制、面的、的限、限制 |
| weak | K · Kerrisk 系统编程手册 | 18 | 18.14 | 解析路径名字符串：dirname()和basename() | part2/ch16.md | 解析路径、解析路、析路径、路径名、解析、析路 |
| weak | K · Kerrisk 系统编程手册 | 18 | 18.3 | 创建和移除（硬）链接：link()和 unlink() | part0/ch04.md | link、unlink、创建、移除、链接 |
| weak | K · Kerrisk 系统编程手册 | 18 | 18.6 | 创建和移除目录：mkdir()和rmdir() | part2/ch06.md | mkdir、rmdir、除目录、创建、移除、除目 |
| weak | K · Kerrisk 系统编程手册 | 19 | 19.6 | 监控文件的旧有系统：dnotify | part0/ch06.md | 文件的、有系统、文件、件的、有系、系统 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.1 | 概念和概述 | part0/ch02.md | 概念 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.12 | 不对信号进行排队处理 | part2/ch10.md | 对信号、信号进、对信、信号、号进、进行 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.14 | 等待信号：pause() | part1/ch08.md | pause、等待、信号 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.2 | 信号类型和默认行为 | part0/ch02.md | 默认行为、默认行、认行为、信号、类型、默认 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.6 | 检查进程的存在 | part1/ch08.md | 查进程、进程的、检查、查进、进程、程的 |
| weak | K · Kerrisk 系统编程手册 | 20 | 20.8 | 显示信号描述 | part2/ch10.md | 示信号、示信、信号、描述 |
| weak | K · Kerrisk 系统编程手册 | 21 | 21.1.1 | 再论信号的非队列化处理 | part1/ch08.md | 信号的、信号、号的、的非、队列、处理 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.1 | 核心转储文件 | part0/ch01.md | 核心、文件 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.10 | 以同步方式等待信号 | part2/ch12.md | 同步方式、同步方、步方式、同步、步方、等待 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.12 | 利用信号进行进程间通信 | part1/ch12.md | 利用信号、利用信、用信号、利用、用信、信号 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.2 | 传递、处置及处理的特殊情况 | part0/ch04.md | 传递、的特殊、处理、理的、的特、特殊 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.5 | 信号的同步生成和异步生成 | part2/ch14.md | 的同步、和异步、信号、号的、的同、同步 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.6 | 信号传递的时机与顺序 | part0/ch01.md | 的时机与、的时机、时机与、信号、的时、时机 |
| weak | K · Kerrisk 系统编程手册 | 22 | 22.9 | 使用掩码来等待信号：sigsuspend() | part1/ch08.md | sigsuspend、掩码、等待、信号 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.2 | 定时器的调度及精度 | part2/ch11.md | 定时器的、定时器、时器的、定时、时器、器的 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.3 | 为阻塞操作设置超时 | part1/ch12.md | 阻塞操作、阻塞操、塞操作、阻塞、塞操、设置 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.4.1 | 低分辨率休眠：sleep() | part2/ch11.md | sleep、分辨率、分辨、辨率、休眠 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.4.2 | 高分辨率休眠：nanosleep() | part2/ch11.md | nanosleep、分辨率、分辨、辨率、休眠 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.5.1 | 获取时钟的值：clock_gettime() | part2/ch01.md | clock_gettime、时钟的、取时、时钟、钟的、的值 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.5.3 | 获取特定进程或线程的时钟ID | part2/ch07.md | 程或线程、定进程、程或线、或线程、定进、进程 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6 | POSIX 间隔式定时器 | part2/ch08.md | posix、定时器、间隔、定时、时器 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6.3 | 获取定时器的当前值：timer_gettime() | part2/ch11.md | timer_gettime、定时器的、定时器、时器的、定时、时器 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6.5 | 通过信号发出通知 | part1/ch08.md | 信号发出、信号发、号发出、通过、信号、号发 |
| weak | K · Kerrisk 系统编程手册 | 23 | 23.6.7 | 通过线程来通知 | part2/ch07.md | 通过、线程、程来、通知 |
| weak | K · Kerrisk 系统编程手册 | 24 | 24.5 | 同步信号以规避竞争条件 | part2/ch07.md | 竞争条件、竞争条、争条件、同步、信号、竞争 |
| weak | K · Kerrisk 系统编程手册 | 26 | 26.1 | 等待子进程 | part0/ch02.md | 子进程、等待、子进、进程 |
| weak | K · Kerrisk 系统编程手册 | 27 | 27.2.2 | 将程序参数指定为列表 | part2/ch02.md | 参数指、程序、参数、数指、指定 |
| weak | K · Kerrisk 系统编程手册 | 27 | 27.2.3 | 将调用者的环境传递给新程序 | part2/ch09.md | 调用者的、调用者、用者的、的环境、调用、用者 |
| weak | K · Kerrisk 系统编程手册 | 27 | 27.3 | 解释器脚本 | part0/ch01.md | 解释器、解释、释器、脚本 |
| weak | K · Kerrisk 系统编程手册 | 28 | 28.1 | 进程记账 | part0/ch09.md | 进程、记账 |
| weak | K · Kerrisk 系统编程手册 | 28 | 28.2.2 | 因克隆生成的子进程而对waitpid()进行的扩展 | part1/ch08.md | waitpid、的子进程、的子进、子进程、进程而、生成 |
| weak | K · Kerrisk 系统编程手册 | 29 | 29.2 | Pthreads API 的详细背景 | part3/ch08.md | api、的详细、的详、详细 |
| weak | K · Kerrisk 系统编程手册 | 29 | 29.6 | 连接（joining）已终止的线程 | part1/ch12.md | 连接、的线程、终止、止的、的线、线程 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.1.2 | 加锁和解锁互斥量 | part2/ch13.md | 互斥量、加锁、锁和、解锁、互斥、斥量 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.1.3 | 互斥量的性能 | part2/ch13.md | 互斥量、互斥、斥量、量的、性能 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.1.7 | 互斥量类型 | part2/ch13.md | 互斥量、互斥、斥量、类型 |
| weak | K · Kerrisk 系统编程手册 | 30 | 30.2.4 | 示例程序：连接任意已终止线程 | part2/ch12.md | 程序、终止线程、终止线、止线程、连接、任意 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3 | 线程特有数据 | part2/ch17.md | 有数据、线程、特有、有数、数据 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.1 | 库函数视角下的线程特有数据 | part1/ch11.md | 库函数、的线程、有数据、库函、函数、下的 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.2 | 线程特有数据API 概述 | part2/ch17.md | api、有数据、线程、特有、有数、数据 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.3 | 线程特有数据API 详述 | part2/ch12.md | api、有数据、线程、有数、数据、详述 |
| weak | K · Kerrisk 系统编程手册 | 31 | 31.3.5 | 线程特有数据的实现限制 | part1/ch12.md | 有数据、数据的、的实现、线程、有数、数据 |
| weak | K · Kerrisk 系统编程手册 | 32 | 32.4 | 线程可取消性的检测 | part2/ch13.md | 线程可、的检测、线程、程可、取消、的检 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.2 | 线程和信号 | part2/ch12.md | 线程和、线程、程和、信号 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.2.1 | UNIX 信号模型如何映射到线程中 | part2/ch07.md | 映射到、信号、模型、映射、射到、线程 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.4 | 线程实现模型 | part3/ch05.md | 程实现、线程、程实、模型 |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.5.1 | LinuxThreads | part2/ch15.md | linuxthreads |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.5.2 | NPTL | part2/ch09.md | nptl |
| weak | K · Kerrisk 系统编程手册 | 33 | 33.5.3 | 哪一种线程实现 | part1/ch10.md | 哪一种、哪一、一种、线程 |
| weak | K · Kerrisk 系统编程手册 | 34 | 34.3 | 会话 | part0/ch02.md | 会话 |
| weak | K · Kerrisk 系统编程手册 | 35 | 35.3.2 | 修改和获取策略和优先级 | part1/ch12.md | 优先级、修改、获取、策略、优先、先级 |
| weak | K · Kerrisk 系统编程手册 | 36 | 36.3 | 特定资源限制细节 | part0/ch09.md | 资源限制、资源限、源限制、资源、源限、限制 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.3 | 编写daemon 指南 | part0/ch02.md | 指南 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.5 | 使用syslog 记录消息和错误 | part2/ch01.md | 和错误、记录、消息、和错、错误 |
| weak | K · Kerrisk 系统编程手册 | 37 | 37.5.3 | /etc/syslog.conf 文件 | part0/ch01.md | 文件 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.10 | 小心拒绝服务攻击 | part2/ch17.md | 拒绝服务、拒绝服、绝服务、拒绝、绝服、服务 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.11 | 检查返回状态和安全地处理失败情况 | part0/ch04.md | 检查返回、检查返、查返回、和安全、安全地、检查 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.2 | 以最小权限操作 | part0/ch04.md | 最小权限、最小权、小权限、最小、小权、权限 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.4 | 避免暴露敏感信息 | part0/ch01.md | 避免、暴露、信息 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.5 | 确定进程的边界 | part0/ch01.md | 进程的、的边界、定进、进程、程的、的边 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.6 | 小心信号和竞争条件 | part2/ch07.md | 竞争条件、竞争条、争条件、小心、信号、竞争 |
| weak | K · Kerrisk 系统编程手册 | 38 | 38.8 | 不要完全相信输入和环境 | part1/ch04.md | 完全相、输入和、不要、完全、全相、输入 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.1 | 能力基本原理 | part0/ch01.md | 能力、基本 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.10 | 不具备文件能力的老式内核和系统 | part0/ch04.md | 文件能力、文件能、件能力、文件、件能、能力 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.2 | Linux 能力 | part0/ch01.md | 能力 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.3 | 进程许可和有效能力集的目的 | part0/ch02.md | 进程、许可、有效、能力、的目、目的 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.4 | 文件许可和有效能力集的目的 | part0/ch02.md | 文件、许可、有效、能力、的目、目的 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.5 | 进程和文件可继承集的目的 | part0/ch10.md | 进程和、和文件、进程、程和、和文、文件 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.3.6 | 在shell 中给文件赋予能力和查看文件能力 | part0/ch04.md | shell、文件能力、看文件、文件能、件能力、文件 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.4 | 现代能力实现 | part0/ch01.md | 现代、能力 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.5 | 在exec()中转变进程能力 | part2/ch09.md | exec、变进程、进程能、变进、进程、程能 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.5.1 | 能力边界集 | part2/ch09.md | 边界集、能力、边界、界集 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.6 | 改变用户ID 对进程能力的影响 | part2/ch09.md | 改变、用户、进程能、能力的、进程、程能 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.7 | 用编程的方式改变进程能力 | part2/ch09.md | 改变进程、改变进、变进程、进程能、用编、编程 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.8 | 创建仅包含能力的环境 | part2/ch09.md | 能力的、的环境、创建、包含、能力、力的 |
| weak | K · Kerrisk 系统编程手册 | 39 | 39.9 | 发现程序所需的能力 | part0/ch01.md | 所需的、发现、程序、所需、需的、能力 |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.2 | utmpx API | part0/ch02.md | api |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.3 | utmpx 结构 | part0/ch12.md | utmpx |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.4 | 从utmp 和wtmp 文件中检索信息 | part2/ch01.md | 文件中、文件、件中、信息 |
| weak | K · Kerrisk 系统编程手册 | 40 | 40.5 | 获取登录名称：getlogin() | part0/ch04.md | 登录名、登录、录名、名称 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.1 | 目标库 | part0/ch01.md | 目标 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.13 | 使用静态库取代共享库 | part1/ch12.md | 使用静态、使用静、用静态、用静、静态、共享 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.3 | 共享库概述 | part0/ch10.md | 共享库、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.4 | 创建和使用共享库——首回合 | part1/ch07.md | 用共享库、用共享、共享库、用共、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.4.2 | 位置独立的代码 | part0/ch08.md | 独立的、的代码、位置、独立、立的、的代 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.6 | 共享库版本和命名规则 | part0/ch11.md | 共享库、库版本、共享、享库、库版、版本 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.7 | 安装共享库 | part0/ch11.md | 共享库、安装、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.8 | 兼容与不兼容库比较 | part0/ch01.md | 不兼容、兼容、与不、不兼、比较 |
| weak | K · Kerrisk 系统编程手册 | 41 | 41.9 | 升级共享库 | part0/ch11.md | 共享库、升级、共享、享库 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.1.2 | 错误诊断：dlerror() | part0/ch01.md | 错误、诊断 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.1.5 | 获取与加载的符号相关的信息：dladdr() | part3/ch01.md | 与加载、加载的、的符号、相关的、与加、加载 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.1.6 | 在主程序中访问符号 | part1/ch08.md | 在主程序、在主程、主程序、在主、主程、程序 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.3.1 | 使用版本脚本控制符号的可见性 | part1/ch16.md | 版本脚本、版本脚、本脚本、符号的、可见性、版本 |
| weak | K · Kerrisk 系统编程手册 | 42 | 42.4 | 初始化和终止函数 | part1/ch01.md | 初始化、初始、始化、终止、函数 |
| weak | K · Kerrisk 系统编程手册 | 43 | 43.2 | 通信工具 | part1/ch10.md | 通信、工具 |
| weak | K · Kerrisk 系统编程手册 | 43 | 43.4 | IPC 工具比较 | part0/ch14.md | ipc、工具、比较 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.2 | 创建和使用管道 | part2/ch07.md | 创建和、创建、建和、管道 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.3 | 将管道作为一种进程同步的方法 | part2/ch13.md | 进程同步、进程同、程同步、同步的、管道、作为 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.5 | 通过管道与shell 命令进行通信：popen() | part2/ch08.md | shell、popen、通过管道、通过管、过管道、通过 |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.7 | FIFO | part0/ch03.md | fifo |
| weak | K · Kerrisk 系统编程手册 | 44 | 44.8 | 使用管道实现一个客户端/服务器应用程序 | part1/ch11.md | 实现一个、个客户端、实现一、现一个、个客户、客户端 |
| weak | K · Kerrisk 系统编程手册 | 45 | 45.4 | IPC 标识符和客户端/服务器应用程序 | part2/ch17.md | 客户端、标识、客户、户端、服务器、服务 |
| weak | K · Kerrisk 系统编程手册 | 45 | 45.7 | 获取所有IPC 对象列表 | part1/ch04.md | ipc、所有、对象、列表 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.1 | 创建或打开一个消息队列 | part2/ch13.md | 消息队列、一个消、消息队、息队列、创建、打开 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.2.1 | 发送消息 | part0/ch12.md | 发送、消息 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.2.2 | 接收消息 | part1/ch11.md | 接收、消息 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.3 | 消息队列控制操作 | part2/ch06.md | 消息队列、消息队、息队列、消息、息队、队列 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.7 | 使用消息队列实现客户端-服务器应用程序 | part2/ch14.md | 消息队列、消息队、息队列、客户端、消息、息队 |
| weak | K · Kerrisk 系统编程手册 | 46 | 46.8 | 使用消息队列实现文件服务器应用程序 | part2/ch14.md | 消息队列、消息队、息队列、服务器、消息、息队 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.10 | 信号量限制 | part1/ch12.md | 信号量、信号、号量、限制 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.5 | 信号量初始化 | part1/ch12.md | 信号量、初始化、信号、号量、初始、始化 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.6 | 信号量操作 | part0/ch02.md | 量操作、信号、量操 |
| weak | K · Kerrisk 系统编程手册 | 47 | 47.8 | 信号量撤销值 | part1/ch19.md | 信号量、信号、号量、撤销 |
| weak | K · Kerrisk 系统编程手册 | 48 | 48.2 | 创建或打开一个共享内存段 | part2/ch15.md | 共享内存、享内存段、共享内、享内存、内存段、创建 |
| weak | K · Kerrisk 系统编程手册 | 48 | 48.4 | 示例：通过共享内存传输数据 | part1/ch06.md | 共享内存、共享内、享内存、通过、共享、享内 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.4.3 | 边界情况 | part0/ch01.md | 边界 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.4.4 | 内存保护和文件访问模式交互 | part0/ch14.md | 访问模式、和文件、访问模、问模式、内存、和文 |
| weak | K · Kerrisk 系统编程手册 | 49 | 49.9 | MAP_NORESERVE 和过度利用交换空间 | part2/ch03.md | map_noreserve、交换空间、交换空、换空间、交换、换空 |
| weak | K · Kerrisk 系统编程手册 | 50 | 50.3 | 确定内存驻留性：mincore() | part1/ch09.md | mincore、确定、内存、驻留 |
| weak | K · Kerrisk 系统编程手册 | 50 | 50.4 | 建议后续的内存使用模式：madvise() | part1/ch18.md | 续的内存、续的内、的内存、续的、的内、内存 |
| weak | K · Kerrisk 系统编程手册 | 51 | 51.1 | API 概述 | part0/ch02.md | api |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.2 | 打开、关闭和断开链接消息队列 | part2/ch06.md | 打开、消息队列、消息队、息队列、关闭、链接 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.5.1 | 发送消息 | part0/ch12.md | 发送、消息 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.5.2 | 接收消息 | part1/ch11.md | 接收、消息 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.5.3 | 在发送和接收消息时设置超时时间 | part2/ch14.md | 超时时间、超时时、时时间、发送、接收、消息 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.6 | 消息通知 | part0/ch08.md | 消息、通知 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.6.1 | 通过信号接收通知 | part2/ch10.md | 信号接、信号、号接、接收、通知 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.6.2 | 通过线程接收通知 | part2/ch16.md | 通过、线程、程接、接收、通知 |
| weak | K · Kerrisk 系统编程手册 | 51 | 52.7 | Linux 特有的特性 | part1/ch04.md | 特有的、特有、有的 |
| weak | K · Kerrisk 系统编程手册 | 53 | 53.3 | 信号量操作 | part0/ch02.md | 量操作、信号、量操 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.2.1 | 锁继承与释放的语义 | part2/ch03.md | 与释放、的语义、继承、与释、释放、的语 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3 | 使用fcntl()给记录加锁 | part1/ch10.md | fcntl、记录、加锁 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.1 | 死锁 | part0/ch05.md | 死锁 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.3 | 示例：一个加锁函数库 | part1/ch12.md | 一个加锁、一个加、个加锁、个加、加锁、函数 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.4 | 锁的限制和性能 | part0/ch12.md | 的限制、的限、限制、制和 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.5 | 锁继承和释放的语义 | part2/ch13.md | 释放的、的语义、继承、释放、放的、的语 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.3.6 | 锁定饿死和排队加锁请求的优先级 | part3/ch10.md | 的优先级、请求的、的优先、优先级、锁定、排队 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.4 | 强制加锁 | part0/ch04.md | 强制、加锁 |
| weak | K · Kerrisk 系统编程手册 | 55 | 55.7 | 老式加锁技术 | part1/ch07.md | 老式、式加 |
| weak | K · Kerrisk 系统编程手册 | 56 | 56.5 | 流socket | part0/ch01.md | socket |
| weak | K · Kerrisk 系统编程手册 | 56 | 56.5.1 | 监听接入连接：listen() | part0/ch13.md | listen、监听、连接 |
| weak | K · Kerrisk 系统编程手册 | 57 | 57.5 | 创建互联socket 对：socketpair() | part2/ch08.md | socket、socketpair、创建 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.1 | 互联网 | part0/ch13.md | 联网 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.2 | 联网协议和层 | part0/ch13.md | 联网、协议 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.5 | IP 地址 | part0/ch01.md | 地址 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.6.3 | 传输控制协议（TCP） | part1/ch11.md | tcp、制协议、传输、控制、制协、协议 |
| weak | K · Kerrisk 系统编程手册 | 58 | 58.7 | 请求注解（RFC） | part0/ch06.md | rfc |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.10 | 独立于协议的主机和服务转换 | part1/ch19.md | 协议的、的主机、独立、协议、议的、的主 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.10.3 | 错误诊断：gai_strerror() | part1/ch11.md | gai_strerror、错误 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.13 | 过时的主机和服务转换API | part3/ch05.md | api、过时的、过时、时的、的主、主机 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.13.2 | gethostbyname()和gethostbyaddr()函数 | part0/ch01.md | 函数 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.13.3 | getserverbyname()和getserverbyport()函数 | part0/ch01.md | 函数 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.3 | 数据表示 | part0/ch01.md | 数据、表示 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.5 | 主机和服务转换函数概述 | part1/ch11.md | 主机、服务、转换、函数 |
| weak | K · Kerrisk 系统编程手册 | 59 | 59.8 | 域名系统（DNS） | part0/ch13.md | dns、域名、系统 |
| weak | K · Kerrisk 系统编程手册 | 60 | 60.1 | 迭代型和并发型服务器 | part2/ch16.md | 迭代型、服务器、迭代、代型、并发、服务 |
| weak | K · Kerrisk 系统编程手册 | 60 | 60.4 | 并发型服务器的其他设计方案 | part1/ch11.md | 服务器的、服务器、务器的、并发、服务、务器 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.1 | 流式套接字上的部分读和部分写 | part2/ch16.md | 套接字、的部分、部分读、套接、接字、上的 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.11 | 在accept()中继承标记和选项 | part0/ch10.md | 继承标、继承、承标、标记、选项 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.12 | TCP vs.UDP | part0/ch01.md | tcp |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13 | 高级功能 | part0/ch02.md | 高级 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13.4 | 接收发送端的凭据 | part1/ch11.md | 发送端、接收、发送、送端、端的 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13.5 | 顺序数据包套接字 | part0/ch12.md | 套接字、顺序、数据、套接、接字 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.13.6 | SCTP 以及DCCP 传输层协议 | part2/ch17.md | 层协议、传输、输层、层协、协议 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.5 | 获取套接字地址 | part1/ch11.md | 套接字、字地址、套接、接字、字地、地址 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.1 | TCP 报文的格式 | part0/ch01.md | tcp、的格式、的格、格式 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.2 | TCP 序列号和确认机制 | part3/ch12.md | tcp、序列号、序列、列号、确认、机制 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.3 | TCP 协议状态机以及状态迁移图 | part1/ch13.md | 状态迁移、状态机、状态迁、态迁移、协议、状态 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.6.6 | 在TCP 套接字上调用shutdown() | part1/ch11.md | tcp、shutdown、套接字、套接、接字、调用 |
| weak | K · Kerrisk 系统编程手册 | 61 | 61.7 | 监视套接字：netstat | part0/ch12.md | 套接字、套接、接字 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.1 | 整体概览 | part0/ch01.md | 整体、概览 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.2 | 获取和修改终端属性 | part2/ch19.md | 终端属性、终端属、端属性、修改、终端、端属 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.6.3 | 加工模式、cbreak 模式以及原始模式 | part2/ch19.md | cbreak、加工、模式、原始模式、原始模、始模式 |
| weak | K · Kerrisk 系统编程手册 | 62 | 62.7 | 终端线速（比特率） | part2/ch19.md | 终端、线速、特率 |
| weak | K · Kerrisk 系统编程手册 | 63 | 63.1 | 整体概览 | part0/ch01.md | 整体、概览 |
| weak | K · Kerrisk 系统编程手册 | 63 | 63.1.2 | 在备选的I/O 模型中采用非阻塞I/O | part2/ch18.md | i/o、备选的、备选、选的、用非阻塞、用非阻 |
| weak | K · Kerrisk 系统编程手册 | 63 | 63.4.2 | 修改epoll 的兴趣列表：epoll_ctl() | part2/ch18.md | epoll、epoll_ctl、修改、兴趣、列表 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.1 | 整体概览 | part0/ch01.md | 整体、概览 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.1 | 打开未使用的主设备：posix_openpt() | part3/ch02.md | 的主设备、的主设、主设备、打开、用的、的主 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.2 | 修改从设备属主和权限：grantpt() | part2/ch14.md | 和权限、修改、设备、属主、和权、权限 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.3 | 解锁从设备：unlockpt() | part2/ch19.md | unlockpt、解锁、设备 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.2.4 | 获取从设备名称：ptsname() | part2/ch19.md | ptsname、设备名、设备、备名 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.3 | 打开主设备：ptyMasterOpen() | part0/ch03.md | 主设备、打开、主设、设备 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.4 | 将进程连接到伪终端：ptyFork() | part2/ch04.md | 连接到、伪终端、进程、连接、接到、伪终 |
| weak | K · Kerrisk 系统编程手册 | 64 | 64.8 | BSD 风格的伪终端 | part0/ch09.md | bsd、伪终端、风格、伪终、终端 |
| weak | L · 操作系统原理、实现与实践 | 1 | 1 | 系统启动——打开电源以后发生的故事 | part3/ch01.md | 系统启动、系统启、统启动、系统、统启、启动 |
| weak | L · 操作系统原理、实现与实践 | 5 | 5 | 进程同步——让多个进程的推进合理有序 | part1/ch08.md | 进程同、进程、程同、同步、多个进程、个进程的 |
| weak | L · 操作系统原理、实现与实践 | 6 | 6 | 内存管理——给程序执行提供一个舞台 | part3/ch02.md | 内存管理、内存管、存管理、内存、存管、序执行 |
| weak | L · 操作系统原理、实现与实践 | 7 | 7 | 换入/换出——用磁盘和时间换取一个规整虚拟内存 | part1/ch09.md | 换入、换出、虚拟内存、用磁盘、虚拟内、拟内存 |
| weak | N · 深入理解 Linux 网络 | 1 | 1.4 | ⼀些术语 | part2/ch10.md | 术语 |
| weak | N · 深入理解 Linux 网络 | 4 | 4.2 | ⽹络包发送过程总览 | part4/ch02.md | 发送过程、发送过、送过程、包发、发送、送过 |
| weak | N · 深入理解 Linux 网络 | 4 | 4.3 | ⽹卡启动准备 | part4/ch09.md | 卡启动、卡启、启动、准备 |
| weak | N · 深入理解 Linux 网络 | 8 | 8.3.1 | ⼀次关于服务端并发的聊天 | part4/ch10.md | 服务端、端并发、并发的、服务、务端、端并 |
| weak | N · 深入理解 Linux 网络 | 8 | 8.5 | 单机百万并发连接的动⼿实验 | part2/ch16.md | 并发连接、并发连、发连接、连接的、并发、发连 |
| weak | N · 深入理解 Linux 网络 | 9 | 9.5 | 握⼿挥⼿过程优化 | part2/ch01.md | 过程、优化 |
| weak | O · OSTEP | 2 | 2.3 | 并发 | part1/ch01.md | 并发 |
| weak | O · OSTEP | 5 | 5.4 | 为什么这样设计 API | part1/ch17.md | api、为什么这、什么这、为什、么这 |
| weak | O · OSTEP | 5 | 5.5 | 其他 API | part1/ch02.md | api |
| weak | O · OSTEP | 6 | 6.2 | 问题 1：受限制的操作 | part1/ch12.md | 限制的、的操作、限制、制的、的操 |
| weak | O · OSTEP | 6 | 6.4 | 担心并发吗 | part1/ch01.md | 并发 |
| weak | O · OSTEP | 7 | 7.7 | 轮转 | part1/ch13.md | 轮转 |
| weak | O · OSTEP | 8 | 8.1 | MLFQ：基本规则 | part1/ch13.md | mlfq、基本、规则 |
| weak | O · OSTEP | 8 | 8.2 | 尝试 1：如何改变优先级 | part1/ch08.md | 尝试、如何改变、如何改、何改变、何改、改变 |
| weak | O · OSTEP | 8 | 8.4 | 尝试 3：更好的计时方式 | part1/ch04.md | 尝试、更好的、更好、好的、的计 |
| weak | O · OSTEP | 8 | 8.5 | MLFQ 调优及其他问题 | part3/ch05.md | mlfq、调优 |
| weak | O · OSTEP | 8 | 8.6 | MLFQ：小结 | part1/ch13.md | mlfq |
| weak | O · OSTEP | 9 | 9.1 | 基本概念：彩票数表示份额 | part1/ch13.md | 基本、概念、彩票数、彩票、票数、份额 |
| weak | O · OSTEP | 9 | 9.2 | 彩票机制 | part1/ch13.md | 彩票、机制 |
| weak | O · OSTEP | 9 | 9.5 | 如何分配彩票 | part1/ch13.md | 分配、彩票 |
| weak | O · OSTEP | 10 | 10.2 | 别忘了同步 | part1/ch19.md | 忘了、同步 |
| weak | O · OSTEP | 10 | 10.4 | 单队列调度 | part1/ch13.md | 单队列、单队、队列、调度 |
| weak | O · OSTEP | 10 | 10.5 | 多队列调度 | part1/ch06.md | 多队列、多队、队列、调度 |
| weak | O · OSTEP | 13 | 13.1 | 早期系统 | part1/ch04.md | 早期、系统 |
| weak | O · OSTEP | 13 | 13.2 | 多道程序和时分共享 | part1/ch19.md | 多道程序、多道程、道程序、多道、道程、程序 |
| weak | O · OSTEP | 13 | 13.4 | 目标 | part1/ch01.md | 目标 |
| weak | O · OSTEP | 14 | 14.1 | 内存类型 | part1/ch01.md | 内存、类型 |
| weak | O · OSTEP | 14 | 14.5 | 底层操作系统支持 | part1/ch09.md | 操作系统、操作系、作系统、底层、作系、系统 |
| weak | O · OSTEP | 14 | 14.6 | 其他调用 | part1/ch01.md | 调用 |
| weak | O · OSTEP | 15 | 15.1 | 假设 | part1/ch01.md | 假设 |
| weak | O · OSTEP | 16 | 16.2 | 我们引用哪个段 | part1/ch10.md | 用哪个、引用、用哪、哪个 |
| weak | O · OSTEP | 16 | 16.5 | 细粒度与粗粒度的分段 | part1/ch07.md | 细粒度、粗粒度、细粒、粒度、粗粒、的分 |
| weak | O · OSTEP | 17 | 17.1 | 假设 | part1/ch01.md | 假设 |
| weak | O · OSTEP | 18 | 18.1 | 一个简单例子 | part3/ch14.md | 一个简、个简 |
| weak | O · OSTEP | 18 | 18.3 | 列表中究竟有什么 | part3/ch01.md | 有什么、列表、表中、有什 |
| weak | O · OSTEP | 18 | 18.4 | 分页：也很慢 | part1/ch09.md | 分页 |
| weak | O · OSTEP | 18 | 18.5 | 内存追踪 | part1/ch09.md | 内存、追踪 |
| weak | O · OSTEP | 20 | 20.1 | 简单的解决方案：更大的页 | part1/ch09.md | 简单的、简单、单的、解决、方案、更大的 |
| weak | O · OSTEP | 20 | 20.2 | 混合方法：分页和分段 | part1/ch09.md | 分页、和分、分段 |
| weak | O · OSTEP | 20 | 20.4 | 反向页表 | part1/ch09.md | 反向、页表 |
| weak | O · OSTEP | 20 | 20.5 | 将页表交换到磁盘 | part1/ch13.md | 到磁盘、页表、交换、换到、到磁、磁盘 |
| weak | O · OSTEP | 21 | 21.1 | 交换空间 | part1/ch03.md | 交换、空间 |
| weak | O · OSTEP | 21 | 21.3 | 页错误 | part1/ch01.md | 错误 |
| weak | O · OSTEP | 21 | 21.6 | 交换何时真正发生 | part1/ch01.md | 何时真正、何时真、时真正、何时、时真、真正 |
| weak | O · OSTEP | 22 | 22.11 | 抖动 | part1/ch01.md | 抖动 |
| weak | O · OSTEP | 22 | 22.3 | 简单策略：FIFO | part1/ch06.md | fifo、简单、策略 |
| weak | O · OSTEP | 22 | 22.4 | 另一简单策略：随机 | part1/ch06.md | 另一、简单、策略、随机 |
| weak | O · OSTEP | 22 | 22.5 | 利用历史数据：LRU | part1/ch13.md | lru、用历史、利用、用历、数据 |
| weak | O · OSTEP | 22 | 22.7 | 实现基于历史信息的算法 | part1/ch02.md | 信息的、的算法、信息、息的、的算、算法 |
| weak | O · OSTEP | 22 | 22.9 | 考虑脏页 | part1/ch13.md | 考虑、脏页 |
| weak | O · OSTEP | 23 | 23.1 | 背景 | part1/ch01.md | 背景 |
| weak | O · OSTEP | 23 | 23.5 | 其他漂亮的虚拟内存技巧 | part3/ch07.md | 虚拟内存、漂亮的、虚拟内、拟内存、漂亮、亮的 |
| weak | O · OSTEP | 26 | 26.6 | 小结：为什么操作系统课要研究 | part1/ch09.md | 操作系统、操作系、作系统、为什、作系、系统 |
| weak | O · OSTEP | 27 | 27.2 | 线程完成 | part1/ch03.md | 线程、完成 |
| weak | O · OSTEP | 27 | 27.5 | 编译和运行 | part1/ch07.md | 和运行、编译、和运、运行 |
| weak | O · OSTEP | 28 | 28.1 | 锁的基本思想 | part1/ch04.md | 的基本、锁的、的基、基本 |
| weak | O · OSTEP | 28 | 28.10 | 链接的加载和条件式存储指令 | part1/ch07.md | 链接的、的加载、加载和、链接、接的、的加 |
| weak | O · OSTEP | 28 | 28.13 | 简单方法：让出来吧，宝贝 | part1/ch13.md | 简单、让出、出来 |
| weak | O · OSTEP | 28 | 28.14 | 使用队列：休眠替代自旋 | part1/ch12.md | 队列、替代、自旋 |
| weak | O · OSTEP | 28 | 28.15 | 不同操作系统，不同实现 | part3/ch14.md | 不同、系统、不同实现、不同实、同实现、同实 |
| weak | O · OSTEP | 28 | 28.2 | Pthread 锁 | part1/ch03.md | pthread |
| weak | O · OSTEP | 28 | 28.4 | 评价锁 | part1/ch13.md | 评价 |
| weak | O · OSTEP | 28 | 28.5 | 控制中断 | part1/ch04.md | 控制、中断 |
| weak | O · OSTEP | 28 | 28.7 | 实现可用的自旋锁 | part3/ch02.md | 的自旋锁、的自旋、自旋锁、可用、用的、的自 |
| weak | O · OSTEP | 28 | 28.8 | 评价自旋锁 | part1/ch13.md | 自旋锁、评价、自旋、旋锁 |
| weak | O · OSTEP | 29 | 29.1 | 并发计数器 | part1/ch04.md | 计数器、并发、计数、数器 |
| weak | O · OSTEP | 29 | 29.2 | 并发链表 | part1/ch09.md | 并发、链表 |
| weak | O · OSTEP | 29 | 29.3 | 并发队列 | part1/ch04.md | 并发、队列 |
| weak | O · OSTEP | 29 | 29.4 | 并发散列表 | part1/ch04.md | 并发、列表 |
| weak | O · OSTEP | 30 | 30.1 | 定义和程序 | part1/ch01.md | 定义、程序 |
| weak | O · OSTEP | 31 | 31.7 | 如何实现信号量 | part1/ch12.md | 信号量、信号、号量 |
| weak | O · OSTEP | 32 | 32.1 | 有哪些类型的缺陷 | part1/ch14.md | 有哪些、有哪、哪些、类型、型的、的缺 |
| weak | O · OSTEP | 32 | 32.2 | 非死锁缺陷 | part3/ch11.md | 死锁、缺陷 |
| weak | O · OSTEP | 32 | 32.3 | 死锁缺陷 | part3/ch11.md | 死锁、缺陷 |
| weak | O · OSTEP | 33 | 33.3 | 使用 select() | part1/ch08.md | select |
| weak | O · OSTEP | 33 | 33.4 | 为何更简单？无须锁 | part1/ch03.md | 更简单、更简、简单 |
| weak | O · OSTEP | 33 | 33.8 | 什么事情仍然很难 | part3/ch04.md | 仍然很、仍然、然很 |
| weak | O · OSTEP | 36 | 36.1 | 系统架构 | part1/ch01.md | 系统、架构 |
| weak | O · OSTEP | 36 | 36.2 | 标准设备 | part1/ch04.md | 标准、设备 |
| weak | O · OSTEP | 36 | 36.3 | 标准协议 | part1/ch02.md | 标准、协议 |
| weak | O · OSTEP | 36 | 36.4 | 利用中断减少 CPU 开销 | part1/ch04.md | cpu、利用、中断、减少、开销 |
| weak | O · OSTEP | 36 | 36.5 | 利用 DMA 进行更高效的数据 | part1/ch13.md | dma、利用、的数据、更高、高效、的数 |
| weak | O · OSTEP | 36 | 36.6 | 设备交互的方法 | part1/ch02.md | 交互的、交互、互的、的方 |
| weak | O · OSTEP | 36 | 36.9 | 历史记录 | part1/ch01.md | 记录 |
| weak | O · OSTEP | 37 | 37.1 | 接口 | part1/ch03.md | 接口 |
| weak | O · OSTEP | 37 | 37.2 | 基本几何形状 | part1/ch06.md | 基本、几何、形状 |
| weak | O · OSTEP | 37 | 37.5 | 磁盘调度 | part1/ch01.md | 磁盘、调度 |
| weak | O · OSTEP | 38 | 38.2 | 故障模型 | part1/ch12.md | 故障、模型 |
| weak | O · OSTEP | 38 | 38.3 | 如何评估 RAID | part1/ch13.md | raid、评估 |
| weak | O · OSTEP | 38 | 38.6 | RAID 4 级：用校验节省空间 | part1/ch13.md | raid、用校验、省空间、用校、校验、省空 |
| weak | O · OSTEP | 38 | 38.7 | RAID 5 级：旋转奇偶校验 | part1/ch13.md | raid、旋转、校验 |
| weak | O · OSTEP | 38 | 38.9 | 其他有趣的 RAID 问题 | part1/ch13.md | raid |
| weak | O · OSTEP | 39 | 39.15 | 创建并挂载文件系统 | part1/ch13.md | 文件系统、文件系、件系统、创建、挂载、文件 |
| weak | O · OSTEP | 39 | 39.5 | 读取和写入，但不按顺序 | part3/ch01.md | 写入、按顺序、但不、按顺、顺序 |
| weak | O · OSTEP | 39 | 39.6 | 用 fsync()立即写入 | part1/ch01.md | fsync、立即、写入 |
| weak | O · OSTEP | 39 | 39.7 | 文件重命名 | part1/ch03.md | 重命名、文件、重命、命名 |
| weak | O · OSTEP | 39 | 39.8 | 获取文件信息 | part1/ch10.md | 取文件、获取、取文、文件 |
| weak | O · OSTEP | 40 | 40.1 | 思考方式 | part1/ch19.md | 思考 |
| weak | O · OSTEP | 40 | 40.2 | 整体组织 | part1/ch09.md | 整体、组织 |
| weak | O · OSTEP | 40 | 40.3 | 文件组织：inode | part1/ch09.md | inode、文件、组织 |
| weak | O · OSTEP | 40 | 40.4 | 目录组织 | part1/ch13.md | 目录、组织 |
| weak | O · OSTEP | 40 | 40.6 | 访问路径：读取和写入 | part1/ch10.md | 访问、路径、读取、和写、写入 |
| weak | O · OSTEP | 41 | 41.2 | FFS：磁盘意识是解决方案 | part1/ch09.md | ffs、磁盘、解决、方案 |
| weak | O · OSTEP | 41 | 41.5 | 测量文件的局部性 | part1/ch13.md | 文件的、的局部、局部性、文件、件的、的局 |
| weak | O · OSTEP | 41 | 41.7 | 关于 FFS 的其他几件事 | part3/ch02.md | ffs、关于、的其、件事 |
| weak | O · OSTEP | 42 | 42.1 | 一个详细的例子 | part1/ch03.md | 的例子、的例 |
| weak | O · OSTEP | 42 | 42.4 | 解决方案 3：其他方法 | part1/ch09.md | 解决、方案 |
| weak | O · OSTEP | 43 | 43.1 | 按顺序写入磁盘 | part1/ch06.md | 顺序写、顺序、序写、写入、磁盘 |
| weak | O · OSTEP | 43 | 43.10 | 确定块的死活 | part1/ch06.md | 确定、块的 |
| weak | O · OSTEP | 43 | 43.2 | 顺序而高效地写入 | part1/ch06.md | 顺序、地写、写入 |
| weak | O · OSTEP | 43 | 43.3 | 要缓冲多少 | part1/ch11.md | 要缓冲、要缓、缓冲 |
| weak | O · OSTEP | 43 | 43.5 | 通过间接解决方案：inode 映射 | part1/ch13.md | inode、通过、间接、解决、方案、映射 |
| weak | O · OSTEP | 43 | 43.6 | 检查点区域 | part3/ch12.md | 检查点、检查、查点 |
| weak | O · OSTEP | 43 | 43.8 | 目录如何 | part1/ch01.md | 目录 |
| weak | O · OSTEP | 44 | 44.1 | 磁盘故障模式 | part1/ch13.md | 盘故障、磁盘、盘故、故障、模式 |
| weak | O · OSTEP | 44 | 44.2 | 处理潜在的扇区错误 | part3/ch13.md | 的扇区、处理、的扇、扇区、错误 |
| weak | O · OSTEP | 44 | 44.5 | 一个新问题：错误的写入 | part1/ch13.md | 一个新、个新、的写入、错误、的写、写入 |
| weak | O · OSTEP | 44 | 44.7 | 擦净 | part3/ch12.md | 擦净 |
| weak | O · OSTEP | 47 | 47.1 | 通信基础 | part1/ch10.md | 通信 |
| weak | O · OSTEP | 47 | 47.2 | 不可靠的通信层 | part1/ch10.md | 可靠的、不可、可靠、靠的、通信 |
| weak | O · OSTEP | 47 | 47.3 | 可靠的通信层 | part1/ch10.md | 可靠的、可靠、靠的、通信 |
| weak | O · OSTEP | 47 | 47.4 | 通信抽象 | part1/ch01.md | 抽象 |
| weak | O · OSTEP | 48 | 48.11 | 服务器端写缓冲的隐含意义 | part1/ch11.md | 服务器端、服务器、务器端、服务、务器、器端 |
| weak | O · OSTEP | 48 | 48.3 | 关注点：简单快速的服务器崩溃 | part1/ch12.md | 的服务器、的服务、服务器、简单、快速、的服 |
| weak | O · OSTEP | 48 | 48.5 | NFSv2 协议 | part1/ch02.md | 协议 |
| weak | O · OSTEP | 48 | 48.7 | 利用幂等操作处理服务器故障 | part1/ch11.md | 服务器故、服务器、务器故、处理、服务、务器 |
| weak | O · OSTEP | 49 | 49.3 | 改进协议 | part1/ch02.md | 协议 |
| weak | O · OSTEP | 49 | 49.8 | AFS：其他改进 | part1/ch12.md | afs |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.17 | KSM | part1/ch09.md | ksm |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.6 | vmalloc | part1/ch09.md | vmalloc |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.7 | VMA操作 | part1/ch08.md | vma |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.8 | malloc | part1/ch01.md | malloc |
| weak | R · 奔跑吧 Linux 内核 | 2 | 2.9 | mmap | part1/ch01.md | mmap |
| weak | R · 奔跑吧 Linux 内核 | 4 | 4.2 | spinlock | part1/ch12.md | spinlock |
| weak | R · 奔跑吧 Linux 内核 | 4 | 4.6 | RCU | part1/ch09.md | rcu |
| weak | R · 奔跑吧 Linux 内核 | 6 | 6.2 | ftrace | part3/ch01.md | ftrace |
| weak | R · 奔跑吧 Linux 内核 | 6 | 6.3 | SystemTap | part3/ch01.md | systemtap |
| weak | S · Linux 命令行大全 | 2 | 2 | 导航 | part0/ch02.md | 导航 |
| weak | S · Linux 命令行大全 | 4 | 4 | 操作文件和目录 | part0/ch12.md | 和目录、文件、件和、和目、目录 |
| weak | S · Linux 命令行大全 | 5 | 5 | 和命令打交道 | part0/ch12.md | 打交道、命令、打交、交道 |
| weak | S · Linux 命令行大全 | 9 | 9 | 权限 | part0/ch01.md | 权限 |
| weak | S · Linux 命令行大全 | 10 | 10 | 进程 | part0/ch01.md | 进程 |
| weak | S · Linux 命令行大全 | 11 | 11 | 环境 | part0/ch01.md | 环境 |
| weak | S · Linux 命令行大全 | 16 | 16 | 联网 | part0/ch13.md | 联网 |
| weak | S · Linux 命令行大全 | 18 | 18 | 归档与备份 | part0/ch01.md | 归档、备份 |
| weak | S · Linux 命令行大全 | 22 | 22 | 打印 | part0/ch01.md | 打印 |
| weak | S · Linux 命令行大全 | 26 | 26 | 自顶向下设计 | part0/ch02.md | 向下 |
| weak | S · Linux 命令行大全 | 28 | 28 | 读取键盘输入 | part0/ch02.md | 读取、键盘、输入 |
| weak | S · Linux 命令行大全 | 35 | 35 | 数组 | part0/ch03.md | 数组 |
