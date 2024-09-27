//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Sign
//*============================================================================*

@Suite struct SignTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Sign as Bit", .serialized, arguments: [
        
        (sign: Sign.plus,  bit: Bit.zero),
        (sign: Sign.minus, bit: Bit.one ),
        
    ])  func bit(_ argument: (sign: Sign, bit: Bit)) {
        #expect(Bit (     argument.sign) == argument.bit )
        #expect(Bit (raw: argument.sign) == argument.bit )
        #expect(Sign(     argument.bit ) == argument.sign)
        #expect(Sign(raw: argument.bit ) == argument.sign)
    }
    
    @Test("Sign as Bool", .serialized, arguments: [
        
        (sign: Sign.plus,  bool: false),
        (sign: Sign.minus, bool: true ),
        
    ])  func bool(_ argument: (sign: Sign, bool: Bool)) {
        #expect(Bool(     argument.sign) == argument.bool)
        #expect(Bool(raw: argument.sign) == argument.bool)
        #expect(Sign(     argument.bool) == argument.sign)
        #expect(Sign(raw: argument.bool) == argument.sign)
    }
    
    @Test("Sign as Stdlib", .serialized, arguments: [
        
        (sign: Sign.plus,  stdlib: FloatingPointSign.plus ),
        (sign: Sign.minus, stdlib: FloatingPointSign.minus),
        
    ])  func stdlib(_ argument: (sign: Sign, stdlib: FloatingPointSign)) {
        #expect(argument.sign.stdlib()                == argument.stdlib)
        #expect(FloatingPointSign(     argument.sign) == argument.stdlib)
        #expect(FloatingPointSign(raw: argument.sign) == argument.stdlib)
        #expect(Sign(     argument.stdlib) == argument.sign)
        #expect(Sign(raw: argument.stdlib) == argument.sign)
    }
}
