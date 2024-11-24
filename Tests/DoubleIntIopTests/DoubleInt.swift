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
// MARK: * Double Int x Stdlib
//*============================================================================*

@Suite struct DoubleIntStdlibTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib: metadata",
        Tag.List.tags(.forwarding, .generic),
        arguments: typesAsDoubleIntStdlibAsWorkaround
    )   func metadata(
        type: AnyDoubleIntStdlibType
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            #expect(T.isSigned == T.Base.isSigned)
            #expect(T.Magnitude.isSigned == false)
        }
    }
    
    @Test(
        "DoubleInt.Stdlib: init(raw:)",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func bitcasting(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            for _ in 0 ..< 8 {
                let value = T(T.Base.entropic(through: Shift.max(or: 255), using: &randomness))
                try #require(T(raw: T.Base.Signitude(raw: value)) == value)
                try #require(T(raw: T.Base.Magnitude(raw: value)) == value)
            }
        }
    }
}
