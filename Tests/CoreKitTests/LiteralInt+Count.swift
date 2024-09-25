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
// MARK: * Literal Int x Count
//*============================================================================*

@Suite struct LiteralIntTestsOnCount {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("LiteralInt/entropy()", .serialized, arguments: [
        
        Some(-8 as LiteralInt, yields: Count(4)), // 000....1
        Some(-7 as LiteralInt, yields: Count(4)), // 100....1
        Some(-6 as LiteralInt, yields: Count(4)), // 010....1
        Some(-5 as LiteralInt, yields: Count(4)), // 110....1
        Some(-4 as LiteralInt, yields: Count(3)), // 00.....1
        Some(-3 as LiteralInt, yields: Count(3)), // 10.....1
        Some(-2 as LiteralInt, yields: Count(2)), // 0......1
        Some(-1 as LiteralInt, yields: Count(1)), // .......1
        Some( 0 as LiteralInt, yields: Count(1)), // .......0
        Some( 1 as LiteralInt, yields: Count(2)), // 1......0
        Some( 2 as LiteralInt, yields: Count(3)), // 01.....0
        Some( 3 as LiteralInt, yields: Count(3)), // 11.....0
        Some( 4 as LiteralInt, yields: Count(4)), // 001....0
        Some( 5 as LiteralInt, yields: Count(4)), // 101....0
        Some( 6 as LiteralInt, yields: Count(4)), // 011....0
        Some( 7 as LiteralInt, yields: Count(4)), // 111....0
        
        Some(-0x80000000000000000000000000000000 as LiteralInt, yields: Count(128)),
        Some( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF as LiteralInt, yields: Count(128)),
        
    ])  func éntropy(_ argument: Some<LiteralInt, Count>) {
        #expect(argument.input.entropy() == argument.output)
    }
}
