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
// MARK: * Minimi Int x Addition
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.addition( 0 as T,  0 as T,  0 as T)
            Test.addition(-1 as T,  0 as T, -1 as T)
            Test.addition( 0 as T, -1 as T, -1 as T)
            Test.addition(-1 as T, -1 as T,  0 as T, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.addition( 0 as T,  0 as T,  0 as T)
            Test.addition( 1 as T,  0 as T,  1 as T)
            Test.addition( 0 as T,  1 as T,  1 as T)
            Test.addition( 1 as T,  1 as T,  0 as T, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testIncrementation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.incrementation(-1 as T,  0 as T)
            Test.incrementation( 0 as T, -1 as T, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.incrementation( 0 as T,  1 as T)
            Test.incrementation( 1 as T,  0 as T, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
