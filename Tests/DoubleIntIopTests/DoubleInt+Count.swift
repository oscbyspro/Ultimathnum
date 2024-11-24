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
// MARK: * Double Int x Stdlib x Count
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnCount {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/count: bitWidth of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func bitWidth(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 1024 {
                let value = T.Base.entropic(size: size, using: &randomness)
                let expectation = IX(raw: value.size())
                try #require(T(value).bitWidth == Swift.Int(expectation))
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/count: leadingZeroBitCount of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func leadingZeroBitCountOfSelfVersusBase(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 1024 {
                let value = T.Base.entropic(size: size, using: &randomness)
                let expectation = IX(IX(raw: value.descending(Bit.zero)).magnitude())
                try #require(T(value).leadingZeroBitCount == Swift.Int(expectation))
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/count: trailingZeroBitCount of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func trailingZeroBitCountOfSelfVersusBase(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 1024 {
                let value = T.Base.entropic(size: size, using: &randomness)
                let expectation = IX(IX(raw: value.ascending(Bit.zero)).magnitude())
                try #require(T(value).trailingZeroBitCount == Swift.Int(expectation))
            }
        }
    }
}
