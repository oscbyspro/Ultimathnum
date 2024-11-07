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
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Addition
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
@Suite struct StdlibIntTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt - addition [forwarding]", arguments: [
        
        ( 0 as StdlibInt,  0 as StdlibInt,  0 as StdlibInt),
        ( 3 as StdlibInt,  5 as StdlibInt,  8 as StdlibInt),
        ( 3 as StdlibInt, -5 as StdlibInt, -2 as StdlibInt),
        (-3 as StdlibInt,  5 as StdlibInt,  2 as StdlibInt),
        (-3 as StdlibInt, -5 as StdlibInt, -8 as StdlibInt),
        
    ]   as [(StdlibInt, StdlibInt, StdlibInt)]) func addition(lhs: StdlibInt, rhs: StdlibInt, expectation: StdlibInt) {
        #expect(lhs + rhs == expectation)
        #expect(rhs + lhs == expectation)
        
        #expect({ var x = lhs; x += rhs; return x }() == expectation)
        #expect({ var x = rhs; x += lhs; return x }() == expectation)
        
        #expect(expectation - lhs == rhs)
        #expect(expectation - rhs == lhs)
        
        #expect({ var x = expectation; x -= lhs; return x }() == rhs)
        #expect({ var x = expectation; x -= rhs; return x }() == lhs)
    }
    
    @Test("StdlibInt - negation [forwarding]", arguments: [
        
        (-2 as StdlibInt,  2 as StdlibInt),
        (-1 as StdlibInt,  1 as StdlibInt),
        ( 0 as StdlibInt,  0 as StdlibInt),
        ( 1 as StdlibInt, -1 as StdlibInt),
        ( 2 as StdlibInt, -2 as StdlibInt),
        
    ]   as [(StdlibInt, StdlibInt)]) func negation(instance: StdlibInt, expectation: StdlibInt) {
        #expect(-instance == expectation)
        #expect(-expectation == instance)
        
        #expect({ var x = instance; x.negate(); return x }() == expectation)
        #expect({ var x = expectation; x.negate(); return x }() == instance)
    }
}
