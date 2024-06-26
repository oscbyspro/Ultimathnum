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
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).comparisonOfGenericLowEntropy()
            IntegerInvariants(T.self).comparisonOfGenericMinMaxEsque()
            IntegerInvariants(T.self).comparisonOfGenericRepeatingBit()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    /// - Note: Generic tests may depend on these results.
    func testComparisonOfSize() {
        for size: U8x2 in [I8x2.size, U8x2.size] {
            Test().comparison(size, U8  .size,  1 as Signum)
            Test().comparison(size, U16 .size,  0 as Signum)
            Test().comparison(size, U32 .size, -1 as Signum)
            Test().comparison(size, U64 .size, -1 as Signum)
            
            Test().comparison(size, I8x2.size,  0 as Signum)
            Test().comparison(size, U8x2.size,  0 as Signum)
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
            
            Test().comparison(T(low:  0, high:  0), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  1, high:  0), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  2, high:  0), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  0, high:  1), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  1, high:  1), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  2, high:  1), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  0, high:  2), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  1, high:  2), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low:  2, high:  2), T(low: ~1, high: ~1), -Signum.one(Sign(raw: T.isSigned)))
            
            Test().comparison(T(low: ~0, high: ~0), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~1, high: ~0), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~2, high: ~0), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~0, high: ~1), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~1, high: ~1), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~2, high: ~1), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~0, high: ~2), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~1, high: ~2), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            Test().comparison(T(low: ~2, high: ~2), T(low:  1, high:  1),  Signum.one(Sign(raw: T.isSigned)))
            
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
