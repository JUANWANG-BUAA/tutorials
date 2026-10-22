//! Fixed-size desktop experiments; CSV values are batch means, not request latency.
use std::hint::black_box;
use std::time::{Duration, Instant};

pub const N: usize = 65_536;
pub const ROUNDS: usize = 21;

pub struct Case<'a> {
    pub name: &'static str,
    pub work: Box<dyn FnMut() -> u64 + 'a>,
    pub expected: u64,
}

/// Timer surrounds a batch; validate every output after the stop timestamp.
pub fn run(cases: &mut [Case<'_>], iterations: usize, units: usize) {
    assert!(iterations > 0 && units > 0 && !cases.is_empty());
    let mut outputs = vec![0; iterations];
    for case in cases.iter_mut() {
        let start = Instant::now();
        while start.elapsed() < Duration::from_millis(500) {
            assert_eq!(black_box((case.work)()), case.expected);
        }
    }
    println!("kind,round,position,case,ns_per_unit,checksum");
    for round in 0..ROUNDS {
        for position in 0..cases.len() {
            let index = (round + position) % cases.len();
            let case = &mut cases[index];
            let start = Instant::now();
            for output in &mut outputs {
                *output = black_box((case.work)());
            }
            let elapsed = start.elapsed();
            assert!(outputs.iter().all(|&v| v == case.expected));
            let ns = elapsed.as_secs_f64() * 1e9 / (iterations * units) as f64;
            println!(
                "raw,{round},{position},{},{ns:.9},{}",
                case.name, case.expected
            );
        }
    }
}

pub fn data(n: usize) -> Vec<u64> {
    (0..n)
        .map(|i| (i as u64).wrapping_mul(17) ^ 0x5a5a)
        .collect()
}

#[inline(never)]
pub fn sum_index(input: &[u64]) -> u64 {
    let mut sum = 0u64;
    let mut i = 0;
    while i < input.len() {
        sum = sum.wrapping_add(input[i]);
        i += 1;
    }
    sum
}

#[inline(never)]
pub fn sum_iter(input: &[u64]) -> u64 {
    input.iter().copied().fold(0u64, u64::wrapping_add)
}

#[inline(never)]
pub fn dce_empty(input: &[u64]) -> u64 {
    let _ = input.iter().copied().fold(0u64, u64::wrapping_add);
    0
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct Record {
    pub hot: u64,
    pub cold: [u64; 7],
}

#[inline(never)]
pub fn sum_aos(input: &[Record]) -> u64 {
    input
        .iter()
        .fold(0u64, |sum, row| sum.wrapping_add(row.hot))
}

#[inline(never)]
pub fn sum_soa(input: &[u64]) -> u64 {
    input.iter().copied().fold(0u64, u64::wrapping_add)
}

/// Initialized byte region, not a GlobalAlloc implementation or a typed arena.
/// Reset requires exclusive access, so existing slices cannot be used afterward.
///
/// ```compile_fail
/// use foundations_lab::ByteRegion;
/// let mut region = ByteRegion::new(64);
/// let slice = region.take(4).expect("capacity");
/// region.reset();
/// slice[0] = 3;
/// ```
pub struct ByteRegion {
    storage: Vec<u8>,
    used: usize,
}

impl ByteRegion {
    pub fn new(capacity: usize) -> Self {
        Self {
            storage: vec![0; capacity],
            used: 0,
        }
    }

    pub fn take(&mut self, len: usize) -> Option<&mut [u8]> {
        let end = self.used.checked_add(len)?;
        let result = self.storage.get_mut(self.used..end)?;
        self.used = end;
        Some(result)
    }

    pub fn reset(&mut self) {
        self.used = 0;
    }
}

#[inline(never)]
pub fn borrowed(input: &[u64]) -> u64 {
    sum_iter(black_box(input))
}

#[inline(never)]
pub fn cloned(input: &[u64]) -> u64 {
    let owned = input.to_vec();
    sum_iter(black_box(&owned))
}

#[inline(never)]
pub fn init_push(n: usize) -> u64 {
    let mut out = Vec::with_capacity(n);
    for i in 0..n {
        out.push((i as u64).wrapping_mul(17));
    }
    sum_iter(black_box(&out))
}

#[inline(never)]
pub fn init_zero(n: usize) -> u64 {
    let mut out = vec![0u64; n];
    for (i, value) in out.iter_mut().enumerate() {
        *value = (i as u64).wrapping_mul(17);
    }
    sum_iter(black_box(&out))
}

/// Error paths drop exactly the initialized prefix using Vec's ownership.
pub fn try_build<T, E>(n: usize, mut make: impl FnMut(usize) -> Result<T, E>) -> Result<Vec<T>, E> {
    let mut out = Vec::with_capacity(n);
    for i in 0..n {
        out.push(make(i)?);
    }
    Ok(out)
}

/// A valid alias-sensitive kernel: caller proves disjointness with split_at_mut.
#[inline(never)]
pub fn copy_add(dst: &mut [u64], src: &[u64]) {
    assert_eq!(dst.len(), src.len());
    for (dst, src) in dst.iter_mut().zip(src) {
        *dst = src.wrapping_add(1);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::cell::Cell;
    use std::rc::Rc;

    #[test]
    fn sums_and_representations_agree() {
        for n in [0, 1, 7, 65, N] {
            let input = data(n);
            let rows: Vec<_> = input
                .iter()
                .map(|&hot| Record { hot, cold: [0; 7] })
                .collect();
            assert_eq!(sum_index(&input), sum_iter(&input));
            assert_eq!(sum_aos(&rows), sum_soa(&input));
            assert_eq!(borrowed(&input), cloned(&input));
            assert_eq!(init_push(n), init_zero(n));
        }
    }

    #[test]
    fn region_capacity_failure_is_transactional() {
        let mut region = ByteRegion::new(8);
        region.take(6).expect("fits").fill(7);
        assert!(region.take(3).is_none());
        assert!(region.take(usize::MAX).is_none());
        assert_eq!(region.take(2).expect("failure preserved cursor"), [0; 2]);
        region.reset();
        assert_eq!(region.take(6).expect("reusable"), [7; 6]);
    }

    struct Tracked(Rc<Cell<usize>>);
    impl Drop for Tracked {
        fn drop(&mut self) {
            self.0.set(self.0.get() + 1);
        }
    }

    #[test]
    fn failure_drops_initialized_prefix() {
        let count = Rc::new(Cell::new(0));
        let result = try_build(8, |i| {
            if i == 3 {
                Err("injected")
            } else {
                Ok(Tracked(Rc::clone(&count)))
            }
        });
        assert!(result.is_err());
        assert_eq!(count.get(), 3);
    }

    #[test]
    fn unwind_drops_initialized_prefix() {
        let count = Rc::new(Cell::new(0));
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let _: Result<Vec<_>, ()> = try_build(8, |i| {
                assert!(i != 4, "injected panic");
                Ok(Tracked(Rc::clone(&count)))
            });
        }));
        assert!(result.is_err());
        assert_eq!(count.get(), 4);
    }

    #[test]
    fn disjoint_borrow_updates_only_destination() {
        let mut input = [10, 20, 0, 0];
        let (src, dst) = input.split_at_mut(2);
        copy_add(dst, src);
        assert_eq!(input, [10, 20, 11, 21]);
    }

    #[test]
    fn dynamic_borrow_conflict_is_safe_failure() {
        let cell = std::cell::RefCell::new(7);
        let first = cell.borrow_mut();
        assert!(cell.try_borrow().is_err());
        drop(first);
        assert_eq!(*cell.borrow(), 7);
    }
}
