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
// MARK: * UMN x Bit Int
//*============================================================================*

final class UMNBitIntTests: XCTestCase {
    
    typealias T = UMNBitInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMinIs0() {
        XCTAssertEqual(T.min, 0)
    }
    
    func testMsbIs1() {
        XCTAssertEqual(T.msb, 1)
    }
    
    func testMaxIs1() {
        XCTAssertEqual(T.max, 1)
    }
    
    func testBitWidthIs1() {
        XCTAssertEqual(T.bitWidth, 1)
    }
    
    func testValueIsUnsigned() {
        XCTAssertFalse(T.isSigned)
    }
}
