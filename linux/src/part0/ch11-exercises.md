# 0.11 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机/容器里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · `.deb` 里有什么

`.deb` 是什么格式？`control.tar` 与 `data.tar` 各放什么？`Depends`/`Provides`/`Conflicts` 是什么？

::: sol 解答

`.deb` 是 ar 归档，含 `debian-binary`、`control.tar.*`、`data.tar.*`。`control.tar` 放 `control`（包名/版本/架构/Depends/Description）、维护者脚本、`md5sums`、`conffiles`；`data.tar` 放文件树。`Depends` 运行依赖，`Provides` 虚拟包/替代，`Conflicts` 冲突。

:::
:::

::: ex A2 · apt 源、pin 与求解器

apt 从哪里读源？pinning 是什么？`apt-cache policy`/`apt install -s` 各做什么？

::: sol 解答

源在 `/etc/apt/sources.list`/`sources.list.d/*.sources`；`apt update` 刷新索引。pinning 在 `/etc/apt/preferences.d/`，按源/版本设优先级。`apt-cache policy <pkg>` 看已装/候选/各源版本；`apt install -s` 预演不安装；`apt-mark hold` 锁版本。

:::
:::

::: ex A3 · `prefix` 与 `DESTDIR`

`./configure --prefix=/usr/local` 与 `make DESTDIR=/tmp/pkg install` 各做什么？为什么打包用 `DESTDIR`？

::: sol 解答

`prefix` 是安装前缀；`DESTDIR` 是暂存根，把文件装到 `$DESTDIR$prefix`，不污染系统，便于打包/检查清单。打包时 `DESTDIR=/tmp/pkg` 收集文件，再打成 deb；不要直接 `make install` 到 `/usr/local`。

:::
:::

::: ex A4 · 静态库、共享库与 soname

`.a` 与 `.so` 有什么区别？`soname` 是什么？`ldconfig` 做什么？

::: sol 解答

`.a` 静态库链接时复制进可执行；`.so` 共享库运行时加载。`soname` 是共享库的 ABI 名字（如 `libfoo.so.1`），程序链接时记录它；`ldconfig` 维护 `/etc/ld.so.cache` 与符号链接。`readelf -d` 看 soname/依赖；`ldd` 看运行时依赖（会执行 loader）。

:::
:::

::: ex A5 · 链接错误的三层

`undefined reference`、`undefined symbol`、`not found` 各发生在哪一期？`-l` 顺序为什么重要？

::: sol 解答

`undefined reference` 在链接期：目标/库没提供符号，常见 `-l` 顺序错（库放对象后）、缺 `-L`/`pkg-config --libs`。`undefined symbol` 在运行期：库版本/符号版本不匹配。`not found` 在运行期：interpreter/依赖路径不存在（`readelf -l`、`ldd`）。

:::
:::

::: ex A6 · `pkg-config` 与 CMake

`pkg-config --cflags/--libs` 做什么？`.pc` 在哪？CMake 怎样找库？

::: sol 解答

`pkg-config --cflags foo` 给头文件路径/宏，`--libs foo` 给 `-L`/`-l`；`.pc` 在 `/usr/lib/pkgconfig`、`/usr/share/pkgconfig`，`PKG_CONFIG_PATH` 可加。CMake 用 `find_package`/`pkg_check_modules`；找不到看 `CMAKE_PREFIX_PATH`/`PKG_CONFIG_PATH`；`--modversion` 看版本。

:::
:::

::: ex A7 · 容器镜像

容器镜像由什么组成？为什么“只拷二进制”经常跑不起来？多阶段构建解决什么？

::: sol 解答

镜像 = rootfs + 元数据（entrypoint/cmd/env）+ 层。只拷二进制缺共享库、interpreter、CA 证书、locale、时区、用户等，运行时会 `not found`/`undefined symbol`。多阶段构建在 builder 编译，runtime 只拷二进制+依赖，减小体积/攻击面；static/distroless 更彻底。

:::
:::

::: ex A8 · dpkg 状态与文件所有权

