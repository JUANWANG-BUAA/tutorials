// Diagnostic-only macOS 27 interposer. Pause once after a real pipe/pipe2
// allocation. Compare inherited kernel descriptors at the SAME spawn barrier.
// No fabricated reads/writes, no descriptor flag modification.
#include <fcntl.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
static _Atomic int seen;
static int gate(int result, int fds[2], const char *api) {
    const char *dir = getenv("DRAIN_GATE_DIR");
    if (result == 0 && dir) {
        char path[4096];
        snprintf(path, sizeof(path), "%s/armed", dir);
        const char *nth = getenv("DRAIN_GATE_N");
        int wanted = nth ? atoi(nth) : 1;
        if (access(path, F_OK) == 0 && atomic_fetch_add(&seen, 1) + 1 == wanted) {
            snprintf(path, sizeof(path), "%s/ready", dir);
            FILE *file = fopen(path, "w");
            if (!file) _exit(91);
            fprintf(file, "api=%s pid=%d read_fd=%d flags=%d write_fd=%d flags=%d\n",
                    api, getpid(), fds[0], fcntl(fds[0], F_GETFD), fds[1], fcntl(fds[1], F_GETFD));
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
// References from this interposer image call the original symbols, per dyld's
// interpose contract. dlsym(RTLD_NEXT, "pipe") here recurses; do not use it.
static int gated_pipe(int fds[2]) { return gate(pipe(fds), fds, "pipe"); }
static int gated_pipe2(int fds[2], int flags) { return gate(pipe2(fds, flags), fds, "pipe2"); }
#define INTERPOSE(replacement, original) \
__attribute__((used)) static struct { const void *new_fn; const void *old_fn; } \
interpose_##original __attribute__((section("__DATA,__interpose"))) = { (const void *)replacement, (const void *)original }
INTERPOSE(gated_pipe, pipe);
INTERPOSE(gated_pipe2, pipe2);
