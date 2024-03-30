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
    
    public static func addition<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: Fallible<T>,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        brr: do {
            XCTAssertEqual(lhs &+ rhs, expectation.value, file: file, line: line)
            XCTAssertEqual(rhs &+ lhs, expectation.value, file: file, line: line)
        };  if !expectation.error {
            XCTAssertEqual(lhs  + rhs, expectation.value, file: file, line: line)
            XCTAssertEqual(rhs  + lhs, expectation.value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &+= rhs; return x }(), expectation.value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x &+= lhs; return x }(), expectation.value, file: file, line: line)
        };  if !expectation.error {
            XCTAssertEqual({ var x = lhs; x  += rhs; return x }(), expectation.value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x  += lhs; return x }(), expectation.value, file: file, line: line)
        }
        
        if  rhs == T.exactly(1).optional() {
            Test.incrementation(lhs, expectation, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(lhs.plus(rhs),                     expectation, file: file, line: line)
            XCTAssertEqual(lhs.plus(Fallible(rhs)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).plus(rhs),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(lhs).plus(Fallible(rhs)), expectation, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(rhs.plus(lhs),                     expectation, file: file, line: line)
            XCTAssertEqual(rhs.plus(Fallible(lhs)),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).plus(lhs),           expectation, file: file, line: line)
            XCTAssertEqual(Fallible(rhs).plus(Fallible(lhs)), expectation, file: file, line: line)
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
    
    public static func incrementation<T>(
        _ instance: T, 
        _ expectation: Fallible<T>,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        XCTAssertEqual(instance.incremented(),           expectation, file: file, line: line)
        XCTAssertEqual(Fallible(instance).incremented(), expectation, file: file, line: line)
    }
}
