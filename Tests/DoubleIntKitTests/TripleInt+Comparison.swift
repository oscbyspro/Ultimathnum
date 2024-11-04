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
import TestKit2

//*============================================================================*
// MARK: * Triple Int x Comparison
//*============================================================================*

@Suite struct TripleIntTestsOnComparison {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TripleInt: comparison (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.bases
    )   func comparison(base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = TripleInt<B>
            //=----------------------------------=
            let a1 = T(low:  1, mid:  1, high:  1)
            let b1 = T(low: ~1, mid: ~1, high: ~1)
            //=----------------------------------=
            try Ɣrequire(T(low:  0, mid:  0, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  1, mid:  0, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  2, mid:  0, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  0, mid:  1, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  1, mid:  1, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  2, mid:  1, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  0, mid:  2, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  1, mid:  2, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  2, mid:  2, high:  0), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  0, mid:  0, high:  1), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  1, mid:  0, high:  1), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  2, mid:  0, high:  1), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  0, mid:  1, high:  1), equals: a1, is:  Signum.negative)
            try Ɣrequire(T(low:  1, mid:  1, high:  1), equals: a1, is:  Signum.zero)
            try Ɣrequire(T(low:  2, mid:  1, high:  1), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  0, mid:  2, high:  1), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  1, mid:  2, high:  1), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  2, mid:  2, high:  1), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  0, mid:  0, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  1, mid:  0, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  2, mid:  0, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  0, mid:  1, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  1, mid:  1, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  2, mid:  1, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  0, mid:  2, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  1, mid:  2, high:  2), equals: a1, is:  Signum.positive)
            try Ɣrequire(T(low:  2, mid:  2, high:  2), equals: a1, is:  Signum.positive)
            //=----------------------------------=
            try Ɣrequire(T(low:  0, mid:  0, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  0, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  0, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  1, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  1, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  1, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  2, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  2, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  2, high:  0), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  0, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  0, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  0, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  1, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  1, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  1, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  2, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  2, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  2, high:  1), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  0, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  0, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  0, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  1, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  1, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  1, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  0, mid:  2, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  1, mid:  2, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low:  2, mid:  2, high:  2), equals: b1, is: -Signum(Sign(B.isSigned)))
            //=----------------------------------=
            try Ɣrequire(T(low: ~0, mid: ~0, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~0, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~0, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~1, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~1, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~1, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~2, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~2, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~2, high: ~0), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~0, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~0, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~0, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~1, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~1, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~1, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~2, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~2, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~2, high: ~1), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~0, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~0, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~0, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~1, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~1, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~1, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~0, mid: ~2, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~1, mid: ~2, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            try Ɣrequire(T(low: ~2, mid: ~2, high: ~2), equals: a1, is:  Signum(Sign(B.isSigned)))
            //=----------------------------------=
            try Ɣrequire(T(low: ~0, mid: ~0, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~1, mid: ~0, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~2, mid: ~0, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~0, mid: ~1, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~1, mid: ~1, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~2, mid: ~1, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~0, mid: ~2, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~1, mid: ~2, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~2, mid: ~2, high: ~0), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~0, mid: ~0, high: ~1), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~1, mid: ~0, high: ~1), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~2, mid: ~0, high: ~1), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~0, mid: ~1, high: ~1), equals: b1, is:  Signum.positive)
            try Ɣrequire(T(low: ~1, mid: ~1, high: ~1), equals: b1, is:  Signum.zero)
            try Ɣrequire(T(low: ~2, mid: ~1, high: ~1), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~0, mid: ~2, high: ~1), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~1, mid: ~2, high: ~1), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~2, mid: ~2, high: ~1), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~0, mid: ~0, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~1, mid: ~0, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~2, mid: ~0, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~0, mid: ~1, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~1, mid: ~1, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~2, mid: ~1, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~0, mid: ~2, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~1, mid: ~2, high: ~2), equals: b1, is:  Signum.negative)
            try Ɣrequire(T(low: ~2, mid: ~2, high: ~2), equals: b1, is:  Signum.negative)
            
            func Ɣrequire(_ lhs: T, equals rhs: T, is expectation: Signum) throws {
                Ɣexpect(lhs, equals: rhs, is: expectation)
                Ɣexpect(rhs, equals: lhs, is: expectation.negated())
                
                try #require(lhs.compared(to: rhs) == expectation)
                try #require(rhs.compared(to: lhs) == expectation.negated())
            }
        }
    }
}
