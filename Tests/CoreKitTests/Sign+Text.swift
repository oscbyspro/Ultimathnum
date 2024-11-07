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

@Suite struct SignTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Sign/description", .serialized, arguments: [
        
        (sign: Sign.plus,  description: "+"),
        (sign: Sign.minus, description: "-"),
        
    ])  func description(sign: Sign, description: String) {
        Ɣexpect(sign, description: description)
    }
}
