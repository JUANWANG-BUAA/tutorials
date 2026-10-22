use std::hint::black_box;
type TransformFn = fn(&[u32], &mut [u32]);

fn main() {
    const N: usize = 65539;
    const REPEAT: usize = 16;
    let input = systems_lab::make_input(N);
    let expected = input
        .iter()
        .map(|x| x.wrapping_mul(3).wrapping_add(7))
        .collect::<Vec<_>>();
    let mut output = vec![0; N];
    let functions: [TransformFn; 3] = [
        systems_lab::scalar_transform,
        systems_lab::auto_transform,
        systems_lab::neon_transform,
    ];
    systems_lab::measure(&["scalar_call", "auto", "neon"], N * REPEAT, |case| {
        for _ in 0..REPEAT {
            functions[case](black_box(&input), black_box(&mut output));
            black_box(&output);
        }
        assert_eq!(output, expected);
        output.iter().map(|&v| u64::from(v)).sum()
    });
}
