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
// MARK: * Metadata
//*============================================================================*

/// The preferred radix type.
///
/// - Note: Generic alternatives derive from it.
///
private typealias Radix = UX // TODO: consider IX or fancy branches

private let radices: Range<Radix> = 0..<37

private let letters: [TextInt.Letters] = [.lowercase, .uppercase]

//*============================================================================*
// MARK: * Text Int x Numerals
//*============================================================================*

@Suite struct TextIntTestsOnNumerals {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/numerals: decode each byte for each instance",
        Tag.List.tags(.exhaustive)
    )   func decodeEachByteForEachInstance() throws {
        var expectation: [U8: U8] = [:]
        
        try #require(UInt8(ascii: "0") ==  48)
        try #require(UInt8(ascii: "9") ==  57)
        try #require(UInt8(ascii: "A") ==  65)
        try #require(UInt8(ascii: "Z") ==  90)
        try #require(UInt8(ascii: "a") ==  97)
        try #require(UInt8(ascii: "z") == 122)

        for key: U8 in 48...57 {
            expectation[key] = key - 48
        }

        for key: U8 in 65...90 {
            expectation[key] = key - 55
        }

        for key: U8 in 97...122 {
            expectation[key] = key - 87
        }
        
        for radix in radices {
            for letters in letters {
                let numerals = try #require(
                    TextInt.Numerals(radix: radix, letters: letters)
                )

                for key in U8.min...U8.max {
                    if  let value = expectation[key], value < radix {
                        try #require(numerals.decode(key) == value)
                    }   else {
                        try #require(numerals.decode(key) == (nil))
                    }
                }
            }
        }
    }
    
    @Test(
        "TextInt/numerals: encode each byte for each instance",
        Tag.List.tags(.exhaustive),
        arguments: Array<(TextInt.Letters, [U8])>.infer([
        
        (TextInt.Letters.lowercase, [U8](48...57) + [U8](97...122)),
        (TextInt.Letters.uppercase, [U8](48...57) + [U8](65...090)),
            
    ])) func encodeEachByteForEachInstance(
        letters: TextInt.Letters, expectation: [U8]
    )   throws {
        
        for radix in radices {
            let numerals = try #require(
                TextInt.Numerals(radix: radix, letters: letters)
            )
            
            for data in U8.min..<U8(numerals.radix) {
                try #require(numerals.encode(data) == expectation[Int(IX(data))])
            }
            
            for data in U8(numerals.radix)..<U8.max {
                try #require(numerals.encode(data) == nil)
            }
        }
    }
}

//*============================================================================*
// MARK: * Text Int x Numerals x Initialization
//*============================================================================*

@Suite struct TextIntTestsOnNumeralsInitialization {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt.Numerals/initialization: default radix is 10",
        Tag.List.tags(.exhaustive)
    )   func defaultRadixIsDecimal() throws {
        try #require(TextInt.Numerals().radix == 10)
    }
    
    @Test(
        "TextInt.Numerals/initialization: default letters is lowercase",
        Tag.List.tags(.exhaustive)
    )   func defaultLettersIsLowercase() throws {
        try #require(TextInt.Numerals().letters == TextInt.Letters.lowercase)
        
        for radix: Radix in radices {
            let generic: some BinaryInteger = radix
            try #require(TextInt.Numerals(radix: (radix))?.letters == TextInt.Letters.lowercase)
            try #require(TextInt.Numerals(radix: generic)?.letters == TextInt.Letters.lowercase)
        }
    }
    
    @Test(
        "TextInt.Numerals/initialization: from each radix in [0, 36]",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryInteger
    )   func fromEachRadixFromZeroThrough36(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for radix in radices.lazy.map(T.init) {
                for letters in letters {
                    let instance = try #require(TextInt.Numerals(radix:      (radix), letters: letters))
                    let concrete = try #require(TextInt.Numerals(radix: Radix(radix), letters: letters))
                    try #require(instance == concrete)
                    
                    try #require(instance.radix   == radix)
                    try #require(instance.letters == letters)
                    
                    try #require(instance.lowercased().radix   == radix)
                    try #require(instance.lowercased().letters == TextInt.Letters.lowercase)
                    try #require(instance.uppercased().radix   == radix)
                    try #require(instance.uppercased().letters == TextInt.Letters.uppercase)
                    
                    try #require(instance.letters(.lowercase).radix   == radix)
                    try #require(instance.letters(.lowercase).letters == TextInt.Letters.lowercase)
                    try #require(instance.letters(.uppercase).radix   == radix)
                    try #require(instance.letters(.uppercase).letters == TextInt.Letters.uppercase)
                }
            }
        }
    }
    
    @Test(
        "TextInt.Numerals/initialization: throws error if radix is invalid",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(TimeLimitTrait.Duration.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func throwsErrorIfRadixIsInvalid(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var   counter = 00
            while counter < 32 {
                let radix = T.entropic(through: Shift.max(or: 255), using: &randomness)
                if  0 <= radix, radix <= 36 { continue } else { counter += 1 }
                
                for letters in letters {
                    if  let radix = T.exactly(radix).optional() {
                        try #require(TextInt.Numerals(radix: radix, letters: letters) == nil)
                    }
                    
                    if  let radix = Radix.exactly(radix).optional() {
                        try #require(TextInt.Numerals(radix: radix, letters: letters) == nil)
                    }
                }
            }
        }
    }
    
    @Test(
        "TextInt.Numerals/initialization: throws error if radix is one past limit",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryInteger, [-1, 37] as [I8]
    )   func throwsErrorIfRadixIsOnePastLimit(
        type: any BinaryInteger.Type, radix: I8
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for letters in letters {
                if  let radix = T.exactly(radix).optional() {
                    try #require(TextInt.Numerals(radix: radix, letters: letters) == nil)
                }
                
                if  let radix = Radix.exactly(radix).optional() {
                    try #require(TextInt.Numerals(radix: radix, letters: letters) == nil)
                }
            }
        }
    }
}
