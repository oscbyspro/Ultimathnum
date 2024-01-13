//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    func testInitBit() {
        XCTAssertEqual(T(0 as Bit), T.plus )
        XCTAssertEqual(T(1 as Bit), T.minus)
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
    
    func testNot() {
        Test.not(T.plus,  T.minus)
        Test.not(T.minus, T.plus )
    }
    
    func testAnd() {
        Test.and(T.plus , T.plus , T.plus )
        Test.and(T.plus , T.minus, T.plus )
        Test.and(T.minus, T.plus , T.plus )
        Test.and(T.minus, T.minus, T.minus)
    }
    
    func testOr() {
        Test.or (T.plus , T.plus , T.plus )
        Test.or (T.plus , T.minus, T.minus)
        Test.or (T.minus, T.plus , T.minus)
        Test.or (T.minus, T.minus, T.minus)
    }
    
    func testXor() {
        Test.xor(T.plus , T.plus , T.plus )
        Test.xor(T.plus , T.minus, T.minus)
        Test.xor(T.minus, T.plus , T.minus)
        Test.xor(T.minus, T.minus, T.plus )
    }
}
