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
    
    @Test("Sign ← Bit", .serialized, arguments: [
        
        Some(Bit.zero, yields: Sign.plus ),
        Some(Bit.one,  yields: Sign.minus),
        
    ]) func initBit(_ argument: Some<Bit, Sign>) {
        #expect(Sign(     argument.input) == argument.output)
        #expect(Sign(raw: argument.input) == argument.output)
    }
    
    @Test("Sign → Bit", .serialized, arguments: [
        
        Some(Sign.plus,  yields: Bit.zero),
        Some(Sign.minus, yields: Bit.one ),
        
    ]) func makeBit(_ argument: Some<Sign, Bit>) {
        #expect(Bit(     argument.input) == argument.output)
        #expect(Bit(raw: argument.input) == argument.output)
    }
    
    @Test("Sign ← Bool", .serialized, arguments: [
        
        Some(false, yields: Sign.plus ),
        Some(true,  yields: Sign.minus),
        
    ]) func initBool(_ argument: Some<Bool, Sign>) {
        #expect(Sign(     argument.input) == argument.output)
        #expect(Sign(raw: argument.input) == argument.output)
    }
    
    @Test("Sign → Bool", .serialized, arguments: [
        
        Some(Sign.plus,  yields: false),
        Some(Sign.minus, yields: true ),
        
    ]) func makeBool(_ argument: Some<Sign, Bool>) {
        #expect(Bool(     argument.input) == argument.output)
        #expect(Bool(raw: argument.input) == argument.output)
    }
    
    @Test("Sign ← Stdlib", .serialized, arguments: [
        
        Some(FloatingPointSign.plus,  yields: Sign.plus ),
        Some(FloatingPointSign.minus, yields: Sign.minus),
        
    ]) func initStdlib(_ argument: Some<FloatingPointSign, Sign>) {
        #expect(Sign(     argument.input) == argument.output)
        #expect(Sign(raw: argument.input) == argument.output)
    }
    
    @Test("Sign → Stdlib", .serialized, arguments: [
        
        Some(Sign.plus,  yields: FloatingPointSign.plus ),
        Some(Sign.minus, yields: FloatingPointSign.minus),
        
    ]) func makeStdlib(_ argument: Some<Sign, FloatingPointSign>) {
        #expect(argument.input.stdlib()                == argument.output)
        #expect(FloatingPointSign(     argument.input) == argument.output)
        #expect(FloatingPointSign(raw: argument.input) == argument.output)
    }
}
