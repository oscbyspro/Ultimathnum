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
// MARK: * Test x Addition
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func addition<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.additionAsSomeBinaryInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func additionAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(lhs &+ rhs, value, file: file, line: line)
            XCTAssertEqual(rhs &+ lhs, value, file: file, line: line)
        };  if !overflow {
            XCTAssertEqual(lhs  + rhs, value, file: file, line: line)
            XCTAssertEqual(rhs  + lhs, value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &+= rhs; return x }(), value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x &+= lhs; return x }(), value, file: file, line: line)
        };  if !overflow {
            XCTAssertEqual({ var x = lhs; x  += rhs; return x }(), value, file: file, line: line)
            XCTAssertEqual({ var x = rhs; x  += lhs; return x }(), value, file: file, line: line)
        }
        //=--------------------------------------=
        if  let one = try? T(literally: 1), rhs == one {
            Test.incrementation(lhs, value, overflow, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try lhs.plus(rhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try lhs.plus(rhs) }).overflow, overflow, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try rhs.plus(lhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try rhs.plus(lhs) }).overflow, overflow, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func incrementation<T: BinaryInteger>(_ instance: T, _ expectation: T, _ overflow: Bool = false, file: StaticString = #file, line: UInt = #line) {
        let result = Overflow.capture({ try instance.incremented() })
        XCTAssertEqual(result.value, expectation, file: file, line: line)
        XCTAssertEqual(result.overflow, overflow, file: file, line: line)
    }
}
