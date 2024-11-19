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
// MARK: * Stdlib Int x Comparison
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
@Suite struct StdlibIntTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/comparison: Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func forwarding(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< conditional(debug: 64, release: 128) {
            let lhs = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let rhs = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            Ɣexpect(StdlibInt(lhs), equals: StdlibInt(rhs), is: lhs.compared(to: rhs))
        }
    }
}
