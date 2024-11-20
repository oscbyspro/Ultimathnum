//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Text Int x Samples
//*============================================================================*

@Suite(.serialized) struct TextKitTestsOnSamples {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let coders: [TextInt] = Self.radices.map({ TextInt.radix($0)! })
    
    static let radices: [UX] = conditional(debug: [10, 16], release: [UX](2...36))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/samples: invalid",
        Tag.List.tags(.generic, .important),
        arguments: Array<String>.infer([
            
        String(   ),
        String(" "),
        String("+"),
        String("-"),
        String("&"),
        
        String(" 0"),
        String("  "),
        String("0 "),
        String("+ "),
        String("- "),
        String("& "),
        String(" +"),
        String("0+"),
        String("++"),
        String("-+"),
        String("&+"),
        String(" -"),
        String("0-"),
        String("+-"),
        String("--"),
        String("&-"),
        String(" &"),
        String("0&"),
        String("+&"),
        String("-&"),
        String("&&"),
        
        String(" 0 "),
        String("+0 "),
        String("-0 "),
        String("&0 "),
        String(" 0+"),
        String("+0+"),
        String("-0+"),
        String("&0+"),
        String(" 0-"),
        String("+0-"),
        String("-0-"),
        String("&0-"),
        String(" 0&"),
        String("+0&"),
        String("-0&"),
        String("&0&"),
        
    ])) func invalid(description: String) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let expectation = Optional<Fallible<T>>(nil)
            for coder in Self.coders {
                try #require(coder.decode(description) == expectation)
            }
        }
    }
    
    @Test(
        "TextInt/samples: zero",
        Tag.List.tags(.generic, .important),
        arguments: Array<String>.infer([
        
        String( "0"),
        String( "00"),
        String( "000"),
        String( "0000"),
        String( "00000"),
        String( "000000"),
        String( "0000000"),
        String( "00000000"),
        
        String("+0"),
        String("+00"),
        String("+000"),
        String("+0000"),
        String("+00000"),
        String("+000000"),
        String("+0000000"),
        String("+00000000"),
        
        String("-0"),
        String("-00"),
        String("-000"),
        String("-0000"),
        String("-00000"),
        String("-000000"),
        String("-0000000"),
        String("-00000000"),
        
    ])) func zero(description: String) throws {
        for destination in typesAsBinaryInteger {
            try whereIs(destination)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let expectation = Fallible(T.zero)
            for coder in Self.coders {
                try #require(coder.decode(description) == expectation)
            }
        }
    }
    
    @Test(
        "TextInt/samples: round-tripping radix 10",
        Tag.List.tags(.generic, .important),
        arguments: Array<(any BinaryInteger, String)>.infer([
        
        (I64(  U8.min) - 1, String("-1")),
        (I64(  U8.min),     String( "0")),
        
        (I64(  I8.min) - 1, String("-129")),
        (I64(  I8.min),     String("-128")),
        (I64(  I8.max),     String( "127")),
        (I64(  I8.max) + 1, String( "128")),
        (I64(  U8.max),     String( "255")),
        (I64(  U8.max) + 1, String( "256")),
        
        (I64( I16.min) - 1, String("-32769")),
        (I64( I16.min),     String("-32768")),
        (I64( I16.max),     String( "32767")),
        (I64( I16.max) + 1, String( "32768")),
        (I64( U16.max),     String( "65535")),
        (I64( U16.max) + 1, String( "65536")),
        
        (I64( I32.min) - 1, String("-2147483649")),
        (I64( I32.min),     String("-2147483648")),
        (I64( I32.max),     String( "2147483647")),
        (I64( I32.max) + 1, String( "2147483648")),
        (I64( U32.max),     String( "4294967295")),
        (I64( U32.max) + 1, String( "4294967296")),
        
        (IXL( I64.min) - 1, String("-9223372036854775809")),
        (IXL( I64.min),     String("-9223372036854775808")),
        (IXL( I64.max),     String( "9223372036854775807")),
        (IXL( I64.max) + 1, String( "9223372036854775808")),
        (IXL( U64.max),     String("18446744073709551615")),
        (IXL( U64.max) + 1, String("18446744073709551616")),
        
        (IXL(I128.min) - 1, String("-170141183460469231731687303715884105729")),
        (IXL(I128.min),     String("-170141183460469231731687303715884105728")),
        (IXL(I128.max),     String( "170141183460469231731687303715884105727")),
        (IXL(I128.max) + 1, String( "170141183460469231731687303715884105728")),
        (IXL(U128.max),     String( "340282366920938463463374607431768211455")),
        (IXL(U128.max) + 1, String( "340282366920938463463374607431768211456")),
        
        (UXL.max,           String("&0")),
        (UXL.max - 0xf,     String("&15")),
        (UXL.max - 0xff,    String("&255")),
        (UXL.max - 0xfff,   String("&4095")),
        (UXL.max - 0xffff,  String("&65535")),
        
        (IXL(-0x123456789abcdef0), String( "-1311768467463790320")),
        (IXL( 0x123456789abcdef0), String(  "1311768467463790320")),
        (IXL(-0x5555555555555555), String( "-6148914691236517205")),
        (IXL( 0x5555555555555555), String(  "6148914691236517205")),
        (IXL(-0xaaaaaaaaaaaaaaaa), String("-12297829382473034410")),
        (IXL( 0xaaaaaaaaaaaaaaaa), String( "12297829382473034410")),
        
    ])) func roundtrippingRadix10(value: any BinaryInteger, description: String) throws {
        let coder = TextInt.decimal
        for type in typesAsBinaryInteger {
            try  whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let expectation = T.exactly(value)
            try #require(coder.decode(description) == expectation)
            if  let expectation = expectation.optional() {
                try #require(coder.encode(expectation) == description)
            }
        }
    }
    
    @Test(
        "TextInt/samples: round-tripping radix 16",
        Tag.List.tags(.generic, .important),
        arguments: Array<(any BinaryInteger, String)>.infer([
            
        (I64(  U8.min) - 1, String("-1")),
        (I64(  U8.min),     String( "0")),
        
        (I64(  I8.min) - 1, String("-81")),
        (I64(  I8.min),     String("-80")),
        (I64(  I8.max),     String( "7f")),
        (I64(  I8.max) + 1, String( "80")),
        (I64(  U8.max),     String( "ff")),
        (I64(  U8.max) + 1, String("100")),
        
        (I64( I16.min) - 1, String("-8001")),
        (I64( I16.min),     String("-8000")),
        (I64( I16.max),     String( "7fff")),
        (I64( I16.max) + 1, String( "8000")),
        (I64( U16.max),     String( "ffff")),
        (I64( U16.max) + 1, String("10000")),
        
        (I64( I32.min) - 1, String("-80000001")),
        (I64( I32.min),     String("-80000000")),
        (I64( I32.max),     String( "7fffffff")),
        (I64( I32.max) + 1, String( "80000000")),
        (I64( U32.max),     String( "ffffffff")),
        (I64( U32.max) + 1, String("100000000")),
        
        (IXL( I64.min) - 1, String("-8000000000000001")),
        (IXL( I64.min),     String("-8000000000000000")),
        (IXL( I64.max),     String( "7fffffffffffffff")),
        (IXL( I64.max) + 1, String( "8000000000000000")),
        (IXL( U64.max),     String( "ffffffffffffffff")),
        (IXL( U64.max) + 1, String("10000000000000000")),
        
        (IXL(I128.min) - 1, String("-80000000000000000000000000000001")),
        (IXL(I128.min),     String("-80000000000000000000000000000000")),
        (IXL(I128.max),     String( "7fffffffffffffffffffffffffffffff")),
        (IXL(I128.max) + 1, String( "80000000000000000000000000000000")),
        (IXL(U128.max),     String( "ffffffffffffffffffffffffffffffff")),
        (IXL(U128.max) + 1, String("100000000000000000000000000000000")),
        
        (UXL.max,           String("&0")),
        (UXL.max - 0xf,     String("&f")),
        (UXL.max - 0xff,    String("&ff")),
        (UXL.max - 0xfff,   String("&fff")),
        (UXL.max - 0xffff,  String("&ffff")),
        
        (IXL(-0x123456789abcdef0), String("-123456789abcdef0")),
        (IXL( 0x123456789abcdef0), String( "123456789abcdef0")),
        (IXL(-0x5555555555555555), String("-5555555555555555")),
        (IXL( 0x5555555555555555), String( "5555555555555555")),
        (IXL(-0xaaaaaaaaaaaaaaaa), String("-aaaaaaaaaaaaaaaa")),
        (IXL( 0xaaaaaaaaaaaaaaaa), String( "aaaaaaaaaaaaaaaa")),
        
    ])) func roundtrippingRadix16(value: any BinaryInteger, description: String) throws {
        let coder = TextInt.hexadecimal
        for type in typesAsBinaryInteger {
            try  whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let expectation = T.exactly(value)
            try #require(coder.decode(description) == expectation)
            if  let expectation = expectation.optional() {
                try #require(coder.encode(expectation) == description)
            }
        }
    }
}
