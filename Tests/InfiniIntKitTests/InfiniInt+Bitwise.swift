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
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let x = UX.msb
            //=----------------------------------=
            Test().complement(T([ 0,  0] as [UX], repeating: Bit.zero), false, F(T([~0, ~0    ] as [UX], repeating: Bit.one )))
            Test().complement(T([ 0,  0] as [UX], repeating: Bit.zero), true , F(T([ 0,  0    ] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().complement(T([ 0,  0] as [UX], repeating: Bit.one ), false, F(T([~0, ~0    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([ 0,  0] as [UX], repeating: Bit.one ), true , F(T([ 0,  0,  1] as [UX], repeating: Bit.zero)))
            Test().complement(T([~0, ~0] as [UX], repeating: Bit.zero), false, F(T([ 0,  0    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~0, ~0] as [UX], repeating: Bit.zero), true , F(T([ 1,  0    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~0, ~0] as [UX], repeating: Bit.one ), false, F(T([ 0,  0    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([~0, ~0] as [UX], repeating: Bit.one ), true , F(T([ 1,  0    ] as [UX], repeating: Bit.zero)))
            
            Test().complement(T([ 0,  x] as [UX], repeating: Bit.zero), false, F(T([~0, ~x    ] as [UX], repeating: Bit.one )))
            Test().complement(T([ 0,  x] as [UX], repeating: Bit.zero), true , F(T([ 0,  x    ] as [UX], repeating: Bit.one )))
            Test().complement(T([ 0,  x] as [UX], repeating: Bit.one ), false, F(T([~0, ~x    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([ 0,  x] as [UX], repeating: Bit.one ), true , F(T([ 0,  x    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([~0, ~x] as [UX], repeating: Bit.zero), false, F(T([ 0,  x    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~0, ~x] as [UX], repeating: Bit.zero), true , F(T([ 1,  x    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~0, ~x] as [UX], repeating: Bit.one ), false, F(T([ 0,  x    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([~0, ~x] as [UX], repeating: Bit.one ), true , F(T([ 1,  x    ] as [UX], repeating: Bit.zero)))
            
            Test().complement(T([ 1,  2] as [UX], repeating: Bit.zero), false, F(T([~1, ~2    ] as [UX], repeating: Bit.one )))
            Test().complement(T([ 1,  2] as [UX], repeating: Bit.zero), true , F(T([~0, ~2    ] as [UX], repeating: Bit.one )))
            Test().complement(T([ 1,  2] as [UX], repeating: Bit.one ), false, F(T([~1, ~2    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([ 1,  2] as [UX], repeating: Bit.one ), true , F(T([~0, ~2    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([~1, ~2] as [UX], repeating: Bit.zero), false, F(T([ 1,  2    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~1, ~2] as [UX], repeating: Bit.zero), true , F(T([ 2,  2    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~1, ~2] as [UX], repeating: Bit.one ), false, F(T([ 1,  2    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([~1, ~2] as [UX], repeating: Bit.one ), true , F(T([ 2,  2    ] as [UX], repeating: Bit.zero)))
        }
                
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Logic
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            Test().not(T([ 1,  2,  3,  4] as [UX], repeating: Bit.zero), T([~1, ~2, ~3, ~4] as [UX], repeating: Bit.one ))
            Test().not(T([ 1,  2,  3,  4] as [UX], repeating: Bit.one ), T([~1, ~2, ~3, ~4] as [UX], repeating: Bit.zero))
            Test().not(T([~1, ~2, ~3, ~4] as [UX], repeating: Bit.zero), T([ 1,  2,  3,  4] as [UX], repeating: Bit.one ))
            Test().not(T([~1, ~2, ~3, ~4] as [UX], repeating: Bit.one ), T([ 1,  2,  3,  4] as [UX], repeating: Bit.zero))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalAnd() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
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
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalOr() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
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
        
        for types in Self.types {
            whereIs(types)
        }
    }
    
    func testLogicalXor() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
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
                
        for type in Self.types {
            whereIs(type)
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
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            
            /// ```swift
            /// UXL(repeating: Bit.zero) //  x
            /// UXL(repeating: Bit.one ) // ~x
            /// UXL(repeating: Bit.zero) // ~x &+ 1 == y
            /// UXL(repeating: Bit.one ) // ~y
            /// UXL(repeating: Bit.zero) // ~y &+ 1 == x
            /// ```
            Test().complement(T(repeating: Bit.zero), false, Fallible(T(repeating: Bit.one )))
            Test().complement(T(repeating: Bit.zero), true,  Fallible(T(repeating: Bit.zero), error: !T.isSigned))
            Test().complement(T(repeating: Bit.zero), false, Fallible(T(repeating: Bit.one )))
            Test().complement(T(repeating: Bit.zero), true,  Fallible(T(repeating: Bit.zero), error: !T.isSigned))
            
            /// ```swift
            /// UXL([~0] as [UX], repeating: Bit.zero) //  x
            /// UXL([ 0] as [UX], repeating: Bit.one ) // ~x
            /// UXL([ 1] as [UX], repeating: Bit.one ) // ~x &+ 1 == y
            /// UXL([~1] as [UX], repeating: Bit.zero) // ~y
            /// UXL([~0] as [UX], repeating: Bit.zero) // ~y &+ 1 == x
            /// ```
            Test().complement(T([~0    ] as [UX], repeating: Bit.zero), false, Fallible(T([ 0    ] as [UX], repeating: Bit.one )))
            Test().complement(T([~0    ] as [UX], repeating: Bit.zero), true,  Fallible(T([ 1    ] as [UX], repeating: Bit.one )))
            Test().complement(T([ 1    ] as [UX], repeating: Bit.one ), false, Fallible(T([~1    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([ 1    ] as [UX], repeating: Bit.one ), true,  Fallible(T([~0    ] as [UX], repeating: Bit.zero)))
            
            /// ```swift
            /// UXL([ 0    ] as [UX], repeating: Bit.one ) //  x
            /// UXL([~0    ] as [UX], repeating: Bit.zero) // ~x
            /// UXL([ 0,  1] as [UX], repeating: Bit.zero) // ~x &+ 1 == y
            /// UXL([~0, ~1] as [UX], repeating: Bit.one ) // ~y
            /// UXL([ 0    ] as [UX], repeating: Bit.one ) // ~y &+ 1 == x
            /// ```
            Test().complement(T([ 0    ] as [UX], repeating: Bit.one ), false, Fallible(T([~0    ] as [UX], repeating: Bit.zero)))
            Test().complement(T([ 0    ] as [UX], repeating: Bit.one ), true,  Fallible(T([ 0,  1] as [UX], repeating: Bit.zero)))
            Test().complement(T([ 0,  1] as [UX], repeating: Bit.zero), false, Fallible(T([~0, ~1] as [UX], repeating: Bit.one )))
            Test().complement(T([ 0,  1] as [UX], repeating: Bit.zero), true,  Fallible(T([ 0    ] as [UX], repeating: Bit.one )))
        }
                
        for type in Self.types {
            whereIs(type)
        }
    }
}
