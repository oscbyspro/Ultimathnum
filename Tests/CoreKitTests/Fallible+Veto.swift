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
import TestKit

//*============================================================================*
// MARK: * Fallible x Veto
//*============================================================================*

@Suite(.serialized) struct FallibleTestsOnVeto {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/veto: for each Bit",
        Tag.List.tags(.exhaustive),
        arguments: Fallible<Bit>.all
    )   func veto(argument: Fallible<Bit>) {
        
        let invalid = Fallible(argument.value, error: true)
        
        #expect(argument.veto(              ) == invalid)
        #expect(argument.veto(       false  ) == argument)
        #expect(argument.veto(       true   ) == invalid)
        #expect(argument.veto({ _ in false }) == argument)
        #expect(argument.veto({ _ in true  }) == invalid)
    }
}
