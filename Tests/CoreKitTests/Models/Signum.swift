//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import XCTest

//*============================================================================*
// MARK: * Signum
//*============================================================================*

final class SignumTests: XCTestCase {
    
    typealias T = Signum
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitIntegerLiteral() {
        XCTAssertEqual(-1 as T, T.less)
        XCTAssertEqual( 0 as T, T.same)
        XCTAssertEqual( 1 as T, T.more)
    }
    
    func testComparison() {
        XCTAssertEqual(      T.less, T.less)
        XCTAssertLessThan(   T.less, T.same)
        XCTAssertLessThan(   T.less, T.more)
        
        XCTAssertGreaterThan(T.same, T.less)
        XCTAssertEqual(      T.same, T.same)
        XCTAssertLessThan(   T.same, T.more)
        
        XCTAssertGreaterThan(T.more, T.less)
        XCTAssertGreaterThan(T.more, T.same)
        XCTAssertEqual(      T.more, T.more)
    }
    
    func testNegation() {
        XCTAssertEqual(T.less.negated(), T.more)
        XCTAssertEqual(T.same.negated(), T.same)
        XCTAssertEqual(T.more.negated(), T.less)
    }
}
