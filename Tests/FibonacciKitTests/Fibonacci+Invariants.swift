//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import FibonacciKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci x Invariants
//*============================================================================*

@Suite struct FibonacciTestsOnInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci/invariants: pairs are coprime",
        Tag.List.tags(.generic, .random),
        arguments: FibonacciTests.metadata, fuzzers
    )   func pairsAreCoprime(
        metadata:  FibonacciTests.Metadata, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let arbitrary: IX = conditional(debug: 144, release: 369)
            let low  = T(metadata.low  ?? -arbitrary)
            let high = T(metadata.high ??  arbitrary)
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let index = T.random(in: low...high, using: &randomness)
                let fibonacci = try #require(try Fibonacci(index))
                try #require(fibonacci.minor.euclidean(fibonacci.major) == 1)
            }
        }
    }
    
    /// Generates random values to check the following invariant:
    ///
    ///     f(a) * f(b) == (f(a+b+1) / f(a+1) - f(b+1)) * f(a+1) + f(a+b+1) % f(a+1) where (a != -1)
    ///
    /// ### Calls: Fibonacci
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
        "Fibonacci/invariants: multiplication of elements",
        Tag.List.tags(.generic, .random),
        arguments: FibonacciTests.metadata, fuzzers
    )   func multiplicationOfElements(
        metadata:  FibonacciTests.Metadata, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let arbitrary: IX = conditional(debug: 144, release: 369)
            let low   = T(metadata.low  ?? -arbitrary)
            let high  = T(metadata.high ??  arbitrary)
            
            for _ in 0 ..< conditional(debug: 32, release: 128) {
                let i = next()
                
                try #require((low...high).contains(i.0))
                try #require((low...high).contains(i.1))
                try #require((low...high).contains(i.2))
                
                guard i.1 != IX(-1) else { continue }
                
                let a = try #require(Fibonacci(i.0))
                let b = try #require(Fibonacci(i.1))
                let c = try #require(a.major.division(b.major)?.optional())
                let d = try #require(a.decremented(by: b))
                let e = try #require(d.incremented(by: b))
                
                let x = (d.minor    &* b.minor)
                let y = (c.quotient &- d.major) &* b.major &+ c.remainder
                
                try #require(a == e)
                try #require(x == y)
            }
            
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
