use foundations_lab::{ByteRegion, Case, run};
use std::hint::black_box;
const COUNT: usize = 4096;
const LEN: usize = 64;
fn main() {
    let mut region = ByteRegion::new(COUNT * LEN);
    let mut cases = [
        Case {
            name: "fresh_vec",
            expected: (COUNT * 7) as u64,
            work: Box::new(|| {
                let mut sum = 0;
                for _ in 0..COUNT {
                    let mut bytes = vec![0u8; black_box(LEN)];
                    bytes.fill(7);
                    sum += u64::from(black_box(&bytes)[0]);
                }
                sum
            }),
        },
        Case {
            name: "byte_region",
            expected: (COUNT * 7) as u64,
            work: Box::new(|| {
                region.reset();
                let mut sum = 0;
                for _ in 0..COUNT {
                    let bytes = region.take(black_box(LEN)).expect("fixed capacity");
                    bytes.fill(7);
                    sum += u64::from(black_box(bytes)[0]);
                }
                sum
            }),
        },
    ];
    run(&mut cases, 16, COUNT);
}
