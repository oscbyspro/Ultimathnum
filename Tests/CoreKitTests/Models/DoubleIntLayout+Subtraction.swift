//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Double Int Layout x Subtraction
//*============================================================================*

extension DoubleIntLayoutTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtraction21B() {
        func whereTheBaseIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = DoubleIntLayout<T>
            typealias F = Fallible<DoubleIntLayout<T>>
                        
            Test().same(X(low:  0, high:  0).minus(T(~3)), F(X(low:  4, high:  0)))
            Test().same(X(low:  1, high:  2).minus(T(~3)), F(X(low:  5, high:  2)))
            Test().same(X(low: ~1, high: ~2).minus(T( 3)), F(X(low: ~4, high: ~2)))
            Test().same(X(low: ~0, high: ~0).minus(T( 3)), F(X(low: ~3, high: ~0)))
            
            Test().same(X(low: ~4, high: ~T.msb).minus(T(~3)), F(X(low: ~0, high: ~T.msb)))
            Test().same(X(low: ~3, high: ~T.msb).minus(T(~3)), F(X(low:  0, high:  T.msb), error: true))
            Test().same(X(low:  3, high:  T.msb).minus(T( 3)), F(X(low:  0, high:  T.msb)))
            Test().same(X(low:  2, high:  T.msb).minus(T( 3)), F(X(low: ~0, high: ~T.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = DoubleIntLayout<T>
            typealias F = Fallible<DoubleIntLayout<T>>
            
            Test().same(X(low:  0, high:  0).minus(T(~3)), F(X(low:  4, high: ~0), error: true))
            Test().same(X(low:  1, high:  2).minus(T(~3)), F(X(low:  5, high:  1)))
            Test().same(X(low: ~1, high: ~2).minus(T( 3)), F(X(low: ~4, high: ~2)))
            Test().same(X(low: ~0, high: ~0).minus(T( 3)), F(X(low: ~3, high: ~0)))
            
            Test().same(X(low: ~3, high:  0).minus(T(~3)), F(X(low:  0, high:  0)))
            Test().same(X(low: ~4, high:  0).minus(T(~3)), F(X(low: ~0, high: ~0), error: true))
            Test().same(X(low:  3, high:  0).minus(T( 3)), F(X(low:  0, high:  0)))
            Test().same(X(low:  2, high:  0).minus(T( 3)), F(X(low: ~0, high: ~0), error: true))
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    func testSubtraction22B() {
        func whereTheBaseIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = DoubleIntLayout<T>
            typealias F = Fallible<DoubleIntLayout<T>>
                        
            Test().same(X(low:  0, high:  0).minus(X(low: ~3, high: ~4)), F(X(low:  4, high:  4)))
            Test().same(X(low:  1, high:  2).minus(X(low: ~3, high: ~4)), F(X(low:  5, high:  6)))
            Test().same(X(low: ~1, high: ~2).minus(X(low:  3, high:  4)), F(X(low: ~4, high: ~6)))
            Test().same(X(low: ~0, high: ~0).minus(X(low:  3, high:  4)), F(X(low: ~3, high: ~4)))
            
            Test().same(X(low: ~4, high: ~T.msb - 4).minus(X(low: ~3, high: ~4)), F(X(low: ~0, high: ~T.msb)))
            Test().same(X(low: ~3, high: ~T.msb - 4).minus(X(low: ~3, high: ~4)), F(X(low:  0, high:  T.msb), error: true))
            Test().same(X(low:  3, high:  T.msb + 4).minus(X(low:  3, high:  4)), F(X(low:  0, high:  T.msb)))
            Test().same(X(low:  2, high:  T.msb + 4).minus(X(low:  3, high:  4)), F(X(low: ~0, high: ~T.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = DoubleIntLayout<T>
            typealias F = Fallible<DoubleIntLayout<T>>
            
            Test().same(X(low:  0, high:  0).minus(X(low: ~3, high: ~4)), F(X(low:  4, high:  4), error: true))
            Test().same(X(low:  1, high:  2).minus(X(low: ~3, high: ~4)), F(X(low:  5, high:  6), error: true))
            Test().same(X(low: ~1, high: ~2).minus(X(low:  3, high:  4)), F(X(low: ~4, high: ~6)))
            Test().same(X(low: ~0, high: ~0).minus(X(low:  3, high:  4)), F(X(low: ~3, high: ~4)))
            
            Test().same(X(low: ~3, high: ~4).minus(X(low: ~3, high: ~4)), F(X(low:  0, high:  0)))
            Test().same(X(low: ~4, high: ~4).minus(X(low: ~3, high: ~4)), F(X(low: ~0, high: ~0), error: true))
            Test().same(X(low:  3, high:  4).minus(X(low:  3, high:  4)), F(X(low:  0, high:  0)))
            Test().same(X(low:  2, high:  4).minus(X(low:  3, high:  4)), F(X(low: ~0, high: ~0), error: true))
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
}
