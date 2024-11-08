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
import TestKit

//*============================================================================*
// MARK: * Data Integer x Multiplication
//*============================================================================*

@Suite struct DataIntegerTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DataInt/multiplication: none × none + none",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsUnsigned
    )   func noneByNonePlusNone(
        type: any CoreIntegerAsUnsigned.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            //  note that the increment must be zero if the combined count is zero
            try Ɣrequire([] as [T], squared:(((()))), plus: T.zero, is: [] as [T])
            try Ɣrequire([] as [T], times: [] as [T], plus: T.zero, is: [] as [T])
        }
    }
    
    @Test(
        "DataInt/multiplication: some × none + some",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func someByNonePlusSome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let mul = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                try Ɣrequire([mul], times: [   ] as [T], plus: add, is: [add])
                try Ɣrequire([   ], times: [mul] as [T], plus: add, is: [add])
            }
        }
    }
    
    @Test(
        "DataInt/multiplication: some × some + some",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func someBySomePlusSome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = (T).random(using: &randomness)
                let rhs = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                let res = lhs.multiplication(rhs, plus: add)
                try Ɣrequire([lhs], times: [rhs], plus: add, is: [res.low, res.high])
                try Ɣrequire([rhs], times: [lhs], plus: add, is: [res.low, res.high])
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let mul = (T).random(using: &randomness)
                let add = (T).random(using: &randomness)
                let res = mul.multiplication(mul, plus: add)
                try Ɣrequire([mul], squared:(  ), plus: add, is: [res.low, res.high])
                try Ɣrequire([mul], times: [mul], plus: add, is: [res.low, res.high])
            }
        }
    }
    
    @Test(
        "DataInt/multiplication: many × some + some",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func manyBySomePlusSome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
                
                try Ɣrequire((lhs), times: [rhs], plus: add, is: res)
                try Ɣrequire([rhs], times: (lhs), plus: add, is: res)
            }
        }
    }
    
    @Test(
        "DataInt/multiplication: many × many + some",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func manyByManyPlusSome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
                
                try Ɣrequire(lhs, times: rhs, plus: add, is: res)
                try Ɣrequire(rhs, times: lhs, plus: add, is: res)
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
                
                try Ɣrequire(mul, squared:(), plus: add, is: res)
                try Ɣrequire(mul, times: mul, plus: add, is: res)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<Element>(
        _ integer: [Element],
        times multiplier: [Element],
        plus increment:  Element,
        is expectation: [Element],
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(expectation.count == integer.count  + multiplier.count)
        try #require(expectation.count >= 0000000000001 || increment.isZero)
        //=--------------------------------------=
        // multiplication: expectation <= U64.max
        //=--------------------------------------=
        if  IX(expectation.count) * IX(size: Element.self) <= 64 {
            let a = try #require(U64.exactly(integer    ).optional())
            let b = try #require(U64.exactly(multiplier ).optional())
            let c = try #require(U64.exactly(increment  ).optional())
            let d = try #require(U64.exactly(expectation).optional())
            let e = a.times(b).optional()?.plus(c).optional()
            try #require(e == d, "DataInt/initialize(to:times:plus:) <= U64.max", sourceLocation: location)
        }
        //=--------------------------------------=
        // multiplication: many × some + some
        //=--------------------------------------=
        if  integer.count == 1 {
            var result = multiplier
            let last = result.withUnsafeMutableBinaryIntegerBody {
                $0.multiply(by: integer.first!, add: increment)
            }
            
            result.append(last)
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  multiplier.count == 1 {
            var result = integer
            let last = result.withUnsafeMutableBinaryIntegerBody {
                $0.multiply(by: multiplier.first!, add: increment)
            }
            
            result.append(last)
            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // multiplication: many × many
        //=--------------------------------------=
        always: do {
            var result = [Element](repeating: 144, count: expectation.count)
            try result.withUnsafeMutableBinaryIntegerBody { result in
                try integer.withUnsafeBinaryIntegerBody { integer in
                    try multiplier.withUnsafeBinaryIntegerBody { multiplier in
                        result.initializeByLongAlgorithm(to: integer, times: multiplier)
                        if !result.isEmpty {
                            try #require(!result.increment(by: increment).error)
                        }
                    }
                }
            }

            try #require(result == expectation, sourceLocation: location)
        }

        always: do {
            var result = [Element](repeating: 144, count: expectation.count)
            try result.withUnsafeMutableBinaryIntegerBody { result in
                try integer.withUnsafeBinaryIntegerBody { integer in
                    try multiplier.withUnsafeBinaryIntegerBody { multiplier in
                        result.initializeByKaratsubaAlgorithm(to: integer, times: multiplier)
                        if !result.isEmpty {
                            try #require(!result.increment(by: increment).error)
                        }
                    }
                }
            }

            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // multiplication: many × many + some
        //=--------------------------------------=
        always: do {
            var result = [Element](repeating: 144, count: expectation.count)
            result.withUnsafeMutableBinaryIntegerBody { result in
                integer.withUnsafeBinaryIntegerBody { integer in
                    multiplier.withUnsafeBinaryIntegerBody { multiplier in
                        result.initializeByLongAlgorithm(to: integer, times: multiplier, plus: increment)
                    }
                }
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
    }

    private func Ɣrequire<Element>(
        _ integer: [Element],
        squared: Void,
        plus increment:  Element,
        is expectation: [Element],
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(expectation.count == integer.count  + integer   .count)
        try #require(expectation.count >= 0000000000001 || increment.isZero)
        //=--------------------------------------=
        // multiplication: long
        //=--------------------------------------=
        always: do {
            var result = [Element](repeating: 144, count: expectation.count)
            try result.withUnsafeMutableBinaryIntegerBody { result in
                try integer.withUnsafeBinaryIntegerBody { integer in
                    result.initializeByLongAlgorithm(toSquareProductOf: integer)
                    if !result.isEmpty {
                        try #require(!result.increment(by: increment).error)
                    }
                }
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        always: do {
            var result = [Element](repeating: 144, count: expectation.count)
            result.withUnsafeMutableBinaryIntegerBody { result in
                integer.withUnsafeBinaryIntegerBody { integer in
                    result.initializeByLongAlgorithm(toSquareProductOf: integer, plus: increment)
                }
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // multiplication: karatsuba
        //=--------------------------------------=
        always: do {
            var result = [Element](repeating: 144, count: expectation.count)
            try result.withUnsafeMutableBinaryIntegerBody { result in
                try integer.withUnsafeBinaryIntegerBody { integer in
                    result.initializeByKaratsubaAlgorithm(toSquareProductOf: integer)
                    if !result.isEmpty {
                        try #require(!result.increment(by: increment).error)
                    }
                }
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
    }
}
