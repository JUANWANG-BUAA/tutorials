/* proc_stat_exit.c — 证明 /proc/PID/stat 的 exit_code 是 wait 编码，不是低 8 位退出码。
 *
 * 子进程 exit(42)。父进程用 waitid(WNOWAIT) 让子进程保持僵尸，读
 * /proc/PID/stat 的第 52 个字段，再 waitpid 取 wait status 对比。
 *
 * 预期（Linux 6.8）：
 *   /proc exit_code = 10752 (0x2a00)
 *   wait status     = 0x2a00
 *   WEXITSTATUS     = 42
 *
 * 编译：cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g proc_stat_exit.c -o proc_stat_exit
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

static int read_exit_code(pid_t pid, long *out) {
    char path[64], buf[4096];
    snprintf(path, sizeof path, "/proc/%ld/stat", (long)pid);
    int fd = open(path, O_RDONLY);
    if (fd < 0) return -1;
    ssize_t n = read(fd, buf, sizeof buf - 1);
    close(fd);
    if (n <= 0) return -1;
    buf[n] = '\0';

    /* comm 可能含空格与括号，所以从最后一个 ')' 之后开始数。 */
    char *p = strrchr(buf, ')');
    if (!p || p[1] != ' ') return -1;
    p += 2;
    /* 此时 p 指向 field 3 (state)；field 52 是第 50 个 token（从 0 数）。 */
    for (int field = 3; field < 52; field++) {
        p = strchr(p, ' ');
        if (!p) return -1;
        p++;
    }
    char *end = NULL;
    errno = 0;
    long v = strtol(p, &end, 10);
    if (errno || end == p) return -1;
    *out = v;
    return 0;
}

int main(void) {
    pid_t pid = fork();
    if (pid == -1) { perror("fork"); return 1; }
    if (pid == 0) {
        _exit(42);
    }

    siginfo_t si;
    memset(&si, 0, sizeof si);
    if (waitid(P_PID, (id_t)pid, &si, WEXITED | WNOWAIT) == -1) {
        perror("waitid");
        return 1;
    }

    long exit_code = -1;
    if (read_exit_code(pid, &exit_code) == -1) {
        perror("read_exit_code");
        return 1;
    }

    int status = 0;
    if (waitpid(pid, &status, 0) == -1) { perror("waitpid"); return 1; }

    printf("/proc exit_code = %ld (0x%lx)\n", exit_code, (unsigned long)exit_code);
    printf("wait status     = 0x%04x\n", (unsigned)status);
    printf("WEXITSTATUS     = %d\n", WEXITSTATUS(status));
    printf("low byte        = 0x%02x\n", (unsigned)(status & 0xff));
    printf("status & 0xff   = %d  (wrong if treated as exit code)\n", status & 0xff);

    if (exit_code != status) {
        fprintf(stderr, "mismatch: /proc exit_code != wait status\n");
        return 2;
    }
    if (WEXITSTATUS(status) != 42) {
        fprintf(stderr, "unexpected exit code\n");
        return 3;
    }
    return 0;
}
