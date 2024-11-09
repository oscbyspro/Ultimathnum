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
// MARK: * Signedness x Comparison
//*============================================================================*

@Suite struct SignednessTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Signedness/comparison: Self vs Self",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Signedness, Signedness, Bool)>([
        
        (Signedness.unsigned, Signedness.unsigned, true ),
        (Signedness.unsigned, Signedness  .signed, false),
        (Signedness  .signed, Signedness.unsigned, false),
        (Signedness  .signed, Signedness  .signed, true ),
        
    ])) func comparison(lhs: Signedness, rhs: Signedness, expectation: Bool) {
        Ɣexpect(lhs, equals: rhs, is: expectation)
    }
}
