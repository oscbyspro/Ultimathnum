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
    
    @Test("StdlibInt/multiplication: vs StdlibInt.Base", .tags(.forwarding, .random), arguments: fuzzers)
    func forwarding(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< conditional(debug: 64, release: 128) {
            let lhs = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let rhs = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            
            let a = StdlibInt(lhs)
            let b = StdlibInt(rhs)
            let c = a * b
            
            try #require(c == ( a * b ))
            try #require(c == { var x = a; x *= b; return x }())
            
            Ɣexpect(lhs, times: rhs, is: Fallible(IXL(c)))
        }
    }
}
