//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Minimi Int x Bit
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
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
    
    func testBitCountSelection() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for bit: Bit in [0, 1] {
                for selection: Bit.Selection in [.all, .ascending, .descending] {
                    XCTAssertEqual(T(bitPattern: 0 as T.Magnitude).count(bit, option: selection), bit == 0 ? 1 : 0)
                    XCTAssertEqual(T(bitPattern: 1 as T.Magnitude).count(bit, option: selection), bit == 1 ? 1 : 0)
                }
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLeastSignificantBit() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual((-1 as T).leastSignificantBit, 1 as Bit)
            XCTAssertEqual(( 0 as T).leastSignificantBit, 0 as Bit)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( 1 as T).leastSignificantBit, 1 as Bit)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Elements
    //=------------------------------------------------------------------------=
    
    func testMakeToken() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).load(as: IX.self),  0 as IX)
            XCTAssertEqual((-1 as T).load(as: IX.self), ~0 as IX)
            XCTAssertEqual(( 0 as T).load(as: UX.self),  0 as UX)
            XCTAssertEqual((-1 as T).load(as: UX.self), ~0 as UX)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).load(as: IX.self),  0 as IX)
            XCTAssertEqual(( 1 as T).load(as: IX.self),  1 as IX)
            XCTAssertEqual(( 0 as T).load(as: UX.self),  0 as UX)
            XCTAssertEqual(( 1 as T).load(as: UX.self),  1 as UX)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
