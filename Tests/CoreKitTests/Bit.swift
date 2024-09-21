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
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBool() {
        Test().same(Bit(false), Bit.zero)
        Test().same(Bit(true ), Bit.one )
        
        Test().same(Bit(raw: false), Bit.zero)
        Test().same(Bit(raw: true ), Bit.one )
        
        Test().same(Bool(Bit.zero), false)
        Test().same(Bool(Bit.one ), true )
        
        Test().same(Bool(raw: Bit.zero), false)
        Test().same(Bool(raw: Bit.one ), true )
    }
        
    func testSign() {
        Test().same(Bit(Sign.plus ), Bit.zero)
        Test().same(Bit(Sign.minus), Bit.one )
        
        Test().same(Bit(raw: Sign.plus ), Bit.zero)
        Test().same(Bit(raw: Sign.minus), Bit.one )
        
        Test().same(Sign(Bit.zero), .plus )
        Test().same(Sign(Bit.one ), .minus)
        
        Test().same(Sign(raw: Bit.zero), .plus )
        Test().same(Sign(raw: Bit.one ), .minus)
    }
    
    func testComparison() {
        func comparison(_ lhs: Bit, _ rhs: Bit, _ expectation: Signum, _ test: Test = .init()) {
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
        
        comparison(Bit.zero,  Bit.zero, Signum.zero)
        comparison(Bit.zero,  Bit.one,  Signum.negative)
        comparison(Bit.one,   Bit.zero, Signum.positive)
        comparison(Bit.one,   Bit.one,  Signum.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        Test().not(Bit.zero, Bit.one )
        Test().not(Bit.one,  Bit.zero)
    }
    
    func testLogicalAnd() {
        Test().and(Bit.zero, Bit.zero, Bit.zero)
        Test().and(Bit.zero, Bit.one,  Bit.zero)
        Test().and(Bit.one,  Bit.zero, Bit.zero)
        Test().and(Bit.one,  Bit.one,  Bit.one )
    }
    
    func testLogicalOr() {
        Test().or (Bit.zero, Bit.zero, Bit.zero)
        Test().or (Bit.zero, Bit.one,  Bit.one )
        Test().or (Bit.one,  Bit.zero, Bit.one )
        Test().or (Bit.one,  Bit.one,  Bit.one )
    }
    
    func testLogcialXor() {
        Test().xor(Bit.zero, Bit.zero, Bit.zero)
        Test().xor(Bit.zero, Bit.one,  Bit.one )
        Test().xor(Bit.one,  Bit.zero, Bit.one )
        Test().xor(Bit.one,  Bit.one,  Bit.zero)
    }
}
