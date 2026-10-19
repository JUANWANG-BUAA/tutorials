/* harden.c — Linux 6.8 · Ubuntu 24.04
 *
 * 一个最小加固链：no_new_privs → 清 capability →（可选）landlock → seccomp。
 *
 *   cc -std=c17 -O2 -Wall -Wextra -Werror harden.c -o harden
 *   ./harden            # seccomp 白名单，openat 返回 EPERM
 *   ./harden --landlock # 先用 landlock 只放行 /usr 的读/执行，再装 seccomp
 *
 * 这不是生产级沙箱：它只演示顺序、返回值与自检。生产代码应使用
 * libseccomp / landlock 库，并把策略做成可测试的配置。
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/audit.h>
#include <linux/capability.h>
#include <linux/filter.h>
#include <linux/landlock.h>
#include <linux/seccomp.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <unistd.h>

#if defined(__x86_64__)
# define DEMO_AUDIT_ARCH AUDIT_ARCH_X86_64
#elif defined(__aarch64__)
# define DEMO_AUDIT_ARCH AUDIT_ARCH_AARCH64
#else
# error "harden.c 只覆盖 x86-64 与 arm64；其他架构请自行补 AUDIT_ARCH_*"
#endif

/* 用 write(2) 而不是 stdio：seccomp 安装后 stdio 的隐式 flushed 也可能被拦。 */
static void say(const char *s)
{
    size_t len = strlen(s);
    size_t off = 0;

    while (off < len) {
        ssize_t n = syscall(SYS_write, STDOUT_FILENO, s + off, len - off);
        if (n < 0) {
            if (errno == EINTR)
                continue;
            return;
        }
        off += (size_t)n;
    }
}

static void sayf(const char *fmt, ...)
{
    char buf[512];
    va_list ap;
    int n;

    va_start(ap, fmt);
    n = vsnprintf(buf, sizeof buf, fmt, ap);
    va_end(ap);
    if (n > 0)
        say(buf);
}

static const char *err_name(int e)
{
    switch (e) {
    case EACCES: return "EACCES";
    case EPERM:  return "EPERM";
    case ENOENT: return "ENOENT";
    default:     return "E?";
    }
}

static int read_effective_caps(uint32_t out[2])
{
    struct __user_cap_header_struct hdr = {
        .version = _LINUX_CAPABILITY_VERSION_3,
        .pid = 0,
    };
    struct __user_cap_data_struct data[2];

    memset(data, 0, sizeof data);
    if (syscall(SYS_capget, &hdr, data) != 0)
        return -1;
    out[0] = data[0].effective;
    out[1] = data[1].effective;
    return 0;
}

/* 返回 0 表示 bounding 也清空了；返回 errno 表示 bounding 没权限动。
 * 注意 CAP_SETPCAP 必须最后 drop：每次 PR_CAPBSET_DROP 都要检查它。 */
static int drop_capabilities(void)
{
    int bounding_err = 0;
    int cap;

    for (cap = 0; cap <= CAP_LAST_CAP; cap++) {
        if (cap == CAP_SETPCAP)
            continue;
        if (prctl(PR_CAPBSET_DROP, cap, 0, 0, 0) != 0) {
            if (errno == EINVAL)   /* 编号不被当前内核支持：跳过 */
                continue;
            bounding_err = errno;
            break;
        }
    }
    if (bounding_err == 0 && prctl(PR_CAPBSET_DROP, CAP_SETPCAP, 0, 0, 0) != 0)
        bounding_err = errno;

    if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_CLEAR_ALL, 0, 0, 0) != 0)
        return -1;

    {
        struct __user_cap_header_struct hdr = {
            .version = _LINUX_CAPABILITY_VERSION_3,
            .pid = 0,
        };
        struct __user_cap_data_struct zero[2];

        memset(zero, 0, sizeof zero);
        if (syscall(SYS_capset, &hdr, zero) != 0)
            return -1;
    }
    return bounding_err;
}

