//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Fallible x Text
//*============================================================================*

@Suite struct FallibleTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Fallible/description - x1", arguments: [
        
        Some(Bit.zero, false, yields: "0[-]"),
        Some(Bit.zero, true,  yields: "0[x]"),
        Some(Bit.one,  false, yields: "1[-]"),
        Some(Bit.one,  true,  yields: "1[x]"),
        
    ])  func description1(_ argument: Some<Bit, Bool, String>) {
        Ɣexpect(Fallible(argument.0, error: argument.1), description: argument.output)
    }
    
    @Test("Fallible/description - x2", arguments: [
        
        Some(Bit.zero, false, false, yields: "0[-][-]"),
        Some(Bit.zero, false, true,  yields: "0[-][x]"),
        Some(Bit.zero, true,  false, yields: "0[x][-]"),
        Some(Bit.zero, true,  true,  yields: "0[x][x]"),
        Some(Bit.one,  false, false, yields: "1[-][-]"),
        Some(Bit.one,  false, true,  yields: "1[-][x]"),
        Some(Bit.one,  true,  false, yields: "1[x][-]"),
        Some(Bit.one,  true,  true,  yields: "1[x][x]"),
        
    ])  func description2(_ argument: Some<Bit, Bool, Bool, String>) {
        Ɣexpect(Fallible(Fallible(argument.0, error: argument.1), error: argument.2), description: argument.output)
    }
}
