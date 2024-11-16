//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import FibonacciKit
import TestKit

//*============================================================================*
// MARK: * Tupleacci x Text
//*============================================================================*

@Suite struct TupleacciTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Tupleacci/text: description",
        Tag.List.tags(.documentation, .unofficial),
        ParallelizationTrait.serialized,
        arguments: Array<(I8, I8, String)>([
        
        (I8(0), I8(0), "(0, 0)"),
        (I8(3), I8(5), "(3, 5)"),
        
    ])) func description(minor: I8, major: I8, expectation: String) {
        Ɣexpect(Tupleacci(minor: minor, major: major), description: expectation)
    }
}
