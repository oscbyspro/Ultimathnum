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
        
    ]) func initBool(_ expectation: Some<Bool, Bit>) {
        #expect(Bit(     expectation.input) == expectation.output)
        #expect(Bit(raw: expectation.input) == expectation.output)
    }
    
    @Test("Bit → Bool", arguments: [
        
        Some(Bit.zero, yields: false),
        Some(Bit.one,  yields: true ),
        
    ]) func makeBool(_ expectation: Some<Bit, Bool>) {
        #expect(Bool(     expectation.input) == expectation.output)
        #expect(Bool(raw: expectation.input) == expectation.output)
    }
    
    @Test("Bit ← Sign", arguments: [
        
        Some(Sign.plus,  yields: Bit.zero),
        Some(Sign.minus, yields: Bit.one ),
        
    ]) func initSign(_ expectation: Some<Sign, Bit>) {
        #expect(Bit(     expectation.input) == expectation.output)
        #expect(Bit(raw: expectation.input) == expectation.output)
    }
    
    @Test("Bit → Sign", arguments: [
        
        Some(Bit.zero, yields: Sign.plus ),
        Some(Bit.one,  yields: Sign.minus),
        
    ]) func makeSign(_ expectation: Some<Bit, Sign>) {
        #expect(Sign(     expectation.input) == expectation.output)
        #expect(Sign(raw: expectation.input) == expectation.output)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Test
    //=------------------------------------------------------------------------=
    
    @Test("Bit/description", arguments: [
        
        Some(Bit.zero, yields: "0"),
        Some(Bit.one,  yields: "1"),
        
    ]) func description(_ expectation: Some<Bit, String>) {
        #expect(expectation.input.description == expectation.output)
        #expect(String(describing: expectation.input) == expectation.output)
    }
}
