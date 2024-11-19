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
// MARK: * Binary Integer x Addition
//*============================================================================*

@Suite struct BinaryIntegerTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/addition: 0 ± x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfZeroByRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 64, release: 256) {
                let a = T.zero
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = a.minus(b)
                let d = a.plus (b)
                
                try #require(c.value.plus (b) == a.veto(c.error))
                try #require(d.value.minus(b) == a.veto(d.error))
                try #require(d.value.minus(c.value).value == b.doubled().value)
                
                if  let c = c.optional(), let d = d.optional() {
                    Ɣexpect(c, equals: d, is: b.signum().negated())
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition: x ± y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func subtractionOfRandomByRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
                try #require(d.value.minus(c.value).value == b.doubled().value)
            }
        }
    }
        
    @Test(
        "BinaryInteger/addition: x ± x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomBySelf(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in IX.zero ..< conditional(debug: 64, release: 256) {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = a.minus(a)
                let c = a.plus (a)
                
                try #require(b.value.isZero)
                try #require(b.error == false)
                
                try #require(c == a.times(2))
                try #require(c == a.doubled())
                try #require(c.value.minus(a) == a.veto(c.error))
                
                if !T.isSigned, !a.msb.isZero {
                    try #require(c.error)
                }
                
                if  T.isSigned, a.descending(a.appendix) == Count(1) {
                    try #require(c.error)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition: x ± 0 or 1",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomByBool(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
                try #require(d.value.minus(c.value).value == T(Bit(b)).doubled().value)
                
                if  let c = c.optional(), let d = d.optional() {
                    Ɣexpect(c, equals: d, is: Signum(Bit(b)).negated())
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition: versus linear expression",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionVersusLinearExpression(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsSystemsIntegerAsSigned
    )   func additiveInverseOfMinValueAsSignedIsError(
        type: any SystemsIntegerAsSigned.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsSigned {
            #expect(T.min.negated()        == T.min.veto())
            #expect(T.min.complement(true) == T.min.veto())
        }
    }
    
    @Test(
        "BinaryInteger/addition/edge-cases: additive inverse of T.min as unsigned is not error",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryIntegerAsUnsigned
    )   func additiveInverseOfMinValueAsUnsignedIsNotError(
        type: any UnsignedInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: UnsignedInteger {
            #expect(T.min.negated()        == T.min.veto(false))
            #expect(T.min.complement(true) == T.min.veto())
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnAdditionConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/addition/conveniences: 0 ± x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfZeroByRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
                
                if !c.error {
                    try #require(c.value == -b)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x ± 0",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomByZero(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
        "BinaryInteger/addition/conveniences: x ± 0 or 1",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomByZeroOrOne(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.lsb
                let c = a.plus(b)
                
                try #require(a.incremented( ) == c)
                try #require(c.value.decremented( ) == a.veto(c.error))
            }
            
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = Bool.random(using: &randomness.stdlib)
                let c = a.plus(T(Bit(b)))
                                
                try #require(a.incremented(b) == c)
                try #require(c.value.decremented(b) == a.veto(c.error))
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x ± y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func additionOfRandomByRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
    // MARK: Tests x Lenient
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/addition/conveniences: -x as LenientInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func additionInverseAsLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let a = T.entropic(size: 256, using: &randomness)
                let b = a.negated() as Fallible<T>
                let c = a.negated() as T
                var d = a
                var e = a
                
                let complement: T = a.complement()
                
                try #require(d.negate().error == false)
                try #require(e.negate() == ((((( ))))))
                
                try #require(complement == b.optional())
                try #require(complement == c)
                try #require(complement == d)
                try #require(complement == e)
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x + x as LenientInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func additionOfRandomBySelfAsLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let a = T.entropic(size: 256, using: &randomness)
                let b = a.times(2).optional() as Optional<T>
                
                try #require(b == a.times(02) as T)
                try #require(b == a.plus((a)) as T)
                try #require(b == a.doubled() as T)
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x ± y as LenientInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func additionOfRandomByRandomAsLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let a = T.entropic(size: 256, using: &randomness)
                let b = T.entropic(size: 256, using: &randomness)
                
                try #require(a.plus (b).optional() == a.plus (b) as T)
                try #require(a.minus(b).optional() == a.minus(b) as T)
            }
        }
    }
    
    @Test(
        "BinaryInteger/addition/conveniences: x ± 0 or 1 as LenientInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func additionOfRandomByZeroOrOneAsLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let a = T.entropic(size: 256, using: &randomness)
                let b = Bool.random(using: &randomness.stdlib)
                
                try #require(a.incremented( ).optional() == a.incremented( ) as T)
                try #require(a.decremented( ).optional() == a.decremented( ) as T)
                try #require(a.incremented(b).optional() == a.incremented(b) as T)
                try #require(a.decremented(b).optional() == a.decremented(b) as T)
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
