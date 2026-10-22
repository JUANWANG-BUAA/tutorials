fn main() { let mut data = 7u64; let reader = &data; let writer = &mut data; *writer = 9; println!("{reader}"); }
