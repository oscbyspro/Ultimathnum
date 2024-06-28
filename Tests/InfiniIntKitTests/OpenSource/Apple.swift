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
// MARK: * Infini Int x Open Source x Apple
//*============================================================================*
// https://github.com/apple/swift/blob/6ead0c8071974b3ecf678ddf63d719bbc8c68626/test/Prototypes/BigInt.swift
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testOpenSourceAppleBigIntBitwise() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            for value in [T(254), T(255), T(256), T(I32.max), T(U32.max)] {
                for x in [value, value.complement()] {
                    Test().or  (x,  0,  x)
                    Test().and (x,  0,  0)
                    Test().and (x, ~0,  x)
                    Test().xor (x,  0,  x)
                    Test().xor (x, ~0, ~x)
                    
                    Test().same(T(load:  I64(load: x)),  x)
                    Test().same(T(load: ~I64(load: x)), ~x)
                }
            }
        }
        
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
    
    func testOpenSourceAppleBigIntComparison() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            Test().comparison( 100 as T,  U8( 100 as T),  0 as Signum)
            Test().comparison( 100 as T,  U8( 101 as T), -1 as Signum)
            Test().comparison( 101 as T,  U8( 100 as T),  1 as Signum)
            Test().comparison( 101 as T,  U8( 101 as T),  0 as Signum)

            Test().comparison(T(UX.max) - 1, UX.max - 0, -1 as Signum)
            Test().comparison(T(UX.max) - 1, UX.max - 1,  0 as Signum)
            Test().comparison(T(UX.max) - 1, UX.max - 2,  1 as Signum)
        }
        
        func whereTheElementIsSigned<E>(_ type: E.Type) where E: SystemsInteger & SignedInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            Test().comparison(-100 as T,  I8(-100 as T),  0 as Signum)
            Test().comparison(-100 as T,  I8(-101 as T),  1 as Signum)
            Test().comparison(-101 as T,  I8(-100 as T), -1 as Signum)
            Test().comparison(-101 as T,  I8(-101 as T),  0 as Signum)
            
            Test().comparison(T(IX.min) + 1, IX.min + 0,  1 as Signum)
            Test().comparison(T(IX.min) + 1, IX.min + 1,  0 as Signum)
            Test().comparison(T(IX.min) + 1, IX.min + 2, -1 as Signum)
        }
        
        for element in Self.elements {
            whereTheElementIs(element)
        }
        
        for element in Self.elementsWhereIsSigned {
            whereTheElementIsSigned(element)
        }
    }
    
    func testOpenSourceAppleBigIntDivision() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let minus = T.isSigned ? "-" : ""
            let radix36 = TextInt.radix(0036)
            //=----------------------------------=
            Test().division(
                T(Array(repeating: U64.max, count: 50)),
                T(Array(repeating: U64.max, count: 35)),
                T(Array(repeating: U64.max, count: 15)) + 1,
                T(Array(repeating: U64.max, count: 15))
            )
            
            try! Test().division(
                T("\(minus)000000326JY57SJVC", as: radix36),
                T("\(minus)8H98AQ1OY7CGAOOSG", as: radix36),
                T("0000000000000000000000000", as: radix36),
                T("\(minus)000000326JY57SJVC", as: radix36)
            )
            
            try! Test().division(
                T("1000000000000000000000000000000000000000000000", as: radix36),
                T("0000000001000000000000000000000000000000000000", as: radix36),
                T("0000000000000000000000000000000000001000000000", as: radix36),
                T("0000000000000000000000000000000000000000000000", as: radix36)
            )
                        
            try! Test().division(
                T("3GFWFN54YXNBS6K2ST8K9B89Q2AMRWCNYP4JAS5ZOPPZ1WU09MXXTIT27ZPVEG2Y", as: radix36),
                T("0000000000000000000000000000000000009Y1QXS4XYYDSBMU4N3LW7R3R1WKK", as: radix36),
                T("0000000000000000000000000000CIFJIVHV0K4MSX44QEX2US0MFFEAWJVQ8PJZ", as: radix36),
                T("00000000000000000000000000000000000026HILZ7GZQN8MB4O17NSPO5XN1JI", as: radix36)
            )
                
            try! Test().division(
                T("""
                000000000000000000000007PM82EHP7ZN3ZL7KOPB7B8KYDD1R7EEOYWB6M4SEI\
                ON47EMS6SMBEA0FNR6U9VAM70HPY4WKXBM8DCF1QOR1LE38NJAVOPOZEBLIU1M05
                """, as: radix36), T("""
                \(minus)0000000000000000000000000000202WEEIRRLRA9FULGA15RYROVW69\
                ZPDHW0FMYSURBNWB93RNMSLRMIFUPDLP5YOO307XUNEFLU49FV12MI22MLCVZ5JH
                """, as: radix36), T("""
                \(minus)0000000000000000000000000000000000000000003UNIZHA6PAL30Y
                """, as: radix36), T("""
                0000000000000000000000000000000000001Y13W1HYB0QV2Z5RDV9Z7QXEGPLZ\
                6SAA2906T3UKA46E6M4S6O9RMUF5ETYBR2QT15FJZP87JE0W06FA17RYOCZ3AYM3
                """, as: radix36)
            )

            try! Test().division(
                T("""
                \(minus)000000000000ICT39SS0ONER9Z7EAPVXS3BNZDD6WJA791CV5LT8I4PO\
                LF6QYXBQGUQG0LVGPVLT0L5Z53BX6WVHWLCI5J9CHCROCKH3B381CCLZ4XAALLMD
                """, as: radix36), T("""
                000000000000000000000000000006T1XIVCPIPXODRK8312KVMCDPBMC7J4K0RW\
                B7PM2V4VMBMODQ8STMYSLIXFN9ORRXCTERWS5U4BLUNA4H6NG8O01IM510NJ5STE
                """, as: radix36), T("""
                \(minus)00000000000000000000000000000000000000000000002P2RVZ11QF
                """, as: radix36), T("""
                \(minus)0000000000000000000003YSI67CCOD8OI1HFF7VF5AWEQ34WK6B8AAF\
                V95U7C04GBXN0R6W5GM5OGOO22HY0KADIUBXSY13435TW4VLHCKLM76VS51W5Z9J
                """, as: radix36)
            )
            
            try! Test().division(
                T("""
                \(minus)000000000000000000000000000000XIYY0P3X9JIDF20ZQG2CN5D2Q5\
                CD9WFDDXRLFZRDKZ8V4TSLE2EHRA31XL3YOHPYLE0I0ZAV2V9RF8AGPCYPVWEIYW\
                WWZ3HVDR64M08VZTBL85PR66Z2F0W5AIDPXIAVLS9VVNLNA6I0PKM87YW4T98P0K
                """, as: radix36), T("""
                \(minus)00000000000000000000000000000000000000000000BUBZEC4NTOSC\
                O0XHCTETN4ROPSXIJBTEFYMZ7O4Q1REOZO2SFU62KM3L8D45Z2K4NN3EC4BSRNEE
                """, as: radix36), T("""
                00000000000000000000000000000000000000000000000002TX1KWYGAW9LAXU\
                YRXZQENY5P3DSVXJJXK4Y9DWGNZHOWCL5QD5PLLZCE6D0G7VBNP9YGFC0Z9XIPCB
                """, as: radix36), T("""
                \(minus)0000000000000000000000000000000000000000000003LNPZ9JK5PU\
                XRZ2Y1EJ4E3QRMAMPKZNI90ZFOBQJM5GZUJ84VMF8EILRGCHZGXJX4AXZF0Z00YA
                """, as: radix36)
            )
        }
        
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
    
    func testOpenSourceAppleBigIntShift() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            Test().upshift(T(U8 .max), 01, T([U8 .max << 01, U8 .max >> 07]))
            Test().upshift(T(U32.max), 16, T([U32.max << 16, U32.max >> 16]))
            //=----------------------------------=
            for distance in U64.zero ... 128 {
                Test().downshift(~0 as T, T(distance), ~0 as T)
            }
            
            for distance in U64.zero ..< 064 {
                Test()  .upshift( 1 as T, T(distance), T(U64(1) << distance))
            }
            
            for distance in U64.zero ... 064 {
                Test().downshift( 1 as T, T(distance), T(U64(1) >> distance))
            }
        }
        
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
    
    func testOpenSourceAppleBigIntText() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let minus = T.isSigned ? "-" : ""
            let value = try! T("\(minus)3UNIZHA6PAL30Y", as: .radix(36))
            //=----------------------------------=
            Test().description(value, radix: 36, body: ">>>>>>>\(minus)3UNIZHA6PAL30Y")
            Test().description(value, radix: 16, body: ">>>\(minus)239D9D3816766F3092")
            Test().description(value, radix: 10, body: "\(minus)656993338084259999890")
            Test().description(value, radix: 02, body: "\(minus)1000111001110110011101001110000001011001110110011011110011000010010010")
            //=----------------------------------=
            Test().same(T( "12345"), 12345)
            Test().same(T("-12345"), T.isSigned ? -12345 : nil)
            //=----------------------------------=
            for bad in ["---", " 123", "-3UNIZHA6PAL30Y"] {
                Test().none(T.init(((((bad))))))
                Test().failure({ try T(bad, as:     .decimal) }, TextInt.Failure.invalid)
                Test().failure({ try T(bad, as: .hexadecimal) }, TextInt.Failure.invalid)
            }
        }
        
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOpenSourceAppleBigIntIdentities() {
        func whereTheElementIsSigned<E>(_ type: E.Type) where E: SystemsInteger & SignedInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let a = T(Array(repeating: U64.max, count: 20)), b = a.complement()
            //=----------------------------------=
            Test().addition   (a, 0, Fallible(a))
            Test().addition   (b, 0, Fallible(b))
            Test().subtraction(a, 0, Fallible(a))
            Test().subtraction(b, 0, Fallible(b))
            Test().subtraction(a, a, Fallible(0))
            Test().subtraction(b, b, Fallible(0))
            
            Test().multiplication(a,  1, Fallible(a))
            Test().multiplication(a, -1, Fallible(b))
            Test().multiplication(b,  1, Fallible(b))
            Test().multiplication(b, -1, Fallible(a))
            
            Test().division(a, a, Fallible(Division(quotient:  1, remainder: 0)))
            Test().division(a, b, Fallible(Division(quotient: -1, remainder: 0)))
            Test().division(b, a, Fallible(Division(quotient: -1, remainder: 0)))
            Test().division(b, b, Fallible(Division(quotient:  1, remainder: 0)))
        }
        
        /// This part was not inspired by Apple (for obvious reasons).
        func whereTheElementIsUnsigned<E>(_ type: E.Type) where E: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let a = T(Array(repeating: U64.max, count: 20)), b = a.complement()
            //=----------------------------------=
            Test().addition   (a, 0, Fallible(a))
            Test().addition   (b, 0, Fallible(b))
            Test().subtraction(a, 0, Fallible(a))
            Test().subtraction(b, 0, Fallible(b))
            Test().subtraction(a, a, Fallible(0))
            Test().subtraction(b, b, Fallible(0))
            
            Test().multiplication(a,  1, Fallible(a))
            Test().multiplication(a, ~0, Fallible(b, error: true))
            Test().multiplication(b,  1, Fallible(b))
            Test().multiplication(b, ~0, Fallible(a, error: true))
            
            Test().division(a, a, Fallible(Division(quotient:  1, remainder: 0)))
            Test().division(a, b, Fallible(Division(quotient:  0, remainder: a)))
            Test().division(b, a, Fallible(Division(quotient: ~0, remainder: 0), error: true))
            Test().division(b, b, Fallible(Division(quotient:  1, remainder: 0)))
        }
        
        for element in Self.elementsWhereIsSigned {
            whereTheElementIsSigned(element)
        }
        
        for element in Self.elementsWhereIsUnsigned {
            whereTheElementIsUnsigned(element)
        }
    }
}
