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
// MARK: * Core Int x Numbers
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias AR = ArithmeticResult<T>
                        
            XCTAssertEqual(T.exactly(magnitude:  M( 0)), AR(T( 0)))
            XCTAssertEqual(T.exactly(magnitude:  M( 1)), AR(T( 1)))
            XCTAssertEqual(T.exactly(magnitude: ~M.msb), AR(T.max))
            XCTAssertEqual(T.exactly(magnitude:  M.msb), AR(T.msb, error: true))
            XCTAssertEqual(T.exactly(magnitude:  M.max), AR(T(-1), error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias AR = ArithmeticResult<T>
            
            XCTAssertEqual(T.exactly(magnitude:  M.min), AR(T.min))
            XCTAssertEqual(T.exactly(magnitude:  M.max), AR(T.max))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual((-1 as T).magnitude,  1 as M)
            XCTAssertEqual(( 0 as T).magnitude,  0 as M)
            XCTAssertEqual(( T .max).magnitude, ~M .msb)
            XCTAssertEqual(( T .min).magnitude,  M .msb)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(( 0 as T).magnitude, 0 as M)
            XCTAssertEqual(( 1 as T).magnitude, 1 as M)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
