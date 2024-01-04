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

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(0 as Bit), 0)
        XCTAssertEqual(T(1 as Bit), 1)
    }
    
    func testInitBitOnRepeat() {
        XCTAssertEqual(T(repeating: 0 as Bit),  0)
        XCTAssertEqual(T(repeating: 1 as Bit), ~0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testCountBitOption() {
        XCTAssertEqual((~0 as T).count(1, option:        .all), 1)
        XCTAssertEqual((~1 as T).count(1, option:        .all), 0)
        XCTAssertEqual(( 0 as T).count(1, option:        .all), 0)
        XCTAssertEqual(( 1 as T).count(1, option:        .all), 1)
        
        XCTAssertEqual((~0 as T).count(0, option:        .all), 0)
        XCTAssertEqual((~1 as T).count(0, option:        .all), 1)
        XCTAssertEqual(( 0 as T).count(0, option:        .all), 1)
        XCTAssertEqual(( 1 as T).count(0, option:        .all), 0)
        
        XCTAssertEqual((~0 as T).count(1, option:  .ascending), 1)
        XCTAssertEqual((~1 as T).count(1, option:  .ascending), 0)
        XCTAssertEqual(( 0 as T).count(1, option:  .ascending), 0)
        XCTAssertEqual(( 1 as T).count(1, option:  .ascending), 1)
        
        XCTAssertEqual((~0 as T).count(0, option:  .ascending), 0)
        XCTAssertEqual((~1 as T).count(0, option:  .ascending), 1)
        XCTAssertEqual(( 0 as T).count(0, option:  .ascending), 1)
        XCTAssertEqual(( 1 as T).count(0, option:  .ascending), 0)
        
        XCTAssertEqual((~0 as T).count(1, option: .descending), 1)
        XCTAssertEqual((~1 as T).count(1, option: .descending), 0)
        XCTAssertEqual(( 0 as T).count(1, option: .descending), 0)
        XCTAssertEqual(( 1 as T).count(1, option: .descending), 1)
        
        XCTAssertEqual((~0 as T).count(0, option: .descending), 0)
        XCTAssertEqual((~1 as T).count(0, option: .descending), 1)
        XCTAssertEqual(( 0 as T).count(0, option: .descending), 1)
        XCTAssertEqual(( 1 as T).count(0, option: .descending), 0)
    }
}
