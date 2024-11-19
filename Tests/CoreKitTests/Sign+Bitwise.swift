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
// MARK: * Sign x Bitwise
//*============================================================================*

@Suite(.serialized) struct SignTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test(
        "Sign/bitwise: ~(_:)",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, Sign)>.infer([
        
        (Sign.plus,  Sign.minus),
        (Sign.minus, Sign.plus ),
        
    ])) func not(instance: Sign, expectation: Sign) {
        #expect(expectation == reduce(instance) { ~$0 })
        #expect(expectation == reduce(instance) {  $0.toggle () })
        #expect(expectation == reduce(instance) {  $0.toggled() })
    }
    
    @Test(
        "Sign/bitwise: &(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, Sign, Sign)>.infer([
        
        (Sign.plus,  Sign.plus,  Sign.plus ),
        (Sign.plus,  Sign.minus, Sign.plus ),
        (Sign.minus, Sign.plus,  Sign.plus ),
        (Sign.minus, Sign.minus, Sign.minus),
        
    ])) func and(lhs: Sign, rhs: Sign, expectation: Sign) {
        #expect(expectation == reduce(lhs, &,  rhs))
        #expect(expectation == reduce(lhs, &=, rhs))
    }
    
    @Test(
        "Sign/bitwise: |(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, Sign, Sign)>.infer([
        
        (Sign.plus,  Sign.plus,  Sign.plus ),
        (Sign.plus,  Sign.minus, Sign.minus),
        (Sign.minus, Sign.plus,  Sign.minus),
        (Sign.minus, Sign.minus, Sign.minus),
        
    ])) func or(lhs: Sign, rhs: Sign, expectation: Sign) {
        #expect(expectation == reduce(lhs, |,  rhs))
        #expect(expectation == reduce(lhs, |=, rhs))
    }
    
    @Test(
        "Sign/bitwise: ^(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, Sign, Sign)>.infer([
        
        (Sign.plus,  Sign.plus,  Sign.plus ),
        (Sign.plus,  Sign.minus, Sign.minus),
        (Sign.minus, Sign.plus,  Sign.minus),
        (Sign.minus, Sign.minus, Sign.plus ),
        
    ])) func xor(lhs: Sign, rhs: Sign, expectation: Sign) {
        #expect(expectation == reduce(lhs, ^,  rhs))
        #expect(expectation == reduce(lhs, ^=, rhs))
    }
}
