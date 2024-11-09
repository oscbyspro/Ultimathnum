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
// MARK: * Sign x Comparison
//*============================================================================*

@Suite struct SignTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Sign/comparison: Sign vs Sign",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Sign, Sign, Bool)>([
        
        (Sign.plus,  Sign.plus,  true ),
        (Sign.plus,  Sign.minus, false),
        (Sign.minus, Sign.plus,  false),
        (Sign.minus, Sign.minus, true ),
        
    ])) func comparison(lhs: Sign, rhs: Sign, expectation: Bool) {
        Ɣexpect(lhs, equals: rhs, is: expectation)
    }
}
