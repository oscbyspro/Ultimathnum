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
// MARK: * Infini Int x Bitwise
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplement() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let x = UX.msb
            //=----------------------------------=
            Test().complement(T([ 0,  0] as [UX], repeating: 0), false, Fallible(T([~0, ~0    ] as [UX], repeating: 1)))
            Test().complement(T([ 0,  0] as [UX], repeating: 0), true , Fallible(T([ 0,  0    ] as [UX], repeating: 0), error: !T.isSigned))
            Test().complement(T([ 0,  0] as [UX], repeating: 1), false, Fallible(T([~0, ~0    ] as [UX], repeating: 0)))
            Test().complement(T([ 0,  0] as [UX], repeating: 1), true , Fallible(T([ 0,  0,  1] as [UX], repeating: 0)))
            Test().complement(T([~0, ~0] as [UX], repeating: 0), false, Fallible(T([ 0,  0    ] as [UX], repeating: 1)))
            Test().complement(T([~0, ~0] as [UX], repeating: 0), true , Fallible(T([ 1,  0    ] as [UX], repeating: 1)))
            Test().complement(T([~0, ~0] as [UX], repeating: 1), false, Fallible(T([ 0,  0    ] as [UX], repeating: 0)))
            Test().complement(T([~0, ~0] as [UX], repeating: 1), true , Fallible(T([ 1,  0    ] as [UX], repeating: 0)))
            
            Test().complement(T([ 0,  x] as [UX], repeating: 0), false, Fallible(T([~0, ~x    ] as [UX], repeating: 1)))
            Test().complement(T([ 0,  x] as [UX], repeating: 0), true , Fallible(T([ 0,  x    ] as [UX], repeating: 1)))
            Test().complement(T([ 0,  x] as [UX], repeating: 1), false, Fallible(T([~0, ~x    ] as [UX], repeating: 0)))
            Test().complement(T([ 0,  x] as [UX], repeating: 1), true , Fallible(T([ 0,  x    ] as [UX], repeating: 0)))
            Test().complement(T([~0, ~x] as [UX], repeating: 0), false, Fallible(T([ 0,  x    ] as [UX], repeating: 1)))
            Test().complement(T([~0, ~x] as [UX], repeating: 0), true , Fallible(T([ 1,  x    ] as [UX], repeating: 1)))
            Test().complement(T([~0, ~x] as [UX], repeating: 1), false, Fallible(T([ 0,  x    ] as [UX], repeating: 0)))
            Test().complement(T([~0, ~x] as [UX], repeating: 1), true , Fallible(T([ 1,  x    ] as [UX], repeating: 0)))
            
            Test().complement(T([ 1,  2] as [UX], repeating: 0), false, Fallible(T([~1, ~2    ] as [UX], repeating: 1)))
            Test().complement(T([ 1,  2] as [UX], repeating: 0), true , Fallible(T([~0, ~2    ] as [UX], repeating: 1)))
            Test().complement(T([ 1,  2] as [UX], repeating: 1), false, Fallible(T([~1, ~2    ] as [UX], repeating: 0)))
            Test().complement(T([ 1,  2] as [UX], repeating: 1), true , Fallible(T([~0, ~2    ] as [UX], repeating: 0)))
            Test().complement(T([~1, ~2] as [UX], repeating: 0), false, Fallible(T([ 1,  2    ] as [UX], repeating: 1)))
            Test().complement(T([~1, ~2] as [UX], repeating: 0), true , Fallible(T([ 2,  2    ] as [UX], repeating: 1)))
            Test().complement(T([~1, ~2] as [UX], repeating: 1), false, Fallible(T([ 1,  2    ] as [UX], repeating: 0)))
            Test().complement(T([~1, ~2] as [UX], repeating: 1), true , Fallible(T([ 2,  2    ] as [UX], repeating: 0)))
        }
                
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Logic
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            //=----------------------------------=
            Test().not(T([ 1,  2,  3,  4] as [UX], repeating: 0), T([~1, ~2, ~3, ~4] as [UX], repeating: 1))
            Test().not(T([ 1,  2,  3,  4] as [UX], repeating: 1), T([~1, ~2, ~3, ~4] as [UX], repeating: 0))
            Test().not(T([~1, ~2, ~3, ~4] as [UX], repeating: 0), T([ 1,  2,  3,  4] as [UX], repeating: 1))
            Test().not(T([~1, ~2, ~3, ~4] as [UX], repeating: 1), T([ 1,  2,  3,  4] as [UX], repeating: 0))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testLogicalAnd() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            //=----------------------------------=
            let a = T([3 << 0, 3 << 1, 3 << 2        ] as [UX])
            let b = T([3 << 1, 3 << 2, 3 << 3, 3 << 4] as [UX])
            //=----------------------------------=
            Test().and( a,  b,  T([1 << 1, 1 << 2, 1 << 3        ] as [UX]))
            Test().and( a, ~b,  T([1 << 0, 1 << 1, 1 << 2        ] as [UX]))
            Test().and(~a,  b,  T([1 << 2, 1 << 3, 1 << 4, 3 << 4] as [UX]))
            Test().and(~a, ~b, ~T([7 << 0, 7 << 1, 7 << 2, 3 << 4] as [UX]))
            //=----------------------------------=
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
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            //=----------------------------------=
            let a = T([3 << 0, 3 << 1, 3 << 2        ] as [UX])
            let b = T([3 << 1, 3 << 2, 3 << 3, 3 << 4] as [UX])
            //=----------------------------------=
            Test().or ( a,  b,  T([7 << 0, 7 << 1, 7 << 2, 3 << 4] as [UX]))
            Test().or ( a, ~b, ~T([1 << 2, 1 << 3, 1 << 4, 3 << 4] as [UX]))
            Test().or (~a,  b, ~T([1 << 0, 1 << 1, 1 << 2        ] as [UX]))
            Test().or (~a, ~b, ~T([1 << 1, 1 << 2, 1 << 3        ] as [UX]))
            //=----------------------------------=
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
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            //=----------------------------------=
            let a = T([3 << 0, 3 << 1, 3 << 2        ] as [UX])
            let b = T([3 << 1, 3 << 2, 3 << 3, 3 << 4] as [UX])
            //=----------------------------------=
            Test().xor( a,  b,  T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [UX]))
            Test().xor( a, ~b, ~T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [UX]))
            Test().xor(~a,  b, ~T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [UX]))
            Test().xor(~a, ~b,  T([5 << 0, 5 << 1, 5 << 2, 3 << 4] as [UX]))
            //=----------------------------------=
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

