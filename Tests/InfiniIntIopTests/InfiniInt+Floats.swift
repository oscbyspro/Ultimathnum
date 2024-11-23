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
import InfiniIntIop
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stdlib x Floats
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnFloats {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/floats: from SwiftIEEE754 of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func forwarding(
        randomness: consuming FuzzerInt
    )   throws {
        
        for source in typesAsSwiftIEEE754 {
            for destination in typesAsInfiniIntStdlib {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: SwiftIEEE754, B: InfiniIntStdlib {
            
            try #require(B.Base.isArbitrary)
            
            let limits: [A] = [1.0, 1024.0, A.greatestFiniteMagnitude/2]
            
            for bounds: ClosedRange<A> in limits.lazy.map({ -$0...$0 }) {
                for _ in 0 ..< 64 {
                    let float   = A.random(in: bounds, using: &randomness.stdlib)
                    let rounded = float.rounded(FloatingPointRoundingRule.towardZero)
                    let integer = try #require(B.Base.leniently(float)?.map(B.init(_:)))
                    
                    try #require(B(         (float)) == integer.value)
                    try #require(B(exactly: (float)) == integer.optional())
                    try #require(B(         rounded) == integer.value)
                    try #require(B(exactly: rounded) == integer.value)
                }
            }
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/floats: round-tripping SwiftIEEE754 integers",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func roundtripping(
        randomness: consuming FuzzerInt
    )   throws {
        
        for source in typesAsSwiftIEEE754 {
            for destination in typesAsInfiniIntStdlib {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: SwiftIEEE754, B: InfiniIntStdlib {
            
            try #require(B.Base.isArbitrary)
            
            let limits: [A] = [1.0, 1024.0, A.greatestFiniteMagnitude/2]
            
            for bounds: ClosedRange<A> in limits.lazy.map({ -$0...$0 }) {
                for _ in 0 ..< 64 {
                    let float   = A.random(in: bounds, using: &randomness.stdlib)
                    let rounded = float.rounded(FloatingPointRoundingRule.towardZero)
                    let integer = try #require(B(exactly: rounded))
                    
                    try #require(rounded == A(integer), "integer → float")
                    try #require(integer == B((float)), "integer ← float")
                }
            }
            
        }
    }
}
