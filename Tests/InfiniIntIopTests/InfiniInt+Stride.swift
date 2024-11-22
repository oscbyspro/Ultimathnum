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
// MARK: * Infini Int x Stdlib x Stride
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnStride {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/stride: Self vs Base",
        Tag.List.tags(.forwarding, .random, .todo),
        arguments: fuzzers
    )   func forwarding(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 256 {
                let start    = T.Base.entropic(size: size, using: &randomness)
                let distance = ((IX)).entropic(using: &randomness)
                let end      = start .advanced(by: distance) as Fallible<T.Base>
                
                if  let end: T.Base = end.optional() {
                    try #require(T(start).advanced(by: Swift.Int(distance)) == T(end))
                    try #require(T(start).distance(to: T(end)) == Swift.Int(distance))
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
            }
        }
    }
}
