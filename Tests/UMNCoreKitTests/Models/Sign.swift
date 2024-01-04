//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit
import XCTest

//*============================================================================*
// MARK: * UMN x Sign
//*============================================================================*

final class SignTests: XCTestCase {
    
    typealias T = Sign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(Bit(false)), T.plus )
        XCTAssertEqual(T(Bit(true )), T.minus)
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
        XCTAssertEqual(T.plus .toggled(), T.minus)
        XCTAssertEqual(T.minus.toggled(), T.plus )
    }
    
    func testAnd() {
        XCTAssertEqual(T.plus  & T.plus , T.plus )
        XCTAssertEqual(T.plus  & T.minus, T.plus )
        XCTAssertEqual(T.minus & T.plus , T.plus )
        XCTAssertEqual(T.minus & T.minus, T.minus)
    }
    
    func testOr() {
        XCTAssertEqual(T.plus  | T.plus , T.plus )
        XCTAssertEqual(T.plus  | T.minus, T.minus)
        XCTAssertEqual(T.minus | T.plus , T.minus)
        XCTAssertEqual(T.minus | T.minus, T.minus)
    }
    
    func testXor() {
        XCTAssertEqual(T.plus  ^ T.plus , T.plus )
        XCTAssertEqual(T.plus  ^ T.minus, T.minus)
        XCTAssertEqual(T.minus ^ T.plus , T.minus)
        XCTAssertEqual(T.minus ^ T.minus, T.plus )
    }
}
