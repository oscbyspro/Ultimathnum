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
import TestKit

//*============================================================================*
// MARK: * Fibonacci x Small
//*============================================================================*

/// A small integer sequence test suite.
///
/// This suite runs exhaustive tests on:
///
/// - `Fibonacci<I8>`
/// - `Fibonacci<U8>`
///
@Suite struct FibonacciTestsOnSmall {
    
    struct Source<Value: SystemsInteger>: Metadata {
        
        let all: [Fibonacci<Value>]
        
    }
    
    protocol Metadata: CustomTestStringConvertible, Sendable {

        associatedtype Value: SystemsInteger

        var all: [Fibonacci<Value>] { get }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let metadata: [any Metadata] = [
        i8s,
        u8s,
    ]

    static let i8s: Source<I8> = reinterpret([

        (index: -11, element:  89, next: -55), //  0
        (index: -10, element: -55, next:  34), //  1
        (index:  -9, element:  34, next: -21), //  2
        (index:  -8, element: -21, next:  13), //  3
        (index:  -7, element:  13, next:  -8), //  4
        (index:  -6, element:  -8, next:   5), //  5
        (index:  -5, element:   5, next:  -3), //  6
        (index:  -4, element:  -3, next:   2), //  7
        (index:  -3, element:   2, next:  -1), //  8
        (index:  -2, element:  -1, next:   1), //  9
        (index:  -1, element:   1, next:   0), // 10
        (index:   0, element:   0, next:   1), // 11
        (index:   1, element:   1, next:   1), // 12
        (index:   2, element:   1, next:   2), // 13
        (index:   3, element:   2, next:   3), // 14
        (index:   4, element:   3, next:   5), // 15
        (index:   5, element:   5, next:   8), // 16
        (index:   6, element:   8, next:  13), // 17
        (index:   7, element:  13, next:  21), // 18
        (index:   8, element:  21, next:  34), // 19
        (index:   9, element:  34, next:  55), // 20
        (index:  10, element:  55, next:  89), // 21

    ])

    static let u8s: Source<U8> = reinterpret([

        (index:   0, element:   0, next:   1), //  0
        (index:   1, element:   1, next:   1), //  1
        (index:   2, element:   1, next:   2), //  2
        (index:   3, element:   2, next:   3), //  3
        (index:   4, element:   3, next:   5), //  4
        (index:   5, element:   5, next:   8), //  5
        (index:   6, element:   8, next:  13), //  6
        (index:   7, element:  13, next:  21), //  7
        (index:   8, element:  21, next:  34), //  8
        (index:   9, element:  34, next:  55), //  9
        (index:  10, element:  55, next:  89), // 10
        (index:  11, element:  89, next: 144), // 11
        (index:  12, element: 144, next: 233), // 12
        
    ])

    static func reinterpret<T>(_ x: [(index: T, element: T, next: T)]) -> Source<T> {
        Source(all: x.map(reinterpret))
    }
    
    static func reinterpret<T>(_ x: ((index: T, element: T, next: T))) -> Fibonacci<T> {
        Fibonacci(unsafe: Indexacci(minor: x.element, major: x.next, index: x.index))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Fast
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci/small: init(_:) and T.fibonacci(_:)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func fast(source: any Metadata) throws {
        
        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            for x in metadata.all {
                try #require(Fibonacci(x.index)?.components() == x.components())
                try #require(T.Value.fibonacci((((x.index)))) == Fallible(x.minor), "\((T.Value.self, x))")
            }
            
            if  let index = metadata.min.index.decremented().optional() {
                let lossy = metadata.min.major &- metadata.min.minor
                try #require(Fibonacci<T.Value>(index) == nil)
                try #require(T.Value .fibonacci(index) == lossy.veto())
            }
            
            if  let index = metadata.max.index.incremented().optional() {
                try #require(Fibonacci<T.Value>(index) == nil)
                try #require(T.Value .fibonacci(index) == Fallible(metadata.max.major))
            }
            
            if  let index = metadata.max.index.plus(2).optional() {
                let lossy = metadata.max.major &+ metadata.max.minor
                try #require(Fibonacci<T.Value>(index) == nil)
                try #require(T.Value .fibonacci(index) == lossy.veto())
            }
        }
    }
    
