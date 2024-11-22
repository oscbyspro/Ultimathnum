//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import InfiniIntIop
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stdlib x Bitwise
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/bitwise: ~(_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func not(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 32 {
                let value = T.Base.entropic(size: size, using: &randomness)
                let expectation = value.toggled()
                
                try #require(~T(value) == T(expectation))
                try #require(~T(expectation) == T(value))
            }
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/bitwise: &(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func and(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 32 {
                let lhs = T.Base.entropic(size: size, using: &randomness)
                let rhs = T.Base.entropic(size: size, using: &randomness)
                let expectation = lhs & rhs
                
                try #require(T(expectation) == reduce(T(lhs), &,  T(rhs)))
                try #require(T(expectation) == reduce(T(lhs), &=, T(rhs)))
            }
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/bitwise: |(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func or(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 32 {
                let lhs = T.Base.entropic(size: size, using: &randomness)
                let rhs = T.Base.entropic(size: size, using: &randomness)
                let expectation = lhs | rhs
                
                try #require(T(expectation) == reduce(T(lhs), |,  T(rhs)))
                try #require(T(expectation) == reduce(T(lhs), |=, T(rhs)))
            }
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/bitwise: ^(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func xor(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 32 {
                let lhs = T.Base.entropic(size: size, using: &randomness)
                let rhs = T.Base.entropic(size: size, using: &randomness)
                let expectation = lhs ^ rhs
                
                try #require(T(expectation) == reduce(T(lhs), ^,  T(rhs)))
                try #require(T(expectation) == reduce(T(lhs), ^=, T(rhs)))
            }
        }
    }
}
