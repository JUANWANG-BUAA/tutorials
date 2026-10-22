use std::hint::black_box;
fn main() {
    const COUNT: usize = 4096;
    let bytes = systems_lab::encode_frames(COUNT, 1024);
    let expected = systems_lab::view_batch(&bytes, COUNT, false);
    systems_lab::measure(&["owned_copy", "borrowed_view"], COUNT, |case| {
        let sum = systems_lab::view_batch(black_box(&bytes), COUNT, case == 0);
        assert_eq!(sum, expected);
        sum
    });
}
