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
import TestKit2

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
        Metadata(type: I8  .self, low: 0, high: 10),
        Metadata(type: U8  .self, low: 0, high: 12),
        Metadata(type: I16 .self, low: 0, high: 22),
        Metadata(type: U16 .self, low: 0, high: 23),
        Metadata(type: I32 .self, low: 0, high: 45),
        Metadata(type: U32 .self, low: 0, high: 46),
        Metadata(type: I64 .self, low: 0, high: 91),
        Metadata(type: U64 .self, low: 0, high: 92),
        
        Metadata(type: I8x2.self, low: 0, high: 22),
        Metadata(type: U8x2.self, low: 0, high: 23),
        Metadata(type: I8x4.self, low: 0, high: 45),
        Metadata(type: U8x4.self, low: 0, high: 46),
        Metadata(type: I8x8.self, low: 0, high: 91),
        Metadata(type: U8x8.self, low: 0, high: 92),
        
        Metadata(type: I8L .self, low: 0, high: nil),
        Metadata(type: U8L .self, low: 0, high: nil)
    ]
    
    static let metadataAsSystemsInteger = metadata.filter {
        !$0.type.isArbitrary
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
            try #require(Fibonacci<T>(      ).components() == (0, 0, 1))
            try #require(Fibonacci<T>(T.zero).components() == (0, 0, 1))
        }
    }
    
    @Test(
        "Fibonacci: accessors",
        Tag.List.tags(.generic),
        arguments: metadata
    )   func accessors(metadata: Metadata) throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let fibonacci = try Fibonacci<T>( 4)
            try #require(fibonacci.index   == 4)
            try #require(fibonacci.element == 3)
            try #require(fibonacci.next    == 5)
            try #require(fibonacci.components() == (4, 3, 5))
        }
    }
}
