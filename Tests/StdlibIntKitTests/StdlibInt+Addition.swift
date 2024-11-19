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
// MARK: * Stdlib Int x Addition
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
@Suite struct StdlibIntTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/addition: -(_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func negation(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< conditional(debug: 64,  release: 128) {
            let x = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let y = x.negated() as IXL
            
            try #require(StdlibInt(x) == -StdlibInt(y))
            try #require(StdlibInt(y) == -StdlibInt(x))
        }
    }
    
    @Test(
        "StdlibInt/addition: +(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func addition(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< conditional(debug: 64,  release: 128) {
            let a = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let b = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let c = a.plus(b) as IXL
            
            try #require(StdlibInt(c) == reduce(StdlibInt(a), +,  StdlibInt(b)))
            try #require(StdlibInt(c) == reduce(StdlibInt(a), +=, StdlibInt(b)))
        }
    }
    
    @Test(
        "StdlibInt/addition: -(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func subtraction(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< conditional(debug: 64,  release: 128) {
            let a = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let b = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let c = a.minus(b) as IXL
            
            try #require(StdlibInt(c) == reduce(StdlibInt(a), -,  StdlibInt(b)))
            try #require(StdlibInt(c) == reduce(StdlibInt(a), -=, StdlibInt(b)))
        }
    }
}
