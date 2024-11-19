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
import TestKit

//*============================================================================*
// MARK: * Fallible x Comparison
//*============================================================================*

@Suite struct FallibleTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/comparison: Fallible<Bit> vs Fallible<Bit>",
        Tag.List.tags(.exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Fallible<Bit>, Fallible<Bit>, Bool)>.infer([
        
        (Fallible(Bit.zero, error: false), Fallible(Bit.zero, error: false), true ),
        (Fallible(Bit.zero, error: false), Fallible(Bit.zero, error: true ), false),
        (Fallible(Bit.zero, error: false), Fallible(Bit.one,  error: false), false),
        (Fallible(Bit.zero, error: false), Fallible(Bit.one,  error: true ), false),
            
        (Fallible(Bit.zero, error: true ), Fallible(Bit.zero, error: false), false),
        (Fallible(Bit.zero, error: true ), Fallible(Bit.zero, error: true ), true ),
        (Fallible(Bit.zero, error: true ), Fallible(Bit.one,  error: false), false),
        (Fallible(Bit.zero, error: true ), Fallible(Bit.one,  error: true ), false),
            
        (Fallible(Bit.one,  error: false), Fallible(Bit.zero, error: false), false),
        (Fallible(Bit.one,  error: false), Fallible(Bit.zero, error: true ), false),
        (Fallible(Bit.one,  error: false), Fallible(Bit.one,  error: false), true ),
        (Fallible(Bit.one,  error: false), Fallible(Bit.one,  error: true ), false),
            
        (Fallible(Bit.one,  error: true ), Fallible(Bit.zero, error: false), false),
        (Fallible(Bit.one,  error: true ), Fallible(Bit.zero, error: true ), false),
        (Fallible(Bit.one,  error: true ), Fallible(Bit.one,  error: false), false),
        (Fallible(Bit.one,  error: true ), Fallible(Bit.one,  error: true ), true ),
            
    ])) func compare(lhs: Fallible<Bit>, rhs: Fallible<Bit>, expectation: Bool) {
        #expect(memeq(lhs,   rhs) ==  expectation)
        Ɣexpect(lhs, equals: rhs, is: expectation)
    }
}
