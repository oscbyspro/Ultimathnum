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
// MARK: * UMN x Core Int x Subtraction
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertNegation( 0,  0 as T)
            UMNAssertNegation( 1, ~0 as T)
            UMNAssertNegation(-1,  1 as T)
            
            UMNAssertNegation(T.max, T.min + 1)
            UMNAssertNegation(T.min, T.min + 0, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertNegation( 0,  0 as T)
            UMNAssertNegation( 1, ~0 as T, true)
            UMNAssertNegation( 2, ~1 as T, true)
            
            UMNAssertNegation(T.min, T.min + 0)
            UMNAssertNegation(T.max, T.min + 1, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtraction() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertSubtraction( 0,  0,  0 as T)
            UMNAssertSubtraction(-1,  0, -1 as T)
            UMNAssertSubtraction( 0, -1,  1 as T)
            UMNAssertSubtraction(-1, -1,  0 as T)
            
            UMNAssertSubtraction(T.min, T.min,  0)
            UMNAssertSubtraction(T.max, T.min, -1, true)
            UMNAssertSubtraction(T.min, T.max,  1, true)
            UMNAssertSubtraction(T.max, T.max,  0)

            UMNAssertSubtraction(T.max,  1, T.max - 1)
            UMNAssertSubtraction(T.max,  0, T.max)
            UMNAssertSubtraction(T.max, -1, T.min, true)
            UMNAssertSubtraction(T.min,  1, T.max, true)
            UMNAssertSubtraction(T.min,  0, T.min)
            UMNAssertSubtraction(T.min, -1, T.min + 1)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            UMNAssertSubtraction( 0,  0,  0 as T)
            UMNAssertSubtraction( 1,  0,  1 as T)
            UMNAssertSubtraction( 0,  1, ~0 as T, true)
            UMNAssertSubtraction( 1,  1,  0 as T)
            
            UMNAssertSubtraction(T.min, T.min, T.min)
            UMNAssertSubtraction(T.max, T.min, T.max)
            UMNAssertSubtraction(T.min, T.max,   001, true)
            UMNAssertSubtraction(T.max, T.max, T.min)
            
            UMNAssertSubtraction(T.min, 2, T.max - 1, true)
            UMNAssertSubtraction(T.min, 1, T.max - 0, true)
            UMNAssertSubtraction(T.min, 0, T.min - 0)
            UMNAssertSubtraction(T.max, 2, T.max - 2)
            UMNAssertSubtraction(T.max, 1, T.max - 1)
            UMNAssertSubtraction(T.max, 0, T.max - 0)
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
        XCTAssertEqual(-value, operand, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(operand.negated().value,    value,    file: file, line: line)
    XCTAssertEqual(value  .negated().value,    operand,  file: file, line: line)
    XCTAssertEqual(operand.negated().overflow, overflow, file: file, line: line)
    XCTAssertEqual(value  .negated().overflow, overflow, file: file, line: line)    
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
