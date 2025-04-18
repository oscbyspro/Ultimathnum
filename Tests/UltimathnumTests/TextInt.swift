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
// MARK: * Text Int
//*============================================================================*

@Suite struct TextIntTests {
    
    /// The preferred radix type.
    ///
    /// - Note: Generic alternatives derive from it.
    ///
    typealias Radix = UX // TODO: consider IX or fancy branches
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt: named instances",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(TextInt, U8, TextInt.Letters)>.infer([
            
        (TextInt.binary,      U8(02), TextInt.Letters.lowercase),
        (TextInt.decimal,     U8(10), TextInt.Letters.lowercase),
        (TextInt.hexadecimal, U8(16), TextInt.Letters.lowercase),
        
    ])) func namedInstances(
        instance: TextInt, radix: U8, letters: TextInt.Letters
    )   throws {
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
        
        for radix: Radix in TextInt.radices {
            let generic: some BinaryInteger = radix
            try #require(TextInt(radix:   radix)?.letters == TextInt.Letters.lowercase)
            try #require(TextInt(radix: generic)?.letters == TextInt.Letters.lowercase)
            try #require(TextInt.radix(   radix)?.letters == TextInt.Letters.lowercase)
            try #require(TextInt.radix( generic)?.letters == TextInt.Letters.lowercase)
        }
    }
    
    @Test(
        "TextInt: from each radix in [2, 36]",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsBinaryInteger
    )   func fromEachRadixFromTwoThrough36(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for radix in TextInt.radices.lazy.map(T.init) {
                for letters in TextInt.letters {
                    let instance = try #require(TextInt(radix:      (radix), letters: letters))
                    let concrete = try #require(TextInt(radix: Radix(radix), letters: letters))
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
    )   func throwsErrorIfRadixIsInvalid(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var   counter = 00
            while counter < 32 {
                let radix = T.entropic(through: Shift.max(or: 255), using: &randomness)
                if  2 <= radix, radix <= 36 { continue } else { counter += 1 }
                
                for letters in TextInt.letters {
                    if  let radix = T.exactly(radix).optional() {
                        try #require(TextInt(radix: radix, letters: letters) == nil)
                    }
                    
                    if  let radix = Radix.exactly(radix).optional() {
                        try #require(TextInt(radix: radix, letters: letters) == nil)
                    }
                }
            }
        }
    }
    
    @Test(
        "TextInt: throws error if radix is one past limit",
        Tag.List.tags(.generic, .exhaustive),
        arguments: typesAsBinaryInteger, [1, 37] as [I8]
    )   func throwsErrorIfRadixIsOnePastLimit(
        type: any BinaryInteger.Type, radix: I8
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for letters in TextInt.letters {
                if  let radix = T.exactly(radix).optional() {
                    try #require(TextInt(radix: radix, letters: letters) == nil)
                }
                
                if  let radix = Radix.exactly(radix).optional() {
                    try #require(TextInt(radix: radix, letters: letters) == nil)
                }
            }
        }
    }
}
