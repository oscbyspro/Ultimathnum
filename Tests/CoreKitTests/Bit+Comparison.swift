//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Bit x Comparison
//*============================================================================*

@Suite struct BitTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Bit/isZero", .serialized, arguments: [
        
        Some(Bit.zero, yields: true ),
        Some(Bit.one,  yields: false),
        
    ])  func isZero(_ argument: Some<Bit, Bool>) {
        #expect(argument.input.isZero == argument.output)
    }
    
    @Test("Bit/compared(to:)", .serialized, arguments: [
        
        Some(Bit.zero, Bit.zero, yields: Signum.zero),
        Some(Bit.zero, Bit.one,  yields: Signum.negative),
        Some(Bit.one,  Bit.zero, yields: Signum.positive),
        Some(Bit.one,  Bit.one,  yields: Signum.zero),
        
    ])  func compare(_ argument: Some<Bit, Bit, Signum>) {
        Ɣexpect(argument.0, equals: argument.1, is:    argument.output)
        #expect(argument.0.compared(to: argument.1) == argument.output)
    }
}
