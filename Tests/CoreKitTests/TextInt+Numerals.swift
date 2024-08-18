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
// MARK: * Text Int x Numerals
//*============================================================================*

final class TextIntTestsOnNumerals: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let radices: Range<UX> = 0..<37
    
    static let letters: [TextInt.Letters] = [.uppercase, .lowercase]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitialization() throws {
        for radix in Self.radices {
            for letters in Self.letters {
                let numerals = try TextInt.Numerals(radix, letters: letters)
                Test().same(numerals.radix, U8(radix))
                Test().same(numerals.letters, letters)
            }
        }
        
        for radix in Self.radices.upperBound...255 {
            for letters in Self.letters {
                Test().failure({ try TextInt.Numerals(radix, letters: letters) }, TextInt.Error.invalid)
            }
        }
    }
    
    func testDecodingEachByte() throws {
        var expectation: [U8: U8] = [:]
                
        Test().same(UInt8(ascii: "0"), 048)
        Test().same(UInt8(ascii: "9"), 057)

        for key: U8 in 048...057 {
            expectation[key] = key - 48
        }
        
        Test().same(UInt8(ascii: "A"), 065)
        Test().same(UInt8(ascii: "Z"), 090)
        
        for key: U8 in 065...090 {
            expectation[key] = key - 55
        }
        
        Test().same(UInt8(ascii: "a"), 097)
        Test().same(UInt8(ascii: "z"), 122)
        
        for key: U8 in 097...122 {
            expectation[key] = key - 87
        }
        
        for radix in Self.radices {
            for letters in Self.letters {
                let numerals = try TextInt.Numerals(radix, letters: letters)
                
                for key in U8.min...U8.max {
                    if  let value = expectation[key], value < radix {
                        Test().success({ try numerals.decode(key) }, value)
                    }   else {
                        Test().failure({ try numerals.decode(key) }, TextInt.Error.invalid)
                    }
                }
            }
        }
    }
    
    func testEncodingEachByte() throws {
        func whereIs(letters: TextInt.Letters, expectation: [U8]) throws {
            for radix in Self.radices {
                let numerals = try TextInt.Numerals(radix, letters: letters)
                
                for data in U8.min..<U8(radix) {
                    Test().success({ try numerals.encode(data) }, expectation[Int(IX(data))])
                }
                
                for data in U8(radix)..<U8.max {
                    Test().failure({ try numerals.encode(data) }, TextInt.Error.invalid)
                }
            }
        }
        
        try whereIs(letters: .uppercase, expectation: [48...57, 65...090].flatMap({ $0 }))
        try whereIs(letters: .lowercase, expectation: [48...57, 97...122].flatMap({ $0 }))
    }
}
