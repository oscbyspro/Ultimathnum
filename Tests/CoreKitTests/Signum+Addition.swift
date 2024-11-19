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
// MARK: * Signum x Addition
//*============================================================================*

@Suite(.serialized) struct SignumTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Signum/addition: negated()",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Signum, Signum)>.infer([
        
        (Signum.negative, Signum.positive),
        (Signum.zero,     Signum.zero    ),
        (Signum.positive, Signum.negative),
        
    ])) func negation(instance: Signum, expectation: Signum) {
        #expect(reduce(instance, { -$0           }) == expectation)
        #expect(reduce(instance, {  $0.negate () }) == expectation)
        #expect(reduce(instance, {  $0.negated() }) == expectation)
    }
}
