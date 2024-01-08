//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import BitIntKit
import CoreKit
import TestKit
import XCTest

//*============================================================================*
// MARK: * Bit Int x Logic
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            Test.not(T.min, T.max)
            Test.not(T.max, T.min)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalAnd() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
                        
            Test.and(T(bitPattern: 0 as M), T(bitPattern: 0 as M), T(bitPattern: 0 as M))
            Test.and(T(bitPattern: 1 as M), T(bitPattern: 0 as M), T(bitPattern: 0 as M))
            Test.and(T(bitPattern: 0 as M), T(bitPattern: 1 as M), T(bitPattern: 0 as M))
            Test.and(T(bitPattern: 1 as M), T(bitPattern: 1 as M), T(bitPattern: 1 as M))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalOr() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            Test.or (T(bitPattern: 0 as M), T(bitPattern: 0 as M), T(bitPattern: 0 as M))
            Test.or (T(bitPattern: 1 as M), T(bitPattern: 0 as M), T(bitPattern: 1 as M))
            Test.or (T(bitPattern: 0 as M), T(bitPattern: 1 as M), T(bitPattern: 1 as M))
            Test.or (T(bitPattern: 1 as M), T(bitPattern: 1 as M), T(bitPattern: 1 as M))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalXor() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            Test.xor(T(bitPattern: 0 as M), T(bitPattern: 0 as M), T(bitPattern: 0 as M))
            Test.xor(T(bitPattern: 1 as M), T(bitPattern: 0 as M), T(bitPattern: 1 as M))
            Test.xor(T(bitPattern: 0 as M), T(bitPattern: 1 as M), T(bitPattern: 1 as M))
            Test.xor(T(bitPattern: 1 as M), T(bitPattern: 1 as M), T(bitPattern: 0 as M))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
