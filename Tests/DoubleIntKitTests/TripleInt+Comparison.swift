//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Triple Int x Comparison
//*============================================================================*

final class TripleIntTestsOnComparison: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereTheBaseIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            //=----------------------------------=
            let a1 =  T(low:  1, mid:  1, high:  1)
            let b1 =  T(low: ~1, mid: ~1, high: ~1)
            //=----------------------------------=
            Test().comparison(T(low:  0, mid:  0, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  1, mid:  0, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  2, mid:  0, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  0, mid:  1, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  1, mid:  1, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  2, mid:  1, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  0, mid:  2, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  1, mid:  2, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  2, mid:  2, high:  0), a1,  Signum.negative)
            Test().comparison(T(low:  0, mid:  0, high:  1), a1,  Signum.negative)
            Test().comparison(T(low:  1, mid:  0, high:  1), a1,  Signum.negative)
            Test().comparison(T(low:  2, mid:  0, high:  1), a1,  Signum.negative)
            Test().comparison(T(low:  0, mid:  1, high:  1), a1,  Signum.negative)
            Test().comparison(T(low:  1, mid:  1, high:  1), a1,  Signum.zero)
            Test().comparison(T(low:  2, mid:  1, high:  1), a1,  Signum.positive)
            Test().comparison(T(low:  0, mid:  2, high:  1), a1,  Signum.positive)
            Test().comparison(T(low:  1, mid:  2, high:  1), a1,  Signum.positive)
            Test().comparison(T(low:  2, mid:  2, high:  1), a1,  Signum.positive)
            Test().comparison(T(low:  0, mid:  0, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  1, mid:  0, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  2, mid:  0, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  0, mid:  1, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  1, mid:  1, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  2, mid:  1, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  0, mid:  2, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  1, mid:  2, high:  2), a1,  Signum.positive)
            Test().comparison(T(low:  2, mid:  2, high:  2), a1,  Signum.positive)
            //=----------------------------------=
            Test().comparison(T(low:  0, mid:  0, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  0, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  0, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  1, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  1, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  1, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  2, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  2, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  2, high:  0), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  0, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  0, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  0, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  1, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  1, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  1, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  2, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  2, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  2, high:  1), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  0, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  0, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  0, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  1, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  1, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  1, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  0, mid:  2, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  1, mid:  2, high:  2), b1, -Signum(Sign(B.isSigned)))
            Test().comparison(T(low:  2, mid:  2, high:  2), b1, -Signum(Sign(B.isSigned)))
            //=----------------------------------=
            Test().comparison(T(low: ~0, mid: ~0, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~0, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~0, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~1, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~1, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~1, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~2, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~2, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~2, high: ~0), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~0, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~0, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~0, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~1, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~1, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~1, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~2, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~2, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~2, high: ~1), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~0, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~0, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~0, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~1, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~1, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~1, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~0, mid: ~2, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~1, mid: ~2, high: ~2), a1,  Signum(Sign(B.isSigned)))
            Test().comparison(T(low: ~2, mid: ~2, high: ~2), a1,  Signum(Sign(B.isSigned)))
            //=----------------------------------=
            Test().comparison(T(low: ~0, mid: ~0, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~1, mid: ~0, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~2, mid: ~0, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~0, mid: ~1, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~1, mid: ~1, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~2, mid: ~1, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~0, mid: ~2, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~1, mid: ~2, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~2, mid: ~2, high: ~0), b1,  Signum.positive)
            Test().comparison(T(low: ~0, mid: ~0, high: ~1), b1,  Signum.positive)
            Test().comparison(T(low: ~1, mid: ~0, high: ~1), b1,  Signum.positive)
            Test().comparison(T(low: ~2, mid: ~0, high: ~1), b1,  Signum.positive)
            Test().comparison(T(low: ~0, mid: ~1, high: ~1), b1,  Signum.positive)
            Test().comparison(T(low: ~1, mid: ~1, high: ~1), b1,  Signum.zero)
            Test().comparison(T(low: ~2, mid: ~1, high: ~1), b1,  Signum.negative)
            Test().comparison(T(low: ~0, mid: ~2, high: ~1), b1,  Signum.negative)
            Test().comparison(T(low: ~1, mid: ~2, high: ~1), b1,  Signum.negative)
            Test().comparison(T(low: ~2, mid: ~2, high: ~1), b1,  Signum.negative)
            Test().comparison(T(low: ~0, mid: ~0, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~1, mid: ~0, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~2, mid: ~0, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~0, mid: ~1, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~1, mid: ~1, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~2, mid: ~1, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~0, mid: ~2, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~1, mid: ~2, high: ~2), b1,  Signum.negative)
            Test().comparison(T(low: ~2, mid: ~2, high: ~2), b1,  Signum.negative)
        }
        
        for base in TripleIntTests.bases {
            whereTheBaseIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

private extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func comparison<B>(_ lhs: TripleInt<B>, _ rhs: TripleInt<B>, _ expectation: Signum) {
        same(lhs.compared(to: rhs), expectation)
        same(rhs.compared(to: lhs), expectation.negated())
        comparison(lhs, rhs, expectation, id: ComparableID())
    }
}
