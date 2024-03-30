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
    
    func testInvariants() {
        Test().invariants(T.self, BitCastableID())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        Test().same(T(bitPattern: false as Bool), 0)
        Test().same(T(bitPattern: true  as Bool), 1)
        
        Test().same(Bool(bitPattern: 0 as T), false)
        Test().same(Bool(bitPattern: 1 as T), true )
    }
    
    func testComparison() {
        checkComparison( 0 as T,  0 as T,  0 as Signum)
        checkComparison( 0 as T,  1 as T, -1 as Signum)
        checkComparison( 1 as T,  0 as T,  1 as Signum)
        checkComparison( 1 as T,  1 as T,  0 as Signum)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        Test.not(0 as T, 1 as T)
        Test.not(1 as T, 0 as T)
    }
    
    func testLogicalAnd() {
        Test.and(0 as T, 0 as T, 0 as T)
        Test.and(0 as T, 1 as T, 0 as T)
        Test.and(1 as T, 0 as T, 0 as T)
        Test.and(1 as T, 1 as T, 1 as T)
    }
    
    func testLogicalOr() {
        Test.or (0 as T, 0 as T, 0 as T)
        Test.or (0 as T, 1 as T, 1 as T)
        Test.or (1 as T, 0 as T, 1 as T)
        Test.or (1 as T, 1 as T, 1 as T)
    }
    
    func testLogcialXor() {
        Test.xor(0 as T, 0 as T, 0 as T)
        Test.xor(0 as T, 1 as T, 1 as T)
        Test.xor(1 as T, 0 as T, 1 as T)
        Test.xor(1 as T, 1 as T, 0 as T)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    // TODO: Write a custom Comparable protocol with a compared(to:) method.
    //=------------------------------------------------------------------------=
    
    func checkComparison(_ lhs: T, _ rhs: T, _ expectation: Signum, _ check: Test = .init()) {
        for (x, y, z) in [(lhs, rhs, expectation), (rhs, lhs, expectation.negated())] {
            check.same(x.compared(to: y), ((z)))
            check.same(x <  y, z == Signum.less)
            check.same(x >= y, z != Signum.less)
            check.same(x >  y, z == Signum.more)
            check.same(x <= y, z != Signum.more)
            check.same(x == y, z == Signum.same)
            check.same(x != y, z != Signum.same)
        }
    }
}
