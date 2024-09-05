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
// MARK: * Text Int
//*============================================================================*

final class TextIntTests: XCTestCase {
    
    typealias T = TextInt
    
    typealias E = TextInt.Error
    
    typealias R<Value> = Result<Value, TextInt.Error>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    static let regex36: Regex = #/^(\+|-)?(#|&)?([0-9A-Za-z]+)$/#
    
    static let radices: Range<U8> = 2 ..< 37
    
    static let letters: [TextInt.Letters] = [.lowercase, .uppercase]
    
    static let signs: [(data: Sign?, text: String)] = [(nil, ""), (Sign.plus, "+"), (Sign.minus, "-")]
    
    static let masks: [(data: Bit?,  text: String)] = [(nil, ""), (Bit .zero, "#"), (Bit .one,   "&")]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        Test().same(TextInt.radix(02), TextInt.binary)
        Test().same(TextInt.radix(10), TextInt.decimal)
        Test().same(TextInt.radix(16), TextInt.hexadecimal)
        
        for radix: U8 in Self.radices {
            guard let lowercase = Test().success(try TextInt(radix: radix, letters: .lowercase)) else { return }
            guard let uppercase = Test().success(try TextInt(radix: radix, letters: .uppercase)) else { return }
            
            Test().same(lowercase, TextInt.radix(U8(radix)))
            Test().same(lowercase, TextInt.radix(UX(radix)))
            
            Test().same(lowercase.letters, TextInt.Letters.lowercase)
            Test().same(uppercase.letters, TextInt.Letters.uppercase)
            
            for coder in [lowercase, uppercase] {
                Test().same(coder.radix, radix)
                Test().same(coder.lowercased().letters,        TextInt.Letters.lowercase)
                Test().same(coder.uppercased().letters,        TextInt.Letters.uppercase)
                Test().same(coder.letters(.lowercase).letters, TextInt.Letters.lowercase)
                Test().same(coder.letters(.uppercase).letters, TextInt.Letters.uppercase)
            }
        }
    }
    
    func testInitNegativeRadixIsInvalid() {
        for letters in Self.letters {
            Test().failure(try TextInt(radix: -1 as IXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt(radix: -2 as IXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt(radix: -3 as IXL, letters: letters), TextInt.Error.invalid)
        }
    }
    
    func testInitInfiniteRadixIsInvalid() {
        for letters in Self.letters {
            Test().failure(try TextInt(radix: ~0 as UXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt(radix: ~1 as UXL, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt(radix: ~2 as UXL, letters: letters), TextInt.Error.invalid)
        }
    }
    
    func testInitSuperBigRadixIsInvalid() {
        for letters in Self.letters {
            Test().failure(try TextInt(radix: UXL(UX.max) - 1, letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt(radix: UXL(UX.max),     letters: letters), TextInt.Error.invalid)
            Test().failure(try TextInt(radix: UXL(UX.max) + 1, letters: letters), TextInt.Error.invalid)
        }
    }
    
    func testInitDefaultLettersIsLowercase() throws {
        for radix: U8 in Self.radices {
            let numerals = try TextInt(radix: radix)
            Test().same(numerals.radix,   U8(radix))
            Test().same(numerals.letters, TextInt.Letters.lowercase)
        }
        
        for radix: UX in Self.radices.lazy.map(UX.init) {
            let numerals = try TextInt(radix: radix)
            Test().same(numerals.radix,   U8(radix))
            Test().same(numerals.letters, TextInt.Letters.lowercase)
        }
    }
    
    //*========================================================================*
    // MARK: * Case
    //*========================================================================*
    
    struct Case {
        
        typealias T = TextIntTests.T
        typealias E = TextIntTests.E
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let test: Test
        let item: TextInt
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        init(_ item: TextInt, test: Test) {
            self.test = test
            self.item = item
        }
        
        init(_ item: TextInt, file: StaticString = #file, line: UInt = #line) {
            self.init(item, test: Test(file: file, line: line))
        }
    }
}

//*============================================================================*
// MARK: * Text Int x Case x Assertions
//*============================================================================*

extension TextIntTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Decoding
    //=------------------------------------------------------------------------=
    
    func decode<I: BinaryInteger>(_ description: StaticString, _ expectation: Result<I, E>) {
        if  case let .success(value) = expectation {
            test.same(self.item.decode(description), value)
        }
        
        description.withUTF8Buffer {
            self.decode(dynamic: String(decoding: $0, as: UTF8.self), expectation)
        }
    }
    
    func decode<I: BinaryInteger>(dynamic description: String, _ expectation: Result<I, E>) {
        let matches36 = description.matches(of: TextIntTests.regex36)
        if  matches36.count != 1 {
            test.same(matches36.count, 0 as Int)
            test.same(expectation, Result.failure(E.invalid), "regex [36][mismatch]")
        }
        
        always: do {
            let value = try self.item.decode(description) as I
            test.same(Result.success(value), expectation)
            test.same(matches36.count, 1 as Int, "regex [36][success]")
            
        }   catch let error as E {
            test.same(Result.failure(error), expectation)
            
            if  item.radix == 10 {
                test.same(I(description), nil, "BinaryInteger.init?(_:)")
            }
            
            if  item.radix == 36, error == E.invalid {
                test.same(matches36.count, 0 as Int, "regex [36][failure]")
            }
            
        }   catch {
            test.fail("unknown error before typed throws: \(error)")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Encoding (and Decoding)
    //=------------------------------------------------------------------------=
    
    func encode<I: BinaryInteger>(_ integer: I, _ expectation: String) {
        decoding: do {
            self.decode(dynamic: expectation, .success(integer))
        }
        
        encoding: do {
            let result = self.item.encode(integer)
            test.same(result, expectation, "integer")
        }
        
        encoding: do {
            let sign = Sign(integer.isNegative)
            let magnitude = integer.magnitude()
            let result = self.item.encode(sign: sign, magnitude: magnitude)
            test.same(result, expectation, "sign-magnitude")
        }

        encoding: do {
            var body = integer
            let sign: Sign? =  I.isSigned && Bool(body.appendix) ? .minus : nil
            let mask: Bit?  = !I.isSigned && Bool(body.appendix) ? .one   : nil
            
            if  Bool(body.appendix) {
                body = body.complement(I.isSigned).value
            }
            
            let array = body.withUnsafeBinaryIntegerBody({ Array($0.buffer()) })
            self.encode(sign, mask, array, expectation)
        }
    }
    
    func encode<I>(_ sign: Sign?, _ mask: Bit?, _ body: [I], _ expectation: String) where I: SystemsInteger & UnsignedInteger {
        body.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: U8.self) {
                let result = self.item.encode(
                    sign: sign,
                    mask: mask,
                    body: DataInt.Body($0)!
                )
                
                test.same(result, expectation, "sign-mask-body")
            }
        }
    }
}
