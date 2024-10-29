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
// MARK: * Randomness
//*============================================================================*

@Suite struct RandomnessTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Randomness: next(upTo:)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryIntegerAsUnsigned, randomnesses
    )   func nextUpTo(
        type: any UnsignedInteger.Type,
        randomness: any Randomness
    )   throws {
        
        try  whereIs(type, randomness)
        func whereIs<T, R>(_ type: T.Type, _ randomness: consuming R)
        throws where T: UnsignedInteger, R: Randomness {
            for limit: T in 1 ... T(U8.max) {
                try #require(randomness.next(upTo: Nonzero(limit)) < limit)
            }
        }
    }
    
    @Test(
        "Randomness: next(through:)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryIntegerAsUnsigned, randomnesses
    )   func nextThrough(
        type: any UnsignedInteger.Type,
        randomness: any Randomness
    )   throws {
        
        try  whereIs(type, randomness)
        func whereIs<T, R>(_ type: T.Type, _ randomness: consuming R)
        throws where T: UnsignedInteger, R: Randomness {
            for limit: T in 0 ... T(U8.max) {
                try #require(randomness.next(through: limit) <= limit)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Req. Determinism
    //=------------------------------------------------------------------------=
    
    @Test(
        "Randomness: next() is similar to fill(_:) as SystemsInteger",
        Tag.List.tags(.documentation, .generic, .random, .unofficial),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func nextIsSimilarToFillAsSystemsInteger(
        type: any SystemsIntegerAsUnsigned.Type,
        randomness: FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            var a = randomness
            var b = randomness
            
            for _ in 0 ..< 32 {
                let x = a.next(as: T.self)
                var y = T.zero
                
                y.withUnsafeMutableBinaryIntegerBody {
                    b.fill($0.bytes())
                }
                
                try #require(x == y)
            }
        }
    }
    
    @Test(
        "Randomness: next(upTo:) is similar to next(through:) as SystemsInteger",
        Tag.List.tags(.documentation, .generic, .random, .unofficial),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func nextUpToIsSimilarToNextThroughAsSystemsInteger(
        type: any SystemsIntegerAsUnsigned.Type,
        randomness: FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            var a = randomness
            var b = randomness
            
            for limit: T in 0 ..< 32 {
                try #require(a.next(through: limit) == b.next(upTo: Nonzero(limit + 1)))
            }
        }
    }
}
