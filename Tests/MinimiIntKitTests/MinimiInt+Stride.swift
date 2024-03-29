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
    
    func testStrideAdvancedBy() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult
            
            XCTAssertEqual(T.advanced(-1 as T, by:  IX .min), AR(-1 as T, error: true))
            XCTAssertEqual(T.advanced(-1 as T, by: -2 as IX), AR(-1 as T, error: true))
            XCTAssertEqual(T.advanced(-1 as T, by: -1 as IX), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced(-1 as T, by:  0 as IX), AR(-1 as T))
            XCTAssertEqual(T.advanced(-1 as T, by:  1 as IX), AR( 0 as T))
            XCTAssertEqual(T.advanced(-1 as T, by:  2 as IX), AR(-1 as T, error: true))
            XCTAssertEqual(T.advanced(-1 as T, by:  IX .max), AR( 0 as T, error: true))
            
            XCTAssertEqual(T.advanced( 0 as T, by:  IX .min), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by: -2 as IX), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by: -1 as IX), AR(-1 as T))
            XCTAssertEqual(T.advanced( 0 as T, by:  0 as IX), AR( 0 as T))
            XCTAssertEqual(T.advanced( 0 as T, by:  1 as IX), AR(-1 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by:  2 as IX), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by:  IX .max), AR(-1 as T, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult
            
            XCTAssertEqual(T.advanced( 0 as T, by:  IX .min), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by: -2 as IX), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by: -1 as IX), AR( 1 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by:  0 as IX), AR( 0 as T))
            XCTAssertEqual(T.advanced( 0 as T, by:  1 as IX), AR( 1 as T))
            XCTAssertEqual(T.advanced( 0 as T, by:  2 as IX), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 0 as T, by:  IX .max), AR( 1 as T, error: true))
            
            XCTAssertEqual(T.advanced( 1 as T, by:  IX .min), AR( 1 as T, error: true))
            XCTAssertEqual(T.advanced( 1 as T, by: -2 as IX), AR( 1 as T, error: true))
            XCTAssertEqual(T.advanced( 1 as T, by: -1 as IX), AR( 0 as T))
            XCTAssertEqual(T.advanced( 1 as T, by:  0 as IX), AR( 1 as T))
            XCTAssertEqual(T.advanced( 1 as T, by:  1 as IX), AR( 0 as T, error: true))
            XCTAssertEqual(T.advanced( 1 as T, by:  2 as IX), AR( 1 as T, error: true))
            XCTAssertEqual(T.advanced( 1 as T, by:  IX .max), AR( 0 as T, error: true))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testStrideDistanceTo() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult
            
            XCTAssertEqual(T.distance(-1 as T, to: -1 as T, as: IX.self), AR( 0 as IX))
            XCTAssertEqual(T.distance(-1 as T, to:  0 as T, as: IX.self), AR( 1 as IX))
            XCTAssertEqual(T.distance( 0 as T, to: -1 as T, as: IX.self), AR(-1 as IX))
            XCTAssertEqual(T.distance( 0 as T, to:  0 as T, as: IX.self), AR( 0 as IX))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias AR = ArithmeticResult
            
            XCTAssertEqual(T.distance( 0 as T, to:  0 as T, as: IX.self), AR( 0 as IX))
            XCTAssertEqual(T.distance( 0 as T, to:  1 as T, as: IX.self), AR( 1 as IX))
            XCTAssertEqual(T.distance( 1 as T, to:  0 as T, as: IX.self), AR(-1 as IX))
            XCTAssertEqual(T.distance( 1 as T, to:  1 as T, as: IX.self), AR( 0 as IX))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
