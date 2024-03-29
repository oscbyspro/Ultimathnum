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
// MARK: * Test x Multiplication
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func multiplication<T: SystemsInteger>(
    _ lhs: T, _ rhs: T, _ product: DoubleIntLayout<T>,_ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.multiplicationAsSomeSystemsInteger(lhs, rhs, product, overflow, file: file, line: line)
    }
    
    public static func multiplication<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T,_ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.multiplicationAsSomeBinaryInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func multiplicationAsSomeSystemsInteger<T: SystemsInteger>(
    _ lhs: T, _ rhs: T, _ product: DoubleIntLayout<T>, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(T.multiplying(lhs, by: rhs), (product), file: file, line: line)
        //=--------------------------------------=
        Test.multiplicationAsSomeBinaryInteger(lhs, rhs, T(bitPattern: product.low), overflow, file: file, line: line)
    }
    
    public static func multiplicationAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ error: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        let result = Fallible(value, error: error)
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(lhs &* rhs, value, file: file, line: line)
            XCTAssertEqual(rhs &* lhs, value, file: file, line: line)
        };  if !error {
            XCTAssertEqual(lhs  * rhs, value, file: file, line: line)
            XCTAssertEqual(rhs  * lhs, value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &*= rhs; return x }(), value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x &*= lhs; return x }(), value, file: file, line: line)
        };  if !error {
            XCTAssertEqual({ var x = lhs; x  *= rhs; return x }(), value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x  *= lhs; return x }(), value, file: file, line: line)
        }
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(result, lhs.times(rhs), file: file, line: line)
            XCTAssertEqual(result, lhs.times(Fallible(rhs)), file: file, line: line)
            XCTAssertEqual(result, Fallible(lhs).times(rhs), file: file, line: line)
            XCTAssertEqual(result, Fallible(lhs).times(Fallible(rhs)), file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(result, rhs.times(lhs), file: file, line: line)
            XCTAssertEqual(result, rhs.times(Fallible(lhs)), file: file, line: line)
            XCTAssertEqual(result, Fallible(rhs).times(lhs), file: file, line: line)
            XCTAssertEqual(result, Fallible(rhs).times(Fallible(lhs)), file: file, line: line)
        }
        //=--------------------------------------=
        if  lhs == rhs {
            XCTAssertEqual(result, rhs.squared(), file: file, line: line)
            XCTAssertEqual(result, Fallible(lhs).squared(), file: file, line: line)
        }
        
        if  lhs == rhs {
            XCTAssertEqual(result, rhs.squared(), file: file, line: line)
            XCTAssertEqual(result, Fallible(rhs).squared(), file: file, line: line)
        }
    }
}
