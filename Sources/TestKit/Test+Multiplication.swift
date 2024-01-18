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
        self.multiplicationAsSomeSystemInteger(lhs, rhs, product, overflow, file: file, line: line)
    }
    
    public static func multiplication<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T,_ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.multiplicationAsSomeBinaryInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    public static func multiplication<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.multiplicationAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    private static func multiplicationAsSomeSystemInteger<T: SystemsInteger>(
    _ lhs: T, _ rhs: T, _ product: Doublet<T>, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(T.multiplying(lhs, by: rhs), (product), file: file, line: line)
        //=--------------------------------------=
        Test.multiplicationAsSomeBinaryInteger(lhs, rhs, T(bitPattern: product.low), overflow, file: file, line: line)
    }
    
    private static func multiplicationAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(lhs &* rhs, value, file: file, line: line)
        XCTAssertEqual(rhs &* lhs, value, file: file, line: line)
        //=--------------------------------------=
        Test.multiplicationAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    private static func multiplicationAsSomeInteger<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
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
            Test.multiplicationBySquareProductAsSomeInteger(lhs, value, overflow, file: file, line: line)
            Test.multiplicationBySquareProductAsSomeInteger(rhs, value, overflow, file: file, line: line)
        }
    }
    
    private static func multiplicationBySquareProductAsSomeInteger<T: Integer>(
    _ instance: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try instance.squared() }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try instance.squared() }).overflow, overflow, file: file, line: line)
    }
}
