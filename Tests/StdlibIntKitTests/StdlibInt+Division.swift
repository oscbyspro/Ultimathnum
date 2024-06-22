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
// MARK: * Stdlib Int x Division
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func check(_ test: Test, _ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T) {
            let division = dividend.quotientAndRemainder(dividingBy: divisor)
            test.same(dividend / divisor, quotient )
            test.same(division .quotient, quotient )
            test.same(dividend % divisor, remainder)
            test.same(division.remainder, remainder)
            
            test.same({ var x = dividend; x /= divisor; return x }(), quotient )
            test.same({ var x = dividend; x %= divisor; return x }(), remainder)
        }
        
        check(Test(),  0 as T, -2 as T,  0 as T,  0 as T)
        check(Test(),  0 as T, -1 as T,  0 as T,  0 as T)
        check(Test(),  0 as T,  1 as T,  0 as T,  0 as T)
        check(Test(),  0 as T,  2 as T,  0 as T,  0 as T)
        
        check(Test(),  5 as T,  3 as T,  1 as T,  2 as T)
        check(Test(),  5 as T, -3 as T, -1 as T,  2 as T)
        check(Test(), -5 as T,  3 as T, -1 as T, -2 as T)
        check(Test(), -5 as T, -3 as T,  1 as T, -2 as T)
        
        check(Test(),  7 as T,  3 as T,  2 as T,  1 as T)
        check(Test(),  7 as T, -3 as T, -2 as T,  1 as T)
        check(Test(), -7 as T,  3 as T, -2 as T, -1 as T)
        check(Test(), -7 as T, -3 as T,  2 as T, -1 as T)
    }
}
