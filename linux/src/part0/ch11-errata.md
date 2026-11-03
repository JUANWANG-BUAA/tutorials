# 0.11 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与包/库/镜像陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换发行版、换 glibc、换工具链后要复核什么**。

**本章基线**：Ubuntu 24.04、glibc 2.39、dpkg 1.22、apt 2.8、binutils 2.42、patchelf 0.18。换环境时逐条复核。

## 1. 包与 apt

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `.deb` 是普通 tar | 是 ar 归档，含 control.tar/data.tar/debian-binary | `ar t pkg.deb`、`dpkg-deb -c/-I` |
| 2 | `apt install` 会先更新索引 | 不会；要先 `apt update` | `apt-cache policy pkg` |
| 3 | pin 只影响“装不装” | 影响候选版本/优先级，可能锁死版本 | `/etc/apt/preferences.d`、`apt-cache policy` |
| 4 | `apt install` 直接装就行 | 先 `-s` 预演，看依赖/版本/删除 | `apt install -s pkg` |
| 5 | `apt-mark hold` 是永久锁 | 可 `unhold`；升级/重装可能绕过 | `apt-mark showhold` |
| 6 | 源里版本越多越好 | 多源/pin 冲突会让求解器选错/失败 | `apt-cache madison pkg` |

## 2. 编译、链接与库

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | `prefix` 与 `DESTDIR` 一样 | `prefix` 是运行时前缀；`DESTDIR` 是打包暂存根 | `make DESTDIR=/tmp/pkg install` |
| 8 | `-lfoo` 放哪都行 | 链接器从左到右；库要放使用它的对象之后 | 调换顺序对比 |
| 9 | `ldd` 只是看依赖 | 它会执行 loader；来源不明用 `readelf -d`/`objdump -p` | `ldd` vs `readelf -d` |
| 10 | soname 就是文件名 | soname 是 ABI 名字（`libfoo.so.1`），文件名可不同 | `readelf -d libfoo.so` |
| 11 | `ldconfig` 会找所有路径 | 只读配置/标准路径，维护 cache；自定义路径要 `-rpath`/配置 | `ldconfig -p`、`/etc/ld.so.conf.d` |
| 12 | `LD_LIBRARY_PATH` 万能 | 会被 setuid/安全模式忽略；优先修 rpath/安装路径 | 对比 setuid 程序 |
| 13 | `undefined reference` 与 `undefined symbol` 一样 | 前者链接期，后者运行期 | 看报错阶段/`readelf --dyn-syms` |

## 3. 运行、镜像与 ABI

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 14 | `not found` 是文件不存在 | 多是 interpreter/依赖库不存在 | `file`、`readelf -l`、`ldd` |
| 15 | glibc 向后兼容所有旧二进制 | 符号版本/ABI 可能变；旧二进制在新 glibc 通常可跑，反向不行 | 在目标环境构建/测试 |
| 16 | 小版本升级不会破坏 ABI | ABI 包括结构布局/符号版本；不保证 | `readelf -V`、ABI 检查工具 |
| 17 | `patchelf` 改完就能跑 | 路径机器相关/可能破坏签名；优先构建期 rpath | `readelf -d`、校验签名 |
| 18 | 镜像只拷二进制就够 | 缺共享库/interpreter/证书/locale/用户 | `docker run`、`ldd`、`readelf -l` |
| 19 | 镜像越小越好 | 要平衡调试/证书/时区/安全更新 | 多阶段/static/distroless 取舍 |
| 20 | `dpkg -l` 的 `ii` 就万事大吉 | 还要看依赖/文件冲突/维护者脚本/半配置 | `dpkg -l`、`dpkg -S`、`apt -f install` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的发行版/glibc 上使用前先验证：

- glibc 的符号版本/ABI 依版本；在旧系统构建的二进制通常能在新系统跑，反向不保证。
- `apt` 的 pin/求解器行为依版本与源配置；`apt-cache policy`/`-s` 为准。
- `patchelf` 对已签名/已校验二进制可能破坏签名；生产优先构建期设置。
- 容器镜像的运行时依赖依基础镜像（debian/alpine/distroless）；`ldd` 在 musl 上不适用。
- `dpkg` 维护者脚本失败会留半配置；修复前备份 `/var/lib/dpkg/status`。

## 5. 发现新问题怎么记

如果你在别的发行版/glibc 上发现本章结论不成立，按「现象 → 命令/输出 → 版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
