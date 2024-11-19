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

@Suite(.serialized) struct SignednessTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Signedness: init()",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: CollectionOfOne(Signedness.unsigned)
    )   func unspecified(expectation: Signedness) {
        #expect(Signedness() == expectation)
        #expect(Signedness(raw: Bit.zero) == expectation)
    }
    
    @Test(
        "Signedness: init(signed:)",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Signedness, Bool)>.infer([
      
        (Signedness.unsigned, false),
        (Signedness  .signed, true ),
        
    ])) func signed(instance: Signedness, expectation: Bool) {
        #expect(instance == Signedness(signed: expectation))
    }
}
