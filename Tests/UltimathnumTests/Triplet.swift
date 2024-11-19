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
// MARK: * Triplet
//*============================================================================*

@Suite struct TripletTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Triplet: from Source as Base",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func fromSourceAsBase(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let base = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let wide = Triplet(base)
                
                if  T.isSigned {
                    let low  = T.Magnitude(raw: base)
                    let mid  = T.Magnitude(repeating: base.appendix)
                    let high = T(repeating: base.appendix)
                    try #require(wide == Triplet(low: low, mid: mid, high: high))
                    
                }   else {
                    let low  = T.Magnitude(raw: base)
                    let mid  = T.Magnitude(repeating: Bit.zero)
                    let high = T(repeating: Bit.zero)
                    try #require(wide == Triplet(low: low, mid: mid, high: high))
                }
            }
        }
    }
}
