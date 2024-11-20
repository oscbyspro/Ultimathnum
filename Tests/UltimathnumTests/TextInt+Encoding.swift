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
// MARK: * Text Int x Encoding
//*============================================================================*

@Suite struct TextIntTestsOnEncoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/encoding: description matches known regex",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionMatchesKnownRegex(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let regex = TextInt.regex
            
            for _ in 0 ..< 64 {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let description = value.description(using: coder)
                let match = try #require(try regex.wholeMatch(in: description))
                try #require(match.output.0    == (description))
                try #require(match.output.sign == (value.isNegative ? "-" : nil))
                try #require(match.output.mask == (value.isInfinite ? "&" : nil))
            }
        }
    }
    
    @Test(
        "TextInt/encoding: (-) vs (+)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryIntegerAsSigned, fuzzers
    )   func negativeVersusPositive(
        type: any SignedInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 32 {
                let negative = T.entropic(size: size, as: Domain.natural, using: &randomness).toggled()
                let positive = negative.magnitude()
                
                try #require(negative.isNegative)
                try #require(positive.isPositive)
                
                for _ in 0 ..< 8 {
                    let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                    let lhs = negative.description(using: coder)
                    let rhs = positive.description(using: coder)
                    try #require(lhs == "-\(rhs)")
                }
            }
        }
    }

    @Test(
        "TextInt/encoding: (∞) vs (ℤ)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func infiniteVersusFinite(
        type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let (finite) = T.entropic(size: 256, as: Domain.finite, using: &randomness)
                let infinite = finite.toggled()
                
                try #require(!(finite).isInfinite)
                try #require( infinite.isInfinite)
                
                for _ in 0 ..< 8 {
                    let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                    let lhs = infinite.description(using: coder)
                    let rhs = (finite).description(using: coder)
                    try #require(lhs == "&\(rhs)")
                }
            }
        }
    }
    
    @Test(
        "TextInt/encoding: (-) & (∞) vs (ℤ)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func negativeAndInfiniteVersusFinite(
        type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let (finite) = T.entropic(size: 256, as: Domain.finite, using: &randomness)
                let infinite = finite.toggled()
                
                try #require(!(finite).isInfinite)
                try #require( infinite.isInfinite)
                
                for _ in 0 ..< 8 {
                    let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                    let lhs = coder.encode(sign: Sign.minus, magnitude: infinite)
                    let rhs = coder.encode(sign: Sign.plus,  magnitude: (finite))
                    try #require(lhs == "-&\(rhs)")
                }
            }
        }
    }
    
    @Test(
        "TextInt/encoding: uppercase vs lowercase",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func uppercaseVersusLowercase(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = T.entropic(size: size, using: &randomness)
                
                let lowercased: String = value.description(using: coder.lowercased())
                let uppercased: String = value.description(using: coder.uppercased())
                
                if  coder.radix <= 10 {
                    try #require(lowercased == uppercased)
                }
                
                try #require(lowercased == lowercased.lowercased())
                try #require(uppercased == uppercased.uppercased())
            }
        }
    }
    
    @Test(
        "TextInt/encoding: binary integer vs sign and magnitude",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func binaryIntegerVersusSignMagnitude(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 64 {
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let value = T.entropic(size: size, using: &randomness)
                let magnitude: T.Magnitude = value.magnitude()
                let expectation: String =  coder.encode(value)
                
                if !value.isNegative {
                    let result = coder.encode(sign: Sign.plus,  magnitude: magnitude)
                    try #require(result == expectation)
                }
                
                if !value.isPositive {
                    let result = coder.encode(sign: Sign.minus, magnitude: magnitude)
                    try #require(result == expectation)
                }
            }
        }
    }
}
