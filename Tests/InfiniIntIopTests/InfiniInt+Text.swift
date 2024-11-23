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
// MARK: * Infini Int x Stdlib x Text
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/text: Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func forwarding(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0  ..< 128 {
                let value = T.Base.entropic(size: size,  using: &randomness)
                let radix = ((IX)).random(in: 002...36,  using: &randomness)
                let coder = try #require(TextInt(radix:  radix))
                let lowercase = value.description(using: coder.lowercased())
                let uppercase = value.description(using: coder.uppercased())
                
                try #require(String(T(value), radix: Swift.Int(radix), uppercase: false) == lowercase)
                try #require(String(T(value), radix: Swift.Int(radix), uppercase: true ) == uppercase)
                
                if  radix == 10 {
                    try #require(T(lowercase)  == T(value))
                    try #require(T(value).description == lowercase)
                    try #require(String(T(((value)))) == lowercase)
                }
            }
        }
    }
}
