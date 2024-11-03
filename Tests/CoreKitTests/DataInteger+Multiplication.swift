//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Data Integer x Multiplication
//*============================================================================*

@Suite struct DataIntegerTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Note: The increment must be zero if the combined input size is zero.
    @Test(
        "DataInt/initialize(to:times:plus:) - none-by-none-plus-none",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegersAsUnsigned
    )   func multiplicationOfNoneByNonePlusNone(type: any CoreIntegerAsUnsigned.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            try Ɣexpect(squared:          [] as [T], plus: T.zero, is: [] as [T])
            try Ɣexpect([] as [T], times: [] as [T], plus: T.zero, is: [] as [T])
        }
    }
    
    @Test(
        "DataInt/initialize(to:times:plus:) - some-by-none-plus-some [uniform]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegersAsUnsigned, fuzzers
    )   func multiplicationOfSomeByNonePlusSome(type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let mul = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                try Ɣexpect([mul], times: [   ] as [T], plus: add, is: [add])
                try Ɣexpect([   ], times: [mul] as [T], plus: add, is: [add])
            }
        }
    }
    
    @Test(
        "DataInt/initialize(to:times:plus:) - some-by-some-plus-some [uniform]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegersAsUnsigned, fuzzers
    )   func multiplicationOfSomeBySomePlusSome(type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = (T).random(using: &randomness)
                let rhs = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                let res = lhs.multiplication(rhs, plus: add)
                try Ɣexpect([lhs], times:  [rhs], plus: add, is: [res.low, res.high])
                try Ɣexpect([rhs], times:  [lhs], plus: add, is: [res.low, res.high])
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let mul = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                let res = mul.multiplication(mul, plus: add)
                try Ɣexpect(squared:       [mul], plus: add, is: [res.low, res.high])
                try Ɣexpect([mul], times:  [mul], plus: add, is: [res.low, res.high])
            }
        }
    }
    
    @Test(
        "DataInt/initialize(to:times:plus:) - many-by-some-plus-some [uniform]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegersAsUnsigned, fuzzers
    )   func multiplicationOfManyBySomePlusSome(type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T].random(count: 0...32, using: &randomness)
                let rhs = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                var res = lhs + [0]
                
                try res.withUnsafeMutableBinaryIntegerBody {
                    try #require($0.multiply(by: rhs, add: add).isZero)
                }
                
                try Ɣexpect((lhs), times: [rhs], plus: add, is: res)
                try Ɣexpect([rhs], times: (lhs), plus: add, is: res)
            }
        }
    }
    
    /// - Note: The increment must be zero if the combined input size is zero.
    @Test(
        "DataInt/initialize(to:times:plus:) - many-by-many-plus-some [uniform]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegersAsUnsigned, fuzzers
    )   func multiplicationOfManyByManyPlusSome(type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 08, release: 1024) {
                let lhs = [T].random(count: 0...32, using: &randomness)
                let rhs = [T].random(count: 0...32, using: &randomness)
                let add = (T).random(using: &randomness)
                var res = [T](repeating: 144, count: lhs.count + rhs.count)
                
                if  lhs.isEmpty, rhs.isEmpty { continue }
                
                res.withUnsafeMutableBinaryIntegerBody { res in
                    lhs.withUnsafeBinaryIntegerBody { lhs in
                        rhs.withUnsafeBinaryIntegerBody { rhs in
                            res.initializeByLongAlgorithm(to: lhs, times: rhs, plus: add)
                        }
                    }
                }
                
                try Ɣexpect(lhs, times: rhs, plus: add, is: res)
                try Ɣexpect(rhs, times: lhs, plus: add, is: res)
            }
            
            for _ in 0 ..< conditional(debug: 08, release: 1024) {
                let mul = [T].random(count: 0...32, using: &randomness)
                let add = (T).random(using: &randomness)
                var res = [T](repeating: 144, count: mul.count * 2)
                
                if  mul.isEmpty { continue }
                
                res.withUnsafeMutableBinaryIntegerBody { res in
                    mul.withUnsafeBinaryIntegerBody { mul in
                        res.initializeByLongAlgorithm(toSquareProductOf: mul, plus: add)
                    }
                }
                
                try Ɣexpect(squared:    mul, plus: add, is: res)
                try Ɣexpect(mul, times: mul, plus: add, is: res)
            }
        }
    }
}
