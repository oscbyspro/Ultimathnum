//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import FibonacciKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

@Suite struct FibonacciTests {
    
    typealias I8x2 = DoubleInt<I8>
    typealias I8x4 = DoubleInt<I8x2>
    typealias I8x8 = DoubleInt<I8x4>
    
    typealias U8x2 = DoubleInt<U8>
    typealias U8x4 = DoubleInt<U8x2>
    typealias U8x8 = DoubleInt<U8x4>
    
    typealias I8L  = InfiniInt<I8>
    typealias U8L  = InfiniInt<U8>
    
    struct Metadata {
        let type: any BinaryInteger.Type
        let low:  Optional<IX>
        let high: Optional<IX>
    }
    
    static let metadata: [Metadata] = [
        Metadata(type: I8  .self, low: -11, high: 10),
        Metadata(type: U8  .self, low:   0, high: 12),
        Metadata(type: I16 .self, low: -23, high: 22),
        Metadata(type: U16 .self, low:   0, high: 23),
        Metadata(type: I32 .self, low: -46, high: 45),
        Metadata(type: U32 .self, low:   0, high: 46),
        Metadata(type: I64 .self, low: -92, high: 91),
        Metadata(type: U64 .self, low:   0, high: 92),
        
        Metadata(type: I8x2.self, low: -23, high: 22),
        Metadata(type: U8x2.self, low:   0, high: 23),
        Metadata(type: I8x4.self, low: -46, high: 45),
        Metadata(type: U8x4.self, low:   0, high: 46),
        Metadata(type: I8x8.self, low: -92, high: 91),
        Metadata(type: U8x8.self, low:   0, high: 92),
        
        Metadata(type: I8L .self, low: nil, high: nil),
        Metadata(type: U8L .self, low:   0, high: nil)
    ]
    
    static let metadataAsSystemsInteger: [Metadata] = metadata.filter {
        $0.type.isArbitrary == false
    }
    
    static let metadataAsMaximalInteger: [Metadata] = metadata.filter {
        $0.type.isMaximal
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci: start",
        Tag.List.tags(.generic),
        arguments: metadata
    )   func start(metadata: Metadata) throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let components = Indexacci<T>(minor: 0, major: 1, index: 0)
            try #require(try #require(Fibonacci<T>(      )).components() == components)
            try #require(try #require(Fibonacci<T>(T.zero)).components() == components)
        }
    }
    
    @Test(
        "Fibonacci: accessors",
        Tag.List.tags(.generic),
        arguments: metadata
    )   func accessors(metadata: Metadata) throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let instance = try #require(Fibonacci<T>(4))
            let components = Indexacci<T>(minor: 3, major: 5, index: 4)
            try #require(instance.index == 4)
            try #require(instance.minor == 3)
            try #require(instance.major == 5)
            try #require(instance.components() == components)
        }
    }
}

//*============================================================================*
// MARK: * Fibonacci x Edge Cases
//*============================================================================*

@Suite struct FibonacciEdgeCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci/edge-cases: from infinite index is nil",
        Tag.List.tags(.generic, .random),
        arguments: FibonacciTests.metadataAsMaximalInteger, fuzzers
    )   func fromInfiniteIndexIsNil(
        metadata: FibonacciTests.Metadata, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let index = T.entropic(size: 256, as: Domain.natural, using: &randomness).toggled()
            try #require(index.isInfinite)
            try #require(Fibonacci<T>(index) == nil)
            try #require(T.fibonacci (index) == nil)
        }
    }
}
