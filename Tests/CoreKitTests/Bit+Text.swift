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
// MARK: * Bit x Text
//*============================================================================*

@Suite struct BitTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Test
    //=------------------------------------------------------------------------=
    
    @Test("Bit/description", arguments: [
        
        Some(Bit.zero, yields: "0"),
        Some(Bit.one,  yields: "1"),
        
    ])  func description(_ argument: Some<Bit, String>) {
        Ɣexpect(argument.input, description: argument.output)
    }
}
