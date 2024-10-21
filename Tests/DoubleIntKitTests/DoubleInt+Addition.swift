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
    // TODO: HalveableInteger/plus (_:) would let us hoist these tests
    // TODO: HalveableInteger/minus(_:) would let us hoist these tests
    //=------------------------------------------------------------------------=
    
    func testAddition21() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger & SignedInteger {
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
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger & UnsignedInteger {
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
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIsUnsigned(base)
        }
    }
    
    func testSubtraction21() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger & SignedInteger {
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
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger & UnsignedInteger {
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
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIsUnsigned(base)
        }
    }
}
