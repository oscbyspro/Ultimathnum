//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
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
    
    public static func subtraction<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.subtractionAsSomeBinaryInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func subtractionAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ error: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(lhs &- rhs, value, file: file, line: line)
        };  if !error {
            XCTAssertEqual(lhs  - rhs, value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &-= rhs; return x }(), value, file: file, line: line)
        };  if !error {
            XCTAssertEqual({ var x = lhs; x  -= rhs; return x }(), value, file: file, line: line)
        }
        //=--------------------------------------=
        if !error {
            let abc: T = rhs.minus(lhs).value.negated().value
            let xyz: T = lhs.minus(rhs).value
            XCTAssertEqual(abc, xyz, "binary integer subtraction must be reversible", file: file, line: line)
        }   else {
            let abc: T = rhs.minus(lhs).value
            let xyz: T = lhs.minus(rhs).value.negated().value
            XCTAssertEqual(abc, xyz, "binary integer subtraction must be reversible", file: file, line: line)
        }
        //=--------------------------------------=
        if  let one = T.exactly(literal: 1).optional(), rhs == one {
            Test.decrementation(lhs, value, error, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(lhs.minus(rhs).value, value, file: file, line: line)
        XCTAssertEqual(lhs.minus(rhs).error, error, file: file, line: line)
        //=--------------------------------------=
        // same as rhs negation when lhs is zero
        //=--------------------------------------=
        if  lhs == 0 {
            XCTAssertEqual(rhs.negated().value, value, file: file, line: line)
            XCTAssertEqual(rhs.negated().error, error, file: file, line: line)
        }
        
        if  lhs == 0, !error {
            XCTAssertEqual(-rhs, value, file: file, line: line)
            XCTAssertEqual(-value, rhs, file: file, line: line)
        }
        
        
        if  lhs == 0, !error {
            XCTAssertEqual(value.negated().value, rhs,   file: file, line: line)
            XCTAssertEqual(value.negated().error, error, file: file, line: line)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func decrementation<T: BinaryInteger>(_ instance: T, _ value: T, _ error: Bool = false, file: StaticString = #file, line: UInt = #line) {
        let result = instance.decremented()
        XCTAssertEqual(result.value, value, file: file, line: line)
        XCTAssertEqual(result.error, error, file: file, line: line)
    }
}
