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
import TestKit

//*============================================================================*
// MARK: * Text Int x Numerals
//*============================================================================*

final class TextIntTestsOnNumerals: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let radices: Range<U8> = 0..<37
    
    static let letters: [TextInt.Letters] = [.uppercase, .lowercase]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() throws {
        Test().same(TextInt.Numerals().radix,   10)
        Test().same(TextInt.Numerals().letters, TextInt.Letters.lowercase)
        
        for radix in Self.radices {
            for letters in Self.letters {
                let numerals = try TextInt.Numerals(radix: radix, letters: letters)
                Test().same(numerals.radix,   radix)
                Test().same(numerals.letters, letters)
                Test().same(numerals.lowercased().letters,        TextInt.Letters.lowercase)
                Test().same(numerals.uppercased().letters,        TextInt.Letters.uppercase)
                Test().same(numerals.letters(.lowercase).letters, TextInt.Letters.lowercase)
                Test().same(numerals.letters(.uppercase).letters, TextInt.Letters.uppercase)
            }
        }
        
        for radix in Self.radices.upperBound...255 {
            for letters in Self.letters {
                Test().failure(try TextInt.Numerals(radix: radix, letters: letters), TextInt.Error.invalid)
            }
        }
    }
    
    func testInitNegativeRadixIsInvalid() {
        for letters in Self.letters {
            Test().failure(try TextInt.Numerals(radix: -1 as IXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt.Numerals(radix: -2 as IXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt.Numerals(radix: -3 as IXL, letters: letters), TextInt.Error.invalid)
        }
    }
    
    func testInitInfiniteRadixIsInvalid() {
        for letters in Self.letters {
            Test().failure(try TextInt.Numerals(radix: ~0 as UXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt.Numerals(radix: ~1 as UXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt.Numerals(radix: ~2 as UXL, letters: letters), TextInt.Error.invalid)
        }
    }
    
    func testInitSuperBigRadixIsInvalid() {
        for letters in Self.letters {
            Test().failure(try TextInt.Numerals(radix: UXL(U8.max) - 1, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt.Numerals(radix: UXL(U8.max),     letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt.Numerals(radix: UXL(U8.max) + 1, letters: letters), TextInt.Error.invalid)
        }
    }
    
    func testInitDefaultLettersIsLowercase() throws {
        for radix: U8 in Self.radices {
            let numerals = try TextInt.Numerals(radix: radix)
            Test().same(numerals.radix,   U8(radix))
            Test().same(numerals.letters, TextInt.Letters.lowercase)
        }
        
        for radix: UX in Self.radices.lazy.map(UX.init) {
            let numerals = try TextInt.Numerals(radix: radix)
            Test().same(numerals.radix,   U8(radix))
            Test().same(numerals.letters, TextInt.Letters.lowercase)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingEachByteForEachRadix() throws {
        var expectation: [U8: U8] = [:]
                
        Test().same(UInt8(ascii: "0"),  48)
        Test().same(UInt8(ascii: "9"),  57)
        Test().same(UInt8(ascii: "A"),  65)
        Test().same(UInt8(ascii: "Z"),  90)
        Test().same(UInt8(ascii: "a"),  97)
        Test().same(UInt8(ascii: "z"), 122)
        
        for key: U8 in 48...57 {
            expectation[key] = key - 48
        }
        
        for key: U8 in 65...90 {
            expectation[key] = key - 55
        }
        
        for key: U8 in 97...122 {
            expectation[key] = key - 87
        }
        
        for radix in Self.radices {
            for letters in Self.letters {
                let numerals = try TextInt.Numerals(radix: radix, letters: letters)
                
                for key in U8.min...U8.max {
                    if  let value = expectation[key], value < radix {
                        Test().success(try numerals.decode(key), value)
                    }   else {
                        Test().failure(try numerals.decode(key), TextInt.Error.invalid)
                    }
                }
            }
        }
    }
    
    func testEncodingEachByteForEachRadix() throws {
        func whereIs(letters: TextInt.Letters, expectation: [U8]) throws {
            for radix in Self.radices {
                let numerals = try TextInt.Numerals(radix: radix, letters: letters)
                
                for data in U8.min..<U8(radix) {
                    Test().success(try numerals.encode(data), expectation[Int(IX(data))])
                }
                
                for data in U8(radix)..<U8.max {
                    Test().failure(try numerals.encode(data), TextInt.Error.invalid)
                }
            }
        }
        
        try whereIs(letters: .uppercase, expectation: [48...57, 65...090].flatMap({ $0 }))
        try whereIs(letters: .lowercase, expectation: [48...57, 97...122].flatMap({ $0 }))
    }
}
