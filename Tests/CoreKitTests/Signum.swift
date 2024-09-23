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
// MARK: * Signum
//*============================================================================*

@Suite struct SignumTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Signum ← Bit", arguments: [
        
        Some(Bit.zero, yields: Signum.zero    ),
        Some(Bit.one,  yields: Signum.positive),
        
    ]) func initBit(_ expectation: Some<Bit, Signum>) {
        #expect(Signum(expectation.input) == expectation.output)
    }
    
    
    @Test("Signum ← Sign or Sign?", arguments: [
        
        Some(Optional<Sign>(nil ), yields: Signum.zero),
        Some(Optional(Sign.plus ), yields: Signum.positive),
        Some(Optional(Sign.minus), yields: Signum.negative),
        
    ]) func initSignOrOptionalSign(_ expectation: Some<Sign?, Signum>) {
        #expect(Signum(expectation.input) == expectation.output)
        
        if  let sign = expectation.input {
            #expect(Signum(sign) == expectation.output)
        }
    }
}
