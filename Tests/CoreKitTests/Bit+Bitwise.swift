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
// MARK: * Bit x Bitwise
//*============================================================================*

@Suite(.serialized) struct BitTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test(
        "Bit/bitwise: ~(_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit)>([
        
        (instance: Bit.zero, expectation: Bit.one ),
        (instance: Bit.one,  expectation: Bit.zero),
    
    ])) func not(instance: Bit, expectation: Bit) {
        #expect(reduce(instance, { ~$0           }) == expectation)
        #expect(reduce(instance, {  $0.toggle () }) == expectation)
        #expect(reduce(instance, {  $0.toggled() }) == expectation)
    }
    
    @Test(
        "Bit/bitwise: &(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit, Bit)>([
        
        (lhs: Bit.zero, rhs: Bit.zero, expectation: Bit.zero),
        (lhs: Bit.zero, rhs: Bit.one,  expectation: Bit.zero),
        (lhs: Bit.one,  rhs: Bit.zero, expectation: Bit.zero),
        (lhs: Bit.one,  rhs: Bit.one,  expectation: Bit.one ),
        
    ])) func and(lhs: Bit, rhs: Bit, expectation: Bit) {
        #expect(reduce(lhs, &,  rhs) == expectation)
        #expect(reduce(lhs, &=, rhs) == expectation)
    }
    
    @Test(
        "Bit/bitwise: |(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit, Bit)>([
        
        (lhs: Bit.zero, rhs: Bit.zero, expectation: Bit.zero),
        (lhs: Bit.zero, rhs: Bit.one,  expectation: Bit.one ),
        (lhs: Bit.one,  rhs: Bit.zero, expectation: Bit.one ),
        (lhs: Bit.one,  rhs: Bit.one,  expectation: Bit.one ),
        
    ])) func or(lhs: Bit, rhs: Bit, expectation: Bit) {
        #expect(reduce(lhs, |,  rhs) == expectation)
        #expect(reduce(lhs, |=, rhs) == expectation)
    }
    
    @Test(
        "Bit/bitwise: ^(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit, Bit)>([
        
        (lhs: Bit.zero, rhs: Bit.zero, expectation: Bit.zero),
        (lhs: Bit.zero, rhs: Bit.one,  expectation: Bit.one ),
        (lhs: Bit.one,  rhs: Bit.zero, expectation: Bit.one ),
        (lhs: Bit.one,  rhs: Bit.one,  expectation: Bit.zero),
        
    ])) func xor(lhs: Bit, rhs: Bit, expectation: Bit) {
        #expect(reduce(lhs, ^,  rhs) == expectation)
        #expect(reduce(lhs, ^=, rhs) == expectation)
    }
}
