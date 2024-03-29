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
// MARK: * Test x Addition
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func addition<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.additionAsSomeBinaryInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func additionAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ error: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        let result = ArithmeticResult(value, error: error)
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(lhs &+ rhs, value, file: file, line: line)
            XCTAssertEqual(rhs &+ lhs, value, file: file, line: line)
        };  if !error {
            XCTAssertEqual(lhs  + rhs, value, file: file, line: line)
            XCTAssertEqual(rhs  + lhs, value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &+= rhs; return x }(), value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x &+= lhs; return x }(), value, file: file, line: line)
        };  if !error {
            XCTAssertEqual({ var x = lhs; x  += rhs; return x }(), value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x  += lhs; return x }(), value, file: file, line: line)
        }
        //=--------------------------------------=
        if  let one = T.exactly(1).optional(), rhs == one {
            Test.incrementation(lhs, value, error, file: file, line: line)
        }
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(result, lhs.plus(rhs), file: file, line: line)
            XCTAssertEqual(result, lhs.plus(ArithmeticResult(rhs)), file: file, line: line)
            XCTAssertEqual(result, ArithmeticResult(lhs).plus(rhs), file: file, line: line)
            XCTAssertEqual(result, ArithmeticResult(lhs).plus(ArithmeticResult(rhs)), file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(result, rhs.plus(lhs), file: file, line: line)
            XCTAssertEqual(result, rhs.plus(ArithmeticResult(lhs)), file: file, line: line)
            XCTAssertEqual(result, ArithmeticResult(rhs).plus(lhs), file: file, line: line)
            XCTAssertEqual(result, ArithmeticResult(rhs).plus(ArithmeticResult(lhs)), file: file, line: line)
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
    
    public static func incrementation<T: BinaryInteger>(_ instance: T, _ value: T, _ error: Bool = false, file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        let result = ArithmeticResult(value, error: error)
        //=--------------------------------------=
        XCTAssertEqual(result, instance.incremented(), file: file, line: line)
        XCTAssertEqual(result, ArithmeticResult(instance).incremented(), file: file, line: line)
    }
}
