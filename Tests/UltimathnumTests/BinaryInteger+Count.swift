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
// MARK: * Binary Integer x Count
//*============================================================================*

@Suite struct BinaryIntegerTestsOnCount {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/count: size",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func size(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64, release: 256) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(random.size() == T.size)
            }
        }
    }
    
    @Test(
        "BinaryInteger/count: count",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func count(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64, release: 256) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let nonappendix = random.appendix.toggled()
                let expectation = random.count(nonappendix)
                let body = random.withUnsafeBinaryIntegerBody {
                    IX($0.bits.count(where:{$0 == nonappendix}))
                }
                
                try #require(body == expectation.natural().optional())
                
                for bit in Bit.all {
                    let x = IX(raw: random.count(bit))
                    let y = IX(raw: random.count(bit.toggled()))
                    try #require(Count(raw: x + y) == T.size)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/count: ascending",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func ascending(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64, release: 256) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let appendix = random.appendix
                
                for bit in Bit.all {
                    let expectation = random.ascending(bit)
                    let size = random.withUnsafeBinaryIntegerBody{$0.size()}
                    let body = random.withUnsafeBinaryIntegerBody {
                        Count(IX($0.bits.prefix(while:{ $0 == bit }).count))
                    }
                    
                    if  body == size, bit == appendix {
                        try #require(expectation == T.size)
                    }   else {
                        try #require(expectation == body)
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/count: descending",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descending(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64, release: 256) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let appendix = random.appendix
                
                for bit in Bit.all {
                    let expectation = random.descending(bit)
                    let size = random.withUnsafeBinaryIntegerBody {
                        $0.size()
                    }
                    
                    let body = random.withUnsafeBinaryIntegerBody {
                        Count(IX($0.bits.reversed().prefix(while:{ $0 == bit }).count))
                    }
                                        
                    if !T.isArbitrary, !T.isSigned {
                        try #require(expectation == body)
                        
                    }   else if bit != appendix {
                        try #require(expectation == Count.zero)
                        
                    }   else {
                        try #require(expectation == Count(raw: IX(raw: T.size) - IX(raw: size) + IX(raw: body)))
                    }
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Count x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnCountConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/count/conveniences: entropy",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func entropy(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let nonappendix = try #require(random.nondescending(random.appendix).natural().optional())
                let incremented = try #require(nonappendix.incremented().optional())
                let expectation = try Count(#require(Natural(exactly: incremented)))
                try #require(random.entropy() == expectation)
            }
        }
    }
    
    @Test(
        "BinaryInteger/count/conveniences: nonascending",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func nonascending(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                for bit in Bit.all {
                    let a = random   .ascending(bit)
                    let b = random.nonascending(bit)
                    try #require(Count(raw: IX(raw: a) + IX(raw: b)) == T.size)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/count/conveniences: nondescending",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func nondescending(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                for bit in Bit.all {
                    let a = random   .descending(bit)
                    let b = random.nondescending(bit)
                    try #require(Count(raw: IX(raw: a) + IX(raw: b)) == T.size)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Count x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnCountEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Data Integer
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/count/edge-cases: systems integer is like data integer body",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func systemsIntegerIsLikeDataIntegerBody(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< 64 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                always: do {
                    var x = random as T
                    let a = x.size()
                    let b = x.withUnsafeBinaryIntegerBody{$0.size()}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.size()}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                if  random.appendix.isZero {
                    var x = random as T
                    let a = x.entropy()
                    let b = x.withUnsafeBinaryIntegerBody{$0.entropy()}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.entropy()}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.count(bit)
                    let b = x.withUnsafeBinaryIntegerBody{$0.count(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.count(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.ascending(bit)
                    let b = x.withUnsafeBinaryIntegerBody{$0.ascending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.ascending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.nonascending(bit)
                    let b = x.withUnsafeBinaryIntegerBody{$0.nonascending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.nonascending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.descending(bit)
                    let b = x.withUnsafeBinaryIntegerBody{$0.descending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.descending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.nondescending(bit)
                    let b = x.withUnsafeBinaryIntegerBody{$0.nondescending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerBody{$0.nondescending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/count/edge-cases: arbitrary integer is like data integer elements",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryInteger, fuzzers
    )   func arbitraryIntegerIsLikeDataIntegerElements(
        type: any ArbitraryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryInteger {
            for _ in 0 ..< 64 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                always: do {
                    var x = random as T
                    let a = x.size()
                    let b = x.withUnsafeBinaryIntegerElements{$0.size()}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.size()}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                always: do {
                    var x = random as T
                    let a = x.entropy()
                    let b = x.withUnsafeBinaryIntegerElements{$0.entropy()}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.entropy()}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.count(bit)
                    let b = x.withUnsafeBinaryIntegerElements{$0.count(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.count(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.ascending(bit)
                    let b = x.withUnsafeBinaryIntegerElements{$0.ascending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.ascending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.nonascending(bit)
                    let b = x.withUnsafeBinaryIntegerElements{$0.nonascending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.nonascending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.descending(bit)
                    let b = x.withUnsafeBinaryIntegerElements{$0.descending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.descending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
                
                for bit in Bit.all {
                    var x = random as T
                    let a = x.nondescending(bit)
                    let b = x.withUnsafeBinaryIntegerElements{$0.nondescending(bit)}
                    let c = x.withUnsafeMutableBinaryIntegerElements{$0.nondescending(bit)}
                    try #require(a == b)
                    try #require(a == c)
                }
            }
        }
    }
}
