// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

// ANCHOR: enum_test
// Note, that the module has changed!
module book::segment_tests;

use book::segment;

#[test]
fun test_full_enum_cycle() {
    use std::unit_test::assert_eq;

    // Create a vector of different Segment variants.
    let segments = vector[
        segment::new_empty(),
        segment::new_string("hello"),
        segment::new_special(b" ", 0), // plaintext
        segment::new_string("move"),
        segment::new_special(b"21", 1), // hex
    ];

    // Aggregate all segments into the final string using `vector::fold!` macro.
    let result = segments.fold!(b"".to_string(), |mut acc, segment| {
        // Do not append empty, only `Special` and `String`.
        if (!segment.is_empty()) {
            acc.append(segment.to_string());
        };
        acc
    });

    // Check that the result is what's expected.
    assert_eq!(result, "hello move!");
}
// ANCHOR_END: enum_test
