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
    
    /// - Note: Generic tests may depend on these results.
    func testComparisonOfSize() {
        for size: Count in [I8x2.size, U8x2.size] {
            Test().comparison(size, U8  .size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U16 .size,  0 as Signum, id: ComparableID())
            Test().comparison(size, U32 .size, -1 as Signum, id: ComparableID())
            Test().comparison(size, U64 .size, -1 as Signum, id: ComparableID())
            
            Test().comparison(size, I8x2.size,  0 as Signum, id: ComparableID())
            Test().comparison(size, U8x2.size,  0 as Signum, id: ComparableID())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparisonOfLowHighPairs() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            //=----------------------------------=
            Test().comparison(T(low:  0, high:  0), T(low:  1, high:  1), -1 as Signum)
            Test().comparison(T(low:  1, high:  0), T(low:  1, high:  1), -1 as Signum)
            Test().comparison(T(low:  2, high:  0), T(low:  1, high:  1), -1 as Signum)
            Test().comparison(T(low:  0, high:  1), T(low:  1, high:  1), -1 as Signum)
            Test().comparison(T(low:  1, high:  1), T(low:  1, high:  1),  0 as Signum)
            Test().comparison(T(low:  2, high:  1), T(low:  1, high:  1),  1 as Signum)
            Test().comparison(T(low:  0, high:  2), T(low:  1, high:  1),  1 as Signum)
            Test().comparison(T(low:  1, high:  2), T(low:  1, high:  1),  1 as Signum)
            Test().comparison(T(low:  2, high:  2), T(low:  1, high:  1),  1 as Signum)
            
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
            
            Test().comparison(T(low: ~0, high: ~0), T(low: ~1, high: ~1),  1 as Signum)
            Test().comparison(T(low: ~1, high: ~0), T(low: ~1, high: ~1),  1 as Signum)
            Test().comparison(T(low: ~2, high: ~0), T(low: ~1, high: ~1),  1 as Signum)
            Test().comparison(T(low: ~0, high: ~1), T(low: ~1, high: ~1),  1 as Signum)
            Test().comparison(T(low: ~1, high: ~1), T(low: ~1, high: ~1),  0 as Signum)
            Test().comparison(T(low: ~2, high: ~1), T(low: ~1, high: ~1), -1 as Signum)
            Test().comparison(T(low: ~0, high: ~2), T(low: ~1, high: ~1), -1 as Signum)
            Test().comparison(T(low: ~1, high: ~2), T(low: ~1, high: ~1), -1 as Signum)
            Test().comparison(T(low: ~2, high: ~2), T(low: ~1, high: ~1), -1 as Signum)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
