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

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func check(_ test: Test, _ lhs: T, _ rhs: T, _ expecation: T) {
            test.same(lhs + rhs, expecation)
            test.same(rhs + lhs, expecation)
            
            test.same({ var x = lhs; x += rhs; return x }(), expecation)
            test.same({ var x = rhs; x += lhs; return x }(), expecation)
            
            test.same(expecation - lhs, rhs)
            test.same(expecation - rhs, lhs)
            
            test.same({ var x = expecation; x -= lhs; return x }(), rhs)
            test.same({ var x = expecation; x -= rhs; return x }(), lhs)
        }
        
        check(Test(),  0 as T,  0 as T,  0 as T)
        check(Test(),  3 as T,  5 as T,  8 as T)
        check(Test(),  3 as T, -5 as T, -2 as T)
        check(Test(), -3 as T,  5 as T,  2 as T)
        check(Test(), -3 as T, -5 as T, -8 as T)
    }
    
    func testNegation() {
        func check(_ test: Test, _ instance: T, _ expecation: T) {
            test.same(-instance, expecation)
            test.same(-expecation, instance)
            
            test.same({ var x = instance;   x.negate(); return x }(), expecation)
            test.same({ var x = expecation; x.negate(); return x }(),   instance)
        }
        
        check(Test(), -2 as T,  2 as T)
        check(Test(), -1 as T,  1 as T)
        check(Test(),  0 as T,  0 as T)
        check(Test(),  1 as T, -1 as T)
        check(Test(),  2 as T, -2 as T)
    }
}
