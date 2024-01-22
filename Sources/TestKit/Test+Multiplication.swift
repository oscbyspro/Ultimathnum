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
// MARK: * Test x Multiplication
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func multiplication<T: SystemsInteger>(
    _ lhs: T, _ rhs: T, _ product: Doublet<T>,_ overflow: Bool = false,
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
    _ lhs: T, _ rhs: T, _ product: Doublet<T>, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(T.multiplying(lhs, by: rhs), (product), file: file, line: line)
        //=--------------------------------------=
        Test.multiplicationAsSomeBinaryInteger(lhs, rhs, T(bitPattern: product.low), overflow, file: file, line: line)
    }
    
    public static func multiplicationAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(lhs &* rhs, value, file: file, line: line)
        XCTAssertEqual(rhs &* lhs, value, file: file, line: line)
        //=--------------------------------------=
        if !overflow {
            XCTAssertEqual(lhs * rhs, value, file: file, line: line)
            XCTAssertEqual(rhs * lhs, value, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try lhs.times(rhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try lhs.times(rhs) }).overflow, overflow, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try rhs.times(lhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try rhs.times(lhs) }).overflow, overflow, file: file, line: line)
        //=--------------------------------------=
        if  lhs == rhs {
            XCTAssertEqual(Overflow.capture({ try lhs.squared() }).value,    value,    file: file, line: line)
            XCTAssertEqual(Overflow.capture({ try lhs.squared() }).overflow, overflow, file: file, line: line)
            XCTAssertEqual(Overflow.capture({ try rhs.squared() }).value,    value,    file: file, line: line)
            XCTAssertEqual(Overflow.capture({ try rhs.squared() }).overflow, overflow, file: file, line: line)
        }
    }
}
