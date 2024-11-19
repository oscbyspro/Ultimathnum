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
// MARK: * Literal Int x Text
//*============================================================================*

@Suite(.serialized) struct LiteralIntTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "LiteralInt/text: description",
        Tag.List.tags(.documentation, .unofficial),
        arguments: Array<(LiteralInt, String)>.infer([
        
        (LiteralInt(-8), "-0x8"), // 000....1
        (LiteralInt(-7), "-0x7"), // 100....1
        (LiteralInt(-6), "-0x6"), // 010....1
        (LiteralInt(-5), "-0x5"), // 110....1
        (LiteralInt(-4), "-0x4"), // 00.....1
        (LiteralInt(-3), "-0x3"), // 10.....1
        (LiteralInt(-2), "-0x2"), // 0......1
        (LiteralInt(-1), "-0x1"), // .......1
        (LiteralInt( 0), "+0x0"), // .......0
        (LiteralInt( 1), "+0x1"), // 1......0
        (LiteralInt( 2), "+0x2"), // 01.....0
        (LiteralInt( 3), "+0x3"), // 11.....0
        (LiteralInt( 4), "+0x4"), // 001....0
        (LiteralInt( 5), "+0x5"), // 101....0
        (LiteralInt( 6), "+0x6"), // 011....0
        (LiteralInt( 7), "+0x7"), // 111....0
        
        (LiteralInt(-0x80000000000000000000000000000000), "-0x80000000000000000000000000000000"),
        (LiteralInt( 0x7fffffffffffffffffffffffffffffff), "+0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"),
        
    ])) func description(instance: LiteralInt, expectation: String) {
        Ɣexpect(instance, description: expectation)
    }
}
