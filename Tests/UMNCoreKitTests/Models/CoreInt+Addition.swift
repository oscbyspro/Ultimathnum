//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit
import XCTest

//*============================================================================*
// MARK: * UMN x Core Int x Addition
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertAddition( 0,  0,  0 as T)
            UMNAssertAddition(-1,  0, -1 as T)
            UMNAssertAddition( 0, -1, -1 as T)
            UMNAssertAddition(-1, -1, -2 as T)
                        
            UMNAssertAddition(T.min, T.min,  0, true)
            UMNAssertAddition(T.max, T.min, -1)
            UMNAssertAddition(T.min, T.max, -1)
            UMNAssertAddition(T.max, T.max, -2, true)
            
            UMNAssertAddition(T.min, -1, T.max, true)
            UMNAssertAddition(T.min,  0, T.min)
            UMNAssertAddition(T.min,  1, T.min + 1)
            UMNAssertAddition(T.max, -1, T.max - 1)
            UMNAssertAddition(T.max,  0, T.max)
            UMNAssertAddition(T.max,  1, T.min, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertAddition( 0,  0,  0 as T)
            UMNAssertAddition( 1,  0,  1 as T)
            UMNAssertAddition( 0,  1,  1 as T)
            UMNAssertAddition( 1,  1,  2 as T)
                        
            UMNAssertAddition(T.min, T.min, T.min)
            UMNAssertAddition(T.max, T.min, T.max)
            UMNAssertAddition(T.min, T.max, T.max)
            UMNAssertAddition(T.max, T.max, T.max - 1, true)
            
            UMNAssertAddition(T.min,  0, T.min)
            UMNAssertAddition(T.min,  1, T.min + 1)
            UMNAssertAddition(T.max,  0, T.max)
            UMNAssertAddition(T.max,  1, T.min, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

//*============================================================================*
// MARK: * UMN x Bit Int x Addition x Assertions
//*============================================================================*

private func UMNAssertAddition<T: SystemInteger>(
_ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs + rhs, value, file: file, line: line)
        XCTAssertEqual(rhs + lhs, value, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs &+ rhs,                        value,    file: file, line: line)
    XCTAssertEqual(rhs &+ lhs,                        value,    file: file, line: line)
    XCTAssertEqual(lhs.incremented(by: rhs).value,    value,    file: file, line: line)
    XCTAssertEqual(rhs.incremented(by: lhs).value,    value,    file: file, line: line)
    XCTAssertEqual(lhs.incremented(by: rhs).overflow, overflow, file: file, line: line)
    XCTAssertEqual(rhs.incremented(by: lhs).overflow, overflow, file: file, line: line)
}
