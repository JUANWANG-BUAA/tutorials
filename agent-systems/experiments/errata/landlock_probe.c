/* landlock_probe.c — 查询当前内核的 Landlock ABI，并尝试限制自己。
 *
 * 预期（Ubuntu 24.04 / Linux 6.8，Landlock enabled）：ABI = 4。
 * ABI 与内核的对应（man-pages 6.19）：
 *   1  5.13  文件系统
 *   2  5.19  REFER
 *   3  6.2   TRUNCATE
 *   4  6.7   NET_BIND_TCP / NET_CONNECT_TCP
 *   5  6.10  IOCTL_DEV
 *   6  6.12  SCOPE_ABSTRACT_UNIX_SOCKET / SCOPE_SIGNAL
 *   7  6.15  log 控制
 *   8  7.0   TSYNC
 *   9  7.1   RESOLVE_UNIX
 *
 * 编译（Linux）：cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 landlock_probe.c -o landlock_probe
 */
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

#ifndef LANDLOCK_CREATE_RULESET_VERSION
#define LANDLOCK_CREATE_RULESET_VERSION (1U << 0)
#endif

int main(void) {
    long abi = syscall(SYS_landlock_create_ruleset, NULL, 0,
                       LANDLOCK_CREATE_RULESET_VERSION);
    if (abi < 0) {
        perror("landlock_create_ruleset(VERSION)");
        fprintf(stderr,
                "Landlock 不可用：内核未启用 CONFIG_SECURITY_LANDLOCK，"
                "或 lsm= 未包含 landlock\n");
        return 1;
    }
    printf("Landlock ABI = %ld\n", abi);
    if (abi >= 4) {
        printf("网络规则（TCP bind/connect）可用\n");
    } else {
        printf("网络规则不可用；需要 ABI >= 4（Linux 6.7+）\n");
    }
    if (abi >= 6) {
        printf("IPC scoping（abstract unix socket / signal）可用\n");
    }
    return 0;
}
