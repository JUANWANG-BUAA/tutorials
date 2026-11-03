# 0.6 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 三种方言

BRE、ERE、PCRE 的 `+`、`{}`、`()` 写法差在哪？`grep`、`grep -E`、`grep -P` 各用哪个？

::: sol 解答

BRE 里 `+`、`{}`、`()` 默认是普通字符，要写成 `\+`、`\{m,n\}`、`\(...\)`；ERE 直接写 `+`、`{m,n}`、`(...)`；PCRE 在 ERE 基础上加 `\d`、`\w`、环视、懒惰量词。`grep` 默认 BRE，`grep -E` 用 ERE，`grep -P` 用 PCRE（GNU）。不要把一个方言的写法直接塞进另一个方言。

:::
:::

::: ex A2 · 语法骨架

`^`、`$`、`[^abc]`、`*`、`+`、`?`、`{2,4}`、`(...)`、`\1` 各做什么？贪婪与懒惰量词差在哪？

::: sol 解答

`^`/`$` 锚定行首/行尾；`[^abc]` 排除集合；`*` 0+、`+` 1+、`?` 0/1、`{2,4}` 2–4 次；`(...)` 分组并捕获，`\1` 反向引用第 1 组。贪婪量词尽量多匹配，懒惰（PCRE 的 `*?`/`+?`）尽量少匹配；不同引擎对贪婪/回溯的实现不同。

:::
:::

::: ex A3 · grep 选项与退出码

`grep` 的 `-E`/`-F`/`-P`/`-r`/`-n`/`-c`/`-v`/`-o`/`-q` 各做什么？退出码 0/1/2 分别表示什么？

::: sol 解答

`-E` ERE，`-F` 固定字符串，`-P` PCRE，`-r` 递归，`-n` 行号，`-c` 计数，`-v` 反向，`-o` 只输出匹配，`-q` 静默。退出码：0 有匹配，1 无匹配，2 出错。脚本里 `grep -q` 常用来判断“有没有匹配”，不要把 1 当错误。

:::
:::

::: ex A4 · sed 模型

sed 的「模式空间 + 地址 + 命令」是什么？`-n`、`p`、`d`、`s///g`、`-i` 各做什么？

::: sol 解答

sed 逐行读入模式空间，按地址（行号/正则）选命令执行，默认输出模式空间。`-n` 关闭默认输出；`p` 打印；`d` 删除并进入下一轮；`s/old/new/g` 全局替换；`-i` 原地编辑（临时文件 + rename）。`sed -n '2,4p'` 只打印 2–4 行；`sed '/^#/d'` 删注释行。

:::
:::

::: ex A5 · hold space

hold space 是什么？`h/H/g/G/x` 各做什么？写出「倒序输出」的 sed 思路。

::: sol 解答

hold space 是 sed 的第二个缓冲区，初始为空。`h` 用模式空间覆盖 hold；`H` 追加；`g` 用 hold 覆盖模式空间；`G` 追加；`x` 交换。倒序：`sed -n '1!G;h;$p'`——每行把 hold 追加到模式空间，再把模式空间存回 hold，最后打印，得到倒序。

:::
:::

::: ex A6 · awk 模型

awk 的记录、字段、`FS/OFS/RS/ORS`、`NR/FNR/NF`、`BEGIN/END` 各是什么？怎样按 `:` 取 `/etc/passwd` 的用户名？

::: sol 解答

每行是记录 `$0`；按 `FS` 切字段 `$1..$NF`；`OFS` 输出分隔符，`RS`/`ORS` 输入/输出记录分隔符；`NR` 总记录号，`FNR` 当前文件记录号，`NF` 字段数；`BEGIN` 读取前执行，`END` 结束后执行。`awk -F: '{print $1}' /etc/passwd` 取用户名。

:::
:::

::: ex A7 · 三者怎么选

grep、sed、awk 各最适合什么任务？各给一个不该用它的例子。

::: sol 解答

grep 筛行/计数/找模式；sed 按行替换/删除/插入/流编辑；awk 按字段统计/报表/数组。反例：用 grep 做替换（应 sed）；用 sed 做列求和（应 awk）；用 awk 只筛行（grep 更直接）。选择标准是数据形状：行、流、字段。