dpkg 有哪些状态？维护者脚本在什么时候跑？`dpkg -S`/`dpkg -L` 各做什么？

::: sol 解答

状态：not-installed、config-files、half-installed、unpacked、half-configured、triggers-pending、triggers-awaited、installed。维护者脚本：preinst/postinst/prerm/postrm。`dpkg -S /path` 查文件属于哪个包；`dpkg -L pkg` 列包内文件；`dpkg -l` 看状态；`dpkg --configure -a` 修复半配置。

:::
:::

## B 组 · 诊断推理

::: ex B1 · apt 装的版本不对

`apt install foo` 装的版本比预期旧。列出至少三种原因与验证命令。

::: sol B1 核对

① 源里没有新版本/源没更新：`apt update`、`apt-cache policy foo`；② pin 优先级低/被 hold：`/etc/apt/preferences.d`、`apt-mark showhold`；③ 依赖冲突阻止升级：`apt install -s foo` 看求解；④ 包名/架构不对：`apt-cache search`、`dpkg --print-architecture`。用 `apt-cache madison foo` 看各源版本。

:::
:::

::: ex B2 · `undefined reference`

链接报 `undefined reference to 'foo'`，但 `libfoo.a` 已存在。列出至少三种原因与修法。

::: sol B2 核对

① `-lfoo` 放在使用它的对象之前（链接器从左到右）；② 缺 `-L` 路径；③ 库名/架构不对（`libfoo.a` vs `libfoo.so`）；④ C++ 名字修饰（`extern "C"`）；⑤ 符号在另一个库。修法：把 `-lfoo` 放最后/用 `pkg-config --libs`、检查 `nm -g libfoo.a | grep foo`、`file` 架构。

:::
:::

::: ex B3 · `undefined symbol`

运行报 `undefined symbol: foo`，但 `ldd` 显示库都在。为什么？怎样查？

::: sol B3 核对

库在但符号版本/ABI 不匹配（库升级删/改了符号），或加载了错误路径的库。查：`readelf --dyn-syms`/`objdump -T` 看符号版本；`ldd` 看实际加载路径；`LD_DEBUG=libs` 看搜索过程；对比构建环境与运行环境的库版本。修法：装匹配版本、重建、设 rpath/容器固定依赖。

:::
:::

::: ex B4 · `not found` 但文件在

执行二进制报 `not found`，`ls` 能看到文件。为什么？怎样查？

::: sol B4 核对

`not found` 通常不是文件不存在，而是 interpreter/依赖库不存在（如 `/lib64/ld-linux-x86-64.so.2`）。查：`file`/`readelf -l` 看 interpreter；`ldd`；`readelf -d` 看 NEEDED；`ls` 对应路径。修法：装兼容库/用 musl 重编/静态链接/容器固定 rootfs；`patchelf --set-interpreter` 有风险。

:::
:::

::: ex B5 · dpkg 半配置

`dpkg -l` 显示 `iF`/`iU`，`apt install` 报依赖断裂。怎样修？

::: sol B5 核对

`iF` 半配置、`iU` 半安装。先 `dpkg --configure -a`；再 `apt -f install` 修依赖；看 `/var/log/dpkg.log` 与报错；必要时 `dpkg --remove --force-remove-reinstreq`（谨慎）。修前备份/快照；不要直接删 `/var/lib/dpkg/status`。

:::
:::

::: ex B6 · `patchelf` 与 ABI

`patchelf --set-rpath` 后程序能跑，但换机器又不行；或签名校验失败。为什么？怎样做更稳？

::: sol B6 核对

`patchelf` 改 ELF 的 rpath/interpreter，路径是机器相关的；换机器路径不存在就失败；改已签名/校验的二进制会破坏签名。更稳：构建期设 rpath（`-Wl,-rpath,$ORIGIN/../lib`）、用容器固定 rootfs、静态链接、把库放标准路径。改前备份，`readelf -d` 验证。

:::
:::

## C 组 · 动手实验

::: ex C1 · 拆一个 deb

