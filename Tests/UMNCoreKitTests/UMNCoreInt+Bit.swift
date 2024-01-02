//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Ultimathnum
import XCTest

//*============================================================================*
// MARK: * UMN x Core Int x Bit
//*============================================================================*

extension UMNCoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
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
}
