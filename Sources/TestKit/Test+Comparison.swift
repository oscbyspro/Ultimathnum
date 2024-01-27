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
// MARK: * Test x Comparison
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func comparison<T: BinaryInteger, U: BinaryInteger>(
    _ lhs: T, _ rhs: U, _ expectation: Signum,
    file: StaticString = #file, line: UInt = #line) {
        self.comparisonAsSomeBinaryInteger(lhs, rhs, expectation, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func comparisonAsSomeBinaryInteger<T: BinaryInteger, U: BinaryInteger>(
    _   lhs: T, _ rhs: U, _ expectation: Signum, file: StaticString, line: UInt) {
        //=--------------------------------------=
        Test.comparisonAsSomeExchangeInt(lhs.elements, rhs.elements, expectation, file: file, line: line)
        //=--------------------------------------=
        guard let rhs = rhs as? T else { return }
        //=--------------------------------------=
        for (lhs, rhs, expectation) in [(lhs, rhs, expectation), (rhs, lhs, expectation.negated())] {
            signum: if rhs.signum() == Signum.same {
                let result:  Signum = lhs.signum()
                let success: Bool = result == expectation
                XCTAssert(success, "\(lhs).signum() -> \(result)", file: file, line: line)
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                XCTAssert(success, "\(lhs).compared(to: \(rhs)) -> \(result)", file: file, line: line)
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
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                XCTAssert(success, "\(lhs) != \(rhs) -> \(result)", file: file, line: line)
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                XCTAssert(success, "\(lhs) <= \(rhs) -> \(result)", file: file, line: line)
            }
        }
    }
    
    public static func comparisonAsSomeExchangeInt<A, B, C, D>(
    _   lhs: ExchangeInt<A, B>, _ rhs: ExchangeInt<C, D>, _ expectation: Signum, file: StaticString, line: UInt) {
        func unidirectional<E, F, G, H>(_ lhs: ExchangeInt<E, F>, _ rhs: ExchangeInt<G, H>, _ expectation: Signum) {
            signum: if rhs.signum() == Signum.same {
                let result:  Signum = lhs.signum()
                let success: Bool = result == expectation
                XCTAssert(success, "\(lhs).signum() -> \(result)", file: file, line: line)
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                XCTAssert(success, "\(lhs).compared(to: \(rhs)) -> \(result)", file: file, line: line)
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
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                XCTAssert(success, "\(lhs) != \(rhs) -> \(result)", file: file, line: line)
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                XCTAssert(success, "\(lhs) <= \(rhs) -> \(result)", file: file, line: line)
            }
        }
        
        unidirectional(lhs, rhs, expectation)
        unidirectional(rhs, lhs, expectation.negated())
    }
}
