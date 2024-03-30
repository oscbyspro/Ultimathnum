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
// MARK: * Core Int
//*============================================================================*

final class CoreIntTests: XCTestCase {
    
    typealias I = any (SystemsInteger &   SignedInteger).Type
    typealias U = any (SystemsInteger & UnsignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let types: [any SystemsInteger.Type] = [
        IX.self, I8.self, I16.self, I32.self, I64.self,
        UX.self, U8.self, U16.self, U32.self, U64.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test.invariants(type, identifier: SystemsIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testMinMax() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T.min, T.isSigned ?  T.msb :  0)
            Test().same(T.max, T.isSigned ? ~T.msb : ~0)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLsbMsb() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T.lsb.count(1, option: .ascending ), 1)
            Test().same(T.lsb.count(0, option: .descending), T.bitWidth - 1)
            Test().same(T.msb.count(0, option: .ascending ), T.bitWidth - 1)
            Test().same(T.msb.count(1, option: .descending), 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
