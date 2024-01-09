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
// MARK: * Main Int x Multiplication
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            typealias F = FullWidth<T, M>
            //=----------------------------------=
            Test.multiplication( 0 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( 0 as T, -1 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication(-1 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication(-1 as T, -1 as T, F(low:  1 as M,     high:  0 as T))
            //=----------------------------------=
            Test.multiplication( 3 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( 3 as T, -0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication(-3 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication(-3 as T, -0 as T, F(low:  0 as M,     high:  0 as T))
            
            Test.multiplication( 3 as T,  1 as T, F(low:  3 as M,     high:  0 as T))
            Test.multiplication( 3 as T, -1 as T, F(low: ~2 as M,     high: -1 as T))
            Test.multiplication(-3 as T,  1 as T, F(low: ~2 as M,     high: -1 as T))
            Test.multiplication(-3 as T, -1 as T, F(low:  3 as M,     high:  0 as T))
            
            Test.multiplication( 3 as T,  2 as T, F(low:  6 as M,     high:  0 as T))
            Test.multiplication( 3 as T, -2 as T, F(low: ~5 as M,     high: -1 as T))
            Test.multiplication(-3 as T,  2 as T, F(low: ~5 as M,     high: -1 as T))
            Test.multiplication(-3 as T, -2 as T, F(low:  6 as M,     high:  0 as T))
            //=----------------------------------=
            Test.multiplication( T .min,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .min, -0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .max,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .max, -0 as T, F(low:  0 as M,     high:  0 as T))
                        
            Test.multiplication( T .min,  1 as T, F(low:  M .msb,     high: -1 as T))
            Test.multiplication( T .min, -1 as T, F(low:  M .msb,     high:  0 as T), true)
            Test.multiplication( T .max,  1 as T, F(low:  M .msb - 1, high:  0 as T))
            Test.multiplication( T .max, -1 as T, F(low:  M .msb + 1, high: -1 as T))
            
            Test.multiplication( T .min,  2 as T, F(low:  0 as M,     high: -1 as T), true)
            Test.multiplication( T .min, -2 as T, F(low:  0 as M,     high:  1 as T), true)
            Test.multiplication( T .max,  2 as T, F(low: ~1 as M,     high:  0 as T), true)
            Test.multiplication( T .max, -2 as T, F(low:  2 as M,     high: -1 as T), true)
            //=----------------------------------=
            Test.multiplication( T .min,  T .min, F(low:  0 as M,     high:  T .max / 2 + 1), true)
            Test.multiplication( T .min,  T .max, F(low:  M .msb,     high:  T .min / 2    ), true)
            Test.multiplication( T .max,  T .min, F(low:  M .msb,     high:  T .min / 2    ), true)
            Test.multiplication( T .max,  T .max, F(low:  1 as M,     high:  T .max / 2 + 0), true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            typealias F = FullWidth<T, M>
            //=----------------------------------=
            Test.multiplication( 0 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( 0 as T,  1 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( 1 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( 1 as T,  1 as T, F(low:  1 as M,     high:  0 as T))
            //=----------------------------------=
            Test.multiplication( 3 as T,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( 3 as T,  1 as T, F(low:  3 as M,     high:  0 as T))
            Test.multiplication( 3 as T,  2 as T, F(low:  6 as M,     high:  0 as T))
            Test.multiplication( 3 as T,  3 as T, F(low:  9 as M,     high:  0 as T))
            //=----------------------------------=
            Test.multiplication( T .max,  0 as T, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .max,  1 as T, F(low:  M .max,     high:  0 as T))
            Test.multiplication( T .max,  2 as T, F(low: ~1 as M,     high:  1 as T), true)
            Test.multiplication( T .max,  3 as T, F(low: ~2 as M,     high:  2 as T), true)
            //=----------------------------------=
            Test.multiplication( T .min,  T .min, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .min,  T .max, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .max,  T .min, F(low:  0 as M,     high:  0 as T))
            Test.multiplication( T .max,  T .max, F(low:  1 as M,     high: ~1 as T), true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
