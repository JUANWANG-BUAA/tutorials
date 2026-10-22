#ifndef RB_BRIDGE_H
#define RB_BRIDGE_H
#include <stddef.h>
#include <stdint.h>

/* Contract for every pointer parameter:
 * - nonzero regions belong to one valid allocation, with correct alignment;
 * - inputs contain initialized uint64_t values and stay immutable during call;
 * - outputs are writable and exclusively accessed for the entire call;
 * - all parameter regions in one call are pairwise disjoint;
 * - no concurrent access to the same output, even through another pointer.
 * Numeric/null checks cannot prove allocation validity, lifetime or provenance.
 * Empty data regions accept NULL. Metadata outputs never accept NULL.
 * No pointer or borrowed reference is retained after return.
 * Never free Rust storage with free(): only rb_release consumes a handle.
 * Handles belong to this loaded library instance, not to files/processes.
 * A handle is NOT an authorization token. Copies are not extra owners.
 */
#ifdef __cplusplus
extern "C" {
#endif

typedef uint64_t rb_handle;
enum rb_status {
    RB_OK = 0, RB_EINVAL = 1, RB_ERANGE = 2, RB_ESTALE = 3,
    RB_ECAPACITY = 4, RB_EPANIC = 5, RB_EPOISON = 6, RB_ERESOURCE = 7
};
#define RB_ABI_VERSION UINT32_C(1)
#define RB_MAX_WORDS (UINT64_C(1) << 24)

typedef struct rb_info_v1 {
    uint32_t abi_version;
    uint32_t struct_size;
    uint64_t len;
    uint64_t checksum;
} rb_info_v1;

/* This distribution supports 64-bit native targets; fail loudly elsewhere. */
_Static_assert(sizeof(void *) == 8, "64-bit target required");
_Static_assert(sizeof(rb_handle) == 8, "handle size");
_Static_assert(sizeof(rb_info_v1) == 24, "v1 size");
_Static_assert(_Alignof(rb_info_v1) == 8, "v1 alignment");
_Static_assert(offsetof(rb_info_v1, abi_version) == 0, "version offset");
_Static_assert(offsetof(rb_info_v1, struct_size) == 4, "size offset");
_Static_assert(offsetof(rb_info_v1, len) == 8, "length offset");
_Static_assert(offsetof(rb_info_v1, checksum) == 16, "checksum offset");

int32_t rb_mix(uint64_t value, uint64_t *out);
/* Disjoint input/output, never an in-place transform. */
int32_t rb_transform(const uint64_t *input, uint64_t *out, uint64_t len);
/* Copy C-owned initialized input into new immutable Rust storage. */
int32_t rb_create_copy(const uint64_t *input, uint64_t len, rb_handle *out);
/* Produce immutable Rust data: word[i] = mix(seed + i), wrapping mod 2^64. */
int32_t rb_generate(uint64_t seed, uint64_t len, rb_handle *out);
/* Version and exact size are checked before writing the output object. */
int32_t rb_info(rb_handle handle, uint32_t version, uint32_t bytes, rb_info_v1 *out);
/* Capacity failure leaves both output regions unchanged. No partial copy. */
int32_t rb_copy(rb_handle handle, uint64_t *out, uint64_t capacity, uint64_t *written);
/* Linearization: one release succeeds; later lookups are stale. An operation
 * that already took an internal Arc snapshot may finish after release returns.
 * Other library calls are thread-safe on distinct output allocations.
 * Do not unload the library while any calls or handles remain in flight.
 */
int32_t rb_release(rb_handle handle);
#ifdef RB_TEST_HOOKS
/* Test builds only. The default panic hook may print; no unwind crosses C. */
int32_t rb_test_panic(void);
#endif
#ifdef __cplusplus
}
#endif
#endif
