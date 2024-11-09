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
// MARK: * Signum
//*============================================================================*

@Suite(.serialized) struct SignumTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Signum: from Bit",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Signum)>([
        
        (Bit.zero, Signum.zero    ),
        (Bit.one,  Signum.positive),
        
    ])) func bit(source: Bit, destination: Signum) {
        #expect(Signum(source) == destination)
    }
    
    @Test(
        "Signum: from Sign or Sign?",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Sign?, Signum)>([
        
        (Optional<Sign>(nil ), Signum.zero),
        (Optional(Sign.plus ), Signum.positive),
        (Optional(Sign.minus), Signum.negative),
        
    ])) func sign(source: Sign?, destination: Signum) {
        always: do {
            #expect(Signum(source) == destination)
        }
        
        if  let source = source {
            #expect(Signum(source) == destination)
        }
    }
}
