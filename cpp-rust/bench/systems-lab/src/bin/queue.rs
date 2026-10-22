fn main() {
    const EACH: usize = 32768;
    systems_lab::measure(&["mutex", "array_queue"], EACH * 2, |case| {
        systems_lab::queue_batch(case == 1, EACH)
    });
}
