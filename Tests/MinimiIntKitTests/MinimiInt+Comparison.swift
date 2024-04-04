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
// MARK: * Minimi Int x Comparison
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison(-1 as T,  0 as T, -1 as Signum)
            Test().comparison( 0 as T, -1 as T,  1 as Signum)
            Test().comparison(-1 as T, -1 as T,  0 as Signum)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison( 1 as T,  0 as T,  1 as Signum)
            Test().comparison( 0 as T,  1 as T, -1 as Signum)
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
        }
        
        for type in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
