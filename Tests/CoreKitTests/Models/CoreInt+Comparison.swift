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
// MARK: * Core Int x Comparison
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison(-1 as T,  0 as T, -1 as Signum)
            Test().comparison( 0 as T, -1 as T,  1 as Signum)
            Test().comparison(-1 as T, -1 as T,  0 as Signum)
            
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison(-0 as T,  0 as T,  0 as Signum)
            Test().comparison( 0 as T, -0 as T,  0 as Signum)
            Test().comparison(-0 as T, -0 as T,  0 as Signum)
            
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
            Test().comparison(-1 as T,  1 as T, -1 as Signum)
            Test().comparison( 1 as T, -1 as T,  1 as Signum)
            Test().comparison(-1 as T, -1 as T,  0 as Signum)
            
            Test().comparison( 2 as T,  3 as T, -1 as Signum)
            Test().comparison(-2 as T,  3 as T, -1 as Signum)
            Test().comparison( 2 as T, -3 as T,  1 as Signum)
            Test().comparison(-2 as T, -3 as T,  1 as Signum)
            
            Test().comparison( 3 as T,  2 as T,  1 as Signum)
            Test().comparison(-3 as T,  2 as T, -1 as Signum)
            Test().comparison( 3 as T, -2 as T,  1 as Signum)
            Test().comparison(-3 as T, -2 as T, -1 as Signum)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison( 1 as T,  0 as T,  1 as Signum)
            Test().comparison( 0 as T,  1 as T, -1 as Signum)
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
            
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
            Test().comparison( 2 as T,  3 as T, -1 as Signum)
            Test().comparison( 3 as T,  2 as T,  1 as Signum)
        }
        
        for type in coreSystemsIntegers {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
