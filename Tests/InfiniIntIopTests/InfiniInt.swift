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
// MARK: * Infini Int x Stdlib
//*============================================================================*

@Suite struct InfiniIntStdlibTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib: metadata",
        Tag.List.tags(.forwarding, .generic, .todo)
    )   func metadata() throws {

        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib {
            #expect(T.isSigned)
            #expect(T.Base.isSigned)
            #expect(T.Magnitude.isSigned)
        }
    }
    
    @Test(
        "InfiniInt.Stdlib: init(raw:)",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func bitcasting(
        randomness: consuming FuzzerInt
    )   throws {

        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib {
            for _ in 0 ..< 8 {
                let value = T(T.Base.entropic(through: Shift.max(or: 255), using: &randomness))
                try #require(T(raw: T.Base.Signitude(raw: value)) == value)
                try #require(T(raw: T.Base.Magnitude(raw: value)) == value)
            }
        }
    }
}
