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
// MARK: * Bit
//*============================================================================*

@Suite struct BitTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Bit ← Bool", arguments: [
        
        Some(false, yields: Bit.zero),
        Some(true,  yields: Bit.one ),
        
    ])  func initBool(_ argument: Some<Bool, Bit>) {
        #expect(Bit(     argument.input) == argument.output)
        #expect(Bit(raw: argument.input) == argument.output)
    }
    
    @Test("Bit → Bool", arguments: [
        
        Some(Bit.zero, yields: false),
        Some(Bit.one,  yields: true ),
        
    ])  func makeBool(_ argument: Some<Bit, Bool>) {
        #expect(Bool(     argument.input) == argument.output)
        #expect(Bool(raw: argument.input) == argument.output)
    }
    
    @Test("Bit ← Sign", arguments: [
        
        Some(Sign.plus,  yields: Bit.zero),
        Some(Sign.minus, yields: Bit.one ),
        
    ])  func initSign(_ argument: Some<Sign, Bit>) {
        #expect(Bit(     argument.input) == argument.output)
        #expect(Bit(raw: argument.input) == argument.output)
    }
    
    @Test("Bit → Sign", arguments: [
        
        Some(Bit.zero, yields: Sign.plus ),
        Some(Bit.one,  yields: Sign.minus),
        
    ])  func makeSign(_ argument: Some<Bit, Sign>) {
        #expect(Sign(     argument.input) == argument.output)
        #expect(Sign(raw: argument.input) == argument.output)
    }
}
