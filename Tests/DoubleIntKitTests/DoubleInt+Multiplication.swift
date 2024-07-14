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
// MARK: * Double Int x Multiplication
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    func testMultiplication213() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger & UnsignedInteger {
            typealias T = DoubleInt<B>
            typealias P = TripleInt<B>
            
            Test().same(T(low:  0, high:  0).multiplication( 0 as B), P(low:  0, mid:  0, high:  0))
            Test().same(T(low:  0, high:  0).multiplication(~0 as B), P(low:  0, mid:  0, high:  0))
            Test().same(T(low: ~0, high: ~0).multiplication( 0 as B), P(low:  0, mid:  0, high:  0))
            Test().same(T(low: ~0, high: ~0).multiplication(~0 as B), P(low:  1, mid: ~0, high: ~1))
            
            Test().same(T(low:  1, high:  2).multiplication( 3 as B), P(low:  3, mid:  6, high:  0))
            Test().same(T(low:  1, high:  2).multiplication(~3 as B), P(low: ~3, mid: ~7, high:  1))
            Test().same(T(low: ~1, high: ~2).multiplication( 3 as B), P(low: ~5, mid: ~6, high:  2))
            Test().same(T(low: ~1, high: ~2).multiplication(~3 as B), P(low:  8, mid:  6, high: ~5))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 2
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        func whereTheBaseTypeIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias M = DoubleInt<B>.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication(T(low:  1, high:  2), T(low:  3, high:  4), F(X(low: M(low:  3, high:  10), high: T(low:  8, high:  0)), error: true))
            Test().multiplication(T(low:  1, high:  2), T(low: ~3, high: ~4), F(X(low: M(low: ~3, high: ~12), high: T(low: ~8, high: ~0)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low:  3, high:  4), F(X(low: M(low: ~5, high: ~14), high: T(low: ~8, high: ~0)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low: ~3, high: ~4), F(X(low: M(low:  8, high:  16), high: T(low:  8, high:  0)), error: true))
        }
        
        func whereTheBaseTypeIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias M = DoubleInt<B>.Magnitude
            typealias P = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication(T(low:  1, high:  2), T(low:  3, high:  4), F(P(low: M(low:  3, high:  10), high: T(low:  8, high:  0)), error: true))
            Test().multiplication(T(low:  1, high:  2), T(low: ~3, high: ~4), F(P(low: M(low: ~3, high: ~12), high: T(low: ~7, high:  1)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low:  3, high:  4), F(P(low: M(low: ~5, high: ~14), high: T(low: ~5, high:  3)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low: ~3, high: ~4), F(P(low: M(low:  8, high:  16), high: T(low:  2, high: ~5)), error: true))
        }
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseTypeIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseTypeIsUnsigned(base)
        }
    }
}