static long landlock_abi(void)
{
    return syscall(__NR_landlock_create_ruleset, NULL, 0,
                   LANDLOCK_CREATE_RULESET_VERSION);
}

/* 只放行 /usr 的读与执行；其余 handled 权限一律拒绝。 */
static int landlock_usr_readonly(void)
{
    long abi = landlock_abi();
    uint64_t fs;
    struct landlock_ruleset_attr attr;
    struct landlock_path_beneath_attr path;
    int ruleset_fd;
    int usr_fd;

    if (abi < 0) {
        sayf("landlock: unavailable (errno=%d)\n", errno);
        return -1;
    }

    fs = LANDLOCK_ACCESS_FS_EXECUTE |
         LANDLOCK_ACCESS_FS_WRITE_FILE |
         LANDLOCK_ACCESS_FS_READ_FILE |
         LANDLOCK_ACCESS_FS_READ_DIR |
         LANDLOCK_ACCESS_FS_REMOVE_DIR |
         LANDLOCK_ACCESS_FS_REMOVE_FILE |
         LANDLOCK_ACCESS_FS_MAKE_CHAR |
         LANDLOCK_ACCESS_FS_MAKE_DIR |
         LANDLOCK_ACCESS_FS_MAKE_REG |
         LANDLOCK_ACCESS_FS_MAKE_SOCK |
         LANDLOCK_ACCESS_FS_MAKE_FIFO |
         LANDLOCK_ACCESS_FS_MAKE_BLOCK |
         LANDLOCK_ACCESS_FS_MAKE_SYM;
    if (abi >= 2)
        fs |= LANDLOCK_ACCESS_FS_REFER;
    if (abi >= 3)
        fs |= LANDLOCK_ACCESS_FS_TRUNCATE;

    memset(&attr, 0, sizeof attr);
    attr.handled_access_fs = fs;
    ruleset_fd = syscall(__NR_landlock_create_ruleset, &attr, sizeof attr, 0);
    if (ruleset_fd < 0) {
        sayf("landlock: create_ruleset failed (errno=%d)\n", errno);
        return -1;
    }

    usr_fd = open("/usr", O_PATH | O_CLOEXEC);
    if (usr_fd < 0) {
        sayf("landlock: open /usr failed (errno=%d)\n", errno);
        close(ruleset_fd);
        return -1;
    }

    memset(&path, 0, sizeof path);
    path.allowed_access = LANDLOCK_ACCESS_FS_READ_FILE |
                          LANDLOCK_ACCESS_FS_READ_DIR |
                          LANDLOCK_ACCESS_FS_EXECUTE;
    path.allowed_access &= fs;
    path.parent_fd = usr_fd;
    if (syscall(__NR_landlock_add_rule, ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
                &path, 0) != 0) {
        sayf("landlock: add_rule failed (errno=%d)\n", errno);
        close(usr_fd);
        close(ruleset_fd);
        return -1;
    }
    close(usr_fd);

    if (syscall(__NR_landlock_restrict_self, ruleset_fd, 0) != 0) {
        sayf("landlock: restrict_self failed (errno=%d)\n", errno);
        close(ruleset_fd);
        return -1;
    }
    close(ruleset_fd);
    sayf("landlock: ABI %ld, only /usr is readable\n", abi);
    return 0;
}

/*
 * 白名单：只允许 write / exit_group。
 *  - arch 不匹配 → KILL_PROCESS（挡住 i386 等其它 ABI）
 *  - nr 带 x32 位 → KILL_PROCESS（x32 与 x86-64 共用 AUDIT_ARCH_X86_64）
 *  - openat / openat2 → EPERM
 *  - 其余 → EPERM（默认拒绝）
 */
