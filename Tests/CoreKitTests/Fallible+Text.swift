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
// MARK: * Fallible x Text
//*============================================================================*

@Suite(.serialized) struct FallibleTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/text: description",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bool, String)>([
        
        (Bit.zero, false, "0[-]"),
        (Bit.zero, true,  "0[x]"),
        (Bit.one,  false, "1[-]"),
        (Bit.one,  true,  "1[x]"),
        
    ])) func description(value: Bit, error: Bool, expectation: String) {
        Ɣexpect(Fallible(value, error: error), description: expectation)
    }
}
