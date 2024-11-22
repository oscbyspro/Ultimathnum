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
// MARK: * Infini Int x Stdlib x Count
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnCount {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/count: Self vs Base",
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
            
            for _ in 0 ..< 1024 {
                let value = T.Base.entropic(size: size, using: &randomness)
                
                always: do {
                    let a = T(value).bitWidth
                    let b = Swift.Int(IX(raw: value.entropy()))
                    try #require(a == b)
                }
                
                always: do {
                    let a = T(value).trailingZeroBitCount
                    let b = Swift.Int(IX(IX(raw: value.ascending(Bit.zero)).magnitude()))
                    try #require(a == b)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Infini Int x Stdlib x Count x Edge Cases
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnCountEdgeCases {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/count/edge-cases: 0.trailingZeroBitCount",
        Tag.List.tags(.exhaustive, .important, .todo)
    )   func trailingZeroBitCountOfZero() throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            #expect(T.zero.trailingZeroBitCount ==  1)
            #expect(T.zero.trailingZeroBitCount ==  T.zero.bitWidth)
            #expect(T.Base.zero.ascending(Bit.zero) == Count.infinity)
        }
    }
}
