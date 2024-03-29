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
            typealias M  = T.Magnitude
            typealias QR = Division<T, T>
            
            Test.division( 7 as T,  3 as T, QR(quotient:  2, remainder:  1))
            Test.division( 7 as T, -3 as T, QR(quotient: -2, remainder:  1))
            Test.division(-7 as T,  3 as T, QR(quotient: -2, remainder: -1))
            Test.division(-7 as T, -3 as T, QR(quotient:  2, remainder: -1))
            
            Test.division(-2 as T,  0 as T, QR(quotient:  0, remainder: -2), true)
            Test.division(-1 as T,  0 as T, QR(quotient:  0, remainder: -1), true)
            Test.division( 0 as T,  0 as T, QR(quotient:  0, remainder:  0), true)
            Test.division( 1 as T,  0 as T, QR(quotient:  0, remainder:  1), true)
            
            Test.division( T .min, -2 as T, QR(quotient:  T(bitPattern: M.msb >> 1 + 0), remainder: 0))
            Test.division( T .min, -1 as T, QR(quotient:  T.min, remainder: T(  )), true)
            Test.division( T .min,  0 as T, QR(quotient:  T(  ), remainder: T.min), true)
            Test.division( T .min,  1 as T, QR(quotient:  T(bitPattern: M.msb >> 0 + 0), remainder: 0))
            
            Test.division( T .max, -2 as T, QR(quotient:  T(bitPattern: T.min >> 1 + 1), remainder: 1))
            Test.division( T .max, -1 as T, QR(quotient:  T(bitPattern: T.min +  1 + 0), remainder: 0))
            Test.division( T .max,  0 as T, QR(quotient:  T(  ), remainder: T.max), true)
            Test.division( T .max,  1 as T, QR(quotient:  T(bitPattern: T.max >> 0 + 0), remainder: 0))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias QR = Division<T, T>
            
            Test.division( 7 as T,  0 as T, QR(quotient:  0, remainder:  7), true)
            Test.division( 7 as T,  1 as T, QR(quotient:  7, remainder:  0))
            Test.division( 7 as T,  2 as T, QR(quotient:  3, remainder:  1))
            Test.division( 7 as T,  3 as T, QR(quotient:  2, remainder:  1))
            
            Test.division( 0 as T,  0 as T, QR(quotient:  0, remainder:  0), true)
            Test.division( 1 as T,  0 as T, QR(quotient:  0, remainder:  1), true)
            Test.division( 2 as T,  0 as T, QR(quotient:  0, remainder:  2), true)
            Test.division( 3 as T,  0 as T, QR(quotient:  0, remainder:  3), true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision2111() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias QR = Division<T, T>
            typealias X2 = DoubleIntLayout<T>
            //=----------------------------------=
            Test.division2111(X2(low:  1 as M, high:  T .max >> 1    ), T.max, QR(quotient: T.max, remainder:         0))
            Test.division2111(X2(low: ~M .msb, high:  T .max >> 1    ), T.max, QR(quotient: T.max, remainder: T.max - 1))
            Test.division2111(X2(low:  M .msb, high:  T .max >> 1    ), T.max, QR(quotient: T.min, remainder:         0), true)
            Test.division2111(X2(low:  0 as M, high:  T .max >> 1 + 1), T.min, QR(quotient: T.min, remainder:         0))
            Test.division2111(X2(low: ~M .msb, high:  T .max >> 1 + 1), T.min, QR(quotient: T.min, remainder: T.max - 0))
            Test.division2111(X2(low:  M .msb, high:  T .max >> 1 + 1), T.min, QR(quotient: T.max, remainder:         0), true)
            //=----------------------------------=
            Test.division2111(X2(low:  1 as M, high:  0 as T), -2 as T, QR(quotient:  0,     remainder:  1))
            Test.division2111(X2(low: ~0 as M, high: -1 as T),  2 as T, QR(quotient:  0,     remainder: -1))
            Test.division2111(X2(low:  7 as M, high:  0 as T),  0 as T, QR(quotient:  0,     remainder:  7), true)
            Test.division2111(X2(low:  7 as M, high: -1 as T),  0 as T, QR(quotient:  0,     remainder:  7), true)
            Test.division2111(X2(low: ~M .msb, high:  0 as T), -1 as T, QR(quotient: -T.max, remainder:  0))
            Test.division2111(X2(low:  M .msb, high: -1 as T), -1 as T, QR(quotient:  T.min, remainder:  0), true)
            //=----------------------------------=
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  0 as T, QR(quotient:  0,                                  remainder: 0), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  1 as T, QR(quotient:  0,                                  remainder: 0), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  2 as T, QR(quotient: ~0 << T(bitPattern: T.bitWidth - 1), remainder: 0))
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  4 as T, QR(quotient: ~0 << T(bitPattern: T.bitWidth - 2), remainder: 0))
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  8 as T, QR(quotient: ~0 << T(bitPattern: T.bitWidth - 3), remainder: 0))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias QR = Division<T, T>
            typealias X2 = DoubleIntLayout<T>
            //=----------------------------------=
            Test.division2111(X2(low:  1 as M, high: ~1 as T), ~0 as T, QR(quotient: ~0, remainder:  0))
            Test.division2111(X2(low: ~0 as M, high: ~1 as T), ~0 as T, QR(quotient: ~0, remainder: ~1))
            //=----------------------------------=
            Test.division2111(X2(low:  7 as M, high:  0 as T),  0 as T, QR(quotient:  0, remainder:  7), true)
            Test.division2111(X2(low:  7 as M, high: ~0 as T),  0 as T, QR(quotient:  0, remainder:  7), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T), ~0 as T, QR(quotient:  0, remainder:  0), true)
            Test.division2111(X2(low: ~0 as M, high: ~1 as T), ~0 as T, QR(quotient: ~0, remainder: ~1))
            //=----------------------------------=
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  0 as T, QR(quotient:  0,                                  remainder:  0), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  1 as T, QR(quotient:  0,                                  remainder:  0), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  2 as T, QR(quotient: ~0 << T(bitPattern: T.bitWidth - 1), remainder:  0), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  4 as T, QR(quotient: ~0 << T(bitPattern: T.bitWidth - 2), remainder:  0), true)
            Test.division2111(X2(low:  0 as M, high: ~0 as T),  8 as T, QR(quotient: ~0 << T(bitPattern: T.bitWidth - 3), remainder:  0), true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
