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
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stdlib
//*============================================================================*

@Suite struct BinaryIntegerStdlibTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib: metadata",
        Tag.List.tags(.forwarding, .generic),
        arguments: typesAsFiniteIntegerInteroperable
    )   func metadata(
        type: any FiniteIntegerInteroperable.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            #expect(T.Stdlib.isSigned == T.isSigned)
            #expect(T.Stdlib.Magnitude.isSigned == T.isArbitrary)
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib: bitcasting",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func bitcasting(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            for _ in 0 ..< 8 {
                let shift = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: shift, using: &randomness).stdlib()
                try #require(value == T.Stdlib(raw: T.Magnitude(raw: value)))
                try #require(value == T.Stdlib(raw: T.Signitude(raw: value)))
                try #require(value == T.Stdlib(raw: T.Stdlib   (raw: value)))
                try #require(value == T.Stdlib(raw: T.Stdlib.Magnitude(raw: value)))
            }
        }
    }
}
