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
    
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult<T>
            
            XCTAssertEqual(T.exactly(magnitude: 0), AR( 0))
            XCTAssertEqual(T.exactly(magnitude: 1), AR(-1, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult<T>

            XCTAssertEqual(T.exactly(magnitude: 0), AR( 0))
            XCTAssertEqual(T.exactly(magnitude: 1), AR( 1))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult<T>
            
            XCTAssertEqual(( 0 as T).magnitude, 0 as T.Magnitude)
            XCTAssertEqual((-1 as T).magnitude, 1 as T.Magnitude)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult<T>
            
            XCTAssertEqual(( 0 as T).magnitude, 0 as T.Magnitude)
            XCTAssertEqual(( 1 as T).magnitude, 1 as T.Magnitude)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
