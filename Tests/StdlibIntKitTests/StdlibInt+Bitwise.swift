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
// MARK: * Stdlib Int x Bitwise
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
@Suite struct StdlibIntTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/bitwise: ~(_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func not(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 32 {
            let random = IXL.entropic(size: 256, using: &randomness)
            let expectation = random.toggled()
            
            #expect(~StdlibInt(random) == StdlibInt(expectation))
            #expect(~StdlibInt(expectation) == StdlibInt(random))
        }
    }
    
    @Test(
        "StdlibInt/bitwise: &(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func and(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 32 {
            let lhs = IXL.entropic(size: 256, using: &randomness)
            let rhs = IXL.entropic(size: 256, using: &randomness)
            let expectation = lhs & rhs
            
            try #require(StdlibInt(expectation) == reduce(StdlibInt(lhs), &,  StdlibInt(rhs)))
            try #require(StdlibInt(expectation) == reduce(StdlibInt(lhs), &=, StdlibInt(rhs)))
        }
    }
    
    @Test(
        "StdlibInt/bitwise: |(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func or(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 32 {
            let lhs = IXL.entropic(size: 256, using: &randomness)
            let rhs = IXL.entropic(size: 256, using: &randomness)
            let expectation = lhs | rhs

            try #require(StdlibInt(expectation) == reduce(StdlibInt(lhs), |,  StdlibInt(rhs)))
            try #require(StdlibInt(expectation) == reduce(StdlibInt(lhs), |=, StdlibInt(rhs)))
        }
    }
    
    @Test(
        "StdlibInt/bitwise: ^(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func xor(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 32 {
            let lhs = IXL.entropic(size: 256, using: &randomness)
            let rhs = IXL.entropic(size: 256, using: &randomness)
            let expectation = lhs ^ rhs
            
            try #require(StdlibInt(expectation) == reduce(StdlibInt(lhs), ^,  StdlibInt(rhs)))
            try #require(StdlibInt(expectation) == reduce(StdlibInt(lhs), ^=, StdlibInt(rhs)))
        }
    }
}
