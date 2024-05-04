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
// MARK: * Infini Int x Validation
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIntegers() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).exactlyCoreSystemsIntegers()
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: UnsignedInteger {
            IntegerInvariants(T.self).clampingCoreSystemsIntegers()
        }
        
        for type in Self.types {
            whereIs(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
    
    func testIntegerLiterals() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias F = Fallible<T>
            Test().same(T.exactly(-0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), F(~0 << 128 + 1, error: !T.isSigned))
            Test().same(T.exactly(-0x80000000000000000000000000000001), F(~0 << 127 - 1, error: !T.isSigned))
            Test().same(T.exactly(-0x80000000000000000000000000000000), F(~0 << 127,     error: !T.isSigned))
            Test().same(T.exactly( 0x00000000000000000000000000000000), F(T.zero))
            Test().same(T.exactly( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), F( 1 << 127 - 1))
            Test().same(T.exactly( 0x80000000000000000000000000000000), F( 1 << 127    ))
            Test().same(T.exactly( 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), F( 1 << 128 - 1))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
