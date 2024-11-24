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
import DoubleIntIop
import DoubleIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Stdlib x Bitwise
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/bitwise: ~(_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func not(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
        "DoubleInt.Stdlib/bitwise: &(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func and(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
        "DoubleInt.Stdlib/bitwise: |(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func or(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
        "DoubleInt.Stdlib/bitwise: ^(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func xor(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Systems
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/bitwise: byteSwapped of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func byteSwapped(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            for _ in 0 ..< 32 {
                let value = T.Base.entropic(using: &randomness)
                let expectation = value.reversed(U8.self)
                
                try #require(T(expectation) == T(value).byteSwapped)
                try #require(T(value) == T(expectation).byteSwapped)
            }
        }
    }
}
