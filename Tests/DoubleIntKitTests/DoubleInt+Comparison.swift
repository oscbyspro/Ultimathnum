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
// MARK: * Double Int x Comparison
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparisonOfLowHighPairs() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            //=----------------------------------=
            Test().comparison(T(low:  0, high:  0), T(low:  1, high:  1),  Signum.negative)
            Test().comparison(T(low:  1, high:  0), T(low:  1, high:  1),  Signum.negative)
            Test().comparison(T(low:  2, high:  0), T(low:  1, high:  1),  Signum.negative)
            Test().comparison(T(low:  0, high:  1), T(low:  1, high:  1),  Signum.negative)
            Test().comparison(T(low:  1, high:  1), T(low:  1, high:  1),  Signum.zero)
            Test().comparison(T(low:  2, high:  1), T(low:  1, high:  1),  Signum.positive)
            Test().comparison(T(low:  0, high:  2), T(low:  1, high:  1),  Signum.positive)
            Test().comparison(T(low:  1, high:  2), T(low:  1, high:  1),  Signum.positive)
            Test().comparison(T(low:  2, high:  2), T(low:  1, high:  1),  Signum.positive)
            
            Test().comparison(T(low:  0, high:  0), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  1, high:  0), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  2, high:  0), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  0, high:  1), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  1, high:  1), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  2, high:  1), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  0, high:  2), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  1, high:  2), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            Test().comparison(T(low:  2, high:  2), T(low: ~1, high: ~1), -Signum(Sign(T.isSigned)))
            
            Test().comparison(T(low: ~0, high: ~0), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~1, high: ~0), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~2, high: ~0), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~0, high: ~1), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~1, high: ~1), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~2, high: ~1), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~0, high: ~2), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~1, high: ~2), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            Test().comparison(T(low: ~2, high: ~2), T(low:  1, high:  1),  Signum(Sign(T.isSigned)))
            
            Test().comparison(T(low: ~0, high: ~0), T(low: ~1, high: ~1),  Signum.positive)
            Test().comparison(T(low: ~1, high: ~0), T(low: ~1, high: ~1),  Signum.positive)
            Test().comparison(T(low: ~2, high: ~0), T(low: ~1, high: ~1),  Signum.positive)
            Test().comparison(T(low: ~0, high: ~1), T(low: ~1, high: ~1),  Signum.positive)
            Test().comparison(T(low: ~1, high: ~1), T(low: ~1, high: ~1),  Signum.zero)
            Test().comparison(T(low: ~2, high: ~1), T(low: ~1, high: ~1),  Signum.negative)
            Test().comparison(T(low: ~0, high: ~2), T(low: ~1, high: ~1),  Signum.negative)
            Test().comparison(T(low: ~1, high: ~2), T(low: ~1, high: ~1),  Signum.negative)
            Test().comparison(T(low: ~2, high: ~2), T(low: ~1, high: ~1),  Signum.negative)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
