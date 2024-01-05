//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit
import UMNTestKit
import XCTest

//*============================================================================*
// MARK: * Bit Int x Comparison
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.comparison( 0 as T,  0 as T,  0 as Signum)
            Test.comparison(-1 as T,  0 as T, -1 as Signum)
            Test.comparison( 0 as T, -1 as T,  1 as Signum)
            Test.comparison(-1 as T, -1 as T,  0 as Signum)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.comparison( 0 as T,  0 as T,  0 as Signum)
            Test.comparison( 1 as T,  0 as T,  1 as Signum)
            Test.comparison( 0 as T,  1 as T, -1 as Signum)
            Test.comparison( 1 as T,  1 as T,  0 as Signum)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
