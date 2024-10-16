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
import TestKit2

//*============================================================================*
// MARK: * Fallible x Sink
//*============================================================================*

@Suite("Fallible/sink") struct FallibleTestsOnSink {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/sink: into Bool",
        Tag.List.tags(.exhaustive),
        ParallelizationTrait.serialized,
        arguments: Fallible<Bit>.all
    )   func bool(instance: Fallible<Bit>) {
        
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
    
    @Test(
        "Fallible/sink: into Fallible<Void>",
        Tag.List.tags(.exhaustive),
        ParallelizationTrait.serialized,
        arguments: Fallible<Bit>.all
    )   func fallible(instance: Fallible<Bit>) {
        
        let values: (Bit, Bit)
        var errors: (Fallible<Void>, Fallible<Void>)
        
        errors.0 = Fallible()
        errors.1 = Fallible().veto()

        values.0 = instance.sink(&errors.0)
        values.1 = instance.sink(&errors.1)
        
        #expect(values.0 == instance.value)
        #expect(values.1 == instance.value)

        #expect(errors.0.error == instance.error)
        #expect(errors.1.error)
    }
}
