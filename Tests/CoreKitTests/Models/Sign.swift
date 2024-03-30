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
// MARK: * Sign
//*============================================================================*

final class SignTests: XCTestCase {
    
    typealias T = Sign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        Test.invariants(T.self, identifier: BitCastableID())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(bitPattern: 0 as Bit), T.plus )
        XCTAssertEqual(T(bitPattern: 1 as Bit), T.minus)
    }
    
    func testInitFloatingPointSign() {
        XCTAssertEqual(T(FloatingPointSign.plus ), T.plus )
        XCTAssertEqual(T(FloatingPointSign.minus), T.minus)
    }
    
    func testMakeFloatingPointSign() {
        XCTAssertEqual(FloatingPointSign(T.plus ), FloatingPointSign.plus )
        XCTAssertEqual(FloatingPointSign(T.minus), FloatingPointSign.minus)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        Test.not(T.plus,  T.minus)
        Test.not(T.minus, T.plus )
        
        XCTAssertEqual({ var x = T.plus;  x.toggle(); return x }(), T.minus)
        XCTAssertEqual({ var x = T.minus; x.toggle(); return x }(), T.plus )
    }
    
    func testLogicalAnd() {
        Test.and(T.plus , T.plus , T.plus )
        Test.and(T.plus , T.minus, T.plus )
        Test.and(T.minus, T.plus , T.plus )
        Test.and(T.minus, T.minus, T.minus)
    }
    
    func testLogicalOr() {
        Test.or (T.plus , T.plus , T.plus )
        Test.or (T.plus , T.minus, T.minus)
        Test.or (T.minus, T.plus , T.minus)
        Test.or (T.minus, T.minus, T.minus)
    }
    
    func testLogcialXor() {
        Test.xor(T.plus , T.plus , T.plus )
        Test.xor(T.plus , T.minus, T.minus)
        Test.xor(T.minus, T.plus , T.minus)
        Test.xor(T.minus, T.minus, T.plus )
    }
}
