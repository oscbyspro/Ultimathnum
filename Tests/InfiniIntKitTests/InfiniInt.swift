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
// MARK: * Infini Int
//*============================================================================*

@Suite struct InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt: StaticBigInt vs String",
        arguments: Array<(StaticBigInt, String)>.infer([
            
        (StaticBigInt(   0), String(   "0")),
        (StaticBigInt(  00), String(  "00")),
        (StaticBigInt( 000), String( "000")),
        (StaticBigInt(0000), String("0000")),
            
        (StaticBigInt(-129), String("-129")),
        (StaticBigInt(-128), String("-128")),
        (StaticBigInt(-127), String("-127")),
        (StaticBigInt( 126), String( "126")),
        (StaticBigInt( 127), String( "127")),
        (StaticBigInt( 128), String( "128")),
        (StaticBigInt( 254), String( "254")),
        (StaticBigInt( 255), String( "255")),
        (StaticBigInt( 256), String( "256")),
                    
        (StaticBigInt(-32769), String("-32769")),
        (StaticBigInt(-32768), String("-32768")),
        (StaticBigInt(-32767), String("-32767")),
        (StaticBigInt( 32766), String( "32766")),
        (StaticBigInt( 32767), String( "32767")),
        (StaticBigInt( 32768), String( "32768")),
        (StaticBigInt( 65534), String( "65534")),
        (StaticBigInt( 65535), String( "65535")),
        (StaticBigInt( 65536), String( "65536")),
                    
        (StaticBigInt(-2147483649), String("-2147483649")),
        (StaticBigInt(-2147483648), String("-2147483648")),
        (StaticBigInt(-2147483647), String("-2147483647")),
        (StaticBigInt( 2147483646), String( "2147483646")),
        (StaticBigInt( 2147483647), String( "2147483647")),
        (StaticBigInt( 2147483648), String( "2147483648")),
        (StaticBigInt( 4294967294), String( "4294967294")),
        (StaticBigInt( 4294967295), String( "4294967295")),
        (StaticBigInt( 4294967296), String( "4294967296")),

        (StaticBigInt( -9223372036854775809), String( "-9223372036854775809")),
        (StaticBigInt( -9223372036854775808), String( "-9223372036854775808")),
        (StaticBigInt( -9223372036854775807), String( "-9223372036854775807")),
        (StaticBigInt(  9223372036854775806), String(  "9223372036854775806")),
        (StaticBigInt(  9223372036854775807), String(  "9223372036854775807")),
        (StaticBigInt(  9223372036854775808), String(  "9223372036854775808")),
        (StaticBigInt( 18446744073709551614), String( "18446744073709551614")),
        (StaticBigInt( 18446744073709551615), String( "18446744073709551615")),
        (StaticBigInt( 18446744073709551616), String( "18446744073709551616")),
        
        (StaticBigInt(-170141183460469231731687303715884105729), String("-170141183460469231731687303715884105729")),
        (StaticBigInt(-170141183460469231731687303715884105728), String("-170141183460469231731687303715884105728")),
        (StaticBigInt(-170141183460469231731687303715884105727), String("-170141183460469231731687303715884105727")),
        (StaticBigInt( 170141183460469231731687303715884105726), String( "170141183460469231731687303715884105726")),
        (StaticBigInt( 170141183460469231731687303715884105727), String( "170141183460469231731687303715884105727")),
        (StaticBigInt( 170141183460469231731687303715884105728), String( "170141183460469231731687303715884105728")),
        (StaticBigInt( 340282366920938463463374607431768211454), String( "340282366920938463463374607431768211454")),
        (StaticBigInt( 340282366920938463463374607431768211455), String( "340282366920938463463374607431768211455")),
        (StaticBigInt( 340282366920938463463374607431768211456), String( "340282366920938463463374607431768211456")),
        
        (StaticBigInt(                              1), String(                              "1")),
        (StaticBigInt(                             12), String(                             "12")),
        (StaticBigInt(                            123), String(                            "123")),
        (StaticBigInt(                           1234), String(                           "1234")),
        (StaticBigInt(                          12345), String(                          "12345")),
        (StaticBigInt(                         123456), String(                         "123456")),
        (StaticBigInt(                        1234567), String(                        "1234567")),
        (StaticBigInt(                       12345678), String(                       "12345678")),
        (StaticBigInt(                      123456789), String(                      "123456789")),
        (StaticBigInt(                     1234567890), String(                     "1234567890")),
        (StaticBigInt(                    12345678901), String(                    "12345678901")),
        (StaticBigInt(                   123456789012), String(                   "123456789012")),
        (StaticBigInt(                  1234567890123), String(                  "1234567890123")),
        (StaticBigInt(                 12345678901234), String(                 "12345678901234")),
        (StaticBigInt(                123456789012345), String(                "123456789012345")),
        (StaticBigInt(               1234567890123456), String(               "1234567890123456")),
        (StaticBigInt(              12345678901234567), String(              "12345678901234567")),
        (StaticBigInt(             123456789012345678), String(             "123456789012345678")),
        (StaticBigInt(            1234567890123456789), String(            "1234567890123456789")),
        (StaticBigInt(           12345678901234567890), String(           "12345678901234567890")),
        (StaticBigInt(          123456789012345678901), String(          "123456789012345678901")),
        (StaticBigInt(         1234567890123456789012), String(         "1234567890123456789012")),
        (StaticBigInt(        12345678901234567890123), String(        "12345678901234567890123")),
        (StaticBigInt(       123456789012345678901234), String(       "123456789012345678901234")),
        (StaticBigInt(      1234567890123456789012345), String(      "1234567890123456789012345")),
        (StaticBigInt(     12345678901234567890123456), String(     "12345678901234567890123456")),
        (StaticBigInt(    123456789012345678901234567), String(    "123456789012345678901234567")),
        (StaticBigInt(   1234567890123456789012345678), String(   "1234567890123456789012345678")),
        (StaticBigInt(  12345678901234567890123456789), String(  "12345678901234567890123456789")),
        (StaticBigInt( 123456789012345678901234567890), String( "123456789012345678901234567890")),
        
        (StaticBigInt(                             -1), String(                             "-1")),
        (StaticBigInt(                            -12), String(                            "-12")),
        (StaticBigInt(                           -123), String(                           "-123")),
        (StaticBigInt(                          -1234), String(                          "-1234")),
        (StaticBigInt(                         -12345), String(                         "-12345")),
        (StaticBigInt(                        -123456), String(                        "-123456")),
        (StaticBigInt(                       -1234567), String(                       "-1234567")),
        (StaticBigInt(                      -12345678), String(                      "-12345678")),
        (StaticBigInt(                     -123456789), String(                     "-123456789")),
        (StaticBigInt(                    -1234567890), String(                    "-1234567890")),
        (StaticBigInt(                   -12345678901), String(                   "-12345678901")),
        (StaticBigInt(                  -123456789012), String(                  "-123456789012")),
        (StaticBigInt(                 -1234567890123), String(                 "-1234567890123")),
        (StaticBigInt(                -12345678901234), String(                "-12345678901234")),
        (StaticBigInt(               -123456789012345), String(               "-123456789012345")),
        (StaticBigInt(              -1234567890123456), String(              "-1234567890123456")),
        (StaticBigInt(             -12345678901234567), String(             "-12345678901234567")),
        (StaticBigInt(            -123456789012345678), String(            "-123456789012345678")),
        (StaticBigInt(           -1234567890123456789), String(           "-1234567890123456789")),
        (StaticBigInt(          -12345678901234567890), String(          "-12345678901234567890")),
        (StaticBigInt(         -123456789012345678901), String(         "-123456789012345678901")),
        (StaticBigInt(        -1234567890123456789012), String(        "-1234567890123456789012")),
        (StaticBigInt(       -12345678901234567890123), String(       "-12345678901234567890123")),
        (StaticBigInt(      -123456789012345678901234), String(      "-123456789012345678901234")),
        (StaticBigInt(     -1234567890123456789012345), String(     "-1234567890123456789012345")),
        (StaticBigInt(    -12345678901234567890123456), String(    "-12345678901234567890123456")),
        (StaticBigInt(   -123456789012345678901234567), String(   "-123456789012345678901234567")),
        (StaticBigInt(  -1234567890123456789012345678), String(  "-1234567890123456789012345678")),
        (StaticBigInt( -12345678901234567890123456789), String( "-12345678901234567890123456789")),
        (StaticBigInt(-123456789012345678901234567890), String("-123456789012345678901234567890")),
        
    ])) func staticBigIntVersusString(literal: StaticBigInt, text: String) throws {
        
        try  whereIs(InfiniInt<I8>.self)
        try  whereIs(InfiniInt<IX>.self)
        try  whereIs(InfiniInt<U8>.self)
        try  whereIs(InfiniInt<UX>.self)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger, T.IntegerLiteralType == StaticBigInt {
            if  let expectation = T(text) {
                let result = T(integerLiteral: literal)
                #expect(result == expectation)
                
            }   else {
                #expect(!T.isSigned)
                #expect(literal.signum() == -1)
            }
        }
    }
}
