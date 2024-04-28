//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infinit Int x Bitwise
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitwiseNot() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
            //=--------------------------------------=
            Test().not(T([ 1,  2,  3,  4] as [L], repeating: 0), T([~1, ~2, ~3, ~4] as [L], repeating: 1))
            Test().not(T([ 1,  2,  3,  4] as [L], repeating: 1), T([~1, ~2, ~3, ~4] as [L], repeating: 0))
            Test().not(T([~1, ~2, ~3, ~4] as [L], repeating: 0), T([ 1,  2,  3,  4] as [L], repeating: 1))
            Test().not(T([~1, ~2, ~3, ~4] as [L], repeating: 1), T([ 1,  2,  3,  4] as [L], repeating: 0))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testBitwiseAnd() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
            //=--------------------------------------=
            let a = T([3 << 0, 3 << 1, 3 << 2        ] as [L])
            let b = T([3 << 1, 3 << 2, 3 << 3, 3 << 4] as [L])
            //=--------------------------------------=
            Test().and( a,  b,  T([1 << 1, 1 << 2, 1 << 3        ] as [L]))
            Test().and( a, ~b,  T([1 << 0, 1 << 1, 1 << 2        ] as [L]))
            Test().and(~a,  b,  T([1 << 2, 1 << 3, 1 << 4, 3 << 4] as [L]))
            Test().and(~a, ~b, ~T([7 << 0, 7 << 1, 7 << 2, 3 << 4] as [L]))
            //=--------------------------------------=
            for x in [a, b] {
                Test().and( x,  x,  x)
                Test().and( x, ~x,  0)
                Test().and(~x,  x,  0)
                Test().and(~x, ~x, ~x)
            }
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testBitwiseOr() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
            //=--------------------------------------=
            let a = T([3 << 0, 3 << 1, 3 << 2        ] as [L])
            let b = T([3 << 1, 3 << 2, 3 << 3, 3 << 4] as [L])
            //=--------------------------------------=
            Test().or ( a,  b,  T([7 << 0, 7 << 1, 7 << 2, 3 << 4] as [L]))
            Test().or ( a, ~b, ~T([1 << 2, 1 << 3, 1 << 4, 3 << 4] as [L]))
            Test().or (~a,  b, ~T([1 << 0, 1 << 1, 1 << 2        ] as [L]))
            Test().or (~a, ~b, ~T([1 << 1, 1 << 2, 1 << 3        ] as [L]))
            //=--------------------------------------=
            for x in [a, b] {
                Test().or ( x,  x,  x)
                Test().or ( x, ~x, ~0)
                Test().or (~x,  x, ~0)
                Test().or (~x, ~x, ~x)
            }
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testBitwiseXor() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
            //=--------------------------------------=
            let a = T([3 << 0, 3 << 1, 3 << 2        ] as [L])
            let b = T([3 << 1, 3 << 2, 3 << 3, 3 << 4] as [L])
            //=--------------------------------------=
            Test().xor( a,  b,  T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [L]))
            Test().xor( a, ~b, ~T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [L]))
            Test().xor(~a,  b, ~T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [L]))
            Test().xor(~a, ~b,  T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [L]))
            //=--------------------------------------=
            for x in [a, b] {
                Test().xor( x,  x,  0)
                Test().xor( x, ~x, ~0)
                Test().xor(~x,  x, ~0)
                Test().xor(~x, ~x,  0)
            }
        }
                
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCountSelection() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias M = InfiniInt<E>.Magnitude
            
            Test().count(T(0x00000000000000000000000000000000), 0 as Bit, .anywhere,   ~000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, .anywhere,   ~032 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, .anywhere,   ~064 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, .anywhere,   ~096 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, .anywhere,   ~128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 1 as Bit, .anywhere,   0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, .anywhere,   0032 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, .anywhere,   0064 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, .anywhere,   0096 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, .anywhere,   0128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 0 as Bit, .ascending,  ~000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, .ascending,  0008 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, .ascending,  0003 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, .ascending,  0004 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, .ascending,  0000 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, .ascending,  0128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 0 as Bit, .descending,  ~00 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, .descending, ~124 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, .descending, ~128 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, .descending, ~128 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, .descending, ~128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, .descending, 0000 as M)
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}
