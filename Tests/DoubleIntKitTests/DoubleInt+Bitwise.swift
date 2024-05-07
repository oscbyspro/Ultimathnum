//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Bitwise
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test().same(T(repeating: 0 as Bit),  0 as T)
            Test().same(T(repeating: 1 as Bit), ~0 as T)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test().not(T(low:  1, high:  2), T(low: ~1, high: ~2))
            Test().not(T(low:  1, high: ~2), T(low: ~1, high:  2))
            Test().not(T(low: ~1, high:  2), T(low:  1, high: ~2))
            Test().not(T(low: ~1, high: ~2), T(low:  1, high:  2))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testLogicalAnd() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test().and(T(low:  1, high:  2), T(low:  3, high:  4), T(low:  1, high:  0))
            Test().and(T(low:  1, high:  2), T(low: ~3, high: ~4), T(low:  0, high:  2))
            Test().and(T(low: ~1, high: ~2), T(low:  3, high:  4), T(low:  2, high:  4))
            Test().and(T(low: ~1, high: ~2), T(low: ~3, high: ~4), T(low: ~3, high: ~6))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testLogicalOr() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test().or (T(low:  1, high:  2), T(low:  3, high:  4), T(low:  3, high:  6))
            Test().or (T(low:  1, high:  2), T(low: ~3, high: ~4), T(low: ~2, high: ~4))
            Test().or (T(low: ~1, high: ~2), T(low:  3, high:  4), T(low: ~0, high: ~2))
            Test().or (T(low: ~1, high: ~2), T(low: ~3, high: ~4), T(low: ~1, high: ~0))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testLogicalXor() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test().xor(T(low:  1, high:  2), T(low:  3, high:  4), T(low:  2, high:  6))
            Test().xor(T(low:  1, high:  2), T(low: ~3, high: ~4), T(low: ~2, high: ~6))
            Test().xor(T(low: ~1, high: ~2), T(low:  3, high:  4), T(low: ~2, high: ~6))
            Test().xor(T(low: ~1, high: ~2), T(low: ~3, high: ~4), T(low:  2, high:  6))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplement() {
        func whereTheBaseTypeIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible<T>
            
            Test().complement(T(low:  0, high:  00000), false,  F(T(low: ~0, high: ~00000)))
            Test().complement(T(low:  0, high:  00000), true,   F(T(low:  0, high:  00000), error: !B.isSigned))
            Test().complement(T(low:  1, high:  00002), false,  F(T(low: ~1, high: ~00002)))
            Test().complement(T(low:  1, high:  00002), true,   F(T(low: ~0, high: ~00002)))
            
            Test().complement(T(low: ~0, high: ~B.msb), false,  F(T(low:  0, high:  B.msb)))
            Test().complement(T(low: ~0, high: ~B.msb), true,   F(T(low:  1, high:  B.msb)))
            Test().complement(T(low:  0, high:  B.msb), false,  F(T(low: ~0, high: ~B.msb)))
            Test().complement(T(low:  0, high:  B.msb), true,   F(T(low:  0, high:  B.msb), error:  B.isSigned))
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLeastSignificantBit() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test().same(( T .min).leastSignificantBit, 0 as Bit)
            Test().same(( T .max).leastSignificantBit, 1 as Bit)
            Test().same((~1 as T).leastSignificantBit, 0 as Bit)
            Test().same((~0 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 0 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 1 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 2 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 3 as T).leastSignificantBit, 1 as Bit)
            
            Test().same(T(low:  0, high:  0).leastSignificantBit, 0 as Bit)
            Test().same(T(low:  0, high: ~0).leastSignificantBit, 0 as Bit)
            Test().same(T(low: ~0, high:  0).leastSignificantBit, 1 as Bit)
            Test().same(T(low: ~0, high: ~0).leastSignificantBit, 1 as Bit)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
