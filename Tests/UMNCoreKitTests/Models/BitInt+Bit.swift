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
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(bitPattern: ~0 as M).count(1, option:        .all), 1)
            XCTAssertEqual(T(bitPattern: ~1 as M).count(1, option:        .all), 0)
            XCTAssertEqual(T(bitPattern:  0 as M).count(1, option:        .all), 0)
            XCTAssertEqual(T(bitPattern:  1 as M).count(1, option:        .all), 1)
            
            XCTAssertEqual(T(bitPattern: ~0 as M).count(0, option:        .all), 0)
            XCTAssertEqual(T(bitPattern: ~1 as M).count(0, option:        .all), 1)
            XCTAssertEqual(T(bitPattern:  0 as M).count(0, option:        .all), 1)
            XCTAssertEqual(T(bitPattern:  1 as M).count(0, option:        .all), 0)
            
            XCTAssertEqual(T(bitPattern: ~0 as M).count(1, option:  .ascending), 1)
            XCTAssertEqual(T(bitPattern: ~1 as M).count(1, option:  .ascending), 0)
            XCTAssertEqual(T(bitPattern:  0 as M).count(1, option:  .ascending), 0)
            XCTAssertEqual(T(bitPattern:  1 as M).count(1, option:  .ascending), 1)
            
            XCTAssertEqual(T(bitPattern: ~0 as M).count(0, option:  .ascending), 0)
            XCTAssertEqual(T(bitPattern: ~1 as M).count(0, option:  .ascending), 1)
            XCTAssertEqual(T(bitPattern:  0 as M).count(0, option:  .ascending), 1)
            XCTAssertEqual(T(bitPattern:  1 as M).count(0, option:  .ascending), 0)
            
            XCTAssertEqual(T(bitPattern: ~0 as M).count(1, option: .descending), 1)
            XCTAssertEqual(T(bitPattern: ~1 as M).count(1, option: .descending), 0)
            XCTAssertEqual(T(bitPattern:  0 as M).count(1, option: .descending), 0)
            XCTAssertEqual(T(bitPattern:  1 as M).count(1, option: .descending), 1)
            
            XCTAssertEqual(T(bitPattern: ~0 as M).count(0, option: .descending), 0)
            XCTAssertEqual(T(bitPattern: ~1 as M).count(0, option: .descending), 1)
            XCTAssertEqual(T(bitPattern:  0 as M).count(0, option: .descending), 1)
            XCTAssertEqual(T(bitPattern:  1 as M).count(0, option: .descending), 0)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
