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
        
    ]) func not(_ expectation: Some<Sign, Sign>) {
        Ɣexpect(not: expectation.input, is: expectation.output)
    }
    
    @Test("Sign.&(_:_:)", arguments: [
        
        Some((lhs: Sign.plus,  rhs: Sign.plus ), yields: Sign.plus ),
        Some((lhs: Sign.plus,  rhs: Sign.minus), yields: Sign.plus ),
        Some((lhs: Sign.minus, rhs: Sign.plus ), yields: Sign.plus ),
        Some((lhs: Sign.minus, rhs: Sign.minus), yields: Sign.minus),
        
    ]) func and(_ expectation: Some<(lhs: Sign, rhs: Sign), Sign>) {
        Ɣexpect(expectation.input.lhs, and: expectation.input.rhs, is: expectation.output)
    }
    
    @Test("Sign.|(_:_:)", arguments: [
        
        Some((lhs: Sign.plus,  rhs: Sign.plus ), yields: Sign.plus ),
        Some((lhs: Sign.plus,  rhs: Sign.minus), yields: Sign.minus),
        Some((lhs: Sign.minus, rhs: Sign.plus ), yields: Sign.minus),
        Some((lhs: Sign.minus, rhs: Sign.minus), yields: Sign.minus),
        
    ]) func or(_ expectation: Some<(lhs: Sign, rhs: Sign), Sign>) {
        Ɣexpect(expectation.input.lhs, or: expectation.input.rhs, is: expectation.output)
    }
    
    @Test("Sign.^(_:_:)", arguments: [
        
        Some((lhs: Sign.plus,  rhs: Sign.plus ), yields: Sign.plus ),
        Some((lhs: Sign.plus,  rhs: Sign.minus), yields: Sign.minus),
        Some((lhs: Sign.minus, rhs: Sign.plus ), yields: Sign.minus),
        Some((lhs: Sign.minus, rhs: Sign.minus), yields: Sign.plus ),
        
    ]) func xor(_ expectation: Some<(lhs: Sign, rhs: Sign), Sign>) {
        Ɣexpect(expectation.input.lhs, xor: expectation.input.rhs, is: expectation.output)
    }
}
