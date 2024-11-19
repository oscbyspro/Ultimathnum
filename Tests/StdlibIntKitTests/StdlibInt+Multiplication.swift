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
import InfiniIntKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Multiplication
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
@Suite struct StdlibIntTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/multiplication: Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func forwarding(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< conditional(debug: 64,  release: 128) {
            let a = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let b = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let c = a.times(b) as IXL
            
            try #require(StdlibInt(c) == reduce(StdlibInt(a), *,  StdlibInt(b)))
            try #require(StdlibInt(c) == reduce(StdlibInt(a), *=, StdlibInt(b)))
        }
    }
}
