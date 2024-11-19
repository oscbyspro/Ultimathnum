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
// MARK: * Fallible x Validation
//*============================================================================*

@Suite(.serialized) struct FallibleTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/validation: veto(_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Fallible<Bit>.all
    )   func veto(instance: Fallible<Bit>) {
        
        let invalid = Fallible(instance.value, error: true)
        #expect(instance.veto(              )  ==  invalid)
        #expect(instance.veto(       false  )  == instance)
        #expect(instance.veto(       true   )  ==  invalid)
        #expect(instance.veto({ _ in false })  == instance)
        #expect(instance.veto({ _ in true  })  ==  invalid)
    }
    
    @Test(
        "Fallible/validation: optional()",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Fallible<Bit>, Optional<Bit>)>.infer([

        (Fallible(Bit.zero, error: false), Optional(Bit.zero)),
        (Fallible(Bit.zero, error: true ), Optional<Bit>(nil)),
        (Fallible(Bit.one,  error: false), Optional(Bit.one )),
        (Fallible(Bit.one,  error: true ), Optional<Bit>(nil)),
            
    ])) func optional(instance: Fallible<Bit>, expectation: Optional<Bit>) {
        #expect(instance.optional() == expectation)
    }
    
    @Test(
        "Fallible/validation: prune(_:) and result(_:)",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Fallible<Bit>, Bad, Result<Bit, Bad>)>.infer([

        (Fallible(Bit.zero, error: false), Bad.error, Result<Bit, Bad>.success(Bit.zero )),
        (Fallible(Bit.zero, error: true ), Bad.error, Result<Bit, Bad>.failure(Bad.error)),
        (Fallible(Bit.one,  error: false), Bad.error, Result<Bit, Bad>.success(Bit.one  )),
        (Fallible(Bit.one,  error: true ), Bad.error, Result<Bit, Bad>.failure(Bad.error)),
            
    ])) func result(instance: Fallible<Bit>, argument: Bad, expectation: Result<Bit, Bad>) throws {
        #expect(instance.result(argument) == expectation)
        
        switch expectation {
        case let Result.success(x): #expect(try     x ==     instance.prune(argument) )
        case let Result.failure(x): #expect(throws: x ){ try instance.prune(argument) }
        }
    }
}
