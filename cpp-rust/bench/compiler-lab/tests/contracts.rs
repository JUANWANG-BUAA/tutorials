use compiler_lab::*;
use std::cell::Cell;

#[test]
fn sums_match_for_tails_and_overflow() {
    for len in [0, 1, 3, 7, 16, 129, 16384] {
        let input = input_data(len);
        let expected = input.iter().copied().fold(0, u64::wrapping_add);
        assert_eq!(borrowed_sum(&input), expected);
        assert_eq!(cloned_sum(&input), expected);
    }
}

#[test]
fn partial_move_drops_exactly_once() {
    for flag in [false, true] {
        let count = Cell::new(0);
        conditional_drop(flag, &count);
        assert_eq!(count.get(), 2);
        option_drop(flag, &count);
        assert_eq!(count.get(), 4);
    }
}

#[test]
fn panic_unwinds_initialized_guards() {
    let count = Cell::new(0);
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        let pair = (DropProbe(&count), DropProbe(&count));
        drop(pair.0);
        panic!("intentional safe regression");
    }));
    assert!(result.is_err());
    assert_eq!(count.get(), 2);
}

#[test]
fn dispatch_preserves_integer_semantics() {
    let kernel = Affine {
        multiplier: 17,
        increment: 29,
    };
    for len in [0, 1, 7, 65, 1000] {
        let input = input_data(len);
        let expected = input
            .iter()
            .map(|&v| v.wrapping_mul(17).wrapping_add(29).rotate_left(7))
            .fold(0, u64::wrapping_add);
        assert_eq!(generic_batch(&kernel, &input), expected);
        assert_eq!(dynamic_items(&kernel, &input), expected);
        assert_eq!(dynamic_batch(&kernel, &input), expected);
        assert_eq!(visible_dynamic(&kernel, &input), expected);
    }
}

#[test]
fn vector_tails_and_max_values() {
    for len in 0..130 {
        let input = input_data(len);
        let mut left = vec![u64::MAX; len];
        let mut right = left.clone();
        add_slices(&mut left, &input);
        add_with_calls(&mut right, &input);
        assert_eq!(left, right);
        for (got, v) in left.iter().zip(input) {
            assert_eq!(*got, v.wrapping_sub(1));
        }
    }
}

#[test]
#[should_panic(expected = "assertion")]
fn unequal_lengths_are_rejected() {
    add_slices(&mut [0; 2], &[1]);
}

#[test]
fn ctfe_exhaustive_domain() {
    assert_eq!(BIT_TABLE, runtime_table());
    for v in 0u8..=255 {
        assert_eq!(u32::from(BIT_TABLE[usize::from(v)]), v.count_ones());
    }
}

trait Parent {
    fn value(&self) -> u64;
}
trait Child: Parent {}
impl Parent for u64 {
    fn value(&self) -> u64 {
        *self
    }
}
impl Child for u64 {}
#[test]
fn current_stable_supports_trait_upcast() {
    let value = 19u64;
    let child: &dyn Child = &value;
    let parent: &dyn Parent = child;
    assert_eq!(parent.value(), 19);
}
