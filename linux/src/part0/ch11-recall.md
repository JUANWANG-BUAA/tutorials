# 0.11 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · `.deb` 里有什么

`.deb` 是什么格式？`control.tar` 与 `data.tar` 各放什么？`Depends`/`Provides`/`Conflicts` 是什么？

::: sol D1 核对

`.deb` 是 ar 归档，含 `debian-binary`、`control.tar.*`、`data.tar.*`。`control.tar` 放 `control`（包名/版本/架构/Depends/Description）、维护者脚本（preinst/postinst/prerm/postrm）、`md5sums`、`conffiles`；`data.tar` 放实际文件树（`/usr/bin`、`/usr/lib`、文档等）。`Depends` 是运行依赖，`Provides` 是虚拟包/替代，`Conflicts` 是冲突。
:::

### D2 · apt 的源、pin 与求解器

apt 从哪里读源？pinning 是什么？`apt-cache policy`/`apt install -s` 各做什么？

::: sol D2 核对

源在 `/etc/apt/sources.list`/`/etc/apt/sources.list.d/*.sources`；`apt update` 刷新索引。pinning 在 `/etc/apt/preferences.d/`，按源/版本设优先级，决定装哪个版本。`apt-cache policy <pkg>` 看已装/候选/各源版本与 pin；`apt install -s` 只预演，不实际安装。`apt-mark hold` 锁版本。
:::

### D3 · `prefix` 与 `DESTDIR`

`./configure --prefix=/usr/local` 与 `make DESTDIR=/tmp/pkg install` 各做什么？为什么打包时用 `DESTDIR`？

::: sol D3 核对

`prefix` 是安装前缀（程序运行时找资源的根，如 `/usr/local`）；`DESTDIR` 是“暂存根”，把文件装到 `$DESTDIR$prefix`，不污染真实系统，便于打包/检查文件清单。打包时 `DESTDIR=/tmp/pkg` 收集文件，再打成 deb；不要直接 `make install` 到 `/usr/local`。
:::

### D4 · 静态库、共享库与 soname

`.a` 与 `.so` 有什么区别？`soname` 是什么？`ldconfig` 做什么？

::: sol D4 核对

`.a` 是静态库，链接时被复制进可执行；`.so` 是共享库，运行时由动态加载器加载。`soname` 是共享库的 ABI 名字（如 `libfoo.so.1`），程序链接时记录 soname；`ldconfig` 维护 `/etc/ld.so.cache` 与符号链接。`readelf -d libfoo.so` 看 soname/依赖；`ldd` 看运行时依赖（注意它会执行 loader）。
:::

### D5 · 链接错误的三层

`undefined reference`、`undefined symbol`、`not found` 各发生在哪一期？`-l` 顺序为什么重要？

::: sol D5 核对

`undefined reference` 在链接期：目标文件/库没提供符号，常见 `-l` 顺序错（链接器从左到右解析，库要放在使用它的对象之后）、缺 `-L`/`pkg-config --libs`。`undefined symbol` 在运行期：加载的库版本不对/符号版本不匹配。`not found` 在运行期：interpreter 或依赖库路径不存在（`readelf -l` 看 interpreter，`ldd` 看依赖）。
:::

### D6 · `pkg-config` 与 CMake

`pkg-config --cflags/--libs` 做什么？`.pc` 文件在哪？CMake 怎样找库？

::: sol D6 核对

`pkg-config --cflags foo` 给头文件路径/宏，`--libs foo` 给 `-L`/`-l`；`.pc` 在 `/usr/lib/pkgconfig`、`/usr/share/pkgconfig`，`PKG_CONFIG_PATH` 可加路径。CMake 用 `find_package`/`pkg_check_modules`；找不到时看 `CMAKE_PREFIX_PATH`/`PKG_CONFIG_PATH`。`pkg-config --modversion` 看版本。
:::

## B. 第二遍：打包、ABI 与边界

### D7 · 容器镜像

容器镜像由什么组成？为什么“只拷二进制”经常跑不起来？多阶段构建解决什么？

::: sol D7 核对

镜像 = rootfs（文件系统）+ 元数据（entrypoint/cmd/env）+ 层（每层是文件变更）。只拷二进制缺共享库、interpreter、CA 证书、locale、时区、用户等，运行时会 `not found`/`undefined symbol`。多阶段构建在 builder 阶段编译，在 runtime 阶段只拷二进制+运行时依赖，减小体积/攻击面；static/distroless 更彻底。
:::

### D8 · dpkg 状态机与文件所有权

dpkg 有哪些状态？维护者脚本在什么时候跑？`dpkg -S`/`dpkg -L` 各做什么？

::: sol D8 核对

状态：not-installed、config-files、half-installed、unpacked、half-configured、triggers-pending、triggers-awaited、installed。维护者脚本：preinst（解包前）、postinst（配置后）、prerm（删除前）、postrm（删除后）。`dpkg -S /path` 查文件属于哪个包；`dpkg -L pkg` 列包内文件；`dpkg -l` 看状态；`dpkg --configure -a` 修复半配置。
:::

### D9 · 符号版本与 ABI

符号版本是什么？为什么“小版本升级”可能破坏 ABI？`patchelf` 能做什么、有什么风险？

::: sol D9 核对

符号版本是共享库给符号打的版本标签（如 `memcpy@GLIBC_2.14`），程序链接时记录所需版本；库升级若删/改符号版本，运行期会 `undefined symbol`。ABI 包括函数签名/结构布局/调用约定/符号版本，不保证向后兼容的“小版本”也会破坏。`patchelf --set-rpath`/`--set-interpreter` 改 ELF 的 rpath/interpreter；风险是破坏签名/校验、路径不可移植，优先在构建期设 rpath。
:::

### D10 · apt 求解器与 pin

apt 怎样决定装哪个版本？pin 优先级怎样覆盖？`apt-mark hold` 做什么？

::: sol D10 核对

apt 读源索引，按包名/架构/版本/依赖求解，考虑 pin 优先级（`/etc/apt/preferences.d`）与已装版本。pin 可把某源/版本设为高/低优先级，甚至禁止；`apt-cache policy` 看候选与 pin。`apt-mark hold` 锁住包版本，防止自动升级；`apt-mark unhold` 解锁。求解失败看 `apt install -s` 的依赖链。
:::

### D11 · 巡检脚本

包/库/构建三条巡检各查什么？`readelf`/`ldd`/`pkg-config` 怎样对账？

::: sol D11 核对

包巡检：`dpkg -l` 半配置/残留、`dpkg -S` 文件归属、`apt-cache policy` 版本/pin；库巡检：`ldd`/`readelf -d` 缺失依赖、soname、rpath；构建巡检：`pkg-config --modversion`、`readelf -V` 符号版本、`file` 架构。`ldd` 会执行 loader，来源不明的二进制用 `readelf -d`/`objdump -p`。
:::

### D12 · 包/库/镜像陷阱

任选四个陷阱，说出“现象 → 原因 → 修复”。

::: sol D12 核对

示例：① `apt install` 后仍 `undefined symbol`——库版本/符号版本不匹配，`readelf --dyn-syms`/`ldd`；② `not found` 但文件在——interpreter/依赖路径缺失，`readelf -l`/`patchelf`/装运行时；③ 镜像大——多阶段/static/distroless；④ dpkg 半配置——`dpkg --configure -a`/`apt -f install`；⑤ `-l` 顺序错——把库放对象后/用 `pkg-config --libs`；⑥ `patchelf` 后校验失败——构建期设 rpath，别改已签名二进制。
:::
