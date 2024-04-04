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
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication(T(low:  1, high:  2), T(low:  3, high:  4), F(X(low: M(low:  3, high:  10), high: T(low:  8, high:  0)), error: true))
            Test().multiplication(T(low:  1, high:  2), T(low: ~3, high: ~4), F(X(low: M(low: ~3, high: ~12), high: T(low: ~8, high: ~0)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low:  3, high:  4), F(X(low: M(low: ~5, high: ~14), high: T(low: ~8, high: ~0)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low: ~3, high: ~4), F(X(low: M(low:  8, high:  16), high: T(low:  8, high:  0)), error: true))
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>

            Test().multiplication(T(low:  1, high:  2), T(low:  3, high:  4), F(X(low: M(low:  3, high:  10), high: T(low:  8, high:  0)), error: true))
            Test().multiplication(T(low:  1, high:  2), T(low: ~3, high: ~4), F(X(low: M(low: ~3, high: ~12), high: T(low: ~7, high:  1)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low:  3, high:  4), F(X(low: M(low: ~5, high: ~14), high: T(low: ~5, high:  3)), error: true))
            Test().multiplication(T(low: ~1, high: ~2), T(low: ~3, high: ~4), F(X(low: M(low:  8, high:  16), high: T(low:  2, high: ~5)), error: true))
        }
        
        for base in bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
    
    func testMultiplicationMinMax() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication(T.min,  T .min, F(X(low: 0 as M, high: T(bitPattern:  M.msb >> 1)), error: true))
            Test().multiplication(T.min,  T .max, F(X(low: M .msb, high: T(bitPattern:  T.msb >> 1)), error: true))
            Test().multiplication(T.max,  T .min, F(X(low: M .msb, high: T(bitPattern:  T.msb >> 1)), error: true))
            Test().multiplication(T.max,  T .max, F(X(low: 1 as M, high: T(bitPattern: ~M.msb >> 1)), error: true))
            
            Test().multiplication(T.min, ~1 as T, F(X(low:  0 as M, high:  1 as T), error: true))
            Test().multiplication(T.min, ~0 as T, F(X(low:  M .msb, high:  0 as T), error: true))
            Test().multiplication(T.min,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.min,  1 as T, F(X(low:  M .msb, high: ~0 as T)))
            Test().multiplication(T.min,  2 as T, F(X(low:  0 as M, high: ~0 as T), error: true))
            
            Test().multiplication(T.max, ~1 as T, F(X(low:  2 as M, high: ~0 as T), error: true))
            Test().multiplication(T.max, ~0 as T, F(X(low:  .msb+1, high: ~0 as T)))
            Test().multiplication(T.max,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.max,  1 as T, F(X(low: ~M .msb, high:  0 as T)))
            Test().multiplication(T.max,  2 as T, F(X(low: ~1 as M, high:  0 as T), error: true))
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>

            Test().multiplication(T.min,  T .min, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.min,  T .max, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.max,  T .min, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.max,  T .max, F(X(low:  1 as M, high: ~1 as T), error: true))
            
            Test().multiplication(T.min, ~1 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.min, ~0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.min,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.min,  1 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.min,  2 as T, F(X(low:  0 as M, high:  0 as T)))
            
            Test().multiplication(T.max, ~1 as T, F(X(low:  2 as M, high: ~2 as T), error: true))
            Test().multiplication(T.max, ~0 as T, F(X(low:  1 as M, high: ~1 as T), error: true))
            Test().multiplication(T.max,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(T.max,  1 as T, F(X(low: ~0 as M, high:  0 as T)))
            Test().multiplication(T.max,  2 as T, F(X(low: ~1 as M, high:  1 as T), error: true))
        }
        
        for base in bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
}
