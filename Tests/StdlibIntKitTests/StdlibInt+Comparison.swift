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
// MARK: * Stdlib Int x Comparison
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func check(_ test: Test, _ lhs: T, _ rhs: T, _ expectation: Signum) {
            test.comparison(lhs, rhs, expectation, id: ComparableID())
        }
        
        check(Test(), -2 as T, -2 as T,  0 as Signum)
        check(Test(), -2 as T, -1 as T, -1 as Signum)
        check(Test(), -2 as T,  0 as T, -1 as Signum)
        check(Test(), -2 as T,  1 as T, -1 as Signum)
        check(Test(), -2 as T,  2 as T, -1 as Signum)
        
        check(Test(), -1 as T, -2 as T,  1 as Signum)
        check(Test(), -1 as T, -1 as T,  0 as Signum)
        check(Test(), -1 as T,  0 as T, -1 as Signum)
        check(Test(), -1 as T,  1 as T, -1 as Signum)
        check(Test(), -1 as T,  2 as T, -1 as Signum)
        
        check(Test(),  0 as T, -2 as T,  1 as Signum)
        check(Test(),  0 as T, -1 as T,  1 as Signum)
        check(Test(),  0 as T,  0 as T,  0 as Signum)
        check(Test(),  0 as T,  1 as T, -1 as Signum)
        check(Test(),  0 as T,  2 as T, -1 as Signum)
        
        check(Test(),  1 as T, -2 as T,  1 as Signum)
        check(Test(),  1 as T, -1 as T,  1 as Signum)
        check(Test(),  1 as T,  0 as T,  1 as Signum)
        check(Test(),  1 as T,  1 as T,  0 as Signum)
        check(Test(),  1 as T,  2 as T, -1 as Signum)
        
        check(Test(),  2 as T, -2 as T,  1 as Signum)
        check(Test(),  2 as T, -1 as T,  1 as Signum)
        check(Test(),  2 as T,  0 as T,  1 as Signum)
        check(Test(),  2 as T,  1 as T,  1 as Signum)
        check(Test(),  2 as T,  2 as T,  0 as Signum)
    }
}
