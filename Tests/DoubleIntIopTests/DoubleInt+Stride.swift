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
// MARK: * Double Int x Stdlib x Stride
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnStride {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/stride: Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func forwarding(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
