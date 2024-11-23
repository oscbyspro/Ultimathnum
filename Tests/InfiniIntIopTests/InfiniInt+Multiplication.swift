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
// MARK: * Infini Int x Stdlib x Multiplication
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/multiplication: Self vs Base",
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
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.Base.entropic(size: size, using: &randomness)
                let b = T.Base.entropic(size: size, using: &randomness)
                let c = a.times(b) as Fallible<T.Base>
                
                if  let c: T.Base = c.optional() {
                    try #require(T(c) == reduce(T(a), *,  T(b)))
                    try #require(T(c) == reduce(T(a), *=, T(b)))
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
            }
        }
    }
}
