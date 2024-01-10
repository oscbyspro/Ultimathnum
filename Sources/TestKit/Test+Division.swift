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
// MARK: * Test x Division
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func division<T: Integer>(
    _ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.divisionAsSomeInteger(dividend, divisor, quotient, remainder, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliites x Private
    //=------------------------------------------------------------------------=
    
    private static func divisionAsSomeInteger<T: Integer>(
    _ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        let expectation = Division(quotient: quotient,remainder: remainder)
        //=--------------------------------------=
        if !overflow {
            XCTAssertEqual(dividend / divisor, quotient,  file: file, line: line)
            XCTAssertEqual(dividend % divisor, remainder, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try dividend.quotient (divisor: divisor) }).value,    quotient,  file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try dividend.quotient (divisor: divisor) }).overflow, overflow,  file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try dividend.remainder(divisor: divisor) }).value,    remainder, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try dividend.remainder(divisor: divisor) }).overflow, overflow,  file: file, line: line)
        
        XCTAssertEqual(Overflow.capture({ try dividend.divided(by: divisor) }).value,    expectation, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try dividend.divided(by: divisor) }).overflow, overflow,    file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + 2 by 1
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func division<T: SystemInteger>(
    _ dividend: Doublet<T>, _ divisor: T, _ quotient: T, _ remainder: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.divisionAsSomeSystemInteger(dividend, divisor, quotient, remainder, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliites x Private
    //=------------------------------------------------------------------------=
    
    private static func divisionAsSomeSystemInteger<T: SystemInteger>(
    _ dividend: Doublet<T>, _ divisor: T, _ quotient: T, _ remainder: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        let expectation = Division(quotient: quotient, remainder: remainder)
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try T.dividing(dividend, by: divisor) }).value,    expectation, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try T.dividing(dividend, by: divisor) }).overflow, overflow,    file: file, line: line)
    }
}
