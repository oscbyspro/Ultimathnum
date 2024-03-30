//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MinimiIntKit
import TestKit

//*============================================================================*
// MARK: * Minimi Int
//*============================================================================*

final class MinimiIntTests: XCTestCase {
    
    typealias I = any (SystemsInteger &   SignedInteger).Type
    typealias U = any (SystemsInteger & UnsignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let types: [any SystemsInteger.Type] = [
        I1.self,
        U1.self,
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
            Test().same(T.min, T.isSigned ? -1 : 0)
            Test().same(T.max, T.isSigned ?  0 : 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLsbMsb() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T.lsb, T.isSigned ? -1 : 1)
            Test().same(T.msb, T.isSigned ? -1 : 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
