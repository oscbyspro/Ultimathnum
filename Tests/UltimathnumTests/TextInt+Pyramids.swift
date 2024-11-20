//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Text Int x Pyramids
//*============================================================================*

@Suite struct TextIntTestsOnPyramids {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let coders: [TextInt] = Self.radices.map({ TextInt.radix($0)! })
    
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
        "TextInt/pyramids: one followed by zeros",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger
    )   func oneFollowedByZeros(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for coder: TextInt in Self.coders {
                var encoded = String("1")
                var decoded = Fallible(T(1))
                let (radix) = T(coder.radix)
                
                for _ in 0 ..< 64 {
                    try #require(decoded == coder.decode(encoded))
                    
                    if !decoded.error {
                        try #require(encoded == decoded.value.description(using: coder))
                    }
                    
                    encoded.append("0")
                    decoded = decoded.map{$0.times(radix)}
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
        "TextInt/pyramids: ascending numeral cycle",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger
    )   func ascendingNumeralCycle(
        type: any BinaryInteger.Type
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for coder: TextInt in Self.coders {
                var encoded = String()
                var decoded = Fallible(T( ))
                let radix   = T(coder.radix)
                
                for index: U8 in 1 ... 64 {
                    let element = index % coder.radix
                    let numeral = try #require(coder.numerals.encode(element))
                    
                    decoded = decoded.map{$0.times(T((radix)))}
                    decoded = decoded.map{$0.plus (T(element))}
                    encoded.append(String(UnicodeScalar(UInt8(numeral))))
                    
                    try #require(decoded == coder.decode(encoded))
                    
                    if !decoded.error {
                        try #require(encoded == decoded.value.description(using: coder))
                    }
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
        "TextInt/pyramids: repeating highest numeral",
        Tag.List.tags(.generic, .important),
        arguments: typesAsBinaryInteger
    )   func repeatingHighestNumeral(
        type: any BinaryInteger.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for coder: TextInt in Self.coders {
                var encoded = String()
                var decoded = Fallible(T( ))
                let radix   = T(coder.radix)
                let value   = T(coder.radix - 1)
                let numeral = try #require(coder.numerals.encode(coder.radix - 1))
                
                for _ in 0 ..< 64 {
                    decoded = decoded.map{$0.times(radix)}
                    decoded = decoded.map{$0.plus (value)}
                    encoded.append(String(UnicodeScalar(UInt8(numeral))))
                    
                    try #require(decoded == coder.decode(encoded))
                    
                    if !decoded.error {
                        try #require(encoded == decoded.value.description(using: coder))
                    }
                }
            }
        }
    }
}
