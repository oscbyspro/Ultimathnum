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
            
            Case(T(low:  0, high:  00000)).complement(false, is: F(T(low: ~0, high: ~00000)))
            Case(T(low:  0, high:  00000)).complement(true,  is: F(T(low:  0, high:  00000), error: !B.isSigned))
            Case(T(low:  1, high:  00002)).complement(false, is: F(T(low: ~1, high: ~00002)))
            Case(T(low:  1, high:  00002)).complement(true,  is: F(T(low: ~0, high: ~00002)))
            
            Case(T(low: ~0, high: ~B.msb)).complement(false, is: F(T(low:  0, high:  B.msb)))
            Case(T(low: ~0, high: ~B.msb)).complement(true,  is: F(T(low:  1, high:  B.msb)))
            Case(T(low:  0, high:  B.msb)).complement(false, is: F(T(low: ~0, high: ~B.msb)))
            Case(T(low:  0, high:  B.msb)).complement(true,  is: F(T(low:  0, high:  B.msb), error:  B.isSigned))
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCountSelection() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            //=----------------------------------=
            let full = M.size
            let half = M(low: Base.size)
            let none = M.zero
            //=----------------------------------=
            Test().count(T(low:  00, high: 00), 0 as Bit, .anywhere,   full)
            Test().count(T(low: ~00, high: 00), 0 as Bit, .anywhere,   half)
            Test().count(T(low:  00, high: 11), 0 as Bit, .anywhere,   full - 3 as M)
            Test().count(T(low: ~00, high: 11), 0 as Bit, .anywhere,   half - 3 as M)
            Test().count(T(low:  11, high: 00), 0 as Bit, .anywhere,   full - 3 as M)
            Test().count(T(low: ~11, high: 00), 0 as Bit, .anywhere,   half + 3 as M)
            Test().count(T(low:  11, high: 11), 0 as Bit, .anywhere,   full - 6 as M)
            Test().count(T(low: ~11, high: 11), 0 as Bit, .anywhere,   half)
            
            Test().count(T(low:  00, high: 00), 1 as Bit, .anywhere,   none)
            Test().count(T(low: ~00, high: 00), 1 as Bit, .anywhere,   half)
            Test().count(T(low:  00, high: 11), 1 as Bit, .anywhere,   none + 3 as M)
            Test().count(T(low: ~00, high: 11), 1 as Bit, .anywhere,   half + 3 as M)
            Test().count(T(low:  11, high: 00), 1 as Bit, .anywhere,   none + 3 as M)
            Test().count(T(low: ~11, high: 00), 1 as Bit, .anywhere,   half - 3 as M)
            Test().count(T(low:  11, high: 11), 1 as Bit, .anywhere,   none + 6 as M)
            Test().count(T(low: ~11, high: 11), 1 as Bit, .anywhere,   half)
            
            Test().count(T(low:  00, high: 00), 0 as Bit, .ascending,  full)
            Test().count(T(low: ~00, high: 00), 0 as Bit, .ascending,  none)
            Test().count(T(low:  00, high: 11), 0 as Bit, .ascending,  half)
            Test().count(T(low: ~00, high: 11), 0 as Bit, .ascending,  none)
            Test().count(T(low:  11, high: 00), 0 as Bit, .ascending,  none)
            Test().count(T(low: ~11, high: 00), 0 as Bit, .ascending,  none + 2 as M)
            Test().count(T(low:  11, high: 11), 0 as Bit, .ascending,  none)
            Test().count(T(low: ~11, high: 11), 0 as Bit, .ascending,  none + 2 as M)
            
            Test().count(T(low:  00, high: 00), 1 as Bit, .ascending,  none)
            Test().count(T(low: ~00, high: 00), 1 as Bit, .ascending,  half)
            Test().count(T(low:  00, high: 11), 1 as Bit, .ascending,  none)
            Test().count(T(low: ~00, high: 11), 1 as Bit, .ascending,  half + 2 as M)
            Test().count(T(low:  11, high: 00), 1 as Bit, .ascending,  none + 2 as M)
            Test().count(T(low: ~11, high: 00), 1 as Bit, .ascending,  none)
            Test().count(T(low:  11, high: 11), 1 as Bit, .ascending,  none + 2 as M)
            Test().count(T(low: ~11, high: 11), 1 as Bit, .ascending,  none)
            
            Test().count(T(low:  00, high: 00), 0 as Bit, .descending, full)
            Test().count(T(low: ~00, high: 00), 0 as Bit, .descending, half)
            Test().count(T(low:  00, high: 11), 0 as Bit, .descending, half - 4 as M)
            Test().count(T(low: ~00, high: 11), 0 as Bit, .descending, half - 4 as M)
            Test().count(T(low:  11, high: 00), 0 as Bit, .descending, full - 4 as M)
            Test().count(T(low: ~11, high: 00), 0 as Bit, .descending, half)
            Test().count(T(low:  11, high: 11), 0 as Bit, .descending, half - 4 as M)
            Test().count(T(low: ~11, high: 11), 0 as Bit, .descending, half - 4 as M)
            
            Test().count(T(low:  00, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low: ~00, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low:  00, high: 11), 1 as Bit, .descending, none)
            Test().count(T(low: ~00, high: 11), 1 as Bit, .descending, none)
            Test().count(T(low:  11, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low: ~11, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low:  11, high: 11), 1 as Bit, .descending, none)
            Test().count(T(low: ~11, high: 11), 1 as Bit, .descending, none)
        }

        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
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
