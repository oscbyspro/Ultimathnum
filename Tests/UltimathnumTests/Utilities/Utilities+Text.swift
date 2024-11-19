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
import TestKit

//*============================================================================*
// MARK: * Utilities x Text
//*============================================================================*

@Suite(.serialized) struct UtilitiesTestsOnText {
    
    typealias I8L = InfiniInt<I8>
    typealias U8L = InfiniInt<I8>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Utilities/text: Bit/ascii",
        Tag.List.tags(.exhaustive),
        arguments: Array<(Bit, U8)>.infer([
            
        (Bit.zero, U8(UInt8(ascii: "0"))),
        (Bit.one,  U8(UInt8(ascii: "1"))),
            
    ])) func ascii(instance: Bit, expectation: U8) {
        #expect(instance.ascii == expectation)
    }
    
    @Test(
        "Utilities/text: BinaryInteger/bitstring()",
        Tag.List.tags(.generic),
        arguments: Array<(any BinaryInteger.Type, IXL, String)>.infer([
            
        (I8 .self, IXL( 2), String("01000000")),
        (I8 .self, IXL( 1), String("10000000")),
        (I8 .self, IXL( 0), String("00000000")),
        (I8 .self, IXL(~0), String("11111111")),
        (I8 .self, IXL(~1), String("01111111")),
        (I8 .self, IXL(~2), String("10111111")),
        
        (U8 .self, IXL( 2), String("01000000")),
        (U8 .self, IXL( 1), String("10000000")),
        (U8 .self, IXL( 0), String("00000000")),
        (U8 .self, IXL(~0), String("11111111")),
        (U8 .self, IXL(~1), String("01111111")),
        (U8 .self, IXL(~2), String("10111111")),
        
        (I8L.self, IXL( 2), String("01000000...0")),
        (I8L.self, IXL( 1), String("10000000...0")),
        (I8L.self, IXL( 0), String(        "...0")),
        (I8L.self, IXL(~0), String(        "...1")),
        (I8L.self, IXL(~1), String("01111111...1")),
        (I8L.self, IXL(~2), String("10111111...1")),
        
        (U8L.self, IXL( 2), String("01000000...0")),
        (U8L.self, IXL( 1), String("10000000...0")),
        (U8L.self, IXL( 0), String(        "...0")),
        (U8L.self, IXL(~0), String(        "...1")),
        (U8L.self, IXL(~1), String("01111111...1")),
        (U8L.self, IXL(~2), String("10111111...1")),
        
        (I32.self, IXL( 0x55555555), String("10101010101010101010101010101010")),
        (I32.self, IXL(~0x55555555), String("01010101010101010101010101010101")),
        
        (U32.self, IXL( 0x55555555), String("10101010101010101010101010101010")),
        (U32.self, IXL(~0x55555555), String("01010101010101010101010101010101")),
            
    ])) func bitstring(
        type: any BinaryInteger.Type, source: IXL, expectation: String
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(T(load: source).bitstring() == expectation)
        }
    }
}
