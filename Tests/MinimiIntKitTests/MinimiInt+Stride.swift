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
// MARK: * Minimi Int x Stride
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    #warning("perform nonoptional comparisons")
    func testStrideAdvancedBy() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T.advanced(-1 as T, by:  IX .min).get(),  nil)
            XCTAssertEqual(try? T.advanced(-1 as T, by: -2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced(-1 as T, by: -1 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced(-1 as T, by:  0 as IX).get(), -1 as T)
            XCTAssertEqual(try? T.advanced(-1 as T, by:  1 as IX).get(),  0 as T)
            XCTAssertEqual(try? T.advanced(-1 as T, by:  2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced(-1 as T, by:  IX .max).get(),  nil)
            
            XCTAssertEqual(try? T.advanced( 0 as T, by:  IX .min).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by: -2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by: -1 as IX).get(), -1 as T)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  0 as IX).get(),  0 as T)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  1 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  IX .max).get(),  nil)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T.advanced( 0 as T, by:  IX .min).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by: -2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by: -1 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  0 as IX).get(),  0 as T)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  1 as IX).get(),  1 as T)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 0 as T, by:  IX .max).get(),  nil)
            
            XCTAssertEqual(try? T.advanced( 1 as T, by:  IX .min).get(),  nil)
            XCTAssertEqual(try? T.advanced( 1 as T, by: -2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 1 as T, by: -1 as IX).get(),  0 as T)
            XCTAssertEqual(try? T.advanced( 1 as T, by:  0 as IX).get(),  1 as T)
            XCTAssertEqual(try? T.advanced( 1 as T, by:  1 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 1 as T, by:  2 as IX).get(),  nil)
            XCTAssertEqual(try? T.advanced( 1 as T, by:  IX .max).get(),  nil)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    #warning("perform nonoptional comparisons")
    func testStrideDistanceTo() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T.distance(-1 as T, to: -1 as T, as: IX.self).get(),  0 as IX)
            XCTAssertEqual(try? T.distance(-1 as T, to:  0 as T, as: IX.self).get(),  1 as IX)
            XCTAssertEqual(try? T.distance( 0 as T, to: -1 as T, as: IX.self).get(), -1 as IX)
            XCTAssertEqual(try? T.distance( 0 as T, to:  0 as T, as: IX.self).get(),  0 as IX)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T.distance( 0 as T, to:  0 as T, as: IX.self).get(),  0 as IX)
            XCTAssertEqual(try? T.distance( 0 as T, to:  1 as T, as: IX.self).get(),  1 as IX)
            XCTAssertEqual(try? T.distance( 1 as T, to:  0 as T, as: IX.self).get(), -1 as IX)
            XCTAssertEqual(try? T.distance( 1 as T, to:  1 as T, as: IX.self).get(),  0 as IX)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
