# String

Move does not have a primitive string type - strings are represented as byte vectors (`vector<u8>`)
under the hood. The [Standard Library](./standard-library) provides two wrapper types that add
validation and convenience methods: `std::string::String` for UTF-8 encoded strings, and
`std::ascii::String` for ASCII-only strings. Both are widely used, but `std::string` is the default
choice for most applications.

> The Sui execution environment automatically converts string arguments in transaction inputs into
> `String` values. In many cases, you don't need to construct a `String` inside a
> [Transaction Block](./../concepts/what-is-a-transaction) - just pass the byte content directly.

## Strings are bytes

No matter which type of string you use, it is important to know that strings are just bytes. The
wrappers provided by the `string` and `ascii` modules are just that: wrappers. They do provide
safety checks and methods to work with strings, but at the end of the day, they are just vectors of
bytes.

```move file=packages/samples/sources/move-basics/string.move anchor=custom

```

## String Literals and Byte Vectors

Move has two syntaxes for creating byte vectors (see [Expressions](./expression#literals)). The
`b"..."` form creates a `vector<u8>` from a UTF-8 byte sequence, and `x"..."` creates a
`vector<u8>` from hex-encoded bytes:

```move
let bytes: vector<u8> = b"Hello";           // byte vector from UTF-8 content
let hex_bytes: vector<u8> = x"48656C6C6F";  // byte vector from hex, same as b"Hello"
```

These are byte vector literals, not string literals - they produce `vector<u8>` values.

String literals use the `"..."` syntax (without the `b` prefix). The compiler automatically converts
them to the expected type based on context - `vector<u8>`, `string::String`, or `ascii::String`.
String literals support escape sequences: `\\`, `\n`, `\t`, `\r`, `\0`, and `\x<hex>` for arbitrary
byte values.

```move
use std::string;
use std::ascii;

// compiler infers the correct type from context
let bytes: vector<u8> = "Hello";
let utf8: string::String = "Hello";
let ascii: ascii::String = "Hello";

// escape sequences work in string literals
let with_newline: string::String = "Hello\n";
```

String literals make code more readable when the expected type is clear from context, such as
function arguments or typed bindings.

## UTF-8 Strings

The `std::string` module is the default string type in Move. It uses native (VM-level)
implementations for validation and operations, making it more performant than the ASCII module. Use
this type unless you specifically need ASCII-only features like case conversion or character access.

### Definition

```move
module std::string;

/// A `String` holds a sequence of bytes which is guaranteed to be in utf8 format.
public struct String has copy, drop, store {
    bytes: vector<u8>,
}
```

_See [full documentation for std::string][string-stdlib] module._

### Creating a String

Use `string::utf8` to create a string from bytes, or the `.to_string()` alias on `vector<u8>`:

```move file=packages/samples/sources/move-basics/string.move anchor=utf8

```

If the bytes may not be valid UTF-8, use `try_utf8` (or `.try_to_string()`) which returns
`Option<String>` instead of aborting:

```move file=packages/samples/sources/move-basics/string.move anchor=safe_utf8

```

> Hint: Functions starting with `try_*` return an `Option` - `Some` on success, `None` on failure.
> This convention is common in Move and inspired by Rust.

### Common Operations

```move file=packages/samples/sources/move-basics/string.move anchor=utf8_ops

```

### Character Boundaries

UTF-8 is a variable-length encoding where characters can be 1 to 4 bytes. The `length()` method
returns bytes, not characters, and there is no way to access individual characters. Methods like
`substring` and `insert` enforce valid character boundaries - they abort if an index falls in the
middle of a multi-byte character.

### Converting to ASCII

A UTF-8 string can be converted to an ASCII string if all its bytes are valid ASCII:

```move file=packages/samples/sources/move-basics/string.move anchor=utf8_to_ascii

```

## ASCII Strings

The `std::ascii` module provides a string type that only allows valid ASCII characters (bytes in the
range `0x00` to `0x7F`). It also defines a `Char` type for individual ASCII characters. Unlike
`std::string`, the ASCII module is implemented entirely in Move (no native functions), but it offers
features that UTF-8 strings don't have, such as character-level access, case conversion, and
printability checks.

### Definition

```move
module std::ascii;

/// A `String` holds a sequence of bytes that are all valid ASCII characters.
public struct String has copy, drop, store {
    bytes: vector<u8>,
}

/// An ASCII character.
public struct Char has copy, drop, store {
    byte: u8,
}
```

_See [full documentation for std::ascii][ascii-stdlib] module._

### Creating an ASCII String

Use `ascii::string` to create an ASCII string from bytes. The function aborts if any byte is not
valid ASCII. The alias `.to_ascii_string()` is available on `vector<u8>` for convenience.

```move file=packages/samples/sources/move-basics/string.move anchor=ascii

```

For safe creation, use `ascii::try_string`, which returns `Option<String>`:

```move file=packages/samples/sources/move-basics/string.move anchor=ascii_safe

```

### Common Operations

ASCII strings support operations similar to UTF-8 strings, plus character-level access and case
conversion:

```move file=packages/samples/sources/move-basics/string.move anchor=ascii_ops

```

### Character Operations

Unlike UTF-8 strings, ASCII strings support character-level operations through the `Char` type:

```move file=packages/samples/sources/move-basics/string.move anchor=ascii_char

```

### Case Conversion

ASCII strings provide `to_uppercase` and `to_lowercase` for case conversion:

```move file=packages/samples/sources/move-basics/string.move anchor=ascii_case

```

### Printability Check

Not all ASCII characters are printable (e.g., control characters like `\n` or `\t`). Use
`all_characters_printable` to check:

```move file=packages/samples/sources/move-basics/string.move anchor=ascii_printable

```

### Converting Between String Types

ASCII strings can be converted to UTF-8 strings (every valid ASCII string is valid UTF-8):

```move file=packages/samples/sources/move-basics/string.move anchor=ascii_convert

```

## Further Reading

- [std::string][string-stdlib] module documentation.
- [std::ascii][ascii-stdlib] module documentation.

[enum-reference]: /reference/enums.html
[string-stdlib]: https://docs.sui.io/references/framework/std/string
[ascii-stdlib]: https://docs.sui.io/references/framework/std/ascii
