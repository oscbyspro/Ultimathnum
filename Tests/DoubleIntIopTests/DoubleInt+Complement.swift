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
// MARK: * Double Int x Stdlib x Complement
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnComplement {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/complement: magnitude",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func magnitude(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
