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
    
    func testBitwise() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).endianness()
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T(0 as Bit),             0 as T)
            Test().same(T(1 as Bit),             1 as T)
            Test().same(T(repeating: 0 as Bit),  0 as T)
            Test().same(T(repeating: 1 as Bit), ~0 as T)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().not(T.min, T.max)
            Test().not(T.max, T.min)
        }
        
        for type in coreSystemsIntegers {
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
        
        for type in coreSystemsIntegers {
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
        
        for type in coreSystemsIntegers {
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
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLeastSignificantBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(( T .min).leastSignificantBit, 0 as Bit)
            Test().same(( T .max).leastSignificantBit, 1 as Bit)
            Test().same((~1 as T).leastSignificantBit, 0 as Bit)
            Test().same((~0 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 0 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 1 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 2 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 3 as T).leastSignificantBit, 1 as Bit)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
