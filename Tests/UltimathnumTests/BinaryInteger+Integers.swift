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
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Integers
//*============================================================================*

@Suite struct BinaryIntegerTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Loading vs Exactly vs Trapping
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers: loading vs exactly",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func loadingVersusExactly(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(B(load: source) == B.exactly(source).value)
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers: trapping vs exactly",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func trappingVersusExactly(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(in: B.self, or: 256, using: &randomness)
                try #require(B(source) == B.exactly(source).optional())
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x To & From
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/roundtripping: in exact range",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func rountrippingInExactRange(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(in: B.self, or: 256, using: &randomness)
                let destination = try #require(B.exactly(source).optional())
                let backtracked = try #require(A.exactly(destination).optional())
                try #require(backtracked == source)
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/roundtripping: exactly versus masking",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func rountrippingExactlyVersusMasking(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let destination = B.exactly(source) as Fallible<B>
                let backtracked = A(load: destination.value) as A
                let isSameIsNegative = source.isNegative == destination.value.isNegative
                let isSameIsInfinite = source.isInfinite == destination.value.isInfinite
                let isSameAppendixRange: Bool = isSameIsNegative && isSameIsInfinite
                
                if  A.size <= B.size {
                    try #require(backtracked == source)
                    try #require(destination.error == !isSameAppendixRange)
                    
                }   else if Bool(destination.value.appendix) {
                    let mask = A(repeating: Bit.one).up(B.size)
                    let masked = source | mask
                    try #require(backtracked == masked)
                    try #require(destination.error == ((source != masked) || !isSameAppendixRange))
                    
                }   else {
                    let mask = A(repeating: Bit.one).up(B.size).toggled()
                    let masked = source & mask
                    try #require(backtracked == masked)
                    try #require(destination.error == ((source != masked) || !isSameAppendixRange))
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnIntegersEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/edge-cases: init ± zero is zero",
        Tag.List.tags(.generic, .exhaustive)
    )   func initPlusMinusZeroIsZero() throws {
        for source in typesAsBinaryIntegerAsUnsigned {
            for destination in typesAsBinaryIntegerAsUnsigned {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: UnsignedInteger, B: BinaryInteger {
            for sign in Sign.all {
                try #require(B.zero == B(sign: sign, magnitude: A.zero))
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/edge-cases: round-tripping same or smaller always works",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func roundtrippingSameOrSmallerAlwaysWorks(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            guard A.mode == B.mode else { return }
            guard A.size <= B.size else { return }
            
            for _ in 0 ..< conditional(debug: 8, release: 64) {
                let random = A.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(random == B(random))
                
                try random.withUnsafeBinaryIntegerElements {
                    try #require(random == B($0, mode: B.mode))
                }
                
                try random.withUnsafeBinaryIntegerElements(as: U8.self) {
                    try #require(random == B($0, mode: B.mode))
                }
                
                let sign = Sign(raw: random.isNegative)
                let magnitude: some UnsignedInteger = random.magnitude()
                try #require(random == B(sign: sign, magnitude: magnitude))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnIntegersConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/conveniences: consuming",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func consuming(randomness: consuming FuzzerInt) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 64) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(random == T.init(random))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Data Integer
//*============================================================================*

@Suite struct BinaryIntegerTestsOnIntegersVersusDataInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/data-integer: loading BinaryInteger vs DataInteger",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func loadingBinaryIntegerVersusDataInteger(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let destination = B(load: source)
                
                try source.withUnsafeBinaryIntegerElements {
                    try #require(destination == B(load: $0))
                }
                
                try source.withUnsafeBinaryIntegerElements(as: U8.self) {
                    try #require(destination == B(load: $0))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/data-integer: exactly BinaryInteger vs DataInteger",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func exactlyBinaryIntegerVersusDataInteger(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let destination = B.exactly(source) as Fallible<B>
                
                try source.withUnsafeBinaryIntegerElements {
                    try #require(destination == B.exactly($0, mode: A.mode))
                }
                
                try source.withUnsafeBinaryIntegerElements(as: U8.self) {
                    try #require(destination == B.exactly($0, mode: A.mode))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/data-integer: trapping BinaryInteger vs DataInteger",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func trappingBinaryIntegerVersusDataInteger(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(in: B.self, or: 256, using: &randomness)
                let destination = B(source)
                
                try source.withUnsafeBinaryIntegerElements {
                    try #require(destination == B($0, mode: A.mode))
                }
                
                try source.withUnsafeBinaryIntegerElements(as: U8.self) {
                    try #require(destination == B($0, mode: A.mode))
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Sign & Magnitude
//*============================================================================*

@Suite struct BinaryIntegerTestsOnIntegersVersusSignMagnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/sign-magnitude: exactly BinaryInteger vs Sign & Magnitude",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func exactlyBinaryIntegerVersusSignMagnitude(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let destination = B.exactly(source) as Fallible<B>
                
                let sign = Sign(source.isNegative)
                let magnitude = source.magnitude()
                
                try #require(destination == B.exactly(sign: sign, magnitude: magnitude))
                
                if  sign == Sign.plus {
                    try #require(destination == B.exactly(magnitude: source.magnitude()))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/sign-magnitude: trapping BinaryInteger vs Sign & Magnitude",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func trappingBinaryIntegerVersusSignMagnitude(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let source = A.entropic(in: B.self, or: 256, using: &randomness)
                let destination = B(source)
                
                let sign = Sign(source.isNegative)
                let magnitude = source.magnitude()
                
                try #require(destination == B(sign: sign, magnitude: magnitude))
                
                if  sign == Sign.plus {
                    try #require(destination == B(magnitude: magnitude))
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Sequences
//*============================================================================*

@Suite(.tags(.important)) struct BinaryIntegerTestsOnIntegersUsingSequences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Validates the following sequence:
    ///
    ///     00000000000000000000000000000000 → == 0s
    ///     10000000000000000000000000000000 →
    ///     11000000000000000000000000000000 →
    ///     11100000000000000000000000000000 →
    ///     ................................
    ///     11111111111111111111111111110000 →
    ///     11111111111111111111111111111000 →
    ///     11111111111111111111111111111100 →
    ///     11111111111111111111111111111110 → != 1s
    ///
    @Test(
        "BinaryInteger/integers/generators: rain 0s",
        Tag.List.tags(.generic)
    )   func rain0s() throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                var a = A.zero, x = A.lsb
                var b = B.zero, y = B.lsb
                
                let size = IX(size: A.self) ?? conditional(debug: 64, release: 256)
                for ones in 0 ..< size {
                    let error = switch B.mode {
                    case   .signed: B.size <= Count(ones)
                    case .unsigned: B.size <  Count(ones)
                    }
                    
                    require(B.exactly(a) == b.veto(error))
                    require(a.ascending(Bit.one) == Count(ones))
                    
                    a = a.up(Shift.one) | x
                    b = b.up(Shift.one) | y
                }
            }
        }
    }
    
    /// Validates the following sequence:
    ///
    ///     11111111111111111111111111111111 → == 1s
    ///     01111111111111111111111111111111 →
    ///     00111111111111111111111111111111 →
    ///     00011111111111111111111111111111 →
    ///     ................................
    ///     00000000000000000000000000001111 →
    ///     00000000000000000000000000000111 →
    ///     00000000000000000000000000000011 →
    ///     00000000000000000000000000000001 → != 0s
    ///
    @Test(
        "BinaryInteger/integers/generators: rain 1s",
        Tag.List.tags(.generic)
    )   func rain1s() throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                var mask = B(repeating: Bit.one)
    
                if !A.isSigned {
                    mask = mask.up(A.size).toggled()
                }
    
                always: do {
                    var a = A(repeating: Bit.one)
                    var b = B(repeating: Bit.one)
    
                    let size = IX(size: A.self) ?? conditional(debug: 64, release: 256)
                    for zeros in 0 ..< size {
                        let error = switch (A.mode,  B.mode) {
                        case (  .signed,   .signed): B.size <= Count(zeros)
                        case (  .signed, .unsigned): ((((((true))))))
                        case (.unsigned,   .signed): A.size >= B.size
                        case (.unsigned, .unsigned): A.size >  B.size
                        }

                        b = b & mask
                        
                        require(B.exactly(a) == b.veto(error))
                        require(a.ascending(Bit.zero) == Count(zeros))
                        
                        a = a.up(Shift.one)
                        b = b.up(Shift.one)
                    }
                }
            }
        }
    }
    
    /// Validates the following sequence:
    ///
    ///     00001111111111111111111111111111 →
    ///     10000111111111111111111111111111 →
    ///     11000011111111111111111111111111 →
    ///     11100001111111111111111111111111 →
    ///     ................................
    ///     11111111111111111111111110000111 →
    ///     11111111111111111111111111000011 →
    ///     11111111111111111111111111100001 →
    ///     11111111111111111111111111110000 →
    ///
    @Test(
        "BinaryInteger/integers/generators: slices 0s",
        Tag.List.tags(.generic),
        arguments: IX(1)..<IX(5)
    )   func slices0s(zeros: IX) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                var mask = B(repeating: Bit.one)

                if !A.isSigned {
                    mask = mask.up(A.size).toggled()
                }
                
                var a = A(load: IX(repeating: Bit.one) << zeros), x = A.lsb
                var b = B(load: IX(repeating: Bit.one) << zeros), y = B.lsb
                
                let size = IX(size: A.self) ?? conditional(debug: 64, release: 256)
                for ones in 0 ..< size - zeros + IX(Bit(A.isArbitrary)) {
                    let error = switch (A.mode, B.mode) {
                    case (  .signed,   .signed): B.size <= Count(ones + zeros)
                    case (  .signed, .unsigned): ((((((true))))))
                    case (.unsigned,   .signed): B.size <= A.size
                    case (.unsigned, .unsigned): B.size <  A.size
                    }

                    b = b & mask
                    
                    require(B.exactly(a) == b.veto(error))
                    require(a.count(Bit.zero) == Count(zeros))
                    require(a.ascending(Bit.one) == Count(ones))
                                            
                    a = a.up(Shift.one) | x
                    b = b.up(Shift.one) | y
                }
                
                for ones: IX in CollectionOfOne(size - zeros) where !A.isArbitrary {
                    let error = switch B.mode {
                    case   .signed: B.size <= Count(ones)
                    case .unsigned: B.size <  Count(ones)
                    }
                    
                    b = b & B(load: A.Magnitude(repeating: Bit.one))
                    
                    require(B.exactly(a) == b.veto(error))
                    require(a.descending(Bit.zero) == Count(zeros))
                }
            }
        }
    }
    
    /// Validates the following sequence:
    ///
    ///     11110000000000000000000000000000 →
    ///     01111000000000000000000000000000 →
    ///     00111100000000000000000000000000 →
    ///     00011110000000000000000000000000 →
    ///     ................................
    ///     00000000000000000000000001111000 →
    ///     00000000000000000000000000111100 →
    ///     00000000000000000000000000011110 →
    ///     00000000000000000000000000001111 →
    ///
    @Test(
        "BinaryInteger/integers/generators: slices 1s",
        Tag.List.tags(.generic),
        arguments: IX(1)..<IX(5)
    )   func slices1s(ones: IX) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                let mask = B(load: A.Magnitude(repeating: Bit.one))

                var a = A(load: ~(UX.max << ones))
                var b = B(load: ~(UX.max << ones))
                                
                let size = IX(size: A.self) ?? conditional(debug: 64, release: 256)
                for zeros in 0 ..< size - ones + IX(Bit(A.isArbitrary)) {
                    let error = switch B.mode {
                    case   .signed: B.size <= Count(zeros + ones)
                    case .unsigned: B.size <  Count(zeros + ones)
                    }
                    
                    b = b & mask
                    
                    require(B.exactly(a) == b.veto(error))
                    require(a.count(Bit.one) == Count(ones))
                    require(a.ascending(Bit.zero) == Count(zeros))

                    a = a.up(Shift.one)
                    b = b.up(Shift.one)
                }
                
                for zeros in CollectionOfOne(size - ones) where !A.isArbitrary {
                    let value = A.isSigned ? b ^ mask.toggled() : b & mask
                    let error = switch (A.mode,  B.mode) {
                    case (  .signed,   .signed): B.size <  Count(zeros + ones)
                    case (  .signed, .unsigned): (true)
                    case (.unsigned,   .signed): B.size <= Count(zeros + ones)
                    case (.unsigned, .unsigned): B.size <  Count(zeros + ones)
                    }

                    require(B.exactly(a) == value.veto(error))
                }
            }
        }
    }
}
