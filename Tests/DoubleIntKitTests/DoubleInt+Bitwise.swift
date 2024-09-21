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
    
    func testLeastSignificantBit() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias M = DoubleInt<B>.Magnitude
            
            Test().same(T(low:  0, high:  0).lsb, Bit.zero)
            Test().same(T(low:  0, high: ~0).lsb, Bit.zero)
            Test().same(T(low: ~0, high:  0).lsb, Bit.one )
            Test().same(T(low: ~0, high: ~0).lsb, Bit.one )
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplement() {
        func whereTheBaseIs<B>(_ base: B.Type) where B: SystemsInteger {
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
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEndianness() {
        func whereTheBaseTypeIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias M = DoubleInt<B.Magnitude>
            typealias U = DoubleInt<T> // x4
            
            let l1 = B.Magnitude(1).endianness( .ascending)
            let l2 = B.Magnitude(2).endianness( .ascending)
            let l3 = B.Magnitude(3).endianness( .ascending)
            let l4 = B.Magnitude(4).endianness( .ascending)
            
            let b1 = B.Magnitude(1).endianness(.descending)
            let b2 = B.Magnitude(2).endianness(.descending)
            let b3 = B.Magnitude(3).endianness(.descending)
            let b4 = B.Magnitude(4).endianness(.descending)
            
            Test().same(
                U(low: M(low: 01, high: 02), high: T(low: 03, high: 0000000004)).endianness(.endianess),
                U(low: M(low: 01, high: 02), high: T(low: 03, high: 0000000004))
            )
            
            Test().same(
                U(low: M(low: l1, high: l2), high: T(low: l3, high: B(raw: l4))).reversed(U8.self),
                U(low: M(low: b4, high: b3), high: T(low: b2, high: B(raw: b1)))
            )
            
            Test().same(
                U(low: M(low: l1, high: l2), high: T(low: l3, high: B(raw: l4))).endianness(.endianess.reversed()),
                U(low: M(low: b4, high: b3), high: T(low: b2, high: B(raw: b1)))
            )
            
            Test().same(
                U(low: M(low: l1, high: l2), high: T(low: l3, high: B(raw: l4))),
                U(low: M(low: b4, high: b3), high: T(low: b2, high: B(raw: b1))).reversed(U8.self)
            )
            
            Test().same(
                U(low: M(low: l1, high: l2), high: T(low: l3, high: B(raw: l4))),
                U(low: M(low: b4, high: b3), high: T(low: b2, high: B(raw: b1))).endianness(.endianess.reversed())
            )
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Logic
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
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
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
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
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
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
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            Test().xor(T(low:  1, high:  2), T(low:  3, high:  4), T(low:  2, high:  6))
            Test().xor(T(low:  1, high:  2), T(low: ~3, high: ~4), T(low: ~2, high: ~6))
            Test().xor(T(low: ~1, high: ~2), T(low:  3, high:  4), T(low: ~2, high: ~6))
            Test().xor(T(low: ~1, high: ~2), T(low: ~3, high: ~4), T(low:  2, high:  6))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
