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
// MARK: * Test x Division
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func division<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T, _ error: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        let expectation = Division(quotient: quotient, remainder: remainder)
        self.divisionAsSomeInteger(dividend, divisor, expectation, error, file: file, line: line)
    }
    
    public static func division<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ expectation: Division<T, T>, _ error: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.divisionAsSomeInteger(dividend, divisor, expectation, error, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliites
    //=------------------------------------------------------------------------=
    
    public static func divisionAsSomeInteger<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ value: Division<T, T>, _ error: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        let result = Fallible(value, error: error)
        //=--------------------------------------=
        checkSameSizeInverseInvariant: do {
            let lhs = value.remainder.plus(value.quotient.times(divisor)).combine(error)
            let rhs = Fallible(dividend, error: error)
            XCTAssertEqual(lhs, rhs, "dividend != divisor &* quotient &+ remainder", file: file, line: line)
        }
        
        if !error {
            XCTAssertEqual(dividend / divisor, value.quotient,  file: file, line: line)
            XCTAssertEqual(dividend % divisor, value.remainder, file: file, line: line)
        }
        
        if !error {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), value.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), value.remainder, file: file, line: line)
        }
        
        if !error {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), value.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), value.remainder, file: file, line: line)
        }
        
        quotient: do {
            XCTAssertEqual(result.map(\.quotient), dividend.quotient(divisor), file: file, line: line)
            XCTAssertEqual(result.map(\.quotient), dividend.quotient(Fallible(divisor)), file: file, line: line)
            XCTAssertEqual(result.map(\.quotient), Fallible(dividend).quotient(divisor), file: file, line: line)
            XCTAssertEqual(result.map(\.quotient), Fallible(dividend).quotient(Fallible(divisor)), file: file, line: line)
        }
        
        remainder: do {
            XCTAssertEqual(result.map(\.remainder), dividend.remainder(divisor), file: file, line: line)
            XCTAssertEqual(result.map(\.remainder), dividend.remainder(Fallible(divisor)), file: file, line: line)
            XCTAssertEqual(result.map(\.remainder), Fallible(dividend).remainder(divisor), file: file, line: line)
            XCTAssertEqual(result.map(\.remainder), Fallible(dividend).remainder(Fallible(divisor)), file: file, line: line)
        }
        
        division: do {
            XCTAssertEqual(result, dividend.division(divisor), file: file, line: line)
            XCTAssertEqual(result, dividend.division(Fallible(divisor)), file: file, line: line)
            XCTAssertEqual(result, Fallible(dividend).division(divisor), file: file, line: line)
            XCTAssertEqual(result, Fallible(dividend).division(Fallible(divisor)), file: file, line: line)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + 2 vs 1
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func division2111<T: SystemsInteger>(
    _ dividend: DoubleIntLayout<T>, _ divisor: T, _ value: Division<T, T>, _ error: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        typealias M = T.Magnitude
        //=--------------------------------------=
        let result = T.dividing(dividend, by: divisor)
        //=--------------------------------------=
        // TODO: DoubleIntLayout plus(_:) minus(_:)
        //=--------------------------------------=
        if !error {
            // TODO: reverse engineer the dividend
        }
        //=--------------------------------------=
        XCTAssertEqual(result.value, value, file: file, line: line)
        XCTAssertEqual(result.error, error, file: file, line: line)
    }
}
