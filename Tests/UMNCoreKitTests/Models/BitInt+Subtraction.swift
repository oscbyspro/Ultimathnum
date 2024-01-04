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
// MARK: * UMN x Bit Int x Subtraction
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertNegation( 0,  0 as T)
            UMNAssertNegation(-1, -1 as T, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertNegation( 0,  0 as T)
            UMNAssertNegation( 1,  1 as T, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtraction() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertSubtraction( 0,  0,  0 as T)
            UMNAssertSubtraction(-1,  0, -1 as T)
            UMNAssertSubtraction( 0, -1, -1 as T, true)
            UMNAssertSubtraction(-1, -1,  0 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertSubtraction( 0,  0,  0 as T)
            UMNAssertSubtraction( 1,  0,  1 as T)
            UMNAssertSubtraction( 0,  1,  1 as T, true)
            UMNAssertSubtraction( 1,  1,  0 as T)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

//*============================================================================*
// MARK: * UMN x Bit Int x Subtraction x Assertions
//*============================================================================*

private func UMNAssertNegation<T: SystemInteger>(
_ operand: T, _ value: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(-operand, value, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(operand.negated().value,    value,    file: file, line: line)
    XCTAssertEqual(operand.negated().overflow, overflow, file: file, line: line)
}

private func UMNAssertSubtraction<T: SystemInteger>(
_ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs - rhs, value, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs &- rhs,                        value,    file: file, line: line)
    XCTAssertEqual(lhs.decremented(by: rhs).value,    value,    file: file, line: line)
    XCTAssertEqual(lhs.decremented(by: rhs).overflow, overflow, file: file, line: line)
}
