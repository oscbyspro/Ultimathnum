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
// MARK: * Sign x Text
//*============================================================================*

@Suite(.serialized) struct SignTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Sign/text: description",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, String)>.infer([
        
        (Sign.plus,  "+"),
        (Sign.minus, "-"),
        
    ])) func description(instance: Sign, description: String) {
        Ɣexpect(instance, description: description)
    }
}
