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
// MARK: * Signedness
//*============================================================================*

@Suite struct SignednessTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    @Test("Signedness.init(raw:)", arguments: [
        
        Some(Bit.zero, yields: Signedness.unsigned),
        Some(Bit.one,  yields: Signedness  .signed),
        
    ]) func initBit(_ expectation: Some<Bit, Signedness>) {
        #expect(Signedness(raw: expectation.input) == expectation.output)
    }
    
    @Test("Signedness.init(signed:)", arguments: [
      
        Some(false, yields: Signedness.unsigned),
        Some(true,  yields: Signedness  .signed),
        
    ]) func initSigned(_ expectation: Some<Bool, Signedness>) {
        #expect(Signedness(signed: expectation.input) == expectation.output)
    }
}
