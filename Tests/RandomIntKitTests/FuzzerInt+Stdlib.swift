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
import TestKit2

//*============================================================================*
// MARK: * Fuzzer Int x Stdlib
//*============================================================================*

@Suite struct FuzzerIntTestsOnStdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test func metadata() {
        #expect(FuzzerInt.Stdlib.self as Any is any Swift.RandomNumberGenerator.Type)
        #expect(MemoryLayout<FuzzerInt.Stdlib>.size == 8)
    }
}

