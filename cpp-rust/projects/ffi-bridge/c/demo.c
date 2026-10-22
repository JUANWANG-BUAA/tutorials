#include "bridge.h"
#include <errno.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "usage: %s SEED WORDS\n", argv[0]);
        return 2;
    }
    uint64_t args[2];
    for (int i = 0; i != 2; ++i) {
        char *end = NULL;
        errno = 0;
        unsigned long long n = strtoull(argv[i + 1], &end, 10);
        if (errno || end == argv[i + 1] || *end || argv[i + 1][0] == '-') {
            fprintf(stderr, "invalid unsigned integer: %s\n", argv[i + 1]);
            return 2;
        }
        args[i] = (uint64_t)n;
    }
    rb_handle handle = 0;
    int32_t code = rb_generate(args[0], args[1], &handle);
    if (code != RB_OK) {
        fprintf(stderr, "generate error=%" PRId32 "\n", code);
        return 1;
    }
    rb_info_v1 info = {0};
    code = rb_info(handle, RB_ABI_VERSION, sizeof(info), &info);
    int32_t release = rb_release(handle); /* cleanup even if info failed */
    if (code != RB_OK || release != RB_OK) {
        fprintf(stderr, "info error=%" PRId32 " release=%" PRId32 "\n", code, release);
        return 1;
    }
    printf("abi=%" PRIu32 " words=%" PRIu64 " checksum=%016" PRIx64 "\n",
           info.abi_version, info.len, info.checksum);
    return 0;
}
