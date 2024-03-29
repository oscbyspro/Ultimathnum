//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Numbers
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            XCTAssertEqual(T.exactly(magnitude:  M( 0)), F(T( 0)))
            XCTAssertEqual(T.exactly(magnitude:  M( 1)), F(T( 1)))
            XCTAssertEqual(T.exactly(magnitude: ~M.msb), F(T.max))
            XCTAssertEqual(T.exactly(magnitude:  M.msb), F(T.msb, error: true))
            XCTAssertEqual(T.exactly(magnitude:  M.max), F(T(-1), error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            XCTAssertEqual(T.exactly(magnitude:  M.min), F(T.min))
            XCTAssertEqual(T.exactly(magnitude:  M.max), F(T.max))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias AR = Fallible<T>
            
            XCTAssertEqual((-1 as T).magnitude,  1 as M)
            XCTAssertEqual(( 0 as T).magnitude,  0 as M)
            XCTAssertEqual(( T .max).magnitude, ~M .msb)
            XCTAssertEqual(( T .min).magnitude,  M .msb)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias AR = Fallible<T>
            
            XCTAssertEqual(( 0 as T).magnitude, 0 as M)
            XCTAssertEqual(( 1 as T).magnitude, 1 as M)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
