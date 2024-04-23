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
// MARK: * Text Int x Base
//*============================================================================*

extension TextIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodeAsAnyBaseIsValid() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias R = Result<T, TextInt.Failure>
            //=----------------------------------=
            let negative = T.isSigned ? R.success(-1) : R.failure(.overflow)
            //=----------------------------------=
            for radix in Self.radices {
                guard let lowercase = Test().some(try? TextInt(radix: radix, letters: .lowercase)) else { return }
                guard let uppercase = Test().some(try? TextInt(radix: radix, letters: .uppercase)) else { return }
                
                for item in [lowercase, uppercase] {
                    Case(item).decode(   "0", R.success(0))
                    Case(item).decode(  "#0", R.success(0))
                    Case(item).decode(  "&0", R.failure(.overflow))
                    Case(item).decode(  "+0", R.success(0))
                    Case(item).decode( "+#0", R.success(0))
                    Case(item).decode( "+&0", R.failure(.overflow))
                    Case(item).decode(  "-0", R.success(0))
                    Case(item).decode( "-#0", R.success(0))
                    Case(item).decode( "-&0", R.failure(.overflow))
                    Case(item).decode(  "00", R.success(0))
                    Case(item).decode( "#00", R.success(0))
                    Case(item).decode( "&00", R.failure(.overflow))
                    Case(item).decode( "+00", R.success(0))
                    Case(item).decode("+#00", R.success(0))
                    Case(item).decode("+&00", R.failure(.overflow))
                    Case(item).decode( "-00", R.success(0))
                    Case(item).decode("-#00", R.success(0))
                    Case(item).decode("-&00", R.failure(.overflow))
                    
                    Case(item).decode(   "1", R.success(1))
                    Case(item).decode(  "#1", R.success(1))
                    Case(item).decode(  "&1", R.failure(.overflow))
                    Case(item).decode(  "+1", R.success(1))
                    Case(item).decode( "+#1", R.success(1))
                    Case(item).decode( "+&1", R.failure(.overflow))
                    Case(item).decode(  "-1",  negative)
                    Case(item).decode( "-#1",  negative)
                    Case(item).decode( "-&1", R.failure(.overflow))
                    Case(item).decode(  "01", R.success(1))
                    Case(item).decode( "#01", R.success(1))
                    Case(item).decode( "&01", R.failure(.overflow))
                    Case(item).decode( "+01", R.success(1))
                    Case(item).decode("+#01", R.success(1))
                    Case(item).decode("+&01", R.failure(.overflow))
                    Case(item).decode( "-01",  negative)
                    Case(item).decode("-#01",  negative)
                    Case(item).decode("-&01", R.failure(.overflow))
                }
            }
        }
                
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testDecodingAsAnyBaseIsInvalid() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias R = Result<T, TextInt.Failure>

            Case(TextInt.radix(02)).decode("2", R.failure(.invalid))
            Case(TextInt.radix(10)).decode("a", R.failure(.invalid))
            Case(TextInt.radix(16)).decode("g", R.failure(.invalid))
            
            for radix in Self.radices {
                let (item) = TextInt.radix(radix)

                Case(item).decode(   " ", R.failure(.invalid))
                Case(item).decode(   "+", R.failure(.invalid))
                Case(item).decode(   "-", R.failure(.invalid))
                Case(item).decode(   "#", R.failure(.invalid))
                Case(item).decode(   "&", R.failure(.invalid))
                
                Case(item).decode(  " 0", R.failure(.invalid))
                Case(item).decode(  " 1", R.failure(.invalid))
                Case(item).decode(  "0 ", R.failure(.invalid))
                Case(item).decode(  "1 ", R.failure(.invalid))
                
                Case(item).decode( "#+0", R.failure(.invalid))
                Case(item).decode( "#-0", R.failure(.invalid))
                Case(item).decode( "&+0", R.failure(.invalid))
                Case(item).decode( "&-0", R.failure(.invalid))
                
                Case(item).decode("!0000000000000000001", R.failure(.invalid))
                Case(item).decode("000000000!1000000000", R.failure(.invalid))
                Case(item).decode("0000000001!000000000", R.failure(.invalid))
                Case(item).decode("1000000000000000000!", R.failure(.invalid))
            }
        }
                
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testEncodingAsAnyBaseIsValid() {
        for radix in Self.radices {
            guard let lowercase = Test().success({ try TextInt(radix: radix, letters: .lowercase) }) else { break }
            guard let uppercase = Test().success({ try TextInt(radix: radix, letters: .uppercase) }) else { break }
            //=----------------------------------=
            // test: no elements in body is zero
            //=----------------------------------=
            for sign in Self.signs {
                for mask in Self.masks {
                    Case(lowercase).encode(sign.data, mask.data, [] as [U64], "\(sign.text)\(mask.text)0")
                    Case(uppercase).encode(sign.data, mask.data, [] as [U64], "\(sign.text)\(mask.text)0")
                }
            }
            //=----------------------------------=
            // test: one and zero with extension
            //=----------------------------------=
            for count in (0 ..< 4) {
                let x0 = [0] + Array(repeating: 0 as U64, count: count)
                let x1 = [1] + Array(repeating: 0 as U64, count: count)
                
                for item in [lowercase, uppercase] {
                    for sign in Self.signs {
                        for mask in Self.masks {
                            Case(item).encode(sign.data, mask.data, x0 as [U64], "\(sign.text)\(mask.text)0")
                            Case(item).encode(sign.data, mask.data, x1 as [U64], "\(sign.text)\(mask.text)1")
                        }
                    }
                }
            }
        }
    }
}
