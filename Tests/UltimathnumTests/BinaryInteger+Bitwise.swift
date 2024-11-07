//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Bitwise
//*============================================================================*

@Suite struct BinaryIntegerTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/bitwise: from bit",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryInteger
    )   func fromBit(type: any BinaryInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #expect(T(Bit.zero) == (0 as T))
            #expect(T(Bit.one ) == (1 as T))
        }
    }
    
    @Test(
        "BinaryInteger/bitwise: from repeating bit",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryInteger
    )   func fromRepeatingBit(type: any BinaryInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #expect(T(repeating: Bit.zero) == ( 0 as T))
            #expect(T(repeating: Bit.one ) == (~0 as T))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/bitwise: least significant bit",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func lsb(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..<  4 {
                var value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                value = value | 1
                var expectation = true
                
                try withOnlyOneCallToRequire(value) { require in
                    for _ in U8.all {
                        require(value.lsb == Bit(expectation))
                        value = value.incremented().value
                        expectation.toggle()
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise: most significant bit",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func msb(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let expectation = Bit(T.Signitude(raw: value).isNegative)
                try #require( expectation ==  value.msb)
                try #require(~expectation == ~value.msb)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/bitwise: NOT(x)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func not(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = ~a
                
                try #require(a  == b.toggled())
                try Ɣrequire(a, ^, T(repeating: Bit.one), is: b)
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise: x AND y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func and(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try Ɣrequire(a, &, b, is: a & b)
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise: x OR y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func or(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try Ɣrequire(a, |, b, is: a | b)
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise: x XOR y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func xor(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try Ɣrequire(a, ^, b, is: a ^ b)
            }
        }
    }
    
    func Ɣrequire<T>(_ a: T, _ map: (Bit, Bit) -> Bit, _ b: T, is c: T) throws where T: BinaryInteger {
        try withOnlyOneCallToRequire((a, b)) { require in
            require(map(a.appendix, b.appendix) == c.appendix)
            
            a.withUnsafeBinaryIntegerElements { a in
                b.withUnsafeBinaryIntegerElements { b in
                    c.withUnsafeBinaryIntegerElements { c in
                        let max = UX(Swift.max(a.body.count, b.body.count))
                        for major in 0 ..< max {
                            let x = a[major]
                            let y = b[major]
                            let z = c[major]
                            
                            for minor in Shift<T.Element.Magnitude>.all {
                                require(map(x[minor], y[minor]) == z[minor])
                            }
                        }
                    }
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Systems
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/bitwise: byte swapped",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func byteSwapped(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 64,release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = a.reversed(U8.self)
                let c = b.reversed(U8.self)
                
                try #require(a == c)
                
                try a.withUnsafeBinaryIntegerBody(as: U8.self) { a in
                    try b.withUnsafeBinaryIntegerBody(as: U8.self) { b in
                        let x = a.buffer()
                        let y = b.buffer().reversed()
                        try #require(x.elementsEqual(y))
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise: get/set bit at index",
        Tag.List.tags(.generic),
        arguments: typesAsSystemsInteger
    )   func getSetBitAtIndex(type: any SystemsInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            var result: T   = T.zero
            var expectation = T.Magnitude.zero
            let range = 0 ..< IX(size: T.self)

            try #require(result == T(repeating: Bit.zero))

            for index: IX in range {
                expectation <<= T.Magnitude.lsb
                expectation  |= T.Magnitude.lsb
                result[Shift(Count(index))].toggle()
                try #require(result == T(raw: expectation))
            }

            try #require(result == T(repeating: Bit.one))

            for index: IX in range {
                expectation <<= T.Magnitude.lsb
                result[Shift(Count(index))].toggle()
                try #require(result == T(raw: expectation))
            }

            try #require(result == T(repeating: Bit.zero))

            for index: IX in range.reversed() {
                expectation >>= T.Magnitude.lsb
                expectation  |= T.Magnitude.msb
                result[Shift(Count(index))].toggle()
                try #require(result == T(raw: expectation))
            }

            try #require(result == T(repeating: Bit.one))

            for index: IX in range.reversed() {
                expectation >>= T.Magnitude.lsb
                result[Shift(Count(index))].toggle()
                try #require(result == T(raw: expectation))
            }

            try #require(result == T(repeating: Bit.zero))
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Bitwise x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnBitwiseConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/bitwise/conveniences: NOT(x)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func not(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = ~a
                
                try #require(b == a.toggled())
                try #require(b == { var x = a;  x.toggle(); return x }())
                try #require(b == reduce(a, ^,  T(repeating: Bit.one)))
                try #require(b == reduce(a, ^=, T(repeating: Bit.one)))
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise/conveniences: x AND y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func and(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a & b
                
                try #require(c == reduce(a, &=, b))
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise/conveniences: x OR y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func or(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a | b
                
                try #require(c == reduce(a, |=, b))
            }
        }
    }
    
    @Test(
        "BinaryInteger/bitwise/conveniences: x XOR y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func xor(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a ^ b
                
                try #require(c == reduce(a, ^=, b))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Systems
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/bitwise: x.reversed(U8.self)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func reversed(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< 64 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = a.reversed(U8.self)
                
                try #require(a.endianness(.endianess) == a)
                try #require(a.endianness(.endianess.reversed()) == b)
                try #require(a.endianness(.ascending ).endianness(.ascending ) == a)
                try #require(a.endianness(.ascending ).endianness(.descending) == b)
                try #require(a.endianness(.descending).endianness(.ascending ) == b)
                try #require(a.endianness(.descending).endianness(.descending) == a)
            }
        }
    }
}
