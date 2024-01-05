//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit
import XCTest

//*============================================================================*
// MARK: * Test x Comparison
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func comparison<T: Integer>(_ lhs: T, _ rhs: T, _ expectation: Signum, file: StaticString = #file, line: UInt = #line) {
        self.comparisonAsSomeInteger(lhs, rhs, expectation, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    private static func comparisonAsSomeInteger<T: Integer>(_ lhs: T, _ rhs: T, _ expectation: Signum, file: StaticString = #file, line: UInt = #line) {
        for (lhs,  rhs, expectation) in [(lhs, rhs, expectation), (rhs, lhs, expectation.negated())] {
            signum: do {
                let result:  Signum = lhs.compared(to:  rhs)
                let success: Bool = result == expectation
                XCTAssert(success, "\(lhs).compared(to: \(rhs) -> \(result)", file: file, line: line)
            }
            
            less: do {
                let result:  Bool = lhs < rhs
                let success: Bool = result == (expectation == .less)
                XCTAssert(success, "\(lhs) <  \(rhs) -> \(result)", file: file, line: line)
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                XCTAssert(success, "\(lhs) == \(rhs) -> \(result)", file: file, line: line)
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                XCTAssert(success, "\(lhs) >  \(rhs) -> \(result)", file: file, line: line)
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                XCTAssert(success, "\(lhs) >= \(rhs) -> \(result)", file: file, line: line)
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                XCTAssert(success, "\(lhs) <= \(rhs) -> \(result)", file: file, line: line)
            }
        }
    }
}
