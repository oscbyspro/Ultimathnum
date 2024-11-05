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
    
    static let metadataAsSystemsInteger = metadata.filter({ !$0.type.isArbitrary })
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci: start is (0, 0, 1)",
        Tag.List.tags(.generic),
        arguments: metadata
    )   func startIsZeroZeroOne(metadata: Metadata) throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(Fibonacci<T>(      ).components() == (0, 0, 1))
            try #require(Fibonacci<T>(T.zero).components() == (0, 0, 1))
        }
    }
    
    @Test(
        "Fibonacci: pairs are coprime",
        Tag.List.tags(.generic, .random),
        arguments: metadata, fuzzers
    )   func pairsAreCoprime(metadata: Metadata, randomness: consuming FuzzerInt) throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let arbitrary: IX = conditional(debug: 144, release: 369)
            let low  = T(metadata.low  ?? -arbitrary)
            let high = T(metadata.high ??  arbitrary)
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let index = T.random(in: low...high, using: &randomness)
                let fibonacci = try #require(try Fibonacci(index))
                try #require(fibonacci.element.euclidean(fibonacci.next) == 1)
            }
        }
    }
    
    /// Generates random values to check the following invariant:
    ///
    ///     f(x) * f(y) == (f(x+y+1) / f(x+1) - f(y+1)) * f(x+1) + f(x+y+1) % f(x+1)
    ///
    /// ### Calls: Fibonacci<Value>
    ///
    /// - Fibonacci.init(\_:)
    /// - Fibonacci/increment(by:)
    /// - Fibonacci/decrement(by:)
    ///
    /// ### Calls: BinaryInteger
    ///
    /// - BinaryInteger/plus(\_:)
    /// - BinaryInteger/minus(\_:)
    /// - BinaryInteger/times(\_:)
    /// - BinaryInteger/quotient(\_:)
    /// - BinaryInteger/division(\_:)
    ///
    @Test(
        "Fibonacci: math invariant",
        Tag.List.tags(.generic, .random),
        arguments: metadata, fuzzers
    )   func mathInvariant(
        metadata: Metadata,
        randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let arbitrary: IX = conditional(debug: 144, release: 369)
            let low   = T(metadata.low  ?? -arbitrary)
            let high  = T(metadata.high ??  arbitrary)
            //=----------------------------------=
            let x = Bad.message("arithmetic")
            //=----------------------------------=
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let i = next()
                
                try #require((low...high).contains(i.0))
                try #require((low...high).contains(i.1))
                try #require((low...high).contains(i.2))
                
                var a = try Fibonacci(i.0)
                let b = try Fibonacci(i.1)
                let c = try #require(a.next.division(b.next)).prune(x)
                
                try a.decrement(by: b)
                
                let d = try a.element.times(b.element).prune(x)
                let e = try c.quotient.minus((a.next)).prune(x).times(b.next).prune(x).plus(c.remainder).prune(x)
                
                try a.increment(by: b)
                try #require((d) == e)
            }
            
            /// Two random indices and their difference in [low, high].
            func next() -> (T, T, T) {
                var a = low, b = high
                
                let i = T.random(in: a...b, using: &randomness)
                
                (a, b) = (
                    Swift.max(a, i.minus(b).optional() ?? a),
                    Swift.min(b, i.minus(a).optional() ?? b)
                )
                
                let j = T.random(in: a...b, using: &randomness)
                return (i, j, i - j)
            }
        }
    }
}

//*============================================================================*
// MARK: * Fibonacci x Utilities
//*============================================================================*

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func components() -> (index: Value, element: Value, next: Value) {
        (self.index, self.element, self.next)
    }
}
