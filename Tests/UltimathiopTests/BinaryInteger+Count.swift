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
// MARK: * Binary Integer x Stdlib x Count
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnCount {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/count: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 256 {
                let x = T.entropic(size: size, using: &randomness)
                
                always: do {
                    let expectation = switch T.isArbitrary {
                    case  true: Swift.Int(raw: x.entropy())
                    case false: Swift.Int(raw:    x.size())
                    }
                    
                    try #require(expectation == T.Stdlib(x).bitWidth)
                }
                
                always: do {
                    let expectation = Swift.Int(IX(IX(raw: x.ascending(Bit.zero)).magnitude()))
                    try #require(expectation == T.Stdlib(x).trailingZeroBitCount)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/count: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {
            for _ in 0 ..< 256 {
                let x = T.entropic(using: &randomness)
                
                always: do {
                    let expectation = Swift.Int(IX(IX(raw: x.count(Bit.one)).magnitude()))
                    try #require(expectation == T.Stdlib(x).nonzeroBitCount)
                }
                
                always: do {
                    let expectation = Swift.Int(IX(IX(raw: x.descending(Bit.zero)).magnitude()))
                    try #require(expectation == T.Stdlib(x).leadingZeroBitCount)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Stdlib x Count x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnCountEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/count/edge-cases: T.zero as Swift.BinaryInteger",
        Tag.List.tags(.exhaustive, .generic, .important),
        arguments: typesAsLenientIntegerInteroperable
    )   func zeroAsSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type
    )   throws {

        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            #expect(T.Stdlib.zero.trailingZeroBitCount == T.Stdlib.zero.bitWidth)
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/count/edge-cases: T.zero as Swift.FixedWidthInteger",
        Tag.List.tags(.exhaustive, .generic, .important),
        arguments: typesAsSystemsIntegerInteroperable
    )   func zeroAsSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type
    )   throws {

        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {
            #expect(T.Stdlib.zero    .nonzeroBitCount == T.Stdlib.zero)
            #expect(T.Stdlib.zero.leadingZeroBitCount == T.Stdlib.zero.bitWidth)
        }
    }
}
