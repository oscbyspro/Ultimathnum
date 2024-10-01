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
// MARK: * Stdlib Int x Multiplication
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
@Suite struct StdlibIntTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt - multiplication [forwarding]", arguments: [
        
        (-2 as StdlibInt, -2 as StdlibInt,  4 as StdlibInt),
        (-1 as StdlibInt, -2 as StdlibInt,  2 as StdlibInt),
        ( 0 as StdlibInt, -2 as StdlibInt,  0 as StdlibInt),
        ( 1 as StdlibInt, -2 as StdlibInt, -2 as StdlibInt),
        ( 2 as StdlibInt, -2 as StdlibInt, -4 as StdlibInt),
        
        (-2 as StdlibInt, -1 as StdlibInt,  2 as StdlibInt),
        (-1 as StdlibInt, -1 as StdlibInt,  1 as StdlibInt),
        ( 0 as StdlibInt, -1 as StdlibInt,  0 as StdlibInt),
        ( 1 as StdlibInt, -1 as StdlibInt, -1 as StdlibInt),
        ( 2 as StdlibInt, -1 as StdlibInt, -2 as StdlibInt),
        
        (-2 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        (-1 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 0 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 1 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 2 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        
        (-2 as StdlibInt,  1 as StdlibInt, -2 as StdlibInt),
        (-1 as StdlibInt,  1 as StdlibInt, -1 as StdlibInt),
        ( 0 as StdlibInt,  1 as StdlibInt,  0 as StdlibInt),
        ( 1 as StdlibInt,  1 as StdlibInt,  1 as StdlibInt),
        ( 2 as StdlibInt,  1 as StdlibInt,  2 as StdlibInt),
        
        (-2 as StdlibInt,  2 as StdlibInt, -4 as StdlibInt),
        (-1 as StdlibInt,  2 as StdlibInt, -2 as StdlibInt),
        ( 0 as StdlibInt,  2 as StdlibInt,  0 as StdlibInt),
        ( 1 as StdlibInt,  2 as StdlibInt,  2 as StdlibInt),
        ( 2 as StdlibInt,  2 as StdlibInt,  4 as StdlibInt),
        
    ] as [(StdlibInt, StdlibInt, StdlibInt)])
    func multiplication(lhs: StdlibInt, rhs: StdlibInt, expectation: StdlibInt) {
        #expect(lhs * rhs == expectation)
        #expect(rhs * lhs == expectation)
        
        #expect({ var x = lhs; x *= rhs; return x }() == expectation)
        #expect({ var x = rhs; x *= lhs; return x }() == expectation)
    }
}
