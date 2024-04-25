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
// MARK: * Double Int x Addition
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible<T>
                        
            Test().addition(T(low:  0, high:   0), T(low:  0, high:  0), F(T(low:  0, high:  0)))
            Test().addition(T(low:  0, high:   0), T(low: ~0, high: ~0), F(T(low: ~0, high: ~0)))
            Test().addition(T(low: ~0, high:  ~0), T(low:  0, high:  0), F(T(low: ~0, high: ~0)))
            Test().addition(T(low: ~0, high:  ~0), T(low: ~0, high: ~0), F(T(low: ~1, high: ~0), error: !T.isSigned))
            
            Test().addition(T(low:  1, high:   2), T(low:  3, high:  4), F(T(low:  4, high:  6)))
            Test().addition(T(low:  1, high:   2), T(low: ~3, high: ~4), F(T(low: ~2, high: ~2)))
            Test().addition(T(low: ~1, high:  ~2), T(low:  3, high:  4), F(T(low:  1, high:  2), error: !T.isSigned))
            Test().addition(T(low: ~1, high:  ~2), T(low: ~3, high: ~4), F(T(low: ~5, high: ~6), error: !T.isSigned))
            
            if  T.isSigned {
                Test().addition(T(low: .max, high: .max), -1 as T, F(T(low: .max - 1, high: .max))) // carry 1st
                Test().addition(T(low: .max, high: .min), -1 as T, F(T(low: .max - 1, high: .min))) // carry 2nd
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testAdditionMinMax() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible<T>
            
            Test().addition(T.min,  T .min, F( 0 as T, error: T.isSigned))
            Test().addition(T.min,  T .max, F(~0 as T))
            Test().addition(T.max,  T .min, F(~0 as T))
            Test().addition(T.max,  T .max, F(~1 as T, error: true))
            
            Test().addition(T.min, ~0 as T, F( T .max, error: T.isSigned))
            Test().addition(T.min,  0 as T, F( T .min))
            Test().addition(T.min,  1 as T, F( T .min + 1))
            Test().addition(T.max, ~0 as T, F( T .max - 1, error: !T.isSigned))
            Test().addition(T.max,  0 as T, F( T .max))
            Test().addition(T.max,  1 as T, F( T .min, error: true))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
