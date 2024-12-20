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
// MARK: * Swift x Optional
//*============================================================================*

@Suite struct SwiftOptionalTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Swift.Optional: init(raw:)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreInteger, fuzzers
    )   func bitcasting(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            try #require(Optional<T>(raw: Optional<T.Magnitude>.none) == Optional<T>.none)
            try #require(Optional<T>(raw: Optional<T.Signitude>.none) == Optional<T>.none)
            
            for _ in 0 ..< 8 {
                let magnitude = T.Magnitude.random(using: &randomness)
                let signitude = T.Signitude.random(using: &randomness)
                
                try #require(Optional<T>(raw: Optional(magnitude)) == T(raw: magnitude))
                try #require(Optional<T>(raw: Optional(signitude)) == T(raw: signitude))
            }
        }
    }
    
    @Test(
        "Swift.Optional: unwrap()",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreInteger, fuzzers
    )   func unwrapping(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< 8 {
                let random = T.random(using: &randomness)
                try #require(Optional(random).unwrap()    == random)
                try #require(Optional(random).unchecked() == random)
            }
        }
    }
}
