//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import BitIntKit
import CoreKit
import TestKit

//*============================================================================*
// MARK: * Bit Int x Addition
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.addition( 0,  0,  0 as T)
            Test.addition(-1,  0, -1 as T)
            Test.addition( 0, -1, -1 as T)
            Test.addition(-1, -1,  0 as T, true)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.addition( 0,  0,  0 as T)
            Test.addition( 1,  0,  1 as T)
            Test.addition( 0,  1,  1 as T)
            Test.addition( 1,  1,  0 as T, true)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
