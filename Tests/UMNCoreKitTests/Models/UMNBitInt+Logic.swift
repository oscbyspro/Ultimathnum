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
// MARK: * UMN x Bit Int x Logic
//*============================================================================*

extension UMNBitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        XCTAssertEqual(~T.min, T.max as T)
        XCTAssertEqual(~T.max, T.min as T)
    }
    
    func testLogicalAnd() {
        XCTAssertEqual(~1 & ~1, ~1 as T)
        XCTAssertEqual(~1 & ~0, ~1 as T)
        XCTAssertEqual(~1 &  0,  0 as T)
        XCTAssertEqual(~1 &  1,  0 as T)
        
        XCTAssertEqual(~0 & ~1, ~1 as T)
        XCTAssertEqual(~0 & ~0, ~0 as T)
        XCTAssertEqual(~0 &  0,  0 as T)
        XCTAssertEqual(~0 &  1,  1 as T)
        
        XCTAssertEqual( 0 & ~1,  0 as T)
        XCTAssertEqual( 0 & ~0,  0 as T)
        XCTAssertEqual( 0 &  0,  0 as T)
        XCTAssertEqual( 0 &  1,  0 as T)
        
        XCTAssertEqual( 1 & ~1,  0 as T)
        XCTAssertEqual( 1 & ~0,  1 as T)
        XCTAssertEqual( 1 &  0,  0 as T)
        XCTAssertEqual( 1 &  1,  1 as T)
    }
    
    func testLogicalOr() {
        XCTAssertEqual(~1 | ~1, ~1 as T)
        XCTAssertEqual(~1 | ~0, ~0 as T)
        XCTAssertEqual(~1 |  0, ~1 as T)
        XCTAssertEqual(~1 |  1, ~0 as T)
        
        XCTAssertEqual(~0 | ~1, ~0 as T)
        XCTAssertEqual(~0 | ~0, ~0 as T)
        XCTAssertEqual(~0 |  0, ~0 as T)
        XCTAssertEqual(~0 |  1, ~0 as T)
        
        XCTAssertEqual( 0 | ~1, ~1 as T)
        XCTAssertEqual( 0 | ~0, ~0 as T)
        XCTAssertEqual( 0 |  0,  0 as T)
        XCTAssertEqual( 0 |  1,  1 as T)
        
        XCTAssertEqual( 1 | ~1, ~0 as T)
        XCTAssertEqual( 1 | ~0, ~0 as T)
        XCTAssertEqual( 1 |  0,  1 as T)
        XCTAssertEqual( 1 |  1,  1 as T)
    }
    
    func testLogicalXor() {
        XCTAssertEqual(~1 ^ ~1,  0 as T)
        XCTAssertEqual(~1 ^ ~0,  1 as T)
        XCTAssertEqual(~1 ^  0, ~1 as T)
        XCTAssertEqual(~1 ^  1, ~0 as T)
        
        XCTAssertEqual(~0 ^ ~1,  1 as T)
        XCTAssertEqual(~0 ^ ~0,  0 as T)
        XCTAssertEqual(~0 ^  0, ~0 as T)
        XCTAssertEqual(~0 ^  1, ~1 as T)
        
        XCTAssertEqual( 0 ^ ~1, ~1 as T)
        XCTAssertEqual( 0 ^ ~0, ~0 as T)
        XCTAssertEqual( 0 ^  0,  0 as T)
        XCTAssertEqual( 0 ^  1,  1 as T)
        
        XCTAssertEqual( 1 ^ ~1, ~0 as T)
        XCTAssertEqual( 1 ^ ~0, ~1 as T)
        XCTAssertEqual( 1 ^  0,  1 as T)
        XCTAssertEqual( 1 ^  1,  0 as T)
    }
}
