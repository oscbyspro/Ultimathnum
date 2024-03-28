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
    _ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T,
    file: StaticString = #file, line: UInt = #line) {
        let expectation = Division(quotient: quotient, remainder: remainder)
        self.divisionAsSomeInteger(dividend, divisor, expectation, file: file, line: line)
    }
    
    #warning("remove")
    public static func division<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ expectation: Division<T, T>?,
    file: StaticString = #file, line: UInt = #line) {
        self.divisionAsSomeInteger(dividend, divisor, expectation, file: file, line: line)
    }    
    
    #warning("remove")
    public static func division<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ expectation: Division<T, T>, _ error: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.divisionAsSomeInteger(dividend, divisor, expectation, error, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliites
    //=------------------------------------------------------------------------=
    
    #warning("remove")
    public static func divisionAsSomeInteger<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ expectation: Division<T, T>?, file: StaticString, line: UInt) {
        //=--------------------------------------=
        if  let expectation {
            XCTAssertEqual(dividend, divisor * expectation.quotient + expectation.remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
        }
        
        if  let expectation {
            XCTAssertEqual(dividend / divisor, expectation.quotient,  file: file, line: line)
            XCTAssertEqual(dividend % divisor, expectation.remainder, file: file, line: line)
        }
        
        if  let expectation {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), expectation.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), expectation.remainder, file: file, line: line)
        }
        
        if  let expectation {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), expectation.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), expectation.remainder, file: file, line: line)
        }
        
        brr: do {
            #warning("perform nonoptional comparisons")
            XCTAssertEqual(dividend.quotient (divisor: divisor).optional(), expectation?.quotient,  file: file, line: line)
            XCTAssertEqual(dividend.remainder(divisor: divisor).optional(), expectation?.remainder, file: file, line: line)
            XCTAssertEqual(dividend.divided  (by:      divisor).optional(), expectation,            file: file, line: line)
        }
    }
    
    public static func divisionAsSomeInteger<T: BinaryInteger>(
    _ dividend: T, _ divisor: T, _ expectation: Division<T, T>, _ error: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        if !error {
            XCTAssertEqual(dividend, divisor * expectation.quotient + expectation.remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
        }
        
        if !error {
            XCTAssertEqual(dividend / divisor, expectation.quotient,  file: file, line: line)
            XCTAssertEqual(dividend % divisor, expectation.remainder, file: file, line: line)
        }
        
        if !error {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), expectation.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), expectation.remainder, file: file, line: line)
        }
        
        if !error {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), expectation.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), expectation.remainder, file: file, line: line)
        }
        
        brr: do {
            #warning("perform nonoptional comparisons")
            XCTAssertEqual(dividend.quotient (divisor: divisor).value, expectation.quotient,  file: file, line: line)
            XCTAssertEqual(dividend.quotient (divisor: divisor).error, error,                 file: file, line: line)
            XCTAssertEqual(dividend.remainder(divisor: divisor).value, expectation.remainder, file: file, line: line)
            XCTAssertEqual(dividend.remainder(divisor: divisor).error, error,                 file: file, line: line)
            XCTAssertEqual(dividend.divided  (by:      divisor).value, expectation,           file: file, line: line)
            XCTAssertEqual(dividend.divided  (by:      divisor).error, error,                 file: file, line: line)
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
    _ dividend: DoubleIntLayout<T>, _ divisor: T, _ expectation: Division<T, T>?, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        #warning("perform nonoptional comparisons")
        #warning("perform nonoptional comparisons")
        #warning("perform nonoptional comparisons")
        #warning("perform nonoptional comparisons")
        XCTAssertEqual(T.dividing(dividend, by: divisor).optional(), expectation, file: file, line: line)
    }
    
    public static func division2111<T: SystemsInteger>(
    _ dividend: DoubleIntLayout<T>, _ divisor: T, _ expectation: Division<T, T>, _ error: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        let result = T.dividing(dividend, by: divisor)
        //=--------------------------------------=
        XCTAssertEqual(result.value.quotient,  expectation.quotient,  file: file, line: line)
        XCTAssertEqual(result.value.remainder, expectation.remainder, file: file, line: line)
        XCTAssertEqual(result.error,           error,                 file: file, line: line)
    }
}
