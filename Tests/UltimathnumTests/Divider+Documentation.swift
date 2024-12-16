//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Divider x Documentation
//*============================================================================*

@Suite struct DividerTestsOnDocumentation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("README") func readme() {
        for _ in 0 ..< 8 {
            let random  = U8.random()
            let divisor = Nonzero(U8.random(in: 1...255))
            let divider = Divider(divisor)
            let typical = random.division(divisor) as Division<U8, U8> // div
            let magical = random.division(divider) as Division<U8, U8> // mul-add-shr
            precondition(typical == magical) // quotient and remainder
        }
    }
}

//*============================================================================*
// MARK: * Divider x Documentation x 2-by-1
//*============================================================================*

@Suite struct DividerTestsOnDocumentation21 {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("README") func readme() {
        for _ in 0 ..< 8 {
            let random  = Doublet(low: U8.random(), high: U8.random())
            let divisor = Nonzero(U8.random(in: 1...255))
            let divider = Divider21(divisor)
            let typical = U8.division(random, by: divisor) as Fallible<Division<U8, U8>>
            let magical = U8.division(random, by: divider) as Fallible<Division<U8, U8>>
            precondition(typical == magical) // quotient, remainder, and error indicator
        }
    }
}
