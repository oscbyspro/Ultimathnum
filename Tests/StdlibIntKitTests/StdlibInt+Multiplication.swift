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
// MARK: * Stdlib Int x Multiplication
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        func check(_ test: Test, _ lhs: T, _ rhs: T, _ expecation: T) {
            test.same(lhs * rhs, expecation)
            test.same(rhs * lhs, expecation)
            
            test.same({ var x = lhs; x *= rhs; return x }(), expecation)
            test.same({ var x = rhs; x *= lhs; return x }(), expecation)
        }
        
        check(Test(), -2 as T, -2 as T,  4 as T)
        check(Test(), -1 as T, -2 as T,  2 as T)
        check(Test(),  0 as T, -2 as T,  0 as T)
        check(Test(),  1 as T, -2 as T, -2 as T)
        check(Test(),  2 as T, -2 as T, -4 as T)
        
        check(Test(), -2 as T, -1 as T,  2 as T)
        check(Test(), -1 as T, -1 as T,  1 as T)
        check(Test(),  0 as T, -1 as T,  0 as T)
        check(Test(),  1 as T, -1 as T, -1 as T)
        check(Test(),  2 as T, -1 as T, -2 as T)
        
        check(Test(), -2 as T,  0 as T,  0 as T)
        check(Test(), -1 as T,  0 as T,  0 as T)
        check(Test(),  0 as T,  0 as T,  0 as T)
        check(Test(),  1 as T,  0 as T,  0 as T)
        check(Test(),  2 as T,  0 as T,  0 as T)
        
        check(Test(), -2 as T,  1 as T, -2 as T)
        check(Test(), -1 as T,  1 as T, -1 as T)
        check(Test(),  0 as T,  1 as T,  0 as T)
        check(Test(),  1 as T,  1 as T,  1 as T)
        check(Test(),  2 as T,  1 as T,  2 as T)
        
        check(Test(), -2 as T,  2 as T, -4 as T)
        check(Test(), -1 as T,  2 as T, -2 as T)
        check(Test(),  0 as T,  2 as T,  0 as T)
        check(Test(),  1 as T,  2 as T,  2 as T)
        check(Test(),  2 as T,  2 as T,  4 as T)
    }
}
