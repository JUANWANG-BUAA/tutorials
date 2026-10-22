use ffi_bridge::*;
use std::mem::{align_of, offset_of, size_of};

#[test]
fn layout_matches_c_v1() {
    assert_eq!(size_of::<InfoV1>(), 24);
    assert_eq!(align_of::<InfoV1>(), 8);
    assert_eq!(offset_of!(InfoV1, abi_version), 0);
    assert_eq!(offset_of!(InfoV1, struct_size), 4);
    assert_eq!(offset_of!(InfoV1, len), 8);
    assert_eq!(offset_of!(InfoV1, checksum), 16);
}

#[test]
fn rust_kernel_matches_ffi_and_errors_are_transactional() {
    let input = [0, 1, u64::MAX, 19, 9000];
    let mut expected = [0; 5];
    transform(&input, &mut expected).expect("equal lengths");
    let mut actual = [0; 5];
    // SAFETY: disjoint live arrays with matching lengths and exclusive output.
    assert_eq!(
        unsafe { rb_transform(input.as_ptr(), actual.as_mut_ptr(), 5) },
        OK
    );
    assert_eq!(actual, expected);
    assert_eq!(transform(&input, &mut actual[..4]), Err(ECAPACITY));
    // SAFETY: zero regions permit null. Oversized length is rejected first.
    unsafe {
        assert_eq!(rb_transform(std::ptr::null(), std::ptr::null_mut(), 0), OK);
        assert_eq!(
            rb_transform(std::ptr::null(), std::ptr::null_mut(), u64::MAX),
            ERANGE
        );
        assert_eq!(rb_mix(1, std::ptr::null_mut()), EINVAL);
        // Creating an unaligned raw Rust pointer is allowed; the export rejects
        // it before dereference or reference formation. No C pointer conversion.
        let bytes = [0u8; 24];
        let base = bytes.as_ptr() as usize;
        let offset = if base.is_multiple_of(8) { 1 } else { 0 };
        let misaligned = bytes.as_ptr().add(offset).cast::<u64>();
        assert_eq!(rb_transform(misaligned, actual.as_mut_ptr(), 1), EINVAL);
    }
}

#[test]
fn cleanup_capacity_stale_and_version() {
    let mut handle = 0;
    let input = [10u64, 20, 30];
    // SAFETY: all passed references/arrays are live, aligned and disjoint.
    unsafe {
        assert_eq!(rb_create_copy(input.as_ptr(), 3, &mut handle), OK);
        let mut info = InfoV1::default();
        assert_eq!(rb_info(handle, 2, 24, &mut info), EINVAL);
        assert_eq!(info, InfoV1::default());
        assert_eq!(rb_info(handle, VERSION, 24, &mut info), OK);
        assert_eq!((info.len, info.checksum), (3, 60));
        let mut out = [999; 2];
        let mut written = 888;
        assert_eq!(
            rb_copy(handle, out.as_mut_ptr(), 2, &mut written),
            ECAPACITY
        );
        assert_eq!(out, [999; 2]);
        assert_eq!(written, 888);
        assert_eq!(rb_release(handle), OK);
        assert_eq!(rb_release(handle), ESTALE);
        assert_eq!(rb_info(handle, VERSION, 24, &mut info), ESTALE);
        let mut replacement = 0;
        assert_eq!(rb_generate(3, 3, &mut replacement), OK);
        assert_ne!(handle, replacement);
        assert_eq!(rb_release(handle), ESTALE);
        assert_eq!(rb_release(replacement), OK);
    }
}

#[test]
fn empty_owned_object_and_bounds() {
    let mut handle = 123;
    // SAFETY: zero lengths permit null, metadata is live and exclusive.
    unsafe {
        assert_eq!(rb_generate(0, MAX_WORDS as u64 + 1, &mut handle), ERANGE);
        assert_eq!(handle, 123);
        assert_eq!(rb_create_copy(std::ptr::null(), 0, &mut handle), OK);
        let mut n = 99;
        assert_eq!(rb_copy(handle, std::ptr::null_mut(), 0, &mut n), OK);
        assert_eq!(n, 0);
    }
    assert_eq!(rb_release(handle), OK);
}

#[test]
fn concurrent_release_is_exactly_once() {
    let mut handle = 0;
    // SAFETY: valid exclusive stack output.
    assert_eq!(unsafe { rb_generate(0, 4096, &mut handle) }, OK);
    let workers: Vec<_> = (0..12)
        .map(|_| std::thread::spawn(move || rb_release(handle)))
        .collect();
    let codes: Vec<_> = workers
        .into_iter()
        .map(|t| t.join().expect("thread"))
        .collect();
    assert_eq!(codes.iter().filter(|&&c| c == OK).count(), 1);
    assert_eq!(codes.iter().filter(|&&c| c == ESTALE).count(), 11);
}

#[test]
fn concurrent_readers_and_release_have_defined_outcomes() {
    let mut handle = 0;
    // SAFETY: valid exclusive stack output.
    assert_eq!(unsafe { rb_generate(42, 8192, &mut handle) }, OK);
    let gate = std::sync::Arc::new(std::sync::Barrier::new(9));
    let workers: Vec<_> = (0..8)
        .map(|_| {
            let gate = gate.clone();
            std::thread::spawn(move || {
                gate.wait();
                let mut info = InfoV1::default();
                // SAFETY: each thread has its own output. Handle lookups synchronize.
                let code = unsafe { rb_info(handle, VERSION, 24, &mut info) };
                assert!(code == OK || code == ESTALE);
                if code == OK {
                    assert_eq!(info.len, 8192);
                }
            })
        })
        .collect();
    gate.wait();
    assert_eq!(rb_release(handle), OK);
    for w in workers {
        w.join().expect("reader");
    }
}