static int install_seccomp(void)
{
    struct sock_filter filter[] = {
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
                 (uint32_t)offsetof(struct seccomp_data, arch)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, DEMO_AUDIT_ARCH, 0, 9),
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
                 (uint32_t)offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JGE | BPF_K, 0x40000000U, 7, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_openat, 4, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_openat2, 3, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_write, 3, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_exit_group, 2, 0),
        BPF_STMT(BPF_RET | BPF_K,
                 SECCOMP_RET_ERRNO | (EPERM & SECCOMP_RET_DATA)),
        BPF_STMT(BPF_RET | BPF_K,
                 SECCOMP_RET_ERRNO | (EPERM & SECCOMP_RET_DATA)),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_KILL_PROCESS),
    };
    struct sock_fprog prog = {
        .len = (unsigned short)(sizeof filter / sizeof filter[0]),
        .filter = filter,
    };
    long rc;

    rc = syscall(SYS_seccomp, SECCOMP_SET_MODE_FILTER,
                 SECCOMP_FILTER_FLAG_TSYNC, &prog);
    if (rc == 0)
        return 0;
    /* TSYNC 失败时返回值是 tid，不是 -1；别用 rc == -1 判断。 */
    if (rc > 0)
        sayf("seccomp: TSYNC failed on tid %ld\n", rc);
    else
        sayf("seccomp: install failed (errno=%d)\n", errno);
    return -1;
}

static int probe_open(const char *path)
{
    int fd = open(path, O_RDONLY | O_CLOEXEC);

    if (fd >= 0) {
        close(fd);
        return 0;
    }
    return errno;
}

int main(int argc, char **argv)
{
    int use_landlock = (argc == 2 && strcmp(argv[1], "--landlock") == 0);
    uint32_t caps_before[2] = {0, 0};
    uint32_t caps_after[2] = {0, 0};
    int bounding_err;
    int e;

    sayf("uid=%ld euid=%ld\n", (long)getuid(), (long)geteuid());

    /* ① no_new_privs：之后 exec 不再获得 setuid / file capability。 */
    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) != 0) {
        sayf("prctl(PR_SET_NO_NEW_PRIVS): failed (errno=%d)\n", errno);
        return 1;
    }
    sayf("NoNewPrivs: %d\n", prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0));

    /* ② 清 capability：先 bounding，再 ambient，最后 capset 清零。 */
    if (read_effective_caps(caps_before) != 0) {
        sayf("capget: failed (errno=%d)\n", errno);
        return 1;
    }
    sayf("CapEff before drop: 0x%08x%08x\n", caps_before[1], caps_before[0]);

    bounding_err = drop_capabilities();
    if (bounding_err < 0) {
        sayf("capset: failed (errno=%d)\n", errno);
        return 2;
    }
    if (read_effective_caps(caps_after) != 0) {
        sayf("capget after drop: failed (errno=%d)\n", errno);
        return 2;
    }
    sayf("CapEff after drop:  0x%08x%08x\n", caps_after[1], caps_after[0]);
    if (bounding_err == 0)
        sayf("bounding: dropped 0..%d, CAP_SETPCAP last\n", CAP_LAST_CAP);
    else
        sayf("bounding: skipped (errno=%d; run as root to exercise)\n",
             bounding_err);

    /* ③ landlock 可选：必须在 seccomp 之前，否则自己的过滤器会拦住它。 */
    if (use_landlock) {
        if (landlock_usr_readonly() != 0)
            return 3;
        e = probe_open("/etc/passwd");
        sayf("openat(\"/etc/passwd\") after landlock: %s (%d)\n",
             err_name(e), e);
        if (e != EACCES)
            return 4;
    }

    /* ④ seccomp 最后：装上之后只允许 write 与 exit_group。 */
    if (install_seccomp() != 0)
        return 5;
    say("seccomp: filter installed (TSYNC)\n");

    e = probe_open("/etc/passwd");
    sayf("openat(\"/etc/passwd\") after seccomp: %s (%d)\n", err_name(e), e);
    if (e != EPERM)
        return 6;

    say("result: OK\n");
    syscall(SYS_exit_group, 0);
    return 0;
}
