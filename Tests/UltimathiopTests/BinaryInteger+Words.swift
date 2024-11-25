//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stdlib x Words
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnWords {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/words: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 256 {
                let value = T.entropic(size: size, using: &randomness)
                var expectation: [Swift.UInt] = []
                
                always: do {
                    var pattern = value
                    var counter = IX(raw: T.isArbitrary ? value.entropy() : value.size())
                                        
                    while counter.isPositive {
                        expectation.append(Swift.UInt(UX(load: pattern)))
                        pattern = pattern.down (UX.size)
                        counter = counter.minus(IX(size: UX.self)).unwrap()
                    }
                }
                
                let result = T.Stdlib(value).words
                try #require(result.elementsEqual(expectation))
                try #require(result[Swift.Int.zero] == T.Stdlib(value)._lowWord)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Stdlib x Words x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnWordsEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/words/edge-cases: minimalism",
        Tag.List.tags(.documentation, .forwarding, .generic, .important),
        arguments: typesAsLenientIntegerInteroperable, fuzzers
    )   func minimalism(
        type: any LenientIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: LenientIntegerInteroperable {
            let x: Swift.Int = UInt.bitWidth
            
            for i: Swift.Int in 0 ..< x {
                try whereIs( (  1  << i))
                try whereIs(~(  1  << i))
                try whereIs( ( -1  << i))
                try whereIs(~( -1  << i))
            }
            
            try #require(( (T.Stdlib( 1) << x)).words.elementsEqual([ 0,  1] as [Swift.UInt]))
            try #require((~(T.Stdlib( 1) << x)).words.elementsEqual([~0, ~1] as [Swift.UInt]))
            try #require(( (T.Stdlib(-1) << x)).words.elementsEqual([ 0, ~0] as [Swift.UInt]))
            try #require((~(T.Stdlib(-1) << x)).words.elementsEqual([~0,  0] as [Swift.UInt]))

            func whereIs(_ small: Swift.Int) throws {
                let value = T.Stdlib(truncatingIfNeeded: small)
                let words = CollectionOfOne(Swift.UInt(bitPattern: small))
                try #require(T.Stdlib((value)).words.elementsEqual(words))
            }
        }
    }
}
