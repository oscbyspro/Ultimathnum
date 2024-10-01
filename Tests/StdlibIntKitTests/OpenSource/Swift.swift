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
import TestKit2

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
@Suite(.tags(.opensource)) struct StdlibIntTestsLikeOpenSourceTestsBySwift {
    
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
    @Test func initialization() {
        let a = StdlibInt(1_000_000 as Swift.Int)
        #expect((a.magnitude.words[0]) == (1_000_000 as Swift.UInt))
        #expect((a < 0) == false)
        
        let b = StdlibInt(1_000 as Swift.UInt16)
        #expect((b.magnitude.words[0]) == (1_000 as Swift.UInt))
        #expect((b < 0) == false)

        let c = StdlibInt(-1_000_000 as Swift.Int)
        #expect((c.magnitude.words[0]) == (1_000_000 as Swift.UInt))
        #expect((c < 0))

        let d = StdlibInt(c * c * c * c * c * c)
        #expect((Array(d.magnitude.words)) == ([12919594847110692864, 54210108624275221] as [Swift.UInt]))
        #expect((d < 0) == false)
    }
    
    /// See also: `BigIntTests.test("Identity/Fixed point")`.
    @Test func identityFixedPoint() {
        let a = StdlibInt(IXL(Array(repeating: UX.max, count: 20)))
        let b = -a
        
        #expect(( a /  a) == ( 1))
        #expect(( a /  b) == (-1))
        #expect(( b /  a) == (-1))
        #expect(( b /  b) == ( 1))
        #expect(( a %  a) == ( 0))
        #expect(( a %  b) == ( 0))
        #expect(( b %  a) == ( 0))
        #expect(( b %  b) == ( 0))

        #expect(( a *  1) == ( a))
        #expect(( b *  1) == ( b))
        #expect(( a * -1) == ( b))
        #expect(( b * -1) == ( a))
        #expect((-a) == (      b))
        #expect((-b) == (      a))

        #expect(( a +  0) == ( a))
        #expect(( b +  0) == ( b))
        #expect(( a -  0) == ( a))
        #expect(( b -  0) == ( b))

        #expect(( a -  a) == ( 0))
        #expect(( b -  b) == ( 0))
    }
    
    /// See also: `BigIntTests.test("Max arithmetic")`.
    @Test func maxArithmetic() {
        let a = StdlibInt(IXL(Array(repeating: UX.max, count: 50)))
        let b = StdlibInt(IXL(Array(repeating: UX.max, count: 35)))
        let (q, r) = a.quotientAndRemainder(dividingBy: b)

        #expect((q * b + r) == (a))
        #expect((q * b) == (a - r))
    }
    
    /// See also: `BigIntTests.test("Zero arithmetic")`.
    @Test func zeroArithmetic() {
        let zero: StdlibInt = 0
        #expect((zero  == 0))
        #expect((zero  <  0) == false)
        
        let a =  1 as StdlibInt
        #expect((a - a == 0))
        #expect((a - a <  0) == false)

        let b = -1 as StdlibInt
        #expect((b < 0))
        #expect((b - b == 0))
        #expect((b - b <  0) == false)

        #expect((a * zero == zero))
    }
    
    /// See also: `BigIntTests.test("Conformances")`.
    @Test func conformances() {
        let a = StdlibInt(Swift.Int.max)
        let b = (a * a * a * a * a)
        Ɣexpect(( b), equals: (b + 1), is: Signum.negative)
        Ɣexpect(( b), equals: (b - 1), is: Signum.positive)
        Ɣexpect(( b), equals: (0),     is: Signum.positive)
        
        let c = (-b)
        Ɣexpect(( c), equals: (c + 1), is: Signum.negative)
        Ɣexpect(( c), equals: (c - 1), is: Signum.positive)
        Ɣexpect(( c), equals: (0),     is: Signum.negative)
        
        #expect((-c)     == b)
        #expect(( b + c) == 0)
        
        #expect(( a)     != b) // was a Hashable/hashValue comparison
        #expect(( b)     != c) // was a Hashable/hashValue comparison
        
        let set = Set([a, b,  c])
        #expect(set.contains( a))
        #expect(set.contains( b))
        #expect(set.contains( c))
        #expect(set.contains(-a) == false)
    }
    
    /// See also: `BigIntTests.test("BinaryInteger interop")`.
    @Test func binaryIntegerInterop() {
        let a:  StdlibInt = 100
        let b = Swift.UInt8(a)
        #expect((a == b))
        #expect((a <  b + 1))
        #expect((b +  1 < a) == false)

        let c:  StdlibInt = -100
        let d = Swift.Int8(c)
        #expect((c == d))
        #expect((c <  d + 1))
        #expect((d +  1 < c) == false)
        
        let e = StdlibInt(Swift.Int.min + 1)
        let f = Swift.Int(truncatingIfNeeded: e)
        #expect((e == f))
        #expect((f == e))
        #expect((f +  1 < e) == false)
        #expect((e <  f + 1))

        let g = StdlibInt(Swift.UInt.max)
        let h = Swift.UInt(truncatingIfNeeded: g)
        #expect((g == h))
        #expect((h == g))
        #expect((h -  1 < g))
        #expect((g <  h - 1) == false)
    }
    
    /// See also: `BigIntTests.test("Huge")`.
    @Test func huge() {
        let a = makeRandomStdlibInt(maxBitWidth: 1_000_000)
        let b = -a

        Ɣexpect((a), equals: a - 1, is: Signum.positive)
        Ɣexpect((b), equals: b - 1, is: Signum.positive)
    }
    
    /// See also: `BigIntTests.test("Numeric")`.
    @Test(arguments: [

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
        
    ] as [(String, String, String, String)])
    func numeric(dividend: String, divisor: String, quotient: String, remainder: String) throws {
        let dividend  = try StdlibInt(dividend,  as: .radix(36))
        let divisor   = try StdlibInt(divisor,   as: .radix(36))
        let quotient  = try StdlibInt(quotient,  as: .radix(36))
        let remainder = try StdlibInt(remainder, as: .radix(36))
        
        let division  = dividend.quotientAndRemainder(dividingBy: divisor)
        #expect(division.quotient  == quotient )
        #expect(division.remainder == remainder)
        #expect(dividend == (divisor * quotient + remainder))
    }
    
    /// See also: `BigIntTests.test("Strings")`.
    @Test func strings() throws {
        let a = try StdlibInt("-3UNIZHA6PAL30Y", as: .radix(36))
        #expect((String(a, radix: 02, uppercase: true)) == "-1000111001110110011101001110000001011001110110011011110011000010010010")
        #expect((String(a, radix: 10, uppercase: true)) == "-656993338084259999890")
        #expect((String(a, radix: 16, uppercase: true)) == "-239D9D3816766F3092")
        #expect((String(a, radix: 36, uppercase: true)) == "-3UNIZHA6PAL30Y")

        #expect((StdlibInt( "12345") ==  12345))
        #expect((StdlibInt("-12345") == -12345))

        #expect((try? StdlibInt("-3UNIZHA6PAL30Y", as: .decimal)) == nil)
        #expect((StdlibInt( "---")) == nil)
        #expect((StdlibInt(" 123")) == nil)
    }
    
    /// See also: `BigIntTests.test("Randomized arithmetic")`.
    @Test func randomizedArithmetic() {
        let a = makeRandomStdlibInt()
        let b = makeRandomStdlibInt()
        
        if  b != (0) {
          let (q, r) = a.quotientAndRemainder(dividingBy: b)
          #expect((q * b + r) == ( a))
          #expect((q * b) == ( a - r))
        }
        
        let c = makeRandomStdlibInt()
        let d = makeRandomStdlibInt()
        let e = makeRandomStdlibInt()
        let f = makeRandomStdlibInt()
        
        #expect(((c + d) * (e + f)) == ((c * e)) + (c * f) + (d * e) + (d * f))
    }
    
    /// See also: `BigIntTests.test("isMultiple")`.
    @Test func isMultiple() {
        #expect(((0 as StdlibInt).isMultiple(of: 0)))
        #expect(((1 as StdlibInt).isMultiple(of: 0)) == false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x BigInt8
    //=------------------------------------------------------------------------=
    
    /// See also: `BigInt8Tests.test("Bitshift")`.
    @Test func bitshift() {
        #expect((StdlibInt(255) << 1) == (510))
        #expect( (StdlibInt(Swift.UInt32.max)) << 16 == Swift.UInt(Swift.UInt32.max) << 16)
        
        let a = StdlibInt(1)
        let b = Swift.UInt(1)
        
        for i in 0 ..< 64 {
          #expect(((a << i) == (b << i)))
        }

        let c = StdlibInt(Swift.UInt.max)
        let d = Swift.UInt.max
        
        for i in 0 ... 64 {
          #expect(((c >> i) == (d >> i)))
        }

        let e = StdlibInt(-1)
        let f = Swift.Int(-1)
        
        for i in 0 ..< 64 {
          #expect(((e << i) == (f << i)))
        }
    }
    
    /// See also: `BigInt8Tests.test("Bitwise")`.
    @Test(arguments: [
        
        StdlibInt(Swift.Int.max-2),
        StdlibInt(255),
        StdlibInt(256),
        StdlibInt(Swift.UInt32.max),
        
    ])  func bitwise(base: StdlibInt) {
        for value: StdlibInt in [base, -base] {
            #expect(( value |  0 ==  value))
            #expect(( value &  0 ==  0))
            #expect(( value & ~0 ==  value))
            #expect(( value ^  0 ==  value))
            #expect(( value ^ ~0 == ~value))
            #expect(( value      == StdlibInt( Swift.Int(truncatingIfNeeded: value))))
            #expect((~value      == StdlibInt(~Swift.Int(truncatingIfNeeded: value))))
        }
    }
}
