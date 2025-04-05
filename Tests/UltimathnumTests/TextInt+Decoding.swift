//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Text Int x Decoding
//*============================================================================*

@Suite struct TextIntTestsOnDecoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/decoding: description",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func description(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = T.entropic(size: size, using: &randomness)
                try whereIs(value, using: coder)
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let value = T.entropic(size: size, using: &randomness)
                try whereIs(value, using: TextInt.decimal)
                try whereIs(value, using: TextInt.hexadecimal.lowercased())
                try whereIs(value, using: TextInt.hexadecimal.uppercased())
            }
            
            func whereIs(_ value: T, using coder: TextInt, at location: SourceLocation = #_sourceLocation) throws {
                let encoded = value.description(using: coder)
                let decoded = coder.decode(encoded,as: T.self)?.optional()
                try #require(decoded == value, sourceLocation: location)
            }
        }
    }
    
    @Test(
        "TextInt/decoding: lossy vs exact",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func lossyVersusExact(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = IXL.entropic(size: 256, using: &randomness)
                let description = value.description(using: coder)
                let expectation = T.exactly(value)
                try #require(coder.decode(description, as: T.self) == expectation)
            }
        }
    }
}

//*============================================================================*
// MARK: * Text Int x Decoding x Edge Cases
//*============================================================================*

@Suite struct TextIntTestsOnDecodingEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/decoding/edge-cases: edges",
        Tag.List.tags(.generic, .important),
        arguments: typesAsEdgyInteger
    )   func edges(
        type: any EdgyInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            for coder in TextInt.all {
                for value in [T.min, T.max] {
                    let description: String = value.description(using: coder)
                    try #require(T(description, using: coder) == value)
                }
            }
        }
    }
    
    @Test(
        "TextInt/decoding/edge-cases: one past min is lossy",
        Tag.List.tags(.generic, .important),
        arguments: typesAsEdgyInteger
    )   func onePastMinIsLossy(
        type: any EdgyInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            let value = IXL(T.min).decremented()
            
            for coder in TextInt.all {
                let description = value.description(using: coder)
                try #require(coder.decode(description) == T.max.veto())
            }
        }
    }
    
    @Test(
        "TextInt/decoding/edge-cases: one past max is lossy",
        Tag.List.tags(.generic, .important),
        arguments: typesAsSystemsInteger
    )   func onePastMaxIsLossy(
        type: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            let value = IXL(T.max).incremented()
            
            for coder in TextInt.all {
                let description = value.description(using: coder)
                try #require(coder.decode(description) == T.min.veto())
            }
        }
    }
    
    @Test(
        "TextInt/decoding/edge-cases: random past min is lossy",
        Tag.List.tags(.generic, .random, .important),
        arguments: typesAsEdgyInteger, fuzzers
    )   func randomPastMinIsLossy(
        type: any EdgyInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            let base = IXL(T.min).decremented()
            
            for _ in 0 ..< 64 {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let natural = IXL.entropic(size: 256, as: Domain.natural, using: &randomness)
                let value = base.minus(natural) as IXL
                let description: String = value.description(using: coder)
                try #require(coder.decode(description) == T.exactly(value))
            }
        }
    }
    
    @Test(
        "TextInt/decoding/edge-cases: random past max is lossy",
        Tag.List.tags(.generic, .random, .important),
        arguments: typesAsSystemsInteger, fuzzers
    )   func randomPastMaxIsLossy(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            let base = IXL(T.max).incremented()
            
            for _ in 0 ..< 64 {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let natural = IXL.entropic(size: 256, as: Domain.natural, using: &randomness)
                let value = base.plus(natural) as IXL
                let description: String = value.description(using: coder)
                try #require(coder.decode(description) == T.exactly(value))
            }
        }
    }
    
    @Test(
        "TextInt/decoding/edge-cases: infinite as finite is lossy",
        Tag.List.tags(.generic, .random, .important),
        arguments: typesAsFiniteInteger, fuzzers
    )   func infiniteAsFiniteIsLossy(
        type: any FiniteInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteInteger {
            for _ in 0 ..< 64 {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = UXL.entropic(size: 256, as: Domain.natural, using: &randomness).toggled()
                let description: String = value.description(using: coder)
                try #require(value.isInfinite)
                try #require(coder.decode(description) == T.exactly(value))
            }
        }
    }
}

