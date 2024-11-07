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
        let random  = U8.random()
        let divisor = Nonzero(U8.random(in: 1...255))
        let divider = Divider(divisor.value)
        let typical = random.division(divisor) as Division<U8, U8> // div
        let magical = random.division(divider) as Division<U8, U8> // mul-add-shr
        precondition(typical == magical) // quotient and remainder
    }
}
