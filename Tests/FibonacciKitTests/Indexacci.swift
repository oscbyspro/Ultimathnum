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
// MARK: * Indexacci
//*============================================================================*

@Suite struct IndexacciTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let types: [any BinaryInteger.Type] = FibonacciTests.metadata.map(\.type)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Indexacci: start",
        Tag.List.tags(.generic),
        arguments: types
    )   func start(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(Indexacci<T>.fibonacci() == Indexacci(minor: 0, major: 1, index: 0))
        }
    }
    
    @Test(
        "Indexacci: accessors",
        Tag.List.tags(.generic, .random),
        arguments: types, fuzzers
    )   func accessors(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let shift = Shift<T.Magnitude>.max(or: 255)
                let minor = T.random(through: shift, using: &randomness)
                let major = T.random(through: shift, using: &randomness)
                let index = T.random(through: shift, using: &randomness)
                let tuple = Tupleacci<T>.init(minor: minor, major: major)
                let value = Indexacci<T>.init(tuple: tuple, index: index)
                
                try #require(value.minor == minor)
                try #require(value.major == major)
                try #require(value.index == index)
                try #require(value.tuple == tuple)
                try #require(value.components() == (tuple, index))
                
                always: do {
                    var   other = Indexacci(minor: T.zero, major: T.zero, index: T.zero)
                    other.minor = minor
                    other.major = major
                    other.index = index
                    try #require(value == other)
                }
            }
        }
    }
}
