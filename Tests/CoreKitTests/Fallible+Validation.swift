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
// MARK: * Fallible x Validation
//*============================================================================*

@Suite struct FallibleTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Fallible/veto(_:)", .serialized, arguments:
            
        Fallible<Bit>.all
          
    )   func veto(_ argument: Fallible<Bit>) {
        let invalid = Fallible(argument.value, error: true)
        #expect(argument.veto(              )  ==  invalid)
        #expect(argument.veto(       false  )  == argument)
        #expect(argument.veto(       true   )  ==  invalid)
        #expect(argument.veto({ _ in false })  == argument)
        #expect(argument.veto({ _ in true  })  ==  invalid)
    }
    
    @Test("Fallible/optional(_:)", .serialized, arguments: [

        Some(Fallible(Bit.zero, error: false), yields: Optional(Bit.zero)),
        Some(Fallible(Bit.zero, error: true ), yields: Optional<Bit>(nil)),
        Some(Fallible(Bit.one,  error: false), yields: Optional(Bit.one )),
        Some(Fallible(Bit.one,  error: true ), yields: Optional<Bit>(nil)),
            
    ])  func optional(_ argument: Some<Fallible<Bit>, Bit?>) throws {
        #expect(argument.input.optional() == argument.output)
    }
    
    @Test("Fallible/prune(_:) and /result(_:)", .serialized, arguments: [

        Some(Fallible(Bit.zero, error: false), Bad.error, yields: Result<Bit, Bad>.success(Bit.zero )),
        Some(Fallible(Bit.zero, error: true ), Bad.error, yields: Result<Bit, Bad>.failure(Bad.error)),
        Some(Fallible(Bit.one,  error: false), Bad.error, yields: Result<Bit, Bad>.success(Bit.one  )),
        Some(Fallible(Bit.one,  error: true ), Bad.error, yields: Result<Bit, Bad>.failure(Bad.error)),
            
    ])  func result(_ argument: Some<Fallible<Bit>, Bad, Result<Bit, Bad>>) throws {
        Ɣexpect(try argument.0.prune (argument.1), is: argument.output)
        #expect(    argument.0.result(argument.1)  ==  argument.output)
    }
}
