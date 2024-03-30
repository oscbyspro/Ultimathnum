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
    
    public static func multiplication<T>(
        _ lhs: T, 
        _ rhs: T,
        _ expectation: Fallible<DoubleIntLayout<T>>,
        file: StaticString = #file,
        line: UInt = #line
    )   where T: SystemsInteger {
        self.multiplicationAsSomeSystemsInteger(lhs, rhs, expectation, file: file, line: line)
    }
    
    public static func multiplication<T>(
        _ lhs: T, 
        _ rhs: T,
        _ expectation: Fallible<T>,
        file: StaticString = #file,
        line: UInt = #line
    )   where T: BinaryInteger {
        self.multiplicationAsSomeBinaryInteger(lhs, rhs, expectation, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func multiplicationAsSomeSystemsInteger<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: Fallible<DoubleIntLayout<T>>,
        file: StaticString,
        line: UInt
    )   where T: SystemsInteger {
        //=--------------------------------------=
        XCTAssertEqual(T.multiplying(lhs, by: rhs), expectation.value, file: file, line: line)
        //=--------------------------------------=
        Test.multiplicationAsSomeBinaryInteger(
            lhs,
            rhs,
            expectation.map(\.low).map(T.init(bitPattern:)),
            file: file,
            line: line
        )
    }
    
    public static func multiplicationAsSomeBinaryInteger<T>(
        _ lhs: T, 
        _ rhs: T, 
        _ expectation: Fallible<T>,
        file: StaticString,
        line: UInt
    )   where T: BinaryInteger {
        brr: do {
            XCTAssertEqual(lhs &* rhs, expectation.value, file: file, line: line)
            XCTAssertEqual(rhs &* lhs, expectation.value, file: file, line: line)
        };  if !expectation.error {
            XCTAssertEqual(lhs  * rhs, expectation.value, file: file, line: line)
            XCTAssertEqual(rhs  * lhs, expectation.value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &*= rhs; return x }(), expectation.value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x &*= lhs; return x }(), expectation.value, file: file, line: line)
        };  if !expectation.error {
            XCTAssertEqual({ var x = lhs; x  *= rhs; return x }(), expectation.value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x  *= lhs; return x }(), expectation.value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(lhs.times(rhs),                     expectation, file: file, line: line)
            XCTAssertEqual(lhs.times(Fallible(rhs)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).times(rhs),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).times(Fallible(rhs)), expectation, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(rhs.times(lhs),                     expectation, file: file, line: line)
            XCTAssertEqual(rhs.times(Fallible(lhs)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).times(lhs),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).times(Fallible(lhs)), expectation, file: file, line: line)
        }
        
        if  lhs == rhs {
            XCTAssertEqual(rhs.squared(),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).squared(), expectation, file: file, line: line)
        }
        
        if  lhs == rhs {
            XCTAssertEqual(rhs.squared(),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).squared(), expectation, file: file, line: line)
        }
    }
}
