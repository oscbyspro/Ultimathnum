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
// MARK: * Core Int x Subtraction
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 0 as T,  1 as T, F(~0 as T))
            Test().subtraction( 0 as T, -1 as T, F( 1 as T))
            
            Test().subtraction( 0 as T,  T .max, F( T .min + 1))
            Test().subtraction( 0 as T,  T .min, F( T .min + 0, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 0 as T,  1 as T, F(~0 as T, error: true))
            Test().subtraction( 0 as T,  2 as T, F(~1 as T, error: true))
            
            Test().subtraction( 0 as T,  T .min, F( T .min + 0))
            Test().subtraction( 0 as T,  T .max, F( T .min + 1, error: true))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtraction() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction(-1 as T,  0 as T, F(-1 as T))
            Test().subtraction( 0 as T, -1 as T, F( 1 as T))
            Test().subtraction(-1 as T, -1 as T, F( 0 as T))
            
            Test().subtraction( T .min,  T .min, F( 0 as T))
            Test().subtraction( T .max,  T .min, F(-1 as T, error: true))
            Test().subtraction( T .min,  T .max, F( 1 as T, error: true))
            Test().subtraction( T .max,  T .max, F( 0 as T))

            Test().subtraction( T .max,  1 as T, F( T .max - 1))
            Test().subtraction( T .max,  0 as T, F( T .max))
            Test().subtraction( T .max, -1 as T, F( T .min, error: true))
            Test().subtraction( T .min,  1 as T, F( T .max, error: true))
            Test().subtraction( T .min,  0 as T, F( T .min))
            Test().subtraction( T .min, -1 as T, F( T .min + 1))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 1 as T,  0 as T, F( 1 as T))
            Test().subtraction( 0 as T,  1 as T, F(~0 as T, error: true))
            Test().subtraction( 1 as T,  1 as T, F( 0 as T))
            
            Test().subtraction( T .min,  T .min, F( T .min))
            Test().subtraction( T .max,  T .min, F( T .max))
            Test().subtraction( T .min,  T .max, F( 1 as T, error: true))
            Test().subtraction( T .max,  T .max, F( T .min))
            
            Test().subtraction( T .min,  2 as T, F( T .max - 1, error: true))
            Test().subtraction( T .min,  1 as T, F( T .max - 0, error: true))
            Test().subtraction( T .min,  0 as T, F( T .min - 0))
            Test().subtraction( T .max,  2 as T, F( T .max - 2))
            Test().subtraction( T .max,  1 as T, F( T .max - 1))
            Test().subtraction( T .max,  0 as T, F( T .max - 0))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
