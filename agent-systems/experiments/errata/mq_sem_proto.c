/* mq_sem_proto.c — 证明 mq_open / sem_open 是 variadic：
 *   - 带 O_CREAT 时传 4 个参数（name, oflag, mode, attr/value）
 *   - 不带 O_CREAT 时传 2 个参数（name, oflag）
 *
 * 编译（Linux）：cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 mq_sem_proto.c -o mq_sem_proto
 * 链接：-lrt（老 glibc 需要；新 glibc 已并入 libc）
 *
 * 这个程序不要求 mq_open 的两参数调用成功（队列不存在会返回 -1/ENOENT），
 * 只要求它能通过编译与链接，从而证明原型确实是 variadic，而不是固定四参数。
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <mqueue.h>
#include <semaphore.h>
#include <stdio.h>

int main(void) {
    /* 4 参数：带 O_CREAT，必须给 mode 与 attr。 */
    mqd_t q = mq_open("/as-errata-q", O_CREAT | O_RDWR, 0600, NULL);
    if (q == (mqd_t)-1) {
        perror("mq_open create");
    } else {
        if (mq_send(q, "x", 1, 0) == -1) perror("mq_send");
        mq_close(q);
        mq_unlink("/as-errata-q");
    }

    /* 2 参数：不带 O_CREAT，不能传 mode/attr；不存在时返回 ENOENT。 */
    mqd_t q2 = mq_open("/as-errata-missing", O_RDONLY);
    if (q2 == (mqd_t)-1) {
        printf("mq_open 2-arg: errno=%d (%s) — 编译通过即证明 variadic\n",
               errno, errno == ENOENT ? "ENOENT" : "other");
    } else {
        mq_close(q2);
    }

    /* sem_open：4 参数（带 O_CREAT）与 2 参数（不带）。 */
    sem_t *s = sem_open("/as-errata-sem", O_CREAT, 0600, 1);
    if (s == SEM_FAILED) {
        perror("sem_open create");
    } else {
        sem_close(s);
        sem_unlink("/as-errata-sem");
    }

    sem_t *s2 = sem_open("/as-errata-missing-sem", 0);
    if (s2 == SEM_FAILED) {
        printf("sem_open 2-arg: errno=%d (%s) — 编译通过即证明 variadic\n",
               errno, errno == ENOENT ? "ENOENT" : "other");
    } else {
        sem_close(s2);
    }
    return 0;
}
