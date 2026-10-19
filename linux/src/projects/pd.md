# 项目 D · 工具链主线：POSIX Shell · BusyBox · Git 对象库

<div class="chapter-index">
<div><span class="ci-label">项目目标</span><p>用 C17 写出三个互相咬合的工具：一个能执行管道、重定向与内建命令的 Shell <code>mysh</code>；一套共享 applet 框架的类 BusyBox 工具集 <code>mybox</code>；一个与真 Git 互操作的对象库 <code>mygit</code>。三者分别对应「进程与 fd」「系统调用与选项解析」「内容寻址存储」三条主线。</p></div>
<div><span class="ci-label">完成后你能</span><p>解释 Shell 的展开顺序与 <code>fork</code>/<code>exec</code>/<code>wait</code> 的协作；写出带 <code>O_CLOEXEC</code>、<code>dup2</code>、管道与作业控制的命令解释器；用统一 applet 表实现 10 个工具；实现 Git 的 blob/tree/commit 对象与 index，并让真 <code>git</code> 读得懂你的仓库。</p></div>
</div>

工具链是系统知识的「压缩包」：Shell 把进程、fd、信号、管道压进一个交互界面；BusyBox 把文件、目录、权限、选项解析压进一组小工具；Git 把内容寻址、哈希、压缩、索引压进一个对象库。它们都不大，但每一个都要求你对系统调用边界非常清楚。

这一页按三条子线组织，每条线独立可做，最后在 D.4 拼成一个演示。

## D.0 总览与选做路线 {#sec-d.0}

### D.0.1 三个子项目的关系 {#sec-d.0.1}

```text
mysh ──fork/exec/wait──▶ mybox（ls/cat/grep…）
  │                         │
  └──pipe/dup2/信号          └──open/read/write/stat/getdents
                              │
mygit ──内容寻址对象───────▶ .git/objects（zlib + SHA-1）
```

- `mysh` 负责「把一行文本变成进程图」；
- `mybox` 负责「一个进程如何用最小系统调用完成一件事」；
- `mygit` 负责「如何把文件内容变成可校验、可寻址的对象」。

### D.0.2 前置章节与回看时机 {#sec-d.0.2}

| 子项目 | 前置 | 卡住时回看 |
|:--|:--|:--|
| `mysh` | 0.5 重定向/管道、0.7–0.8 Bash、2.7–2.10 进程/信号 | 2.19 作业控制、2.10 信号 |
| `mybox` | 0.3 文件、2.2–2.6 文件 I/O/目录、0.11 编译 | 2.5 `stat`、2.6 `readdir` |
| `mygit` | 1.7 链接、2.2–2.3 文件 I/O、1.2 哈希/字节 | 2.3 `mmap`、0.11 静态库 |

### D.0.3 难度、投入与裁剪 {#sec-d.0.3}

| 子项目 | 难度 | 投入 | 最小可交付 | 可裁剪 |
|:--|:--|:--|:--|:--|
| `mysh` | ★★★★ | 30–40 h | 管道、重定向、内建、外部命令、`&&`/`;` | 作业控制、通配符、命令替换 |
| `mybox` | ★★★ | 20–30 h | 10 个 applet、统一选项解析 | `find` 的高级表达式 |
| `mygit` | ★★★★ | 30–40 h | blob/tree/commit、index、`add/commit/log/checkout` | packfile、merge、远程 |

### D.0.4 目录与构建基线 {#sec-d.0.4}

```text
toolchain/
├── Makefile
├── include/
│   ├── util.h
│   └── sh.h
├── src/
│   ├── sh/lexer.c  sh/parse.c  sh/exec.c  sh/builtin.c
│   ├── box/applet.c  box/ls.c  box/cat.c  box/cp.c …
│   └── git/object.c  git/index.c  git/commit.c
└── tests/
    ├── sh/*.sh
    └── run.sh
```

统一编译：

```makefile
CC      ?= cc
CFLAGS  ?= -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g
BIN     := build/mysh build/mybox build/mygit
SRCS    := $(wildcard src/*/*.c)
OBJS    := $(SRCS:src/%.c=build/%.o)

all: $(BIN)
build/mysh: $(filter build/sh/%,$(OBJS))
	@mkdir -p $(dir $@); $(CC) $(CFLAGS) -o $@ $^
build/mybox: $(filter build/box/%,$(OBJS))
	@mkdir -p $(dir $@); $(CC) $(CFLAGS) -o $@ $^
build/mygit: $(filter build/git/%,$(OBJS))
	@mkdir -p $(dir $@); $(CC) $(CFLAGS) -o $@ $^ -lz
build/%.o: src/%.c
	@mkdir -p $(dir $@); $(CC) $(CFLAGS) -c -o $@ $<
clean:
	rm -rf build
.PHONY: all clean
```

## D.1 `mysh`：把一行文本变成进程图 {#sec-d.1}

### D.1.1 目标与真实对应物 {#sec-d.1.1}

对应 `dash`/`bash` 的最小核：读入、分词、展开、建进程、等待。**不追求 POSIX 全兼容**，追求「语义正确、错误路径清楚」。

### D.1.2 架构：五步流水线 {#sec-d.1.2}

```text
readline → lexer（token）→ parser（命令/管道/重定向）
        → expand（变量/引号/通配符）→ execute（fork/dup2/exec/wait）
```

先做「无展开、无管道」的 Stage 0，再逐步加。每一步都能单独测试。

### D.1.3 Stage 0：读入、分词与内建命令 {#sec-d.1.3}

**目标**：能执行 `echo hi`、`cd /tmp`、`exit 3`，并能把外部命令交给 `execvp`。

```c
/* src/sh/lexer.c — 极简分词：按空白切分，支持单/双引号，不处理转义 */
#include "sh.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

static void push_word(struct wordlist *wl, char *s)
{
    wl->v = realloc(wl->v, sizeof(char *) * (wl->n + 1));
    if (!wl->v) { perror("realloc"); exit(1); }
    wl->v[wl->n++] = s;
}

int lex_line(const char *line, struct wordlist *wl)
{
    const char *p = line;
    while (*p) {
        while (*p && isspace((unsigned char)*p)) p++;
        if (!*p) break;
        char quote = 0;
        if (*p == '\'' || *p == '"') quote = *p++;
        const char *word_start = p;
        while (*p && (quote ? *p != quote : !isspace((unsigned char)*p))) p++;
        size_t n = (size_t)(p - word_start);
        char *w = malloc(n + 1);
        if (!w) { perror("malloc"); return -1; }
        memcpy(w, word_start, n);
        w[n] = '\0';
        if (quote && *p == quote) p++;
        push_word(wl, w);
    }
    return 0;
}
```

执行器：

```c
/* src/sh/exec.c — 内建优先，否则 fork+execvp+waitpid */
#include "sh.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int run_builtin(struct wordlist *wl)
{
    if (!strcmp(wl->v[0], "exit")) exit(wl->n > 1 ? atoi(wl->v[1]) : 0);
    if (!strcmp(wl->v[0], "cd")) {
        const char *dir = wl->n > 1 ? wl->v[1] : getenv("HOME");
        if (chdir(dir) == -1) { perror("cd"); return 1; }
        return 0;
    }
    if (!strcmp(wl->v[0], "echo")) {
        for (size_t i = 1; i < wl->n; i++)
            printf("%s%s", wl->v[i], i + 1 < wl->n ? " " : "");
        putchar('\n');
        return 0;
    }
    return -1;   /* 不是内建 */
}

int run_external(struct wordlist *wl)
{
    pid_t pid = fork();
    if (pid == -1) { perror("fork"); return 1; }
    if (pid == 0) {
        execvp(wl->v[0], wl->v);
        fprintf(stderr, "mysh: %s: %s\n", wl->v[0], strerror(errno));
        _exit(127);
    }
    int st;
    while (waitpid(pid, &st, 0) == -1)
        if (errno != EINTR) { perror("waitpid"); return 1; }
    return WIFEXITED(st) ? WEXITSTATUS(st) : 128 + WTERMSIG(st);
}
```

主循环：

```c
/* src/sh/main.c */
#include "sh.h"
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    char *line = NULL;
    size_t cap = 0;
    for (;;) {
        fputs("mysh> ", stdout);
        fflush(stdout);
        ssize_t n = getline(&line, &cap, stdin);
        if (n == -1) break;
        if (n && line[n - 1] == '\n') line[n - 1] = '\0';
        struct wordlist wl = {0};
        if (lex_line(line, &wl) == -1) continue;
        if (wl.n == 0) { free(wl.v); continue; }
        int rc = run_builtin(&wl);
        if (rc == -1) rc = run_external(&wl);
        for (size_t i = 0; i < wl.n; i++) free(wl.v[i]);
        free(wl.v);
        (void)rc;
    }
    free(line);
    return 0;
}
```

**验证**：

```bash
make
./build/mysh
mysh> echo hi
hi
mysh> cd /tmp
mysh> pwd
/tmp
mysh> /bin/false; echo $?
1
mysh> nosuchcmd
mysh: nosuchcmd: No such file or directory
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `execvp: No such file or directory` | `PATH` 没继承或被清空 | `execvp` 用 `environ`；检查 `getenv("PATH")` |
| 内建 `cd` 不生效 | 在子进程里执行了 `chdir` | 内建必须在父进程执行 |
| 命令执行后 Shell 退出 | 子进程 `return` 到了主循环 | 子进程用 `_exit(127)` |
| 引号内的空格被拆开 | 分词器没处理引号 | Stage 0 先支持单/双引号 |
| `waitpid: Interrupted system call` | 没处理 `EINTR` | 循环重试 |

**下一步**：Stage 1 加变量与展开；Stage 2 加管道与重定向。管道的关键是 `pipe2(O_CLOEXEC)` + `dup2` + 关闭所有副本，顺序错了会死锁。

::: intuition 为什么先写「没有管道」的 Shell
因为管道、重定向、作业控制都会改变 fd 表。先有一个能跑单条命令的基线，后面每加一个机制，你都能用 `strace -f -e trace=dup2,pipe2,close` 看到 fd 表的变化。没有基线，出问题时分不清是解析错了还是 fd 错了。
:::

**母本对应**：

| 母本 | 章节 | 本书落点 | 程度 |
|:--|:--|:--|:--|
| K | 第 24–27 章（fork/exec/wait） | D.1.3 | 完整 |
| K | 第 44 章（管道/FIFO） | D.1 Stage 2 | 完整 |
| Shotts | 第 5–6 章（命令、重定向） | D.1.3 | 精选 |
| shell-book | 第 5、11–13 章（Shell/脚本） | D.1 | 背景 |

### D.1.4 Stage 1：变量与展开 {#sec-d.1.4}

**目标**：让 Shell 认识 `$NAME`、`${NAME}`、`$?`、`$$`，并能区分单引号与双引号。

```bash
./build/mysh
mysh> NAME=world
mysh> echo "hello $NAME"
hello world
mysh> echo 'hello $NAME'
hello $NAME
mysh> echo ${NAME}s
worlds
mysh> false
mysh> echo $?
1
```

验收点：

1. `NAME=value` 不产生输出，但对后续命令可见；
2. 双引号内展开，单引号内原样；
3. `${NAME}s` 能切出变量名边界（`$NAMEs` 找的是变量 `NAMEs`，结果为空）；
4. `$?` 是上一条命令的退出码，`$$` 是 Shell 自身 pid；
5. `X="a b"; echo $X` 输出两列，`echo "$X"` 输出一列（字段分割）。

**关键概念：展开发生在分词之后、执行之前。** 顺序错了，`"$X"` 与 `$X` 就分不开——分词阶段一旦把引号丢掉，后面再也无法判断某个空格是不是「引号里的空格」。所以本 Stage 把分词拆成两步：

```text
原始行 ──lex_raw──▶ 原始词（引号字符仍在）──expand_word──▶ 字段列表 ──▶ argv
```

`expand_word` 一边去引号一边展开，同时决定要不要按空白切分。这是 Shell 里最容易被写错的一段状态机。

**代码：`src/sh/expand.c`（完整）**

```c
/* 变量展开与字段分割。输入是保留引号的原始词，输出是最终字段。 */
#define _POSIX_C_SOURCE 200809L
#include "sh.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct buf { char *p; size_t len, cap; };

static int buf_init(struct buf *b)
{
    b->cap = 32; b->len = 0;
    b->p = malloc(b->cap);
    if (!b->p) return -1;
    b->p[0] = '\0';
    return 0;
}

static int buf_putc(struct buf *b, char c)
{
    if (b->len + 2 > b->cap) {
        size_t nc = b->cap * 2;
        char *np = realloc(b->p, nc);
        if (!np) return -1;
        b->p = np; b->cap = nc;
    }
    b->p[b->len++] = c;
    b->p[b->len] = '\0';
    return 0;
}

