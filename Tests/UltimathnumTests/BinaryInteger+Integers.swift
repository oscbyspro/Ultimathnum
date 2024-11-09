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
// MARK: * Binary Integer x Integers
//*============================================================================*

@Suite struct BinaryIntegerTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers: random in bounds",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func randomInBounds(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                for _ in 0 ..< conditional(debug: 32, release: 256) {
                    let source: A  = A.entropic(in: B.self,or: 255, using: &randomness)
                    let magnitude: A.Magnitude = source.magnitude()
                    let destination: B = B(source)
                    //=--------------------------=
                    require(source == A(destination))
                    require(source == B(destination))
                    //=--------------------------=
                    require(destination == B(load: source))
                    
                    if !source.isNegative {
                        require(destination == B(                 magnitude: magnitude))
                        require(destination == B(sign: Sign.plus, magnitude: magnitude))
                    }
                    
                    if !source.isPositive {
                        require(destination == B(sign: Sign.minus, magnitude: magnitude))
                    }
                    
                    source.withUnsafeBinaryIntegerElements {
                        require(destination == B(load: $0))
                        require(destination == B($0, mode: A.mode))
                        require(destination == B($0.body.buffer(), repeating: $0.appendix, mode: A.mode))
                    }
                    
                    source.withUnsafeBinaryIntegerElements(as: U8.self) {
                        require(destination == B(load: $0))
                        require(destination == B($0, mode: A.mode))
                        require(destination == B($0.body.buffer(), repeating: $0.appendix, mode: A.mode))
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers: random vs alternatives",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func randomVersusAlternatives(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                let size = IX(size: B.self) ?? (1 + 256)
                let min: B = B(repeating: Bit(B.isSigned)).up(Count(size - 1))
                let max: B = min.toggled()
                //=------------------------------=
                let mask01: A = A(repeating: Bit.one).up(B.size)
                let mask10: A = mask01.toggled()
                //=------------------------------=
                for _ in 0 ..< conditional(debug: 32, release: 256) {
                    let source: A  = A.entropic(through: Shift.max(or: 255), using: &randomness)
                    let magnitude: A.Magnitude = source.magnitude()
                    let destination: Fallible<B> = B.exactly(source)
                    let backtracked: A = A(load: destination.value)
                    let isSameIsNegative = source.isNegative == destination.value.isNegative
                    let isSameIsInfinite = source.isInfinite == destination.value.isInfinite
                    let isSameAppendixRange: Bool = isSameIsNegative && isSameIsInfinite
                    //=--------------------------=
                    require(destination.value == B(load: source))
                    require(destination.error == (source < min || max < source))
                    //=--------------------------=
                    if  A.size <= B.size {
                        require(backtracked == source)
                        require(destination.error == !isSameAppendixRange)
                        
                    }   else if Bool(destination.value.appendix) {
                        require(backtracked == source | mask01)
                        require(destination.error == !isSameAppendixRange || (backtracked != source))

                    }   else {
                        require(backtracked == source & mask10)
                        require(destination.error == !isSameAppendixRange || (backtracked != source))
                    }
                    
                    if !source.isNegative {
                        require(destination == B.exactly(                 magnitude: magnitude))
                        require(destination == B.exactly(sign: Sign.plus, magnitude: magnitude))
                    }
                    
                    if !source.isPositive {
                        require(destination == B.exactly(sign: Sign.minus, magnitude: magnitude))
                    }
                    
                    source.withUnsafeBinaryIntegerElements {
                        require(destination.value == B(load: $0))
                        require(destination == B.exactly($0, mode: A.mode))
                        require(destination == B.exactly($0.body.buffer(), repeating: $0.appendix, mode: A.mode))
                    }
                    
                    source.withUnsafeBinaryIntegerElements(as: U8.self) {
                        require(destination.value == B(load: $0))
                        require(destination == B.exactly($0, mode: A.mode))
                        require(destination == B.exactly($0.body.buffer(), repeating: $0.appendix, mode: A.mode))
                    }
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Edge Cases
//*============================================================================*

@Suite(.tags(.important)) struct BinaryIntegerTestsOnIntegersEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/edge-cases: ± zero is zero",
        Tag.List.tags(.generic, .exhaustive)
    )   func initPlusMinusZeroIsZero() throws {
        for source in typesAsBinaryIntegerAsUnsigned {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: UnsignedInteger, B: BinaryInteger {
            for sign in Sign.all {
                try #require(B(sign: sign, magnitude: A.Magnitude.zero).isZero)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Destination Edges
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/integers/edge-cases: Destination.min",
        Tag.List.tags(.generic)
    )   func destinationMinValue() throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsEdgyInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: BinaryInteger, B: EdgyInteger {
            let source: Fallible<A> = A.exactly(B.min)
            switch (A.mode, A.size.compared(to: B.size), B.mode) {
            case ( _,  _, .u): fallthrough
            case (.s, .z,  _): fallthrough
            case (.s, .p,  _): try #require(source.map(B.exactly).optional() == B.min)
            default:           try #require(source.error)
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/edge-cases: Destination.min - 1",
        Tag.List.tags(.generic)
    )   func destinationMinValueMinusOne() throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsEdgyInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: BinaryInteger, B: EdgyInteger {
            let source: Fallible<A> = A.exactly(B.min).map{$0.decremented()}
            switch (A.mode, A.size.compared(to: B.size), B.mode) {
            case (.s,  _, .u): fallthrough
            case (.s, .p,  _): try #require(B.exactly(#require(source.optional())) == B.min.decremented())
            default:           try #require(source.error)
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/edge-cases: Destination.max",
        Tag.List.tags(.generic)
    )   func destinationMaxValue() throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsEdgyInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: BinaryInteger, B: EdgyInteger {
            let source: Fallible<A> = A.exactly(B.max)
            switch (A.mode, A.size.compared(to: B.size), B.mode) {
            case ( _, .p,  _): fallthrough
            case (.u, .z,  _): fallthrough
            case (.s, .z, .s): try #require(source.map(B.exactly).optional() == B.max)
            default:           try #require(source.error)
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/edge-cases: Destination.max + 1",
        Tag.List.tags(.generic)
    )   func destinationMaxValuePlusOne() throws {
        for source in typesAsBinaryInteger {
            for destination in typesAsEdgyInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: BinaryInteger, B: EdgyInteger {
            let source: Fallible<A> = A.exactly(B.max).map{$0.incremented()}
            switch (A.mode, A.size.compared(to: B.size), B.mode) {
            case ( _, .p,  _): fallthrough
            case (.u, .z, .s): try #require(B.exactly(#require(source.optional())) == B.max.incremented())
            default:           try #require(source.error)
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
        "BinaryInteger/integers/conveniences: no-ops",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func noops(randomness: consuming FuzzerInt) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(random == T.init(random)) // TODO: cosider whether to keep
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/conveniences: default sign is Sign.plus",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func defaultSignIsPlus(randomness: consuming FuzzerInt) throws {
        for source in typesAsBinaryIntegerAsUnsigned {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: UnsignedInteger, B: BinaryInteger {
            for _ in 0 ..< 8 {
                let value = A.entropic(in: B.self, or: 256, using: &randomness)
                try #require(    value == A(magnitude: value))
                try #require(try value == #require(A.exactly(magnitude: value).optional()))
                try #require(    value == B(magnitude: value))
                try #require(try value == #require(B.exactly(magnitude: value).optional()))
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/conveniences: default appendix is Bit.zero",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func defaultAppendixIsZero(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness)
                try #require(value.appendix.isZero)
                
                try value.withUnsafeBinaryIntegerElements { data in
                    let body: UnsafeBufferPointer = data.body.buffer()
                    try #require(    value == T.init(body))
                    try #require(try value == #require(T.exactly(body).optional()))
                }
                
                try value.withUnsafeBinaryIntegerElements(as: U8.self) { data in
                    let body: UnsafeBufferPointer = data.body.buffer()
                    try #require(    value == T.init(body))
                    try #require(try value == #require(T.exactly(body).optional()))
                }
                
                try value.withUnsafeBinaryIntegerElements {
                    try  opaque($0)
                    func opaque<E>(_ data: DataInt<E>) throws {
                        let body: UnsafeBufferPointer = data.body.buffer()
                        try #require(    value == T.init(body))
                        try #require(try value == #require(T.exactly(body).optional()))
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/integers/conveniences: default mode is Self.mode",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func defaultModeIsMode(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                if !T.isNatural {
                    try #require(value.appendix == Bit.one)
                }
                
                try value.withUnsafeBinaryIntegerElements { data in
                    try #require(value == T.init   (data))
                    try #require(value == T.exactly(data).optional())
                    try #require(value == T.init   (data.body.buffer(), repeating: data.appendix))
                    try #require(value == T.exactly(data.body.buffer(), repeating: data.appendix).optional())
                }
                
                try value.withUnsafeBinaryIntegerElements(as: U8.self) { data in
                    try #require(value == T.init   (data))
                    try #require(value == T.exactly(data).optional())
                    try #require(value == T.init   (data.body.buffer(), repeating: data.appendix))
                    try #require(value == T.exactly(data.body.buffer(), repeating: data.appendix).optional())
                }
                
                try value.withUnsafeBinaryIntegerElements {
                    try  opaque($0)
                    func opaque<E>(_ data: DataInt<E>) throws {
                        try #require(value == T.init   (data))
                        try #require(value == T.exactly(data).optional())
                        try #require(value == T.init   (data.body.buffer(), repeating: data.appendix))
                        try #require(value == T.exactly(data.body.buffer(), repeating: data.appendix).optional())
                    }
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
