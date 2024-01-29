//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
            Test.subtraction( 0 as T,  0 as T,  0 as T)
            Test.subtraction( 0 as T,  1 as T, ~0 as T)
            Test.subtraction( 0 as T, -1 as T,  1 as T)
            
            Test.subtraction( 0 as T,  T .max,  T .min + 1)
            Test.subtraction( 0 as T,  T .min,  T .min + 0, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.subtraction( 0 as T,  0 as T,  0 as T)
            Test.subtraction( 0 as T,  1 as T, ~0 as T, true)
            Test.subtraction( 0 as T,  2 as T, ~1 as T, true)
            
            Test.subtraction( 0 as T,  T .min,  T .min + 0)
            Test.subtraction( 0 as T,  T .max,  T .min + 1, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtraction() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.subtraction( 0 as T,  0 as T,  0 as T)
            Test.subtraction(-1 as T,  0 as T, -1 as T)
            Test.subtraction( 0 as T, -1 as T,  1 as T)
            Test.subtraction(-1 as T, -1 as T,  0 as T)
            
            Test.subtraction( T .min,  T .min,  0 as T)
            Test.subtraction( T .max,  T .min, -1 as T, true)
            Test.subtraction( T .min,  T .max,  1 as T, true)
            Test.subtraction( T .max,  T .max,  0 as T)

            Test.subtraction( T .max,  1 as T,  T .max - 1)
            Test.subtraction( T .max,  0 as T,  T .max)
            Test.subtraction( T .max, -1 as T,  T .min, true)
            Test.subtraction( T .min,  1 as T,  T .max, true)
            Test.subtraction( T .min,  0 as T,  T .min)
            Test.subtraction( T .min, -1 as T,  T .min + 1)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.subtraction( 0 as T,  0 as T,  0 as T)
            Test.subtraction( 1 as T,  0 as T,  1 as T)
            Test.subtraction( 0 as T,  1 as T, ~0 as T, true)
            Test.subtraction( 1 as T,  1 as T,  0 as T)
            
            Test.subtraction( T .min,  T .min,  T .min)
            Test.subtraction( T .max,  T .min,  T .max)
            Test.subtraction( T .min,  T .max,  1 as T, true)
            Test.subtraction( T .max,  T .max,  T .min)
            
            Test.subtraction( T .min,  2 as T,  T .max - 1, true)
            Test.subtraction( T .min,  1 as T,  T .max - 0, true)
            Test.subtraction( T .min,  0 as T,  T .min - 0)
            Test.subtraction( T .max,  2 as T,  T .max - 2)
            Test.subtraction( T .max,  1 as T,  T .max - 1)
            Test.subtraction( T .max,  0 as T,  T .max - 0)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
