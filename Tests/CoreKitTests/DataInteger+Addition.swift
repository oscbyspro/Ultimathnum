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
// MARK: * Data Integer x Addition
//*============================================================================*

@Suite struct DataIntegerTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x None + Some
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/increment(by:plus:) - 0-by-0-plus-bit", .tags(.exhaustive), arguments: coreIntegersWhereIsUnsigned)
    func incrementByNonePlusBit(type: any SystemsIntegerWhereIsUnsigned.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            try Ɣexpect([] as [T], increment: [] as [T], plus: false, is: Fallible([] as [T]))
            try Ɣexpect([] as [T], increment: [] as [T], plus: true,  is: Fallible([] as [T], error: true))
        }
    }
    
    @Test("DataInt/decrement(by:plus:) - 0-by-0-plus-bit", .tags(.exhaustive), arguments: coreIntegersWhereIsUnsigned)
    func decrementByNonePlusBit(type: any SystemsIntegerWhereIsUnsigned.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            try Ɣexpect([] as [T], decrement: [] as [T], plus: false, is: Fallible([] as [T]))
            try Ɣexpect([] as [T], decrement: [] as [T], plus: true,  is: Fallible([] as [T], error: true))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many + Some
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/decrement(by:plus:) - [bidirectional][uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func incrementByManyPlusBit(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let bit = Bool.random(using: &randomness.stdlib)
                
                let lhs = Array(count: Swift.Int(IX.random(in: 0...0000000000032, using: &randomness))) {
                    T.random(using: &randomness)
                }
                
                let rhs = Array(count: Swift.Int(IX.random(in: 0...IX(lhs.count), using: &randomness))) {
                    T.random(using: &randomness)
                }
                
                var res = lhs
                let err = res.withUnsafeMutableBufferPointer { res in
                    rhs.withUnsafeBufferPointer { rhs in
                        MutableDataInt.Body(res)!.increment(by: DataInt.Body(rhs)!, plus: bit).error
                    }
                }
                
                try Ɣexpect(lhs, increment: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣexpect(res, decrement: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    @Test("DataInt/decrement(by:plus:) - [bidirectional][uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func decrementByManyPlusBit(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let bit = Bool.random(using: &randomness.stdlib)
                
                let lhs = Array(count: Swift.Int(IX.random(in: 0...0000000000032, using: &randomness))) {
                    T.random(using: &randomness)
                }
                
                let rhs = Array(count: Swift.Int(IX.random(in: 0...IX(lhs.count), using: &randomness))) {
                    T.random(using: &randomness)
                }
                
                var res = lhs
                let err = res.withUnsafeMutableBufferPointer { res in
                    rhs.withUnsafeBufferPointer { rhs in
                        MutableDataInt.Body(res)!.decrement(by: DataInt.Body(rhs)!, plus: bit).error
                    }
                }
                
                try Ɣexpect(lhs, decrement: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣexpect(res, increment: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many × Some + Some
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/increment(by:times:plus:) - [bidirectional][uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func incrementByManyTimesSomePlusSome(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = Array(count: Swift.Int(IX.random(in: 1...0000000000032, using: &randomness))) {
                    T.random(using: &randomness)
                }
                
                let rhs = Array(count: Swift.Int(IX.random(in: 0..<IX(lhs.count), using: &randomness)!)) {
                    T.random(using: &randomness)
                }
                
                let mul = T.random(using: &randomness)
                let add = T.random(using: &randomness)
                
                var res = lhs
                let err = res.withUnsafeMutableBufferPointer { res in
                    rhs.withUnsafeBufferPointer { rhs in
                        let a = mul.floorceil()!
                        let b = add.floorceil()!
                        let x = MutableDataInt.Body(res)!.increment(by: DataInt.Body(rhs)!, times: a.floor, plus: b.floor).error
                        let y = MutableDataInt.Body(res)!.increment(by: DataInt.Body(rhs)!, times: a.ceil,  plus: b.ceil ).error
                        return (x || y)
                    }
                }
                
                try Ɣexpect(lhs, increment: rhs, times: mul, plus: add, is: Fallible(res, error: err))
                try Ɣexpect(res, decrement: rhs, times: mul, plus: add, is: Fallible(lhs, error: err))
            }
        }
    }
    
    @Test("DataInt/decrement(by:times:plus:) - [bidirectional][uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func decrementByManyTimesSomePlusSome(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = Array(count: Swift.Int(IX.random(in: 1...0000000000032, using: &randomness))) {
                    T.random(using: &randomness)
                }
                
                let rhs = Array(count: Swift.Int(IX.random(in: 0..<IX(lhs.count), using: &randomness)!)) {
                    T.random(using: &randomness)
                }
                
                let mul = T.random(using: &randomness)
                let add = T.random(using: &randomness)
                
                var res = lhs
                let err = res.withUnsafeMutableBufferPointer { res in
                    rhs.withUnsafeBufferPointer { rhs in
                        let a = mul.floorceil()!
                        let b = add.floorceil()!
                        let x = MutableDataInt.Body(res)!.decrement(by: DataInt.Body(rhs)!, times: a.floor, plus: b.floor).error
                        let y = MutableDataInt.Body(res)!.decrement(by: DataInt.Body(rhs)!, times: a.ceil,  plus: b.ceil ).error
                        return (x || y)
                    }
                }
                
                try Ɣexpect(lhs, decrement: rhs, times: mul, plus: add, is: Fallible(res, error: err))
                try Ɣexpect(res, increment: rhs, times: mul, plus: add, is: Fallible(lhs, error: err))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Reps × Bit
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/incrementSameSize(repeating:plus:) - [bidirectional][uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func incrementByRepsPlusBit(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = Array(count: Swift.Int(IX.random(in: 0...32, using: &randomness) )) {
                    T.random(using: &randomness)
                }
                
                let rhs = Bool.random(using: &randomness.stdlib)
                let bit = Bool.random(using: &randomness.stdlib)
                                
                var res = lhs
                let err = res.withUnsafeMutableBufferPointer { res in
                    Array(repeating: T(repeating: Bit(rhs)), count: lhs.count).withUnsafeBufferPointer { rhs in
                        MutableDataInt.Body(res)!.increment(by: DataInt.Body(rhs)!, plus: bit).error
                    }
                }
                
                try Ɣexpect(lhs, incrementSameSizeRepeating: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣexpect(res, decrementSameSizeRepeating: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    @Test("DataInt/decrementSameSize(repeating:plus:) - [bidirectional][uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func decrementByRepsPlusBit(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = Array(count: Swift.Int(IX.random(in: 0...32, using: &randomness) )) {
                    T.random(using: &randomness)
                }
                
                let rhs = Bool.random(using: &randomness.stdlib)
                let bit = Bool.random(using: &randomness.stdlib)
                                
                var res = lhs
                let err = res.withUnsafeMutableBufferPointer { res in
                    Array(repeating: T(repeating: Bit(rhs)), count: lhs.count).withUnsafeBufferPointer { rhs in
                        MutableDataInt.Body(res)!.decrement(by: DataInt.Body(rhs)!, plus: bit).error
                    }
                }
                
                try Ɣexpect(lhs, decrementSameSizeRepeating: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣexpect(res, incrementSameSizeRepeating: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
}
