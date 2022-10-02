use crate::entry::Entry;
use std::collections::{HashMap, LinkedList};

pub struct Cache<'a, T> {
  map: HashMap<String, Entry<T>>,
  ll: LinkedList<&'a Entry<T>>,
  siz: usize,
}

impl<'a, T> Cache<'a, T> {
  pub fn get(&mut self, key: &str) -> Option<&T> {
    if let Some(entry) = self.map.get(key) {
      // TODO: move entry to front, fix lifetime error
      // self.ll.push_front( entry);
      Some(&entry.value)
    } else {
      None
    }
  }

  pub fn get_mut(&mut self, key: &str) -> Option<&mut T> {
    // TODO
    None
  }
}
