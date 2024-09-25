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
// MARK: * Literal Int x Comparison
//*============================================================================*

@Suite struct LiteralIntTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("LiteralInt/signum()", .serialized, arguments: [
        
        Some(-8 as LiteralInt, yields: Signum.negative), // 000....1
        Some(-7 as LiteralInt, yields: Signum.negative), // 100....1
        Some(-6 as LiteralInt, yields: Signum.negative), // 010....1
        Some(-5 as LiteralInt, yields: Signum.negative), // 110....1
        Some(-4 as LiteralInt, yields: Signum.negative), // 00.....1
        Some(-3 as LiteralInt, yields: Signum.negative), // 10.....1
        Some(-2 as LiteralInt, yields: Signum.negative), // 0......1
        Some(-1 as LiteralInt, yields: Signum.negative), // .......1
        Some( 0 as LiteralInt, yields: Signum.zero    ), // .......0
        Some( 1 as LiteralInt, yields: Signum.positive), // 1......0
        Some( 2 as LiteralInt, yields: Signum.positive), // 01.....0
        Some( 3 as LiteralInt, yields: Signum.positive), // 11.....0
        Some( 4 as LiteralInt, yields: Signum.positive), // 001....0
        Some( 5 as LiteralInt, yields: Signum.positive), // 101....0
        Some( 6 as LiteralInt, yields: Signum.positive), // 011....0
        Some( 7 as LiteralInt, yields: Signum.positive), // 111....0
        
        Some(-0x80000000000000000000000000000000 as LiteralInt, yields: Signum.negative),
        Some( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF as LiteralInt, yields: Signum.positive),
        
    ])  func signum(_ argument: Some<LiteralInt, Signum>) {
        #expect(argument.input.signum() == argument.output)
    }
}
