//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import XCTest

//*============================================================================*
// MARK: * Core Int x Bit
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T(repeating: 0 as Bit),  0)
            XCTAssertEqual(T(repeating: 1 as Bit), ~0)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testBitCountSelection() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual((~0 as T).count(1, option:        .all), T.bitWidth)
            XCTAssertEqual((~1 as T).count(1, option:        .all), T.bitWidth - 1)
            XCTAssertEqual(( 0 as T).count(1, option:        .all), 0)
            XCTAssertEqual(( 1 as T).count(1, option:        .all), 1)
            
            XCTAssertEqual((~0 as T).count(0, option:        .all), 0)
            XCTAssertEqual((~1 as T).count(0, option:        .all), 1)
            XCTAssertEqual(( 0 as T).count(0, option:        .all), T.bitWidth)
            XCTAssertEqual(( 1 as T).count(0, option:        .all), T.bitWidth - 1)
            
            XCTAssertEqual((~0 as T).count(1, option:  .ascending), T.bitWidth)
            XCTAssertEqual((~1 as T).count(1, option:  .ascending), 0)
            XCTAssertEqual(( 0 as T).count(1, option:  .ascending), 0)
            XCTAssertEqual(( 1 as T).count(1, option:  .ascending), 1)
            
            XCTAssertEqual((~0 as T).count(0, option:  .ascending), 0)
            XCTAssertEqual((~1 as T).count(0, option:  .ascending), 1)
            XCTAssertEqual(( 0 as T).count(0, option:  .ascending), T.bitWidth)
            XCTAssertEqual(( 1 as T).count(0, option:  .ascending), 0)
            
            XCTAssertEqual((~0 as T).count(1, option: .descending), T.bitWidth)
            XCTAssertEqual((~1 as T).count(1, option: .descending), T.bitWidth - 1)
            XCTAssertEqual(( 0 as T).count(1, option: .descending), 0)
            XCTAssertEqual(( 1 as T).count(1, option: .descending), 0)
            
            XCTAssertEqual((~0 as T).count(0, option: .descending), 0)
            XCTAssertEqual((~1 as T).count(0, option: .descending), 0)
            XCTAssertEqual(( 0 as T).count(0, option: .descending), T.bitWidth)
            XCTAssertEqual(( 1 as T).count(0, option: .descending), T.bitWidth - 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
