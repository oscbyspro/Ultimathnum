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
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    func testSubtraction21B() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
                        
            Test().same(T(low:  0, high:  0).minus(B(~3)), F(T(low:  4, high:  0)))
            Test().same(T(low:  1, high:  2).minus(B(~3)), F(T(low:  5, high:  2)))
            Test().same(T(low: ~1, high: ~2).minus(B( 3)), F(T(low: ~4, high: ~2)))
            Test().same(T(low: ~0, high: ~0).minus(B( 3)), F(T(low: ~3, high: ~0)))
            
            Test().same(T(low: ~4, high: ~B.msb).minus(B(~3)), F(T(low: ~0, high: ~B.msb)))
            Test().same(T(low: ~3, high: ~B.msb).minus(B(~3)), F(T(low:  0, high:  B.msb), error: true))
            Test().same(T(low:  3, high:  B.msb).minus(B( 3)), F(T(low:  0, high:  B.msb)))
            Test().same(T(low:  2, high:  B.msb).minus(B( 3)), F(T(low: ~0, high: ~B.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            
            Test().same(T(low:  0, high:  0).minus(B(~3)), F(T(low:  4, high: ~0), error: true))
            Test().same(T(low:  1, high:  2).minus(B(~3)), F(T(low:  5, high:  1)))
            Test().same(T(low: ~1, high: ~2).minus(B( 3)), F(T(low: ~4, high: ~2)))
            Test().same(T(low: ~0, high: ~0).minus(B( 3)), F(T(low: ~3, high: ~0)))
            
            Test().same(T(low: ~3, high:  0).minus(B(~3)), F(T(low:  0, high:  0)))
            Test().same(T(low: ~4, high:  0).minus(B(~3)), F(T(low: ~0, high: ~0), error: true))
            Test().same(T(low:  3, high:  0).minus(B( 3)), F(T(low:  0, high:  0)))
            Test().same(T(low:  2, high:  0).minus(B( 3)), F(T(low: ~0, high: ~0), error: true))
        }
        
        for base in coreSystemsIntegers {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    func testSubtraction22B() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
                        
            Test().same(T(low:  0, high:  0).minus(T(low: ~3, high: ~4)), F(T(low:  4, high:  4)))
            Test().same(T(low:  1, high:  2).minus(T(low: ~3, high: ~4)), F(T(low:  5, high:  6)))
            Test().same(T(low: ~1, high: ~2).minus(T(low:  3, high:  4)), F(T(low: ~4, high: ~6)))
            Test().same(T(low: ~0, high: ~0).minus(T(low:  3, high:  4)), F(T(low: ~3, high: ~4)))
            
            Test().same(T(low: ~4, high: ~B.msb - 4).minus(T(low: ~3, high: ~4)), F(T(low: ~0, high: ~B.msb)))
            Test().same(T(low: ~3, high: ~B.msb - 4).minus(T(low: ~3, high: ~4)), F(T(low:  0, high:  B.msb), error: true))
            Test().same(T(low:  3, high:  B.msb + 4).minus(T(low:  3, high:  4)), F(T(low:  0, high:  B.msb)))
            Test().same(T(low:  2, high:  B.msb + 4).minus(T(low:  3, high:  4)), F(T(low: ~0, high: ~B.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            
            Test().same(T(low:  0, high:  0).minus(T(low: ~3, high: ~4)), F(T(low:  4, high:  4), error: true))
            Test().same(T(low:  1, high:  2).minus(T(low: ~3, high: ~4)), F(T(low:  5, high:  6), error: true))
            Test().same(T(low: ~1, high: ~2).minus(T(low:  3, high:  4)), F(T(low: ~4, high: ~6)))
            Test().same(T(low: ~0, high: ~0).minus(T(low:  3, high:  4)), F(T(low: ~3, high: ~4)))
            
            Test().same(T(low: ~3, high: ~4).minus(T(low: ~3, high: ~4)), F(T(low:  0, high:  0)))
            Test().same(T(low: ~4, high: ~4).minus(T(low: ~3, high: ~4)), F(T(low: ~0, high: ~0), error: true))
            Test().same(T(low:  3, high:  4).minus(T(low:  3, high:  4)), F(T(low:  0, high:  0)))
            Test().same(T(low:  2, high:  4).minus(T(low:  3, high:  4)), F(T(low: ~0, high: ~0), error: true))
        }
        
        for base in coreSystemsIntegers {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 2
    //=------------------------------------------------------------------------=
    
    func testSubtraction() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible<T>
            //=----------------------------------=
            IntegerInvariants(T.self).subtractionOfMinMax(SystemsIntegerID())
            IntegerInvariants(T.self).subtractionByNegation(SystemsIntegerID())
            IntegerInvariants(T.self).subtractionOfRepeatingBit(BinaryIntegerID())
            //=----------------------------------=
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
}
