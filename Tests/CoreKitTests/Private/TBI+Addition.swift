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
// MARK: * Tuple Binary Integer x Addition
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition32B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X = DoubleIntLayout<Base>
            typealias Y = TripleIntLayout<Base>
            typealias F = Fallible<TripleIntLayout<Base>>
            
            Test.addition32B(Y(low:  0, mid:  0, high:  0), X(low: ~4, high: ~5), F(Y(low: ~4, mid: ~5, high:  0)))
            Test.addition32B(Y(low:  1, mid:  2, high:  3), X(low: ~4, high: ~5), F(Y(low: ~3, mid: ~3, high:  3)))
            Test.addition32B(Y(low: ~1, mid: ~2, high: ~3), X(low:  4, high:  5), F(Y(low:  2, mid:  3, high: ~2)))
            Test.addition32B(Y(low: ~0, mid: ~0, high: ~0), X(low:  4, high:  5), F(Y(low:  3, mid:  5, high:  0), error: true))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
    
    func testAddition33B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X = DoubleIntLayout<Base>
            typealias Y = TripleIntLayout<Base>
            typealias F = Fallible<TripleIntLayout<Base>>
            
            Test.addition33B(Y(low:  0, mid:  0, high:  0), Y(low: ~4, mid: ~5, high: ~6), F(Y(low: ~4, mid: ~5, high: ~6)))
            Test.addition33B(Y(low:  1, mid:  2, high:  3), Y(low: ~4, mid: ~5, high: ~6), F(Y(low: ~3, mid: ~3, high: ~3)))
            Test.addition33B(Y(low: ~1, mid: ~2, high: ~3), Y(low:  4, mid:  5, high:  6), F(Y(low:  2, mid:  3, high:  3), error: true))
            Test.addition33B(Y(low: ~0, mid: ~0, high: ~0), Y(low:  4, mid:  5, high:  6), F(Y(low:  3, mid:  5, high:  6), error: true))
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
    
    static func addition32B<Base>(
        _ lhs: TripleIntLayout<Base>, 
        _ rhs: DoubleIntLayout<Base>,
        _ expectation: Fallible<TripleIntLayout<Base>>,
        _ test: Test = .init()
    )   where Base: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.increment32B(&x, by: rhs)
        //=--------------------------------------=
        test.same(Fallible(x, error: o), expectation)
    }

    static func addition33B<Base>(
        _ lhs: TripleIntLayout<Base>, 
        _ rhs: TripleIntLayout<Base>,
        _ expectation: Fallible<TripleIntLayout<Base>>,
        _ test: Test = .init()
    )   where Base: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.increment33B(&x, by: rhs)
        //=--------------------------------------=
        test.same(Fallible(x, error: o), expectation)
    }
}
