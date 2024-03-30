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
    
    func testDivision() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias F = Fallible<Division<T, T>>
            
            Test.division( 7 as T,  3 as T, F(D(quotient:  2, remainder:  1)))
            Test.division( 7 as T, -3 as T, F(D(quotient: -2, remainder:  1)))
            Test.division(-7 as T,  3 as T, F(D(quotient: -2, remainder: -1)))
            Test.division(-7 as T, -3 as T, F(D(quotient:  2, remainder: -1)))
            
            Test.division(-2 as T,  0 as T, F(D(quotient:  0, remainder: -2), error: true))
            Test.division(-1 as T,  0 as T, F(D(quotient:  0, remainder: -1), error: true))
            Test.division( 0 as T,  0 as T, F(D(quotient:  0, remainder:  0), error: true))
            Test.division( 1 as T,  0 as T, F(D(quotient:  0, remainder:  1), error: true))
            
            Test.division( T .min, -2 as T, F(D(quotient:  T(bitPattern: M.msb >> 1 + 0), remainder: 0)))
            Test.division( T .min, -1 as T, F(D(quotient:  T.min, remainder: T(  )), error: true))
            Test.division( T .min,  0 as T, F(D(quotient:  T(  ), remainder: T.min), error: true))
            Test.division( T .min,  1 as T, F(D(quotient:  T(bitPattern: M.msb >> 0 + 0), remainder: 0)))
            
            Test.division( T .max, -2 as T, F(D(quotient:  T(bitPattern: T.min >> 1 + 1), remainder: 1)))
            Test.division( T .max, -1 as T, F(D(quotient:  T(bitPattern: T.min +  1 + 0), remainder: 0)))
            Test.division( T .max,  0 as T, F(D(quotient:  T(  ), remainder: T.max), error: true))
            Test.division( T .max,  1 as T, F(D(quotient:  T(bitPattern: T.max >> 0 + 0), remainder: 0)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias D = Division<T, T>
            typealias F = Fallible<Division<T, T>>
            
            Test.division( 7 as T,  0 as T, F(D(quotient:  0, remainder:  7), error: true))
            Test.division( 7 as T,  1 as T, F(D(quotient:  7, remainder:  0)))
            Test.division( 7 as T,  2 as T, F(D(quotient:  3, remainder:  1)))
            Test.division( 7 as T,  3 as T, F(D(quotient:  2, remainder:  1)))
            
            Test.division( 0 as T,  0 as T, F(D(quotient:  0, remainder:  0), error: true))
            Test.division( 1 as T,  0 as T, F(D(quotient:  0, remainder:  1), error: true))
            Test.division( 2 as T,  0 as T, F(D(quotient:  0, remainder:  2), error: true))
            Test.division( 3 as T,  0 as T, F(D(quotient:  0, remainder:  3), error: true))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision2111() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias X = DoubleIntLayout<T>
            typealias F = Fallible<Division<T, T>>
            //=----------------------------------=
            Test.division2111(X(low:  1 as M, high:  T .max >> 1    ), T.max, F(D(quotient: T.max, remainder:         0)))
            Test.division2111(X(low: ~M .msb, high:  T .max >> 1    ), T.max, F(D(quotient: T.max, remainder: T.max - 1)))
            Test.division2111(X(low:  M .msb, high:  T .max >> 1    ), T.max, F(D(quotient: T.min, remainder:         0), error: true))
            Test.division2111(X(low:  0 as M, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.min, remainder:         0)))
            Test.division2111(X(low: ~M .msb, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.min, remainder: T.max - 0)))
            Test.division2111(X(low:  M .msb, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.max, remainder:         0), error: true))
            //=----------------------------------=
            Test.division2111(X(low:  1 as M, high:  0 as T), -2 as T, F(D(quotient:  0,     remainder:  1)))
            Test.division2111(X(low: ~0 as M, high: -1 as T),  2 as T, F(D(quotient:  0,     remainder: -1)))
            Test.division2111(X(low:  7 as M, high:  0 as T),  0 as T, F(D(quotient:  0,     remainder:  7), error: true))
            Test.division2111(X(low:  7 as M, high: -1 as T),  0 as T, F(D(quotient:  0,     remainder:  7), error: true))
            Test.division2111(X(low: ~M .msb, high:  0 as T), -1 as T, F(D(quotient: -T.max, remainder:  0)))
            Test.division2111(X(low:  M .msb, high: -1 as T), -1 as T, F(D(quotient:  T.min, remainder:  0), error: true))
            //=----------------------------------=
            Test.division2111(X(low:  0 as M, high: ~0 as T),  0 as T, F(D(quotient:  0,                                  remainder: 0), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  1 as T, F(D(quotient:  0,                                  remainder: 0), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  2 as T, F(D(quotient: ~0 << T(bitPattern: T.bitWidth - 1), remainder: 0)))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  4 as T, F(D(quotient: ~0 << T(bitPattern: T.bitWidth - 2), remainder: 0)))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  8 as T, F(D(quotient: ~0 << T(bitPattern: T.bitWidth - 3), remainder: 0)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias X = DoubleIntLayout<T>
            typealias F = Fallible<Division<T, T>>
            //=----------------------------------=
            Test.division2111(X(low:  1 as M, high: ~1 as T), ~0 as T, F(D(quotient: ~0, remainder:  0)))
            Test.division2111(X(low: ~0 as M, high: ~1 as T), ~0 as T, F(D(quotient: ~0, remainder: ~1)))
            //=----------------------------------=
            Test.division2111(X(low:  7 as M, high:  0 as T),  0 as T, F(D(quotient:  0, remainder:  7), error: true))
            Test.division2111(X(low:  7 as M, high: ~0 as T),  0 as T, F(D(quotient:  0, remainder:  7), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T), ~0 as T, F(D(quotient:  0, remainder:  0), error: true))
            Test.division2111(X(low: ~0 as M, high: ~1 as T), ~0 as T, F(D(quotient: ~0, remainder: ~1)))
            //=----------------------------------=
            Test.division2111(X(low:  0 as M, high: ~0 as T),  0 as T, F(D(quotient:  0,                                  remainder:  0), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  1 as T, F(D(quotient:  0,                                  remainder:  0), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  2 as T, F(D(quotient: ~0 << T(bitPattern: T.bitWidth - 1), remainder:  0), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  4 as T, F(D(quotient: ~0 << T(bitPattern: T.bitWidth - 2), remainder:  0), error: true))
            Test.division2111(X(low:  0 as M, high: ~0 as T),  8 as T, F(D(quotient: ~0 << T(bitPattern: T.bitWidth - 3), remainder:  0), error: true))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
