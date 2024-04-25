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
// MARK: * Double Int x Subtraction
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtraction() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible<T>
                        
            Test().subtraction(T(low:  0, high:   0), T(low:  0, high:  0), F(T(low:  0, high:  0)))
            Test().subtraction(T(low:  0, high:   0), T(low: ~0, high: ~0), F(T(low:  1, high:  0), error: !T.isSigned))
            Test().subtraction(T(low: ~0, high:  ~0), T(low:  0, high:  0), F(T(low: ~0, high: ~0)))
            Test().subtraction(T(low: ~0, high:  ~0), T(low: ~0, high: ~0), F(T(low:  0, high:  0)))
            
            Test().subtraction(T(low:  1, high:   2), T(low:  3, high:  4), F(T(low: ~1, high: ~2), error: !T.isSigned))
            Test().subtraction(T(low:  1, high:   2), T(low: ~3, high: ~4), F(T(low:  5, high:  6), error: !T.isSigned))
            Test().subtraction(T(low: ~1, high:  ~2), T(low:  3, high:  4), F(T(low: ~4, high: ~6)))
            Test().subtraction(T(low: ~1, high:  ~2), T(low: ~3, high: ~4), F(T(low:  2, high:  2)))
            
            if  T.isSigned {
                Test().subtraction(T(low: .min, high: .min), -1 as T, F(T(low: .min + 1, high: .min))) // carry 1st
                Test().subtraction(T(low: .min, high: .max), -1 as T, F(T(low: .min + 1, high: .max))) // carry 2nd
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testSubtractionMinMax() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible<T>
            
            Test().subtraction(T.min,  T .min, F( 0 as T))
            Test().subtraction(T.min,  T .max, F( 1 as T, error: true))
            Test().subtraction(T.max,  T .min, F(~0 as T, error: T.isSigned))
            Test().subtraction(T.max,  T .max, F( 0 as T))
            
            Test().subtraction(T.min, ~0 as T, F( T .min + 1, error: !T.isSigned))
            Test().subtraction(T.min,  0 as T, F( T .min))
            Test().subtraction(T.min,  1 as T, F( T .max, error: true))
            Test().subtraction(T.max, ~0 as T, F( T .min, error: T.isSigned))
            Test().subtraction(T.max,  0 as T, F( T .max))
            Test().subtraction(T.max,  1 as T, F( T .max - 1))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testSubtractionNegation() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible<T>
            
            Test().subtraction(0 as T, ~1 as T, F( 2 as T, error: !T.isSigned))
            Test().subtraction(0 as T, ~0 as T, F( 1 as T, error: !T.isSigned))
            Test().subtraction(0 as T,  0 as T, F( 0 as T))
            Test().subtraction(0 as T,  1 as T, F(~0 as T, error: !T.isSigned))
            Test().subtraction(0 as T,  2 as T, F(~1 as T, error: !T.isSigned))
            
            for x in [T.init(), T.min, T.max, T.lsb, T.msb] {
                Test().subtraction(0 as T, x, F(~x &+ 1, error: T.isSigned == (x == T.min)))
                Test().subtraction(0 as T, x, F(~x &+ 1, error: T.isSigned == (x == T.min)))
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
