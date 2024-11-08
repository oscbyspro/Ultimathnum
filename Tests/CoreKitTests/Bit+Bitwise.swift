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
        
        (Bit.zero, Bit.one ),
        (Bit.one,  Bit.zero),
        
    ])) func not(instance: Bit, expectation: Bit) {
        #expect(expectation == reduce(instance) { ~$0 })
        #expect(expectation == reduce(instance) {  $0.toggle () })
        #expect(expectation == reduce(instance) {  $0.toggled() })
    }
    
    @Test(
        "Bit/bitwise: &(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit, Bit)>([
        
        (Bit.zero, Bit.zero, Bit.zero),
        (Bit.zero, Bit.one,  Bit.zero),
        (Bit.one,  Bit.zero, Bit.zero),
        (Bit.one,  Bit.one,  Bit.one ),
        
    ])) func and(lhs: Bit, rhs: Bit, expectation: Bit) {
        #expect(expectation == reduce(lhs, &,  rhs))
        #expect(expectation == reduce(lhs, &=, rhs))
    }
    
    @Test(
        "Bit/bitwise: |(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit, Bit)>([
        
        (Bit.zero, Bit.zero, Bit.zero),
        (Bit.zero, Bit.one,  Bit.one ),
        (Bit.one,  Bit.zero, Bit.one ),
        (Bit.one,  Bit.one,  Bit.one ),
        
    ])) func or(lhs: Bit, rhs: Bit, expectation: Bit) {
        #expect(expectation == reduce(lhs, |,  rhs))
        #expect(expectation == reduce(lhs, |=, rhs))
    }
    
    @Test(
        "Bit/bitwise: ^(_:_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit, Bit)>([
        
        (Bit.zero, Bit.zero, Bit.zero),
        (Bit.zero, Bit.one,  Bit.one ),
        (Bit.one,  Bit.zero, Bit.one ),
        (Bit.one,  Bit.one,  Bit.zero),
        
    ])) func xor(lhs: Bit, rhs: Bit, expectation: Bit) {
        #expect(expectation == reduce(lhs, ^,  rhs))
        #expect(expectation == reduce(lhs, ^=, rhs))
    }
}
