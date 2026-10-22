//! Small analysis-only program, separate from the timed Cargo binaries.
use std::cell::Cell;
struct Guard<'a>(&'a Cell<u64>);
impl Drop for Guard<'_> {
    fn drop(&mut self) {
        self.0.set(self.0.get() + 1);
    }
}
fn conditional(flag: bool, count: &Cell<u64>) {
    let a = Guard(count);
    let b = Guard(count);
    if flag {
        drop(a);
    }
    std::hint::black_box(&b);
}
fn main() {
    let count = Cell::new(0);
    conditional(std::hint::black_box(true), &count);
    assert_eq!(count.get(), 2);
}
