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
    
    func testLogicalNot() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = B.Element.Magnitude
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
    
    func testLogicalAnd() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = B.Element.Magnitude
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
    
    func testLogicalOr() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = B.Element.Magnitude
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
    
    func testLogicalXor() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = B.Element.Magnitude
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
}
