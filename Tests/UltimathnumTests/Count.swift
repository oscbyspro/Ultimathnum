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
// MARK: * Count
//*============================================================================*

@Suite struct CountTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Count: instances"
    )   func instances() {
        #expect(Count.zero     == Count(raw:  0 as IX))
        #expect(Count.infinity == Count(raw: -1 as IX))
    }
    
    @Test(
        "Count: init(raw:)",
        Tag.List.tags(.random),
        arguments: fuzzers
    )   func bitcasting(randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let random = IX.entropic(using: &randomness)
            let result = IX(raw: Count(raw: random))
            #expect(result == random)
        }
    }
    
    @Test(
        "Count/natural",
        Tag.List.tags(.random),
        arguments: fuzzers
    )   func natural(randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let random = IX.entropic(using: &randomness)
            let result = Count(raw: random).natural()
            #expect(result == random.veto(random.isNegative))
        }
    }
}
