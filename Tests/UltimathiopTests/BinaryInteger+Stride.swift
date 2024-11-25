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
// MARK: * Binary Integer x Stdlib x Stride
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnStride {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/stride: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 256 {
                let a = T .entropic(size:  size, using: &randomness)
                let b = IX.entropic(using: &randomness)
                let c = a.advanced(by: b) as Fallible<T>
                
                if  let end: T = c.optional() {
                    try #require(T.Stdlib(a).advanced(by: Swift.Int(b)) == T.Stdlib(end))
                    try #require(T.Stdlib(a).distance(to: T.Stdlib(end)) == Swift.Int(b))
                }   else {
                    try #require(!T.isArbitrary)
                }
            }
        }
    }
}
