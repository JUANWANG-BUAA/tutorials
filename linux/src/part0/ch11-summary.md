# 0.11 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、包与 apt**（0.11.1–0.11.2） | `.deb` 里有什么？apt 怎样选版本？ | `.deb` 是 ar 归档：`control.tar`（control/维护者脚本/md5sums/conffiles）+ `data.tar`（文件树）。apt 读源、求解依赖、按 pin 优先级选版本。 | 只看包名不看版本；`apt install` 不 `-s` 预演；pin 写错锁死版本。 |
| **二、编译与链接**（0.11.3–0.11.6） | 源码怎样装？静态/共享库怎样工作？链接错误怎么查？ | `prefix` 定安装前缀，`DESTDIR` 做暂存；静态 `.a` 编进可执行，共享 `.so` 运行时加载；`soname` 是 ABI 名字；链接错误分编译期/链接期/运行期。 | `make install` 直接污染 `/usr/local`；`-l` 顺序错；`LD_LIBRARY_PATH` 当万能。 |
| **三、打包与镜像**（0.11.7–0.11.8） | 镜像里有什么？dpkg 状态机怎样？ | 镜像 = rootfs + 元数据 + 层；运行时依赖要齐。dpkg 有 not-installed/config-files/half-installed/unpacked/half-configured/installed 等状态，维护者脚本在关键点执行。 | 镜像只拷二进制不带库；`dpkg` 半配置不修；维护者脚本失败。 |
| **四、ABI 与求解器**（0.11.9–0.11.10） | 为什么换机器跑不了？ | apt 求解器按版本/依赖/pin 选包；符号版本、`soname`、`rpath`/`runpath`、interpreter 决定二进制能否加载；`patchelf` 可改 rpath/interpreter（有风险）。 | 只升 soname 不重编；`patchelf` 破坏签名/校验；ABI 不兼容当“小版本升级”。 |
| **五、实验与脚本**（0.11.11–0.11.16） | 怎样证明/对账？ | 包/库/构建三条巡检；自建 deb、soname 断裂、`pkg-config`/`ldd`/`readelf` 对账；`debian/` 目录做依赖闭合。 | 不 `-s` 预演；不 `readelf` 对账；不写 `debian/control` 依赖。 |

## 一条主线

这一章从“装包”走到“跑不起来”。**先看 `.deb` 与 apt**：control/data、依赖、pin、求解器；**再学源码构建与链接**：`prefix`/`DESTDIR`、静态/共享库、`soname`、链接错误、`pkg-config`/CMake；**然后打包容器镜像、看 `dpkg` 状态机**；**第二遍看 apt 求解器、符号版本/ABI/`patchelf`**。最后用巡检脚本、自建 deb/soname 实验、加载器审计、`debian/` 目录与陷阱清单收口。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| `apt install` 装的版本不对 | `apt-cache policy <pkg>`、`apt install -s` | 看候选版本/源/pin；先预演。 |
| 编译找不到头文件 | `pkg-config --cflags <lib>`、`apt-file search` | 头文件路径/开发包；`-dev` 包。 |
| 链接 `undefined reference` | 检查 `-l` 顺序、`pkg-config --libs`、`nm -D` | 链接器从左到右解析；库顺序错会找不到符号。 |
| 运行 `undefined symbol` | `readelf --dyn-syms`、`objdump -T`、`ldd` | 运行期符号版本/库版本不匹配。 |
| 运行 `not found` | `readelf -l` 看 interpreter、`ldd` | 动态加载器/库路径不存在。 |
| 想查文件属于哪个包 | `dpkg -S /path` | 文件所有权。 |
| 想查包装了哪些文件 | `dpkg -L <pkg>` | 包文件清单。 |
| dpkg 半配置/依赖断裂 | `dpkg --configure -a`、`apt -f install` | 修复状态机/依赖。 |
| 镜像太大 | 多阶段构建/static/distroless | 只带运行时依赖。 |
| 换机器 ABI 不兼容 | `readelf -V`/`ldd`、在目标环境构建 | glibc/符号版本/架构。 |

## 能否讲出这八句话

1. `.deb` 是 ar 归档：`control.tar` 放 control/维护者脚本/md5sums/conffiles，`data.tar` 放文件树。
2. apt 读源、求解依赖、按 pin 优先级选版本；`apt-cache policy` 看候选，`apt install -s` 预演。
3. `prefix` 定安装前缀，`DESTDIR` 做暂存安装；`make install` 前先想清楚装到哪。
4. 静态库 `.a` 编进可执行；共享库 `.so` 运行时加载；`soname` 是 ABI 名字，`ldconfig` 维护缓存。
5. 链接错误分编译期（头文件）、链接期（`undefined reference`）、运行期（`undefined symbol`/`not found`）；`-l` 顺序重要。
6. `dpkg` 有半安装/半配置等状态；维护者脚本在 preinst/postinst/prerm/postrm 执行；`dpkg -S` 查文件归属。
7. 符号版本/`soname`/`rpath`/interpreter 决定二进制能否加载；`patchelf` 可改但有风险。
8. 镜像 = rootfs + 元数据 + 层；运行时依赖要齐；多阶段/static/distroless 可减小体积。

## 学完之后

1. **[闭卷回忆卡](ch11-recall.md)**：先合上正文，把 deb、apt、prefix/DESTDIR、soname、链接错误、dpkg 状态六组结论从空白纸上叫出来。
2. **[习题集](ch11-exercises.md)**：A 组检查概念，B 组诊断“为什么装不上/链接不上/跑不起来”，C 组做自建 deb、soname、`readelf` 对账实验。
3. **[学习目标自检表](ch11-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch11-errata.md)**：把 dpkg/apt、glibc/符号版本、`patchelf` 的版本差异过一遍。
5. **下一站**：[0.12 systemd、启动、日志与定时任务](ch12.md) 会从软件供应链转到服务管理；本章的包/镜像会在那里接到 unit 与启动。