用 `dpkg-deb -c/-I` 或 `ar` 拆一个 `.deb`，看 control、维护者脚本、文件树。

::: sol C1 核对

```bash
apt download hello
dpkg-deb -I hello_*.deb
dpkg-deb -c hello_*.deb | head
mkdir /tmp/deb && cd /tmp/deb && ar x /path/hello_*.deb && ls
tar -tf control.tar.* | head
tar -tf data.tar.* | head
```

`-I` 看 control/脚本；`-c` 列文件树；`ar x` 拆出 control/data；`tar -tf` 看内容。验收：能说出包名/版本/依赖/装了哪些文件。

:::
:::

::: ex C2 · `DESTDIR` 暂存安装

编译一个小项目，用 `DESTDIR=/tmp/pkg make install`，检查文件都在 `/tmp/pkg` 下，不污染系统。

::: sol C2 核对

```bash
./configure --prefix=/usr/local
make
make DESTDIR=/tmp/pkg install
find /tmp/pkg -type f | head
```

`DESTDIR` 把 `prefix` 放到暂存根下；`find` 检查文件；确认 `/usr/local` 没被写。打包时把 `/tmp/pkg` 打成 deb/tar；`DESTDIR` 不改变程序运行时前缀。

:::
:::

::: ex C3 · soname 实验

编一个共享库 `libfoo.so.1`，链接一个程序，删掉 soname 链接/换版本，观察 `ldd`/运行结果。

::: sol C3 核对

```bash
cc -fPIC -shared -Wl,-soname,libfoo.so.1 -o libfoo.so.1 foo.c
ln -s libfoo.so.1 libfoo.so
cc main.c -L. -lfoo -Wl,-rpath,'$ORIGIN' -o main
./main
readelf -d libfoo.so.1 | grep SONAME
ldd ./main
```

删 soname/换不兼容版本后，运行可能 `undefined symbol`/`not found`；`readelf -d` 看 NEEDED/SONAME/RPATH；`ldd` 看加载路径。实验用临时目录，别动系统库。

:::
:::

::: ex C4 · 加载器审计

对一个二进制跑 `file`、`readelf -l`、`readelf -d`、`ldd`、`objdump -T`，列出 interpreter、NEEDED、RPATH/RUNPATH、依赖库。

::: sol C4 核对

```bash
file ./app
readelf -l ./app | grep -A1 INTERP
readelf -d ./app | grep -E 'NEEDED|RPATH|RUNPATH|SONAME'
ldd ./app
objdump -T ./app | grep foo
```

`readelf -l` 看 interpreter；`-d` 看 NEEDED/RPATH/RUNPATH；`ldd` 看实际解析（会执行 loader，来源不明用 `readelf`）；`objdump -T` 看动态符号。验收：能说出缺哪个库/路径对不对。

:::
:::

::: ex C5 · 最小 deb 或镜像

用 `debian/` 目录或 `dpkg-deb -b` 做一个最小 deb；或写一个多阶段 Dockerfile，只带运行时依赖。

::: sol C5 核对

最小 deb：

```bash
mkdir -p pkg/DEBIAN pkg/usr/bin
printf '#!/bin/sh\necho hi\n' > pkg/usr/bin/hi && chmod +x pkg/usr/bin/hi
cat > pkg/DEBIAN/control <<'EOF'
Package: hi
Version: 0.1
Architecture: all
Maintainer: you <you@example.com>
Description: minimal hi
EOF
dpkg-deb -b pkg hi_0.1_all.deb
sudo dpkg -i hi_0.1_all.deb
```

多阶段 Dockerfile：

```dockerfile
FROM gcc:13 AS build
COPY . /src
RUN cc -O2 -o /out/app /src/main.c
FROM debian:12-slim
COPY --from=build /out/app /usr/local/bin/app
ENTRYPOINT ["/usr/local/bin/app"]
```

关键：control 字段/依赖；镜像只拷运行时；`dpkg -c`/`docker run` 验证。生产还要签名/测试/依赖闭合。

:::
:::
