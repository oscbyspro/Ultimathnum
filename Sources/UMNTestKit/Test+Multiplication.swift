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
// MARK: * Test x Multiplication
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func multiplication<T: SystemInteger>(
    _ lhs: T, _ rhs: T, _ low: T, _ high: T,_ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.multiplicationAsSomeSystemInteger(lhs, rhs, low, high, overflow, file: file, line: line)
    }
    
    public static func multiplication<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.multiplicationAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    private static func multiplicationAsSomeSystemInteger<T: SystemInteger>(
    _ lhs: T, _ rhs: T, _ low: T, _ high: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(lhs &* rhs, low, file: file, line: line)
        XCTAssertEqual(rhs &* lhs, low, file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(T.multiplying(lhs, by: rhs), FullWidth(low: T.Magnitude(bitPattern: low), high: high), file: file, line: line)
        //=--------------------------------------=
        Test.multiplicationAsSomeInteger(lhs, rhs, low, overflow, file: file, line: line)
    }
    
    private static func multiplicationAsSomeInteger<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        if !overflow {
            XCTAssertEqual(lhs * rhs, value, file: file, line: line)
            XCTAssertEqual(rhs * lhs, value, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(lhs.multiplied(by: rhs).value,    value,    file: file, line: line)
        XCTAssertEqual(lhs.multiplied(by: rhs).overflow, overflow, file: file, line: line)
        XCTAssertEqual(rhs.multiplied(by: lhs).value,    value,    file: file, line: line)
        XCTAssertEqual(rhs.multiplied(by: lhs).overflow, overflow, file: file, line: line)
        //=--------------------------------------=
        if  lhs == rhs {
            Test.multiplicationBySquareProductAsSomeInteger(lhs, value, overflow, file: file, line: line)
            Test.multiplicationBySquareProductAsSomeInteger(rhs, value, overflow, file: file, line: line)
        }
    }
    
    private static func multiplicationBySquareProductAsSomeInteger<T: Integer>(
    _ operand: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(operand.squared().value,    value,    file: file, line: line)
        XCTAssertEqual(operand.squared().overflow, overflow, file: file, line: line)
    }
}
