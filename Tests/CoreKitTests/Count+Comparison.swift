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
import TestKit2

//*============================================================================*
// MARK: * Count x Comparison
//*============================================================================*

@Suite struct CountTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(arguments: CollectionOfOne(fuzzer))
    func isZeroIsLikeBinaryIntegerIsZero(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let random: IX = randomness.sizewise()
            #expect(Count(raw: random).isZero == random.isZero)
        }
    }
    
    @Test(arguments: CollectionOfOne(fuzzer))
    func isInfiniteIsLikeSignedIntegerIsNegative(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let random: IX = randomness.sizewise()
            #expect(Count(raw: random).isInfinite == random.isNegative)
        }
    }
    
    @Test(arguments: CollectionOfOne(fuzzer))
    func comparisonIsLikeUnsignedIntegerComparison(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 256 {
            let lhs: UX = randomness.sizewise()
            let rhs: UX = randomness.sizewise()
            Ɣexpect(Count(raw: lhs), equals: Count(raw: rhs), is: lhs.compared(to: rhs))
        }
    }
}
