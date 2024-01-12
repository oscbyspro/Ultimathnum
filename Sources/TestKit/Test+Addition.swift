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
    
    public static func addition<T: SystemInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.additionAsSomeSystemInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    public static func addition<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.additionAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    private static func additionAsSomeSystemInteger<T: SystemInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(lhs &+ rhs, value, file: file, line: line)
        XCTAssertEqual(rhs &+ lhs, value, file: file, line: line)
        //=--------------------------------------=
        Test.additionAsSomeInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    private static func additionAsSomeInteger<T: Integer>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        if !overflow {
            XCTAssertEqual(lhs + rhs, value, file: file, line: line)
            XCTAssertEqual(rhs + lhs, value, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try lhs.plus(rhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try lhs.plus(rhs) }).overflow, overflow, file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try rhs.plus(lhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try rhs.plus(lhs) }).overflow, overflow, file: file, line: line)
    }
}
