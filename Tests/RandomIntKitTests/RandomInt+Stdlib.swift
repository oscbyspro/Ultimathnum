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
import TestKit

//*============================================================================*
// MARK: * Random Int x Stdlib
//*============================================================================*

@Suite struct RandomIntTestsOnStdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test func metadata() {
        #expect(RandomInt.Stdlib.self as Any is any Swift.RandomNumberGenerator.Type)
        #expect(MemoryLayout<RandomInt.Stdlib>.size == 0)
    }
    
    @Test func stdlib() {
        let custom = RandomInt(Swift.SystemRandomNumberGenerator())
        let stdlib: Swift.SystemRandomNumberGenerator = custom.stdlib()
        #expect(MemoryLayout.size(ofValue: custom) == Swift.Int.zero)
        #expect(MemoryLayout.size(ofValue: stdlib) == Swift.Int.zero)
    }
}

