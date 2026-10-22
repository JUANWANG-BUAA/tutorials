#define _POSIX_C_SOURCE 200809L
#include "bridge.h"
#include <assert.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define WORDS 8192u
#define REPEATS 64u
#define CASES 4u
#define OBSERVATIONS 21u

static uint64_t input[WORDS], output[WORDS];
static volatile uint64_t sink;
static const char *names[CASES] = {"per_element", "batch", "copy_out", "owned_handle"};

static uint64_t reference(uint64_t x) {
    return (x ^ (x >> 29)) * UINT64_C(0x9e3779b97f4a7c15) + UINT64_C(0x243f6a8885a308d3);
}

static uint64_t now_ns(void) {
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) abort();
    return (uint64_t)ts.tv_sec * UINT64_C(1000000000) + (uint64_t)ts.tv_nsec;
}

static void check(int32_t code) {
    if (code != RB_OK) {
        fprintf(stderr, "benchmark API error=%" PRId32 "\n", code);
        abort();
    }
}

static uint64_t expected(unsigned which) {
    uint64_t sum = 0;
    for (unsigned rep = 0; rep != REPEATS; ++rep) {
        for (unsigned i = 0; i != WORDS; ++i) {
            uint64_t x = which < 2 ? input[i] : UINT64_C(97) + rep + i;
            sum += reference(x);
        }
    }
    return sum;
}

/* Every timed case computes the same mathematical sum in its pair. Per-element
 * and batch include identical C checksum loops. Ownership cases both include
 * generate+release; only copy_out materializes another full C output buffer. */
static uint64_t run_case(unsigned which) {
    uint64_t sum = 0;
    for (unsigned rep = 0; rep != REPEATS; ++rep) {
        if (which == 0) {
            for (unsigned i = 0; i != WORDS; ++i) check(rb_mix(input[i], &output[i]));
        } else if (which == 1) {
            check(rb_transform(input, output, WORDS));
        } else {
            rb_handle handle = 0;
            check(rb_generate(UINT64_C(97) + rep, WORDS, &handle));
            if (which == 2) {
                uint64_t written = 0;
                check(rb_copy(handle, output, WORDS, &written));
                if (written != WORDS) abort();
            } else {
                rb_info_v1 info;
                check(rb_info(handle, RB_ABI_VERSION, sizeof(info), &info));
                if (info.len != WORDS) abort();
                sum += info.checksum;
            }
            check(rb_release(handle));
        }
        if (which != 3) {
            for (unsigned i = 0; i != WORDS; ++i) sum += output[i];
        }
    }
    return sum;
}

int main(int argc, char **argv) {
    double profile_seconds = 0;
    if (argc == 3 && strcmp(argv[1], "--profile-seconds") == 0) {
        char *end;
        profile_seconds = strtod(argv[2], &end);
        if (*end || profile_seconds <= 0 || profile_seconds > 120) return 2;
    } else if (argc != 1) return 2;
    for (unsigned i = 0; i != WORDS; ++i) input[i] = UINT64_C(0x100000000) + i * UINT64_C(17);
    uint64_t checksums[CASES];
    for (unsigned c = 0; c != CASES; ++c) checksums[c] = expected(c);
    assert(checksums[0] == checksums[1]);
    assert(checksums[2] == checksums[3]);
    /* Each case gets >=500ms warmup, not just 500ms shared among four cases. */
    for (unsigned c = 0; c != CASES; ++c) {
        uint64_t start = now_ns();
        do {
            uint64_t actual = run_case(c);
            if (actual != checksums[c]) abort();
            sink = actual;
        } while (now_ns() - start < UINT64_C(500000000));
    }
    if (profile_seconds > 0) {
        uint64_t start = now_ns();
        unsigned c = 0;
        do {
            uint64_t actual = run_case(c);
            if (actual != checksums[c]) abort();
            sink = actual;
            c = (c + 1) % CASES;
        } while ((double)(now_ns() - start) < profile_seconds * 1e9);
        return 0;
    }
    puts("case,observation,elapsed_ns,words,checksum");
    for (unsigned observation = 0; observation != OBSERVATIONS; ++observation) {
        for (unsigned order = 0; order != CASES; ++order) {
            unsigned c = (observation + order) % CASES;
            uint64_t start = now_ns();
            uint64_t actual = run_case(c);
            uint64_t elapsed = now_ns() - start;
            if (actual != checksums[c]) abort();
            sink = actual;
            printf("%s,%u,%" PRIu64 ",%u,%016" PRIx64 "\n",
                   names[c], observation + 1, elapsed, WORDS * REPEATS, actual);
        }
    }
    return 0;
}
