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
// MARK: * Tupleacci
//*============================================================================*

@Suite struct TupleacciTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let types: [any BinaryInteger.Type] = FibonacciTests.metadata.map(\.type)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Tupleacci: start",
        Tag.List.tags(.generic),
        arguments: types
    )   func start(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(Tupleacci<T>.fibonacci() == Tupleacci(minor: 0, major: 1))
        }
    }
    
    @Test(
        "Tupleacci: accessors",
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
                let value = Tupleacci<T>.init(minor: minor, major: major)

                try #require(value.minor == minor)
                try #require(value.major == major)
                try #require(value.components() == (minor, major))
                
                always: do {
                    var   other = Tupleacci(minor: T.zero, major: T.zero)
                    other.minor = minor
                    other.major = major
                    try #require((other) == value)
                }
            }
        }
    }
}
