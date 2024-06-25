//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Integer Invariants x Bitwise
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func bitwiseInitBitOrRepeatingBit() {
        test.same(T(0 as Bit), 0 as T)
        test.same(T(1 as Bit), 1 as T)
        test.same(T(repeating: 0 as Bit),  (0 as T))
        test.same(T(repeating: 1 as Bit), ~(0 as T))
    }
    
    public func bitwiseLogicOfAlternatingBitEsque() {
        let a = T.exactly(0x55555555555555555555555555555555).value // 128-bit: 1010...
        let b = T.exactly(0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA).value // 128-bit: 0101...
        let x = T.exactly(0x00000000000000000000000000000000).value // 128-bit: 0000...
        let y = T.exactly(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).value // 128-bit: 1111...
        
        test.not( a, T(repeating: 1) - a)
        test.not(~a, T(repeating: 1) - a.toggled())
        test.not( b, T(repeating: 1) - b)
        test.not(~b, T(repeating: 1) - b.toggled())
        
        test.and( a,  a,  a)
        test.and( a,  b,  x)
        test.and( b,  a,  x)
        test.and( b,  b,  b)
        test.and(~a, ~a, ~a)
        test.and(~a, ~b, ~y)
        test.and(~b, ~a, ~y)
        test.and(~b, ~b, ~b)
        
        test.or ( a,  a,  a)
        test.or ( a,  b,  y)
        test.or ( b,  a,  y)
        test.or ( b,  b,  b)
        test.or (~a, ~a, ~a)
        test.or (~a, ~b, ~x)
        test.or (~b, ~a, ~x)
        test.or (~b, ~b, ~b)
        
        test.xor( a,  a,  x)
        test.xor( a,  b,  y)
        test.xor( b,  a,  y)
        test.xor( b,  b,  x)
        test.xor(~a, ~a,  x)
        test.xor(~a, ~b,  y)
        test.xor(~b, ~a,  y)
        test.xor(~b, ~b,  x)
    }
    
    public func bitwiseLsbEqualsIsOdd() {
        var isOdd =  false
        for small in I8.min ... I8.max {
            test.same(T(load: small).lsb, Bit(isOdd))
            isOdd.toggle()
        }
        
        test.same((Self.minEsque    ).lsb, 0 as Bit)
        test.same((Self.minEsque + 1).lsb, 1 as Bit)
        test.same((Self.minEsque + 2).lsb, 0 as Bit)
        test.same((Self.minEsque + 3).lsb, 1 as Bit)
        
        test.same((Self.maxEsque - 3).lsb, 0 as Bit)
        test.same((Self.maxEsque - 2).lsb, 1 as Bit)
        test.same((Self.maxEsque - 1).lsb, 0 as Bit)
        test.same((Self.maxEsque    ).lsb, 1 as Bit)
    }
    
    public func bitwiseMsbEqualsSignitudeIsNegative() {
        for small in I8.min ... I8.max {
            test.same(T(load: small).msb, Bit(small.isNegative))
        }
        
        test.same((Self.minEsque    ).msb, Bit( T.isSigned))
        test.same((Self.minEsque + 1).msb, Bit( T.isSigned))
        test.same((Self.minEsque + 2).msb, Bit( T.isSigned))
        test.same((Self.minEsque + 3).msb, Bit( T.isSigned))
        
        test.same((Self.maxEsque - 3).msb, Bit(!T.isSigned))
        test.same((Self.maxEsque - 2).msb, Bit(!T.isSigned))
        test.same((Self.maxEsque - 1).msb, Bit(!T.isSigned))
        test.same((Self.maxEsque    ).msb, Bit(!T.isSigned))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func endianness(_ id: SystemsIntegerID) where T: SystemsInteger {
        test.same(T(repeating: 0).endianness(.big   ), T(repeating: 0))
        test.same(T(repeating: 0).endianness(.little), T(repeating: 0))
        test.same(T(repeating: 1).endianness(.big   ), T(repeating: 1))
        test.same(T(repeating: 1).endianness(.little), T(repeating: 1))
        
        test.same(T(1).endianness(.system),                     T(1))
        test.same(T(2).endianness(.big   ).endianness(.big   ), T(2))
        test.same(T(3).endianness(.big   ).endianness(.little), T(3) << T(raw: T.size - 8))
        test.same(T(4).endianness(.little).endianness(.big   ), T(4) << T(raw: T.size - 8))
        test.same(T(5).endianness(.little).endianness(.little), T(5))
    }
}
