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
// MARK: * Infini Int x Stdlib x Complement
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnComplement {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/complement: magnitude",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func magnitude(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 32 {
                let value = T.Base.entropic(size: size, using: &randomness)
                let magnitude = T.Base.exactly(value.magnitude())
                
                if  let magnitude: T.Base = magnitude.optional() {
                    let lhs = T(magnitude)
                    let rhs = T(value).magnitude
                    try #require(lhs == rhs)
                }   else {
                    try #require(!T.Base.isArbitrary && T.Base.isSigned)
                }
            }
        }
    }
}
