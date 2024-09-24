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
// MARK: * Fallible x Comparison
//*============================================================================*

@Suite struct FallibleTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Equatable vs memeq(_:_:)", .serialized, arguments:
        
        Fallible<Bit>.all,
        Fallible<Bit>.all
          
    )   func compare(_ lhs: Fallible<Bit>, _ rhs: Fallible<Bit>) {
        Ɣexpect(lhs, equals: rhs, is: memeq(lhs, rhs))
    }
}
