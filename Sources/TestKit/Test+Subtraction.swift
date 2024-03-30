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
    
    public static func subtraction<T>(
        _ lhs: T, 
        _ rhs: T,
        _ expectation: Fallible<T>,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        brr: do {
            XCTAssertEqual(lhs &- rhs, expectation.value, file: file, line: line)
        };  if !expectation.error {
            XCTAssertEqual(lhs  - rhs, expectation.value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &-= rhs; return x }(), expectation.value, file: file, line: line)
        };  if !expectation.error {
            XCTAssertEqual({ var x = lhs; x  -= rhs; return x }(), expectation.value, file: file, line: line)
        }
        
        if !expectation.error {
            let abc: T = rhs.minus(lhs).value.negated().value
            let xyz: T = lhs.minus(rhs).value
            XCTAssertEqual(abc, xyz, "binary integer subtraction must be reversible", file: file, line: line)
        }   else {
            let abc: T = rhs.minus(lhs).value
            let xyz: T = lhs.minus(rhs).value.negated().value
            XCTAssertEqual(abc, xyz, "binary integer subtraction must be reversible", file: file, line: line)
        }
        
        if  let one = T.exactly(1).optional(), rhs == one {
            Test.decrementation(lhs, expectation, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(lhs.minus(rhs),                     expectation, file: file, line: line)
            XCTAssertEqual(lhs.minus(Fallible(rhs)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).minus(rhs),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).minus(Fallible(rhs)), expectation, file: file, line: line)
        }
        
        if  !expectation.error {
            let expectation = expectation.negated()
            XCTAssertEqual(rhs.minus(lhs),                     expectation, file: file, line: line)
            XCTAssertEqual(rhs.minus(Fallible(lhs)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).minus(lhs),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).minus(Fallible(lhs)), expectation, file: file, line: line)
        }
        //=--------------------------------------=
        // same as rhs negation when lhs is zero
        //=--------------------------------------=
        if  lhs == 0 {
            XCTAssertEqual(expectation, rhs.negated(),           file: file, line: line)
            XCTAssertEqual(expectation, Fallible(rhs).negated(), file: file, line: line)
        }
        
        if  lhs == 0 && !expectation.error {
            XCTAssertEqual(-rhs, expectation.value, file: file, line: line)
            XCTAssertEqual(-expectation.value, rhs, file: file, line: line)
        }
        
        if  lhs == 0 && !expectation.error {
            XCTAssertEqual(Fallible(rhs), expectation.value.negated(),           file: file, line: line)
            XCTAssertEqual(Fallible(rhs), Fallible(expectation.value).negated(), file: file, line: line)
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
    
    public static func decrementation<T>(
        _ instance: T,
        _ expectation: Fallible<T>,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        XCTAssertEqual(instance.decremented(),           expectation, file: file, line: line)
        XCTAssertEqual(Fallible(instance).decremented(), expectation, file: file, line: line)
    }
}
