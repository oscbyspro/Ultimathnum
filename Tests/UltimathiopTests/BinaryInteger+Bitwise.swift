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
// MARK: * Binary Integer x Stdlib x Bitwise
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/bitwise: as Swift.BinaryInteger",
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
                    let expectation = T.Stdlib( ~x)
                    try #require(expectation == ~T.Stdlib(x))
                }
            }
            
            for _ in 0 ..< 32 {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                
                always: do {
                    let expectation = T.Stdlib(a & b)
                    try #require(expectation == reduce(T.Stdlib(a), &,  T.Stdlib(b)))
                    try #require(expectation == reduce(T.Stdlib(a), &=, T.Stdlib(b)))
                }
                
                always: do {
                    let expectation = T.Stdlib(a | b)
                    try #require(expectation == reduce(T.Stdlib(a), |,  T.Stdlib(b)))
                    try #require(expectation == reduce(T.Stdlib(a), |=, T.Stdlib(b)))
                }
                
                always: do {
                    let expectation = T.Stdlib(a ^ b)
                    try #require(expectation == reduce(T.Stdlib(a), ^,  T.Stdlib(b)))
                    try #require(expectation == reduce(T.Stdlib(a), ^=, T.Stdlib(b)))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/bitwise: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {            
            for _ in 0 ..< 32 {
                let x = T.entropic(using: &randomness)
                
                always: do {
                    let expectation = T.Stdlib(x.reversed(U8.self))
                    try #require(expectation == T.Stdlib(x).byteSwapped)
                }
                
                always: do {
                    let expectation = T.Stdlib(x.endianness(Order.ascending))
                    try #require(expectation == T.Stdlib(x).littleEndian)
                    try #require(expectation == T.Stdlib(littleEndian: T.Stdlib(x)))
                }
                
                always: do {
                    let expectation = T.Stdlib(x.endianness(Order.descending))
                    try #require(expectation == T.Stdlib(x).bigEndian)
                    try #require(expectation == T.Stdlib(bigEndian: T.Stdlib(x)))
                }
            }
        }
    }
}
