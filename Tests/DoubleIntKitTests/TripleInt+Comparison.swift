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

extension TripleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias C = Case<B>
            //=----------------------------------=
            let a1 =  T(low:  1, mid:  1, high:  1)
            let b1 =  T(low: ~1, mid: ~1, high: ~1)
            //=----------------------------------=
            C(T(low:  0, mid:  0, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  1, mid:  0, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  2, mid:  0, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  0, mid:  1, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  1, mid:  1, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  2, mid:  1, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  0, mid:  2, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  1, mid:  2, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  2, mid:  2, high:  0)).compared(to: a1, is: -1 as Signum)
            C(T(low:  0, mid:  0, high:  1)).compared(to: a1, is: -1 as Signum)
            C(T(low:  1, mid:  0, high:  1)).compared(to: a1, is: -1 as Signum)
            C(T(low:  2, mid:  0, high:  1)).compared(to: a1, is: -1 as Signum)
            C(T(low:  0, mid:  1, high:  1)).compared(to: a1, is: -1 as Signum)
            C(T(low:  1, mid:  1, high:  1)).compared(to: a1, is:  0 as Signum)
            C(T(low:  2, mid:  1, high:  1)).compared(to: a1, is:  1 as Signum)
            C(T(low:  0, mid:  2, high:  1)).compared(to: a1, is:  1 as Signum)
            C(T(low:  1, mid:  2, high:  1)).compared(to: a1, is:  1 as Signum)
            C(T(low:  2, mid:  2, high:  1)).compared(to: a1, is:  1 as Signum)
            C(T(low:  0, mid:  0, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  1, mid:  0, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  2, mid:  0, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  0, mid:  1, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  1, mid:  1, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  2, mid:  1, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  0, mid:  2, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  1, mid:  2, high:  2)).compared(to: a1, is:  1 as Signum)
            C(T(low:  2, mid:  2, high:  2)).compared(to: a1, is:  1 as Signum)
            //=----------------------------------=
            C(T(low:  0, mid:  0, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  0, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  0, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  1, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  1, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  1, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  2, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  2, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  2, high:  0)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  0, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  0, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  0, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  1, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  1, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  1, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  2, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  2, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  2, high:  1)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  0, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  0, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  0, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  1, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  1, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  1, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  0, mid:  2, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  1, mid:  2, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            C(T(low:  2, mid:  2, high:  2)).compared(to: b1, is: -Signum(Sign(B.isSigned)))
            //=----------------------------------=
            C(T(low: ~0, mid: ~0, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~0, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~0, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~1, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~1, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~1, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~2, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~2, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~2, high: ~0)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~0, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~0, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~0, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~1, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~1, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~1, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~2, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~2, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~2, high: ~1)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~0, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~0, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~0, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~1, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~1, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~1, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~0, mid: ~2, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~1, mid: ~2, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            C(T(low: ~2, mid: ~2, high: ~2)).compared(to: a1, is:  Signum(Sign(B.isSigned)))
            //=----------------------------------=
            C(T(low: ~0, mid: ~0, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~1, mid: ~0, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~2, mid: ~0, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~0, mid: ~1, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~1, mid: ~1, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~2, mid: ~1, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~0, mid: ~2, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~1, mid: ~2, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~2, mid: ~2, high: ~0)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~0, mid: ~0, high: ~1)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~1, mid: ~0, high: ~1)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~2, mid: ~0, high: ~1)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~0, mid: ~1, high: ~1)).compared(to: b1, is:  1 as Signum)
            C(T(low: ~1, mid: ~1, high: ~1)).compared(to: b1, is:  0 as Signum)
            C(T(low: ~2, mid: ~1, high: ~1)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~0, mid: ~2, high: ~1)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~1, mid: ~2, high: ~1)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~2, mid: ~2, high: ~1)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~0, mid: ~0, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~1, mid: ~0, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~2, mid: ~0, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~0, mid: ~1, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~1, mid: ~1, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~2, mid: ~1, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~0, mid: ~2, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~1, mid: ~2, high: ~2)).compared(to: b1, is: -1 as Signum)
            C(T(low: ~2, mid: ~2, high: ~2)).compared(to: b1, is: -1 as Signum)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension TripleIntTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func compared(to other: Item, is expectation: Signum) {
        test.same(item .compared(to: other), expectation)
        test.same(other.compared(to: item ), expectation.negated())
        test.comparison(item, other, expectation, id: ComparableID())
        test.same(item.hashValue == other.hashValue, expectation.isZero)
    }
}
