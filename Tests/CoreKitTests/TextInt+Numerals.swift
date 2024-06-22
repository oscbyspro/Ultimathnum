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

extension TextIntTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNumerals() {
        //=--------------------------------------=
        // test: the maximum radix is 36
        //=--------------------------------------=
        Test().failure({ try T.Numerals(37, letters: .lowercase) }, E.invalid)
        Test().failure({ try T.Numerals(37, letters: .uppercase) }, E.invalid)
        //=--------------------------------------=
        // test: for each radix in 0 through 36
        //=--------------------------------------=
        for radix: UX in 0 ... 36  {
            guard let lowercase = Test().success({ try T.Numerals(radix, letters: .lowercase) }) else { break }
            guard let uppercase = Test().success({ try T.Numerals(radix, letters: .uppercase) }) else { break }
            //=----------------------------------=
            Test().same(lowercase.radix,   U8(load: radix))
            Test().same(lowercase.letters, TextInt.Letters.lowercase)
            Test().same(uppercase.radix,   U8(load: radix))
            Test().same(uppercase.letters, TextInt.Letters.uppercase)
            //=----------------------------------=
            // test: decoding
            //=----------------------------------=
            for coder in [lowercase, uppercase] {
                for byte in Self.numerals.invalid {
                    Test().failure({ try coder.decode(U8(byte)) }, E.invalid)
                }
                
                for source in [Self.numerals.lowercase, Self.numerals.uppercase] {
                    for index in source.indices {
                        let text = U8(source[  index])
                        let data = U8(load: IX(index))
                        if  data < radix {
                            Test().success({ try coder.decode(text) }, data)
                        }   else {
                            Test().failure({ try coder.decode(U8(source[index])) }, E.invalid)
                        }
                    }
                }
            }
            //=----------------------------------=
            // test: encoding
            //=----------------------------------=
            for value in U8.min ..< U8(load: radix) {
                Test().success({ try lowercase.encode(value) }, U8(Self.numerals.lowercase[Int(IX(load: value))]))
                Test().success({ try uppercase.encode(value) }, U8(Self.numerals.uppercase[Int(IX(load: value))]))
            }
            
            for value in U8(load: radix) ... U8.max {
                Test().failure({ try lowercase.encode(value) }, E.invalid)
                Test().failure({ try uppercase.encode(value) }, E.invalid)
            }
        }
    }
}
