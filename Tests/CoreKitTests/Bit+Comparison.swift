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
// MARK: * Bit x Comparison
//*============================================================================*

@Suite struct BitTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Bit/comparison: is 0",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Bit, Bool)>.infer([
        
        (Bit.zero, true ),
        (Bit.one,  false),
        
    ])) func isZero(instance: Bit, expectation: Bool) {
        #expect(instance.isZero == expectation)
    }
    
    @Test(
        "Bit/comparison: Bit vs Bit",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Bit, Bit, Signum)>.infer([
        
        (Bit.zero, Bit.zero, Signum.zero),
        (Bit.zero, Bit.one,  Signum.negative),
        (Bit.one,  Bit.zero, Signum.positive),
        (Bit.one,  Bit.one,  Signum.zero),
        
    ])) func comparison(lhs: Bit, rhs: Bit, expectation: Signum) {
        Ɣexpect(lhs, equals: rhs, is:    expectation)
        #expect(lhs.compared(to: rhs) == expectation)
    }
}
