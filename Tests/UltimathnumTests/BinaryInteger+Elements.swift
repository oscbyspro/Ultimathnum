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
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Elements
//*============================================================================*

@Suite struct BinaryIntegerTestsOnElements {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/elements: systems(...) is like init(load:) or nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func systemsIsLikeInitLoadOrNil(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size   = IX(size: T.self) ?? 256
            let count  = size /  IX(size: T.Element.Magnitude.self)
            var source = Array(repeating: T.Element.Magnitude.zero, count: Swift.Int(count))
            try source.withUnsafeMutableBinaryIntegerBody { source in
                for _ in 0 ..< 32 {
                    randomness.fill(source)
                    
                    let result: Optional<T> = T.systems {
                        $0.initialize(to: DataInt.Body(source))
                    }
                    
                    if  T.isArbitrary {
                        try #require(result == nil)
                    }   else {
                        try #require(result == T(load: DataInt(source)))
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/elements: arbitrary(...) is like init(load:) or nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func arbitraryIsLikeInitLoadOrNil(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var source = Array(repeating: T.Element.Magnitude.zero, count: 4)
            try source.withUnsafeMutableBinaryIntegerBody { source in
                for _ in 0 ..< 32 {
                    randomness.fill(source)
                    let length = IX.random(in: IX.zero...source.count, using: &randomness)
                    let prefix = DataInt.Body(source[unchecked: ..<length])
                    
                    always: do {
                        let result = T.arbitrary(uninitialized: prefix.count) {
                            $0.initialize(to: prefix)
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                    
                    always: do {
                        let result = T.arbitrary(uninitialized: source.count) {
                            $0[unchecked: ..<prefix.count].initialize(to: prefix)
                            return prefix.count as IX
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                    
                    for bit in Bit.all {
                        let result = T.arbitrary(uninitialized: prefix.count, repeating: bit) {
                            $0.initialize(to: prefix)
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix, repeating: bit)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                    
                    for bit in Bit.all {
                        let result = T.arbitrary(uninitialized: source.count, repeating: bit) {
                            $0[unchecked: ..<prefix.count].initialize(to: prefix)
                            return prefix.count as IX
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix, repeating: bit)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/elements: arbitrary(...) where count is invalid is nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func arbitraryWhereCountIsInvalidIsNil(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let capacity: IX = DataInt<T.Element.Magnitude>.capacity
            
            for _ in 0 ..< 32 {
                try whereIs(count: IX.random(in: capacity...IX.max, using: &randomness))
                try whereIs(count: IX.random(in: IX.min..<00000000, using: &randomness)!)
            }
            
            func whereIs(count: IX) throws {
                always: do {
                    try #require(nil == T.arbitrary(uninitialized: count) { _ in IX.zero })
                    try #require(nil == T.arbitrary(uninitialized: count) { _ in Void( ) })
                }
                
                for bit in Bit.all {
                    try #require(nil == T.arbitrary(uninitialized: count, repeating: bit) { _ in IX.zero })
                    try #require(nil == T.arbitrary(uninitialized: count, repeating: bit) { _ in Void( ) })
                }
            }
        }
    }
}
