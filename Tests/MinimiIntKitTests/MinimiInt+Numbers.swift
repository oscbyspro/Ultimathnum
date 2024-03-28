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
// MARK: * Minimi Int x Numbers
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    #warning("perform nonoptional comparisons")
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(T.exactly(magnitude: 0).optional(), 000 as T?)
            XCTAssertEqual(T.exactly(magnitude: 1).optional(), nil as T?)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(T.exactly(magnitude: 0).optional(), 000 as T?)
            XCTAssertEqual(T.exactly(magnitude: 1).optional(), 001 as T?)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).magnitude, 0 as T.Magnitude)
            XCTAssertEqual((-1 as T).magnitude, 1 as T.Magnitude)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).magnitude, 0 as T.Magnitude)
            XCTAssertEqual(( 1 as T).magnitude, 1 as T.Magnitude)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
