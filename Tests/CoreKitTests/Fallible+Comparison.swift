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
// MARK: * Fallible x Multiplication
//*============================================================================*

extension FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8 {
                    let equal = lhs == rhs
                    success &+= U32(Bit((lhs.veto(false) == rhs.veto(false)) == equal))
                    success &+= U32(Bit((lhs.veto(false) == rhs.veto(true )) == false))
                    success &+= U32(Bit((lhs.veto(true ) == rhs.veto(false)) == false))
                    success &+= U32(Bit((lhs.veto(true ) == rhs.veto(true )) == equal))
                }
            }
            
            Test().same(success, 4 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
}
