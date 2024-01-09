//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit
import XCTest

//*============================================================================*
// MARK: * Main Int x Division
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            Test.division( 7 as T,  3 as T,  2 as T,  1 as T)
            Test.division( 7 as T, -3 as T, -2 as T,  1 as T)
            Test.division(-7 as T,  3 as T, -2 as T, -1 as T)
            Test.division(-7 as T, -3 as T,  2 as T, -1 as T)
            
            Test.division(-2 as T,  0 as T, -2 as T, -2 as T, true)
            Test.division(-1 as T,  0 as T, -1 as T, -1 as T, true)
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, true)
            Test.division( 1 as T,  0 as T,  1 as T,  1 as T, true)
            
            Test.division( T .min, -2 as T,  T(bitPattern: M.msb >> 1 + 0),  0 as T)
            Test.division( T .min, -1 as T,  T(bitPattern: M.msb >> 0 + 0),  0 as T, true)
            Test.division( T .min,  0 as T,  T(bitPattern: M.msb >> 0 + 0),  T .min, true)
            Test.division( T .min,  1 as T,  T(bitPattern: M.msb >> 0 + 0),  0 as T)
            
            Test.division( T .max, -2 as T,  T(bitPattern: T.min >> 1 + 1),  1 as T)
            Test.division( T .max, -1 as T,  T(bitPattern: T.min +  1 + 0),  0 as T)
            Test.division( T .max,  0 as T,  T(bitPattern: T.max >> 0 + 0),  T .max, true)
            Test.division( T .max,  1 as T,  T(bitPattern: T.max >> 0 + 0),  0 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.division( 7 as T,  0 as T,  7 as T,  7 as T, true)
            Test.division( 7 as T,  1 as T,  7 as T,  0 as T)
            Test.division( 7 as T,  2 as T,  3 as T,  1 as T)
            Test.division( 7 as T,  3 as T,  2 as T,  1 as T)
            
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, true)
            Test.division( 1 as T,  0 as T,  1 as T,  1 as T, true)
            Test.division( 2 as T,  0 as T,  2 as T,  2 as T, true)
            Test.division( 3 as T,  0 as T,  3 as T,  3 as T, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision21() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            typealias F = FullWidth<T, M>
            //=----------------------------------=
            Test.division(F(low:  1 as M, high:  T .max >> 1 + 0),  T .max,  T .max,      0 as T    )
            Test.division(F(low: ~M .msb, high:  T .max >> 1 + 0),  T .max,  T .max,      T .max - 1)
            Test.division(F(low:  0 as M, high:  T .max >> 1 + 1),  T .min,  T .min,      0 as T    )
            Test.division(F(low: ~M .msb, high:  T .max >> 1 + 1),  T .min,  T .min,      T .max - 0)
            //=----------------------------------=
            Test.division(F(low:  1 as M, high:  0 as T         ), -2 as T,  0 as T,      1 as T)
            Test.division(F(low: ~0 as M, high: -1 as T         ),  2 as T,  0 as T,     -1 as T)
            Test.division(F(low:  7 as M, high:  0 as T         ),  0 as T,  7 as T,      7 as T, true)
            Test.division(F(low:  7 as M, high: -1 as T         ),  0 as T,  7 as T,      7 as T, true)
            Test.division(F(low: ~M .msb, high:  0 as T         ), -1 as T,  T .min + 1,  0 as T)
            Test.division(F(low:  M .msb, high: -1 as T         ), -1 as T,  T .min + 0,  0 as T, true)
            Test.division(F(low: ~M .msb, high:  T .max >> 1 + 0),  T .max,  T .max,      T .max  -  1)
            Test.division(F(low:  M .msb, high:  T .max >> 1 + 0),  T .max,  T .min,      0 as T, true)
            Test.division(F(low: ~M .msb, high:  T .max >> 1 + 1),  T .min,  T .min,      T .max  -  0)
            Test.division(F(low:  M .msb, high:  T .max >> 1 + 1),  T .min,  T .max,      0 as T, true)
            //=----------------------------------=
            Test.division(F(low:  0 as M, high: ~0 as T),  0 as T, ~0 << T(bitPattern: T.bitWidth - 0),  0 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T),  1 as T, ~0 << T(bitPattern: T.bitWidth - 0),  0 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T),  2 as T, ~0 << T(bitPattern: T.bitWidth - 1),  0 as T)
            Test.division(F(low:  0 as M, high: ~0 as T),  4 as T, ~0 << T(bitPattern: T.bitWidth - 2),  0 as T)
            Test.division(F(low:  0 as M, high: ~0 as T),  8 as T, ~0 << T(bitPattern: T.bitWidth - 3),  0 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            typealias F = FullWidth<T, M>
            //=----------------------------------=
            Test.division(F(low:  1 as M, high: ~1 as T), ~0 as T, ~0 as T,  0 as T)
            Test.division(F(low: ~0 as M, high: ~1 as T), ~0 as T, ~0 as T, ~1 as T)
            //=----------------------------------=
            Test.division(F(low:  7 as M, high:  0 as T),  0 as T,  7 as T,  7 as T, true)
            Test.division(F(low:  7 as M, high: ~0 as T),  0 as T,  7 as T,  7 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T), ~0 as T,  0 as T,  0 as T, true)
            Test.division(F(low: ~0 as M, high: ~1 as T), ~0 as T, ~0 as T, ~1 as T)
            //=----------------------------------=
            Test.division(F(low:  0 as M, high: ~0 as T),  0 as T, ~0 << T(bitPattern: T.bitWidth - 0),  0 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T),  1 as T, ~0 << T(bitPattern: T.bitWidth - 0),  0 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T),  2 as T, ~0 << T(bitPattern: T.bitWidth - 1),  0 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T),  4 as T, ~0 << T(bitPattern: T.bitWidth - 2),  0 as T, true)
            Test.division(F(low:  0 as M, high: ~0 as T),  8 as T, ~0 << T(bitPattern: T.bitWidth - 3),  0 as T, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