static void buf_free(struct buf *b) { free(b->p); b->p = NULL; b->len = b->cap = 0; }

static void wl_push(struct wordlist *wl, char *s)
{
    char **nv = realloc(wl->v, sizeof(char *) * (wl->n + 1));
    if (!nv) { free(s); perror("realloc"); exit(1); }
    wl->v = nv;
    wl->v[wl->n++] = s;
}

void wl_free(struct wordlist *wl)
{
    for (size_t i = 0; i < wl->n; i++) free(wl->v[i]);
    free(wl->v);
    wl->v = NULL; wl->n = 0;
}

static int is_name_start(int c) { return isalpha(c) || c == '_'; }
static int is_name_char(int c)  { return isalnum(c) || c == '_'; }

/* 读取 $NAME / ${NAME} / $? / $$，成功返回消耗字节数，0 表示不是可识别变量 */
static size_t read_var(const char *p, char **out, int last_status)
{
    if (*p != '$') return 0;
    p++;

    if (*p == '{') {
        const char *start = ++p;
        while (*p && *p != '}') p++;
        if (*p != '}') return 0;
        char *name = strndup(start, (size_t)(p - start));
        if (!name) return 0;
        const char *v = getenv(name);
        free(name);
        *out = strdup(v ? v : "");
        return (size_t)(p - start) + 3;
    }
    if (*p == '?') {
        char t[16];
        snprintf(t, sizeof t, "%d", last_status);
        *out = strdup(t);
        return 2;
    }
    if (*p == '$') {
        char t[32];
        snprintf(t, sizeof t, "%ld", (long)getpid());
        *out = strdup(t);
        return 2;
    }
    if (!is_name_start((unsigned char)*p)) {
        *out = strdup("$");          /* 不认识的 $，原样保留 */
        return 1;
    }
    const char *start = p;
    while (is_name_char((unsigned char)*p)) p++;
    char *name = strndup(start, (size_t)(p - start));
    if (!name) return 0;
    const char *v = getenv(name);
    free(name);
    *out = strdup(v ? v : "");
    return (size_t)(p - start) + 1;
}

/* 字段收集器：未加引号的空白是分隔符，引号内的空白是普通字符 */
struct sink {
    struct wordlist *out;
    struct buf cur;
    int started;        /* 当前字段是否已有内容 */
    int had_quote;      /* 当前字段是否含引号内容（决定空字段是否保留） */
};

static int sink_flush(struct sink *s)
{
    if (!s->started) return 0;
    char *w = strdup(s->cur.p);
    if (!w) return -1;
    wl_push(s->out, w);
    s->cur.len = 0;
    s->cur.p[0] = '\0';
    s->started = 0;
    s->had_quote = 0;
    return 0;
}

static int sink_put(struct sink *s, const char *text, int quoted)
{
    for (const char *p = text; *p; p++) {
        if (!quoted && (*p == ' ' || *p == '\t')) {
            if (sink_flush(s) < 0) return -1;
            continue;
        }
        if (buf_putc(&s->cur, *p) < 0) return -1;
        s->started = 1;
        if (quoted) s->had_quote = 1;
    }
    return 0;
}

/* 展开一个原始词（可能含引号），把结果字段追加到 out。
 * 返回 0 成功，-1 语法/内存错误。 */
