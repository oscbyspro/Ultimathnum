//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Sign x Text
//*============================================================================*

@Suite struct SignTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Sign/ascii", .serialized, arguments: [
        
        (sign: Sign.plus,  ascii: 43 as U8),
        (sign: Sign.minus, ascii: 45 as U8),
        
    ])  func ascii(sign: Sign, ascii: U8) {
        #expect(sign.ascii == ascii)
    }
    
    @Test("Sign/description", .serialized, arguments: [
        
        (sign: Sign.plus,  description: "+"),
        (sign: Sign.minus, description: "-"),
        
    ])  func description(sign: Sign, description: String) {
        Ɣexpect(sign, description: description)
    }
}
