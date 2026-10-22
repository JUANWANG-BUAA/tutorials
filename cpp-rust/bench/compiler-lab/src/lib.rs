//! Stable compiler experiments; all kernels are safe Rust.
use std::cell::Cell;
use std::hint::black_box;
use std::time::{Duration, Instant};

pub struct Case<'a> {
    pub name: &'a str,
    pub run: Box<dyn FnMut() -> u64 + 'a>,
    pub expected: u64,
}

/// Reports batch means, not a distribution of individual request latencies.
pub fn measure(cases: &mut [Case<'_>], units: usize) {
    assert!(units > 0);
    let mut repeats = Vec::new();
    for case in cases.iter_mut() {
        let start = Instant::now();
        let mut n = 0;
        while start.elapsed() < Duration::from_millis(500) {
            assert_eq!(black_box((case.run)()), case.expected);
            n += 1;
        }
        let ns = start.elapsed().as_secs_f64() * 1e9 / n as f64;
        repeats.push((10_000_000.0 / ns).ceil().max(1.0) as usize);
    }
    println!("case,round,repeats,units,elapsed_ns,ns_per_unit,checksum");
    let mut samples = vec![Vec::new(); cases.len()];
    for round in 0..21 {
        for offset in 0..cases.len() {
            let index = (round + offset) % cases.len();
            let case = &mut cases[index];
            let n = repeats[index];
            let start = Instant::now();
            let mut checksum = 0u64;
            for _ in 0..n {
                checksum = checksum.wrapping_add(black_box((case.run)()));
            }
            let elapsed = start.elapsed().as_nanos();
            assert_eq!(checksum, case.expected.wrapping_mul(n as u64));
            let value = elapsed as f64 / (n * units) as f64;
            samples[index].push(value);
            println!(
                "{},{round},{n},{units},{elapsed},{value:.9},{checksum}",
                case.name
            );
        }
    }
    for (case, values) in cases.iter().zip(samples.iter_mut()) {
        let mean = values.iter().sum::<f64>() / values.len() as f64;
        let sd = (values.iter().map(|v| (v - mean).powi(2)).sum::<f64>()
            / (values.len() - 1) as f64)
            .sqrt();
        values.sort_by(f64::total_cmp);
        println!(
            "summary,{},{mean:.9},{sd:.9},{:.9},{:.9}",
            case.name, values[10], values[20]
        );
    }
}

#[inline(never)]
pub fn borrowed_sum(input: &[u64]) -> u64 {
    input.iter().copied().fold(0, u64::wrapping_add)
}

#[inline(never)]
pub fn cloned_sum(input: &[u64]) -> u64 {
    let owned = black_box(input.to_vec());
    borrowed_sum(&owned)
}

pub struct DropProbe<'a>(pub &'a Cell<u64>);
impl Drop for DropProbe<'_> {
    fn drop(&mut self) {
        self.0.set(self.0.get().wrapping_add(1));
    }
}

#[inline(never)]
pub fn conditional_drop(flag: bool, count: &Cell<u64>) {
    let first = DropProbe(count);
    let second = DropProbe(count);
    if flag {
        drop(first);
    }
    black_box(&second);
}

#[inline(never)]
pub fn option_drop(flag: bool, count: &Cell<u64>) {
    let mut first = Some(DropProbe(count));
    let second = DropProbe(count);
    if flag {
        drop(first.take());
    }
    black_box(&second);
}

pub trait Kernel {
    fn step(&self, value: u64) -> u64;
    fn batch(&self, input: &[u64]) -> u64 {
        input
            .iter()
            .map(|&v| self.step(v))
            .fold(0, u64::wrapping_add)
    }
}

#[derive(Clone, Copy)]
pub struct Affine {
    pub multiplier: u64,
    pub increment: u64,
}
impl Kernel for Affine {
    #[inline]
    fn step(&self, value: u64) -> u64 {
        value
            .wrapping_mul(self.multiplier)
            .wrapping_add(self.increment)
            .rotate_left(7)
    }
}

pub fn generic_batch<T: Kernel>(kernel: &T, input: &[u64]) -> u64 {
    kernel.batch(input)
}

#[inline(never)]
pub fn dynamic_items(kernel: &dyn Kernel, input: &[u64]) -> u64 {
    input
        .iter()
        .map(|&v| kernel.step(v))
        .fold(0, u64::wrapping_add)
}

#[inline(never)]
pub fn dynamic_batch(kernel: &dyn Kernel, input: &[u64]) -> u64 {
    kernel.batch(input)
}

#[inline(never)]
pub fn visible_dynamic(kernel: &Affine, input: &[u64]) -> u64 {
    let erased: &dyn Kernel = kernel;
    erased.batch(input)
}

#[inline(never)]
pub fn add_slices(output: &mut [u64], input: &[u64]) {
    assert_eq!(output.len(), input.len());
    for (out, &value) in output.iter_mut().zip(input) {
        *out = out.wrapping_add(value);
    }
}

#[inline(never)]
pub fn scalar_add(left: u64, right: u64) -> u64 {
    left.wrapping_add(right)
}

#[inline(never)]
pub fn add_with_calls(output: &mut [u64], input: &[u64]) {
    assert_eq!(output.len(), input.len());
    for (out, &value) in output.iter_mut().zip(input) {
        *out = scalar_add(*out, value);
    }
}

pub const fn bit_table() -> [u8; 256] {
    let mut table = [0; 256];
    let mut index = 0;
    while index < table.len() {
        let mut bits = index;
        let mut count = 0;
        while bits != 0 {
            count += (bits & 1) as u8;
            bits >>= 1;
        }
        table[index] = count;
        index += 1;
    }
    table
}

pub static BIT_TABLE: [u8; 256] = bit_table();

#[inline(never)]
pub fn runtime_table() -> [u8; 256] {
    // Runtime black_box prevents replacing this experiment with its const result.
    let seed = black_box(0usize);
    let mut table = [0; 256];
    for (index, slot) in table.iter_mut().enumerate() {
        let mut bits = index + seed;
        let mut count = 0;
        while bits != 0 {
            count += (bits & 1) as u8;
            bits >>= 1;
        }
        *slot = count;
    }
    table
}

#[inline(never)]
pub fn lookup_bits(table: &[u8; 256], input: &[u8]) -> u64 {
    input
        .iter()
        .map(|&v| u64::from(table[usize::from(v)]))
        .sum()
}

pub fn input_data(len: usize) -> Vec<u64> {
    (0..len as u64)
        .map(|i| i.wrapping_mul(6364136223846793005).wrapping_add(1))
        .collect()
}
