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
// MARK: * Count x Validation
//*============================================================================*

@Suite struct CountTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Guarantee-esque initializers",   arguments: fuzzers)
    func validation(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 256 {
            let random: IX = randomness.sizewise()
            if !random.isNegative {
                #expect(Count(random)            == Count(raw: random))
                #expect(Count(unchecked: random) == Count(raw: random))
                #expect(Count(exactly:   random) == Count(raw: random))
                #expect(try Count(random, prune: Bad.error) == Count(raw: random))
            }   else {
                #expect(Count(exactly:   random) == nil)
                #expect(throws: Bad.error) {
                    try Count(random, prune: Bad.error)
                }
            }
        }
    }
}
