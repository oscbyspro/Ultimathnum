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
        Test.invariants(T.self, identifier: BitCastableID())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        XCTAssertEqual(T(bitPattern: false as Bool), 0)
        XCTAssertEqual(T(bitPattern: true  as Bool), 1)
        
        XCTAssertEqual(Bool(bitPattern: 0 as T), false)
        XCTAssertEqual(Bool(bitPattern: 1 as T), true )
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
    
    func checkComparison(_ lhs: T, _ rhs: T, _ expectation: Signum, file: StaticString = #file, line: UInt = #line) {
        for (x, y, z) in [(lhs, rhs, expectation), (rhs, lhs, expectation.negated())] {
            XCTAssertEqual(x.compared(to: y), ((z)), file: file, line: line)
            XCTAssertEqual(x <  y, z == Signum.less, file: file, line: line)
            XCTAssertEqual(x >= y, z != Signum.less, file: file, line: line)
            XCTAssertEqual(x >  y, z == Signum.more, file: file, line: line)
            XCTAssertEqual(x <= y, z != Signum.more, file: file, line: line)
            XCTAssertEqual(x == y, z == Signum.same, file: file, line: line)
            XCTAssertEqual(x != y, z != Signum.same, file: file, line: line)
        }
    }
}
