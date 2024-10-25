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
// MARK: * Binary Integer x Text
//*============================================================================*

@Suite struct BinaryIntegerTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text: description is stable",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionIsStable(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                let value = T.entropic(size: size, using: &randomness)
                let radix = UX.random(in: 02...36, using: &randomness)
                let uppercase = Bool.random(using: &randomness.stdlib)
                let letters   = TextInt.Letters(uppercase:  uppercase)
                let coder = try TextInt(radix: radix, letters: letters)
                try Ɣrequire(bidirectional: value, using: coder)
            }
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                let value = T.entropic(size: size, using: &randomness)
                try Ɣrequire(bidirectional: value, using: TextInt.decimal)
                try Ɣrequire(bidirectional: value, using: TextInt.hexadecimal.lowercased())
                try Ɣrequire(bidirectional: value, using: TextInt.hexadecimal.uppercased())
            }
            
            func Ɣrequire(bidirectional value: T, using coder: TextInt, at location: SourceLocation = #_sourceLocation) throws {
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
    )   func descriptionLetterCaseIsStable(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                let value = T.entropic(size: size, using: &randomness)
                let radix = UX.random(in: 02...36, using: &randomness)
                let coder = try TextInt(radix: radix)
                
                let lowercased: String = value.description(as: coder.lowercased())
                let uppercased: String = value.description(as: coder.uppercased())
                
                if  radix <= 10 {
                    try #require(lowercased == uppercased)
                }
                
                try #require(lowercased == lowercased.lowercased())
                try #require(uppercased == uppercased.uppercased())
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
// MARK: * Binary Integer x Text x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnTextEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text/edge-cases: description of negative vs positive",
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
        "BinaryInteger/text/edge-cases: description of infinite vs finite",
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
