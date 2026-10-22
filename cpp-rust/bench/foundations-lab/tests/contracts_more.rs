use foundations_lab::try_build;
use std::cell::{Cell, RefCell};
use std::rc::Rc;

struct Counted(Rc<Cell<usize>>);
impl Drop for Counted {
    fn drop(&mut self) {
        self.0.set(self.0.get() + 1);
    }
}

#[test]
fn successful_return_transfers_cleanup() {
    let count = Rc::new(Cell::new(0));
    let values = try_build::<_, ()>(5, |_| Ok(Counted(Rc::clone(&count))))
        .expect("all elements constructed");
    assert_eq!(count.get(), 0);
    let moved = values;
    assert_eq!(count.get(), 0);
    drop(moved);
    assert_eq!(count.get(), 5);
}

#[test]
fn partial_move_drops_each_resource_once() {
    let count = Rc::new(Cell::new(0));
    let pair = (Counted(Rc::clone(&count)), Counted(Rc::clone(&count)));
    let first = pair.0;
    drop(first);
    assert_eq!(count.get(), 1);
    drop(pair.1);
    assert_eq!(count.get(), 2);
}

#[test]
fn taking_ownership_leaves_valid_empty_container() {
    let count = Rc::new(Cell::new(0));
    let mut original = vec![Counted(Rc::clone(&count))];
    let moved = std::mem::take(&mut original);
    assert!(original.is_empty());
    drop(original);
    assert_eq!(count.get(), 0);
    drop(moved);
    assert_eq!(count.get(), 1);
}

struct Logged {
    id: u8,
    events: Rc<RefCell<Vec<u8>>>,
}
impl Drop for Logged {
    fn drop(&mut self) {
        self.events.borrow_mut().push(self.id);
    }
}

#[test]
fn fields_and_locals_have_different_drop_order() {
    let events = Rc::new(RefCell::new(Vec::new()));
    {
        let _first_local = Logged {
            id: 1,
            events: Rc::clone(&events),
        };
        let _second_local = Logged {
            id: 2,
            events: Rc::clone(&events),
        };
    }
    assert_eq!(*events.borrow(), [2, 1]);
    events.borrow_mut().clear();
    let fields = (
        Logged {
            id: 3,
            events: Rc::clone(&events),
        },
        Logged {
            id: 4,
            events: Rc::clone(&events),
        },
    );
    drop(fields);
    assert_eq!(*events.borrow(), [3, 4]);
}
