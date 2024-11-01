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
import TestKit2

//*============================================================================*
// MARK: * Utilities x Text
//*============================================================================*

@Suite struct UtilitiesTestsOnText {
    
    typealias I8L = InfiniInt<I8>
    typealias U8L = InfiniInt<I8>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Utilities/text: BinaryInteger/debug()")
    func debug() {
        #expect(I8 ( 2).debug() == "01000000")
        #expect(I8 ( 1).debug() == "10000000")
        #expect(I8 ( 0).debug() == "00000000")
        #expect(I8 (~0).debug() == "11111111")
        #expect(I8 (~1).debug() == "01111111")
        #expect(I8 (~2).debug() == "10111111")
        
        #expect(U8 ( 2).debug() == "01000000")
        #expect(U8 ( 1).debug() == "10000000")
        #expect(U8 ( 0).debug() == "00000000")
        #expect(U8 (~0).debug() == "11111111")
        #expect(U8 (~1).debug() == "01111111")
        #expect(U8 (~2).debug() == "10111111")
        
        #expect(I8L( 2).debug() == "01000000...0")
        #expect(I8L( 1).debug() == "10000000...0")
        #expect(I8L( 0).debug() ==         "...0")
        #expect(I8L(~0).debug() ==         "...1")
        #expect(I8L(~1).debug() == "01111111...1")
        #expect(I8L(~2).debug() == "10111111...1")
        
        #expect(U8L( 2).debug() == "01000000...0")
        #expect(U8L( 1).debug() == "10000000...0")
        #expect(U8L( 0).debug() ==         "...0")
        #expect(U8L(~0).debug() ==         "...1")
        #expect(U8L(~1).debug() == "01111111...1")
        #expect(U8L(~2).debug() == "10111111...1")
        
        #expect(I32( 0x55555555).debug() == "10101010101010101010101010101010")
        #expect(I32(~0x55555555).debug() == "01010101010101010101010101010101")
        
        #expect(U32( 0x55555555).debug() == "10101010101010101010101010101010")
        #expect(U32(~0x55555555).debug() == "01010101010101010101010101010101")
    }
    
    @Test("Utilities/text: Bit/ascii")
    func ascii() {
        #expect(Bit.zero.ascii == U8(UInt8(ascii: "0")))
        #expect(Bit.one .ascii == U8(UInt8(ascii: "1")))
    }
}
