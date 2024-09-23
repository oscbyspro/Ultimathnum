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
    
    @Test("Sign ← Bit", arguments: [
        
        Some(Bit.zero, yields: Sign.plus ),
        Some(Bit.one,  yields: Sign.minus),
        
    ]) func initBit(_ expectation: Some<Bit, Sign>) {
        #expect(Sign(     expectation.input) == expectation.output)
        #expect(Sign(raw: expectation.input) == expectation.output)
    }
    
    @Test("Sign → Bit", arguments: [
        
        Some(Sign.plus,  yields: Bit.zero),
        Some(Sign.minus, yields: Bit.one ),
        
    ]) func makeBit(_ expectation: Some<Sign, Bit>) {
        #expect(Bit(     expectation.input) == expectation.output)
        #expect(Bit(raw: expectation.input) == expectation.output)
    }
    
    @Test("Sign ← Bool", arguments: [
        
        Some(false, yields: Sign.plus ),
        Some(true,  yields: Sign.minus),
        
    ]) func initBool(_ expectation: Some<Bool, Sign>) {
        #expect(Sign(     expectation.input) == expectation.output)
        #expect(Sign(raw: expectation.input) == expectation.output)
    }
    
    @Test("Sign → Bool", arguments: [
        
        Some(Sign.plus,  yields: false),
        Some(Sign.minus, yields: true ),
        
    ]) func makeBool(_ expectation: Some<Sign, Bool>) {
        #expect(Bool(     expectation.input) == expectation.output)
        #expect(Bool(raw: expectation.input) == expectation.output)
    }
    
    @Test("Sign ← Stdlib", arguments: [
        
        Some(FloatingPointSign.plus,  yields: Sign.plus ),
        Some(FloatingPointSign.minus, yields: Sign.minus),
        
    ]) func initStdlib(_ expectation: Some<FloatingPointSign, Sign>) {
        #expect(Sign(     expectation.input) == expectation.output)
        #expect(Sign(raw: expectation.input) == expectation.output)
    }
    
    @Test("Sign → Stdlib", arguments: [
        
        Some(Sign.plus,  yields: FloatingPointSign.plus ),
        Some(Sign.minus, yields: FloatingPointSign.minus),
        
    ]) func makeStdlib(_ expectation: Some<Sign, FloatingPointSign>) {
        #expect(expectation.input.stdlib()                == expectation.output)
        #expect(FloatingPointSign(     expectation.input) == expectation.output)
        #expect(FloatingPointSign(raw: expectation.input) == expectation.output)
    }
}
