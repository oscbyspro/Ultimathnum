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
import TestKit2

//*============================================================================*
// MARK: * Fibonacci x Stride
//*============================================================================*

@Suite struct FibonacciTestsOnStride {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci: for each (index, increment, decrement) in range",
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
            var fibonacci = try #require(try Fibonacci(T(low)))
            
            scope: if let _ = metadata.low {
                try #require(throws: Fibonacci<T>.Error.indexOutOfBounds) {
                    try fibonacci.decrement()
                }
                
                guard T.isSigned else { break scope }
                try #require(throws: Fibonacci<T>.Error.indexOutOfBounds) {
                    try Fibonacci(T(fibonacci.index - 1))
                }
            }
            
            while fibonacci.index < high {
                let (i, a, b) =  fibonacci.components()
                try #require(try fibonacci.increment())
                try #require(fibonacci.components() == (i + 1, b, b + a))
                
                let (indexed) = try Fibonacci(fibonacci.index)
                try #require(fibonacci.components() == indexed.components())
            }
            
            scope: if let _ = metadata.high {
                try #require(throws: Fibonacci<T>.Error.overflow) {
                    try fibonacci.increment()
                }
                
                try #require(throws: Fibonacci<T>.Error.overflow) {
                    try Fibonacci(T(fibonacci.index + 1))
                }
            }
            
            while fibonacci.index > low {
                let (i, a, b) =  fibonacci.components()
                try #require(try fibonacci.decrement())
                try #require(fibonacci.components() == (i - 1, b - a, a))
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
        metadata:  FibonacciTests.Metadata,
        randomness: consuming FuzzerInt
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
                
                let a = try #require(try Fibonacci(i.0))
                let b = try #require(try Fibonacci(i.1))
                let c = try #require(try Fibonacci(i.2))
                
                always: do {
                    var x: Fibonacci<T> = a
                    try #require(try x.increment(by: b))
                    try #require(x.components() == c.components())
                }
                   
                always: do {
                    var x: Fibonacci<T> = b
                    try #require(try x.increment(by: a))
                    try #require(x.components() == c.components())
                }
                
                always: do {
                    var x: Fibonacci<T> = c
                    try #require(try x.decrement(by: b))
                    try #require(x.components() == a.components())

                }
                
                always: do {
                    var x: Fibonacci<T> = c
                    try #require(try x.decrement(by: a))
                    try #require(x.components() == b.components())
                }
            }
            
            /// Two random indices and their sum in [low, high].
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
        Tag.List.tags(.generic, .todo, .random),
        arguments: FibonacciTests.metadataAsSystemsInteger, fuzzers
    )   func randomJumpOutOfBoundsThrowsError(
        metadata: FibonacciTests.Metadata,
        randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(metadata.type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let low  = try T(#require(metadata.low ))
            let high = try T(#require(metadata.high))
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let i = T.random(in: low...high, using: &randomness)
                var a = try Fibonacci(i)
                
                if  let k = (i+1).minus(low).optional(),  k <= high {
                    let j = T.random(in: k...high, using: &randomness)
                    let b = try Fibonacci(j)
                    
                    try #require(throws: Fibonacci<T>.Error.indexOutOfBounds) {
                        try a.decrement(by: b) // i - j < low
                    }
                }
                
                if  let k = i.minus(high+1).optional(),  k >= low {
                    let j = T.random(in: low...k, using: &randomness)
                    let b = try Fibonacci(j)
                    
                    try #require(low.isNegative, "todo: index < 0")
                    try #require(throws: Fibonacci<T>.Error.indexOutOfBounds) {
                        try a.decrement(by: b) // i - j > high
                    }
                }
                
                if  let k = low.minus(i+1).optional(),   k >= low {
                    let j = T.random(in: low...k, using: &randomness)
                    let b = try Fibonacci(j)
                    
                    try #require(low.isNegative, "todo: index < 0")
                    try #require(throws: Fibonacci<T>.Error.indexOutOfBounds) {
                        try a.decrement(by: b) // i + j < low
                    }
                }
                                
                if  let k = (high+1).minus(i).optional(), k <= high {
                    let j = T.random(in: k...high, using: &randomness)
                    let b = try Fibonacci(j)
                    
                    try #require(throws: Fibonacci<T>.Error.overflow) {
                        try a.increment(by: b) // i + j > high
                    }
                }
            }
        }
    }
}
