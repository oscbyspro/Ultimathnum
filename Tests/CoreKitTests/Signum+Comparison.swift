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
// MARK: * Signum x Comparison
//*============================================================================*

@Suite(.serialized) struct SignumTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Signum/comparison: is negative",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Signum, Bool)>.infer([
        
        (Signum.negative, true ),
        (Signum.zero,     false),
        (Signum.positive, false),
        
    ])) func isNegative(instance: Signum, expectation: Bool) {
        #expect(instance.isNegative == expectation)
    }
    
    @Test(
        "Signum/comparison: is zero",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Signum, Bool)>.infer([
        
        (Signum.negative, false),
        (Signum.zero,     true ),
        (Signum.positive, false),
        
    ])) func isZero(instance: Signum, expectation: Bool) {
        #expect(instance.isZero == expectation)
    }
    
    @Test(
        "Signum/comparison: is positive",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Signum, Bool)>.infer([
        
        (Signum.negative, false),
        (Signum.zero,     false),
        (Signum.positive, true ),
        
    ])) func isPositive(instance: Signum, expectation: Bool) {
        #expect(instance.isPositive == expectation)
    }
    
    @Test(
        "Signum/comparison: Self vs Self",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Signum, Signum, Signum)>.infer([
        
        (Signum.negative, Signum.negative, Signum.zero),
        (Signum.negative, Signum.zero,     Signum.negative),
        (Signum.negative, Signum.positive, Signum.negative),
        (Signum.zero,     Signum.negative, Signum.positive),
        (Signum.zero,     Signum.zero,     Signum.zero),
        (Signum.zero,     Signum.positive, Signum.negative),
        (Signum.positive, Signum.negative, Signum.positive),
        (Signum.positive, Signum.zero,     Signum.positive),
        (Signum.positive, Signum.positive, Signum.zero),
        
    ])) func comparison(lhs: Signum, rhs: Signum, expectation: Signum) {
        Ɣexpect(lhs, equals: rhs, is:    expectation)
        #expect(lhs.compared(to: rhs) == expectation)
    }
}
