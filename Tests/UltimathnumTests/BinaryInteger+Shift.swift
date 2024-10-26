//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Shift
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShift {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift: down(Shift<T.Magnitude>)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func down(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 32, release: 1024) {
                let s = IX.random(in: 0..<size, using: &randomness)!
                let a = T.entropic(size:  size, using: &randomness)
                let b = a.down(Shift<T.Magnitude>(Count(s)))
                
                try withOnlyOneCallToRequire((a, s, b)) { require in
                    a.withUnsafeBinaryIntegerElements(as: U8.self) { a in
                        b.withUnsafeBinaryIntegerElements(as: U8.self) { b in
                            for (i, j) in zip(s...s+size, 0...size) {
                                let x = a[UX(i / 8)][Shift(Count(i % 8))]
                                let y = b[UX(j / 8)][Shift(Count(j % 8))]
                                require(x == y)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift: up(Shift<T.Magnitude>)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func up(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 32, release: 1024) {
                let s = IX.random(in: 0...size-1, using: &(randomness))
                let a = T.entropic(size:  size-s*IX(Bit(T.isArbitrary)), using: &randomness)
                let b = a.up(Shift<T.Magnitude>(Count(s)))
                
                if  T.isArbitrary {
                    try #require(a.entropy() <= Count(size))
                    try #require(b.entropy() <= Count(size))
                }
                
                try withOnlyOneCallToRequire((a, s, b)) { require in
                    a.withUnsafeBinaryIntegerElements(as: U8.self) { a in
                        b.withUnsafeBinaryIntegerElements(as: U8.self) { b in
                            for (i, j) in zip(-s..<size-s, 0..<size) {
                                if  i.isNegative {
                                    let x = Bit.zero
                                    let y = b[UX(j / 8)][Shift(Count(j % 8))]
                                    require(x == y)
                                }   else {
                                    let x = a[UX(i / 8)][Shift(Count(i % 8))]
                                    let y = b[UX(j / 8)][Shift(Count(j % 8))]
                                    require(x == y)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnShiftConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/conveniences: masking",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func masking(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: SystemsInteger, U: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 128) {
                let (random) = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.entropic(through: Shift.max(or: 255), using: &randomness)
                
                let up   = random.up  (Shift<T.Magnitude>(masking: distance))
                let down = random.down(Shift<T.Magnitude>(masking: distance))
                
                try #require(reduce(random, &<<,  distance) == up)
                try #require(reduce(random, &<<=, distance) == up)
                try #require(reduce(random, &>>,  distance) == down)
                try #require(reduce(random, &>>=, distance) == down)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/conveniences: down(Shift<T.Magnitude>) vs positive distance in ±[0, size)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func downVersusPositiveDistanceFromZeroUpToSize(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            let size =  IX(size: T.self) ?? 256
            let clamped = IX(U(clamping: size - 1))
            
            for _ in 0 ..< conditional(debug: 32, release: 128) {
                let distance = IX.random(in: 0...clamped, using: &randomness)
                let random = T.entropic(size: (((size))), using: &randomness)
                let expectation = random.down(Shift<T.Magnitude>(Count(distance)))
                try #require(expectation == reduce(random, >>,  U(distance)))
                try #require(expectation == reduce(random, >>=, U(distance)))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/conveniences: down(Shift<T.Magnitude>) vs negative distance in ±[0, size)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func downVersusNegativeDistanceFromZeroUpToSize(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryIntegerAsSigned {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: SignedInteger {
            let size =  IX(size: T.self) ?? 256
            let clamped = IX(U(clamping: size - 1))
            
            for _ in 0 ..< conditional(debug: 32, release: 128) {
                let distance = IX.random(in: 0...clamped, using: &randomness)
                let random = T.entropic(size: (((size))), using: &randomness)
                let expectation = random.down(Shift<T.Magnitude>(Count(distance)))
                try #require(expectation == reduce(random, <<,  U(-distance)))
                try #require(expectation == reduce(random, <<=, U(-distance)))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/conveniences: up(Shift<T.Magnitude>) vs positive distance in ±[0, size)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func upVersusPositiveDistanceFromZeroUpToSize(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            let size =  IX(size: T.self) ?? 256
            let clamped = IX(U(clamping: size - 1))
            let arbitrary = IX(Bit(T.isArbitrary))
            
            for _ in 0 ..< conditional(debug: 32, release: 128) {
                let distance = IX.random(in: 0...clamped, using: &randomness)
                let random = T.entropic(size: size-distance*arbitrary, using: &randomness)
                let expectation = random.up(Shift<T.Magnitude>(Count(distance)))
                try #require(expectation == reduce(random, <<,  U(distance)))
                try #require(expectation == reduce(random, <<=, U(distance)))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/conveniences: up(Shift<T.Magnitude>) vs negative distance in ±[0, size)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func upVersusNegativeDistanceFromZeroUpToSize(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryIntegerAsSigned {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: SignedInteger {
            let size =  IX(size: T.self) ?? 256
            let clamped = IX(U(clamping: size - 1))
            let arbitrary = IX(Bit(T.isArbitrary))
            
            for _ in 0 ..< conditional(debug: 32, release: 128) {
                let distance = IX.random(in: 0...clamped, using: &randomness)
                let random = T.entropic(size: size-distance*arbitrary, using: &randomness)
                let expectation = random.up(Shift<T.Magnitude>(Count(distance)))
                try #require(expectation == reduce(random, >>,  U(-distance)))
                try #require(expectation == reduce(random, >>=, U(-distance)))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShiftEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/edge-cases: distance of zero yields input",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func distanceOfZeroYieldsInput(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(random == random.up  (Count.zero))
                try #require(random == random.down(Count.zero))
                try #require(random == random.up  (Shift.min ))
                try #require(random == random.down(Shift.min ))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: down by distance near nonappendix count",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func downByDistanceNearNonappendixCount(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 256 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let nonappendix = IX(raw: random.nondescending(random.appendix))
                let overshifted = T(repeating: random.appendix)
                
                if  let distance = Count.exactly(nonappendix - 1)?.optional() {
                    try #require(random.down(distance) == (overshifted ^ 1))
                }
                
                try #require(random.down(Count(nonappendix    )) == overshifted)
                try #require(random.down(Count(nonappendix + 1)) == overshifted)
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: up by distance to start of next element",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func upByDistanceToStartOfNextElement(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                var expectation = random
                
                for distance in 0 ... IX(size:T.Element.self) {
                    try #require((expectation) == random.up(Count(distance)))
                    expectation = expectation.plus(expectation).value
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x |distance| > (size) is overshift
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by Count or Shift in ±[size, IX.max]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func overshiftByCountOrShiftFromSizeThroughLimit(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            let size = IX(size: T.self)
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = Count(raw: IX.random(in: size...IX.max, using: &randomness))
                
                try #require(random.up  (Count(raw: distance)).isZero)
                try #require(random.down(Count(raw: distance)) == T(repeating: random.appendix))
                
                if  let distance = Shift<T.Magnitude>(exactly: distance) {
                    try #require(random.up  (distance).isZero)
                    try #require(random.down(distance) == T(repeating: random.appendix))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by positive distance in ±[size, IX.max]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func overshiftByPositiveDistanceFromSizeThroughLimit(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: SystemsInteger, U: BinaryInteger {
            guard let min = U.exactly(IX(size: T.self)).optional() else { return }
            let max = U(clamping: IX.max)
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.random(in: min...max, using: &randomness)

                try #require(distance.isPositive)
                try #require(distance.magnitude() >= IX(size: T.self))
                try #require(distance.magnitude() <= IX.max)
                try #require((random << distance).isZero)
                try #require((random >> distance) == T(repeating: random.appendix))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by negative distance in ±[size, IX.max]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func overshiftByNegativeDistanceFromSizeThroughLimit(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: SystemsInteger, U: BinaryInteger {
            guard let max = U.exactly(-IX(size: T.self)).optional() else { return }
            let min = U(clamping: -IX.max)
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.random(in: min...max, using: &randomness)
                
                try #require(distance.isNegative)
                try #require(distance.magnitude() >= IX(size: T.self))
                try #require(distance.magnitude() <= IX.max)
                try #require((random << distance) == T(repeating: random.appendix))
                try #require((random >> distance).isZero)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x |distance| > IX.max is overshift (by protocol)
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by positive distance in ±(IX.max, ∞)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func overshiftByPositiveDistanceGreaterThanLimit(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            guard let min = U.exactly(UX.msb).optional() else { return }
            let max = U(clamping: IXL(Array(repeating: U64.max, count: 4)))
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.random(in: min...max, using: &randomness)
                
                try #require(distance.isInfinite  == false)
                try #require(distance.magnitude() > IX.max)
                try #require((random << distance).isZero)
                try #require((random >> distance) == T(repeating: random.appendix))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by negative distance in ±(IX.max, ∞)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func overshiftByNegativeDistanceGreaterThanLimit(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            guard let max = U.exactly(IX.min).optional() else { return }
            let min = U(clamping:-IXL(Array(repeating: U64.max, count: 4)))
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.random(in: min...max, using: &randomness)
                
                try #require(distance.isInfinite  == false)
                try #require(distance.magnitude() > IX.max)
                try #require((random << distance) == T(repeating: random.appendix))
                try #require((random >> distance).isZero)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x |distance| > IX.max is overshift (by protocol)
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by infinite Count or Shift",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func overshiftByInfiniteCountOrShift(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)

        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = Count(raw: IX.random(in:  IX.negatives, using: &randomness)!)
                
                try #require(distance.isInfinite)
                try #require(random.up  (Count(raw: distance)).isZero)
                try #require(random.down(Count(raw: distance)) == T(repeating: random.appendix))
                
                if  let distance = Shift<T.Magnitude>(exactly: distance) {
                    try #require(T.isArbitrary)
                    try #require(distance.isInfinite)
                    try #require(random.up  (distance).isZero)
                    try #require(random.down(distance) == T(repeating: random.appendix))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: overshift by infinite ArbitraryInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func overshiftByInfiniteArbitraryInteger(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        for distance in typesAsArbitraryIntegerAsUnsigned {
            try whereIs(type, distance)
        }

        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) throws where T: BinaryInteger, U: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let random   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.entropic(through: Shift.max(or: 255), as: Domain.natural, using: &randomness).toggled()

                try #require(distance.isInfinite)
                try #require((random << distance).isZero)
                try #require((random >> distance) == T(repeating: random.appendix))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Disambiguation
//*============================================================================*

@Suite(.tags(.disambiguation)) struct BinaryIntegerTestsOnShiftDisambiguation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/exponentiation/disambiguation: literals",
        Tag.List.tags(.generic)
    )   func literals() {
        func build<T>(_ x: inout T) where T: BinaryInteger {
            x <<= 0
            x >>= 0
            
            _ = x << 0
            _ = x >> 0
        }
        
        func build<T>(_ x: inout T) where T: SystemsInteger {
            x  <<= 0
            x &<<= 0
            x  >>= 0
            x &>>= 0
            
            _ = x  << 0
            _ = x &<< 0
            _ = x  >> 0
            _ = x &>> 0
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation/disambiguation: smart shift by IX vs Swift.Int",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func smartByTokenVersusSwiftToken(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
                
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                var distance = IX.entropic(using: &randomness)
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                if  T.isArbitrary {
                    distance = IX.random(in: -256...256)
                }
                
                try #require(reduce(random, <<,  distance) == reduce(random, <<,  Swift.Int(distance)))
                try #require(reduce(random, <<=, distance) == reduce(random, <<=, Swift.Int(distance)))
                try #require(reduce(random, >>,  distance) == reduce(random, >>,  Swift.Int(distance)))
                try #require(reduce(random, >>=, distance) == reduce(random, >>=, Swift.Int(distance)))
            }
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation/disambiguation: masking swift as IX vs Swift.Int",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func maskingByTokenVersusSwiftToken(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< 32 {
                let distance = IX.entropic(using: &randomness)
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                try #require(reduce(random, &<<,  distance) == reduce(random, &<<,  Swift.Int(distance)))
                try #require(reduce(random, &<<=, distance) == reduce(random, &<<=, Swift.Int(distance)))
                try #require(reduce(random, &>>,  distance) == reduce(random, &>>,  Swift.Int(distance)))
                try #require(reduce(random, &>>=, distance) == reduce(random, &>>=, Swift.Int(distance)))
            }
        }
    }
}
