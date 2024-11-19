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
// MARK: * Binary Integer x Random
//*============================================================================*

@Suite struct BinaryIntegerTestsOnRandom {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Index
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/random: through bit index",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomThroughBitIndex(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 128
            for index in 0 ..< size {
                let limit = index + (T.isSigned ? 1 : 2)
                let index = Shift<T.Magnitude>(Count(index))
                
                while true {
                    let random  = T.random(through: index)
                    let entropy = random.entropy()
                    try #require(entropy >= Count(00001))
                    try #require(entropy <= Count(limit))
                    if  entropy == Count(limit) { break }
                }
                
                while true {
                    let random  = T.random(through: index, using: &randomness)
                    let entropy = random.entropy()
                    try #require(!random.isInfinite)
                    try #require(entropy >= Count(00001))
                    try #require(entropy <= Count(limit))
                    if  entropy == Count(limit) { break }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/random: through bit index has known bounds",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomThroughBitIndexHasKnownBounds(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try require(Shift(Count(0)), T.isSigned ? -001...000 : 000...001)
            try require(Shift(Count(1)), T.isSigned ? -002...001 : 000...003)
            try require(Shift(Count(2)), T.isSigned ? -004...003 : 000...007)
            try require(Shift(Count(3)), T.isSigned ? -008...007 : 000...015)
            try require(Shift(Count(4)), T.isSigned ? -016...015 : 000...031)
            try require(Shift(Count(5)), T.isSigned ? -032...031 : 000...063)
            try require(Shift(Count(6)), T.isSigned ? -064...063 : 000...127)
            try require(Shift(Count(7)), T.isSigned ? -128...127 : 000...255)
            
            func require(_ index: Shift<T.Magnitude>, _ expectation: ClosedRange<T>) throws {
                let middle = T.isSigned ? T.zero : (expectation.upperBound / 2 + 1)
                
                var min = false
                var mid = false
                var max = false
                
                while !(min && mid && max) {
                    let random = T.random(through: index, using: &randomness)
                    guard expectation.contains(random) else {  break }
                    if random == expectation.lowerBound { min = true }
                    if random == ((((((((middle)))))))) { mid = true }
                    if random == expectation.upperBound { max = true }
                }
                
                try #require(min && mid && max)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Range
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/random: in range",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomInRange(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            let min: T = T.minLikeSystemsInteger(size: size)!
            let max: T = T.maxLikeSystemsInteger(size: size)!
            
            let eight: T = T((max.magnitude() + min.magnitude()) / 8 + 1)
            let small: Range<T> = (T.isSigned ? -4..<3 : 0..<8)
            let large: Range<T> = (min + eight)..<(max - eight)
            
            for min: T in small {
                for max: T in min..<small.upperBound {
                    try require(( min)..<( max))
                    try require((~max)..<(~min))
                }
            }
            
            for _ in 0 ..< 16 {
                try require(( large.lowerBound) ..< ( large.upperBound))
                try require((~large.upperBound) ..< (~large.lowerBound))
            }
            
            func require(_ range: Range<T>) throws {
                let a = T.random(in: range)
                let b = T.random(in: range, using: &randomness)
                
                for x in [a, b] {
                    try #require(x == nil ? range.isEmpty : range.contains(x!))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/random: in range has known bounds",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomInRangeHasKnownBounds(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for index: IX in 0 ... 7 {
                let min = T.random(through: Shift(Count(index)), using: &randomness)
                let max = T.random(through: Shift(Count(index)), using: &randomness)
                try require(min <= max ? min..<max : max..<min)
            }
            
            func require(_ expectation: Range<T>) throws {
                guard !expectation.isEmpty else { return }
                let last: T = expectation.upperBound - 1
                
                var min = false
                var max = false
                
                while !(min && max) {
                    let random = T.random(in: expectation, using: &randomness)!
                    guard expectation.contains(random) else {  break }
                    if random == expectation.lowerBound { min = true }
                    if random == (((((((((last))))))))) { max = true }
                }
                
                try #require(min && max)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Closed Range
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/random: in closed range",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomInClosedRange(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            let min: T = T.minLikeSystemsInteger(size: size)!
            let max: T = T.maxLikeSystemsInteger(size: size)!
            
            let eight: T = T((max.magnitude() + min.magnitude()) / 8 + 1)
            let small: ClosedRange<T> = (T.isSigned ? -4...3 : 0...8)
            let large: ClosedRange<T> = (min + eight)...(max - eight)
            
            for min: T in small {
                for max: T in min...small.upperBound {
                    try require(( min)...( max))
                    try require((~max)...(~min))
                }
            }
            
            for _ in 0 ..< 16 {
                try require(( large.lowerBound)...( large.upperBound))
                try require((~large.upperBound)...(~large.lowerBound))
            }
            
            func require(_ range: ClosedRange<T>) throws {
                try #require(range.contains(T.random(in: range)))
                try #require(range.contains(T.random(in: range, using: &randomness)))
            }
        }
    }
    
    @Test(
        "BinaryInteger/random: in closed range has known bounds",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomInClosedRangeHasKnownBounds(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for index: IX in 0 ... 7 {
                let min = T.random(through: Shift(Count(index)), using: &randomness)
                let max = T.random(through: Shift(Count(index)), using: &randomness)
                try require(min <= max ? min...max : max...min)
            }
            
            func require(_ expectation: ClosedRange<T>) throws {
                var min = false
                var max = false
                
                while !(min && max) {
                    let random = T.random(in: expectation, using: &randomness)
                    guard expectation.contains(random) else {  break }
                    if random == expectation.lowerBound { min = true }
                    if random == expectation.upperBound { max = true }
                }
                
                try #require(min && max)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Random x Byte
//*============================================================================*

@Suite struct BinaryIntegerTestsOnRandomAsByte {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/random/byte: random hits all values",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsCoreIntegerAsByte, randomnesses
    )   func randomAsByteHitsAllValues(
        type: any SystemsInteger.Type, randomness: any Randomness & Sendable
    )   throws {
       
        try  whereIs(type, randomness)
        func whereIs<T>(_ type: T.Type, _ randomness: consuming some Randomness)
        throws where T: SystemsInteger {
            var matches: Set<T> = []
            matches.reserveCapacity(T.all.count)
            
            while matches.count != T.all.count {
                matches.insert(T.random(using: &randomness))
            }
            
            try #require(matches.sorted() == Array(T.all))
        }
    }
    
    @Test(
        "BinaryInteger/random/byte: random hits all values in range",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsCoreIntegerAsByte, randomnesses
    )   func randomAsByteHitsAllValuesInRange(
        type: any SystemsInteger.Type, randomness: any Randomness & Sendable
    )   throws {
       
        try  whereIs(type, randomness)
        func whereIs<T>(_ type: T.Type, _ randomness: consuming some Randomness)
        throws where T: SystemsInteger {
            var matches: Set<T> = []
            matches.reserveCapacity(T.all.count)
            
            for _ in 0 ..< 8 {
                let a = T.random(using: &randomness)
                let b = T.random(using: &randomness)
                let r = a <= b ? a..<b : b..<a
                
                while matches.count != r.count {
                    matches.insert(T.random(in: r, using: &randomness)!)
                }
                
                try #require(matches.sorted() == Array(r))
                matches.removeAll(keepingCapacity: true)
            }
        }
    }
    
    @Test(
        "BinaryInteger/random/byte: random hits all values in closed range",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(.minutes(3)),
        arguments: typesAsCoreIntegerAsByte, randomnesses
    )   func randomAsByteHitsAllValuesInClosedRange(
        type: any SystemsInteger.Type, randomness: any Randomness & Sendable
    )   throws {
        
        try  whereIs(type, randomness)
        func whereIs<T>(_ type: T.Type, _ randomness: consuming some Randomness)
        throws where T: SystemsInteger {
            var matches: Set<T> = []
            matches.reserveCapacity(T.all.count)
            
            for _ in 0 ..< 8 {
                let a = T.random(using: &randomness)
                let b = T.random(using: &randomness)
                let r = a <= b ? a...b : b...a
                
                while matches.count != r.count {
                    matches.insert(T.random(in: r, using: &randomness))
                }
                
                try #require(matches.sorted() == Array(r))
                matches.removeAll(keepingCapacity: true)
            }
        }
    }
}