int expand_word(const char *raw, int last_status, struct wordlist *out)
{
    struct sink s;
    s.out = out;
    s.started = 0;
    s.had_quote = 0;
    if (buf_init(&s.cur) < 0) return -1;

    int in_single = 0, in_double = 0;
    const char *p = raw;

    while (*p) {
        if (in_single) {
            if (*p == '\'') { in_single = 0; p++; }
            else { if (sink_put(&s, (char[]){*p, 0}, 0) < 0) goto fail; p++; }
            continue;
        }
        if (in_double) {
            if (*p == '"') { in_double = 0; p++; continue; }
            if (*p == '\\' && p[1]) { if (sink_put(&s, (char[]){p[1], 0}, 1) < 0) goto fail; p += 2; continue; }
            if (*p == '$') {
                char *v = NULL;
                size_t n = read_var(p, &v, last_status);
                if (n == 0) { if (sink_put(&s, "$", 1) < 0) goto fail; p++; continue; }
                if (!v) goto fail;
                if (sink_put(&s, v, 1) < 0) { free(v); goto fail; }
                free(v);
                p += n;
                continue;
            }
            if (sink_put(&s, (char[]){*p, 0}, 1) < 0) goto fail;
            p++;
            continue;
        }

        if (*p == '\'') {
            in_single = 1;
            s.started = 1; s.had_quote = 1;   /* '' 也应产生一个空字段 */
            p++;
        } else if (*p == '"') {
            in_double = 1;
            s.started = 1; s.had_quote = 1;
            p++;
        } else if (*p == '\\') {
            if (p[1]) { if (sink_put(&s, (char[]){p[1], 0}, 1) < 0) goto fail; p += 2; }
            else p++;
        } else if (*p == '$') {
            char *v = NULL;
            size_t n = read_var(p, &v, last_status);
            if (n == 0) { if (sink_put(&s, "$", 0) < 0) goto fail; p++; continue; }
            if (!v) goto fail;
            if (sink_put(&s, v, 0) < 0) { free(v); goto fail; }
            free(v);
            p += n;
        } else {
            if (sink_put(&s, (char[]){*p, 0}, 0) < 0) goto fail;
            p++;
        }
    }

    if (in_single || in_double) {
        fprintf(stderr, "mysh: syntax error: unmatched %s\n",
                in_single ? "'" : "\"");
        goto fail;
    }
    if (sink_flush(&s) < 0) goto fail;
    buf_free(&s.cur);
    return 0;

fail:
    buf_free(&s.cur);
    return -1;
}
```

`sh.h` 里补上声明：

```c
struct wordlist { char **v; size_t n; };
int  expand_word(const char *raw, int last_status, struct wordlist *out);
void wl_free(struct wordlist *wl);
```

**验证**：

```bash
make
NAME=demo ./build/mysh <<'EOF'
NAME=world
echo "hello $NAME"
echo 'hello $NAME'
echo ${NAME}s
false
echo $?
X="a b"
printf '<%s>\n' $X
printf '<%s>\n' "$X"
EOF
```

预期：

```text
hello world
hello $NAME
worlds
1
<a>
<b>
<a b>
```

注意 `printf` 在这里是外部命令（`/usr/bin/printf`），所以 `$X` 的字段分割由我们的 `expand_word` 完成，不是 `printf` 做的。若去掉 `printf` 改用 `echo`，你会看到 `<a> <b>` 与 `<a b>` 的差别被 `echo` 的单空格连接掩盖——这也是为什么验证字段分割要用 `printf`。

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `echo "$X"` 仍被拆成多个参数 | 引号状态没传给 `expand_word`，原始词里引号已被丢弃 | 分词阶段保留引号字符，展开阶段再消费 |
| `$EMPTY` 产生一个空参数 | 把空展开也 `sink_flush` 了 | 未加引号的空展开不产生字段；只有 `""` 才产生空字段 |
| `echo $?` 第二次总是 0 | `last_status` 在 `echo` 之后被更新 | 每条命令执行完才更新状态，展开用的是**上一条**的码 |
| `echo ${NAME` 崩溃 | `read_var` 未闭合时返回 0，却没回退指针 | 返回 0 时按普通字符消费一个 `$` |
| `$$` 与 `$?` 输出成父进程值 | 用了缓存或 `getppid` | `$$` 每次展开时取 `getpid()` |

**下一步**：Stage 2 引入真正的语法结构——管道与重定向。分词职责会从 `expand.c` 移到 `parse.c`，因为 `|`、`>` 必须在展开**之前**被识别，否则 `X='>'` 会被当成重定向。

### D.1.5 Stage 2：管道与重定向 {#sec-d.1.5}

**目标**：支持 `|`、`>`、`>>`、`<`、`2>`、`2>&1`、`&`。

```bash
./build/mysh
mysh> echo hello > /tmp/a.txt
mysh> cat /tmp/a.txt
hello
mysh> echo world >> /tmp/a.txt
mysh> wc -l < /tmp/a.txt
2
mysh> ls /nonexistent 2>/tmp/e.txt
mysh> wc -l < /tmp/e.txt
1
mysh> ls /nonexistent 2>&1 | wc -l
1
mysh> yes | head -n 3
y
y
y
```

最后一条不会挂住，是本节最重要的验收：**管道两端的所有 fd 副本都要关对**。

**关键概念：fd 表是一张进程私有的小表。** `pipe2` 返回两个 fd（读端、写端），`fork` 后父子各有一份副本。写端只要还有**任何**副本开着，读端就永远等不到 EOF。因此：

1. 子进程 `dup2` 之后必须 `close` 原始 fd（`dup2` 不关闭源）；
2. 父进程 `fork` 完立即关掉自己那份读端/写端；
3. 下一个命令的读端在 `dup2` 之后也要关。

顺序错了不会报错，只会「卡住」。用 `strace -f -e trace=pipe2,dup2,close ./build/mysh` 能直接看到漏关的那一个。

**代码：`src/sh/parse.c`（完整）**

```c
/* 把一行解析成 pipeline：命令、重定向、是否后台。
 * 本阶段只识别 | > >> < 2> 2>&1 &，不识别 && || ;（下一节补）。 */
#define _POSIX_C_SOURCE 200809L
#include "sh.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int is_meta(char c)
{
    return c == '|' || c == '&' || c == '<' || c == '>';
}

/* 读一个原始词：保留引号，遇到未加引号的空白或元字符停止。
 * 返回 1 读到词，0 到行尾，-1 错误。 */
static int read_raw_word(const char **pp, struct buf_simple *b)
{
    const char *p = *pp;
    while (*p == ' ' || *p == '\t') p++;
    if (!*p || is_meta(*p)) { *pp = p; return 0; }

    b->len = 0;
    if (b->p) b->p[0] = '\0';

    int in_s = 0, in_d = 0;
    while (*p) {
        char c = *p;
        if (in_s) {
            if (c == '\'') { in_s = 0; }
            else appendc(b, c);
            p++;
            continue;
        }
        if (in_d) {
            if (c == '"') { in_d = 0; p++; continue; }
            if (c == '\\' && p[1]) { appendc(b, c); appendc(b, p[1]); p += 2; continue; }
            appendc(b, c); p++;
            continue;
        }
        if (c == ' ' || c == '\t' || is_meta(c)) break;
        if (c == '\'') { in_s = 1; appendc(b, c); p++; continue; }
        if (c == '"')  { in_d = 1; appendc(b, c); p++; continue; }
        if (c == '\\' && p[1]) { appendc(b, c); appendc(b, p[1]); p += 2; continue; }
        appendc(b, c);
        p++;
    }
    if (in_s || in_d) {
        fprintf(stderr, "mysh: syntax error: unmatched quote\n");
        return -1;
    }
    *pp = p;
    return 1;
}

/* 解析重定向前缀：2> 2>> 2>&1 1> 0< > >> <
 * 成功返回 1 并填 r；不是重定向返回 0。 */
static int parse_redir(const char **pp, struct redir *r)
{
    const char *p = *pp;
    int fd = -1;

    if ((p[0] == '2' || p[0] == '1' || p[0] == '0') && p[1] == '>') {
        fd = p[0] - '0';
        p++;
    } else if ((p[0] == '2' || p[0] == '1' || p[0] == '0') && p[1] == '<') {
        fd = p[0] - '0';
        p++;
    }
    if (*p == '<') {
        r->fd = fd < 0 ? 0 : fd;
        r->kind = R_IN;
        *pp = p + 1;
        return 1;
    }
    if (*p != '>') return 0;

    if (p[1] == '>') {
        r->fd = fd < 0 ? 1 : fd;
        r->kind = R_APPEND;
        p += 2;
    } else if (p[1] == '&') {
        r->fd = fd < 0 ? 1 : fd;
        r->kind = R_DUP;
        p += 2;
    } else {
        r->fd = fd < 0 ? 1 : fd;
        r->kind = R_OUT;
        p += 1;
    }
    *pp = p;
    return 1;
}

int parse_line(const char *line, struct pipeline *pl)
{
    memset(pl, 0, sizeof *pl);
    const char *p = line;

    for (;;) {
        struct cmd *c = &pl->cmds[pl->ncmds];
        c->argc = 0;
        c->nredirs = 0;

        for (;;) {
            while (*p == ' ' || *p == '\t') p++;
            struct redir r;
            if (parse_redir(&p, &r)) {
                while (*p == ' ' || *p == '\t') p++;
                struct buf_simple tb = {0};
                if (read_raw_word(&p, &tb) != 1) {
                    fprintf(stderr, "mysh: syntax error near redirection\n");
                    return -1;
                }
                if (c->nredirs >= MAX_REDIRS) {
                    fprintf(stderr, "mysh: too many redirections\n");
                    free(tb.p);
                    return -1;
                }
                r.target = strdup(tb.p);
                free(tb.p);
                if (!r.target) return -1;
                c->redirs[c->nredirs++] = r;
                continue;
            }
            struct buf_simple wb = {0};
            int got = read_raw_word(&p, &wb);
            if (got < 0) { free(wb.p); return -1; }
            if (got == 0) break;
            if (c->argc >= MAX_ARGS) {
                fprintf(stderr, "mysh: too many arguments\n");
                free(wb.p);
                return -1;
            }
            c->argv[c->argc++] = wb.p;      /* 转移所有权，稍后 free_pipeline */
            c->argv[c->argc] = NULL;
        }

        if (c->argc == 0 && c->nredirs == 0) {
            if (pl->ncmds == 0) return 0;   /* 空行 */
            fprintf(stderr, "mysh: syntax error: empty command\n");
            return -1;
        }
        pl->ncmds++;
        if (pl->ncmds > MAX_CMDS) {
            fprintf(stderr, "mysh: pipeline too long\n");
            return -1;
        }

        if (*p == '|') { p++; continue; }
        if (*p == '&') { pl->background = 1; p++; }
        break;
    }

    while (*p == ' ' || *p == '\t') p++;
    if (*p) {
        fprintf(stderr, "mysh: syntax error near '%s'\n", p);
        return -1;
    }
    return 0;
}

void free_pipeline(struct pipeline *pl)
{
    for (int i = 0; i < pl->ncmds; i++) {
        struct cmd *c = &pl->cmds[i];
        for (int k = 0; k < c->argc; k++) free(c->argv[k]);
        c->argc = 0;
        for (int k = 0; k < c->nredirs; k++) free(c->redirs[k].target);
        c->nredirs = 0;
    }
    pl->ncmds = 0;
    pl->background = 0;
}
```

`sh.h` 需要的类型与辅助：

```c
#define MAX_ARGS 256
#define MAX_CMDS 16
#define MAX_REDIRS 8

enum redir_kind { R_IN, R_OUT, R_APPEND, R_DUP };

struct redir { int fd; enum redir_kind kind; char *target; };
struct cmd   { char *argv[MAX_ARGS]; int argc; struct redir redirs[MAX_REDIRS]; int nredirs; };
struct pipeline { struct cmd cmds[MAX_CMDS]; int ncmds; int background; };

/* parse.c 内部用的小缓冲区 */
struct buf_simple { char *p; size_t len, cap; };
void appendc(struct buf_simple *b, char c);

int  parse_line(const char *line, struct pipeline *pl);
void free_pipeline(struct pipeline *pl);
```

`appendc` 放在 `parse.c` 顶部（原型在 `sh.h`）：

```c
void appendc(struct buf_simple *b, char c)
{
    if (b->len + 2 > b->cap) {
        size_t nc = b->cap ? b->cap * 2 : 32;
        char *np = realloc(b->p, nc);
        if (!np) { perror("realloc"); exit(1); }
        b->p = np; b->cap = nc;
    }
    b->p[b->len++] = c;
    b->p[b->len] = '\0';
}
```

**执行：`src/sh/exec.c` 的管道部分**

```c
static int apply_redirs(const struct cmd *c)
{
    for (int i = 0; i < c->nredirs; i++) {
        const struct redir *r = &c->redirs[i];
        if (r->kind == R_DUP) {
            char *end = NULL;
            long src = strtol(r->target, &end, 10);
            if (!end || *end || src < 0 || src > 9) {
                fprintf(stderr, "mysh: bad fd '%s'\n", r->target);
                return -1;
            }
            if (dup2((int)src, r->fd) < 0) { perror("dup2"); return -1; }
            continue;
        }
        int flags = r->kind == R_IN ? O_RDONLY
                  : (r->kind == R_OUT ? O_WRONLY | O_CREAT | O_TRUNC
                                      : O_WRONLY | O_CREAT | O_APPEND);
        int fd = open(r->target, flags, 0666);
        if (fd < 0) {
            fprintf(stderr, "mysh: %s: %s\n", r->target, strerror(errno));
            return -1;
        }
        if (dup2(fd, r->fd) < 0) { perror("dup2"); close(fd); return -1; }
        close(fd);
    }
    return 0;
}

/* 展开一个命令的所有词，得到 argv */
static int build_argv(struct cmd *c, int last_status, char ***out_argv, int *out_argc)
{
    struct wordlist wl = {0};
    for (int i = 0; i < c->argc; i++) {
        if (expand_word(c->argv[i], last_status, &wl) < 0) return -1;
    }
    *out_argv = wl.v;
    *out_argc = (int)wl.n;
    return 0;
}

int run_pipeline(struct pipeline *pl, int last_status, int *status_out)
{
    /* 单命令且是内建：在当前进程执行，重定向要恢复 */
    if (pl->ncmds == 1) {
        char **argv = NULL; int argc = 0;
        if (build_argv(&pl->cmds[0], last_status, &argv, &argc) < 0) return 1;
        if (argc == 0) { free(argv); return 0; }
        if (is_builtin(argv[0])) {
            int rc = run_builtin_redirected(&pl->cmds[0], argc, argv);
            free(argv);
            *status_out = rc;
            return rc;
        }
        free(argv);
    }

    pid_t pgid = 0;
    pid_t pids[MAX_CMDS];
    int prev_read = -1;

    for (int i = 0; i < pl->ncmds; i++) {
        int pfd[2] = {-1, -1};
        int last = (i == pl->ncmds - 1);
        if (!last && pipe2(pfd, O_CLOEXEC) < 0) { perror("pipe2"); return 1; }

        pid_t pid = fork();
        if (pid < 0) { perror("fork"); return 1; }

        if (pid == 0) {
            if (pgid == 0) pgid = getpid();
            setpgid(0, pgid);
            if (prev_read != -1) {
                if (dup2(prev_read, STDIN_FILENO) < 0) _exit(126);
                close(prev_read);
            }
            if (!last) {
                close(pfd[0]);
                if (dup2(pfd[1], STDOUT_FILENO) < 0) _exit(126);
                close(pfd[1]);
            }
            if (apply_redirs(&pl->cmds[i]) < 0) _exit(1);

            char **argv = NULL; int argc = 0;
            if (build_argv(&pl->cmds[i], last_status, &argv, &argc) < 0) _exit(1);
            if (argc == 0) _exit(0);
            if (is_builtin(argv[0])) _exit(run_builtin(argc, argv));
            execvp(argv[0], argv);
            fprintf(stderr, "mysh: %s: %s\n", argv[0], strerror(errno));
            _exit(errno == ENOENT ? 127 : 126);
        }

        if (pgid == 0) pgid = pid;
        setpgid(pid, pgid);              /* 父子都设，消除调度竞态 */
        pids[i] = pid;

        if (!last) close(pfd[1]);
        if (prev_read != -1) close(prev_read);
        prev_read = last ? -1 : pfd[0];
    }

    int last_rc = 0;
    for (int i = 0; i < pl->ncmds; i++) {
        int st;
        for (;;) {
            pid_t r = waitpid(pids[i], &st, 0);
            if (r == pids[i]) break;
            if (r < 0 && errno == EINTR) continue;
            perror("waitpid");
            return 1;
        }
        if (i == pl->ncmds - 1)
            last_rc = WIFEXITED(st) ? WEXITSTATUS(st) : 128 + WTERMSIG(st);
    }
    *status_out = last_rc;
    if (pl->background)
        fprintf(stderr, "[%d] %d\n", pl->ncmds, (int)pgid);   /* 完整作业表见 Stage 4 */
    return last_rc;
}
```

内建带重定向的辅助函数（保存并恢复 0/1/2）：

```c
static int run_builtin_redirected(const struct cmd *c, int argc, char **argv)
{
    int save[3] = {-1, -1, -1};
    if (c->nredirs) {
        for (int fd = 0; fd < 3; fd++) save[fd] = dup(fd);
        if (apply_redirs(c) < 0) goto restore;
    }
    int rc = run_builtin(argc, argv);
    fflush(stdout);
restore:
    for (int fd = 0; fd < 3; fd++)
        if (save[fd] >= 0) { dup2(save[fd], fd); close(save[fd]); }
    return rc;
}
```

**验证**：

```bash
make
timeout 5 ./build/mysh <<'EOF'
echo hello > /tmp/a.txt
echo world >> /tmp/a.txt
wc -l < /tmp/a.txt
yes | head -n 3
ls /nonexistent 2>/dev/null | wc -l
echo done
EOF
echo "rc=$?"
```

预期：

```text
2
y
y
y
0
done
rc=0
```

若 `rc=124`（timeout 杀掉），说明管道写端没关干净，回去查 `close(pfd[1])` 与 `close(prev_read)` 的位置。

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `yes \| head` 永不结束 | 父进程留着写端副本 | `fork` 后立即 `close(pfd[1])` |
| 第二个管道命令读不到数据 | 上一个命令的读端没关 | `dup2` 后 `close(prev_read)` |
| `Too many open files` | 每次管道泄漏 2 个 fd | 用 `pipe2(O_CLOEXEC)` 并在父子两侧都关 |
| `2>&1 > f` 与 `> f 2>&1` 结果一样 | 先收集重定向再统一应用 | 必须从左到右依次 `dup2` |
| 内建 `echo > f` 之后终端没输出 | 重定向没恢复 | 保存 0/1/2，执行完 `dup2` 回来并先 `fflush` |
| `ls 2>/tmp/e` 生成了名为 `2` 的文件 | 认错了 fd 前缀 | 只在「数字紧跟 `>`」时当前缀 |

::: errata 重定向的目标也要展开，但不能做字段分割
`echo hi > $OUT` 里的 `$OUT` 要展开，但结果只能是**一个**文件名。若走 `expand_word` 的字段分割，`OUT="a b"` 会得到两个词，第二个被当成新命令。正确做法是对目标词调用「不分割」的展开：把 `expand_word` 的 `sink_put` 一律传 `quoted=1`，即只展开不切分。
:::

**下一步**：`execvp` 已经能跑外部命令，但 127/126 的区分、`PATH` 查找、以及无 shebang 脚本的 `ENOEXEC` 回退还没做。Stage 3 把这些补上，同时把 `&&`、`||`、`;` 接进解析器。


### D.1.6 Stage 3：外部命令、`PATH` 与命令列表 {#sec-d.1.6}

**目标**：区分「找不到命令」（127）与「找到了但不能执行」（126），并支持 `;`、`&&`、`||`。

```bash
./build/mysh
mysh> /bin/echo absolute
absolute
mysh> nosuchcmd
mysh: nosuchcmd: command not found
mysh> echo $?
127
mysh> /etc/passwd
mysh: /etc/passwd: Exec format error
mysh> echo $?
126
mysh> false && echo no
mysh> true && echo yes
yes
mysh> false || echo fallback
fallback
```

**关键概念：`execve` 成功不返回。** 它把当前进程的代码段、数据段、栈全部换成新程序，调用点之后的指令根本不存在。所以「`execve` 返回了」本身就是失败信号，后面必须紧跟 `_exit`。少了这一句，子进程会继续跑父进程的循环，出现「命令没执行、退出码却是 0」的幽灵 bug。

**126 / 127 的约定**：

| 情况 | 退出码 | `errno` |
|:--|:--|:--|
| 命令不存在 | 127 | `ENOENT` |
| 存在但无执行权限 | 126 | `EACCES` |
| 可执行但格式错误（且 `/bin/sh` 回退也失败） | 126 | `ENOEXEC` |
| shebang 里的解释器不存在 | 127 | `ENOENT` |

脚本里 `command -v foo` 与 `if foo; then` 都依赖这个区分，不能统一返回 1。

**代码：`src/sh/execpath.c`（完整）**

```c
/* PATH 查找 + execve + ENOEXEC 回退。不返回。 */
#define _POSIX_C_SOURCE 200809L
#include "sh.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern char **environ;

static char *try_dir(const char *dir, const char *cmd)
{
    size_t need = strlen(dir) + 1 + strlen(cmd) + 1;
    char *full = malloc(need);
    if (!full) return NULL;
    snprintf(full, need, "%s/%s", dir, cmd);
    if (access(full, X_OK) == 0) return full;
    free(full);
    return NULL;
}

char *find_in_path(const char *cmd)
{
    const char *path = getenv("PATH");
    if (!path) path = "/usr/local/bin:/usr/bin:/bin";

    char *copy = strdup(path);
    if (!copy) return NULL;

    char *save = NULL;
    for (char *dir = strtok_r(copy, ":", &save); dir;
         dir = strtok_r(NULL, ":", &save)) {
        if (!*dir) dir = ".";            /* 空项按 POSIX 表示当前目录 */
        char *full = try_dir(dir, cmd);
        if (full) { free(copy); return full; }
    }
    free(copy);
    return NULL;
}

void exec_external(char **argv)
{
    char *path = strchr(argv[0], '/') ? strdup(argv[0]) : find_in_path(argv[0]);
    if (!path) {
        fprintf(stderr, "mysh: %s: command not found\n", argv[0]);
        _exit(127);
    }

    execve(path, argv, environ);
    int saved = errno;

    if (saved == ENOEXEC) {
        /* 无 shebang 的脚本：按 POSIX 用 /bin/sh 重试 */
        int argc = 0;
        while (argv[argc]) argc++;
        char **nargv = malloc(sizeof(char *) * (size_t)(argc + 2));
        if (nargv) {
            nargv[0] = (char *)"/bin/sh";
            nargv[1] = path;
            for (int i = 1; i < argc; i++) nargv[i + 1] = argv[i];
            nargv[argc + 1] = NULL;
            execve("/bin/sh", nargv, environ);
            saved = errno;
            free(nargv);
        }
    }

    fprintf(stderr, "mysh: %s: %s\n", argv[0], strerror(saved));
    _exit(saved == ENOENT ? 127 : 126);
}
```

**代码：`src/sh/list.c`（完整）** —— 在 `parse_line` 之上加一层列表解析：

```c
/* 把一行按未加引号的 ; && || 切成若干 pipeline，再逐段 parse_line。 */
#define _POSIX_C_SOURCE 200809L
#include "sh.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int split_list(const char *line, char **segs, int *seps, int max)
{
    size_t cap = 128, len = 0;
    char *cur = malloc(cap);
    if (!cur) return -1;
    cur[0] = '\0';

    int n = 0;
    const char *p = line;
    int in_s = 0, in_d = 0;

    while (*p) {
        char c = *p;
        if (in_s) {
            if (c == '\'') in_s = 0;
            if (len + 2 > cap) { cap *= 2; cur = realloc(cur, cap); if (!cur) return -1; }
            cur[len++] = c; cur[len] = '\0'; p++;
            continue;
        }
        if (in_d) {
            if (c == '"') in_d = 0;
            if (len + 2 > cap) { cap *= 2; cur = realloc(cur, cap); if (!cur) return -1; }
            cur[len++] = c; cur[len] = '\0'; p++;
            continue;
        }
        if (c == '\'') { in_s = 1; }
        else if (c == '"') { in_d = 1; }
        else if (c == ';' || (c == '&' && p[1] == '&') || (c == '|' && p[1] == '|')) {
            if (n >= max) { free(cur); fprintf(stderr, "mysh: too many commands\n"); return -1; }
            seps[n] = (c == ';') ? SEP_SEQ : (c == '&') ? SEP_AND : SEP_OR;
            segs[n++] = strdup(cur);
            len = 0; cur[0] = '\0';
            p += (c == ';') ? 1 : 2;
            continue;
        }
        if (len + 2 > cap) { cap *= 2; cur = realloc(cur, cap); if (!cur) return -1; }
        cur[len++] = c; cur[len] = '\0';
        p++;
    }
    if (in_s || in_d) { free(cur); fprintf(stderr, "mysh: unmatched quote\n"); return -1; }
    seps[n] = SEP_END;
    segs[n++] = cur;                    /* 转移 cur */
    return n;
}

int run_list(const char *line, int *last_status)
{
    char *segs[MAX_LIST];
    int seps[MAX_LIST];
    int n = split_list(line, segs, seps, MAX_LIST);
    if (n < 0) return 2;

    int rc = 0;
    for (int i = 0; i < n; i++) {
        int skip = (i > 0 && seps[i-1] == SEP_AND && rc != 0) ||
                   (i > 0 && seps[i-1] == SEP_OR  && rc == 0);
        if (!skip) {
            struct pipeline pl;
            if (parse_line(segs[i], &pl) < 0) { rc = 2; }
            else if (pl.ncmds > 0) rc = run_pipeline(&pl, *last_status, &rc);
            else rc = 0;
            free_pipeline(&pl);
        }
        free(segs[i]);
    }
    *last_status = rc;
    return rc;
}
```

`sh.h` 增加：

```c
#define MAX_LIST 32
enum list_sep { SEP_SEQ, SEP_AND, SEP_OR, SEP_END };
char *find_in_path(const char *cmd);
void  exec_external(char **argv);
int   run_list(const char *line, int *last_status);
```

**验证**：

```bash
make
printf '%s\n' 'true && echo yes' 'false && echo no' 'false || echo alt' 'echo a; echo b' \
  | ./build/mysh
```

预期：

```text
yes
alt
a
b
```

再验证 126/127：

```bash
printf '%s\n' 'nosuchcmd' 'echo $?' '/etc/passwd' 'echo $?' | ./build/mysh
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| 命令静默不执行、`$?` 为 0 | `execve` 失败后没有 `_exit` | `exec` 后必须紧跟 `_exit(126/127)` |
| `PATH=:/bin` 下 `foo` 找不到 | 空项没当 `.` 处理 | `strtok_r` 会跳过空项，需特殊处理或手动扫描 |
| 用 `stat` 判断可执行 | mode 位不反映 ACL/`noexec` | 用 `access(X_OK)` 查找，最终以 `execve` 结果为准 |
| `&&` 后面的命令仍执行 | 列表分隔符在引号内被误切 | 切分前跟踪 `'`/`"` 状态 |
| `echo "a;b"` 被切成两段 | 同上 | 同上，这是最典型的回归用例 |

**下一步**：现在 Shell 能跑脚本了，但按 Ctrl-C 会把 Shell 自己也杀掉，`&` 也只是「不等」，没有作业表。Stage 4 处理进程组、控制终端与 `waitpid` 的 `WUNTRACED`。

### D.1.7 Stage 4：作业控制与信号 {#sec-d.1.7}

**目标**：

```bash
./build/mysh
mysh> sleep 100 &
[1] 12345
mysh> jobs
[1]+  Running   sleep 100
mysh> sleep 200
^Z
[2]+  Stopped   sleep 200
mysh> bg %2
mysh> fg %1
^C
mysh> echo alive
alive
```

验收点：

1. `&` 立即返回，打印作业号与 pgid；
2. `jobs` 显示 `+`/`-` 与状态；
3. Ctrl-Z 只挂起前台作业，Shell 拿回提示符；
4. `fg` 把终端交给作业组，Ctrl-C 只杀作业，Shell 存活；
5. 退出 Shell 时不误杀后台作业（`SIGHUP` 可选，本项目不发）。

**关键概念：三个 id 决定谁能读写终端。**

```text
session（会话）── 控制终端 /dev/pts/N
   ├── 前台进程组（tcsetpgrp 设定）← 只有它能 read/write，Ctrl-C 发给它
   ├── 进程组 A（作业 1）: sleep
   └── 进程组 B（作业 2）: vim
```

`setpgid(0, 0)` 建新组；`tcsetpgrp(fd, pgid)` 设前台组；终端的 `SIGINT`/`SIGTSTP` 只发给前台组。Shell 自己必须**忽略** `SIGINT`/`SIGQUIT`/`SIGTSTP`，否则 Ctrl-C 会把解释器一起杀掉。

**代码：`src/sh/jobs.c`（完整）**

```c
/* 极简作业表：固定数组，作业号单调递增。 */
#define _POSIX_C_SOURCE 200809L
#include "sh.h"
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <termios.h>
#include <unistd.h>

#define MAX_JOBS 32

static struct job {
    int  id;
    pid_t pgid;
    int  state;                 /* J_RUNNING / J_STOPPED / J_DONE */
    int  status;
    char cmd[256];
} jobs_tab[MAX_JOBS];
static int next_id = 1;

static struct job *job_new(pid_t pgid, const char *cmd)
{
    for (int i = 0; i < MAX_JOBS; i++) {
        if (jobs_tab[i].id == 0) {
            jobs_tab[i].id = next_id++;
            jobs_tab[i].pgid = pgid;
            jobs_tab[i].state = J_RUNNING;
            jobs_tab[i].status = 0;
            snprintf(jobs_tab[i].cmd, sizeof jobs_tab[i].cmd, "%s", cmd);
            return &jobs_tab[i];
        }
    }
    return NULL;
}

static struct job *job_find(int id)
{
    for (int i = 0; i < MAX_JOBS; i++)
        if (jobs_tab[i].id == id) return &jobs_tab[i];
    return NULL;
}

static void term_give(pid_t pgid)
{
    signal(SIGTTOU, SIG_IGN);
    tcsetpgrp(STDIN_FILENO, pgid);
    signal(SIGTTOU, SIG_DFL);
}

/* 非阻塞收割：把状态变更同步进作业表 */
void jobs_reap(void)
{
    int st;
    pid_t pid;
    while ((pid = waitpid(-1, &st, WNOHANG | WUNTRACED | WCONTINUED)) > 0) {
        for (int i = 0; i < MAX_JOBS; i++) {
            struct job *j = &jobs_tab[i];
            if (!j->id || j->pgid != getpgid(pid)) continue;
            if (WIFSTOPPED(st))       j->state = J_STOPPED;
            else if (WIFCONTINUED(st)) j->state = J_RUNNING;
            else {
                j->state = J_DONE;
                j->status = WIFEXITED(st) ? WEXITSTATUS(st)
                                          : 128 + WTERMSIG(st);
            }
            break;
        }
    }
}

void jobs_print(void)
{
    jobs_reap();
    for (int i = 0; i < MAX_JOBS; i++) {
        if (!jobs_tab[i].id) continue;
        const char *s = jobs_tab[i].state == J_RUNNING ? "Running"
                      : jobs_tab[i].state == J_STOPPED ? "Stopped" : "Done";
        printf("[%d]%c  %-8s  %s\n", jobs_tab[i].id,
               i == 0 ? '+' : ' ', s, jobs_tab[i].cmd);
    }
}

/* 前台等待：终端交给作业组，直到退出或停止 */
int job_wait_fg(struct job *j)
{
    term_give(j->pgid);
    int st = 0;
    for (;;) {
        pid_t r = waitpid(-j->pgid, &st, WUNTRACED);
        if (r < 0) {
            if (errno == EINTR) continue;
            break;
        }
        if (WIFSTOPPED(st)) { j->state = J_STOPPED; break; }
        if (WIFEXITED(st) || WIFSIGNALED(st)) {
            j->state = J_DONE;
            j->status = WIFEXITED(st) ? WEXITSTATUS(st) : 128 + WTERMSIG(st);
            break;
        }
    }
    term_give(getpgrp());
    return j->status;
}

int job_fg(int id)
{
    struct job *j = job_find(id);
    if (!j) { fprintf(stderr, "mysh: fg: no such job\n"); return 1; }
    if (j->state == J_STOPPED) kill(-j->pgid, SIGCONT);
    j->state = J_RUNNING;
    return job_wait_fg(j);
}

int job_bg(int id)
{
    struct job *j = job_find(id);
    if (!j) { fprintf(stderr, "mysh: bg: no such job\n"); return 1; }
    if (kill(-j->pgid, SIGCONT) < 0) { perror("kill"); return 1; }
    j->state = J_RUNNING;
    return 0;
}
```

**接入执行器**：在 `run_pipeline` 里，子进程 `setpgid(0, pgid)` 之后，父进程记录作业；前台时 `term_give(pgid)`，等待用 `waitpid(-pgid, ..., WUNTRACED)`；后台时只登记不等待。

```c
/* fork 循环结束后 */
struct job *j = job_new(pgid, cmdline);
if (pl->background) {
    printf("[%d] %d\n", j->id, (int)pgid);
    *status_out = 0;
} else {
    term_give(pgid);
    int st = 0;
    while (waitpid(-pgid, &st, WUNTRACED) > 0) {
        if (WIFSTOPPED(st)) {
            j->state = J_STOPPED;
            printf("\n[%d]+  Stopped   %s\n", j->id, j->cmd);
            break;
        }
        if (WIFEXITED(st) || WIFSIGNALED(st)) {
            j->state = J_DONE;
            *status_out = WIFEXITED(st) ? WEXITSTATUS(st) : 128 + WTERMSIG(st);
            break;
        }
    }
    term_give(getpgrp());
}
```

启动时（仅交互模式）：

```c
if (isatty(STDIN_FILENO)) {
    pid_t me = getpid();
    if (getpgrp() != me) setpgid(0, 0);
    signal(SIGTTOU, SIG_IGN);
    tcsetpgrp(STDIN_FILENO, me);
    signal(SIGTTOU, SIG_DFL);
    signal(SIGINT,  SIG_IGN);
    signal(SIGQUIT, SIG_IGN);
    signal(SIGTSTP, SIG_IGN);
    signal(SIGTTIN, SIG_IGN);
    signal(SIGTTOU, SIG_IGN);
}
```

**验证**：

```bash
make
./build/mysh
mysh> sleep 300 &
[1] 24680
mysh> ps -o pid,pgid,tpgid,stat,cmd -p 24680
mysh> sleep 200
^Z
[2]+  Stopped   sleep 200
mysh> jobs
mysh> bg %2
mysh> fg %1
^C
mysh> echo alive
alive
```

用 `ps -o pid,ppid,pgid,sid,tpgid,stat,cmd -t $(tty)` 对照：Shell 的 `tpgid` 应等于它自己的 pgid，作业运行时 `tpgid` 变成作业组的 pgid。

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| Ctrl-C 后 Shell 也退出 | 没忽略 `SIGINT`，或 Shell 在前台组 | `signal(SIGINT, SIG_IGN)` 且 `setpgid` 分家 |
| `fg` 后下一行输入无回显、Shell 变 `T` 状态 | 终端没还给 Shell，`read` 收到 `SIGTTIN` | `job_wait_fg` 返回前 `tcsetpgrp(STDIN, getpgrp())` |
| `setpgid: Operation not permitted` | 在 `exec` 之后才调 | `fork` 后、`exec` 前调，父子都调 |
| 只杀了管道第一个进程 | 用了 `kill(pid, ...)` | 用 `kill(-pgid, ...)` |
| Ctrl-Z 后 `waitpid` 不返回 | 没加 `WUNTRACED` | `waitpid(..., WUNTRACED)` |
| `jobs` 里状态永远 Running | 没装 `SIGCHLD` 也没主动收割 | 每次打印前 `jobs_reap()` |

**下一步**：作业控制让 Shell 能交互，但脚本模式还有三件事没定：`exit` 的码怎么传、最后一条命令的码怎么变成 Shell 的码、`set -e` 何时生效。Stage 5 统一这两条路径。

### D.1.8 Stage 5：脚本执行与退出码 {#sec-d.1.8}

**目标**：

```bash
printf 'echo one\nfalse\nexit 42\n' > /tmp/t.sh
./build/mysh /tmp/t.sh; echo "shell=$?"
# one
# shell=42
```

验收点：

1. `mysh file` 从文件读，不打印提示符；
2. 脚本里的 `exit N` 让 Shell 以 N 退出；
3. 无 `exit` 时，最后一条命令的码成为 Shell 的码；
4. `set -e` 下失败即停；
5. 语法错误返回 2，且不执行后续行（本项目把语法错误当致命错误）。

**关键概念：交互与脚本只差几个开关，不是两条代码路径。** 把开关收进一个 `struct shell_ctx`，主循环只有一份。散落的全局变量是这类项目最常见的技术债：加 `set -e` 时你得在五个地方判断「现在是不是脚本模式」。

**代码：`src/sh/main.c`（完整替换）**

```c
#define _POSIX_C_SOURCE 200809L
#include "sh.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static struct shell_ctx {
    int  interactive;
    int  errexit;
    int  last_status;
    int  should_exit;
    int  exit_code;
    const char *script;
} ctx = { .last_status = 0, .script = "mysh" };

int shell_should_exit(void) { return ctx.should_exit; }
void shell_exit(int code)   { ctx.should_exit = 1; ctx.exit_code = code & 0xFF; }

static int run_one(const char *line)
{
    if (ctx.interactive) { fputs("mysh> ", stderr); fflush(stderr); }
    if (!*line || *line == '#') return ctx.last_status;

    int rc = run_list(line, &ctx.last_status);
    if (rc == 2) {                       /* 语法错误：脚本模式直接终止 */
        if (!ctx.interactive) shell_exit(2);
        return 2;
    }
    if (ctx.errexit && rc != 0) shell_exit(rc);
    return rc;
}

int main(int argc, char **argv)
{
    FILE *in = stdin;

    if (argc > 1) {
        in = fopen(argv[1], "r");
        if (!in) {
            fprintf(stderr, "mysh: %s: %s\n", argv[1], strerror(errno));
            return 127;
        }
        ctx.script = argv[1];
    } else {
        ctx.interactive = isatty(STDIN_FILENO);
        if (ctx.interactive) shell_init_terminal();
    }

    char *line = NULL;
    size_t cap = 0;
    ssize_t n;

    while (!ctx.should_exit && (n = getline(&line, &cap, in)) >= 0) {
        if (n > 0 && line[n - 1] == '\n') line[n - 1] = '\0';
        int rc = run_one(line);
        ctx.last_status = rc;
    }
    free(line);
    if (in != stdin) fclose(in);

    if (!ctx.should_exit) ctx.exit_code = ctx.last_status;
    return ctx.exit_code;
}
```

`set` 内建（加进 `builtin.c` 的表）：

```c
int bi_set(int argc, char **argv)
{
    if (argc == 1) { printf("errexit %s\n", shell_errexit() ? "on" : "off"); return 0; }
    if (!strcmp(argv[1], "-e")) { shell_set_errexit(1); return 0; }
    if (!strcmp(argv[1], "+e")) { shell_set_errexit(0); return 0; }
    fprintf(stderr, "set: unsupported option %s\n", argv[1]);
    return 2;
}
```

`exit` 内建改为走 `shell_exit()`，不再直接 `exit()`——否则 Stage 4 的终端恢复、作业表清理都会被跳过。

**验证**：

```bash
make
printf 'echo one\nfalse\necho two\n' > /tmp/a.sh
./build/mysh /tmp/a.sh; echo "rc=$?"
# one
# two
# rc=0        ← 最后一条成功，没有 set -e

printf 'set -e\nfalse\necho unreachable\n' > /tmp/b.sh
./build/mysh /tmp/b.sh; echo "rc=$?"
# rc=1

printf 'echo "unterminated\necho no\n' > /tmp/c.sh
./build/mysh /tmp/c.sh; echo "rc=$?"
# mysh: unmatched quote
# rc=2
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| 脚本模式仍打印 `mysh>` | 用 `isatty` 判断而非 `ctx.interactive` | 交互标志只在无参数且 stdin 是 tty 时为真 |
| `exit 3` 后进程返回 0 | `main` 末尾无条件 `return 0` | 只返回 `ctx.exit_code` |
| `set -e` 对 `if false; then` 也生效 | 简化实现未跟踪条件上下文 | 文档标注差异；完整实现需 AST 标记 |
| 语法错误后继续执行 | 只打印不终止 | 脚本模式 `shell_exit(2)` |
| `exit` 后终端不回显 | 直接 `exit(3)` 跳过了恢复 | 走 `shell_exit` + 主循环统一清理 |

**下一步**：功能齐了不等于对了。Stage 6 用「同一脚本喂 mysh 与 dash，比对 stdout 和退出码」的方式，把已知差异钉死。

### D.1.9 Stage 6：测试与兼容性 {#sec-d.1.9}

**目标**：

```bash
make test
=== mysh: 14 passed, 1 skipped, 0 failed ===
```

**关键概念：差分测试（differential testing）。** 你不必手写期望输出——`dash` 就是期望。同一段脚本分别喂给两个 Shell，比较 stdout 与退出码：

```bash
run_both() {
    a=$(printf '%s\n' "$1" | ./build/mysh 2>/dev/null); ra=$?
    b=$(printf '%s\n' "$1" | dash       2>/dev/null); rb=$?
    [ "$a" = "$b" ] && [ "$ra" = "$rb" ]
}
```

只挑两者都支持的语法交集。`dash` 支持而 `mysh` 不支持的（函数、`case`、here-doc）不要放进对照集，否则测试永远红。

**代码：`tests/sh/run.sh`（完整）**

```bash
#!/bin/sh
# mysh 回归：不依赖 bash，可在 dash 下跑。
set -u
MISH=${MISH:-./build/mysh}
pass=0; fail=0; skip=0

ok()  { pass=$((pass+1)); printf '[ok]   %s\n' "$1"; }
bad() { fail=$((fail+1)); printf '[FAIL] %s\n' "$1"; }
skp() { skip=$((skip+1)); printf '[skip] %s\n' "$1"; }

# expect <name> <script> <want_out> <want_rc>
expect() {
    name=$1; script=$2; want_out=$3; want_rc=$4
    got_out=$(printf '%s\n' "$script" | "$MISH" 2>/dev/null)
    got_rc=$?
    if [ "$got_out" = "$want_out" ] && [ "$got_rc" = "$want_rc" ]; then
        ok "$name"
    else
        bad "$name"
        printf '  want rc=%s out=<%s>\n' "$want_rc" "$want_out"
        printf '  got  rc=%s out=<%s>\n' "$got_rc" "$got_out"
    fi
}

expect echo          'echo hi'                 'hi' 0
expect quote-double  'X=1; echo "v=$X"'        'v=1' 0
expect quote-single  "X=1; echo 'v=\$X'"       'v=$X' 0
expect brace         'X=ab; echo ${X}c'        'abc' 0
expect field-split   'X="a b"; printf "<%s>" $X' '<a><b>' 0
expect no-split      'X="a b"; printf "<%s>" "$X"' '<a b>' 0
expect false-rc      'false'                   '' 1
expect exit-rc       'exit 7'                  '' 7
expect and           'true && echo y'          'y' 0
expect and-short     'false && echo n'         '' 1
expect or            'false || echo alt'       'alt' 0
expect pipe          'printf "a\nb\n" | wc -l' '2' 0
expect redirect      'echo x > /tmp/mysh_t; cat /tmp/mysh_t' 'x' 0
expect append        'echo a > /tmp/mysh_t; echo b >> /tmp/mysh_t; wc -l < /tmp/mysh_t' '2' 0
expect stderr-redir  'ls /no-such 2>/dev/null; echo ok' 'ok' 0
expect dup-fd        'ls /no-such 2>&1 | wc -l' '1' 0
expect not-found     'nosuchcmd'               '' 127

# 管道 EOF：必须 5 秒内结束
if command -v timeout >/dev/null 2>&1; then
    if timeout 5 sh -c "printf 'yes | head -n 1\n' | $MISH >/dev/null 2>&1"; then
        ok pipe-eof
    else
        bad pipe-eof
    fi
else
    skp pipe-eof
fi

# 作业控制需要 tty，CI 里跳过
if [ -t 0 ] && [ -t 1 ]; then
    skp job-control        # 真测需 pty（script/expect），见 D.6
else
    skp job-control
fi

printf '=== mysh: %d passed, %d skipped, %d failed ===\n' "$pass" "$skip" "$fail"
[ "$fail" -eq 0 ]
```

`Makefile` 增加：

```makefile
test-sh: build/mysh tests/sh/run.sh
	MISH=build/mysh sh tests/sh/run.sh
```

**验证**：

```bash
make test-sh
sh tests/sh/run.sh          # 用 dash 跑测试自身，确保不依赖 bash 扩展
```

**已知差异清单**（写进 `tests/sh/KNOWN_DIFF.md`）：

| 差异 | mysh 行为 | dash 行为 | 计划 |
|:--|:--|:--|:--|
| 无引号展开的字段数 | 按空白分割 | 按 `IFS` 分割 | 不修，`IFS` 固定为空白 |
| `set -e` 的条件上下文 | 一律退出 | `if`/`while`/`&&` 内不退出 | 延伸项 |
| 语法错误位置 | 整个脚本终止 | 终止并返回 2 | 一致 |
| `$*`、`$@`、`$#` | 不支持 | 支持 | 延伸项 |
| 重定向目标含空格 | 需引号 | 需引号 | 一致 |

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| 第一个用例失败后测试全停 | 脚本里写了 `set -e` | 只用 `set -u`，手动累计 `fail` |
| 在 CI 上 `local: not found` | 用了 bash 的 `local`/`[[ ]]` | 用 `#!/bin/sh` 并在 dash 下自测 |
| `/tmp/mysh_t` 覆盖别的测试数据 | 固定文件名 | `mktemp -d` + `trap 'rm -rf' EXIT` |
| `timeout` 不存在导致误报 | 未判断命令存在 | `command -v timeout` 后再用 |
| pty 测试偶发失败 | 靠 `sleep` 等时序 | 只做冒烟测试，或用 expect 等模式匹配 |

**下一步**：`mysh` 收尾。拿它跑你写的脚本、在 `PATH` 里放几个小工具、用 `ps` 观察进程组，就算真正掌握了。接下来换 `mybox`：挑战从「进程」变成「接口」——一份二进制如何冒充一群命令。

## D.2 `mybox`：一个二进制，多个 applet {#sec-d.2}

### D.2.1 目标与真实对应物 {#sec-d.2.1}

BusyBox 的核心不是「把很多程序塞进一个文件」，而是**共享启动代码、选项解析、错误处理与帮助文本**。`mybox` 先实现 8 个 applet：`ls`、`cat`、`cp`、`mv`、`rm`、`wc`、`head`、`tail`。每个 applet 是一个函数，注册到一张表里。

### D.2.2 applet 框架 {#sec-d.2.2}

```c
/* src/box/applet.h */
#ifndef APPLET_H
#define APPLET_H
struct applet {
    const char *name;
    int (*fn)(int argc, char **argv);
};
extern const struct applet applets[];
int applet_main(int argc, char **argv);
#endif
```

```c
/* src/box/applet.c */
#include "applet.h"
#include <stdio.h>
#include <string.h>

int ls_main(int argc, char **argv);
int cat_main(int argc, char **argv);
int cp_main(int argc, char **argv);
int mv_main(int argc, char **argv);
int rm_main(int argc, char **argv);
int wc_main(int argc, char **argv);
int head_main(int argc, char **argv);
int tail_main(int argc, char **argv);

const struct applet applets[] = {
    {"ls", ls_main}, {"cat", cat_main}, {"cp", cp_main}, {"mv", mv_main},
    {"rm", rm_main}, {"wc", wc_main}, {"head", head_main}, {"tail", tail_main},
    {NULL, NULL},
};

int main(int argc, char **argv)
{
    const char *prog = strrchr(argv[0], '/');
    prog = prog ? prog + 1 : argv[0];

    /* 以 mybox ls ... 调用 */
    if (!strcmp(prog, "mybox")) {
        if (argc < 2) { fprintf(stderr, "usage: mybox APPLET [args]\n"); return 1; }
        for (const struct applet *a = applets; a->name; a++)
            if (!strcmp(a->name, argv[1]))
                return a->fn(argc - 1, argv + 1);
        fprintf(stderr, "mybox: unknown applet %s\n", argv[1]);
        return 127;
    }

    /* 以符号链接名调用：ln -s mybox ls */
    for (const struct applet *a = applets; a->name; a++)
        if (!strcmp(a->name, prog))
            return a->fn(argc, argv);
    fprintf(stderr, "mybox: unknown applet %s\n", prog);
    return 127;
}
```

`argv[0]` 的 basename 决定行为；这也是 BusyBox 能用一个二进制提供几百个命令的机制。

### D.2.3 `ls`：目录、inode 与长格式 {#sec-d.2.3}

```c
/* src/box/ls.c — 支持 -l -a -h 的最小实现 */
#define _GNU_SOURCE
#include "applet.h"
#include <dirent.h>
#include <errno.h>
#include <grp.h>
#include <pwd.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

static void mode_string(mode_t m, char out[11])
{
    out[0] = S_ISDIR(m) ? 'd' : S_ISLNK(m) ? 'l' : S_ISCHR(m) ? 'c'
           : S_ISBLK(m) ? 'b' : S_ISFIFO(m) ? 'p' : S_ISSOCK(m) ? 's' : '-';
    const char *rwx = "rwxrwxrwx";
    for (int i = 0; i < 9; i++) out[i + 1] = (m & (1 << (8 - i))) ? rwx[i] : '-';
    out[10] = '\0';
}

static void print_long(const char *dir, const char *name, bool human)
{
    char path[4096];
    snprintf(path, sizeof path, "%s/%s", dir, name);
    struct stat st;
    if (lstat(path, &st) == -1) { perror(path); return; }

    char modes[11]; mode_string(st.st_mode, modes);
    struct passwd *pw = getpwuid(st.st_uid);
    struct group  *gr = getgrgid(st.st_gid);
    char tbuf[32];
    strftime(tbuf, sizeof tbuf, "%b %e %H:%M", localtime(&st.st_mtime));

    if (human)
        printf("%s %3lu %-8s %-8s %6.1fK %s %s\n", modes, (unsigned long)st.st_nlink,
               pw ? pw->pw_name : "?", gr ? gr->gr_name : "?",
               st.st_size / 1024.0, tbuf, name);
    else
        printf("%s %3lu %-8s %-8s %8ld %s %s\n", modes, (unsigned long)st.st_nlink,
               pw ? pw->pw_name : "?", gr ? gr->gr_name : "?",
               (long)st.st_size, tbuf, name);
}

int ls_main(int argc, char **argv)
{
    bool longfmt = false, showall = false, human = false;
    int opt;
    while ((opt = getopt(argc, argv, "lah")) != -1) {
        switch (opt) {
        case 'l': longfmt = true; break;
        case 'a': showall = true; break;
        case 'h': human = true; break;
        default: fprintf(stderr, "usage: ls [-lah] [dir]\n"); return 1;
        }
    }
    const char *dir = optind < argc ? argv[optind] : ".";
    DIR *d = opendir(dir);
    if (!d) { perror(dir); return 1; }

    struct dirent *de;
    while ((de = readdir(d)) != NULL) {
        if (!showall && de->d_name[0] == '.') continue;
        if (longfmt) print_long(dir, de->d_name, human);
        else puts(de->d_name);
    }
    closedir(d);
    return 0;
}
```

要点：

- `readdir` 返回的 `d_name` 在下次调用后可能失效；这里立刻用掉，没有保存指针。
- `lstat` 而不是 `stat`：符号链接本身也要显示。
- `getpwuid`/`getgrgid` 返回静态缓冲区，多线程要换 `_r` 版本。

### D.2.4 `cat`、`cp` 与错误处理 {#sec-d.2.4}

```c
/* src/box/cat.c */
#include "applet.h"
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

static int copy_fd(int in, int out)
{
    char buf[65536];
    for (;;) {
        ssize_t n = read(in, buf, sizeof buf);
        if (n == -1) { if (errno == EINTR) continue; return -1; }
        if (n == 0) return 0;
        ssize_t off = 0;
        while (off < n) {
            ssize_t w = write(out, buf + off, (size_t)(n - off));
            if (w == -1) { if (errno == EINTR) continue; return -1; }
            off += w;
        }
    }
}

int cat_main(int argc, char **argv)
{
    if (argc < 2) return copy_fd(STDIN_FILENO, STDOUT_FILENO) == -1 ? 1 : 0;
    int rc = 0;
    for (int i = 1; i < argc; i++) {
        int fd = open(argv[i], O_RDONLY | O_CLOEXEC);
        if (fd == -1) { perror(argv[i]); rc = 1; continue; }
        if (copy_fd(fd, STDOUT_FILENO) == -1) { perror("write"); rc = 1; }
        close(fd);
    }
    return rc;
}
```

`cp` 的骨架相同，只是多一步 `open(dst, O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0644)`，并在关闭前 `fsync`（可选）。**不要**用 `system("cp ...")`：参数含空格/分号时会注入。

### D.2.5 Stage 2：`mv` 与 `rm` {#sec-d.2.5}

**目标**：`mv` 同盘走 `rename`，跨盘回退「复制 + 删除」；`rm -r` 后序删除；两者都拒绝 `/`、`.`、`..`。

```bash
./build/mybox mv a.txt b.txt
./build/mybox mv dir /tmp/other/       # 目标是目录 → 拼 basename
./build/mybox rm -rf /tmp/junk
./build/mybox rm .
mybox: rm: refusing to remove '.'
```

**关键概念**：`rename(2)` 同文件系统内原子，跨文件系统返回 `EXDEV`，只能「复制 + `unlink`」，此时**不原子**——中途失败会留下两份。目录删除必须**后序**（先清空再 `rmdir`），复制则必须**先序**（先建目录再填内容），顺序写反会得到 `ENOTEMPTY`。

**代码（`src/box/rm.c` 核心 + `mv.c` 的跨盘分支）**

```c
static int rm_tree(const char *path)
{
    struct stat st;
    if (lstat(path, &st) == -1) { perror(path); return -1; }
    if (!S_ISDIR(st.st_mode)) return unlink(path);

    DIR *d = opendir(path);
    if (!d) { perror(path); return -1; }
    struct dirent *de;
    int rc = 0;
    while ((de = readdir(d))) {
        if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..")) continue;
        char child[PATH_MAX];
        snprintf(child, sizeof child, "%s/%s", path, de->d_name);
        if (rm_tree(child) == -1) rc = -1;
    }
    closedir(d);
    return rmdir(path) == -1 ? -1 : rc;      /* 后序：清空后才删自己 */
}

/* mv：先试 rename，EXDEV 时退化 */
static int move_one(const char *src, const char *dst)
{
    if (rename(src, dst) == 0) return 0;
    if (errno != EXDEV) { perror("rename"); return -1; }
    fprintf(stderr, "mybox: mv: warning: cross-device move is not atomic\n");
    if (copy_tree(src, dst) == -1) return -1;
    return rm_tree(src);
}
```

**验证**：

```bash
mkdir -p /tmp/r/a/b && touch /tmp/r/a/b/f
./build/mybox rm -rf /tmp/r && test ! -e /tmp/r && echo gone
./build/mybox rm -rf / ; echo $?          # 1，且 / 还在
df /tmp /dev/shm | awk 'NR>1{print $1}'
./build/mybox mv /tmp/x /dev/shm/x        # 跨设备，触发 EXDEV 回退
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `rm -rf /` 真的开始删 | 没挡危险路径 | 先判 `/`、`.`、`..` |
| `rmdir: Directory not empty` | 先删自己后删内容 | 改成后序 |
| `mv: Invalid cross-device link` | 只用 `rename` | 捕获 `EXDEV` 回退 |
| 复制目录权限不对 | `open(..., 0666)` 受 umask 影响 | 写完 `fchmod` 到源 mode |

**下一步**：`mybox` 的读写有了，Stage 3 做遍历——`find`。

### D.2.6 Stage 3：`find` {#sec-d.2.6}

**目标**：`find [path...] [-name PAT] [-type f|d|l] [-maxdepth N]`，先序输出，不跟随符号链接。

```bash
./build/mybox find /tmp/ft -name '*.txt'
./build/mybox find /tmp/ft -type d -maxdepth 1
```

**关键概念**：`-name` 只匹配 **basename**，用 `fnmatch(pat, base, 0)`；用 `lstat` 而不是 `stat`，否则 `a -> b -> a` 的链接环会无限递归；`-maxdepth` 在**进入子目录前**判断，`depth >= maxdepth` 就返回，保证 `-maxdepth 0` 只输出起点本身。

```c
static int walk(const char *path, int depth, const struct find_opts *o)
{
    struct stat st;
    if (lstat(path, &st) == -1) { perror(path); return -1; }

    const char *base = strrchr(path, '/');
    base = base ? base + 1 : path;
    if (!*base) base = path;                 /* 根目录 "/" 的 basename 为空 */

    int hit = (!o->name_pat || fnmatch(o->name_pat, base, 0) == 0);
    if (hit && o->type)
        hit = (o->type == 'f' && S_ISREG(st.st_mode)) ||
              (o->type == 'd' && S_ISDIR(st.st_mode)) ||
              (o->type == 'l' && S_ISLNK(st.st_mode));
    if (hit) puts(path);                     /* 先序：先输出自己 */

    if (!S_ISDIR(st.st_mode)) return 0;
    if (o->maxdepth >= 0 && depth >= o->maxdepth) return 0;

    DIR *d = opendir(path);
    if (!d) { perror(path); return -1; }
    struct dirent *de;
    int rc = 0;
    while ((de = readdir(d))) {
        if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..")) continue;
        char child[PATH_MAX];
        snprintf(child, sizeof child, "%s%s%s", path,
                 path[strlen(path) - 1] == '/' ? "" : "/", de->d_name);
        if (walk(child, depth + 1, o) == -1) rc = -1;
    }
    closedir(d);
    return rc;
}
```

**验证**：

```bash
mkdir -p /tmp/loop && ln -sfn /tmp/loop /tmp/loop/self
timeout 5 ./build/mybox find /tmp/loop      # 只输出 loop 与 self，不递归
./build/mybox find /tmp/ft -maxdepth 0      # 只输出 /tmp/ft
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| 链接环无限递归 | 用了 `stat` | 改 `lstat`，不跟随 |
| `-name 'a*'` 误匹配子目录 | 拿完整路径去 `fnmatch` | 只匹配 basename |
| `readdir` 结束被当成错误 | 没在循环前 `errno = 0` | 用 `errno` 区分 EOF 与失败 |
| 根目录 `base` 越界 | `/` 的 `strrchr` 指向结尾 | 空 basename 时用原路径 |

**下一步**：找到了文件，下一节把它们读出来、数出来、截出来。

### D.2.7 Stage 4：`grep`、`wc`、`head`、`tail` {#sec-d.2.7}

**目标**：

```bash
printf 'apple\nBanana\napple pie\n' > /tmp/f
./build/mybox grep -ic apple /tmp/f     # 2
./build/mybox wc -l /tmp/f              # 3
seq 1 1000000 | ./build/mybox tail -n 2 # 999999 1000000
```

**关键概念**：行读取用 `getline`（POSIX 2008，自动扩容），别用固定缓冲的 `fgets`；`wc -l` 只数 `\n`，所以 `printf 'a\nb'` 是 1 行不是 2 行；`tail` 不能把整个文件读进内存，用**环形缓冲**保存最后 N 行，内存 O(N)，对管道与文件都成立；`grep` 的退出码是 **0 匹配 / 1 无匹配 / 2 出错**。

```c
/* tail 的环形缓冲：ring 存行指针，count 是已读行数 */
while (getline(&line, &cap, fp) >= 0) {
    long slot = count % n;
    free(ring[slot]);
    ring[slot] = strdup(line);
    count++;
}
long start = count > n ? count % n : 0;
for (long k = 0; k < (count > n ? n : count); k++)
    fputs(ring[(start + k) % n], stdout);

/* wc 的计数：只认 '\n' 与空白边界 */
for (size_t i = 0; i < len; i++) {
    if (buf[i] == '\n') c->lines++;
    if (isspace((unsigned char)buf[i])) in_word = 0;
    else if (!in_word) { in_word = 1; c->words++; }
}
```

**验证**：

```bash
printf 'a\nb' | ./build/mybox wc -l          # 1
printf 'a\nb' | ./build/mybox grep b         # b
seq 1 100000 | ./build/mybox tail -n 2 | ./build/mybox wc -l   # 2
/usr/bin/time -f '%M KB' sh -c 'seq 1 1000000 | ./build/mybox tail -n 3' 
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `wc -l` 把无换行末行也算一行 | 按「读到一行」计数 | 只数 `\n` |
| `tail` 大文件吃几百 MB | 全量读入数组 | 环形缓冲 |
| `grep` 无匹配返回 0 | 退出码语义错 | 0/1/2 三态 |
| `head -n 0` 仍输出一行 | `do/while` 结构 | 先判断再读 |
| `grep -i` 在 musl 上链接失败 | `strcasestr` 是 GNU 扩展 | 定义 `_GNU_SOURCE` 或自写比较 |

**下一步**：四个工具各写各的选项，`-n` 在 `head` 里带参数、在 `ls` 里是一行一个。Stage 5 统一选项解析与退出码。

### D.2.8 Stage 5：选项解析与退出码 {#sec-d.2.8}

**目标**：所有 applet 统一用 `getopt`；非法选项返回 **2**；`--` 终止选项；`-` 表示 stdin。

```bash
./build/mybox ls -Z ; echo $?      # 2
./build/mybox cat -               # 读 stdin
./build/mybox rm -- -dashfile     # 文件名以 - 开头
```

**关键概念**：退出码分三层——**0 成功、1 运行时失败、2 用法错误**（127 留给「applet 不存在」）。脚本靠这个区分「数据问题」与「我参数写错了」。`--help` 走 stdout + 0，用法错误走 stderr + 2。

```c
int ls_main(int argc, char **argv)
{
    bool l = false, a = false, h = false;
    int opt;
    opterr = 0;                       /* 自己打印，格式统一 */
    while ((opt = getopt(argc, argv, ":lah")) != -1) {
        switch (opt) {
        case 'l': l = true; break;
        case 'a': a = true; break;
        case 'h': h = true; break;
        case ':':
            fprintf(stderr, "mybox: ls: option -%c requires an argument\n", optopt);
            return 2;
        default:
            fprintf(stderr, "mybox: ls: invalid option -- '%c'\n", optopt);
            return 2;
        }
    }
    if (optind < argc && !strcmp(argv[optind], "--")) optind++;
    /* optind 之后的都是路径；"-" 单独处理为 stdin */
    return list_paths(argc - optind, argv + optind, l, a, h);
}
```

**验证**：

```bash
for a in ls cat wc head tail; do ./build/mybox $a -Q >/dev/null 2>&1; echo "$a=$?"; done
# 全部为 2
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `cat -` 报 invalid option | 没把单独的 `-` 当操作数 | `getopt` 默认已处理，别自己再判 |
| 退出码统一为 1 | 未区分用法错误 | 参数错误路径 `return 2` |
| `--help` 输出到 stderr | 帮助与错误混用 | 帮助走 stdout + 0 |
| 全局 `optind` 串味 | applet 复用了同一个进程 | 每个 applet 入口 `optind = 1` |

**下一步**：12 个 applet 与统一选项都齐了，Stage 6 用差分测试与 BusyBox 对照收尾。

### D.2.9 Stage 6：测试与 BusyBox 对照 {#sec-d.2.9}

`mybox` 的测试已在 D.2.5 给了骨架，这里补两条原则：

1. **比语义，不比格式**：`ls -l` 的列宽、时间格式、错误措辞必然与 BusyBox 不同，只比较「排序后的行集合」与退出码；
2. **不测未定义行为**：目录不存在时返回 1 还是 2，POSIX 允许 1，别硬比。

```bash
diff <(./build/mybox ls /tmp/ft | sort) <(busybox ls /tmp/ft | sort) && echo same
sha=$(printf 'hello\n' | ./build/mybox wc -c); echo "wc -c=$sha"   # 与 busybox 对照
```

差异写进 `tests/box/KNOWN_DIFF.md`，每条注明「差异 / 原因 / 是否计划修」。没有 BusyBox 时整段 skip，不要让 CI 变红。

## D.3 `mygit`：内容寻址对象库 {#sec-d.3}

### D.3.1 目标与真实对应物 {#sec-d.3.1}

Git 的核心是一个键值库：键 = `sha1(type + " " + len + "\0" + content)`，值 = zlib 压缩后的内容。`blob` 存文件内容，`tree` 存目录项，`commit` 存快照元数据。先实现 `hash-object`、`cat-file`、`write-tree`、`commit-tree`、`log`，再实现 index 与 `add/commit`。

### D.3.2 对象读写与 SHA-1 {#sec-d.3.2}

```c
/* src/git/object.c — 写入 blob 对象，返回 40 位 hex */
#define _GNU_SOURCE
#include "git.h"
#include <openssl/sha.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>

static int write_object(const char *type, const void *data, size_t len, char hex[41])
{
    char header[64];
    int hlen = snprintf(header, sizeof header, "%s %zu", type, len) + 1; /* +1 含 \0 */
    size_t total = (size_t)hlen + len;
    unsigned char *raw = malloc(total);
    if (!raw) return -1;
    memcpy(raw, header, (size_t)hlen);
    memcpy(raw + hlen, data, len);

    unsigned char digest[SHA_DIGEST_LENGTH];
    SHA1(raw, total, digest);
    for (int i = 0; i < SHA_DIGEST_LENGTH; i++)
        sprintf(hex + i * 2, "%02x", digest[i]);
    hex[40] = '\0';

    char path[4096];
    snprintf(path, sizeof path, ".git/objects/%.2s/%s", hex, hex + 2);
    char dir[4096];
    snprintf(dir, sizeof dir, ".git/objects/%.2s", hex);
    mkdir_p(dir);

    FILE *fp = fopen(path, "wb");
    if (!fp) { free(raw); return -1; }
    z_stream zs = {0};
    deflateInit(&zs, Z_BEST_SPEED);
    unsigned char out[65536];
    zs.next_in = raw; zs.avail_in = (uInt)total;
    do {
        zs.next_out = out; zs.avail_out = sizeof out;
        deflate(&zs, Z_FINISH);
        fwrite(out, 1, sizeof out - zs.avail_out, fp);
    } while (zs.avail_out == 0);
    deflateEnd(&zs);
    fclose(fp);
    free(raw);
    return 0;
}
```

`git cat-file -p` 是逆过程：读文件、`inflate`、按第一个 `\0` 拆出 `type len` 与内容。先写这两个命令，就能用真 `git` 验证：

```bash
mkdir -p .git/objects
printf 'hello\n' > a.txt
./build/mygit hash-object -w a.txt
# 输出 40 位 hex，例如 ce013625030ba8dba906f756967f9e9ca394464a
git cat-file -p ce013625030ba8dba906f756967f9e9ca394464a
# hello
```

### D.3.3 tree 与 commit {#sec-d.3.3}

`tree` 的二进制格式：若干 `<mode> <name>\0<20 字节 SHA-1>` 按 name 排序。`commit` 是文本：

```text
tree <tree-hex>
parent <parent-hex>        # 可省略
author Name <email> 1700000000 +0800
committer Name <email> 1700000000 +0800

message
```

实现顺序：`write-tree`（递归目录）→ `commit-tree`（接受 tree/parent/message）→ `log`（沿 parent 走）。用真 `git` 读：

```bash
git cat-file -p HEAD
git ls-tree HEAD
```

### D.3.4 Stage 2：index（暂存区） {#sec-d.3.4}

**目标**：`add` 之后 `git ls-files -s` 能读出同样的 mode/sha/路径——index 格式与真 git 二进制兼容。

```bash
./build/mygit init && echo hello > a.txt && ./build/mygit add a.txt
git ls-files -s
# 100644 ce013625030ba8dba906f756967f9e9ca394464a 0	a.txt
git status           # 显示 "new file: a.txt"，说明 index 被正确识别
```

**index v2 的布局**：

```text
"DIRC" | 版本=2 (u32) | 条目数 N (u32)
条目 0 … 条目 N-1
[扩展段]
SHA-1(前面所有字节) (20 字节)
```

每条目定长 62 字节 + 路径 + NUL + 填充，**总长按 8 字节对齐**：

| 字段 | 宽度 | 说明 |
|:--|:--|:--|
| ctime / mtime | 8+4 各 | 秒 + 纳秒，大端 |
| dev / ino | 4+4 | 取 `lstat`，用于快速判断「是否改过」 |
| mode | 4 | `100644`/`100755`/`120000`，八进制值 |
| uid / gid / size | 4×3 | 同上 |
| sha | 20 | 二进制，不是 40 位 hex |
| flags | 2 | 低 12 位是路径长度 |
| path | 变长 | NUL 结尾，再补 `\0` 到 8 字节边界 |

**关键概念**：全部整数是**大端**（网络字节序），宿主是小端也要转；`8` 字节对齐算错，`git` 读到的路径就没有终止符；尾部 SHA-1 覆盖「校验和之前的全部字节」，不能把自己算进去；写 index 同样要「临时文件 + `rename`」，否则崩溃会留下半截 index。

**代码（写 index 的核心）**

```c
static void put_be32(unsigned char *p, uint32_t v)
{
    p[0] = v >> 24; p[1] = v >> 16; p[2] = v >> 8; p[3] = v;
}

memcpy(buf, "DIRC", 4);
put_be32(buf + 4, 2);                 /* version */
put_be32(buf + 8, (uint32_t)ix->count);

size_t o = 12;
for (size_t i = 0; i < ix->count; i++) {
    const struct index_entry *e = &ix->entries[i];
    put_be64(buf + o, e->ctime_sec);  o += 8;   /* 秒用 64 位 */
    put_be32(buf + o, e->ctime_nsec); o += 4;
    /* …mtime/dev/ino/mode/uid/gid/size 各 4 或 8 字节，顺序固定… */
    memcpy(buf + o, e->sha, 20);      o += 20;
    size_t plen = strlen(e->path);
    buf[o++] = (unsigned char)(plen >> 8);
    buf[o++] = (unsigned char)(plen & 0xFF);
    memcpy(buf + o, e->path, plen);
    o += ((62 + plen + 8) & ~(size_t)7) - 62;   /* NUL + 填充 */
}
SHA1(buf, o, buf + o);                /* 校验和只算 o 字节 */
```

**验证**：

```bash
git ls-files -s          # 与 mygit ls-files -s 逐行一致
git status --porcelain   # ?? 之外的 "A  a.txt" 表示已暂存
xxd .git/index | head -2 # 前 4 字节应为 4449 5243 ("DIRC")
git update-index --index-version 2   # 保持 v2，别升到 v4
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `git ls-files` 输出乱码路径 | 对齐算错，少写或多写填充 | 总长 `(62+plen+8) & ~7` |
| `index checksum mismatch` | 校验和把自身算进去 | 只对 `[0, o)` 做 SHA-1 |
| `git status` 认为文件已修改 | ctime/mtime/size 字段没填 | 从 `lstat` 逐字段复制 |
| 每次 add 后条目翻倍 | 没按路径查找已有条目 | upsert：先线性查找再插入排序 |

**下一步**：index 只是清单，Stage 3 把它变成 tree 与 commit。

### D.3.5 Stage 3：`add` 与 `commit` {#sec-d.3.5}

**目标**：把 index 变成 tree，再包成 commit，并原子更新 `refs/heads/master`。

```bash
./build/mygit init
echo hello > a.txt && mkdir sub && echo world > sub/b.txt
./build/mygit add a.txt sub/b.txt
./build/mygit commit -m "first"
git log --oneline          # 真 git 读得到
git fsck                   # 无输出即通过
```

**关键概念**：index 是**扁平路径**（`sub/b.txt`），tree 是**嵌套结构**。构建时按 `/` 切段，逐层折叠出「目录 → 子项」的临时树，再递归序列化。两个字节级陷阱：

1. 目录 mode 序列化成 `40000`（`%o`），**不是** `040000`；
2. tree 条目排序时，目录名要**当作带 `/` 后缀**比较——`foo.txt`（`.`=0x2E）排在 `foo/`（`/`=0x2F）之前，用裸 `strcmp` 会得到相反顺序，`git fsck` 报 `tree not sorted`。

commit 是纯文本，字段顺序固定，message 前有一个空行、末尾必须有一个 `\n`：

```text
tree <40 hex>
parent <40 hex>          ← 首个 commit 没有这一行
author Name <email> <unix-ts> <tz>
committer Name <email> <unix-ts> <tz>

<message>
```

**代码（摘要）**

```c
/* 把 index 折叠成树，再写 commit 对象 */
for (size_t i = 0; i < ix.count; i++) {
    struct node *cur = &root;
    char *save = NULL, *seg = strtok_r(ix.entries[i].path, "/", &save);
    while (seg) {
        char *next = strtok_r(NULL, "/", &save);
        struct node *c = child_get(cur, seg, next != NULL);
        if (!next) { c->mode = ix.entries[i].mode;
                     memcpy(c->sha, ix.entries[i].sha, 20); }
        cur = c;
        seg = next;
    }
}

snprintf(body, cap,
         "tree %s\n%s%s%s"
         "author %s <%s> %lld %s\n"
         "committer %s <%s> %lld %s\n\n%s\n",
         tree_hex,
         has_parent ? "parent " : "", has_parent ? parent : "",
         has_parent ? "\n" : "",
         name, email, (long long)now, tz,
         name, email, (long long)now, tz, msg);
object_write("commit", body, strlen(body), commit_hex);

/* ref 原子更新：临时文件 + rename */
snprintf(tmp, sizeof tmp, ".git/refs/heads/master.tmp.%ld", (long)getpid());
FILE *rf = fopen(tmp, "w");
fprintf(rf, "%s\n", commit_hex);
fclose(rf);
rename(tmp, ".git/refs/heads/master");
```

**验证**：

```bash
./build/mygit commit -m "second"
git log --oneline | wc -l      # 2
git cat-file -p HEAD | head -3  # tree / parent / author
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `git fsck: tree not sorted` | 排序没算目录 `/` 后缀 | 比较时临时拼后缀 |
| `bad tree object` | 目录 mode 写成 `040000` | 用 `%o` 输出 `40000` |
| `git log` 显示空 message | 空行与 message 之间少了 `\n` | 格式串末尾补 `\n` |
| ref 为空、仓库损坏 | 直接 `fopen(ref, "w")` | 临时文件 + `rename` |

**下一步**：能提交，还要能回看与回到过去——`log` 与 `checkout`。

### D.3.6 Stage 4：`log` 与 `checkout` {#sec-d.3.6}

**目标**：`log` 沿 `parent` 回溯到根；`checkout <commit>` 把 tree 展开回工作区。

```bash
./build/mygit log --oneline
./build/mygit checkout <old-sha>
cat a.txt            # 旧内容
```

**关键概念**：commit 里可能有 0 个（根）、1 个（普通）或多个（merge）`parent` 行；本项目只跟第一个，merge 留作延伸。tree 是**二进制**：`<mode> <name>\0<20 字节 sha>`，没有长度前缀，必须「找空格 → 找 NUL → 跳 20 字节」显式扫描，绝不能用 `strtok` 按 `\0` 切——sha 里随时可能出现 `\0`。

```c
/* 解析 commit：空行之前是头，之后是 message */
char *sep = strstr(text, "\n\n");
ci->message = strdup(sep + 2);
*sep = '\0';
for (char *line = text; line && *line; ) {
    char *nl = strchr(line, '\n');
    if (nl) *nl = '\0';
    if (!strncmp(line, "tree ", 5))        snprintf(ci->tree, 41, "%s", line + 5);
    else if (!strncmp(line, "parent ", 7) && !ci->has_parent) {
        snprintf(ci->parent, 41, "%s", line + 7);
        ci->has_parent = 1;
    } else if (!strncmp(line, "author ", 7))    ci->author = strdup(line + 7);
    line = nl ? nl + 1 : NULL;
}

/* 展开 tree：先建目录、再写文件；符号链接单独处理 */
while (off < size) {
    size_t ms = off;
    while (off < size && content[off] != ' ') off++;
    char mode[8] = {0};
    memcpy(mode, content + ms, off - ms); off++;
    size_t ns = off;
    while (off < size && content[off]) off++;
    char *name = strndup((char *)content + ns, off - ns); off++;
    memcpy(sha, content + off, 20); off += 20;
    uint32_t m = strtoul(mode, NULL, 8);
    if (m == 0040000) { mkdir(path, 0777); recurse(hex, path + "/"); }
    else if (m == 0120000) { /* 内容是 target，symlink(target, path) */ }
    else { /* object_read + write，最后 fchmod 到 m & 0777 */ }
}
```

**验证**：

```bash
git init -q && echo v1 > a.txt && git add . && git commit -qm v1
./build/mygit log --oneline          # 读到 git 的提交
old=$(git rev-parse HEAD)
echo v2 > a.txt && git commit -qam v2
./build/mygit checkout "$old" && cat a.txt    # v1
```

**常见错误**：

| 报错/现象 | 原因 | 修复 |
|:--|:--|:--|
| `checkout` 报 `ENOENT` | 子目录没先创建 | 先递归目录再写文件 |
| 符号链接变成普通文件 | 按 blob 写了目标路径字符串 | mode `120000` 走 `symlink` |
| `log` 只输出一条 | parent 没解析或没跟 | 检查 `parent ` 前缀与 `has_parent` |
| tree 解析错位 | 用 `strtok` 切二进制 | 显式扫描空格/NUL/20 字节 |

**下一步**：自读自写不算数，Stage 5 用真 git 做双向验证。

### D.3.7 Stage 5：与真 git 互操作 {#sec-d.3.7}

```bash
rm -rf demo && mkdir demo && cd demo
git init
cp ../a.txt .
../build/mygit add a.txt
../build/mygit commit -m "first"
git log --oneline        # 真 git 能读你的 commit
git fsck                 # 对象图完整
```

### D.3.8 Stage 6：packfile 一句带过 + 测试 {#sec-d.3.8}

**packfile 是什么**：loose object 一个对象一个文件，几十万对象就是几十万个 inode。packfile 把多个对象打进一个 `.pack`，相似对象只存**差异**（delta），再用 `.idx` 提供「sha → 偏移」的二分查找：`fanout[256]` 累积计数、排序后的 sha 表、CRC 表、偏移表。读一个对象 = 查 idx 得偏移 → 读 pack 条目（类型 3 位 + 变长 size）→ 若是 `OBJ_OFS_DELTA`/`OBJ_REF_DELTA` 递归应用 delta。

本项目**不实现** packfile：它影响体积与速度，不影响语义。代价是**不能对仓库跑 `git gc`**——打包后 loose object 消失，`mygit` 就读不到了。互操作测试里固定 `git config gc.auto 0`，并在文档里写明这条限制。

**测试要点**（`tests/git/run.sh`）：空 blob 与 `"hello\n"` 是两个固定向量，必须逐字节对上；然后 `init → add → commit`，用 `git fsck` 判断格式、`git log --oneline | grep` 判断互操作。在 `mktemp -d` 里跑，`trap 'rm -rf' EXIT` 清理，全程不碰仓库外的路径。

两个哈希是**标准测试向量**，必须逐字符一致；它们同时验证了「长度前缀 + `\0` + 内容」的哈希口径没有写错。

## D.4 三条线拼成一个演示 {#sec-d.4}

```bash
# 1. 用 mygit 管理一个脚本项目
./build/mygit init
printf '#!/bin/sh\necho hi\n' > hi.sh
./build/mygit add hi.sh && ./build/mygit commit -m "hi"

# 2. 用 mysh 执行它
./build/mysh
mysh> chmod +x hi.sh
mysh> ./hi.sh
hi

# 3. 用 mybox 查看结果
./build/mybox ls -l
./build/mybox cat hi.sh
```

## D.5 验收清单 {#sec-d.5}

- [ ] `mysh` 能执行内建、外部命令、管道、重定向、`&&`/`;`，退出码正确
- [ ] `mysh` 的 `strace -f -e trace=pipe2,dup2,close` 显示 fd 表正确关闭
- [ ] `mybox` 8 个 applet 可用；错误路径返回非零并打印 `perror` 风格信息
- [ ] `mygit` 的 blob/tree/commit 能被真 `git cat-file`/`git log` 读取
- [ ] `git fsck` 通过；`mygit add/commit` 后 `git status` 干净
- [ ] 所有 C 程序 `-Wall -Wextra -Werror` 通过；ASan/UBSan 无报告
- [ ] 测试脚本 `tests/run.sh` 自清理，可在干净目录重复运行

## D.6 延伸与母本对应 {#sec-d.6}

| 母本 | 章节 | 本书落点 | 程度 |
|:--|:--|:--|:--|
| K | 第 24–28 章（fork/exec/wait/作业控制） | D.1.3–D.1.6 | 完整 |
| K | 第 44 章（管道/FIFO） | D.1 Stage 2 | 完整 |
| K | 第 2–5 章（文件 I/O） | D.2.3–D.2.5 | 完整 |
| Shotts | 第 5–6、24–36 章（命令/重定向/脚本） | D.1 | 精选 |
| shell-book | 第 5、11–17 章（Shell/脚本/函数） | D.1 | 背景 |
| CSAPP | 第 7 章（链接）、第 10 章（I/O） | D.0.4、D.2 | 背景 |
| Git 官方文档 | `gitformat-index`、`gitformat-pack` | D.3.4–D.3.5 | 精选 |

### D.6.1 实测状态与未实测项 {#sec-d.6.1}

本页代码是按「可编译、可复现」的目标写的，但**并非全部在作者环境里跑过**，读的时候请按下面的口径判断可信度：

| 项目 | 状态 | 说明 |
|:--|:--|:--|
| `hash-object` 的两个哈希向量 | 已核对标准值 | `e69de29…`（空 blob）与 `ce0136…`（`hello\n`）是 git 的公开测试向量 |
| Stage 0 的词法/内建/`execvp` 路径 | 已实测（Linux x86-64/glibc） | 其余 Stage 的代码为同架构下的设计实现，未逐行编译 |
| 管道 EOF、`2>&1` 顺序、`waitpid` 语义 | 未实测 | 按 POSIX 与 Linux 行为编写；请用 D.1.5 的 `timeout 5` 用例自测 |
| 作业控制的终端行为（`tcsetpgrp`/Ctrl-Z） | 未实测 | 依赖真实 pty；CI 中跳过，需在交互终端手工验证 |
| `ls` 的列宽、时间格式、排序 | 未实测 | 与 BusyBox/coreutils 必然有格式差异，已列入 `KNOWN_DIFF.md` |
| 跨设备 `mv`（`EXDEV` 回退） | 未实测 | 需 `/tmp` 与 `/dev/shm` 分属不同文件系统，先用 `df` 确认 |
| index 二进制格式 | 未实测 | 字段顺序按 `gitformat-index` 编写，务用 `xxd` 与真 git 的 index 逐字节对照 |
| `git gc` 之后的仓库 | 不支持 | 只支持 loose object；测试前 `git config gc.auto 0` |
| musl、macOS、非 x86-64 | 未实测 | `pipe2`、`getline`、`strcasestr` 等需按平台调整 |

原则：**凡是「预期输出」都应当被你的 `make test` 重新证明一次**。本页给的是设计与验收标准，不是运行记录。

> **下一站**：回到 [项目总览](overview.md) 选另一条主线；或去 [R.9 面试竞技场](../review/interview.md) 用项目里的取舍回答问题。
