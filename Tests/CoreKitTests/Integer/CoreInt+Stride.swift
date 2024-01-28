//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Stride
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStride() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            var lhsLength = 000 as Int
            var rhsLength = 255 as Int
            
            let lowerBound: T = T.isSigned ? -128 : 000
            let upperBound: T = T.isSigned ?  127 : 255
            
            for value in lowerBound ... upperBound {
                XCTAssertEqual(lowerBound.distance(to: value),  lhsLength)
                XCTAssertEqual(upperBound.distance(to: value), -rhsLength)

                XCTAssertEqual(value.distance(to: lowerBound), -lhsLength)
                XCTAssertEqual(value.distance(to: upperBound),  rhsLength)
                
                XCTAssertEqual(lowerBound.advanced(by:  lhsLength), value)
                XCTAssertEqual(upperBound.advanced(by: -rhsLength), value)
                
                XCTAssertEqual(value.advanced(by: -lhsLength), lowerBound)
                XCTAssertEqual(value.advanced(by:  rhsLength), upperBound)
                
                lhsLength += 1
                rhsLength -= 1
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStrideOverflowAdvanced() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T.advanced(T.min, by: -1 as IX),   nil)
            XCTAssertEqual(try? T.advanced(T.min, by:  0 as IX), T.min)
            XCTAssertEqual(try? T.advanced(T.min, by:  1 as IX), T.min + 1)
            XCTAssertEqual(try? T.advanced(T.max, by: -1 as IX), T.max - 1)
            XCTAssertEqual(try? T.advanced(T.max, by:  0 as IX), T.max)
            XCTAssertEqual(try? T.advanced(T.max, by:  1 as IX),   nil)
            
            if  T.bitWidth.load(as: UX.self) < IX.bitWidth.load(as: UX.self) {
                XCTAssertNil(try? T.advanced(0 as T, by: IX.min))
                XCTAssertNil(try? T.advanced(0 as T, by: IX.max))
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testStrideOverflowDistance() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(try? T.distance(T.max, to: T.max.advanced(by: -129), as: I8.self),    nil)
            XCTAssertEqual(try? T.distance(T.max, to: T.max.advanced(by: -128), as: I8.self), I8.min)
            XCTAssertEqual(try? T.distance(T.max, to: T.max.advanced(by: -127), as: I8.self), I8.min + 1)
            XCTAssertEqual(try? T.distance(T.min, to: T.min.advanced(by:  126), as: I8.self), I8.max - 1)
            XCTAssertEqual(try? T.distance(T.min, to: T.min.advanced(by:  127), as: I8.self), I8.max)
            XCTAssertEqual(try? T.distance(T.min, to: T.min.advanced(by:  128), as: I8.self),    nil)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}