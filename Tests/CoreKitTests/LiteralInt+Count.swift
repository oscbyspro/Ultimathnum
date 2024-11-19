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
// MARK: * Literal Int x Count
//*============================================================================*

@Suite(.serialized) struct LiteralIntTestsOnCount {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "LiteralInt/count: entropy()",
        Tag.List.tags(.documentation),
        arguments: Array<(LiteralInt, Count)>.infer([
        
        (LiteralInt(-8), Count(4)), // 000....1
        (LiteralInt(-7), Count(4)), // 100....1
        (LiteralInt(-6), Count(4)), // 010....1
        (LiteralInt(-5), Count(4)), // 110....1
        (LiteralInt(-4), Count(3)), // 00.....1
        (LiteralInt(-3), Count(3)), // 10.....1
        (LiteralInt(-2), Count(2)), // 0......1
        (LiteralInt(-1), Count(1)), // .......1
        (LiteralInt( 0), Count(1)), // .......0
        (LiteralInt( 1), Count(2)), // 1......0
        (LiteralInt( 2), Count(3)), // 01.....0
        (LiteralInt( 3), Count(3)), // 11.....0
        (LiteralInt( 4), Count(4)), // 001....0
        (LiteralInt( 5), Count(4)), // 101....0
        (LiteralInt( 6), Count(4)), // 011....0
        (LiteralInt( 7), Count(4)), // 111....0
        
        (LiteralInt(-0x80000000000000000000000000000000), Count(128)),
        (LiteralInt( 0x7fffffffffffffffffffffffffffffff), Count(128)),
        
    ])) func entropy(instance: LiteralInt, expectation: Count) {
        #expect(instance.entropy() == expectation)
    }
}
