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
            
            Test.multiplication(T(low:  1, high:  2), T(low:  3, high:  4), Doublet(low: M(low:  3, high:  10), high: T(low:  8, high:  0)), true)
            Test.multiplication(T(low:  1, high:  2), T(low: ~3, high: ~4), Doublet(low: M(low: ~3, high: ~12), high: T(low: ~8, high: ~0)), true)
            Test.multiplication(T(low: ~1, high: ~2), T(low:  3, high:  4), Doublet(low: M(low: ~5, high: ~14), high: T(low: ~8, high: ~0)), true)
            Test.multiplication(T(low: ~1, high: ~2), T(low: ~3, high: ~4), Doublet(low: M(low:  8, high:  16), high: T(low:  8, high:  0)), true)
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test.multiplication(T(low:  1, high:  2), T(low:  3, high:  4), Doublet(low: M(low:  3, high:  10), high: T(low:  8, high:  0)), true)
            Test.multiplication(T(low:  1, high:  2), T(low: ~3, high: ~4), Doublet(low: M(low: ~3, high: ~12), high: T(low: ~7, high:  1)), true)
            Test.multiplication(T(low: ~1, high: ~2), T(low:  3, high:  4), Doublet(low: M(low: ~5, high: ~14), high: T(low: ~5, high:  3)), true)
            Test.multiplication(T(low: ~1, high: ~2), T(low: ~3, high: ~4), Doublet(low: M(low:  8, high:  16), high: T(low:  2, high: ~5)), true)
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
    
    func testMultiplicationMinMax() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test.multiplication(T.min,  T .min, Doublet(low: 0 as M, high: T(bitPattern:  M.msb >> 1)), true)
            Test.multiplication(T.min,  T .max, Doublet(low: M .msb, high: T(bitPattern:  T.msb >> 1)), true)
            Test.multiplication(T.max,  T .min, Doublet(low: M .msb, high: T(bitPattern:  T.msb >> 1)), true)
            Test.multiplication(T.max,  T .max, Doublet(low: 1 as M, high: T(bitPattern: ~M.msb >> 1)), true)
            
            Test.multiplication(T.min, ~1 as T, Doublet(low:  0 as M, high:  1 as T), true)
            Test.multiplication(T.min, ~0 as T, Doublet(low:  M .msb, high:  0 as T), true)
            Test.multiplication(T.min,  0 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.min,  1 as T, Doublet(low:  M .msb, high: ~0 as T))
            Test.multiplication(T.min,  2 as T, Doublet(low:  0 as M, high: ~0 as T), true)
            
            Test.multiplication(T.max, ~1 as T, Doublet(low:  2 as M, high: ~0 as T), true)
            Test.multiplication(T.max, ~0 as T, Doublet(low:  .msb+1, high: ~0 as T))
            Test.multiplication(T.max,  0 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.max,  1 as T, Doublet(low: ~M .msb, high:  0 as T))
            Test.multiplication(T.max,  2 as T, Doublet(low: ~1 as M, high:  0 as T), true)
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test.multiplication(T.min,  T .min, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.min,  T .max, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.max,  T .min, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.max,  T .max, Doublet(low:  1 as M, high: ~1 as T), true)
            
            Test.multiplication(T.min, ~1 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.min, ~0 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.min,  0 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.min,  1 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.min,  2 as T, Doublet(low:  0 as M, high:  0 as T))
            
            Test.multiplication(T.max, ~1 as T, Doublet(low:  2 as M, high: ~2 as T), true)
            Test.multiplication(T.max, ~0 as T, Doublet(low:  1 as M, high: ~1 as T), true)
            Test.multiplication(T.max,  0 as T, Doublet(low:  0 as M, high:  0 as T))
            Test.multiplication(T.max,  1 as T, Doublet(low: ~0 as M, high:  0 as T))
            Test.multiplication(T.max,  2 as T, Doublet(low: ~1 as M, high:  1 as T), true)
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
}
