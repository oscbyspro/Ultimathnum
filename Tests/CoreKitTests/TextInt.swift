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
// MARK: * Text Int
//*============================================================================*

final class TextIntTests: XCTestCase {
    
    typealias T = TextInt
    typealias E = TextInt.Failure
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    static let radices: Range<UX> = 2 ..< 37
    
    static let signs: [(data: Sign?, text: String)] = [(nil, ""), (Sign.plus, "+"), (Sign.minus, "-")]
    
    static let masks: [(data: Bit?,  text: String)] = [(nil, ""), (Bit .zero, "#"), (Bit .one,   "&")]
    
    static let numerals: (lowercase: [UInt8], uppercase: [UInt8], invalid: [UInt8]) = (
        [48...57, 97...122].flatMap({ $0 }),
        [48...57, 65...090].flatMap({ $0 }),
        [00...47, 58...64, 91...96, 123...255].flatMap({ $0 })
    )
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        Test().same(TextInt.radix(02), TextInt.binary)
        Test().same(TextInt.radix(10), TextInt.decimal)
        Test().same(TextInt.radix(16), TextInt.hexadecimal)
        
        for radix: UX in Self.radices {
            guard let lowercase = Test().success({ try TextInt(radix: radix, letters: .lowercase) }) else { return }
            guard let uppercase = Test().success({ try TextInt(radix: radix, letters: .uppercase) }) else { return }
            
            let standard = TextInt.radix(radix)
            Test().same(standard .radix, radix)
            Test().same(standard .letters, .lowercase)
            
            Test().same(lowercase.letters, .lowercase)
            Test().same(lowercase.lowercased().letters, .lowercase)
            Test().same(lowercase.uppercased().letters, .uppercase)
            
            Test().same(uppercase.letters, .uppercase)
            Test().same(uppercase.lowercased().letters, .lowercase)
            Test().same(uppercase.uppercased().letters, .uppercase)
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
            self.decode(normal: String(decoding: $0, as: UTF8.self), expectation)
        }
    }
    
    func decode<I: BinaryInteger>(normal description: String, _ expectation: Result<I, E>) {
        always: do {
            let value = try self.item.decode(description) as I
            test.same(Result.success(value), expectation)
        }   catch let error as TextInt.Failure {
            test.same(Result.failure(error), expectation)
            
            if  item.radix == 10 {
                test.same(I(description), nil, "BinaryInteger.init?(_:)")
            }
        }   catch {
            test.fail("unknown error before typed throws: \(error)")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Encoding (and Decoding)
    //=------------------------------------------------------------------------=
    
    func encode<I: BinaryInteger>(_ integer: I, _ expectation: String) {
        //=--------------------------------------=
        decoding: do {
            self.decode(normal: expectation, .success(integer))
        }
        //=--------------------------------------=
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
