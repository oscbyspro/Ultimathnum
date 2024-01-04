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
// MARK: * UMN x Core Int x Bit
//*============================================================================*

extension UMNCoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereIs<T>(_ type: T.Type) where T: UMNSystemInteger {
            XCTAssertEqual(T(false), 0)
            XCTAssertEqual(T(true ), 1)
        }
        
        for type in Self.allIntegers {
            whereIs(type)
        }
    }
    
    func testInitBitOnRepeat() {
        func whereIs<T>(_ type: T.Type) where T: UMNSystemInteger {
            XCTAssertEqual(T(repeating: false),  0)
            XCTAssertEqual(T(repeating: true ), ~0)
        }
        
        for type in Self.allIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testCountBitOption() {
        func whereIs<T>(_ type: T.Type) where T: UMNSystemInteger {
            XCTAssertEqual((~0 as T).count(true,  option:        .all), T.bitWidth)
            XCTAssertEqual((~1 as T).count(true,  option:        .all), T.bitWidth - 1)
            XCTAssertEqual(( 0 as T).count(true,  option:        .all), 0)
            XCTAssertEqual(( 1 as T).count(true,  option:        .all), 1)
            
            XCTAssertEqual((~0 as T).count(false, option:        .all), 0)
            XCTAssertEqual((~1 as T).count(false, option:        .all), 1)
            XCTAssertEqual(( 0 as T).count(false, option:        .all), T.bitWidth)
            XCTAssertEqual(( 1 as T).count(false, option:        .all), T.bitWidth - 1)
            
            XCTAssertEqual((~0 as T).count(true,  option:  .ascending), T.bitWidth)
            XCTAssertEqual((~1 as T).count(true,  option:  .ascending), 0)
            XCTAssertEqual(( 0 as T).count(true,  option:  .ascending), 0)
            XCTAssertEqual(( 1 as T).count(true,  option:  .ascending), 1)
            
            XCTAssertEqual((~0 as T).count(false, option:  .ascending), 0)
            XCTAssertEqual((~1 as T).count(false, option:  .ascending), 1)
            XCTAssertEqual(( 0 as T).count(false, option:  .ascending), T.bitWidth)
            XCTAssertEqual(( 1 as T).count(false, option:  .ascending), 0)
            
            XCTAssertEqual((~0 as T).count(true,  option: .descending), T.bitWidth)
            XCTAssertEqual((~1 as T).count(true,  option: .descending), T.bitWidth - 1)
            XCTAssertEqual(( 0 as T).count(true,  option: .descending), 0)
            XCTAssertEqual(( 1 as T).count(true,  option: .descending), 0)
            
            XCTAssertEqual((~0 as T).count(false, option: .descending), 0)
            XCTAssertEqual((~1 as T).count(false, option: .descending), 0)
            XCTAssertEqual(( 0 as T).count(false, option: .descending), T.bitWidth)
            XCTAssertEqual(( 1 as T).count(false, option: .descending), T.bitWidth - 1)
        }
        
        for type in Self.allIntegers {
            whereIs(type)
        }
    }
}
