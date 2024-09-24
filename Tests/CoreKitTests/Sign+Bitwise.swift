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
// MARK: * Sign x Bitwise
//*============================================================================*

@Suite struct SignTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test("Sign.~(_:)", arguments: [
        
        Some(Sign.plus,  yields: Sign.minus),
        Some(Sign.minus, yields: Sign.plus ),
        
    ]) func not(_ argument: Some<Sign, Sign>) {
        Ɣexpect(not: argument.input, is: argument.output)
    }
    
    @Test("Sign.&(_:_:)", arguments: [
        
        Some(Sign.plus,  Sign.plus,  yields: Sign.plus ),
        Some(Sign.plus,  Sign.minus, yields: Sign.plus ),
        Some(Sign.minus, Sign.plus,  yields: Sign.plus ),
        Some(Sign.minus, Sign.minus, yields: Sign.minus),
        
    ]) func and(_ argument: Some<Sign, Sign, Sign>) {
        Ɣexpect(argument.0, and: argument.1, is: argument.output)
    }
    
    @Test("Sign.|(_:_:)", arguments: [
        
        Some(Sign.plus,  Sign.plus,  yields: Sign.plus ),
        Some(Sign.plus,  Sign.minus, yields: Sign.minus),
        Some(Sign.minus, Sign.plus,  yields: Sign.minus),
        Some(Sign.minus, Sign.minus, yields: Sign.minus),
        
    ]) func or(_ argument: Some<Sign, Sign, Sign>) {
        Ɣexpect(argument.0,  or: argument.1, is: argument.output)
    }
    
    @Test("Sign.^(_:_:)", arguments: [
        
        Some(Sign.plus,  Sign.plus,  yields: Sign.plus ),
        Some(Sign.plus,  Sign.minus, yields: Sign.minus),
        Some(Sign.minus, Sign.plus,  yields: Sign.minus),
        Some(Sign.minus, Sign.minus, yields: Sign.plus ),
        
    ]) func xor(_ argument: Some<Sign, Sign, Sign>) {
        Ɣexpect(argument.0, xor: argument.1, is: argument.output)
    }
}
