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
    
    public static func division<T>(
        _ dividend:  T,
        _ divisor:   T,
        _ quotient:  T,
        _ remainder: T,
        _ error: Bool = false,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        let division = Division(quotient: quotient, remainder: remainder)
        let expectation = Fallible(division, error: error)
        self.division(dividend, divisor, expectation, file: file, line: line)
    }
    
    public static func division<T>(
        _ dividend: T, 
        _ divisor:  T,
        _ expectation: Fallible<Division<T, T>>,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        checkSameSizeInverseInvariant: do {
            let lhs = expectation.map({ $0.remainder.plus($0.quotient.times(divisor)) })
            let rhs = Fallible(dividend, error: expectation.error)
            XCTAssertEqual(lhs, rhs, "dividend != divisor &* quotient &+ remainder", file: file, line: line)
        }
        
        if !expectation.error {
            XCTAssertEqual(dividend / divisor, expectation.value.quotient,  file: file, line: line)
            XCTAssertEqual(dividend % divisor, expectation.value.remainder, file: file, line: line)
        }
        
        if !expectation.error {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), expectation.value.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), expectation.value.remainder, file: file, line: line)
        }
        
        if !expectation.error {
            XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), expectation.value.quotient,  file: file, line: line)
            XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), expectation.value.remainder, file: file, line: line)
        }
        
        quotient: do {
            let expectation = expectation.map(\.quotient)
            XCTAssertEqual(dividend.quotient(divisor),                     expectation, file: file, line: line)
            XCTAssertEqual(dividend.quotient(Fallible(divisor)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(dividend).quotient(divisor),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(dividend).quotient(Fallible(divisor)), expectation, file: file, line: line)
        }
        
        remainder: do {
            let expectation = expectation.map(\.remainder)
            XCTAssertEqual(dividend.remainder(divisor),                     expectation, file: file, line: line)
            XCTAssertEqual(dividend.remainder(Fallible(divisor)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(dividend).remainder(divisor),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(dividend).remainder(Fallible(divisor)), expectation, file: file, line: line)
        }
        
        division: do {
            XCTAssertEqual(dividend.division(divisor),                     expectation, file: file, line: line)
            XCTAssertEqual(dividend.division(Fallible(divisor)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(dividend).division(divisor),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(dividend).division(Fallible(divisor)), expectation, file: file, line: line)
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
    
    public static func division<T>(
        _ dividend: DoubleIntLayout<T>, 
        _ divisor: T,
        _ expectation: Fallible<Division<T, T>>,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: SystemsInteger {
        //=--------------------------------------=
        let result = T.dividing(dividend, by: divisor)
        //=--------------------------------------=
        // TODO: DoubleIntLayout plus(_:) minus(_:)
        //=--------------------------------------=
        if !expectation.error {
            // TODO: reverse engineer the dividend
        }
        //=--------------------------------------=
        XCTAssertEqual(result, expectation, file: file, line: line)
    }
}
