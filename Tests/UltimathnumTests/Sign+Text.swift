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
import TestKit2

//*============================================================================*
// MARK: * Sign x Text
//*============================================================================*

@Suite struct SignTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Sign.init(ascii:) - literal")
    func initIntegerLiteralAsASCII() {
        #expect(Sign(ascii: 42) == nil)
        #expect(Sign(ascii: 43) == Sign.plus)
        #expect(Sign(ascii: 44) == nil)
        #expect(Sign(ascii: 45) == Sign.minus)
        #expect(Sign(ascii: 46) == nil)
    }
    
    @Test("Sign.init(ascii:) - load each I8", arguments: binaryIntegers)
    func initBinaryIntegerAsASCII(_ type: any BinaryInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for x in I8.all {
                switch x {
                case 43: #expect(Sign(ascii: T(load: x)) == Sign.plus)
                case 45: #expect(Sign(ascii: T(load: x)) == Sign.minus)
                default: #expect(Sign(ascii: T(load: x)) == nil)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Sign/ascii", .serialized, arguments: [
        
        (sign: Sign.plus,  ascii: 43 as U8),
        (sign: Sign.minus, ascii: 45 as U8),
        
    ])  func ascii(sign: Sign, ascii: U8) {
        #expect(sign.ascii  == ascii)
        #expect(Sign(ascii: ascii) == sign)
    }
        
    @Test("Sign/description", .serialized, arguments: [
        
        (sign: Sign.plus,  description: "+"),
        (sign: Sign.minus, description: "-"),
        
    ])  func description(sign: Sign, description: String) {
        Ɣexpect(sign, description: description)
    }
}
