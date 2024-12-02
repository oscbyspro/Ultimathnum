//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fallible x Sink
//*============================================================================*

@Suite(.serialized) struct FallibleTestsOnSink {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/sink: into Bool",
        Tag.List.tags(.exhaustive),
        arguments: Fallible<Bit>.all
    )   func sink(instance: Fallible<Bit>) {
        
        let values: (Bit,  Bit )
        var errors: (Bool, Bool)
        
        errors.0 = false
        errors.1 = true
        
        values.0 = instance.sink(&errors.0)
        values.1 = instance.sink(&errors.1)
        
        #expect(values.0 == instance.value)
        #expect(values.1 == instance.value)
        
        #expect(errors.0 == instance.error)
        #expect(errors.1)
    }
}
