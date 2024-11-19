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
// MARK: * Indexacci x Text
//*============================================================================*

@Suite(.serialized) struct IndexacciTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Indexacci/text: description",
        Tag.List.tags(.documentation, .unofficial),
        arguments: Array<(I8, I8, I8, String)>.infer([
        
        (I8(0), I8(0), I8(0), "(0: 0, 0)"),
        (I8(3), I8(5), I8(4), "(4: 3, 5)"),
        
    ])) func description(minor: I8, major: I8, index: I8, expectation: String) {
        Ɣexpect(Indexacci(minor: minor, major: major, index: index), description: expectation)
    }
}
