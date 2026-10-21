/*
 * ub_lab.c -- 第 9 章实验：在真实机器上触发并与 sanitizer 对照。
 *
 * 每个 case 都从命令行取运行时值，避免优化器把整个计算折叠成常量。
 * 编译：cc -std=c17 -Wall -Wextra -Werror ...
 */
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Cell {
    int value;
};

static int add_one(int x)
{
    return x + 1;
}

static int shift_left(int x, int s)
{
    return x << s;
}

__attribute__((noinline)) int guarded_load(struct Cell *p)
{
    int v = p->value;      /* 若 p 为 NULL，这里是 UB，优化器可假设 p != NULL */
    if (p != NULL) {       /* 因而这个检查是死代码 */
        return v;
    }
    return -1;
}

static int read_at(int *a, int i)
{
    return ((volatile int *)a)[i];
}

static void write_at(int *a, int i, int v)
{
    ((volatile int *)a)[i] = v;
}

static int use_after_free(void)
{
    int *p = malloc(sizeof *p);

    if (p == NULL) {
        return -1;
    }
    *p = 7;
    free(p);
    return *p;              /* 生命周期已结束 */
}

static int signed_char_value(void)
{
    return (int)(char)255;  /* char 是否有符号由实现定义 */
}

static int shared_counter;

static void *race_worker(void *arg)
{
    (void)arg;
    for (int i = 0; i < 100000; i++) {
        shared_counter++;   /* 无同步的读改写：数据竞争 */
    }
    return NULL;
}

static int run_race(void)
{
    pthread_t t1;
    pthread_t t2;

    if (pthread_create(&t1, NULL, race_worker, NULL) != 0) {
        return -1;
    }
    if (pthread_create(&t2, NULL, race_worker, NULL) != 0) {
        return -1;
    }
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    return shared_counter;
}

static void usage(const char *argv0)
{
    fprintf(stderr,
            "usage: %s CASE [ARG]\n"
            "cases: overflow N | shift N S | oob-read I | oob-write I |\n"
            "       uaf | race | null-guard | char-signed | layout\n",
            argv0);
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        usage(argv[0]);
        return 2;
    }

    if (strcmp(argv[1], "overflow") == 0 && argc >= 3) {
        int x = atoi(argv[2]);
        int y = add_one(x);
        printf("overflow: in=%d out=%d\n", x, y);
        return 0;
    }
    if (strcmp(argv[1], "shift") == 0 && argc >= 4) {
        int x = atoi(argv[2]);
        int s = atoi(argv[3]);
        int y = shift_left(x, s);
        printf("shift: %d << %d = %d\n", x, s, y);
        return 0;
    }
    if (strcmp(argv[1], "oob-read") == 0 && argc >= 3) {
        int *a = malloc(4 * sizeof *a);

        if (a == NULL) {
            return 1;
        }
        for (int i = 0; i < 4; i++) {
            a[i] = i * 10;
        }
        int i = atoi(argv[2]);
        int v = read_at(a, i);
        printf("oob-read: a[%d]=%d (array length 4)\n", i, v);
        free(a);
        return 0;
    }
    if (strcmp(argv[1], "oob-write") == 0 && argc >= 3) {
        int *a = malloc(4 * sizeof *a);

        if (a == NULL) {
            return 1;
        }
        for (int i = 0; i < 4; i++) {
            a[i] = i;
        }
        int i = atoi(argv[2]);
        write_at(a, i, 99);
        printf("oob-write: a[%d]=%d (array length 4)\n", i, read_at(a, i));
        free(a);
        return 0;
    }
    if (strcmp(argv[1], "uaf") == 0) {
        printf("uaf: %d\n", use_after_free());
        return 0;
    }
    if (strcmp(argv[1], "null-guard") == 0) {
        struct Cell c = {42};
        struct Cell *p = (argc > 7) ? &c : NULL;
        printf("null-guard: %d\n", guarded_load(p));
        return 0;
    }
    if (strcmp(argv[1], "race") == 0) {
        printf("race: counter=%d\n", run_race());
        return 0;
    }
    if (strcmp(argv[1], "char-signed") == 0) {
        printf("char-signed: (char)255=%d sizeof(int)=%zu\n",
               signed_char_value(), sizeof(int));
        return 0;
    }
    if (strcmp(argv[1], "layout") == 0) {
        printf("int=%zu pointer=%zu struct-Cell=%zu\n",
               sizeof(int), sizeof(void *), sizeof(struct Cell));
        return 0;
    }

    usage(argv[0]);
    return 2;
}
