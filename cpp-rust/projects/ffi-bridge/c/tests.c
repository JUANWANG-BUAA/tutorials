#include "bridge.h"
#include <assert.h>
#include <pthread.h>
#include <stdio.h>

static uint64_t reference(uint64_t x) {
    return (x ^ (x >> 29)) * UINT64_C(0x9e3779b97f4a7c15) + UINT64_C(0x243f6a8885a308d3);
}

static void *reader(void *argument) {
    const rb_handle handle = *(const rb_handle *)argument;
    for (unsigned i = 0; i != 100; ++i) {
        rb_info_v1 info = {0};
        assert(rb_info(handle, RB_ABI_VERSION, sizeof(info), &info) == RB_OK);
        assert(info.len == 1024);
    }
    return NULL;
}

int main(void) {
    uint64_t input[] = {0, 1, UINT64_MAX, 42};
    uint64_t output[4] = {0};
    assert(rb_transform(input, output, 4) == RB_OK);
    for (unsigned i = 0; i != 4; ++i) {
        uint64_t single = 0;
        assert(rb_mix(input[i], &single) == RB_OK);
        assert(single == output[i] && single == reference(input[i]));
    }
    assert(rb_mix(1, NULL) == RB_EINVAL);
    assert(rb_transform(NULL, NULL, 0) == RB_OK);
    assert(rb_transform(NULL, output, 1) == RB_EINVAL);
    assert(rb_transform(NULL, NULL, UINT64_MAX) == RB_ERANGE);
    /* Safe rejection: overlap is checked before any slice is formed. */
    assert(rb_transform(input, input, 4) == RB_EINVAL);

    rb_handle handle = 0;
    assert(rb_create_copy(input, 4, &handle) == RB_OK);
    input[0] = 999; /* Rust retained a copy, not the C pointer. */
    rb_info_v1 info = {0};
    assert(rb_info(handle, 2, sizeof(info), &info) == RB_EINVAL);
    assert(rb_info(handle, 1, sizeof(info) - 1, &info) == RB_EINVAL);
    assert(info.len == 0);
    uint64_t short_out[2] = {71, 72};
    uint64_t written = 777;
    assert(rb_copy(handle, short_out, 2, &written) == RB_ECAPACITY);
    assert(short_out[0] == 71 && short_out[1] == 72 && written == 777);
    assert(rb_copy(handle, output, 4, &written) == RB_OK);
    assert(output[0] == 0 && written == 4);
    assert(rb_release(handle) == RB_OK);
    assert(rb_release(handle) == RB_ESTALE);
    assert(rb_info(handle, 1, sizeof(info), &info) == RB_ESTALE);

    rb_handle newer = 0;
    assert(rb_generate(19, 1024, &newer) == RB_OK);
    assert(newer != handle);
    assert(rb_release(handle) == RB_ESTALE);
    pthread_t threads[4];
    for (unsigned i = 0; i != 4; ++i) assert(pthread_create(&threads[i], NULL, reader, &newer) == 0);
    for (unsigned i = 0; i != 4; ++i) assert(pthread_join(threads[i], NULL) == 0);
    assert(rb_release(newer) == RB_OK);

    handle = UINT64_C(123);
    assert(rb_generate(0, RB_MAX_WORDS + 1, &handle) == RB_ERANGE);
    assert(handle == 123);
    assert(rb_create_copy(NULL, 0, &handle) == RB_OK);
    assert(rb_copy(handle, NULL, 0, &written) == RB_OK && written == 0);
    assert(rb_release(handle) == RB_OK);
#ifdef RB_TEST_HOOKS
    assert(rb_test_panic() == RB_EPANIC);
    assert(rb_mix(1, &written) == RB_OK); /* subsequent call still works */
#endif
    puts("C11 integration: layout, kernel, errors, cleanup, threads, panic passed");
    return 0;
}
