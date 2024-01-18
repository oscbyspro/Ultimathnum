//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import BitIntKit
import CoreKit
import TestKit

//*============================================================================*
// MARK: * Bit Int x Numbers
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T(magnitude: 0), 000 as T?)
            XCTAssertEqual(try? T(magnitude: 1), nil as T?)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T(magnitude: 0), 000 as T?)
            XCTAssertEqual(try? T(magnitude: 1), 001 as T?)
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
