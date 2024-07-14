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
// MARK: * Core Int x Bitwise
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplement() {
        func whereIs<T>(_ base: T.Type) where T: SystemsInteger {
            Test().complement(~2 as T, false, Fallible( 2 as T, error:  false))
            Test().complement(~1 as T, false, Fallible( 1 as T, error:  false))
            Test().complement(~0 as T, false, Fallible( 0 as T, error:  false))
            Test().complement( 0 as T, false, Fallible(~0 as T, error:  false))
            Test().complement( 1 as T, false, Fallible(~1 as T, error:  false))
            Test().complement( 2 as T, false, Fallible(~2 as T, error:  false))
            Test().complement( T .msb, false, Fallible(~T .msb, error:  false))

            Test().complement(~2 as T, true,  Fallible( 3 as T, error:  false))
            Test().complement(~1 as T, true,  Fallible( 2 as T, error:  false))
            Test().complement(~0 as T, true,  Fallible( 1 as T, error:  false))
            Test().complement( 0 as T, true,  Fallible( 0 as T, error: !T.isSigned))
            Test().complement( 1 as T, true,  Fallible(~0 as T, error:  false))
            Test().complement( 2 as T, true,  Fallible(~1 as T, error:  false))
            Test().complement( T .msb, true,  Fallible( T .msb, error:  T.isSigned))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Logic
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().not(T.min, T.max)
            Test().not(T.max, T.min)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalAnd() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().and(~1 as T, ~1 as T, ~1 as T)
            Test().and(~1 as T, ~0 as T, ~1 as T)
            Test().and(~1 as T,  0 as T,  0 as T)
            Test().and(~1 as T,  1 as T,  0 as T)
            
            Test().and(~0 as T, ~1 as T, ~1 as T)
            Test().and(~0 as T, ~0 as T, ~0 as T)
            Test().and(~0 as T,  0 as T,  0 as T)
            Test().and(~0 as T,  1 as T,  1 as T)
            
            Test().and( 0 as T, ~1 as T,  0 as T)
            Test().and( 0 as T, ~0 as T,  0 as T)
            Test().and( 0 as T,  0 as T,  0 as T)
            Test().and( 0 as T,  1 as T,  0 as T)
            
            Test().and( 1 as T, ~1 as T,  0 as T)
            Test().and( 1 as T, ~0 as T,  1 as T)
            Test().and( 1 as T,  0 as T,  0 as T)
            Test().and( 1 as T,  1 as T,  1 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalOr() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().or (~1 as T, ~1 as T, ~1 as T)
            Test().or (~1 as T, ~0 as T, ~0 as T)
            Test().or (~1 as T,  0 as T, ~1 as T)
            Test().or (~1 as T,  1 as T, ~0 as T)
            
            Test().or (~0 as T, ~1 as T, ~0 as T)
            Test().or (~0 as T, ~0 as T, ~0 as T)
            Test().or (~0 as T,  0 as T, ~0 as T)
            Test().or (~0 as T,  1 as T, ~0 as T)
            
            Test().or ( 0 as T, ~1 as T, ~1 as T)
            Test().or ( 0 as T, ~0 as T, ~0 as T)
            Test().or ( 0 as T,  0 as T,  0 as T)
            Test().or ( 0 as T,  1 as T,  1 as T)
            
            Test().or ( 1 as T, ~1 as T, ~0 as T)
            Test().or ( 1 as T, ~0 as T, ~0 as T)
            Test().or ( 1 as T,  0 as T,  1 as T)
            Test().or ( 1 as T,  1 as T,  1 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalXor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().xor(~1 as T, ~1 as T,  0 as T)
            Test().xor(~1 as T, ~0 as T,  1 as T)
            Test().xor(~1 as T,  0 as T, ~1 as T)
            Test().xor(~1 as T,  1 as T, ~0 as T)
            
            Test().xor(~0 as T, ~1 as T,  1 as T)
            Test().xor(~0 as T, ~0 as T,  0 as T)
            Test().xor(~0 as T,  0 as T, ~0 as T)
            Test().xor(~0 as T,  1 as T, ~1 as T)
            
            Test().xor( 0 as T, ~1 as T, ~1 as T)
            Test().xor( 0 as T, ~0 as T, ~0 as T)
            Test().xor( 0 as T,  0 as T,  0 as T)
            Test().xor( 0 as T,  1 as T,  1 as T)
            
            Test().xor( 1 as T, ~1 as T, ~0 as T)
            Test().xor( 1 as T, ~0 as T, ~1 as T)
            Test().xor( 1 as T,  0 as T,  1 as T)
            Test().xor( 1 as T,  1 as T,  0 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
