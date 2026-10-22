fn main() { let data = vec![1u8]; drop(data); println!("{}", data.len()); }
