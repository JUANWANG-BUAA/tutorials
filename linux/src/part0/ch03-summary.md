# 0.3 章末总结

## 五单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、目录树与路径**（0.3.1–0.3.2） | 文件放在哪？路径怎样变成文件？ | FHS 按用途分 `/etc`、`/var`、`/run`、`/usr`；usrmerge 后 `/bin` 是 `/usr/bin` 的链接。路径按段解析，`.`/`..`/符号链接/挂载点都参与。 | 把 `..` 当“上一层目录”而不看符号链接；忽略末尾 `/` 的语义；在脚本里依赖相对路径。 |
| **二、看清一个文件**（0.3.3–0.3.5） | `ls -l` 每一列是什么？链接与复制删除有什么边界？ | `ls -l` 给 mode、链接数、owner/group、size、mtime、name；`stat` 给 inode、块数、atime/mtime/ctime。硬链接共享 inode，软链接独立 inode 存目标路径。 | 把链接数当“子目录数”；把 `ls` 的 size 当磁盘占用；`cp` 不保留权限/时间；`mv` 跨文件系统不是原子。 |
| **三、找、批量、看占用**（0.3.6–0.3.9） | 怎样找文件、批量处理、看谁占空间？ | `find` 按表达式筛，`-print0` + `xargs -0` 处理任意文件名；`du` 看块占用，`ls` 看 apparent size；FHS 的写入规则由挂载与权限决定。 | `find` 表达式优先级写错；文件名有空格/换行时用 `xargs` 不加 `-0`；`du` 与 `ls` 对不上就以为有 bug。 |
| **四、从路径到 inode**（0.3.10–0.3.18） | 内核里到底发生了什么？ | 路径解析经过 dentry 与 mount；`stat` 字段由 inode/文件系统维护；`renameat2` 支持 `NOREPLACE`/`EXCHANGE`；`chattr +i` 让文件不可删；`rsync --delete` 会删目标端多余文件。 | 以为 `rm` 会清零数据；以为跨文件系统 `mv` 原子；以为 `cp -r` 保留硬链接；忽略 `--delete` 的方向。 |
| **五、取证与脚本**（0.3.19–0.3.21） | 怎样证明“是哪个文件/哪个调用”？ | `strace` 能看到 `openat`/`readlink`/`renameat2`/`unlink`；inode 与 `lsof` 能解释“删了还占空间”；安全脚本默认 dry-run、拒绝危险根目录。 | 直接 `rm -rf` 不试运行；不看 `lsof +L1`；不检查 `realpath` 与危险路径。 |

## 一条主线

这一章分两遍。**第一遍先会用**：把目录树与路径走通，用 `ls`/`stat` 看清文件，用链接与 `cp`/`mv`/`rm` 操作文件，用 `find`/`xargs`/`du` 做批量与占用分析。**第二遍看内核与边界**：路径解析经过 dentry 与 mount，inode 存元数据与数据块位置，`stat` 字段有各自的维护者，`find` 表达式有优先级，`xargs -0` 解决文件名分隔问题，`xattr`/`chattr` 改的是文件系统属性，`cp`/`rsync`/`tar` 与 `mv`/`renameat2`/`rm` 各有原子性与跨文件系统边界。**最后用 `strace` 取证、三个脚本与陷阱清单收口。**

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| `ls` 明明有文件却打不开 | `namei -l <path>`、`readlink -f` | 可能是路径中某一级权限、符号链接或挂载点问题。 |
| `du` 与 `ls -l` 对不上 | `ls -ls`、`du -h --apparent-size` | `ls` 看 apparent size，`du` 看块占用；稀疏文件与硬链接会造成差异。 |
| 磁盘满了但 `du` 很小 | `lsof +L1`、`df -h` | 已删除但仍被进程打开的文件还占着块。 |
| `rm` 删不掉 | `lsattr`、`lsof <file>`、`id` | 可能是 immutable 属性、目录权限、文件被占用或只读挂载。 |
| `find` 结果多了一堆 | 给表达式加括号，先 `-print` 试运行 | `find` 有隐式 AND、OR、NOT 与动作顺序。 |
| 文件名带空格，批量脚本出错 | `find ... -print0 \| xargs -0 ...` | 默认按空白分词；NUL 分隔才安全。 |
| `mv` 跨文件系统很慢/不原子 | 用 `rsync`/`tar` 复制再删源 | 跨文件系统 `mv` 是 copy + unlink，不是 rename。 |
| `df -i` 满了但空间还有 | 找小文件/大量 inode 的目录 | inode 耗尽与块耗尽是两种“磁盘满”。 |
| `cp` 后权限/时间变了 | `cp -a` 或 `cp -p` | 默认受 umask 影响，不保留所有元数据。 |
| 复制后硬链接关系丢了 | `cp -a`、`rsync -H`、`tar --hard-dereference` | 默认复制会展开硬链接。 |

## 能否讲出这八句话

1. 目录是「名字 → inode 号」的映射；inode 存元数据与数据块位置；dentry 是内核里的目录项缓存。
2. 硬链接共享同一个 inode，链接数加一；软链接是独立 inode，内容为目标路径，目标可以不存在。
3. `ls -l` 的 size 是 apparent size，`du` 是占用的块；稀疏文件与硬链接会让两者不一致。
4. `cp` 默认不保留所有元数据；`cp -a` 保留权限/时间/链接；`mv` 同文件系统是 rename，跨文件系统是 copy + unlink。
5. `rm` 是 unlink；被打开的文件仍占空间，直到最后一个 fd 关闭；`lsof +L1` 能找到它们。
6. `find` 表达式有隐式 AND、`-o`、`!` 与括号；动作（`-delete`/`-exec`）的顺序会影响结果。
7. 文件名可以含空格/换行，批量处理用 `-print0` + `xargs -0`，不要用默认按空白分词。
8. `renameat2` 支持 `RENAME_NOREPLACE`/`RENAME_EXCHANGE`；跨文件系统不能原子 rename；`chattr +i` 让文件不可删。

## 学完之后

1. **[闭卷回忆卡](ch03-recall.md)**：先合上正文，把 inode/链接、`ls`/`stat`、`find`/`xargs`、`cp`/`mv`/`rm` 四组结论从空白纸上叫出来。
2. **[习题集](ch03-exercises.md)**：A 组检查概念，B 组诊断“为什么删不掉/对不上/复制错”，C 组做 inode、稀疏文件、find/xargs、strace 实验。
3. **[学习目标自检表](ch03-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch03-errata.md)**：把 GNU coreutils、findutils、rsync 的版本差异过一遍。
5. **下一站**：[0.4 权限与安全模型](ch04.md) 会解释 `ls -l` 的 mode 列、ACL、umask 与 capability；本章的权限边界会在那里补齐。
