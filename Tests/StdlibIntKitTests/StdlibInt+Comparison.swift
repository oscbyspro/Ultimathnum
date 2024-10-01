//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import StdlibIntKit
import TestKit2

//*============================================================================*
// MARK: * Stdlib Int x Comparison
//*============================================================================*

@Suite struct StdlibIntTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt - comparison", arguments: [
        
        (-2 as StdlibInt, -2 as StdlibInt, Signum.zero),
        (-2 as StdlibInt, -1 as StdlibInt, Signum.negative),
        (-2 as StdlibInt,  0 as StdlibInt, Signum.negative),
        (-2 as StdlibInt,  1 as StdlibInt, Signum.negative),
        (-2 as StdlibInt,  2 as StdlibInt, Signum.negative),
        
        (-1 as StdlibInt, -2 as StdlibInt, Signum.positive),
        (-1 as StdlibInt, -1 as StdlibInt, Signum.zero),
        (-1 as StdlibInt,  0 as StdlibInt, Signum.negative),
        (-1 as StdlibInt,  1 as StdlibInt, Signum.negative),
        (-1 as StdlibInt,  2 as StdlibInt, Signum.negative),
        
        ( 0 as StdlibInt, -2 as StdlibInt, Signum.positive),
        ( 0 as StdlibInt, -1 as StdlibInt, Signum.positive),
        ( 0 as StdlibInt,  0 as StdlibInt, Signum.zero),
        ( 0 as StdlibInt,  1 as StdlibInt, Signum.negative),
        ( 0 as StdlibInt,  2 as StdlibInt, Signum.negative),
        
        ( 1 as StdlibInt, -2 as StdlibInt, Signum.positive),
        ( 1 as StdlibInt, -1 as StdlibInt, Signum.positive),
        ( 1 as StdlibInt,  0 as StdlibInt, Signum.positive),
        ( 1 as StdlibInt,  1 as StdlibInt, Signum.zero),
        ( 1 as StdlibInt,  2 as StdlibInt, Signum.negative),
        
        ( 2 as StdlibInt, -2 as StdlibInt, Signum.positive),
        ( 2 as StdlibInt, -1 as StdlibInt, Signum.positive),
        ( 2 as StdlibInt,  0 as StdlibInt, Signum.positive),
        ( 2 as StdlibInt,  1 as StdlibInt, Signum.positive),
        ( 2 as StdlibInt,  2 as StdlibInt, Signum.zero),
        
    ] as [(StdlibInt, StdlibInt, Signum)])
    func comparison(lhs: StdlibInt, rhs: StdlibInt, expectation: Signum) {
        Ɣexpect(lhs, equals: rhs, is: expectation)
    }
}
