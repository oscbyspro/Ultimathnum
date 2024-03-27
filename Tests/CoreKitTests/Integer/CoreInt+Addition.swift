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
// MARK: * Core Int x Addition
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.addition( 0 as T,  0 as T,  0 as T)
            Test.addition(-1 as T,  0 as T, -1 as T)
            Test.addition( 0 as T, -1 as T, -1 as T)
            Test.addition(-1 as T, -1 as T, -2 as T)
                        
            Test.addition( T .min,  T .min,  0 as T, true)
            Test.addition( T .max,  T .min, -1 as T)
            Test.addition( T .min,  T .max, -1 as T)
            Test.addition( T .max,  T .max, -2 as T, true)
            
            Test.addition( T .min, -1 as T,  T .max, true)
            Test.addition( T .min,  0 as T,  T .min)
            Test.addition( T .min,  1 as T,  T .min + 1)
            Test.addition( T .max, -1 as T,  T .max - 1)
            Test.addition( T .max,  0 as T,  T .max)
            Test.addition( T .max,  1 as T,  T .min, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.addition( 0 as T,  0 as T,  0 as T)
            Test.addition( 1 as T,  0 as T,  1 as T)
            Test.addition( 0 as T,  1 as T,  1 as T)
            Test.addition( 1 as T,  1 as T,  2 as T)
                        
            Test.addition( T .min,  T .min,  T .min)
            Test.addition( T .max,  T .min,  T .max)
            Test.addition( T .min,  T .max,  T .max)
            Test.addition( T .max,  T .max,  T .max - 1, true)
            
            Test.addition( T .min,  0 as T,  T .min)
            Test.addition( T .min,  1 as T,  T .min + 1)
            Test.addition( T .max,  0 as T,  T .max)
            Test.addition( T .max,  1 as T,  T .min, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
