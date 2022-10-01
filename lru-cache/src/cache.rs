use crate::entry::Entry;
use std::collections::{HashMap, LinkedList};

pub struct Cache<'a, T> {
  map: HashMap<String, &'a mut Entry<T>>,
  linkedlist: LinkedList<Entry<T>>,
  size: usize,
}

impl<'a, T> Cache<'a, T> {}
