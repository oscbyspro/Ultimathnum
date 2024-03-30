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
            typealias F = Fallible<T>
            
            Test().addition( 0 as T,  0 as T, F( 0 as T))
            Test().addition(-1 as T,  0 as T, F(-1 as T))
            Test().addition( 0 as T, -1 as T, F(-1 as T))
            Test().addition(-1 as T, -1 as T, F(-2 as T))
                        
            Test().addition( T .min,  T .min, F( 0 as T, error: true))
            Test().addition( T .max,  T .min, F(-1 as T))
            Test().addition( T .min,  T .max, F(-1 as T))
            Test().addition( T .max,  T .max, F(-2 as T, error: true))
            
            Test().addition( T .min, -1 as T, F( T .max, error: true))
            Test().addition( T .min,  0 as T, F( T .min))
            Test().addition( T .min,  1 as T, F( T .min + 1))
            Test().addition( T .max, -1 as T, F( T .max - 1))
            Test().addition( T .max,  0 as T, F( T .max))
            Test().addition( T .max,  1 as T, F( T .min, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().addition( 0 as T,  0 as T, F( 0 as T))
            Test().addition( 1 as T,  0 as T, F( 1 as T))
            Test().addition( 0 as T,  1 as T, F( 1 as T))
            Test().addition( 1 as T,  1 as T, F( 2 as T))
                        
            Test().addition( T .min,  T .min, F( T .min))
            Test().addition( T .max,  T .min, F( T .max))
            Test().addition( T .min,  T .max, F( T .max))
            Test().addition( T .max,  T .max, F( T .max - 1, error: true))
            
            Test().addition( T .min,  0 as T, F( T .min))
            Test().addition( T .min,  1 as T, F( T .min + 1))
            Test().addition( T .max,  0 as T, F( T .max))
            Test().addition( T .max,  1 as T, F( T .min, error: true))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
