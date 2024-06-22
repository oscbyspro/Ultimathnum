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
// MARK: * Stdlib Int x Bitwise
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitwiseNot() {
        let values: [T] = [
            0x00000000000000000000000000000000,
            0x00000000000000000000000000000001,
            0x0f0e0d0c0b0a09080706050403020100,
            0xf0f1f2f3f4f5f6f7f8f9fafbfcfdfeff,
            0xfffffffffffffffffffffffffffffffe,
            0xffffffffffffffffffffffffffffffff,
        ]
        
        for value in values  {
            let expectation: T = -1 - value
            Test().same(~value, expectation)
            Test().same(~expectation, value)
        }
    }
    
    func testBitwiseAnd() {
        func check(_ test: Test, _ lhs: T, _ rhs: T, _ expectation: T) {
            test.same(lhs & rhs, expectation)
            test.same(rhs & lhs, expectation)
            
            test.same({ var x = lhs; x &= rhs; return x }(), expectation)
            test.same({ var x = rhs; x &= lhs; return x }(), expectation)
        }
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T)
        check(Test(),  0x55555555555555555555555555555555 as T,  0x55555555555555555555555555555555 as T,  0x55555555555555555555555555555555 as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T)
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T,  0x00000000000000000000000000000000 as T)
        check(Test(),  0x55555555555555555555555555555555 as T, ~0x00000000000000000000000000000000 as T,  0x55555555555555555555555555555555 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T,  0x00000000000000000000000000000000 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T, ~0x00000000000000000000000000000000 as T, ~0x55555555555555555555555555555555 as T)
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T,  0x55555555555555555555555555555555 as T)
        check(Test(),  0x55555555555555555555555555555555 as T, ~0xffffffffffffffffffffffffffffffff as T,  0x00000000000000000000000000000000 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0x55555555555555555555555555555555 as T, ~0xffffffffffffffffffffffffffffffff as T, ~0xffffffffffffffffffffffffffffffff as T)
        
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T,  0x00000000000000000000000000000000 as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0x00000000000000000000000000000000 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T,  0x00000000000000000000000000000000 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0x00000000000000000000000000000000 as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0xffffffffffffffffffffffffffffffff as T,  0x00000000000000000000000000000000 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T,  0x55555555555555555555555555555555 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0xffffffffffffffffffffffffffffffff as T, ~0xffffffffffffffffffffffffffffffff as T)

    }
    
    func testBitwiseOr() {
        func check(_ test: Test, _ lhs: T, _ rhs: T, _ expectation: T) {
            test.same(lhs | rhs, expectation)
            test.same(rhs | lhs, expectation)
            
            test.same({ var x = lhs; x |= rhs; return x }(), expectation)
            test.same({ var x = rhs; x |= lhs; return x }(), expectation)
        }
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T)
        check(Test(),  0x55555555555555555555555555555555 as T,  0x55555555555555555555555555555555 as T,  0x55555555555555555555555555555555 as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T)
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T,  0x55555555555555555555555555555555 as T)
        check(Test(),  0x55555555555555555555555555555555 as T, ~0x00000000000000000000000000000000 as T, ~0x00000000000000000000000000000000 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T, ~0x55555555555555555555555555555555 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T, ~0x00000000000000000000000000000000 as T, ~0x00000000000000000000000000000000 as T)
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T,  0xffffffffffffffffffffffffffffffff as T)
        check(Test(),  0x55555555555555555555555555555555 as T, ~0xffffffffffffffffffffffffffffffff as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T, ~0x00000000000000000000000000000000 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T, ~0xffffffffffffffffffffffffffffffff as T, ~0x55555555555555555555555555555555 as T)
        
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0x00000000000000000000000000000000 as T, ~0x00000000000000000000000000000000 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0x00000000000000000000000000000000 as T, ~0x00000000000000000000000000000000 as T)
        
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T,  0xffffffffffffffffffffffffffffffff as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0xffffffffffffffffffffffffffffffff as T, ~0x55555555555555555555555555555555 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T, ~0x00000000000000000000000000000000 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0xffffffffffffffffffffffffffffffff as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
    }
    
    func testBitwiseXor() {
        func check(_ test: Test, _ lhs: T, _ rhs: T, _ expectation: T) {
            test.same(lhs ^ rhs, expectation)
            test.same(rhs ^ lhs, expectation)
            
            test.same({ var x = lhs; x ^= rhs; return x }(), expectation)
            test.same({ var x = rhs; x ^= lhs; return x }(), expectation)
        }
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T)
        check(Test(),  0x55555555555555555555555555555555 as T,  0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T)
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T,  0x55555555555555555555555555555555 as T)
        check(Test(),  0x55555555555555555555555555555555 as T, ~0x00000000000000000000000000000000 as T, ~0x55555555555555555555555555555555 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T,  0x00000000000000000000000000000000 as T, ~0x55555555555555555555555555555555 as T)
        check(Test(), ~0x55555555555555555555555555555555 as T, ~0x00000000000000000000000000000000 as T,  0x55555555555555555555555555555555 as T)
        
        check(Test(),  0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(),  0x55555555555555555555555555555555 as T, ~0xffffffffffffffffffffffffffffffff as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0x55555555555555555555555555555555 as T,  0xffffffffffffffffffffffffffffffff as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0x55555555555555555555555555555555 as T, ~0xffffffffffffffffffffffffffffffff as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0x00000000000000000000000000000000 as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0x00000000000000000000000000000000 as T, ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0x00000000000000000000000000000000 as T,  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T)
        
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T,  0x55555555555555555555555555555555 as T)
        check(Test(),  0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0xffffffffffffffffffffffffffffffff as T, ~0x55555555555555555555555555555555 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T,  0xffffffffffffffffffffffffffffffff as T, ~0x55555555555555555555555555555555 as T)
        check(Test(), ~0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as T, ~0xffffffffffffffffffffffffffffffff as T,  0x55555555555555555555555555555555 as T)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        Test().same(T(-2).magnitude, 2 as T)
        Test().same(T(-1).magnitude, 1 as T)
        Test().same(T( 0).magnitude, 0 as T)
        Test().same(T( 1).magnitude, 1 as T)
        Test().same(T( 2).magnitude, 2 as T)
    }
}
