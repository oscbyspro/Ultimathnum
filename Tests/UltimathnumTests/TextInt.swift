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
// MARK: * Text Int
//*============================================================================*

@Suite struct TextIntTests {
    
    /// The preferred radix type.
    ///
    /// - Note: Generic alternatives derive from it.
    ///
    typealias Radix = UX // TODO: consider IX or fancy branches
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    static let radices: Range<Radix> = 2 ..< 37
    
    static let letters: [TextInt.Letters] = [.lowercase, .uppercase]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt: named instances",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: [
            
            (TextInt.binary,      02 as U8, TextInt.Letters.lowercase),
            (TextInt.decimal,     10 as U8, TextInt.Letters.lowercase),
            (TextInt.hexadecimal, 16 as U8, TextInt.Letters.lowercase),
            
        ] as [(TextInt, U8, TextInt.Letters)]
    )   func namedInstances(instance: TextInt, radix: U8, letters: TextInt.Letters) throws {
        #expect(instance.radix   == radix)
        #expect(instance.letters == letters)
    }
    
    @Test(
        "TextInt: default radix is 10",
        Tag.List.tags(.documentation, .exhaustive)
    )   func defaultRadixIs10() {
        #expect(TextInt().radix == 10)
    }
    
    @Test(
        "TextInt: default letters is lowercase",
        Tag.List.tags(.documentation, .exhaustive)
    )   func defaultLettersIsLowercase() throws {
        try #require(TextInt().letters == TextInt.Letters.lowercase)
        
        for radix: Radix in Self.radices {
            let generic: some BinaryInteger = radix
            try #require(try TextInt(radix:   radix).letters == TextInt.Letters.lowercase)
            try #require(try TextInt(radix: generic).letters == TextInt.Letters.lowercase)
            try #require(try TextInt.radix(   radix).letters == TextInt.Letters.lowercase)
            try #require(try TextInt.radix( generic).letters == TextInt.Letters.lowercase)
        }
    }
    
    @Test(
        "TextInt: from each radix in [2, 36]",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsBinaryInteger
    )   func fromEachRadixFromTwoThrough36(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for radix in Self.radices.lazy.map(T.init) {
                for letters in Self.letters {
                    let instance = try TextInt(radix:      (radix), letters: letters)
                    let concrete = try TextInt(radix: Radix(radix), letters: letters)
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
        "TextInt: throws error if radix is invalid",
        Tag.List.tags(.generic, .random),
        TimeLimitTrait.timeLimit(TimeLimitTrait.Duration.minutes(3)),
        arguments: typesAsBinaryInteger, fuzzers
    )   func throwsErrorIfRadixIsInvalid(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var   counter = 00
            while counter < 32 {
                let radix = T.entropic(through: Shift.max(or: 255), using: &randomness)
                if  2 <= radix, radix <= 36 { continue } else { counter += 1 }
                
                for letters in Self.letters {
                    try #require(throws: TextInt.Error.invalid) {
                        try TextInt(radix: radix, letters: letters)
                    }
                    
                    if  let radix = Radix.exactly(radix).optional() {
                        try #require(throws: TextInt.Error.invalid) {
                            try TextInt(radix: radix, letters: letters)
                        }
                    }
                }
            }
        }
    }
    
    @Test(
        "TextInt: throws error if radix is one past limit",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryInteger, [1, 37] as [I8]
    )   func throwsErrorIfRadixIsOnePastLimit(type: any BinaryInteger.Type, radix: I8) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for letters in Self.letters {
                if  let radix = T.exactly(radix).optional() {
                    try #require(throws: TextInt.Error.invalid) {
                        try TextInt(radix: radix, letters: letters)
                    }
                }
                
                if  let radix = Radix.exactly(radix).optional() {
                    try #require(throws: TextInt.Error.invalid) {
                        try TextInt(radix: radix, letters: letters)
                    }
                }
            }
        }
    }
}
