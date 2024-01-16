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
// MARK: * Test x Logic
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func not<T: BitInvertible & Equatable>(
    _ instance: T, _ value: T,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        XCTAssertEqual(~instance, value, file: file, line: line)
        XCTAssertEqual(~value, instance, file: file, line: line)
    }
    
    public static func and<T: BitOperable & Equatable>(
    _ lhs: T, _ rhs: T, _ value: T,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        XCTAssertEqual(lhs & rhs, value, file: file, line: line)
        XCTAssertEqual(rhs & lhs, value, file: file, line: line)
    }
    
    public static func or<T: BitOperable & Equatable>(
    _ lhs: T, _ rhs: T, _ value: T,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        XCTAssertEqual(lhs | rhs, value, file: file, line: line)
        XCTAssertEqual(rhs | lhs, value, file: file, line: line)
    }
    
    public static func xor<T: BitOperable & Equatable>(
    _ lhs: T, _ rhs: T, _ value: T,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        XCTAssertEqual(lhs ^ rhs, value, file: file, line: line)
        XCTAssertEqual(rhs ^ lhs, value, file: file, line: line)
    }
}
