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
// MARK: * Bit x Text
//*============================================================================*

@Suite(.serialized) struct BitTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Test
    //=------------------------------------------------------------------------=
    
    @Test(
        "Bit/text: description",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Bit, String)>.infer([
        
        (Bit.zero, "0"),
        (Bit.one,  "1"),
            
    ])) func description(instance: Bit, expectation: String) {
        Ɣexpect(instance, description: expectation)
    }
}