    //=----------------------------------------------------------------------------=
    // MARK: Tests x Stride
    //=----------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci/small: incremented()",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func incremented(source: any Metadata) throws {

        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            var a =  metadata.min
            for b in metadata.all.dropLast() {
                try #require(a.components() == b.components())
                a = try #require(a.incremented())
            }
            
            try #require(a.components()  == metadata.max.components())
            try #require(a.incremented() == nil)
        }
    }
    
    @Test(
        "Fibonacci/small: decremented()",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func decremented(source: any Metadata) throws {

        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            var a =  metadata.max
            for b in metadata.all.dropFirst().reversed() {
                try #require(a.components() == b.components())
                a = try #require(a.decremented())
            }

            try #require(a.components()  == metadata.min.components())
            try #require(a.decremented() == nil)
        }
    }
    
    @Test(
        "Fibonacci/small: doubled()",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func doubled(source: any Metadata) throws {

        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            let (s) = metadata.all.firstIndex(where: \.index.isZero)!
            for (i, a) in metadata.all.enumerated() {
                
                let b = a.doubled()
                let j = s + (i-s)*2
                
                if  metadata.all.indices.contains(j) {
                    try #require(b?.components() == metadata.all[j].components())
                    
                }   else {
                    try #require(b?.components() == nil)
                }
            }
        }
    }
    
    @Test(
        "Fibonacci/small: incremented(by:)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func incrementedBy(source: any Metadata) throws {

        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            let (s) = metadata.all.firstIndex(where: \.index.isZero)!
            for     (i, a) in metadata.all.enumerated() {
                for (j, b) in metadata.all.enumerated() {
                    
                    let c = a.incremented(by: b)
                    let k = s + (i-s) + (j-s)
                    
                    if  metadata.all.indices.contains(k) {
                        try #require(c?.components() == metadata.all[k].components())
                        
                    }   else {
                        try #require(c?.components() == nil)
                    }
                }
            }
        }
    }
    
    @Test(
        "Fibonacci/small: decremented(by:)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func decrementedBy(source: any Metadata) throws {

        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            let (s) = metadata.all.firstIndex(where: \.index.isZero)!
            for     (i, a) in metadata.all.enumerated() {
                for (j, b) in metadata.all.enumerated() {
                    
                    let c = a.decremented(by: b)
                    let k = s + (i-s) - (j-s)
                    
                    if  metadata.all.indices.contains(k) {
                        try #require(c?.components() == metadata.all[k].components())
                        
                    }   else {
                        try #require(c?.components() == nil)
                    }
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Toggle
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fibonacci/small: toggled()",
        Tag.List.tags(.exhaustive, .generic),
        arguments: metadata
    )   func toggled(source: any Metadata) throws {
        
        try  whereIs(source)
        func whereIs<T>(_ metadata: T) throws where T: Metadata {
            for x:  Fibonacci in metadata.all {
                if  T.Value.isSigned {
                    let (mid) = metadata.all.count / 2
                    let index = mid + Swift.Int(IX(x.index.toggled()))
                    try #require(x.toggled()?.components() == metadata.all[index].components())
                    
                }   else {
                    try #require(x.toggled()?.components() == nil)
                }
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension FibonacciTestsOnSmall.Metadata {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    var min: (Fibonacci<Value>) {
        self.all.first!
    }

    var max: (Fibonacci<Value>) {
        self.all.last!
    }

    var indices: ClosedRange<Value> {
        self.min.index...self.max.index
    }
    
    var testDescription: String {
        let type = Fibonacci<Value>.self
        let body = self.all.lazy.map(\.description).joined(separator: ", ")
        return "\(type)([\(body)])"
    }
}
