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
import TestKit2

//*============================================================================*
// MARK: * Stdlib Int
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
@Suite struct StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt - metadata")
    func metadata() {
        #expect(StdlibInt.isSigned)
        #expect(StdlibInt.Magnitude.isSigned)
    }
    
    @Test("StdlibInt.init(raw:) - [entropic]", arguments: fuzzers)
    func bitcasting(randomness: consuming FuzzerInt) {
        for _ in 0 ..< 32 {
            let random = StdlibInt(IXL.entropic(size: 256, using: &randomness))
            #expect(StdlibInt(raw: IXL(raw: random)) == random)
            #expect(StdlibInt(raw: UXL(raw: random)) == random)
        }
    }
}
