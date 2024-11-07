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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stdlib
//*============================================================================*

@Suite struct BinaryIntegerTestsOnStdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/stdlib: conversions",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreInteger, fuzzers
    )   func conversions(type: any CoreInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: CoreInteger {
            for _  in 0 ..< 16 {
                var a = T.random(using: &randomness)
                var b = T.random(using: &randomness)
                let x = a
                let y = b
                
                try #require(a == x)
                try #require(b == y)
                try #require(T(a.stdlib)   == x)
                try #require(T(b.stdlib)   == y)
                try #require(T(a.stdlib()) == x)
                try #require(T(b.stdlib()) == y)
                
                a.stdlib ^= b.stdlib
                b.stdlib ^= a.stdlib
                a.stdlib ^= b.stdlib
                
                try #require(a == y)
                try #require(b == x)
                try #require(T(a.stdlib)   == y)
                try #require(T(b.stdlib)   == x)
                try #require(T(a.stdlib()) == y)
                try #require(T(b.stdlib()) == x)
            }
        }
    }
}
