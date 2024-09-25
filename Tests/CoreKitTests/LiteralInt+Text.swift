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
// MARK: * Literal Int x Text
//*============================================================================*

@Suite struct LiteralIntTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("LiteralInt/description", .serialized, arguments: [
        
        Some(-8 as LiteralInt, yields: "-0x8"), // 000....1
        Some(-7 as LiteralInt, yields: "-0x7"), // 100....1
        Some(-6 as LiteralInt, yields: "-0x6"), // 010....1
        Some(-5 as LiteralInt, yields: "-0x5"), // 110....1
        Some(-4 as LiteralInt, yields: "-0x4"), // 00.....1
        Some(-3 as LiteralInt, yields: "-0x3"), // 10.....1
        Some(-2 as LiteralInt, yields: "-0x2"), // 0......1
        Some(-1 as LiteralInt, yields: "-0x1"), // .......1
        Some( 0 as LiteralInt, yields: "+0x0"), // .......0
        Some( 1 as LiteralInt, yields: "+0x1"), // 1......0
        Some( 2 as LiteralInt, yields: "+0x2"), // 01.....0
        Some( 3 as LiteralInt, yields: "+0x3"), // 11.....0
        Some( 4 as LiteralInt, yields: "+0x4"), // 001....0
        Some( 5 as LiteralInt, yields: "+0x5"), // 101....0
        Some( 6 as LiteralInt, yields: "+0x6"), // 011....0
        Some( 7 as LiteralInt, yields: "+0x7"), // 111....0
        
        Some(-0x80000000000000000000000000000000 as LiteralInt, yields: "-0x80000000000000000000000000000000"),
        Some( 0x7fffffffffffffffffffffffffffffff as LiteralInt, yields: "+0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"),
        
    ])  func description(_ argument: Some<LiteralInt, String>) {
        Ɣexpect(argument.input, description: argument.output)
    }
}
