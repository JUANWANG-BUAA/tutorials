use std::sync::Arc;
use std::sync::atomic::{AtomicUsize, Ordering};
use systems_lab::*;

#[test]
fn queue_full_returns_ownership_and_fifo() {
    for ring in [false, true] {
        let q = Queue::new(ring, 1);
        assert_eq!(q.push(10), Ok(()));
        assert_eq!(q.push(20), Err(20));
        assert_eq!(q.pop(), Some(10));
        assert_eq!(q.push(20), Ok(()));
        assert_eq!(q.pop(), Some(20));
        assert_eq!(q.pop(), None);
    }
}

#[test]
fn mpmc_exactly_once_multiset() {
    for ring in [false, true] {
        assert_eq!(queue_batch(ring, 2048), (4095_u64 * 4096) / 2);
    }
}

#[test]
fn stalled_participant_prevents_reclamation_without_ub() {
    let collector = crossbeam_epoch::Collector::new();
    let holder = collector.register();
    let worker = collector.register();
    let count = Arc::new(AtomicUsize::new(0));
    let held = holder.pin();
    for _ in 0..4 {
        retire(&worker, &count, 256);
        assert_eq!(count.load(Ordering::Relaxed), 0);
    }
    drop(held);
    drain(&worker, &count, 1024);
    assert_eq!(count.load(Ordering::Relaxed), 1024);
}

#[test]
fn nested_guard_is_not_quiescence() {
    let collector = crossbeam_epoch::Collector::new();
    let holder = collector.register();
    let worker = collector.register();
    let count = Arc::new(AtomicUsize::new(0));
    let outer = holder.pin();
    let inner = holder.pin();
    retire(&worker, &count, 512);
    drop(inner);
    for _ in 0..128 {
        worker.pin().flush();
    }
    assert_eq!(count.load(Ordering::Relaxed), 0);
    drop(outer);
    drain(&worker, &count, 512);
}

#[test]
fn epoch_both_paths_drop_all() {
    assert_eq!(epoch_batch(false, 128), 128);
    assert_eq!(epoch_batch(true, 128), 128);
}

#[test]
fn simd_all_tails_offsets_and_wrapping_match() {
    for n in 0..=257 {
        let input = make_input(n + 7);
        for offset in 0..4 {
            let x = &input[offset..offset + n];
            let expected = x
                .iter()
                .map(|v| v.wrapping_mul(3).wrapping_add(7))
                .collect::<Vec<_>>();
            for function in [scalar_transform, auto_transform, neon_transform] {
                let mut output = vec![0x1234_5678; n + 4];
                function(x, &mut output[1..n + 1]);
                assert_eq!(&output[1..n + 1], expected);
                assert_eq!(output[0], 0x1234_5678);
                assert_eq!(output[n + 1], 0x1234_5678);
            }
        }
    }
}

#[test]
#[should_panic(expected = "assertion `left == right` failed")]
fn mismatched_lengths_fail_before_unsafe_access() {
    neon_transform(&[1, 2, 3, 4], &mut [0; 3]);
}

#[test]
fn malformed_frames_fail_safely() {
    for n in 0..4 {
        assert_eq!(next_frame(&[0; 4][..n], 1024), Err(ParseError::Truncated));
    }
    assert_eq!(next_frame(&[0xff; 4], 1024), Err(ParseError::TooLarge));
    assert_eq!(
        next_frame(&[2, 0, 0, 0, 9], 1024),
        Err(ParseError::Truncated)
    );
    assert_eq!(next_frame(&[0; 4], 1024), Ok((&[][..], &[][..])));
}

#[test]
fn owned_and_borrowed_frame_results_match() {
    for n in [0, 1, 3, 64] {
        for len in [0, 1, 63, 64, 65, 1024] {
            let bytes = encode_frames(n, len);
            assert_eq!(view_batch(&bytes, n, false), view_batch(&bytes, n, true));
        }
    }
}

#[test]
fn safe_logic_aba_is_not_a_data_race() {
    let head = AtomicUsize::new(1);
    let observed = head.load(Ordering::SeqCst);
    head.store(2, Ordering::SeqCst);
    head.store(1, Ordering::SeqCst);
    // A successful CAS cannot prove that the intervening history was empty.
    assert_eq!(
        head.compare_exchange(observed, 3, Ordering::SeqCst, Ordering::SeqCst),
        Ok(1)
    );
}
