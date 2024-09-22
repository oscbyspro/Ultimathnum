//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Literals
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLiteralInt() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().same(T.exactly(-0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF as LiteralInt), Fallible((~0 as T) << 128 + 1, error: !T.isSigned))
            Test().same(T.exactly(-0x80000000000000000000000000000001 as LiteralInt), Fallible((~0 as T) << 127 - 1, error: !T.isSigned))
            Test().same(T.exactly(-0x80000000000000000000000000000000 as LiteralInt), Fallible((~0 as T) << 127,     error: !T.isSigned))
            Test().same(T.exactly( 0x00000000000000000000000000000000 as LiteralInt), Fallible(T.zero))
            Test().same(T.exactly( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF as LiteralInt), Fallible(( 1 as T) << 127 - 1))
            Test().same(T.exactly( 0x80000000000000000000000000000000 as LiteralInt), Fallible(( 1 as T) << 127    ))
            Test().same(T.exactly( 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF as LiteralInt), Fallible(( 1 as T) << 128 - 1))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
