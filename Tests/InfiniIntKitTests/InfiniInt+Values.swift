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
// MARK: * Infini Int x Values
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testValues() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: UnsignedInteger {
            IntegerInvariants(T.self).edgesMinMax()
        }
        
        for type in Self.types {
            whereIs(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
}