//*============================================================================*
// MARK: * Text Int x Decoding x Validation
//*============================================================================*

@Suite struct TextIntTestsOnDecodingValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/decoding/validation: no numerals is nil",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger
    )   func noNumeralsIsNil(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let signs: [String] = ["", "+", "-"]
            let masks: [String] = ["", "&"]
            
            for coder in TextInt.all {
                for sign in signs {
                    for mask in masks {
                        try #require(coder.decode(sign + mask, as: T.self) == nil)
                    }
                }
            }
        }
    }
    
    @Test(
        "TextInt/decoding/validation: byte is invalid is nil",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger
    )   func byteIsInvalidIsNil(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var banned = Set(U8.all)
            let prefix = Set("+-&".utf8.lazy.map(U8.init(_:)))
            
            for element in U8(UInt8(ascii: "0"))...U8(UInt8(ascii: "1")) {
                banned.remove(element)
            }
            
            try  whereIs(TextInt.binary)
            
            for element in U8(UInt8(ascii: "2"))...U8(UInt8(ascii: "9")) {
                banned.remove(element)
            }
            
            try  whereIs(TextInt.decimal)
            
            for element in U8(UInt8(ascii: "A"))...U8(UInt8(ascii: "F")) {
                banned.remove(element)
            }
            
            for element in U8(UInt8(ascii: "a"))...U8(UInt8(ascii: "f")) {
                banned.remove(element)
            }
            
            try  whereIs(TextInt.hexadecimal)
            func whereIs(_ coder: TextInt) throws {
                for element in banned {
                    let invalid = String(UnicodeScalar(UInt8(element)))
                    
                    try #require(coder.decode("0" + invalid,       as: T.self) == nil)
                    try #require(coder.decode("0" + invalid + "0", as: T.self) == nil)
                    
                    if !prefix.contains(element) {
                        try #require((coder).decode(invalid + "0", as: T.self) == nil)
                    }
                }
            }
        }
    }
    
    @Test(
        "TextInt/decoding/validation: redundance is allowed",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger, fuzzers
    )   func redundanceIsAllowed(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let pattern: TextInt.Pattern = TextInt.regexForDecodingRadix36()
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let description = value.description(using: coder)
                let match = try #require(try pattern.firstMatch(in: description)).output
                
                for _ in 0 ..< 4 {
                    var modified = String()
                    
                    if  let sign = match.sign {
                        modified.append(contentsOf: sign)
                    }   else if Bool.random(using: &randomness.stdlib) {
                        modified.append("+")
                    }
                    
                    if  let mask = match.mask {
                        modified.append(contentsOf: mask)
                    }
                    
                    let zeros = IX.random(in: 0...12, using: &randomness)
                    modified.append(contentsOf: repeatElement("0", count: Swift.Int(zeros)))
                    modified.append(contentsOf: match.body)
                    try #require(T(modified, using:  coder) == value)
                }
            }
        }
    }
    
    @Test(
        "TextInt/decoding/validation: is case-insensitive",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger, fuzzers
    )   func isCaseInsensitive(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let radix = UX.random(in: 11...36, using: &randomness)
                let coder = try #require(TextInt(radix: radix))
                let value = T.entropic(size: size, using: &randomness)
                
                let lowercase = coder.lowercased().encode(value)
                let uppercase = coder.uppercased().encode(value)
                
                try #require(T(lowercase, using: coder.uppercased()) == value)
                try #require(T(uppercase, using: coder.lowercased()) == value)
            }
        }
    }
}
