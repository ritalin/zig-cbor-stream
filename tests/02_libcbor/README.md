# libcbor

## Requirement

* Zig 0.14.0 or latter
* libcbor (https://github.com/PJK/libcbor)

## Test recipe

Encode(libcbor) -> Decode(zig-cbor-stream)

* u8, u16, u32, u64 (type 0)
* i8, i16, i32, i64 (type 1)
* utf8 string (type 3)
* Tuple (type 4)
* Array of unsigned integer
* Array of signed integer
* Array of utf8 string (type 4)
* Array of tuple (type 4)
* Bool value (type 7, short 20, 21)
* Optional value (type 7, short 22)

Encode(zig-cbor-stream) -> Decode(libcbor)

* u8, u16, u32, u64 (type 0)
* i8, i16, i32, i64 (type 1)
* utf8 string (type 3)
* Tuple (type 4)
* Array of unsigned integer
* Array of signed integer
* Array of utf8 string (type 4)
* Array of tuple (type 4)
* Bool value (type 7, short 20, 21)
* Optional value (type 7, short 22)


Unsupported

* Chunked string from (type 3, short 31)
* Chunked string to (type 7, short 31)
* Struct (type 5)
* Array of struct (type 4)
* f16, f32, f64 (type 7, short 25-27)
* Semantic tag (type 6)