:::
:::

::: ex A8 · 工具链

`sort`、`uniq`、`cut`、`tr`、`paste`、`join`、`diff` 各做什么？`uniq` 为什么通常要先 `sort`？

::: sol 解答

`sort` 排序（`-n` 数值、`-k` 键、`-u` 去重）；`uniq` 去重/计数（`-c`），只处理相邻重复行，所以先 `sort`；`cut` 取列（`-d`/`-f`）；`tr` 字符替换/删除/压缩；`paste` 按行合并；`join` 按共同键连接；`diff` 比较差异（`-u` 统一格式）。`sort | uniq -c` 是统计频次的标准组合。

:::
:::

## B 组 · 诊断推理

::: ex B1 · 统计 5xx Top 10

写一条管道：统计 `access.log` 里每个 IP 的 5xx 次数，按次数降序取前 10。说明每段在做什么。

::: sol 解答

```bash
awk '$9 ~ /^5/ {c[$1]++} END {for (ip in c) print c[ip], ip}' access.log \
  | sort -rn | head -10
```

`awk` 用 `$9` 匹配 5xx、用数组 `c` 按 `$1`（IP）计数；`END` 输出「次数 IP」；`sort -rn` 按数值降序；`head -10` 取前 10。若日志格式不同，先 `awk '{print NF}'` 或 `head -1` 确认字段位置，不要假设 `$9` 永远是状态码。

:::
:::

::: ex B2 · 批量改名

把当前目录所有 `*.jpeg` 改成 `*.jpg`，写出安全步骤；文件名可能带空格。

::: sol 解答

先试运行：

```bash
find . -maxdepth 1 -name '*.jpeg' -print
find . -maxdepth 1 -name '*.jpeg' -print0 | while IFS= read -r -d '' f; do
    printf 'mv -- %q %q\n' "$f" "${f%.jpeg}.jpg"
done
```

确认无误后把 `printf` 换成 `mv -n -- "$f" "${f%.jpeg}.jpg"`。用 `-print0` + `read -d ''` 处理空格/换行；`mv -n` 防覆盖；先备份或先 `cp`。不要用 `for f in $(ls)`。

:::
:::

::: ex B3 · 灾难性回溯

为什么 `(a+)+b` 在长串 `aaaa...` 上可能很慢？给出两种修复方向。

::: sol 解答

回溯引擎在嵌套量词 + 失败匹配时会尝试大量组合，`(a+)+b` 对长串 `a` 可能指数级。修复：① 简化正则，去掉嵌套量词（如 `a+b`）；② 用 `grep -F`（如果只是固定串）或 `LC_ALL=C` 减少开销；③ 限制输入长度/超时；④ 用不支持回溯的引擎（如 RE2/ripgrep 的默认引擎）做预筛。不要在生产脚本里对不可信输入跑复杂回溯正则。

:::
:::

::: ex B4 · `sed -i` 断硬链接

`sed -i 's/a/b/' file` 后，`file` 的硬链接 `file.hard` 内容没变。为什么？怎样保持 inode？

::: sol 解答

GNU sed `-i` 写临时文件再 rename，`file` 的 inode 变了；`file.hard` 仍指向旧 inode，所以内容不变。保持 inode：`sed 's/a/b/' file > tmp && cat tmp > file`（写回原 inode），或接受断链并用 `sed -i.bak` 留备份。先 `ls -li`/`stat` 对比 inode、链接数。

:::
:::

::: ex B5 · awk 浮点

`awk 'BEGIN { printf "%.2f %.2f %d %d\n", 1.005, 2.675, 3.9, -3.9 }'` 输出什么？为什么金额要用整数分？

::: sol 解答

输出可能是 `1.00 2.67 3 -3`（具体取决于 awk/浮点实现）。`%.2f` 按二进制浮点舍入，`1.005` 不能精确表示；`%d` 向零截断，`3.9→3`、`-3.9→-3`。金额用整数分（`amount_cents`）做加减，最后再格式化为元，避免浮点累加误差。

:::
:::

::: ex B6 · locale

`LC_ALL=C` 为什么通常更快？locale 会影响哪些行为？`[a-z]` 在 UTF-8 locale 下一定只匹配 26 个字母吗？

