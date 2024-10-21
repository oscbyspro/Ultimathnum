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
// MARK: * Binary Integer x Addition
//*============================================================================*

@Suite struct BinaryIntegerTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/addition: 0 ± x",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfZeroByRandom(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 64, release: 256) {
                let a = T.zero
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a.minus(b)
                let d = a.plus (b)
                
                try #require(c.value.plus (b) == a.veto(c.error))
                try #require(d.value.minus(b) == a.veto(d.error))
                try #require(d.value.minus(c.value).value == b.times(2).value)
                
                if  let c = c.optional(), let d = d.optional() {
                    Ɣexpect(c, equals: d, is: b.signum().negated())
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition: x ± y",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func subtractionOfRandomByRandom(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 64, release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a.minus(b)
                let d = a.plus (b)
                
                try #require(a.veto(c.error) == c.value.plus (b))
                try #require(b.veto(c.error) == a.minus(c.value))
                
                try #require(a.veto(d.error) == d.value.minus(b))
                try #require(b.veto(d.error) == d.value.minus(a))
                
                try #require(d.value.minus(c.value).value == b.plus (b).value)
                try #require(d.value.minus(c.value).value == b.times(2).value)
            }
        }
    }
        
    @Test(
        "BinaryInteger/addition: x ± x",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomBySelf(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 64, release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = a.minus(a)
                let c = a.plus (a)
                
                try #require(b.value.isZero)
                try #require(b.error == false)
                
                try #require(c == a.times(2))
                try #require(c.value.minus(a) == a.veto(c.error))
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition: x ± 0 or 1",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomByBool(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 64, release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = Bool.random(using: &randomness.stdlib)
                let c = a.decremented(b)
                let d = a.incremented(b)
                
                try #require(c == a.minus(T(Bit(b))))
                try #require(d == a.plus (T(Bit(b))))
                
                try #require(c.value.incremented(b) == a.veto(c.error))
                try #require(d.value.decremented(b) == a.veto(d.error))
                try #require(d.value.minus(c.value).value == T(Bit(b)).times(2).value)
                
                if  let c = c.optional(), let d = d.optional() {
                    Ɣexpect(c, equals: d, is: Signum(Bit(b)).negated())
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition: versus linear expression",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionVersusLinearExpression(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 16, release: 64) {
                let base = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let step = T.entropic(through: Shift.max(or: 255), using: &randomness)
                var some = base
                
                for multiplier in T.zero ..< 16 {
                    let leap = (multiplier &* step)
                    let expectation = base &+ leap
                    try #require(expectation == some)
                    
                    some &+= step
                    
                    try #require(expectation == some &- step)
                    try #require(base == expectation &- leap)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Edge Cases
//*============================================================================*

@Suite(.tags(.documentation)) struct BinaryIntegerTestsOnAdditionEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/addition/edge-cases: additive inverse of T.min as signed is error",
        Tag.List.tags(.exhaustive),
        arguments: typesAsSystemsIntegerAsSigned
    )   func additiveInverseOfMinValueAsSignedIsError(type: any SystemsIntegerAsSigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsSigned {
            #expect(T.min.negated()        == T.min.veto())
            #expect(T.min.complement(true) == T.min.veto())
        }
    }
    
    @Test(
        "BinaryInteger/addition/edge-cases: additive inverse of T.min as unsigned is not error",
        Tag.List.tags(.exhaustive),
        arguments: typesAsBinaryIntegerAsUnsigned
    )   func additiveInverseOfMinValueAsUnsignedIsNotError(type: any UnsignedInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            #expect(T.min.negated()        == T.min.veto(false))
            #expect(T.min.complement(true) == T.min.veto())
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnAdditionVersusConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/addition/conveniences: 0 ± x",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfZeroByRandom(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let a = T.zero
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a.minus(b)
                let d = a.plus (b)
                
                try self.Ɣrequire(a, plus:  b, is: d)
                try self.Ɣrequire(a, minus: b, is: c)
                
                try #require(c == b.negated())
                try #require(c.value == b.complement())
                
                if  let c = c.optional() {
                    try #require(c == reduce(-, b))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x ± 0",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomByZero(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.zero
                
                try #require(a == a.plus (b).optional())
                try #require(a == a.minus(b).optional())
                
                try Ɣrequire(a, plus:  b, is: a.veto(false))
                try Ɣrequire(a, minus: b, is: a.veto(false))
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x ± y",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func subtractionOfRandomByRandomVersusDerivatives(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                try Ɣrequire(a, plus:  b, is: a.plus (b))
                try Ɣrequire(a, minus: b, is: a.minus(b))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func Ɣrequire<T>(_ a: T, plus  b: T, is c: Fallible<T>) throws where T: BinaryInteger {
        try #require(c.value == reduce(a, &+,  b))
        try #require(c.value == reduce(a, &+=, b))
                        
        if  let c = c.optional() {
            try #require(c == reduce(a, +,  b))
            try #require(c == reduce(a, +=, b))
            
            Ɣexpect(c, equals: a, is: b.signum())
            Ɣexpect(c, equals: b, is: a.signum())
        }
    }
    
    func Ɣrequire<T>(_ a: T, minus b: T, is c: Fallible<T>) throws where T: BinaryInteger {
        try #require(c.value == reduce(a, &-,  b))
        try #require(c.value == reduce(a, &-=, b))
        
        if  let c = c.optional() {
            try #require(c == reduce(a, -,  b))
            try #require(c == reduce(a, -=, b))
            
            Ɣexpect(a, equals: c, is: b.signum())
            Ɣexpect(a, equals: b, is: c.signum())
        }
    }
}
