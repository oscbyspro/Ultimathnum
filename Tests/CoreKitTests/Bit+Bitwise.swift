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

    @Test("Bit.~(_:)", .serialized, arguments: [
        
        Some(Bit.zero, yields: Bit.one ),
        Some(Bit.one,  yields: Bit.zero),
        
    ])  func not(_ argument: Some<Bit, Bit>) {
        Ɣexpect(not: argument.input, is: argument.output)
    }
    
    @Test("Bit.&(_:_:)", .serialized, arguments: [
        
        Some(Bit.zero, Bit.zero, yields: Bit.zero),
        Some(Bit.zero, Bit.one,  yields: Bit.zero),
        Some(Bit.one,  Bit.zero, yields: Bit.zero),
        Some(Bit.one,  Bit.one,  yields: Bit.one ),
    
    ])  func and(_ argument: Some<Bit, Bit, Bit>) {
        Ɣexpect(argument.0, and: argument.1, is: argument.output)
    }
    
    @Test("Bit.|(_:_:)", .serialized, arguments: [
        
        Some(Bit.zero, Bit.zero, yields: Bit.zero),
        Some(Bit.zero, Bit.one,  yields: Bit.one ),
        Some(Bit.one,  Bit.zero, yields: Bit.one ),
        Some(Bit.one,  Bit.one,  yields: Bit.one ),
        
    ])  func or(_ argument: Some<Bit, Bit, Bit>) {
        Ɣexpect(argument.0,  or: argument.1, is: argument.output)
    }
    
    @Test("Bit.^(_:_:)", .serialized, arguments: [
        
        Some(Bit.zero, Bit.zero, yields: Bit.zero),
        Some(Bit.zero, Bit.one,  yields: Bit.one ),
        Some(Bit.one,  Bit.zero, yields: Bit.one ),
        Some(Bit.one,  Bit.one,  yields: Bit.zero),
        
    ])  func xor(_ argument: Some<Bit, Bit, Bit>) {
        Ɣexpect(argument.0, xor: argument.1, is: argument.output)
    }
}
