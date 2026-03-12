// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

#[allow(unused_field, unused_variable, unused_use)]
// ANCHOR: vec_map
module book::collections_vec_map;

use std::string::String;
use sui::vec_map::{Self, VecMap};

public struct Metadata has drop {
    name: String,
    /// `VecMap` used in the struct definition
    attributes: VecMap<String, String>
}

#[test]
fun vec_map_playground() {
    let mut map = vec_map::empty<u8, String>(); // create an empty map

    map.insert(2, "two"); // add a key-value pair to the map
    map.insert(3, "three");

    assert!(map.contains(&2)); // check if a key is in the map

    map.remove(&2); // remove a key-value pair from the map
}
// ANCHOR_END: vec_map
