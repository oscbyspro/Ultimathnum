//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Strict Unsigned Integer x Sub Sequence x Division
//*============================================================================*

final class StrictUnsignedIntegerSubSequenceTestsOnDivision: XCTestCase {
    
    typealias X   = [UX]
    typealias X64 = [U64]
    typealias X32 = [U32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivisionSomeBySome() {
        checkDivisionManyBySome([ ] as X, 1 as UX, [ ] as X, 0 as UX)
        checkDivisionManyBySome([ ] as X, 2 as UX, [ ] as X, 0 as UX)
        checkDivisionManyBySome([0] as X, 1 as UX, [0] as X, 0 as UX)
        checkDivisionManyBySome([0] as X, 2 as UX, [0] as X, 0 as UX)
        checkDivisionManyBySome([7] as X, 1 as UX, [7] as X, 0 as UX)
        checkDivisionManyBySome([7] as X, 2 as UX, [3] as X, 1 as UX)
        
        checkDivisionManyBySome([ ] as X, 0 as UX, [ ] as X, 0 as UX, true)
        checkDivisionManyBySome([0] as X, 0 as UX, [0] as X, 0 as UX, true)
        checkDivisionManyBySome([1] as X, 0 as UX, [1] as X, 1 as UX, true)
        checkDivisionManyBySome([2] as X, 0 as UX, [2] as X, 2 as UX, true)
    }
    
    func testDivisionManyBySome() {
        checkDivisionManyBySome([~2,  ~4,  ~6,   9] as X, 2 as UX, [~1, ~2, ~3,  4] as X, 1 as UX)
        checkDivisionManyBySome([~3,  ~6,  ~9,  14] as X, 3 as UX, [~1, ~2, ~3,  4] as X, 2 as UX)
        checkDivisionManyBySome([~4,  ~8, ~12,  19] as X, 4 as UX, [~1, ~2, ~3,  4] as X, 3 as UX)
        checkDivisionManyBySome([~5, ~10, ~15,  24] as X, 5 as UX, [~1, ~2, ~3,  4] as X, 4 as UX)
        
        checkDivisionManyBySome([ 1,   2,   3,   4] as X, 0 as UX, [ 1,  2,  3,  4] as X, 1 as UX, true)
        checkDivisionManyBySome([ 4,   3,   2,   1] as X, 0 as UX, [ 4,  3,  2,  1] as X, 4 as UX, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func checkDivisionManyBySome<Element: SystemInteger & UnsignedInteger>(
    _ dividend: [Element], _ divisor: Element, _ quotient: [Element], _ remainder: Element, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        if  divisor   != 0 {
            let rem = SUISS.remainder(dividing: dividend, by: divisor)
            XCTAssertEqual(rem, remainder, file: file, line: line)
        }
        
        if  divisor   != 0 {
            var lhs = dividend
            let rem = SUISS.formQuotientWithRemainder(dividing:  &lhs, by: divisor)
            XCTAssertEqual(lhs, quotient,  file: file, line: line)
            XCTAssertEqual(rem, remainder, file: file, line: line)
        }
        
        brr: do {
            let pvo = SUISS.remainderReportingOverflow(dividing:  dividend,  by: divisor)
            XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
            XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
        }
        
        brr: do {
            var lhs = dividend
            let pvo = SUISS.formQuotientWithRemainderReportingOverflow(dividing: &lhs, by: divisor)
            XCTAssertEqual(lhs,              quotient,  file: file, line: line)
            XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
            XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
        }
    }
}
