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
// MARK: * Signum x Addition
//*============================================================================*

@Suite struct SignumTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Signum/negated()", .serialized, arguments: [
        
        Some(Signum.negative, yields: Signum.positive),
        Some(Signum.zero,     yields: Signum.zero    ),
        Some(Signum.positive, yields: Signum.negative),
        
    ])  func negation(_ argument: Some<Signum, Signum>) {
        #expect(-argument.input == argument.output)
        #expect((argument.input.negated() == argument.output))
        #expect({ var x = argument.input; x.negate(); return x }() == argument.output)
    }
}
