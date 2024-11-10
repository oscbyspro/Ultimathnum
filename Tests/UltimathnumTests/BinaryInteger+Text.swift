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
// MARK: * Binary Integer x Text
//*============================================================================*

@Suite struct BinaryIntegerTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Metadata
    //=------------------------------------------------------------------------=
    
    static let coders: [TextInt] = (U8(2)...36).reduce(into: []) {
        let coder = TextInt.radix($1)
        $0.append(coder.lowercased())
        $0.append(coder.uppercased())
    }
    
    static var regex: Regex<(Substring, sign: Substring?, mask: Substring?, body: Substring)> {
        #/^(?<sign>\+|-)?(?<mask>#|&)?(?<body>[0-9A-Za-z]+)$/#
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text: description is decodable",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionIsDecodable(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                let coder = TextInt.random(using: &randomness)
                let value = T.entropic(size: size, using: &randomness)
                try whereIs(value, using: coder)
            }
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                let value = T.entropic(size: size, using: &randomness)
                try whereIs(value, using: TextInt.decimal)
                try whereIs(value, using: TextInt.hexadecimal.lowercased())
                try whereIs(value, using: TextInt.hexadecimal.uppercased())
            }
            
            func whereIs(_ value: T, using coder: TextInt, at location: SourceLocation = #_sourceLocation) throws {
                let encoded = value.description(as: coder)
                let decoded = try T(((encoded)),as: coder)
                try #require(decoded == value, sourceLocation: location)
            }
        }
    }
    
    @Test(
        "BinaryInteger/text: description letter case is stable",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionLetterCaseIsStable(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                let coder = TextInt.random(using: &randomness)
                let value = T.entropic(size: size, using: &randomness)
                
                let lowercased: String = value.description(as: coder.lowercased())
                let uppercased: String = value.description(as: coder.uppercased())
                
                if  coder.radix <= 10 {
                    try #require(lowercased == uppercased)
                }
                
                try #require(lowercased == lowercased.lowercased())
                try #require(uppercased == uppercased.uppercased())
            }
        }
    }
    
    @Test(
        "BinaryInteger/text: description matches known regex",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionMatchesKnownRegex(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let regex = BinaryIntegerTestsOnText.regex
                let coder = TextInt.random(using: &randomness)
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let description = value.description(as: coder)
                let match = try #require(try regex.wholeMatch(in: description))
                try #require(match.output.0 == description)
                try #require(match.output.sign == (value.isNegative ? "-" : nil))
                try #require(match.output.mask == (value.isInfinite ? "&" : nil))
            }
        }
    }
    
    @Test(
        "BinaryInteger/text: description alternatives are equivalent",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionAlternativesAreEquivalent(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 64 {
                let coder = TextInt.random(using: &randomness)
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let magnitude: T.Magnitude = value.magnitude()
                let description: String  = value.description(as: coder)
                
                always: do {
                    let result = coder.encode(value)
                    try #require(result == description)
                }
                
                if !value.isNegative {
                    let result = coder.encode(sign: Sign.plus,  magnitude: magnitude)
                    try #require(result == description)
                }
                
                if !value.isPositive {
                    let result = coder.encode(sign: Sign.minus, magnitude: magnitude)
                    try #require(result == description)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text: description of negative vs positive",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryIntegerAsSigned, fuzzers
    )   func descriptionOfNegativeVersusPositive(type: any SignedInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            for _ in 0 ..< 32 {
                let negative = T.entropic(through: Shift.max(or: 255), as: Domain.natural, using: &randomness).toggled()
                let positive = negative.magnitude()
                
                try #require(negative.isNegative)
                try #require(positive.isPositive)
                
                for _ in 0 ..< 8 {
                    let radix = UX.random(in: 02...36, using: &randomness)
                    let uppercase = Bool.random(using: &randomness.stdlib)
                    let letters   = TextInt.Letters(uppercase:  uppercase)
                    let coder = try TextInt(radix: radix,letters: letters)
                    try #require(negative.description(as: coder) == "-\(positive.description(as: coder))")
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text: description of infinite vs finite",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func descriptionOfInfiniteVersusFinite(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let (finite) = T.entropic(size: 256, as: Domain.finite, using: &randomness)
                let infinite = finite.toggled()
                
                try #require(!(finite).isInfinite)
                try #require( infinite.isInfinite)
                
                for _ in 0 ..< 8 {
                    let radix = UX.random(in: 02...36, using: &randomness)
                    let uppercase = Bool.random(using: &randomness.stdlib)
                    let letters   = TextInt.Letters(uppercase:  uppercase)
                    let coder = try TextInt(radix: radix,letters: letters)
                    try #require(infinite.description(as: coder) == "&\(finite.description(as: coder))")
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Text x Validation
//*============================================================================*

@Suite(.tags(.important)) struct BinaryIntegerTestsOnTextValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Validation
    //=------------------------------------------------------------------------=
        
    @Test(
        "BinaryInteger/text/validation: throws error if no numerals",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func throwsErrorIfNoNumerals(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let signs = ["", "+", "-"]
            let masks = ["", "#", "&"]
            
            for coder in BinaryIntegerTestsOnText.coders {
                for sign in signs {
                    for mask in masks {
                        try #require(throws: TextInt.Error.invalid) {
                            try T(sign + mask, as: coder)
                        }
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: throws error on invalid byte",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func throwsErrorOnInvalidByte(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var banned = Set(U8.all)
            let prefix = Set("+-#&".utf8.lazy.map(U8.init(_:)))
            
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
                    let scalar = String(UnicodeScalar(UInt8(element)))
                    
                    always: do {
                        try #require(throws: TextInt.Error.invalid) {
                            try T("0" + scalar, as: coder)
                        }
                    }
                    
                    if !prefix.contains(element) {
                        try #require(throws: TextInt.Error.invalid) {
                            try T(scalar + "0", as: coder)
                        }
                    }
                    
                    always: do {
                        try #require(throws: TextInt.Error.invalid) {
                            try T("0" + scalar + "0", as: coder)
                        }
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: decoding redundant characters",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger, fuzzers
    )   func decodingRedundantCharacters(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let regex  = BinaryIntegerTestsOnText.regex
            let coders = BinaryIntegerTestsOnText.coders
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let coder = coders.randomElement(using: &randomness.stdlib)!
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let description = value.description(as: coder)
                let match = try #require(try regex.firstMatch(in: description)).output
                
                for _ in 0 ..< 4 {
                    var modified = String()
                    
                    if  let sign = match.sign {
                        modified.append(contentsOf: sign)
                    }   else if Bool.random(using: &randomness.stdlib) {
                        modified.append("+")
                    }
                    
                    if  let mask = match.mask {
                        modified.append(contentsOf: mask)
                    }   else if Bool.random(using: &randomness.stdlib) {
                        modified.append("#")
                    }
                    
                    let zeros = IX.random(in: 0...12, using: &randomness)
                    modified.append(contentsOf: repeatElement("0", count: Swift.Int(zeros)))
                    modified.append(contentsOf: try #require(match.body))
                    try #require(try T(modified, as: coder) == value)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Text x Edge Cases
//*============================================================================*

@Suite(.tags(.important)) struct BinaryIntegerTestsOnTextEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text/validation: decoding edges works",
        Tag.List.tags(.generic),
        arguments: typesAsEdgyInteger
    )   func decodingEdgesWorks(
        type: any EdgyInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            for coder in BinaryIntegerTestsOnText.coders {
                for value in [T.min, T.max] {
                    let description: String = value.description(as: coder)
                    try #require(try T(description, as: coder)  ==  value)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: decoding one past min is error",
        Tag.List.tags(.generic),
        arguments: typesAsEdgyInteger
    )   func decodingOnePastMinIsError(
        type: any EdgyInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            let value = IXL(T.min).decremented()
            
            for coder in BinaryIntegerTestsOnText.coders {
                let description = value.description(as: coder)
                try #require(throws: TextInt.Error.lossy) {
                    try T(description, as: coder)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: decoding one past max is error",
        Tag.List.tags(.generic),
        arguments: typesAsSystemsInteger
    )   func decodingOnePastMaxIsError(
        type: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            let value = IXL(T.max).incremented()
            
            for coder in BinaryIntegerTestsOnText.coders {
                let description = value.description(as: coder)
                try #require(throws: TextInt.Error.lossy) {
                    try T(description, as: coder)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: decoding random past min is error",
        Tag.List.tags(.generic, .random),
        arguments: typesAsEdgyInteger, fuzzers
    )   func decodingOnePastMinIsError(
        type: any EdgyInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            let base = IXL(T.min).decremented()
            let coders = BinaryIntegerTestsOnText.coders
            
            for _ in 0 ..< 64 {
                let coder = coders.randomElement(using: &randomness.stdlib)!
                let natural = IXL.entropic(size: 256, as: Domain.natural, using: &randomness)
                let description: String = base.minus(natural).description(as: coder)
                try #require(throws: TextInt.Error.lossy) {
                    try T(description, as: coder)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: decoding random past max is error",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func decodingOnePastMaxIsError(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            let base = IXL(T.max).incremented()
            let coders = BinaryIntegerTestsOnText.coders
            
            for _ in 0 ..< 64 {
                let coder = coders.randomElement(using: &randomness.stdlib)!
                let natural = IXL.entropic(size: 256, as: Domain.natural, using: &randomness)
                let description: String = base.plus(natural).description(as: coder)
                try #require(throws: TextInt.Error.lossy) {
                    try T(description, as: coder)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/text/validation: decoding infinite as finite is error",
        Tag.List.tags(.generic, .random),
        arguments: typesAsFiniteInteger, fuzzers
    )   func decodingInfiniteAsFiniteIsError(
        type: any FiniteInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteInteger {
            let coders = BinaryIntegerTestsOnText.coders
            
            for _ in 0 ..< 64 {
                let coder = coders.randomElement(using: &randomness.stdlib)!
                let value = UXL.entropic(size: 256, as: Domain.natural, using: &randomness).toggled()
                let description: String = value.description(as: coder)
                try #require(value.isInfinite)
                try #require(throws: TextInt.Error.lossy) {
                    try T(description, as: coder)
                }
            }
        }
    }
    
    
}

//*============================================================================*
// MARK: * Binary Integer x Text x Pyramids
//*============================================================================*

@Suite(.tags(.important)) struct BinaryIntegerTestsOnTextPyramids {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let coders: [TextInt] = Self.radices.map(TextInt.radix)
    
    static let radices: [UX] = conditional(debug: [10, 16], release: [UX](2...36))

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Here we check the following sequence:
    ///
    ///     1
    ///     10
    ///     100
    ///     1000
    ///     .....
    ///
    @Test(
        "BinaryInteger/text/pyramids: one followed by zeros",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func pyramidOfOneFollowedByZeros(type: any BinaryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for coder: TextInt in Self.coders {
                var encoded = String("1")
                var decoded = Fallible(T(1))
                let radix   = T(coder.radix)
                
                for _ in 0 ..< 64 {
                    if  decoded.error { break }
                    try #require(encoded == decoded.value.description(as: coder))
                    try #require(try decoded.value == T.init(encoded, as: coder))
                    
                    encoded.append("0")
                    decoded = decoded.value.times(radix)
                }
            }
        }
    }
    
    /// Here we check the following sequence:
    ///
    ///     1
    ///     12
    ///     123
    ///     1234
    ///     .....
    ///
    @Test(
        "BinaryInteger/text/pyramids: ascending numeral cycle",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func pyramidOfAscendingNumeralCycle(type: any BinaryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for coder: TextInt in Self.coders {
                var encoded = String()
                var decoded = Fallible(T( ))
                let radix   = T(coder.radix)
                
                for index: U8 in 1 ... 64 {
                    let element = index % coder.radix
                    let numeral = try coder.numerals.encode(element)
                    
                    decoded = decoded.map{$0.times(T((radix)))}
                    decoded = decoded.map{$0.plus (T(element))}
                    encoded.append(String(UnicodeScalar(UInt8(numeral))))
                    
                    if  decoded.error { break }
                    try #require(encoded == decoded.value.description(as: coder))
                    try #require(try decoded.value == T.init(encoded, as: coder))
                }
            }
        }
    }

    /// Here we check the following sequence:
    ///
    ///     x
    ///     xx
    ///     xxx
    ///     xxxx
    ///     .....
    ///     where x is radix - 1
    ///
    @Test(
        "BinaryInteger/text/pyramids: repeating highest numeral",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func pyramidOfRepeatingHighestNumeral(type: any BinaryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for coder: TextInt in Self.coders {
                var encoded = String()
                var decoded = Fallible(T( ))
                let radix   = T(coder.radix)
                let value   = T(coder.radix - 1)
                let numeral = try coder.numerals.encode(coder.radix - 1)
                
                for _ in 0 ..< 64 {
                    decoded = decoded.map{$0.times(radix)}
                    decoded = decoded.map{$0.plus (value)}
                    encoded.append(String(UnicodeScalar(UInt8(numeral))))
                    
                    if  decoded.error { break }
                    try #require(encoded == decoded.value.description(as: coder))
                    try #require(try decoded.value == T.init(encoded, as: coder))
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Text x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnTextConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text/conveniences: decimal",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func decimal(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(T(String()) == nil)
            
            for byte: U8 in U8.min ... 47 {
                try #require(T(String(UnicodeScalar(UInt8(byte)))) == nil)
            }
            
            for byte: U8 in 58 ... U8.max {
                try #require(T(String(UnicodeScalar(UInt8(byte)))) == nil)
            }
            
            for _ in  0 ..< 32 {
                let decoded = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let encoded = decoded.description(as: TextInt.decimal)
                
                try #require(decoded == T(encoded))
                try #require(encoded == decoded.description)
            }
        }
    }
}
