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
// MARK: * Core Int x Shift
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpshift() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().upshift( 1 as T,  0 as T,  1 as T)
            Test().upshift( 1 as T,  1 as T,  2 as T)
            Test().upshift( 1 as T,  2 as T,  4 as T)
            Test().upshift( 1 as T,  3 as T,  8 as T)
            
            Test().upshift( 1 as T,  T .min,  T(           Bit(!T.isSigned)))
            Test().upshift(~0 as T,  T .min,  T(repeating: Bit.one ))
            Test().upshift( 1 as T,  T .max,  T(repeating: Bit.zero))
            Test().upshift(~0 as T,  T .max,  T(repeating: Bit.zero))
            
            Test().upshift( 1 as T, ~T .msb,  T(repeating: Bit.zero))
            Test().upshift(~0 as T, ~T .msb,  T(repeating: Bit.zero))
            Test().upshift( 1 as T,  T .msb,  T(repeating: Bit.zero))
            Test().upshift(~0 as T,  T .msb,  T(repeating: Bit( T.isSigned)))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testDownshift() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().downshift( 8 as T,  0 as T,  8 as T)
            Test().downshift( 8 as T,  1 as T,  4 as T)
            Test().downshift( 8 as T,  2 as T,  2 as T)
            Test().downshift( 8 as T,  3 as T,  1 as T)
            
            Test().downshift( 1 as T,  T .min,  T(           Bit(!T.isSigned)))
            Test().downshift(~0 as T,  T .min,  T(repeating: Bit(!T.isSigned)))
            Test().downshift( 1 as T,  T .max,  T(repeating: Bit.zero))
            Test().downshift(~0 as T,  T .max,  T(repeating: Bit( T.isSigned)))
            
            Test().downshift( 1 as T, ~T .msb,  T(repeating: Bit.zero))
            Test().downshift(~0 as T, ~T .msb,  T(repeating: Bit( T.isSigned)))
            Test().downshift( 1 as T,  T .msb,  T(repeating: Bit.zero))
            Test().downshift(~0 as T,  T .msb,  T(repeating: Bit.zero))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
