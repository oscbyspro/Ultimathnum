//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit
import XCTest

//*============================================================================*
// MARK: * Main Int x Logic
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            Test.not(T.min, T.max)
            Test.not(T.max, T.min)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalAnd() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            Test.and(~1 as T, ~1 as T, ~1 as T)
            Test.and(~1 as T, ~0 as T, ~1 as T)
            Test.and(~1 as T,  0 as T,  0 as T)
            Test.and(~1 as T,  1 as T,  0 as T)
            
            Test.and(~0 as T, ~1 as T, ~1 as T)
            Test.and(~0 as T, ~0 as T, ~0 as T)
            Test.and(~0 as T,  0 as T,  0 as T)
            Test.and(~0 as T,  1 as T,  1 as T)
            
            Test.and( 0 as T, ~1 as T,  0 as T)
            Test.and( 0 as T, ~0 as T,  0 as T)
            Test.and( 0 as T,  0 as T,  0 as T)
            Test.and( 0 as T,  1 as T,  0 as T)
            
            Test.and( 1 as T, ~1 as T,  0 as T)
            Test.and( 1 as T, ~0 as T,  1 as T)
            Test.and( 1 as T,  0 as T,  0 as T)
            Test.and( 1 as T,  1 as T,  1 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalOr() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            Test.or (~1 as T, ~1 as T, ~1 as T)
            Test.or (~1 as T, ~0 as T, ~0 as T)
            Test.or (~1 as T,  0 as T, ~1 as T)
            Test.or (~1 as T,  1 as T, ~0 as T)
            
            Test.or (~0 as T, ~1 as T, ~0 as T)
            Test.or (~0 as T, ~0 as T, ~0 as T)
            Test.or (~0 as T,  0 as T, ~0 as T)
            Test.or (~0 as T,  1 as T, ~0 as T)
            
            Test.or ( 0 as T, ~1 as T, ~1 as T)
            Test.or ( 0 as T, ~0 as T, ~0 as T)
            Test.or ( 0 as T,  0 as T,  0 as T)
            Test.or ( 0 as T,  1 as T,  1 as T)
            
            Test.or ( 1 as T, ~1 as T, ~0 as T)
            Test.or ( 1 as T, ~0 as T, ~0 as T)
            Test.or ( 1 as T,  0 as T,  1 as T)
            Test.or ( 1 as T,  1 as T,  1 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalXor() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            Test.xor(~1 as T, ~1 as T,  0 as T)
            Test.xor(~1 as T, ~0 as T,  1 as T)
            Test.xor(~1 as T,  0 as T, ~1 as T)
            Test.xor(~1 as T,  1 as T, ~0 as T)
            
            Test.xor(~0 as T, ~1 as T,  1 as T)
            Test.xor(~0 as T, ~0 as T,  0 as T)
            Test.xor(~0 as T,  0 as T, ~0 as T)
            Test.xor(~0 as T,  1 as T, ~1 as T)
            
            Test.xor( 0 as T, ~1 as T, ~1 as T)
            Test.xor( 0 as T, ~0 as T, ~0 as T)
            Test.xor( 0 as T,  0 as T,  0 as T)
            Test.xor( 0 as T,  1 as T,  1 as T)
            
            Test.xor( 1 as T, ~1 as T, ~0 as T)
            Test.xor( 1 as T, ~0 as T, ~1 as T)
            Test.xor( 1 as T,  0 as T,  1 as T)
            Test.xor( 1 as T,  1 as T,  0 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
