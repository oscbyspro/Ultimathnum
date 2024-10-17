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

@Suite struct FallibleTestsOnSink {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/sink: from inout Bool as Bit",
        Tag.List.tags(.exhaustive),
        ParallelizationTrait.serialized,
        arguments: Bit.all
    )   func fromInoutBoolAsBit(value: Bit) {
        
        #expect(Fallible<Bit>.sink({    _ in     return value }).value == value)
        #expect(Fallible<Bit>.sink({    _ in     return value }).error == false)
        #expect(Fallible<Bit>.sink({ $0 = false; return value }).value == value)
        #expect(Fallible<Bit>.sink({ $0 = false; return value }).error == false)
        #expect(Fallible<Bit>.sink({ $0 = true;  return value }).value == value)
        #expect(Fallible<Bit>.sink({ $0 = true;  return value }).error)
    }
    
    @Test(
        "Fallible/sink: from inout Bool as Fallible<Bit>",
        Tag.List.tags(.exhaustive),
        ParallelizationTrait.serialized,
        arguments: Fallible<Bit>.all
    )   func fromInoutBoolAsFallibleBit(instance: Fallible<Bit>) {
                
        #expect(Fallible<Bit>.sink({    _ in     return instance }).value == instance.value)
        #expect(Fallible<Bit>.sink({    _ in     return instance }).error == instance.error)
        #expect(Fallible<Bit>.sink({ $0 = false; return instance }).value == instance.value)
        #expect(Fallible<Bit>.sink({ $0 = false; return instance }).error == instance.error)
        #expect(Fallible<Bit>.sink({ $0 = true;  return instance }).value == instance.value)
        #expect(Fallible<Bit>.sink({ $0 = true;  return instance }).error)
    }
    
    @Test(
        "Fallible/sink: into Bool",
        Tag.List.tags(.exhaustive),
        ParallelizationTrait.serialized,
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
