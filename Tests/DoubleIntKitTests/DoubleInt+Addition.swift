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
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    func testAddition21B() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
                        
            Test().same(T(low:  0, high:  0).plus(B(~3)), F(T(low: ~3, high: ~0)))
            Test().same(T(low:  1, high:  2).plus(B(~3)), F(T(low: ~2, high:  1)))
            Test().same(T(low: ~1, high: ~2).plus(B( 3)), F(T(low:  1, high: ~1)))
            Test().same(T(low: ~0, high: ~0).plus(B( 3)), F(T(low:  2, high:  0)))
            
            Test().same(T(low:  4, high:  B.msb).plus(B(~3)), F(T(low:  0, high:  B.msb)))
            Test().same(T(low:  3, high:  B.msb).plus(B(~3)), F(T(low: ~0, high: ~B.msb), error: true))
            Test().same(T(low: ~3, high: ~B.msb).plus(B( 3)), F(T(low: ~0, high: ~B.msb)))
            Test().same(T(low: ~2, high: ~B.msb).plus(B( 3)), F(T(low:  0, high:  B.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            
            Test().same(T(low:  0, high:  0).plus(B(~3)), F(T(low: ~3, high:  0)))
            Test().same(T(low:  1, high:  2).plus(B(~3)), F(T(low: ~2, high:  2)))
            Test().same(T(low: ~1, high: ~2).plus(B( 3)), F(T(low:  1, high: ~1)))
            Test().same(T(low: ~0, high: ~0).plus(B( 3)), F(T(low:  2, high:  0), error: true))
            
            Test().same(T(low:  3, high: ~0).plus(B(~3)), F(T(low: ~0, high: ~0)))
            Test().same(T(low:  4, high: ~0).plus(B(~3)), F(T(low:  0, high:  0), error: true))
            Test().same(T(low: ~3, high: ~0).plus(B( 3)), F(T(low: ~0, high: ~0)))
            Test().same(T(low: ~2, high: ~0).plus(B( 3)), F(T(low:  0, high:  0), error: true))
        }
        
        for base in coreSystemsIntegers {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    func testAddition22B() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            
            Test().same(T(low:  0, high:  0).plus(T(low: ~3, high: ~4)), F(T(low: ~3, high: ~4)))
            Test().same(T(low:  1, high:  2).plus(T(low: ~3, high: ~4)), F(T(low: ~2, high: ~2)))
            Test().same(T(low: ~1, high: ~2).plus(T(low:  3, high:  4)), F(T(low:  1, high:  2)))
            Test().same(T(low: ~0, high: ~0).plus(T(low:  3, high:  4)), F(T(low:  2, high:  4)))
            
            Test().same(T(low:  4, high:  B.msb + 4).plus(T(low: ~3, high: ~4)), F(T(low:  0, high:  B.msb)))
            Test().same(T(low:  3, high:  B.msb + 4).plus(T(low: ~3, high: ~4)), F(T(low: ~0, high: ~B.msb), error: true))
            Test().same(T(low: ~3, high: ~B.msb - 4).plus(T(low:  3, high:  4)), F(T(low: ~0, high: ~B.msb)))
            Test().same(T(low: ~2, high: ~B.msb - 4).plus(T(low:  3, high:  4)), F(T(low:  0, high:  B.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            
            Test().same(T(low:  0, high:  0).plus(T(low: ~3, high: ~4)), F(T(low: ~3, high: ~4)))
            Test().same(T(low:  1, high:  2).plus(T(low: ~3, high: ~4)), F(T(low: ~2, high: ~2)))
            Test().same(T(low: ~1, high: ~2).plus(T(low:  3, high:  4)), F(T(low:  1, high:  2), error: true))
            Test().same(T(low: ~0, high: ~0).plus(T(low:  3, high:  4)), F(T(low:  2, high:  4), error: true))
            
            Test().same(T(low:  3, high:  4).plus(T(low: ~3, high: ~4)), F(T(low: ~0, high: ~0)))
            Test().same(T(low:  4, high:  4).plus(T(low: ~3, high: ~4)), F(T(low:  0, high:  0), error: true))
            Test().same(T(low: ~3, high: ~4).plus(T(low:  3, high:  4)), F(T(low: ~0, high: ~0)))
            Test().same(T(low: ~2, high: ~4).plus(T(low:  3, high:  4)), F(T(low:  0, high:  0), error: true))
        }
        
        for base in coreSystemsIntegers {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 2
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<T>
            //=----------------------------------=
            IntegerInvariants(T.self).additionAboutMinMaxEsque()
            IntegerInvariants(T.self).additionAboutRepeatingBit(BinaryIntegerID())
            //=----------------------------------=
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
}
