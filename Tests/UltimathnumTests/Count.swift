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
// MARK: * Count
//*============================================================================*

@Suite struct CountTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test func instances() {
        #expect(Count.zero     == Count(raw:  0 as IX))
        #expect(Count.infinity == Count(raw: -1 as IX))
    }
    
    @Test("Count.init(raw:)",  arguments: fuzzers)
    func pattern(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let random = IX.entropic(using: &randomness)
            let result = IX(raw: Count(raw: random))
            #expect(result == random)
        }
    }
    
    @Test("Count/natural", arguments: fuzzers)
    func natural(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let random = IX.entropic(using: &randomness)
            let result = Count(raw: random).natural()
            #expect(result == random.veto(random.isNegative))
        }
    }
}
