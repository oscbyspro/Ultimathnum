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
// MARK: * UMN x Bit Int x Bit
//*============================================================================*

extension UMNBitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(false), 0)
        XCTAssertEqual(T(true ), 1)
    }
    
    func testInitBitOnRepeat() {
        XCTAssertEqual(T(repeating: false),  0)
        XCTAssertEqual(T(repeating: true ), ~0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testCountBitOption() {
        XCTAssertEqual((~0 as T).count(true,  option:        .all), 1)
        XCTAssertEqual((~1 as T).count(true,  option:        .all), 0)
        XCTAssertEqual(( 0 as T).count(true,  option:        .all), 0)
        XCTAssertEqual(( 1 as T).count(true,  option:        .all), 1)
        
        XCTAssertEqual((~0 as T).count(false, option:        .all), 0)
        XCTAssertEqual((~1 as T).count(false, option:        .all), 1)
        XCTAssertEqual(( 0 as T).count(false, option:        .all), 1)
        XCTAssertEqual(( 1 as T).count(false, option:        .all), 0)
        
        XCTAssertEqual((~0 as T).count(true,  option:  .ascending), 1)
        XCTAssertEqual((~1 as T).count(true,  option:  .ascending), 0)
        XCTAssertEqual(( 0 as T).count(true,  option:  .ascending), 0)
        XCTAssertEqual(( 1 as T).count(true,  option:  .ascending), 1)
        
        XCTAssertEqual((~0 as T).count(false, option:  .ascending), 0)
        XCTAssertEqual((~1 as T).count(false, option:  .ascending), 1)
        XCTAssertEqual(( 0 as T).count(false, option:  .ascending), 1)
        XCTAssertEqual(( 1 as T).count(false, option:  .ascending), 0)
        
        XCTAssertEqual((~0 as T).count(true,  option: .descending), 1)
        XCTAssertEqual((~1 as T).count(true,  option: .descending), 0)
        XCTAssertEqual(( 0 as T).count(true,  option: .descending), 0)
        XCTAssertEqual(( 1 as T).count(true,  option: .descending), 1)
        
        XCTAssertEqual((~0 as T).count(false, option: .descending), 0)
        XCTAssertEqual((~1 as T).count(false, option: .descending), 1)
        XCTAssertEqual(( 0 as T).count(false, option: .descending), 1)
        XCTAssertEqual(( 1 as T).count(false, option: .descending), 0)
    }
}
