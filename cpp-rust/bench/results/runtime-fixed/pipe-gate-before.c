// Diagnostic-only macOS interposer. Delay exactly one real pipe() return before
// Rust std can set FD_CLOEXEC; no fabricated bytes or altered read/write results.
#include <dlfcn.h>
#include <fcntl.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
static _Atomic int used;
static int gated_pipe(int fds[2]) {
    int result = pipe(fds);
    const char *dir = getenv("DRAIN_GATE_DIR");
    if (result == 0 && dir) {
        char path[4096];
        snprintf(path, sizeof(path), "%s/armed", dir);
        if (access(path, F_OK) == 0 && !atomic_exchange(&used, 1)) {
            snprintf(path, sizeof(path), "%s/ready", dir);
            FILE *file = fopen(path, "w");
            if (!file) _exit(91);
            fprintf(file, "pid=%d read_fd=%d write_fd=%d\n", getpid(), fds[0], fds[1]);
            fclose(file);
            snprintf(path, sizeof(path), "%s/release", dir);
            for (int i=0; i<10000; ++i) {
                if (access(path, F_OK) == 0) return result;
                usleep(1000);
            }
            _exit(92);
        }
    }
    return result;
}
__attribute__((used)) static struct { const void *replacement; const void *original; }
interpose_pipe __attribute__((section("__DATA,__interpose"))) = { (const void *)gated_pipe, (const void *)pipe };