::: sol 解答

`LC_ALL=C` 用字节/ASCII 排序与字符类，少了多字节处理与 collation，通常更快。locale 影响排序、字符类、大小写、日期/数字格式。`[a-z]` 在 UTF-8 locale 下可能受 collation 影响，范围不一定是严格 ASCII 26 个字母；需要严格字节范围时用 `LC_ALL=C`。`sort` 的排序结果也会随 locale 变化。

:::
:::

## C 组 · 动手实验

::: ex C1 · 三种工具各做一件事

用 `grep` 找出 `/etc/passwd` 里 UID ≥ 1000 的行，用 `sed` 把 shell 为 `/bin/bash` 的行打印出来，用 `awk` 打印用户名与 UID。

::: sol 解答

```bash
awk -F: '$3 >= 1000 {print}' /etc/passwd          # grep 也能做，但 awk 按字段更稳
sed -n '/:\/bin\/bash$/p' /etc/passwd
awk -F: '{print $1, $3}' /etc/passwd
```

`grep` 适合纯文本模式，但 UID 是字段比较，`awk -F:` 更可靠；`sed -n '/pattern/p'` 只打印匹配行；`awk` 用 `-F:` 切字段。验收：三条命令的输出能对上同一个用户。

:::
:::

::: ex C2 · 日志统计

生成 1000 行模拟日志，用 awk + sort + uniq 统计每个状态码的次数，并取 Top 3。

::: sol 解答

```bash
python3 - <<'PY' > /tmp/access.log
import random
random.seed(1)
for i in range(1000):
    print(f"10.0.0.{i%10} GET /p/{i%20} {random.choice([200,200,200,301,404,500])}")
PY
awk '{c[$4]++} END {for (s in c) print c[s], s}' /tmp/access.log | sort -rn | head -3
```

`awk` 按 `$4`（状态码）计数，`END` 输出；`sort -rn` 数值降序；`head -3` 取前三。先 `head -1` 确认字段位置；真实日志的字段可能不同。

:::
:::

::: ex C3 · 批量改名 dry-run

创建 `a.jpeg`、`b.jpeg`、`c d.jpeg`，用 `find -print0` + `read -d ''` 做 dry-run，再真正改名。

::: sol 解答

```bash
mkdir -p /tmp/rename && cd /tmp/rename
touch a.jpeg b.jpeg 'c d.jpeg'
find . -maxdepth 1 -name '*.jpeg' -print0 | while IFS= read -r -d '' f; do
    printf 'mv -- %q %q\n' "$f" "${f%.jpeg}.jpg"
done
```

确认输出后，把 `printf` 换成 `mv -n -- "$f" "${f%.jpeg}.jpg"`。`%q` 让空格可见；`-print0`/`-d ''` 处理任意文件名；`mv -n` 防覆盖。验收：`ls *.jpg` 看到三个文件，`c d.jpg` 完整。

:::
:::

::: ex C4 · sed hold space 倒序

用 sed 把文件行倒序输出，并解释 `1!G;h;$p` 的执行过程。

::: sol 解答

```bash
printf 'a\nb\nc\n' | sed -n '1!G;h;$p'
# c
# b
# a
```

`1!G`：除第一行外，把 hold 追加到模式空间；`h`：把模式空间存回 hold；`$p`：最后一行打印。第一行时 hold 为空，`h` 存 `a`；第二行 `G` 得 `b\na`，`h` 存；第三行 `G` 得 `c\nb\na`，`$p` 打印。`-n` 关闭默认输出。

:::
:::

::: ex C5 · awk 报表

用 awk 读 `/etc/passwd`，输出「UID ≥ 1000 的用户名、UID、shell」，按 UID 数值排序。

::: sol 解答

```bash
awk -F: '$3 >= 1000 {print $1, $3, $7}' /etc/passwd | sort -k2 -n
```

`-F:` 按冒号切字段；`$3 >= 1000` 过滤普通用户；`print $1,$3,$7` 输出用户名/UID/shell；`sort -k2 -n` 按第 2 列数值排序。验收：与 `getent passwd` 对比几个用户；注意不同发行版的 UID 起点可能不同。

:::
:::
