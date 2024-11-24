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
import DoubleIntIop
import DoubleIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Stdlib x Floats
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnFloats {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/floats: from SwiftIEEE754 of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func forwarding(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        for source in typesAsSwiftIEEE754 {
            try whereIs(source: source, destination: type.base)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: SwiftIEEE754, B: DoubleIntStdlib {
            
            let limits: [A] = [1.0, 1024.0, A.greatestFiniteMagnitude/2]
            
            for bounds: ClosedRange<A> in limits.lazy.map({ -$0...$0 }) {
                for _ in 0 ..< 64 {
                    let float   = A.random(in: bounds, using: &randomness.stdlib)
                    let rounded = float.rounded(.towardZero)
                    let integer = B.Base.leniently(float)?.map(B.init(_:))
                    
                    try #require(B(exactly: (float)) == integer?.optional())
                    try #require(B(exactly: rounded) == integer?.value)
                    
                    if  let integer {
                        try #require(B((float)) == integer.value)
                        try #require(B(rounded) == integer.value)
                    }   else {
                        try #require(!B.Base.isArbitrary)
                    }
                }
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/floats: round-tripping SwiftIEEE754 integers",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func roundtripping(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        for source in typesAsSwiftIEEE754 {
            try whereIs(source: source, destination: type.base)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: SwiftIEEE754, B: DoubleIntStdlib {
                        
            let limits: [A] = [1.0, 1024.0, A.greatestFiniteMagnitude/2]
            
            for bounds: ClosedRange<A> in limits.lazy.map({ -$0...$0 }) {
                for _ in 0 ..< 64 {
                    let float   = A.random(in: bounds, using: &randomness.stdlib)
                    let rounded = float.rounded(.towardZero)
                    let integer = B.Base.exactly(rounded).map(B.init(_:))
                    
                    if  let integer {
                        try #require(rounded == A(integer), "integer → float")
                        try #require(integer == B((float)), "integer ← float")
                    }   else {
                        try #require(!B.Base.isArbitrary)
                    }
                }
            }
        }
    }
}
