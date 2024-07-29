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
import RandomIntKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Open Source x Swift
//*============================================================================*

/// An adaptation of Swift's BigInt prototype tests.
///
/// https://github.com/swiftlang/swift/blob/6ead0c8071974b3ecf678ddf63d719bbc8c68626/test/Prototypes/BigInt.swift
///
/// - Note: StdlibInt uses two's complement.
///
/// - Note: Swift's BigInt prototype uses sign and magnitude.
///
/// - Note: StdlibInt is not a generic type.
///
/// - Note: Swift's BigInt prototype is a generic type.
///
/// - Note: Some tests don't have 1:1 translations.
///
final class StdlibIntTestsLikeOpenSourceTestsBySwift: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// See also: `BigInt.init(randomBits:)` and `randomBitLength()`.
    func makeRandomStdlibInt(maxBitWidth: Swift.Int = .random(in: 2...1000)) -> StdlibInt {
        StdlibInt(IXL.random(through: Shift(Count(IX(maxBitWidth).decremented().unwrap()))))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x BigInt
    //=------------------------------------------------------------------------=
    
    /// See also: `BigIntTests.test("Initialization")`.
    func testInitialization() {
        let a = StdlibInt(1_000_000 as Swift.Int)
        Test().same(a.magnitude.words[0], 1_000_000 as Swift.UInt)
        Test().nay (a < 0)
        
        let b = StdlibInt(1_000 as Swift.UInt16)
        Test().same(b.magnitude.words[0], 1_000 as Swift.UInt)
        Test().nay (b < 0)

        let c = StdlibInt(-1_000_000 as Swift.Int)
        Test().same(c.magnitude.words[0], 1_000_000 as Swift.UInt)
        Test().yay (c < 0)

        let d = StdlibInt(c * c * c * c * c * c)
        Test().same(Array(d.magnitude.words), [12919594847110692864, 54210108624275221] as [Swift.UInt])
        Test().nay (d < 0)
    }
    
    /// See also: `BigIntTests.test("Identity/Fixed point")`.
    func testIdentityFixedPoint() {
        let a = StdlibInt(IXL(repeatElement(UX.max, count: 20)))
        let b = -a

        Test().same( a /  a,  1)
        Test().same( a /  b, -1)
        Test().same( b /  a, -1)
        Test().same( b /  b,  1)
        Test().same( a %  a,  0)
        Test().same( a %  b,  0)
        Test().same( b %  a,  0)
        Test().same( b %  b,  0)

        Test().same( a *  1,  a)
        Test().same( b *  1,  b)
        Test().same( a * -1,  b)
        Test().same( b * -1,  a)
        Test().same(-a,       b)
        Test().same(-b,       a)

        Test().same( a +  0,  a)
        Test().same( b +  0,  b)
        Test().same( a -  0,  a)
        Test().same( b -  0,  b)

        Test().same( a -  a,  0)
        Test().same( b -  b,  0)
    }
    
    /// See also: `BigIntTests.test("Max arithmetic")`.
    func testMaxArithmetic() {
        let a = StdlibInt(IXL(repeatElement(UX.max, count: 50)))
        let b = StdlibInt(IXL(repeatElement(UX.max, count: 35)))
        let (q, r) = a.quotientAndRemainder(dividingBy: b)

        Test().same(q * b + r, a)
        Test().same(q * b, a - r)
    }
    
    
    /// See also: `BigIntTests.test("Zero arithmetic")`.
    func testZeroArithmetic() {
        let zero: StdlibInt = 0
        Test().yay(zero == 0)
        Test().nay(zero <  0)

        let a: StdlibInt = 1
        Test().yay((a - a) == 0)
        Test().nay((a - a) <  0)

        let b: StdlibInt = -1
        Test().yay((b < 0))
        Test().yay((b - b) == 0)
        Test().nay((b - b) <  0)

        Test().same(a * zero, zero)
        /*
        Test().traps({ a / zero })
        */
    }
    
    /// See also: `BigIntTests.test("Conformances")`.
    func testConformances() {
        let a = StdlibInt(Swift.Int.max)
        let b = (a * a * a * a * a)
        Test().comparison(b, b + 1, -1 as Signum, id: ComparableID())
        Test().comparison(b, b - 1,  1 as Signum, id: ComparableID())
        Test().comparison(b, 0,      1 as Signum, id: ComparableID())
        
        let c = -b
        Test().comparison(c, c + 1, -1 as Signum, id: ComparableID())
        Test().comparison(c, c - 1,  1 as Signum, id: ComparableID())
        Test().comparison(c, 0,     -1 as Signum, id: ComparableID())
        
        Test().same(-c,     b)
        Test().same( b + c, 0)
        
        Test().nonsame(a.hashValue, b.hashValue)
        Test().nonsame(b.hashValue, c.hashValue)
        
        let set = Set([a, b, c])
        Test().yay(set.contains( a))
        Test().yay(set.contains( b))
        Test().yay(set.contains( c))
        Test().nay(set.contains(-a))
    }
    
    /// See also: `BigIntTests.test("BinaryInteger interop")`.
    func testBinaryIntegerInterop() {
        let a:  StdlibInt = 100
        let b = Swift.UInt8(a)
        Test().yay(a == b)
        Test().yay(a <  b + 1)
        Test().nay(b +  1 < a)

        let c:  StdlibInt = -100
        let d = Swift.Int8(c)
        Test().yay(c == d)
        Test().yay(c <  d + 1)
        Test().nay(d +  1 < c)
        
        let e = StdlibInt(Swift.Int.min + 1)
        let f = Swift.Int(truncatingIfNeeded: e)
        Test().yay(e == f)
        Test().yay(f == e)
        Test().nay(f +  1 < e)
        Test().yay(e <  f + 1)

        let g = StdlibInt(Swift.UInt.max)
        let h = Swift.UInt(truncatingIfNeeded: g)
        Test().yay(g == h)
        Test().yay(h == g)
        Test().yay(h -  1 < g)
        Test().nay(g <  h - 1)
    }
    
    /// See also: `BigIntTests.test("Huge")`.
    func testHuge() {
        let a = makeRandomStdlibInt(maxBitWidth: 1_000_000)
        let b = -a

        Test().comparison(a, a - 1, 1 as Signum, id: ComparableID())
        Test().comparison(b, b - 1, 1 as Signum, id: ComparableID())
    }
    
    /// See also: `BigIntTests.test("Numeric")`.
    func testNumeric() {
        let values: [(dividend: String, divisor: String, quotient: String, remainder: String)] = [
            ("3GFWFN54YXNBS6K2ST8K9B89Q2AMRWCNYP4JAS5ZOPPZ1WU09MXXTIT27ZPVEG2Y",
            "9Y1QXS4XYYDSBMU4N3LW7R3R1WKK",
            "CIFJIVHV0K4MSX44QEX2US0MFFEAWJVQ8PJZ",
            "26HILZ7GZQN8MB4O17NSPO5XN1JI"),
            ("7PM82EHP7ZN3ZL7KOPB7B8KYDD1R7EEOYWB6M4SEION47EMS6SMBEA0FNR6U9VAM70HPY4WKXBM8DCF1QOR1LE38NJAVOPOZEBLIU1M05",
            "-202WEEIRRLRA9FULGA15RYROVW69ZPDHW0FMYSURBNWB93RNMSLRMIFUPDLP5YOO307XUNEFLU49FV12MI22MLCVZ5JH",
            "-3UNIZHA6PAL30Y",
            "1Y13W1HYB0QV2Z5RDV9Z7QXEGPLZ6SAA2906T3UKA46E6M4S6O9RMUF5ETYBR2QT15FJZP87JE0W06FA17RYOCZ3AYM3"), 
            ("-ICT39SS0ONER9Z7EAPVXS3BNZDD6WJA791CV5LT8I4POLF6QYXBQGUQG0LVGPVLT0L5Z53BX6WVHWLCI5J9CHCROCKH3B381CCLZ4XAALLMD",
            "6T1XIVCPIPXODRK8312KVMCDPBMC7J4K0RWB7PM2V4VMBMODQ8STMYSLIXFN9ORRXCTERWS5U4BLUNA4H6NG8O01IM510NJ5STE",
            "-2P2RVZ11QF",
            "-3YSI67CCOD8OI1HFF7VF5AWEQ34WK6B8AAFV95U7C04GBXN0R6W5GM5OGOO22HY0KADIUBXSY13435TW4VLHCKLM76VS51W5Z9J"), 
            ("-326JY57SJVC",
            "-8H98AQ1OY7CGAOOSG",
             "0",
            "-326JY57SJVC"),
            ("-XIYY0P3X9JIDF20ZQG2CN5D2Q5CD9WFDDXRLFZRDKZ8V4TSLE2EHRA31XL3YOHPYLE0I0ZAV2V9RF8AGPCYPVWEIYWWWZ3HVDR64M08VZTBL85PR66Z2F0W5AIDPXIAVLS9VVNLNA6I0PKM87YW4T98P0K",
            "-BUBZEC4NTOSCO0XHCTETN4ROPSXIJBTEFYMZ7O4Q1REOZO2SFU62KM3L8D45Z2K4NN3EC4BSRNEE",
            "2TX1KWYGAW9LAXUYRXZQENY5P3DSVXJJXK4Y9DWGNZHOWCL5QD5PLLZCE6D0G7VBNP9YGFC0Z9XIPCB",
            "-3LNPZ9JK5PUXRZ2Y1EJ4E3QRMAMPKZNI90ZFOBQJM5GZUJ84VMF8EILRGCHZGXJX4AXZF0Z00YA"),
            ("AZZBGH7AH3S7TVRHDJPJ2DR81H4FY5VJW2JH7O4U7CH0GG2DSDDOSTD06S4UM0HP1HAQ68B2LKKWD73UU0FV5M0H0D0NSXUJI7C2HW3P51H1JM5BHGXK98NNNSHMUB0674VKJ57GVVGY4",
            "1LYN8LRN3PY24V0YNHGCW47WUWPLKAE4685LP0J74NZYAIMIBZTAF71",
            "6TXVE5E9DXTPTHLEAG7HGFTT0B3XIXVM8IGVRONGSSH1UC0HUASRTZX8TVM2VOK9N9NATPWG09G7MDL6CE9LBKN",
            "WY37RSPBTEPQUA23AXB3B5AJRIUL76N3LXLP3KQWKFFSR7PR4E1JWH"),
            ("1000000000000000000000000000000000000000000000",
            "1000000000000000000000000000000000000",
            "1000000000",
            "0")
        ]
        
        for strings in values {
            let dividend  = try! StdlibInt(strings.0, as: .radix(36))
            let divisor   = try! StdlibInt(strings.1, as: .radix(36))
            let quotient  = try! StdlibInt(strings.2, as: .radix(36))
            let remainder = try! StdlibInt(strings.3, as: .radix(36))
            
            let division  = dividend.quotientAndRemainder(dividingBy: divisor)
            Test().same(division.quotient,  quotient)
            Test().same(division.remainder, remainder)
            Test().same(dividend, divisor * quotient + remainder)
        }
    }
    
    /// See also: `BigIntTests.test("Strings")`.
    func testStrings() {
        let a = try! StdlibInt("-3UNIZHA6PAL30Y", as: .radix(36))
        Test().same(String(a, radix: 02, uppercase: true), "-1000111001110110011101001110000001011001110110011011110011000010010010")
        Test().same(String(a, radix: 10, uppercase: true), "-656993338084259999890")
        Test().same(String(a, radix: 16, uppercase: true), "-239D9D3816766F3092")
        Test().same(String(a, radix: 36, uppercase: true), "-3UNIZHA6PAL30Y")

        Test().yay(StdlibInt( "12345") ==  12345)
        Test().yay(StdlibInt("-12345") == -12345)

        Test().none(try? StdlibInt("-3UNIZHA6PAL30Y", as: .decimal))
        Test().none(StdlibInt( "---"))
        Test().none(StdlibInt(" 123"))
    }
    
    /// See also: `BigIntTests.test("Randomized arithmetic")`.
    func testRandomizedArithmetic() {
        let a = makeRandomStdlibInt()
        let b = makeRandomStdlibInt()
        
        if  b != (0) {
          let (q, r) = a.quotientAndRemainder(dividingBy: b)
          Test().same(q * b + r,  a)
          Test().same(q * b,  a - r)
        }

        let c = makeRandomStdlibInt()
        let d = makeRandomStdlibInt()
        let e = makeRandomStdlibInt()
        let f = makeRandomStdlibInt()
        
        Test().same((c + d) * (e + f), (c * e) + (c * f) + (d * e) + (d * f))
    }
    
    /// See also: `BigIntTests.test("isMultiple")`.
    func testIsMultiple() {
        Test().yay((0 as StdlibInt).isMultiple(of: 0))
        Test().nay((1 as StdlibInt).isMultiple(of: 0))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x BigInt8
    //=------------------------------------------------------------------------=
    
    /// See also: `BigInt8Tests.test("Bitshift")`.
    func testBitshift() {
        Test().same(StdlibInt(255) << 1, 510)
        Test().yay (StdlibInt(Swift.UInt32.max) << 16 == Swift.UInt(Swift.UInt32.max) << 16)
        
        let a = StdlibInt(1)
        let b = Swift.UInt(1)
        
        for i in 0 ..< 64 {
          Test().yay((a << i) == (b << i))
        }

        let c = StdlibInt(Swift.UInt.max)
        let d = Swift.UInt.max
        
        for i in 0 ... 64 {
          Test().yay((c >> i) == (d >> i))
        }

        let e = StdlibInt(-1)
        let f = Swift.Int(-1)
        
        for i in 0 ..< 64 {
          Test().yay((e << i) == (f << i))
        }
    }
    
    /// See also: `BigInt8Tests.test("Bitwise")`.
    func testBitwise() {
        let bases: [StdlibInt] = [
            StdlibInt(Swift.Int.max - 2),
            StdlibInt(255),
            StdlibInt(256),
            StdlibInt(Swift.UInt32.max),
        ]
        
        for base: StdlibInt in bases {
            for value: StdlibInt in [base, -base] {
                Test().yay( value |  0 ==  value)
                Test().yay( value &  0 ==  0)
                Test().yay( value & ~0 ==  value)
                Test().yay( value ^  0 ==  value)
                Test().yay( value ^ ~0 == ~value)
                Test().yay( value      == StdlibInt( Swift.Int(truncatingIfNeeded: value)))
                Test().yay(~value      == StdlibInt(~Swift.Int(truncatingIfNeeded: value)))
            }
        }
    }
}
