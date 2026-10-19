/* wait_status.c — 证明 wait status 不是退出码本身。
 *
 * 子进程 exit(42)。父进程打印：
 *   raw status（十六进制）
 *   WIFEXITED / WEXITSTATUS
 *   status 的低字节（很多人误把它当退出码）
 *
 * 预期：raw=0x2a00, WIFEXITED=1, WEXITSTATUS=42, low byte=0x00。
 *
 * 编译：cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g wait_status.c -o wait_status
 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void) {
    pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        return 1;
    }
    if (pid == 0) {
        _exit(42);
    }

    int status = 0;
    if (waitpid(pid, &status, 0) == -1) {
        perror("waitpid");
        return 1;
    }

    printf("raw status      = 0x%04x\n", (unsigned)status);
    printf("WIFEXITED       = %d\n", WIFEXITED(status));
    printf("WEXITSTATUS     = %d\n", WEXITSTATUS(status));
    printf("low byte        = 0x%02x\n", (unsigned)(status & 0xff));
    printf("WIFSIGNALED     = %d\n", WIFSIGNALED(status));

    /* 反面教材：直接把 status 当退出码，得到 10752，不是 42。 */
    printf("status as int   = %d  (wrong)\n", status);
    return 0;
}
