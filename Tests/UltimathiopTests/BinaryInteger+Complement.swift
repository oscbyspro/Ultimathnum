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
// MARK: * Binary Integer x Stdlib x Complement
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnComplement {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/complement: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 32 {
                let x = T.entropic(size: size, using: &randomness)
                
                always: do {
                    let expectation = T.Stdlib.Magnitude(raw: x.magnitude())
                    try #require(expectation == T.Stdlib(x).magnitude)
                }
            }
        }
    }
}
