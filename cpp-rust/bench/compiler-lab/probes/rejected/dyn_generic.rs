trait Bad { fn apply<T>(&self, value: T); } fn accept(_: &dyn Bad) {} fn main() {}
