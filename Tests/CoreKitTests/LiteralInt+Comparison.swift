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
// MARK: * Literal Int x Comparison
//*============================================================================*

@Suite struct LiteralIntTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "LiteralInt/comparison: signum()",
        Tag.List.tags(.documentation),
        ParallelizationTrait.serialized,
        arguments: Array<(LiteralInt, Signum)>([
        
        (LiteralInt(-8), Signum.negative), // 000....1
        (LiteralInt(-7), Signum.negative), // 100....1
        (LiteralInt(-6), Signum.negative), // 010....1
        (LiteralInt(-5), Signum.negative), // 110....1
        (LiteralInt(-4), Signum.negative), // 00.....1
        (LiteralInt(-3), Signum.negative), // 10.....1
        (LiteralInt(-2), Signum.negative), // 0......1
        (LiteralInt(-1), Signum.negative), // .......1
        (LiteralInt( 0), Signum.zero    ), // .......0
        (LiteralInt( 1), Signum.positive), // 1......0
        (LiteralInt( 2), Signum.positive), // 01.....0
        (LiteralInt( 3), Signum.positive), // 11.....0
        (LiteralInt( 4), Signum.positive), // 001....0
        (LiteralInt( 5), Signum.positive), // 101....0
        (LiteralInt( 6), Signum.positive), // 011....0
        (LiteralInt( 7), Signum.positive), // 111....0
        
        (LiteralInt(-0x80000000000000000000000000000000), Signum.negative),
        (LiteralInt( 0x7fffffffffffffffffffffffffffffff), Signum.positive),
        
    ])) func signum(instance: LiteralInt, expectation: Signum) {
        #expect(instance.signum() == expectation)
    }
}
