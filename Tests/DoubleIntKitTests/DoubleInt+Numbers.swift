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
    
    #warning("perform nonoptional comparisons")
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(try? T.exactly(magnitude:      0).get(),   000 as T?)
            XCTAssertEqual(try? T.exactly(magnitude:      1).get(),   001 as T?)
            XCTAssertEqual(try? T.exactly(magnitude: ~M.msb).get(), T.max as T?)
            XCTAssertEqual(try? T.exactly(magnitude:  M.msb).get(),   nil as T?)
            XCTAssertEqual(try? T.exactly(magnitude:  M.max).get(),   nil as T?)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(try? T.exactly(magnitude:  M.min).get(), T.min as T?)
            XCTAssertEqual(try? T.exactly(magnitude:  M.max).get(), T.max as T?)
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
