//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
                        
            Test.subtraction(T(low:  0, high:   0), T(low:  0, high:  0), T(low:  0, high:  0))
            Test.subtraction(T(low:  0, high:   0), T(low: ~0, high: ~0), T(low:  1, high:  0), !T.isSigned)
            Test.subtraction(T(low: ~0, high:  ~0), T(low:  0, high:  0), T(low: ~0, high: ~0))
            Test.subtraction(T(low: ~0, high:  ~0), T(low: ~0, high: ~0), T(low:  0, high:  0))
            
            Test.subtraction(T(low:  1, high:   2), T(low:  3, high:  4), T(low: ~1, high: ~2), !T.isSigned)
            Test.subtraction(T(low:  1, high:   2), T(low: ~3, high: ~4), T(low:  5, high:  6), !T.isSigned)
            Test.subtraction(T(low: ~1, high:  ~2), T(low:  3, high:  4), T(low: ~4, high: ~6))
            Test.subtraction(T(low: ~1, high:  ~2), T(low: ~3, high: ~4), T(low:  2, high:  2))
            
            if  T.isSigned {
                Test.subtraction(T(low: .min, high: .min), -1 as T, T(low: .min + 1, high: .min)) // carry 1st
                Test.subtraction(T(low: .min, high: .max), -1 as T, T(low: .min + 1, high: .max)) // carry 2nd
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testSubtractionMinMax() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test.subtraction(T.min,  T .min,  0 as T)
            Test.subtraction(T.min,  T .max,  1 as T, true)
            Test.subtraction(T.max,  T .min, ~0 as T, T.isSigned)
            Test.subtraction(T.max,  T .max,  0 as T)
            
            Test.subtraction(T.min, ~0 as T,  T .min + 1, !T.isSigned)
            Test.subtraction(T.min,  0 as T,  T .min)
            Test.subtraction(T.min,  1 as T,  T .max, true)
            Test.subtraction(T.max, ~0 as T,  T .min, T.isSigned)
            Test.subtraction(T.max,  0 as T,  T .max)
            Test.subtraction(T.max,  1 as T,  T .max - 1)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testSubtractionNegation() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test.subtraction(0 as T, ~1 as T,  2 as T, !T.isSigned)
            Test.subtraction(0 as T, ~0 as T,  1 as T, !T.isSigned)
            Test.subtraction(0 as T,  0 as T,  0 as T)
            Test.subtraction(0 as T,  1 as T, ~0 as T, !T.isSigned)
            Test.subtraction(0 as T,  2 as T, ~1 as T, !T.isSigned)
            
            for x in [T.init(), T.min, T.max, T.lsb, T.msb] {
                Test.subtraction(0 as T, x, ~x &+ 1, T.isSigned == (x == T.min))
                Test.subtraction(0 as T, x, ~x &+ 1, T.isSigned == (x == T.min))
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
