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
// MARK: * Binary Integer x Stdlib x Floats
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnFloats {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/floats: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for source in typesAsSwiftIEEE754 {
            try whereIs(source: source, destination: type)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: SwiftIEEE754, B: FiniteIntegerInteroperable {
            
            var  ranges: [ClosedRange<A>] = []
            try  insert(A.greatestFiniteMagnitude/02)
            try  insert(A(sign: .plus, exponent:   0, significand: 1.0))
            try  insert(A(sign: .plus, exponent:   8, significand: 1.0))
            try? insert(A(sign: .plus, exponent:  16, significand: 1.0))
            try? insert(A(sign: .plus, exponent:  32, significand: 1.0))
            try? insert(A(sign: .plus, exponent:  64, significand: 1.0))
            try? insert(A(sign: .plus, exponent: 128, significand: 1.0))
            try? insert(A(sign: .plus, exponent: 256, significand: 1.0))
            
            for range in ranges {
                for _ in 0 ..< 32 {
                    let float   = A.random(in: range, using: &randomness.stdlib)
                    let rounded = float.rounded(FloatingPointRoundingRule.towardZero)
                    let integer = B.leniently(float)?.map(B.Stdlib.init(_:))
                    
                    try #require(B.Stdlib(exactly: (float)) == integer?.optional())
                    try #require(B.Stdlib(exactly: rounded) == integer?.value)
                    
                    if  let integer {
                        try #require(B.Stdlib((float)) == integer.value, "integer ← float")
                        try #require(B.Stdlib(rounded) == integer.value, "integer ← float")
                        try #require(A.init(integer.value) == (rounded), "integer → float")
                    }   else {
                        try #require(!B.isArbitrary)
                    }
                }
            }
            
            func insert(_ bound: A) throws {
                if !(2 *  bound).isFinite {
                    throw Bad.message("range.isInfinite")
                }   else {
                    ranges.append((-bound.magnitude)...(bound.magnitude))
                }
            }
        }
    }
}
