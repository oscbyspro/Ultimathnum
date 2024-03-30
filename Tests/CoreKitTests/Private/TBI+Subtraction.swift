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
// MARK: * Tuple Binary Integer x Subtraction
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtraction32B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X = DoubleIntLayout<Base>
            typealias Y = TripleIntLayout<Base>
            typealias F = Fallible<TripleIntLayout<Base>>
            
            Test().subtraction32B(Y(low:  0, mid:  0, high:  0), X(low: ~4, high: ~5), F(Y(low:  5, mid:  5, high: ~0), error: true))
            Test().subtraction32B(Y(low:  1, mid:  2, high:  3), X(low: ~4, high: ~5), F(Y(low:  6, mid:  7, high:  2)))
            Test().subtraction32B(Y(low: ~1, mid: ~2, high: ~3), X(low:  4, high:  5), F(Y(low: ~5, mid: ~7, high: ~3)))
            Test().subtraction32B(Y(low: ~0, mid: ~0, high: ~0), X(low:  4, high:  5), F(Y(low: ~4, mid: ~5, high: ~0)))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
    
    func testSubtraction33B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X = DoubleIntLayout<Base>
            typealias Y = TripleIntLayout<Base>
            typealias F = Fallible<TripleIntLayout<Base>>
            
            Test().subtraction33B(Y(low:  0, mid:  0, high:  0), Y(low: ~4, mid: ~5, high: ~6), F(Y(low:  5, mid:  5, high:  6), error: true))
            Test().subtraction33B(Y(low:  1, mid:  2, high:  3), Y(low: ~4, mid: ~5, high: ~6), F(Y(low:  6, mid:  7, high:  9), error: true))
            Test().subtraction33B(Y(low: ~1, mid: ~2, high: ~3), Y(low:  4, mid:  5, high:  6), F(Y(low: ~5, mid: ~7, high: ~9)))
            Test().subtraction33B(Y(low: ~0, mid: ~0, high: ~0), Y(low:  4, mid:  5, high:  6), F(Y(low: ~4, mid: ~5, high: ~6)))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func subtraction32B<Base>(
        _ lhs: TripleIntLayout<Base>, 
        _ rhs: DoubleIntLayout<Base>,
        _ expectation: Fallible<TripleIntLayout<Base>>
    )   where Base: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.decrement32B(&x, by: rhs)
        //=--------------------------------------=
        same(Fallible(x, error: o), expectation)
    }

    func subtraction33B<Base>(
        _ lhs: TripleIntLayout<Base>, 
        _ rhs: TripleIntLayout<Base>,
        _ expectation: Fallible<TripleIntLayout<Base>>
    )   where Base: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.decrement33B(&x, by: rhs)
        //=--------------------------------------=
        same(Fallible(x, error: o), expectation)
    }
}
