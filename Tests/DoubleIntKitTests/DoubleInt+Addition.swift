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
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).additionOfMinMaxEsque()
            IntegerInvariants(T.self).additionOfRepeatingBit(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testSubtraction() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).negation()
            IntegerInvariants(T.self).subtractionOfMinMaxEsque()
            IntegerInvariants(T.self).subtractionOfRepeatingBit(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    func testAddition21() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<T>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            Test().same(T(low:  0, high:  0).plus(B.Magnitude(~3)), F(T(low: ~3, high:  0)))
            Test().same(T(low:  1, high:  2).plus(B.Magnitude(~3)), F(T(low: ~2, high:  2)))
            Test().same(T(low: ~1, high: ~2).plus(B.Magnitude( 3)), F(T(low:  1, high: ~1)))
            Test().same(T(low: ~0, high: ~0).plus(B.Magnitude( 3)), F(T(low:  2, high:  0)))
            
            Test().same(T(low:  3, high:  x).plus(B.Magnitude(~3)), F(T(low: ~0, high:  x)))
            Test().same(T(low:  4, high:  x).plus(B.Magnitude(~3)), F(T(low:  0, high:  x ^ 1)))
            Test().same(T(low: ~3, high: ~x).plus(B.Magnitude( 3)), F(T(low: ~0, high: ~x)))
            Test().same(T(low: ~2, high: ~x).plus(B.Magnitude( 3)), F(T(low:  0, high:  x), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<T>

            Test().same(T(low:  0, high:  0).plus(B.Magnitude(~3)), F(T(low: ~3, high:  0)))
            Test().same(T(low:  1, high:  2).plus(B.Magnitude(~3)), F(T(low: ~2, high:  2)))
            Test().same(T(low: ~1, high: ~2).plus(B.Magnitude( 3)), F(T(low:  1, high: ~1)))
            Test().same(T(low: ~0, high: ~0).plus(B.Magnitude( 3)), F(T(low:  2, high:  0), error: true))
            
            Test().same(T(low:  3, high: ~0).plus(B.Magnitude(~3)), F(T(low: ~0, high: ~0)))
            Test().same(T(low:  4, high: ~0).plus(B.Magnitude(~3)), F(T(low:  0, high:  0), error: true))
            Test().same(T(low: ~3, high: ~0).plus(B.Magnitude( 3)), F(T(low: ~0, high: ~0)))
            Test().same(T(low: ~2, high: ~0).plus(B.Magnitude( 3)), F(T(low:  0, high:  0), error: true))
        }
        
        for base in coreSystemsIntegers {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    func testSubtraction21() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            Test().same(T(low:  0, high:  0).minus(B.Magnitude(~3)), F(T(low:  4, high: ~0)))
            Test().same(T(low:  1, high:  2).minus(B.Magnitude(~3)), F(T(low:  5, high:  1)))
            Test().same(T(low: ~1, high: ~2).minus(B.Magnitude( 3)), F(T(low: ~4, high: ~2)))
            Test().same(T(low: ~0, high: ~0).minus(B.Magnitude( 3)), F(T(low: ~3, high: ~0)))
            
            Test().same(T(low: ~3, high: ~x).minus(B.Magnitude(~3)), F(T(low:  0, high: ~x)))
            Test().same(T(low: ~4, high: ~x).minus(B.Magnitude(~3)), F(T(low: ~0, high: ~x ^ 1)))
            Test().same(T(low:  3, high:  x).minus(B.Magnitude( 3)), F(T(low:  0, high:  x)))
            Test().same(T(low:  2, high:  x).minus(B.Magnitude( 3)), F(T(low: ~0, high: ~x), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<DoubleInt<B>>
            
            Test().same(T(low:  0, high:  0).minus(B.Magnitude(~3)), F(T(low:  4, high: ~0), error: true))
            Test().same(T(low:  1, high:  2).minus(B.Magnitude(~3)), F(T(low:  5, high:  1)))
            Test().same(T(low: ~1, high: ~2).minus(B.Magnitude( 3)), F(T(low: ~4, high: ~2)))
            Test().same(T(low: ~0, high: ~0).minus(B.Magnitude( 3)), F(T(low: ~3, high: ~0)))
            
            Test().same(T(low: ~3, high:  0).minus(B.Magnitude(~3)), F(T(low:  0, high:  0)))
            Test().same(T(low: ~4, high:  0).minus(B.Magnitude(~3)), F(T(low: ~0, high: ~0), error: true))
            Test().same(T(low:  3, high:  0).minus(B.Magnitude( 3)), F(T(low:  0, high:  0)))
            Test().same(T(low:  2, high:  0).minus(B.Magnitude( 3)), F(T(low: ~0, high: ~0), error: true))
        }
        
        for base in coreSystemsIntegers {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 2
    //=------------------------------------------------------------------------=
    
    func testAddition22() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
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
        
        func whereTheBaseTypeIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<T>
            
            Test().same(T(low:  0, high:  0).plus(T(low: ~3, high: ~4)), F(T(low: ~3, high: ~4)))
            Test().same(T(low:  1, high:  2).plus(T(low: ~3, high: ~4)), F(T(low: ~2, high: ~2)))
            Test().same(T(low: ~1, high: ~2).plus(T(low:  3, high:  4)), F(T(low:  1, high:  2)))
            Test().same(T(low: ~0, high: ~0).plus(T(low:  3, high:  4)), F(T(low:  2, high:  4)))
            
            Test().same(T(low:  4, high:  B.msb + 4).plus(T(low: ~3, high: ~4)), F(T(low:  0, high:  B.msb)))
            Test().same(T(low:  3, high:  B.msb + 4).plus(T(low: ~3, high: ~4)), F(T(low: ~0, high: ~B.msb), error: true))
            Test().same(T(low: ~3, high: ~B.msb - 4).plus(T(low:  3, high:  4)), F(T(low: ~0, high: ~B.msb)))
            Test().same(T(low: ~2, high: ~B.msb - 4).plus(T(low:  3, high:  4)), F(T(low:  0, high:  B.msb), error: true))
        }
        
        func whereTheBaseTypeIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<T>

            Test().same(T(low:  0, high:  0).plus(T(low: ~3, high: ~4)), F(T(low: ~3, high: ~4)))
            Test().same(T(low:  1, high:  2).plus(T(low: ~3, high: ~4)), F(T(low: ~2, high: ~2)))
            Test().same(T(low: ~1, high: ~2).plus(T(low:  3, high:  4)), F(T(low:  1, high:  2), error: true))
            Test().same(T(low: ~0, high: ~0).plus(T(low:  3, high:  4)), F(T(low:  2, high:  4), error: true))
            
            Test().same(T(low:  3, high:  4).plus(T(low: ~3, high: ~4)), F(T(low: ~0, high: ~0)))
            Test().same(T(low:  4, high:  4).plus(T(low: ~3, high: ~4)), F(T(low:  0, high:  0), error: true))
            Test().same(T(low: ~3, high: ~4).plus(T(low:  3, high:  4)), F(T(low: ~0, high: ~0)))
            Test().same(T(low: ~2, high: ~4).plus(T(low:  3, high:  4)), F(T(low:  0, high:  0), error: true))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseTypeIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseTypeIsUnsigned(base)
        }
    }
    
    func testSubtraction22() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
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
        
        func whereTheBaseTypeIsSigned<B>(_ type: B.Type) where B: SystemsInteger {
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
        
        func whereTheBaseTypeIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger {
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
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseTypeIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseTypeIsUnsigned(base)
        }
    }
}