//=----------------------------------------------------------------------------=
// MARK: + Documentation
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplementDocumentationExamples() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            typealias T = InfiniInt<E>
            
            /// ```swift
            /// UXL(repeating: 0) //  x
            /// UXL(repeating: 1) // ~x
            /// UXL(repeating: 0) // ~x &+ 1 == y
            /// UXL(repeating: 1) // ~y
            /// UXL(repeating: 0) // ~y &+ 1 == x
            /// ```
            Test().complement(T(repeating: 0), false, Fallible(T(repeating: 1)))
            Test().complement(T(repeating: 0), true,  Fallible(T(repeating: 0), error: !T.isSigned))
            Test().complement(T(repeating: 0), false, Fallible(T(repeating: 1)))
            Test().complement(T(repeating: 0), true,  Fallible(T(repeating: 0), error: !T.isSigned))
            
            /// ```swift
            /// UXL([~0] as [UX], repeating: 0) //  x
            /// UXL([ 0] as [UX], repeating: 1) // ~x
            /// UXL([ 1] as [UX], repeating: 1) // ~x &+ 1 == y
            /// UXL([~1] as [UX], repeating: 0) // ~y
            /// UXL([~0] as [UX], repeating: 0) // ~y &+ 1 == x
            /// ```
            Test().complement(T([~0    ] as [UX], repeating: 0), false, Fallible(T([ 0    ] as [UX], repeating: 1)))
            Test().complement(T([~0    ] as [UX], repeating: 0), true,  Fallible(T([ 1    ] as [UX], repeating: 1)))
            Test().complement(T([ 1    ] as [UX], repeating: 1), false, Fallible(T([~1    ] as [UX], repeating: 0)))
            Test().complement(T([ 1    ] as [UX], repeating: 1), true,  Fallible(T([~0    ] as [UX], repeating: 0)))
            
            /// ```swift
            /// UXL([ 0    ] as [UX], repeating: 1) //  x
            /// UXL([~0    ] as [UX], repeating: 0) // ~x
            /// UXL([ 0,  1] as [UX], repeating: 0) // ~x &+ 1 == y
            /// UXL([~0, ~1] as [UX], repeating: 1) // ~y
            /// UXL([ 0    ] as [UX], repeating: 1) // ~y &+ 1 == x
            /// ```
            Test().complement(T([ 0    ] as [UX], repeating: 1), false, Fallible(T([~0    ] as [UX], repeating: 0)))
            Test().complement(T([ 0    ] as [UX], repeating: 1), true,  Fallible(T([ 0,  1] as [UX], repeating: 0)))
            Test().complement(T([ 0,  1] as [UX], repeating: 0), false, Fallible(T([~0, ~1] as [UX], repeating: 1)))
            Test().complement(T([ 0,  1] as [UX], repeating: 0), true,  Fallible(T([ 0    ] as [UX], repeating: 1)))
        }
                
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
}
