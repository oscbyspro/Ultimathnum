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
// MARK: * Core Int x Bit
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
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
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for bit: Bit in [0, 1] {
                for selection: Bit.Selection in [.all, .ascending, .descending] {
                    XCTAssertEqual(( 0 as T).count(bit, option: selection), bit == 0 ? T.bitWidth : 0)
                    XCTAssertEqual((~0 as T).count(bit, option: selection), bit == 1 ? T.bitWidth : 0)
                }
                
                for element: (integer: T, bit: Bit) in [(11, 0), (~11, 1)] {
                    XCTAssertEqual(element.integer.count(bit, option:        .all), bit == element.bit ? T.bitWidth - 3 : 3)
                    XCTAssertEqual(element.integer.count(bit, option:  .ascending), bit == element.bit ?              0 : 2)
                    XCTAssertEqual(element.integer.count(bit, option: .descending), bit == element.bit ? T.bitWidth - 4 : 0)
                }
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
