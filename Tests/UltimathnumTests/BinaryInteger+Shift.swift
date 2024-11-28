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
import TestKit

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
    )   func down(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
    )   func up(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
// MARK: * Binary Integer x Shift x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShiftEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/edge-cases: nonshift",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func nonshift(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, using: &randomness)
                try #require(value == value.up  (Count.zero))
                try #require(value == value.down(Count.zero))
                try #require(value == value.up  (Shift.min ))
                try #require(value == value.down(Shift.min ))
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: down by distance near nonappendix count",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func downByDistanceNearNonappendixCount(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 256 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, using: &randomness)
                let nonappendix = IX(raw: value.nondescending(value.appendix))
                let overshifted = T(repeating: value.appendix)
                
                if  let distance = Count.exactly(nonappendix - 1)?.optional() {
                    try #require(value.down(distance) == (overshifted ^ 1))
                }
                
                try #require(value.down(Count(nonappendix    )) == overshifted)
                try #require(value.down(Count(nonappendix + 1)) == overshifted)
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/edge-cases: up by distance to start of next element",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func upByDistanceToStartOfNextElement(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, using: &randomness)
                var expectation = value
                
                for distance in 0 ... IX(size: T.Element.self) {
                    try #require((expectation) == value.up(Count(distance)))
                    expectation = expectation.plus(expectation).value
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Overshifts
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShiftOvershifts {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Distance is Count or Shift
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/overshifts: Count or Shift ∈ ℕ",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func distanceIsFiniteCountOrShift(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            let size = IX(size: T.self)
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let value = T.entropic(using: &randomness)
                let distance = Count(raw: IX.random(in: size...IX.max, using: &randomness))
                
                try #require(!distance.isInfinite)
                try #require(value.up  (Count(raw: distance)).isZero)
                try #require(value.down(Count(raw: distance)) == T(repeating: value.appendix))
                
                if  let distance = Shift<T.Magnitude>(exactly: distance) {
                    try #require(value.up  (distance).isZero)
                    try #require(value.down(distance) == T(repeating: value.appendix))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/overshifts: Count or Shift ∉ ℕ",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func distanceIsInfiniteCountOrShift(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let zeros = UX(raw:  value.ascending(Bit.zero))
                let limit = UX.max - zeros
                let distance = Count(raw: UX.random(in: limit...UX.max, using: &randomness))
                
                try #require(distance.isInfinite)
                try #require(value.up  (Count(raw: distance)).isZero)
                try #require(value.down(Count(raw: distance)) == T(repeating: value.appendix))
                
                if  let distance = Shift<T.Magnitude>(exactly: distance) {
                    try #require(value.up  (distance).isZero)
                    try #require(value.down(distance) == T(repeating: value.appendix))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Distance is Binary Integer
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/overshifts: T.size ≤ |distance| ≤ IX.max",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func distanceWhereMagnitudeIsFromSizeThroughLimitAsBinaryInteger(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance: distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, distance: U.Type)
        throws where T: SystemsInteger, U: BinaryInteger {
            
            if  let min = U.exactly(IX(size: T.self)).optional() {
                let max = U(clamping: IX.max)
                
                for _ in 0 ..< conditional(debug: 8, release: 32) {
                    let value    = T.entropic(using: &randomness)
                    let distance = U.random(in: min...max, using: &randomness)
                    
                    try #require((value << distance).isZero)
                    try #require((value >> distance)  == T(repeating: value.appendix))
                }
            }

            if  let max = U.exactly(IX(size: T.self).complement()).optional() {
                let min = U(clamping: IX.max.complement())
                
                for _ in 0 ..< conditional(debug: 8, release: 32) {
                    let value    = T.entropic(using: &randomness)
                    let distance = U.random(in: min...max, using: &randomness)
                    
                    try #require((value << distance)  == T(repeating: value.appendix))
                    try #require((value >> distance).isZero)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/overshifts: distance ∈ ℤ where |distance| > IX.max",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func distanceIsFiniteWhereMagnitudeIsGreaterThanLimitAsBinaryInteger(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance: distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, distance: U.Type)
        throws where T: BinaryInteger, U: BinaryInteger {
            
            if  let min = U.exactly(UX.msb).optional() {
                let max = U(clamping: IXL(Array(repeating: U64.max, count: 4)))
                
                for _ in 0 ..< conditional(debug: 8, release: 32) {
                    let index = Shift<T.Magnitude>.max(or: 255)
                    let value = T.entropic(through: index, using: &randomness)
                    let distance = U.random(in: min...max, using: &randomness)
                    
                    if !T.isArbitrary || value.isZero {
                        try #require((value << distance).isZero)
                    }
                    
                    always: do {
                        try #require((value >> distance) == T(repeating: value.appendix))
                    }
                }
            }
            
            if  let max = U.exactly(IX.min).optional() {
                let min = U(clamping: IXL(Array(repeating: U64.max, count: 4)).negated())
                
                for _ in 0 ..< conditional(debug: 8, release: 32) {
                    let index = Shift<T.Magnitude>.max(or: 255)
                    let value = T.entropic(through: index, using: &randomness)
                    let distance = U.random(in: min...max, using: &randomness)
                    
                    always: do {
                        try #require((value << distance) == T(repeating: value.appendix))
                    }
                    
                    if !T.isArbitrary || value.isZero {
                        try #require((value >> distance).isZero)
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/shift/overshifts: distance ∉ ℤ",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func distanceIsInfiniteAsBinaryInteger(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for distance in typesAsArbitraryIntegerAsUnsigned {
            try whereIs(type, distance)
        }

        func whereIs<T, U>(_ type: T.Type, _ other: U.Type)
        throws where T: BinaryInteger, U: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let value    = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.entropic(through: Shift.max(or: 255), as: Domain.natural, using: &randomness).toggled()

                try #require(distance.isInfinite)
                try #require((value << distance).isZero)
                try #require((value >> distance) == T(repeating: value.appendix))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Overallocations
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShiftOverallocations {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Distance is Count or Shift
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/overallocations: Count or Shift ∉ ℤ (req. exit test)",
        Tag.List.tags(.documentation, .exit, .generic, .todo),
        arguments: typesAsArbitraryInteger
    )   func distanceIsInfiniteAsCountOrShift(
        type: any ArbitraryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryInteger {
            try yay( 0b01, up: Count(raw: UX.max - 0))
//          try nay( 0b01, up: Count(raw: UX.max - 1))
            
            try yay( 0b10, up: Count(raw: UX.max - 0))
            try yay( 0b10, up: Count(raw: UX.max - 1))
//          try nay( 0b10, up: Count(raw: UX.max - 1))
            
            try yay(~0b00, up: Count(raw: UX.max - 0))
//          try nay(~0b00, up: Count(raw: UX.max - 1))
            
            try yay(~0b01, up: Count(raw: UX.max - 0))
            try yay(~0b01, up: Count(raw: UX.max - 1))
//          try nay(~0b01, up: Count(raw: UX.max - 2))
            
            func yay(_ value: T, up count: Count) throws {
                try #require(value.up(count).isZero)
                
                if  let shift = Shift<T.Magnitude>(exactly: count) {
                    try #require(value.up(shift).isZero)
                }
            }
            
            func nay(_ value: T, up count: Count) throws {
                _ = value.up(count) // TODO: req. exit test
                
                if  let shift = Shift<T.Magnitude>(exactly: count) {
                    _ = value.up(shift)
                }
            }
        }
    }
    
    //=----------------------------------------------------------------------------=
    // MARK: Tests x Distance is Binary Integer
    //=----------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/overallocations: BinaryInteger ∈ ℤ (req. exit test)",
        Tag.List.tags(.documentation, .exit, .generic, .todo),
        arguments: typesAsArbitraryInteger, fuzzers
    )   func distanceIsFiniteAsBinaryInteger(
        type: any ArbitraryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for distance in typesAsBinaryInteger {
            try  whereIs(type, distance: distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, distance: U.Type)
        throws where T: ArbitraryInteger, U: BinaryInteger {
            
//          if  let distance = U.exactly(UX.msb).optional() {
//              let value = T.entropic(size: 256, using: &randomness)
//              try nay(value, up:   distance)
//          }

//          if  let distance = U.exactly(IX.min).optional() {
//              let value = T.entropic(size: 256, using: &randomness)
//              try nay(value, down: distance)
//          }
            
            func nay(_ value: T, up   distance: U) throws {
                _ = value << distance // TODO: req. exit test
            }
            
            func nay(_ value: T, down distance: U) throws {
                _ = value >> distance // TODO: req. exit test
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShiftConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/shift/conveniences: masking",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func masking(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func downVersusPositiveDistanceFromZeroUpToSize(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        for distance in typesAsBinaryInteger {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type)
        throws where T: BinaryInteger, U: BinaryInteger {
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
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func downVersusNegativeDistanceFromZeroUpToSize(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for distance in typesAsBinaryIntegerAsSigned {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type)
        throws where T: BinaryInteger, U: SignedInteger {
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
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func upVersusPositiveDistanceFromZeroUpToSize(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func upVersusNegativeDistanceFromZeroUpToSize(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        for distance in typesAsBinaryIntegerAsSigned {
            try whereIs(type, distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type)
        throws where T: BinaryInteger, U: SignedInteger {
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
// MARK: * Binary Integer x Shift x Disambiguation
//*============================================================================*

@Suite struct BinaryIntegerTestsOnShiftDisambiguation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/exponentiation/disambiguation: literals",
        Tag.List.tags(.disambiguation, .generic)
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
        Tag.List.tags(.disambiguation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func smartByTokenVersusSwiftToken(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
        Tag.List.tags(.disambiguation, .generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func maskingByTokenVersusSwiftToken(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
