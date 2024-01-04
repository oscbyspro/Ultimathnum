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
// MARK: * UMN x Bit Int x Addition
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertAddition( 0,  0,  0 as T)
            UMNAssertAddition(-1,  0, -1 as T)
            UMNAssertAddition( 0, -1, -1 as T)
            UMNAssertAddition(-1, -1,  0 as T, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertAddition( 0,  0,  0 as T)
            UMNAssertAddition( 1,  0,  1 as T)
            UMNAssertAddition( 0,  1,  1 as T)
            UMNAssertAddition( 1,  1,  0 as T, true)
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
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs &+ rhs,                        value,    file: file, line: line)
    XCTAssertEqual(lhs.incremented(by: rhs).value,    value,    file: file, line: line)
    XCTAssertEqual(lhs.incremented(by: rhs).overflow, overflow, file: file, line: line)
}
