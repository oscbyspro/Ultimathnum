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
// MARK: * Bit x Comparison
//*============================================================================*

@Suite struct BitTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Bit/isZero", arguments: [
        
        Some(Bit.zero, yields: true ),
        Some(Bit.one,  yields: false),
        
    ]) func isZero(_ expectation: Some<Bit, Bool>) {
        #expect(expectation.input.isZero == expectation.output)
    }
    
    @Test("Bit/compared(to:)", arguments: [
        
        Some((lhs: Bit.zero, rhs: Bit.zero), yields: Signum.zero),
        Some((lhs: Bit.zero, rhs: Bit.one ), yields: Signum.negative),
        Some((lhs: Bit.one,  rhs: Bit.zero), yields: Signum.positive),
        Some((lhs: Bit.one,  rhs: Bit.one ), yields: Signum.zero),
        
    ]) func compare(_ expectation: Some<(lhs: Bit, rhs: Bit), Signum>) {
        Ɣexpect(expectation.input.lhs, equals: expectation.input.rhs, is:    expectation.output)
        #expect(expectation.input.lhs.compared(to: expectation.input.rhs) == expectation.output)
    }
}
