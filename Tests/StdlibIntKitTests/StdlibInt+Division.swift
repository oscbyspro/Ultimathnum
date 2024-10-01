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
// MARK: * Stdlib Int x Division
//*============================================================================*

/// An `StdlibInt` test suite.
///
/// ### Wrapper
///
/// `StdlibInt` should forward most function calls to its underlying model.
///
/// ### Development
///
/// - TODO: Test `StdlibInt` forwarding in generic `BinaryInteger` tests.
///
@Suite struct StdlibIntTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt - division [forwarding]", arguments: [
        
        ( 0 as StdlibInt, -2 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 0 as StdlibInt, -1 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 0 as StdlibInt,  1 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 0 as StdlibInt,  2 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        
        ( 5 as StdlibInt,  3 as StdlibInt,  1 as StdlibInt,  2 as StdlibInt),
        ( 5 as StdlibInt, -3 as StdlibInt, -1 as StdlibInt,  2 as StdlibInt),
        (-5 as StdlibInt,  3 as StdlibInt, -1 as StdlibInt, -2 as StdlibInt),
        (-5 as StdlibInt, -3 as StdlibInt,  1 as StdlibInt, -2 as StdlibInt),
        
        ( 7 as StdlibInt,  3 as StdlibInt,  2 as StdlibInt,  1 as StdlibInt),
        ( 7 as StdlibInt, -3 as StdlibInt, -2 as StdlibInt,  1 as StdlibInt),
        (-7 as StdlibInt,  3 as StdlibInt, -2 as StdlibInt, -1 as StdlibInt),
        (-7 as StdlibInt, -3 as StdlibInt,  2 as StdlibInt, -1 as StdlibInt),
        
    ] as [(StdlibInt, StdlibInt, StdlibInt, StdlibInt)])
    func division(dividend: StdlibInt, divisor: StdlibInt, quotient: StdlibInt, remainder: StdlibInt) {
        let division = dividend.quotientAndRemainder(dividingBy: divisor)
        #expect(dividend / divisor == quotient )
        #expect(division .quotient == quotient )
        #expect(dividend % divisor == remainder)
        #expect(division.remainder == remainder)
        
        #expect({ var x = dividend; x /= divisor; return x }() == quotient )
        #expect({ var x = dividend; x %= divisor; return x }() == remainder)
    }
}
