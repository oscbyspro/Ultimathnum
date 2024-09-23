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
    
    @Test("Signum/negated()", arguments: [
        
        Some(Signum.negative, yields: Signum.positive),
        Some(Signum.zero,     yields: Signum.zero    ),
        Some(Signum.positive, yields: Signum.negative),
        
    ]) func negation(_ expectation: Some<Signum, Signum>) {
        #expect(-expectation.input == expectation.output)
        #expect((expectation.input.negated() == expectation.output))
        #expect({ var x = expectation.input; x.negate(); return x }() == expectation.output)
    }
}
