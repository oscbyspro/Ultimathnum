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
// MARK: * Signum
//*============================================================================*

final class SignumTests: XCTestCase {
    
    typealias T = Signum
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        Test().same(T(0 as Bit), T.same)
        Test().same(T(1 as Bit), T.more)
    }
    
    func testInitIntegerLiteral() {
        Test().same(-1 as T, T.less)
        Test().same( 0 as T, T.same)
        Test().same( 1 as T, T.more)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        Test().same(T.less, T.less)
        Test().less(T.less, T.same)
        Test().less(T.less, T.more)
        
        Test().more(T.same, T.less)
        Test().same(T.same, T.same)
        Test().less(T.same, T.more)
        
        Test().more(T.more, T.less)
        Test().more(T.more, T.same)
        Test().same(T.more, T.more)
    }
    
    func testNegation() {
        Test().same(-T.less, T.more)
        Test().same(-T.same, T.same)
        Test().same(-T.more, T.less)
        
        Test().same( T.less.negated(), T.more)
        Test().same( T.same.negated(), T.same)
        Test().same( T.more.negated(), T.less)
    }
}
