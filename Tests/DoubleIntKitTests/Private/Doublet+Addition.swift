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
// MARK: * Doublet x Addition
//*============================================================================*

extension DoubletTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition21B() {
        func whereTheBaseIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
                        
            Test().same(X(low:  0, high:  0).plus(T(~3)), F(X(low: ~3, high: ~0)))
            Test().same(X(low:  1, high:  2).plus(T(~3)), F(X(low: ~2, high:  1)))
            Test().same(X(low: ~1, high: ~2).plus(T( 3)), F(X(low:  1, high: ~1)))
            Test().same(X(low: ~0, high: ~0).plus(T( 3)), F(X(low:  2, high:  0)))
            
            Test().same(X(low:  4, high:  T.msb).plus(T(~3)), F(X(low:  0, high:  T.msb)))
            Test().same(X(low:  3, high:  T.msb).plus(T(~3)), F(X(low: ~0, high: ~T.msb), error: true))
            Test().same(X(low: ~3, high: ~T.msb).plus(T( 3)), F(X(low: ~0, high: ~T.msb)))
            Test().same(X(low: ~2, high: ~T.msb).plus(T( 3)), F(X(low:  0, high:  T.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().same(X(low:  0, high:  0).plus(T(~3)), F(X(low: ~3, high:  0)))
            Test().same(X(low:  1, high:  2).plus(T(~3)), F(X(low: ~2, high:  2)))
            Test().same(X(low: ~1, high: ~2).plus(T( 3)), F(X(low:  1, high: ~1)))
            Test().same(X(low: ~0, high: ~0).plus(T( 3)), F(X(low:  2, high:  0), error: true))
            
            Test().same(X(low:  3, high: ~0).plus(T(~3)), F(X(low: ~0, high: ~0)))
            Test().same(X(low:  4, high: ~0).plus(T(~3)), F(X(low:  0, high:  0), error: true))
            Test().same(X(low: ~3, high: ~0).plus(T( 3)), F(X(low: ~0, high: ~0)))
            Test().same(X(low: ~2, high: ~0).plus(T( 3)), F(X(low:  0, high:  0), error: true))
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
    
    func testAddition22B() {
        func whereTheBaseIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
                        
            Test().same(X(low:  0, high:  0).plus(X(low: ~3, high: ~4)), F(X(low: ~3, high: ~4)))
            Test().same(X(low:  1, high:  2).plus(X(low: ~3, high: ~4)), F(X(low: ~2, high: ~2)))
            Test().same(X(low: ~1, high: ~2).plus(X(low:  3, high:  4)), F(X(low:  1, high:  2)))
            Test().same(X(low: ~0, high: ~0).plus(X(low:  3, high:  4)), F(X(low:  2, high:  4)))
            
            Test().same(X(low:  4, high:  T.msb + 4).plus(X(low: ~3, high: ~4)), F(X(low:  0, high:  T.msb)))
            Test().same(X(low:  3, high:  T.msb + 4).plus(X(low: ~3, high: ~4)), F(X(low: ~0, high: ~T.msb), error: true))
            Test().same(X(low: ~3, high: ~T.msb - 4).plus(X(low:  3, high:  4)), F(X(low: ~0, high: ~T.msb)))
            Test().same(X(low: ~2, high: ~T.msb - 4).plus(X(low:  3, high:  4)), F(X(low:  0, high:  T.msb), error: true))
        }
        
        func whereTheBaseIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().same(X(low:  0, high:  0).plus(X(low: ~3, high: ~4)), F(X(low: ~3, high: ~4)))
            Test().same(X(low:  1, high:  2).plus(X(low: ~3, high: ~4)), F(X(low: ~2, high: ~2)))
            Test().same(X(low: ~1, high: ~2).plus(X(low:  3, high:  4)), F(X(low:  1, high:  2), error: true))
            Test().same(X(low: ~0, high: ~0).plus(X(low:  3, high:  4)), F(X(low:  2, high:  4), error: true))
            
            Test().same(X(low:  3, high:  4).plus(X(low: ~3, high: ~4)), F(X(low: ~0, high: ~0)))
            Test().same(X(low:  4, high:  4).plus(X(low: ~3, high: ~4)), F(X(low:  0, high:  0), error: true))
            Test().same(X(low: ~3, high: ~4).plus(X(low:  3, high:  4)), F(X(low: ~0, high: ~0)))
            Test().same(X(low: ~2, high: ~4).plus(X(low:  3, high:  4)), F(X(low:  0, high:  0), error: true))
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseIsSigned(base) : whereTheBaseIsUnsigned(base)
        }
    }
}
