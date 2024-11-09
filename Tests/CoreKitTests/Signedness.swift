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
// MARK: * Signedness
//*============================================================================*

@Suite struct SignednessTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Signedness: signed",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Signedness, Bool)>([
      
        (Signedness.unsigned, false),
        (Signedness  .signed, true ),
        
    ])) func signed(instance: Signedness, expectation: Bool) {
        #expect(instance == Signedness(signed: expectation))
    }
}
