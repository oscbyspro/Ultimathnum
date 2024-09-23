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
// MARK: * Bit x Bitwise
//*============================================================================*

@Suite struct BitTestsOnBitwise {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test("Bit.~(_:)", arguments: [
        
        Some(Bit.zero, yields: Bit.one ),
        Some(Bit.one,  yields: Bit.zero),
        
    ]) func not(_ expectation: Some<Bit, Bit>) {
        expect(not: expectation.input, is: expectation.output)
    }
    
    @Test("Bit.&(_:_:)", arguments: [
        
        Some((lhs: Bit.zero, rhs: Bit.zero), yields: Bit.zero),
        Some((lhs: Bit.zero, rhs: Bit.one ), yields: Bit.zero),
        Some((lhs: Bit.one,  rhs: Bit.zero), yields: Bit.zero),
        Some((lhs: Bit.one,  rhs: Bit.one ), yields: Bit.one ),
        
    ]) func and(_ expectation: Some<(lhs: Bit, rhs: Bit), Bit>) {
        expect(expectation.input.lhs, and: expectation.input.rhs, is: expectation.output)
    }
    
    @Test("Bit.|(_:_:)", arguments: [
        
        Some((lhs: Bit.zero, rhs: Bit.zero), yields: Bit.zero),
        Some((lhs: Bit.zero, rhs: Bit.one ), yields: Bit.one ),
        Some((lhs: Bit.one,  rhs: Bit.zero), yields: Bit.one ),
        Some((lhs: Bit.one,  rhs: Bit.one ), yields: Bit.one ),
        
    ]) func or(_ expectation: Some<(lhs: Bit, rhs: Bit), Bit>) {
        expect(expectation.input.lhs, or: expectation.input.rhs, is: expectation.output)
    }
    
    @Test("Bit.^(_:_:)", arguments: [
        
        Some((lhs: Bit.zero, rhs: Bit.zero), yields: Bit.zero),
        Some((lhs: Bit.zero, rhs: Bit.one ), yields: Bit.one ),
        Some((lhs: Bit.one,  rhs: Bit.zero), yields: Bit.one ),
        Some((lhs: Bit.one,  rhs: Bit.one ), yields: Bit.zero),
        
    ]) func xor(_ expectation: Some<(lhs: Bit, rhs: Bit), Bit>) {
        expect(expectation.input.lhs, xor: expectation.input.rhs, is: expectation.output)
    }
}
