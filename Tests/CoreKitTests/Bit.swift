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
// MARK: * Bit
//*============================================================================*

final class BitTests: XCTestCase {
    
    typealias T = Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBool() {
        Test().same(T(false), 0 as T)
        Test().same(T(true ), 1 as T)
        
        Test().same(T(raw: false), 0 as T)
        Test().same(T(raw: true ), 1 as T)
        
        Test().same(Bool(0 as T), false)
        Test().same(Bool(1 as T), true )
        
        Test().same(Bool(raw: 0 as T), false)
        Test().same(Bool(raw: 1 as T), true )
    }
        
    func testSign() {
        Test().same(T(Sign.plus ), 0 as T)
        Test().same(T(Sign.minus), 1 as T)
        
        Test().same(T(raw: Sign.plus ), 0 as T)
        Test().same(T(raw: Sign.minus), 1 as T)
        
        Test().same(Sign(0 as T), .plus )
        Test().same(Sign(1 as T), .minus)
        
        Test().same(Sign(raw: 0 as T), .plus )
        Test().same(Sign(raw: 1 as T), .minus)
    }
    
    func testComparison() {
        func comparison(_ lhs: T, _ rhs: T, _ expectation: Signum, _ test: Test = .init()) {
            for (x, y, z) in [
                (lhs, rhs, expectation),
                (rhs, lhs, expectation.negated())
            ] {
                test.same(x.compared(to: y), z)
                test.same(x <  y, z == Signum.negative)
                test.same(x >= y, z != Signum.negative)
                test.same(x == y, z == Signum.zero)
                test.same(x != y, z != Signum.zero)
                test.same(x >  y, z == Signum.positive)
                test.same(x <= y, z != Signum.positive)
            }
        }
        
        comparison( 0 as T,  0 as T,  0 as Signum)
        comparison( 0 as T,  1 as T, -1 as Signum)
        comparison( 1 as T,  0 as T,  1 as Signum)
        comparison( 1 as T,  1 as T,  0 as Signum)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        Test().not(0 as T, 1 as T)
        Test().not(1 as T, 0 as T)
    }
    
    func testLogicalAnd() {
        Test().and(0 as T, 0 as T, 0 as T)
        Test().and(0 as T, 1 as T, 0 as T)
        Test().and(1 as T, 0 as T, 0 as T)
        Test().and(1 as T, 1 as T, 1 as T)
    }
    
    func testLogicalOr() {
        Test().or (0 as T, 0 as T, 0 as T)
        Test().or (0 as T, 1 as T, 1 as T)
        Test().or (1 as T, 0 as T, 1 as T)
        Test().or (1 as T, 1 as T, 1 as T)
    }
    
    func testLogcialXor() {
        Test().xor(0 as T, 0 as T, 0 as T)
        Test().xor(0 as T, 1 as T, 1 as T)
        Test().xor(1 as T, 0 as T, 1 as T)
        Test().xor(1 as T, 1 as T, 0 as T)
    }
}
