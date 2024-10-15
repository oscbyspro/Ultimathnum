//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Stdlib
//*============================================================================*

@Suite struct BinaryIntegerTestsOnStdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/stdlib - uniform", arguments: typesAsCoreInteger, fuzzers)
    func stdlib(_ type: any CoreInteger.Type, _ randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: CoreInteger {            
            for _  in 0 ..< 16 {
                var a = T.random(using: &randomness)
                var b = T.random(using: &randomness)
                let x = a
                let y = b
                
                #expect(a == x)
                #expect(b == y)
                #expect(T(a.stdlib)   == x)
                #expect(T(b.stdlib)   == y)
                #expect(T(a.stdlib()) == x)
                #expect(T(b.stdlib()) == y)
                
                a.stdlib ^= b.stdlib
                b.stdlib ^= a.stdlib
                a.stdlib ^= b.stdlib
                
                #expect(a == y)
                #expect(b == x)
                #expect(T(a.stdlib)   == y)
                #expect(T(b.stdlib)   == x)
                #expect(T(a.stdlib()) == y)
                #expect(T(b.stdlib()) == x)
            }
        }
    }
}
