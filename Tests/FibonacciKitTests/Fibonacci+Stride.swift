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
// MARK: * Fibonacci x Stride
//*============================================================================*

@Suite struct FibonacciTestsOnStride {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test(
        "Fibonacci/stride: for each (index, increment, decrement) in range",
        Tag.List.tags(.generic, .exhaustive),
        arguments: FibonacciTests.metadata
    )   func forEachIndexIncrementDecrementInRange(
        metadata:  FibonacciTests.Metadata
    )   throws {

        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let arbitrary: IX = conditional(debug: 144, release: 369)
            let low:  IX = metadata.low  ?? -arbitrary
            let high: IX = metadata.high ??  arbitrary
            var fibonacci = try #require(Fibonacci(T(low)))

            if  let _ = metadata.low {
                try #require(fibonacci.decremented() == nil)
                
                if  let index = fibonacci.index.decremented().optional() {
                    try #require(Fibonacci(index) == nil)
                }
            }

            while fibonacci.index < high {
                let minor = fibonacci.minor
                let major = fibonacci.major
                let index = fibonacci.index
                fibonacci = try #require(fibonacci.incremented())
                
                let expectation = Indexacci(
                    minor: major,
                    major: major + minor,
                    index: index + 1
                )
                
                try #require(expectation == fibonacci.components())
                try #require(expectation == Fibonacci(expectation.index)?.components())
            }

            if  let _ = metadata.high {
                try #require(fibonacci.incremented() == nil)
                
                if  let index = fibonacci.index.incremented().optional() {
                    try #require(Fibonacci(index) == nil)
                }
            }

            while fibonacci.index > low {
                let minor = fibonacci.minor
                let major = fibonacci.major
                let index = fibonacci.index
                fibonacci = try #require(fibonacci.decremented())
                
                let expectation = Indexacci(
                    minor: major - minor,
                    major: minor,
                    index: index - 1
                )
                
                try #require(expectation == fibonacci.components())
                try #require(expectation == Fibonacci(expectation.index)?.components())
            }
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Jump
    //=------------------------------------------------------------------------=

    @Test(
        "Fibonacci/stride: random jump in range",
        Tag.List.tags(.generic, .random),
        arguments: FibonacciTests.metadata, fuzzers
    )   func randomJumpInRange(
        metadata:  FibonacciTests.Metadata, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let low  = T(metadata.low  ?? -369)
            let high = T(metadata.high ??  369)

            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let i = next()

                try #require((low...high).contains(i.0))
                try #require((low...high).contains(i.1))
                try #require((low...high).contains(i.2))

                let a = try #require(Fibonacci(i.0))
                let b = try #require(Fibonacci(i.1))
                let c = try #require(Fibonacci(i.2))
                
                try #require(a.incremented(by: b)?.components() == c.components())
                try #require(b.incremented(by: a)?.components() == c.components())
                try #require(c.decremented(by: a)?.components() == b.components())
                try #require(c.decremented(by: b)?.components() == a.components())
            }

            func next() -> (T, T, T) {
                var a = low, b = high

                let i = T.random(in: a...b, using: &randomness)

                (a, b) = (
                    Swift.max(a, a.minus(i).optional() ?? a),
                    Swift.min(b, b.minus(i).optional() ?? b)
                )

                let j = T.random(in: a...b, using: &randomness)
                return (i, j, i + j)
            }
        }
    }

    @Test(
        "Fibonacci/stride: random jump out of bounds throws error",
        Tag.List.tags(.generic, .random),
        arguments: FibonacciTests.metadataAsSystemsInteger, fuzzers
    )   func randomJumpOutOfBoundsThrowsError(
        metadata: FibonacciTests.Metadata, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let low  = try T(#require(metadata.low ))
            let high = try T(#require(metadata.high))

            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let i = T.random(in: low...high, using: &randomness)
                let a = try #require(Fibonacci(i))

                if  let k = (i+1).minus(low).optional(),  k <= high {
                    let j = T.random(in: k...high, using: &randomness)
                    let b = try #require(Fibonacci(j))
                    try #require(a.decremented(by: b) == nil, "i - j < low")
                }

                if  let k = i.minus(high+1).optional(),  k >= low {
                    let j = T.random(in: low...k, using: &randomness)
                    let b = try #require(Fibonacci(j))
                    try #require(a.decremented(by: b) == nil, "i - j > high")
                }

                if  let k = low.minus(i+1).optional(),   k >= low {
                    let j = T.random(in: low...k, using: &randomness)
                    let b = try #require(Fibonacci(j))
                    try #require(a.incremented(by: b) == nil, "i + j < low")
                }

                if  let k = (high+1).minus(i).optional(), k <= high {
                    let j = T.random(in: k...high, using: &randomness)
                    let b = try #require(Fibonacci(j))
                    try #require(a.incremented(by: b) == nil, "i + j > high")
                }
            }
        }
    }
}
