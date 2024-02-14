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
// MARK: * Double Int x Stride
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStrideAdvancedBy() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            XCTAssertEqual(try? T.advanced(T.min, by: -1 as IX),   nil)
            XCTAssertEqual(try? T.advanced(T.min, by:  0 as IX), T.min)
            XCTAssertEqual(try? T.advanced(T.min, by:  1 as IX), T.min + 1)
            XCTAssertEqual(try? T.advanced(T.max, by: -1 as IX), T.max - 1)
            XCTAssertEqual(try? T.advanced(T.max, by:  0 as IX), T.max)
            XCTAssertEqual(try? T.advanced(T.max, by:  1 as IX),   nil)
            
            if  UX(bitWidth: T.self) < IX.bitWidth {
                XCTAssertNil(try? T.advanced(0 as T, by: IX.min))
                XCTAssertNil(try? T.advanced(0 as T, by: IX.max))
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testStrideDistanceTo() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            XCTAssertEqual(try? T.distance(T.max, to: T.max.advanced(by: -129), as: I8.self),    nil)
            XCTAssertEqual(try? T.distance(T.max, to: T.max.advanced(by: -128), as: I8.self), I8.min)
            XCTAssertEqual(try? T.distance(T.max, to: T.max.advanced(by: -127), as: I8.self), I8.min + 1)
            XCTAssertEqual(try? T.distance(T.min, to: T.min.advanced(by:  126), as: I8.self), I8.max - 1)
            XCTAssertEqual(try? T.distance(T.min, to: T.min.advanced(by:  127), as: I8.self), I8.max)
            XCTAssertEqual(try? T.distance(T.min, to: T.min.advanced(by:  128), as: I8.self),    nil)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
