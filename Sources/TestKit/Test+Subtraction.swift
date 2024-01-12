//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import XCTest

//*============================================================================*
// MARK: * Test x Subtraction
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func subtraction<T: SystemInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.subtractionAsSomeSystemInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    public static func subtraction<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.subtractionAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    private static func subtractionAsSomeSystemInteger<T: SystemInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(lhs &- rhs, value, file: file, line: line)
        //=--------------------------------------=
        Test.subtractionAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    private static func subtractionAsSomeInteger<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        if !overflow {
            XCTAssertEqual(lhs - rhs, value, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try lhs.minus(rhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try lhs.minus(rhs) }).overflow, overflow, file: file, line: line)
        //=--------------------------------------=
        if  lhs == 0 {
            Test.subtractionByNegationAsSomeInteger(rhs, value, overflow, file: file, line: line)
        }
    }
    
    private static func subtractionByNegationAsSomeInteger<T: Integer>(
    _ operand: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=------------------------------------------=
        if !overflow {
            XCTAssertEqual(-operand, value, file: file, line: line)
            XCTAssertEqual(-value, operand, file: file, line: line)
        }
        //=------------------------------------------=
        XCTAssertEqual(Overflow.capture({ try operand.negated() }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try value  .negated() }).value,    operand,  file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try operand.negated() }).overflow, overflow, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try value  .negated() }).overflow, overflow, file: file, line: line)
    }
}
