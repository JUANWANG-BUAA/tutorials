/* clone_order.c — 证明 clone(2) 的可变参数顺序是 parent_tid → tls → child_tid。
 *
 * 原型：
 *   int clone(int (*fn)(void *), void *stack, int flags, void *arg,
 *             ... 先 parent_tid，再 tls，最后 child_tid);
 *
 * 这里同时用 CLONE_PARENT_SETTID 与 CLONE_CHILD_SETTID，因此必须按顺序传三个
 * 可变参数：&parent_tid, NULL, &child_tid。
 * 若把 child_tid 放到第二个位置（tls 的位置），内核会把它当 TLS 指针，
 * 轻则 CLONE_CHILD_SETTID 不生效，重则子进程崩溃。
 *
 * 编译（Linux）：cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 clone_order.c -o clone_order
 */
#define _GNU_SOURCE
#include <errno.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#define STACK_SIZE (1 << 20)

static int child_fn(void *arg) {
    (void)arg;
    return 0;
}

int main(void) {
    char *stack = malloc(STACK_SIZE);
    if (!stack) { perror("malloc"); return 1; }

    pid_t parent_tid = 0;
    pid_t child_tid = 0;
    int flags = CLONE_PARENT_SETTID | CLONE_CHILD_SETTID | SIGCHLD;

    /*                        fn        stack top           flags  arg  parent_tid   tls   child_tid */
    pid_t pid = clone(child_fn, stack + STACK_SIZE, flags, NULL, &parent_tid, NULL, &child_tid);
    if (pid == -1) {
        perror("clone");
        free(stack);
        return 1;
    }

    int status = 0;
    if (waitpid(pid, &status, 0) == -1) {
        perror("waitpid");
        free(stack);
        return 1;
    }
    printf("pid=%ld parent_tid=%ld child_tid=%ld WEXITSTATUS=%d\n",
           (long)pid, (long)parent_tid, (long)child_tid, WEXITSTATUS(status));
    free(stack);
    return 0;
}
