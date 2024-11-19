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
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Floats
//*============================================================================*

/// An `StdlibInt` test suite.
///
/// ### Wrapper
///
/// `StdlibInt` should forward most function calls to its underlying model.
///
/// ### Development
///
/// - TODO: Test `StdlibInt` forwarding in generic `BinaryInteger` tests.
///
@Suite struct StdlibIntTestsOnFloats {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/floats: from SwiftIEEE754 of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: fuzzers
    )   func forwarding(randomness: consuming FuzzerInt) throws {
        for source in typesAsSwiftIEEE754 {
            try whereIs(source: source)
        }
        
        func whereIs<A>(source: A.Type) throws where A: SwiftIEEE754 {
            let limits: [A] = [1.0, 1024.0, A.greatestFiniteMagnitude/2]
            for bounds: ClosedRange<A> in limits.lazy.map({ -$0...$0 }) {
                for _ in 0 ..< 64 {
                    let float   = A.random(in: bounds, using: &randomness.stdlib)
                    let rounded = float.rounded(FloatingPointRoundingRule.towardZero)
                    let integer = try #require(IXL.leniently(float)?.map(StdlibInt.init))
                    
                    try #require(StdlibInt(         (float)) == integer.value)
                    try #require(StdlibInt(exactly: (float)) == integer.optional())
                    try #require(StdlibInt(         rounded) == integer.value)
                    try #require(StdlibInt(exactly: rounded) == integer.value)
                }
            }
        }
    }
    
    @Test(
        "StdlibInt/floats: round-tripping SwiftIEEE754 integers",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: fuzzers
    )   func roundtripping(randomness: consuming FuzzerInt) throws {
        for source in typesAsSwiftIEEE754 {
            try whereIs(source: source)
        }
        
        func whereIs<A>(source: A.Type) throws where A: SwiftIEEE754 {
            let limits: [A] = [1.0, 1024.0, A.greatestFiniteMagnitude/2]
            for bounds: ClosedRange<A> in limits.lazy.map({ -$0...$0 }) {
                for _ in 0 ..< 64 {
                    let float   = A.random(in: bounds, using: &randomness.stdlib)
                    let rounded = float.rounded(FloatingPointRoundingRule.towardZero)
                    let integer = try #require(StdlibInt(exactly: rounded))
                    
                    try #require(rounded == A.init (integer), "integer → float")
                    try #require(integer == StdlibInt(float), "integer ← float")
                }
            }
        }
    }
}
