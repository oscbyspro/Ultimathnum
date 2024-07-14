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
// MARK: * Core Int x Division
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision2111() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias F = Fallible<D>
            typealias X = Doublet<T>
            //=----------------------------------=
            let size = IX(size: T.self)
            //=----------------------------------=
            Test().division(X(low:  1 as M, high:  T .max >> 1    ), T.max, F(D(quotient: T.max, remainder:         0)))
            Test().division(X(low: ~M .msb, high:  T .max >> 1    ), T.max, F(D(quotient: T.max, remainder: T.max - 1)))
            Test().division(X(low:  M .msb, high:  T .max >> 1    ), T.max, F(D(quotient: T.min, remainder:         0), error: true))
            Test().division(X(low:  0 as M, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.min, remainder:         0)))
            Test().division(X(low: ~M .msb, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.min, remainder: T.max - 0)))
            Test().division(X(low:  M .msb, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.max, remainder:         0), error: true))
            //=----------------------------------=
            Test().division(X(low:  1 as M, high:  0 as T), -2 as T, F(D(quotient:  0,     remainder:  1)))
            Test().division(X(low: ~0 as M, high: -1 as T),  2 as T, F(D(quotient:  0,     remainder: -1)))
            Test().division(X(low:  7 as M, high:  0 as T),  0 as T, nil)
            Test().division(X(low:  7 as M, high: -1 as T),  0 as T, nil)
            Test().division(X(low: ~M .msb, high:  0 as T), -1 as T, F(D(quotient: -T.max, remainder:  0)))
            Test().division(X(low:  M .msb, high: -1 as T), -1 as T, F(D(quotient:  T.min, remainder:  0), error: true))
            //=----------------------------------=
            Test().division(X(low:  0 as M, high: ~0 as T),  0 as T, nil)
            Test().division(X(low:  0 as M, high: ~0 as T),  1 as T, F(D(quotient: (~0 as T) << (size - 0), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  2 as T, F(D(quotient: (~0 as T) << (size - 1), remainder: 0)))
            Test().division(X(low:  0 as M, high: ~0 as T),  4 as T, F(D(quotient: (~0 as T) << (size - 2), remainder: 0)))
            Test().division(X(low:  0 as M, high: ~0 as T),  8 as T, F(D(quotient: (~0 as T) << (size - 3), remainder: 0)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias F = Fallible<D>
            typealias X = Doublet<T>
            //=----------------------------------=
            let size = IX(size: T.self)
            //=----------------------------------=
            Test().division(X(low:  1 as M, high: ~1 as T), ~0 as T, F(D(quotient: (~0 as T), remainder: ( 0 as T))))
            Test().division(X(low: ~0 as M, high: ~1 as T), ~0 as T, F(D(quotient: (~0 as T), remainder: (~1 as T))))
            //=----------------------------------=
            Test().division(X(low:  7 as M, high:  0 as T),  0 as T, nil)
            Test().division(X(low:  7 as M, high: ~0 as T),  0 as T, nil)
            Test().division(X(low:  0 as M, high: ~0 as T), ~0 as T, F(D(quotient: ( 0 as T), remainder: ( 0 as T)), error: true))
            Test().division(X(low: ~0 as M, high: ~1 as T), ~0 as T, F(D(quotient: (~0 as T), remainder: (~1 as T))))
            //=----------------------------------=
            Test().division(X(low:  0 as M, high: ~0 as T),  0 as T, nil)
            Test().division(X(low:  0 as M, high: ~0 as T),  1 as T, F(D(quotient: (~0 as T) << (size - 0), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  2 as T, F(D(quotient: (~0 as T) << (size - 1), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  4 as T, F(D(quotient: (~0 as T) << (size - 2), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  8 as T, F(D(quotient: (~0 as T) << (size - 3), remainder: 0), error: true))
        }
        
        for type in Self.typesWhereIsSigned {
            whereIsSigned(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
}
