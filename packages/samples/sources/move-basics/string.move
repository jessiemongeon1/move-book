// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

#[allow(unused_variable)]
// ANCHOR: custom
module book::custom_string;

/// Anyone can implement a custom string-like type by wrapping a vector.
public struct MyString {
    bytes: vector<u8>,
}

/// Implement a `from_bytes` function to convert a vector of bytes to a string.
public fun from_bytes(bytes: vector<u8>): MyString {
    MyString { bytes }
}

/// Implement a `bytes` function to convert a string to a vector of bytes.
public fun bytes(self: &MyString): &vector<u8> {
    &self.bytes
}
// ANCHOR_END: custom

#[allow(unused_variable)]
#[test]
fun using_strings() {
// ANCHOR: ascii
// the module is `std::ascii` and the type is `String`
use std::ascii::{Self, String};

// strings can be created using the `string` function
// type declaration is not necessary, we put it here for clarity
let hey: String = ascii::string(b"Hey");

// there is a handy alias `.to_ascii_string()` on the `vector<u8>` type
let hey = b"Hey".to_ascii_string();

// string literal is automatically converted to `ascii::String` when the type is known
let hey: String = "Hey";
// ANCHOR_END: ascii
}

#[allow(unused_variable)]
#[test] fun using_strings_utf8() {
// ANCHOR: utf8
// the module is `std::string` and the type is `String`
use std::string::{Self, String};

// strings are normally created using the `utf8` function
// type declaration is not necessary, we put it here for clarity
let hello: String = string::utf8(b"Hello");

// The `.to_string()` alias on the `vector<u8>` is more convenient
let hello = b"Hello".to_string();

// string literal is automatically converted to `String` when the type is known
let hello: String = "Hello";
// ANCHOR_END: utf8
}

#[test] fun safe_strings() {
// ANCHOR: safe_utf8
// this is a valid UTF-8 string
let hello = b"Hello".try_to_string();

assert!(hello.is_some()); // abort if the value is not valid UTF-8

// this is not a valid UTF-8 string
let invalid = b"\xFF".try_to_string();

assert!(invalid.is_none()); // abort if the value is valid UTF-8
// ANCHOR_END: safe_utf8
}

#[allow(unused_variable)]
#[test] fun utf8_common_operations() {
// ANCHOR: utf8_ops
use std::string::String;

let mut str: String = "Hello,";
let another: String = " World!";

// append(String) adds content to the end
str.append(another);

// substring(start, end) copies a slice
str.substring(0, 5); // "Hello"

// length() returns the number of bytes (not characters)
str.length(); // 13 (bytes)

// is_empty() checks if the string has no bytes
str.is_empty(); // false

// index_of(&String) returns the byte position of the first occurrence
// returns `str.length()` if not found
let world: String = "World";
str.index_of(&world); // 7

// insert(at, String) inserts at a byte index
let bang: String = "!";
str.insert(5, bang); // "Hello!, World!"

// append_utf8(vector<u8>) appends raw bytes (must be valid UTF-8)
str.append_utf8(b"!");

// get the underlying byte vector
let bytes: &vector<u8> = str.as_bytes();

// consume the string and get the bytes back
let bytes: vector<u8> = str.into_bytes();
// ANCHOR_END: utf8_ops
}

#[allow(unused_variable)]
#[test] fun utf8_to_ascii() {
// ANCHOR: utf8_to_ascii
let utf8_str: std::string::String = "Hello";
let ascii_str = utf8_str.to_ascii(); // aborts if not valid ASCII
// ANCHOR_END: utf8_to_ascii
}

#[test] fun ascii_safe_creation() {
// ANCHOR: ascii_safe
let valid = b"Hello".try_to_ascii_string();
assert!(valid.is_some());

let invalid = b"\x80".try_to_ascii_string(); // 0x80 is not ASCII
assert!(invalid.is_none());
// ANCHOR_END: ascii_safe
}

#[allow(unused_variable)]
#[test] fun ascii_common_operations() {
// ANCHOR: ascii_ops
use std::ascii::String;

let mut str: String = "Hello";

// append(String) adds content to the end
let suffix: String = ", World!";
str.append(suffix);

// substring(start, end) copies a slice
str.substring(0, 5); // "Hello"

// length() returns the number of bytes (= number of characters for ASCII)
str.length(); // 13

// is_empty() checks if the string has no characters
str.is_empty(); // false

// index_of(&String) returns the position of the first occurrence
// returns `str.length()` if not found
let world: String = "World";
let pos = str.index_of(&world); // 7

// insert(at, String) inserts a string at a given index
let bang: String = "!";
str.insert(5, bang); // "Hello!, World!"

// get the underlying bytes
let bytes: &vector<u8> = str.as_bytes();
// ANCHOR_END: ascii_ops
}

#[test] fun ascii_char_operations() {
// ANCHOR: ascii_char
use std::ascii;

let mut str: ascii::String = "Hello";

// push_char / pop_char for character-level manipulation
str.push_char(ascii::char(0x21)); // push '!'
let last = str.pop_char(); // pop '!'
assert!(last.byte() == 0x21);
// ANCHOR_END: ascii_char
}

#[allow(unused_variable)]
#[test] fun ascii_case_conversion() {
// ANCHOR: ascii_case
use std::ascii::String;

let lower: String = "hello";
let upper = lower.to_uppercase(); // "HELLO"
let back = upper.to_lowercase(); // "hello"
// ANCHOR_END: ascii_case
}

#[test] fun ascii_printable_check() {
// ANCHOR: ascii_printable
use std::ascii::String;

let printable: String = "Hello!";
assert!(printable.all_characters_printable()); // true

let with_newline: String = "Hello\n";
assert!(!with_newline.all_characters_printable()); // false
// ANCHOR_END: ascii_printable
}

#[allow(unused_variable)]
#[test] fun ascii_utf8_conversion() {
// ANCHOR: ascii_convert
let ascii_str: std::ascii::String = "Hello";

// ASCII -> UTF-8 (always safe)
let utf8_str = ascii_str.to_string();

// UTF-8 -> ASCII (aborts if the string contains non-ASCII characters)
let back = utf8_str.to_ascii();
// ANCHOR_END: ascii_convert
}
