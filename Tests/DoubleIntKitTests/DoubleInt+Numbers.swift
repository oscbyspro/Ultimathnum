//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
            
            XCTAssertEqual(try? T(magnitude:      0),   000 as T?)
            XCTAssertEqual(try? T(magnitude:      1),   001 as T?)
            XCTAssertEqual(try? T(magnitude: ~M.msb), T.max as T?)
            XCTAssertEqual(try? T(magnitude:  M.msb),   nil as T?)
            XCTAssertEqual(try? T(magnitude:  M.max),   nil as T?)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(try? T(magnitude:  M.min), T.min as T?)
            XCTAssertEqual(try? T(magnitude:  M.max), T.max as T?)
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
