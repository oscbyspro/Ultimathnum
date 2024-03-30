//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
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
        typealias D = Division<X, UX>
        typealias F = Fallible<D>
        
        checkDivisionManyBySome([ ] as X, 1 as UX, F(D(quotient: [ ] as X, remainder: 0 as UX)))
        checkDivisionManyBySome([ ] as X, 2 as UX, F(D(quotient: [ ] as X, remainder: 0 as UX)))
        checkDivisionManyBySome([0] as X, 1 as UX, F(D(quotient: [0] as X, remainder: 0 as UX)))
        checkDivisionManyBySome([0] as X, 2 as UX, F(D(quotient: [0] as X, remainder: 0 as UX)))
        checkDivisionManyBySome([7] as X, 1 as UX, F(D(quotient: [7] as X, remainder: 0 as UX)))
        checkDivisionManyBySome([7] as X, 2 as UX, F(D(quotient: [3] as X, remainder: 1 as UX)))
        
        checkDivisionManyBySome([ ] as X, 0 as UX, F(D(quotient: [ ] as X, remainder: 0 as UX), error: true))
        checkDivisionManyBySome([0] as X, 0 as UX, F(D(quotient: [0] as X, remainder: 0 as UX), error: true))
        checkDivisionManyBySome([1] as X, 0 as UX, F(D(quotient: [1] as X, remainder: 1 as UX), error: true))
        checkDivisionManyBySome([2] as X, 0 as UX, F(D(quotient: [2] as X, remainder: 2 as UX), error: true))
    }
    
    func testDivisionManyBySome() {
        typealias D = Division<X, UX>
        typealias F = Fallible<D>
        
        checkDivisionManyBySome([~2,  ~4,  ~6,   9] as X, 2 as UX, F(D(quotient: [~1, ~2, ~3,  4] as X, remainder: 1 as UX)))
        checkDivisionManyBySome([~3,  ~6,  ~9,  14] as X, 3 as UX, F(D(quotient: [~1, ~2, ~3,  4] as X, remainder: 2 as UX)))
        checkDivisionManyBySome([~4,  ~8, ~12,  19] as X, 4 as UX, F(D(quotient: [~1, ~2, ~3,  4] as X, remainder: 3 as UX)))
        checkDivisionManyBySome([~5, ~10, ~15,  24] as X, 5 as UX, F(D(quotient: [~1, ~2, ~3,  4] as X, remainder: 4 as UX)))
        
        checkDivisionManyBySome([ 1,   2,   3,   4] as X, 0 as UX, F(D(quotient: [ 1,  2,  3,  4] as X, remainder: 1 as UX), error: true))
        checkDivisionManyBySome([ 4,   3,   2,   1] as X, 0 as UX, F(D(quotient: [ 4,  3,  2,  1] as X, remainder: 4 as UX), error: true))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func checkDivisionManyBySome<Element>(
        _ dividend: [Element], 
        _ divisor: Element,
        _ expectation: Fallible<Division<[Element], Element>>,
        _ test: Test = .init()
    )   where Element: SystemsInteger & UnsignedInteger {
        
        if  divisor != 0 {
            let o = SUISS.remainder(dividing: dividend, by: divisor)
            test.same(o, expectation.value.remainder)
        }
        
        if  divisor != 0 {
            var i = dividend
            let o = SUISS.formQuotientWithRemainder(dividing: &i, by: divisor)
            test.same(Division(quotient: i, remainder: o), expectation.value)
        }
        
        brr: do {
            let o = SUISS.remainderReportingOverflow(dividing: dividend, by: divisor)
            test.same(Fallible(o.partialValue, error: o.overflow), expectation.map(\.remainder))
        }
        
        brr: do {
            var i = dividend
            let o = SUISS.formQuotientWithRemainderReportingOverflow(dividing: &i, by: divisor)
            test.same(Fallible(Division(quotient: i, remainder: o.partialValue), error: o.overflow), expectation)
        }
    }
}
