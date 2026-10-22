fn main() { let value: u64; if std::hint::black_box(true) { value = 7; } println!("{value}"); }
