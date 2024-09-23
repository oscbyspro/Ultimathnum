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
// MARK: * Signum x Comparison
//*============================================================================*

@Suite struct SignumTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Signum/isNegative", arguments: [
        
        Some(Signum.negative, yields: true ),
        Some(Signum.zero,     yields: false),
        Some(Signum.positive, yields: false),
        
    ]) func isNegative(_ expectation: Some<Signum, Bool>) {
        #expect(expectation.input.isNegative == expectation.output)
    }
    
    @Test("Signum/isZero", arguments: [
        
        Some(Signum.negative, yields: false),
        Some(Signum.zero,     yields: true ),
        Some(Signum.positive, yields: false),
        
    ]) func isZero(_ expectation: Some<Signum, Bool>) {
        #expect(expectation.input.isZero == expectation.output)
    }
    
    @Test("Signum/isPositive", arguments: [
        
        Some(Signum.negative, yields: false),
        Some(Signum.zero,     yields: false),
        Some(Signum.positive, yields: true ),
        
    ]) func isPositive(_ expectation: Some<Signum, Bool>) {
        #expect(expectation.input.isPositive == expectation.output)
    }
    
    @Test("Signum/compared(to:)", arguments: [
        
        Some((lhs: Signum.negative, rhs: Signum.negative), yields: Signum.zero),
        Some((lhs: Signum.negative, rhs: Signum.zero    ), yields: Signum.negative),
        Some((lhs: Signum.negative, rhs: Signum.positive), yields: Signum.negative),
        Some((lhs: Signum.zero,     rhs: Signum.negative), yields: Signum.positive),
        Some((lhs: Signum.zero,     rhs: Signum.zero    ), yields: Signum.zero),
        Some((lhs: Signum.zero,     rhs: Signum.positive), yields: Signum.negative),
        Some((lhs: Signum.positive, rhs: Signum.negative), yields: Signum.positive),
        Some((lhs: Signum.positive, rhs: Signum.zero    ), yields: Signum.positive),
        Some((lhs: Signum.positive, rhs: Signum.positive), yields: Signum.zero),
        
    ]) func compare(_ expectation: Some<(lhs: Signum, rhs: Signum), Signum>) {
        Ɣexpect(expectation.input.lhs, equals: expectation.input.rhs, is:    expectation.output)
        #expect(expectation.input.lhs.compared(to: expectation.input.rhs) == expectation.output)
    }
}
